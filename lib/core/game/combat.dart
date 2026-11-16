import 'dart:math' as math;

import 'attributes.dart';
import 'class_resolver.dart';
import 'legendary_bosses.dart';
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
  heroCriticalFumble,
  enemyStrike,
  enemyHeavyBlow,
  enemyGuard,
  enemyStunned,
  enemyDodged,
  heroDodged,
  legendaryCounter,
  legendaryBleedTick,
  legendaryPhaseShift,
  legendaryPlateBroken,
  legendaryBarrierPierced,
  legendaryFocusDrain,
  legendarySurge,
  victory,
  defeat,
}

/// Outcome classification of a `1d20 + modifier` roll.
enum D20Outcome {
  /// Natural 20 (or Heroic Inspiration guaranteed critical): automatic hit and 2x damage.
  criticalHit,

  /// Total roll (`d20 + attributeModifier + proficiencyBonus`) >= target AC/DC.
  hit,

  /// Total roll < target AC/DC (and not a Natural 1 or 20).
  miss,

  /// Natural 1: catastrophic failure (automatic miss and self-opening recoil).
  criticalFumble,
}

/// Immutable snapshot of a single D&D 5e `1d20` check or attack roll.
final class D20RollResult {
  const D20RollResult({
    required this.naturalRoll,
    required this.attribute,
    required this.attributeModifier,
    required this.proficiencyBonus,
    required this.targetNumber,
    required this.outcome,
  });

  /// Face shown on the 20-sided die (`1..20`).
  final int naturalRoll;

  /// Attribute added to the roll.
  final Attribute attribute;

  /// Classic D&D 5e modifier `floor((score - 10) / 2)`.
  final int attributeModifier;

  /// Level-based proficiency bonus (`+2` to `+6`).
  final int proficiencyBonus;

  /// Target Armor Class (AC) or Difficulty Class (DC).
  final int targetNumber;

  /// Resulting outcome of the roll.
  final D20Outcome outcome;

  int get totalBonus => attributeModifier + proficiencyBonus;
  int get totalRoll => naturalRoll + totalBonus;
  bool get isHit =>
      outcome == D20Outcome.criticalHit || outcome == D20Outcome.hit;
  bool get isCriticalHit => outcome == D20Outcome.criticalHit;
  bool get isCriticalFumble => outcome == D20Outcome.criticalFumble;
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
    this.roll,
  });

  final int turn;
  final CombatLogKind kind;
  final int damage;
  final int heal;
  final bool isCritical;
  final String? skillId;
  final D20RollResult? roll;
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

  /// Target Armor Class (AC) in D&D 5e (`1d20 + attackBonus >= armorClass`).
  int get armorClass =>
      (9 + (defense ~/ 2) + (dodgeChance * 15).round()).clamp(10, 20);
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

/// Multi-round Tournament (Gauntlet) bracket definition.
///
/// Opponents scale up or down according to [statScale] so early tournaments
/// are accessible and high-tier tournaments challenge end-game heroes.
/// Never grants XP (Decision #40); awards a prestige [reward] upon winning
/// all rounds.
final class TournamentDefinition {
  const TournamentDefinition({
    required this.id,
    required this.recommendedLevel,
    required this.statScale,
    required this.opponentIds,
    required this.reward,
  });

  final String id;
  final int recommendedLevel;

  /// Multiplier applied to each opponent's HP, attack, and defense.
  final double statScale;

  /// Ordered list of [ArenaOpponent.id]s fought sequentially in this bracket.
  final List<String> opponentIds;

  /// Prestige title and cosmetic unlocked when all rounds are cleared.
  final CombatReward reward;

  /// Builds the scaled sequence of opponents for this tournament.
  List<ArenaOpponent> get scaledOpponents => [
        for (final npcId in opponentIds)
          if (ArenaCatalog.byId(npcId) case final base?)
            ArenaOpponent(
              id: base.id,
              recommendedLevel: recommendedLevel,
              maxHp: math.max(10, (base.maxHp * statScale).round()),
              attack: math.max(2, (base.attack * statScale).round()),
              defense: math.max(0, (base.defense * statScale).round()),
              initiative: base.initiative,
              dodgeChance: base.dodgeChance,
              reward: reward,
            ),
      ];
}

/// Catalog of Forge Tournaments.
abstract final class TournamentCatalog {
  static const List<TournamentDefinition> tournaments = [
    TournamentDefinition(
      id: 'tournament_bronze',
      recommendedLevel: 3,
      statScale: 0.85,
      opponentIds: [
        'npc_ash_recruit',
        'npc_iron_sentinel',
        'npc_shadow_duelist',
      ],
      reward: CombatReward(
        titleId: 'title_bronze_gladiator',
        cosmeticId: 'cosmetic_bronze_laurel',
      ),
    ),
    TournamentDefinition(
      id: 'tournament_silver',
      recommendedLevel: 7,
      statScale: 1.00,
      opponentIds: [
        'npc_iron_sentinel',
        'npc_shadow_duelist',
        'npc_blood_inquisitor',
      ],
      reward: CombatReward(
        titleId: 'title_iron_champion',
        cosmeticId: 'cosmetic_steel_crest',
      ),
    ),
    TournamentDefinition(
      id: 'tournament_crimson',
      recommendedLevel: 12,
      statScale: 1.15,
      opponentIds: [
        'npc_shadow_duelist',
        'npc_blood_inquisitor',
        'npc_hollow_archmage',
      ],
      reward: CombatReward(
        titleId: 'title_crimson_warlord',
        cosmeticId: 'cosmetic_blood_mantle',
      ),
    ),
    TournamentDefinition(
      id: 'tournament_obsidian',
      recommendedLevel: 16,
      statScale: 1.30,
      opponentIds: [
        'npc_blood_inquisitor',
        'npc_hollow_archmage',
        'npc_forge_colossus',
        'npc_forge_colossus',
      ],
      reward: CombatReward(
        titleId: 'title_grand_monarch',
        cosmeticId: 'cosmetic_obsidian_wings',
      ),
    ),
  ];

