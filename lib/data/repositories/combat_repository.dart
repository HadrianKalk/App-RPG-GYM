import 'dart:async';
import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../../core/game/attributes.dart';
import '../../core/game/combat.dart';
import '../../core/game/xp_event.dart';
import '../database.dart';
import 'character_repository.dart';

/// Live snapshot of the player's Arena progression and daily entry tokens.
final class ArenaState {
  const ArenaState({
    required this.victoriesByOpponent,
    required this.totalEntriesToday,
    required this.entriesUsedToday,
  });

  /// Victory count per opponent id (`npc_*`).
  final Map<String, int> victoriesByOpponent;

  /// Total Arena tokens earned today (free + workouts + quests + health habit).
  final int totalEntriesToday;

  /// Arena tokens already spent today.
  final int entriesUsedToday;

  /// Remaining Arena tokens available right now.
  int get entriesRemainingToday =>
      math.max<int>(0, totalEntriesToday - entriesUsedToday);

  /// Number of distinct Arena opponents defeated at least once.
  int get defeatedChampionsCount =>
      ArenaCatalog.opponents.where((npc) => isDefeated(npc.id)).length;

  /// Number of distinct Tournaments conquered at least once.
  int get tournamentsWonCount =>
      TournamentCatalog.tournaments.where((t) => isDefeated(t.id)).length;

  /// Whether [opponentId] (or tournament id) has been defeated at least once.
  bool isDefeated(String opponentId) =>
      (victoriesByOpponent[opponentId] ?? 0) > 0;

  /// All unlocked combat title ids (`title_*`) from Arena and Tournaments.
  Set<String> get unlockedTitleIds => {
        for (final npc in ArenaCatalog.opponents)
          if (isDefeated(npc.id)) npc.reward.titleId,
        for (final t in TournamentCatalog.tournaments)
          if (isDefeated(t.id)) t.reward.titleId,
      };

  /// All unlocked combat cosmetic ids (`cosmetic_*`) from Arena and Tournaments.
  Set<String> get unlockedCosmeticIds => {
        for (final npc in ArenaCatalog.opponents)
          if (isDefeated(npc.id)) npc.reward.cosmeticId,
        for (final t in TournamentCatalog.tournaments)
          if (isDefeated(t.id)) t.reward.cosmeticId,
      };
}

/// Manages Arena progression, daily entry tokens, and combat outcomes.
class CombatRepository {
  CombatRepository(this._db, this._characterRepo);

  final AppDatabase _db;
  final CharacterRepository _characterRepo;
  int _nonce = 0;

  String _nextId(DateTime now) =>
      'insp_${now.millisecondsSinceEpoch}_${++_nonce}';

  static String _dateKey(DateTime dt) => '${dt.year}-${dt.month}-${dt.day}';

  /// Reactive stream of [ArenaState] combining Arena progress, today's token
  /// usage, and today's real-world habits (workouts, quests, health).
  Stream<ArenaState> watchArenaState() {
    // Recompute whenever any relevant table changes.
    final trigger = _db.customSelect(
      'SELECT 1',
      readsFrom: {
        _db.arenaProgress,
        _db.dailyArenaLogs,
        _db.workoutSessions,
        _db.dailyQuestsTable,
        _db.dailyHealthLogs,
      },
    ).watch();

    return trigger.asyncMap((_) => getArenaState());
  }

