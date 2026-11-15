import 'dart:math' as math;

import 'attributes.dart';
import 'class_resolver.dart';
import 'progression.dart';
import 'xp_rules.dart';

/// Combat outcome state.
enum CombatStatus { ongoing, victory, defeat }

/// Player actions available on each turn.
enum CombatAction {
  /// Basic weapon/magic strike (0 Focus cost, restores +3 Focus).
  basicStrike,

  /// Class signature technique (costs Focus and has a turn cooldown).
  classSkill,

  /// Defensive posture (-50% incoming damage for 1 turn, restores Focus + small heal).
  defend,

  /// Spends 1 real-world Inspiration (max 1 per battle) for a guaranteed critical hit.
  heroicInspiration,
}

/// Telegraphed intention of the opponent for the upcoming turn.
enum EnemyIntent {
  /// Standard attack.
  strike,

  /// Heavy telegraphed blow (1.5x damage — rewards using Defend or Stun).
  heavyBlow,

  /// Defensive brace (+defense and slight recovery).
  guard,
}

/// Type of event recorded in the battle log (resolved to text by the UI).
enum CombatLogKind {
  heroBasicStrike,
  heroClassSkill,
  heroDefend,
  heroInspirationStrike,
  enemyStrike,
  enemyHeavyBlow,
  enemyGuard,
  enemyStunned,
  enemyDodged,
  heroDodged,
  victory,
  defeat,
}

/// Structured, language-neutral combat log entry.
final class CombatLogEntry {
  const CombatLogEntry({
    required this.turn,
    required this.kind,
    this.damage = 0,
    this.heal = 0,
    this.isCritical = false,
    this.skillId,
  });

  final int turn;
  final CombatLogKind kind;
  final int damage;
  final int heal;
  final bool isCritical;
  final String? skillId;
}

/// Signature combat technique of one of the 16 [CharacterClass]es, inspired by
/// classic D&D 5e class archetypes.
///
/// Visible names and descriptions live in localized game content under
/// `skill.<id>.name` and `skill.<id>.description`.
final class ClassSkill {
  const ClassSkill({
    required this.id,
    required this.characterClass,
    required this.focusCost,
    required this.cooldownTurns,
    required this.damageMultiplier,
    this.scalesWith,
    this.ignoresDefense = false,
    this.selfHealFraction = 0.0,
    this.buffTurns = 0,
    this.weakenTurns = 0,
    this.stunsTarget = false,
    this.hitsTwice = false,
    this.guaranteedCritWhenBuffedOrWeaken = false,
  });

  final String id;
  final CharacterClass characterClass;
  final int focusCost;
  final int cooldownTurns;
  final double damageMultiplier;

  /// Attribute that powers this skill (`null` = highest attribute for Adventurer).
  final Attribute? scalesWith;

  /// True when the attack bypasses physical defense (Arcane/Piercing).
  final bool ignoresDefense;

  /// Fraction of dealt damage (or spirit power) restored as HP.
  final double selfHealFraction;

  /// Turns of self-empowerment (+25% damage dealt, -25% damage taken).
  final int buffTurns;

  /// Turns of enemy weakening (-25% enemy attack damage).
  final int weakenTurns;

  /// True when the technique stuns the enemy for 1 turn.
  final bool stunsTarget;

  /// True when the technique strikes twice (e.g. Warrior's Action Surge).
  final bool hitsTwice;

  /// True when the technique is a guaranteed critical if the enemy is weakened
  /// or the hero is defending/buffed (e.g. Rogue's Sneak Attack).
  final bool guaranteedCritWhenBuffedOrWeaken;
}

