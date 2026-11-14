import 'attributes.dart';

/// As 16 classes possíveis no jogo (15 combinações dos 2 maiores atributos + Aventureiro equilibrado).
enum CharacterClass {
  adventurer(
    title: 'Aventureiro',
    lore: 'Seus atributos são equilibrados. Versátil e pronto para qualquer desafio que o mundo imponha.',
    primary: null,
    secondary: null,
  ),
  warrior(
    title: 'Guerreiro',
    lore: 'Mestre da técnica de combate e potência pura. União devastadora de Força e Destreza.',
    primary: Attribute.strength,
    secondary: Attribute.dexterity,
  ),
  barbarian(
    title: 'Bárbaro',
    lore: 'Resistência implacável e poder bruto. Um colosso forjado em Força e Constituição.',
    primary: Attribute.strength,
    secondary: Attribute.constitution,
  ),
  eldritchKnight(
    title: 'Cavaleiro Arcano',
    lore: 'Canaliza inteligência lógica através da lâmina. A perfeita síntese de Força e Mente analítica.',
    primary: Attribute.strength,
    secondary: Attribute.intelligence,
  ),
  templar(
    title: 'Templário',
    lore: 'Fé inabalável e músculos de ferro. Guiado pela intuição da Sabedoria e força da determinação.',
    primary: Attribute.strength,
    secondary: Attribute.wisdom,
  ),
  paladin(
    title: 'Paladino',
    lore: 'Liderança inspiradora e força indomável. Seu juramento brilha na Força e no Carisma.',
    primary: Attribute.strength,
    secondary: Attribute.charisma,
  ),
  ranger(
    title: 'Patrulheiro',
    lore: 'Resistência nas marchas selvagens e reflexos afiados. Destreza combinada com vigor de Constituição.',
    primary: Attribute.dexterity,
    secondary: Attribute.constitution,
  ),
  rogue(
    title: 'Ladino',
    lore: 'Precisão cirúrgica e raciocínio afiado. Destreza rápida aliada a uma Inteligência estratégica.',
    primary: Attribute.dexterity,
    secondary: Attribute.intelligence,
  ),
  monk(
    title: 'Monge',
    lore: 'Harmonia absoluta entre reflexos corporais e quietude interior. Destreza e Sabedoria meditativa.',
    primary: Attribute.dexterity,
    secondary: Attribute.wisdom,
  ),
  bard(
    title: 'Bardo',
    lore: 'Agilidade de dedos e fascínio natural. Encanta multidões com Destreza artística e Carisma.',
    primary: Attribute.dexterity,
    secondary: Attribute.charisma,
  ),
  artificer(
    title: 'Artífice',
    lore: 'Engenho meticuloso e saúde de ferro para noites na forja. Constituição e Inteligência inventiva.',
    primary: Attribute.constitution,
    secondary: Attribute.intelligence,
  ),
  druid(
    title: 'Druida',
    lore: 'Conexão profunda com os ciclos da vida e vitalidade orgânica. Constituição e Sabedoria natural.',
    primary: Attribute.constitution,
    secondary: Attribute.wisdom,
  ),
  sorcerer(
    title: 'Feiticeiro',
    lore: 'Poder inato que pulsa no sangue e presença magnética. Constituição física sustentando Carisma primal.',
    primary: Attribute.constitution,
    secondary: Attribute.charisma,
  ),
  mage(
    title: 'Mago',
    lore: 'Erudição profunda e discernimento aguçado. Domínio da Inteligência técnica e Sabedoria ancestral.',
    primary: Attribute.intelligence,
    secondary: Attribute.wisdom,
  ),
  warlock(
    title: 'Bruxo',
    lore: 'Pactos de poder e intelecto ambicioso. A mente perspicaz da Inteligência com o magnetismo do Carisma.',
    primary: Attribute.intelligence,
    secondary: Attribute.charisma,
  ),
  cleric(
    title: 'Clérigo',
    lore: 'Voz da fé e guia de espíritos. Sabedoria espiritual expressa através de um Carisma pastoral.',
    primary: Attribute.wisdom,
    secondary: Attribute.charisma,
  );

  const CharacterClass({
    required this.title,
    required this.lore,
    required this.primary,
    required this.secondary,
  });

  final String title;
  final String lore;
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
