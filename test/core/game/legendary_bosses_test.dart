import 'dart:math' as math;

import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/class_resolver.dart';
import 'package:app/core/game/combat.dart';
import 'package:app/core/game/legendary_bosses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CombatStats sampleHero({
    int level = 10,
    CharacterClass characterClass = CharacterClass.warrior,
    int score = 18,
  }) {
    return CombatStats.fromHero(
      level: level,
      characterClass: characterClass,
      attributeScores: {for (final a in Attribute.values) a: score},
    );
  }

  group('LegendaryBossCatalog (18 Weekly Legendary Bosses)', () {
    test('contains all 18 unique bosses with unique rewards', () {
      expect(LegendaryBossCatalog.bosses.length, 18);
      final ids = LegendaryBossCatalog.bosses.map((b) => b.id).toSet();
      final titles =
          LegendaryBossCatalog.bosses.map((b) => b.reward.titleId).toSet();
      final cosmetics =
          LegendaryBossCatalog.bosses.map((b) => b.reward.cosmeticId).toSet();
      expect(ids.length, 18);
      expect(titles.length, 18);
      expect(cosmetics.length, 18);
    });

    test('weekly habit seals weaken boss HP, attack, and barriers', () {
      final satorion = LegendaryBossCatalog.byId('boss_satorion')!;
      final hero = sampleHero(level: 10);

      final fullStrength = CombatEngine.startLegendary(
        hero: hero,
        boss: satorion,
        weaknessStacks: 0,
      );
      final weakened = CombatEngine.startLegendary(
        hero: hero,
        boss: satorion,
        weaknessStacks: 6,
      );

      expect(weakened.opponent.maxHp, lessThan(fullStrength.opponent.maxHp));
      expect(weakened.opponent.attack, lessThan(fullStrength.opponent.attack));
      expect(
        weakened.legendaryBarrierTurns,
        lessThan(fullStrength.legendaryBarrierTurns),
      );
    });

    test('forWeek cycles deterministically across weeks', () {
      final w1 = LegendaryBossCatalog.forWeek(DateTime(2026, 1, 5));
      final w2 = LegendaryBossCatalog.forWeek(DateTime(2026, 1, 12));
      expect(w1.id, isNot(w2.id));
      expect(
        LegendaryBossCatalog.forWeek(DateTime(2026, 1, 7)).id,
        w1.id,
      );
    });
  });

  group('Legendary D&D Mechanics in CombatEngine', () {
    test('Infinity Barrier raises AC and is pierced on Natural 20', () {
      final satorion = LegendaryBossCatalog.byId('boss_satorion')!;
      final start = CombatEngine.startLegendary(
        hero: sampleHero(),
        boss: satorion,
        weaknessStacks: 0,
      );
      expect(start.legendaryBarrierTurns, greaterThan(0));
      expect(start.effectiveArmorClass, start.opponent.armorClass + 4);

      final afterCrit = CombatEngine.executeTurn(
        start,
        CombatAction.basicStrike,
        random: math.Random(1),
        forcedD20: 20,
      );
      expect(afterCrit.legendaryBarrierTurns, 0);
      expect(
        afterCrit.log.any((e) => e.kind == CombatLogKind.legendaryBarrierPierced),
        isTrue,
      );
    });

    test('Armor Plates crack under Class Skill and raise AC while active', () {
      final reinor = LegendaryBossCatalog.byId('boss_reinor')!;
      final start = CombatEngine.startLegendary(
        hero: sampleHero(characterClass: CharacterClass.warrior),
        boss: reinor,
      );
      final initialPlates = start.legendaryPlateStacks;
      expect(initialPlates, greaterThan(0));
      expect(start.effectiveArmorClass, greaterThan(start.opponent.armorClass));

      final afterSkill = CombatEngine.executeTurn(
        start,
        CombatAction.classSkill,
        random: math.Random(2),
        forcedD20: 19,
      );
      expect(afterSkill.legendaryPlateStacks, lessThan(initialPlates));
      expect(
        afterSkill.log.any((e) => e.kind == CombatLogKind.legendaryPlateBroken),
        isTrue,
      );
    });

    test('Tactical Adaptation increases AC when repeating the same action', () {
      final meruvor = LegendaryBossCatalog.byId('boss_meruvor')!;
      var state = CombatEngine.startLegendary(
        hero: sampleHero(),
        boss: meruvor,
      );
      final baseAc = state.effectiveArmorClass;

      state = CombatEngine.executeTurn(
        state,
        CombatAction.basicStrike,
        random: math.Random(3),
        forcedD20: 18,
      );
      state = CombatEngine.executeTurn(
        state,
        CombatAction.basicStrike,
        random: math.Random(3),
        forcedD20: 18,
      );
      expect(state.repeatedHeroActionCount, 2);
      expect(state.effectiveArmorClass, greaterThanOrEqualTo(baseAc + 3));
    });

    test('Counter Stance strikes back on non-crit basic attacks', () {
      final netherion = LegendaryBossCatalog.byId('boss_netherion')!;
      final start = CombatEngine.startLegendary(
        hero: sampleHero(),
        boss: netherion,
      );
      final afterBasic = CombatEngine.executeTurn(
        start,
        CombatAction.basicStrike,
        random: math.Random(4),
        forcedD20: 18,
      );
      expect(
        afterBasic.log.any((e) => e.kind == CombatLogKind.legendaryCounter),
        isTrue,
      );
    });

    test('Bleed Sanctuary applies bleed cleared partially by Defend', () {
      final ryomoth = LegendaryBossCatalog.byId('boss_ryomoth')!;
      var state = CombatEngine.startLegendary(
        hero: sampleHero(score: 12, level: 4),
        boss: ryomoth,
      );
      state = CombatEngine.executeTurn(
        state,
        CombatAction.basicStrike,
        random: _FixedZeroDoubleRandom(),
        forcedD20: 10,
      );
      expect(state.heroBleedStacks, greaterThanOrEqualTo(1));
      expect(
        state.log.any((e) => e.kind == CombatLogKind.legendaryBleedTick),
        isTrue,
      );

      final defended = CombatEngine.executeTurn(
        state,
        CombatAction.defend,
        random: _FixedZeroDoubleRandom(),
      );
      expect(defended.heroBleedStacks, 0);
    });
  });
}

class _FixedZeroDoubleRandom implements math.Random {
  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0.99; // ensures hero never dodges in deterministic test

  @override
  int nextInt(int max) => 1;
}
