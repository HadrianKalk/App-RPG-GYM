/// Display-font family used for titles, numbers and buttons.
/// Body text always uses the readable sans-serif font.
enum AppFontStyle {
  /// Jersey 10 — pixel-art look (default).
  pixel,

  /// Cinzel — the original classic fantasy serif.
  classic,
}

/// User preferences. Immutable; use [copyWith] to change a field.
final class AppSettings {
  const AppSettings({
    this.languageCode,
    this.fontStyle = AppFontStyle.pixel,
    this.soundEnabled = true,
    this.geminiApiKey,
    this.geminiModel = defaultGeminiModel,
  });

  static const String defaultGeminiModel = 'gemini-3.8-flash';

  /// `null` = follow the device language; otherwise 'pt' or 'en'.
  final String? languageCode;
  final AppFontStyle fontStyle;
  final bool soundEnabled;

  /// Optional user-provided Gemini API key (BYOK), stored locally only.
  final String? geminiApiKey;
  final String geminiModel;

  bool get hasGeminiKey => (geminiApiKey ?? '').trim().isNotEmpty;

  AppSettings copyWith({
    String? Function()? languageCode,
    AppFontStyle? fontStyle,
    bool? soundEnabled,
    String? Function()? geminiApiKey,
    String? geminiModel,
  }) {
    return AppSettings(
      languageCode: languageCode != null ? languageCode() : this.languageCode,
      fontStyle: fontStyle ?? this.fontStyle,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      geminiApiKey: geminiApiKey != null ? geminiApiKey() : this.geminiApiKey,
      geminiModel: geminiModel ?? this.geminiModel,
    );
  }
}
