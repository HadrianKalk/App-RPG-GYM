import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_settings.dart';
import 'settings_repository.dart';

/// SharedPreferences instance. Loaded once in `main()` and injected with
/// `overrideWithValue`, so the rest of the app can read it synchronously.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override sharedPreferencesProvider in main()'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)),
);

/// Current settings; screens call the notifier methods to change them.
final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  /// `null` follows the device language.
  Future<void> setLanguage(String? languageCode) =>
      _update(state.copyWith(languageCode: () => languageCode));

  Future<void> setFontStyle(AppFontStyle style) =>
      _update(state.copyWith(fontStyle: style));

  Future<void> setSoundEnabled(bool enabled) =>
      _update(state.copyWith(soundEnabled: enabled));

  Future<void> setGeminiConfig({String? apiKey, String? model}) =>
      _update(
        state.copyWith(
          geminiApiKey: () =>
              (apiKey == null || apiKey.trim().isEmpty) ? null : apiKey.trim(),
          geminiModel: model != null && model.trim().isNotEmpty
              ? model.trim()
              : AppSettings.defaultGeminiModel,
        ),
      );

  Future<void> _update(AppSettings next) async {
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }
}
