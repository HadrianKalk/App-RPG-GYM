import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/progression.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';

/// Opens the modal bottom sheet for the Tester Mode sandbox panel.
Future<void> showTesterPanelSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppTheme.obsidianBlack,
    isScrollControlled: true,
    builder: (_) => const TesterPanelSheet(),
  );
}

/// Interactive sandbox panel that lets the user edit the 6 D&D attributes,
/// toggle infinite combat tokens, and force specific d20 outcomes (`20` or `1`)
/// to test classes and combat modes without altering `xp_ledger`.
class TesterPanelSheet extends ConsumerWidget {
  const TesterPanelSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final tester = ref.watch(testerModeProvider);
    final notifier = ref.read(testerModeProvider.notifier);
    final char = ref.watch(characterStreamProvider).valueOrNull;

    Widget stepBtn(Key key, String label, VoidCallback onTap) {
      return InkWell(
        key: key,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.obsidianBlack,
            border: Border.all(color: AppTheme.ironBorder, width: 2),
          ),
          child: Text(
            label,
            style: display.style(16, color: AppTheme.emberGold),
          ),
        ),
      );
    }

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
                child: Row(
                  children: [
                    const PixelIcon(
                      PixelIcons.gear,
                      size: 24,
                      color: AppTheme.emberGold,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.testerSheetTitle,
                        style: display.style(26, color: AppTheme.emberGold),
                      ),
                    ),
                    IconButton(
                      key: const Key('tester_close_btn'),
                      icon: const Icon(Icons.close, color: AppTheme.dullSilver),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  children: [
                    Text(
                      l10n.testerSheetSubtitle,
                      style: const TextStyle(
                        color: AppTheme.dullSilver,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),

              // --- Enable / Disable Switch + Active Summary ----------------
              PixelFrame(
                highlight: tester.enabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            l10n.testerEnableSwitch,
                            style: display.style(
                              22,
                              color: tester.enabled
                                  ? AppTheme.emberGold
                                  : AppTheme.ashWhite,
                            ),
                          ),
                        ),
                        Switch(
                          key: const Key('tester_enable_switch'),
                          value: tester.enabled,
                          activeThumbColor: AppTheme.emberGold,
                          onChanged: notifier.setEnabled,
                        ),
                      ],
                    ),
                    if (char != null) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          PixelTag(
                            text: l10n.characterLevel(char.levelInfo.level),
                            color: AppTheme.emberGold,
                          ),
                          PixelTag(
                            text: game.className(char.characterClass),
                            color: AppTheme.dullSilver,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // --- Quick Presets -------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: PixelButton(
                      key: const Key('tester_preset_10'),
                      label: l10n.testerPresetNovice,
                      variant: PixelButtonVariant.secondary,
                      onPressed: () => notifier.applyPreset({
                        for (final a in Attribute.values) a: 10,
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: PixelButton(
                      key: const Key('tester_preset_16'),
                      label: l10n.testerPresetBalanced,
                      variant: PixelButtonVariant.secondary,
                      onPressed: () => notifier.applyPreset({
                        for (final a in Attribute.values) a: 16,
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: PixelButton(
                      key: const Key('tester_preset_22'),
                      label: l10n.testerPresetLegend,
                      variant: PixelButtonVariant.secondary,
                      onPressed: () => notifier.applyPreset({
                        for (final a in Attribute.values) a: 22,
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // --- Forced D20 Roll Selector --------------------------------
              Text(
                l10n.testerDiceModeTitle,
                style: display.style(22, color: AppTheme.emberGold),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    key: const Key('tester_d20_random'),
                    label: Text(l10n.testerDiceRandom),
                    selected: tester.forcedD20 == null,
                    onSelected: (_) => notifier.setForcedD20(null),
                  ),
                  ChoiceChip(
                    key: const Key('tester_d20_20'),
                    label: Text(l10n.testerDiceForce20),
                    selected: tester.forcedD20 == 20,
                    onSelected: (_) => notifier.setForcedD20(20),
                  ),
                  ChoiceChip(
                    key: const Key('tester_d20_1'),
                    label: Text(l10n.testerDiceForce1),
                    selected: tester.forcedD20 == 1,
                    onSelected: (_) => notifier.setForcedD20(1),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // --- 6 Attribute Editors -------------------------------------
              for (final attr in Attribute.values) ...[
                Builder(
                  builder: (context) {
                    final score = tester.scores[attr] ?? 10;
                    final mod = Progression.calculateModifier(score);
                    final modStr = mod >= 0 ? '+$mod' : '$mod';
                    final color = AppTheme.attributeColor(attr);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: PixelFrame(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Container(width: 8, height: 24, color: color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    game.attributeName(attr),
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${game.attributeCode(attr)} · Mod $modStr',
                                    style: const TextStyle(
                                      color: AppTheme.dullSilver,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            stepBtn(
                              Key('tester_attr_dec5_${attr.name}'),
                              '-5',
                              () => notifier.setAttributeScore(attr, score - 5),
                            ),
                            const SizedBox(width: 4),
                            stepBtn(
                              Key('tester_attr_dec_${attr.name}'),
                              '-1',
                              () => notifier.setAttributeScore(attr, score - 1),
                            ),
                            SizedBox(
                              width: 42,
                              child: Text(
                                '$score',
                                key: Key('tester_attr_val_${attr.name}'),
                                textAlign: TextAlign.center,
                                style: display.style(26, color: AppTheme.ashWhite),
                              ),
                            ),
                            stepBtn(
                              Key('tester_attr_inc_${attr.name}'),
                              '+1',
                              () => notifier.setAttributeScore(attr, score + 1),
                            ),
                            const SizedBox(width: 4),
                            stepBtn(
                              Key('tester_attr_inc5_${attr.name}'),
                              '+5',
                              () => notifier.setAttributeScore(attr, score + 5),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: 8),

              // --- Infinite Tokens & Inspiration ---------------------------
              PixelFrame(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            l10n.testerInfiniteTokens,
                            style: const TextStyle(
                              color: AppTheme.ashWhite,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Switch(
                          value: tester.infiniteCombatTokens,
                          activeThumbColor: AppTheme.emberGold,
                          onChanged: notifier.setInfiniteTokens,
                        ),
                      ],
                    ),
                    const Divider(color: AppTheme.ironBorder),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.testerInspirationLabel,
                            style: const TextStyle(
                              color: AppTheme.ashWhite,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        stepBtn(
                          const Key('tester_insp_dec'),
                          '-1',
                          () => notifier.setInspiration(
                            tester.inspirationCount - 1,
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${tester.inspirationCount}',
                            textAlign: TextAlign.center,
                            style: display.style(22, color: AppTheme.emberGold),
                          ),
                        ),
                        stepBtn(
                          const Key('tester_insp_inc'),
                          '+1',
                          () => notifier.setInspiration(
                            tester.inspirationCount + 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              if (tester.enabled)
                PixelButton(
                  key: const Key('tester_reset_btn'),
                  label: l10n.testerResetButton,
                  variant: PixelButtonVariant.secondary,
                  onPressed: () {
                    notifier.setEnabled(false);
                    notifier.setForcedD20(null);
                  },
                ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
