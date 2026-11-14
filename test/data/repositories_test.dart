import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/core/game/quest_progress.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/activity_repository.dart';
import 'package:app/data/repositories/character_repository.dart';
import 'package:app/data/repositories/hero_repository.dart';
import 'package:app/data/repositories/quest_repository.dart';
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

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    charRepo = CharacterRepository(db);
    questRepo = QuestRepository(db, charRepo);
    workoutRepo = WorkoutRepository(db, charRepo, questRepo);
    activityRepo = ActivityRepository(db, charRepo, questRepo);
    heroRepo = HeroRepository(db);
    await workoutRepo.ensureSeeded();
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
      final session = await workoutRepo.startWorkoutSession();
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
}
