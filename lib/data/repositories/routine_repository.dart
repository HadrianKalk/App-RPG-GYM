import 'package:drift/drift.dart';

import '../../core/game/routine.dart';
import '../database.dart';
import '../seed/routine_seed.dart';

/// Routines from both sources: built-in templates (code) and custom ones
/// (database). The UI only sees [Routine] and never cares where it came from.
class RoutineRepository {
  RoutineRepository(this._db);

  final AppDatabase _db;

  /// Built-in templates, in catalog order.
  List<Routine> get templates => RoutineSeed.templates;

  /// Watches the user's custom routines (most recently edited first).
  Stream<List<Routine>> watchCustomRoutines() {
    final query = _db.select(_db.routines)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    // Every save/delete touches `routines` (updatedAt/cascade), so watching
    // that table is enough to refresh the exercise lists too.
    return query.watch().asyncMap((_) => _loadCustom());
  }

  /// Finds a routine by id in templates or custom routines.
  Future<Routine?> getRoutine(String id) async {
    for (final t in templates) {
      if (t.id == id) return t;
    }
    final custom = await _loadCustom();
    for (final r in custom) {
      if (r.id == id) return r;
    }
    return null;
  }

  /// Creates or replaces a custom routine (name + ordered exercises).
  /// Returns the routine id.
  Future<String> saveCustomRoutine({
    String? id,
    required String name,
    required List<RoutineExercise> exercises,
  }) async {
    final routineId = id ?? 'rt_${DateTime.now().microsecondsSinceEpoch}';
    final now = DateTime.now();
    await _db.transaction(() async {
      final existing = await (_db.select(_db.routines)..where((t) => t.id.equals(routineId))).getSingleOrNull();
      await _db.into(_db.routines).insertOnConflictUpdate(
            RoutinesCompanion.insert(
              id: routineId,
              name: name.trim(),
              createdAt: existing?.createdAt ?? now,
              updatedAt: now,
            ),
          );
      // Replace the whole exercise list (simple and keeps order consistent).
      await (_db.delete(_db.routineExercises)..where((t) => t.routineId.equals(routineId))).go();
      for (var i = 0; i < exercises.length; i++) {
        final e = exercises[i];
        await _db.into(_db.routineExercises).insert(
              RoutineExercisesCompanion.insert(
                routineId: routineId,
                position: i,
                exerciseId: e.exerciseId,
                sets: e.sets,
                repsMin: Value(e.repsMin),
                repsMax: Value(e.repsMax),
                durationSeconds: Value(e.durationSeconds),
                toFailure: Value(e.toFailure),
                restSeconds: Value(e.restSeconds),
              ),
            );
      }
    });
    return routineId;
  }

  /// Deletes a custom routine (its exercises cascade).
  Future<void> deleteCustomRoutine(String id) =>
      (_db.delete(_db.routines)..where((t) => t.id.equals(id))).go();

  Future<List<Routine>> _loadCustom() async {
    final routines = await (_db.select(_db.routines)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();
    final rows = await (_db.select(_db.routineExercises)..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
    final byRoutine = <String, List<RoutineExercise>>{};
    for (final r in rows) {
      byRoutine.putIfAbsent(r.routineId, () => []).add(
            RoutineExercise(
              exerciseId: r.exerciseId,
              sets: r.sets,
              repsMin: r.repsMin,
              repsMax: r.repsMax,
              durationSeconds: r.durationSeconds,
              toFailure: r.toFailure,
              restSeconds: r.restSeconds,
            ),
          );
    }
    return [
      for (final r in routines)
        Routine(
          id: r.id,
          source: RoutineSource.custom,
          customName: r.name,
          exercises: byRoutine[r.id] ?? const [],
        ),
    ];
  }

}
