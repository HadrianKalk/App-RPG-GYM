import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/class_resolver.dart';
import '../../../core/game/combat.dart';
import '../../../core/game/xp_rules.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';

/// Opens a modal bottom sheet allowing the player to select an unlocked
/// [CharacterClass] (Decision #41) and equip unlocked combat titles and
/// cosmetics.
Future<void> showHeroCustomizationSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.obsidianBlack,
    builder: (_) => const HeroCustomizationSheet(),
  );
}

/// Modal bottom sheet displaying unlocked/locked Hero Classes, Arena/Tournament
/// Titles, and Cosmetics.
class HeroCustomizationSheet extends ConsumerWidget {
  const HeroCustomizationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final hero = ref.watch(heroStreamProvider).valueOrNull;
    final char = ref.watch(characterStreamProvider).valueOrNull;
    final arena = ref.watch(arenaStateStreamProvider).valueOrNull;
    final heroRepo = ref.read(heroRepositoryProvider);

    final unlockedClasses =
        char?.unlockedClasses ?? const {CharacterClass.adventurer};
    final emergentClass = char?.emergentClass ?? CharacterClass.adventurer;
    final unlockedTitles = arena?.unlockedTitleIds ?? const <String>{};
    final unlockedCosmetics = arena?.unlockedCosmeticIds ?? const <String>{};

