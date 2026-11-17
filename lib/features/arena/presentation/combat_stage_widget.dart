import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_sprite.dart';
import '../../../core/game/combat.dart';
import '../../../core/game/hero_appearance.dart';

/// Visual 16-bit side-view Battle Stage displaying the Hero (left) and the
/// Opponent (right, facing left) on a dark-fantasy stone floor, with
/// weapon-specific attack poses, projectile/slash/spell VFX, hit flash/shake,
/// and floating damage/crit/heal indicators.
class CombatStageWidget extends StatefulWidget {
  const CombatStageWidget({
    super.key,
    required this.encounter,
    required this.heroAppearance,
    required this.animationSeed,
    this.equippedCosmeticId,
  });

  final CombatEncounter encounter;
  final HeroAppearance heroAppearance;
  final String? equippedCosmeticId;
  final int animationSeed;

  @override
  State<CombatStageWidget> createState() => _CombatStageWidgetState();
}

class _CombatStageWidgetState extends State<CombatStageWidget>
    with TickerProviderStateMixin {
  late final AnimationController _idleController;
  late final AnimationController _actionController;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _actionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    );
  }

  @override
  void didUpdateWidget(covariant CombatStageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationSeed != widget.animationSeed &&
        widget.encounter.turn > 1) {
      _actionController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  /// Extracts the log entries produced during the most recent turn.
  List<CombatLogEntry> _lastTurnEntries() {
    final log = widget.encounter.log;
    if (log.isEmpty) return const [];
    final latestTurn = log.last.turn;
    return [
      for (final entry in log)
        if (entry.turn == latestTurn) entry,
    ];
  }

  AttackAnimationKind _resolveHeroAttackKind(List<CombatLogEntry> entries) {
    var isDefend = false;
    var isClassSkill = false;
    for (final e in entries) {
      if (e.kind == CombatLogKind.heroDefend) isDefend = true;
      if (e.kind == CombatLogKind.heroClassSkill) isClassSkill = true;
    }
    return widget.heroAppearance.resolveAttackAnimation(
      characterClass: widget.encounter.hero.characterClass,
      isClassSkill: isClassSkill,
      isDefend: isDefend,
    );
  }

  AttackAnimationKind _resolveEnemyAttackKind(String opponentId) {
    if (opponentId == 'boss_satorion' ||
        opponentId == 'boss_aforion' ||
        opponentId == 'boss_kaibaron') {
      return AttackAnimationKind.staffArcaneCast;
    }
    if (opponentId == 'boss_gonnir' ||
        opponentId == 'boss_netherion' ||
        opponentId == 'boss_kakarion' ||
        opponentId == 'boss_toshirion' ||
        opponentId == 'boss_vegor' ||
        opponentId == 'boss_naruval') {
      return AttackAnimationKind.martialKiStrike;
    }
    if (opponentId == 'boss_ryomoth' || opponentId == 'boss_sasukar') {
      return AttackAnimationKind.daggerShadowFlurry;
    }
    if (opponentId == 'boss_arthorius' ||
        opponentId == 'boss_vadric' ||
        opponentId == 'boss_saurath') {
      return AttackAnimationKind.eldritchRunicSlash;
    }
    if (opponentId == 'boss_gerric' ||
        opponentId == 'boss_erendir' ||
        opponentId == 'boss_reinor' ||
        opponentId == 'boss_meruvor') {
      return AttackAnimationKind.greatswordCleave;
    }

    final enemyAppearance = OpponentSprites.forOpponent(opponentId);
    if (enemyAppearance.backStyle == BackStyle.runicStaffCape) {
      return AttackAnimationKind.staffArcaneCast;
    }
    if (enemyAppearance.backStyle == BackStyle.twinDaggersCloak) {
      return AttackAnimationKind.daggerShadowFlurry;
    }
    if (enemyAppearance.backStyle == BackStyle.paladinWingedMantle) {
      return AttackAnimationKind.holyRadiantSmite;
    }
    return AttackAnimationKind.greatswordCleave;
  }

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    final entries = _lastTurnEntries();
    final heroAttackKind = _resolveHeroAttackKind(entries);
    final enemyId = widget.encounter.opponent.id;
    final enemyAttackKind = _resolveEnemyAttackKind(enemyId);

    // Inspect what happened on the last turn
    CombatLogEntry? heroAttackEntry;
    CombatLogEntry? enemyAttackEntry;
    var enemyDodged = false;
    var heroDodged = false;
    var enemyStunned = false;
    var heroFumbled = false;
    var heroDefended = false;
    var heroHeal = 0;

    for (final e in entries) {
      switch (e.kind) {
        case CombatLogKind.heroBasicStrike:
        case CombatLogKind.heroClassSkill:
        case CombatLogKind.heroInspirationStrike:
          heroAttackEntry = e;
          if (e.heal > 0) heroHeal += e.heal;
        case CombatLogKind.heroDefend:
          heroDefended = true;
          heroHeal += e.heal;
        case CombatLogKind.heroCriticalFumble:
          heroFumbled = true;
          heroAttackEntry = e;
        case CombatLogKind.enemyDodged:
          enemyDodged = true;
        case CombatLogKind.enemyStunned:
          enemyStunned = true;
        case CombatLogKind.enemyStrike:
        case CombatLogKind.enemyHeavyBlow:
        case CombatLogKind.legendarySurge:
          enemyAttackEntry = e;
        case CombatLogKind.heroDodged:
          heroDodged = true;
        case CombatLogKind.enemyGuard:
        case CombatLogKind.legendaryCounter:
        case CombatLogKind.legendaryBleedTick:
        case CombatLogKind.legendaryPhaseShift:
        case CombatLogKind.legendaryPlateBroken:
        case CombatLogKind.legendaryBarrierPierced:
        case CombatLogKind.legendaryFocusDrain:
        case CombatLogKind.victory:
        case CombatLogKind.defeat:
          break;
      }
    }

    return PixelFrame(
      key: const Key('combat_stage_widget'),
      padding: EdgeInsets.zero,
      color: AppTheme.obsidianBlack,
      child: SizedBox(
        height: 158,
        child: AnimatedBuilder(
          animation: Listenable.merge([_idleController, _actionController]),
          builder: (context, _) {
            final t = _actionController.value;
            final isAnimating =
                _actionController.isAnimating || (t > 0.0 && t < 1.0);
            final idleBob = math.sin(_idleController.value * math.pi) * 2.0;

            // Phase 1 (0.00 .. 0.55): Hero action
            final inHeroPhase = isAnimating && t <= 0.55;
            final heroPhaseT = inHeroPhase ? (t / 0.55).clamp(0.0, 1.0) : 0.0;

            // Phase 2 (0.55 .. 1.00): Enemy counter-attack (if any)
            final inEnemyPhase = isAnimating &&
                t > 0.55 &&
                (enemyAttackEntry != null || heroDodged);
            final enemyPhaseT =
                inEnemyPhase ? ((t - 0.55) / 0.45).clamp(0.0, 1.0) : 0.0;

            // Determine Hero Pose & Offset
            var heroPose = HeroPose.idle;
            var heroDx = 0.0;
            var heroDy = -idleBob;
            Color? heroFlash;

            if (widget.encounter.status == CombatStatus.victory) {
              heroPose = HeroPose.flex;
            } else if (inHeroPhase) {
              heroPose = HeroPose.forAttack(heroAttackKind);
              final lungeCurve = math.sin(heroPhaseT * math.pi);
              heroDx = switch (heroAttackKind) {
                AttackAnimationKind.daggerShadowFlurry => 92.0 * lungeCurve,
                AttackAnimationKind.greatswordCleave ||
                AttackAnimationKind.martialKiStrike ||
                AttackAnimationKind.holyRadiantSmite ||
                AttackAnimationKind.eldritchRunicSlash =>
                  54.0 * lungeCurve,
                AttackAnimationKind.staffArcaneCast ||
                AttackAnimationKind.primalSongWave =>
                  14.0 * lungeCurve,
                AttackAnimationKind.bowPiercingShot ||
                AttackAnimationKind.defensiveGuard =>
                  4.0 * lungeCurve,
              };
              if (heroFumbled && heroPhaseT > 0.35) {
                heroFlash = AppTheme.bloodCrimson;
                heroDx = math.sin(heroPhaseT * math.pi * 10) * 6.0;
              }
            } else if (inEnemyPhase) {
              if (heroDefended) {
                heroPose = HeroPose.guard;
              }
              if (enemyPhaseT > 0.30 && enemyPhaseT < 0.85) {
                if (heroDodged) {
                  heroDx = -18.0 * math.sin(enemyPhaseT * math.pi);
                } else if (enemyAttackEntry != null &&
                    enemyAttackEntry.damage > 0) {
                  heroFlash = AppTheme.bloodCrimson;
                  heroDx = math.sin(enemyPhaseT * math.pi * 12) * 5.0;
                }
              }
            }

            // Determine Enemy Pose & Offset
            var enemyPose = HeroPose.idle;
            var enemyDx = 0.0;
            var enemyDy = -idleBob;
            Color? enemyFlash;

            if (inHeroPhase &&
                !heroDefended &&
                !heroFumbled &&
                heroPhaseT > 0.28 &&
                heroPhaseT < 0.90) {
              if (enemyDodged) {
                enemyDx = 18.0 * math.sin(heroPhaseT * math.pi);
              } else if (heroAttackEntry != null &&
                  heroAttackEntry.damage > 0) {
                enemyFlash = heroAttackEntry.isCritical
                    ? AppTheme.emberGold
                    : AppTheme.ashWhite;
                enemyDx = math.sin(heroPhaseT * math.pi * 14) * 6.0;
              }
            } else if (inEnemyPhase) {
              enemyPose = HeroPose.forAttack(enemyAttackKind);
              final lungeCurve = math.sin(enemyPhaseT * math.pi);
              enemyDx = -52.0 * lungeCurve;
            }

            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // 1. Dark Fantasy Arena / Dungeon Backdrop & Stone Floor
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ArenaBackdropPainter(),
                  ),
                ),

                // 2. Hero Sprite (Left side)
                Positioned(
                  left: 24 + heroDx,
                  bottom: 22 - heroDy,
                  child: HeroAvatar(
                    key: const Key('stage_hero_avatar'),
                    appearance: widget.heroAppearance,
                    equippedCosmeticId: widget.equippedCosmeticId,
                    pose: heroPose,
                    pixelSize: 2.8,
                    hitFlashColor: heroFlash,
                  ),
                ),

                // 3. Opponent Sprite (Right side, flipped horizontally to face Hero)
                Positioned(
                  right: 24 - enemyDx,
                  bottom: 22 - enemyDy,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.encounter.legendaryPhase >= 2)
                        Container(
                          width: 90,
                          height: 108,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (widget.encounter.legendaryPhase >= 3
                                    ? AppTheme.ashWhite
                                    : AppTheme.emberGold)
                                .withValues(alpha: 0.16),
                            border: Border.all(
                              color: widget.encounter.legendaryPhase >= 3
                                  ? AppTheme.ashWhite
                                  : AppTheme.emberGold,
                              width: 1.5,
                            ),
                          ),
                        ),
                      Opacity(
                        opacity: widget.encounter.enemyHp <= 0 ? 0.35 : 1.0,
                        child: OpponentAvatar(
                          key: const Key('stage_opponent_avatar'),
                          opponentId: enemyId,
                          pose: enemyPose,
                          pixelSize: 2.8,
                          flipHorizontal: true,
                          hitFlashColor: enemyFlash,
                        ),
                      ),
                      if (widget.encounter.legendaryBarrierTurns > 0)
                        Container(
                          width: 92,
                          height: 106,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF7B61FF),
                              width: 2,
                            ),
                            color: const Color(0xFF7B61FF)
                                .withValues(alpha: 0.14),
                          ),
                        ),
                    ],
                  ),
                ),

                // 3b. Active Legendary / Bleed status badges at top corners
                if (widget.encounter.isLegendary)
                  Positioned(
                    right: 8,
                    top: 6,
                    child: Wrap(
                      spacing: 4,
                      children: [
                        if (widget.encounter.legendaryBarrierTurns > 0)
                          _StageStatusChip(
                            text: '∞ ${widget.encounter.legendaryBarrierTurns}T',
                            color: const Color(0xFF7B61FF),
                          ),
                        if (widget.encounter.legendaryPlateStacks > 0)
                          _StageStatusChip(
                            text:
                                'ARM ×${widget.encounter.legendaryPlateStacks}',
                            color: AppTheme.emberGold,
                          ),
                        if (widget.encounter.legendaryPhase >= 2)
                          _StageStatusChip(
                            text: 'F${widget.encounter.legendaryPhase}',
                            color: widget.encounter.legendaryPhase >= 3
                                ? AppTheme.ashWhite
                                : AppTheme.emberGold,
                          ),
                      ],
                    ),
                  ),
                if (widget.encounter.heroBleedStacks > 0)
                  Positioned(
                    left: 8,
                    top: 6,
                    child: _StageStatusChip(
                      text: 'BLEED ×${widget.encounter.heroBleedStacks}',
                      color: AppTheme.bloodCrimson,
                    ),
                  ),

                // 4. Weapon & Magic VFX Layer (Slashes, Staff Beams, Arrows, Ki, Holy Pillar, Ward)
                if (inHeroPhase)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _WeaponVfxPainter(
                        kind: heroAttackKind,
                        progress: heroPhaseT,
                        fromLeftToRight: true,
                        isCritical: heroAttackEntry?.isCritical ?? false,
                      ),
                    ),
                  ),
                if (inEnemyPhase)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _WeaponVfxPainter(
                        kind: enemyAttackKind,
                        progress: enemyPhaseT,
                        fromLeftToRight: false,
                        isCritical:
                            enemyAttackEntry?.kind == CombatLogKind.enemyHeavyBlow,
                      ),
                    ),
                  ),

                // 5. Floating Damage / Crit / Heal / Dodge Popups
                if (inHeroPhase && heroPhaseT > 0.25) ...[
                  if (heroFumbled && heroAttackEntry != null)
                    _FloatingBattlePopup(
                      left: 20,
                      bottom: 105 + 22 * heroPhaseT,
                      text: 'FALHA 1! -${heroAttackEntry.damage}',
                      color: AppTheme.bloodCrimson,
                      display: display,
                    )
                  else if (enemyDodged)
                    _FloatingBattlePopup(
                      right: 20,
                      bottom: 105 + 22 * heroPhaseT,
                      text: 'MISS / ESQUIVA!',
                      color: AppTheme.dullSilver,
                      display: display,
                    )
                  else if (heroAttackEntry != null &&
                      heroAttackEntry.damage > 0)
                    _FloatingBattlePopup(
                      right: 18,
                      bottom: 105 + 26 * heroPhaseT,
                      text: heroAttackEntry.isCritical
                          ? 'CRIT! -${heroAttackEntry.damage}'
                          : '-${heroAttackEntry.damage}',
                      color: heroAttackEntry.isCritical
                          ? AppTheme.emberGold
                          : AppTheme.bloodCrimson,
                      display: display,
                      fontSize: heroAttackEntry.isCritical ? 26 : 22,
                    ),
                  if (heroHeal > 0)
                    _FloatingBattlePopup(
                      left: 24,
                      bottom: 105 + 24 * heroPhaseT,
                      text: '+$heroHeal PV',
                      color: const Color(0xFF4CE08D),
                      display: display,
                    ),
                  if (enemyStunned)
                    _FloatingBattlePopup(
                      right: 22,
                      bottom: 126 + 18 * heroPhaseT,
                      text: '★ ATORDOADO!',
                      color: AppTheme.emberGold,
                      display: display,
                    ),
                ],
                if (inEnemyPhase && enemyPhaseT > 0.25) ...[
                  if (heroDodged)
                    _FloatingBattlePopup(
                      left: 20,
                      bottom: 105 + 22 * enemyPhaseT,
                      text: 'ESQUIVOU!',
                      color: AppTheme.emberGold,
                      display: display,
                    )
                  else if (enemyAttackEntry != null &&
                      enemyAttackEntry.damage > 0)
                    _FloatingBattlePopup(
                      left: 22,
                      bottom: 105 + 24 * enemyPhaseT,
                      text: '-${enemyAttackEntry.damage}',
                      color: AppTheme.bloodCrimson,
                      display: display,
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FloatingBattlePopup extends StatelessWidget {
  const _FloatingBattlePopup({
    required this.text,
    required this.color,
    required this.display,
    this.left,
    this.right,
    required this.bottom,
    this.fontSize = 20,
  });

  final String text;
  final Color color;
  final DisplayFont display;
  final double? left;
  final double? right;
  final double bottom;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppTheme.obsidianBlack.withValues(alpha: 0.88),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Text(
          text,
          style: display.style(fontSize, color: color, height: 1),
        ),
      ),
    );
  }
}

