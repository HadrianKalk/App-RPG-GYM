import 'package:app/core/game/activity_catalog.dart';
import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/xp_event.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/features/activities/presentation/activities_screen.dart';
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

  Future<AppDatabase> pumpActivities(WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          locale: const Locale('pt'),
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ActivitiesScreen(),
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

  testWidgets('logs water cup and daily diet check-in', (tester) async {
    final db = await pumpActivities(tester);
    await settle(tester);

    expect(find.textContaining('0/8 copos'), findsOneWidget);
    await tester.tap(find.byKey(const Key('water_add_btn')));
    await settle(tester);

    expect(find.textContaining('1/8 copos · 250 ml'), findsOneWidget);

    final dietBtn = find.byKey(const Key('diet_on_track_btn'));
    await tester.dragUntilVisible(
      dietBtn,
      find.byType(ListView).first,
      const Offset(0, -200),
    );
    await settle(tester);
    await tester.tap(dietBtn);
    await settle(tester);

    // Reward dialog opens showing +25 XP.
    expect(find.text('Atividade Concluída!'), findsOneWidget);
    expect(find.text('+25 XP'), findsWidgets);
    await tester.tap(find.text('Ótimo'));
    await settle(tester);

    // Diet card now displays the completed check-in state.
    expect(
      find.text('Check-in de hoje: Plano alimentar cumprido'),
      findsOneWidget,
    );

    final health = await tester.runAsync(
      () => db.select(db.dailyHealthLogs).getSingle(),
    );
    expect(health!.waterCups, 1);
    expect(health.dietAdherence, DietAdherence.onTrack);

    await disposeApp(tester, db);
  });

  testWidgets('logs a Charisma catalog activity and a custom activity', (tester) async {
    final db = await pumpActivities(tester);
    await settle(tester);

    final oratoryBtn = find.byKey(const Key('act_oratory_20'));
    await tester.dragUntilVisible(
      oratoryBtn,
      find.byType(ListView).first,
      const Offset(0, -250),
    );
    await settle(tester);
    await tester.tap(oratoryBtn);
    await settle(tester);

    expect(find.text('Atividade Concluída!'), findsOneWidget);
    expect(find.text('Carisma'), findsWidgets);
    await tester.tap(find.text('Ótimo'));
    await settle(tester);

    // Open custom activity sheet.
    final customBtn = find.byKey(const Key('open_custom_activity_btn'));
    await tester.dragUntilVisible(
      customBtn,
      find.byType(ListView).first,
      const Offset(0, -250),
    );
    await settle(tester);
    await tester.tap(customBtn);
    await settle(tester);

    await tester.enterText(
      find.byKey(const Key('custom_activity_name_input')),
      'Aula de Violão',
    );
    await tester.tap(find.byKey(const Key('custom_attr_dexterity')));
    await settle(tester);
    final submitBtn = find.byKey(const Key('custom_activity_submit_btn'));
    await tester.ensureVisible(submitBtn);
    await tester.pumpAndSettle();
    await tester.tap(submitBtn);
    await settle(tester);

    expect(find.text('Atividade Concluída!'), findsOneWidget);
    expect(find.textContaining('Aula de Violão'), findsOneWidget);
    await tester.tap(find.text('Ótimo'));
    await settle(tester);

    final events = await tester.runAsync(() => db.select(db.xpLedger).get());
    expect(
      events!.where((e) => e.attribute == Attribute.charisma),
      isNotEmpty,
    );
    expect(
      events.where(
        (e) =>
            e.attribute == Attribute.dexterity &&
            e.source == XpSource.activity,
      ),
      isNotEmpty,
    );

    await disposeApp(tester, db);
  });
}
