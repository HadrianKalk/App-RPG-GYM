import 'package:app/core/game/activity_catalog.dart';
import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/class_resolver.dart';
import 'package:app/core/game/combat.dart';
import 'package:app/core/game/exercise_taxonomy.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/core/game/quest_generator.dart';
import 'package:app/data/seed/exercise_seed.dart';
import 'package:app/l10n/content/game_content_en.dart';
import 'package:app/l10n/content/game_content_pt.dart';
import 'package:app/l10n/game_text.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the "every visible text is translated" rule for game content.
void main() {
  test('pt and en have exactly the same keys', () {
    expect(gameContentEn.keys.toSet(), gameContentPt.keys.toSet());
  });

  test('every engine/catalog identifier has a text in every language', () {
    final required = <String>[
      for (final a in Attribute.values) ...['attribute.${a.name}.name', 'attribute.${a.name}.code', 'attribute.${a.name}.description'],
      for (final c in CharacterClass.values) ...['class.${c.name}.title', 'class.${c.name}.lore'],
      for (final f in HeroForm.values) ...['heroForm.${f.name}.label', 'heroForm.${f.name}.title'],
      for (final o in HeroOrigin.values) ...['origin.${o.name}.name', 'origin.${o.name}.description'],
      for (final s in QuestSlot.values) 'quest.slot.${s.name}',
      for (final a in QuestCatalog.templates.keys) ...['quest.task.${a.name}.title', 'quest.task.${a.name}.description'],
      for (final t in QuestCatalog.templates.values) 'questUnit.${t.unit}',
      for (final m in MuscleGroup.values) 'muscle.${m.name}',
      for (final e in Equipment.values) 'equipment.${e.name}',
      for (final e in ExerciseSeed.defaultExercises) ...['exercise.${e.id}', 'exercise.${e.id}.guide'],
      for (final a in ActivityCatalog.entries) ...['activity.${a.id}.name', 'activity.${a.id}.description'],
      for (final s in ClassSkillCatalog.byClass.values) ...['skill.${s.id}.name', 'skill.${s.id}.description'],
      for (final npc in ArenaCatalog.opponents) ...[
        'arenaNpc.${npc.id}.name',
        'arenaNpc.${npc.id}.lore',
        'combatTitle.${npc.reward.titleId}',
        'combatCosmetic.${npc.reward.cosmeticId}',
      ],
      for (final t in TournamentCatalog.tournaments) ...[
        'tournament.${t.id}.name',
        'tournament.${t.id}.lore',
        'combatTitle.${t.reward.titleId}',
        'combatCosmetic.${t.reward.cosmeticId}',
      ],
      for (final d in DungeonCatalog.dungeons) ...[
        'dungeon.${d.id}.name',
        'dungeon.${d.id}.lore',
        'combatTitle.${d.reward.titleId}',
        'combatCosmetic.${d.reward.cosmeticId}',
        for (final r in d.rooms) ...[
          'dungeonRoom.${r.id}.name',
          'dungeonRoom.${r.id}.description',
        ],
      ],
    ];
    for (final lang in GameText.supportedLanguages) {
      final text = GameText(lang);
      final missing = required.where((k) => !text.has(k)).toList();
      expect(missing, isEmpty, reason: 'missing in "$lang"');
    }
  });

  test('quest rows created before localization keep their stored text', () {
    final text = GameText('en');
    expect(text.questTitle('Superação: O Peso do Ferro', 'Conclua 6 séries'), 'Superação: O Peso do Ferro');
    expect(text.questTitle('quest.slot.overcome', 'quest.task.strength'), 'Overcome: The Weight of Iron');
  });

  test('unknown language falls back to Portuguese', () {
    expect(GameText('xx').attributeName(Attribute.strength), 'Força');
  });
}
