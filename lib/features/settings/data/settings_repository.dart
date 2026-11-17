import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_settings.dart';

/// Persists [AppSettings] in SharedPreferences (small key/value store,
/// available on every platform including web).
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kLanguage = 'settings.languageCode';
  static const _kFontStyle = 'settings.fontStyle';
  static const _kSoundEnabled = 'settings.soundEnabled';
  static const _kGeminiApiKey = 'settings.geminiApiKey';
  static const _kGeminiModel = 'settings.geminiModel';

  /// Reads the saved settings, ignoring unknown/corrupted values.
  AppSettings load() {
    final fontName = _prefs.getString(_kFontStyle);
    final font = AppFontStyle.values.where((f) => f.name == fontName).firstOrNull;
    return AppSettings(
      languageCode: _prefs.getString(_kLanguage),
      fontStyle: font ?? AppFontStyle.pixel,
      soundEnabled: _prefs.getBool(_kSoundEnabled) ?? true,
      geminiApiKey: _prefs.getString(_kGeminiApiKey),
      geminiModel:
          _prefs.getString(_kGeminiModel) ?? AppSettings.defaultGeminiModel,
    );
  }

  /// Writes every field of [settings].
  Future<void> save(AppSettings settings) async {
    final lang = settings.languageCode;
    if (lang == null) {
      await _prefs.remove(_kLanguage);
    } else {
      await _prefs.setString(_kLanguage, lang);
    }
    await _prefs.setString(_kFontStyle, settings.fontStyle.name);
    await _prefs.setBool(_kSoundEnabled, settings.soundEnabled);
    final key = settings.geminiApiKey?.trim();
    if (key == null || key.isEmpty) {
      await _prefs.remove(_kGeminiApiKey);
    } else {
      await _prefs.setString(_kGeminiApiKey, key);
    }
    await _prefs.setString(_kGeminiModel, settings.geminiModel);
  }
}
