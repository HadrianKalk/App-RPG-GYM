/// The six classic D&D attributes, mapped to real-life habits.
///
/// The engine only knows the identifiers; every visible text (name, short
/// code such as FOR/STR, description) lives in the localized game content
/// (`lib/l10n/content/`), keyed by `attribute.<enumName>.*`.
enum Attribute {
  strength,
  dexterity,
  constitution,
  intelligence,
  wisdom,
  charisma,
}
