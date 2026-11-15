import 'dart:math' as math;
import 'xp_rules.dart';

/// Result of passing raw effort XP through the per-attribute daily curve.
final class DailyCurveResult {
  const DailyCurveResult({
    required this.rawXp,
    required this.earnedXp,
  });

  /// Effort XP before the daily diminishing-returns curve.
  final double rawXp;

  /// Effort XP granted after applying the daily curve.
  final double earnedXp;

  /// True when the daily curve scaled down the gain.
  bool get wasReduced => earnedXp + 0.01 < rawXp;

  /// True when the attribute was already at the daily cap (0 XP granted).
  bool get reachedCap => rawXp > 0 && earnedXp <= 0;
}

abstract final class XpCalculator {
  /// Calculates the XP earned after applying the per-attribute **daily
  /// diminishing-returns curve** based on the effort XP already accumulated
  /// today for that attribute.
  ///
  /// Daily tiers (per attribute):
  /// - 0 to 60:   100% efficiency (1.0x)
  /// - 60 to 120:  75% efficiency (0.75x)
  /// - 120 to 180: 50% efficiency (0.50x)
  /// - 180 to 300: 25% efficiency (0.25x)
  /// - 300+:        0% efficiency (daily attribute cap reached)
  ///
  /// [flatBonusXp] (such as a milestone bonus) is never scaled down.
  static double calculateXpWithDiminishingReturns({
    required double minutesAlreadyLoggedToday,
    required double additionalMinutes,
    double intensityMultiplier = XpRules.intensityModerate,
    double flatBonusXp = 0.0,
  }) {
    if (additionalMinutes <= 0 && flatBonusXp <= 0) return 0.0;

    double remaining = additionalMinutes;
    double current = math.max(0.0, minutesAlreadyLoggedToday);
    double earnedXp = 0.0;

    // Tier 1: 0 to 60 (100%)
    if (current < XpRules.tier1MaxMinutes && remaining > 0) {
      final availableInTier = XpRules.tier1MaxMinutes - current;
      final minutesInTier = math.min(remaining, availableInTier);
      earnedXp += minutesInTier *
          XpRules.xpPerFocusedMinute *
          XpRules.tier1Efficiency *
          intensityMultiplier;
      remaining -= minutesInTier;
      current += minutesInTier;
    }

    // Tier 2: 60 to 120 (75%)
    if (current < XpRules.tier2MaxMinutes && remaining > 0) {
      final availableInTier = XpRules.tier2MaxMinutes - current;
      final minutesInTier = math.min(remaining, availableInTier);
      earnedXp += minutesInTier *
          XpRules.xpPerFocusedMinute *
          XpRules.tier2Efficiency *
          intensityMultiplier;
      remaining -= minutesInTier;
      current += minutesInTier;
    }

    // Tier 3: 120 to 180 (50%)
    if (current < XpRules.tier3MaxMinutes && remaining > 0) {
      final availableInTier = XpRules.tier3MaxMinutes - current;
      final minutesInTier = math.min(remaining, availableInTier);
      earnedXp += minutesInTier *
          XpRules.xpPerFocusedMinute *
          XpRules.tier3Efficiency *
          intensityMultiplier;
      remaining -= minutesInTier;
      current += minutesInTier;
    }

    // Tier 4: 180 to 300 (25%)
    if (current < XpRules.tier4MaxMinutes && remaining > 0) {
      final availableInTier = XpRules.tier4MaxMinutes - current;
      final minutesInTier = math.min(remaining, availableInTier);
      earnedXp += minutesInTier *
          XpRules.xpPerFocusedMinute *
          XpRules.tier4Efficiency *
          intensityMultiplier;
      remaining -= minutesInTier;
      current += minutesInTier;
    }

    // Tier 5: 300+ (0% — daily cap reached for this attribute).

    return earnedXp + flatBonusXp;
  }

  /// Applies the per-attribute daily curve to a raw effort XP amount
  /// (e.g. workout sets or health habits that already include intensity).
  static DailyCurveResult applyDailyCurve({
    required double alreadyLoggedToday,
    required double rawEffortXp,
  }) {
    if (rawEffortXp <= 0) {
      return const DailyCurveResult(rawXp: 0, earnedXp: 0);
    }
    final earned = calculateXpWithDiminishingReturns(
      minutesAlreadyLoggedToday: alreadyLoggedToday,
      additionalMinutes: rawEffortXp,
      intensityMultiplier: 1.0,
    );
    return DailyCurveResult(rawXp: rawEffortXp, earnedXp: earned);
  }

  /// XP of one strength set: [XpRules.xpPerWorkoutSet] x intensity (RPE),
  /// plus the Personal Record bonus when applicable.
  static double calculateWorkoutSetXp({
    double intensity = XpRules.intensityModerate,
    bool isPersonalRecord = false,
  }) {
    final base = XpRules.xpPerWorkoutSet * intensity;
    return isPersonalRecord ? base + XpRules.bonusXpPerPersonalRecord : base;
  }

  /// XP of one timed set (plank, run, mobility flow): 1 XP per minute
  /// ([XpRules.xpPerFocusedMinute]), never less than a regular set, times
  /// intensity. A 25-minute run is worth 25 XP; a 45 s plank is worth 4 XP.
  static double calculateDurationSetXp({
    required int durationSeconds,
    double intensity = XpRules.intensityModerate,
  }) {
    if (durationSeconds <= 0) return 0.0;
    final byMinutes = durationSeconds / 60.0 * XpRules.xpPerFocusedMinute;
    return math.max(XpRules.xpPerWorkoutSet, byMinutes) * intensity;
  }
}
