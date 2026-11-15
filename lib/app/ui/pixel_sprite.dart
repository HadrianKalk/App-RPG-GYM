import 'package:material_ui/material_ui.dart';

import '../../core/game/hero_appearance.dart';

/// Multi-color pixel sprite: each character in [rows] maps to a color in
/// [palette]; '.' is transparent.
class PixelSprite extends StatelessWidget {
  const PixelSprite({
    super.key,
    required this.rows,
    required this.palette,
    this.pixelSize = 4,
    this.flipHorizontal = false,
    this.hitFlashColor,
  });

  final List<String> rows;
  final Map<String, Color> palette;
  final double pixelSize;
  final bool flipHorizontal;
  final Color? hitFlashColor;

  @override
  Widget build(BuildContext context) {
    final w = rows.fold<int>(0, (m, r) => r.length > m ? r.length : m);
    return CustomPaint(
      size: Size(w * pixelSize, rows.length * pixelSize),
      painter: _SpritePainter(
        rows,
        palette,
        pixelSize,
        flipHorizontal: flipHorizontal,
        hitFlashColor: hitFlashColor,
      ),
    );
  }
}

class _SpritePainter extends CustomPainter {
  _SpritePainter(
    this.rows,
    this.palette,
    this.px, {
    required this.flipHorizontal,
    required this.hitFlashColor,
  });

