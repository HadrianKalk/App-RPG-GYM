import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/brand.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'features/settings/data/settings_providers.dart';
import 'l10n/l10n.dart';

/// Entry point: loads preferences, then starts the app inside Riverpod.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const GrindheimApp(),
    ),
  );
}

/// Root widget. Rebuilds when language or font style change.
class GrindheimApp extends ConsumerWidget {
  const GrindheimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      title: AppBrand.fullTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(settings.fontStyle),
      routerConfig: ref.watch(routerProvider),
      // null = follow the device language (see resolveAppLocale).
      locale: settings.languageCode == null ? null : Locale(settings.languageCode!),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: appLocalizationsDelegates,
      localeResolutionCallback: (device, supported) => resolveAppLocale(device, supported),
    );
  }
}