/// Catalog of the 16 class signature skills.
abstract final class ClassSkillCatalog {
  static const Map<CharacterClass, ClassSkill> byClass = {
    CharacterClass.adventurer: ClassSkill(
      id: 'skill_adventurer',
      characterClass: CharacterClass.adventurer,
      focusCost: 8,
      cooldownTurns: 2,
      damageMultiplier: 1.45,
      buffTurns: 1,
    ),
    CharacterClass.warrior: ClassSkill(
      id: 'skill_warrior',
      characterClass: CharacterClass.warrior,
      scalesWith: Attribute.strength,
      focusCost: 10,
      cooldownTurns: 3,
      damageMultiplier: 0.90,
      hitsTwice: true,
    ),
    CharacterClass.barbarian: ClassSkill(
      id: 'skill_barbarian',
      characterClass: CharacterClass.barbarian,
      scalesWith: Attribute.strength,
      focusCost: 9,
      cooldownTurns: 3,
      damageMultiplier: 1.40,
      buffTurns: 3,
    ),
    CharacterClass.eldritchKnight: ClassSkill(
      id: 'skill_eldritch_knight',
      characterClass: CharacterClass.eldritchKnight,
      scalesWith: Attribute.strength,
      focusCost: 10,
      cooldownTurns: 2,
      damageMultiplier: 1.50,
      ignoresDefense: true,
    ),
    CharacterClass.templar: ClassSkill(
      id: 'skill_templar',
      characterClass: CharacterClass.templar,
      scalesWith: Attribute.strength,
      focusCost: 10,
      cooldownTurns: 3,
      damageMultiplier: 1.35,
      selfHealFraction: 0.30,
      buffTurns: 2,
    ),
    CharacterClass.paladin: ClassSkill(
      id: 'skill_paladin',
      characterClass: CharacterClass.paladin,
      scalesWith: Attribute.strength,
      focusCost: 11,
      cooldownTurns: 3,
      damageMultiplier: 1.55,
      selfHealFraction: 0.40,
    ),
    CharacterClass.ranger: ClassSkill(
      id: 'skill_ranger',
      characterClass: CharacterClass.ranger,
      scalesWith: Attribute.dexterity,
      focusCost: 9,
      cooldownTurns: 2,
      damageMultiplier: 1.50,
      ignoresDefense: true,
    ),
    CharacterClass.rogue: ClassSkill(
      id: 'skill_rogue',
      characterClass: CharacterClass.rogue,
      scalesWith: Attribute.dexterity,
      focusCost: 9,
      cooldownTurns: 2,
      damageMultiplier: 1.45,
      guaranteedCritWhenBuffedOrWeaken: true,
    ),
    CharacterClass.monk: ClassSkill(
      id: 'skill_monk',
      characterClass: CharacterClass.monk,
      scalesWith: Attribute.dexterity,
      focusCost: 11,
      cooldownTurns: 3,
      damageMultiplier: 1.25,
      stunsTarget: true,
    ),
    CharacterClass.bard: ClassSkill(
      id: 'skill_bard',
      characterClass: CharacterClass.bard,
      scalesWith: Attribute.charisma,
      focusCost: 9,
      cooldownTurns: 2,
      damageMultiplier: 1.30,
      weakenTurns: 2,
      buffTurns: 2,
    ),
    CharacterClass.artificer: ClassSkill(
      id: 'skill_artificer',
      characterClass: CharacterClass.artificer,
      scalesWith: Attribute.intelligence,
      focusCost: 10,
      cooldownTurns: 3,
      damageMultiplier: 1.35,
      buffTurns: 3,
    ),
    CharacterClass.druid: ClassSkill(
      id: 'skill_druid',
      characterClass: CharacterClass.druid,
      scalesWith: Attribute.wisdom,
      focusCost: 10,
      cooldownTurns: 3,
      damageMultiplier: 1.30,
      weakenTurns: 2,
      selfHealFraction: 0.35,
    ),
    CharacterClass.sorcerer: ClassSkill(
      id: 'skill_sorcerer',
      characterClass: CharacterClass.sorcerer,
      scalesWith: Attribute.charisma,
      focusCost: 11,
      cooldownTurns: 3,
      damageMultiplier: 1.70,
      ignoresDefense: true,
    ),
    CharacterClass.mage: ClassSkill(
      id: 'skill_mage',
      characterClass: CharacterClass.mage,
      scalesWith: Attribute.intelligence,
      focusCost: 12,
      cooldownTurns: 3,
      damageMultiplier: 1.75,
      ignoresDefense: true,
    ),
    CharacterClass.warlock: ClassSkill(
      id: 'skill_warlock',
      characterClass: CharacterClass.warlock,
      scalesWith: Attribute.charisma,
      focusCost: 10,
      cooldownTurns: 2,
      damageMultiplier: 1.45,
      selfHealFraction: 0.45,
      weakenTurns: 1,
    ),
    CharacterClass.cleric: ClassSkill(
      id: 'skill_cleric',
      characterClass: CharacterClass.cleric,
      scalesWith: Attribute.wisdom,
      focusCost: 10,
      cooldownTurns: 2,
      damageMultiplier: 1.30,
      selfHealFraction: 0.60,
    ),
  };

