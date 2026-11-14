import 'package:material_ui/material_ui.dart';

import 'game_text.dart';
import 'generated/app_localizations.dart';

export 'game_text.dart';
export 'generated/app_localizations.dart';

/// Shortcuts for localized texts inside widgets:
/// `context.l10n.navHero` (UI chrome) and `context.game.className(c)`
/// (game content).
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  GameText get game => GameTextCache.forLanguage(Localizations.localeOf(this).languageCode);
}

/// Localization delegates for the app.
///
/// IMPORTANT: this app uses `package:material_ui` instead of Flutter's
/// built-in Material library, so the Material/Cupertino delegates must come
/// from `material_ui` (its `GlobalMaterialLocalizations.delegates` also
/// includes the widgets and cupertino delegates). Using the ones generated
/// by gen-l10n (`AppLocalizations.localizationsDelegates`) breaks text
/// fields and chips in Portuguese.
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates = [
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

/// Keeps one [GameText] per language (they are immutable lookups).
abstract final class GameTextCache {
  static final Map<String, GameText> _cache = {};

  static GameText forLanguage(String code) => _cache.putIfAbsent(code, () => GameText(code));
}

/// Picks the app locale: the user's explicit choice wins; otherwise the
/// device language if supported; otherwise English (widest audience).
Locale resolveAppLocale(Locale? deviceLocale, Iterable<Locale> supported) {
  final code = deviceLocale?.languageCode;
  for (final l in supported) {
    if (l.languageCode == code) return l;
  }
  return const Locale('en');
}