  static TournamentDefinition? byId(String id) {
    for (final t in tournaments) {
      if (t.id == id) return t;
    }
    return null;
  }
}

/// Active multi-round Tournament state.
final class TournamentRun {
  const TournamentRun({
    required this.tournament,
    required this.rounds,
    required this.roundIndex,
    required this.encounter,
  });

  final TournamentDefinition tournament;
  final List<ArenaOpponent> rounds;
  final int roundIndex;
  final CombatEncounter encounter;

  int get currentRoundNumber => roundIndex + 1;
  int get totalRounds => rounds.length;
  bool get hasNextRound => roundIndex + 1 < rounds.length;

  /// True when the current round was won and another opponent awaits.
  bool get isRoundVictory =>
      encounter.status == CombatStatus.victory && hasNextRound;

  /// True when the final round of the tournament has been won.
  bool get isTournamentVictory =>
      encounter.status == CombatStatus.victory && !hasNextRound;
}

/// Single room/node inside a [DungeonDefinition] that challenges one of the
/// hero's 6 real-world D&D attributes (`1d20 + mod + proficiency >= difficultyClass`).
final class DungeonRoom {
  const DungeonRoom({
    required this.id,
    required this.attribute,
    required this.difficultyClass,
  });

  final String id;
  final Attribute attribute;
  final int difficultyClass;
}

/// Static definition of a multi-room Dungeon culminating in a Boss fight.
///
/// Never grants XP (Decision #40); awards a prestige [reward] upon defeating
/// the final Boss.
final class DungeonDefinition {
  const DungeonDefinition({
    required this.id,
    required this.recommendedLevel,
    required this.rooms,
    required this.bossId,
    required this.statScale,
    required this.reward,
  });

  final String id;
  final int recommendedLevel;
  final List<DungeonRoom> rooms;
  final String bossId;
  final double statScale;
  final CombatReward reward;

  /// Boss opponent scaled for this dungeon's tier.
  ArenaOpponent get scaledBoss {
    final base = ArenaCatalog.byId(bossId) ?? ArenaCatalog.opponents.first;
    return ArenaOpponent(
      id: base.id,
      recommendedLevel: recommendedLevel,
      maxHp: math.max(15, (base.maxHp * statScale).round()),
      attack: math.max(3, (base.attack * statScale).round()),
      defense: math.max(0, (base.defense * statScale).round()),
      initiative: base.initiative,
      dodgeChance: base.dodgeChance,
      reward: reward,
    );
  }
}

/// Built-in catalog of Forge Dungeons (Stage 5D).
abstract final class DungeonCatalog {
  static const List<DungeonDefinition> dungeons = [
    DungeonDefinition(
      id: 'dungeon_sunken_crypt',
      recommendedLevel: 3,
      statScale: 0.90,
      rooms: [
        DungeonRoom(
          id: 'room_crypt_pendulum',
          attribute: Attribute.dexterity,
          difficultyClass: 11,
        ),
        DungeonRoom(
          id: 'room_crypt_altar',
          attribute: Attribute.wisdom,
          difficultyClass: 11,
        ),
        DungeonRoom(
          id: 'room_crypt_gate',
          attribute: Attribute.strength,
          difficultyClass: 11,
        ),
      ],
      bossId: 'npc_iron_sentinel',
      reward: CombatReward(
        titleId: 'title_crypt_delver',
        cosmeticId: 'cosmetic_crypt_lantern',
      ),
    ),
    DungeonDefinition(
      id: 'dungeon_arcane_sanctum',
      recommendedLevel: 8,
      statScale: 1.05,
      rooms: [
        DungeonRoom(
          id: 'room_sanctum_runes',
          attribute: Attribute.intelligence,
          difficultyClass: 13,
        ),
        DungeonRoom(
          id: 'room_sanctum_miasma',
          attribute: Attribute.constitution,
          difficultyClass: 13,
        ),
        DungeonRoom(
          id: 'room_sanctum_oath',
          attribute: Attribute.charisma,
          difficultyClass: 13,
        ),
      ],
      bossId: 'npc_hollow_archmage',
      reward: CombatReward(
        titleId: 'title_sanctum_breaker',
        cosmeticId: 'cosmetic_arcane_sigil',
      ),
    ),
    DungeonDefinition(
      id: 'dungeon_abyssal_forge',
      recommendedLevel: 14,
      statScale: 1.20,
      rooms: [
        DungeonRoom(
          id: 'room_abyss_chains',
          attribute: Attribute.strength,
          difficultyClass: 15,
        ),
        DungeonRoom(
          id: 'room_abyss_magma',
          attribute: Attribute.dexterity,
          difficultyClass: 15,
        ),
        DungeonRoom(
          id: 'room_abyss_eye',
          attribute: Attribute.wisdom,
          difficultyClass: 15,
        ),
      ],
      bossId: 'npc_forge_colossus',
      reward: CombatReward(
        titleId: 'title_abyss_conqueror',
        cosmeticId: 'cosmetic_abyssal_flame',
      ),
    ),
  ];

