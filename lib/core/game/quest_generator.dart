import 'dart:math' as math;
import 'attributes.dart';
import 'class_resolver.dart';
import 'quest_progress.dart';

final class DailyQuest {
  const DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAttribute,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.bonusXp,
    required this.grantsInspiration,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String description;
  final Attribute targetAttribute;
  final double targetValue;
  final double currentValue;
  final String unit;
  final double bonusXp;
  final bool grantsInspiration;
  final bool isCompleted;

  DailyQuest copyWith({
    double? currentValue,
    bool? isCompleted,
  }) {
    final newCurrent = currentValue ?? this.currentValue;
    return DailyQuest(
      id: id,
      title: title,
      description: description,
      targetAttribute: targetAttribute,
      targetValue: targetValue,
      currentValue: newCurrent,
      unit: unit,
      bonusXp: bonusXp,
      grantsInspiration: grantsInspiration,
      isCompleted: isCompleted ?? (newCurrent >= targetValue),
    );
  }
}

abstract final class QuestGenerator {
  /// Gera 3 missões diárias de forma determinística com base na data do dia:
  /// 1. Missão para fortalecer o atributo mais negligenciado/baixo
  /// 2. Missão focada no atributo primário da classe atual
  /// 3. Missão variada do dia (saúde/geral)
  static List<DailyQuest> generateDailyQuests({
    required DateTime date,
    required CharacterClass characterClass,
    required Map<Attribute, double> currentXpMap,
  }) {
    // Semente determinística pela data YYYYMMDD
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = math.Random(seed);

    // Encontra o atributo mais baixo
    Attribute lowestAttr = Attribute.strength;
    double lowestXp = double.infinity;
    for (final attr in Attribute.values) {
      final xp = currentXpMap[attr] ?? 0.0;
      if (xp < lowestXp) {
        lowestXp = xp;
        lowestAttr = attr;
      }
    }

    // Atributo primário da classe (ou sorteado se for Aventureiro)
    final classAttr = characterClass.primary ??
        Attribute.values[random.nextInt(Attribute.values.length)];

    // Atributo variado garantindo diversidade
    final remainingAttrs = Attribute.values
        .where((a) => a != lowestAttr && a != classAttr)
        .toList();
    final variedAttr = remainingAttrs.isNotEmpty
        ? remainingAttrs[random.nextInt(remainingAttrs.length)]
        : Attribute.constitution;

    return [
      _createQuestForAttribute(
        index: 1,
        dateStr: '${date.year}-${date.month}-${date.day}',
        attribute: lowestAttr,
        label: 'Superação',
        seed: random.nextInt(1000),
      ),
      _createQuestForAttribute(
        index: 2,
        dateStr: '${date.year}-${date.month}-${date.day}',
        attribute: classAttr,
        label: 'Dever da Classe',
        seed: random.nextInt(1000),
      ),
      _createQuestForAttribute(
        index: 3,
        dateStr: '${date.year}-${date.month}-${date.day}',
        attribute: variedAttr,
        label: 'Desafio Diário',
        seed: random.nextInt(1000),
      ),
    ];
  }

  static DailyQuest _createQuestForAttribute({
    required int index,
    required String dateStr,
    required Attribute attribute,
    required String label,
    required int seed,
  }) {
    final id = 'quest_${dateStr}_$index';

    switch (attribute) {
      case Attribute.strength:
        return DailyQuest(
          id: id,
          title: '$label: O Peso do Ferro',
          description: 'Conclua pelo menos 6 séries efetivas de musculação ou calistenia.',
          targetAttribute: attribute,
          targetValue: 6.0,
          currentValue: 0.0,
          unit: QuestUnit.sets,
          bonusXp: 30.0,
          grantsInspiration: true,
          isCompleted: false,
        );
      case Attribute.dexterity:
        return DailyQuest(
          id: id,
          title: '$label: Fluidez e Mobilidade',
          description: 'Dedique 15 minutos a alongamentos, yoga ou treino de mobilidade articular.',
          targetAttribute: attribute,
          targetValue: 15.0,
          currentValue: 0.0,
          unit: QuestUnit.minutes,
          bonusXp: 25.0,
          grantsInspiration: true,
          isCompleted: false,
        );
      case Attribute.constitution:
        return DailyQuest(
          id: id,
          title: '$label: Vigor Implacável',
          description: 'Execute 20 minutos de cardio contínuo ou atinja a meta de 8h de sono.',
          targetAttribute: attribute,
          targetValue: 20.0,
          currentValue: 0.0,
          unit: QuestUnit.minutes,
          bonusXp: 25.0,
          grantsInspiration: true,
          isCompleted: false,
        );
      case Attribute.intelligence:
        return DailyQuest(
          id: id,
          title: '$label: Mente de Aço',
          description: 'Complete ao menos 2 ciclos de foco (50 min totais de estudo ou código).',
          targetAttribute: attribute,
          targetValue: 50.0,
          currentValue: 0.0,
          unit: QuestUnit.minutes,
          bonusXp: 35.0,
          grantsInspiration: true,
          isCompleted: false,
        );
      case Attribute.wisdom:
        return DailyQuest(
          id: id,
          title: '$label: Quietude Interior',
          description: 'Dedique 10 minutos para meditação, escrita de diário ou caminhada consciente.',
          targetAttribute: attribute,
          targetValue: 10.0,
          currentValue: 0.0,
          unit: QuestUnit.minutes,
          bonusXp: 20.0,
          grantsInspiration: true,
          isCompleted: false,
        );
      case Attribute.charisma:
        return DailyQuest(
          id: id,
          title: '$label: Elo Humano',
          description: 'Conecte-se com alguém importante, pratique outro idioma ou fale em público.',
          targetAttribute: attribute,
          targetValue: 15.0,
          currentValue: 0.0,
          unit: QuestUnit.minutes,
          bonusXp: 20.0,
          grantsInspiration: true,
          isCompleted: false,
        );
    }
  }
}
