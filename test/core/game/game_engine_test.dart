import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/xp_rules.dart';
import 'package:app/core/game/xp_calculator.dart';
import 'package:app/core/game/progression.dart';
import 'package:app/core/game/class_resolver.dart';
import 'package:app/core/game/quest_generator.dart';

void main() {
  group('XpCalculator - Retornos Decrescentes e Treinos', () {
    test('Calcula 60 minutos com 100% de eficiencia no primeiro bloco', () {
      final xp = XpCalculator.calculateXpWithDiminishingReturns(
        minutesAlreadyLoggedToday: 0.0,
        additionalMinutes: 60.0,
      );
      expect(xp, equals(60.0));
    });

    test('Calcula 150 minutos dividindo em faixas de eficiencia (60m 100% + 60m 75% + 30m 50%)', () {
      // 0-60 min: 60 * 1.0 = 60
      // 60-120 min: 60 * 0.75 = 45
      // 120-150 min: 30 * 0.50 = 15
      // Total = 120.0
      final xp = XpCalculator.calculateXpWithDiminishingReturns(
        minutesAlreadyLoggedToday: 0.0,
        additionalMinutes: 150.0,
      );
      expect(xp, equals(120.0));
    });

    test('Aplica intensidade alta (1.25x) corretamente', () {
      final xp = XpCalculator.calculateXpWithDiminishingReturns(
        minutesAlreadyLoggedToday: 0.0,
        additionalMinutes: 40.0,
        intensityMultiplier: XpRules.intensityHard,
      );
      expect(xp, equals(50.0)); // 40 * 1.25
    });

    test('Calcula série de treino com e sem recorde pessoal', () {
      final normalSet = XpCalculator.calculateWorkoutSetXp(intensity: 1.0, isPersonalRecord: false);
      expect(normalSet, equals(4.0));

      final prSet = XpCalculator.calculateWorkoutSetXp(intensity: 1.0, isPersonalRecord: true);
      expect(prSet, equals(29.0)); // 4.0 + 25.0
    });

    test('Curva diária zera após o teto de 300 unidades de esforço (máx 165 XP/dia por atributo)', () {
      // 0..60 (100%) = 60
      // 60..120 (75%) = 45
      // 120..180 (50%) = 30
      // 180..300 (25%) = 30
      // 300+ (0%) = 0 -> Total = 165.0
      final curve = XpCalculator.applyDailyCurve(
        alreadyLoggedToday: 0.0,
        rawEffortXp: 500.0,
      );
      expect(curve.earnedXp, equals(165.0));
      expect(curve.wasReduced, isTrue);

      final capped = XpCalculator.applyDailyCurve(
        alreadyLoggedToday: 300.0,
        rawEffortXp: 40.0,
      );
      expect(capped.earnedXp, equals(0.0));
      expect(capped.reachedCap, isTrue);
    });
  });

  group('Progression - Atributos e Niveis D&D', () {
    test('Modificadores seguem fielmente a regra D&D 5e: floor((score - 10) / 2)', () {
      expect(Progression.calculateModifier(10), equals(0));
      expect(Progression.calculateModifier(11), equals(0));
      expect(Progression.calculateModifier(12), equals(1));
      expect(Progression.calculateModifier(13), equals(1));
      expect(Progression.calculateModifier(14), equals(2));
      expect(Progression.calculateModifier(18), equals(4));
      expect(Progression.calculateModifier(9), equals(-1));
      expect(Progression.calculateModifier(8), equals(-1));
    });

    test('Atributo comeca em 10 e avanca com custo progressivo', () {
      final attr0 = Progression.calculateAttribute(Attribute.strength, 0.0);
      expect(attr0.score, equals(10));
      expect(attr0.modifier, equals(0));
      expect(attr0.progressPercent, equals(0.0));

      // Com 300 XP atinge pontuacao 11
      final attr1 = Progression.calculateAttribute(Attribute.strength, 300.0);
      expect(attr1.score, equals(11));
      expect(attr1.modifier, equals(0));
    });

    test('Nivel do personagem escala com o XP total', () {
      final lvl1 = Progression.calculateLevel(0.0);
      expect(lvl1.level, equals(1));

      final lvl2Req = XpRules.xpRequiredForLevel(2);
      final lvl2 = Progression.calculateLevel(lvl2Req.toDouble());
      expect(lvl2.level, equals(2));
    });
  });

  group('ClassResolver - Resolucao Emergente de Classes', () {
    test('Retorna Aventureiro quando atributos sao equilibrados', () {
      final map = {
        Attribute.strength: 100.0,
        Attribute.dexterity: 95.0,
        Attribute.constitution: 105.0,
        Attribute.intelligence: 100.0,
        Attribute.wisdom: 98.0,
        Attribute.charisma: 102.0,
      };
      expect(ClassResolver.resolveClass(map), equals(CharacterClass.adventurer));
    });

    test('FOR + CON resulta em Barbaro', () {
      final map = {
        Attribute.strength: 500.0,
        Attribute.constitution: 400.0,
        Attribute.dexterity: 50.0,
        Attribute.intelligence: 50.0,
        Attribute.wisdom: 50.0,
        Attribute.charisma: 50.0,
      };
      expect(ClassResolver.resolveClass(map), equals(CharacterClass.barbarian));
    });

    test('FOR + INT resulta em Cavaleiro Arcano', () {
      final map = {
        Attribute.strength: 600.0,
        Attribute.intelligence: 550.0,
        Attribute.constitution: 100.0,
        Attribute.dexterity: 100.0,
        Attribute.wisdom: 100.0,
        Attribute.charisma: 100.0,
      };
      expect(ClassResolver.resolveClass(map), equals(CharacterClass.eldritchKnight));
    });

    test('DES + SAB resulta em Monge', () {
      final map = {
        Attribute.dexterity: 800.0,
        Attribute.wisdom: 750.0,
        Attribute.strength: 80.0,
        Attribute.constitution: 80.0,
        Attribute.intelligence: 80.0,
        Attribute.charisma: 80.0,
      };
      expect(ClassResolver.resolveClass(map), equals(CharacterClass.monk));
    });

    test('INT + SAB resulta em Mago', () {
      final map = {
        Attribute.intelligence: 900.0,
        Attribute.wisdom: 850.0,
        Attribute.strength: 50.0,
        Attribute.constitution: 50.0,
        Attribute.dexterity: 50.0,
        Attribute.charisma: 50.0,
      };
      expect(ClassResolver.resolveClass(map), equals(CharacterClass.mage));
    });

    test('FOR + CAR resulta em Paladino', () {
      final map = {
        Attribute.strength: 600.0,
        Attribute.charisma: 550.0,
        Attribute.intelligence: 100.0,
        Attribute.constitution: 100.0,
        Attribute.dexterity: 100.0,
        Attribute.wisdom: 100.0,
      };
      expect(ClassResolver.resolveClass(map), equals(CharacterClass.paladin));
    });
  });

  group('QuestGenerator - Gerador Deterministico de Missoes', () {
    test('Gera 3 missoes identicas para o mesmo dia e estado', () {
      final date = DateTime(2026, 11, 14);
      final xpMap = {
        Attribute.strength: 100.0,
        Attribute.dexterity: 20.0, // Atributo mais baixo
        Attribute.constitution: 50.0,
        Attribute.intelligence: 80.0,
        Attribute.wisdom: 60.0,
        Attribute.charisma: 40.0,
      };

      final quests1 = QuestGenerator.generateDailyQuests(
        date: date,
        characterClass: CharacterClass.warrior,
        currentXpMap: xpMap,
      );

      final quests2 = QuestGenerator.generateDailyQuests(
        date: date,
        characterClass: CharacterClass.warrior,
        currentXpMap: xpMap,
      );

      expect(quests1.length, equals(3));
      expect(quests2.length, equals(3));

      for (int i = 0; i < 3; i++) {
        expect(quests1[i].id, equals(quests2[i].id));
        expect(quests1[i].titleKey, equals(quests2[i].titleKey));
        expect(quests1[i].targetAttribute, equals(quests2[i].targetAttribute));
        expect(quests1[i].targetValue, equals(quests2[i].targetValue));
      }

      // A missao 1 deve cobrir o atributo mais fraco (Destreza)
      expect(quests1[0].targetAttribute, equals(Attribute.dexterity));
    });
  });
}
