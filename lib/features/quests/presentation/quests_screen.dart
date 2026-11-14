import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../data/database.dart';
import '../../../data/repositories/providers.dart';

class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(todayQuestsStreamProvider);
    final charAsync = ref.watch(characterStreamProvider);
    final questRepo = ref.watch(questRepositoryProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Missões Diárias'),
        actions: [
          charAsync.when(
            data: (char) => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Chip(
                avatar: const Text('✨', style: TextStyle(fontSize: 14)),
                label: Text(
                  '${char.inspirationCount} Inspiração',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                backgroundColor: AppTheme.castIron,
                side: const BorderSide(color: AppTheme.emberGold),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: questsAsync.when(
        data: (quests) {
          if (quests.isEmpty && charAsync.hasValue) {
            // Gera as missões do dia
            questRepo.ensureTodayQuestsGenerated(charAsync.value!);
            return const Center(child: CircularProgressIndicator(color: AppTheme.emberGold));
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Banner Informativo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.castIron,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.emberGold.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.auto_stories, color: AppTheme.emberGold, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'As missões diárias fortalecem seus pontos fracos e recompensam consistência com Inspiração ✨ para refazer rolagens na história.',
                        style: TextStyle(color: AppTheme.ashWhite, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Objetivos de Hoje', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              ...quests.map((q) => _buildQuestCard(context, ref, q)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.emberGold)),
        error: (err, _) => Center(child: Text('Erro ao carregar missões: $err', style: textTheme.bodyMedium)),
      ),
    );
  }

  Widget _buildQuestCard(BuildContext context, WidgetRef ref, DailyQuestsTableData quest) {
    final progress = (quest.currentValue / quest.targetValue).clamp(0.0, 1.0);
    final isDone = quest.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone ? AppTheme.emberGold.withValues(alpha: 0.08) : AppTheme.castIron,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDone ? AppTheme.emberGold : AppTheme.ironBorder,
          width: isDone ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  quest.title,
                  style: TextStyle(
                    color: isDone ? AppTheme.emberGold : AppTheme.ashWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.obsidianBlack,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.ironBorder),
                ),
                child: Text(
                  quest.targetAttribute.code,
                  style: const TextStyle(color: AppTheme.emberGold, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            quest.description,
            style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progresso: ${quest.currentValue.toInt()} / ${quest.targetValue.toInt()} ${quest.unit}',
                style: const TextStyle(color: AppTheme.ashWhite, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Text('✨ +1  ', style: TextStyle(color: AppTheme.emberGold, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('+${quest.bonusXp.toInt()} XP', style: const TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppTheme.obsidianBlack,
              color: isDone ? AppTheme.emberGold : AppTheme.bloodCrimson,
            ),
          ),
          if (!isDone) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add_task, size: 16, color: AppTheme.emberGold),
                label: const Text('Registrar Progresso', style: TextStyle(color: AppTheme.emberGold, fontSize: 12)),
                onPressed: () async {
                  final questRepo = ref.read(questRepositoryProvider);
                  await questRepo.incrementProgress(
                    attribute: quest.targetAttribute,
                    delta: quest.unit == 'séries' ? 2.0 : 10.0,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
