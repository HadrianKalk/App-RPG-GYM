import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
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
    setState(() => _restSecondsRemaining = seconds);
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
      _startRestTimer(90); // 90 segundos padrão de descanso
    }
  }

  Future<void> _finishWorkout() async {
    final workoutRepo = ref.read(workoutRepositoryProvider);
    final earnedXp = await workoutRepo.completeWorkoutSession(widget.session.id);

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.castIron,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.emberGold),
        ),
        title: Row(
          children: const [
            Icon(Icons.workspace_premium, color: AppTheme.emberGold, size: 28),
            SizedBox(width: 8),
            Text('Treino Concluído!', style: TextStyle(color: AppTheme.ashWhite)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duração: ${_formatDuration(_secondsElapsed)}', style: const TextStyle(color: AppTheme.dullSilver)),
            const SizedBox(height: 8),
            Text(
              'XP Conquistado: +${earnedXp.toStringAsFixed(1)} XP',
              style: const TextStyle(color: AppTheme.emberGold, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            const Text(
              'Seus músculos se fortaleceram e seu personagem absorveu a experiência do aço.',
              style: TextStyle(color: AppTheme.ashWhite, fontSize: 13),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emberGold,
              foregroundColor: AppTheme.obsidianBlack,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Retornar à Forja', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session.title),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                _formatDuration(_secondsElapsed),
                style: const TextStyle(
                  color: AppTheme.emberGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner de Descanso (se ativo)
          if (_restSecondsRemaining > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppTheme.darkBlood,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer, color: AppTheme.ashWhite, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Descanso: ${_formatDuration(_restSecondsRemaining)}',
                        style: const TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => setState(() => _restSecondsRemaining = 0),
                    child: const Text('Pular', style: TextStyle(color: AppTheme.ashWhite, fontSize: 12)),
                  ),
                ],
              ),
            ),

          Expanded(
            child: _exercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.fitness_center_outlined, size: 64, color: AppTheme.ironBorder),
                        const SizedBox(height: 16),
                        const Text('Nenhum exercício adicionado ainda.', style: TextStyle(color: AppTheme.dullSilver)),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _addExercise,
                          icon: const Icon(Icons.add),
                          label: const Text('Adicionar Exercício'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.emberGold,
                            foregroundColor: AppTheme.obsidianBlack,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final group = _exercises[index];
                      return _buildExerciseCard(group);
                    },
                  ),
          ),

          // Botões de Ação Inferiores
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: AppTheme.castIron,
              border: Border(top: BorderSide(color: AppTheme.ironBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addExercise,
                    icon: const Icon(Icons.add, color: AppTheme.emberGold),
                    label: const Text('Exercício', style: TextStyle(color: AppTheme.emberGold)),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.emberGold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _exercises.isNotEmpty ? _finishWorkout : null,
                    icon: const Icon(Icons.check),
                    label: const Text('Concluir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colorStrength,
                      foregroundColor: AppTheme.ashWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(LocalExerciseGroup group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.castIron,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.ironBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  group.exercise.name,
                  style: const TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.obsidianBlack,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  group.exercise.attribute.code,
                  style: const TextStyle(color: AppTheme.emberGold, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Cabeçalho da tabela
          const Row(
            children: [
              SizedBox(width: 40, child: Text('SÉRIE', style: TextStyle(fontSize: 10, color: AppTheme.darkAsh, fontWeight: FontWeight.bold))),
              Expanded(child: Center(child: Text('KG', style: TextStyle(fontSize: 10, color: AppTheme.darkAsh, fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text('REPS', style: TextStyle(fontSize: 10, color: AppTheme.darkAsh, fontWeight: FontWeight.bold)))),
              SizedBox(width: 48, child: Center(child: Text('✔', style: TextStyle(fontSize: 12, color: AppTheme.darkAsh, fontWeight: FontWeight.bold)))),
            ],
          ),
          const Divider(height: 8),
          // Linhas de séries
          ...group.sets.map((s) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              decoration: BoxDecoration(
                color: s.isCompleted ? AppTheme.emberGold.withValues(alpha: 0.1) : AppTheme.obsidianBlack,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    child: Row(
                      children: [
                        Text('${s.setOrder}', style: const TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold)),
                        if (s.isPr) const Text('🏆', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextFormField(
                        initialValue: s.weightKg.toStringAsFixed(1),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.ashWhite, fontSize: 13),
                        onChanged: (val) => s.weightKg = double.tryParse(val) ?? s.weightKg,
                        decoration: const InputDecoration(isDense: true, border: InputBorder.none),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextFormField(
                        initialValue: '${s.reps}',
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.ashWhite, fontSize: 13),
                        onChanged: (val) => s.reps = int.tryParse(val) ?? s.reps,
                        decoration: const InputDecoration(isDense: true, border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: IconButton(
                      icon: Icon(
                        s.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                        color: s.isCompleted ? AppTheme.emberGold : AppTheme.darkAsh,
                        size: 24,
                      ),
                      onPressed: () => _toggleSetCompleted(group, s),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              setState(() {
                final lastSet = group.sets.last;
                group.sets.add(
                  LocalSetItem(
                    setOrder: group.sets.length + 1,
                    weightKg: lastSet.weightKg,
                    reps: lastSet.reps,
                  ),
                );
              });
            },
            icon: const Icon(Icons.add, size: 16, color: AppTheme.emberGold),
            label: const Text('Adicionar Série', style: TextStyle(color: AppTheme.emberGold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
