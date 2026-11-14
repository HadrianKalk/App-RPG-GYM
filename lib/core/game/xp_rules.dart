/// Centraliza todas as constantes e taxas de balanceamento do motor do jogo.
///
/// Alterar valores aqui rebalanceia o ganho de XP e evolução de forma global.
abstract final class XpRules {
  // --- Esforço Base e Treinos ---
  /// 1 minuto de esforço focado = 1 XP base
  static const double xpPerFocusedMinute = 1.0;

  /// Cada série efetiva de musculação concluída vale 4 XP base
  static const double xpPerWorkoutSet = 4.0;

  /// Bônus épico ao quebrar um Recorde Pessoal (PR) de carga ou volume
  static const double bonusXpPerPersonalRecord = 25.0;

  // --- Multiplicadores de Intensidade (RPE / Esforço Percebido) ---
  static const double intensityLight = 0.75;
  static const double intensityModerate = 1.0;
  static const double intensityHard = 1.25;

  // --- Retornos Decrescentes Diários (por atributo) ---
  // Evita "grind" abusivo e valoriza consistência sobre excessos.
  static const double tier1MaxMinutes = 60.0;  // 0 - 60 min -> 100%
  static const double tier2MaxMinutes = 120.0; // 60 - 120 min -> 75%
  static const double tier3MaxMinutes = 180.0; // 120 - 180 min -> 50%
  // 180 min+ -> 25%

  static const double tier1Efficiency = 1.0;
  static const double tier2Efficiency = 0.75;
  static const double tier3Efficiency = 0.50;
  static const double tier4Efficiency = 0.25;

  // --- Missões Diárias ---
  /// Horas de sono que completam sozinhas a missão de Constituição.
  static const double questSleepHoursForCompletion = 8.0;

  /// Teto de minutos que um único treino pode creditar às missões
  /// (protege contra sessões esquecidas abertas por horas).
  static const double questMaxMinutesPerWorkout = 180.0;

  // --- Pontuação de Atributo e Níveis ---
  /// Todo atributo começa no valor padrão humano do D&D (10)
  static const int baseAttributeScore = 10;

  /// Nível inicial do personagem
  static const int baseCharacterLevel = 1;

  /// Nível máximo suportado na progressão
  static const int maxCharacterLevel = 20;

  /// XP necessário para avançar cada ponto de atributo:
  /// Custo para ir de S para S+1 = baseCost * ((S - 9) ^ exponent)
  static const double attributeCostBase = 300.0;
  static const double attributeCostExponent = 1.5;

  /// XP acumulado total necessário para cada nível de personagem (1 a 20)
  static int xpRequiredForLevel(int level) {
    if (level <= 1) return 0;
    if (level > maxCharacterLevel) level = maxCharacterLevel;
    // Curva progressiva cúbica suave estilo RPG clássico
    final l = level - 1;
    return (150 * (l * l * 1.2) + 200 * l).round();
  }
}
