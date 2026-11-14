/// Single source of truth for the product name.
///
/// Changing the game/franchise name only requires editing these constants.
/// Taglines/subtitles are translatable, so they live in the ARB files.
abstract final class AppBrand {
  /// Franchise / series name.
  static const String seriesTitle = 'RPGym';

  /// Current game name.
  static const String appName = 'Grindheim';

  /// Full title used in window titles and headers.
  static const String fullTitle = '$seriesTitle: $appName';

  /// Display version.
  static const String version = '0.2.0 (Alfa)';
}