  static ClassSkill forClass(CharacterClass c) =>
      byClass[c] ?? byClass[CharacterClass.adventurer]!;
}

/// Cosmetic and title reward unlocked by defeating an Arena opponent or
/// Tournament tier. Never grants XP (Decision #40).
final class CombatReward {
  const CombatReward({
    required this.titleId,
    required this.cosmeticId,
  });

  /// Unlockable hero title key (`combatTitle.<titleId>`).
  final String titleId;

  /// Unlockable cosmetic item key (`combatCosmetic.<cosmeticId>`).
  final String cosmeticId;
}

/// Static definition of an NPC challenger in the Arena.
final class ArenaOpponent {
  const ArenaOpponent({
    required this.id,
    required this.recommendedLevel,
    required this.maxHp,
    required this.attack,
    required this.defense,
    required this.initiative,
    required this.dodgeChance,
    required this.reward,
  });

  final String id;
  final int recommendedLevel;
  final int maxHp;
  final int attack;
  final int defense;
  final int initiative;
  final double dodgeChance;
  final CombatReward reward;
}

/// Built-in catalog of Arena NPCs.
abstract final class ArenaCatalog {
  static const List<ArenaOpponent> opponents = [
    ArenaOpponent(
      id: 'npc_ash_recruit',
      recommendedLevel: 1,
      maxHp: 45,
      attack: 9,
      defense: 2,
      initiative: 9,
      dodgeChance: 0.04,
      reward: CombatReward(
        titleId: 'title_pit_initiate',
        cosmeticId: 'cosmetic_rusted_crest',
      ),
    ),
    ArenaOpponent(
      id: 'npc_iron_sentinel',
      recommendedLevel: 3,
      maxHp: 75,
      attack: 13,
      defense: 6,
      initiative: 8,
      dodgeChance: 0.03,
      reward: CombatReward(
        titleId: 'title_iron_breaker',
        cosmeticId: 'cosmetic_iron_pauldrons',
      ),
    ),
    ArenaOpponent(
      id: 'npc_shadow_duelist',
      recommendedLevel: 5,
      maxHp: 90,
      attack: 18,
      defense: 4,
      initiative: 15,
      dodgeChance: 0.16,
      reward: CombatReward(
        titleId: 'title_shadow_hunter',
        cosmeticId: 'cosmetic_obsidian_cloak',
      ),
    ),
    ArenaOpponent(
      id: 'npc_blood_inquisitor',
      recommendedLevel: 8,
      maxHp: 130,
      attack: 23,
      defense: 8,
      initiative: 12,
      dodgeChance: 0.08,
      reward: CombatReward(
        titleId: 'title_crimson_victor',
        cosmeticId: 'cosmetic_crimson_halo',
      ),
    ),
    ArenaOpponent(
      id: 'npc_hollow_archmage',
      recommendedLevel: 12,
      maxHp: 165,
      attack: 30,
      defense: 9,
      initiative: 14,
      dodgeChance: 0.10,
      reward: CombatReward(
        titleId: 'title_spell_shatterer',
        cosmeticId: 'cosmetic_runic_aura',
      ),
    ),
    ArenaOpponent(
      id: 'npc_forge_colossus',
      recommendedLevel: 16,
      maxHp: 240,
      attack: 38,
      defense: 15,
      initiative: 10,
      dodgeChance: 0.05,
      reward: CombatReward(
        titleId: 'title_arena_champion',
        cosmeticId: 'cosmetic_ember_crown',
      ),
    ),
  ];

  static ArenaOpponent? byId(String id) {
    for (final npc in opponents) {
      if (npc.id == id) return npc;
    }
    return null;
  }
}

