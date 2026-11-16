import 'dart:math' as math;

import 'attributes.dart';
import 'combat.dart';

/// Modular D&D 5e combat mechanics combined by the 18 Legendary Weekly Bosses.
///
/// Keeping mechanics as composable building blocks lets every Legendary Boss feel
/// tactically distinct while sharing deterministic rules in [CombatEngine].
enum LegendaryMechanicKind {
  /// Starts with a spatial/arcane ward raising AC drastically until pierced by a
  /// Critical Hit, class skill pressure, or weekly weakness seals.
  infinityBarrier,

  /// Strikes inflict stacking Bleed ticks; below 50% HP triggers a slashing
  /// domain that rewards using Defend.
  bleedSanctuary,

  /// Telegraphs Rock/Blade/Wave-style heavy patterns and enters an all-out
  /// high-risk stance below 35% HP (lower AC, higher attack).
  telegraphedTriad,

  /// Immediately counters hero `basicStrike` hits unless broken by a Critical,
  /// stun, or class skill.
  counterStance,

  /// Adapts to repeated hero actions: using the same CombatAction two turns in
  /// a row grants the boss +3 AC and 35% damage resistance against it.
  tacticalAdaptation,

  /// Awakens into higher forms at 65% and 30% HP, gaining evasion/attack bursts.
  multiPhaseAwakening,

  /// Starts with armored plates granting +4 AC and 30% mitigation; shattered
  /// one by one via Critical Hits, Class Skills, or weekly weakness seals.
  armorPlates,

  /// Drains hero Focus on landed hits and applies dark/frost burn unless guarded.
  focusDrainAndBurn,

  /// Cycles massive surged blows every 3 turns, leaving a brief recoil opening
  /// (-3 AC) on the following turn.
  powerStealOrSurge,
}

/// Static definition of a Weekly Legendary Boss (inspired by iconic pop-culture
/// archetypes adapted safely into Grindheim's Dark Fantasy D&D 5e rules).
///
/// Never grants XP (Decision #40); awards exclusive Legendary Titles and Cosmetics.
final class LegendaryBossSpec {
  const LegendaryBossSpec({
    required this.id,
    required this.primaryAttribute,
    required this.recommendedLevel,
    required this.maxHp,
    required this.attack,
    required this.defense,
    required this.initiative,
    required this.dodgeChance,
    required this.primaryMechanic,
    required this.secondaryMechanic,
    required this.reward,
  });

  final String id;
  final Attribute primaryAttribute;
  final int recommendedLevel;
  final int maxHp;
  final int attack;
  final int defense;
  final int initiative;
  final double dodgeChance;
  final LegendaryMechanicKind primaryMechanic;
  final LegendaryMechanicKind secondaryMechanic;
  final CombatReward reward;

  bool hasMechanic(LegendaryMechanicKind kind) =>
      primaryMechanic == kind || secondaryMechanic == kind;

  /// Instantiates a combat-ready [ArenaOpponent] scaled to [heroLevel] and
  /// weakened by real-world weekly habit seals ([weaknessStacks], `0..7`).
  ArenaOpponent instantiate({
    required int heroLevel,
    int weaknessStacks = 0,
  }) {
    final safeSeals = weaknessStacks.clamp(0, 7);
    final effectiveLevel = math.max(1, heroLevel);
    // Keep Legendary Bosses formidable above the hero while scaling cleanly.
    final levelScale = (0.72 + effectiveLevel * 0.055).clamp(0.75, 1.55);
    final hpSealFactor = 1.0 - safeSeals * 0.05; // up to -35% HP
    final atkSealFactor = 1.0 - safeSeals * 0.04; // up to -28% Attack
    final defReduction = safeSeals ~/ 2; // up to -3 Defense

    return ArenaOpponent(
      id: id,
      recommendedLevel: effectiveLevel,
      maxHp: math.max(40, (maxHp * levelScale * hpSealFactor).round()),
      attack: math.max(6, (attack * levelScale * atkSealFactor).round()),
      defense: math.max(1, (defense * levelScale).round() - defReduction),
      initiative: initiative,
      dodgeChance: math.max(0.03, dodgeChance - safeSeals * 0.008),
      reward: reward,
    );
  }
}

