import 'package:app/core/game/weekly_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeekCalendar', () {
    test('weeks start on Monday', () {
      expect(WeekCalendar.weekStart(DateTime(2026, 11, 15, 18)), DateTime(2026, 11, 9)); // Sunday
      expect(WeekCalendar.weekStart(DateTime(2026, 11, 9, 0, 5)), DateTime(2026, 11, 9)); // Monday
      expect(WeekCalendar.addWeeks(DateTime(2026, 11, 9), -1), DateTime(2026, 11, 2));
    });
  });

  group('WeeklyProgress.bonusesFor', () {
    test('no bonus before the goal', () {
      expect(WeeklyProgress.bonusesFor(trainingDay: 2, goal: 3, streakWeeks: 5), isEmpty);
    });

    test('goal met grants +50', () {
      final b = WeeklyProgress.bonusesFor(trainingDay: 3, goal: 3, streakWeeks: 1);
      expect(b.single.kind, WeeklyBonusKind.goalMet);
      expect(b.single.xp, 50);
    });

    test('beyond duty grows +15, +20, +25 and stops after day 7', () {
      double xpFor(int day) => WeeklyProgress.bonusesFor(trainingDay: day, goal: 3, streakWeeks: 1).single.xp;
      expect(xpFor(4), 15);
      expect(xpFor(5), 20);
      expect(xpFor(7), 30);
      expect(WeeklyProgress.bonusesFor(trainingDay: 8, goal: 3, streakWeeks: 1), isEmpty);
    });

    test('flame adds 10% per extra week (prototype: 4 weeks = +30%)', () {
      final b = WeeklyProgress.bonusesFor(trainingDay: 4, goal: 3, streakWeeks: 4);
      expect(b.map((e) => e.kind), [WeeklyBonusKind.beyondDuty, WeeklyBonusKind.flame]);
      expect(b.last.flamePercent, 30);
      expect(b.last.xp, 5); // 30% of 15 = 4.5 -> 5
      expect(WeeklyProgress.flamePercent(1), 0);
      expect(WeeklyProgress.flamePercent(20), 50);
    });
  });

  group('WeeklyProgress.streakIncludingCurrent', () {
    final now = DateTime(2026, 11, 12); // Thursday, week of Nov 9
    Map<DateTime, int> weeks(List<int> daysFromCurrentBack) => {
          for (var i = 0; i < daysFromCurrentBack.length; i++)
            WeekCalendar.addWeeks(DateTime(2026, 11, 9), -i): daysFromCurrentBack[i],
        };

    test('current week in progress does not break the streak', () {
      expect(WeeklyProgress.streakIncludingCurrent(trainingDaysByWeek: weeks([1, 3, 4, 3]), now: now, goal: 3), 3);
    });

    test('current week counts once its goal is met', () {
      expect(WeeklyProgress.streakIncludingCurrent(trainingDaysByWeek: weeks([3, 3, 3]), now: now, goal: 3), 3);
    });

    test('a missed week breaks the chain', () {
      expect(WeeklyProgress.streakIncludingCurrent(trainingDaysByWeek: weeks([3, 2, 5]), now: now, goal: 3), 1);
    });
  });
}
