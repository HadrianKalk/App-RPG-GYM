import 'dart:math' as math;
import 'attributes.dart';
import 'xp_rules.dart';

/// Informações calculadas de progressão para um atributo individual.
final class AttributeProgression {
  const AttributeProgression({
    required this.attribute,
    required this.score,
    required this.modifier,
    required this.currentXp,
    required this.xpForNextPoint,
    required this.progressPercent,
  });

  final Attribute attribute;
  final int score;
  final int modifier;
  final double currentXp;
  final double xpForNextPoint;
  final double progressPercent;
}

/// Informações calculadas de nível geral do personagem.
final class CharacterLevelProgression {
  const CharacterLevelProgression({
    required this.level,
    required this.totalXp,
    required this.currentLevelBaseXp,
    required this.nextLevelRequiredXp,
    required this.progressPercent,
  });

  final int level;
  final double totalXp;
  final int currentLevelBaseXp;
  final int nextLevelRequiredXp;
  final double progressPercent;
}

abstract final class Progression {
  /// Modificador de atributo D&D clássico: floor((Score - 10) / 2)
  /// Exemplo: 10 -> +0, 12 -> +1, 14 -> +2, 8 -> -1
  static int calculateModifier(int score) {
    return ((score - 10) / 2).floor();
  }

  /// Custo em XP para avançar do [currentScore] para o próximo ponto (currentScore + 1)
  static double xpCostForScore(int currentScore) {
    if (currentScore < XpRules.baseAttributeScore) return XpRules.attributeCostBase;
    final diff = (currentScore - 9).toDouble();
    return XpRules.attributeCostBase * math.pow(diff, XpRules.attributeCostExponent);
  }

  /// Calcula a pontuação e progresso de um atributo a partir do XP total acumulado nele.
  static AttributeProgression calculateAttribute(Attribute attr, double accumulatedXp) {
    int score = XpRules.baseAttributeScore;
    double remainingXp = math.max(0.0, accumulatedXp);

    while (true) {
      final cost = xpCostForScore(score);
      if (remainingXp >= cost) {
        remainingXp -= cost;
        score++;
      } else {
        final progress = cost > 0 ? (remainingXp / cost).clamp(0.0, 1.0) : 0.0;
        return AttributeProgression(
          attribute: attr,
          score: score,
          modifier: calculateModifier(score),
          currentXp: accumulatedXp,
          xpForNextPoint: cost,
          progressPercent: progress,
        );
      }
    }
  }

  /// Calcula o nível geral do personagem (1 a 20) a partir do XP acumulado total de todos os atributos.
  static CharacterLevelProgression calculateLevel(double totalXp) {
    int level = XpRules.baseCharacterLevel;

    for (int l = 1; l < XpRules.maxCharacterLevel; l++) {
      final nextReq = XpRules.xpRequiredForLevel(l + 1);
      if (totalXp >= nextReq) {
        level = l + 1;
      } else {
        break;
      }
    }

    final currentLevelBase = XpRules.xpRequiredForLevel(level);
    final nextLevelReq = level < XpRules.maxCharacterLevel
        ? XpRules.xpRequiredForLevel(level + 1)
        : currentLevelBase;

    final span = nextLevelReq - currentLevelBase;
    final progressInLevel = totalXp - currentLevelBase;
    final percent = span > 0 ? (progressInLevel / span).clamp(0.0, 1.0) : 1.0;

    return CharacterLevelProgression(
      level: level,
      totalXp: totalXp,
      currentLevelBaseXp: currentLevelBase,
      nextLevelRequiredXp: nextLevelReq,
      progressPercent: percent,
    );
  }
}
