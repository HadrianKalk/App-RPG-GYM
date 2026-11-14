import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../app/ui/segmented_bar.dart';
import '../../../l10n/l10n.dart';
import '../../../data/database.dart';
import '../../../data/repositories/providers.dart';
import 'exercise_picker_sheet.dart';

class LocalExerciseGroup {
  LocalExerciseGroup({required this.exercise, required this.sets});
  final Exercise exercise;
  final List<LocalSetItem> sets;
}

class LocalSetItem {
  LocalSetItem({
    required this.setOrder,
    this.weightKg = 0.0,
    this.reps = 0,
    this.rpe = 8.0,
    this.isCompleted = false,
    this.isPr = false,
  });

  final int setOrder;
  double weightKg;
  int reps;
  double rpe;
  bool isCompleted;
  bool isPr;
}

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({required this.session, super.key});

  final WorkoutSession session;

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  final List<LocalExerciseGroup> _exercises = [];
  Timer? _stopwatchTimer;
  int _secondsElapsed = 0;

  // Timer de Descanso entre séries
  Timer? _restTimer;
  int _restSecondsRemaining = 0;
  int _restTotalSeconds = 90;

  @override
  void initState() {
    super.initState();
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _secondsElapsed++);
    });
  }

  @override
  void dispose() {
    _stopwatchTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  void _startRestTimer(int seconds) {
    _restTimer?.cancel();
    setState(() {
      _restSecondsRemaining = seconds;
      _restTotalSeconds = seconds;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsRemaining > 0) {
        if (mounted) setState(() => _restSecondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  String _formatDuration(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _addExercise() async {
    final selected = await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ExercisePickerSheet(),
    );

    if (selected != null) {
      setState(() {
        _exercises.add(
          LocalExerciseGroup(
            exercise: selected,
            sets: [LocalSetItem(setOrder: 1, weightKg: 20.0, reps: 10)],
          ),
        );
      });
    }
  }

  Future<void> _toggleSetCompleted(LocalExerciseGroup group, LocalSetItem setItem) async {
    final newStatus = !setItem.isCompleted;
    final workoutRepo = ref.read(workoutRepositoryProvider);

    final isPr = await workoutRepo.saveWorkoutSet(
      id: 'set_${widget.session.id}_${group.exercise.id}_${setItem.setOrder}',
      sessionId: widget.session.id,
      exerciseId: group.exercise.id,
      setOrder: setItem.setOrder,
      weightKg: setItem.weightKg,
      reps: setItem.reps,
      rpe: setItem.rpe,
      isCompleted: newStatus,
    );

    setState(() {
      setItem.isCompleted = newStatus;
      setItem.isPr = isPr;
    });

    if (newStatus) {
      _startRestTimer(90); // default rest: 90 seconds
    }
  }

  Future<void> _finishWorkout() async {
    final workoutRepo = ref.read(workoutRepositoryProvider);
    final earnedXp = await workoutRepo.completeWorkoutSession(widget.session.id);

    if (!mounted) return;
    final l10n = context.l10n;
    final display = DisplayFont.from(context);

    // Temporary summary; replaced by the full "Workout Complete" rewards
    // screen (with every bonus and its reason) in the history/bonus step.
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.workoutDoneTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.workoutDuration(_formatDuration(_secondsElapsed))),
            const SizedBox(height: 8),
            Text(l10n.xpGain(earnedXp.toStringAsFixed(1)), style: display.style(30, color: AppTheme.emberGold)),
            const SizedBox(height: 8),
            Text(l10n.workoutDoneFlavor, style: const TextStyle(color: AppTheme.ashWhite)),
          ],
        ),
        actions: [
          PixelButton(
            label: l10n.workoutDoneButton,
            expand: false,
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: PixelTag(
                text: _formatDuration(_secondsElapsed),
                color: AppTheme.ashWhite,
                background: AppTheme.darkBlood,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_restSecondsRemaining > 0)
            PixelFrame(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(l10n.restLabel, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13)),
                      const Spacer(),
                      Text(_formatDuration(_restSecondsRemaining), style: display.style(30, color: AppTheme.emberGold, height: 1)),
                      TextButton(
                        onPressed: () => setState(() => _restSecondsRemaining = 0),
                        child: Text(l10n.restSkip),
                      ),
                    ],
                  ),
                  SegmentedBar(
                    value: _restSecondsRemaining / _restTotalSeconds,
                    segments: 30,
                    color: AppTheme.bloodCrimson,
                  ),
                ],
              ),
            ),
          Expanded(
            child: _exercises.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PixelIcon(PixelIcons.dumbbell, size: 64, color: AppTheme.ironBorder),
                          const SizedBox(height: 12),
                          Text(l10n.activeEmpty),
                          const SizedBox(height: 16),
                          PixelButton(
                            label: l10n.addExercise,
                            expand: false,
                            icon: const Icon(Icons.add),
                            onPressed: _addExercise,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) => _buildExerciseCard(_exercises[index]),
                  ),
          ),
          Container(
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
                      onPressed: _exercises.isNotEmpty ? _finishWorkout : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(LocalExerciseGroup group) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final ex = group.exercise;
    final head = display.style(15, color: AppTheme.darkAsh);

    return PixelFrame(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(game.exerciseName(ex.id, ex.name), style: display.style(22))),
              PixelTag(text: game.attributeCode(ex.attribute), color: AppTheme.attributeColor(ex.attribute), fontSize: 15),
            ],
          ),
          Text(
            '${game.muscle(ex.muscleGroup)} · ${game.equipment(ex.equipment)}',
            style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 44, child: Text(l10n.colSet, style: head)),
              Expanded(child: Center(child: Text(l10n.colKg, style: head))),
              Expanded(child: Center(child: Text(l10n.colReps, style: head))),
              const SizedBox(width: 44),
            ],
          ),
          for (final s in group.sets)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(vertical: 2),
              color: s.isCompleted ? AppTheme.doneGreen : null,
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${s.setOrder}', style: display.style(20)),
                        if (s.isPr) ...[
                          const SizedBox(width: 2),
                          const PixelIcon(PixelIcons.trophy, size: 12, color: AppTheme.emberGold),
                        ],
                      ],
                    ),
                  ),
                  Expanded(child: _numberCell(s.weightKg.toStringAsFixed(1), true, (v) => s.weightKg = double.tryParse(v.replaceAll(',', '.')) ?? s.weightKg)),
                  const SizedBox(width: 6),
                  Expanded(child: _numberCell('${s.reps}', false, (v) => s.reps = int.tryParse(v) ?? s.reps)),
                  SizedBox(
                    width: 44,
                    child: IconButton(
                      icon: s.isCompleted
                          ? const PixelIcon(PixelIcons.check, size: 22, color: AppTheme.emberGold)
                          : Container(width: 20, height: 20, decoration: BoxDecoration(border: Border.all(color: AppTheme.ironBorder, width: 2))),
                      onPressed: () => _toggleSetCompleted(group, s),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => setState(() {
              final last = group.sets.last;
              group.sets.add(LocalSetItem(setOrder: group.sets.length + 1, weightKg: last.weightKg, reps: last.reps));
            }),
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

  /// Numeric input cell styled as a dark pixel box.
  Widget _numberCell(String initial, bool decimal, ValueChanged<String> onChanged) {
    return TextFormField(
      initialValue: initial,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      textAlign: TextAlign.center,
      style: DisplayFont.from(context).style(20),
      onChanged: onChanged,
      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 6)),
    );
  }
}
