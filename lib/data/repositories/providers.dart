import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../backup/backup_service.dart';
import '../database.dart';
import 'character_repository.dart';
import 'workout_repository.dart';
import 'activity_repository.dart';
import 'quest_repository.dart';
import 'hero_repository.dart';
import 'routine_repository.dart';
import 'history_repository.dart';
import 'combat_repository.dart';
import 'story_repository.dart';
import '../../core/game/attributes.dart';
import '../../core/game/combat.dart';
import '../../core/game/routine.dart';
import '../../core/game/hero_profile.dart';
import '../../core/game/story.dart';
import '../../core/game/xp_rules.dart';
import '../../features/story/domain/story_narrator.dart';
import '../../features/story/domain/template_story_narrator.dart';

/// Compile-time flag (`--dart-define=TESTER_MODE=true`) that enables Tester
/// Mode by default on startup.
const bool kDefaultTesterMode = bool.fromEnvironment(
  'TESTER_MODE',
  defaultValue: false,
);

/// Sandbox state for the Tester Mode panel, allowing real-time attribute,
/// Inspiration, token, and d20 roll overrides without mutating `xp_ledger`.
final class TesterModeState {
  const TesterModeState({
    this.enabled = kDefaultTesterMode,
    this.scores = const {
      Attribute.strength: 14,
      Attribute.dexterity: 14,
      Attribute.constitution: 14,
      Attribute.intelligence: 14,
      Attribute.wisdom: 14,
      Attribute.charisma: 14,
    },
    this.inspirationCount = 3,
    this.infiniteCombatTokens = true,
    this.forcedD20,
  });

  final bool enabled;
  final Map<Attribute, int> scores;
  final int inspirationCount;
  final bool infiniteCombatTokens;

  /// Optional forced d20 roll (`null` = normal random `1..20`, `20` = critical, `1` = fumble).
  final int? forcedD20;

  TesterModeState copyWith({
    bool? enabled,
    Map<Attribute, int>? scores,
    int? inspirationCount,
    bool? infiniteCombatTokens,
    int? forcedD20,
    bool clearForcedD20 = false,
  }) {
    return TesterModeState(
      enabled: enabled ?? this.enabled,
      scores: scores ?? this.scores,
      inspirationCount: inspirationCount ?? this.inspirationCount,
      infiniteCombatTokens: infiniteCombatTokens ?? this.infiniteCombatTokens,
      forcedD20: clearForcedD20 ? null : (forcedD20 ?? this.forcedD20),
    );
  }
}

class TesterModeNotifier extends StateNotifier<TesterModeState> {
  TesterModeNotifier() : super(const TesterModeState());

  void setEnabled(bool enabled) => state = state.copyWith(enabled: enabled);

  void setAttributeScore(Attribute attribute, int score) {
    final clamped = score.clamp(8, 30);
    state = state.copyWith(
      enabled: true,
      scores: {...state.scores, attribute: clamped},
    );
  }

  void applyPreset(Map<Attribute, int> preset) {
    state = state.copyWith(
      enabled: true,
      scores: {
        for (final a in Attribute.values)
          a: (preset[a] ?? XpRules.baseAttributeScore).clamp(8, 30),
      },
    );
  }

  void setInspiration(int count) => state = state.copyWith(
        enabled: true,
        inspirationCount: count.clamp(0, 99),
      );

  void setInfiniteTokens(bool infinite) => state = state.copyWith(
        infiniteCombatTokens: infinite,
      );

  void setForcedD20(int? roll) {
    if (roll == null) {
      state = state.copyWith(clearForcedD20: true);
    } else {
      state = state.copyWith(forcedD20: roll.clamp(1, 20));
    }
  }
}

final testerModeProvider =
    StateNotifierProvider<TesterModeNotifier, TesterModeState>(
      (ref) => TesterModeNotifier(),
    );

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CharacterRepository(db);
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final charRepo = ref.watch(characterRepositoryProvider);
  final repo = WorkoutRepository(
    db,
    charRepo,
    ref.watch(questRepositoryProvider),
    ref.watch(heroRepositoryProvider),
    ref.watch(historyRepositoryProvider),
  );
  repo.syncCatalog();
  return repo;
});

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final charRepo = ref.watch(characterRepositoryProvider);
  return ActivityRepository(db, charRepo, ref.watch(questRepositoryProvider));
});

final questRepositoryProvider = Provider<QuestRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final charRepo = ref.watch(characterRepositoryProvider);
  return QuestRepository(db, charRepo);
});

final _dbCharacterStreamProvider = StreamProvider<CharacterState>((ref) {
  return ref.watch(characterRepositoryProvider).watchCharacter();
});