  static DungeonDefinition? byId(String id) {
    for (final d in dungeons) {
      if (d.id == id) return d;
    }
    return null;
  }
}

/// Active multi-room Dungeon expedition state.
final class DungeonRun {
  const DungeonRun({
    required this.dungeon,
    required this.hero,
    required this.roomIndex,
    required this.heroHp,
    required this.heroFocus,
    required this.blessingsEarned,
    required this.availableInspiration,
    this.lastRoomRoll,
    this.lastRoomBypassed = false,
    this.lastRoomDeltaHp = 0,
    this.roomResolved = false,
    this.bossEncounter,
  });

  final DungeonDefinition dungeon;
  final CombatStats hero;
  final int roomIndex;
  final int heroHp;
  final int heroFocus;
  final int blessingsEarned;
  final int availableInspiration;
  final D20RollResult? lastRoomRoll;
  final bool lastRoomBypassed;
  final int lastRoomDeltaHp;
  final bool roomResolved;
  final CombatEncounter? bossEncounter;

  bool get inBossPhase => bossEncounter != null;
  int get currentRoomNumber => roomIndex + 1;
  int get totalRooms => dungeon.rooms.length;
  DungeonRoom get currentRoom => dungeon.rooms[roomIndex];
  bool get isDungeonVictory =>
      bossEncounter != null && bossEncounter!.status == CombatStatus.victory;
  bool get isDungeonDefeat =>
      heroHp <= 0 ||
      (bossEncounter != null && bossEncounter!.status == CombatStatus.defeat);
}

/// Derived combat numbers of the hero from their real-world D&D attributes.
///
/// Every attribute has a clear role:
/// - **STR**: physical strike power and guard penetration.
/// - **DEX**: initiative, Armor Class (AC), dodge chance, and agile strike power.
/// - **CON**: maximum HP, Armor Class (AC), and physical defense.
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

  /// Classic D&D 5e proficiency bonus (`+2` at Lv 1–4 up to `+6` at Lv 17–20).
  int get proficiencyBonus => 2 + ((level - 1) ~/ 4);

  /// Classic D&D 5e Armor Class (`10 + mod(DEX) + mod(CON)/2`).
  int get armorClass {
    final dexMod = attackModifierFor(Attribute.dexterity);
    final conMod = attackModifierFor(Attribute.constitution);
    return (10 + dexMod + (conMod ~/ 2)).clamp(10, 25);
  }

  /// D&D 5e attribute modifier `floor((score - 10) / 2)` for [attribute].
  int attackModifierFor(Attribute attribute) =>
      Progression.calculateModifier(
        scores[attribute] ?? XpRules.baseAttributeScore,
      );

  /// Total D20 attack/check bonus (`attributeModifier + proficiencyBonus`).
  int attackBonusFor(Attribute attribute) =>
      proficiencyBonus + attackModifierFor(attribute);

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
    this.lastRoll,
    this.legendaryBoss,
    this.weaknessStacks = 0,
    this.legendaryBarrierTurns = 0,
    this.legendaryPlateStacks = 0,
    this.legendaryPhase = 1,
    this.heroBleedStacks = 0,
    this.lastHeroAction,
    this.repeatedHeroActionCount = 0,
    this.legendaryExposedTurns = 0,
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

  /// Latest `1d20 + attribute` roll performed by the hero in this encounter.
  final D20RollResult? lastRoll;

  /// Optional Weekly Legendary Boss metadata driving unique D&D mechanics.
  final LegendaryBossSpec? legendaryBoss;

  /// Real-world weekly habit seals (`0..7`) weakening this Legendary Boss.
  final int weaknessStacks;
  final int legendaryBarrierTurns;
  final int legendaryPlateStacks;
  final int legendaryPhase;
  final int heroBleedStacks;
  final CombatAction? lastHeroAction;
  final int repeatedHeroActionCount;
  final int legendaryExposedTurns;

  bool get isLegendary => legendaryBoss != null;

  /// Dynamic Armor Class factoring active Legendary barriers, plates,
  /// tactical adaptation, and post-surge / all-out vow vulnerabilities.
  int get effectiveArmorClass {
    var ac = opponent.armorClass;
    if (legendaryBarrierTurns > 0) ac += 4;
    if (legendaryPlateStacks > 0) ac += math.min(4, legendaryPlateStacks);
    if (legendaryBoss?.hasMechanic(LegendaryMechanicKind.tacticalAdaptation) ==
            true &&
        repeatedHeroActionCount >= 2) {
      ac += 3;
    }
    if (legendaryExposedTurns > 0) ac -= 3;
    if (legendaryBoss?.hasMechanic(LegendaryMechanicKind.telegraphedTriad) ==
            true &&
        enemyHp <= (opponent.maxHp * 0.35).round()) {
      ac -= 3;
    }
    return ac.clamp(8, 28);
  }

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

