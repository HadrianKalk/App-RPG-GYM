import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../app/ui/segmented_bar.dart';
import '../../../core/game/exercise_taxonomy.dart';
import '../../../core/game/routine.dart';
import '../../../data/database.dart';
import '../../../data/repositories/providers.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../l10n/l10n.dart';
import '../application/active_workout_controller.dart';
import 'exercise_guide_sheet.dart';
import 'exercise_picker_sheet.dart';
import 'workout_complete_screen.dart';
import 'workout_format.dart';

/// Workout in progress (Hevy-style table of sets).
///
/// Opened with an already-created [session]; when [routine] is given its
/// exercises are pre-loaded with targets and last-workout values.
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({
    required this.session,
    this.routine,
    this.resume = false,
    super.key,
  });

  final WorkoutSession session;
  final Routine? routine;
  final bool resume;

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  late final ActiveWorkoutController _controller;
  Timer? _clock;
  Timer? _restTimer;
  int _restRemaining = 0;
  int _restTotal = 1;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller = ActiveWorkoutController(repository: ref.read(workoutRepositoryProvider), session: widget.session);
    // Elapsed time is derived from startedAt, so it survives rebuilds and app restarts.
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    if (widget.resume) {
      _loading = true;
      _controller.restoreSession(routine: widget.routine).whenComplete(() {
        if (mounted) setState(() => _loading = false);
      });
    } else if (widget.routine != null) {
      _loading = true;
      _controller.loadRoutine(widget.routine!).whenComplete(() {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  @override
  void dispose() {
    _clock?.cancel();
    _restTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  int get _elapsedSeconds => DateTime.now().difference(widget.session.startedAt).inSeconds;

  void _startRest(int seconds) {
    _restTimer?.cancel();
    if (seconds <= 0) {
      setState(() => _restRemaining = 0);
      return;
    }
    setState(() {
      _restRemaining = seconds;
      _restTotal = seconds;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_restRemaining <= 1) {
        t.cancel();
        setState(() => _restRemaining = 0);
      } else {
        setState(() => _restRemaining--);
      }
    });
  }

  Future<void> _addExercise() async {
    final selected = await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ExercisePickerSheet(),
    );
    if (selected != null) await _controller.addExercise(selected);
  }

  Future<void> _toggle(WorkoutExerciseDraft group, WorkoutSetDraft set) async {
    final rest = await _controller.toggleSet(group, set);
    _startRest(rest);
  }

  /// Asks before throwing the workout away. Returns true when discarded.
  Future<bool> _confirmDiscard() async {
    final l10n = context.l10n;
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.workoutDiscardTitle),
        content: Text(l10n.workoutDiscardBody),
        actions: [
          PixelButton(
            label: l10n.workoutKeepGoing,
            expand: false,
            variant: PixelButtonVariant.secondary,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          PixelButton(
            label: l10n.workoutDiscard,
            expand: false,
            variant: PixelButtonVariant.danger,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (discard == true) {
      await _controller.discard();
      if (mounted) Navigator.of(context).pop();
      return true;
    }
    return false;
  }

  Future<void> _finish() async {
    final l10n = context.l10n;
    if (!_controller.hasCompletedSets) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.workoutNeedOneSet)));
      return;
    }
    final summary = await _controller.finish();
    if (!mounted) return;
    await _showSummary(summary);
    if (mounted) Navigator.of(context).pop();
  }

  /// Shows the full rewards screen ("Workout Complete!").
  Future<void> _showSummary(WorkoutSummary summary) {
    final game = context.game;
    final names = {for (final g in _controller.exercises) g.exercise.id: game.exerciseName(g.exercise.id, g.exercise.name)};
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WorkoutCompleteScreen(summary: summary, exerciseNames: names)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            key: const Key('workout_minimize_btn'),
            icon: const Icon(Icons.keyboard_arrow_down),
            tooltip: l10n.workoutMinimizeTooltip,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.session.title),
          actions: [
            Center(
              child: PixelTag(
                text: WorkoutFormat.duration(_elapsedSeconds),
                color: AppTheme.ashWhite,
                background: AppTheme.darkBlood,
                fontSize: 20,
              ),
            ),
            PopupMenuButton<String>(
              key: const Key('workout_menu_btn'),
              icon: const Icon(Icons.more_vert, color: AppTheme.dullSilver),
              onSelected: (_) => _confirmDiscard(),
              itemBuilder: (_) => [PopupMenuItem(value: 'discard', child: Text(l10n.workoutDiscard))],
            ),
          ],
        ),
        body: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => Column(
            children: [
              if (_restRemaining > 0)
                PixelFrame(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(l10n.restLabel, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13)),
                          const Spacer(),
                          Text(WorkoutFormat.duration(_restRemaining), style: display.style(30, color: AppTheme.emberGold, height: 1)),
                          TextButton(onPressed: () => _startRest(0), child: Text(l10n.restSkip)),
                        ],
                      ),
                      SegmentedBar(value: _restRemaining / _restTotal, segments: 30, color: AppTheme.bloodCrimson),
                    ],
                  ),
                ),
              Expanded(child: _buildBody(l10n)),
              _buildBottomBar(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_controller.exercises.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PixelIcon(PixelIcons.dumbbell, size: 64, color: AppTheme.ironBorder),
              const SizedBox(height: 12),
              Text(l10n.activeEmpty),
              const SizedBox(height: 16),
              PixelButton(label: l10n.addExercise, expand: false, icon: const Icon(Icons.add), onPressed: _addExercise),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [for (final g in _controller.exercises) _ExerciseCard(group: g, controller: _controller, onToggle: _toggle)],
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppTheme.castIron,
        border: Border(top: BorderSide(color: AppTheme.forgedSteel, width: 3)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: PixelButton(
                label: l10n.exerciseShort,
                variant: PixelButtonVariant.secondary,
                icon: const Icon(Icons.add),
                onPressed: _addExercise,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PixelButton(
                label: l10n.finishWorkout,
                icon: const Icon(Icons.check),
                loading: _controller.isBusy,
                onPressed: _controller.exercises.isNotEmpty ? _finish : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One exercise block: header, target, set table and "add set".
class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.group, required this.controller, required this.onToggle});

  final WorkoutExerciseDraft group;
  final ActiveWorkoutController controller;
  final Future<void> Function(WorkoutExerciseDraft, WorkoutSetDraft) onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final ex = group.exercise;
    final head = display.style(15, color: AppTheme.darkAsh);
    final target = group.target;

    // Column layout depends on how the exercise is tracked.
    final valueHeaders = switch (group.tracking) {
      SetTracking.weightReps => [l10n.colKg, l10n.colReps],
      SetTracking.reps => [l10n.colReps],
      SetTracking.duration => [l10n.colTime],
    };

    return PixelFrame(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(game.exerciseName(ex.id, ex.name), style: display.style(22))),
              ExerciseHelpButton(exercise: ex),
              const SizedBox(width: 6),
              PixelTag(text: game.attributeCode(ex.attribute), color: AppTheme.attributeColor(ex.attribute), fontSize: 15),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert, size: 20, color: AppTheme.darkAsh),
                onSelected: (_) => controller.removeExercise(group),
                itemBuilder: (_) => [PopupMenuItem(value: 'remove', child: Text(l10n.exerciseRemove))],
              ),
            ],
          ),
          Text(
            [
              '${game.muscle(ex.muscleGroup)} · ${game.equipment(ex.equipment)}',
              if (target != null) WorkoutFormat.target(l10n, target, group.tracking),
              if (target != null && target.restSeconds > 0) l10n.targetRest(WorkoutFormat.duration(target.restSeconds)),
            ].join('  ·  '),
            style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 36, child: Text(l10n.colSet, style: head)),
              Expanded(flex: 3, child: Text(l10n.colPrevious, style: head)),
              for (final h in valueHeaders) Expanded(flex: 2, child: Center(child: Text(h, style: head))),
              const SizedBox(width: 40),
            ],
          ),
          for (var i = 0; i < group.sets.length; i++)
            _SetRow(
              key: ValueKey(group.sets[i].id),
              index: i,
              group: group,
              set: group.sets[i],
              controller: controller,
              onToggle: onToggle,
            ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => controller.addSet(group),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(border: Border.all(color: AppTheme.ironBorder, width: 2)),
              child: Text('+ ${l10n.addSet}', textAlign: TextAlign.center, style: display.style(18, color: AppTheme.dullSilver)),
            ),
          ),
        ],
      ),
    );
  }
}

