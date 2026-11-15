import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../core/game/exercise_taxonomy.dart';
import '../../../data/repositories/history_repository.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';
import '../../workout/presentation/workout_format.dart';
import 'exercise_progress_screen.dart';

/// Read-only view of a finished workout.
class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.overview});

  final SessionOverview overview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final future = ref.watch(historyRepositoryProvider).getSessionExercises(overview.session.id);

    return Scaffold(
      appBar: AppBar(title: Text(overview.session.title)),
      body: FutureBuilder<List<SessionExercise>>(
        future: future,
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Text(
                '${DateFormat.yMMMMEEEEd(locale).format(overview.session.completedAt!)}  ·  '
                '${WorkoutFormat.duration(overview.duration.inSeconds)}',
                style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13),
              ),
              const SizedBox(height: 10),
              for (final item in snap.data!)
                PixelFrame(
                  margin: const EdgeInsets.only(bottom: 10),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ExerciseProgressScreen(exercise: item.exercise)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(game.exerciseName(item.exercise.id, item.exercise.name), style: display.style(21))),
                          PixelTag(
                            text: game.attributeCode(item.exercise.attribute),
                            color: AppTheme.attributeColor(item.exercise.attribute),
                            fontSize: 14,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      for (var i = 0; i < item.sets.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              SizedBox(width: 28, child: Text('${i + 1}', style: display.style(18, color: AppTheme.darkAsh))),
                              Text(
                                switch (item.exercise.tracking) {
                                  SetTracking.weightReps => '${WorkoutFormat.weight(item.sets[i].weightKg)} kg × ${item.sets[i].reps}',
                                  SetTracking.reps => '× ${item.sets[i].reps}',
                                  SetTracking.duration => WorkoutFormat.duration(item.sets[i].durationSeconds),
                                },
                                style: display.style(19),
                              ),
                              if (item.sets[i].isPersonalRecord) ...[
                                const SizedBox(width: 8),
                                const PixelIcon(PixelIcons.trophy, size: 14, color: AppTheme.emberGold),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              if (snap.data!.isEmpty) Text(l10n.progressEmpty),
            ],
          );
        },
      ),
    );
  }
}
