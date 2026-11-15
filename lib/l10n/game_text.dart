import '../core/game/attributes.dart';
import '../core/game/class_resolver.dart';
import '../core/game/exercise_taxonomy.dart';
import '../core/game/hero_profile.dart';
import '../core/game/routine.dart';
import 'content/game_content_en.dart';
import 'content/game_content_pt.dart';

/// Resolves localized *game content* (attributes, classes, origins, quests,
/// exercises...) from the stable keys exposed by the engine.
///
/// UI chrome (buttons, titles, hints) lives in the ARB files instead
/// (`lib/l10n/arb/`). Game content is kept in plain Dart maps because it is
/// catalog data that grows with the game.
///
/// To add a language: create `content/game_content_<code>.dart` with the
/// same keys and register it in [_tables].
class GameText {
  GameText(this.languageCode)
      : _table = _tables[languageCode] ?? _tables[fallbackLanguage]!;

  /// Language used when a code is unknown or a key is missing.
  static const String fallbackLanguage = 'pt';

  static const Map<String, Map<String, String>> _tables = {
    'pt': gameContentPt,
    'en': gameContentEn,
  };

  /// Language codes that have game content.
  static Iterable<String> get supportedLanguages => _tables.keys;

  final String languageCode;
  final Map<String, String> _table;

  /// Looks up [key]; falls back to Portuguese, then to [fallback] or the key.
  String t(String key, {String? fallback}) =>
      _table[key] ?? _tables[fallbackLanguage]![key] ?? fallback ?? key;

  /// True when [key] exists in this language (no fallback).
  bool has(String key) => _table.containsKey(key);

  // --- Attributes -----------------------------------------------------------
  String attributeName(Attribute a) => t('attribute.${a.name}.name');
  String attributeCode(Attribute a) => t('attribute.${a.name}.code');
  String attributeDescription(Attribute a) => t('attribute.${a.name}.description');

  // --- Classes ------------------------------------------------------------
  String className(CharacterClass c) => t('class.${c.name}.title');
  String classLore(CharacterClass c) => t('class.${c.name}.lore');

  // --- Hero ---------------------------------------------------------------
  String heroFormLabel(HeroForm f) => t('heroForm.${f.name}.label');
  String heroFormTitle(HeroForm f) => t('heroForm.${f.name}.title');
  String originName(HeroOrigin o) => t('origin.${o.name}.name');
  String originDescription(HeroOrigin o) => t('origin.${o.name}.description');

  /// Origin label of a concrete hero: the typed name for custom origins.
  String heroOriginName(HeroProfile hero) =>
      hero.origin == HeroOrigin.custom && (hero.customOriginName?.isNotEmpty ?? false)
          ? hero.customOriginName!
          : originName(hero.origin);

  // --- Routines -----------------------------------------------------------
  /// Template routines are translated; custom ones show the typed name.
  String routineName(Routine r) => r.isTemplate ? t('routine.${r.id}.name') : (r.customName ?? '');
  String routineDescription(Routine r) => r.isTemplate ? t('routine.${r.id}.description') : '';

  // --- Exercises ------------------------------------------------------------
  /// Catalog exercises are translated by id; custom ones keep [storedName].
  String exerciseName(String id, String storedName) =>
      t('exercise.$id', fallback: storedName);
  String muscle(MuscleGroup m) => t('muscle.${m.name}');
  String equipment(Equipment e) => t('equipment.${e.name}');

  /// Step-by-step execution cues for a catalog exercise (`exercise.<id>.guide`).
  List<String> exerciseSteps(String id) {
    final raw = t('exercise.$id.guide', fallback: '');
    if (raw.isEmpty) return const [];
    return raw
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
  }

  // --- Activities -----------------------------------------------------------
  /// Catalog activities are translated by id (`activity.<id>.name` / `.description`).
  String activityName(String id, {String? fallback}) =>
      t('activity.$id.name', fallback: fallback ?? id);
  String activityDescription(String id) =>
      t('activity.$id.description', fallback: '');

  // --- Quests -------------------------------------------------------------
  /// Quest rows store keys (`quest.slot.<slot>` / `quest.task.<attr>`).
  /// Rows created before localization stored final Portuguese texts, which
  /// are shown as-is.
  String questTitle(String titleKey, String descriptionKey) {
    if (!titleKey.startsWith('quest.')) return titleKey;
    return '${t(titleKey)}: ${t('$descriptionKey.title')}';
  }

  String questDescription(String descriptionKey) {
    if (!descriptionKey.startsWith('quest.')) return descriptionKey;
    return t('$descriptionKey.description');
  }

  String questUnit(String unit) => t('questUnit.$unit', fallback: unit);
}
