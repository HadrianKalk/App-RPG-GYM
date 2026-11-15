import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../core/game/weekly_progress.dart';
import '../../../core/game/xp_rules.dart';
import '../../../data/repositories/history_repository.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';

/// Weekly streak ("Flame of Constancy") + this week's day strip.
class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final days = ref.watch(trainingDaysProvider).valueOrNull ?? const <DateTime>{};
    final goal = ref.watch(heroStreamProvider).valueOrNull?.weeklyGoal ?? XpRules.weeklyGoalDefault;

    final now = DateTime.now();
    final weekStart = WeekCalendar.weekStart(now);
    final streak = WeeklyProgress.streakIncludingCurrent(
      trainingDaysByWeek: HistoryRepository.daysByWeek(days),
      now: now,
      goal: goal,
    );
    final weekDays = [for (var i = 0; i < 7; i++) DateTime(weekStart.year, weekStart.month, weekStart.day + i)];
    final doneThisWeek = weekDays.where(days.contains).length;
    final letters = l10n.weekdayLetters.split(',');
    final today = WeekCalendar.dayOf(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PixelIcon(PixelIcons.flame, size: 18, color: streak > 0 ? AppTheme.emberOrange : AppTheme.darkAsh, accent: AppTheme.emberGold),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.streakTitle, style: const TextStyle(color: AppTheme.ashWhite, fontSize: 13, fontWeight: FontWeight.w600))),
            Text(l10n.streakWeeks(streak), style: display.style(18, color: AppTheme.emberGold)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < 7; i++) ...[
              if (i > 0) const SizedBox(width: 5),
              _DayBox(
                letter: letters.length == 7 ? letters[i] : '',
                trained: days.contains(weekDays[i]),
                isToday: weekDays[i] == today,
              ),
            ],
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                doneThisWeek >= goal ? l10n.streakGoalHit(doneThisWeek, goal) : l10n.streakWeekStatus(doneThisWeek, goal),
                textAlign: TextAlign.right,
                style: TextStyle(color: doneThisWeek >= goal ? AppTheme.emberGold : AppTheme.dullSilver, fontSize: 11),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DayBox extends StatelessWidget {
  const _DayBox({required this.letter, required this.trained, required this.isToday});

  final String letter;
  final bool trained;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: trained ? AppTheme.bloodCrimson : AppTheme.obsidianBlack,
        border: Border.all(
          color: trained ? AppTheme.emberGold : (isToday ? AppTheme.dullSilver : AppTheme.ironBorder),
          width: 2,
        ),
      ),
      child: Text(
        letter,
        style: DisplayFont.from(context).style(15, color: trained ? AppTheme.ashWhite : AppTheme.darkAsh),
      ),
    );
  }
}