/// Pure-Dart turn-based combat and dungeon engine.
abstract final class CombatEngine {
  /// Rolls a uniform 20-sided die (`1..20`).
  ///
  /// Maps `0 -> 20` and `1..19 -> 1..19` so every face has exact `1/20`
  /// probability under `math.Random` while `nextInt(20) == 19` in deterministic
  /// test stubs yields `19` (a strong non-critical hit).
  static int rollD20([math.Random? random]) {
    final rng = random ?? math.Random();
    final raw = rng.nextInt(20);
    return raw == 0 ? 20 : raw;
  }

  /// Evaluates a D&D 5e `1d20 + attributeModifier + proficiencyBonus` roll
  /// against [targetNumber] (Armor Class or Difficulty Class).
  static D20RollResult resolveD20Check({
    required CombatStats hero,
    required Attribute attribute,
    required int targetNumber,
    required int naturalRoll,
    bool forceCritical = false,
  }) {
    final clamped = naturalRoll.clamp(1, 20);
    final mod = hero.attackModifierFor(attribute);
    final prof = hero.proficiencyBonus;
    final total = clamped + mod + prof;

    final D20Outcome outcome;
    if (clamped == 20 || (forceCritical && clamped > 1)) {
      outcome = D20Outcome.criticalHit;
    } else if (clamped == 1) {
      outcome = D20Outcome.criticalFumble;
    } else if (total >= targetNumber) {
      outcome = D20Outcome.hit;
    } else {
      outcome = D20Outcome.miss;
    }

    return D20RollResult(
      naturalRoll: clamped,
      attribute: attribute,
      attributeModifier: mod,
      proficiencyBonus: prof,
      targetNumber: targetNumber,
      outcome: outcome,
    );
  }

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

