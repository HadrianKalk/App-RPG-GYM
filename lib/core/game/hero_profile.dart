/// Hero identity chosen during character creation.
///
/// Everything here is **narrative only**: name, origin and form of address
/// never change any game number. They feed the UI and, in Phase 2, the
/// narrator. Visible texts live in the localized game content under
/// `heroForm.<enumName>.*` and `origin.<enumName>.*`.
library;

/// Grammatical form of address. Portuguese inflects by gender, so the
/// narrator needs to know how to refer to the hero.
enum HeroForm { masculine, feminine, neutral }

/// Hero background, in the spirit of D&D 5e backgrounds.
/// Narrative only: no origin grants attribute bonuses.
enum HeroOrigin {
  soldier(icon: '⚔️'),
  scholar(icon: '📜'),
  wanderer(icon: '🥾'),
  acolyte(icon: '🕯️'),
  smith(icon: '🔨'),
  fallenHeir(icon: '👑');

  const HeroOrigin({required this.icon});

  /// Decorative emoji shown next to the origin name (not translated).
  final String icon;
}

/// Reasons a hero name can be rejected. The UI maps each one to a
/// localized message.
enum HeroNameError { empty, tooShort, tooLong }

/// Immutable hero profile.
final class HeroProfile {
  const HeroProfile({
    required this.name,
    required this.form,
    required this.origin,
    required this.createdAt,
    this.oath,
  });

  /// Maximum hero name length.
  static const int maxNameLength = 24;

  /// Minimum hero name length.
  static const int minNameLength = 2;

  /// Maximum oath length.
  static const int maxOathLength = 140;

  final String name;
  final HeroForm form;
  final HeroOrigin origin;
  final DateTime createdAt;

  /// "Why do you train?" — personal motivation, used by the narrator.
  final String? oath;

  /// Validates a raw name. Returns `null` when valid, or the error reason.
  static HeroNameError? validateName(String raw) {
    final name = raw.trim();
    if (name.isEmpty) return HeroNameError.empty;
    if (name.length < minNameLength) return HeroNameError.tooShort;
    if (name.length > maxNameLength) return HeroNameError.tooLong;
    return null;
  }
}
