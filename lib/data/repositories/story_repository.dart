import 'package:drift/drift.dart';

import '../../core/game/attributes.dart';
import '../../core/game/story.dart';
import '../../core/game/xp_event.dart';
import '../database.dart';

/// Persists Weekly Story Arcs, Chronicle chapters, real-world habit digests,
/// and Inspiration re-roll spends.
class StoryRepository {
  StoryRepository(this._db);

  final AppDatabase _db;
  int _nonce = 0;

  String _nextId(String prefix, DateTime now) =>
      '${prefix}_${now.millisecondsSinceEpoch}_${++_nonce}';

  static DateTime _startOfIsoWeek(DateTime dt) {
    final dayStart = DateTime(dt.year, dt.month, dt.day);
    return dayStart.subtract(Duration(days: dt.weekday - DateTime.monday));
  }

  /// Watches the current Weekly Story Arc (recomputing weekly habit seals
  /// whenever workouts, quests, health logs, or story runs change).
  Stream<({StoryArcState arc, StoryHabitDigest habits})> watchWeeklyArc({
    DateTime? now,
  }) {
    final trigger = _db.customSelect(
      'SELECT 1',
      readsFrom: {
        _db.storyRuns,
        _db.workoutSessions,
        _db.workoutSets,
        _db.dailyQuestsTable,
        _db.dailyHealthLogs,
      },
    ).watch();

    return trigger.asyncMap((_) => getOrSyncWeeklyArc(now: now));
  }

