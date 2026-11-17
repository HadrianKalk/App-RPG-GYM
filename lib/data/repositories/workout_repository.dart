import 'package:drift/drift.dart';

import '../../core/game/attributes.dart';
import '../../core/game/exercise_taxonomy.dart';
import '../../core/game/personal_record.dart';
import '../../core/game/progress_diff.dart';
import '../../core/game/quest_progress.dart';
import '../../core/game/routine.dart';
import '../../core/game/weekly_progress.dart';
import '../../core/game/xp_calculator.dart';
import '../../core/game/xp_event.dart';
import '../../core/game/xp_rules.dart';
import '../database.dart';
import '../seed/exercise_seed.dart';
import 'character_repository.dart';
import 'hero_repository.dart';
import 'history_repository.dart';
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
    this.weeklyBonuses = const [],
    this.completedQuests = const [],
    this.trainingDay = 0,
    this.weeklyGoal = 0,
    this.streakWeeks = 0,
    this.progress,
    this.repeatedDay = false,
    this.curveReduced = false,
  });

  final String sessionId;
  final Duration duration;
  final int completedSets;

  /// XP from the sets themselves (without PR bonuses).
  final double setXp;
  final Map<Attribute, double> xpByAttribute;
  final List<AchievedRecord> records;

  /// Weekly consistency bonuses earned (with their reason).
  final List<WeeklyBonus> weeklyBonuses;

  /// Daily quests completed by this workout.
  final List<DailyQuestsTableData> completedQuests;

  /// Distinct training days this week including today, and the goal.
  final int trainingDay;
  final int weeklyGoal;

  /// Consecutive weeks with the goal met (including this one if met).
  final int streakWeeks;

  /// Level / attribute increases caused by this workout (null if no sets).
  final ProgressDiff? progress;

  /// True when today was already a training day: weekly bonuses are only
  /// granted on the first workout of each day.
  final bool repeatedDay;

  /// True when any attribute's set XP was scaled down by the daily curve.
  final bool curveReduced;

  double get recordXp => records.fold(0.0, (sum, r) => sum + r.bonusXp);
  double get weeklyXp => weeklyBonuses.fold(0.0, (sum, b) => sum + b.xp);
  double get questXp => completedQuests.fold(0.0, (sum, q) => sum + q.bonusXp);
  double get totalXp => setXp + recordXp + weeklyXp + questXp;
}

/// Workouts: catalog sync, sessions, sets, records and XP on completion.
class WorkoutRepository {
  WorkoutRepository(this._db, this._characterRepo, this._questRepo, this._heroRepo, this._historyRepo);

  final AppDatabase _db;
  final CharacterRepository _characterRepo;
  final QuestRepository _questRepo;
  final HeroRepository _heroRepo;
  final HistoryRepository _historyRepo;

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

