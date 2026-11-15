import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/exercise_taxonomy.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/data/repositories/workout_repository.dart';
import 'package:app/features/workout/presentation/exercise_picker_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

/// Fake repository: only what the exercise picker uses.
class _FakeWorkoutRepository implements WorkoutRepository {
  @override
  Stream<List<Exercise>> watchAllExercises() => Stream.value(const [
        Exercise(
          id: 'ex_supino_reto_barra',
          name: 'Supino Reto com Barra',
          muscleGroup: MuscleGroup.chest,
          equipment: Equipment.barbell,
          attribute: Attribute.strength,
          tracking: SetTracking.weightReps,
          isCustom: false,
        ),
        Exercise(
          id: 'ex_agachamento_livre_barra',
          name: 'Agachamento Livre com Barra',
          muscleGroup: MuscleGroup.quads,
          equipment: Equipment.barbell,
          attribute: Attribute.strength,
          tracking: SetTracking.weightReps,
          isCustom: false,
        ),
      ]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _picker(String lang) => ProviderScope(
      overrides: [workoutRepositoryProvider.overrideWithValue(_FakeWorkoutRepository())],
      child: testMaterialApp(home: const Scaffold(body: ExercisePickerSheet()), languageCode: lang),
    );

void main() {
  testWidgets('lists exercises without the ListTile ink assertion', (tester) async {
    await tester.pumpWidget(_picker('pt'));
    await tester.pump();

    expect(find.text('Supino Reto com Barra'), findsOneWidget);
    // Before the fix, a ListTile inside a colored Container threw
    // "ListTile background color or ink splashes may be invisible".
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows English names and searches them in English', (tester) async {
    await tester.pumpWidget(_picker('en'));
    await tester.pump();

    expect(find.text('Barbell Bench Press'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'squat');
    await tester.pump();
    expect(find.text('Barbell Back Squat'), findsOneWidget);
    expect(find.text('Barbell Bench Press'), findsNothing);
  });

  testWidgets('search ignores accents and case (pt)', (tester) async {
    await tester.pumpWidget(_picker('pt'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'AGACHAMENTO');
    await tester.pump();
    expect(find.text('Agachamento Livre com Barra'), findsOneWidget);
  });

  testWidgets('tapping "?" opens the step-by-step execution guide', (tester) async {
    await tester.pumpWidget(_picker('pt'));
    await tester.pump();

    await tester.tap(find.byKey(const Key('help_ex_supino_reto_barra')));
    await tester.pumpAndSettle();

    expect(find.text('Guia de Execução'), findsOneWidget);
    expect(find.text('Passo a passo & Postura'), findsOneWidget);
    expect(find.textContaining('escápulas retraídas'), findsOneWidget);
  });
}
