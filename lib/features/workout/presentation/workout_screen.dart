import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/game_app_bar.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';
import 'active_workout_screen.dart';

/// Workout hub: start an empty workout or pick a routine.
///
/// NOTE: routine cards are temporary placeholders; the next step replaces
/// them with the data-driven routine catalog (templates + custom routines).
class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  Future<void> _start(BuildContext context, WidgetRef ref, String title) async {
    final session = await ref.read(workoutRepositoryProvider).startWorkoutSession(title: title);
    if (context.mounted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ActiveWorkoutScreen(session: session)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final routines = [
      (l10n.routinePushTitle, l10n.routinePushSubtitle),
      (l10n.routinePullTitle, l10n.routinePullSubtitle),
      (l10n.routineLegsTitle, l10n.routineLegsSubtitle),
      (l10n.routineCardioTitle, l10n.routineCardioSubtitle),
    ];

    return Scaffold(
      appBar: GameAppBar(title: l10n.workoutTitle),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          PixelFrame(
            highlight: true,
            color: AppTheme.darkBlood,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const PixelIcon(PixelIcons.flame, size: 26, color: AppTheme.emberGold),
                    const SizedBox(width: 10),
                    Text(l10n.workoutForgeTitle, style: display.style(28)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(l10n.workoutForgeBody, style: const TextStyle(color: AppTheme.ashWhite, fontSize: 13)),
                const SizedBox(height: 14),
                PixelButton(
                  label: l10n.workoutStartEmpty,
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => _start(context, ref, l10n.workoutDefaultTitle),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 6),
            child: Text(l10n.routinesTitle, style: Theme.of(context).textTheme.titleLarge),
          ),
          for (final (title, subtitle) in routines)
            PixelFrame(
              margin: const EdgeInsets.only(bottom: 8),
              onTap: () => _start(context, ref, title),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: display.style(21)),
                        const SizedBox(height: 2),
                        Text(subtitle, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.play_arrow, color: AppTheme.emberGold, size: 28),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
