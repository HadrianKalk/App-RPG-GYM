import 'package:drift/drift.dart';

import '../../core/game/activity_catalog.dart';
import '../../core/game/attributes.dart';
import '../../core/game/progress_diff.dart';
import '../../core/game/quest_progress.dart';
import '../../core/game/xp_calculator.dart';
import '../../core/game/xp_event.dart';
import '../database.dart';
import 'character_repository.dart';
import 'quest_repository.dart';

/// Summary of rewards granted by an activity or health habit.
final class ActivityRewardResult {
  const ActivityRewardResult({
    required this.attribute,
    required this.baseXp,
    required this.progress,
    this.bonusXp = 0.0,
    this.completedQuests = const [],
    this.activityId,
    this.customTitle,
    this.durationMinutes = 0,
    this.curveReduced = false,
  });

  final Attribute attribute;

  /// Direct XP from the activity / habit itself (after diminishing returns).
  final double baseXp;

  /// Additional milestone bonus XP (e.g. hitting the daily water goal).
  final double bonusXp;

  /// Daily quests completed by this action.
  final List<DailyQuestsTableData> completedQuests;

  /// Level / attribute increases caused by this action.
  final ProgressDiff progress;

  /// Built-in catalog identifier (`act_*`), if applicable.
  final String? activityId;

  /// User-typed title or subject, if applicable.
  final String? customTitle;

  /// Logged duration in minutes, if applicable.
  final int durationMinutes;

  /// True when the per-attribute daily curve scaled down the base effort XP.
  final bool curveReduced;

  double get questXp =>
      completedQuests.fold(0.0, (sum, quest) => sum + quest.bonusXp);

  double get totalXp => baseXp + bonusXp + questXp;
}

/// Manages real-life activities (catalog & custom) and Constitution health
/// habits (sleep, hydration and daily nutrition check-in).
class ActivityRepository {
  ActivityRepository(this._db, this._characterRepo, this._questRepo);

  final AppDatabase _db;
  final CharacterRepository _characterRepo;
  final QuestRepository _questRepo;

  int _nonce = 0;

  String _nextId(String prefix, DateTime now) =>
      '${prefix}_${now.millisecondsSinceEpoch}_${++_nonce}';

  String _todayDateStr([DateTime? now]) {
    final d = now ?? DateTime.now();
    return '${d.year}-${d.month}-${d.day}';
  }

  /// Watches today's Constitution health state (water cups, diet check-in, sleep).
  Stream<DailyHealthRow?> watchTodayHealth() {
    final today = _todayDateStr();
    final query = _db.select(_db.dailyHealthLogs)
      ..where((t) => t.dateStr.equals(today));
    return query.watchSingleOrNull();
  }

  /// Fetches today's health row, or `null` if nothing has been logged today.
  Future<DailyHealthRow?> getTodayHealth() {
    final today = _todayDateStr();
    return (_db.select(_db.dailyHealthLogs)
          ..where((t) => t.dateStr.equals(today)))
        .getSingleOrNull();
  }

  /// Logs a built-in catalog activity by its [activityId].
  Future<ActivityRewardResult> completeCatalogActivity({
    required String activityId,
    required int durationMinutes,
    double intensity = 1.0,
    String? subject,
  }) async {
    final definition = ActivityCatalog.byId(activityId);
    if (definition == null) {
      throw ArgumentError.value(activityId, 'activityId', 'Unknown catalog activity');
    }
    final safeMinutes = HealthRules.clampActivityMinutes(durationMinutes);
    final cleanSubject = subject?.trim();
    final label = (cleanSubject != null && cleanSubject.isNotEmpty)
        ? '${definition.id}: $cleanSubject'
        : definition.id;

    return _logActivityWithSummary(
      type: label,
      attribute: definition.attribute,
      durationMinutes: safeMinutes.toDouble(),
      intensity: intensity,
      source: definition.xpSource,
      description: cleanSubject,
      activityId: definition.id,
      customTitle: (cleanSubject != null && cleanSubject.isNotEmpty) ? cleanSubject : null,
      displayMinutes: safeMinutes,
    );
  }

  /// Logs a custom user-defined activity for any [attribute].
  Future<ActivityRewardResult> completeCustomActivity({
    required String title,
    required Attribute attribute,
    required int durationMinutes,
    double intensity = 1.0,
    String? notes,
  }) async {
    final safeMinutes = HealthRules.clampActivityMinutes(durationMinutes);
    final cleanTitle = title.trim().isEmpty ? 'custom_activity' : title.trim();
    return _logActivityWithSummary(
      type: cleanTitle,
      attribute: attribute,
      durationMinutes: safeMinutes.toDouble(),
      intensity: intensity,
      source: XpSource.activity,
      description: notes?.trim(),
      customTitle: cleanTitle,
      displayMinutes: safeMinutes,
    );
  }

