import 'package:material_ui/material_ui.dart';

import '../../core/game/hero_appearance.dart';
import 'paper_doll/chibi_layers.g.dart';

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
  ///
  /// Layers come from `paper_doll/chibi_layers.g.dart`, generated by
  /// `tool/art/chibi_gen.py` (chibi style approved Nov/2026). Edit the
  /// generator — not the generated file — to change the art.
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

    void applyLayer(String key) {
      final layer = chibiLayers[key] ?? const <String>[];
      final maxY = layer.length < height ? layer.length : height;
      for (var y = 0; y < maxY; y++) {
        final row = layer[y];
        final maxX = row.length < width ? row.length : width;
        for (var x = 0; x < maxX; x++) {
          final ch = row[x];
          if (ch != '.' && ch != ' ') grid[y][x] = ch;
        }
      }
    }

    final weapon = _weaponFor(pose);
    final bodyPose = pose == HeroPose.flex ? 'flex' : 'idle';
    // With a weapon drawn, the back keeps only a plain cloak.
    final back = weapon != null && appearance.backStyle != BackStyle.none
        ? 'tatteredCloak'
        : appearance.backStyle.name;

    applyLayer(weapon != null && back == 'tatteredCloak' ? 'back.drawnCloak' : 'back.$back'); // 0. back gear
    applyLayer('body.$bodyPose'); // 1. skin anatomy
    applyLayer('legs.${appearance.legsStyle.name}'); // 2. pants
    applyLayer('boots.${appearance.bootsStyle.name}'); // 3. footwear
    applyLayer('torso.${appearance.torsoStyle.name}.$bodyPose'); // 4. armor / shirt
    applyLayer('backFront.$back'); // 5. cloak wrapping the shoulders
    applyLayer('eyes.${appearance.eyeStyle.name}'); // 6. eyes
    applyLayer('beard.${appearance.beardStyle.name}'); // 7. facial hair
    applyLayer('hair.${appearance.hairStyle.name}'); // 8. hair / hood / helm
    if (weapon != null) applyLayer('weapon.$weapon'); // 9. weapon in hand
    if (equippedCosmeticId != null && equippedCosmeticId.isNotEmpty) {
      applyLayer('aura'); // 10. cosmetic sparks
    }

    return ComposedSprite(
      rows: [for (final r in grid) r.join()],
      palette: buildPalette(appearance, equippedCosmeticId: equippedCosmeticId),
    );
  }

  static String? _weaponFor(HeroPose pose) => switch (pose) {
        HeroPose.idle || HeroPose.flex => null,
        HeroPose.attackGreatsword => 'greatsword',
        HeroPose.attackStaff => 'staff',
        HeroPose.attackDaggers => 'daggers',
        HeroPose.attackBow => 'bow',
        HeroPose.attackMartial => 'martial',
        HeroPose.attackHolyBlade => 'holyBlade',
        HeroPose.guard => 'shield',
      };
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
    if (id.startsWith('boss_')) {
      return _legendaryAppearance(id);
    }
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

  static HeroAppearance _legendaryAppearance(String id) => switch (id) {
        'boss_satorion' => const HeroAppearance(
            skinTone: SkinTone.fair,
            eyeStyle: EyeStyle.glowing,
            eyeColor: EyeColor.arcaneBlue,
            hairStyle: HairStyle.spikyBerserk,
            hairColor: HairColor.silverWhite,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.arcaneRobes,
            legsStyle: LegsStyle.scholarTunic,
            bootsStyle: BootsStyle.shadowBoots,
            backStyle: BackStyle.none,
            outfitTint: OutfitTint.arcaneTwilight,
          ),
        'boss_ryomoth' => const HeroAppearance(
            skinTone: SkinTone.pale,
            eyeStyle: EyeStyle.determined,
            eyeColor: EyeColor.crimson,
            hairStyle: HairStyle.spikyWhiteStreak,
            hairColor: HairColor.emberRed,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.bareChestWraps,
            legsStyle: LegsStyle.monkWraps,
            bootsStyle: BootsStyle.strappedSandals,
            backStyle: BackStyle.twinDaggersCloak,
            outfitTint: OutfitTint.crimsonWar,
          ),
        'boss_gonnir' => const HeroAppearance(
            skinTone: SkinTone.warm,
            eyeStyle: EyeStyle.determined,
            eyeColor: EyeColor.emerald,
            hairStyle: HairStyle.spikyBerserk,
            hairColor: HairColor.ravenBlack,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.trainingTunic,
            legsStyle: LegsStyle.trainingPants,
            bootsStyle: BootsStyle.strappedSandals,
            backStyle: BackStyle.none,
            outfitTint: OutfitTint.forestRanger,
          ),
        'boss_netherion' => const HeroAppearance(
            skinTone: SkinTone.warm,
            eyeStyle: EyeStyle.serene,
            eyeColor: EyeColor.amber,
            hairStyle: HairStyle.topknot,
            hairColor: HairColor.silverWhite,
            beardStyle: BeardStyle.warlordBeard,
            torsoStyle: TorsoStyle.bareChestWraps,
            legsStyle: LegsStyle.monkWraps,
            bootsStyle: BootsStyle.strappedSandals,
            backStyle: BackStyle.none,
            outfitTint: OutfitTint.emberGold,
          ),
        'boss_meruvor' => const HeroAppearance(
            skinTone: SkinTone.olive,
            eyeStyle: EyeStyle.focused,
            eyeColor: EyeColor.crimson,
            hairStyle: HairStyle.ironHelm,
            hairColor: HairColor.ashenGrey,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.crimsonBrigandine,
            legsStyle: LegsStyle.platedGreaves,
            bootsStyle: BootsStyle.shadowBoots,
            backStyle: BackStyle.tatteredCloak,
            outfitTint: OutfitTint.forestRanger,
          ),
        'boss_kakarion' => const HeroAppearance(
            skinTone: SkinTone.warm,
            eyeStyle: EyeStyle.determined,
            eyeColor: EyeColor.obsidian,
            hairStyle: HairStyle.spikyBerserk,
            hairColor: HairColor.ravenBlack,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.trainingTunic,
            legsStyle: LegsStyle.monkWraps,
            bootsStyle: BootsStyle.strappedSandals,
            backStyle: BackStyle.none,
            outfitTint: OutfitTint.emberGold,
          ),
        'boss_toshirion' => const HeroAppearance(
            skinTone: SkinTone.fair,
            eyeStyle: EyeStyle.determined,
            eyeColor: EyeColor.arcaneBlue,
            hairStyle: HairStyle.spikyBerserk,
            hairColor: HairColor.goldenBlonde,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.crimsonBrigandine,
            legsStyle: LegsStyle.darkBreeches,
            bootsStyle: BootsStyle.gildedBoots,
            backStyle: BackStyle.tatteredCloak,
            outfitTint: OutfitTint.emberGold,
          ),
        'boss_aforion' => const HeroAppearance(
            skinTone: SkinTone.pale,
            eyeStyle: EyeStyle.glowing,
            eyeColor: EyeColor.crimson,
            hairStyle: HairStyle.ironHelm,
            hairColor: HairColor.ravenBlack,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.royalPlate,
            legsStyle: LegsStyle.darkBreeches,
            bootsStyle: BootsStyle.shadowBoots,
            backStyle: BackStyle.runicStaffCape,
            outfitTint: OutfitTint.obsidianShadow,
          ),
        'boss_vadric' => const HeroAppearance(
            skinTone: SkinTone.ebony,
            eyeStyle: EyeStyle.glowing,
            eyeColor: EyeColor.crimson,
            hairStyle: HairStyle.ironHelm,
            hairColor: HairColor.ravenBlack,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.royalPlate,
            legsStyle: LegsStyle.platedGreaves,
            bootsStyle: BootsStyle.ironSabaton,
            backStyle: BackStyle.tatteredCloak,
            outfitTint: OutfitTint.obsidianShadow,
          ),
        'boss_vegor' => const HeroAppearance(
            skinTone: SkinTone.fair,
            eyeStyle: EyeStyle.focused,
            eyeColor: EyeColor.obsidian,
            hairStyle: HairStyle.spikyBerserk,
            hairColor: HairColor.ravenBlack,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.mercenaryArmor,
            legsStyle: LegsStyle.trainingPants,
            bootsStyle: BootsStyle.gildedBoots,
            backStyle: BackStyle.none,
            outfitTint: OutfitTint.arcaneTwilight,
          ),
        'boss_naruval' => const HeroAppearance(
            skinTone: SkinTone.warm,
            eyeStyle: EyeStyle.determined,
            eyeColor: EyeColor.arcaneBlue,
            hairStyle: HairStyle.spikyBerserk,
            hairColor: HairColor.goldenBlonde,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.trainingTunic,
            legsStyle: LegsStyle.trainingPants,
            bootsStyle: BootsStyle.strappedSandals,
            backStyle: BackStyle.tatteredCloak,
            outfitTint: OutfitTint.emberGold,
          ),
        'boss_sasukar' => const HeroAppearance(
            skinTone: SkinTone.fair,
            eyeStyle: EyeStyle.focused,
            eyeColor: EyeColor.crimson,
            hairStyle: HairStyle.longFlowing,
            hairColor: HairColor.ravenBlack,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.arcaneRobes,
            legsStyle: LegsStyle.monkWraps,
            bootsStyle: BootsStyle.shadowBoots,
            backStyle: BackStyle.twinDaggersCloak,
            outfitTint: OutfitTint.arcaneTwilight,
          ),
        'boss_arthorius' => const HeroAppearance(
            skinTone: SkinTone.pale,
            eyeStyle: EyeStyle.glowing,
            eyeColor: EyeColor.arcaneBlue,
            hairStyle: HairStyle.ironHelm,
            hairColor: HairColor.silverWhite,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.royalPlate,
            legsStyle: LegsStyle.platedGreaves,
            bootsStyle: BootsStyle.ironSabaton,
            backStyle: BackStyle.paladinWingedMantle,
            outfitTint: OutfitTint.ironAndLeather,
          ),
        'boss_gerric' => const HeroAppearance(
            skinTone: SkinTone.pale,
            eyeStyle: EyeStyle.scarredOneEye,
            eyeColor: EyeColor.amber,
            hairStyle: HairStyle.longFlowing,
            hairColor: HairColor.silverWhite,
            beardStyle: BeardStyle.shortBeard,
            torsoStyle: TorsoStyle.mercenaryArmor,
            legsStyle: LegsStyle.darkBreeches,
            bootsStyle: BootsStyle.cuffedMercenaryBoots,
            backStyle: BackStyle.dragonslayerCape,
            outfitTint: OutfitTint.ironAndLeather,
          ),
        'boss_kaibaron' => const HeroAppearance(
            skinTone: SkinTone.fair,
            eyeStyle: EyeStyle.focused,
            eyeColor: EyeColor.arcaneBlue,
            hairStyle: HairStyle.shortCrop,
            hairColor: HairColor.darkBrown,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.arcaneRobes,
            legsStyle: LegsStyle.darkBreeches,
            bootsStyle: BootsStyle.cuffedMercenaryBoots,
            backStyle: BackStyle.runicStaffCape,
            outfitTint: OutfitTint.obsidianShadow,
          ),
        'boss_saurath' => const HeroAppearance(
            skinTone: SkinTone.ebony,
            eyeStyle: EyeStyle.glowing,
            eyeColor: EyeColor.amber,
            hairStyle: HairStyle.ironHelm,
            hairColor: HairColor.ravenBlack,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.royalPlate,
            legsStyle: LegsStyle.platedGreaves,
            bootsStyle: BootsStyle.ironSabaton,
            backStyle: BackStyle.dragonslayerCape,
            outfitTint: OutfitTint.crimsonWar,
          ),
        'boss_erendir' => const HeroAppearance(
            skinTone: SkinTone.fair,
            eyeStyle: EyeStyle.determined,
            eyeColor: EyeColor.emerald,
            hairStyle: HairStyle.longFlowing,
            hairColor: HairColor.darkBrown,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.bareChestWraps,
            legsStyle: LegsStyle.crimsonCuisses,
            bootsStyle: BootsStyle.cuffedMercenaryBoots,
            backStyle: BackStyle.tatteredCloak,
            outfitTint: OutfitTint.forestRanger,
          ),
        _ => const HeroAppearance(
            skinTone: SkinTone.bronze,
            eyeStyle: EyeStyle.glowing,
            eyeColor: EyeColor.amber,
            hairStyle: HairStyle.shortCrop,
            hairColor: HairColor.goldenBlonde,
            beardStyle: BeardStyle.none,
            torsoStyle: TorsoStyle.royalPlate,
            legsStyle: LegsStyle.platedGreaves,
            bootsStyle: BootsStyle.ironSabaton,
            backStyle: BackStyle.none,
            outfitTint: OutfitTint.emberGold,
          ),
      };
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
