import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_border.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../core/game/exercise_taxonomy.dart';
import '../../../data/database.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';

/// Bottom sheet to pick an exercise, with search and muscle filter.
///
/// Filtering happens in memory on the *localized* names, so the search
/// works in any language. Returns the chosen [Exercise] via `Navigator.pop`.
class ExercisePickerSheet extends ConsumerStatefulWidget {
  const ExercisePickerSheet({super.key});

  @override
  ConsumerState<ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends ConsumerState<ExercisePickerSheet> {
  String _query = '';
  MuscleGroup? _muscle;

  /// Lower-case and strip accents so "rosca" matches "Rosca" and "agachamento" matches "Agachamento".
  static String _normalize(String s) {
    const from = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
    const to = 'aaaaaeeeeiiiiooooouuuucn';
    final lower = s.toLowerCase();
    final buffer = StringBuffer();
    for (final ch in lower.split('')) {
      final i = from.indexOf(ch);
      buffer.write(i >= 0 ? to[i] : ch);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final workoutRepo = ref.watch(workoutRepositoryProvider);

    // Material (not a colored Container) so ListTile ink is painted on top.
    return Material(
      color: AppTheme.castIron,
      shape: const PixelBorder(side: BorderSide(color: AppTheme.emberGold, width: 3)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: StreamBuilder<List<Exercise>>(
          stream: workoutRepo.watchAllExercises(),
          builder: (context, snapshot) {
            final all = snapshot.data;
            // Only offer muscle chips that exist in the catalog.
            final muscles = {for (final e in all ?? const <Exercise>[]) e.muscleGroup}.toList()
              ..sort((a, b) => a.index.compareTo(b.index));
            final q = _normalize(_query.trim());
            final visible = (all ?? const <Exercise>[])
                .where((e) => _muscle == null || e.muscleGroup == _muscle)
                .where((e) => q.isEmpty || _normalize(game.exerciseName(e.id, e.name)).contains(q))
                .toList()
              ..sort((a, b) => game.exerciseName(a.id, a.name).compareTo(game.exerciseName(b.id, b.name)));

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: TextField(
                    autofocus: false,
                    onChanged: (v) => setState(() => _query = v),
                    style: const TextStyle(color: AppTheme.ashWhite),
                    decoration: InputDecoration(
                      hintText: l10n.pickerSearchHint,
                      prefixIcon: const Icon(Icons.search, color: AppTheme.emberGold),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _chip(l10n.pickerAll, _muscle == null, () => setState(() => _muscle = null)),
                      for (final m in muscles) _chip(game.muscle(m), _muscle == m, () => setState(() => _muscle = m)),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: all == null
                      ? const Center(child: CircularProgressIndicator())
                      : visible.isEmpty
                          ? Center(child: Text(l10n.pickerEmpty))
                          : ListView.separated(
                              itemCount: visible.length,
                              separatorBuilder: (_, _) => const Divider(indent: 16, endIndent: 16),
                              itemBuilder: (context, i) {
                                final ex = visible[i];
                                return ListTile(
                                  title: Text(game.exerciseName(ex.id, ex.name), style: display.style(20)),
                                  subtitle: Text(
                                    '${game.muscle(ex.muscleGroup)} · ${game.equipment(ex.equipment)}',
                                    style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12),
                                  ),
                                  trailing: PixelTag(
                                    text: game.attributeCode(ex.attribute),
                                    color: AppTheme.attributeColor(ex.attribute),
                                    fontSize: 15,
                                  ),
                                  onTap: () => Navigator.of(context).pop(ex),
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
          labelStyle: DisplayFont.from(context).style(16, color: selected ? AppTheme.obsidianBlack : AppTheme.ashWhite),
        ),
      );
}