  /// Starts a Weekly Legendary Boss battle with unique D&D mechanics and
  /// real-world weekly habit seals ([weaknessStacks], `0..7`).
  static CombatEncounter startLegendary({
    required CombatStats hero,
    required LegendaryBossSpec boss,
    int weaknessStacks = 0,
    int availableInspiration = 0,
  }) {
    final safeSeals = weaknessStacks.clamp(0, 7);
    final opponent = boss.instantiate(
      heroLevel: hero.level,
      weaknessStacks: safeSeals,
    );
    final initialBarrier = boss.hasMechanic(LegendaryMechanicKind.infinityBarrier)
        ? math.max(0, 3 - (safeSeals ~/ 2))
        : 0;
    final initialPlates = boss.hasMechanic(LegendaryMechanicKind.armorPlates)
        ? math.max(1, 4 - (safeSeals ~/ 2))
        : 0;

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
      legendaryBoss: boss,
      weaknessStacks: safeSeals,
      legendaryBarrierTurns: initialBarrier,
      legendaryPlateStacks: initialPlates,
      legendaryPhase: 1,
    );
  }

  /// Resolves one full round (hero action followed by opponent response).
  ///
  /// Offensive actions (`basicStrike`, `classSkill`) roll `1d20 + Attribute + Proficiency`
  /// against `opponent.armorClass`:
  /// - **Natural 20** (`D20Outcome.criticalHit`): automatic hit and `2.0x` damage.
  /// - **Natural 1** (`D20Outcome.criticalFumble`): automatic miss and the hero
  ///   suffers self-opening recoil damage (`6%` of max HP).
  /// - **Hit (`total >= AC`)**: damage scales with both attribute power and the
  ///   `d20 + attributeModifier` roll total.
  /// - **Miss (`total < AC`)**: 0 damage dealt.
  static CombatEncounter executeTurn(
    CombatEncounter state,
    CombatAction action, {
    math.Random? random,
    int? forcedD20,
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
    D20RollResult? lastRoll = state.lastRoll;

    final boss = state.legendaryBoss;
    bool hasMech(LegendaryMechanicKind kind) => boss?.hasMechanic(kind) ?? false;

    var barrierTurns = state.legendaryBarrierTurns;
    var plateStacks = state.legendaryPlateStacks;
    var bossPhase = state.legendaryPhase;
    var heroBleed = state.heroBleedStacks;
    var exposedTurns = state.legendaryExposedTurns;
    final repeatedActionCount = state.lastHeroAction == action
        ? state.repeatedHeroActionCount + 1
        : 1;

    final heroBuffMultiplier = heroBuff > 0 ? 1.25 : 1.0;
    final enemyGuardReduction =
        state.enemyIntent == EnemyIntent.guard ? 0.65 : 1.0;
    final targetAc = state.effectiveArmorClass;

    final plateMitigation = plateStacks > 0 ? 0.70 : 1.0;
    final adaptedMitigation =
        hasMech(LegendaryMechanicKind.tacticalAdaptation) &&
                repeatedActionCount >= 2 &&
                action != CombatAction.heroicInspiration
            ? 0.65
            : 1.0;
    final barrierMitigation =
        barrierTurns > 0 && action != CombatAction.heroicInspiration
            ? 0.75
            : 1.0;

    int computeD20Damage({
      required D20RollResult roll,
      required double multiplier,
      required bool ignoresDefense,
    }) {
      // Higher (d20 + attributeModifier) increases strike precision and damage.
      final rollPrecisionScale = 0.85 +
          ((roll.naturalRoll + math.max(0, roll.attributeModifier)) / 20.0) *
              0.45;
      final raw = state.hero.attackPowerFor(roll.attribute) *
          multiplier *
          rollPrecisionScale *
          heroBuffMultiplier *
          enemyGuardReduction *
          plateMitigation *
          adaptedMitigation *
          barrierMitigation;
      final critBoosted =
          roll.isCriticalHit ? raw * XpRules.combatCriticalMultiplier : raw;
      final mitigation = ignoresDefense ? 0 : state.opponent.defense;
      return math.max(1, (critBoosted - mitigation).round());
    }

    // --- 1. Hero Action ---
    var heroBasicHitLanded = false;
    switch (action) {
      case CombatAction.basicStrike:
        heroFocus = math.min(state.hero.maxFocus, heroFocus + 3);
        final nat = forcedD20 ?? rollD20(rng);
        final roll = resolveD20Check(
          hero: state.hero,
          attribute: state.hero.primaryAttackAttribute,
          targetNumber: targetAc,
          naturalRoll: nat,
        );
        lastRoll = roll;

        if (roll.isCriticalFumble) {
          final fumbleSelfDmg = math.max(
            2,
            (state.hero.maxHp * XpRules.combatFumbleSelfDamageFraction).round(),
          );
          heroHp = math.max(0, heroHp - fumbleSelfDmg);
          log.add(
            CombatLogEntry(
              turn: state.turn,
              kind: CombatLogKind.heroCriticalFumble,
              damage: fumbleSelfDmg,
              roll: roll,
            ),
          );
        } else if (!roll.isHit) {
          log.add(
            CombatLogEntry(
              turn: state.turn,
              kind: CombatLogKind.enemyDodged,
              roll: roll,
            ),
          );
        } else {
          heroBasicHitLanded = !roll.isCriticalHit;
          final dmg = computeD20Damage(
            roll: roll,
            multiplier: 1.0,
            ignoresDefense: false,
          );
          enemyHp = math.max(0, enemyHp - dmg);
          log.add(
            CombatLogEntry(
              turn: state.turn,
              kind: CombatLogKind.heroBasicStrike,
              damage: dmg,
              isCritical: roll.isCriticalHit,
              roll: roll,
            ),
          );
          if (roll.isCriticalHit && plateStacks > 0) {
            plateStacks--;
            log.add(CombatLogEntry(
              turn: state.turn,
              kind: CombatLogKind.legendaryPlateBroken,
            ));
          }
          if (roll.isCriticalHit && barrierTurns > 0) {
            barrierTurns = 0;
            log.add(CombatLogEntry(
              turn: state.turn,
              kind: CombatLogKind.legendaryBarrierPierced,
            ));
          }
        }

      case CombatAction.classSkill:
        if (!state.canUseClassSkill) {
          return executeTurn(
            state,
            CombatAction.basicStrike,
            random: rng,
            forcedD20: forcedD20,
          );
        }
        heroFocus -= skill.focusCost;
        cooldown = skill.cooldownTurns;
        final scaleAttr =
            skill.scalesWith ?? state.hero.primaryAttackAttribute;
        final forceCrit = skill.guaranteedCritWhenBuffedOrWeaken &&
            (heroBuff > 0 || enemyWeaken > 0);
        final nat = forcedD20 ?? rollD20(rng);
        final roll = resolveD20Check(
          hero: state.hero,
          attribute: scaleAttr,
          targetNumber: targetAc,
          naturalRoll: nat,
          forceCritical: forceCrit,
        );
        lastRoll = roll;

        if (roll.isCriticalFumble) {
          final fumbleSelfDmg = math.max(
            2,
            (state.hero.maxHp * XpRules.combatFumbleSelfDamageFraction).round(),
          );
          heroHp = math.max(0, heroHp - fumbleSelfDmg);
          log.add(
            CombatLogEntry(
              turn: state.turn,
              kind: CombatLogKind.heroCriticalFumble,
              damage: fumbleSelfDmg,
              skillId: skill.id,
              roll: roll,
            ),
          );
        } else if (!roll.isHit) {
          log.add(
            CombatLogEntry(
              turn: state.turn,
              kind: CombatLogKind.enemyDodged,
              skillId: skill.id,
              roll: roll,
            ),
          );
        } else {
          final hits = skill.hitsTwice ? 2 : 1;
          var totalDmg = 0;
          for (var i = 0; i < hits; i++) {
            totalDmg += computeD20Damage(
              roll: roll,
              multiplier: skill.damageMultiplier,
              ignoresDefense: skill.ignoresDefense,
            );
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
              isCritical: roll.isCriticalHit,
              skillId: skill.id,
              roll: roll,
            ),
          );
          if (plateStacks > 0) {
            plateStacks = math.max(0, plateStacks - (roll.isCriticalHit ? 2 : 1));
            log.add(CombatLogEntry(
              turn: state.turn,
              kind: CombatLogKind.legendaryPlateBroken,
            ));
          }
          if (barrierTurns > 0) {
            barrierTurns = roll.isCriticalHit ? 0 : math.max(0, barrierTurns - 1);
            if (barrierTurns == 0) {
              log.add(CombatLogEntry(
                turn: state.turn,
                kind: CombatLogKind.legendaryBarrierPierced,
              ));
            }
          }
        }

      case CombatAction.defend:
        defending = true;
        lastRoll = null;
        heroFocus = math.min(state.hero.maxFocus, heroFocus + 8);
        final heal = state.hero.healBonus;
        heroHp = math.min(state.hero.maxHp, heroHp + heal);
        if (heroBleed > 0) {
          heroBleed = math.max(0, heroBleed - 2);
        }
        log.add(
          CombatLogEntry(
            turn: state.turn,
            kind: CombatLogKind.heroDefend,
            heal: heal,
          ),
        );

      case CombatAction.heroicInspiration:
        if (!state.canUseInspiration) {
          return executeTurn(
            state,
            CombatAction.basicStrike,
            random: rng,
            forcedD20: forcedD20,
          );
        }
        inspirationUsed = true;
        availableInsp = math.max(0, availableInsp - 1);
        heroFocus = math.min(state.hero.maxFocus, heroFocus + 6);
        final roll = resolveD20Check(
          hero: state.hero,
          attribute: state.hero.primaryAttackAttribute,
          targetNumber: targetAc,
          naturalRoll: 20,
          forceCritical: true,
        );
        lastRoll = roll;
        final dmg = computeD20Damage(
          roll: roll,
          multiplier: 1.65,
          ignoresDefense: true,
        );
        enemyHp = math.max(0, enemyHp - dmg);
        if (plateStacks > 0) {
          plateStacks = math.max(0, plateStacks - 2);
          log.add(CombatLogEntry(
            turn: state.turn,
            kind: CombatLogKind.legendaryPlateBroken,
          ));
        }
        if (barrierTurns > 0) {
          barrierTurns = 0;
          log.add(CombatLogEntry(
            turn: state.turn,
            kind: CombatLogKind.legendaryBarrierPierced,
          ));
        }
        log.add(
          CombatLogEntry(
            turn: state.turn,
            kind: CombatLogKind.heroInspirationStrike,
            damage: dmg,
            isCritical: true,
            roll: roll,
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
        lastRoll: lastRoll,
        legendaryBoss: boss,
        weaknessStacks: state.weaknessStacks,
        legendaryBarrierTurns: barrierTurns,
        legendaryPlateStacks: plateStacks,
        legendaryPhase: bossPhase,
        heroBleedStacks: heroBleed,
        lastHeroAction: action,
        repeatedHeroActionCount: repeatedActionCount,
        legendaryExposedTurns: exposedTurns,
      );
    }

    // --- 1b. Legendary Boss Phase Awakening & Counter Stance ------------------
    if (heroHp > 0 &&
        !enemyStunned &&
        heroBasicHitLanded &&
        hasMech(LegendaryMechanicKind.counterStance)) {
      final counterDmg = math.max(
        1,
        (state.opponent.attack * 0.40 - state.hero.defense * 0.5).round(),
      );
      heroHp = math.max(0, heroHp - counterDmg);
      log.add(
        CombatLogEntry(
          turn: state.turn,
          kind: CombatLogKind.legendaryCounter,
          damage: counterDmg,
        ),
      );
    }

    if (heroHp > 0 && hasMech(LegendaryMechanicKind.multiPhaseAwakening)) {
      final hpPct = enemyHp / state.opponent.maxHp;
      final nextPhase = hpPct <= 0.30 ? 3 : (hpPct <= 0.65 ? 2 : 1);
      if (nextPhase > bossPhase) {
        bossPhase = nextPhase;
        final phaseHeal = math.max(3, (state.opponent.maxHp * 0.08).round());
        enemyHp = math.min(state.opponent.maxHp, enemyHp + phaseHeal);
        log.add(
          CombatLogEntry(
            turn: state.turn,
            kind: CombatLogKind.legendaryPhaseShift,
            heal: phaseHeal,
          ),
        );
      }
    }

    // --- 2. Opponent Turn (only if hero didn't already fall to 0 HP) ---
    if (heroHp > 0) {
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
        final phaseAtkBonus = 1.0 + (bossPhase - 1) * 0.14;
        final triadFuryBonus = hasMech(LegendaryMechanicKind.telegraphedTriad) &&
                enemyHp <= (state.opponent.maxHp * 0.35).round()
            ? 1.40
            : 1.0;
        final isSurging = hasMech(LegendaryMechanicKind.powerStealOrSurge) &&
            state.turn % 3 == 0;
        final surgeMult = isSurging ? 1.35 : 1.0;

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

          final rawEnemy = state.opponent.attack *
              intentMult *
              weakenMult *
              phaseAtkBonus *
              triadFuryBonus *
              surgeMult;
          final afterDef = math.max(1.0, rawEnemy - state.hero.defense);
          final dmg = math.max(
            1,
            (afterDef * buffMitigation * defendMitigation).round(),
          );
          heroHp = math.max(0, heroHp - dmg);
          log.add(
            CombatLogEntry(
              turn: state.turn,
              kind: isSurging
                  ? CombatLogKind.legendarySurge
                  : (state.enemyIntent == EnemyIntent.heavyBlow
                      ? CombatLogKind.enemyHeavyBlow
                      : CombatLogKind.enemyStrike),
              damage: dmg,
            ),
          );

          if (hasMech(LegendaryMechanicKind.bleedSanctuary) && heroHp > 0) {
            heroBleed = math.min(4, heroBleed + (defending ? 0 : 1));
          }
          if (hasMech(LegendaryMechanicKind.focusDrainAndBurn) &&
              heroHp > 0 &&
              heroFocus > 0) {
            final drain = defending ? 1 : 4;
            heroFocus = math.max(0, heroFocus - drain);
            log.add(
              CombatLogEntry(
                turn: state.turn,
                kind: CombatLogKind.legendaryFocusDrain,
                damage: drain,
              ),
            );
          }
        }

        if (isSurging) {
          exposedTurns = 2; // decrements to 1 at end of this round
        }
      }

      // Bleed / Sanctuary tick at end of round.
      if (heroHp > 0 && heroBleed > 0) {
        final sanctuaryActive = hasMech(LegendaryMechanicKind.bleedSanctuary) &&
            enemyHp <= (state.opponent.maxHp * 0.50).round();
        final tickDmg =
            (heroBleed * 3 + (sanctuaryActive ? 4 : 0)) ~/ (defending ? 2 : 1);
        if (tickDmg > 0) {
          heroHp = math.max(0, heroHp - tickDmg);
          log.add(
            CombatLogEntry(
              turn: state.turn,
              kind: CombatLogKind.legendaryBleedTick,
              damage: tickDmg,
            ),
          );
        }
      }
    }

    // Tick down active buffs/debuffs at end of round.
    if (heroBuff > 0) heroBuff--;
    if (enemyWeaken > 0) enemyWeaken--;
    if (barrierTurns > 0) barrierTurns--;
    if (exposedTurns > 0) exposedTurns--;

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
      lastRoll: lastRoll,
      legendaryBoss: boss,
      weaknessStacks: state.weaknessStacks,
      legendaryBarrierTurns: barrierTurns,
      legendaryPlateStacks: plateStacks,
      legendaryPhase: bossPhase,
      heroBleedStacks: heroBleed,
      lastHeroAction: action,
      repeatedHeroActionCount: repeatedActionCount,
      legendaryExposedTurns: exposedTurns,
    );
  }

  /// Starts a multi-round [tournament] run at round 1.
  static TournamentRun startTournament({
    required CombatStats hero,
    required TournamentDefinition tournament,
    int availableInspiration = 0,
  }) {
    final rounds = tournament.scaledOpponents;
    return TournamentRun(
      tournament: tournament,
      rounds: rounds,
      roundIndex: 0,
      encounter: start(
        hero: hero,
        opponent: rounds.first,
        availableInspiration: availableInspiration,
      ),
    );
  }

  /// Advances a [TournamentRun] to the next opponent after a round victory,
  /// restoring a portion of the hero's HP and Focus.
  static TournamentRun advanceTournamentRound(TournamentRun run) {
    if (!run.isRoundVictory) return run;
    final nextIndex = run.roundIndex + 1;
    final nextOpponent = run.rounds[nextIndex];
    final prev = run.encounter;
    final hpGain =
        (prev.hero.maxHp * XpRules.tournamentBetweenRoundHpRecovery).round();
    final focusGain =
        (prev.hero.maxFocus * XpRules.tournamentBetweenRoundFocusRecovery)
            .round();

    final restoredHp = math.min<int>(prev.hero.maxHp, prev.heroHp + hpGain);
    final restoredFocus =
        math.min<int>(prev.hero.maxFocus, prev.heroFocus + focusGain);

    return TournamentRun(
      tournament: run.tournament,
      rounds: run.rounds,
      roundIndex: nextIndex,
      encounter: CombatEncounter(
        hero: prev.hero,
        opponent: nextOpponent,
        turn: 1,
        heroHp: restoredHp,
        heroFocus: restoredFocus,
        enemyHp: nextOpponent.maxHp,
        heroSkillCooldown: 0,
        heroBuffTurns: 0,
        heroDefending: false,
        enemyWeakenTurns: 0,
        enemyStunned: false,
        enemyIntent: EnemyIntent.strike,
        availableInspiration: prev.availableInspiration,
        inspirationUsed: prev.inspirationUsed,
        status: CombatStatus.ongoing,
        log: const [],
      ),
    );
  }

  /// Starts a new [dungeon] expedition at room 1.
  static DungeonRun startDungeon({
    required CombatStats hero,
    required DungeonDefinition dungeon,
    int availableInspiration = 0,
  }) {
    return DungeonRun(
      dungeon: dungeon,
      hero: hero,
      roomIndex: 0,
      heroHp: hero.maxHp,
      heroFocus: hero.maxFocus,
      blessingsEarned: 0,
      availableInspiration: math.max(0, availableInspiration),
    );
  }

  /// Resolves the current [DungeonRoom] attribute check using `1d20 + mod + proficiency`.
  static DungeonRun resolveDungeonRoom(
    DungeonRun run, {
    math.Random? random,
    int? forcedD20,
  }) {
    if (run.inBossPhase || run.roomResolved) return run;
    final room = run.currentRoom;
    final nat = forcedD20 ?? rollD20(random);
    final roll = resolveD20Check(
      hero: run.hero,
      attribute: room.attribute,
      targetNumber: room.difficultyClass,
      naturalRoll: nat,
    );

    if (roll.isHit) {
      final mult = roll.isCriticalHit ? 1.5 : 1.0;
      final hpGain =
          (run.hero.maxHp * XpRules.dungeonCheckBlessingHpRecovery * mult)
              .round();
      final focusGain =
          (run.hero.maxFocus * XpRules.dungeonCheckBlessingFocusRecovery * mult)
              .round();
      final nextHp = math.min<int>(run.hero.maxHp, run.heroHp + hpGain);
      final nextFocus =
          math.min<int>(run.hero.maxFocus, run.heroFocus + focusGain);
      return DungeonRun(
        dungeon: run.dungeon,
        hero: run.hero,
        roomIndex: run.roomIndex,
        heroHp: nextHp,
        heroFocus: nextFocus,
        blessingsEarned: run.blessingsEarned + (roll.isCriticalHit ? 2 : 1),
        availableInspiration: run.availableInspiration,
        lastRoomRoll: roll,
        lastRoomBypassed: false,
        lastRoomDeltaHp: nextHp - run.heroHp,
        roomResolved: true,
      );
    } else {
      final mult = roll.isCriticalFumble ? 1.6 : 1.0;
      final trapDmg = math.max(
        2,
        (run.hero.maxHp * XpRules.dungeonCheckTrapDamageFraction * mult)
            .round(),
      );
      // Leave at least 1 HP on normal trap failure, or allow 0 HP if already at 1 HP on fumble.
      final nextHp = roll.isCriticalFumble
          ? math.max<int>(1, run.heroHp - trapDmg)
          : math.max<int>(1, run.heroHp - trapDmg);
      return DungeonRun(
        dungeon: run.dungeon,
        hero: run.hero,
        roomIndex: run.roomIndex,
        heroHp: nextHp,
        heroFocus: run.heroFocus,
        blessingsEarned: run.blessingsEarned,
        availableInspiration: run.availableInspiration,
        lastRoomRoll: roll,
        lastRoomBypassed: false,
        lastRoomDeltaHp: nextHp - run.heroHp,
        roomResolved: true,
      );
    }
  }

  /// Cautiously bypasses the current [DungeonRoom] without rolling the d20,
  /// paying a small stamina toll (`-5% HP`, `-3 Focus`).
  static DungeonRun bypassDungeonRoom(DungeonRun run) {
    if (run.inBossPhase || run.roomResolved) return run;
    final toll = math.max(
      1,
      (run.hero.maxHp * XpRules.dungeonBypassHpFraction).round(),
    );
    final nextHp = math.max<int>(1, run.heroHp - toll);
    final nextFocus = math.max<int>(0, run.heroFocus - 3);
    return DungeonRun(
      dungeon: run.dungeon,
      hero: run.hero,
      roomIndex: run.roomIndex,
      heroHp: nextHp,
      heroFocus: nextFocus,
      blessingsEarned: run.blessingsEarned,
      availableInspiration: run.availableInspiration,
      lastRoomRoll: null,
      lastRoomBypassed: true,
      lastRoomDeltaHp: nextHp - run.heroHp,
      roomResolved: true,
    );
  }

  /// Advances the [DungeonRun] after a resolved room to either the next room
  /// or the final Boss chamber.
  static DungeonRun advanceDungeon(DungeonRun run) {
    if (!run.roomResolved || run.inBossPhase) return run;
    if (run.roomIndex + 1 < run.dungeon.rooms.length) {
      return DungeonRun(
        dungeon: run.dungeon,
        hero: run.hero,
        roomIndex: run.roomIndex + 1,
        heroHp: run.heroHp,
        heroFocus: run.heroFocus,
        blessingsEarned: run.blessingsEarned,
        availableInspiration: run.availableInspiration,
      );
    }

    // Enter Boss Chamber carrying current HP, Focus, and earned blessings as initial buff turns!
    final boss = run.dungeon.scaledBoss;
    return DungeonRun(
      dungeon: run.dungeon,
      hero: run.hero,
      roomIndex: run.roomIndex,
      heroHp: run.heroHp,
      heroFocus: run.heroFocus,
      blessingsEarned: run.blessingsEarned,
      availableInspiration: run.availableInspiration,
      roomResolved: true,
      bossEncounter: CombatEncounter(
        hero: run.hero,
        opponent: boss,
        turn: 1,
        heroHp: run.heroHp,
        heroFocus: run.heroFocus,
        enemyHp: boss.maxHp,
        heroSkillCooldown: 0,
        heroBuffTurns: run.blessingsEarned,
        heroDefending: false,
        enemyWeakenTurns: 0,
        enemyStunned: false,
        enemyIntent: EnemyIntent.strike,
        availableInspiration: run.availableInspiration,
        inspirationUsed: false,
        status: CombatStatus.ongoing,
        log: const [],
      ),
    );
  }
}
