import 'attributes.dart';
import 'quest_progress.dart';
import 'xp_event.dart';
import 'xp_rules.dart';

/// How an activity is tracked in the UI.
enum ActivityTracking {
  /// Countdown timer with start/pause/finish controls (e.g. Pomodoro).
  timer,

  /// Quick preset minute buttons (plus optional custom duration).
  duration,
}

/// Static definition of a built-in real-life activity that trains an attribute.
///
/// Visible titles and descriptions live in the localized game content under
/// `activity.<id>.name` and `activity.<id>.description`.
final class ActivityDefinition {
  const ActivityDefinition({
    required this.id,
    required this.attribute,
    required this.presetsMinutes,
    this.tracking = ActivityTracking.duration,
    this.xpSource = XpSource.activity,
  });

  /// Stable identifier (`act_*`).
  final String id;

  /// Attribute trained by this activity.
  final Attribute attribute;

  /// Tracking mode used by the UI.
  final ActivityTracking tracking;

  /// Quick duration presets in minutes offered on the card.
  final List<int> presetsMinutes;

  /// Ledger source tag recorded when the activity completes.
  final XpSource xpSource;
}

/// Single source of truth for the built-in activity catalog.
///
/// Covers non-lifting habits across Intelligence, Wisdom, Charisma, Dexterity
/// and Constitution so every attribute and daily quest can be progressed
/// through real-life actions.
abstract final class ActivityCatalog {
  static const List<ActivityDefinition> entries = [
    // --- Intelligence (INT) ---
    ActivityDefinition(
      id: 'act_pomodoro',
      attribute: Attribute.intelligence,
      tracking: ActivityTracking.timer,
      presetsMinutes: [25, 50],
      xpSource: XpSource.pomodoroStudy,
    ),
    ActivityDefinition(
      id: 'act_reading',
      attribute: Attribute.intelligence,
      presetsMinutes: [15, 30, 45],
    ),
    ActivityDefinition(
      id: 'act_writing',
      attribute: Attribute.intelligence,
      presetsMinutes: [20, 40, 60],
    ),

    // --- Wisdom (WIS / SAB) ---
    ActivityDefinition(
      id: 'act_meditation',
      attribute: Attribute.wisdom,
      presetsMinutes: [10, 20, 30],
    ),
    ActivityDefinition(
      id: 'act_journaling',
      attribute: Attribute.wisdom,
      presetsMinutes: [10, 15, 30],
    ),
    ActivityDefinition(
      id: 'act_breathwork',
      attribute: Attribute.wisdom,
      presetsMinutes: [5, 10, 15],
    ),

    // --- Charisma (CHA / CAR) ---
    ActivityDefinition(
      id: 'act_oratory',
      attribute: Attribute.charisma,
      presetsMinutes: [10, 20, 30],
    ),
    ActivityDefinition(
      id: 'act_social',
      attribute: Attribute.charisma,
      presetsMinutes: [15, 30, 45],
    ),
    ActivityDefinition(
      id: 'act_expression',
      attribute: Attribute.charisma,
      presetsMinutes: [15, 30, 45],
    ),

    // --- Dexterity (DEX / DES) ---
    ActivityDefinition(
      id: 'act_stretching',
      attribute: Attribute.dexterity,
      presetsMinutes: [10, 20, 30],
    ),
    ActivityDefinition(
      id: 'act_motor_skill',
      attribute: Attribute.dexterity,
      presetsMinutes: [15, 30, 45],
    ),

    // --- Constitution (CON) ---
    ActivityDefinition(
      id: 'act_outdoor_walk',
      attribute: Attribute.constitution,
      presetsMinutes: [15, 30, 45],
    ),
  ];

  /// Attributes represented in the quick-duration catalog filter.
  static const List<Attribute> catalogAttributes = [
    Attribute.charisma,
    Attribute.dexterity,
    Attribute.wisdom,
    Attribute.intelligence,
    Attribute.constitution,
  ];

