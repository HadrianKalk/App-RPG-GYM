import 'exercise_taxonomy.dart';

/// Where a routine comes from.
enum RoutineSource {
  /// Built-in template shipped with the app (read-only, translated).
  template,

  /// Created by the user (editable, name typed by the user).
  custom,
}

/// Target for one exercise inside a routine.
///
/// Reps-based targets use [repsMin]/[repsMax] (equal values = fixed reps;
/// [toFailure] = "as many reps as possible"). Timed targets use
/// [durationSeconds].
final class RoutineExercise {
  const RoutineExercise({
    required this.exerciseId,
    required this.sets,
    this.repsMin,
    this.repsMax,
    this.durationSeconds,
    this.toFailure = false,
    this.restSeconds = 90,
  });

  final String exerciseId;
  final int sets;
  final int? repsMin;
  final int? repsMax;
  final int? durationSeconds;
  final bool toFailure;
  final int restSeconds;

  RoutineExercise copyWith({
    int? sets,
    int? Function()? repsMin,
    int? Function()? repsMax,
    int? Function()? durationSeconds,
    bool? toFailure,
    int? restSeconds,
  }) {
    return RoutineExercise(
      exerciseId: exerciseId,
      sets: sets ?? this.sets,
      repsMin: repsMin != null ? repsMin() : this.repsMin,
      repsMax: repsMax != null ? repsMax() : this.repsMax,
      durationSeconds: durationSeconds != null ? durationSeconds() : this.durationSeconds,
      toFailure: toFailure ?? this.toFailure,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }
}

/// A workout plan: ordered exercises with targets.
///
/// For templates the visible name/description come from the localized game
/// content (`routine.<id>.name` / `.description`); custom routines store the
/// name typed by the user in [customName].
final class Routine {
  const Routine({
    required this.id,
    required this.source,
    required this.exercises,
    this.customName,
  });

  final String id;
  final RoutineSource source;
  final List<RoutineExercise> exercises;
  final String? customName;

  bool get isTemplate => source == RoutineSource.template;
}

/// A set pre-filled when a workout starts from a routine.
final class PlannedSet {
  const PlannedSet({this.weightKg = 0, this.reps = 0, this.durationSeconds = 0});

  final double weightKg;
  final int reps;
  final int durationSeconds;
}

/// Values of a set done in a previous workout (used to pre-fill).
final class PreviousSet {
  const PreviousSet({required this.weightKg, required this.reps, this.durationSeconds});

  final double weightKg;
  final int reps;
  final int? durationSeconds;
}

abstract final class RoutinePlanner {
  /// Default reps when a routine gives no target.
  static const int defaultReps = 10;

  /// Default duration (seconds) for timed sets without a target.
  static const int defaultDurationSeconds = 60;

  /// Builds the initial sets of an exercise when a workout starts.
  ///
  /// Each set copies the matching set of the last workout ([previous], in
  /// set order) so the user starts from what they actually lifted; when
  /// there is no history it falls back to the routine target.
  static List<PlannedSet> planSets({
    required RoutineExercise target,
    required SetTracking tracking,
    required List<PreviousSet> previous,
  }) {
    final count = target.sets < 1 ? 1 : target.sets;
    return List.generate(count, (i) {
      final prev = i < previous.length ? previous[i] : (previous.isNotEmpty ? previous.last : null);
      switch (tracking) {
        case SetTracking.duration:
          return PlannedSet(
            durationSeconds: prev?.durationSeconds ?? target.durationSeconds ?? defaultDurationSeconds,
          );
        case SetTracking.reps:
          return PlannedSet(reps: prev?.reps ?? target.repsMax ?? target.repsMin ?? defaultReps);
        case SetTracking.weightReps:
          return PlannedSet(
            weightKg: prev?.weightKg ?? 0,
            reps: prev?.reps ?? target.repsMax ?? target.repsMin ?? defaultReps,
          );
      }
    });
  }
}
