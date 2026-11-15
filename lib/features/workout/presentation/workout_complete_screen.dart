import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_sprite.dart';
import '../../../app/ui/segmented_bar.dart';
import '../../../core/game/hero_appearance.dart';
import '../../../core/game/weekly_progress.dart';
import '../../../data/repositories/providers.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../l10n/l10n.dart';
import 'workout_format.dart';

/// One line of the rewards list.
class _RewardLine {
  const _RewardLine({required this.title, required this.value, this.reason, this.bonus = false, this.icon});

  final String title;
  final String value;
  final String? reason;

  /// Bonus lines are highlighted in gold (they are the "dopamine" part).
  final bool bonus;
  final List<String>? icon;
}

/// "Workout Complete!" — every XP gain is listed with its reason, revealed
/// one line at a time, then level/attribute/week highlights.
class WorkoutCompleteScreen extends ConsumerStatefulWidget {
  const WorkoutCompleteScreen({super.key, required this.summary, required this.exerciseNames});

  final WorkoutSummary summary;

  /// Localized names by exercise id (records lines).
  final Map<String, String> exerciseNames;

  @override
  ConsumerState<WorkoutCompleteScreen> createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends ConsumerState<WorkoutCompleteScreen> with TickerProviderStateMixin {
  /// Delay between two reward lines.
  static const _lineDelay = Duration(milliseconds: 420);

  late final AnimationController _reveal;
  late final AnimationController _glow;
  int _lineCount = 0;

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
    _reveal = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lines depend on localization, so the reveal length is set here.
    final count = _lines(context).length;
    if (count != _lineCount) {
      _lineCount = count;
      _reveal
        ..duration = _lineDelay * (count + 2)
        ..forward(from: 0);
    }
  }

  @override
  void dispose() {
    _reveal.dispose();
    _glow.dispose();
    super.dispose();
  }

  String _xp(double v) => context.l10n.xpGain(v.round().toString());

  List<_RewardLine> _lines(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final s = widget.summary;
    return [
      _RewardLine(
        title: l10n.rewardsSetsLine(s.completedSets),
        value: _xp(s.setXp),
        reason: s.xpByAttribute.keys.map(game.attributeCode).join(' · '),
      ),
      for (final r in s.records.where((r) => r.bonusXp > 0))
        _RewardLine(
          title: l10n.rewardsRecordLine(widget.exerciseNames[r.exerciseId] ?? r.exerciseId, WorkoutFormat.weight(r.weightKg)),
          value: _xp(r.bonusXp),
          reason: '× ${r.reps}',
          bonus: true,
          icon: PixelIcons.trophy,
        ),
      for (final q in s.completedQuests)
        _RewardLine(
          title: l10n.rewardsQuestLine(game.questTitle(q.title, q.description)),
          value: '${_xp(q.bonusXp)}  ✦+1',
          reason: game.attributeCode(q.targetAttribute),
          bonus: true,
          icon: PixelIcons.scroll,
        ),
      for (final b in s.weeklyBonuses)
        switch (b.kind) {
          WeeklyBonusKind.goalMet => _RewardLine(
              title: l10n.bonusGoalMet(b.trainingDay, b.goal),
              value: _xp(b.xp),
              reason: l10n.bonusWeekLabel,
              bonus: true,
              icon: PixelIcons.check,
            ),
          WeeklyBonusKind.beyondDuty => _RewardLine(
              title: l10n.bonusBeyondDuty(b.trainingDay),
              value: _xp(b.xp),
              reason: l10n.bonusWeekLabel,
              bonus: true,
              icon: PixelIcons.star,
            ),
          WeeklyBonusKind.flame => _RewardLine(
              title: l10n.bonusFlame(b.streakWeeks),
              value: _xp(b.xp),
              reason: l10n.bonusFlameReason(b.flamePercent),
              bonus: true,
              icon: PixelIcons.flame,
            ),
        },
    ];
  }

