import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/core/game/xp_event.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/character_repository.dart';
import 'package:app/data/repositories/hero_repository.dart';
import 'package:app/data/repositories/providers.dart';
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

  Future<AppDatabase> pumpCharacterWithHero(WidgetTester tester) async {
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

  testWidgets('challenging an Arena NPC, winning, and equipping title + cosmetic updates Hero sheet', (tester) async {
    final db = await pumpCharacterWithHero(tester);
    await settle(tester);

    // Open Arena from CharacterScreen (scroll to bottom where Arena banner lives)
    final arenaCard = find.byKey(const Key('open_arena_card'));
    await tester.dragUntilVisible(
      arenaCard,
      find.byType(ListView).first,
      const Offset(0, -300),
    );
    await settle(tester);
    await tester.tap(arenaCard);
    await settle(tester);

    expect(find.text('Recruta das Cinzas'), findsOneWidget);

    // Challenge the first NPC
    final challengeBtn = find.byKey(const Key('arena_challenge_npc_ash_recruit'));
    await tester.ensureVisible(challengeBtn);
    await tester.tap(challengeBtn);
    await settle(tester);

    // Execute basic strikes until victory
    for (var turn = 0; turn < 10; turn++) {
      final basicBtn = find.byKey(const Key('combat_action_basic'));
      if (basicBtn.evaluate().isEmpty) break;
      await tester.ensureVisible(basicBtn);
      await tester.tap(basicBtn);
      await settle(tester);
    }

    expect(find.text('Vitória na Arena!'), findsWidgets);

    // Equip unlocked title and cosmetic right from victory card
    final equipBtn = find.byKey(const Key('combat_equip_reward_btn'));
    await tester.ensureVisible(equipBtn);
    await tester.tap(equipBtn);
    await settle(tester);

    // Navigate back to CharacterScreen and scroll back to top
    await tester.tap(find.byKey(const Key('arena_back_btn')));
    await settle(tester);
    await tester.dragUntilVisible(
      find.text('Guts'),
      find.byType(ListView).first,
      const Offset(0, 300),
    );
    await settle(tester);

    expect(find.textContaining('Iniciado do Fosso'), findsOneWidget);
    expect(find.text('Insígnia das Cinzas'), findsOneWidget);

    await disposeApp(tester, db);
  });
}
