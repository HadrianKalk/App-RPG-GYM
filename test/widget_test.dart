import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/data/repositories/character_repository.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/main.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('App smoke test - inicializa sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          characterStreamProvider.overrideWith(
            (ref) => Stream.value(CharacterState.initial()),
          ),
          todayQuestsStreamProvider.overrideWith(
            (ref) => Stream.value([]),
          ),
        ],
        child: const GrindheimApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(GrindheimApp), findsOneWidget);
  });
}
