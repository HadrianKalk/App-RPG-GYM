/// Hero identity chosen during character creation.
///
/// Everything here is **narrative only**: name, origin and form of address
/// never change any game number. They feed the UI and, in Phase 2, the
/// narrator. Visible texts live in the localized game content under
/// `heroForm.<enumName>.*` and `origin.<enumName>.*`.
library;

import 'class_resolver.dart';
import 'hero_appearance.dart';

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
  fallenHeir(icon: '👑'),

  /// The player writes their own origin name and story.
  custom(icon: '✒️');

  const HeroOrigin({required this.icon});

  /// Decorative emoji shown next to the origin name (not translated).
  final String icon;
}

/// Reasons a hero name (or custom origin name) can be rejected. The UI maps
/// each one to a localized message.
enum HeroNameError { empty, tooShort, tooLong }

/// Immutable hero profile.
final class HeroProfile {
  const HeroProfile({
    required this.name,
    required this.form,
    required this.origin,
    required this.createdAt,
    this.oath,
    this.customOriginName,
    this.customOriginStory,
    this.weeklyGoal = 3,
    this.waterGoalCups = 8,
    this.equippedTitleId,
    this.equippedCosmeticId,
    this.selectedClass,
    this.appearance = HeroAppearance.defaultAppearance,
  });

  /// Maximum hero name length.
  static const int maxNameLength = 24;

  /// Minimum hero name length.
  static const int minNameLength = 2;

  /// Maximum oath length.
  static const int maxOathLength = 140;

  /// Maximum length of a custom origin name.
  static const int maxOriginNameLength = 32;

  /// Maximum length of a custom origin story.
  static const int maxOriginStoryLength = 240;

  final String name;
  final HeroForm form;
  final HeroOrigin origin;
  final DateTime createdAt;

  /// "Why do you train?" — personal motivation, used by the narrator.
  final String? oath;

  /// Origin name typed by the player (only when [origin] is custom).
  final String? customOriginName;

  /// Optional origin story typed by the player (only when [origin] is custom).
  final String? customOriginStory;

  /// Training days per week the player aims for (consistency bonuses).
  final int weeklyGoal;

  /// Daily hydration goal in 250 ml cups (Constitution health).
  final int waterGoalCups;

  /// Currently equipped combat title id (`combatTitle.<id>`), if any.
  final String? equippedTitleId;

  /// Currently equipped combat cosmetic id (`combatCosmetic.<id>`), if any.
  final String? equippedCosmeticId;

  /// Player-chosen class among unlocked classes (`null` = automatic emergent class).
  final CharacterClass? selectedClass;

  /// Modular Paper-Doll visual configuration (skin, hair, eyes, beard, armor, pants, boots, cape).
  final HeroAppearance appearance;

  /// Validates a raw hero name. Returns `null` when valid, or the reason.
  static HeroNameError? validateName(String raw) =>
      _validate(raw, minNameLength, maxNameLength);

  /// Validates a custom origin name (same rules, different max length).
  static HeroNameError? validateOriginName(String raw) =>
      _validate(raw, minNameLength, maxOriginNameLength);

  static HeroNameError? _validate(String raw, int min, int max) {
    final text = raw.trim();
    if (text.isEmpty) return HeroNameError.empty;
    if (text.length < min) return HeroNameError.tooShort;
    if (text.length > max) return HeroNameError.tooLong;
    return null;
  }
}
