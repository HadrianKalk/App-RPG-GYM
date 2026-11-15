import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_sprite.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/class_resolver.dart';
import '../../../core/game/combat.dart';
import '../../../core/game/hero_appearance.dart';
import '../../../core/game/xp_rules.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';

/// Tabs inside the Hero Customization Sheet.
enum HeroCustomizationTab { appearance, honors }

/// Opens a modal bottom sheet allowing the player to customize their 16-bit
/// Paper-Doll [HeroAppearance], select an unlocked [CharacterClass]
/// (Decision #41), and equip unlocked combat titles and cosmetics.
Future<void> showHeroCustomizationSheet(
  BuildContext context, {
  HeroCustomizationTab initialTab = HeroCustomizationTab.appearance,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.obsidianBlack,
    builder: (_) => HeroCustomizationSheet(initialTab: initialTab),
  );
}

/// Opens a standalone modal bottom sheet to edit a [HeroAppearance] in-memory
/// (used during Onboarding before the hero row is saved to SQLite).
Future<void> showOnboardingAppearanceSheet({
  required BuildContext context,
  required HeroAppearance initialAppearance,
  required ValueChanged<HeroAppearance> onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.obsidianBlack,
    builder: (_) => _StandaloneAppearanceSheet(
      initialAppearance: initialAppearance,
      onChanged: onChanged,
    ),
  );
}

class _StandaloneAppearanceSheet extends StatefulWidget {
  const _StandaloneAppearanceSheet({
    required this.initialAppearance,
    required this.onChanged,
  });

  final HeroAppearance initialAppearance;
  final ValueChanged<HeroAppearance> onChanged;

  @override
  State<_StandaloneAppearanceSheet> createState() =>
      _StandaloneAppearanceSheetState();
}

