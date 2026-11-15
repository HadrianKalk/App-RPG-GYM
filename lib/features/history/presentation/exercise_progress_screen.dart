import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../core/game/exercise_taxonomy.dart';
import '../../../data/database.dart';
import '../../../data/repositories/history_repository.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';
import '../../workout/presentation/workout_format.dart';
import 'pixel_bar_chart.dart';

/// Progress of one exercise over time: chart of the best mark per workout
/// (estimated 1RM, best time or most reps, depending on tracking).
class ExerciseProgressScreen extends ConsumerWidget {
  const ExerciseProgressScreen({super.key, required this.exercise});

  final Exercise exercise;

  /// Last N workouts shown in the chart.
  static const int chartPoints = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final future = ref.watch(historyRepositoryProvider).exerciseProgress(exercise.id);

    double metric(ExercisePoint p) => switch (exercise.tracking) {
          SetTracking.weightReps => p.bestEstimatedOneRepMax,
          SetTracking.duration => p.bestDurationSeconds.toDouble(),
          SetTracking.reps => p.bestReps.toDouble(),
        };
    String label(ExercisePoint p) => switch (exercise.tracking) {
          SetTracking.weightReps => '${WorkoutFormat.weight(p.bestEstimatedOneRepMax.roundToDouble())} kg',
          SetTracking.duration => WorkoutFormat.duration(p.bestDurationSeconds),
          SetTracking.reps => '× ${p.bestReps}',
        };
    final chartTitle = switch (exercise.tracking) {
      SetTracking.weightReps => l10n.progressChartE1rm,
      SetTracking.duration => l10n.progressChartDuration,
      SetTracking.reps => l10n.progressChartReps,
    };

    return Scaffold(
      appBar: AppBar(title: Text(game.exerciseName(exercise.id, exercise.name))),
      body: FutureBuilder<List<ExercisePoint>>(
        future: future,
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final points = snap.data!;
          if (points.isEmpty) return Center(child: Text(l10n.progressEmpty));
          final recent = points.length > chartPoints ? points.sublist(points.length - chartPoints) : points;
          final first = recent.first, last = recent.last;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              PixelFrame(
                highlight: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chartTitle, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(label(first), style: display.style(20, color: AppTheme.darkAsh)),
                        const Spacer(),
                        Text(label(last), style: display.style(30, color: AppTheme.emberGold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    PixelBarChart(values: [for (final p in recent) metric(p)]),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(l10n.progressSessions, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              for (final p in points.reversed)
                PixelFrame(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(child: Text(DateFormat.yMMMd(locale).format(p.date), style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13))),
                      Text(label(p), style: display.style(20)),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
