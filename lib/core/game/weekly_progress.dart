import 'dart:math' as math;

import 'xp_rules.dart';

/// Kinds of weekly consistency bonuses. Each one has a localized label and
/// reason in the UI (`bonus.<kind>`).
enum WeeklyBonusKind {
  /// The weekly goal was reached on this training day.
  goalMet,

  /// A training day above the weekly goal.
  beyondDuty,

  /// Extra percentage on the weekly bonuses for consecutive weeks.
  flame,
}

/// One bonus line, with what is needed to explain it to the player.
final class WeeklyBonus {
  const WeeklyBonus({
    required this.kind,
    required this.xp,
    required this.trainingDay,
    required this.goal,
    this.streakWeeks = 0,
    this.flamePercent = 0,
  });

  final WeeklyBonusKind kind;
  final double xp;

  /// Training day of the week that triggered it (1-based).
  final int trainingDay;
  final int goal;

  /// Only for [WeeklyBonusKind.flame].
  final int streakWeeks;
  final int flamePercent;
}

/// Calendar helpers. Weeks start on Monday (ISO 8601).
abstract final class WeekCalendar {
  /// Midnight of the given day.
  static DateTime dayOf(DateTime t) => DateTime(t.year, t.month, t.day);

  /// Monday 00:00 of the week containing [t]. Uses calendar arithmetic
  /// (not Durations) so daylight-saving changes never shift the day.
  static DateTime weekStart(DateTime t) =>
      DateTime(t.year, t.month, t.day - (t.weekday - DateTime.monday));

  /// Same weekday [weeks] weeks later (negative = earlier).
  static DateTime addWeeks(DateTime weekStart, int weeks) =>
      DateTime(weekStart.year, weekStart.month, weekStart.day + 7 * weeks);
}

abstract final class WeeklyProgress {
  /// Clamps a user-chosen goal to the allowed range.
  static int clampGoal(int goal) =>
      goal.clamp(XpRules.weeklyGoalMin, XpRules.weeklyGoalMax);

  /// Bonuses earned by a workout that makes [trainingDay] the N-th distinct
  /// training day of the current week.
  ///
  /// Call it only for the FIRST workout of a day (later workouts on the same
  /// day do not advance the week). [streakWeeks] is the number of
  /// consecutive weeks with the goal met, *including* the current week once
  /// its goal is reached (see [streakIncludingCurrent]).
  static List<WeeklyBonus> bonusesFor({
    required int trainingDay,
    required int goal,
    required int streakWeeks,
  }) {
    final g = clampGoal(goal);
    final base = <WeeklyBonus>[];

    if (trainingDay == g) {
      base.add(WeeklyBonus(kind: WeeklyBonusKind.goalMet, xp: XpRules.weeklyGoalMetXp, trainingDay: trainingDay, goal: g));
    } else if (trainingDay > g && trainingDay <= XpRules.weeklyGoalMax) {
      final extraIndex = trainingDay - g - 1; // 0 for the first day beyond
      base.add(WeeklyBonus(
        kind: WeeklyBonusKind.beyondDuty,
        xp: XpRules.beyondDutyBaseXp + XpRules.beyondDutyStepXp * extraIndex,
        trainingDay: trainingDay,
        goal: g,
      ));
    }
    if (base.isEmpty) return base;

    final percent = flamePercent(streakWeeks);
    if (percent > 0) {
      final sum = base.fold<double>(0, (s, b) => s + b.xp);
      base.add(WeeklyBonus(
        kind: WeeklyBonusKind.flame,
        xp: (sum * percent / 100).roundToDouble(),
        trainingDay: trainingDay,
        goal: g,
        streakWeeks: streakWeeks,
        flamePercent: percent,
      ));
    }
    return base;
  }

  /// Flame percentage for a streak: 0% in the first week, +10% per extra
  /// consecutive week, capped at 50%.
  static int flamePercent(int streakWeeks) {
    if (streakWeeks <= 1) return 0;
    final p = math.min((streakWeeks - 1) * XpRules.streakBonusPerWeek, XpRules.streakBonusMax);
    return (p * 100).round();
  }

  /// Consecutive weeks with the goal met, ending at the current week.
  ///
  /// [trainingDaysByWeek] maps each week start (Monday) to its number of
  /// distinct training days. The current week only *adds* to the streak once
  /// its goal is met; while still in progress it never breaks the streak.
  static int streakIncludingCurrent({
    required Map<DateTime, int> trainingDaysByWeek,
    required DateTime now,
    required int goal,
  }) {
    final g = clampGoal(goal);
    final current = WeekCalendar.weekStart(now);
    var streak = (trainingDaysByWeek[current] ?? 0) >= g ? 1 : 0;
    var week = WeekCalendar.addWeeks(current, -1);
    while ((trainingDaysByWeek[week] ?? 0) >= g) {
      streak++;
      week = WeekCalendar.addWeeks(week, -1);
    }
    return streak;
  }
}
