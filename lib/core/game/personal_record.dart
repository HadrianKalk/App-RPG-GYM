/// Personal Record (PR) rules, kept apart from persistence so they can be
/// tested and tuned in one place.
library;

/// Best marks stored for one exercise.
final class RecordMarks {
  const RecordMarks({required this.maxWeightKg, required this.estimatedOneRepMax});

  final double maxWeightKg;
  final double estimatedOneRepMax;
}

/// Outcome of evaluating a completed set against the stored marks.
final class RecordEvaluation {
  const RecordEvaluation({required this.isRecord, required this.grantsBonus, required this.updatedMarks});

  /// True when the set beats (or establishes) the stored marks.
  final bool isRecord;

  /// True only when an *existing* mark was beaten. The very first set of an
  /// exercise just sets the baseline: otherwise every new exercise would
  /// hand out a free PR bonus.
  final bool grantsBonus;

  /// Marks to persist (best of old and new for each metric).
  final RecordMarks updatedMarks;
}

abstract final class PersonalRecordRules {
  /// Epley estimate: 1RM = weight x (1 + reps / 30). One rep = the weight itself.
  static double estimateOneRepMax(double weightKg, int reps) =>
      reps <= 1 ? weightKg : weightKg * (1.0 + reps / 30.0);

  /// Evaluates a completed weighted set. Returns `null` when the set cannot
  /// produce a record (no load or no reps).
  static RecordEvaluation? evaluate({
    required RecordMarks? existing,
    required double weightKg,
    required int reps,
  }) {
    if (weightKg <= 0 || reps <= 0) return null;
    final e1rm = estimateOneRepMax(weightKg, reps);

    if (existing == null) {
      return RecordEvaluation(
        isRecord: true,
        grantsBonus: false,
        updatedMarks: RecordMarks(maxWeightKg: weightKg, estimatedOneRepMax: e1rm),
      );
    }

    final beatsWeight = weightKg > existing.maxWeightKg;
    final beats1rm = e1rm > existing.estimatedOneRepMax;
    if (!beatsWeight && !beats1rm) {
      return RecordEvaluation(isRecord: false, grantsBonus: false, updatedMarks: existing);
    }
    return RecordEvaluation(
      isRecord: true,
      grantsBonus: true,
      updatedMarks: RecordMarks(
        maxWeightKg: beatsWeight ? weightKg : existing.maxWeightKg,
        estimatedOneRepMax: beats1rm ? e1rm : existing.estimatedOneRepMax,
      ),
    );
  }
}
