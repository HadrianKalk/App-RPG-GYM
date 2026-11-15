import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../core/game/exercise_taxonomy.dart';
import '../../../core/game/routine.dart';
import '../../../data/database.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';
import 'exercise_picker_sheet.dart';
import 'workout_format.dart';

/// Creates or edits a custom routine.
///
/// - [initial] null: new routine.
/// - [initial] custom: edit it in place.
/// - [asCopy]: start from [initial] (e.g. a template) and save as a new one.
class RoutineEditorScreen extends ConsumerStatefulWidget {
  const RoutineEditorScreen({super.key, this.initial, this.initialName, this.asCopy = false});

  final Routine? initial;
  final String? initialName;
  final bool asCopy;

  @override
  ConsumerState<RoutineEditorScreen> createState() => _RoutineEditorScreenState();
}

/// Editable row: catalog exercise + its target.
class _Item {
  _Item(this.exercise, this.target) : key = UniqueKey();

  final Exercise exercise;
  RoutineExercise target;
  final Key key;
}

class _RoutineEditorScreenState extends ConsumerState<RoutineEditorScreen> {
  final _name = TextEditingController();
  final List<_Item> _items = [];
  bool _loading = false;
  bool _saving = false;

  bool get _isEdit => widget.initial != null && !widget.asCopy && !widget.initial!.isTemplate;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _name.text = widget.initialName ?? initial?.customName ?? '';
    if (initial != null) {
      _loading = true;
      ref.read(workoutRepositoryProvider).getExercises(initial.exercises.map((e) => e.exerciseId).toList()).then((list) {
        final byId = {for (final e in list) e.id: e};
        if (!mounted) return;
        setState(() {
          for (final t in initial.exercises) {
            final ex = byId[t.exerciseId];
            if (ex != null) _items.add(_Item(ex, t));
          }
          _loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  /// Sensible default target for a newly added exercise.
  RoutineExercise _defaultTarget(Exercise e) => switch (e.tracking) {
        SetTracking.duration => RoutineExercise(exerciseId: e.id, sets: 3, durationSeconds: 60, restSeconds: 60),
        SetTracking.reps => RoutineExercise(exerciseId: e.id, sets: 3, repsMin: 8, repsMax: 12, restSeconds: 90),
        SetTracking.weightReps => RoutineExercise(exerciseId: e.id, sets: 3, repsMin: 8, repsMax: 12, restSeconds: 90),
      };

  Future<void> _addExercise() async {
    final ex = await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ExercisePickerSheet(),
    );
    if (ex != null) setState(() => _items.add(_Item(ex, _defaultTarget(ex))));
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    if (_name.text.trim().isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.editorNameRequired)));
      return;
    }
    if (_items.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.editorNoExercises)));
      return;
    }
    setState(() => _saving = true);
    await ref.read(routineRepositoryProvider).saveCustomRoutine(
          id: _isEdit ? widget.initial!.id : null,
          name: _name.text,
          exercises: [for (final i in _items) i.target],
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? l10n.editorTitleEdit : l10n.editorTitleNew)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: TextField(
                    controller: _name,
                    maxLength: 40,
                    style: DisplayFont.from(context).style(22),
                    decoration: InputDecoration(labelText: l10n.editorNameLabel, counterText: ''),
                  ),
                ),
                if (_items.length > 1)
                  Text(l10n.editorReorderHint, style: const TextStyle(color: AppTheme.darkAsh, fontSize: 11)),
                Expanded(
                  child: ReorderableListView(
                    padding: const EdgeInsets.all(12),
                    buildDefaultDragHandles: false,
                    // onReorderItem already adjusts `to` for the removed item.
                    onReorderItem: (from, to) => setState(() => _items.insert(to, _items.removeAt(from))),
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: PixelButton(
                        label: l10n.addExercise,
                        variant: PixelButtonVariant.secondary,
                        icon: const Icon(Icons.add),
                        onPressed: _addExercise,
                      ),
                    ),
                    children: [
                      for (var i = 0; i < _items.length; i++)
                        _TargetEditor(
                          key: _items[i].key,
                          index: i,
                          item: _items[i],
                          onChanged: (t) => setState(() => _items[i].target = t),
                          onRemove: () => setState(() => _items.removeAt(i)),
                        ),
                    ],
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
                    child: PixelButton(label: l10n.editorSave, loading: _saving, onPressed: _save),
                  ),
                ),
              ],
            ),
    );
  }
}

