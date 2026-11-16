import 'dart:async';
import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../core/audio/sound_service.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/combat.dart';
import '../../../l10n/l10n.dart';
import 'd20_roller_widget.dart';

enum _RollPhase { waiting, rolling, revealed }

/// Opens an interactive center-screen modal window asking the player to click
/// the D20 die. When clicked, the die drops onto the stone table, tumbles/spins,
/// reveals the natural roll (`1..20`) with full D&D 5e modifiers, and returns
/// the rolled natural number so the combat/dungeon engine executes that exact roll.
///
/// Returns `null` if dismissed before rolling.
Future<int?> showInteractiveD20RollDialog({
  required BuildContext context,
  required String actionTitle,
  required Attribute attribute,
  required int attributeModifier,
  required int proficiencyBonus,
  required int targetNumber,
  required SoundService soundService,
  bool isDifficultyClass = false,
  int? forcedD20,
  bool guaranteedNatural20 = false,
}) {
  return showDialog<int>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.78),
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: _D20RollDialogBody(
        actionTitle: actionTitle,
        attribute: attribute,
        attributeModifier: attributeModifier,
        proficiencyBonus: proficiencyBonus,
        targetNumber: targetNumber,
        soundService: soundService,
        isDifficultyClass: isDifficultyClass,
        forcedD20: forcedD20,
        guaranteedNatural20: guaranteedNatural20,
      ),
    ),
  );
}

class _D20RollDialogBody extends StatefulWidget {
  const _D20RollDialogBody({
    required this.actionTitle,
    required this.attribute,
    required this.attributeModifier,
    required this.proficiencyBonus,
    required this.targetNumber,
    required this.soundService,
    required this.isDifficultyClass,
    this.forcedD20,
    this.guaranteedNatural20 = false,
  });

  final String actionTitle;
  final Attribute attribute;
  final int attributeModifier;
  final int proficiencyBonus;
  final int targetNumber;
  final SoundService soundService;
  final bool isDifficultyClass;
  final int? forcedD20;
  final bool guaranteedNatural20;

  @override
  State<_D20RollDialogBody> createState() => _D20RollDialogBodyState();
}

