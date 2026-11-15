import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/game_app_bar.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../app/ui/segmented_bar.dart';
import '../../../core/game/activity_catalog.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/xp_rules.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';

class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen> {
  // Pomodoro timer state.
  Timer? _pomodoroTimer;
  int _pomodoroSeconds = 25 * 60;
  int _initialSeconds = 25 * 60;
  bool _isRunning = false;
  final TextEditingController _subjectController = TextEditingController();

  // Sleep slider state.
  double _hoursSlept = 7.5;

  // Catalog attribute filter (null = All).
  Attribute? _selectedAttribute;

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
    final minutes = elapsedMinutes > 0
        ? elapsedMinutes
        : (_initialSeconds / 60).round();
    final subject = _subjectController.text.trim();
    final result = await ref
        .read(activityRepositoryProvider)
        .completeCatalogActivity(
          activityId: 'act_pomodoro',
          durationMinutes: minutes,
          subject: subject.isNotEmpty ? subject : l10n.pomodoroDefaultSubject,
        );
    _resetPomodoro(25);
    if (mounted) {
      _showRewardSummary(
        result,
        baseLabel: l10n.activityRewardBaseLine(
          subject.isNotEmpty ? subject : context.game.activityName('act_pomodoro'),
          minutes,
        ),
      );
    }
  }

  Future<void> _logCatalogActivity(
    ActivityDefinition activity,
    int minutes,
  ) async {
    final result = await ref
        .read(activityRepositoryProvider)
        .completeCatalogActivity(
          activityId: activity.id,
          durationMinutes: minutes,
        );
    if (mounted) {
      _showRewardSummary(
        result,
        baseLabel: context.l10n.activityRewardBaseLine(
          context.game.activityName(activity.id),
          minutes,
        ),
      );
    }
  }

  Future<void> _logSleep() async {
    final l10n = context.l10n;
    final result = await ref
        .read(activityRepositoryProvider)
        .completeSleep(hoursSlept: _hoursSlept);
    if (mounted) {
      _showRewardSummary(
        result,
        baseLabel:
            '${l10n.sleepTitle} (${l10n.hoursValue(_hoursSlept.toStringAsFixed(1))})',
      );
    }
  }

  Future<void> _changeWater(int delta, int goalCups) async {
    final result = await ref
        .read(activityRepositoryProvider)
        .updateWaterCups(delta: delta, goalCups: goalCups);
    if (!mounted || result == null) return;

    final hasCelebration = result.bonusXp > 0 ||
        result.completedQuests.isNotEmpty ||
        result.progress.leveledUp ||
        result.progress.attributes.isNotEmpty;

    if (hasCelebration) {
      _showRewardSummary(
        result,
        baseLabel: context.l10n.hydrationTitle,
        bonusLabel: result.bonusXp > 0 ? context.l10n.hydrationBonusLine : null,
      );
    } else {
      final code = context.game.attributeCode(Attribute.constitution);
      final xpStr = context.l10n.xpGain(result.baseXp.toStringAsFixed(0));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1200),
            content: Text('$xpStr · $code (${context.l10n.hydrationTitle})'),
          ),
        );
    }
  }

  Future<void> _logDiet(DietAdherence adherence) async {
    final l10n = context.l10n;
    final result = await ref
        .read(activityRepositoryProvider)
        .completeDietCheckIn(adherence: adherence);
    if (!mounted || result == null) return;
    final label = adherence == DietAdherence.onTrack
        ? l10n.dietOnTrackButton
        : l10n.dietPartialButton;
    _showRewardSummary(result, baseLabel: '${l10n.dietTitle}: $label');
  }

  Future<void> _openCustomActivitySheet() async {
    final result = await showModalBottomSheet<ActivityRewardResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.castIron,
      builder: (_) => const _CustomActivitySheet(),
    );
    if (!mounted || result == null) return;
    final label = result.customTitle ?? context.l10n.customActivityDefaultName;
    _showRewardSummary(
      result,
      baseLabel: context.l10n.activityRewardBaseLine(
        label,
        result.durationMinutes,
      ),
    );
  }

  void _showRewardSummary(
    ActivityRewardResult result, {
    required String baseLabel,
    String? bonusLabel,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => _ActivityRewardDialog(
        result: result,
        baseLabel: baseLabel,
        bonusLabel: bonusLabel,
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
        Container(
          width: 10,
          height: 10,
          color: AppTheme.attributeColor(attribute),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: DisplayFont.from(context).style(22)),
        ),
        ?trailing,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final progress = (_initialSeconds - _pomodoroSeconds) / _initialSeconds;
    final intColor = AppTheme.attributeColor(Attribute.intelligence);
    final conColor = AppTheme.attributeColor(Attribute.constitution);

    final waterGoal = ref.watch(heroStreamProvider).valueOrNull?.waterGoalCups ??
        XpRules.waterGoalDefaultCups;
    final todayHealth = ref.watch(todayHealthStreamProvider).valueOrNull;
    final waterCups = todayHealth?.waterCups ?? 0;
    final waterGoalMet = waterCups >= waterGoal;
    final dietAdherence = todayHealth?.dietAdherence;
    final lastSleep = todayHealth?.lastSleepHours;

    final catalogActivities = ActivityCatalog.durationActivities(
      attribute: _selectedAttribute,
    );

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
                  '${l10n.pomodoroTitle} · ${game.attributeCode(Attribute.intelligence)}',
                  Attribute.intelligence,
                  trailing: Text(
                    l10n.minutesShort((_initialSeconds / 60).round()),
                    style: display.style(17, color: AppTheme.dullSilver),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _subjectController,
                  style: const TextStyle(color: AppTheme.ashWhite, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.pomodoroSubjectHint,
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _formatTimer(_pomodoroSeconds),
                  style: display.style(72, height: 1),
                ),
                const SizedBox(height: 8),
                SegmentedBar(
                  value: progress,
                  segments: 25,
                  color: intColor,
                  height: 10,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    for (final m in const [25, 50]) ...[
                      if (m != 25) const SizedBox(width: 8),
                      Expanded(
                        child: PixelButton(
                          label: l10n.minutesShort(m),
                          variant: (_initialSeconds == m * 60)
                              ? PixelButtonVariant.primary
                              : PixelButtonVariant.secondary,
                          onPressed:
                              _isRunning ? null : () => _resetPomodoro(m),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                PixelButton(
                  label: _isRunning ? l10n.timerPause : l10n.timerStart,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  variant: _isRunning
                      ? PixelButtonVariant.danger
                      : PixelButtonVariant.primary,
                  onPressed: _togglePomodoro,
                ),
                if (_pomodoroSeconds < _initialSeconds)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _completePomodoroSession,
                      child: Text(l10n.timerFinishNow),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Text(
            l10n.healthSection,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),

          // --- Hydration (CON) ---
          PixelFrame(
            borderColor: waterGoalMet ? AppTheme.emberGold : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(
                  '${l10n.hydrationTitle} · ${game.attributeCode(Attribute.constitution)}',
                  Attribute.constitution,
                  trailing: Text(
                    l10n.hydrationProgress(
                      waterCups,
                      waterGoal,
                      waterCups * XpRules.waterCupMl,
                    ),
                    style: display.style(
                      18,
                      color: waterGoalMet ? AppTheme.emberGold : conColor,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.hydrationSubtitle,
                  style: const TextStyle(
                    color: AppTheme.dullSilver,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                SegmentedBar(
                  value: waterGoal > 0
                      ? (waterCups / waterGoal).clamp(0.0, 1.0)
                      : 0.0,
                  segments: waterGoal.clamp(4, 16),
                  color: waterGoalMet ? AppTheme.emberGold : conColor,
                  height: 10,
                ),
                if (waterGoalMet) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const PixelIcon(
                        PixelIcons.check,
                        size: 14,
                        color: AppTheme.emberGold,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.hydrationGoalMetBadge,
                        style: display.style(16, color: AppTheme.emberGold),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      key: const Key('water_minus_btn'),
                      onTap: waterCups > 0
                          ? () => _changeWater(-1, waterGoal)
                          : null,
                      child: Container(
                        width: 44,
                        height: 42,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.ironBorder,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 18,
                          color: waterCups > 0
                              ? AppTheme.ashWhite
                              : AppTheme.forgedSteel,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PixelButton(
                        key: const Key('water_add_btn'),
                        label: l10n.hydrationAddCup,
                        variant: PixelButtonVariant.secondary,
                        icon: PixelIcon(
                          PixelIcons.plus,
                          size: 14,
                          color: conColor,
                        ),
                        onPressed: waterCups < XpRules.waterMaxDailyCups
                            ? () => _changeWater(1, waterGoal)
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // --- Nutrition / Diet Check-in (CON) ---
          PixelFrame(
            borderColor: dietAdherence != null ? AppTheme.emberGold : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(
                  '${l10n.dietTitle} · ${game.attributeCode(Attribute.constitution)}',
                  Attribute.constitution,
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.dietSubtitle,
                  style: const TextStyle(
                    color: AppTheme.dullSilver,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                if (dietAdherence != null)
                  Row(
                    children: [
                      const PixelIcon(
                        PixelIcons.check,
                        size: 16,
                        color: AppTheme.emberGold,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          dietAdherence == DietAdherence.onTrack
                              ? l10n.dietDoneOnTrack
                              : l10n.dietDonePartial,
                          style: display.style(18, color: AppTheme.emberGold),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: PixelButton(
                          key: const Key('diet_on_track_btn'),
                          label: l10n.dietOnTrackButton,
                          variant: PixelButtonVariant.primary,
                          onPressed: () => _logDiet(DietAdherence.onTrack),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PixelButton(
                          key: const Key('diet_partial_btn'),
                          label: l10n.dietPartialButton,
                          variant: PixelButtonVariant.secondary,
                          onPressed: () => _logDiet(DietAdherence.partial),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // --- Sleep (CON) ---
          PixelFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(
                  '${l10n.sleepTitle} · ${game.attributeCode(Attribute.constitution)}',
                  Attribute.constitution,
                  trailing: Text(
                    l10n.hoursValue(_hoursSlept.toStringAsFixed(1)),
                    style: display.style(24, color: conColor),
                  ),
                ),
                if (lastSleep != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.sleepLoggedToday(lastSleep.toStringAsFixed(1)),
                    style: const TextStyle(
                      color: AppTheme.emberGold,
                      fontSize: 12,
                    ),
                  ),
                ],
                Slider(
                  value: _hoursSlept,
                  min: 4.0,
                  max: 12.0,
                  divisions: 16,
                  activeColor: conColor,
                  thumbColor: conColor,
                  onChanged: (val) => setState(() => _hoursSlept = val),
                ),
                PixelButton(
                  label: l10n.sleepLog,
                  variant: PixelButtonVariant.secondary,
                  onPressed: _logSleep,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Text(
            l10n.activitiesCatalogSection,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          // --- Attribute Filter Bar ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.pickerAll,
                  selected: _selectedAttribute == null,
                  color: AppTheme.emberGold,
                  onTap: () => setState(() => _selectedAttribute = null),
                ),
                for (final attr in ActivityCatalog.catalogAttributes) ...[
                  const SizedBox(width: 6),
                  _FilterChip(
                    key: Key('filter_${attr.name}'),
                    label:
                        '${game.attributeCode(attr)} · ${game.attributeName(attr)}',
                    selected: _selectedAttribute == attr,
                    color: AppTheme.attributeColor(attr),
                    onTap: () => setState(() => _selectedAttribute = attr),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),

          // --- Catalog Activity Cards ---
          for (final activity in catalogActivities) ...[
            _CatalogActivityCard(
              activity: activity,
              onSelectMinutes: (m) => _logCatalogActivity(activity, m),
            ),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 4),
          PixelButton(
            key: const Key('open_custom_activity_btn'),
            label: l10n.activitiesCustomButton,
            icon: const PixelIcon(
              PixelIcons.plus,
              size: 14,
              color: AppTheme.obsidianBlack,
            ),
            onPressed: _openCustomActivitySheet,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.18) : AppTheme.castIron,
          border: Border.all(
            color: selected ? color : AppTheme.ironBorder,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: display.style(
            16,
            color: selected ? color : AppTheme.dullSilver,
          ),
        ),
      ),
    );
  }
}

class _CatalogActivityCard extends StatelessWidget {
  const _CatalogActivityCard({
    required this.activity,
    required this.onSelectMinutes,
  });

  final ActivityDefinition activity;
  final ValueChanged<int> onSelectMinutes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final color = AppTheme.attributeColor(activity.attribute);
    final title = game.activityName(activity.id);
    final description = game.activityDescription(activity.id);

    return PixelFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 10, height: 10, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$title · ${game.attributeCode(activity.attribute)}',
                  style: DisplayFont.from(context).style(21),
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              description,
              style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < activity.presetsMinutes.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: PixelButton(
                    key: Key('${activity.id}_${activity.presetsMinutes[i]}'),
                    label: l10n.plusMinutes(activity.presetsMinutes[i]),
                    variant: PixelButtonVariant.secondary,
                    icon: PixelIcon(PixelIcons.plus, size: 13, color: color),
                    onPressed: () =>
                        onSelectMinutes(activity.presetsMinutes[i]),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomActivitySheet extends ConsumerStatefulWidget {
  const _CustomActivitySheet();

  @override
  ConsumerState<_CustomActivitySheet> createState() =>
      _CustomActivitySheetState();
}

class _CustomActivitySheetState extends ConsumerState<_CustomActivitySheet> {
  final TextEditingController _nameController = TextEditingController();
  Attribute _attribute = Attribute.charisma;
  int _minutes = 20;
  double _intensity = XpRules.intensityModerate;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final raw = _nameController.text.trim();
    final title = raw.isNotEmpty ? raw : l10n.customActivityDefaultName;
    final result = await ref
        .read(activityRepositoryProvider)
        .completeCustomActivity(
          title: title,
          attribute: _attribute,
          durationMinutes: _minutes,
          intensity: _intensity,
        );
    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final intensities = [
      (XpRules.intensityLight, l10n.intensityLightLabel),
      (XpRules.intensityModerate, l10n.intensityModerateLabel),
      (XpRules.intensityHard, l10n.intensityHardLabel),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.customActivityTitle, style: display.style(26)),
            const SizedBox(height: 12),
            Text(
              l10n.customActivityNameLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            TextField(
              key: const Key('custom_activity_name_input'),
              controller: _nameController,
              style: const TextStyle(color: AppTheme.ashWhite, fontSize: 14),
              decoration: InputDecoration(
                hintText: l10n.customActivityNameHint,
                isDense: true,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.customActivityAttributeLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final attr in Attribute.values)
                  _FilterChip(
                    key: Key('custom_attr_${attr.name}'),
                    label:
                        '${game.attributeCode(attr)} · ${game.attributeName(attr)}',
                    selected: _attribute == attr,
                    color: AppTheme.attributeColor(attr),
                    onTap: () => setState(() => _attribute = attr),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.customActivityDurationLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  l10n.minutesShort(_minutes),
                  style: display.style(22, color: AppTheme.emberGold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                for (final preset in const [15, 30, 45, 60]) ...[
                  if (preset != 15) const SizedBox(width: 6),
                  Expanded(
                    child: PixelButton(
                      label: l10n.minutesShort(preset),
                      variant: _minutes == preset
                          ? PixelButtonVariant.primary
                          : PixelButtonVariant.secondary,
                      onPressed: () => setState(() => _minutes = preset),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),
            Text(
              l10n.customActivityIntensityLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                for (var i = 0; i < intensities.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: PixelButton(
                      label: intensities[i].$2,
                      variant: _intensity == intensities[i].$1
                          ? PixelButtonVariant.primary
                          : PixelButtonVariant.secondary,
                      onPressed: () =>
                          setState(() => _intensity = intensities[i].$1),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 18),
            PixelButton(
              key: const Key('custom_activity_submit_btn'),
              label: l10n.customActivitySubmit,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Celebration dialog presenting the breakdown of XP, bonuses, completed quests
/// and attribute/level increases after an activity.
class _ActivityRewardDialog extends StatelessWidget {
  const _ActivityRewardDialog({
    required this.result,
    required this.baseLabel,
    this.bonusLabel,
  });

  final ActivityRewardResult result;
  final String baseLabel;
  final String? bonusLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final attrColor = AppTheme.attributeColor(result.attribute);

    String fmtXp(double v) => l10n.xpGain(
          v == v.roundToDouble() ? v.round().toString() : v.toStringAsFixed(1),
        );

    return AlertDialog(
      title: Text(l10n.activityRewardTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PixelTag(
                text: game.attributeName(result.attribute),
                color: attrColor,
              ),
              const Spacer(),
              Text(
                fmtXp(result.totalXp),
                style: display.style(30, color: AppTheme.emberGold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _RewardRow(
            label: baseLabel,
            value: fmtXp(result.baseXp),
            color: AppTheme.ashWhite,
          ),
          if (result.bonusXp > 0) ...[
            const SizedBox(height: 6),
            _RewardRow(
              label: bonusLabel ?? l10n.hydrationBonusLine,
              value: fmtXp(result.bonusXp),
              color: AppTheme.emberGold,
            ),
          ],
          for (final q in result.completedQuests) ...[
            const SizedBox(height: 6),
            _RewardRow(
              label: l10n.rewardsQuestLine(
                game.questTitle(q.title, q.description),
              ),
              value: '${fmtXp(q.bonusXp)}  ✦+1',
              color: AppTheme.emberGold,
            ),
          ],
          if (result.progress.leveledUp) ...[
            const SizedBox(height: 10),
            PixelFrame(
              borderColor: AppTheme.emberGold,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  const PixelIcon(
                    PixelIcons.star,
                    size: 18,
                    color: AppTheme.emberGold,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.rewardsLevelUp(result.progress.levelAfter),
                      style: display.style(19, color: AppTheme.emberGold),
                    ),
                  ),
                ],
              ),
            ),
          ],
          for (final inc in result.progress.attributes) ...[
            const SizedBox(height: 6),
            PixelFrame(
              borderColor: AppTheme.attributeColor(inc.attribute),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                l10n.rewardsAttributeUp(
                  game.attributeName(inc.attribute),
                  inc.to,
                ),
                style: display.style(
                  18,
                  color: AppTheme.attributeColor(inc.attribute),
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        PixelButton(
          label: l10n.commonGreat,
          expand: false,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: color, fontSize: 13),
          ),
        ),
        const SizedBox(width: 8),
        Text(value, style: display.style(18, color: color)),
      ],
    );
  }
}
