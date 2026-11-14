/// Normalized exercise taxonomy shared by the catalog, filters, routines
/// and (later) the per-muscle hero animations.
///
/// Identifiers only; texts live in the localized game content under
/// `muscle.<enumName>` and `equipment.<enumName>`.
library;

/// Primary muscle group trained by an exercise.
enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  forearms,
  traps,
  quads,
  hamstrings,
  glutes,
  calves,
  core,
  cardio,
  mobility,
  fullBody,
}

/// Main equipment used by an exercise.
enum Equipment { barbell, dumbbell, machine, cable, bodyweight, other }

/// How a set of this exercise is recorded.
enum SetTracking {
  /// Load (kg) x repetitions — classic lifting.
  weightReps,

  /// Repetitions only — bodyweight movements.
  reps,

  /// Duration only — planks, cardio, mobility flows.
  duration,
}
