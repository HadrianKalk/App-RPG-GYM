import 'dart:convert';
import 'dart:math' as math;

import 'attributes.dart';
import 'combat.dart';
import 'legendary_bosses.dart';

/// Product access tier controlling Story Mode turn quotas.
///
/// MVP keeps [unlimited] active by default while exposing a clean policy hook
/// for future Free vs. Pro tier limits.
enum StoryAccessTier { free, unlimited }

/// Evaluates whether the hero can advance another narrative turn today.
final class StoryQuotaPolicy {
  const StoryQuotaPolicy({
    this.tier = StoryAccessTier.unlimited,
    this.freeDailyTurnLimit = 10,
  });

  static const StoryQuotaPolicy mvpDefault = StoryQuotaPolicy();

  final StoryAccessTier tier;
  final int freeDailyTurnLimit;

  bool canAdvanceTurn(int turnsUsedToday) {
    if (tier == StoryAccessTier.unlimited) return true;
    return turnsUsedToday < freeDailyTurnLimit;
  }

  int? remainingTurnsToday(int turnsUsedToday) {
    if (tier == StoryAccessTier.unlimited) return null;
    return math.max(0, freeDailyTurnLimit - turnsUsedToday);
  }
}

/// Type of engine action requested by the Story Narrator on a scene turn.
enum StoryTriggerType {
  /// Pure exploration / dialogue; advances campaign memory without rolls.
  narrative,

  /// Requests a `1d20 + Attribute + Proficiency` check in the interactive D20 modal.
  skillCheck,

  /// Transitions the story directly into a live turn-based Combat encounter.
  combatTrigger,

  /// Concludes the current story beat and records a Chronicle entry.
  chapterComplete,
}

/// Standardized difficulty tiers translated into a D&D 5e DC by [StoryEngine].
enum StoryCheckDifficulty { easy, medium, hard, legendary }

/// Tier of opponent instantiated when a story scene triggers combat.
enum StoryCombatTier { normal, elite, legendary }

/// Action option proposed to the player during a story beat.
final class StoryChoiceOption {
  const StoryChoiceOption({
    required this.id,
    required this.label,
    required this.actionPrompt,
    required this.triggerType,
    this.attribute,
    this.difficulty,
    this.combatTier,
    this.opponentId,
  });

  final String id;
  final String label;
  final String actionPrompt;
  final StoryTriggerType triggerType;
  final Attribute? attribute;
  final StoryCheckDifficulty? difficulty;
  final StoryCombatTier? combatTier;
  final String? opponentId;
}

/// Engine-owned parameters for an interactive D20 check inside Story Mode.
final class StorySkillCheckSpec {
  const StorySkillCheckSpec({
    required this.attribute,
    required this.difficulty,
    required this.difficultyClass,
    required this.reason,
  });

  final Attribute attribute;
  final StoryCheckDifficulty difficulty;
  final int difficultyClass;
  final String reason;
}

/// Engine-owned parameters to launch a live 16-bit combat encounter from Story Mode.
final class StoryCombatSpec {
  const StoryCombatSpec({
    required this.tier,
    required this.opponentId,
    required this.weaknessStacks,
    required this.reason,
  });

  final StoryCombatTier tier;
  final String opponentId;
  final int weaknessStacks;
  final String reason;
}

/// Compact record of a recurring NPC encountered during the campaign.
final class StoryNpcMemory {
  const StoryNpcMemory({
    required this.id,
    required this.name,
    required this.attitude,
    required this.lastNote,
  });

  factory StoryNpcMemory.fromJson(Map<String, dynamic> json) => StoryNpcMemory(
        id: (json['id'] as String?) ?? '',
        name: (json['name'] as String?) ?? '',
        attitude: (json['attitude'] as String?) ?? 'neutral',
        lastNote: (json['lastNote'] as String?) ?? '',
      );

  final String id;
  final String name;

  /// `'ally' | 'neutral' | 'hostile'`
  final String attitude;
  final String lastNote;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'attitude': attitude,
        'lastNote': lastNote,
      };
}

/// Bounded long-term memory passed to the Narrator so token usage stays tiny.
final class CampaignMemory {
  const CampaignMemory({
    this.visitedPlaces = const [],
    this.npcs = const [],
    this.flags = const {},
    this.recentSummaries = const [],
  });

