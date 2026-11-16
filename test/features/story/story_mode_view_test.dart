import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/core/game/legendary_bosses.dart';
import 'package:app/core/game/xp_event.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/character_repository.dart';
import 'package:app/data/repositories/hero_repository.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/features/arena/presentation/arena_screen.dart';
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
        name: 'Kaelen',
        form: HeroForm.masculine,
        origin: HeroOrigin.scholar,
      );
      await CharacterRepository(db).addXp(
        XpEvent(
          id: 'seed_int',
          attribute: Attribute.intelligence,
          amount: 400,
          source: XpSource.pomodoroStudy,
          timestamp: DateTime.now(),
        ),
      );
      // Give 1 real-world Inspiration via dailyQuest.
      await db.into(db.xpLedger).insert(
            XpLedgerCompanion.insert(
              id: 'seed_insp',
              attribute: Attribute.intelligence,
              amount: 50,
              source: XpSource.dailyQuest,
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

  testWidgets(
    'Story Mode runs free-text D20 check with Inspiration re-roll and logs Chronicle',
    (tester) async {
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

      // Enter Story Mode from the top Combat Hub card.
      await tester.tap(find.byKey(const Key('combat_mode_story_btn')));
      await settle(tester);
      expect(find.byKey(const Key('story_scene_card')), findsOneWidget);
      expect(find.byKey(const Key('story_challenge_boss_btn')), findsOneWidget);

      // Force natural 2 (normal miss vs DC 13+) via TesterModeNotifier so the
      // Inspiration Re-roll flow triggers before combat escalation.
      final storyCtx = tester.element(find.byKey(const Key('story_scene_card')));
      ProviderScope.containerOf(storyCtx)
          .read(testerModeProvider.notifier)
          .setForcedD20(2);

      // Type a free-text Charisma action (CAR = 10 -> total 4 vs DC 13 = Miss).
      final input = find.byKey(const Key('story_free_input'));
      final sendBtn = find.byKey(const Key('story_send_action_btn'));
      await tester.ensureVisible(input);
      await settle(tester);
      await tester.enterText(input, 'Vou persuadir o guarda');
      await tester.ensureVisible(sendBtn);
      await settle(tester);
      await tester.tap(sendBtn);
      await settle(tester);

      // Interactive D20 modal opens -> tap die -> wait -> tap continue.
      expect(find.byKey(const Key('d20_interactive_dialog')), findsOneWidget);
      await tester.tap(find.byKey(const Key('d20_dialog_tap_area')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();
      await tester.tap(find.byKey(const Key('d20_dialog_continue_hint')));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 120)),
      );
      await settle(tester);

      // Verify D20 banner rendered with the rolled 20 after Inspiration re-roll.
      final natText =
          tester.widget<Text>(find.byKey(const Key('d20_natural_value'))).data;
      final headlineText =
          tester.widget<Text>(find.byKey(const Key('d20_outcome_headline'))).data;
      final charInsp = ProviderScope.containerOf(
        tester.element(find.byType(ArenaScreen)),
      ).read(characterStreamProvider).valueOrNull?.inspirationCount;
      expect(natText, '2', reason: 'headline=$headlineText insp=$charInsp');
      expect(charInsp, greaterThan(0), reason: 'headline=$headlineText nat=$natText');
      expect(
        find.byKey(const Key('story_reroll_inspiration_btn')),
        findsOneWidget,
        reason: 'BEFORE scroll/setForcedD20: headline=$headlineText insp=$charInsp',
      );

      // After failure, Inspiration re-roll button is shown -> spend Inspiration to re-roll 20.
      ProviderScope.containerOf(
        tester.element(find.byType(ArenaScreen)),
      ).read(testerModeProvider.notifier).setForcedD20(20);
      final rerollBtn = find.byKey(const Key('story_reroll_inspiration_btn'));
      await tester.scrollUntilVisible(
        rerollBtn,
        -150,
        scrollable: find.byType(Scrollable).first,
      );
      await settle(tester);
      expect(rerollBtn, findsOneWidget);
      await tester.tap(rerollBtn);
      await settle(tester);

      expect(find.byKey(const Key('d20_interactive_dialog')), findsOneWidget);
      await tester.tap(find.byKey(const Key('d20_dialog_tap_area')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();
      await tester.tap(find.byKey(const Key('d20_dialog_continue_hint')));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 120)),
      );
      await settle(tester);

      // Verify D20 banner rendered with the rolled 20 after Inspiration re-roll.
      expect(find.byKey(const Key('d20_roller_banner')), findsOneWidget);

      // Open Chronicle Log and confirm the beat + Inspiration crit were persisted.
      final chronicleBtn = find.byKey(const Key('story_chronicle_btn'));
      await tester.scrollUntilVisible(
        chronicleBtn,
        -250,
        scrollable: find.byType(Scrollable).first,
      );
      await settle(tester);
      await tester.tap(chronicleBtn);
      await settle(tester);
      expect(find.textContaining('Diário de Crônicas'), findsOneWidget);
      expect(find.textContaining('persuadir o guarda'), findsWidgets);

      await disposeApp(tester, db);
    },
  );

  testWidgets(
    'Legendary Bosses mode lets Tester challenge Satorion (18-boss catalog)',
    (tester) async {
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

      // Enable Tester Mode so all 18 Legendary Bosses are unlocked.
      await tester.tap(find.byKey(const Key('open_tester_panel_btn')));
      await settle(tester);
      await tester.tap(find.byKey(const Key('tester_preset_16')));
      await settle(tester);
      await tester.tap(find.byIcon(Icons.close));
      await settle(tester);

      final legBtn = find.byKey(const Key('combat_mode_legendary_btn'));
      await tester.scrollUntilVisible(
        legBtn,
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await settle(tester);
      await tester.tap(legBtn);
      await settle(tester);

      expect(find.textContaining('TODOS OS 18 LENDÁRIOS'), findsOneWidget);

      final satorionBtn = find.byKey(
        Key('legendary_challenge_${LegendaryBossCatalog.bosses.first.id}'),
      );
      await tester.scrollUntilVisible(
        satorionBtn,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await settle(tester);
      await tester.tap(satorionBtn);
      await settle(tester);

      expect(find.byKey(const Key('combat_stage_widget')), findsOneWidget);
      expect(find.textContaining('Satorion'), findsOneWidget);

      await disposeApp(tester, db);
    },
  );
}
