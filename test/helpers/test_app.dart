import 'package:app/app/theme.dart';
import 'package:app/features/settings/domain/app_settings.dart';
import 'package:app/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';

/// MaterialApp configured like the real app (theme + localization) for
/// widget tests. Fonts are bundled assets, so no network is needed.
Widget testMaterialApp({required Widget home, String languageCode = 'pt'}) => MaterialApp(
      theme: AppTheme.build(AppFontStyle.pixel),
      locale: Locale(languageCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: appLocalizationsDelegates,
      home: home,
    );