/// One set row; swipe left to delete.
class _SetRow extends StatelessWidget {
  const _SetRow({
    super.key,
    required this.index,
    required this.group,
    required this.set,
    required this.controller,
    required this.onToggle,
  });

  final int index;
  final WorkoutExerciseDraft group;
  final WorkoutSetDraft set;
  final ActiveWorkoutController controller;
  final Future<void> Function(WorkoutExerciseDraft, WorkoutSetDraft) onToggle;

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    final previous = index < group.previous.length ? group.previous[index] : null;

    final cells = switch (group.tracking) {
      SetTracking.weightReps => [
          _NumberCell(
            initial: WorkoutFormat.weight(set.weightKg),
            decimal: true,
            onChanged: (v) {
              final kg = double.tryParse(v.replaceAll(',', '.'));
              if (kg != null) controller.updateSet(group, set, weightKg: kg);
            },
          ),
          _NumberCell(
            initial: '${set.reps}',
            onChanged: (v) {
              final r = int.tryParse(v);
              if (r != null) controller.updateSet(group, set, reps: r);
            },
          ),
        ],
      SetTracking.reps => [
          _NumberCell(
            initial: '${set.reps}',
            onChanged: (v) {
              final r = int.tryParse(v);
              if (r != null) controller.updateSet(group, set, reps: r);
            },
          ),
        ],
      SetTracking.duration => [
          _NumberCell(
            initial: WorkoutFormat.duration(set.durationSeconds),
            keyboard: TextInputType.datetime,
            hint: context.l10n.timeHint,
            onChanged: (v) {
              final s = WorkoutFormat.parseDuration(v);
              if (s != null) controller.updateSet(group, set, durationSeconds: s);
            },
          ),
        ],
    };

