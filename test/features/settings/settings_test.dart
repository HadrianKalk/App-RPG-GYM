import 'package:app/features/settings/data/settings_providers.dart';
import 'package:app/features/settings/data/settings_repository.dart';
import 'package:app/features/settings/domain/app_settings.dart';
import 'package:app/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('settings default to device language + pixel font, and persist', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(container.dispose);

    expect(container.read(settingsProvider).languageCode, isNull);
    expect(container.read(settingsProvider).fontStyle, AppFontStyle.pixel);

    await container.read(settingsProvider.notifier).setLanguage('en');
    await container.read(settingsProvider.notifier).setFontStyle(AppFontStyle.classic);

    final reloaded = SettingsRepository(prefs).load();
    expect(reloaded.languageCode, 'en');
    expect(reloaded.fontStyle, AppFontStyle.classic);

    await container.read(settingsProvider.notifier).setLanguage(null);
    expect(SettingsRepository(prefs).load().languageCode, isNull);
  });

  test('corrupted stored font falls back to pixel', () async {
    SharedPreferences.setMockInitialValues({'settings.fontStyle': 'comic-sans'});
    final prefs = await SharedPreferences.getInstance();
    expect(SettingsRepository(prefs).load().fontStyle, AppFontStyle.pixel);
  });

  test('device locale resolution: supported language, else English', () {
    const supported = [Locale('en'), Locale('pt')];
    expect(resolveAppLocale(const Locale('pt', 'BR'), supported), const Locale('pt'));
    expect(resolveAppLocale(const Locale('de'), supported), const Locale('en'));
    expect(resolveAppLocale(null, supported), const Locale('en'));
  });
}
