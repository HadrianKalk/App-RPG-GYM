import 'package:drift/drift.dart';

import '../../core/game/personal_record.dart';
import '../../core/game/weekly_progress.dart';
import '../database.dart';

/// One finished workout in the history list.
final class SessionOverview {
  const SessionOverview({
    required this.session,
    required this.completedSets,
    required this.volumeKg,
    required this.recordCount,
    required this.exerciseIds,
  });

  final WorkoutSession session;
  final int completedSets;

  /// Sum of weight x reps of completed sets.
  final double volumeKg;
  final int recordCount;

  /// Distinct exercises, in first-appearance order.
  final List<String> exerciseIds;

  Duration get duration => session.completedAt!.difference(session.startedAt);
}

/// Completed sets of one exercise inside a workout.
final class SessionExercise {
  const SessionExercise({required this.exercise, required this.sets});

  final Exercise exercise;
  final List<WorkoutSet> sets;
}

/// Best performance of an exercise in one workout (progress chart point).
final class ExercisePoint {
  const ExercisePoint({
    required this.date,
    required this.bestEstimatedOneRepMax,
    required this.bestWeightKg,
    required this.volumeKg,
    required this.bestDurationSeconds,
    required this.bestReps,
  });

  final DateTime date;
  final double bestEstimatedOneRepMax;
  final double bestWeightKg;
  final double volumeKg;
  final int bestDurationSeconds;
  final int bestReps;
}

/// Read-only queries over finished workouts.
class HistoryRepository {
  HistoryRepository(this._db);

  final AppDatabase _db;

  /// Finished workouts with at least one completed set, newest first.
  Stream<List<SessionOverview>> watchFinishedSessions() {
    final query = _db.select(_db.workoutSets).join([
      innerJoin(_db.workoutSessions, _db.workoutSessions.id.equalsExp(_db.workoutSets.sessionId)),
    ])
      ..where(_db.workoutSets.isCompleted.equals(true) & _db.workoutSessions.completedAt.isNotNull())
      ..orderBy([
        OrderingTerm.desc(_db.workoutSessions.completedAt),
        OrderingTerm.desc(_db.workoutSessions.id),
        OrderingTerm.asc(_db.workoutSets.setOrder),
      ]);

    return query.watch().map((rows) {
      final order = <String>[];
      final sessions = <String, WorkoutSession>{};
      final sets = <String, List<WorkoutSet>>{};
      for (final row in rows) {
        final session = row.readTable(_db.workoutSessions);
        if (!sessions.containsKey(session.id)) {
          order.add(session.id);
          sessions[session.id] = session;
        }
        sets.putIfAbsent(session.id, () => []).add(row.readTable(_db.workoutSets));
      }
      return [
        for (final id in order)
          SessionOverview(
            session: sessions[id]!,
            completedSets: sets[id]!.length,
            volumeKg: sets[id]!.fold(0.0, (v, s) => v + s.weightKg * s.reps),
            recordCount: sets[id]!.where((s) => s.isPersonalRecord).length,
            exerciseIds: sets[id]!.map((s) => s.exerciseId).toSet().toList(),
          ),
      ];
    });
  }

  /// Completed sets of a workout grouped by exercise (in workout order).
  Future<List<SessionExercise>> getSessionExercises(String sessionId) async {
    final sets = await (_db.select(_db.workoutSets)
          ..where((t) => t.sessionId.equals(sessionId) & t.isCompleted.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.setOrder)]))
        .get();
    final ids = <String>[];
    final byExercise = <String, List<WorkoutSet>>{};
    for (final s in sets) {
      if (!byExercise.containsKey(s.exerciseId)) ids.add(s.exerciseId);
      byExercise.putIfAbsent(s.exerciseId, () => []).add(s);
    }
    final exercises = await (_db.select(_db.exercises)..where((t) => t.id.isIn(ids))).get();
    final byId = {for (final e in exercises) e.id: e};
    return [
      for (final id in ids)
        if (byId[id] != null) SessionExercise(exercise: byId[id]!, sets: byExercise[id]!),
    ];
  }

  /// Distinct days with at least one finished workout (local midnight).
  Stream<Set<DateTime>> watchTrainingDays() {
    final query = _db.select(_db.workoutSessions).join([
      innerJoin(_db.workoutSets, _db.workoutSets.sessionId.equalsExp(_db.workoutSessions.id)),
    ])
      ..where(_db.workoutSets.isCompleted.equals(true) & _db.workoutSessions.completedAt.isNotNull());
    return query.watch().map((rows) => {
          for (final r in rows) WeekCalendar.dayOf(r.readTable(_db.workoutSessions).completedAt!),
        });
  }

  /// Same as [watchTrainingDays], once.
  Future<Set<DateTime>> trainingDays() => watchTrainingDays().first;

  /// Groups training days by week start (Monday) -> distinct days count.
  static Map<DateTime, int> daysByWeek(Set<DateTime> days) {
    final map = <DateTime, int>{};
    for (final d in days) {
      final w = WeekCalendar.weekStart(d);
      map[w] = (map[w] ?? 0) + 1;
    }
    return map;
  }

  /// Personal records joined with their exercise, best e1RM first.
  Stream<List<(PersonalRecord, Exercise)>> watchRecords() {
    final query = _db.select(_db.personalRecords).join([
      innerJoin(_db.exercises, _db.exercises.id.equalsExp(_db.personalRecords.exerciseId)),
    ])
      ..orderBy([OrderingTerm.desc(_db.personalRecords.achievedAt)]);
    return query.watch().map((rows) => [
          for (final r in rows) (r.readTable(_db.personalRecords), r.readTable(_db.exercises)),
        ]);
  }

  /// One point per finished workout containing [exerciseId], oldest first.
  Future<List<ExercisePoint>> exerciseProgress(String exerciseId) async {
    final query = _db.select(_db.workoutSets).join([
      innerJoin(_db.workoutSessions, _db.workoutSessions.id.equalsExp(_db.workoutSets.sessionId)),
    ])
      ..where(_db.workoutSets.exerciseId.equals(exerciseId) &
          _db.workoutSets.isCompleted.equals(true) &
          _db.workoutSessions.completedAt.isNotNull())
      ..orderBy([OrderingTerm.asc(_db.workoutSessions.completedAt), OrderingTerm.asc(_db.workoutSessions.id)]);
    final rows = await query.get();

    final order = <String>[];
    final dates = <String, DateTime>{};
    final sets = <String, List<WorkoutSet>>{};
    for (final r in rows) {
      final s = r.readTable(_db.workoutSessions);
      if (!dates.containsKey(s.id)) {
        order.add(s.id);
        dates[s.id] = s.completedAt!;
      }
      sets.putIfAbsent(s.id, () => []).add(r.readTable(_db.workoutSets));
    }
    return [
      for (final id in order)
        ExercisePoint(
          date: dates[id]!,
          bestEstimatedOneRepMax: sets[id]!.fold(0.0, (m, s) {
            final e = s.weightKg > 0 && s.reps > 0 ? PersonalRecordRules.estimateOneRepMax(s.weightKg, s.reps) : 0.0;
            return e > m ? e : m;
          }),
          bestWeightKg: sets[id]!.fold(0.0, (m, s) => s.weightKg > m ? s.weightKg : m),
          volumeKg: sets[id]!.fold(0.0, (v, s) => v + s.weightKg * s.reps),
          bestDurationSeconds: sets[id]!.fold(0, (m, s) => s.durationSeconds > m ? s.durationSeconds : m),
          bestReps: sets[id]!.fold(0, (m, s) => s.reps > m ? s.reps : m),
        ),
    ];
  }
}
