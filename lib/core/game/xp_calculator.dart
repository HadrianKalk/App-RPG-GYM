import 'dart:math' as math;
import 'xp_rules.dart';

abstract final class XpCalculator {
  /// Calcula o XP ganho aplicando a curva de **retornos decrescentes**
  /// com base nos minutos já acumulados hoje para o atributo.
  ///
  /// Faixas diárias:
  /// - 0 a 60 min: 100% de eficiência (1.0x)
  /// - 60 a 120 min: 75% de eficiência (0.75x)
  /// - 120 a 180 min: 50% de eficiência (0.50x)
  /// - 180+ min: 25% de eficiência (0.25x)
  static double calculateXpWithDiminishingReturns({
    required double minutesAlreadyLoggedToday,
    required double additionalMinutes,
    double intensityMultiplier = XpRules.intensityModerate,
    double flatBonusXp = 0.0,
  }) {
    if (additionalMinutes <= 0 && flatBonusXp <= 0) return 0.0;

    double remaining = additionalMinutes;
    double current = minutesAlreadyLoggedToday;
    double earnedXp = 0.0;

    // Fatia 1: 0 a 60 min (100%)
    if (current < XpRules.tier1MaxMinutes && remaining > 0) {
      final availableInTier = XpRules.tier1MaxMinutes - current;
      final minutesInTier = math.min(remaining, availableInTier);
      earnedXp += minutesInTier * XpRules.xpPerFocusedMinute * XpRules.tier1Efficiency * intensityMultiplier;
      remaining -= minutesInTier;
      current += minutesInTier;
    }

    // Fatia 2: 60 a 120 min (75%)
    if (current < XpRules.tier2MaxMinutes && remaining > 0) {
      final availableInTier = XpRules.tier2MaxMinutes - current;
      final minutesInTier = math.min(remaining, availableInTier);
      earnedXp += minutesInTier * XpRules.xpPerFocusedMinute * XpRules.tier2Efficiency * intensityMultiplier;
      remaining -= minutesInTier;
      current += minutesInTier;
    }

    // Fatia 3: 120 a 180 min (50%)
    if (current < XpRules.tier3MaxMinutes && remaining > 0) {
      final availableInTier = XpRules.tier3MaxMinutes - current;
      final minutesInTier = math.min(remaining, availableInTier);
      earnedXp += minutesInTier * XpRules.xpPerFocusedMinute * XpRules.tier3Efficiency * intensityMultiplier;
      remaining -= minutesInTier;
      current += minutesInTier;
    }

    // Fatia 4: 180+ min (25%)
    if (remaining > 0) {
      earnedXp += remaining * XpRules.xpPerFocusedMinute * XpRules.tier4Efficiency * intensityMultiplier;
    }

    return earnedXp + flatBonusXp;
  }

  /// Calcula o XP de uma série de musculação.
  /// Cada série vale [XpRules.xpPerWorkoutSet] * intensidade (RPE) + bônus de Recorde Pessoal se houver.
  static double calculateWorkoutSetXp({
    double intensity = XpRules.intensityModerate,
    bool isPersonalRecord = false,
  }) {
    final base = XpRules.xpPerWorkoutSet * intensity;
    return isPersonalRecord ? base + XpRules.bonusXpPerPersonalRecord : base;
  }
}
