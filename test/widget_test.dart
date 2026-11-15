import 'package:app/data/database.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:app/features/settings/data/settings_providers.dart';
import 'package:app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  setUpAll(() {
    // Each test creates its own in-memory database.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  /// Pumps the real app with an in-memory database and the given language.
  Future<AppDatabase> pumpApp(WidgetTester tester, {String language = 'pt'}) async {
    final db = AppDatabase(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({'settings.languageCode': language});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const GrindheimApp(),
      ),
    );
    return db;
  }

  /// Unmounts the app and closes the database. Call at the END of every
  /// test: Drift uses timers when cancelling watched queries.
  Future<void> disposeApp(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
    await tester.pump(const Duration(seconds: 1));
  }

  /// Pumps frames while giving the database real time to answer.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  testWidgets('without a hero the app opens on character creation', (tester) async {
    final db = await pumpApp(tester);
    await settle(tester);

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('INICIAR A JORNADA'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('full hero creation leads to the hero screen', (tester) async {
    final db = await pumpApp(tester);
    await settle(tester);

    await tester.tap(find.text('INICIAR A JORNADA'));
    await settle(tester);

    // Name step.
    await tester.enterText(find.byType(TextField), 'Guts');
    await tester.tap(find.textContaining('Heroína'));
    await settle(tester);
    await tester.tap(find.text('CONTINUAR'));
    await settle(tester);

    // Origin step.
    await tester.tap(find.text('Ex-Soldado'));
    await settle(tester);
    await tester.tap(find.text('CONTINUAR'));
    await settle(tester);

    // Oath (optional) + summary.
    expect(find.textContaining('Heroína · Ex-Soldado'), findsOneWidget);
    await tester.tap(find.text('FORJAR HERÓI'));
    await settle(tester);

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.text('Guts'), findsOneWidget);
    expect(find.textContaining('Ex-Soldado'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('the whole flow also works in English', (tester) async {
    final db = await pumpApp(tester, language: 'en');
    await settle(tester);

    await tester.tap(find.text('BEGIN THE JOURNEY'));
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'Casca');
    await tester.tap(find.textContaining('Heroine'));
    await settle(tester);
    await tester.tap(find.text('CONTINUE'));
    await settle(tester);
    await tester.tap(find.text('Former Soldier'));
    await settle(tester);
    await tester.tap(find.text('CONTINUE'));
    await settle(tester);
    expect(find.textContaining('Heroine · Former Soldier · Level 1'), findsOneWidget);
    await tester.tap(find.text('FORGE HERO'));
    await settle(tester);

    expect(find.text('Casca'), findsOneWidget);
    expect(find.text('Attributes'), findsOneWidget);
    expect(find.text('Strength'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('custom origin: typed name and story are saved and shown', (tester) async {
    final db = await pumpApp(tester);
    await settle(tester);

    await tester.tap(find.text('INICIAR A JORNADA'));
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'Guts');
    await settle(tester);
    await tester.tap(find.text('CONTINUAR'));
    await settle(tester);

    // The origin list is lazy: drag it until the custom option is built.
    await tester.dragUntilVisible(find.text('Origem própria'), find.byType(ListView).first, const Offset(0, -300));
    await settle(tester);
    await tester.tap(find.text('Origem própria'));
    await settle(tester);
    // Continue stays disabled until the custom origin has a name.
    await tester.enterText(find.byType(TextField).first, 'Mercenário Negro');
    await settle(tester);
    final story = find.widgetWithText(TextField, 'Sua história (opcional)');
    await tester.dragUntilVisible(story, find.byType(ListView).first, const Offset(0, -200));
    await tester.enterText(story, 'Nasceu sob a forca.');
    await settle(tester);
    await tester.tap(find.text('CONTINUAR'));
    await settle(tester);
    expect(find.textContaining('Herói · Mercenário Negro · Nível 1'), findsOneWidget);
    await tester.tap(find.text('FORJAR HERÓI'));
    await settle(tester);

    final hero = await tester.runAsync(() => db.select(db.heroes).getSingle());
    expect(hero!.customOriginName, 'Mercenário Negro');
    expect(hero.customOriginStory, 'Nasceu sob a forca.');
    expect(find.textContaining('Mercenário Negro'), findsOneWidget);
    await disposeApp(tester, db);
  });
}
