import 'package:app/core/game/attributes.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/data/repositories/workout_repository.dart';
import 'package:app/features/workout/presentation/exercise_picker_sheet.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Repositório falso: só o que o seletor de exercícios usa.
class _FakeWorkoutRepository implements WorkoutRepository {
  @override
  Stream<List<Exercise>> watchExercises({String? query, String? muscleGroup}) =>
      Stream.value(const [
        Exercise(
          id: 'supino',
          name: 'Supino Reto',
          muscleGroup: 'Peito',
          equipment: 'Barra',
          attribute: Attribute.strength,
          isCustom: false,
        ),
      ]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('seletor de exercícios lista itens sem assertion de ListTile',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(_FakeWorkoutRepository()),
        ],
        child: const MaterialApp(
          home: Scaffold(body: ExercisePickerSheet()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Supino Reto'), findsOneWidget);
    // Antes da correção, o ListTile dentro de um Container colorido
    // disparava "ListTile background color or ink splashes may be invisible".
    expect(tester.takeException(), isNull);
  });
}