final characterStreamProvider = StreamProvider<CharacterState>((ref) async* {
  final repo = ref.watch(characterRepositoryProvider);
  final tester = ref.watch(testerModeProvider);
  final selectedClass =
      ref.watch(heroStreamProvider).valueOrNull?.selectedClass;
  final cached = ref.watch(_dbCharacterStreamProvider).valueOrNull;

  CharacterState mapState(CharacterState real) {
    if (!tester.enabled) return real;
    return CharacterState.fromOverrideScores(
      scores: tester.scores,
      inspirationCount: tester.inspirationCount,
      selectedClass: selectedClass,
    );
  }

  if (cached != null) {
    yield mapState(cached);
  }
  await for (final real in repo.watchCharacter()) {
    yield mapState(real);
  }
});

final todayQuestsStreamProvider = StreamProvider<List<DailyQuestsTableData>>((ref) {
  final repo = ref.watch(questRepositoryProvider);
  return repo.watchTodayQuests();
});

final heroRepositoryProvider = Provider<HeroRepository>((ref) {
  return HeroRepository(ref.watch(databaseProvider));
});

/// Perfil do herói; `null` enquanto o onboarding não foi concluído.
final heroStreamProvider = StreamProvider<HeroProfile?>((ref) {
  return ref.watch(heroRepositoryProvider).watchHero();
});

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository(ref.watch(databaseProvider));
});

/// User-created routines (templates come from `RoutineRepository.templates`).
final customRoutinesProvider = StreamProvider<List<Routine>>((ref) {
  return ref.watch(routineRepositoryProvider).watchCustomRoutines();
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(ref.watch(databaseProvider));
});

/// Finished workouts, newest first.
final finishedSessionsProvider = StreamProvider<List<SessionOverview>>((ref) {
  return ref.watch(historyRepositoryProvider).watchFinishedSessions();
});

/// Distinct training days (calendar, week strip, streak).
final trainingDaysProvider = StreamProvider<Set<DateTime>>((ref) {
  return ref.watch(historyRepositoryProvider).watchTrainingDays();
});

/// Personal records with their exercise.
final recordsProvider = StreamProvider<List<(PersonalRecord, Exercise)>>((ref) {
  return ref.watch(historyRepositoryProvider).watchRecords();
});

/// Today's Constitution health state (water cups, diet check-in, sleep).
final todayHealthStreamProvider = StreamProvider<DailyHealthRow?>((ref) {
  return ref.watch(activityRepositoryProvider).watchTodayHealth();
});

final combatRepositoryProvider = Provider<CombatRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final charRepo = ref.watch(characterRepositoryProvider);
  return CombatRepository(db, charRepo);
});

final _dbArenaStateStreamProvider = StreamProvider<ArenaState>((ref) {
  return ref.watch(combatRepositoryProvider).watchArenaState();
});

/// Live Arena progression, unlocked titles/cosmetics, and today's entry tokens.
final arenaStateStreamProvider = StreamProvider<ArenaState>((ref) async* {
  final repo = ref.watch(combatRepositoryProvider);
  final tester = ref.watch(testerModeProvider);
  final cached = ref.watch(_dbArenaStateStreamProvider).valueOrNull;

  ArenaState mapArena(ArenaState real) {
    if (!tester.enabled || !tester.infiniteCombatTokens) return real;
    return ArenaState(
      victoriesByOpponent: real.victoriesByOpponent,
      totalEntriesToday:
          math.max(real.totalEntriesToday, real.entriesUsedToday + 99),
      entriesUsedToday: real.entriesUsedToday,
    );
  }

  if (cached != null) {
    yield mapArena(cached);
  }
  await for (final real in repo.watchArenaState()) {
    yield mapArena(real);
  }
});

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepository(ref.watch(databaseProvider));
});

/// Active Weekly Story Arc plus today/week real-world habit digest.
final weeklyStoryArcProvider =
    StreamProvider<({StoryArcState arc, StoryHabitDigest habits})>((ref) {
  return ref.watch(storyRepositoryProvider).watchWeeklyArc();
});

/// Chronicle log rows for a given ISO week key (`YYYY-Www`).
final weeklyStoryChaptersProvider =
    StreamProvider.family<List<StoryChapterRow>, String>((ref, weekKey) {
  return ref.watch(storyRepositoryProvider).watchChapters(weekKey);
});

/// Swappable Story Narrator (offline Template narrator now; Remote AI in 7C).
final storyNarratorProvider = Provider<StoryNarrator>((ref) {
  return const TemplateStoryNarrator();
});

/// Carries a finished Story-triggered combat encounter back to StoryModeView.
final storyPendingCombatOutcomeProvider = StateProvider<
    ({StoryCombatSpec spec, CombatEncounter encounter})?>((ref) => null);
