import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/core/game/quest_progress.dart';
import 'package:app/core/game/xp_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuestProgress.fromWorkout', () {
    test('séries por atributo e minutos divididos proporcionalmente', () {
      final credit = QuestProgress.fromWorkout(
        completedSetsByAttribute: {Attribute.strength: 9, Attribute.dexterity: 3},
        sessionDuration: const Duration(minutes: 60),
      );
      expect(credit.sets[Attribute.strength], 9);
      expect(credit.sets[Attribute.dexterity], 3);
      expect(credit.minutes[Attribute.strength], 45);
      expect(credit.minutes[Attribute.dexterity], 15);
    });

    test('treino esquecido aberto credita no máximo o teto de minutos', () {
      final credit = QuestProgress.fromWorkout(
        completedSetsByAttribute: {Attribute.constitution: 1},
        sessionDuration: const Duration(hours: 10),
      );
      expect(credit.minutes[Attribute.constitution], XpRules.questMaxMinutesPerWorkout);
    });

    test('treino sem séries concluídas não gera crédito', () {
      final credit = QuestProgress.fromWorkout(
        completedSetsByAttribute: const {},
        sessionDuration: const Duration(minutes: 40),
      );
      expect(credit.isEmpty, isTrue);
    });
  });

  group('QuestProgress.apply', () {
    const credit = QuestCredit(
      sets: {Attribute.strength: 4},
      minutes: {Attribute.strength: 30},
    );

    test('usa a unidade da missão', () {
      expect(
        QuestProgress.apply(credit: credit, attribute: Attribute.strength, unit: QuestUnit.sets, currentValue: 1, targetValue: 6),
        5,
      );
      expect(
        QuestProgress.apply(credit: credit, attribute: Attribute.strength, unit: QuestUnit.minutes, currentValue: 0, targetValue: 50),
        30,
      );
    });

    test('não passa do alvo e ignora outros atributos', () {
      expect(
        QuestProgress.apply(credit: credit, attribute: Attribute.strength, unit: QuestUnit.sets, currentValue: 5, targetValue: 6),
        6,
      );
      expect(
        QuestProgress.apply(credit: credit, attribute: Attribute.wisdom, unit: QuestUnit.minutes, currentValue: 2, targetValue: 10),
        2,
      );
    });

    test('sono de 8h conclui a missão de CON', () {
      final sleep = QuestProgress.fromSleep(hoursSlept: 8);
      expect(
        QuestProgress.apply(credit: sleep, attribute: Attribute.constitution, unit: QuestUnit.minutes, currentValue: 0, targetValue: 20),
        20,
      );
      expect(QuestProgress.fromSleep(hoursSlept: 7.5).isEmpty, isTrue);
    });
  });

  group('HeroProfile.validateName', () {
    test('aceita nomes válidos e recusa vazios/curtos/longos', () {
      expect(HeroProfile.validateName('Guts'), isNull);
      expect(HeroProfile.validateName('   '), isNotNull);
      expect(HeroProfile.validateName('A'), isNotNull);
      expect(HeroProfile.validateName('A' * (HeroProfile.maxNameLength + 1)), isNotNull);
    });
  });
}
