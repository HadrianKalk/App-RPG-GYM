import 'dart:math' as math;

import 'attributes.dart';
import 'class_resolver.dart';
import 'quest_progress.dart';

/// The three daily quest slots. Each day has exactly one quest per slot.
enum QuestSlot {
  /// Trains the hero's weakest attribute.
  overcome,

  /// Trains the primary attribute of the hero's current class.
  classDuty,

  /// A varied challenge on another attribute.
  dailyChallenge,
}

/// Static definition of the quest offered for one attribute.
///
/// This is the quest catalog: tweak targets/rewards here (or add new
/// attributes) without touching any screen. Texts live in the localized
/// game content under `quest.task.<attribute>.title` / `.description`.
final class QuestTemplate {
  const QuestTemplate({
    required this.targetValue,
    required this.unit,
    required this.bonusXp,
  });

  final double targetValue;
  final String unit;
  final double bonusXp;
}

abstract final class QuestCatalog {
  static const Map<Attribute, QuestTemplate> templates = {
    Attribute.strength: QuestTemplate(targetValue: 6, unit: QuestUnit.sets, bonusXp: 30),
    Attribute.dexterity: QuestTemplate(targetValue: 15, unit: QuestUnit.minutes, bonusXp: 25),
    Attribute.constitution: QuestTemplate(targetValue: 20, unit: QuestUnit.minutes, bonusXp: 25),
    Attribute.intelligence: QuestTemplate(targetValue: 50, unit: QuestUnit.minutes, bonusXp: 35),
    Attribute.wisdom: QuestTemplate(targetValue: 10, unit: QuestUnit.minutes, bonusXp: 20),
    Attribute.charisma: QuestTemplate(targetValue: 15, unit: QuestUnit.minutes, bonusXp: 20),
  };
}

/// A generated daily quest.
///
/// [titleKey] and [descriptionKey] are localization keys, never final
/// texts: `quest.slot.<slot>` and `quest.task.<attribute>`.
final class DailyQuest {
  const DailyQuest({
    required this.id,
    required this.slot,
    required this.titleKey,
    required this.descriptionKey,
    required this.targetAttribute,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.bonusXp,
    required this.grantsInspiration,
    required this.isCompleted,
  });

  final String id;
  final QuestSlot slot;
  final String titleKey;
  final String descriptionKey;
  final Attribute targetAttribute;
  final double targetValue;
  final double currentValue;
  final String unit;
  final double bonusXp;
  final bool grantsInspiration;
  final bool isCompleted;
}

abstract final class QuestGenerator {
  /// Deterministically generates the 3 daily quests for [date]:
  /// 1. overcome  -> the weakest attribute (lowest XP);
  /// 2. classDuty -> the class primary attribute (random for Adventurer);
  /// 3. dailyChallenge -> a random attribute different from the other two.
  static List<DailyQuest> generateDailyQuests({
    required DateTime date,
    required CharacterClass characterClass,
    required Map<Attribute, double> currentXpMap,
  }) {
    // Same date -> same seed -> same quests.
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = math.Random(seed);

    // Weakest attribute (first one wins on ties, in enum order).
    var lowestAttr = Attribute.strength;
    var lowestXp = double.infinity;
    for (final attr in Attribute.values) {
      final xp = currentXpMap[attr] ?? 0.0;
      if (xp < lowestXp) {
        lowestXp = xp;
        lowestAttr = attr;
      }
    }

    final classAttr = characterClass.primary ??
        Attribute.values[random.nextInt(Attribute.values.length)];

    final remaining = Attribute.values
        .where((a) => a != lowestAttr && a != classAttr)
        .toList();
    final variedAttr = remaining.isNotEmpty
        ? remaining[random.nextInt(remaining.length)]
        : Attribute.constitution;

    final dateStr = '${date.year}-${date.month}-${date.day}';
    return [
      _build(dateStr, QuestSlot.overcome, lowestAttr),
      _build(dateStr, QuestSlot.classDuty, classAttr),
      _build(dateStr, QuestSlot.dailyChallenge, variedAttr),
    ];
  }

  /// Builds one quest from the catalog template of [attribute].
  static DailyQuest _build(String dateStr, QuestSlot slot, Attribute attribute) {
    final template = QuestCatalog.templates[attribute]!;
    return DailyQuest(
      id: 'quest_${dateStr}_${slot.index + 1}',
      slot: slot,
      titleKey: 'quest.slot.${slot.name}',
      descriptionKey: 'quest.task.${attribute.name}',
      targetAttribute: attribute,
      targetValue: template.targetValue,
      currentValue: 0,
      unit: template.unit,
      bonusXp: template.bonusXp,
      grantsInspiration: true,
      isCompleted: false,
    );
  }
}
