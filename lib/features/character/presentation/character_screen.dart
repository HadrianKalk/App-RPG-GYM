import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/brand.dart';
import '../../../app/theme.dart';
import '../../../app/ui/game_app_bar.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_sprite.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../app/ui/segmented_bar.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/hero_profile.dart';
import '../../../core/game/progression.dart';
import '../../../data/repositories/character_repository.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';
import 'streak_card.dart';

/// Hero sheet: identity, level/XP and the six attributes.
class CharacterScreen extends ConsumerWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(characterStreamProvider);
    final hero = ref.watch(heroStreamProvider).valueOrNull;

    return Scaffold(
      appBar: const GameAppBar(title: AppBrand.fullTitle),
      body: characterAsync.when(
        data: (char) => _HeroSheet(char: char, hero: hero),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(context.l10n.loadError('$err'))),
      ),
    );
  }
}

class _HeroSheet extends StatelessWidget {
  const _HeroSheet({required this.char, required this.hero});

  final CharacterState char;
  final HeroProfile? hero;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final level = char.levelInfo;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // --- Hero card ---------------------------------------------------
        PixelFrame(
          highlight: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.obsidianBlack,
                      border: Border.all(color: AppTheme.emberGold, width: 3),
                    ),
                    child: const PixelSprite(rows: HeroSprites.idle, palette: HeroSprites.palette, pixelSize: 4),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hero != null)
                          Text(hero!.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: display.style(34, height: 1)),
                        const SizedBox(height: 2),
                        Text(
                          [
                            if (hero != null) '${hero!.origin.icon} ${game.heroOriginName(hero!)}',
                            game.className(char.characterClass),
                          ].join(' · '),
                          style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(l10n.characterLevel(level.level), style: display.style(28, color: AppTheme.emberGold, height: 1)),
                        const SizedBox(height: 6),
                        Text(
                          game.classLore(char.characterClass),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppTheme.darkAsh, fontSize: 11, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.characterExperience, style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12)),
                  Text(
                    l10n.characterXpProgress(level.totalXp.toInt(), level.nextLevelRequiredXp),
                    style: display.style(18, color: AppTheme.emberGold),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SegmentedBar(value: level.progressPercent, segments: 24),
              const SizedBox(height: 14),
              const StreakCard(),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(l10n.characterAttributes, style: Theme.of(context).textTheme.titleLarge),
        ),
        // --- Attribute grid ----------------------------------------------
        LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth = (constraints.maxWidth - 8) / 2;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final attr in Attribute.values)
                  SizedBox(width: cellWidth, child: _AttributeCell(prog: char.attributeProgressions[attr]!)),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// One attribute: name, modifier, score and progress to the next point.
class _AttributeCell extends StatelessWidget {
  const _AttributeCell({required this.prog});

  final AttributeProgression prog;

  @override
  Widget build(BuildContext context) {
    final game = context.game;
    final display = DisplayFont.from(context);
    final color = AppTheme.attributeColor(prog.attribute);
    final mod = prog.modifier >= 0 ? '+${prog.modifier}' : '${prog.modifier}';

    return Tooltip(
      message: game.attributeDescription(prog.attribute),
      child: PixelFrame(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    game.attributeName(prog.attribute),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                PixelTag(text: mod, color: color, fontSize: 15),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${prog.score}', style: display.style(40, height: 1.1)),
                const SizedBox(width: 6),
                Text(game.attributeCode(prog.attribute), style: display.style(16, color: AppTheme.darkAsh)),
              ],
            ),
            SegmentedBar(value: prog.progressPercent, segments: 10, color: color, height: 7),
            const SizedBox(height: 3),
            Text(
              context.l10n.characterNextPoint((prog.progressPercent * 100).toInt()),
              style: const TextStyle(fontSize: 10, color: AppTheme.darkAsh),
            ),
          ],
        ),
      ),
    );
  }
}
