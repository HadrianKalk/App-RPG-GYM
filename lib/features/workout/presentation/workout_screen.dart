import '../../../core/game/attributes.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../data/repositories/providers.dart';
import 'active_workout_screen.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final workoutRepo = ref.watch(workoutRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Treino do Aço'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner de Iniciar Treino
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.castIron, AppTheme.darkBlood],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.bloodCrimson.withValues(alpha: 0.6)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.bloodCrimson.withValues(alpha: 0.2),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.flash_on, color: AppTheme.emberGold, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'Forjar o Corpo',
                      style: TextStyle(
                        color: AppTheme.ashWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cada repetição alimenta Força, Destreza e Constituição. Recordes Pessoais geram bônus de XP instantâneo.',
                  style: TextStyle(color: AppTheme.dullSilver, fontSize: 13),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('INICIAR TREINO VAZIO', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.emberGold,
                      foregroundColor: AppTheme.obsidianBlack,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final session = await workoutRepo.startWorkoutSession(title: 'Treino de Força');
                      if (context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ActiveWorkoutScreen(session: session),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Rotinas Populares', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildRoutineCard(context, ref, 'Push / Peito, Ombro e Tríceps', 'Supino, Militar, Elevação Lateral, Paralelas', Attribute.strength),
          const SizedBox(height: 8),
          _buildRoutineCard(context, ref, 'Pull / Costas e Bíceps', 'Puxada Alta, Remada Curvada, Terra, Rosca', Attribute.strength),
          const SizedBox(height: 8),
          _buildRoutineCard(context, ref, 'Legs / Pernas e Glúteos', 'Agachamento, Leg Press, Stiff, Panturrilhas', Attribute.strength),
          const SizedBox(height: 8),
          _buildRoutineCard(context, ref, 'Cardio & Mobilidade', 'Corrida, Corda, Alongamentos, Yoga', Attribute.constitution),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(BuildContext context, WidgetRef ref, String title, String subtitle, Attribute attr) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.castIron,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.ironBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: AppTheme.emberGold, size: 28),
            onPressed: () async {
              final workoutRepo = ref.read(workoutRepositoryProvider);
              final session = await workoutRepo.startWorkoutSession(title: title);
              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActiveWorkoutScreen(session: session),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

