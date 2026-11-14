import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../app/ui/game_app_bar.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../app/ui/segmented_bar.dart';
import '../../../core/game/attributes.dart';
import '../../../data/database.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';

/// Today's three quests. Progress is automatic (fed by workouts and
/// activities); this screen only displays it.
class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final questsAsync = ref.watch(todayQuestsStreamProvider);
    final charAsync = ref.watch(characterStreamProvider);

    return Scaffold(
      appBar: GameAppBar(title: l10n.questsTitle),
      body: questsAsync.when(
        data: (quests) {
          if (quests.isEmpty && charAsync.hasValue) {
            // First visit of the day: generate (idempotent) and wait for the stream.
            ref.read(questRepositoryProvider).ensureTodayQuestsGenerated(charAsync.value!);
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              PixelFrame(
                child: Row(
                  children: [
                    const PixelIcon(PixelIcons.scroll, size: 26, color: AppTheme.emberGold),
                    const SizedBox(width: 12),
                    Expanded(child: Text(l10n.questsBanner, style: const TextStyle(color: AppTheme.ashWhite, fontSize: 13))),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 6),
                child: Text(l10n.questsToday, style: Theme.of(context).textTheme.titleLarge),
              ),
              for (final q in quests) _QuestCard(quest: q),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.loadError('$err'))),
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  const _QuestCard({required this.quest});

  final DailyQuestsTableData quest;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final isDone = quest.isCompleted;
    final progress = quest.targetValue > 0 ? quest.currentValue / quest.targetValue : 0.0;
    final attrColor = AppTheme.attributeColor(quest.targetAttribute);

    return PixelFrame(
      highlight: isDone,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isDone) ...[
                const PixelIcon(PixelIcons.check, size: 18, color: AppTheme.emberGold),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  game.questTitle(quest.title, quest.description),
                  style: display.style(21, color: isDone ? AppTheme.emberGold : AppTheme.ashWhite),
                ),
              ),
              PixelTag(text: game.attributeCode(quest.targetAttribute), color: attrColor, fontSize: 15),
            ],
          ),
          const SizedBox(height: 4),
          Text(game.questDescription(quest.description), style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.questProgress(quest.currentValue.toInt(), quest.targetValue.toInt(), game.questUnit(quest.unit)),
                  style: display.style(17),
                ),
              ),
              if (quest.grantsInspiration) ...[
                const PixelIcon(PixelIcons.star, size: 13, color: AppTheme.emberGold),
                Text(' +1  ', style: display.style(17, color: AppTheme.emberGold)),
              ],
              Text(l10n.xpGain('${quest.bonusXp.toInt()}'), style: display.style(17, color: AppTheme.emberGold)),
            ],
          ),
          const SizedBox(height: 5),
          SegmentedBar(value: progress, color: isDone ? AppTheme.emberGold : AppTheme.bloodCrimson),
          if (!isDone) ...[
            const SizedBox(height: 6),
            _QuestHint(attribute: quest.targetAttribute),
          ],
        ],
      ),
    );
  }
}

/// Explains how a quest advances and links to the right tab.
class _QuestHint extends StatelessWidget {
  const _QuestHint({required this.attribute});

  final Attribute attribute;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (String hint, String? route) = switch (attribute) {
      Attribute.strength => (l10n.questHintStrength, '/workout'),
      Attribute.dexterity => (l10n.questHintDexterity, '/workout'),
      Attribute.constitution => (l10n.questHintConstitution, '/activities'),
      Attribute.intelligence => (l10n.questHintIntelligence, '/activities'),
      Attribute.wisdom => (l10n.questHintWisdom, '/activities'),
      Attribute.charisma => (l10n.questHintCharisma, null),
    };

    return Row(
      children: [
        const Icon(Icons.auto_mode, size: 14, color: AppTheme.darkAsh),
        const SizedBox(width: 6),
        Expanded(child: Text(hint, style: const TextStyle(color: AppTheme.darkAsh, fontSize: 12))),
        if (route != null)
          TextButton(onPressed: () => context.go(route), child: Text(l10n.commonGo)),
      ],
    );
  }
}
