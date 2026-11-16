import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/combat.dart';
import '../../../l10n/l10n.dart';

/// Animated D20 roll banner displayed in combat and dungeon attribute checks.
///
/// Plays a finite 350ms tumbling/cycling animation whenever [animationSeed]
/// changes, then settles on [roll.naturalRoll] (`1..20`) with full D&D 5e
/// formula breakdown (`d20 + Attribute Mod + Proficiency vs AC/DC`).
class D20RollerBanner extends StatelessWidget {
  const D20RollerBanner({
    super.key,
    required this.roll,
    required this.animationSeed,
    this.isDifficultyClass = false,
  });

  final D20RollResult roll;
  final Object animationSeed;

  /// True when rolling against a Dungeon room's Difficulty Class (DC) instead
  /// of an opponent's Armor Class (AC).
  final bool isDifficultyClass;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);

    final Color accentColor;
    final Color frameColor;
    final String headline;

    switch (roll.outcome) {
      case D20Outcome.criticalHit:
        accentColor = AppTheme.emberGold;
        frameColor = const Color(0xFF2B2212);
        headline = l10n.combatD20CritTitle;
      case D20Outcome.criticalFumble:
        accentColor = AppTheme.bloodCrimson;
        frameColor = AppTheme.darkBlood;
        headline = l10n.combatD20FumbleTitle;
      case D20Outcome.hit:
        accentColor = AppTheme.attributeColor(Attribute.constitution);
        frameColor = AppTheme.castIron;
        headline = l10n.combatD20HitTitle(roll.totalRoll, roll.targetNumber);
      case D20Outcome.miss:
        accentColor = AppTheme.dullSilver;
        frameColor = AppTheme.castIron;
        headline = l10n.combatD20MissTitle(roll.totalRoll, roll.targetNumber);
    }

    final modStr = roll.attributeModifier >= 0
        ? '+${roll.attributeModifier}'
        : '${roll.attributeModifier}';
    final targetLabel = isDifficultyClass ? 'CD/DC' : 'CA/AC';
    final formulaText = l10n.combatD20Formula(
      roll.naturalRoll,
      game.attributeCode(roll.attribute),
      modStr,
      roll.proficiencyBonus,
      roll.totalRoll,
      targetLabel,
      roll.targetNumber,
    );

    return TweenAnimationBuilder<double>(
      key: ValueKey(animationSeed),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      builder: (context, t, _) {
        final clampedT = t.clamp(0.0, 1.0);
        final isRolling = clampedT < 0.82;
        final displayedNumber = isRolling
            ? ((clampedT * 37).floor() % 20) + 1
            : roll.naturalRoll;
        final angle = isRolling ? (1.0 - clampedT) * math.pi * 2.0 : 0.0;
        final scale = 0.85 + 0.15 * clampedT;

        return PixelFrame(
          key: const Key('d20_roller_banner'),
          highlight: roll.isCriticalHit || roll.isCriticalFumble,
          color: frameColor,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Transform.scale(
                scale: scale,
                child: Transform.rotate(
                  angle: angle,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CustomPaint(
                      painter: D20FacetPainter(
                        borderColor: accentColor,
                        fillColor: AppTheme.obsidianBlack,
                      ),
                      child: Center(
                        child: Text(
                          '$displayedNumber',
                          key: const Key('d20_natural_value'),
                          style: display.style(
                            30,
                            color: accentColor,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headline,
                      key: const Key('d20_outcome_headline'),
                      style: display.style(20, color: accentColor, height: 1.1),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formulaText,
                      key: const Key('d20_formula_text'),
                      style: const TextStyle(
                        color: AppTheme.ashWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class D20FacetPainter extends CustomPainter {
  const D20FacetPainter({
    required this.borderColor,
    required this.fillColor,
  });

  final Color borderColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final r = math.min(w, h) * 0.46;

    // Outer hexagonal icosahedron silhouette.
    final hex = Path();
    for (var i = 0; i < 6; i++) {
      final a = -math.pi / 2 + i * (math.pi / 3);
      final x = cx + r * math.cos(a);
      final y = cy + r * math.sin(a);
      if (i == 0) {
        hex.moveTo(x, y);
      } else {
        hex.lineTo(x, y);
      }
    }
    hex.close();

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final facetPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawPath(hex, fillPaint);

    // Inner triangle facet lines of a d20.
    final innerR = r * 0.58;
    final tri = Path();
    for (var i = 0; i < 3; i++) {
      final a = -math.pi / 2 + i * (2 * math.pi / 3);
      final x = cx + innerR * math.cos(a);
      final y = cy + innerR * math.sin(a);
      if (i == 0) {
        tri.moveTo(x, y);
      } else {
        tri.lineTo(x, y);
      }
    }
    tri.close();
    canvas.drawPath(tri, facetPaint);
    canvas.drawPath(hex, borderPaint);
  }

  @override
  bool shouldRepaint(D20FacetPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor ||
      oldDelegate.fillColor != fillColor;
}