  /// Watches Chronicle entries for [weekKey], newest first.
  Stream<List<StoryChapterRow>> watchChapters(String weekKey) {
    return (_db.select(_db.storyChapters)
          ..where((t) => t.weekKey.equals(weekKey))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Computes today's and this week's real-world habit digest and ensures the
  /// corresponding [StoryRuns] row exists and reflects updated weakness seals.
  Future<({StoryArcState arc, StoryHabitDigest habits})> getOrSyncWeeklyArc({
    DateTime? now,
  }) async {
    final current = now ?? DateTime.now();
    final habits = await getHabitDigest(now: current);
    final weekKey = StoryEngine.isoWeekKey(current);

    final row = await (_db.select(_db.storyRuns)
          ..where((t) => t.weekKey.equals(weekKey)))
        .getSingleOrNull();

    // Carry forward compact memory from the latest previous week if starting fresh.
    CampaignMemory? carryMemory;
    if (row == null) {
      final previous = await (_db.select(_db.storyRuns)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
            ..limit(1))
          .getSingleOrNull();
      if (previous != null) {
        carryMemory = CampaignMemory.decode(previous.memoryJson);
      }
    }

    final existingState = row == null
        ? (carryMemory == null
            ? null
            : StoryArcState(
                weekKey: 'prev',
                weeklyBossId: '',
                weaknessStacks: 0,
                memory: carryMemory,
              ))
        : StoryArcState(
            weekKey: row.weekKey,
            weeklyBossId: row.weeklyBossId,
            weaknessStacks: row.weaknessStacks,
            chaptersCompleted: row.chaptersCompleted,
            bossDefeated: row.bossDefeated,
            memory: CampaignMemory.decode(row.memoryJson),
          );

    final synced = StoryEngine.startOrResumeWeeklyArc(
      now: current,
      habits: habits,
      existing: existingState,
    );

    if (row == null || row.weaknessStacks != synced.weaknessStacks) {
      await _db.into(_db.storyRuns).insertOnConflictUpdate(
            StoryRunsCompanion.insert(
              weekKey: synced.weekKey,
              weeklyBossId: synced.weeklyBossId,
              weaknessStacks: Value(synced.weaknessStacks),
              chaptersCompleted: Value(synced.chaptersCompleted),
              bossDefeated: Value(synced.bossDefeated),
              memoryJson: Value(synced.memory.encode()),
              updatedAt: current,
            ),
          );
    }

    return (arc: synced, habits: habits);
  }

  /// Summarizes real-world training, quests, and health habits for Story Mode.
  Future<StoryHabitDigest> getHabitDigest({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final startOfDay = DateTime(current.year, current.month, current.day);
    final endOfDay =
        DateTime(current.year, current.month, current.day, 23, 59, 59);
    final startOfWeek = _startOfIsoWeek(current);
    final todayDateStr = '${current.year}-${current.month}-${current.day}';

    final weekWorkouts = await (_db.select(_db.workoutSessions)
          ..where((t) => t.completedAt.isNotNull())
          ..where(
            (t) => t.completedAt.isBetweenValues(startOfWeek, endOfDay),
          ))
        .get();

    final todayWorkoutDays = weekWorkouts
        .where((s) => !s.completedAt!.isBefore(startOfDay))
        .toList();

    final distinctTrainingDays = {
      for (final s in weekWorkouts)
        '${s.completedAt!.year}-${s.completedAt!.month}-${s.completedAt!.day}',
    }.length;

    // Collect distinct attributes trained in today's workouts/activities.
    final trainedAttrs = <Attribute>{};
    if (todayWorkoutDays.isNotEmpty) {
      final sessionIds = todayWorkoutDays.map((s) => s.id).toList();
      final setsToday = await (_db.select(_db.workoutSets)
            ..where((t) => t.sessionId.isIn(sessionIds))
            ..where((t) => t.isCompleted.equals(true)))
          .get();
      if (setsToday.isNotEmpty) {
        final exIds = setsToday.map((s) => s.exerciseId).toSet().toList();
        final exercises = await (_db.select(_db.exercises)
              ..where((t) => t.id.isIn(exIds)))
            .get();
        for (final ex in exercises) {
          trainedAttrs.add(ex.attribute);
        }
      }
    }

    final activitiesToday = await (_db.select(_db.activities)
          ..where((t) => t.timestamp.isBetweenValues(startOfDay, endOfDay)))
        .get();
    for (final a in activitiesToday) {
      trainedAttrs.add(a.attribute);
    }

    // Completed quests this ISO week.
    final weekDateKeys = [
      for (var i = 0; i < 7; i++)
        () {
          final d = startOfWeek.add(Duration(days: i));
          return '${d.year}-${d.month}-${d.day}';
        }(),
    ];
    final weekQuests = await (_db.select(_db.dailyQuestsTable)
          ..where((t) => t.dateStr.isIn(weekDateKeys))
          ..where((t) => t.isCompleted.equals(true)))
        .get();

    final weekHealth = await (_db.select(_db.dailyHealthLogs)
          ..where((t) => t.dateStr.isIn(weekDateKeys)))
        .get();
    final healthHabitsCount = weekHealth
        .where((h) => h.waterGoalBonusClaimed || h.dietAdherence != null)
        .length;
    final todayHealth = weekHealth
        .where((h) => h.dateStr == todayDateStr)
        .firstOrNull;

    return StoryHabitDigest(
      workoutsToday: todayWorkoutDays.length,
      workoutsThisWeek: distinctTrainingDays,
      questsCompletedThisWeek: weekQuests.length,
      healthHabitsThisWeek: healthHabitsCount,
      trainedAttributesToday: trainedAttrs.toList(growable: false),
      waterCupsToday: todayHealth?.waterCups ?? 0,
      lastSleepHours: todayHealth?.lastSleepHours,
    );
  }

  /// Appends a played Story scene to the Chronicle and updates campaign memory.
  Future<void> recordChapterBeat({
    required StoryArcState currentArc,
    required String locationName,
    required String playerAction,
    required String narration,
    required StoryTriggerType triggerType,
    String? outcomeSummary,
    String? placeVisited,
    StoryNpcMemory? npcUpdate,
    String? memorySummary,
    bool markBossDefeated = false,
    DateTime? now,
  }) async {
    final ts = now ?? DateTime.now();
    final updatedMemory = currentArc.memory.append(
      visitedPlace: placeVisited ?? locationName,
      npcUpdate: npcUpdate,
      summary: memorySummary ?? outcomeSummary,
    );
    final incrementChapter =
        triggerType == StoryTriggerType.chapterComplete ? 1 : 0;

    await _db.transaction(() async {
      await _db.into(_db.storyChapters).insert(
            StoryChaptersCompanion.insert(
              id: _nextId('chap', ts),
              weekKey: currentArc.weekKey,
              locationName: locationName,
              playerAction: playerAction,
              narration: narration,
              triggerType: triggerType.name,
              outcomeSummary: Value(outcomeSummary),
              createdAt: ts,
            ),
          );
      await _db.into(_db.storyRuns).insertOnConflictUpdate(
            StoryRunsCompanion.insert(
              weekKey: currentArc.weekKey,
              weeklyBossId: currentArc.weeklyBossId,
              weaknessStacks: Value(currentArc.weaknessStacks),
              chaptersCompleted:
                  Value(currentArc.chaptersCompleted + incrementChapter),
              bossDefeated: Value(currentArc.bossDefeated || markBossDefeated),
              memoryJson: Value(updatedMemory.encode()),
              updatedAt: ts,
            ),
          );
    });
  }

  /// Appends a zero-XP Inspiration spend event to the immutable `xp_ledger`
  /// when the hero spends 1 Inspiration to re-roll a Story Mode D20 check.
  Future<void> spendInspirationForReroll(
    Attribute attribute, {
    DateTime? now,
  }) async {
    final ts = now ?? DateTime.now();
    await _db.into(_db.xpLedger).insert(
          XpLedgerCompanion.insert(
            id: _nextId('story_insp', ts),
            attribute: attribute,
            amount: 0.0,
            source: XpSource.inspirationSpend,
            timestamp: ts,
            description: const Value('Story Mode Inspiration Re-roll'),
          ),
        );
  }
}
