import 'dart:math' as math;

import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/class_resolver.dart';
import 'package:app/core/game/combat.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/core/game/legendary_bosses.dart';
import 'package:app/core/game/story.dart';
import 'package:app/features/story/domain/story_narrator.dart';
import 'package:app/features/story/domain/template_story_narrator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CombatStats sampleStats() => CombatStats.fromHero(
        level: 6,
        characterClass: CharacterClass.paladin,
        attributeScores: {for (final a in Attribute.values) a: 14},
      );

  HeroProfile sampleHero() => HeroProfile(
        name: 'Kael',
        form: HeroForm.masculine,
        origin: HeroOrigin.soldier,
        createdAt: DateTime(2026, 11, 1),
      );

  group('StoryEngine & StoryQuotaPolicy', () {
    test('MVP quota policy has no daily lock, while free tier enforces limit', () {
      expect(StoryQuotaPolicy.mvpDefault.canAdvanceTurn(0), isTrue);
      expect(StoryQuotaPolicy.mvpDefault.canAdvanceTurn(500), isTrue);
      expect(StoryQuotaPolicy.mvpDefault.remainingTurnsToday(5), isNull);

      const freePolicy = StoryQuotaPolicy(
        tier: StoryAccessTier.free,
        freeDailyTurnLimit: 3,
      );
      expect(freePolicy.canAdvanceTurn(2), isTrue);
      expect(freePolicy.canAdvanceTurn(3), isFalse);
      expect(freePolicy.remainingTurnsToday(2), 1);
    });

    test('startOrResumeWeeklyArc binds weekly Legendary Boss & habit seals', () {
      const habits = StoryHabitDigest(
        workoutsThisWeek: 3,
        questsCompletedThisWeek: 4,
        healthHabitsThisWeek: 2,
      );
      final arc = StoryEngine.startOrResumeWeeklyArc(
        now: DateTime(2026, 11, 16),
        habits: habits,
      );
      expect(arc.weekKey, '2026-W47');
      expect(arc.weaknessStacks, 6);
      expect(LegendaryBossCatalog.byId(arc.weeklyBossId), isNotNull);
    });

    test('rerollWithInspiration consumes Inspiration only when available', () {
      final stats = sampleStats();
      final failed = StoryEngine.resolveSkillCheck(
        hero: stats,
        attribute: Attribute.charisma,
        difficultyClass: 20,
        forcedD20: 2,
      );
      expect(failed.isHit, isFalse);

      final noInsp = StoryEngine.rerollWithInspiration(
        hero: stats,
        attribute: Attribute.charisma,
        difficultyClass: 20,
        availableInspiration: 0,
        previousRoll: failed,
        forcedD20: 20,
      );
      expect(noInsp.spentInspiration, isFalse);
      expect(noInsp.roll.naturalRoll, 2);

      final withInsp = StoryEngine.rerollWithInspiration(
        hero: stats,
        attribute: Attribute.charisma,
        difficultyClass: 20,
        availableInspiration: 2,
        previousRoll: failed,
        forcedD20: 19,
        random: math.Random(1),
      );
      expect(withInsp.spentInspiration, isTrue);
      expect(withInsp.roll.isHit, isTrue);
    });

    test('startStoryCombat launches weakened Legendary Boss encounters (0 XP)', () {
      final encounter = StoryEngine.startStoryCombat(
        hero: sampleStats(),
        spec: const StoryCombatSpec(
          tier: StoryCombatTier.legendary,
          opponentId: 'boss_satorion',
          weaknessStacks: 5,
          reason: 'Sanctum showdown',
        ),
        availableInspiration: 1,
      );
      expect(encounter.isLegendary, isTrue);
      expect(encounter.weaknessStacks, 5);
      expect(encounter.opponent.id, 'boss_satorion');
    });

    test('CampaignMemory round-trips compact JSON with bounded lists', () {
      var memory = const CampaignMemory();
      for (var i = 0; i < 10; i++) {
        memory = memory.append(
          visitedPlace: 'Place $i',
          summary: 'Summary $i',
          npcUpdate: StoryNpcMemory(
            id: 'npc_$i',
            name: 'NPC $i',
            attitude: 'ally',
            lastNote: 'Note $i',
          ),
          flagUpdates: {'k$i': 'v$i'},
        );
      }
      final decoded = CampaignMemory.decode(memory.encode());
      expect(decoded.visitedPlaces.length, 8);
      expect(decoded.npcs.length, 8);
      expect(decoded.recentSummaries.length, 6);
      expect(decoded.flags['k9'], 'v9');
    });
  });

  group('TemplateStoryNarrator (Offline-First)', () {
    test('interprets free-text boss challenge and skill checks in pt & en', () async {
      const narrator = TemplateStoryNarrator();
      const habits = StoryHabitDigest(
        workoutsToday: 1,
        workoutsThisWeek: 3,
        trainedAttributesToday: [Attribute.strength],
      );
      final arc = StoryEngine.startOrResumeWeeklyArc(
        now: DateTime(2026, 11, 16),
        habits: habits,
      );

      final openingPt = await narrator.advanceScene(
        StoryNarrationContext(
          languageCode: 'pt',
          heroProfile: sampleHero(),
          heroLevel: 6,
          effectiveClass: CharacterClass.paladin,
          heroStats: sampleStats(),
          arc: arc,
          habits: habits,
        ),
      );
      expect(openingPt.triggerType, StoryTriggerType.narrative);
      expect(openingPt.choices.length, 4);

      final checkEn = await narrator.advanceScene(
        StoryNarrationContext(
          languageCode: 'en',
          heroProfile: sampleHero(),
          heroLevel: 6,
          effectiveClass: CharacterClass.paladin,
          heroStats: sampleStats(),
          arc: arc,
          habits: habits,
          playerInput: 'I decipher the ancient runes',
        ),
      );
      expect(checkEn.triggerType, StoryTriggerType.skillCheck);
      expect(checkEn.skillCheck?.attribute, Attribute.intelligence);

      final bossChallenge = await narrator.advanceScene(
        StoryNarrationContext(
          languageCode: 'pt',
          heroProfile: sampleHero(),
          heroLevel: 6,
          effectiveClass: CharacterClass.paladin,
          heroStats: sampleStats(),
          arc: arc,
          habits: habits,
          playerInput: 'Vou desafiar o chefe lendário agora!',
        ),
      );
      expect(bossChallenge.triggerType, StoryTriggerType.combatTrigger);
      expect(bossChallenge.combatTrigger?.tier, StoryCombatTier.legendary);
      expect(bossChallenge.combatTrigger?.opponentId, arc.weeklyBossId);
    });
  });
}
