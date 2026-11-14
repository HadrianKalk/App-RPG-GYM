import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/game_app_bar.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/segmented_bar.dart';
import '../../../l10n/l10n.dart';
import '../../../core/game/attributes.dart';
import '../../../data/repositories/providers.dart';

class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen> {
  // Pomodoro state
  Timer? _pomodoroTimer;
  int _pomodoroSeconds = 25 * 60;
  int _initialSeconds = 25 * 60;
  bool _isRunning = false;
  final TextEditingController _subjectController = TextEditingController();

  // Sleep state
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
    final l10n = context.l10n;
    final elapsedMinutes = ((_initialSeconds - _pomodoroSeconds) / 60).round();
    final minutes = elapsedMinutes > 0 ? elapsedMinutes : (_initialSeconds / 60).round();
    final subject = _subjectController.text.trim();
    final earnedXp = await ref.read(activityRepositoryProvider).logPomodoroStudy(
          durationMinutes: minutes,
          subject: subject.isNotEmpty ? subject : l10n.pomodoroDefaultSubject,
        );
    _resetPomodoro(25);
    if (mounted) {
      _showReward(l10n.rewardIntTitle, Attribute.intelligence, earnedXp, l10n.rewardIntMessage(minutes));
    }
  }

  Future<void> _logSleep() async {
    final l10n = context.l10n;
    final earnedXp = await ref.read(activityRepositoryProvider).logSleep(hoursSlept: _hoursSlept);
    if (mounted) {
      _showReward(l10n.rewardConTitle, Attribute.constitution, earnedXp, l10n.rewardConMessage(_hoursSlept.toStringAsFixed(1)));
    }
  }

  Future<void> _logMeditation(int minutes) async {
    final l10n = context.l10n;
    final earnedXp = await ref.read(activityRepositoryProvider).logMeditation(durationMinutes: minutes);
    if (mounted) {
      _showReward(l10n.rewardWisTitle, Attribute.wisdom, earnedXp, l10n.rewardWisMessage(minutes));
    }
  }

  /// Small reward dialog after logging an activity.
  void _showReward(String title, Attribute attribute, double earnedXp, String message) {
    final display = DisplayFont.from(context);
    final color = AppTheme.attributeColor(attribute);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${ctx.l10n.xpGain(earnedXp.toStringAsFixed(1))}  ${ctx.game.attributeName(attribute)}',
              style: display.style(28, color: color),
            ),
            const SizedBox(height: 8),
            Text(message),
          ],
        ),
        actions: [
          PixelButton(label: ctx.l10n.commonGreat, expand: false, onPressed: () => Navigator.of(ctx).pop()),
        ],
      ),
    );
  }

  String _formatTimer(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// Section header: colored attribute square + title.
  Widget _header(String title, Attribute attribute, {Widget? trailing}) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: AppTheme.attributeColor(attribute)),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: DisplayFont.from(context).style(22))),
        ?trailing,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final progress = (_initialSeconds - _pomodoroSeconds) / _initialSeconds;
    final intColor = AppTheme.attributeColor(Attribute.intelligence);
    final conColor = AppTheme.attributeColor(Attribute.constitution);
    final wisColor = AppTheme.attributeColor(Attribute.wisdom);

    return Scaffold(
      appBar: GameAppBar(title: l10n.activitiesTitle),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // --- Pomodoro (INT) ---
          PixelFrame(
            borderColor: intColor,
            child: Column(
              children: [
                _header(
                  '${l10n.pomodoroTitle} · ${context.game.attributeCode(Attribute.intelligence)}',
                  Attribute.intelligence,
                  trailing: Text(l10n.minutesShort((_initialSeconds / 60).round()), style: display.style(17, color: AppTheme.dullSilver)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _subjectController,
                  style: const TextStyle(color: AppTheme.ashWhite, fontSize: 14),
                  decoration: InputDecoration(hintText: l10n.pomodoroSubjectHint, isDense: true),
                ),
                const SizedBox(height: 16),
                Text(_formatTimer(_pomodoroSeconds), style: display.style(72, height: 1)),
                const SizedBox(height: 8),
                SegmentedBar(value: progress, segments: 25, color: intColor, height: 10),
                const SizedBox(height: 14),
                Row(
                  children: [
                    for (final m in const [25, 50]) ...[
                      if (m != 25) const SizedBox(width: 8),
                      Expanded(
                        child: PixelButton(
                          label: l10n.minutesShort(m),
                          variant: (_initialSeconds == m * 60) ? PixelButtonVariant.primary : PixelButtonVariant.secondary,
                          onPressed: _isRunning ? null : () => _resetPomodoro(m),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                PixelButton(
                  label: _isRunning ? l10n.timerPause : l10n.timerStart,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  variant: _isRunning ? PixelButtonVariant.danger : PixelButtonVariant.primary,
                  onPressed: _togglePomodoro,
                ),
                if (_pomodoroSeconds < _initialSeconds)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: _completePomodoroSession, child: Text(l10n.timerFinishNow)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(l10n.healthSection, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          // --- Sleep (CON) ---
          PixelFrame(
            child: Column(
              children: [
                _header(
                  '${l10n.sleepTitle} · ${context.game.attributeCode(Attribute.constitution)}',
                  Attribute.constitution,
                  trailing: Text(l10n.hoursValue(_hoursSlept.toStringAsFixed(1)), style: display.style(24, color: conColor)),
                ),
                Slider(
                  value: _hoursSlept,
                  min: 4.0,
                  max: 12.0,
                  divisions: 16,
                  activeColor: conColor,
                  thumbColor: conColor,
                  onChanged: (val) => setState(() => _hoursSlept = val),
                ),
                PixelButton(label: l10n.sleepLog, variant: PixelButtonVariant.secondary, onPressed: _logSleep),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(l10n.wisdomSection, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          // --- Meditation (WIS) ---
          PixelFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header('${l10n.meditationTitle} · ${context.game.attributeCode(Attribute.wisdom)}', Attribute.wisdom),
                const SizedBox(height: 2),
                Text(l10n.meditationSubtitle, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (final m in const [10, 20]) ...[
                      if (m != 10) const SizedBox(width: 8),
                      Expanded(
                        child: PixelButton(
                          label: l10n.plusMinutes(m),
                          variant: PixelButtonVariant.secondary,
                          icon: PixelIcon(PixelIcons.plus, size: 14, color: wisColor),
                          onPressed: () => _logMeditation(m),
                        ),
                      ),
                    ],
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