  final List<String> rows;
  final Map<String, Color> palette;
  final double px;
  final bool flipHorizontal;
  final Color? hitFlashColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final maxW = rows.fold<int>(0, (m, r) => r.length > m ? r.length : m);
    for (var y = 0; y < rows.length; y++) {
      final row = rows[y];
      for (var x = 0; x < row.length; x++) {
        final ch = row[x];
        if (ch == '.') continue;
        final baseColor = palette[ch];
        if (baseColor == null) continue;
        paint.color = hitFlashColor != null
            ? Color.lerp(baseColor, hitFlashColor, 0.72)!
            : baseColor;
        final drawX = flipHorizontal ? (maxW - 1 - x) : x;
        canvas.drawRect(
          Rect.fromLTWH(drawX * px, y * px, px + 0.35, px + 0.35),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SpritePainter old) =>
      old.rows != rows ||
      old.palette != palette ||
      old.px != px ||
      old.flipHorizontal != flipHorizontal ||
      old.hitFlashColor != hitFlashColor;
}

/// Poses supported by the Paper-Doll compositor, including weapon-specific
/// combat stances.
enum HeroPose {
  idle,
  flex,
  attackGreatsword,
  attackStaff,
  attackDaggers,
  attackBow,
  attackMartial,
  attackHolyBlade,
  guard;

  bool get isCombatWeaponDrawn =>
      this != HeroPose.idle && this != HeroPose.flex;

  static HeroPose forAttack(AttackAnimationKind kind) => switch (kind) {
        AttackAnimationKind.greatswordCleave => HeroPose.attackGreatsword,
        AttackAnimationKind.staffArcaneCast ||
        AttackAnimationKind.primalSongWave =>
          HeroPose.attackStaff,
        AttackAnimationKind.daggerShadowFlurry => HeroPose.attackDaggers,
        AttackAnimationKind.bowPiercingShot => HeroPose.attackBow,
        AttackAnimationKind.martialKiStrike => HeroPose.attackMartial,
        AttackAnimationKind.holyRadiantSmite ||
        AttackAnimationKind.eldritchRunicSlash =>
          HeroPose.attackHolyBlade,
        AttackAnimationKind.defensiveGuard => HeroPose.guard,
      };
}

/// Renders the player's customized [HeroAppearance] as a 28x36 16-bit
/// Action-RPG sprite (inspired by the 2nd Berserk reference image),
/// compositing back gear, body, pants, boots, torso, eyes, beard, hair,
/// weapon action pose, and optional combat cosmetic aura.
class HeroAvatar extends StatelessWidget {
  const HeroAvatar({
    super.key,
    required this.appearance,
    this.equippedCosmeticId,
    this.pose = HeroPose.idle,
    this.pixelSize = 3.2,
    this.flipHorizontal = false,
    this.hitFlashColor,
  });

  final HeroAppearance appearance;
  final String? equippedCosmeticId;
  final HeroPose pose;
  final double pixelSize;
  final bool flipHorizontal;
  final Color? hitFlashColor;

  @override
  Widget build(BuildContext context) {
    final composed = HeroPaperDoll.compose(
      appearance,
      equippedCosmeticId: equippedCosmeticId,
      pose: pose,
    );
    return PixelSprite(
      rows: composed.rows,
      palette: composed.palette,
      pixelSize: pixelSize,
      flipHorizontal: flipHorizontal,
      hitFlashColor: hitFlashColor,
    );
  }
}

/// Result of compositing all Paper-Doll layers into a single 28x36 grid and palette.
final class ComposedSprite {
  const ComposedSprite({required this.rows, required this.palette});

  final List<String> rows;
  final Map<String, Color> palette;
}

/// 28x36 16-bit Action-RPG Paper-Doll layer compositor.
///
/// Palette tokens:
/// - `.` : transparent
/// - `K` : obsidian outline (`#0F0F12`)
/// - `W` / `w` : bright white / soft grey-white (sclera, bandage, blade shine, white hair streak)
/// - `S` / `s` / `d` : skin highlight / base / shadow
/// - `E` : eye iris color
/// - `H` / `h` / `j` : hair & beard highlight / base / shadow
/// - `T` / `t` / `u` : primary torso/armor highlight / base / shadow
/// - `L` / `l` / `b` : secondary leather/boots/belt highlight / base / shadow
/// - `P` / `p` / `q` : pants/cloth highlight / base / shadow
/// - `C` / `c` / `v` : cape/cloak highlight / base / shadow
/// - `A` : metallic gold / buckle / boot toe highlight
/// - `M` / `m` / `n` : forged weapon steel highlight / mid / dark
/// - `G` : cosmetic aura/crest accent
abstract final class HeroPaperDoll {
  static const int width = 28;
  static const int height = 36;

  /// Builds the dynamic color palette from [appearance] and optional [equippedCosmeticId].
  static Map<String, Color> buildPalette(
    HeroAppearance appearance, {
    String? equippedCosmeticId,
  }) {
    final skin = appearance.skinTone.ramp;
    final hair = appearance.hairColor.ramp;
    final tint = appearance.outfitTint;
    final eyeArgb = appearance.eyeStyle == EyeStyle.glowing
        ? appearance.eyeColor.glowArgb
        : appearance.eyeColor.argb;

    return {
      'K': const Color(0xFF0F0F12),
      'W': const Color(0xFFF2F4F8),
      'w': const Color(0xFFB5BBC7),
      'S': Color(skin.highlight),
      's': Color(skin.base),
      'd': Color(skin.shadow),
      'E': Color(eyeArgb),
      'H': Color(hair.highlight),
      'h': Color(hair.base),
      'j': Color(hair.shadow),
      'T': Color(tint.primary.highlight),
      't': Color(tint.primary.base),
      'u': Color(tint.primary.shadow),
      'L': Color(tint.secondary.highlight),
      'l': Color(tint.secondary.base),
      'b': Color(tint.secondary.shadow),
      'P': Color(tint.cloth.highlight),
      'p': Color(tint.cloth.base),
      'q': Color(tint.cloth.shadow),
      'C': Color(tint.cape.highlight),
      'c': Color(tint.cape.base),
      'v': Color(tint.cape.shadow),
      'A': Color(tint.accentArgb),
      'M': const Color(0xFFA8AAB5),
      'm': const Color(0xFF686A75),
      'n': const Color(0xFF3A3C46),
      'R': const Color(0xFFC83232),
      'G': _cosmeticColor(equippedCosmeticId),
    };
  }

  static Color _cosmeticColor(String? cosmeticId) {
    if (cosmeticId == null) return const Color(0xFFE0A96D);
    if (cosmeticId.contains('crimson') ||
        cosmeticId.contains('blood') ||
        cosmeticId.contains('berserk')) {
      return const Color(0xFFE03C3E);
    }
    if (cosmeticId.contains('arcane') ||
        cosmeticId.contains('lich') ||
        cosmeticId.contains('void')) {
      return const Color(0xFF6CD4FF);
    }
    if (cosmeticId.contains('emerald') || cosmeticId.contains('hydra')) {
      return const Color(0xFF4CE08D);
    }
    return const Color(0xFFFFD166);
  }

  /// Composites all selected layers from back to front into a 28x36 grid.
  static ComposedSprite compose(
    HeroAppearance appearance, {
    String? equippedCosmeticId,
    HeroPose pose = HeroPose.idle,
  }) {
    final grid = List.generate(
      height,
      (_) => List<String>.filled(width, '.'),
      growable: false,
    );

    void applyLayer(List<String> layer) {
      final maxY = layer.length < height ? layer.length : height;
      for (var y = 0; y < maxY; y++) {
        final row = layer[y];
        final maxX = row.length < width ? row.length : width;
        for (var x = 0; x < maxX; x++) {
          final ch = row[x];
          if (ch != '.' && ch != ' ') {
            grid[y][x] = ch;
          }
        }
      }
    }

    // 0. Back layer (when a weapon is drawn in hand during combat, show cloak only)
    applyLayer(
      pose.isCombatWeaponDrawn
          ? (appearance.backStyle == BackStyle.none
              ? const []
              : _backTatteredCloak)
          : _backLayer(appearance.backStyle),
    );

    // 1. Base body anatomy (head, neck, arms, hands, legs silhouette)
    applyLayer(pose == HeroPose.flex ? _bodyFlexLayer : _bodyIdleLayer);

    // 2. Legs / pants layer
    applyLayer(_legsLayer(appearance.legsStyle));

    // 3. Boots / footwear layer
    applyLayer(_bootsLayer(appearance.bootsStyle));

    // 4. Torso / armor / shirt layer
    applyLayer(
      pose == HeroPose.flex
          ? _torsoFlexLayer(appearance.torsoStyle)
          : _torsoIdleLayer(appearance.torsoStyle),
    );

    // 5. Eyes & facial expression layer
    applyLayer(_eyesLayer(appearance.eyeStyle));

    // 6. Beard / facial hair layer
    applyLayer(_beardLayer(appearance.beardStyle));

    // 7. Hair / helm / hood layer
    applyLayer(_hairLayer(appearance.hairStyle));

    // 8. Weapon / Action Foreground Layer (drawn weapon in hand during attack/guard)
    applyLayer(_weaponPoseForegroundLayer(pose));

    // 9. Equipped combat cosmetic aura/crest (if any)
    if (equippedCosmeticId != null && equippedCosmeticId.isNotEmpty) {
      applyLayer(_cosmeticAuraLayer);
    }

    return ComposedSprite(
      rows: [for (final r in grid) r.join()],
      palette: buildPalette(appearance, equippedCosmeticId: equippedCosmeticId),
    );
  }

  // ---------------------------------------------------------------------------
  // Layer 0: Back Gear (Capes & Weapons on Back — 28x36)
  // ---------------------------------------------------------------------------

  static List<String> _backLayer(BackStyle style) => switch (style) {
        BackStyle.dragonslayerCape => _backDragonslayerCape,
        BackStyle.tatteredCloak => _backTatteredCloak,
        BackStyle.runicStaffCape => _backRunicStaffCape,
        BackStyle.twinDaggersCloak => _backTwinDaggersCloak,
        BackStyle.paladinWingedMantle => _backPaladinMantle,
        BackStyle.none => const [],
      };

  /// Exact 2nd-image back gear: diagonal greatsword hilt top-right, broad blade
  /// behind right shoulder, blade tip lower-left, and tattered dark cape!
  static const List<String> _backDragonslayerCape = [
    '............................', // 00
    '............................', // 01
    '............................', // 02
    '............................', // 03
    '....................KKK.....', // 04
    '...................KMMMK....', // 05
    '...................KmnK.....', // 06
    '..................KLlK......', // 07
    '...............KKK.LlK......', // 08
    '..............KMMmKLK.......', // 09
    '.............KMmmnnKKK......', // 10
    '.............KmnnnnnMMK.....', // 11
    '.............KnnnnnmmMK.....', // 12
    '..............KnnnnmmK......', // 13
    '...............KKKKcCK......', // 14
    '..................KccK......', // 15
    '..................KccvK.....', // 16
    '..................KccvK.....', // 17
    '........K.........KcccvK....', // 18
    '........Kv........KcccvK....', // 19
    '.......Kcv........KccccvK...', // 20
    '......KWMK........KccccvK...', // 21
    '.....KWMmnK.......KcccccvK..', // 22
    '.....KMmnnK..KKK..KcccccvK..', // 23
    '.....KMmnnK..KcvK.KccccccvK.', // 24
    '.....KMmnnK..KccvKKccccccvK.', // 25
    '.....KWMmnK..KcccvccccccccvK', // 26
    '.....KKKKMK..KcccvccccccccvK', // 27
    '.........KK..KcvKvcccccccvK.', // 28
    '.............KK.KcvKccccvK..', // 29
    '................KK.KcvKcvK..', // 30
    '...................KK.KKK...', // 31
    '............................', // 32
    '............................', // 33
    '............................', // 34
    '............................', // 35
  ];

  static const List<String> _backTatteredCloak = [
    '............................', // 00
    '............................', // 01
    '............................', // 02
    '............................', // 03
    '............................', // 04
    '............................', // 05
    '............................', // 06
    '............................', // 07
    '............................', // 08
    '............................', // 09
    '............................', // 10
    '............................', // 11
    '............................', // 12
    '............................', // 13
    '.................KKcCK......', // 14
    '..................KccK......', // 15
    '..................KccvK.....', // 16
    '..................KccvK.....', // 17
    '........K.........KcccvK....', // 18
    '........Kv........KcccvK....', // 19
    '........Kcv.......KccccvK...', // 20
    '........Kcv.......KccccvK...', // 21
    '........Kccv......KcccccvK..', // 22
    '........Kccv.KKK..KcccccvK..', // 23
    '........Kccv.KcvK.KccccccvK.', // 24
    '.......Kcccv.KccvKKccccccvK.', // 25
    '.......Kcccv.KcccvccccccccvK', // 26
    '.......KcvKv.KcccvccccccccvK', // 27
    '.......KK.KK.KcvKvcccccccvK.', // 28
    '.............KK.KcvKccccvK..', // 29
    '................KK.KcvKcvK..', // 30
    '...................KK.KKK...', // 31
    '............................', // 32
    '............................', // 33
    '............................', // 34
    '............................', // 35
  ];

  static const List<String> _backRunicStaffCape = [
    '............................', // 00
    '............................', // 01
    '............................', // 02
    '....................KKK.....', // 03
    '...................KAAAK....', // 04
    '..................KAEWEAK...', // 05
    '..................KAAAK.....', // 06
    '...................KLlK.....', // 07
    '..................KLlK......', // 08
    '.................KLlK.......', // 09
    '................KLlK........', // 10
    '...............KLlK.........', // 11
    '..............KLlK..........', // 12
    '..............KLK...........', // 13
    '.................KKcCK......', // 14
    '..................KccK......', // 15
    '..................KccvK.....', // 16
    '..................KccvK.....', // 17
    '..................KcccvK....', // 18
    '..................KcccvK....', // 19
    '..................KccccvK...', // 20
    '.......KLK........KccccvK...', // 21
    '......KLlK........KcccccvK..', // 22
    '.....KLlK....KKK..KcccccvK..', // 23
    '....KLlK.....KcvK.KccccccvK.', // 24
    '....KAK......KccvKKccccccvK.', // 25
    '....KK.......KcccvccccccccvK', // 26
    '.............KcccvccccccccvK', // 27
    '.............KcvKvcccccccvK.', // 28
    '.............KK.KcvKccccvK..', // 29
    '................KK.KcvKcvK..', // 30
    '...................KK.KKK...', // 31
    '............................', // 32
    '............................', // 33
    '............................', // 34
    '............................', // 35
  ];

  static const List<String> _backTwinDaggersCloak = [
    '............................', // 00
    '............................', // 01
    '............................', // 02
    '............................', // 03
    '............................', // 04
    '............................', // 05
    '.....KK.............KK......', // 06
    '....KAAK...........KAAK.....', // 07
    '.....KLlK.........KLlK......', // 08
    '......KMMK.......KMMK.......', // 09
    '.......KmmK.....KmmK........', // 10
    '........KmnK...KmnK.........', // 11
    '............................', // 12
    '............................', // 13
    '.................KKcCK......', // 14
    '..................KccK......', // 15
    '..................KccvK.....', // 16
    '..................KccvK.....', // 17
    '..................KcccvK....', // 18
    '..................KcccvK....', // 19
    '..................KccccvK...', // 20
    '..................KccccvK...', // 21
    '..................KcccccvK..', // 22
    '.............KKK..KcccccvK..', // 23
    '.............KcvK.KccccccvK.', // 24
    '.............KccvKKccccccvK.', // 25
    '.............KcccvccccccccK.', // 26
    '.............KcvK.KcccvKcvK.', // 27
    '.............KK...KK.KK.KK..', // 28
    '............................', // 29
    '............................', // 30
    '............................', // 31
    '............................', // 32
    '............................', // 33
    '............................', // 34
    '............................', // 35
  ];

  static const List<String> _backPaladinMantle = [
    '............................', // 00
    '............................', // 01
    '............................', // 02
    '............................', // 03
    '....................KKK.....', // 04
    '...................KAAAK....', // 05
    '..................KAWWWAK...', // 06
    '...................KAAAK....', // 07
    '..................KMMK......', // 08
    '.................KWMmK......', // 09
    '................KWMmnK......', // 10
    '....KKK........KWMmnK.KKK...', // 11
    '...KAAAK.......KMmnK.KAAAK..', // 12
    '...KAccK........KmnK.KccAK..', // 13
    '....KccK.........KKK.KccK...', // 14
    '.....KccK...........KccvK...', // 15
    '......KccK..........KccvK...', // 16
    '......KccK..........KcccvK..', // 17
    '.......KcvK.........KcccvK..', // 18
    '.......KcvK.........KccccvK.', // 19
    '.......KccvK........KccccvK.', // 20
    '.......KccvK........KcccccvK', // 21
    '.......KcccvK.......KcccccvK', // 22
    '.......KcccvK.KKK...KcccccvK', // 23
    '.......KccccvKKcvK..KcccccvK', // 24
    '.......KccccvKccvK..KcccccvK', // 25
    '.......KACccvKcccvKKccccccAK', // 26
    '.......KAAccvKcccvccccccccAK', // 27
    '........KKKcvKcvKvccccccAAK.', // 28
    '..........KK.KK.KcvKcccAAK..', // 29
    '................KK.KKKKKK...', // 30
    '............................', // 31
    '............................', // 32
    '............................', // 33
    '............................', // 34
    '............................', // 35
  ];

  // ---------------------------------------------------------------------------
  // Layer 1: Base Body Silhouette (Skin + Outline — 28x36)
  // ---------------------------------------------------------------------------

  static const List<String> _bodyIdleLayer = [
    '............................', // 00
    '............................', // 01
    '............................', // 02
    '............................', // 03
    '.........KKKKKKKK...........', // 04
    '........KSSSSSSSSK..........', // 05
    '........KSSSSSSSSK..........', // 06
    '........KSSSSssssK..........', // 07
    '.......KKSSSSssssKK.........', // 08
    '.......KsSSSSssssdK.........', // 09
    '.......KdSSSSssssdK.........', // 10
    '........KSSSssssdK..........', // 11
    '.........KssssddK...........', // 12
    '.........KKsdddKK...........', // 13
    '......KKKKKssssKKKKK........', // 14
    '.....KSSSSSssssSSSSSK.......', // 15
    '....KSSSSSSssssSSSSSSK......', // 16
    '....KSSsKSSSSSSSSKsSSK......', // 17
    '....KSsdKSSSSSSSSKdsSK......', // 18
    '....KSsdKSSSSSSSSKdsSK......', // 19
    '....KSsdKssssssssKdsSK......', // 20
    '....KSsdKssssssssKdsSK......', // 21
    '....KssSKssssssssKSssK......', // 22
    '.....KKKKssssssssKKKK.......', // 23
    '........KssssKssssK.........', // 24
    '.......KssssK.KssssK........', // 25
    '.......KssssK.KssssK........', // 26
    '......KssssK...KssssK.......', // 27
    '......KssssK...KssssK.......', // 28
    '......KssssK...KssssK.......', // 29
    '......KssssK...KssssK.......', // 30
    '......KssssK...KssssK.......', // 31
    '......KssssK...KssssK.......', // 32
    '.....KsssssK...KsssssK......', // 33
    '.....KsssssK...KsssssK......', // 34
    '.....KKKKKKK...KKKKKKK......', // 35
  ];

  static const List<String> _bodyFlexLayer = [
    '............................', // 00
    '............................', // 01
    '............................', // 02
    '............................', // 03
    '.........KKKKKKKK...........', // 04
    '........KSSSSSSSSK..........', // 05
    '........KSSSSSSSSK..........', // 06
    '........KSSSSssssK..........', // 07
    '.......KKSSSSssssKK.........', // 08
    '.......KsSSSSssssdK.........', // 09
    '.......KdSSSSssssdK.........', // 10
    '........KSSSssssdK..........', // 11
    '.........KssssddK...........', // 12
    '...KKK...KKsdddKK...KKK.....', // 13
    '..KSSSKKKKKssssKKKKKSSSK....', // 14
    '..KSsdSSSSSssssSSSSSdsSK....', // 15
    '..KSsdSSSSSssssSSSSSdsSK....', // 16
    '...KKKSSsKSSSSSSKsSSKKK.....', // 17
    '.....KKKKSSSSSSSSKKKK.......', // 18
    '........KSSSSSSSSK..........', // 19
    '........KssssssssK..........', // 20
    '........KssssssssK..........', // 21
    '........KssssssssK..........', // 22
    '........KssssssssK..........', // 23
    '........KssssKssssK.........', // 24
    '.......KssssK.KssssK........', // 25
    '.......KssssK.KssssK........', // 26
    '......KssssK...KssssK.......', // 27
    '......KssssK...KssssK.......', // 28
    '......KssssK...KssssK.......', // 29
    '......KssssK...KssssK.......', // 30
    '......KssssK...KssssK.......', // 31
    '......KssssK...KssssK.......', // 32
    '.....KsssssK...KsssssK......', // 33
    '.....KsssssK...KsssssK......', // 34
    '.....KKKKKKK...KKKKKKK......', // 35
  ];

  // ---------------------------------------------------------------------------
  // Layer 2: Legs / Pants (28x36)
  // ---------------------------------------------------------------------------

  static List<String> _legsLayer(LegsStyle style) => switch (style) {
        LegsStyle.darkBreeches => _legsDarkBreeches,
        LegsStyle.trainingPants => _legsTrainingPants,
        LegsStyle.platedGreaves => _legsPlatedGreaves,
        LegsStyle.monkWraps => _legsMonkWraps,
        LegsStyle.scholarTunic => _legsScholarTunic,
        LegsStyle.crimsonCuisses => _legsCrimsonCuisses,
      };

  /// 2nd image dark combat breeches + waist belt + center belt flap + side pouch!
  static const List<String> _legsDarkBreeches = [
    '............................', // 00..19
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........KLLlAAllKK..........', // 20 belt
    '........KqpKLLKLLlK.........', // 21 belt flap + side pouch
    '........KppKllKllbK.........', // 22
    '........KPPpKKqpqqK.........', // 23
    '........KPPpK.KPPqK.........', // 24
    '.......KPPPpK.KPPPqK........', // 25
    '.......KPPpqK.KPPpqK........', // 26
    '......KPPPpqK...KPPpqK......', // 27
    '......KPPpqqK...KPPpqK......', // 28
    '......KppqqqK...KppqqK......', // 29
    '............................', // 30..35 covered by boots
  ];

  static const List<String> _legsTrainingPants = [
    '............................', // 00..19
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........KAAAAAAAaK..........', // 20 sash
    '........KpppAAAppqK.........', // 21
    '........KPPPpAAppqK.........', // 22
    '........KPPPpKAppqK.........', // 23
    '........KPPPpK.KPPqK........', // 24
    '.......KPPPPpK.KPPPqK.......', // 25
    '.......KPPPpqK.KPPPqK.......', // 26
    '......KPPPPpqK...KPPPqK.....', // 27
    '......KPPPpqqK...KPPPqK.....', // 28
    '......KpppqqqK...KpppqK.....', // 29
  ];

  static const List<String> _legsPlatedGreaves = [
    '............................', // 00..19
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........KLLlAAllLK..........', // 20
    '........KTTtAAttuK..........', // 21
    '........KTTtKKttuK..........', // 22
    '........KTTtK.KTTuK.........', // 23
    '........KttuK.KttuK.........', // 24
    '.......KTTtuK.KTTtuK........', // 25
    '.......KAAtuK.KAAtuK........', // 26 knee guard
    '......KTTTtuK...KTTtuK......', // 27
    '......KTTtuuK...KTTtuK......', // 28
    '......KttuuuK...KttuuK......', // 29
  ];

  static const List<String> _legsMonkWraps = [
    '............................', // 00..19
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........KLLLLlllLK..........', // 20
    '........KPPPllpppqK.........', // 21
    '........KPPPppKppqK.........', // 22
    '........KPPPpK.KPPqK........', // 23
    '........KPPPpK.KPPqK........', // 24
    '.......KPPPpK..KPPPqK.......', // 25
    '.......KWWwK...KWWwK........', // 26 shin wraps
    '......KWWwwK...KWWwwK.......', // 27
    '......KWWWwK...KWWWwK.......', // 28
    '......KwwwwK...KwwwwK.......', // 29
  ];

  static const List<String> _legsScholarTunic = [
    '............................', // 00..19
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........KAAALLLAAK..........', // 20
    '........KTTTtAttuK..........', // 21
    '........KTTTtAttuK..........', // 22
    '........KTTtKAKttuK.........', // 23
    '........KTTtK.KTTuK.........', // 24
    '.......KTTtuK.KTTtuK........', // 25
    '.......KAAAK...KAAAK........', // 26 gold robe hem
    '......KPPpqK...KPPpqK.......', // 27
    '......KPPpqK...KPPpqK.......', // 28
    '......KppqqK...KppqqK.......', // 29
  ];

  static const List<String> _legsCrimsonCuisses = [
    '............................', // 00..19
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........KLLlAAllKK..........', // 20
    '........KLLlKAKllbK.........', // 21
    '........KLLlK.KllbK.........', // 22
    '........KllbK.KllbK.........', // 23
    '........KPPpK.KPPqK.........', // 24
    '.......KLLlpK.KLLlqK........', // 25
    '.......KllbqK.KllbqK........', // 26
    '......KPPPpqK...KPPpqK......', // 27
    '......KPPpqqK...KPPpqK......', // 28
    '......KppqqqK...KppqqK......', // 29
  ];

  // ---------------------------------------------------------------------------
  // Layer 3: Boots / Footwear (rows 29..35 — 28x36)
  // ---------------------------------------------------------------------------

  static List<String> _bootsLayer(BootsStyle style) => switch (style) {
        BootsStyle.cuffedMercenaryBoots => _bootsCuffedMercenary,
        BootsStyle.ironSabaton => _bootsIronSabaton,
        BootsStyle.strappedSandals => _bootsStrappedSandals,
        BootsStyle.shadowBoots => _bootsShadow,
        BootsStyle.crimsonGreaves => _bootsCrimsonGreaves,
        BootsStyle.gildedBoots => _bootsGilded,
      };

  /// Exact 2nd-image boots: wide folded brown cuff + dark leather shaft +
  /// rounded toe box with bright golden-brown shine (`A`) + black sole (`K`)!
  static const List<String> _bootsCuffedMercenary = [
    '............................', // 00..28
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.....KKKKKKK...KKKKKK.......', // 29 top of boot cuff
    '.....KLLLLlK...KLLllK.......', // 30 cuff highlight
    '.....KlllbbK...KllbbK.......', // 31 cuff shadow
    '......KllbbK....KllbbK......', // 32 ankle shaft
    '....KKLllbbK....KllbbKK.....', // 33 toe box top
    '....KLAAllbK....KlAAlbK.....', // 34 golden toe highlight
    '....KKKKKKKK....KKKKKKK.....', // 35 sole
  ];

  static const List<String> _bootsIronSabaton = [
    '............................', // 00..28
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.....KKKKKKK...KKKKKK.......', // 29
    '.....KMMMMmK...KMMmmK.......', // 30
    '.....KmmmnnK...KmmnnK.......', // 31
    '......KmmnnK....KmmnnK......', // 32
    '....KKMmmnnK....KmmnnKK.....', // 33
    '....KMWMmnnK....KmWMmnK.....', // 34
    '....KKKKKKKK....KKKKKKK.....', // 35
  ];

  static const List<String> _bootsStrappedSandals = [
    '............................', // 00..28
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '......KWWWWK...KWWWWK.......', // 29 ankle wrap
    '......KllllK...KllllK.......', // 30 leather strap
    '......KWWWWK...KWWWWK.......', // 31
    '......KllllK....KllllK......', // 32
    '.....KSSlllK....KlllSSK.....', // 33 toes + strap
    '.....KbbbbbK....KbbbbbK.....', // 34 sandal sole
    '.....KKKKKKK....KKKKKKK.....', // 35
  ];

  static const List<String> _bootsShadow = [
    '............................', // 00..28
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '......KKKKKK...KKKKKK.......', // 29
    '......KPPPqK...KPPqqK.......', // 30
    '......KppqqK...KppqqK.......', // 31
    '......KppqqK....KppqqK......', // 32
    '....KKPppqqK....KppqqKK.....', // 33
    '....KPPppqqK....KppPPqK.....', // 34
    '....KKKKKKKK....KKKKKKK.....', // 35
  ];

  static const List<String> _bootsCrimsonGreaves = [
    '............................', // 00..28
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.....KKKKKKK...KKKKKK.......', // 29
    '.....KAAAATK...KAAATK.......', // 30
    '.....KTTTtuK...KTTtuK.......', // 31
    '......KttuuK....KttuuK......', // 32
    '....KKTttuuK....KttuuKK.....', // 33
    '....KTAATuuK....KtAATuK.....', // 34
    '....KKKKKKKK....KKKKKKK.....', // 35
  ];

  static const List<String> _bootsGilded = [
    '............................', // 00..28
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.....KKKKKKK...KKKKKK.......', // 29
    '.....KAAAAAK...KAAAAK.......', // 30
    '.....KLLLLlK...KLLllK.......', // 31
    '......KllbbK....KllbbK......', // 32
    '....KKAllbbK....KllbbAK.....', // 33
    '....KAAAllbK....KlAAAbK.....', // 34
    '....KKKKKKKK....KKKKKKK.....', // 35
  ];

  // ---------------------------------------------------------------------------
  // Layer 4: Torso / Shirt / Chest Armor (rows 13..23 — 28x36)
  // ---------------------------------------------------------------------------

  static List<String> _torsoIdleLayer(TorsoStyle style) => switch (style) {
        TorsoStyle.mercenaryArmor => _torsoMercenaryIdle,
        TorsoStyle.trainingTunic => _torsoTrainingIdle,
        TorsoStyle.bareChestWraps => _torsoBareChestIdle,
        TorsoStyle.crimsonBrigandine => _torsoBrigandineIdle,
        TorsoStyle.arcaneRobes => _torsoArcaneIdle,
        TorsoStyle.royalPlate => _torsoRoyalPlateIdle,
      };

  static List<String> _torsoFlexLayer(TorsoStyle style) => switch (style) {
        TorsoStyle.bareChestWraps => _torsoBareChestFlex,
        _ => _torsoMercenaryFlex,
      };

  /// Exact 2nd-image torso: dark collar scarf + layered steel pauldrons with
  /// shine + sculpted breastplate with diagonal brown leather strap (`L`/`l`) +
  /// white bandaged right fist (`W`/`w`) + dark iron left gauntlet (`M`/`m`/`n`)!
  static const List<String> _torsoMercenaryIdle = [
    '............................', // 00..12
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........KKKqqqqqKKK.........', // 13 dark neck scarf
    '.....KKKTTtqqqqqTTtKKK......', // 14 top of pauldrons + scarf
    '....KTTTTtuKLtttTTTTtuK.....', // 15 pauldrons + chestplate + strap start
    '...KuuuuuuKTLWWTtuuuuuuK....', // 16 pauldron rim + chest shine + strap
    '....KKKKKK.KtLLttu.KKKKK....', // 17 chest strap diagonal
    '...........KttLLtu..........', // 18
    '...........KuttLLuKmmK......', // 19 iron gauntlet start on right arm
    '....KWWw...KuuutLLKMmnK.....', // 20 white hand wrap on left + iron gauntlet
    '....KWWw...KKKKKKK.KMmnK....', // 21
    '....KwwS...........KmnnK....', // 22
    '.....KKK............KKKK....', // 23
  ];

  static const List<String> _torsoTrainingIdle = [
    '............................', // 00..12
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.........KKsdddKK...........', // 13 open collar
    '.......KKTTsdddTTKK.........', // 14 sleeveless tunic shoulders
    '......K..KTTssTTK..K........', // 15 V-neck chest
    '.........KTTTTtuK...........', // 16
    '.........KTTTttuK...........', // 17
    '.........KTTttuuK...........', // 18
    '.........KttuuuuK...........', // 19
    '....KLLl.KAAALLAK..KlLK.....', // 20 leather wrist bracers
    '....Kllb.KKKKKKKK..KbllK....', // 21
  ];

  static const List<String> _torsoBareChestIdle = [
    '............................', // 00..12
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................', // 13 bare neck
    '.........KLsssssK...........', // 14 barbarian leather harness
    '.........KsLsssRss..........', // 15 chest scar (`R`) + strap
    '.........KddLssddK..........', // 16 pec shadow
    '.........KsssLsdsK..........', // 17 abs
    '.........KsdssLdsK..........', // 18 abs
    '....KWWw.KsddssddK.KwWWK....', // 19 wrist wraps
    '....Kwwd.KKKKKKKK..KdwwK....', // 20
  ];

  static const List<String> _torsoBrigandineIdle = [
    '............................', // 00..12
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........KKKqqqqqKKK.........', // 13 high rogue collar
    '.....KKKLLLqqqqqLLLKKK......', // 14 leather pauldrons
    '....KLLLLlbKTTTTLLLLlbK.....', // 15 studded brigandine
    '....KbbbbbbKTATtbbbbbbK.....', // 16 gold studs (`A`)
    '....KqqqqK.KTTttu.KqqqK.....', // 17 dark sleeves
    '....KqqqK..KTATtu..KqqK.....', // 18
    '....KLLlK..Ktttuu..KlLK.....', // 19
    '....KllbK..Kuuuuu..KblK.....', // 20
    '....KqqqK..KKKKKK..KqqK.....', // 21
  ];

  static const List<String> _torsoArcaneIdle = [
    '............................', // 00..12
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.......KKAAqqqqqAAKK........', // 13 high arcane gold-trimmed collar
    '.....KKATTTAqqqATTTAKK......', // 14
    '....KATTTtuKAAAKTTTtuAK.....', // 15 runic mantle
    '....KTTttuuKTTTtTTttuuK.....', // 16
    '....KTTtuK.KTAATu.KTTuK.....', // 17 wide robe sleeves
    '....KTTtuK.KTTTtu.KTTuK.....', // 18
    '....KAAAK..KTAATu..KAAK.....', // 19 gold cuffs
    '...........Ktttuu...........', // 20
  ];

  static const List<String> _torsoRoyalPlateIdle = [
    '............................', // 00..12
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........KKKAAAAAKKK.........', // 13 gilded gorget
    '....KKKKATTTAAATTTTKKKK.....', // 14 heavy knight pauldrons
    '...KAAATTTTtAAATTTTtuAAK....', // 15
    '...KuuuuuuuKTWWTtuuuuuuK....', // 16
    '....KKKKKK.KTAAtu.KKKKKK....', // 17 golden crest on breastplate
    '....KMMmK..KTTTtu..KmMMK....', // 18 full steel arm plates
    '....KmmnK..KTAATu..KnmMK....', // 19
    '....KAAAK..Kuuuuu..KAAAK....', // 20 gilded gauntlets
    '....KmmnK..KKKKKK..KnmMK....', // 21
  ];

  static const List<String> _torsoMercenaryFlex = [
    '............................', // 00..12
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '..KWWK..KKKqqqqqKKK..KMMK...', // 13 raised fists!
    '..KwwKKKKTTtqqqqTTtKKKKmnK..', // 14
    '........KTTTtuLTTTTu........', // 15
    '........KTTtLLWWTttu........', // 16
    '........KKKKtLLttuKK........', // 17
    '........KTTTTtLLtuuK........', // 18
    '........KuttutLLuuuK........', // 19
  ];

  static const List<String> _torsoBareChestFlex = [
    '............................', // 00..12
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '..KWWK...KKsdddKK...KWWK....', // 13 raised wrapped fists
    '.........KLsssssK...........', // 14
    '.........KsLsssRss..........', // 15
    '.........KddLssddK..........', // 16
    '.........KsssLsdsK..........', // 17
    '.........KsdssLdsK..........', // 18
    '.........KsddssddK..........', // 19
  ];

  // ---------------------------------------------------------------------------
  // Layer 5: Eyes & Facial Expression (rows 8..12 — 28x36)
  // ---------------------------------------------------------------------------

  static List<String> _eyesLayer(EyeStyle style) => switch (style) {
        EyeStyle.scarredOneEye => _eyesScarredOneEye,
        EyeStyle.determined => _eyesDetermined,
        EyeStyle.focused => _eyesFocused,
        EyeStyle.glowing => _eyesGlowing,
        EyeStyle.serene => _eyesSerene,
      };

  /// 2nd image face: fierce dark brow, white sclera + iris on viewer's left,
  /// closed/scarred right eye (`d`/`K`), and determined mouth!
  static const List<String> _eyesScarredOneEye = [
    '............................', // 00..07
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.........KKKK.dKK...........', // 08 brow + top of scar
    '.........KWWEsKKs...........', // 09 open left eye (`WWE`) + closed right eye (`KK`)
    '.........KSSssdss...........', // 10 lower scar (`d`)
    '............ssKK............', // 11 mouth (`KK`)
  ];

  static const List<String> _eyesDetermined = [
    '............................', // 00..07
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.........KKKK.KKKK..........', // 08 fierce brows
    '.........KWWEsKWWK..........', // 09 both eyes open
    '.........KSSsssss...........', // 10
    '............ssKK............', // 11 mouth
  ];

  static const List<String> _eyesFocused = [
    '............................', // 00..07
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.........KKKKKKKK...........', // 08 low tactical brow
    '.........KWEssKWE...........', // 09 narrowed eyes
    '.........KSSsssss...........', // 10
    '............ssKK............', // 11
  ];

  static const List<String> _eyesGlowing = [
    '............................', // 00..07
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.........KKKK.KKKK..........', // 08
    '.........KEWEsKEWK..........', // 09 glowing eyes
    '.........KESssSEs...........', // 10 subtle eye glow
    '............ssKK............', // 11
  ];

  static const List<String> _eyesSerene = [
    '............................', // 00..07
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................', // 08
    '.........KKKK.KKKK..........', // 09 calm closed/meditative eyes
    '.........KSSsssss...........', // 10
    '............ssKK............', // 11
  ];

  // ---------------------------------------------------------------------------
  // Layer 6: Beard / Facial Hair (rows 10..15 — 28x36)
  // ---------------------------------------------------------------------------

  static List<String> _beardLayer(BeardStyle style) => switch (style) {
        BeardStyle.none => const [],
        BeardStyle.stubble => _beardStubble,
        BeardStyle.shortBeard => _beardShort,
        BeardStyle.warlordBeard => _beardWarlord,
        BeardStyle.goatee => _beardGoatee,
      };

  static const List<String> _beardStubble = [
    '............................', // 00..10
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.........j..KK..j...........', // 11 jaw stubble
    '.........KjjjjjjK...........', // 12
  ];

  static const List<String> _beardShort = [
    '............................', // 00..09
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........Kh..hh..hK..........', // 10 sideburns + mustache
    '........KhhhjKKjhK..........', // 11
    '.........KhhhhhhK...........', // 12
    '..........KjjjjK............', // 13
  ];

  static const List<String> _beardWarlord = [
    '............................', // 00..09
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........Khh.hh.hhK..........', // 10
    '........KhhhhKKhhK..........', // 11
    '........KHhhhhhhhK..........', // 12
    '.........KhhhhhhK...........', // 13
    '.........KjjhhjjK...........', // 14 long braided beard over chest
    '..........KKjjKK............', // 15
  ];

  static const List<String> _beardGoatee = [
    '............................', // 00..10
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '...........hKKh.............', // 11
    '...........KhhK.............', // 12
    '...........KjjK.............', // 13
  ];

  // ---------------------------------------------------------------------------
  // Layer 7: Hair / Headgear (rows 0..13 — 28x36)
  // ---------------------------------------------------------------------------

  static List<String> _hairLayer(HairStyle style) => switch (style) {
        HairStyle.spikyBerserk => _hairSpikyBerserk,
        HairStyle.spikyWhiteStreak => _hairSpikyWhiteStreak,
        HairStyle.shortCrop => _hairShortCrop,
        HairStyle.longFlowing => _hairLongFlowing,
        HairStyle.topknot => _hairTopknot,
        HairStyle.hooded => _hairHooded,
        HairStyle.ironHelm => _hairIronHelm,
        HairStyle.bald => const [],
      };

  /// Exact 2nd-image spiky Guts hair with jagged crown spikes & sideburns!
  static const List<String> _hairSpikyBerserk = [
    '............................', // 00
    '..........KK.KK.KK..........', // 01 crown spikes
    '........KKHhKHhKHhKK........', // 02
    '.......KHHhhhhhhhhhHK.......', // 03
    '......KHHhhhhjjhhhhhHK......', // 04
    '......KhhhhjjjjjjhhhhK......', // 05
    '.....KKhjjjKhjjhKjjjhhK.....', // 06 forehead spikes
    '......KjjK..KjjK..KjjK......', // 07 bangs over brow
    '.......KK..........KK.......', // 08
    '.......K............K.......', // 09
  ];

  /// Spiky warrior hair with the iconic white streak (`W`/`w`) on the front!
  static const List<String> _hairSpikyWhiteStreak = [
    '............................', // 00
    '..........KK.KK.KK..........', // 01
    '........KKHhKHhKHhKK........', // 02
    '.......KHHWWWhhhhhhHK.......', // 03
    '......KHHWwwhjjhhhhhHK......', // 04
    '......KhhWWwjjjjjhhhhK......', // 05
    '.....KKhjWWKhjjhKjjjhhK.....', // 06 white streak bang
    '......KjjK..KjjK..KjjK......', // 07
    '.......KK..........KK.......', // 08
  ];

  static const List<String> _hairShortCrop = [
    '............................', // 00
    '............................', // 01
    '.........KKKKKKKK...........', // 02
    '........KHHHhhhhhK..........', // 03
    '.......KHHhhhhjjhhK.........', // 04
    '.......KhhhhjjjjjhK.........', // 05
    '.......KjjK....KjjK.........', // 06
  ];

  static const List<String> _hairLongFlowing = [
    '............................', // 00
    '............................', // 01
    '.........KKKKKKKK...........', // 02
    '........KHHHhhhhhK..........', // 03
    '.......KHHhhhhjjhhK.........', // 04
    '......KHhhhjjjjjjhhK........', // 05
    '......KhjjK....KjjhK........', // 06
    '......KhjK......KjhK........', // 07
    '......Khj........jhK........', // 08
    '......Khj........jhK........', // 09
    '.....Khhj........jhhK.......', // 10 locks flowing over shoulders
    '.....Khjj........jjhK.......', // 11
    '.....KjjK........KjjK.......', // 12
    '......KK..........KK........', // 13
  ];

  static const List<String> _hairTopknot = [
    '...........KKKK.............', // 00 topknot bun
    '..........KHHhhK............', // 01
    '..........KAAjjK............', // 02 gold hair tie
    '.........KKKKKKKK...........', // 03
    '........KHHHhhhhhK..........', // 04
    '.......KhhhhjjjjjhK.........', // 05
    '.......KjjK....KjjK.........', // 06
  ];

  static const List<String> _hairHooded = [
    '............................', // 00
    '..........KKKKKK............', // 01 hood peak
    '........KKCCCCCCKK..........', // 02
    '.......KCCCcccccccK.........', // 03
    '......KCCccccvvccccK........', // 04
    '......KccvvvvKKKKvvcK.......', // 05
    '......KcvK..KKKK..KvcK......', // 06 hood shadow over brow
    '......KcvK........KvcK......', // 07
    '......Kcv..........vcK......', // 08
    '......Kcv..........vcK......', // 09
    '......Kcv..........vcK......', // 10
    '......KcvK........KvcK......', // 11
    '.......KcvKKKKKKKKvcK.......', // 12 hood cowling at neck
    '........KKKKKKKKKKKK........', // 13
  ];

  static const List<String> _hairIronHelm = [
    '............................', // 00
    '...........KKKK.............', // 01 helm crest
    '.........KKAAAAKK...........', // 02
    '........KMMMAAMMMK..........', // 03
    '.......KMMMMAAmmmmK.........', // 04
    '.......KmmmmAAmmmmK.........', // 05
    '......KMmnnKKKKnnmMK........', // 06 visor brow
    '......KmnK......KnmK........', // 07 cheek guards
    '......KmnK..AA..KnmK........', // 08 nasal guard
    '......KmnK......KnmK........', // 09
    '......KmnK......KnmK........', // 10
    '.......KmnK....KnmK.........', // 11
    '........KKK....KKK..........', // 12
  ];

  // ---------------------------------------------------------------------------
  // Layer 8: Weapon / Combat Action Foreground Layer (28x36)
  // ---------------------------------------------------------------------------

  static List<String> _weaponPoseForegroundLayer(HeroPose pose) => switch (pose) {
        HeroPose.idle || HeroPose.flex => const [],
        HeroPose.attackGreatsword => _weaponGreatswordSwing,
        HeroPose.attackStaff => _weaponStaffCast,
        HeroPose.attackDaggers => _weaponDaggersSlash,
        HeroPose.attackBow => _weaponBowDraw,
        HeroPose.attackMartial => _weaponMartialStrike,
        HeroPose.attackHolyBlade => _weaponHolyBladeSwing,
        HeroPose.guard => _weaponShieldGuard,
      };

  /// Colossal greatsword swung forward horizontally across the right side!
  static const List<String> _weaponGreatswordSwing = [
    '............................', // 00..13
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '...................KK.......', // 14 crossguard top
    '..................KAAK......', // 15
    '...............KKKKAAMKKKKK.', // 16 colossal blade top edge (`W` shine)
    '..............KLLlKAAMWWWWWK', // 17 hilt + gauntleted grip + bright edge
    '..............KSSsKAAMmmmmWK', // 18 blade fuller
    '...............KKKKAAnnnnnK.', // 19 blade dark edge
    '..................KAAKKKKK..', // 20 crossguard bottom
    '...................KK.......', // 21
  ];

  /// Runic quarterstaff held upright in the outstretched right hand with a
  /// glowing arcane crystal orb (`E`/`W`/`A`) at the crown!
  static const List<String> _weaponStaffCast = [
    '............................', // 00..05
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.....................EEE....', // 06 arcane energy sparks
    '....................EWWWE...', // 07 glowing crystal orb
    '....................EWWWE...', // 08
    '....................KAAAK...', // 09 golden staff cradle
    '.....................KLlK...', // 10 wooden shaft
    '.....................KLlK...', // 11
    '.....................KLlK...', // 12
    '.....................KLlK...', // 13
    '.....................KLlK...', // 14
    '.....................KLlK...', // 15
    '................KKKKKKLlK...', // 16 outstretched casting arm
    '...............KSSSSSKSSK...', // 17 hand gripping staff
    '................KKKKKKLlK...', // 18
    '.....................KLlK...', // 19
    '.....................KLlK...', // 20
    '.....................KLlK...', // 21
    '.....................KLlK...', // 22
    '.....................KAAK...', // 23 staff butt-cap
    '.....................KKKK...', // 24
  ];

  /// Twin rogue daggers brandished forward with gleaming silver blades!
  static const List<String> _weaponDaggersSlash = [
    '............................', // 00..13
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.......................KKK..', // 14 upper dagger tip
    '.....................KKMWWK.', // 15
    '.................KKKKAMmmK..', // 16 right hand + upper dagger
    '................KSSSSAKKK...', // 17
    '..KKKK...........KKKK.......', // 18 left off-hand dagger
    '.KWWWMK.............KKKKKK..', // 19 lower forward dagger slash
    '..KKKK.............KAAWWWWK.', // 20
    '....................KKKKKK..', // 21
  ];

  /// Curved hunter longbow drawn with a glowing notched arrow!
  static const List<String> _weaponBowDraw = [
    '............................', // 00..10
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '....................KKK.....', // 11 upper bow limb
    '...................KwKLK....', // 12 bowstring + wood
    '...................Kw.KLK...', // 13
    '...................Kw..KLK..', // 14
    '...................Kw...KLK.', // 15
    '...............KKKKKWWWWWWAK', // 16 drawn arrow + glowing arrowhead!
    '...............KSSSSSSSKAAK.', // 17 outstretched bow hand
    '...................Kw...KLK.', // 18
    '...................Kw..KLK..', // 19
    '...................Kw.KLK...', // 20
    '...................KwKLK....', // 21
    '....................KKK.....', // 22 lower bow limb
  ];

  /// Monk martial arts Ki palm thrust with golden/emerald aura!
  static const List<String> _weaponMartialStrike = [
    '............................', // 00..13
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '......................AA....', // 14 Ki aura
    '.....................AWWA...', // 15
    '...............KKKKKAWWWWAK.', // 16 thrusting wrapped fist + Ki burst
    '..............KWWWWWSSSSWWAK', // 17
    '...............KKKKKAWWWWAK.', // 18
    '.....................AWWA...', // 19
    '......................AA....', // 20
  ];

  /// Radiant holy broadsword / runic blade raised in a golden slash!
  static const List<String> _weaponHolyBladeSwing = [
    '............................', // 00..09
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '........................AA..', // 10 holy blade tip
    '.......................AWWA.', // 11
    '......................KWWWAK', // 12
    '.....................KWWMWK.', // 13
    '....................KWWMMK..', // 14
    '..................KKAWWMK...', // 15
    '................KKAAAKKK....', // 16 golden crossguard
    '...............KSSSSAK......', // 17 hand on hilt
    '................KKKKK.......', // 18
  ];

  /// Forged iron & golden buckler shield raised in defensive brace!
  static const List<String> _weaponShieldGuard = [
    '............................', // 00..12
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '............................',
    '.................KKKKKK.....', // 13 shield top rim
    '................KAAAAAAMK...', // 14
    '...............KAMMMMMMmAK..', // 15
    '...............KAMMWWWmmAK..', // 16 shield boss shine
    '...............KAMMWWWmmAK..', // 17
    '...............KAMmmmnnnAK..', // 18
    '...............KAMmnnnnnAK..', // 19
    '................KAAAAAAAK...', // 20
    '.................KKKKKKK....', // 21 shield bottom point
  ];

  // ---------------------------------------------------------------------------
  // Layer 9: Equipped Combat Cosmetic Aura / Floating Crest (28x36)
  // ---------------------------------------------------------------------------

  static const List<String> _cosmeticAuraLayer = [
    '....G.................G.....', // 00 ember sparks around the hero
    '...GWG...............GWG....', // 01
    '....G.................G.....', // 02
    '............................', // 03
    '............................', // 04
    '..G.........................', // 05
    '..........................G.', // 06
    '............................', // 07
    '............................', // 08
    '............................', // 09
    '.G..........................', // 10
    '............................', // 11
    '...........................G', // 12
    '............................', // 13
    '............................', // 14
    '............................', // 15
    '..G.........................', // 16
    '............................', // 17
  ];
}

/// Renders a 28x36 16-bit sprite for an Arena NPC, Tournament Champion, or
/// Dungeon Boss based on its [opponentId].
class OpponentAvatar extends StatelessWidget {
  const OpponentAvatar({
    super.key,
    required this.opponentId,
    this.pose = HeroPose.idle,
    this.pixelSize = 3.0,
    this.flipHorizontal = false,
    this.hitFlashColor,
  });

  final String opponentId;
  final HeroPose pose;
  final double pixelSize;
  final bool flipHorizontal;
  final Color? hitFlashColor;

  @override
  Widget build(BuildContext context) {
    final appearance = OpponentSprites.forOpponent(opponentId);
    final composed = HeroPaperDoll.compose(
      appearance,
      equippedCosmeticId: opponentId,
      pose: pose,
    );
    return PixelSprite(
      rows: composed.rows,
      palette: composed.palette,
      pixelSize: pixelSize,
      flipHorizontal: flipHorizontal,
      hitFlashColor: hitFlashColor,
    );
  }
}

/// Maps Arena NPCs, Tournament Champions, and Dungeon Bosses to distinct
/// 16-bit appearances so every battle shows a visual adversary.
abstract final class OpponentSprites {
  static HeroAppearance forOpponent(String id) {
    if (id.contains('recruit') || id.contains('ash')) {
      return const HeroAppearance(
        skinTone: SkinTone.pale,
        eyeStyle: EyeStyle.focused,
        eyeColor: EyeColor.ashGrey,
        hairStyle: HairStyle.shortCrop,
        hairColor: HairColor.ashenGrey,
        beardStyle: BeardStyle.stubble,
        torsoStyle: TorsoStyle.trainingTunic,
        legsStyle: LegsStyle.trainingPants,
        bootsStyle: BootsStyle.strappedSandals,
        backStyle: BackStyle.tatteredCloak,
        outfitTint: OutfitTint.obsidianShadow,
      );
    }
    if (id.contains('sentinel') || id.contains('iron') || id.contains('golem')) {
      return const HeroAppearance(
        skinTone: SkinTone.bronze,
        eyeStyle: EyeStyle.glowing,
        eyeColor: EyeColor.amber,
        hairStyle: HairStyle.ironHelm,
        hairColor: HairColor.ravenBlack,
        beardStyle: BeardStyle.none,
        torsoStyle: TorsoStyle.royalPlate,
        legsStyle: LegsStyle.platedGreaves,
        bootsStyle: BootsStyle.ironSabaton,
        backStyle: BackStyle.paladinWingedMantle,
        outfitTint: OutfitTint.ironAndLeather,
      );
    }
    if (id.contains('shadow') || id.contains('stalker') || id.contains('assassin')) {
      return HeroAppearance.fromPreset(HeroAppearancePreset.shadowRogue);
    }
    if (id.contains('inquisitor') || id.contains('archon') || id.contains('lich')) {
      return const HeroAppearance(
        skinTone: SkinTone.pale,
        eyeStyle: EyeStyle.glowing,
        eyeColor: EyeColor.arcaneBlue,
        hairStyle: HairStyle.hooded,
        hairColor: HairColor.silverWhite,
        beardStyle: BeardStyle.warlordBeard,
        torsoStyle: TorsoStyle.arcaneRobes,
        legsStyle: LegsStyle.scholarTunic,
        bootsStyle: BootsStyle.gildedBoots,
        backStyle: BackStyle.runicStaffCape,
        outfitTint: OutfitTint.arcaneTwilight,
      );
    }
    if (id.contains('berserker') || id.contains('executioner') || id.contains('colossus')) {
      return const HeroAppearance(
        skinTone: SkinTone.bronze,
        eyeStyle: EyeStyle.scarredOneEye,
        eyeColor: EyeColor.crimson,
        hairStyle: HairStyle.spikyWhiteStreak,
        hairColor: HairColor.ravenBlack,
        beardStyle: BeardStyle.warlordBeard,
        torsoStyle: TorsoStyle.bareChestWraps,
        legsStyle: LegsStyle.crimsonCuisses,
        bootsStyle: BootsStyle.crimsonGreaves,
        backStyle: BackStyle.dragonslayerCape,
        outfitTint: OutfitTint.crimsonWar,
      );
    }
    // Sovereign / Boss / Default
    return const HeroAppearance(
      skinTone: SkinTone.ebony,
      eyeStyle: EyeStyle.glowing,
      eyeColor: EyeColor.crimson,
      hairStyle: HairStyle.ironHelm,
      hairColor: HairColor.emberRed,
      beardStyle: BeardStyle.none,
      torsoStyle: TorsoStyle.royalPlate,
      legsStyle: LegsStyle.platedGreaves,
      bootsStyle: BootsStyle.gildedBoots,
      backStyle: BackStyle.dragonslayerCape,
      outfitTint: OutfitTint.crimsonWar,
    );
  }
}

/// Legacy static sprites kept for backward compatibility; delegates to the
/// default 28x36 Black Swordsman Paper-Doll composition.
abstract final class HeroSprites {
  static final Map<String, Color> palette = HeroPaperDoll.buildPalette(
    HeroAppearance.defaultAppearance,
  );

  static final List<String> idle = HeroPaperDoll.compose(
    HeroAppearance.defaultAppearance,
    pose: HeroPose.idle,
  ).rows;

  static final List<String> flex = HeroPaperDoll.compose(
    HeroAppearance.defaultAppearance,
    pose: HeroPose.flex,
  ).rows;
}
