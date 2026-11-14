import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import 'character_repository.dart';
import 'workout_repository.dart';
import 'activity_repository.dart';
import 'quest_repository.dart';
import 'hero_repository.dart';
import '../../core/game/hero_profile.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CharacterRepository(db);
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final charRepo = ref.watch(characterRepositoryProvider);
  final repo = WorkoutRepository(db, charRepo, ref.watch(questRepositoryProvider));
  repo.ensureSeeded();
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

final characterStreamProvider = StreamProvider<CharacterState>((ref) {
  final repo = ref.watch(characterRepositoryProvider);
  return repo.watchCharacter();
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