/// Target fields of one exercise inside the editor.
class _TargetEditor extends StatelessWidget {
  const _TargetEditor({
    super.key,
    required this.index,
    required this.item,
    required this.onChanged,
    required this.onRemove,
  });

  final int index;
  final _Item item;
  final ValueChanged<RoutineExercise> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final ex = item.exercise;
    final t = item.target;
    final label = const TextStyle(color: AppTheme.dullSilver, fontSize: 11);

    return PixelFrame(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.drag_indicator, color: AppTheme.darkAsh),
                ),
              ),
              Expanded(child: Text(game.exerciseName(ex.id, ex.name), style: display.style(20))),
              PixelTag(text: game.attributeCode(ex.attribute), color: AppTheme.attributeColor(ex.attribute), fontSize: 14),
              IconButton(
                tooltip: l10n.editorRemove,
                icon: const Icon(Icons.close, size: 18, color: AppTheme.darkAsh),
                onPressed: onRemove,
              ),
            ],
          ),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              _Stepper(
                label: l10n.editorSets,
                value: '${t.sets}',
                onMinus: t.sets > 1 ? () => onChanged(t.copyWith(sets: t.sets - 1)) : null,
                onPlus: t.sets < 10 ? () => onChanged(t.copyWith(sets: t.sets + 1)) : null,
              ),
              if (ex.tracking == SetTracking.duration)
                _Field(
                  label: l10n.editorDuration,
                  initial: WorkoutFormat.duration(t.durationSeconds ?? 60),
                  width: 72,
                  keyboard: TextInputType.datetime,
                  onChanged: (v) {
                    final s = WorkoutFormat.parseDuration(v);
                    if (s != null && s > 0) onChanged(t.copyWith(durationSeconds: () => s));
                  },
                )
              else ...[
                if (!t.toFailure) ...[
                  _Field(
                    label: l10n.editorRepsMin,
                    initial: '${t.repsMin ?? ''}',
                    onChanged: (v) => onChanged(t.copyWith(repsMin: () => int.tryParse(v))),
                  ),
                  _Field(
                    label: l10n.editorRepsMax,
                    initial: '${t.repsMax ?? ''}',
                    onChanged: (v) => onChanged(t.copyWith(repsMax: () => int.tryParse(v))),
                  ),
                ],
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.editorToFailure, style: label),
                    Checkbox(
                      value: t.toFailure,
                      onChanged: (v) => onChanged(t.copyWith(toFailure: v ?? false)),
                    ),
                  ],
                ),
              ],
              _Stepper(
                label: l10n.editorRest,
                value: WorkoutFormat.duration(t.restSeconds),
                onMinus: t.restSeconds >= 15 ? () => onChanged(t.copyWith(restSeconds: t.restSeconds - 15)) : null,
                onPlus: t.restSeconds < 600 ? () => onChanged(t.copyWith(restSeconds: t.restSeconds + 15)) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "−  value  +" control.
class _Stepper extends StatelessWidget {
  const _Stepper({required this.label, required this.value, this.onMinus, this.onPlus});

  final String label;
  final String value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    Widget btn(IconData icon, VoidCallback? onTap) => InkWell(
          onTap: onTap,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(border: Border.all(color: AppTheme.ironBorder, width: 2)),
            child: Icon(icon, size: 16, color: onTap == null ? AppTheme.forgedSteel : AppTheme.emberGold),
          ),
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 11)),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            btn(Icons.remove, onMinus),
            SizedBox(width: 46, child: Text(value, textAlign: TextAlign.center, style: display.style(20))),
            btn(Icons.add, onPlus),
          ],
        ),
      ],
    );
  }
}

/// Small labeled numeric input.
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.initial,
    required this.onChanged,
    this.width = 56,
    this.keyboard = TextInputType.number,
  });

  final String label;
  final String initial;
  final ValueChanged<String> onChanged;
  final double width;
  final TextInputType keyboard;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 11)),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: initial,
            keyboardType: keyboard,
            textAlign: TextAlign.center,
            style: DisplayFont.from(context).style(20),
            onChanged: onChanged,
            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 6)),
          ),
        ],
      ),
    );
  }
}