  /// Computes the current [ArenaState] for [now] (defaults to `DateTime.now()`).
  Future<ArenaState> getArenaState({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final todayStr = _dateKey(current);
    final startOfDay = DateTime(current.year, current.month, current.day);
    final endOfDay =
        DateTime(current.year, current.month, current.day, 23, 59, 59);

    final progressRows = await _db.select(_db.arenaProgress).get();
    final victories = <String, int>{
      for (final row in progressRows) row.opponentId: row.victories,
    };

    final arenaLog = await (_db.select(_db.dailyArenaLogs)
          ..where((t) => t.dateStr.equals(todayStr)))
        .getSingleOrNull();
    final usedToday = arenaLog?.entriesUsed ?? 0;

    final finishedWorkoutsToday = await (_db.select(_db.workoutSessions)
          ..where((t) => t.completedAt.isNotNull())
          ..where((t) => t.completedAt.isBiggerOrEqualValue(startOfDay))
          ..where((t) => t.completedAt.isSmallerOrEqualValue(endOfDay)))
        .get();

    final completedQuestsToday = await (_db.select(_db.dailyQuestsTable)
          ..where((t) => t.dateStr.equals(todayStr))
          ..where((t) => t.isCompleted.equals(true)))
        .get();

    final healthToday = await (_db.select(_db.dailyHealthLogs)
          ..where((t) => t.dateStr.equals(todayStr)))
        .getSingleOrNull();
    final healthHabitDone = healthToday != null &&
        (healthToday.waterGoalBonusClaimed ||
            healthToday.dietAdherence != null);

    final totalEntries = ArenaTokenRules.totalEntriesToday(
      workoutsToday: finishedWorkoutsToday.length,
      questsCompletedToday: completedQuestsToday.length,
      healthHabitDoneToday: healthHabitDone,
    );

    return ArenaState(
      victoriesByOpponent: victories,
      totalEntriesToday: totalEntries,
      entriesUsedToday: usedToday,
    );
  }

  /// Spends 1 daily Arena entry token for today. Returns `false` if none remain.
  Future<bool> consumeDailyEntry({DateTime? now}) async {
    final state = await getArenaState(now: now);
    if (state.entriesRemainingToday <= 0) return false;

    final todayStr = _dateKey(now ?? DateTime.now());
    final newUsed = state.entriesUsedToday + 1;
    await _db.into(_db.dailyArenaLogs).insertOnConflictUpdate(
          DailyArenaLogsCompanion.insert(
            dateStr: todayStr,
            entriesUsed: Value(newUsed),
          ),
        );
    return true;
  }

  /// Records the end of an Arena match.
  ///
  /// - Never grants XP (Decision #40).
  /// - If [spentInspiration] is `true`, appends an immutable `inspirationSpend`
  ///   entry (0 XP) to `xp_ledger`.
  /// - On victory, increments the opponent's victory count (unlocking their
  ///   title and cosmetic) and returns `true` when this is the **first**
  ///   victory against [opponent].
  Future<bool> finishMatch({
    required ArenaOpponent opponent,
    required bool victory,
    required bool spentInspiration,
    DateTime? now,
  }) async {
    final timestamp = now ?? DateTime.now();

    if (spentInspiration) {
      await _characterRepo.addXp(
        XpEvent(
          id: _nextId(timestamp),
          attribute: Attribute.charisma,
          amount: 0.0,
          source: XpSource.inspirationSpend,
          timestamp: timestamp,
          description: 'Heroic Inspiration spent in Arena (${opponent.id})',
        ),
      );
    }

    if (!victory) return false;

    final existing = await (_db.select(_db.arenaProgress)
          ..where((t) => t.opponentId.equals(opponent.id)))
        .getSingleOrNull();
    final prevVictories = existing?.victories ?? 0;

    await _db.into(_db.arenaProgress).insertOnConflictUpdate(
          ArenaProgressCompanion.insert(
            opponentId: opponent.id,
            victories: Value(prevVictories + 1),
            lastDefeatedAt: timestamp,
          ),
        );

    return prevVictories == 0;
  }

  /// Records the end of a multi-round Tournament.
  ///
  /// - Never grants XP (Decision #40).
  /// - Deducts 1 Inspiration via append-only ledger if [spentInspiration] is `true`.
  /// - On tournament victory, increments the tournament's completion count and
  ///   returns `true` when this is the first time conquering [tournament].
  Future<bool> finishTournament({
    required TournamentDefinition tournament,
    required bool victory,
    required bool spentInspiration,
    DateTime? now,
  }) async {
    final timestamp = now ?? DateTime.now();

    if (spentInspiration) {
      await _characterRepo.addXp(
        XpEvent(
          id: _nextId(timestamp),
          attribute: Attribute.charisma,
          amount: 0.0,
          source: XpSource.inspirationSpend,
          timestamp: timestamp,
          description: 'Heroic Inspiration spent in Tournament (${tournament.id})',
        ),
      );
    }

    if (!victory) return false;

    final existing = await (_db.select(_db.arenaProgress)
          ..where((t) => t.opponentId.equals(tournament.id)))
        .getSingleOrNull();
    final prevVictories = existing?.victories ?? 0;

    await _db.into(_db.arenaProgress).insertOnConflictUpdate(
          ArenaProgressCompanion.insert(
            opponentId: tournament.id,
            victories: Value(prevVictories + 1),
            lastDefeatedAt: timestamp,
          ),
        );

    return prevVictories == 0;
  }
}