  /// Finds an activity by its stable [id], or `null` if unknown.
  static ActivityDefinition? byId(String id) {
    for (final entry in entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  /// Returns all catalog activities for [attribute].
  static List<ActivityDefinition> forAttribute(Attribute attribute) =>
      entries.where((e) => e.attribute == attribute).toList(growable: false);

  /// Returns quick-duration catalog entries, optionally filtered by [attribute].
  static List<ActivityDefinition> durationActivities({Attribute? attribute}) =>
      entries
          .where((e) =>
              e.tracking == ActivityTracking.duration &&
              (attribute == null || e.attribute == attribute))
          .toList(growable: false);
}

/// Daily nutrition / diet adherence check-in option.
enum DietAdherence {
  /// Kept the planned meals / clean nutrition for the day.
  onTrack,

  /// Mostly balanced day with minor deviations.
  partial,
}

/// Pure result of updating the player's daily water intake.
final class WaterUpdateResult {
  const WaterUpdateResult({
    required this.cups,
    required this.rewardedCups,
    required this.goalBonusClaimed,
    required this.cupXp,
    required this.goalBonusXp,
    required this.questCredit,
  });

  /// Updated cup count for today.
  final int cups;

  /// High-water mark of cups already rewarded today (prevents -/+ farming).
  final int rewardedCups;

  /// Whether the daily goal bonus has been claimed today.
  final bool goalBonusClaimed;

  /// XP awarded for newly logged cups (up to the daily goal).
  final double cupXp;

  /// Bonus XP awarded when reaching the daily goal for the first time today.
  final double goalBonusXp;

  /// Quest credit earned (non-empty when the daily goal is reached).
  final QuestCredit questCredit;

  /// Total Constitution XP granted by this change.
  double get totalXp => cupXp + goalBonusXp;

  /// True when the daily goal was reached on this update.
  bool get justReachedGoal => goalBonusXp > 0;
}

/// Pure rules for Constitution health habits (sleep, hydration and diet).
abstract final class HealthRules {
  /// Clamps a water goal (in cups) to the allowed range.
  static int clampWaterGoal(int goalCups) =>
      goalCups.clamp(XpRules.waterGoalMinCups, XpRules.waterGoalMaxCups);

  /// Clamps a custom activity duration (in minutes) to the allowed range.
  static int clampActivityMinutes(int minutes) =>
      minutes.clamp(XpRules.activityMinMinutes, XpRules.activityMaxMinutes);

  /// Base Constitution XP equivalent (before diminishing returns) for a sleep log.
  static double sleepBaseMinutes(double hoursSlept) {
    if (hoursSlept >= XpRules.sleepIdealMinHours &&
        hoursSlept <= XpRules.sleepIdealMaxHours) {
      return XpRules.sleepIdealXp;
    }
    if (hoursSlept >= XpRules.sleepModerateMinHours) {
      return XpRules.sleepModerateXp;
    }
    return XpRules.sleepLowXp;
  }

  /// Applies a [delta] of water cups (e.g. +1 or -1) to today's hydration state.
  ///
  /// - [rewardedCups] tracks the highest cup count already rewarded today so
  ///   decrementing and re-adding a cup never duplicates XP in the append-only
  ///   ledger.
  /// - Cups beyond [goalCups] are still counted on the UI, but cup XP is capped
  ///   at [goalCups].
  /// - Reaching [goalCups] for the first time today awards
  ///   [XpRules.waterGoalBonusXp] and credits the Constitution daily quest.
  static WaterUpdateResult applyWaterDelta({
    required int currentCups,
    required int rewardedCups,
    required bool goalBonusClaimed,
    required int goalCups,
    required int delta,
  }) {
    final safeGoal = clampWaterGoal(goalCups);
    final nextCups = (currentCups + delta).clamp(0, XpRules.waterMaxDailyCups);

    // Only cups up to the daily goal grant per-cup XP, and only above the
    // previous high-water mark for today.
    final eligibleCups = nextCups.clamp(0, safeGoal);
    final previousRewarded = rewardedCups.clamp(0, safeGoal);
    final newlyRewarded =
        eligibleCups > previousRewarded ? eligibleCups - previousRewarded : 0;
    final nextRewarded =
        eligibleCups > rewardedCups ? eligibleCups : rewardedCups;

    final cupXp = newlyRewarded * XpRules.xpPerWaterCup;
    final hitGoalNow = !goalBonusClaimed && nextCups >= safeGoal;
    final goalBonusXp = hitGoalNow ? XpRules.waterGoalBonusXp : 0.0;
    final questCredit = hitGoalNow
        ? QuestProgress.fromActivity(
            attribute: Attribute.constitution,
            durationMinutes: XpRules.waterGoalQuestMinutes,
          )
        : const QuestCredit();

    return WaterUpdateResult(
      cups: nextCups,
      rewardedCups: nextRewarded,
      goalBonusClaimed: goalBonusClaimed || hitGoalNow,
      cupXp: cupXp,
      goalBonusXp: goalBonusXp,
      questCredit: questCredit,
    );
  }

  /// Base XP and quest credit for a daily nutrition check-in.
  static ({double baseXp, QuestCredit questCredit}) dietReward(
    DietAdherence adherence,
  ) {
    return switch (adherence) {
      DietAdherence.onTrack => (
          baseXp: XpRules.dietOnTrackXp,
          questCredit: QuestProgress.fromActivity(
            attribute: Attribute.constitution,
            durationMinutes: XpRules.dietOnTrackQuestMinutes,
          ),
        ),
      DietAdherence.partial => (
          baseXp: XpRules.dietPartialXp,
          questCredit: QuestProgress.fromActivity(
            attribute: Attribute.constitution,
            durationMinutes: XpRules.dietPartialQuestMinutes,
          ),
        ),
    };
  }
}
