import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/core/game/xp_event.dart';
import 'package:app/data/backup/backup_service.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/hero_repository.dart';
import 'package:app/data/seed/exercise_seed.dart';
import 'package:app/features/settings/domain/app_settings.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late BackupService backupService;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.batch((b) {
      b.insertAll(
        db.exercises,
        [
          for (final item in ExerciseSeed.defaultExercises)
            ExercisesCompanion.insert(
              id: item.id,
              name: item.name,
              muscleGroup: item.muscle,
              equipment: item.equipment,
              attribute: item.attribute,
              tracking: Value(item.tracking),
            ),
        ],
      );
    });
    backupService = BackupService(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('exports and restores full hero, XP ledger, and settings JSON', () async {
    final heroRepo = HeroRepository(db);

    await heroRepo.createHero(
      name: 'Guts',
      form: HeroForm.masculine,
      origin: HeroOrigin.soldier,
    );
    await db.into(db.xpLedger).insert(
          XpLedgerCompanion.insert(
            id: 'xp_1',
            attribute: Attribute.strength,
            amount: 320,
            source: XpSource.workoutSet,
            timestamp: DateTime(2026, 11, 16, 10, 0),
            description: const Value('Bench Press'),
          ),
        );
    await db.into(db.arenaProgress).insert(
          ArenaProgressCompanion.insert(
            opponentId: 'npc_ash_recruit',
            lastDefeatedAt: DateTime(2026, 11, 16),
          ),
        );

    const exportedSettings = AppSettings(
      languageCode: 'en',
      fontStyle: AppFontStyle.classic,
      soundEnabled: false,
    );

    final json = await backupService.exportJson(settings: exportedSettings);
    final preview = backupService.inspectJson(json);
    expect(preview.heroName, 'Guts');
    expect(preview.xpEntryCount, 1);

    // Wipe database completely to simulate fresh device / cleared Safari cache.
    await db.delete(db.arenaProgress).go();
    await db.delete(db.xpLedger).go();
    await db.delete(db.heroes).go();
    expect(await heroRepo.watchHero().first, isNull);

    final restoredSettings = await backupService.restoreJson(json);
    expect(restoredSettings?.languageCode, 'en');
    expect(restoredSettings?.fontStyle, AppFontStyle.classic);
    expect(restoredSettings?.soundEnabled, isFalse);

    final restoredHero = await heroRepo.watchHero().first;
    expect(restoredHero?.name, 'Guts');

    final restoredLedger = await db.select(db.xpLedger).get();
    expect(restoredLedger.length, 1);
    expect(restoredLedger.first.amount, 320);

    final restoredArena = await db.select(db.arenaProgress).get();
    expect(restoredArena.single.opponentId, 'npc_ash_recruit');
  });

  test('inspectJson throws FormatException on invalid payload', () {
    expect(
      () => backupService.inspectJson('{"not_a_backup": true}'),
      throwsFormatException,
    );
  });
}