/// Derived combat numbers of the hero from their real-world D&D attributes.
///
/// Every attribute has a clear role:
/// - **STR**: physical strike power and guard penetration.
/// - **DEX**: initiative, dodge chance, critical chance, and agile strike power.
/// - **CON**: maximum HP and physical defense.
/// - **INT**: maximum Focus pool and arcane strike power.
/// - **WIS**: healing efficiency, defend recovery, and counter-insight.
/// - **CHA**: critical chance, buff/debuff potency, and Heroic Inspiration power.
final class CombatStats {
  const CombatStats({
    required this.level,
    required this.characterClass,
    required this.scores,
    required this.maxHp,
    required this.maxFocus,
    required this.defense,
    required this.initiative,
    required this.dodgeChance,
    required this.critChance,
    required this.healBonus,
    required this.presenceMultiplier,
  });

  factory CombatStats.fromHero({
    required int level,
    required CharacterClass characterClass,
    required Map<Attribute, int> attributeScores,
  }) {
    int scoreOf(Attribute a) =>
        attributeScores[a] ?? XpRules.baseAttributeScore;
    int aboveBase(Attribute a) =>
        math.max(0, scoreOf(a) - XpRules.baseAttributeScore);

    final strAbove = aboveBase(Attribute.strength);
    final dexAbove = aboveBase(Attribute.dexterity);
    final conAbove = aboveBase(Attribute.constitution);
    final intAbove = aboveBase(Attribute.intelligence);
    final wisAbove = aboveBase(Attribute.wisdom);
    final chaAbove = aboveBase(Attribute.charisma);

    final safeLevel = level.clamp(1, XpRules.maxCharacterLevel);
    final maxHp = 42 + safeLevel * 8 + conAbove * 6 + strAbove * 2;
    final maxFocus = 20 + safeLevel * 2 + intAbove * 3 + wisAbove * 2;
    final defense = 2 + safeLevel + conAbove * 2 + (strAbove ~/ 2);
    final initiative =
        scoreOf(Attribute.dexterity) + Progression.calculateModifier(scoreOf(Attribute.wisdom));
    final dodgeChance = (0.05 + dexAbove * 0.015).clamp(0.05, 0.35);
    final critChance =
        (0.08 + dexAbove * 0.01 + chaAbove * 0.015).clamp(0.08, 0.45);
    final healBonus = 4 + wisAbove * 3 + conAbove;
    final presenceMultiplier = 1.0 + (chaAbove * 0.03).clamp(0.0, 0.45);

    return CombatStats(
      level: safeLevel,
      characterClass: characterClass,
      scores: {
        for (final a in Attribute.values) a: scoreOf(a),
      },
      maxHp: maxHp,
      maxFocus: maxFocus,
      defense: defense,
      initiative: initiative,
      dodgeChance: dodgeChance,
      critChance: critChance,
      healBonus: healBonus,
      presenceMultiplier: presenceMultiplier,
    );
  }

  final int level;
  final CharacterClass characterClass;
  final Map<Attribute, int> scores;
  final int maxHp;
  final int maxFocus;
  final int defense;
  final int initiative;
  final double dodgeChance;
  final double critChance;
  final int healBonus;
  final double presenceMultiplier;

  /// Attribute that powers the hero's primary attack (class primary, or the
  /// highest attribute for Adventurer).
  Attribute get primaryAttackAttribute {
    if (characterClass.primary != null) return characterClass.primary!;
    var best = Attribute.strength;
    var bestScore = -1;
    for (final a in Attribute.values) {
      final s = scores[a] ?? XpRules.baseAttributeScore;
      if (s > bestScore) {
        bestScore = s;
        best = a;
      }
    }
    return best;
  }

  /// Base offensive power for an attack scaling with [attribute].
  double attackPowerFor(Attribute attribute) {
    final primary = scores[attribute] ?? XpRules.baseAttributeScore;
    final primaryAbove = math.max(0, primary - XpRules.baseAttributeScore);
    final secondaryAttr = characterClass.secondary;
    final secondaryAbove = secondaryAttr == null
        ? 0
        : math.max(
            0,
            (scores[secondaryAttr] ?? XpRules.baseAttributeScore) -
                XpRules.baseAttributeScore,
          );
    return (10 + level * 2 + primaryAbove * 3 + secondaryAbove * 1.5) *
        presenceMultiplier;
  }
}

