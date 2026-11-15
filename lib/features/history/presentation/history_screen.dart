import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../core/game/weekly_progress.dart';
import '../../../data/database.dart';
import '../../../data/repositories/history_repository.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';
import '../../workout/presentation/workout_format.dart';
import 'exercise_progress_screen.dart';
import 'session_detail_screen.dart';

/// History hub: past workouts, training calendar and personal records.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.historyTitle),
          bottom: TabBar(
            indicatorColor: AppTheme.emberGold,
            indicatorWeight: 3,
            labelColor: AppTheme.emberGold,
            unselectedLabelColor: AppTheme.darkAsh,
            labelStyle: display.style(19),
            dividerColor: AppTheme.forgedSteel,
            tabs: [
              Tab(text: l10n.historyTabWorkouts),
              Tab(text: l10n.historyTabCalendar),
              Tab(text: l10n.historyTabRecords),
            ],
          ),
        ),
        body: const TabBarView(children: [_WorkoutsTab(), _CalendarTab(), _RecordsTab()]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Workouts
// ---------------------------------------------------------------------------

class _WorkoutsTab extends ConsumerWidget {
  const _WorkoutsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return ref.watch(finishedSessionsProvider).when(
          data: (sessions) => sessions.isEmpty
              ? _Empty(text: l10n.historyEmpty)
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [for (final s in sessions) _SessionCard(overview: s)],
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.loadError('$e'))),
        );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.overview});

  final SessionOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.yMMMEd(locale).format(overview.session.completedAt!);
    final stats = <String>[
      WorkoutFormat.duration(overview.duration.inSeconds),
      l10n.workoutSetsDone(overview.completedSets),
      if (overview.volumeKg > 0) l10n.historyVolume(NumberFormat.decimalPattern(locale).format(overview.volumeKg.round())),
    ];

    return PixelFrame(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SessionDetailScreen(overview: overview)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(overview.session.title, style: display.style(21)),
                Text(date, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12)),
                const SizedBox(height: 4),
                Text(stats.join('  ·  '), style: const TextStyle(color: AppTheme.darkAsh, fontSize: 12)),
              ],
            ),
          ),
          if (overview.recordCount > 0)
            PixelTag(
              text: '${overview.recordCount}',
              leading: const PixelIcon(PixelIcons.trophy, size: 12, color: AppTheme.emberGold),
              fontSize: 16,
            ),
          const Icon(Icons.chevron_right, color: AppTheme.darkAsh),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Calendar
// ---------------------------------------------------------------------------

class _CalendarTab extends ConsumerStatefulWidget {
  const _CalendarTab();

  @override
  ConsumerState<_CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends ConsumerState<_CalendarTab> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  void _shift(int months) => setState(() => _month = DateTime(_month.year, _month.month + months));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final days = ref.watch(trainingDaysProvider).valueOrNull ?? const <DateTime>{};
    final letters = l10n.weekdayLetters.split(',');

    final first = DateTime(_month.year, _month.month);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final leading = first.weekday - DateTime.monday; // empty cells before day 1
    final trainedThisMonth = days.where((d) => d.year == _month.year && d.month == _month.month).length;
    final today = WeekCalendar.dayOf(DateTime.now());

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        PixelFrame(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.chevron_left, color: AppTheme.emberGold), onPressed: () => _shift(-1)),
                  Expanded(
                    child: Text(
                      toBeginningOfSentenceCase(DateFormat.yMMMM(locale).format(_month)),
                      textAlign: TextAlign.center,
                      style: display.style(24),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.chevron_right, color: AppTheme.emberGold), onPressed: () => _shift(1)),
                ],
              ),
              const SizedBox(height: 6),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: [
                  for (final l in letters) Center(child: Text(l, style: display.style(16, color: AppTheme.darkAsh))),
                  for (var i = 0; i < leading; i++) const SizedBox.shrink(),
                  for (var d = 1; d <= daysInMonth; d++)
                    _CalendarDay(
                      day: d,
                      trained: days.contains(DateTime(_month.year, _month.month, d)),
                      isToday: DateTime(_month.year, _month.month, d) == today,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(l10n.calendarMonthDays(trainedThisMonth), style: display.style(18, color: AppTheme.emberGold)),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({required this.day, required this.trained, required this.isToday});

  final int day;
  final bool trained;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: trained ? AppTheme.bloodCrimson : AppTheme.obsidianBlack,
        border: Border.all(
          color: trained ? AppTheme.emberGold : (isToday ? AppTheme.dullSilver : AppTheme.forgedSteel),
          width: 2,
        ),
      ),
      child: Text('$day', style: DisplayFont.from(context).style(17, color: trained ? AppTheme.ashWhite : AppTheme.darkAsh)),
    );
  }
}

// ---------------------------------------------------------------------------
// Records
// ---------------------------------------------------------------------------

class _RecordsTab extends ConsumerWidget {
  const _RecordsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return ref.watch(recordsProvider).when(
          data: (records) => records.isEmpty
              ? _Empty(text: l10n.recordsEmpty)
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [for (final (pr, ex) in records) _RecordCard(record: pr, exercise: ex)],
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.loadError('$e'))),
        );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record, required this.exercise});

  final PersonalRecord record;
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    return PixelFrame(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ExerciseProgressScreen(exercise: exercise)),
      ),
      child: Row(
        children: [
          const PixelIcon(PixelIcons.trophy, size: 22, color: AppTheme.emberGold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.exerciseName(exercise.id, exercise.name), style: display.style(20)),
                Text(
                  l10n.recordBest(WorkoutFormat.weight(record.maxWeightKg), record.repsAtMaxWeight),
                  style: const TextStyle(color: AppTheme.ashWhite, fontSize: 12),
                ),
                Text(
                  l10n.recordE1rm(WorkoutFormat.weight(record.estimatedOneRepMax.roundToDouble())),
                  style: const TextStyle(color: AppTheme.darkAsh, fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.darkAsh),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PixelIcon(PixelIcons.scroll, size: 56, color: AppTheme.ironBorder),
              const SizedBox(height: 12),
              Text(text, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}
