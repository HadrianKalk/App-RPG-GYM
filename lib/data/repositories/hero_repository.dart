import 'package:drift/drift.dart';

import '../../core/game/activity_catalog.dart';
import '../../core/game/class_resolver.dart';
import '../../core/game/hero_appearance.dart';
import '../../core/game/hero_profile.dart';
import '../../core/game/weekly_progress.dart';
import '../../core/game/xp_rules.dart';
import '../database.dart';

/// Persists the hero profile (single row).
class HeroRepository {
  HeroRepository(this._db);

  final AppDatabase _db;

  static const int _heroId = 1;

  /// Watches the hero; emits `null` until onboarding creates it.
  Stream<HeroProfile?> watchHero() {
    final query = _db.select(_db.heroes)..where((t) => t.id.equals(_heroId));
    return query.watchSingleOrNull().map((row) => row == null ? null : _toProfile(row));
  }

  /// Creates (or recreates) the hero. Custom origins require a valid name.
  Future<void> createHero({
    required String name,
    required HeroForm form,
    required HeroOrigin origin,
    String? oath,
    String? customOriginName,
    String? customOriginStory,
    HeroAppearance appearance = HeroAppearance.defaultAppearance,
  }) async {
    final error = HeroProfile.validateName(name);
    if (error != null) throw ArgumentError(error);
    final isCustom = origin == HeroOrigin.custom;
    if (isCustom && HeroProfile.validateOriginName(customOriginName ?? '') != null) {
      throw ArgumentError('custom origin needs a valid name');
    }
    String? clean(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();

    final trimmedOath = oath?.trim();
    await _db.into(_db.heroes).insertOnConflictUpdate(
          HeroesCompanion.insert(
            id: const Value(_heroId),
            name: name.trim(),
            form: form,
            origin: origin,
            oath: Value(
              trimmedOath == null || trimmedOath.isEmpty ? null : trimmedOath,
            ),
            createdAt: DateTime.now(),
            customOriginName: Value(isCustom ? clean(customOriginName) : null),
            customOriginStory: Value(isCustom ? clean(customOriginStory) : null),
            appearance: Value(appearance.encode()),
          ),
        );
  }

  /// Changes the weekly goal (clamped to the allowed range). Affects only
  /// future bonuses.
  Future<void> setWeeklyGoal(int goal) =>
      (_db.update(_db.heroes)..where((t) => t.id.equals(_heroId)))
          .write(HeroesCompanion(weeklyGoal: Value(WeeklyProgress.clampGoal(goal))));

  /// Current weekly goal (default when no hero exists yet).
  Future<int> weeklyGoal() async {
    final row = await (_db.select(_db.heroes)..where((t) => t.id.equals(_heroId))).getSingleOrNull();
    return row?.weeklyGoal ?? XpRules.weeklyGoalDefault;
  }

  /// Changes the daily water goal in 250 ml cups (clamped to allowed range).
  Future<void> setWaterGoalCups(int cups) =>
      (_db.update(_db.heroes)..where((t) => t.id.equals(_heroId)))
          .write(HeroesCompanion(waterGoalCups: Value(HealthRules.clampWaterGoal(cups))));

  /// Current daily water goal in cups (default when no hero exists yet).
  Future<int> waterGoalCups() async {
    final row = await (_db.select(_db.heroes)..where((t) => t.id.equals(_heroId))).getSingleOrNull();
    return row?.waterGoalCups ?? XpRules.waterGoalDefaultCups;
  }

  /// Equips (or unequips with `null`) an unlocked combat title.
  Future<void> setEquippedTitle(String? titleId) =>
      (_db.update(_db.heroes)..where((t) => t.id.equals(_heroId)))
          .write(HeroesCompanion(equippedTitleId: Value(titleId)));

  /// Equips (or unequips with `null`) an unlocked combat cosmetic.
  Future<void> setEquippedCosmetic(String? cosmeticId) =>
      (_db.update(_db.heroes)..where((t) => t.id.equals(_heroId)))
          .write(HeroesCompanion(equippedCosmeticId: Value(cosmeticId)));

  /// Sets the hero's chosen class (`null` returns to automatic emergent class).
  Future<void> setSelectedClass(CharacterClass? selectedClass) =>
      (_db.update(_db.heroes)..where((t) => t.id.equals(_heroId)))
          .write(HeroesCompanion(selectedClass: Value(selectedClass)));

  /// Persists the hero's modular Paper-Doll [appearance].
  Future<void> setAppearance(HeroAppearance appearance) =>
      (_db.update(_db.heroes)..where((t) => t.id.equals(_heroId)))
          .write(HeroesCompanion(appearance: Value(appearance.encode())));

  HeroProfile _toProfile(HeroRow row) => HeroProfile(
        name: row.name,
        form: row.form,
        origin: row.origin,
        oath: row.oath,
        createdAt: row.createdAt,
        customOriginName: row.customOriginName,
        customOriginStory: row.customOriginStory,
        weeklyGoal: row.weeklyGoal,
        waterGoalCups: row.waterGoalCups,
        equippedTitleId: row.equippedTitleId,
        equippedCosmeticId: row.equippedCosmeticId,
        selectedClass: row.selectedClass,
        appearance: HeroAppearance.decode(row.appearance),
      );
}