  /// 0..1 visibility of line [i] (each fades/slides in after the previous).
  double _lineT(int i) {
    final total = _lineCount + 2;
    final start = i / total;
    final end = (i + 1) / total;
    return ((_reveal.value - start) / (end - start)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final s = widget.summary;
    final lines = _lines(context);
    final weekDone = s.weeklyGoal > 0 && s.trainingDay >= s.weeklyGoal;
    final hero = ref.watch(heroStreamProvider).valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_reveal, _glow]),
          builder: (context, _) {
            final finalT = _lineT(lines.length);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              children: [
                // Hero flexing with a pulsing ember glow.
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.emberOrange.withValues(alpha: 0.25 + 0.25 * _glow.value),
                          blurRadius: 40,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: HeroAvatar(
                      appearance: hero?.appearance ?? HeroAppearance.defaultAppearance,
                      equippedCosmeticId: hero?.equippedCosmeticId,
                      pose: HeroPose.flex,
                      pixelSize: 4.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(l10n.workoutDoneTitle, textAlign: TextAlign.center, style: display.style(42, color: AppTheme.emberGold, height: 1)),
                const SizedBox(height: 4),
                Text(
                  '${l10n.workoutDoneFlavor}  ·  ${WorkoutFormat.duration(s.duration.inSeconds)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13),
                ),
                const SizedBox(height: 14),
                PixelFrame(
                  highlight: true,
                  child: Column(
                    children: [
                      for (var i = 0; i < lines.length; i++)
                        Opacity(
                          opacity: _lineT(i),
                          child: Transform.translate(
                            offset: Offset(24 * (1 - _lineT(i)), 0),
                            child: _LineView(line: lines[i]),
                          ),
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(l10n.rewardsTotal, style: display.style(28, color: AppTheme.emberGold)),
                          const Spacer(),
                          // Total counts up while the lines appear.
                          Text(
                            _xp(s.totalXp * _reveal.value.clamp(0.0, 1.0)),
                            style: display.style(30, color: AppTheme.emberGold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Opacity(
                  opacity: finalT,
                  child: Column(
                    children: [
                      // Weekly progress (always shown).
                      PixelFrame(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const PixelIcon(PixelIcons.flame, size: 18, color: AppTheme.emberOrange),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    weekDone ? l10n.rewardsWeekDone : l10n.rewardsWeekProgress(s.trainingDay, s.weeklyGoal),
                                    style: display.style(20, color: weekDone ? AppTheme.emberGold : AppTheme.ashWhite),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            SegmentedBar(
                              value: s.weeklyGoal == 0 ? 0 : s.trainingDay / s.weeklyGoal,
                              segments: s.weeklyGoal.clamp(1, 7),
                              height: 10,
                              color: AppTheme.emberOrange,
                            ),
                            if (s.repeatedDay) ...[
                              const SizedBox(height: 6),
                              Text(l10n.rewardsNoWeeklyBonus, style: const TextStyle(color: AppTheme.darkAsh, fontSize: 11)),
                            ],
                            if (s.curveReduced) ...[
                              const SizedBox(height: 6),
                              Text(l10n.dailyCurveNote, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 11)),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (s.progress?.leveledUp ?? false)
                        _Banner(icon: PixelIcons.star, text: l10n.rewardsLevelUp(s.progress!.levelAfter)),
                      for (final a in s.progress?.attributes ?? const [])
                        _Banner(
                          icon: PixelIcons.plus,
                          color: AppTheme.attributeColor(a.attribute),
                          text: l10n.rewardsAttributeUp(game.attributeName(a.attribute), a.to),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                PixelButton(label: l10n.commonContinueShort, onPressed: () => Navigator.of(context).pop()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LineView extends StatelessWidget {
  const _LineView({required this.line});

  final _RewardLine line;

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    final color = line.bonus ? AppTheme.emberGold : AppTheme.ashWhite;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.forgedSteel, width: 2))),
      child: Row(
        children: [
          if (line.icon != null) ...[
            PixelIcon(line.icon!, size: 16, color: color),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.title, style: TextStyle(color: color, fontSize: 13, fontWeight: line.bonus ? FontWeight.w600 : FontWeight.w400)),
                if (line.reason != null && line.reason!.isNotEmpty)
                  Text(line.reason!, style: const TextStyle(color: AppTheme.darkAsh, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(line.value, style: display.style(21, color: color)),
        ],
      ),
    );
  }
}

/// Crimson celebration banner (level / attribute up).
class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.text, this.color = AppTheme.emberGold});

  final List<String> icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: AppTheme.darkBlood, border: Border.all(color: AppTheme.bloodCrimson, width: 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PixelIcon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Flexible(child: Text(text, style: DisplayFont.from(context).style(22))),
        ],
      ),
    );
  }
}
