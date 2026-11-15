import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_border.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../data/database.dart';
import '../../../l10n/l10n.dart';

/// Opens the step-by-step execution guide modal for [exercise].
Future<void> showExerciseGuide(BuildContext context, Exercise exercise) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ExerciseGuideSheet(exercise: exercise),
  );
}

/// Compact "?" button that opens the step-by-step guide for [exercise].
class ExerciseHelpButton extends StatelessWidget {
  const ExerciseHelpButton({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    return Tooltip(
      message: context.l10n.exerciseGuideTooltip,
      child: InkWell(
        key: Key('help_${exercise.id}'),
        onTap: () => showExerciseGuide(context, exercise),
        child: Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.obsidianBlack,
            border: Border.all(color: AppTheme.ironBorder, width: 2),
          ),
          child: Text(
            '?',
            style: display.style(17, color: AppTheme.emberGold, height: 1),
          ),
        ),
      ),
    );
  }
}

/// Modal bottom sheet showing muscle group, equipment and step-by-step form
/// cues for a catalog [exercise].
class ExerciseGuideSheet extends StatelessWidget {
  const ExerciseGuideSheet({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final attrColor = AppTheme.attributeColor(exercise.attribute);
    final steps = game.exerciseSteps(exercise.id);

    return Material(
      color: AppTheme.castIron,
      shape: const PixelBorder(
        side: BorderSide(color: AppTheme.emberGold, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const PixelIcon(
                      PixelIcons.dumbbell,
                      size: 20,
                      color: AppTheme.emberGold,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.exerciseGuideTitle,
                        style: display.style(18, color: AppTheme.dullSilver),
                      ),
                    ),
                    PixelTag(
                      text:
                          '${game.attributeCode(exercise.attribute)} · ${game.attributeName(exercise.attribute)}',
                      color: attrColor,
                      fontSize: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  game.exerciseName(exercise.id, exercise.name),
                  style: display.style(28, color: AppTheme.ashWhite),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    PixelTag(
                      text: game.muscle(exercise.muscleGroup),
                      color: AppTheme.emberGold,
                      fontSize: 15,
                    ),
                    PixelTag(
                      text: game.equipment(exercise.equipment),
                      color: AppTheme.dullSilver,
                      fontSize: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Visual placeholder frame for future exercise sprite / diagram.
                PixelFrame(
                  color: AppTheme.obsidianBlack,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      PixelIcon(
                        PixelIcons.shield,
                        size: 28,
                        color: attrColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.exerciseGuideSpriteNote,
                          style: const TextStyle(
                            color: AppTheme.dullSilver,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.exerciseGuideStepsTitle,
                  style: display.style(20, color: AppTheme.emberGold),
                ),
                const SizedBox(height: 8),
                for (var i = 0; i < steps.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  PixelFrame(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: attrColor.withValues(alpha: 0.18),
                            border: Border.all(color: attrColor, width: 2),
                          ),
                          child: Text(
                            '${i + 1}',
                            style: display.style(16, color: attrColor, height: 1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            steps[i],
                            style: const TextStyle(
                              color: AppTheme.ashWhite,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                PixelButton(
                  label: l10n.commonGreat,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