    return DraggableScrollableSheet(
      initialChildSize: 0.80,
      minChildSize: 0.5,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.heroCustomizeButton,
                    style: display.style(28, color: AppTheme.emberGold),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppTheme.dullSilver),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // --- Hero Class Selection (Decision #41) ------------------------
            Text(
              l10n.heroClassSection,
              style: display.style(22, color: AppTheme.ashWhite),
            ),
            const SizedBox(height: 6),
            PixelFrame(
              key: const Key('select_class_auto'),
              onTap: () => heroRepo.setSelectedClass(null),
              highlight: hero?.selectedClass == null,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.heroClassAuto(game.className(emergentClass)),
                      style: TextStyle(
                        color: hero?.selectedClass == null
                            ? AppTheme.emberGold
                            : AppTheme.dullSilver,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (hero?.selectedClass == null)
                    const PixelTag(text: '★', color: AppTheme.emberGold),
                ],
              ),
            ),
            const SizedBox(height: 6),
            for (final c in CharacterClass.values) ...[
              Builder(
                builder: (context) {
                  final unlocked = unlockedClasses.contains(c);
                  final selected = hero?.selectedClass == c;
                  final skill = ClassSkillCatalog.forClass(c);
                  final subtitle = unlocked
                      ? l10n.heroClassUnlockedHint(game.skillName(skill.id))
                      : l10n.heroClassLockedHint(
                          game.attributeCode(c.primary!),
                          game.attributeCode(c.secondary!),
                          XpRules.classUnlockAttributeScore,
                        );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: PixelFrame(
                      key: Key('select_class_${c.name}'),
                      highlight: selected,
                      onTap: unlocked
                          ? () => heroRepo.setSelectedClass(c)
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
                                  game.className(c),
                                  style: display.style(
                                    20,
                                    color: unlocked
                                        ? AppTheme.emberGold
                                        : AppTheme.darkAsh,
                                  ),
                                ),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: unlocked
                                        ? AppTheme.dullSilver
                                        : AppTheme.darkAsh,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selected)
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
            for (final npc in ArenaCatalog.opponents)
              _RewardOptionTile(
                tileKey: Key('equip_title_${npc.reward.titleId}'),
                label: game.combatTitle(npc.reward.titleId),
                lockedHint: l10n.heroLockedHint(game.arenaNpcName(npc.id)),
                unlocked: unlockedTitles.contains(npc.reward.titleId),
                equipped: hero?.equippedTitleId == npc.reward.titleId,
                accentColor: AppTheme.emberGold,
                onTap: () => heroRepo.setEquippedTitle(npc.reward.titleId),
              ),
            for (final t in TournamentCatalog.tournaments)
              _RewardOptionTile(
                tileKey: Key('equip_title_${t.reward.titleId}'),
                label: game.combatTitle(t.reward.titleId),
                lockedHint:
                    l10n.heroTournamentLockedHint(game.tournamentName(t.id)),
                unlocked: unlockedTitles.contains(t.reward.titleId),
                equipped: hero?.equippedTitleId == t.reward.titleId,
                accentColor: AppTheme.emberGold,
                onTap: () => heroRepo.setEquippedTitle(t.reward.titleId),
              ),
            for (final d in DungeonCatalog.dungeons)
              _RewardOptionTile(
                tileKey: Key('equip_title_${d.reward.titleId}'),
                label: game.combatTitle(d.reward.titleId),
                lockedHint: l10n.heroDungeonLockedHint(game.dungeonName(d.id)),
                unlocked: unlockedTitles.contains(d.reward.titleId),
                equipped: hero?.equippedTitleId == d.reward.titleId,
                accentColor: AppTheme.emberGold,
                onTap: () => heroRepo.setEquippedTitle(d.reward.titleId),
              ),
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
            for (final npc in ArenaCatalog.opponents)
              _RewardOptionTile(
                tileKey: Key('equip_cosmetic_${npc.reward.cosmeticId}'),
                label: game.combatCosmetic(npc.reward.cosmeticId),
                lockedHint: l10n.heroLockedHint(game.arenaNpcName(npc.id)),
                unlocked: unlockedCosmetics.contains(npc.reward.cosmeticId),
                equipped: hero?.equippedCosmeticId == npc.reward.cosmeticId,
                accentColor: AppTheme.attributeColor(Attribute.charisma),
                onTap: () =>
                    heroRepo.setEquippedCosmetic(npc.reward.cosmeticId),
              ),
            for (final t in TournamentCatalog.tournaments)
              _RewardOptionTile(
                tileKey: Key('equip_cosmetic_${t.reward.cosmeticId}'),
                label: game.combatCosmetic(t.reward.cosmeticId),
                lockedHint:
                    l10n.heroTournamentLockedHint(game.tournamentName(t.id)),
                unlocked: unlockedCosmetics.contains(t.reward.cosmeticId),
                equipped: hero?.equippedCosmeticId == t.reward.cosmeticId,
                accentColor: AppTheme.attributeColor(Attribute.charisma),
                onTap: () => heroRepo.setEquippedCosmetic(t.reward.cosmeticId),
              ),
            for (final d in DungeonCatalog.dungeons)
              _RewardOptionTile(
                tileKey: Key('equip_cosmetic_${d.reward.cosmeticId}'),
                label: game.combatCosmetic(d.reward.cosmeticId),
                lockedHint: l10n.heroDungeonLockedHint(game.dungeonName(d.id)),
                unlocked: unlockedCosmetics.contains(d.reward.cosmeticId),
                equipped: hero?.equippedCosmeticId == d.reward.cosmeticId,
                accentColor: AppTheme.attributeColor(Attribute.charisma),
                onTap: () => heroRepo.setEquippedCosmetic(d.reward.cosmeticId),
              ),
          ],
        );
      },
    );
  }
}

class _RewardOptionTile extends StatelessWidget {
  const _RewardOptionTile({
    required this.tileKey,
    required this.label,
    required this.lockedHint,
    required this.unlocked,
    required this.equipped,
    required this.accentColor,
    required this.onTap,
  });

  final Key tileKey;
  final String label;
  final String lockedHint;
  final bool unlocked;
  final bool equipped;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: PixelFrame(
        key: tileKey,
        highlight: equipped,
        onTap: unlocked ? onTap : null,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: display.style(
                      20,
                      color: unlocked ? accentColor : AppTheme.darkAsh,
                    ),
                  ),
                  if (!unlocked)
                    Text(
                      lockedHint,
                      style: const TextStyle(
                        color: AppTheme.darkAsh,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            if (equipped) PixelTag(text: '★', color: accentColor),
          ],
        ),
      ),
    );
  }
}