/// Immutable snapshot of an ongoing or finished 1v1 combat encounter.
final class CombatEncounter {
  const CombatEncounter({
    required this.hero,
    required this.opponent,
    required this.turn,
    required this.heroHp,
    required this.heroFocus,
    required this.enemyHp,
    required this.heroSkillCooldown,
    required this.heroBuffTurns,
    required this.heroDefending,
    required this.enemyWeakenTurns,
    required this.enemyStunned,
    required this.enemyIntent,
    required this.availableInspiration,
    required this.inspirationUsed,
    required this.status,
    required this.log,
  });

  final CombatStats hero;
  final ArenaOpponent opponent;
  final int turn;
  final int heroHp;
  final int heroFocus;
  final int enemyHp;
  final int heroSkillCooldown;
  final int heroBuffTurns;
  final bool heroDefending;
  final int enemyWeakenTurns;
  final bool enemyStunned;
  final EnemyIntent enemyIntent;
  final int availableInspiration;
  final bool inspirationUsed;
  final CombatStatus status;
  final List<CombatLogEntry> log;

  ClassSkill get skill => ClassSkillCatalog.forClass(hero.characterClass);

  bool get canUseClassSkill =>
      status == CombatStatus.ongoing &&
      heroSkillCooldown <= 0 &&
      heroFocus >= skill.focusCost;

  bool get canUseInspiration =>
      status == CombatStatus.ongoing &&
      !inspirationUsed &&
      availableInspiration > 0;
}

/// Rules for daily Arena entry tokens earned from real-world habits.
abstract final class ArenaTokenRules {
  /// Total Arena entries earned for today:
  /// - [XpRules.arenaFreeDailyEntries] free daily entries;
  /// - +1 per finished workout today;
  /// - +1 per completed daily quest today;
  /// - +1 when today's water goal or diet check-in is completed.
  static int totalEntriesToday({
    required int workoutsToday,
    required int questsCompletedToday,
    required bool healthHabitDoneToday,
  }) {
    return XpRules.arenaFreeDailyEntries +
        math.max<int>(0, workoutsToday) +
        math.max<int>(0, questsCompletedToday) +
        (healthHabitDoneToday ? 1 : 0);
  }
}

/// Pure-Dart turn-based combat engine.
abstract final class CombatEngine {
  /// Starts a new 1v1 encounter between [hero] and [opponent].
  static CombatEncounter start({
    required CombatStats hero,
    required ArenaOpponent opponent,
    int availableInspiration = 0,
  }) {
    return CombatEncounter(
      hero: hero,
      opponent: opponent,
      turn: 1,
      heroHp: hero.maxHp,
      heroFocus: hero.maxFocus,
      enemyHp: opponent.maxHp,
      heroSkillCooldown: 0,
      heroBuffTurns: 0,
      heroDefending: false,
      enemyWeakenTurns: 0,
      enemyStunned: false,
      enemyIntent: EnemyIntent.strike,
      availableInspiration: math.max(0, availableInspiration),
      inspirationUsed: false,
      status: CombatStatus.ongoing,
      log: const [],
    );
  }

