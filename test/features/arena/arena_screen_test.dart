import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/core/game/xp_event.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/character_repository.dart';
import 'package:app/data/repositories/hero_repository.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/features/arena/presentation/arena_screen.dart';
import 'package:app/features/character/presentation/character_screen.dart';
import 'package:app/l10n/l10n.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  Future<AppDatabase> seedHeroDb(WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() async {
      await HeroRepository(db).createHero(
        name: 'Guts',
        form: HeroForm.masculine,
        origin: HeroOrigin.soldier,
      );
      await CharacterRepository(db).addXp(
        XpEvent(
          id: 'seed_str',
          attribute: Attribute.strength,
          amount: 400,
          source: XpSource.workoutSet,
          timestamp: DateTime.now(),
        ),
      );
    });
    return db;
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  Future<void> disposeApp(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('Combat Hub displays locked Story Mode at top, Tester Mode forces Nat 20 on D20 banner, and equipping rewards updates Hero sheet', (tester) async {
    final db = await seedHeroDb(tester);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          locale: Locale('pt'),
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ArenaScreen(),
        ),
      ),
    );
    await settle(tester);

    // 1. Verify Combat Hub shows Story Mode (locked at top) and 1v1 Duels card
    expect(find.byKey(const Key('combat_mode_story_card')), findsOneWidget);
    expect(find.textContaining('EM BREVE'), findsOneWidget);
    expect(find.byKey(const Key('combat_mode_duels_card')), findsOneWidget);

    // 2. Open Tester Panel and force Natural 20 + Veteran preset (16 in all attributes)
    await tester.tap(find.byKey(const Key('open_tester_panel_btn')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('tester_preset_16')));
    await settle(tester);
    final force20Chip = find.byKey(const Key('tester_d20_20'));
    await tester.ensureVisible(force20Chip);
    await tester.tap(force20Chip);
    await settle(tester);
    await tester.tap(find.byIcon(Icons.close));
    await settle(tester);

    // 3. Enter 1v1 Duel Arena from the Hub card
    final duelsBtn = find.byKey(const Key('combat_mode_duels_btn'));
    await tester.ensureVisible(duelsBtn);
    await settle(tester);
    await tester.tap(duelsBtn);
    await settle(tester);

    expect(find.text('Recruta das Cinzas'), findsOneWidget);

    // 4. Challenge the first NPC
    final challengeBtn = find.byKey(const Key('arena_challenge_npc_ash_recruit'));
    await tester.ensureVisible(challengeBtn);
    await settle(tester);
    await tester.tap(challengeBtn);
    await settle(tester);

    expect(find.byKey(const Key('combat_stage_widget')), findsOneWidget);
    expect(find.byKey(const Key('stage_hero_avatar')), findsOneWidget);
    expect(find.byKey(const Key('stage_opponent_avatar')), findsOneWidget);

    // 5. Execute basic strikes: opens interactive D20 dialog, tap die to roll (Nat 20), and verify battle banner
    for (var turn = 0; turn < 5; turn++) {
      final basicBtn = find.byKey(const Key('combat_action_basic'));
      if (basicBtn.evaluate().isEmpty) break;
      await tester.ensureVisible(basicBtn);
      await settle(tester);
      await tester.tap(basicBtn);
      await settle(tester);

      // Interactive center D20 modal appears asking user to tap the die
      expect(find.byKey(const Key('d20_interactive_dialog')), findsOneWidget);
      await tester.tap(find.byKey(const Key('d20_dialog_tap_area')));
      // Pump through the 620ms drop/spin animation; modal stays open until user taps
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();
      expect(find.byKey(const Key('d20_dialog_continue_hint')), findsOneWidget);
      await tester.tap(find.byKey(const Key('d20_dialog_continue_hint')));
      await settle(tester);

      expect(find.byKey(const Key('d20_roller_banner')), findsOneWidget);
      expect(find.byKey(const Key('d20_natural_value')), findsOneWidget);
    }

    expect(find.text('Vitória na Arena!'), findsWidgets);

    // 6. Equip unlocked title and cosmetic right from victory card
    final equipBtn = find.byKey(const Key('combat_equip_reward_btn'));
    await tester.ensureVisible(equipBtn);
    await settle(tester);
    await tester.tap(equipBtn);
    await settle(tester);

    // 7. Render CharacterScreen to verify equipped title, cosmetic, and unlocked classes
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          locale: Locale('pt'),
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CharacterScreen(),
        ),
      ),
    );
    await settle(tester);

    expect(find.textContaining('Iniciado do Fosso'), findsOneWidget);
    expect(find.text('Insígnia das Cinzas'), findsOneWidget);

    await disposeApp(tester, db);
  });
}
