import 'dart:math' as math;

import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/class_resolver.dart';
import 'package:app/core/game/combat.dart';
import 'package:app/core/game/xp_rules.dart';
import 'package:flutter_test/flutter_test.dart';

/// Deterministic RNG for combat tests (always returns [fixedDouble] for
/// `nextDouble()`).
class _FixedRandom implements math.Random {
  _FixedRandom(this.fixedDouble);
  final double fixedDouble;

  @override
  bool nextBool() => fixedDouble < 0.5;

  @override
  double nextDouble() => fixedDouble;

  @override
  int nextInt(int max) => (fixedDouble * max).floor().clamp(0, max - 1);
}

void main() {
  group('ClassSkillCatalog & ArenaCatalog', () {
    test('every CharacterClass has a unique signature skill', () {
      final ids = <String>{};
      for (final c in CharacterClass.values) {
        final skill = ClassSkillCatalog.forClass(c);
        expect(skill.characterClass, c);
        expect(skill.focusCost, greaterThan(0));
        expect(skill.cooldownTurns, greaterThan(0));
        expect(ids.add(skill.id), isTrue, reason: 'duplicate skill id ${skill.id}');
      }
      expect(ids.length, CharacterClass.values.length);
    });

    test('ArenaCatalog opponents are ordered by recommendedLevel and have unique rewards', () {
      expect(ArenaCatalog.opponents, isNotEmpty);
      final npcIds = <String>{};
      final titleIds = <String>{};
      final cosmeticIds = <String>{};
      var lastLevel = 0;

      for (final npc in ArenaCatalog.opponents) {
        expect(npc.recommendedLevel, greaterThanOrEqualTo(lastLevel));
        lastLevel = npc.recommendedLevel;
        expect(npcIds.add(npc.id), isTrue);
        expect(titleIds.add(npc.reward.titleId), isTrue);
        expect(cosmeticIds.add(npc.reward.cosmeticId), isTrue);
        expect(ArenaCatalog.byId(npc.id), same(npc));
      }
      expect(ArenaCatalog.byId('unknown_npc'), isNull);
    });
  });

  group('CombatStats.fromHero', () {
    Map<Attribute, int> baseScores() => {
          for (final a in Attribute.values) a: XpRules.baseAttributeScore,
        };

    test('all 6 D&D attributes contribute to distinct combat stats', () {
      final base = CombatStats.fromHero(
        level: 3,
        characterClass: CharacterClass.warrior,
        attributeScores: baseScores(),
      );

      final highCon = CombatStats.fromHero(
        level: 3,
        characterClass: CharacterClass.warrior,
        attributeScores: {...baseScores(), Attribute.constitution: 16},
      );
      expect(highCon.maxHp, greaterThan(base.maxHp));
      expect(highCon.defense, greaterThan(base.defense));

      final highDex = CombatStats.fromHero(
        level: 3,
        characterClass: CharacterClass.rogue,
        attributeScores: {...baseScores(), Attribute.dexterity: 16},
      );
      expect(highDex.initiative, greaterThan(base.initiative));
      expect(highDex.dodgeChance, greaterThan(base.dodgeChance));

      final highInt = CombatStats.fromHero(
        level: 3,
        characterClass: CharacterClass.mage,
        attributeScores: {...baseScores(), Attribute.intelligence: 16},
      );
      expect(highInt.maxFocus, greaterThan(base.maxFocus));
      expect(
        highInt.attackPowerFor(Attribute.intelligence),
        greaterThan(base.attackPowerFor(Attribute.intelligence)),
      );

      final highWis = CombatStats.fromHero(
        level: 3,
        characterClass: CharacterClass.cleric,
        attributeScores: {...baseScores(), Attribute.wisdom: 16},
      );
      expect(highWis.healBonus, greaterThan(base.healBonus));
      expect(highWis.maxFocus, greaterThan(base.maxFocus));

      final highCha = CombatStats.fromHero(
        level: 3,
        characterClass: CharacterClass.paladin,
        attributeScores: {...baseScores(), Attribute.charisma: 16},
      );
      expect(highCha.critChance, greaterThan(base.critChance));
      expect(highCha.presenceMultiplier, greaterThan(base.presenceMultiplier));
    });

    test('Adventurer uses highest attribute as primaryAttackAttribute', () {
      final stats = CombatStats.fromHero(
        level: 2,
        characterClass: CharacterClass.adventurer,
        attributeScores: {
          ...baseScores(),
          Attribute.intelligence: 15,
        },
      );
      expect(stats.primaryAttackAttribute, Attribute.intelligence);
    });
  });

  group('ArenaTokenRules', () {
    test('totalEntriesToday combines free entries with real-world habit bonuses', () {
      expect(
        ArenaTokenRules.totalEntriesToday(
          workoutsToday: 0,
          questsCompletedToday: 0,
          healthHabitDoneToday: false,
        ),
        XpRules.arenaFreeDailyEntries,
      );

      expect(
        ArenaTokenRules.totalEntriesToday(
          workoutsToday: 1,
          questsCompletedToday: 2,
          healthHabitDoneToday: true,
        ),
        XpRules.arenaFreeDailyEntries + 1 + 2 + 1,
      );
    });
  });

  group('CombatEngine', () {
    final recruit = ArenaCatalog.opponents.first;
    final inquisitor = ArenaCatalog.opponents[3]; // 130 HP, 23 attack

    CombatStats makeHero({
      int level = 3,
      CharacterClass characterClass = CharacterClass.warrior,
      int score = 14,
    }) {
      return CombatStats.fromHero(
        level: level,
        characterClass: characterClass,
        attributeScores: {
          for (final a in Attribute.values) a: score,
        },
      );
    }

    test('basicStrike deals damage, restores Focus, and advances enemy intent', () {
      final hero = makeHero();
      final initial = CombatEngine.start(hero: hero, opponent: inquisitor);
      final afterTurn1 = CombatEngine.executeTurn(
        initial,
        CombatAction.basicStrike,
        random: _FixedRandom(0.99), // no dodge, no crit
      );

      expect(afterTurn1.enemyHp, lessThan(inquisitor.maxHp));
      expect(afterTurn1.heroHp, lessThan(hero.maxHp));
      expect(afterTurn1.turn, 2);
      expect(afterTurn1.enemyIntent, EnemyIntent.heavyBlow);
      expect(
        afterTurn1.log.any((e) => e.kind == CombatLogKind.heroBasicStrike),
        isTrue,
      );
    });

    test('classSkill consumes Focus, sets cooldown, and Warrior hits twice', () {
      final hero = makeHero(characterClass: CharacterClass.warrior);
      final initial = CombatEngine.start(hero: hero, opponent: inquisitor);
      final skill = initial.skill;
      expect(skill.hitsTwice, isTrue);

      final afterSkill = CombatEngine.executeTurn(
        initial,
        CombatAction.classSkill,
        random: _FixedRandom(0.99),
      );

      expect(afterSkill.heroFocus, hero.maxFocus - skill.focusCost);
      expect(afterSkill.heroSkillCooldown, skill.cooldownTurns);
      expect(afterSkill.canUseClassSkill, isFalse);
      expect(
        afterSkill.log.any(
          (e) => e.kind == CombatLogKind.heroClassSkill && e.skillId == skill.id,
        ),
        isTrue,
      );
    });

    test('Monk Stunning Strike stuns opponent and skips enemy attack that round', () {
      final monk = makeHero(characterClass: CharacterClass.monk);
      final initial = CombatEngine.start(hero: monk, opponent: inquisitor);

      final afterStun = CombatEngine.executeTurn(
        initial,
        CombatAction.classSkill,
        random: _FixedRandom(0.99),
      );

      // Enemy was stunned on turn 1, so hero took 0 damage!
      expect(afterStun.status, CombatStatus.ongoing);
      expect(afterStun.heroHp, monk.maxHp);
      expect(
        afterStun.log.any((e) => e.kind == CombatLogKind.enemyStunned),
        isTrue,
      );
    });

    test('Paladin Divine Smite deals damage and heals the hero', () {
      final paladin = makeHero(characterClass: CharacterClass.paladin);
      final initial = CombatEngine.start(hero: paladin, opponent: inquisitor);
      // Take a hit first
      final wounded = CombatEngine.executeTurn(
        initial,
        CombatAction.basicStrike,
        random: _FixedRandom(0.99),
      );
      expect(wounded.heroHp, lessThan(paladin.maxHp));

      final afterSmite = CombatEngine.executeTurn(
        wounded,
        CombatAction.classSkill,
        random: _FixedRandom(0.99),
      );
      final smiteLog = afterSmite.log.firstWhere(
        (e) => e.kind == CombatLogKind.heroClassSkill,
      );
      expect(smiteLog.heal, greaterThan(0));
    });

    test('defend reduces incoming heavy blow damage by 50% and restores Focus + HP', () {
      final hero = makeHero();
      final t1 = CombatEngine.start(hero: hero, opponent: inquisitor);
      // Turn 1 -> Turn 2 sets enemyIntent to heavyBlow
      final t2 = CombatEngine.executeTurn(
        t1,
        CombatAction.classSkill,
        random: _FixedRandom(0.99),
      );
      expect(t2.status, CombatStatus.ongoing);
      expect(t2.enemyIntent, EnemyIntent.heavyBlow);

      final noDefend = CombatEngine.executeTurn(
        t2,
        CombatAction.basicStrike,
        random: _FixedRandom(0.99),
      );
      final withDefend = CombatEngine.executeTurn(
        t2,
        CombatAction.defend,
        random: _FixedRandom(0.99),
      );

      final enemyDmgNoDefend = noDefend.log
          .lastWhere((e) => e.kind == CombatLogKind.enemyHeavyBlow)
          .damage;
      final enemyDmgWithDefend = withDefend.log
          .lastWhere((e) => e.kind == CombatLogKind.enemyHeavyBlow)
          .damage;

      expect(enemyDmgWithDefend, lessThan(enemyDmgNoDefend));
      expect(withDefend.heroFocus, greaterThan(t2.heroFocus));
    });

    test('heroicInspiration guarantees a critical hit and can only be used once per battle', () {
      final hero = makeHero();
      final start = CombatEngine.start(
        hero: hero,
        opponent: recruit,
        availableInspiration: 2,
      );
      expect(start.canUseInspiration, isTrue);

      final afterInsp = CombatEngine.executeTurn(
        start,
        CombatAction.heroicInspiration,
        random: _FixedRandom(0.99), // even with 0.99, crit is forced
      );

      expect(afterInsp.inspirationUsed, isTrue);
      expect(afterInsp.availableInspiration, 1);
      expect(afterInsp.canUseInspiration, isFalse);
      final entry = afterInsp.log.firstWhere(
        (e) => e.kind == CombatLogKind.heroInspirationStrike,
      );
      expect(entry.isCritical, isTrue);
      expect(entry.damage, greaterThan(0));
    });

    test('encounter ends in victory when opponent HP reaches 0', () {
      final strongHero = makeHero(level: 12, score: 18);
      var state = CombatEngine.start(hero: strongHero, opponent: recruit);
      while (state.status == CombatStatus.ongoing) {
        state = CombatEngine.executeTurn(
          state,
          CombatAction.basicStrike,
          random: _FixedRandom(0.99),
        );
      }
      expect(state.status, CombatStatus.victory);
      expect(state.enemyHp, 0);
      expect(state.log.last.kind, CombatLogKind.victory);
    });

    test('encounter ends in defeat when hero HP reaches 0', () {
      final weakHero = makeHero(level: 1, score: 8);
      final boss = ArenaCatalog.opponents.last;
      var state = CombatEngine.start(hero: weakHero, opponent: boss);
      while (state.status == CombatStatus.ongoing) {
        state = CombatEngine.executeTurn(
          state,
          CombatAction.basicStrike,
          random: _FixedRandom(0.99),
        );
      }
      expect(state.status, CombatStatus.defeat);
      expect(state.heroHp, 0);
      expect(state.log.last.kind, CombatLogKind.defeat);
    });
  });

  group('ClassResolver.unlockedClasses & effectiveClass (Decision #41)', () {
    test('unlocks classes whose primary and secondary attributes reach score >= 12, and never unlocks untrained classes', () {
      // 1200 XP in STR, DEX, and INT -> score >= 12 in STR, DEX, INT; 0 XP in WIS/CHA/CON -> score 10
      final xpMap = <Attribute, double>{
        Attribute.strength: 1200,
        Attribute.dexterity: 1200,
        Attribute.intelligence: 1200,
        Attribute.constitution: 0,
        Attribute.wisdom: 0,
        Attribute.charisma: 0,
      };

      final unlocked = ClassResolver.unlockedClasses(xpMap);
      expect(unlocked.contains(CharacterClass.adventurer), isTrue);
      expect(unlocked.contains(CharacterClass.warrior), isTrue); // STR + DEX
      expect(unlocked.contains(CharacterClass.eldritchKnight), isTrue); // STR + INT
      expect(unlocked.contains(CharacterClass.rogue), isTrue); // DEX + INT

      // Mage requires INT + WIS >= 12, but WIS is 10 -> must remain locked!
      expect(unlocked.contains(CharacterClass.mage), isFalse);
      expect(
        ClassResolver.effectiveClass(
          attributeXpMap: xpMap,
          selectedClass: CharacterClass.rogue,
        ),
        CharacterClass.rogue,
      );
      expect(
        ClassResolver.effectiveClass(
          attributeXpMap: xpMap,
          selectedClass: CharacterClass.mage, // locked -> falls back to emergent
        ),
        ClassResolver.resolveClass(xpMap),
      );
    });
  });

  group('TournamentCatalog & Gauntlet progression (Step 5C)', () {
    test('TournamentCatalog scales opponents according to statScale and advances rounds with partial recovery', () {
      final bronze = TournamentCatalog.byId('tournament_bronze')!;
      final obsidian = TournamentCatalog.byId('tournament_obsidian')!;
      expect(bronze.statScale, lessThan(1.0));
      expect(obsidian.statScale, greaterThan(1.0));

      final baseRecruit = ArenaCatalog.byId('npc_ash_recruit')!;
      final scaledRecruit = bronze.scaledOpponents.first;
      expect(scaledRecruit.maxHp, lessThan(baseRecruit.maxHp));

      final hero = CombatStats.fromHero(
        level: 10,
        characterClass: CharacterClass.warrior,
        attributeScores: {for (final a in Attribute.values) a: 16},
      );
      var run = CombatEngine.startTournament(
        hero: hero,
        tournament: bronze,
        availableInspiration: 1,
      );
      expect(run.currentRoundNumber, 1);
      expect(run.totalRounds, 3);

      // Clear round 1
      var enc = run.encounter;
      while (enc.status == CombatStatus.ongoing) {
        enc = CombatEngine.executeTurn(
          enc,
          CombatAction.basicStrike,
          random: _FixedRandom(0.99),
        );
      }
      run = TournamentRun(
        tournament: run.tournament,
        rounds: run.rounds,
        roundIndex: run.roundIndex,
        encounter: enc,
      );
      expect(run.isRoundVictory, isTrue);
      expect(run.isTournamentVictory, isFalse);

      // Advance to round 2 -> HP & Focus recover partially
      final round2 = CombatEngine.advanceTournamentRound(run);
      expect(round2.currentRoundNumber, 2);
      expect(round2.encounter.status, CombatStatus.ongoing);
      expect(round2.encounter.opponent.id, 'npc_iron_sentinel');
    });
  });

  group('D20 Roll Mechanics, Critical Hit (20) & Critical Fumble (1)', () {
    test('Natural 20 guarantees criticalHit (2x damage), Natural 1 causes criticalFumble, and d20 + Attribute scales hit & damage', () {
      final hero = CombatStats.fromHero(
        level: 4,
        characterClass: CharacterClass.warrior,
        attributeScores: {for (final a in Attribute.values) a: 14},
      );
      final inquisitor = ArenaCatalog.byId('npc_blood_inquisitor')!;
      final start = CombatEngine.start(hero: hero, opponent: inquisitor);

      // 1. Natural 20 -> Critical Hit (2x damage)
      final on20 = CombatEngine.executeTurn(
        start,
        CombatAction.basicStrike,
        random: _FixedRandom(0.99),
        forcedD20: 20,
      );
      expect(on20.lastRoll, isNotNull);
      expect(on20.lastRoll!.naturalRoll, 20);
      expect(on20.lastRoll!.outcome, D20Outcome.criticalHit);
      final critDmg = on20.log
          .firstWhere((e) => e.kind == CombatLogKind.heroBasicStrike)
          .damage;

      // 2. Normal Hit (roll 15) vs Lower Hit (roll 10) -> 15 deals more damage than 10
      final on15 = CombatEngine.executeTurn(
        start,
        CombatAction.basicStrike,
        random: _FixedRandom(0.99),
        forcedD20: 15,
      );
      final on10 = CombatEngine.executeTurn(
        start,
        CombatAction.basicStrike,
        random: _FixedRandom(0.99),
        forcedD20: 10,
      );
      final dmg15 = on15.log
          .firstWhere((e) => e.kind == CombatLogKind.heroBasicStrike)
          .damage;
      final dmg10 = on10.log
          .firstWhere((e) => e.kind == CombatLogKind.heroBasicStrike)
          .damage;
      expect(critDmg, greaterThan(dmg15));
      expect(dmg15, greaterThan(dmg10));

      // 3. Low roll below AC (roll 2 + bonus 4 = 6 < AC 14) -> Miss!
      final onMiss = CombatEngine.executeTurn(
        start,
        CombatAction.basicStrike,
        random: _FixedRandom(0.99),
        forcedD20: 2,
      );
      expect(onMiss.lastRoll!.outcome, D20Outcome.miss);
      expect(onMiss.enemyHp, inquisitor.maxHp);

      // 4. Natural 1 -> Critical Fumble (0 enemy damage + self recoil damage)
      final on1 = CombatEngine.executeTurn(
        start,
        CombatAction.basicStrike,
        random: _FixedRandom(0.0), // hero dodges enemy follow-up so we isolate fumble damage
        forcedD20: 1,
      );
      expect(on1.lastRoll!.naturalRoll, 1);
      expect(on1.lastRoll!.outcome, D20Outcome.criticalFumble);
      expect(on1.enemyHp, inquisitor.maxHp);
      expect(on1.heroHp, lessThan(hero.maxHp));
      expect(
        on1.log.any((e) => e.kind == CombatLogKind.heroCriticalFumble),
        isTrue,
      );
    });
  });

  group('DungeonCatalog & Multi-Room Exploration (Step 5D)', () {
    test('Dungeon rooms test 6 attributes with d20 checks and transition into the Boss fight', () {
      final crypt = DungeonCatalog.byId('dungeon_sunken_crypt')!;
      final hero = CombatStats.fromHero(
        level: 5,
        characterClass: CharacterClass.warrior,
        attributeScores: {for (final a in Attribute.values) a: 14},
      );

      var run = CombatEngine.startDungeon(hero: hero, dungeon: crypt);
      expect(run.inBossPhase, isFalse);
      expect(run.currentRoomNumber, 1);

      // Room 1: pass check with d20 = 18 -> Blessing (+1)
      run = CombatEngine.resolveDungeonRoom(run, forcedD20: 18);
      expect(run.roomResolved, isTrue);
      expect(run.lastRoomRoll!.isHit, isTrue);
      expect(run.blessingsEarned, 1);
      run = CombatEngine.advanceDungeon(run);
      expect(run.currentRoomNumber, 2);

      // Room 2: fail check with d20 = 2 -> Trap damage
      final hpBeforeTrap = run.heroHp;
      run = CombatEngine.resolveDungeonRoom(run, forcedD20: 2);
      expect(run.lastRoomRoll!.isHit, isFalse);
      expect(run.heroHp, lessThan(hpBeforeTrap));
      run = CombatEngine.advanceDungeon(run);
      expect(run.currentRoomNumber, 3);

      // Room 3: cautious bypass -> advances to Boss Phase carrying earned blessings!
      run = CombatEngine.bypassDungeonRoom(run);
      expect(run.lastRoomBypassed, isTrue);
      run = CombatEngine.advanceDungeon(run);
      expect(run.inBossPhase, isTrue);
      expect(run.bossEncounter, isNotNull);
      expect(run.bossEncounter!.heroBuffTurns, 1);
    });
  });
}