  /// Watches the most recent unfinished workout session (`completedAt == null`).
  Stream<WorkoutSession?> watchActiveWorkoutSession() {
    return (_db.select(_db.workoutSessions)
          ..where((t) => t.completedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Returns the most recent unfinished workout session, if any.
  Future<WorkoutSession?> getActiveWorkoutSession() {
    return (_db.select(_db.workoutSessions)
          ..where((t) => t.completedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Loads all saved sets (completed or draft) for [sessionId] in creation order.
  Future<List<WorkoutSet>> getSessionSets(String sessionId) {
    return (_db.select(_db.workoutSets)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.id),
            (t) => OrderingTerm.asc(t.setOrder),
          ]))
        .get();
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
  /// 4. on the FIRST workout of the day, grants weekly consistency bonuses;
  /// 5. credits today's quests;
  /// 6. reports level/attribute increases.
  Future<WorkoutSummary> completeWorkoutSession(String sessionId, {String? notes}) async {
    await _questRepo.ensureTodayQuests();
    final xpBefore = (await _characterRepo.watchCharacter().first).totalXpMap;
    final now = DateTime.now();
    final today = WeekCalendar.dayOf(now);
    // Was today already a training day before this workout?
    final alreadyTrainedToday = (await _historyRepo.trainingDays()).contains(today);
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
    final rawXpByAttribute = <Attribute, double>{};
    final xpByAttribute = <Attribute, double>{};
    final setsByAttribute = <Attribute, int>{};
    final runningMarks = <String, RecordMarks?>{};
    final records = <String, AchievedRecord>{};
    var setXp = 0.0;
    var curveReduced = false;

    for (final set in sets) {
      final exercise = exercises[set.exerciseId];
      if (exercise == null) continue;
      final attr = exercise.attribute;
      final intensity = set.rpe / 8.0;

      // Set XP depends on how the exercise is tracked.
      final xp = exercise.tracking == SetTracking.duration
          ? XpCalculator.calculateDurationSetXp(durationSeconds: set.durationSeconds, intensity: intensity)
          : XpCalculator.calculateWorkoutSetXp(intensity: intensity);
      rawXpByAttribute[attr] = (rawXpByAttribute[attr] ?? 0) + xp;
      setsByAttribute[attr] = (setsByAttribute[attr] ?? 0) + 1;

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

    // Apply the per-attribute daily diminishing-returns curve to set effort XP.
    for (final entry in rawXpByAttribute.entries) {
      final alreadyToday = await _characterRepo.getMinutesOrXpLoggedToday(entry.key);
      final curve = XpCalculator.applyDailyCurve(
        alreadyLoggedToday: alreadyToday,
        rawEffortXp: entry.value,
      );
      xpByAttribute[entry.key] = curve.earnedXp;
      setXp += curve.earnedXp;
      if (curve.wasReduced) curveReduced = true;
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
      if (entry.value <= 0) continue;
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

    // --- Weekly consistency -------------------------------------------------
    final goal = await _heroRepo.weeklyGoal();
    final byWeek = HistoryRepository.daysByWeek(await _historyRepo.trainingDays());
    final trainingDay = byWeek[WeekCalendar.weekStart(now)] ?? 0;
    final streak = WeeklyProgress.streakIncludingCurrent(trainingDaysByWeek: byWeek, now: now, goal: goal);
    final weekly = alreadyTrainedToday
        ? const <WeeklyBonus>[]
        : WeeklyProgress.bonusesFor(trainingDay: trainingDay, goal: goal, streakWeeks: streak);
    await _grantWeeklyBonuses(sessionId, now, weekly, rawXpByAttribute);

    final quests = await _questRepo.applyCredit(
      QuestProgress.fromWorkout(completedSetsByAttribute: setsByAttribute, sessionDuration: duration),
    );

    final xpAfter = (await _characterRepo.watchCharacter().first).totalXpMap;
    return WorkoutSummary(
      sessionId: sessionId,
      duration: duration,
      completedSets: sets.length,
      setXp: setXp,
      xpByAttribute: xpByAttribute,
      records: records.values.toList(),
      weeklyBonuses: weekly,
      completedQuests: quests,
      trainingDay: trainingDay,
      weeklyGoal: goal,
      streakWeeks: streak,
      progress: ProgressDiff.between(xpBefore, xpAfter),
      repeatedDay: alreadyTrainedToday,
      curveReduced: curveReduced,
    );
  }

  /// Writes weekly bonuses to the ledger, split across the attributes trained
  /// in this workout proportionally to their set XP.
  Future<void> _grantWeeklyBonuses(
    String sessionId,
    DateTime now,
    List<WeeklyBonus> bonuses,
    Map<Attribute, double> xpByAttribute,
  ) async {
    final total = xpByAttribute.values.fold(0.0, (a, b) => a + b);
    if (bonuses.isEmpty || total <= 0) return;
    for (final bonus in bonuses) {
      for (final entry in xpByAttribute.entries) {
        final share = bonus.xp * entry.value / total;
        if (share <= 0) continue;
        await _characterRepo.addXp(
          XpEvent(
            id: 'weekly_${sessionId}_${bonus.kind.name}_${entry.key.name}',
            attribute: entry.key,
            amount: share,
            source: XpSource.weeklyBonus,
            timestamp: now,
            description: 'weekly:${bonus.kind.name}:day${bonus.trainingDay}/${bonus.goal}',
          ),
        );
      }
    }
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
