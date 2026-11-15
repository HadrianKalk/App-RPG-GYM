import 'package:drift/drift.dart';

import '../../core/game/hero_profile.dart';
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
          ),
        );
  }

  HeroProfile _toProfile(HeroRow row) => HeroProfile(
        name: row.name,
        form: row.form,
        origin: row.origin,
        oath: row.oath,
        createdAt: row.createdAt,
        customOriginName: row.customOriginName,
        customOriginStory: row.customOriginStory,
      );
}
