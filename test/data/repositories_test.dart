import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/core/game/quest_progress.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/activity_repository.dart';
import 'package:app/data/repositories/character_repository.dart';
import 'package:app/data/repositories/hero_repository.dart';
import 'package:app/data/repositories/history_repository.dart';
import 'package:app/data/repositories/quest_repository.dart';
import 'package:app/data/repositories/routine_repository.dart';
import 'package:app/core/game/routine.dart';
import 'package:app/core/game/weekly_progress.dart';
import 'package:drift/drift.dart' as drift show Value;
import 'package:app/core/game/xp_event.dart';
import 'package:app/data/repositories/workout_repository.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CharacterRepository charRepo;
  late QuestRepository questRepo;
  late WorkoutRepository workoutRepo;
  late ActivityRepository activityRepo;
  late HeroRepository heroRepo;
  late RoutineRepository routineRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    charRepo = CharacterRepository(db);
    questRepo = QuestRepository(db, charRepo);
    workoutRepo = WorkoutRepository(db, charRepo, questRepo, HeroRepository(db), HistoryRepository(db));
    activityRepo = ActivityRepository(db, charRepo, questRepo);
    heroRepo = HeroRepository(db);
    routineRepo = RoutineRepository(db);
    await workoutRepo.syncCatalog();
  });

  tearDown(() => db.close());

  Future<List<DailyQuestsTableData>> todayQuests() =>
      questRepo.watchTodayQuests().first;

  Future<String> exerciseIdFor(Attribute attribute) async {
    final ex = await (db.select(db.exercises)
          ..where((t) => t.attribute.equalsValue(attribute))
          ..limit(1))
        .getSingle();
    return ex.id;
  }

  /// Insere uma missão fixa para hoje (impede o sorteio e torna o teste determinístico).
  Future<void> insertQuest(Attribute attribute, String unit, double target) async {
    final now = DateTime.now();
    await db.into(db.dailyQuestsTable).insert(
          DailyQuestsTableCompanion.insert(
            id: 'q_${attribute.name}',
            dateStr: '${now.year}-${now.month}-${now.day}',
            title: 'Teste',
            description: 'Teste',
            targetAttribute: attribute,
            targetValue: target,
            currentValue: 0,
            unit: unit,
            bonusXp: 10,
            grantsInspiration: const Value(true),
          ),
        );
  }

  group('Herói', () {
    test('começa sem herói e passa a existir após a criação', () async {
      expect(await heroRepo.watchHero().first, isNull);

      await heroRepo.createHero(
        name: '  Guts  ',
        form: HeroForm.masculine,
        origin: HeroOrigin.soldier,
        oath: '   ',
      );

      final hero = await heroRepo.watchHero().first;
      expect(hero, isNotNull);
      expect(hero!.name, 'Guts');
      expect(hero.origin, HeroOrigin.soldier);
      expect(hero.oath, isNull, reason: 'juramento vazio vira null');
    });

    test('recusa nome inválido', () async {
      expect(
        () => heroRepo.createHero(name: ' ', form: HeroForm.neutral, origin: HeroOrigin.wanderer),
        throwsArgumentError,
      );
    });
  });

  group('Treino', () {
    test('iniciar um segundo treino não quebra (regressão "Too many elements")', () async {
      final first = await workoutRepo.startWorkoutSession(title: 'A');
      await Future<void>.delayed(const Duration(milliseconds: 2));
      final second = await workoutRepo.startWorkoutSession(title: 'B');
      expect(first.id, isNot(second.id));
      expect(second.title, 'B');
    });

    test('finalizar treino de Força avança a missão de séries sozinho', () async {
      // Sem XP, Força está empatada como atributo mais fraco → missão "Superação".
      final session = await workoutRepo.startWorkoutSession(title: 'T');
      final benchId = await exerciseIdFor(Attribute.strength);
      for (var i = 0; i < 6; i++) {
        await workoutRepo.saveWorkoutSet(
          id: 'set_$i',
          sessionId: session.id,
          exerciseId: benchId,
          setOrder: i,
          weightKg: 0, // sem carga → não gera PR, isola o teste
          reps: 10,
          rpe: 8,
          isCompleted: true,
        );
      }
      await workoutRepo.completeWorkoutSession(session.id);

      final strengthQuests = (await todayQuests())
          .where((q) => q.targetAttribute == Attribute.strength && q.unit == QuestUnit.sets);
      expect(strengthQuests, isNotEmpty);
      for (final q in strengthQuests) {
        expect(q.currentValue, 6);
        expect(q.isCompleted, isTrue);
      }

      final hero = await charRepo.watchCharacter().first;
      expect(hero.inspirationCount, strengthQuests.length,
          reason: 'cada missão cumprida concede 1 Inspiração');
    });
  });

  group('Atividades', () {
    test('Pomodoro credita minutos na missão de INT, sem passar do alvo', () async {
      await insertQuest(Attribute.intelligence, QuestUnit.minutes, 50);

      await activityRepo.logPomodoroStudy(durationMinutes: 25);
      var q = (await todayQuests()).single;
      expect(q.currentValue, 25);
      expect(q.isCompleted, isFalse);

      await activityRepo.logPomodoroStudy(durationMinutes: 50);
      q = (await todayQuests()).single;
      expect(q.currentValue, 50, reason: 'nunca passa do alvo');
      expect(q.isCompleted, isTrue);
      expect((await charRepo.watchCharacter().first).inspirationCount, 1);
    });

    test('sono: menos de 8h não conclui a missão de CON; 8h conclui', () async {
      await insertQuest(Attribute.constitution, QuestUnit.minutes, 20);

      await activityRepo.logSleep(hoursSlept: 7);
      var q = (await todayQuests()).single;
      expect(q.isCompleted, isFalse);
      expect(q.currentValue, 0, reason: 'XP do sono não vira minutos de missão');

      await activityRepo.logSleep(hoursSlept: 8);
      q = (await todayQuests()).single;
      expect(q.isCompleted, isTrue);
    });

    test('diminishing returns apply within the same day (regression)', () async {
      // Bug: the "already logged today" query compared the attribute's
      // Portuguese label with the stored enum name, so it always returned 0
      // and diminishing returns never kicked in.
      final first = await activityRepo.logPomodoroStudy(durationMinutes: 60);
      final second = await activityRepo.logPomodoroStudy(durationMinutes: 60);
      expect(first, 60);
      expect(second, lessThan(first));
    });

    test('atividade de outro atributo não mexe na missão', () async {
      await insertQuest(Attribute.intelligence, QuestUnit.minutes, 50);
      await activityRepo.logMeditation(durationMinutes: 30);
      expect((await todayQuests()).single.currentValue, 0);
    });

    test('gerar missões duas vezes em paralelo é seguro', () async {
      final character = await charRepo.watchCharacter().first;
      await Future.wait([
        questRepo.ensureTodayQuestsGenerated(character),
        questRepo.ensureTodayQuestsGenerated(character),
      ]);
      expect(await todayQuests(), hasLength(3));
    });
  });

  /// Logs a finished workout with the given (weight, reps) sets of [exerciseId].
  Future<String> logWorkout(String exerciseId, List<(double, int)> sets) async {
    final session = await workoutRepo.startWorkoutSession(title: 'W');
    for (var i = 0; i < sets.length; i++) {
      await workoutRepo.saveWorkoutSet(
        id: '${session.id}_$i',
        sessionId: session.id,
        exerciseId: exerciseId,
        setOrder: i + 1,
        weightKg: sets[i].$1,
        reps: sets[i].$2,
        isCompleted: true,
      );
    }
    await workoutRepo.completeWorkoutSession(session.id);
    return session.id;
  }

  Future<List<XpLedgerData>> ledger(XpSource source) =>
      (db.select(db.xpLedger)..where((t) => t.source.equalsValue(source))).get();

  group('Personal records & workouts (step 2)', () {
    const bench = 'ex_supino_reto_barra';

    test('first ever set is a baseline: record saved, no bonus XP', () async {
      await logWorkout(bench, [(60, 8)]);
      expect(await ledger(XpSource.personalRecord), isEmpty);
      final pr = await (db.select(db.personalRecords)..where((t) => t.exerciseId.equals(bench))).getSingle();
      expect(pr.maxWeightKg, 60);
    });

    test('beating the mark later grants ONE bonus per exercise per workout', () async {
      await logWorkout(bench, [(60, 8)]);
      await Future<void>.delayed(const Duration(milliseconds: 2));
      await logWorkout(bench, [(62.5, 8), (65, 6)]); // two improving sets
      final bonuses = await ledger(XpSource.personalRecord);
      expect(bonuses, hasLength(1));
      expect(bonuses.single.amount, 25);
    });

    test('discarding a workout leaves no sets, session or XP', () async {
      final session = await workoutRepo.startWorkoutSession(title: 'D');
      await workoutRepo.saveWorkoutSet(
        id: 'd1', sessionId: session.id, exerciseId: bench, setOrder: 1, weightKg: 100, reps: 5, isCompleted: true,
      );
      await workoutRepo.discardWorkoutSession(session.id);
      expect(await db.select(db.workoutSets).get(), isEmpty);
      expect(await db.select(db.workoutSessions).get(), isEmpty);
      expect(await db.select(db.xpLedger).get(), isEmpty);
    });

    test('timed sets earn 1 XP per minute (min. one set)', () async {
      final session = await workoutRepo.startWorkoutSession(title: 'C');
      await workoutRepo.saveWorkoutSet(
        id: 'run', sessionId: session.id, exerciseId: 'ex_corrida_esteira_rua', setOrder: 1,
        weightKg: 0, reps: 0, durationSeconds: 25 * 60, isCompleted: true,
      );
      final summary = await workoutRepo.completeWorkoutSession(session.id);
      expect(summary.setXp, 25);
    });

    test('previous sets come from the last finished workout, in order', () async {
      await logWorkout(bench, [(50, 10), (55, 8)]);
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await logWorkout(bench, [(60, 8), (62.5, 6), (60, 7)]);
      final prev = await workoutRepo.getPreviousSets(bench);
      expect(prev.map((p) => p.weightKg), [60, 62.5, 60]);
      expect(prev.map((p) => p.reps), [8, 6, 7]);
    });
  });

  group('Routines', () {
    test('save, edit and delete a custom routine', () async {
      final id = await routineRepo.saveCustomRoutine(
        name: ' Upper A ',
        exercises: const [
          RoutineExercise(exerciseId: 'ex_supino_reto_barra', sets: 4, repsMin: 6, repsMax: 8),
          RoutineExercise(exerciseId: 'ex_prancha_isometrica', sets: 3, durationSeconds: 45),
        ],
      );
      var list = await routineRepo.watchCustomRoutines().first;
      expect(list.single.customName, 'Upper A');
      expect(list.single.exercises.map((e) => e.exerciseId), ['ex_supino_reto_barra', 'ex_prancha_isometrica']);
      expect(list.single.exercises.last.durationSeconds, 45);

      await routineRepo.saveCustomRoutine(
        id: id,
        name: 'Upper B',
        exercises: const [RoutineExercise(exerciseId: 'ex_prancha_isometrica', sets: 2, durationSeconds: 60)],
      );
      list = await routineRepo.watchCustomRoutines().first;
      expect(list.single.customName, 'Upper B');
      expect(list.single.exercises, hasLength(1));

      await routineRepo.deleteCustomRoutine(id);
      expect(await routineRepo.watchCustomRoutines().first, isEmpty);
      expect(await db.select(db.routineExercises).get(), isEmpty, reason: 'cascade delete');
    });

    test('every template exercise exists in the catalog', () async {
      final ids = routineRepo.templates.expand((r) => r.exercises.map((e) => e.exerciseId)).toSet().toList();
      final found = await workoutRepo.getExercises(ids);
      expect(found.map((e) => e.id).toSet(), ids.toSet());
    });
  });

  group('Custom hero origin', () {
    test('stores typed origin name and story', () async {
      await heroRepo.createHero(
        name: 'Guts',
        form: HeroForm.masculine,
        origin: HeroOrigin.custom,
        customOriginName: ' Mercenário Negro ',
        customOriginStory: 'Nasceu do cadáver de uma enforcada.',
      );
      final hero = await heroRepo.watchHero().first;
      expect(hero!.customOriginName, 'Mercenário Negro');
      expect(hero.customOriginStory, startsWith('Nasceu'));
    });

    test('custom origin without a name is rejected', () async {
      expect(
        () => heroRepo.createHero(name: 'Guts', form: HeroForm.masculine, origin: HeroOrigin.custom, customOriginName: ' '),
        throwsArgumentError,
      );
    });
  });

  group('Weekly consistency (step 3)', () {
    /// Inserts a finished past workout with one completed set on [day].
    Future<void> pastWorkout(DateTime day) async {
      final id = 'past_${day.millisecondsSinceEpoch}';
      await db.into(db.workoutSessions).insert(WorkoutSessionsCompanion.insert(
            id: id,
            title: 'past',
            startedAt: day.add(const Duration(hours: 10)),
            completedAt: drift.Value(day.add(const Duration(hours: 11))),
          ));
      await db.into(db.workoutSets).insert(WorkoutSetsCompanion.insert(
            id: '${id}_s',
            sessionId: id,
            exerciseId: 'ex_supino_reto_barra',
            setOrder: 1,
            weightKg: 40,
            reps: 10,
            isCompleted: const drift.Value(true),
          ));
    }

    setUp(() async {
      await heroRepo.createHero(name: 'Guts', form: HeroForm.masculine, origin: HeroOrigin.soldier);
      await heroRepo.setWeeklyGoal(1);
      // Two previous weeks with the goal (1 day) met -> streak 3 with today.
      final thisWeek = WeekCalendar.weekStart(DateTime.now());
      await pastWorkout(WeekCalendar.addWeeks(thisWeek, -1));
      await pastWorkout(WeekCalendar.addWeeks(thisWeek, -2));
    });

    test('first workout of the day grants goal + flame bonuses with reasons', () async {
      final session = await workoutRepo.startWorkoutSession(title: 'Today');
      await workoutRepo.saveWorkoutSet(
        id: 't1', sessionId: session.id, exerciseId: 'ex_agachamento_livre_barra', setOrder: 1,
        weightKg: 60, reps: 8, isCompleted: true,
      );
      final summary = await workoutRepo.completeWorkoutSession(session.id);

      expect(summary.trainingDay, 1);
      expect(summary.weeklyGoal, 1);
      expect(summary.streakWeeks, 3);
      expect(summary.weeklyBonuses.map((b) => b.kind), [WeeklyBonusKind.goalMet, WeeklyBonusKind.flame]);
      expect(summary.weeklyBonuses.last.flamePercent, 20);
      expect(summary.weeklyXp, 60); // 50 + 20% of 50
      expect(summary.repeatedDay, isFalse);

      final ledgerTotal = (await ledger(XpSource.weeklyBonus)).fold<double>(0, (a, e) => a + e.amount);
      expect(ledgerTotal, closeTo(60, 0.001));
      expect(summary.totalXp, summary.setXp + summary.recordXp + summary.weeklyXp + summary.questXp);
    });

    test('a second workout on the same day gets no weekly bonus', () async {
      for (final n in [1, 2]) {
        final session = await workoutRepo.startWorkoutSession(title: 'W$n');
        await workoutRepo.saveWorkoutSet(
          id: 'w$n', sessionId: session.id, exerciseId: 'ex_agachamento_livre_barra', setOrder: 1,
          weightKg: 60, reps: 8, isCompleted: true,
        );
        final summary = await workoutRepo.completeWorkoutSession(session.id);
        if (n == 2) {
          expect(summary.weeklyBonuses, isEmpty);
          expect(summary.repeatedDay, isTrue);
        }
        await Future<void>.delayed(const Duration(milliseconds: 2));
      }
    });

    test('summary reports level and attribute increases', () async {
      final session = await workoutRepo.startWorkoutSession(title: 'Big');
      // 80 sets x 4 XP = 320 XP of STR (+ weekly bonus): STR 10 -> 11 (300 XP)
      // and total XP above 380 -> level 2.
      for (var i = 0; i < 80; i++) {
        await workoutRepo.saveWorkoutSet(
          id: 'b$i', sessionId: session.id, exerciseId: 'ex_agachamento_livre_barra', setOrder: i + 1,
          weightKg: 0, reps: 10, isCompleted: true,
        );
      }
      final summary = await workoutRepo.completeWorkoutSession(session.id);
      expect(summary.progress!.attributes.any((a) => a.attribute == Attribute.strength && a.to > a.from), isTrue);
      expect(summary.progress!.leveledUp, isTrue);
    });
  });
}
