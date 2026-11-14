import 'attributes.dart';

/// The 16 possible classes: 15 combinations of the two highest attributes,
/// plus the balanced Adventurer. Texts live in the localized game content
/// under `class.<enumName>.title` / `.lore`.
enum CharacterClass {
  adventurer(
    primary: null,
    secondary: null,
  ),
  warrior(
    primary: Attribute.strength,
    secondary: Attribute.dexterity,
  ),
  barbarian(
    primary: Attribute.strength,
    secondary: Attribute.constitution,
  ),
  eldritchKnight(
    primary: Attribute.strength,
    secondary: Attribute.intelligence,
  ),
  templar(
    primary: Attribute.strength,
    secondary: Attribute.wisdom,
  ),
  paladin(
    primary: Attribute.strength,
    secondary: Attribute.charisma,
  ),
  ranger(
    primary: Attribute.dexterity,
    secondary: Attribute.constitution,
  ),
  rogue(
    primary: Attribute.dexterity,
    secondary: Attribute.intelligence,
  ),
  monk(
    primary: Attribute.dexterity,
    secondary: Attribute.wisdom,
  ),
  bard(
    primary: Attribute.dexterity,
    secondary: Attribute.charisma,
  ),
  artificer(
    primary: Attribute.constitution,
    secondary: Attribute.intelligence,
  ),
  druid(
    primary: Attribute.constitution,
    secondary: Attribute.wisdom,
  ),
  sorcerer(
    primary: Attribute.constitution,
    secondary: Attribute.charisma,
  ),
  mage(
    primary: Attribute.intelligence,
    secondary: Attribute.wisdom,
  ),
  warlock(
    primary: Attribute.intelligence,
    secondary: Attribute.charisma,
  ),
  cleric(
    primary: Attribute.wisdom,
    secondary: Attribute.charisma,
  );

  const CharacterClass({
    required this.primary,
    required this.secondary,
  });

  final Attribute? primary;
  final Attribute? secondary;
}

abstract final class ClassResolver {
  /// Determina a classe emergente com base no mapa de XP ou scores dos atributos.
  ///
  /// Se a diferença entre os atributos for insignificante (ex: início de jogo ou vida equilibrada),
  /// o personagem assume a classe **Aventureiro**.
  static CharacterClass resolveClass(Map<Attribute, double> attributeXpMap) {
    if (attributeXpMap.isEmpty) return CharacterClass.adventurer;

    // Ordena os atributos do maior XP para o menor
    final sorted = attributeXpMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final highest = sorted[0];
    final second = sorted.length > 1 ? sorted[1] : null;
    final lowest = sorted.last;

    // Se o maior atributo tiver quase o mesmo XP do menor (margem < 50 XP ou menos de 10% de diferença), é Aventureiro
    final spread = highest.value - lowest.value;
    if (spread < 60.0 || (highest.value > 0 && (spread / highest.value) < 0.12)) {
      return CharacterClass.adventurer;
    }

    if (second == null) return CharacterClass.adventurer;

    final attr1 = highest.key;
    final attr2 = second.key;

    return _matchPair(attr1, attr2);
  }

  static CharacterClass _matchPair(Attribute a, Attribute b) {
    final set = {a, b};

    if (set.contains(Attribute.strength) && set.contains(Attribute.dexterity)) return CharacterClass.warrior;
    if (set.contains(Attribute.strength) && set.contains(Attribute.constitution)) return CharacterClass.barbarian;
    if (set.contains(Attribute.strength) && set.contains(Attribute.intelligence)) return CharacterClass.eldritchKnight;
    if (set.contains(Attribute.strength) && set.contains(Attribute.wisdom)) return CharacterClass.templar;
    if (set.contains(Attribute.strength) && set.contains(Attribute.charisma)) return CharacterClass.paladin;

    if (set.contains(Attribute.dexterity) && set.contains(Attribute.constitution)) return CharacterClass.ranger;
    if (set.contains(Attribute.dexterity) && set.contains(Attribute.intelligence)) return CharacterClass.rogue;
    if (set.contains(Attribute.dexterity) && set.contains(Attribute.wisdom)) return CharacterClass.monk;
    if (set.contains(Attribute.dexterity) && set.contains(Attribute.charisma)) return CharacterClass.bard;

    if (set.contains(Attribute.constitution) && set.contains(Attribute.intelligence)) return CharacterClass.artificer;
    if (set.contains(Attribute.constitution) && set.contains(Attribute.wisdom)) return CharacterClass.druid;
    if (set.contains(Attribute.constitution) && set.contains(Attribute.charisma)) return CharacterClass.sorcerer;

    if (set.contains(Attribute.intelligence) && set.contains(Attribute.wisdom)) return CharacterClass.mage;
    if (set.contains(Attribute.intelligence) && set.contains(Attribute.charisma)) return CharacterClass.warlock;

    if (set.contains(Attribute.wisdom) && set.contains(Attribute.charisma)) return CharacterClass.cleric;

    return CharacterClass.adventurer;
  }
}
