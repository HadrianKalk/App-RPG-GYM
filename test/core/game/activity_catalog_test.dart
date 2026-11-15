import 'package:app/core/game/activity_catalog.dart';
import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/xp_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityCatalog', () {
    test('covers every catalog attribute with unique ids and positive presets', () {
      final ids = <String>{};
      for (final entry in ActivityCatalog.entries) {
        expect(ids.add(entry.id), isTrue, reason: 'duplicate id ${entry.id}');
        expect(entry.presetsMinutes, isNotEmpty);
        expect(entry.presetsMinutes.every((m) => m > 0), isTrue);
      }

      for (final attr in ActivityCatalog.catalogAttributes) {
        expect(
          ActivityCatalog.forAttribute(attr),
          isNotEmpty,
          reason: '$attr must have at least one catalog activity',
        );
      }
    });

    test('byId finds known entries and returns null for unknown ids', () {
      expect(ActivityCatalog.byId('act_oratory')?.attribute, Attribute.charisma);
      expect(ActivityCatalog.byId('act_stretching')?.attribute, Attribute.dexterity);
      expect(ActivityCatalog.byId('unknown_id'), isNull);
    });
  });

  group('HealthRules - Hydration', () {
    test('awards cup XP up to the goal and grants bonus + quest credit on goal', () {
      var cups = 0;
      var rewarded = 0;
      var bonusClaimed = false;
      const goal = 4;

      // Cups 1..3: only cup XP, no goal bonus yet.
      for (var i = 1; i <= 3; i++) {
        final r = HealthRules.applyWaterDelta(
          currentCups: cups,
          rewardedCups: rewarded,
          goalBonusClaimed: bonusClaimed,
          goalCups: goal,
          delta: 1,
        );
        expect(r.cups, i);
        expect(r.cupXp, XpRules.xpPerWaterCup);
        expect(r.goalBonusXp, 0);
        expect(r.questCredit.isEmpty, isTrue);
        cups = r.cups;
        rewarded = r.rewardedCups;
        bonusClaimed = r.goalBonusClaimed;
      }

      // Cup 4 hits the goal: cup XP + goal bonus + CON quest credit.
      final hit = HealthRules.applyWaterDelta(
        currentCups: cups,
        rewardedCups: rewarded,
        goalBonusClaimed: bonusClaimed,
        goalCups: goal,
        delta: 1,
      );
      expect(hit.cups, 4);
      expect(hit.cupXp, XpRules.xpPerWaterCup);
      expect(hit.goalBonusXp, XpRules.waterGoalBonusXp);
      expect(hit.justReachedGoal, isTrue);
      expect(
        hit.questCredit.minutes[Attribute.constitution],
        XpRules.waterGoalQuestMinutes,
      );

      // Cup 5 (above goal): counted on UI, 0 extra XP.
      final extra = HealthRules.applyWaterDelta(
        currentCups: hit.cups,
        rewardedCups: hit.rewardedCups,
        goalBonusClaimed: hit.goalBonusClaimed,
        goalCups: goal,
        delta: 1,
      );
      expect(extra.cups, 5);
      expect(extra.totalXp, 0);
    });

    test('decrementing and re-adding a cup never duplicates XP', () {
      final first = HealthRules.applyWaterDelta(
        currentCups: 0,
        rewardedCups: 0,
        goalBonusClaimed: false,
        goalCups: 8,
        delta: 1,
      );
      expect(first.cupXp, XpRules.xpPerWaterCup);

      final dec = HealthRules.applyWaterDelta(
        currentCups: first.cups,
        rewardedCups: first.rewardedCups,
        goalBonusClaimed: first.goalBonusClaimed,
        goalCups: 8,
        delta: -1,
      );
      expect(dec.cups, 0);
      expect(dec.rewardedCups, 1);
      expect(dec.totalXp, 0);

      final reAdd = HealthRules.applyWaterDelta(
        currentCups: dec.cups,
        rewardedCups: dec.rewardedCups,
        goalBonusClaimed: dec.goalBonusClaimed,
        goalCups: 8,
        delta: 1,
      );
      expect(reAdd.cups, 1);
      expect(reAdd.totalXp, 0, reason: 'cup #1 was already rewarded today');
    });
  });

  group('HealthRules - Sleep & Diet', () {
    test('sleep tiers reward ideal window (7-9h) highest', () {
      expect(HealthRules.sleepBaseMinutes(8.0), XpRules.sleepIdealXp);
      expect(HealthRules.sleepBaseMinutes(6.0), XpRules.sleepModerateXp);
      expect(HealthRules.sleepBaseMinutes(4.5), XpRules.sleepLowXp);
    });

    test('diet rewards onTrack higher than partial and credits CON quest', () {
      final onTrack = HealthRules.dietReward(DietAdherence.onTrack);
      final partial = HealthRules.dietReward(DietAdherence.partial);
      expect(onTrack.baseXp, greaterThan(partial.baseXp));
      expect(
        onTrack.questCredit.minutes[Attribute.constitution],
        XpRules.dietOnTrackQuestMinutes,
      );
    });
  });
}
