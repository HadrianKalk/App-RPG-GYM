import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/brand.dart';
import 'app/router.dart';
import 'app/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: GrindheimApp(),
    ),
  );
}

class GrindheimApp extends StatelessWidget {
  const GrindheimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppBrand.fullTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