  factory CampaignMemory.fromJson(Map<String, dynamic> json) {
    final places = (json['visitedPlaces'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(growable: false);
    final npcsRaw = (json['npcs'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(StoryNpcMemory.fromJson)
        .toList(growable: false);
    final flagsRaw = (json['flags'] as Map<String, dynamic>? ?? const {})
        .map((k, v) => MapEntry(k, v.toString()));
    final summaries = (json['recentSummaries'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(growable: false);
    return CampaignMemory(
      visitedPlaces: places,
      npcs: npcsRaw,
      flags: flagsRaw,
      recentSummaries: summaries,
    );
  }

  static CampaignMemory decode(String raw) {
    if (raw.trim().isEmpty) return const CampaignMemory();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return CampaignMemory.fromJson(decoded);
      }
    } catch (_) {
      // Corrupt or legacy string returns clean empty memory instead of crashing.
    }
    return const CampaignMemory();
  }

  final List<String> visitedPlaces;
  final List<StoryNpcMemory> npcs;
  final Map<String, String> flags;
  final List<String> recentSummaries;

  String encode() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'visitedPlaces': visitedPlaces,
        'npcs': [for (final n in npcs) n.toJson()],
        'flags': flags,
        'recentSummaries': recentSummaries,
      };

  /// Appends new campaign events while keeping memory capped for compact AI prompts.
  CampaignMemory append({
    String? visitedPlace,
    StoryNpcMemory? npcUpdate,
    Map<String, String> flagUpdates = const {},
    String? summary,
  }) {
    final nextPlaces = List<String>.of(visitedPlaces);
    if (visitedPlace != null &&
        visitedPlace.trim().isNotEmpty &&
        !nextPlaces.contains(visitedPlace.trim())) {
      nextPlaces.add(visitedPlace.trim());
      if (nextPlaces.length > 8) nextPlaces.removeAt(0);
    }

    final nextNpcs = List<StoryNpcMemory>.of(npcs);
    if (npcUpdate != null && npcUpdate.id.isNotEmpty) {
      final idx = nextNpcs.indexWhere((n) => n.id == npcUpdate.id);
      if (idx >= 0) {
        nextNpcs[idx] = npcUpdate;
      } else {
        nextNpcs.add(npcUpdate);
        if (nextNpcs.length > 8) nextNpcs.removeAt(0);
      }
    }

    final nextFlags = Map<String, String>.of(flags)..addAll(flagUpdates);

    final nextSummaries = List<String>.of(recentSummaries);
    if (summary != null && summary.trim().isNotEmpty) {
      nextSummaries.add(summary.trim());
      if (nextSummaries.length > 6) nextSummaries.removeAt(0);
    }

    return CampaignMemory(
      visitedPlaces: nextPlaces,
      npcs: nextNpcs,
      flags: nextFlags,
      recentSummaries: nextSummaries,
    );
  }
}

/// Real-world effort digest fed into Story Mode so narrative and boss weakness
/// react authentically to workouts, health, and quests.
final class StoryHabitDigest {
  const StoryHabitDigest({
    this.workoutsToday = 0,
    this.workoutsThisWeek = 0,
    this.questsCompletedThisWeek = 0,
    this.healthHabitsThisWeek = 0,
    this.trainedAttributesToday = const [],
    this.prCountToday = 0,
    this.waterCupsToday = 0,
    this.lastSleepHours,
  });

  final int workoutsToday;
  final int workoutsThisWeek;
  final int questsCompletedThisWeek;
  final int healthHabitsThisWeek;
  final List<Attribute> trainedAttributesToday;
  final int prCountToday;
  final int waterCupsToday;
  final double? lastSleepHours;

  int get weeklyWeaknessStacks =>
      LegendaryBossCatalog.computeWeeklyWeaknessStacks(
        workoutsThisWeek: workoutsThisWeek,
        questsCompletedThisWeek: questsCompletedThisWeek,
        healthHabitsThisWeek: healthHabitsThisWeek,
      );
}

/// Active Weekly Story Arc linked to one of the 18 Legendary Bosses.
final class StoryArcState {
  const StoryArcState({
    required this.weekKey,
    required this.weeklyBossId,
    required this.weaknessStacks,
    this.chaptersCompleted = 0,
    this.bossDefeated = false,
    this.memory = const CampaignMemory(),
  });

  final String weekKey;
  final String weeklyBossId;
  final int weaknessStacks;
  final int chaptersCompleted;
  final bool bossDefeated;
  final CampaignMemory memory;

  LegendaryBossSpec get weeklyBoss =>
      LegendaryBossCatalog.byId(weeklyBossId) ??
      LegendaryBossCatalog.bosses.first;

  StoryArcState copyWith({
    int? weaknessStacks,
    int? chaptersCompleted,
    bool? bossDefeated,
    CampaignMemory? memory,
  }) {
    return StoryArcState(
      weekKey: weekKey,
      weeklyBossId: weeklyBossId,
      weaknessStacks: weaknessStacks ?? this.weaknessStacks,
      chaptersCompleted: chaptersCompleted ?? this.chaptersCompleted,
      bossDefeated: bossDefeated ?? this.bossDefeated,
      memory: memory ?? this.memory,
    );
  }
}

/// Pure-Dart Story Mode rules connecting real-world training, interactive D20
/// checks with Inspiration re-rolls, and live Combat encounters.
abstract final class StoryEngine {
  /// Returns an ISO-8601 week key (`YYYY-Www`) anchored on Monday.
  static String isoWeekKey(DateTime date) {
    final utc = DateTime.utc(date.year, date.month, date.day);
    // Thursday determines the ISO year.
    final thursday = utc.add(Duration(days: DateTime.thursday - utc.weekday));
    final firstJan = DateTime.utc(thursday.year, 1, 1);
    final weekNumber =
        ((thursday.difference(firstJan).inDays) / 7).floor() + 1;
    final w = weekNumber.toString().padLeft(2, '0');
    return '${thursday.year}-W$w';
  }

  /// Computes a balanced D&D 5e Difficulty Class for [heroLevel].
  static int computeDifficultyClass(
    int heroLevel,
    StoryCheckDifficulty difficulty,
  ) {
    final safeLevel = heroLevel.clamp(1, 20);
    final base = switch (difficulty) {
      StoryCheckDifficulty.easy => 10,
      StoryCheckDifficulty.medium => 12,
      StoryCheckDifficulty.hard => 15,
      StoryCheckDifficulty.legendary => 18,
    };
    return (base + (safeLevel ~/ 3)).clamp(9, 24);
  }

  /// Creates or updates the current Weekly Arc from [now] and [habits].
  static StoryArcState startOrResumeWeeklyArc({
    required DateTime now,
    required StoryHabitDigest habits,
    StoryArcState? existing,
  }) {
    final key = isoWeekKey(now);
    final seals = habits.weeklyWeaknessStacks;
    if (existing != null && existing.weekKey == key) {
      return existing.copyWith(weaknessStacks: seals);
    }

    final weeklyBoss = LegendaryBossCatalog.forWeek(now);
    return StoryArcState(
      weekKey: key,
      weeklyBossId: weeklyBoss.id,
      weaknessStacks: seals,
      chaptersCompleted: 0,
      bossDefeated: false,
      memory: existing?.memory ?? const CampaignMemory(),
    );
  }

  /// Resolves a Story Mode `1d20 + attributeModifier + proficiencyBonus` check.
  static D20RollResult resolveSkillCheck({
    required CombatStats hero,
    required Attribute attribute,
    required int difficultyClass,
    int? forcedD20,
    math.Random? random,
  }) {
    final nat = forcedD20 ?? CombatEngine.rollD20(random);
    return CombatEngine.resolveD20Check(
      hero: hero,
      attribute: attribute,
      targetNumber: difficultyClass,
      naturalRoll: nat,
    );
  }

  /// Spends 1 real-world Inspiration to re-roll a Story Mode D20 check.
  ///
  /// Returns `(roll, spentInspiration)`. If `availableInspiration <= 0`, does not
  /// consume Inspiration and returns `spentInspiration = false`.
  static ({D20RollResult roll, bool spentInspiration}) rerollWithInspiration({
    required CombatStats hero,
    required Attribute attribute,
    required int difficultyClass,
    required int availableInspiration,
    required D20RollResult previousRoll,
    int? forcedD20,
    math.Random? random,
  }) {
    if (availableInspiration <= 0) {
      return (roll: previousRoll, spentInspiration: false);
    }
    final next = resolveSkillCheck(
      hero: hero,
      attribute: attribute,
      difficultyClass: difficultyClass,
      forcedD20: forcedD20,
      random: random,
    );
    return (roll: next, spentInspiration: true);
  }

  /// Instantiates a live [CombatEncounter] triggered directly by a Story beat.
  ///
  /// Always enforces Decision #40 (**0 XP** from combat) and applies weekly
  /// habit [StoryCombatSpec.weaknessStacks] whenever facing a Legendary Boss.
  static CombatEncounter startStoryCombat({
    required CombatStats hero,
    required StoryCombatSpec spec,
    int availableInspiration = 0,
  }) {
    if (spec.tier == StoryCombatTier.legendary ||
        spec.opponentId.startsWith('boss_')) {
      final boss = LegendaryBossCatalog.byId(spec.opponentId) ??
          LegendaryBossCatalog.bosses.first;
      return CombatEngine.startLegendary(
        hero: hero,
        boss: boss,
        weaknessStacks: spec.weaknessStacks,
        availableInspiration: availableInspiration,
      );
    }

    final base = ArenaCatalog.byId(spec.opponentId) ??
        ArenaCatalog.opponents.first;
    final tierScale = spec.tier == StoryCombatTier.elite ? 1.15 : 0.90;
    final levelScale = (0.65 + hero.level * 0.06).clamp(0.7, 1.5);
    final scaled = ArenaOpponent(
      id: base.id,
      recommendedLevel: hero.level,
      maxHp: math.max(30, (base.maxHp * levelScale * tierScale).round()),
      attack: math.max(5, (base.attack * levelScale * tierScale).round()),
      defense: math.max(1, (base.defense * levelScale * tierScale).round()),
      initiative: base.initiative,
      dodgeChance: base.dodgeChance,
      reward: base.reward,
    );
    return CombatEngine.start(
      hero: hero,
      opponent: scaled,
      availableInspiration: availableInspiration,
    );
  }
}