  /// Resolves one full round (hero action followed by opponent response).
  static CombatEncounter executeTurn(
    CombatEncounter state,
    CombatAction action, {
    math.Random? random,
  }) {
    if (state.status != CombatStatus.ongoing) return state;
    final rng = random ?? math.Random();
    final log = List<CombatLogEntry>.of(state.log);
    final skill = state.skill;

    var heroHp = state.heroHp;
    var heroFocus = state.heroFocus;
    var enemyHp = state.enemyHp;
    var cooldown = math.max(0, state.heroSkillCooldown - 1);
    var heroBuff = state.heroBuffTurns;
    var enemyWeaken = state.enemyWeakenTurns;
    var enemyStunned = state.enemyStunned;
    var defending = false;
    var inspirationUsed = state.inspirationUsed;
    var availableInsp = state.availableInspiration;

    final heroBuffMultiplier = heroBuff > 0 ? 1.25 : 1.0;
    final enemyGuardReduction =
        state.enemyIntent == EnemyIntent.guard ? 0.65 : 1.0;

    int computeDamage({
      required Attribute attr,
      required double multiplier,
      required bool ignoresDefense,
      required bool forceCrit,
    }) {
      final raw = state.hero.attackPowerFor(attr) *
          multiplier *
          heroBuffMultiplier *
          enemyGuardReduction;
      final isCrit = forceCrit || rng.nextDouble() < state.hero.critChance;
      final critBoosted = isCrit ? raw * 1.5 : raw;
      final mitigation = ignoresDefense ? 0 : state.opponent.defense;
      return math.max(1, (critBoosted - mitigation).round());
    }

    // --- 1. Hero Action ---
    switch (action) {
      case CombatAction.basicStrike:
        heroFocus = math.min(state.hero.maxFocus, heroFocus + 3);
        if (rng.nextDouble() < state.opponent.dodgeChance) {
          log.add(
            CombatLogEntry(turn: state.turn, kind: CombatLogKind.enemyDodged),
          );
        } else {
          final isCrit = rng.nextDouble() < state.hero.critChance;
          final raw = state.hero.attackPowerFor(
                state.hero.primaryAttackAttribute,
              ) *
              heroBuffMultiplier *
              enemyGuardReduction *
              (isCrit ? 1.5 : 1.0);
          final dmg = math.max(1, (raw - state.opponent.defense).round());
          enemyHp = math.max(0, enemyHp - dmg);
          log.add(
            CombatLogEntry(
              turn: state.turn,
              kind: CombatLogKind.heroBasicStrike,
              damage: dmg,
              isCritical: isCrit,
            ),
          );
        }

      case CombatAction.classSkill:
        if (!state.canUseClassSkill) {
          return executeTurn(state, CombatAction.basicStrike, random: rng);
        }
        heroFocus -= skill.focusCost;
        cooldown = skill.cooldownTurns;
        final scaleAttr =
            skill.scalesWith ?? state.hero.primaryAttackAttribute;
        final forceCrit = skill.guaranteedCritWhenBuffedOrWeaken &&
            (heroBuff > 0 || enemyWeaken > 0);
        final hits = skill.hitsTwice ? 2 : 1;
        var totalDmg = 0;
        var anyCrit = forceCrit;
        for (var i = 0; i < hits; i++) {
          final isCrit =
              forceCrit || rng.nextDouble() < state.hero.critChance;
          if (isCrit) anyCrit = true;
          final raw = state.hero.attackPowerFor(scaleAttr) *
              skill.damageMultiplier *
              heroBuffMultiplier *
              enemyGuardReduction *
              (isCrit ? 1.5 : 1.0);
          final mitigation =
              skill.ignoresDefense ? 0 : state.opponent.defense;
          totalDmg += math.max(1, (raw - mitigation).round());
        }
        enemyHp = math.max(0, enemyHp - totalDmg);
        var healAmount = 0;
        if (skill.selfHealFraction > 0) {
          healAmount = math.max(
            state.hero.healBonus,
            (totalDmg * skill.selfHealFraction).round(),
          );
          heroHp = math.min(state.hero.maxHp, heroHp + healAmount);
        }
        if (skill.buffTurns > 0) {
          heroBuff = math.max(heroBuff, skill.buffTurns);
        }
        if (skill.weakenTurns > 0) {
          enemyWeaken = math.max(enemyWeaken, skill.weakenTurns);
        }
        if (skill.stunsTarget) {
          enemyStunned = true;
        }
        log.add(
          CombatLogEntry(
            turn: state.turn,
            kind: CombatLogKind.heroClassSkill,
            damage: totalDmg,
            heal: healAmount,
            isCritical: anyCrit,
            skillId: skill.id,
          ),
        );

      case CombatAction.defend:
        defending = true;
        heroFocus = math.min(state.hero.maxFocus, heroFocus + 8);
        final heal = state.hero.healBonus;
        heroHp = math.min(state.hero.maxHp, heroHp + heal);
        log.add(
          CombatLogEntry(
            turn: state.turn,
            kind: CombatLogKind.heroDefend,
            heal: heal,
          ),
        );

      case CombatAction.heroicInspiration:
        if (!state.canUseInspiration) {
          return executeTurn(state, CombatAction.basicStrike, random: rng);
        }
        inspirationUsed = true;
        availableInsp = math.max(0, availableInsp - 1);
        heroFocus = math.min(state.hero.maxFocus, heroFocus + 6);
        final dmg = computeDamage(
          attr: state.hero.primaryAttackAttribute,
          multiplier: 1.65,
          ignoresDefense: true,
          forceCrit: true,
        );
        enemyHp = math.max(0, enemyHp - dmg);
        log.add(
          CombatLogEntry(
            turn: state.turn,
            kind: CombatLogKind.heroInspirationStrike,
            damage: dmg,
            isCritical: true,
          ),
        );
    }

    // Check if opponent was defeated by the hero's action.
    if (enemyHp <= 0) {
      log.add(CombatLogEntry(turn: state.turn, kind: CombatLogKind.victory));
      return CombatEncounter(
        hero: state.hero,
        opponent: state.opponent,
        turn: state.turn,
        heroHp: heroHp,
        heroFocus: heroFocus,
        enemyHp: 0,
        heroSkillCooldown: cooldown,
        heroBuffTurns: heroBuff,
        heroDefending: defending,
        enemyWeakenTurns: enemyWeaken,
        enemyStunned: false,
        enemyIntent: state.enemyIntent,
        availableInspiration: availableInsp,
        inspirationUsed: inspirationUsed,
        status: CombatStatus.victory,
        log: log,
      );
    }

    // --- 2. Opponent Turn ---
    if (enemyStunned) {
      enemyStunned = false;
      log.add(
        CombatLogEntry(turn: state.turn, kind: CombatLogKind.enemyStunned),
      );
    } else if (state.enemyIntent == EnemyIntent.guard) {
      final enemyHeal = math.max(2, (state.opponent.maxHp * 0.05).round());
      enemyHp = math.min(state.opponent.maxHp, enemyHp + enemyHeal);
      log.add(
        CombatLogEntry(
          turn: state.turn,
          kind: CombatLogKind.enemyGuard,
          heal: enemyHeal,
        ),
      );
    } else {
      if (rng.nextDouble() < state.hero.dodgeChance) {
        log.add(
          CombatLogEntry(turn: state.turn, kind: CombatLogKind.heroDodged),
        );
      } else {
        final intentMult =
            state.enemyIntent == EnemyIntent.heavyBlow ? 1.50 : 1.0;
        final weakenMult = enemyWeaken > 0 ? 0.75 : 1.0;
        final buffMitigation = heroBuff > 0 ? 0.75 : 1.0;
        final defendMitigation = defending ? 0.50 : 1.0;

        final rawEnemy = state.opponent.attack * intentMult * weakenMult;
        final afterDef = math.max(1.0, rawEnemy - state.hero.defense);
        final dmg = math.max(
          1,
          (afterDef * buffMitigation * defendMitigation).round(),
        );
        heroHp = math.max(0, heroHp - dmg);
        log.add(
          CombatLogEntry(
            turn: state.turn,
            kind: state.enemyIntent == EnemyIntent.heavyBlow
                ? CombatLogKind.enemyHeavyBlow
                : CombatLogKind.enemyStrike,
            damage: dmg,
          ),
        );
      }
    }

    // Tick down active buffs/debuffs at end of round.
    if (heroBuff > 0) heroBuff--;
    if (enemyWeaken > 0) enemyWeaken--;

    final nextTurn = state.turn + 1;
    final defeated = heroHp <= 0 || nextTurn > XpRules.combatMaxTurns;
    if (defeated) {
      log.add(CombatLogEntry(turn: state.turn, kind: CombatLogKind.defeat));
    }

    // Deterministic/telegraphed enemy intent cycle: strike -> heavyBlow -> strike -> guard.
    final nextIntent = switch (nextTurn % 4) {
      2 => EnemyIntent.heavyBlow,
      0 => EnemyIntent.guard,
      _ => EnemyIntent.strike,
    };

    return CombatEncounter(
      hero: state.hero,
      opponent: state.opponent,
      turn: defeated ? state.turn : nextTurn,
      heroHp: heroHp,
      heroFocus: heroFocus,
      enemyHp: enemyHp,
      heroSkillCooldown: cooldown,
      heroBuffTurns: heroBuff,
      heroDefending: false,
      enemyWeakenTurns: enemyWeaken,
      enemyStunned: enemyStunned,
      enemyIntent: nextIntent,
      availableInspiration: availableInsp,
      inspirationUsed: inspirationUsed,
      status: defeated ? CombatStatus.defeat : CombatStatus.ongoing,
      log: log,
    );
  }
}
