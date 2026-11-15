import 'package:app/core/game/exercise_taxonomy.dart';
import 'package:app/core/game/personal_record.dart';
import 'package:app/core/game/routine.dart';
import 'package:app/core/game/xp_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PersonalRecordRules', () {
    test('first set establishes the baseline without bonus', () {
      final e = PersonalRecordRules.evaluate(existing: null, weightKg: 60, reps: 8)!;
      expect(e.isRecord, isTrue);
      expect(e.grantsBonus, isFalse);
    });

    test('beating weight or estimated 1RM is a record with bonus', () {
      const marks = RecordMarks(maxWeightKg: 60, estimatedOneRepMax: 76);
      expect(PersonalRecordRules.evaluate(existing: marks, weightKg: 62.5, reps: 3)!.grantsBonus, isTrue);
      // Same weight, more reps -> higher e1RM.
      expect(PersonalRecordRules.evaluate(existing: marks, weightKg: 60, reps: 10)!.grantsBonus, isTrue);
      expect(PersonalRecordRules.evaluate(existing: marks, weightKg: 55, reps: 8)!.isRecord, isFalse);
    });

    test('no load or no reps cannot be a record', () {
      expect(PersonalRecordRules.evaluate(existing: null, weightKg: 0, reps: 10), isNull);
      expect(PersonalRecordRules.evaluate(existing: null, weightKg: 50, reps: 0), isNull);
    });
  });

  group('RoutinePlanner.planSets', () {
    const target = RoutineExercise(exerciseId: 'x', sets: 3, repsMin: 6, repsMax: 8);

    test('without history uses the routine target', () {
      final sets = RoutinePlanner.planSets(target: target, tracking: SetTracking.weightReps, previous: const []);
      expect(sets, hasLength(3));
      expect(sets.every((s) => s.reps == 8 && s.weightKg == 0), isTrue);
    });

    test('with history copies last workout set by set (last one repeats)', () {
      final sets = RoutinePlanner.planSets(
        target: target,
        tracking: SetTracking.weightReps,
        previous: const [PreviousSet(weightKg: 60, reps: 8), PreviousSet(weightKg: 62.5, reps: 6)],
      );
      expect(sets.map((s) => s.weightKg), [60, 62.5, 62.5]);
      expect(sets.map((s) => s.reps), [8, 6, 6]);
    });

    test('timed exercise uses durations', () {
      final sets = RoutinePlanner.planSets(
        target: const RoutineExercise(exerciseId: 'p', sets: 2, durationSeconds: 45),
        tracking: SetTracking.duration,
        previous: const [],
      );
      expect(sets.map((s) => s.durationSeconds), [45, 45]);
    });
  });

  group('XpCalculator.calculateDurationSetXp', () {
    test('1 XP per minute, never less than a regular set', () {
      expect(XpCalculator.calculateDurationSetXp(durationSeconds: 25 * 60), 25);
      expect(XpCalculator.calculateDurationSetXp(durationSeconds: 45), 4);
      expect(XpCalculator.calculateDurationSetXp(durationSeconds: 0), 0);
    });
  });
}