  /// Logs a night of sleep and updates today's health row, returning the full summary.
  Future<ActivityRewardResult> completeSleep({
    required double hoursSlept,
    String? notes,
  }) async {
    final baseMinutes = HealthRules.sleepBaseMinutes(hoursSlept);
    final today = _todayDateStr();
    final existing = await getTodayHealth();
    await _db.into(_db.dailyHealthLogs).insertOnConflictUpdate(
          DailyHealthLogsCompanion.insert(
            dateStr: today,
            waterCups: Value(existing?.waterCups ?? 0),
            rewardedWaterCups: Value(existing?.rewardedWaterCups ?? 0),
            waterGoalBonusClaimed: Value(existing?.waterGoalBonusClaimed ?? false),
            dietAdherence: Value(existing?.dietAdherence),
            lastSleepHours: Value(hoursSlept),
          ),
        );

    return _logActivityWithSummary(
      type: 'sleep:${hoursSlept.toStringAsFixed(1)}h',
      attribute: Attribute.constitution,
      durationMinutes: baseMinutes,
      intensity: 1.0,
      source: XpSource.sleep,
      description: notes ?? 'Restful sleep',
      customQuestCredit: QuestProgress.fromSleep(hoursSlept: hoursSlept),
    );
  }

  /// Applies [delta] (+1 or -1) to today's water cups and grants Constitution XP
  /// for newly reached cups and for hitting the daily [goalCups] milestone.
  ///
  /// Returns an [ActivityRewardResult] when new XP was earned, or `null` when
  /// decrementing / re-logging an already-rewarded cup.
  Future<ActivityRewardResult?> updateWaterCups({
    required int delta,
    required int goalCups,
  }) async {
    await _questRepo.ensureTodayQuests();
    final before = (await _characterRepo.watchCharacter().first).totalXpMap;
    final today = _todayDateStr();
    final existing = await getTodayHealth();

    final update = HealthRules.applyWaterDelta(
      currentCups: existing?.waterCups ?? 0,
      rewardedCups: existing?.rewardedWaterCups ?? 0,
      goalBonusClaimed: existing?.waterGoalBonusClaimed ?? false,
      goalCups: goalCups,
      delta: delta,
    );

    await _db.into(_db.dailyHealthLogs).insertOnConflictUpdate(
          DailyHealthLogsCompanion.insert(
            dateStr: today,
            waterCups: Value(update.cups),
            rewardedWaterCups: Value(update.rewardedCups),
            waterGoalBonusClaimed: Value(update.goalBonusClaimed),
            dietAdherence: Value(existing?.dietAdherence),
            lastSleepHours: Value(existing?.lastSleepHours),
          ),
        );

    if (update.totalXp <= 0) return null;

    final now = DateTime.now();
    final alreadyToday =
        await _characterRepo.getMinutesOrXpLoggedToday(Attribute.constitution);
    final cupCurve = XpCalculator.applyDailyCurve(
      alreadyLoggedToday: alreadyToday,
      rawEffortXp: update.cupXp,
    );

    if (cupCurve.earnedXp > 0) {
      await _characterRepo.addXp(
        XpEvent(
          id: _nextId('xp_water', now),
          attribute: Attribute.constitution,
          amount: cupCurve.earnedXp,
          source: XpSource.hydration,
          timestamp: now,
          description: 'hydration:cup:${update.cups}',
        ),
      );
    }

    if (update.goalBonusXp > 0) {
      await _characterRepo.addXp(
        XpEvent(
          id: _nextId('xp_water_goal', now),
          attribute: Attribute.constitution,
          amount: update.goalBonusXp,
          source: XpSource.hydration,
          timestamp: now,
          description: 'hydration:goal:$goalCups',
        ),
      );
    }

    final completedQuests = await _questRepo.applyCredit(update.questCredit);
    final after = (await _characterRepo.watchCharacter().first).totalXpMap;

    return ActivityRewardResult(
      attribute: Attribute.constitution,
      baseXp: cupCurve.earnedXp,
      bonusXp: update.goalBonusXp,
      completedQuests: completedQuests,
      progress: ProgressDiff.between(before, after),
      curveReduced: cupCurve.wasReduced,
    );
  }

