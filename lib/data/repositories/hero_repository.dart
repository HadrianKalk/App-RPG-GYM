import 'package:drift/drift.dart';

import '../../core/game/hero_profile.dart';
import '../database.dart';

/// Persistência do perfil do herói (linha única).
class HeroRepository {
  HeroRepository(this._db);

  final AppDatabase _db;

  static const int _heroId = 1;

  /// Observa o herói. Emite `null` enquanto ele não foi criado (onboarding).
  Stream<HeroProfile?> watchHero() {
    final query = _db.select(_db.heroes)..where((t) => t.id.equals(_heroId));
    return query.watchSingleOrNull().map((row) => row == null ? null : _toProfile(row));
  }

  /// Cria (ou recria) o herói.
  Future<void> createHero({
    required String name,
    required HeroForm form,
    required HeroOrigin origin,
    String? oath,
  }) async {
    final error = HeroProfile.validateName(name);
    if (error != null) throw ArgumentError(error);

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
          ),
        );
  }

  HeroProfile _toProfile(HeroRow row) => HeroProfile(
        name: row.name,
        form: row.form,
        origin: row.origin,
        oath: row.oath,
        createdAt: row.createdAt,
      );
}
