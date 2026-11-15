import 'package:material_ui/material_ui.dart';

import '../../../core/game/exercise_taxonomy.dart';
import '../../../core/game/routine.dart';
import '../../../data/database.dart';
import '../../../data/repositories/workout_repository.dart';

/// Editable set of the running workout.
class WorkoutSetDraft {
  WorkoutSetDraft({
    required this.id,
    this.weightKg = 0,
    this.reps = 0,
    this.durationSeconds = 0,
  });

  /// Stable id (also the database id), unaffected by reordering.
  final String id;
  double weightKg;
  int reps;
  int durationSeconds;
  bool completed = false;

  /// Shown as a trophy: this set would beat the stored record.
  bool previewRecord = false;
}

/// One exercise of the running workout with its sets.
class WorkoutExerciseDraft {
  WorkoutExerciseDraft({
    required this.exercise,
    required this.sets,
    this.target,
    this.previous = const [],
  });

  final Exercise exercise;

  /// Routine target (null when added freely).
  final RoutineExercise? target;

  /// Sets of the last finished workout with this exercise ("Previous").
  final List<PreviousSet> previous;
  final List<WorkoutSetDraft> sets;

  SetTracking get tracking => exercise.tracking;

  /// Rest after completing a set of this exercise.
  int get restSeconds => target?.restSeconds ?? ActiveWorkoutController.defaultRestSeconds;
}

/// State and actions of a workout in progress.
///
/// Persists sets as the user checks them, and delegates XP/records to
/// [WorkoutRepository.completeWorkoutSession] at the end.
class ActiveWorkoutController extends ChangeNotifier {
  ActiveWorkoutController({required WorkoutRepository repository, required this.session})
      : _repo = repository;

  static const int defaultRestSeconds = 90;

  final WorkoutRepository _repo;
  final WorkoutSession session;
  final List<WorkoutExerciseDraft> exercises = [];
  int _idCounter = 0;
  bool _busy = false;

  bool get isBusy => _busy;
  bool get hasCompletedSets => exercises.any((e) => e.sets.any((s) => s.completed));

  String _newSetId() => 'set_${session.id}_${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}';

  /// Pre-fills the workout with every exercise of [routine].
  Future<void> loadRoutine(Routine routine) async {
    final catalog = await _repo.getExercises(routine.exercises.map((e) => e.exerciseId).toList());
    final byId = {for (final e in catalog) e.id: e};
    for (final target in routine.exercises) {
      final exercise = byId[target.exerciseId];
      if (exercise == null) continue; // exercise removed from catalog
      await _append(exercise, target);
    }
    notifyListeners();
  }

  /// Adds a free exercise (one set, pre-filled from history).
  Future<void> addExercise(Exercise exercise) async {
    await _append(exercise, null);
    notifyListeners();
  }

  Future<void> _append(Exercise exercise, RoutineExercise? target) async {
    final previous = await _repo.getPreviousSets(exercise.id, excludeSessionId: session.id);
    final planned = RoutinePlanner.planSets(
      target: target ?? RoutineExercise(exerciseId: exercise.id, sets: 1),
      tracking: exercise.tracking,
      previous: previous,
    );
    exercises.add(
      WorkoutExerciseDraft(
        exercise: exercise,
        target: target,
        previous: previous,
        sets: [
          for (final p in planned)
            WorkoutSetDraft(id: _newSetId(), weightKg: p.weightKg, reps: p.reps, durationSeconds: p.durationSeconds),
        ],
      ),
    );
  }

  /// Removes an exercise and any of its saved sets.
  Future<void> removeExercise(WorkoutExerciseDraft group) async {
    exercises.remove(group);
    notifyListeners();
    await _repo.deleteExerciseSets(session.id, group.exercise.id);
  }

  /// Adds a set copying the last one of [group].
  void addSet(WorkoutExerciseDraft group) {
    final last = group.sets.isNotEmpty ? group.sets.last : null;
    group.sets.add(
      WorkoutSetDraft(
        id: _newSetId(),
        weightKg: last?.weightKg ?? 0,
        reps: last?.reps ?? RoutinePlanner.defaultReps,
        durationSeconds: last?.durationSeconds ?? RoutinePlanner.defaultDurationSeconds,
      ),
    );
    notifyListeners();
  }

  /// Removes one set and renumbers the remaining saved sets.
  Future<void> removeSet(WorkoutExerciseDraft group, WorkoutSetDraft set) async {
    group.sets.remove(set);
    notifyListeners();
    await _repo.deleteWorkoutSet(set.id);
    await _persistGroup(group, onlyCompleted: true);
  }

  /// Updates values of a set; re-saves it if it was already completed.
  Future<void> updateSet(
    WorkoutExerciseDraft group,
    WorkoutSetDraft set, {
    double? weightKg,
    int? reps,
    int? durationSeconds,
  }) async {
    if (weightKg != null) set.weightKg = weightKg;
    if (reps != null) set.reps = reps;
    if (durationSeconds != null) set.durationSeconds = durationSeconds;
    if (set.completed) {
      await _save(group, set);
      await _refreshPreview(group, set);
      notifyListeners();
    }
  }

  /// Checks/unchecks a set. Returns the rest to start (0 when unchecking).
  Future<int> toggleSet(WorkoutExerciseDraft group, WorkoutSetDraft set) async {
    set.completed = !set.completed;
    await _save(group, set);
    await _refreshPreview(group, set);
    notifyListeners();
    return set.completed ? group.restSeconds : 0;
  }

  Future<void> _refreshPreview(WorkoutExerciseDraft group, WorkoutSetDraft set) async {
    if (!set.completed || group.tracking != SetTracking.weightReps) {
      set.previewRecord = false;
      return;
    }
    final eval = await _repo.previewRecord(exerciseId: group.exercise.id, weightKg: set.weightKg, reps: set.reps);
    // Only show the trophy when an existing mark is beaten (not the baseline).
    set.previewRecord = eval?.grantsBonus ?? false;
  }

  Future<void> _persistGroup(WorkoutExerciseDraft group, {required bool onlyCompleted}) async {
    for (final s in group.sets) {
      if (!onlyCompleted || s.completed) await _save(group, s);
    }
  }

  Future<void> _save(WorkoutExerciseDraft group, WorkoutSetDraft set) {
    final order = group.sets.indexOf(set) + 1;
    return _repo.saveWorkoutSet(
      id: set.id,
      sessionId: session.id,
      exerciseId: group.exercise.id,
      setOrder: order < 1 ? 1 : order,
      weightKg: group.tracking == SetTracking.weightReps ? set.weightKg : 0,
      reps: group.tracking == SetTracking.duration ? 0 : set.reps,
      durationSeconds: group.tracking == SetTracking.duration ? set.durationSeconds : 0,
      isCompleted: set.completed,
    );
  }

  /// Completes the workout (XP, records, quests).
  Future<WorkoutSummary> finish() async {
    _busy = true;
    notifyListeners();
    try {
      return await _repo.completeWorkoutSession(session.id);
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  /// Throws the workout away (no XP is ever granted for it).
  Future<void> discard() => _repo.discardWorkoutSession(session.id);
}