/// Paints the 16-bit dark-fantasy stone arena floor and night/ember sky
/// inspired by the 2nd reference image.
class _ArenaBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // 1. Night / Twilight Forge Sky bands
    paint.color = const Color(0xFF141820);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    paint.color = const Color(0xFF1B222C);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.35, size.width, size.height * 0.45),
      paint,
    );

    // Subtle pixel stars & crescent moon on top-right
    paint.color = const Color(0xFF3A4659);
    for (var i = 0; i < 6; i++) {
      final sx = (size.width * (0.12 + i * 0.14));
      final sy = 14.0 + (i.isEven ? 6.0 : 18.0);
      canvas.drawRect(Rect.fromLTWH(sx, sy, 3, 3), paint);
    }

    // 2. Stonebrick Platform Floor (bottom 22px, matching 2nd reference image)
    final floorTop = size.height - 22;
    paint.color = const Color(0xFF3E3D4A);
    canvas.drawRect(Rect.fromLTWH(0, floorTop, size.width, 4), paint);

    paint.color = const Color(0xFF23222B);
    canvas.drawRect(Rect.fromLTWH(0, floorTop + 4, size.width, 18), paint);

    // Pixel stone tile joints
    paint.color = const Color(0xFF0F0F12);
    for (var x = 0.0; x < size.width; x += 24) {
      canvas.drawRect(Rect.fromLTWH(x, floorTop, 2, 10), paint);
      canvas.drawRect(Rect.fromLTWH(x + 12, floorTop + 10, 2, 12), paint);
    }
    canvas.drawRect(Rect.fromLTWH(0, floorTop + 10, size.width, 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints weapon-specific and class-specific pixel-art VFX across the stage:
/// - Greatsword crescent slash arc
/// - Staff arcane orb + beam + runic explosion
/// - Twin dagger X-slash + shadow trail
/// - Hunter bow piercing arrow + wind rings
/// - Monk Ki shockwave rings + palm bursts
/// - Paladin/Cleric vertical pillar of radiant golden light
/// - Eldritch Knight sword slash + crackling lightning bolts
/// - Druid/Bard resonance waves + erupting thorns
/// - Defensive hexagonal shield ward
class _WeaponVfxPainter extends CustomPainter {
  _WeaponVfxPainter({
    required this.kind,
    required this.progress,
    required this.fromLeftToRight,
    required this.isCritical,
  });

  final AttackAnimationKind kind;
  final double progress;
  final bool fromLeftToRight;
  final bool isCritical;

  @override
  void paint(Canvas canvas, Size size) {
    final startX = fromLeftToRight ? 95.0 : size.width - 95.0;
    final endX = fromLeftToRight ? size.width - 75.0 : 75.0;
    final currentX = startX + (endX - startX) * progress.clamp(0.0, 1.0);
    final centerY = size.height - 66.0;

    switch (kind) {
      case AttackAnimationKind.greatswordCleave:
        _paintGreatswordSlash(canvas, endX, centerY);
      case AttackAnimationKind.staffArcaneCast:
        _paintStaffArcaneCast(canvas, startX, currentX, endX, centerY);
      case AttackAnimationKind.daggerShadowFlurry:
        _paintDaggerXSlash(canvas, startX, endX, centerY);
      case AttackAnimationKind.bowPiercingShot:
        _paintBowArrowShot(canvas, startX, currentX, endX, centerY);
      case AttackAnimationKind.martialKiStrike:
        _paintMartialKiStrike(canvas, endX, centerY);
      case AttackAnimationKind.holyRadiantSmite:
        _paintHolyRadiantSmite(canvas, endX, size.height);
      case AttackAnimationKind.eldritchRunicSlash:
        _paintEldritchLightningSlash(canvas, startX, endX, centerY);
      case AttackAnimationKind.primalSongWave:
        _paintPrimalSongWave(canvas, startX, currentX, endX, centerY, size.height);
      case AttackAnimationKind.defensiveGuard:
        _paintDefensiveWard(canvas, startX, centerY);
    }
  }

  void _paintGreatswordSlash(Canvas canvas, double targetX, double centerY) {
    if (progress < 0.20 || progress > 0.90) return;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isCritical ? 6.0 : 4.5
      ..color = isCritical ? AppTheme.emberGold : AppTheme.bloodCrimson;

    final dir = fromLeftToRight ? 1.0 : -1.0;
    final rect = Rect.fromCenter(
      center: Offset(targetX - 10 * dir, centerY),
      width: 56,
      height: 76,
    );
    canvas.drawArc(
      rect,
      fromLeftToRight ? -1.1 : 2.0,
      2.2 * ((progress - 0.20) / 0.70).clamp(0.2, 1.0),
      false,
      p,
    );

    // Inner bright steel edge
    p
      ..strokeWidth = 2.0
      ..color = AppTheme.ashWhite;
    canvas.drawArc(
      rect.deflate(4),
      fromLeftToRight ? -1.0 : 2.1,
      1.9,
      false,
      p,
    );
  }

  void _paintStaffArcaneCast(
    Canvas canvas,
    double startX,
    double currentX,
    double endX,
    double centerY,
  ) {
    final paint = Paint();
    final primaryColor =
        isCritical ? AppTheme.emberGold : const Color(0xFF6CD4FF);
    final coreColor = AppTheme.ashWhite;

    // 1. Casting rune circle near the staff tip
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = primaryColor.withValues(alpha: (1.0 - progress * 0.5).clamp(0.2, 1.0));
    canvas.drawCircle(Offset(startX, centerY - 10), 12 + 4 * progress, paint);

    // 2. Travelling arcane spell bolt + glowing trail
    paint
      ..style = PaintingStyle.fill
      ..color = primaryColor.withValues(alpha: 0.45);
    final beamLeft = math.min(startX, currentX);
    final beamWidth = (currentX - startX).abs().clamp(8.0, 90.0);
    canvas.drawRect(
      Rect.fromLTWH(beamLeft, centerY - 12, beamWidth, 6),
      paint,
    );

    // Pixelated arcane orb head
    paint.color = primaryColor;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(currentX, centerY - 9), width: 16, height: 16),
      paint,
    );
    paint.color = coreColor;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(currentX, centerY - 9), width: 8, height: 8),
      paint,
    );

    // 3. Arcane burst on target impact
    if (progress > 0.65) {
      final burstR = (progress - 0.65) * 75.0;
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = primaryColor;
      canvas.drawCircle(Offset(endX, centerY - 6), burstR, paint);
    }
  }

  void _paintDaggerXSlash(
    Canvas canvas,
    double startX,
    double endX,
    double centerY,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    // Shadow dash afterimage lines
    paint.color = const Color(0xFF4CE08D).withValues(alpha: 0.55);
    canvas.drawLine(
      Offset(startX, centerY + 6),
      Offset(endX, centerY + 6),
      paint,
    );

    if (progress > 0.25) {
      // Twin X-shaped blade slashes on target
      paint
        ..strokeWidth = 4.0
        ..color = isCritical ? AppTheme.emberGold : const Color(0xFF4CE08D);
      canvas.drawLine(
        Offset(endX - 22, centerY - 24),
        Offset(endX + 22, centerY + 20),
        paint,
      );
      paint.color = AppTheme.ashWhite;
      canvas.drawLine(
        Offset(endX - 22, centerY + 20),
        Offset(endX + 22, centerY - 24),
        paint,
      );
    }
  }

  void _paintBowArrowShot(
    Canvas canvas,
    double startX,
    double currentX,
    double endX,
    double centerY,
  ) {
    final dir = fromLeftToRight ? 1.0 : -1.0;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = AppTheme.emberGold;

    // Arrow shaft + wind trail
    canvas.drawLine(
      Offset(currentX - 28 * dir, centerY - 6),
      Offset(currentX, centerY - 6),
      paint,
    );

    // Glowing arrowhead
    paint
      ..style = PaintingStyle.fill
      ..color = AppTheme.ashWhite;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(currentX, centerY - 6), width: 8, height: 6),
      paint,
    );

    // Wind rings along trajectory
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = const Color(0xFF7CE8B0).withValues(alpha: 0.7);
    final midX = (startX + currentX) / 2;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(midX, centerY - 6), width: 8, height: 22),
      paint,
    );
  }

  void _paintMartialKiStrike(Canvas canvas, double targetX, double centerY) {
    if (progress < 0.20) return;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = AppTheme.emberGold;

    final r1 = ((progress - 0.20) * 52.0).clamp(4.0, 42.0);
    canvas.drawCircle(Offset(targetX, centerY - 4), r1, paint);

    paint.color = const Color(0xFF7CE8B0);
    final r2 = ((progress - 0.30) * 38.0).clamp(2.0, 28.0);
    canvas.drawCircle(Offset(targetX, centerY - 4), r2, paint);
  }

  void _paintHolyRadiantSmite(Canvas canvas, double targetX, double stageHeight) {
    final paint = Paint()..style = PaintingStyle.fill;
    final alpha = math.sin(progress * math.pi).clamp(0.15, 0.85);

    // Vertical pillar of golden divine light descending from heaven
    paint.color = AppTheme.emberGold.withValues(alpha: alpha * 0.55);
    canvas.drawRect(
      Rect.fromLTWH(targetX - 18, 0, 36, stageHeight - 22),
      paint,
    );

    paint.color = AppTheme.ashWhite.withValues(alpha: alpha * 0.85);
    canvas.drawRect(
      Rect.fromLTWH(targetX - 6, 0, 12, stageHeight - 22),
      paint,
    );

    // Radiant cross sigil at impact height
    paint.color = AppTheme.emberGold;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(targetX, stageHeight - 68),
        width: 44,
        height: 6,
      ),
      paint,
    );
  }

  void _paintEldritchLightningSlash(
    Canvas canvas,
    double startX,
    double endX,
    double centerY,
  ) {
    _paintGreatswordSlash(canvas, endX, centerY);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = const Color(0xFF6CD4FF);

    final path = Path()
      ..moveTo(startX + 20, centerY - 18)
      ..lineTo((startX + endX) * 0.45, centerY - 30)
      ..lineTo((startX + endX) * 0.60, centerY - 4)
      ..lineTo(endX, centerY - 12);
    canvas.drawPath(path, paint);
  }

  void _paintPrimalSongWave(
    Canvas canvas,
    double startX,
    double currentX,
    double endX,
    double centerY,
    double stageHeight,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = const Color(0xFF4CE08D);

    // Expanding sonic/nature wave rings
    for (var i = 0; i < 3; i++) {
      final wx = startX + (currentX - startX) * ((i + 1) / 3);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(wx, centerY - 6),
          width: 10,
          height: 18 + i * 10.0,
        ),
        paint,
      );
    }

    // Erupting primal thorns under enemy
    if (progress > 0.45) {
      paint
        ..style = PaintingStyle.fill
        ..color = const Color(0xFF38A36D);
      final h = ((progress - 0.45) * 65.0).clamp(6.0, 36.0);
      canvas.drawRect(
        Rect.fromLTWH(endX - 14, stageHeight - 22 - h, 6, h),
        paint,
      );
      canvas.drawRect(
        Rect.fromLTWH(endX + 6, stageHeight - 22 - h * 0.8, 6, h * 0.8),
        paint,
      );
    }
  }

  void _paintDefensiveWard(Canvas canvas, double heroX, double centerY) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = AppTheme.emberGold.withValues(alpha: 0.85);

    canvas.drawArc(
      Rect.fromCenter(center: Offset(heroX - 6, centerY), width: 46, height: 68),
      -1.3,
      2.6,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _WeaponVfxPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.kind != kind ||
      oldDelegate.isCritical != isCritical;
}

class _StageStatusChip extends StatelessWidget {
  const _StageStatusChip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.obsidianBlack.withValues(alpha: 0.85),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
