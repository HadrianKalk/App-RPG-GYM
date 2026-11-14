import 'package:drift/drift.dart';
import '../../core/game/attributes.dart';
import '../../core/game/quest_progress.dart';
import '../../core/game/xp_calculator.dart';
import '../../core/game/xp_event.dart';
import '../database.dart';
import '../seed/exercise_seed.dart';
import 'character_repository.dart';
import 'quest_repository.dart';

final class WorkoutSessionWithSets {
  const WorkoutSessionWithSets({
    required this.session,
    required this.sets,
    required this.exerciseMap,
  });

  final WorkoutSession session;
  final List<WorkoutSet> sets;
  final Map<String, Exercise> exerciseMap;
}

class WorkoutRepository {
  WorkoutRepository(this._db, this._characterRepo, this._questRepo);

  final AppDatabase _db;
  final CharacterRepository _characterRepo;
  final QuestRepository _questRepo;

  /// Garante que o catálogo de exercícios padrão em pt-BR seja inserido se a tabela estiver vazia.
  Future<void> ensureSeeded() async {
    final countExp = _db.exercises.id.count();
    final query = _db.selectOnly(_db.exercises)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();

    if (result == null || result == 0) {
      await _db.batch((batch) {
        batch.insertAll(
          _db.exercises,
          ExerciseSeed.defaultExercises.map(
            (item) => ExercisesCompanion.insert(
              id: item.id,
              name: item.name,
              muscleGroup: item.muscleGroup,
              equipment: item.equipment,
              attribute: item.attribute,
              isCustom: const Value(false),
            ),
          ),
        );
      });
    }
  }

  /// Observa a lista de exercícios com filtros opcionais de busca e grupo muscular.
  Stream<List<Exercise>> watchExercises({String? query, String? muscleGroup}) {
    final selectQuery = _db.select(_db.exercises);

    if (muscleGroup != null && muscleGroup.isNotEmpty && muscleGroup != 'Todos') {
      selectQuery.where((tbl) => tbl.muscleGroup.equals(muscleGroup));
    }

    if (query != null && query.trim().isNotEmpty) {
      final term = '%${query.trim()}%';
      selectQuery.where((tbl) => tbl.name.like(term));
    }

    selectQuery.orderBy([(t) => OrderingTerm.asc(t.name)]);
    return selectQuery.watch();
  }

