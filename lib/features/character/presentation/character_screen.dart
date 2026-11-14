import '../../../core/game/progression.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/brand.dart';
import '../../../app/theme.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/hero_profile.dart';
import '../../../data/repositories/character_repository.dart';
import '../../../data/repositories/providers.dart';

class CharacterScreen extends ConsumerWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(characterStreamProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBrand.fullTitle),
        actions: [
          characterAsync.when(
            data: (char) => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Chip(
                avatar: const Text('✨', style: TextStyle(fontSize: 14)),
                label: Text(
                  '${char.inspirationCount} Inspiração',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                backgroundColor: AppTheme.castIron,
                side: const BorderSide(color: AppTheme.emberGold),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: characterAsync.when(
        data: (char) => _buildHeroContent(context, char, ref.watch(heroStreamProvider).valueOrNull, textTheme),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.emberGold),
        ),
        error: (err, stack) => Center(
          child: Text('Erro ao carregar herói: $err', style: textTheme.bodyMedium),
        ),
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context, CharacterState char, HeroProfile? hero, TextTheme textTheme) {
    final level = char.levelInfo;
    final characterClass = char.characterClass;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // --- Card Principal do Herói ---
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: AppTheme.castIron,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.emberGold.withValues(alpha: 0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppTheme.emberOrange.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppTheme.obsidianBlack,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.emberGold, width: 1.5),
                    ),
                    child: const Icon(Icons.shield_outlined, size: 40, color: AppTheme.emberGold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hero != null) ...[
                          Text(
                            hero.name,
                            style: textTheme.titleLarge?.copyWith(color: AppTheme.ashWhite),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${hero.origin.icon} ${hero.origin.name}',
                            style: textTheme.bodySmall?.copyWith(color: AppTheme.dullSilver),
                          ),
                          const SizedBox(height: 6),
                        ],
                        Row(
                          children: [
                            Text(
                              'Nível ${level.level}',
                              style: textTheme.titleLarge?.copyWith(
                                color: AppTheme.emberGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.forgedSteel,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppTheme.ironBorder),
                              ),
                              child: Text(
                                characterClass.title,
                                style: const TextStyle(
                                  color: AppTheme.ashWhite,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          characterClass.lore,
                          style: textTheme.bodySmall?.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Barra de XP do Nível
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Experiência Geral', style: textTheme.bodySmall),
                      Text(
                        '${level.totalXp.toInt()} / ${level.nextLevelRequiredXp} XP',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppTheme.emberGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: level.progressPercent,
                      minHeight: 8,
                      backgroundColor: AppTheme.obsidianBlack,
                      color: AppTheme.emberGold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Text('Atributos D&D', style: textTheme.titleMedium),
        const SizedBox(height: 12),

        // --- Grid dos 6 Atributos ---
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: Attribute.values.map((attr) {
            final prog = char.attributeProgressions[attr]!;
            return _buildAttributeCard(attr, prog, textTheme);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAttributeCard(Attribute attr, AttributeProgression prog, TextTheme textTheme) {
    Color attrColor;
    IconData attrIcon;

    switch (attr) {
      case Attribute.strength:
        attrColor = AppTheme.colorStrength;
        attrIcon = Icons.fitness_center;
        break;
      case Attribute.dexterity:
        attrColor = AppTheme.colorDexterity;
        attrIcon = Icons.directions_run;
        break;
      case Attribute.constitution:
        attrColor = AppTheme.colorConstitution;
        attrIcon = Icons.favorite_border;
        break;
      case Attribute.intelligence:
        attrColor = AppTheme.colorIntelligence;
        attrIcon = Icons.auto_stories;
        break;
      case Attribute.wisdom:
        attrColor = AppTheme.colorWisdom;
        attrIcon = Icons.self_improvement;
        break;
      case Attribute.charisma:
        attrColor = AppTheme.colorCharisma;
        attrIcon = Icons.campaign_outlined;
        break;
    }

    final modString = prog.modifier >= 0 ? '+${prog.modifier}' : '${prog.modifier}';

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppTheme.castIron,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.ironBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(attrIcon, size: 16, color: attrColor),
                  const SizedBox(width: 6),
                  Text(
                    attr.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppTheme.ashWhite,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: attrColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  modString,
                  style: TextStyle(
                    color: attrColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${prog.score}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.ashWhite,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                attr.code,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.darkAsh,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: prog.progressPercent,
                  minHeight: 4,
                  backgroundColor: AppTheme.obsidianBlack,
                  color: attrColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${(prog.progressPercent * 100).toInt()}% para +1 ponto',
                style: const TextStyle(fontSize: 9, color: AppTheme.dullSilver),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

