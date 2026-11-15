import '../../../core/game/exercise_taxonomy.dart';
import '../../../core/game/routine.dart';
import '../../../l10n/l10n.dart';

/// Text helpers shared by the workout screens.
abstract final class WorkoutFormat {
  /// 75 -> "1:15", 600 -> "10:00", 3725 -> "1:02:05".
  static String duration(int totalSeconds) {
    final s = totalSeconds < 0 ? 0 : totalSeconds;
    final h = s ~/ 3600, m = (s % 3600) ~/ 60, sec = s % 60;
    final ss = sec.toString().padLeft(2, '0');
    return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$ss' : '$m:$ss';
  }

  /// Parses user input for a timed set: "1:30" -> 90 s; a plain number is
  /// read as minutes ("25" -> 1500 s, "0.5" -> 30 s). Returns null if invalid.
  static int? parseDuration(String raw) {
    final text = raw.trim().replaceAll(',', '.');
    if (text.isEmpty) return null;
    if (text.contains(':')) {
      final parts = text.split(':').map(int.tryParse).toList();
      if (parts.any((p) => p == null || p < 0)) return null;
      var total = 0;
      for (final p in parts) {
        total = total * 60 + p!;
      }
      return total;
    }
    final minutes = double.tryParse(text);
    return minutes == null || minutes < 0 ? null : (minutes * 60).round();
  }

  /// Formats a weight without useless decimals: 60.0 -> "60", 62.5 -> "62.5".
  static String weight(double kg) =>
      kg == kg.roundToDouble() ? kg.toStringAsFixed(0) : kg.toStringAsFixed(1);

  /// "4 × 6–8 reps", "2 × to failure", "3 × 0:45".
  static String target(AppLocalizations l10n, RoutineExercise t, SetTracking tracking) {
    if (tracking == SetTracking.duration && t.durationSeconds != null) {
      return l10n.targetDuration(t.sets, duration(t.durationSeconds!));
    }
    if (t.toFailure) return l10n.targetFailure(t.sets);
    final min = t.repsMin, max = t.repsMax;
    if (min != null && max != null && min != max) return l10n.targetReps(t.sets, min, max);
    final fixed = max ?? min;
    return fixed != null ? l10n.targetRepsFixed(t.sets, fixed) : l10n.targetSetsOnly(t.sets);
  }

  /// "Previous" cell: "60 × 8", "× 12" or "0:45"; "—" when none.
  static String previous(PreviousSet? p, SetTracking tracking) {
    if (p == null) return '—';
    return switch (tracking) {
      SetTracking.weightReps => '${weight(p.weightKg)} × ${p.reps}',
      SetTracking.reps => '× ${p.reps}',
      SetTracking.duration => duration(p.durationSeconds ?? 0),
    };
  }
}