class _D20RollDialogBodyState extends State<_D20RollDialogBody>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _rollController;
  Timer? _autoCloseTimer;

  _RollPhase _phase = _RollPhase.waiting;
  int _finalRoll = 10;
  int _displayFace = 20;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _rollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );

    _rollController.addListener(_onRollTick);
    _rollController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _revealResult();
      }
    });
  }

  void _onRollTick() {
    if (_phase != _RollPhase.rolling) return;
    final step = (_rollController.value * 14).floor();
    final face = ((step * 7 + _finalRoll) % 20) + 1;
    if (face != _displayFace) {
      setState(() => _displayFace = face);
    }
  }

  void _startRoll() {
    if (_phase != _RollPhase.waiting) {
      if (_phase == _RollPhase.revealed) {
        _closeWithResult();
      }
      return;
    }

    final rng = math.Random();
    final rolled = widget.guaranteedNatural20
        ? 20
        : (widget.forcedD20 != null
            ? widget.forcedD20!.clamp(1, 20)
            : rng.nextInt(20) + 1);

    setState(() {
      _finalRoll = rolled;
      _phase = _RollPhase.rolling;
    });

    unawaited(widget.soundService.play(GameSfx.diceRoll));
    _rollController.forward(from: 0);
  }

  void _revealResult() {
    setState(() {
      _displayFace = _finalRoll;
      _phase = _RollPhase.revealed;
    });

    if (_finalRoll == 20) {
      unawaited(widget.soundService.play(GameSfx.criticalHit));
    } else if (_finalRoll == 1) {
      unawaited(widget.soundService.play(GameSfx.criticalFumble));
    } else {
      unawaited(widget.soundService.play(GameSfx.diceReveal));
    }

    _autoCloseTimer = Timer(const Duration(milliseconds: 950), () {
      if (mounted) _closeWithResult();
    });
  }

  void _closeWithResult() {
    _autoCloseTimer?.cancel();
    if (mounted) {
      Navigator.of(context).pop(_finalRoll);
    }
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _pulseController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  D20Outcome _computeOutcome(int natural) {
    if (natural == 20) return D20Outcome.criticalHit;
    if (natural == 1) return D20Outcome.criticalFumble;
    final total =
        natural + widget.attributeModifier + widget.proficiencyBonus;
    return total >= widget.targetNumber ? D20Outcome.hit : D20Outcome.miss;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);

    final attrCode = game.attributeCode(widget.attribute);
    final modText = widget.attributeModifier >= 0
        ? '+${widget.attributeModifier}'
        : '${widget.attributeModifier}';
    final targetLabel = widget.isDifficultyClass
        ? l10n.dungeonDifficultyLabel(widget.targetNumber)
        : l10n.combatArmorClassLabel(widget.targetNumber);

    final outcome = _phase == _RollPhase.revealed
        ? _computeOutcome(_finalRoll)
        : null;

    final accentColor = switch (outcome) {
      D20Outcome.criticalHit => AppTheme.emberGold,
      D20Outcome.criticalFumble => AppTheme.bloodCrimson,
      D20Outcome.hit => AppTheme.emberGold,
      D20Outcome.miss => AppTheme.dullSilver,
      null => AppTheme.emberGold,
    };

    final total =
        _finalRoll + widget.attributeModifier + widget.proficiencyBonus;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: PixelFrame(
        key: const Key('d20_interactive_dialog'),
        highlight: true,
        color: outcome == D20Outcome.criticalFumble
            ? AppTheme.darkBlood
            : AppTheme.castIron,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Header -----------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.actionTitle,
                    style: display.style(24, color: AppTheme.emberGold),
                  ),
                ),
                PixelTag(
                  text: 'vs $targetLabel',
                  color: AppTheme.emberGold,
                ),
                if (_phase == _RollPhase.waiting) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    key: const Key('d20_dialog_close_btn'),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop(null),
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppTheme.dullSilver,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),

            if (widget.guaranteedNatural20) ...[
              PixelTag(
                text: l10n.d20DialogInspiredBanner,
                color: AppTheme.emberGold,
              ),
              const SizedBox(height: 8),
            ] else ...[
              Text(
                '1d20 + $attrCode ($modText) + Prof (+${widget.proficiencyBonus})',
                style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12),
              ),
              const SizedBox(height: 8),
            ],

            // --- Interactive Drop & Tumble Die Stage ------------------------
            GestureDetector(
              key: const Key('d20_dialog_tap_area'),
              onTap: _startRoll,
              child: Container(
                width: double.infinity,
                height: 148,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.obsidianBlack,
                  border: Border.all(color: accentColor, width: 2),
                ),
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _pulseController,
                    _rollController,
                  ]),
                  builder: (context, _) {
                    var offsetY = 0.0;
                    var angle = 0.0;
                    var scale = 1.0;

                    if (_phase == _RollPhase.waiting) {
                      scale = 1.0 + 0.06 * _pulseController.value;
                    } else if (_phase == _RollPhase.rolling) {
                      final bounce = Curves.bounceOut.transform(
                        _rollController.value,
                      );
                      offsetY = -58.0 * (1.0 - bounce);
                      angle = _rollController.value * math.pi * 5.0;
                      scale = 0.85 + 0.25 * _rollController.value;
                    } else if (_phase == _RollPhase.revealed) {
                      scale = _finalRoll == 20 ? 1.16 : 1.05;
                    }

                    return Transform.translate(
                      offset: Offset(0, offsetY),
                      child: Transform.rotate(
                        angle: angle,
                        child: Transform.scale(
                          scale: scale,
                          child: SizedBox(
                            width: 88,
                            height: 88,
                            child: CustomPaint(
                              painter: D20FacetPainter(
                                borderColor: accentColor,
                                fillColor: outcome == D20Outcome.criticalHit
                                    ? const Color(0xFF423015)
                                    : (outcome == D20Outcome.criticalFumble
                                        ? AppTheme.darkBlood
                                        : AppTheme.castIron),
                              ),
                              child: Center(
                                child: Text(
                                  _phase == _RollPhase.waiting
                                      ? 'd20'
                                      : '$_displayFace',
                                  key: const Key('d20_dialog_face_text'),
                                  style: display.style(
                                    _phase == _RollPhase.waiting ? 26 : 36,
                                    color: accentColor,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- Status / Result Footer -------------------------------------
            if (_phase == _RollPhase.waiting)
              Text(
                l10n.d20DialogTapToRoll,
                textAlign: TextAlign.center,
                style: display.style(22, color: AppTheme.emberGold),
              )
            else if (_phase == _RollPhase.rolling)
              Text(
                l10n.d20DialogRolling,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13),
              )
            else ...[
              Text(
                switch (outcome!) {
                  D20Outcome.criticalHit => l10n.combatD20CritTitle,
                  D20Outcome.criticalFumble => l10n.combatD20FumbleTitle,
                  D20Outcome.hit => l10n.combatD20HitTitle(
                      total,
                      widget.targetNumber,
                    ),
                  D20Outcome.miss => l10n.combatD20MissTitle(
                      total,
                      widget.targetNumber,
                    ),
                },
                textAlign: TextAlign.center,
                style: display.style(22, color: accentColor, height: 1.1),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.combatD20Formula(
                  _finalRoll,
                  attrCode,
                  modText,
                  widget.proficiencyBonus,
                  total,
                  widget.isDifficultyClass ? 'CD/DC' : 'CA/AC',
                  widget.targetNumber,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.ashWhite, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.d20DialogTapToContinue,
                style: const TextStyle(color: AppTheme.darkAsh, fontSize: 11),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