    return Dismissible(
      key: ValueKey('dismiss_${set.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppTheme.darkBlood,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete_outline, color: AppTheme.ashWhite),
      ),
      onDismissed: (_) => controller.removeSet(group, set),
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(vertical: 2),
        color: set.completed ? AppTheme.doneGreen : null,
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Row(
                children: [
                  Text('${index + 1}', style: display.style(20)),
                  if (set.previewRecord) ...[
                    const SizedBox(width: 2),
                    const PixelIcon(PixelIcons.trophy, size: 12, color: AppTheme.emberGold),
                  ],
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                WorkoutFormat.previous(previous, group.tracking),
                style: const TextStyle(color: AppTheme.darkAsh, fontSize: 12),
              ),
            ),
            for (final c in cells)
              Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: c)),
            SizedBox(
              width: 40,
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: context.l10n.setComplete,
                icon: set.completed
                    ? const PixelIcon(PixelIcons.check, size: 22, color: AppTheme.emberGold)
                    : Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(border: Border.all(color: AppTheme.ironBorder, width: 2)),
                      ),
                onPressed: () => onToggle(group, set),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dark pixel input box for set values.
class _NumberCell extends StatelessWidget {
  const _NumberCell({
    required this.initial,
    required this.onChanged,
    this.decimal = false,
    this.keyboard,
    this.hint,
  });

  final String initial;
  final ValueChanged<String> onChanged;
  final bool decimal;
  final TextInputType? keyboard;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initial,
      keyboardType: keyboard ?? TextInputType.numberWithOptions(decimal: decimal),
      textAlign: TextAlign.center,
      style: DisplayFont.from(context).style(20),
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      ),
    );
  }
}
