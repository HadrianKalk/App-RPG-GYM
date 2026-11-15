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
  static const double tier1MaxMinutes = 60.0;  // 0 - 60 -> 100%
  static const double tier2MaxMinutes = 120.0; // 60 - 120 -> 75%
  static const double tier3MaxMinutes = 180.0; // 120 - 180 -> 50%
  static const double tier4MaxMinutes = 300.0; // 180 - 300 -> 25%
  // 300+ -> 0% (teto diário de esforço por atributo atingido)

  static const double tier1Efficiency = 1.0;
  static const double tier2Efficiency = 0.75;
  static const double tier3Efficiency = 0.50;
  static const double tier4Efficiency = 0.25;
  static const double tier5Efficiency = 0.0;

  // --- Missões Diárias ---
  /// Horas de sono que completam sozinhas a missão de Constituição.
  static const double questSleepHoursForCompletion = 8.0;

  /// Teto de minutos que um único treino pode creditar às missões
  /// (protege contra sessões esquecidas abertas por horas).
  static const double questMaxMinutesPerWorkout = 180.0;

  // --- Health & Activities (Constitution / Stage 4) ---
  /// Ideal sleep window (hours) and base XP tiers for sleep logs.
  static const double sleepIdealMinHours = 7.0;
  static const double sleepIdealMaxHours = 9.0;
  static const double sleepModerateMinHours = 5.0;
  static const double sleepIdealXp = 60.0;
  static const double sleepModerateXp = 40.0;
  static const double sleepLowXp = 20.0;

  /// Hydration tracking (cups of 250 ml).
  static const int waterCupMl = 250;
  static const int waterGoalDefaultCups = 8;
  static const int waterGoalMinCups = 4;
  static const int waterGoalMaxCups = 16;
  static const int waterMaxDailyCups = 24;

  /// XP per newly logged cup of water (up to the daily goal) and goal bonus.
  static const double xpPerWaterCup = 2.0;
  static const double waterGoalBonusXp = 10.0;

  /// Minutes credited to Constitution daily quests when hitting the water goal.
  static const double waterGoalQuestMinutes = 10.0;

  /// Daily nutrition / diet check-in rewards (once per day).
  static const double dietOnTrackXp = 25.0;
  static const double dietPartialXp = 12.0;
  static const double dietOnTrackQuestMinutes = 10.0;
  static const double dietPartialQuestMinutes = 5.0;

  /// Allowed duration range (in minutes) when logging a custom activity.
  static const int activityMinMinutes = 1;
  static const int activityMaxMinutes = 240;

  // --- Arena & Combat (Stage 5 — zero XP, cosmetic/title rewards only) ---
  /// Free Arena entries granted every day even before logging a workout.
  static const int arenaFreeDailyEntries = 2;

  /// Maximum turns before an Arena duel ends by exhaustion (prevents infinite loops).
  static const int combatMaxTurns = 30;

  /// Attribute score required in BOTH primary and secondary attributes of a
  /// class to unlock it for manual selection (Decision #41; score 12 = +1 mod).
  static const int classUnlockAttributeScore = 12;

  /// Fraction of max HP and max Focus restored between Tournament rounds.
  static const double tournamentBetweenRoundHpRecovery = 0.35;
  static const double tournamentBetweenRoundFocusRecovery = 0.50;

  /// Damage multiplier on a Natural 20 (or forced critical hit).
  static const double combatCriticalMultiplier = 2.0;

  /// Fraction of max HP lost by the hero on a Natural 1 (Critical Fumble).
  static const double combatFumbleSelfDamageFraction = 0.06;

  /// Dungeon room attribute check rewards and trap penalties.
  static const double dungeonCheckBlessingHpRecovery = 0.15;
  static const double dungeonCheckBlessingFocusRecovery = 0.25;
  static const double dungeonCheckTrapDamageFraction = 0.12;
  static const double dungeonBypassHpFraction = 0.05;

  // --- Weekly consistency (see weekly_progress.dart) ---
  /// Default weekly goal: training days per week.
  static const int weeklyGoalDefault = 3;
  static const int weeklyGoalMin = 1;
  static const int weeklyGoalMax = 7;

  /// "Goal Met": bonus on the training day that reaches the weekly goal.
  static const double weeklyGoalMetXp = 50.0;

  /// "Beyond Duty": bonus for each training day above the goal:
  /// base, base + step, base + 2*step... (days are capped at 7 per week).
  static const double beyondDutyBaseXp = 15.0;
  static const double beyondDutyStepXp = 5.0;

  /// "Flame of Constancy": +10% on weekly bonuses per consecutive week with
  /// the goal met (the current week counts from the 2nd week on), max +50%.
  static const double streakBonusPerWeek = 0.10;
  static const double streakBonusMax = 0.50;

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
