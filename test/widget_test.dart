import 'package:app/data/database.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:app/app/router.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  setUpAll(() {
    // Cada teste cria seu próprio banco em memória.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  Future<AppDatabase> pumpApp(WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    // Roteador real do app; tema simples porque o tema oficial baixa fontes
    // do Google, o que não funciona em teste.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            theme: ThemeData.dark(),
            routerConfig: ref.watch(routerProvider),
          ),
        ),
      ),
    );
    return db;
  }

  /// Desmonta o app e fecha o banco. Chamar no FIM de cada teste: o Drift
  /// usa temporizadores ao cancelar consultas observadas.
  Future<void> disposeApp(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
    await tester.pump(const Duration(seconds: 1));
  }

  /// Bombeia frames dando tempo real para o banco responder.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  testWidgets('sem herói, o app abre na criação de personagem', (tester) async {
    final db = await pumpApp(tester);
    await settle(tester);

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('INICIAR A JORNADA'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('criação completa do herói leva à tela do personagem', (tester) async {
    final db = await pumpApp(tester);
    await settle(tester);

    await tester.tap(find.text('INICIAR A JORNADA'));
    await settle(tester);

    // Passo do nome: botão desabilitado até haver nome válido.
    await tester.enterText(find.byType(TextField), 'Guts');
    await tester.tap(find.textContaining('Heroína'));
    await settle(tester);
    await tester.tap(find.text('CONTINUAR'));
    await settle(tester);

    // Passo da origem.
    await tester.tap(find.text('Ex-Soldado'));
    await settle(tester);
    await tester.tap(find.text('CONTINUAR'));
    await settle(tester);

    // Juramento (opcional) + resumo.
    expect(find.textContaining('Heroína · Ex-Soldado'), findsOneWidget);
    await tester.tap(find.text('FORJAR HERÓI'));
    await settle(tester);

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.text('Guts'), findsOneWidget);
    expect(find.textContaining('Ex-Soldado'), findsOneWidget);
    expect(find.textContaining('0 Inspiração'), findsOneWidget);
    await disposeApp(tester, db);
  });
}
