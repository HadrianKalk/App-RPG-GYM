import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/game/attributes.dart';
import '../../../data/repositories/providers.dart';

class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen> {
  // Pomodoro State
  Timer? _pomodoroTimer;
  int _pomodoroSeconds = 25 * 60;
  int _initialSeconds = 25 * 60;
  bool _isRunning = false;
  final TextEditingController _subjectController = TextEditingController(text: 'Estudo Focado');

  // Sono State
  double _hoursSlept = 7.5;

  @override
  void dispose() {
    _pomodoroTimer?.cancel();
    _subjectController.dispose();
    super.dispose();
  }

  void _togglePomodoro() {
    if (_isRunning) {
      _pomodoroTimer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _pomodoroTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_pomodoroSeconds > 0) {
          setState(() => _pomodoroSeconds--);
        } else {
          timer.cancel();
          setState(() => _isRunning = false);
          _completePomodoroSession();
        }
      });
    }
  }

  void _resetPomodoro(int minutes) {
    _pomodoroTimer?.cancel();
    setState(() {
      _isRunning = false;
      _initialSeconds = minutes * 60;
      _pomodoroSeconds = _initialSeconds;
    });
  }

  Future<void> _completePomodoroSession() async {
    final elapsedMinutes = ((_initialSeconds - _pomodoroSeconds) / 60).round();
    final actualMinutes = elapsedMinutes > 0 ? elapsedMinutes : (_initialSeconds / 60).round();

    final activityRepo = ref.read(activityRepositoryProvider);
    final earnedXp = await activityRepo.logPomodoroStudy(
      durationMinutes: actualMinutes,
      subject: _subjectController.text.trim().isNotEmpty ? _subjectController.text.trim() : null,
    );

    _resetPomodoro(25);

    if (mounted) {
      _showRewardDialog(
        title: 'Mente Forjada!',
        attribute: Attribute.intelligence,
        earnedXp: earnedXp,
        message: 'Você completou $actualMinutes minutos de foco e ganhou XP de Inteligência.',
      );
    }
  }

  Future<void> _logSleep() async {
    final activityRepo = ref.read(activityRepositoryProvider);
    final earnedXp = await activityRepo.logSleep(hoursSlept: _hoursSlept);

    if (mounted) {
      _showRewardDialog(
        title: 'Corpo Recuperado!',
        attribute: Attribute.constitution,
        earnedXp: earnedXp,
        message: '${_hoursSlept.toStringAsFixed(1)} horas de descanso registradas. Sua Constituição aumentou.',
      );
    }
  }

  Future<void> _logMeditation(int minutes) async {
    final activityRepo = ref.read(activityRepositoryProvider);
    final earnedXp = await activityRepo.logMeditation(durationMinutes: minutes);

    if (mounted) {
      _showRewardDialog(
        title: 'Quietude Interior',
        attribute: Attribute.wisdom,
        earnedXp: earnedXp,
        message: '$minutes minutos de presença e reflexão. Sua Sabedoria aumentou.',
      );
    }
  }

  void _showRewardDialog({
    required String title,
    required Attribute attribute,
    required double earnedXp,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.castIron,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.emberGold),
        ),
        title: Text(title, style: const TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.obsidianBlack,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.emberGold),
                  ),
                  child: Text('+${earnedXp.toStringAsFixed(1)} XP', style: const TextStyle(color: AppTheme.emberGold, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Text('(${attribute.name})', style: const TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13)),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emberGold,
              foregroundColor: AppTheme.obsidianBlack,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Ótimo'),
          ),
        ],
      ),
    );
  }

  String _formatTimer(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final progress = (_initialSeconds - _pomodoroSeconds) / _initialSeconds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atividades da Vida Real'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- CARD DO POMODORO (INTELIGÊNCIA) ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.castIron,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.colorIntelligence.withValues(alpha: 0.6)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.colorIntelligence.withValues(alpha: 0.1),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_stories, color: AppTheme.colorIntelligence, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Timer Pomodoro (INT)',
                          style: TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Text(
                      '${(_initialSeconds / 60).round()} min',
                      style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _subjectController,
                  style: const TextStyle(color: AppTheme.ashWhite, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'O que você está estudando?',
                    hintStyle: const TextStyle(color: AppTheme.darkAsh),
                    filled: true,
                    fillColor: AppTheme.obsidianBlack,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppTheme.ironBorder)),
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: AppTheme.obsidianBlack,
                        color: AppTheme.colorIntelligence,
                      ),
                    ),
                    Text(
                      _formatTimer(_pomodoroSeconds),
                      style: const TextStyle(color: AppTheme.ashWhite, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => _resetPomodoro(25),
                      child: const Text('25 min', style: TextStyle(color: AppTheme.ashWhite)),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _resetPomodoro(50),
                      child: const Text('50 min', style: TextStyle(color: AppTheme.ashWhite)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _togglePomodoro,
                      icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                      label: Text(_isRunning ? 'Pausar' : 'Iniciar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colorIntelligence,
                        foregroundColor: AppTheme.ashWhite,
                      ),
                    ),
                    if (_pomodoroSeconds < _initialSeconds) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.check, color: AppTheme.emberGold),
                        tooltip: 'Concluir Agora',
                        onPressed: _completePomodoroSession,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Text('Descanso & Saúde', style: textTheme.titleMedium),
          const SizedBox(height: 12),

          // --- CARD DE SONO (CONSTITUIÇÃO) ---
          Container(
            padding: const EdgeInsets.all(16),
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
                    Row(
                      children: const [
                        Icon(Icons.bedtime_outlined, color: AppTheme.colorConstitution, size: 20),
                        SizedBox(width: 8),
                        Text('Sono Reparador (CON)', style: TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(
                      '${_hoursSlept.toStringAsFixed(1)} horas',
                      style: const TextStyle(color: AppTheme.colorConstitution, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _hoursSlept,
                  min: 4.0,
                  max: 12.0,
                  divisions: 16,
                  activeColor: AppTheme.colorConstitution,
                  inactiveColor: AppTheme.obsidianBlack,
                  onChanged: (val) => setState(() => _hoursSlept = val),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.obsidianBlack,
                      foregroundColor: AppTheme.colorConstitution,
                      side: const BorderSide(color: AppTheme.colorConstitution),
                    ),
                    onPressed: _logSleep,
                    child: const Text('Registrar Sono de Ontem'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Text('Sabedoria & Presença', style: textTheme.titleMedium),
          const SizedBox(height: 12),

          // --- CARD DE MEDITAÇÃO (SABEDORIA) ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.castIron,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.ironBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.self_improvement, color: AppTheme.colorWisdom, size: 24),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Meditação & Diário (SAB)', style: TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold)),
                        Text('Quietude mental e presença', style: TextStyle(color: AppTheme.dullSilver, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(onPressed: () => _logMeditation(10), child: const Text('+10m', style: TextStyle(color: AppTheme.colorWisdom))),
                    TextButton(onPressed: () => _logMeditation(20), child: const Text('+20m', style: TextStyle(color: AppTheme.colorWisdom))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
