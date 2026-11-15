import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/combat.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';

/// Opens a modal bottom sheet allowing the player to view and equip unlocked
/// combat titles and cosmetics.
Future<void> showHeroCustomizationSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.obsidianBlack,
    builder: (_) => const HeroCustomizationSheet(),
  );
}

/// Modal bottom sheet displaying all Arena titles and cosmetics.
class HeroCustomizationSheet extends ConsumerWidget {
  const HeroCustomizationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final hero = ref.watch(heroStreamProvider).valueOrNull;
    final arena = ref.watch(arenaStateStreamProvider).valueOrNull;
    final heroRepo = ref.read(heroRepositoryProvider);

    final unlockedTitles = arena?.unlockedTitleIds ?? const <String>{};
    final unlockedCosmetics = arena?.unlockedCosmeticIds ?? const <String>{};

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.heroCustomizeButton,
                  style: display.style(28, color: AppTheme.emberGold),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppTheme.dullSilver),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // --- Combat Titles Section --------------------------------------
            Text(
              l10n.heroTitlesSection,
              style: display.style(22, color: AppTheme.ashWhite),
            ),
            const SizedBox(height: 6),
            PixelFrame(
              onTap: () => heroRepo.setEquippedTitle(null),
              highlight: hero?.equippedTitleId == null,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                l10n.heroUnequip,
                style: TextStyle(
                  color: hero?.equippedTitleId == null
                      ? AppTheme.emberGold
                      : AppTheme.dullSilver,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 6),
            for (final npc in ArenaCatalog.opponents) ...[
              Builder(
                builder: (context) {
                  final titleId = npc.reward.titleId;
                  final unlocked = unlockedTitles.contains(titleId);
                  final equipped = hero?.equippedTitleId == titleId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: PixelFrame(
                      key: Key('equip_title_$titleId'),
                      highlight: equipped,
                      onTap: unlocked
                          ? () => heroRepo.setEquippedTitle(titleId)
                          : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game.combatTitle(titleId),
                                  style: display.style(
                                    20,
                                    color: unlocked
                                        ? AppTheme.emberGold
                                        : AppTheme.darkAsh,
                                  ),
                                ),
                                if (!unlocked)
                                  Text(
                                    l10n.heroLockedHint(
                                      game.arenaNpcName(npc.id),
                                    ),
                                    style: const TextStyle(
                                      color: AppTheme.darkAsh,
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (equipped)
                            const PixelTag(
                              text: '★',
                              color: AppTheme.emberGold,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 14),

            // --- Hero Cosmetics Section -------------------------------------
            Text(
              l10n.heroCosmeticsSection,
              style: display.style(22, color: AppTheme.ashWhite),
            ),
            const SizedBox(height: 6),
            PixelFrame(
              onTap: () => heroRepo.setEquippedCosmetic(null),
              highlight: hero?.equippedCosmeticId == null,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                l10n.heroUnequip,
                style: TextStyle(
                  color: hero?.equippedCosmeticId == null
                      ? AppTheme.emberGold
                      : AppTheme.dullSilver,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 6),
            for (final npc in ArenaCatalog.opponents) ...[
              Builder(
                builder: (context) {
                  final cosmeticId = npc.reward.cosmeticId;
                  final unlocked = unlockedCosmetics.contains(cosmeticId);
                  final equipped = hero?.equippedCosmeticId == cosmeticId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: PixelFrame(
                      key: Key('equip_cosmetic_$cosmeticId'),
                      highlight: equipped,
                      onTap: unlocked
                          ? () => heroRepo.setEquippedCosmetic(cosmeticId)
                          : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game.combatCosmetic(cosmeticId),
                                  style: display.style(
                                    20,
                                    color: unlocked
                                        ? AppTheme.attributeColor(
                                            Attribute.charisma,
                                          )
                                        : AppTheme.darkAsh,
                                  ),
                                ),
                                if (!unlocked)
                                  Text(
                                    l10n.heroLockedHint(
                                      game.arenaNpcName(npc.id),
                                    ),
                                    style: const TextStyle(
                                      color: AppTheme.darkAsh,
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (equipped)
                            PixelTag(
                              text: '★',
                              color: AppTheme.attributeColor(
                                Attribute.charisma,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}