  /// Inicia uma nova sessão de treino ativa.
  Future<WorkoutSession> startWorkoutSession({String title = 'Treino do Aço'}) async {
    final id = 'session_${DateTime.now().millisecondsSinceEpoch}';
    final companion = WorkoutSessionsCompanion.insert(
      id: id,
      title: title,
      startedAt: DateTime.now(),
    );
    await _db.into(_db.workoutSessions).insert(companion);
    return (_db.select(_db.workoutSessions)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  /// Adiciona ou atualiza uma série de exercício.
  Future<bool> saveWorkoutSet({
    required String id,
    required String sessionId,
    required String exerciseId,
    required int setOrder,
    required double weightKg,
    required int reps,
    required double rpe,
    required bool isCompleted,
  }) async {
    bool isPr = false;

    if (isCompleted && reps > 0 && weightKg > 0) {
      // Fórmula de Epley: 1RM = Carga * (1 + Reps / 30)
      final estimated1Rm = reps == 1 ? weightKg : weightKg * (1.0 + (reps / 30.0));
      final existingPr = await (_db.select(_db.personalRecords)
            ..where((tbl) => tbl.exerciseId.equals(exerciseId)))
          .getSingleOrNull();

      if (existingPr == null || weightKg > existingPr.maxWeightKg || estimated1Rm > existingPr.estimatedOneRepMax) {
        isPr = true;
        await _db.into(_db.personalRecords).insertOnConflictUpdate(
          PersonalRecordsCompanion.insert(
            exerciseId: exerciseId,
            maxWeightKg: existingPr != null && existingPr.maxWeightKg > weightKg ? existingPr.maxWeightKg : weightKg,
            estimatedOneRepMax: existingPr != null && existingPr.estimatedOneRepMax > estimated1Rm ? existingPr.estimatedOneRepMax : estimated1Rm,
            repsAtMaxWeight: reps,
            achievedAt: DateTime.now(),
          ),
        );

        // Bônus imediato de XP no Livro-Razão pelo Recorde Pessoal
        final exercise = await (_db.select(_db.exercises)..where((tbl) => tbl.id.equals(exerciseId))).getSingle();
        await _characterRepo.addXp(
          XpEvent(
            id: 'pr_${DateTime.now().millisecondsSinceEpoch}',
            attribute: exercise.attribute,
            amount: 25.0,
            source: XpSource.personalRecord,
            timestamp: DateTime.now(),
            description: 'Recorde Pessoal em ${exercise.name}: ${weightKg.toStringAsFixed(1)} kg ($reps reps)',
          ),
        );
      }
    }

    await _db.into(_db.workoutSets).insertOnConflictUpdate(
      WorkoutSetsCompanion.insert(
        id: id,
        sessionId: sessionId,
        exerciseId: exerciseId,
        setOrder: setOrder,
        weightKg: weightKg,
        reps: reps,
        rpe: Value(rpe),
        isCompleted: Value(isCompleted),
        isPersonalRecord: Value(isPr),
      ),
    );

    return isPr;
  }

  /// Finaliza o treino, computa o XP de todas as séries efetivas e salva no livro-razão.
  Future<double> completeWorkoutSession(String sessionId, {String? notes}) async {
    await _questRepo.ensureTodayQuests();
    final now = DateTime.now();
    final session = await (_db.select(_db.workoutSessions)..where((tbl) => tbl.id.equals(sessionId))).getSingle();
    await (_db.update(_db.workoutSessions)..where((tbl) => tbl.id.equals(sessionId))).write(
      WorkoutSessionsCompanion(
        completedAt: Value(now),
        notes: Value(notes),
      ),
    );

    final sets = await (_db.select(_db.workoutSets)..where((tbl) => tbl.sessionId.equals(sessionId))).get();
    final completedSets = sets.where((s) => s.isCompleted).toList();

    if (completedSets.isEmpty) return 0.0;

    // Agrupa séries por exercício e atributo
    double totalEarnedXp = 0.0;
    final Map<Attribute, double> attributeXpMap = {};
    final Map<Attribute, int> setsByAttribute = {};

    for (final set in completedSets) {
      final exercise = await (_db.select(_db.exercises)..where((tbl) => tbl.id.equals(set.exerciseId))).getSingle();
      final setXp = XpCalculator.calculateWorkoutSetXp(intensity: set.rpe / 8.0);
      attributeXpMap[exercise.attribute] = (attributeXpMap[exercise.attribute] ?? 0.0) + setXp;
      setsByAttribute[exercise.attribute] = (setsByAttribute[exercise.attribute] ?? 0) + 1;
      totalEarnedXp += setXp;
    }

    // Registra cada grupo no livro-razão de XP
    for (final entry in attributeXpMap.entries) {
      await _characterRepo.addXp(
        XpEvent(
          id: 'workout_${sessionId}_${entry.key.name}',
          attribute: entry.key,
          amount: entry.value,
          source: XpSource.workoutSet,
          timestamp: now,
          description: 'Treino finalizado: ${completedSets.length} séries efetivas',
        ),
      );
    }

    // Missões diárias avançam sozinhas com o treino.
    await _questRepo.applyCredit(
      QuestProgress.fromWorkout(
        completedSetsByAttribute: setsByAttribute,
        sessionDuration: now.difference(session.startedAt),
      ),
    );

    return totalEarnedXp;
  }

  /// Retorna as séries do último treino de um exercício para exibir como "Anterior".
  Future<List<WorkoutSet>> getPreviousSetsForExercise(String exerciseId) async {
    final query = _db.select(_db.workoutSets)
      ..where((tbl) => tbl.exerciseId.equals(exerciseId))
      ..where((tbl) => tbl.isCompleted.equals(true))
      ..orderBy([(t) => OrderingTerm.desc(t.id)])
      ..limit(10);
    return query.get();
  }
}
