import 'package:drift/drift.dart';

import '../../core/game/attributes.dart';
import '../../core/game/exercise_taxonomy.dart';
import '../../core/game/personal_record.dart';
import '../../core/game/quest_progress.dart';
import '../../core/game/routine.dart';
import '../../core/game/xp_calculator.dart';
import '../../core/game/xp_event.dart';
import '../../core/game/xp_rules.dart';
import '../database.dart';
import '../seed/exercise_seed.dart';
import 'character_repository.dart';
import 'quest_repository.dart';

/// A personal record achieved when a workout was completed.
final class AchievedRecord {
  const AchievedRecord({
    required this.exerciseId,
    required this.weightKg,
    required this.reps,
    required this.bonusXp,
  });

  final String exerciseId;
  final double weightKg;
  final int reps;

  /// 0 when the record only set the first baseline for the exercise.
  final double bonusXp;
}

/// Result of completing a workout (feeds the "Workout Complete" screen).
final class WorkoutSummary {
  const WorkoutSummary({
    required this.sessionId,
    required this.duration,
    required this.completedSets,
    required this.setXp,
    required this.xpByAttribute,
    required this.records,
  });

  final String sessionId;
  final Duration duration;
  final int completedSets;

  /// XP from the sets themselves (without PR bonuses).
  final double setXp;
  final Map<Attribute, double> xpByAttribute;
  final List<AchievedRecord> records;

  double get recordXp => records.fold(0.0, (sum, r) => sum + r.bonusXp);
  double get totalXp => setXp + recordXp;
}

/// Workouts: catalog sync, sessions, sets, records and XP on completion.
class WorkoutRepository {
  WorkoutRepository(this._db, this._characterRepo, this._questRepo);

  final AppDatabase _db;
  final CharacterRepository _characterRepo;
  final QuestRepository _questRepo;