class _StandaloneAppearanceSheetState
    extends State<_StandaloneAppearanceSheet> {
  late HeroAppearance _appearance = widget.initialAppearance;
  HeroPose _pose = HeroPose.idle;

  void _update(HeroAppearance next) {
    setState(() => _appearance = next);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);

    return FractionallySizedBox(
      heightFactor: 0.88,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.appearanceCustomizeButton,
                    style: display.style(26, color: AppTheme.emberGold),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppTheme.dullSilver),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _LiveHeroPreviewHeader(
              appearance: _appearance,
              pose: _pose,
              onTogglePose: () => setState(() {
                _pose = _pose == HeroPose.idle ? HeroPose.flex : HeroPose.idle;
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  HeroAppearanceEditor(
                    appearance: _appearance,
                    onChanged: _update,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal bottom sheet displaying the Paper-Doll Appearance Editor and
/// unlocked/locked Hero Classes, Arena/Tournament/Dungeon Titles, and Cosmetics.
class HeroCustomizationSheet extends ConsumerStatefulWidget {
  const HeroCustomizationSheet({
    super.key,
    this.initialTab = HeroCustomizationTab.appearance,
  });

  final HeroCustomizationTab initialTab;

  @override
  ConsumerState<HeroCustomizationSheet> createState() =>
      _HeroCustomizationSheetState();
}

class _HeroCustomizationSheetState
    extends ConsumerState<HeroCustomizationSheet> {
  late HeroCustomizationTab _tab = widget.initialTab;
  HeroPose _pose = HeroPose.idle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final hero = ref.watch(heroStreamProvider).valueOrNull;
    final char = ref.watch(characterStreamProvider).valueOrNull;
    final arena = ref.watch(arenaStateStreamProvider).valueOrNull;
    final heroRepo = ref.read(heroRepositoryProvider);

    final appearance = hero?.appearance ?? HeroAppearance.defaultAppearance;
    final unlockedClasses =
        char?.unlockedClasses ?? const {CharacterClass.adventurer};
    final emergentClass = char?.emergentClass ?? CharacterClass.adventurer;
    final unlockedTitles = arena?.unlockedTitleIds ?? const <String>{};
    final unlockedCosmetics = arena?.unlockedCosmeticIds ?? const <String>{};

    return FractionallySizedBox(
      heightFactor: 0.90,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Pinned Header ------------------------------------------------
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
            const SizedBox(height: 6),

            // --- Pinned Live Paper-Doll Preview -------------------------------
            _LiveHeroPreviewHeader(
              appearance: appearance,
              equippedCosmeticId: hero?.equippedCosmeticId,
              pose: _pose,
              onTogglePose: () => setState(() {
                _pose = _pose == HeroPose.idle ? HeroPose.flex : HeroPose.idle;
              }),
            ),
            const SizedBox(height: 10),

            // --- Tab Switcher: Appearance vs Class & Titles -------------------
            Row(
              children: [
                Expanded(
                  child: _TabButton(
                    buttonKey: const Key('customize_tab_appearance'),
                    label: l10n.appearanceTabLook,
                    selected: _tab == HeroCustomizationTab.appearance,
                    onTap: () =>
                        setState(() => _tab = HeroCustomizationTab.appearance),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabButton(
                    buttonKey: const Key('customize_tab_honors'),
                    label: l10n.appearanceTabHonors,
                    selected: _tab == HeroCustomizationTab.honors,
                    onTap: () =>
                        setState(() => _tab = HeroCustomizationTab.honors),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // --- Scrollable Content -------------------------------------------
            Expanded(
              child: _tab == HeroCustomizationTab.appearance
                  ? ListView(
                      children: [
                        HeroAppearanceEditor(
                          appearance: appearance,
                          onChanged: heroRepo.setAppearance,
                        ),
                      ],
                    )
                  : ListView(
                      children: [
                        // --- Hero Class Selection (Decision #41) --------------
                        Text(
                          l10n.heroClassSection,
                          style: display.style(22, color: AppTheme.ashWhite),
                        ),
                        const SizedBox(height: 6),
                        PixelFrame(
                          key: const Key('select_class_auto'),
                          onTap: () => heroRepo.setSelectedClass(null),
                          highlight: hero?.selectedClass == null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.heroClassAuto(
                                    game.className(emergentClass),
                                  ),
                                  style: TextStyle(
                                    color: hero?.selectedClass == null
                                        ? AppTheme.emberGold
                                        : AppTheme.dullSilver,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              if (hero?.selectedClass == null)
                                const PixelTag(
                                  text: '★',
                                  color: AppTheme.emberGold,
                                ),
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
                                  ? l10n.heroClassUnlockedHint(
                                      game.skillName(skill.id),
                                    )
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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

                        // --- Combat Titles Section ----------------------------
                        Text(
                          l10n.heroTitlesSection,
                          style: display.style(22, color: AppTheme.ashWhite),
                        ),
                        const SizedBox(height: 6),
                        PixelFrame(
                          onTap: () => heroRepo.setEquippedTitle(null),
                          highlight: hero?.equippedTitleId == null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
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
                            lockedHint:
                                l10n.heroLockedHint(game.arenaNpcName(npc.id)),
                            unlocked:
                                unlockedTitles.contains(npc.reward.titleId),
                            equipped:
                                hero?.equippedTitleId == npc.reward.titleId,
                            accentColor: AppTheme.emberGold,
                            onTap: () =>
                                heroRepo.setEquippedTitle(npc.reward.titleId),
                          ),
                        for (final t in TournamentCatalog.tournaments)
                          _RewardOptionTile(
                            tileKey: Key('equip_title_${t.reward.titleId}'),
                            label: game.combatTitle(t.reward.titleId),
                            lockedHint: l10n.heroTournamentLockedHint(
                              game.tournamentName(t.id),
                            ),
                            unlocked: unlockedTitles.contains(t.reward.titleId),
                            equipped: hero?.equippedTitleId == t.reward.titleId,
                            accentColor: AppTheme.emberGold,
                            onTap: () =>
                                heroRepo.setEquippedTitle(t.reward.titleId),
                          ),
                        for (final d in DungeonCatalog.dungeons)
                          _RewardOptionTile(
                            tileKey: Key('equip_title_${d.reward.titleId}'),
                            label: game.combatTitle(d.reward.titleId),
                            lockedHint: l10n.heroDungeonLockedHint(
                              game.dungeonName(d.id),
                            ),
                            unlocked: unlockedTitles.contains(d.reward.titleId),
                            equipped: hero?.equippedTitleId == d.reward.titleId,
                            accentColor: AppTheme.emberGold,
                            onTap: () =>
                                heroRepo.setEquippedTitle(d.reward.titleId),
                          ),
                        const SizedBox(height: 14),

                        // --- Hero Cosmetics Section ---------------------------
                        Text(
                          l10n.heroCosmeticsSection,
                          style: display.style(22, color: AppTheme.ashWhite),
                        ),
                        const SizedBox(height: 6),
                        PixelFrame(
                          onTap: () => heroRepo.setEquippedCosmetic(null),
                          highlight: hero?.equippedCosmeticId == null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
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
                            tileKey:
                                Key('equip_cosmetic_${npc.reward.cosmeticId}'),
                            label: game.combatCosmetic(npc.reward.cosmeticId),
                            lockedHint:
                                l10n.heroLockedHint(game.arenaNpcName(npc.id)),
                            unlocked: unlockedCosmetics
                                .contains(npc.reward.cosmeticId),
                            equipped: hero?.equippedCosmeticId ==
                                npc.reward.cosmeticId,
                            accentColor:
                                AppTheme.attributeColor(Attribute.charisma),
                            onTap: () => heroRepo
                                .setEquippedCosmetic(npc.reward.cosmeticId),
                          ),
                        for (final t in TournamentCatalog.tournaments)
                          _RewardOptionTile(
                            tileKey:
                                Key('equip_cosmetic_${t.reward.cosmeticId}'),
                            label: game.combatCosmetic(t.reward.cosmeticId),
                            lockedHint: l10n.heroTournamentLockedHint(
                              game.tournamentName(t.id),
                            ),
                            unlocked:
                                unlockedCosmetics.contains(t.reward.cosmeticId),
                            equipped:
                                hero?.equippedCosmeticId == t.reward.cosmeticId,
                            accentColor:
                                AppTheme.attributeColor(Attribute.charisma),
                            onTap: () => heroRepo
                                .setEquippedCosmetic(t.reward.cosmeticId),
                          ),
                        for (final d in DungeonCatalog.dungeons)
                          _RewardOptionTile(
                            tileKey:
                                Key('equip_cosmetic_${d.reward.cosmeticId}'),
                            label: game.combatCosmetic(d.reward.cosmeticId),
                            lockedHint: l10n.heroDungeonLockedHint(
                              game.dungeonName(d.id),
                            ),
                            unlocked:
                                unlockedCosmetics.contains(d.reward.cosmeticId),
                            equipped:
                                hero?.equippedCosmeticId == d.reward.cosmeticId,
                            accentColor:
                                AppTheme.attributeColor(Attribute.charisma),
                            onTap: () => heroRepo
                                .setEquippedCosmetic(d.reward.cosmeticId),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveHeroPreviewHeader extends StatelessWidget {
  const _LiveHeroPreviewHeader({
    required this.appearance,
    required this.pose,
    required this.onTogglePose,
    this.equippedCosmeticId,
  });

  final HeroAppearance appearance;
  final String? equippedCosmeticId;
  final HeroPose pose;
  final VoidCallback onTogglePose;

  @override
  Widget build(BuildContext context) {
    final game = context.game;
    return PixelFrame(
      color: AppTheme.castIron,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            key: const Key('hero_preview_toggle_pose'),
            onTap: onTogglePose,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.obsidianBlack,
                border: Border.all(color: AppTheme.emberGold, width: 2),
              ),
              child: HeroAvatar(
                appearance: appearance,
                equippedCosmeticId: equippedCosmeticId,
                pose: pose,
                pixelSize: 2.8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${game.hairStyle(appearance.hairStyle)} · ${game.eyeStyle(appearance.eyeStyle)}',
                  style: const TextStyle(
                    color: AppTheme.ashWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${game.torsoStyle(appearance.torsoStyle)} · ${game.legsStyle(appearance.legsStyle)}',
                  style: const TextStyle(
                    color: AppTheme.dullSilver,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${game.bootsStyle(appearance.bootsStyle)} · ${game.backStyle(appearance.backStyle)}',
                  style: const TextStyle(
                    color: AppTheme.emberGold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.buttonKey,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Key buttonKey;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    return InkWell(
      key: buttonKey,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppTheme.emberGold : AppTheme.castIron,
          border: Border.all(
            color: selected ? AppTheme.emberGold : AppTheme.ironBorder,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: display.style(
            18,
            color: selected ? AppTheme.obsidianBlack : AppTheme.ashWhite,
          ),
        ),
      ),
    );
  }
}

/// Reusable modular Paper-Doll editor widget allowing the player to choose
/// pre-made archetypes or customize skin tone, eyes, hair, beard, torso,
/// pants, boots, cape/back weapon, and outfit color palette.
class HeroAppearanceEditor extends StatelessWidget {
  const HeroAppearanceEditor({
    super.key,
    required this.appearance,
    required this.onChanged,
  });

  final HeroAppearance appearance;
  final ValueChanged<HeroAppearance> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. Pre-Made Archetypes -----------------------------------------
        _SectionHeader(title: l10n.appearancePresetsTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final preset in HeroAppearancePreset.values)
              _OptionChip(
                chipKey: Key('preset_${preset.name}'),
                label: game.appearancePreset(preset),
                selected: appearance == HeroAppearance.fromPreset(preset),
                onTap: () => onChanged(HeroAppearance.fromPreset(preset)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 2. Skin Tone ---------------------------------------------------
        _SectionHeader(title: l10n.appearanceSkinTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final tone in SkinTone.values)
              _ColorOptionChip(
                chipKey: Key('skin_${tone.name}'),
                label: game.skinTone(tone),
                swatchColor: Color(tone.ramp.base),
                selected: appearance.skinTone == tone,
                onTap: () => onChanged(appearance.copyWith(skinTone: tone)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 3. Hair / Headgear Style ---------------------------------------
        _SectionHeader(title: l10n.appearanceHairTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final style in HairStyle.values)
              _OptionChip(
                chipKey: Key('hair_${style.name}'),
                label: game.hairStyle(style),
                selected: appearance.hairStyle == style,
                onTap: () => onChanged(appearance.copyWith(hairStyle: style)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 4. Hair Color --------------------------------------------------
        _SectionHeader(title: l10n.appearanceHairColorTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final color in HairColor.values)
              _ColorOptionChip(
                chipKey: Key('hairColor_${color.name}'),
                label: game.hairColor(color),
                swatchColor: Color(color.ramp.base),
                selected: appearance.hairColor == color,
                onTap: () => onChanged(appearance.copyWith(hairColor: color)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 5. Eyes & Scar -------------------------------------------------
        _SectionHeader(title: l10n.appearanceEyesTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final style in EyeStyle.values)
              _OptionChip(
                chipKey: Key('eye_${style.name}'),
                label: game.eyeStyle(style),
                selected: appearance.eyeStyle == style,
                onTap: () => onChanged(appearance.copyWith(eyeStyle: style)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 6. Eye Color ---------------------------------------------------
        _SectionHeader(title: l10n.appearanceEyeColorTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final color in EyeColor.values)
              _ColorOptionChip(
                chipKey: Key('eyeColor_${color.name}'),
                label: game.eyeColor(color),
                swatchColor: Color(color.argb),
                selected: appearance.eyeColor == color,
                onTap: () => onChanged(appearance.copyWith(eyeColor: color)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 7. Beard -------------------------------------------------------
        _SectionHeader(title: l10n.appearanceBeardTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final style in BeardStyle.values)
              _OptionChip(
                chipKey: Key('beard_${style.name}'),
                label: game.beardStyle(style),
                selected: appearance.beardStyle == style,
                onTap: () => onChanged(appearance.copyWith(beardStyle: style)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 8. Shirt / Chest Armor -----------------------------------------
        _SectionHeader(title: l10n.appearanceTorsoTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final style in TorsoStyle.values)
              _OptionChip(
                chipKey: Key('torso_${style.name}'),
                label: game.torsoStyle(style),
                selected: appearance.torsoStyle == style,
                onTap: () => onChanged(appearance.copyWith(torsoStyle: style)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 9. Pants / Greaves ---------------------------------------------
        _SectionHeader(title: l10n.appearanceLegsTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final style in LegsStyle.values)
              _OptionChip(
                chipKey: Key('legs_${style.name}'),
                label: game.legsStyle(style),
                selected: appearance.legsStyle == style,
                onTap: () => onChanged(appearance.copyWith(legsStyle: style)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 10. Footwear / Boots -------------------------------------------
        _SectionHeader(title: l10n.appearanceBootsTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final style in BootsStyle.values)
              _OptionChip(
                chipKey: Key('boots_${style.name}'),
                label: game.bootsStyle(style),
                selected: appearance.bootsStyle == style,
                onTap: () => onChanged(appearance.copyWith(bootsStyle: style)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 11. Cape & Back Weapon -----------------------------------------
        _SectionHeader(title: l10n.appearanceBackTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final style in BackStyle.values)
              _OptionChip(
                chipKey: Key('back_${style.name}'),
                label: game.backStyle(style),
                selected: appearance.backStyle == style,
                onTap: () => onChanged(appearance.copyWith(backStyle: style)),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 12. Outfit Color Palette ---------------------------------------
        _SectionHeader(title: l10n.appearanceTintTitle),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final tint in OutfitTint.values)
              _ColorOptionChip(
                chipKey: Key('tint_${tint.name}'),
                label: game.outfitTint(tint),
                swatchColor: Color(tint.primary.base),
                selected: appearance.outfitTint == tint,
                onTap: () => onChanged(appearance.copyWith(outfitTint: tint)),
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(title, style: display.style(20, color: AppTheme.emberGold)),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.chipKey,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Key chipKey;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: chipKey,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.emberGold : AppTheme.castIron,
          border: Border.all(
            color: selected ? AppTheme.emberGold : AppTheme.ironBorder,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppTheme.obsidianBlack : AppTheme.ashWhite,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ColorOptionChip extends StatelessWidget {
  const _ColorOptionChip({
    required this.chipKey,
    required this.label,
    required this.swatchColor,
    required this.selected,
    required this.onTap,
  });

  final Key chipKey;
  final String label;
  final Color swatchColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: chipKey,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.emberGold : AppTheme.castIron,
          border: Border.all(
            color: selected ? AppTheme.emberGold : AppTheme.ironBorder,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: swatchColor,
                border: Border.all(color: AppTheme.obsidianBlack, width: 1.5),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppTheme.obsidianBlack : AppTheme.ashWhite,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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
