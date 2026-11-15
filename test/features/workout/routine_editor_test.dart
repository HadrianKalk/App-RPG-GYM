import 'package:app/data/database.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/features/workout/presentation/routine_editor_screen.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  testWidgets('build a routine from catalog exercises and save it', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);

    final db = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
    await tester.runAsync(() => container.read(workoutRepositoryProvider).syncCatalog());

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: testMaterialApp(home: const RoutineEditorScreen()),
      ),
    );
    await settle(tester);

    await tester.enterText(find.byType(TextField).first, 'Upper A');

    // Add two exercises through the picker (search narrows the lazy list).
    for (final (query, name) in [('prancha', 'Prancha Isométrica'), ('supino reto', 'Supino Reto com Barra')]) {
      await tester.tap(find.text('Adicionar exercício'));
      await settle(tester);
      await tester.enterText(find.byType(TextField).last, query);
      await settle(tester);
      await tester.tap(find.text(name).last);
      await settle(tester);
    }
    expect(find.text('Prancha Isométrica'), findsOneWidget);
    expect(find.text('Tempo'), findsOneWidget, reason: 'timed exercise shows a time field');
    expect(find.text('Reps mín.'), findsOneWidget, reason: 'lifting exercise shows a reps range');

    await tester.tap(find.text('Salvar rotina'));
    await settle(tester);

    final saved = await tester.runAsync(() => container.read(routineRepositoryProvider).watchCustomRoutines().first);
    expect(saved!.single.customName, 'Upper A');
    expect(saved.single.exercises.map((e) => e.exerciseId), ['ex_prancha_isometrica', 'ex_supino_reto_barra']);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
    container.dispose();
  });
}