  /// Upserts the built-in catalog into the database. Runs on every start so
  /// changes to `ExerciseSeed` (new exercises, re-classification) propagate
  /// to existing installs. Custom exercises are never touched.
  Future<void> syncCatalog() async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.exercises,
        ExerciseSeed.defaultExercises.map(
          (item) => ExercisesCompanion.insert(
            id: item.id,
            name: item.name,
            muscleGroup: item.muscle,
            equipment: item.equipment,
            attribute: item.attribute,
            tracking: Value(item.tracking),
            isCustom: const Value(false),
          ),
        ),
      );
    });
  }

  /// Watches every exercise in the catalog. Filtering by text/muscle happens
  /// in the UI so the search can match the *localized* names.
  Stream<List<Exercise>> watchAllExercises() => _db.select(_db.exercises).watch();

  /// Loads exercises by id, keeping the order of [ids] and skipping unknown ones.
  Future<List<Exercise>> getExercises(List<String> ids) async {
    if (ids.isEmpty) return [];
    final rows = await (_db.select(_db.exercises)..where((t) => t.id.isIn(ids))).get();
    final byId = {for (final r in rows) r.id: r};
    return [for (final id in ids) ?byId[id]];
  }

  /// Starts a new workout session, optionally linked to a routine.
  Future<WorkoutSession> startWorkoutSession({required String title, String? routineId}) async {
    final id = 'session_${DateTime.now().microsecondsSinceEpoch}';
    await _db.into(_db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            id: id,
            title: title,
            startedAt: DateTime.now(),
            routineId: Value(routineId),
          ),
        );
    return (_db.select(_db.workoutSessions)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  /// Inserts or updates one set of the running workout. No XP here: all XP
  /// (sets and records) is granted on [completeWorkoutSession], so editing,
  /// un-checking or discarding never leaves orphan ledger entries.
  Future<void> saveWorkoutSet({
    required String id,
    required String sessionId,
    required String exerciseId,
    required int setOrder,
    required double weightKg,
    required int reps,
    int durationSeconds = 0,
    double rpe = 8.0,
    required bool isCompleted,
  }) async {
    await _db.into(_db.workoutSets).insertOnConflictUpdate(
          WorkoutSetsCompanion.insert(
            id: id,
            sessionId: sessionId,
            exerciseId: exerciseId,
            setOrder: setOrder,
            weightKg: weightKg,
            reps: reps,
            durationSeconds: Value(durationSeconds),
            rpe: Value(rpe),
            isCompleted: Value(isCompleted),
          ),
        );
  }

  /// Removes one set (e.g. the user deleted a row).
  Future<void> deleteWorkoutSet(String id) =>
      (_db.delete(_db.workoutSets)..where((t) => t.id.equals(id))).go();

  /// Removes every set of [exerciseId] in [sessionId] (exercise removed).
  Future<void> deleteExerciseSets(String sessionId, String exerciseId) => (_db.delete(_db.workoutSets)
        ..where((t) => t.sessionId.equals(sessionId) & t.exerciseId.equals(exerciseId)))
      .go();

  /// Discards an unfinished workout entirely (sets + session).
  Future<void> discardWorkoutSession(String sessionId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.workoutSets)..where((t) => t.sessionId.equals(sessionId))).go();
      await (_db.delete(_db.workoutSessions)..where((t) => t.id.equals(sessionId))).go();
    });
  }

  /// Preview used during the workout to show a trophy on a set that would
  /// beat the stored marks. Nothing is persisted.
  Future<RecordEvaluation?> previewRecord({
    required String exerciseId,
    required double weightKg,
    required int reps,
  }) async {
    return PersonalRecordRules.evaluate(
      existing: await _marksFor(exerciseId),
      weightKg: weightKg,
      reps: reps,
    );
  }

  Future<RecordMarks?> _marksFor(String exerciseId) async {
    final row = await (_db.select(_db.personalRecords)..where((t) => t.exerciseId.equals(exerciseId)))
        .getSingleOrNull();
    return row == null
        ? null
        : RecordMarks(maxWeightKg: row.maxWeightKg, estimatedOneRepMax: row.estimatedOneRepMax);
  }

  /// Finishes the workout:
  /// 1. generates today's quests first (so this workout cannot change the draw);
  /// 2. evaluates personal records in set order (max one PR bonus per exercise);
  /// 3. writes set XP (per attribute) and PR bonuses to the ledger;
  /// 4. credits today's quests.
  Future<WorkoutSummary> completeWorkoutSession(String sessionId, {String? notes}) async {
    await _questRepo.ensureTodayQuests();
    final now = DateTime.now();
    final session = await (_db.select(_db.workoutSessions)..where((tbl) => tbl.id.equals(sessionId))).getSingle();

    await (_db.update(_db.workoutSessions)..where((tbl) => tbl.id.equals(sessionId))).write(
      WorkoutSessionsCompanion(completedAt: Value(now), notes: Value(notes)),
    );

    final sets = await (_db.select(_db.workoutSets)
          ..where((tbl) => tbl.sessionId.equals(sessionId) & tbl.isCompleted.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.setOrder)]))
        .get();
    final duration = now.difference(session.startedAt);
    if (sets.isEmpty) {
      return WorkoutSummary(
        sessionId: sessionId,
        duration: duration,
        completedSets: 0,
        setXp: 0,
        xpByAttribute: const {},
        records: const [],
      );
    }

    final exercises = {for (final e in await getExercises(sets.map((s) => s.exerciseId).toSet().toList())) e.id: e};
    final xpByAttribute = <Attribute, double>{};
    final setsByAttribute = <Attribute, int>{};
    final runningMarks = <String, RecordMarks?>{};
    final records = <String, AchievedRecord>{};
    var setXp = 0.0;

    for (final set in sets) {
      final exercise = exercises[set.exerciseId];
      if (exercise == null) continue;
      final attr = exercise.attribute;
      final intensity = set.rpe / 8.0;

      // Set XP depends on how the exercise is tracked.
      final xp = exercise.tracking == SetTracking.duration
          ? XpCalculator.calculateDurationSetXp(durationSeconds: set.durationSeconds, intensity: intensity)
          : XpCalculator.calculateWorkoutSetXp(intensity: intensity);
      xpByAttribute[attr] = (xpByAttribute[attr] ?? 0) + xp;
      setsByAttribute[attr] = (setsByAttribute[attr] ?? 0) + 1;
      setXp += xp;

      // Records only exist for loaded sets.
      if (exercise.tracking != SetTracking.weightReps) continue;
      if (!runningMarks.containsKey(exercise.id)) runningMarks[exercise.id] = await _marksFor(exercise.id);
      final eval = PersonalRecordRules.evaluate(
        existing: runningMarks[exercise.id],
        weightKg: set.weightKg,
        reps: set.reps,
      );
      if (eval == null || !eval.isRecord) continue;
      runningMarks[exercise.id] = eval.updatedMarks;
      await (_db.update(_db.workoutSets)..where((t) => t.id.equals(set.id)))
          .write(const WorkoutSetsCompanion(isPersonalRecord: Value(true)));
      final alreadyBonus = (records[exercise.id]?.bonusXp ?? 0) > 0;
      records[exercise.id] = AchievedRecord(
        exerciseId: exercise.id,
        weightKg: set.weightKg,
        reps: set.reps,
        bonusXp: alreadyBonus || eval.grantsBonus ? XpRules.bonusXpPerPersonalRecord : 0,
      );
    }

    // Persist the improved marks.
    for (final entry in runningMarks.entries) {
      final marks = entry.value;
      final achieved = records[entry.key];
      if (marks == null || achieved == null) continue;
      await _db.into(_db.personalRecords).insertOnConflictUpdate(
            PersonalRecordsCompanion.insert(
              exerciseId: entry.key,
              maxWeightKg: marks.maxWeightKg,
              estimatedOneRepMax: marks.estimatedOneRepMax,
              repsAtMaxWeight: achieved.reps,
              achievedAt: now,
            ),
          );
    }

    // Ledger: one entry per attribute for sets, one per PR bonus.
    for (final entry in xpByAttribute.entries) {
      await _characterRepo.addXp(
        XpEvent(
          id: 'workout_${sessionId}_${entry.key.name}',
          attribute: entry.key,
          amount: entry.value,
          source: XpSource.workoutSet,
          timestamp: now,
          description: 'workout:$sessionId',
        ),
      );
    }
    for (final record in records.values.where((r) => r.bonusXp > 0)) {
      await _characterRepo.addXp(
        XpEvent(
          id: 'pr_${sessionId}_${record.exerciseId}',
          attribute: exercises[record.exerciseId]!.attribute,
          amount: record.bonusXp,
          source: XpSource.personalRecord,
          timestamp: now,
          description: 'pr:${record.exerciseId}:${record.weightKg}x${record.reps}',
        ),
      );
    }

    await _questRepo.applyCredit(
      QuestProgress.fromWorkout(completedSetsByAttribute: setsByAttribute, sessionDuration: duration),
    );

    return WorkoutSummary(
      sessionId: sessionId,
      duration: duration,
      completedSets: sets.length,
      setXp: setXp,
      xpByAttribute: xpByAttribute,
      records: records.values.toList(),
    );
  }

  /// Completed sets of [exerciseId] from the most recent *finished* workout
  /// that included it, in set order ("Previous" column + pre-fill).
  Future<List<PreviousSet>> getPreviousSets(String exerciseId, {String? excludeSessionId}) async {
    final query = _db.select(_db.workoutSets).join([
      innerJoin(_db.workoutSessions, _db.workoutSessions.id.equalsExp(_db.workoutSets.sessionId)),
    ])
      ..where(_db.workoutSets.exerciseId.equals(exerciseId) &
          _db.workoutSets.isCompleted.equals(true) &
          _db.workoutSessions.completedAt.isNotNull())
      // Drift stores DateTime with second precision; the session id (made of
      // microseconds) breaks ties between workouts finished in the same second.
      ..orderBy([
        OrderingTerm.desc(_db.workoutSessions.completedAt),
        OrderingTerm.desc(_db.workoutSessions.id),
        OrderingTerm.asc(_db.workoutSets.setOrder),
      ]);
    if (excludeSessionId != null) {
      query.where(_db.workoutSessions.id.equals(excludeSessionId).not());
    }
    final rows = await query.get();
    if (rows.isEmpty) return const [];
    final lastSessionId = rows.first.readTable(_db.workoutSessions).id;
    return [
      for (final row in rows)
        if (row.readTable(_db.workoutSessions).id == lastSessionId)
          PreviousSet(
            weightKg: row.readTable(_db.workoutSets).weightKg,
            reps: row.readTable(_db.workoutSets).reps,
            durationSeconds: row.readTable(_db.workoutSets).durationSeconds,
          ),
    ];
  }
}
