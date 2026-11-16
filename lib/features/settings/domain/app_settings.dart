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
  });

  /// `null` = follow the device language; otherwise 'pt' or 'en'.
  final String? languageCode;
  final AppFontStyle fontStyle;
  final bool soundEnabled;

  AppSettings copyWith({
    String? Function()? languageCode,
    AppFontStyle? fontStyle,
    bool? soundEnabled,
  }) {
    return AppSettings(
      languageCode: languageCode != null ? languageCode() : this.languageCode,
      fontStyle: fontStyle ?? this.fontStyle,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}