/// Built-in catalog of all 18 Weekly Legendary Bosses.
abstract final class LegendaryBossCatalog {
  static const List<LegendaryBossSpec> bosses = [
    // 1. Satorion (inspired by Satoru Gojo)
    LegendaryBossSpec(
      id: 'boss_satorion',
      primaryAttribute: Attribute.intelligence,
      recommendedLevel: 8,
      maxHp: 175,
      attack: 25,
      defense: 8,
      initiative: 16,
      dodgeChance: 0.14,
      primaryMechanic: LegendaryMechanicKind.infinityBarrier,
      secondaryMechanic: LegendaryMechanicKind.powerStealOrSurge,
      reward: CombatReward(
        titleId: 'title_infinite_gaze',
        cosmeticId: 'cosmetic_void_blindfold',
      ),
    ),
    // 2. Ryomoth (inspired by Ryomen Sukuna)
    LegendaryBossSpec(
      id: 'boss_ryomoth',
      primaryAttribute: Attribute.strength,
      recommendedLevel: 10,
      maxHp: 190,
      attack: 29,
      defense: 8,
      initiative: 15,
      dodgeChance: 0.10,
      primaryMechanic: LegendaryMechanicKind.bleedSanctuary,
      secondaryMechanic: LegendaryMechanicKind.counterStance,
      reward: CombatReward(
        titleId: 'title_curse_monarch',
        cosmeticId: 'cosmetic_shrine_marks',
      ),
    ),
    // 3. Gonnir (inspired by Gon Freecss)
    LegendaryBossSpec(
      id: 'boss_gonnir',
      primaryAttribute: Attribute.strength,
      recommendedLevel: 6,
      maxHp: 155,
      attack: 26,
      defense: 6,
      initiative: 14,
      dodgeChance: 0.12,
      primaryMechanic: LegendaryMechanicKind.telegraphedTriad,
      secondaryMechanic: LegendaryMechanicKind.powerStealOrSurge,
      reward: CombatReward(
        titleId: 'title_vow_breaker',
        cosmeticId: 'cosmetic_oath_gauntlets',
      ),
    ),
    // 4. Netherion (inspired by Isaac Netero)
    LegendaryBossSpec(
      id: 'boss_netherion',
      primaryAttribute: Attribute.wisdom,
      recommendedLevel: 11,
      maxHp: 185,
      attack: 27,
      defense: 9,
      initiative: 17,
      dodgeChance: 0.15,
      primaryMechanic: LegendaryMechanicKind.counterStance,
      secondaryMechanic: LegendaryMechanicKind.telegraphedTriad,
      reward: CombatReward(
        titleId: 'title_hundred_palms',
        cosmeticId: 'cosmetic_lotus_prayer_beads',
      ),
    ),
    // 5. Meruvor (inspired by Meruem)
    LegendaryBossSpec(
      id: 'boss_meruvor',
      primaryAttribute: Attribute.intelligence,
      recommendedLevel: 13,
      maxHp: 215,
      attack: 30,
      defense: 12,
      initiative: 16,
      dodgeChance: 0.12,
      primaryMechanic: LegendaryMechanicKind.tacticalAdaptation,
      secondaryMechanic: LegendaryMechanicKind.armorPlates,
      reward: CombatReward(
        titleId: 'title_chimera_sovereign',
        cosmeticId: 'cosmetic_chitin_crown',
      ),
    ),
    // 6. Kakarion (inspired by Son Goku)
    LegendaryBossSpec(
      id: 'boss_kakarion',
      primaryAttribute: Attribute.dexterity,
      recommendedLevel: 12,
      maxHp: 200,
      attack: 28,
      defense: 8,
      initiative: 17,
      dodgeChance: 0.16,
      primaryMechanic: LegendaryMechanicKind.multiPhaseAwakening,
      secondaryMechanic: LegendaryMechanicKind.powerStealOrSurge,
      reward: CombatReward(
        titleId: 'title_astral_ascendant',
        cosmeticId: 'cosmetic_silver_instinct_aura',
      ),
    ),
    // 7. Toshirion (inspired by All Might)
    LegendaryBossSpec(
      id: 'boss_toshirion',
      primaryAttribute: Attribute.strength,
      recommendedLevel: 9,
      maxHp: 195,
      attack: 31,
      defense: 9,
      initiative: 12,
      dodgeChance: 0.08,
      primaryMechanic: LegendaryMechanicKind.powerStealOrSurge,
      secondaryMechanic: LegendaryMechanicKind.telegraphedTriad,
      reward: CombatReward(
        titleId: 'title_beacon_of_forging',
        cosmeticId: 'cosmetic_ember_cape_crest',
      ),
    ),
    // 8. Aforion (inspired by All For One)
    LegendaryBossSpec(
      id: 'boss_aforion',
      primaryAttribute: Attribute.charisma,
      recommendedLevel: 12,
      maxHp: 190,
      attack: 27,
      defense: 10,
      initiative: 13,
      dodgeChance: 0.09,
      primaryMechanic: LegendaryMechanicKind.focusDrainAndBurn,
      secondaryMechanic: LegendaryMechanicKind.powerStealOrSurge,
      reward: CombatReward(
        titleId: 'title_gift_usurper',
        cosmeticId: 'cosmetic_faceless_iron_mask',
      ),
    ),
    // 9. Lord Vadric (inspired by Darth Vader)
    LegendaryBossSpec(
      id: 'boss_vadric',
      primaryAttribute: Attribute.constitution,
      recommendedLevel: 10,
      maxHp: 205,
      attack: 28,
      defense: 12,
      initiative: 11,
      dodgeChance: 0.06,
      primaryMechanic: LegendaryMechanicKind.focusDrainAndBurn,
      secondaryMechanic: LegendaryMechanicKind.armorPlates,
      reward: CombatReward(
        titleId: 'title_iron_shroud_lord',
        cosmeticId: 'cosmetic_crimson_saber_hilt',
      ),
    ),
    // 10. Vegor (inspired by Vegeta)
    LegendaryBossSpec(
      id: 'boss_vegor',
      primaryAttribute: Attribute.strength,
      recommendedLevel: 11,
      maxHp: 185,
      attack: 29,
      defense: 9,
      initiative: 15,
      dodgeChance: 0.12,
      primaryMechanic: LegendaryMechanicKind.multiPhaseAwakening,
      secondaryMechanic: LegendaryMechanicKind.focusDrainAndBurn,
      reward: CombatReward(
        titleId: 'title_pride_prince',
        cosmeticId: 'cosmetic_royal_battle_pauldron',
      ),
    ),
    // 11. Naruval (inspired by Naruto)
    LegendaryBossSpec(
      id: 'boss_naruval',
      primaryAttribute: Attribute.charisma,
      recommendedLevel: 9,
      maxHp: 180,
      attack: 25,
      defense: 7,
      initiative: 15,
      dodgeChance: 0.15,
      primaryMechanic: LegendaryMechanicKind.multiPhaseAwakening,
      secondaryMechanic: LegendaryMechanicKind.counterStance,
      reward: CombatReward(
        titleId: 'title_nine_flame_sage',
        cosmeticId: 'cosmetic_spiral_fox_mantle',
      ),
    ),
    // 12. Sasukar (inspired by Sasuke)
    LegendaryBossSpec(
      id: 'boss_sasukar',
      primaryAttribute: Attribute.dexterity,
      recommendedLevel: 10,
      maxHp: 170,
      attack: 27,
      defense: 8,
      initiative: 16,
      dodgeChance: 0.16,
      primaryMechanic: LegendaryMechanicKind.focusDrainAndBurn,
      secondaryMechanic: LegendaryMechanicKind.tacticalAdaptation,
      reward: CombatReward(
        titleId: 'title_eclipse_blade',
        cosmeticId: 'cosmetic_scarlet_eclipse_eye',
      ),
    ),
    // 13. Arthorius (inspired by Lich King / Arthas)
    LegendaryBossSpec(
      id: 'boss_arthorius',
      primaryAttribute: Attribute.constitution,
      recommendedLevel: 12,
      maxHp: 220,
      attack: 27,
      defense: 13,
      initiative: 11,
      dodgeChance: 0.06,
      primaryMechanic: LegendaryMechanicKind.armorPlates,
      secondaryMechanic: LegendaryMechanicKind.focusDrainAndBurn,
      reward: CombatReward(
        titleId: 'title_frost_crown_bane',
        cosmeticId: 'cosmetic_frost_helm_shards',
      ),
    ),
    // 14. Gerric (inspired by Geralt of Rivia)
    LegendaryBossSpec(
      id: 'boss_gerric',
      primaryAttribute: Attribute.wisdom,
      recommendedLevel: 7,
      maxHp: 165,
      attack: 24,
      defense: 8,
      initiative: 15,
      dodgeChance: 0.14,
      primaryMechanic: LegendaryMechanicKind.counterStance,
      secondaryMechanic: LegendaryMechanicKind.infinityBarrier,
      reward: CombatReward(
        titleId: 'title_silver_wolf_slayer',
        cosmeticId: 'cosmetic_twin_silver_medallion',
      ),
    ),
    // 15. Kaibaron (inspired by Seto Kaiba)
    LegendaryBossSpec(
      id: 'boss_kaibaron',
      primaryAttribute: Attribute.intelligence,
      recommendedLevel: 8,
      maxHp: 170,
      attack: 25,
      defense: 9,
      initiative: 14,
      dodgeChance: 0.09,
      primaryMechanic: LegendaryMechanicKind.tacticalAdaptation,
      secondaryMechanic: LegendaryMechanicKind.telegraphedTriad,
      reward: CombatReward(
        titleId: 'title_white_wyrm_master',
        cosmeticId: 'cosmetic_white_wyrm_coat',
      ),
    ),
    // 16. Saurath (inspired by Sauron)
    LegendaryBossSpec(
      id: 'boss_saurath',
      primaryAttribute: Attribute.charisma,
      recommendedLevel: 14,
      maxHp: 230,
      attack: 30,
      defense: 14,
      initiative: 10,
      dodgeChance: 0.04,
      primaryMechanic: LegendaryMechanicKind.focusDrainAndBurn,
      secondaryMechanic: LegendaryMechanicKind.bleedSanctuary,
      reward: CombatReward(
        titleId: 'title_dark_tower_conqueror',
        cosmeticId: 'cosmetic_forged_ring_sigil',
      ),
    ),
    // 17. Erendir (inspired by Eren Yeager)
    LegendaryBossSpec(
      id: 'boss_erendir',
      primaryAttribute: Attribute.constitution,
      recommendedLevel: 11,
      maxHp: 225,
      attack: 28,
      defense: 10,
      initiative: 12,
      dodgeChance: 0.07,
      primaryMechanic: LegendaryMechanicKind.multiPhaseAwakening,
      secondaryMechanic: LegendaryMechanicKind.armorPlates,
      reward: CombatReward(
        titleId: 'title_titan_of_ruin',
        cosmeticId: 'cosmetic_crystal_titan_scars',
      ),
    ),
    // 18. Reinor (inspired by Reiner Braun)
    LegendaryBossSpec(
      id: 'boss_reinor',
      primaryAttribute: Attribute.constitution,
      recommendedLevel: 10,
      maxHp: 235,
      attack: 26,
      defense: 15,
      initiative: 9,
      dodgeChance: 0.04,
      primaryMechanic: LegendaryMechanicKind.armorPlates,
      secondaryMechanic: LegendaryMechanicKind.telegraphedTriad,
      reward: CombatReward(
        titleId: 'title_armored_colossus_breaker',
        cosmeticId: 'cosmetic_armored_titan_plates',
      ),
    ),
  ];

  static LegendaryBossSpec? byId(String id) {
    for (final b in bosses) {
      if (b.id == id) return b;
    }
    return null;
  }

  /// Deterministically picks the Weekly Legendary Boss for the ISO week of [date].
  static LegendaryBossSpec forWeek(DateTime date) {
    final epoch = DateTime.utc(2026, 1, 5); // Monday anchor
    final utcDate = DateTime.utc(date.year, date.month, date.day);
    final diffDays = utcDate.difference(epoch).inDays;
    final weekIndex = diffDays >= 0 ? (diffDays ~/ 7) : 0;
    return bosses[weekIndex % bosses.length];
  }

  /// Computes how many Weakness Seals (`0..7`) the hero has earned this week
  /// through real-world habits to weaken the Weekly Legendary Boss.
  static int computeWeeklyWeaknessStacks({
    required int workoutsThisWeek,
    required int questsCompletedThisWeek,
    required int healthHabitsThisWeek,
  }) {
    final total = math.max(0, workoutsThisWeek) +
        (math.max(0, questsCompletedThisWeek) ~/ 2) +
        (math.max(0, healthHabitsThisWeek) ~/ 2);
    return total.clamp(0, 7);
  }
}
