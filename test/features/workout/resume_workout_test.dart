import 'package:app/core/game/hero_profile.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/hero_repository.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/data/seed/exercise_seed.dart';
import 'package:app/features/workout/application/active_workout_controller.dart';
import 'package:app/features/workout/presentation/workout_screen.dart';
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

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  test('new requested exercises exist in ExerciseSeed', () {
    final ids = ExerciseSeed.defaultExercises.map((e) => e.id).toSet();
    expect(ids, contains('ex_triceps_frances_unilateral_polia'));
    expect(ids, contains('ex_triceps_coice_polia'));
    expect(ids, contains('ex_triceps_coice_halter'));
    expect(ids, contains('ex_rosca_punho_polia'));
    expect(ids, contains('ex_rosca_punho_inversa_polia'));
    expect(ids, contains('ex_rosca_inversa_polia'));
    expect(ids, contains('ex_agachamento_bulgaro_smith'));
  });

  testWidgets(
    'allows minimizing active workout and resuming with saved sets across restart',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );

      await tester.runAsync(() async {
        await HeroRepository(db).createHero(
          name: 'Guts',
          form: HeroForm.masculine,
          origin: HeroOrigin.soldier,
        );
        final repo = container.read(workoutRepositoryProvider);
        await repo.syncCatalog();

        final pushRoutine = container.read(routineRepositoryProvider).templates.first;
        final session = await repo.startWorkoutSession(
          title: 'Treino Push Teste',
          routineId: pushRoutine.id,
        );
        final controller = ActiveWorkoutController(
          repository: repo,
          session: session,
        );
        await controller.loadRoutine(pushRoutine);
        await controller.updateSet(
          controller.exercises.first,
          controller.exercises.first.sets.first,
          weightKg: 82.5,
          reps: 8,
        );
        await controller.toggleSet(
          controller.exercises.first,
          controller.exercises.first.sets.first,
        );
        controller.dispose();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            locale: Locale('pt'),
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: WorkoutScreen(),
          ),
        ),
      );
      await settle(tester);

      // Resume banner appears with workout title and Resume button.
      expect(find.byKey(const Key('active_workout_resume_card')), findsOneWidget);
      expect(find.text('Treino Push Teste'), findsOneWidget);

      await tester.tap(find.byKey(const Key('workout_resume_btn')));
      await settle(tester);

      // ActiveWorkoutScreen restores exercises, saved weight, and minimize button.
      expect(find.byKey(const Key('workout_minimize_btn')), findsOneWidget);
      expect(find.textContaining('82.5'), findsOneWidget);

      // Minimize back to WorkoutScreen without losing the active workout!
      await tester.tap(find.byKey(const Key('workout_minimize_btn')));
      await settle(tester);
      expect(find.byKey(const Key('active_workout_resume_card')), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
      await tester.runAsync(db.close);
      container.dispose();
    },
  );
}