  /// Records today's nutrition / diet adherence check-in (once per day).
  ///
  /// Returns `null` if today's check-in was already completed.
  Future<ActivityRewardResult?> completeDietCheckIn({
    required DietAdherence adherence,
  }) async {
    final existing = await getTodayHealth();
    if (existing?.dietAdherence != null) return null;

    await _questRepo.ensureTodayQuests();
    final before = (await _characterRepo.watchCharacter().first).totalXpMap;
    final today = _todayDateStr();

    await _db.into(_db.dailyHealthLogs).insertOnConflictUpdate(
          DailyHealthLogsCompanion.insert(
            dateStr: today,
            waterCups: Value(existing?.waterCups ?? 0),
            rewardedWaterCups: Value(existing?.rewardedWaterCups ?? 0),
            waterGoalBonusClaimed: Value(existing?.waterGoalBonusClaimed ?? false),
            dietAdherence: Value(adherence),
            lastSleepHours: Value(existing?.lastSleepHours),
          ),
        );

    final reward = HealthRules.dietReward(adherence);
    final alreadyLoggedToday =
        await _characterRepo.getMinutesOrXpLoggedToday(Attribute.constitution);
    final earnedXp = XpCalculator.calculateXpWithDiminishingReturns(
      minutesAlreadyLoggedToday: alreadyLoggedToday,
      additionalMinutes: reward.baseXp,
      intensityMultiplier: 1.0,
    );

    final now = DateTime.now();
    await _characterRepo.addXp(
      XpEvent(
        id: _nextId('xp_diet', now),
        attribute: Attribute.constitution,
        amount: earnedXp,
        source: XpSource.nutrition,
        timestamp: now,
        description: 'nutrition:${adherence.name}',
      ),
    );

    final completedQuests = await _questRepo.applyCredit(reward.questCredit);
    final after = (await _characterRepo.watchCharacter().first).totalXpMap;

    return ActivityRewardResult(
      attribute: Attribute.constitution,
      baseXp: earnedXp,
      completedQuests: completedQuests,
      progress: ProgressDiff.between(before, after),
      curveReduced: earnedXp + 0.01 < reward.baseXp,
    );
  }

  // --- Legacy / direct convenience methods returning earned XP ---

  /// Logs a focused study session (Pomodoro) granting Intelligence (INT) XP.
  Future<double> logPomodoroStudy({
    required int durationMinutes,
    double intensity = 1.0,
    String? subject,
  }) async {
    final result = await completeCatalogActivity(
      activityId: 'act_pomodoro',
      durationMinutes: durationMinutes,
      intensity: intensity,
      subject: subject,
    );
    return result.baseXp;
  }

  /// Logs a night of sleep granting Constitution (CON) XP.
  Future<double> logSleep({
    required double hoursSlept,
    String? notes,
  }) async {
    final result = await completeSleep(hoursSlept: hoursSlept, notes: notes);
    return result.baseXp;
  }

  /// Logs a meditation session granting Wisdom (WIS) XP.
  Future<double> logMeditation({
    required int durationMinutes,
    String? notes,
  }) async {
    final result = await completeCatalogActivity(
      activityId: 'act_meditation',
      durationMinutes: durationMinutes,
      subject: notes,
    );
    return result.baseXp;
  }

  /// Logs a general activity for [attribute].
  Future<double> logGeneralActivity({
    required String title,
    required Attribute attribute,
    required double durationMinutes,
    double intensity = 1.0,
    String? notes,
  }) async {
    final result = await completeCustomActivity(
      title: title,
      attribute: attribute,
      durationMinutes: durationMinutes.round(),
      intensity: intensity,
      notes: notes,
    );
    return result.baseXp;
  }

  Future<ActivityRewardResult> _logActivityWithSummary({
    required String type,
    required Attribute attribute,
    required double durationMinutes,
    required double intensity,
    required XpSource source,
    String? description,
    String? activityId,
    String? customTitle,
    int displayMinutes = 0,
    QuestCredit? customQuestCredit,
  }) async {
    await _questRepo.ensureTodayQuests();
    final before = (await _characterRepo.watchCharacter().first).totalXpMap;
    final now = DateTime.now();
    final alreadyLoggedToday =
        await _characterRepo.getMinutesOrXpLoggedToday(attribute);

    final earnedXp = XpCalculator.calculateXpWithDiminishingReturns(
      minutesAlreadyLoggedToday: alreadyLoggedToday,
      additionalMinutes: durationMinutes,
      intensityMultiplier: intensity,
    );

    final id = _nextId('act', now);

    await _db.into(_db.activities).insert(
          ActivitiesCompanion.insert(
            id: id,
            type: type,
            attribute: attribute,
            durationMinutes: durationMinutes,
            intensity: Value(intensity),
            timestamp: now,
            notes: Value(description),
          ),
        );

    await _characterRepo.addXp(
      XpEvent(
        id: 'xp_$id',
        attribute: attribute,
        amount: earnedXp,
        source: source,
        timestamp: now,
        description:
            '$type (${durationMinutes.toInt()} min) -> +${earnedXp.toStringAsFixed(1)} XP',
      ),
    );

    final credit = customQuestCredit ??
        QuestProgress.fromActivity(
          attribute: attribute,
          durationMinutes: durationMinutes,
        );
    final completedQuests = await _questRepo.applyCredit(credit);
    final after = (await _characterRepo.watchCharacter().first).totalXpMap;

    final rawEffortXp = durationMinutes * intensity;
    return ActivityRewardResult(
      attribute: attribute,
      baseXp: earnedXp,
      completedQuests: completedQuests,
      progress: ProgressDiff.between(before, after),
      activityId: activityId,
      customTitle: customTitle,
      durationMinutes: displayMinutes,
      curveReduced: earnedXp + 0.01 < rawEffortXp,
    );
  }
}
