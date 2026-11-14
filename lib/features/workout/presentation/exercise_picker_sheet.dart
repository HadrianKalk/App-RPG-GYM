import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../data/database.dart';
import '../../../data/repositories/providers.dart';

class ExercisePickerSheet extends ConsumerStatefulWidget {
  const ExercisePickerSheet({super.key});

  @override
  ConsumerState<ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends ConsumerState<ExercisePickerSheet> {
  String _selectedMuscle = 'Todos';
  String _searchQuery = '';

  static const _muscleGroups = [
    'Todos',
    'Peitoral',
    'Dorsal',
    'Deltoides',
    'Quadríceps',
    'Isquiotibiais',
    'Glúteos',
    'Bíceps',
    'Tríceps',
    'Panturrilhas',
    'Cardiovascular',
    'Core / Abdômen',
  ];

  @override
  Widget build(BuildContext context) {
    final workoutRepo = ref.watch(workoutRepositoryProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.castIron,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.ironBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(color: AppTheme.ashWhite),
                  decoration: InputDecoration(
                    hintText: 'Buscar exercício...',
                    hintStyle: const TextStyle(color: AppTheme.darkAsh),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.emberGold),
                    filled: true,
                    fillColor: AppTheme.obsidianBlack,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.ironBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.emberGold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _muscleGroups.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final group = _muscleGroups[index];
                      final isSelected = group == _selectedMuscle;
                      return ChoiceChip(
                        label: Text(group, style: TextStyle(fontSize: 12, color: isSelected ? AppTheme.obsidianBlack : AppTheme.ashWhite)),
                        selected: isSelected,
                        selectedColor: AppTheme.emberGold,
                        backgroundColor: AppTheme.obsidianBlack,
                        side: BorderSide(color: isSelected ? AppTheme.emberGold : AppTheme.ironBorder),
                        onSelected: (_) => setState(() => _selectedMuscle = group),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<Exercise>>(
              stream: workoutRepo.watchExercises(
                query: _searchQuery,
                muscleGroup: _selectedMuscle,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: AppTheme.emberGold));
                }

                final exercises = snapshot.data!;
                if (exercises.isEmpty) {
                  return const Center(
                    child: Text('Nenhum exercício encontrado.', style: TextStyle(color: AppTheme.dullSilver)),
                  );
                }

                return ListView.separated(
                  itemCount: exercises.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    final ex = exercises[index];
                    return ListTile(
                      title: Text(ex.name, style: const TextStyle(color: AppTheme.ashWhite, fontWeight: FontWeight.bold)),
                      subtitle: Text('${ex.muscleGroup} • ${ex.equipment}', style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.obsidianBlack,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.ironBorder),
                        ),
                        child: Text(
                          ex.attribute.code,
                          style: const TextStyle(color: AppTheme.emberGold, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop(ex),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
