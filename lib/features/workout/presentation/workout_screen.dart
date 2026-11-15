import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/game_app_bar.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_border.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../core/game/routine.dart';
import '../../../data/database.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';
import '../../history/presentation/history_screen.dart';
import 'active_workout_screen.dart';
import 'routine_editor_screen.dart';
import 'workout_format.dart';

/// Workout hub: empty workout, starter templates and the user's routines.
class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final templates = ref.watch(routineRepositoryProvider).templates;
    final customAsync = ref.watch(customRoutinesProvider);

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
                    Expanded(child: Text(l10n.workoutForgeTitle, style: display.style(28))),
                  ],
                ),
                const SizedBox(height: 6),
                Text(l10n.workoutForgeBody, style: const TextStyle(color: AppTheme.ashWhite, fontSize: 13)),
                const SizedBox(height: 14),
                PixelButton(
                  label: l10n.workoutStartEmpty,
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => startWorkout(context, ref, title: l10n.workoutDefaultTitle),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PixelFrame(
            onTap: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
            child: Row(
              children: [
                const PixelIcon(PixelIcons.trophy, size: 24, color: AppTheme.emberGold),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.historyOpen, style: display.style(21)),
                      Text(l10n.historyOpenSubtitle, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.emberGold, size: 28),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SectionHeader(
            title: l10n.routinesMine,
            action: TextButton.icon(
              icon: const PixelIcon(PixelIcons.plus, size: 14, color: AppTheme.emberGold),
              label: Text(l10n.routinesNew),
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const RoutineEditorScreen()),
              ),
            ),
          ),
          customAsync.when(
            data: (routines) => routines.isEmpty
                ? PixelFrame(child: Text(l10n.routinesEmpty, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13)))
                : Column(children: [for (final r in routines) _RoutineCard(routine: r)]),
            loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Text(l10n.loadError('$e')),
          ),
          const SizedBox(height: 14),
          _SectionHeader(title: l10n.routinesTemplates),
          for (final t in templates) _RoutineCard(routine: t),
        ],
      ),
    );
  }
}

/// Creates a session (optionally from [routine]) and opens the workout.
Future<void> startWorkout(BuildContext context, WidgetRef ref, {required String title, Routine? routine}) async {
  final session = await ref.read(workoutRepositoryProvider).startWorkoutSession(title: title, routineId: routine?.id);
  if (context.mounted) {
    // Root navigator: the workout is full-screen, without the tab bar.
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => ActiveWorkoutScreen(session: session, routine: routine)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 6),
        child: Row(
          children: [
            Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
            ?action,
          ],
        ),
      );
}

/// Routine summary card; tap to preview.
class _RoutineCard extends ConsumerWidget {
  const _RoutineCard({required this.routine});

  final Routine routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final exercises = ref.watch(_exercisesProvider(routine.exercises.map((e) => e.exerciseId).join(','))).valueOrNull;
    final names = exercises?.map((e) => game.exerciseName(e.id, e.name)).join(', ');

    return PixelFrame(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _RoutinePreviewSheet(routine: routine),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.routineName(routine), style: display.style(21)),
                const SizedBox(height: 2),
                Text(
                  names ?? l10n.routineExerciseCount(routine.exercises.length),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppTheme.emberGold, size: 28),
        ],
      ),
    );
  }
}

/// Exercises of a routine by comma-joined ids (cached per routine).
final _exercisesProvider = FutureProvider.family<List<Exercise>, String>((ref, joinedIds) {
  final ids = joinedIds.isEmpty ? <String>[] : joinedIds.split(',');
  return ref.watch(workoutRepositoryProvider).getExercises(ids);
});

/// Bottom sheet: routine exercises/targets + start/edit/delete/copy.
class _RoutinePreviewSheet extends ConsumerWidget {
  const _RoutinePreviewSheet({required this.routine});

  final Routine routine;

  Future<void> _delete(BuildContext context, WidgetRef ref, String name) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.routineDeleteConfirm(name)),
        actions: [
          PixelButton(label: l10n.commonCancel, expand: false, variant: PixelButtonVariant.secondary, onPressed: () => Navigator.of(ctx).pop(false)),
          PixelButton(label: l10n.commonDelete, expand: false, variant: PixelButtonVariant.danger, onPressed: () => Navigator.of(ctx).pop(true)),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(routineRepositoryProvider).deleteCustomRoutine(routine.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final name = game.routineName(routine);
    final description = game.routineDescription(routine);
    final exercises = ref.watch(_exercisesProvider(routine.exercises.map((e) => e.exerciseId).join(','))).valueOrNull ?? const [];
    final byId = {for (final e in exercises) e.id: e};

    return Material(
      color: AppTheme.castIron,
      shape: const PixelBorder(side: BorderSide(color: AppTheme.emberGold, width: 3)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(name, style: display.style(30, color: AppTheme.emberGold)),
              ),
              if (description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(description, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13)),
                ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final target in routine.exercises)
                      if (byId[target.exerciseId] case final ex?)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Container(width: 8, height: 8, color: AppTheme.attributeColor(ex.attribute)),
                              const SizedBox(width: 10),
                              Expanded(child: Text(game.exerciseName(ex.id, ex.name), style: display.style(19))),
                              Text(WorkoutFormat.target(l10n, target, ex.tracking), style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12)),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    PixelButton(
                      label: l10n.routineStart,
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        Navigator.of(context).pop();
                        startWorkout(context, ref, title: name, routine: routine);
                      },
                    ),
                    const SizedBox(height: 8),
                    if (routine.isTemplate)
                      PixelButton(
                        label: l10n.routineDuplicate,
                        variant: PixelButtonVariant.secondary,
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                            builder: (_) => RoutineEditorScreen(initial: routine, initialName: l10n.routineCopyName(name), asCopy: true),
                          ));
                        },
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: PixelButton(
                              label: l10n.routineEdit,
                              variant: PixelButtonVariant.secondary,
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => RoutineEditorScreen(initial: routine)));
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PixelButton(
                              label: l10n.commonDelete,
                              variant: PixelButtonVariant.danger,
                              onPressed: () => _delete(context, ref, name),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
