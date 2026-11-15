/// Modular Paper-Doll appearance model for the hero (`HeroAppearance`).
///
/// Pure Dart: zero imports of Flutter, Drift, or Riverpod. Colors are exposed
/// as 32-bit ARGB integers (`0xAARRGGBB`) with 3 shading tones (highlight,
/// base, shadow) so the UI sprite compositor can render 16-bit shaded pixel
/// art (inspired by the 32x38 Action-RPG Berserk style) from modular layers.
library;

import 'class_resolver.dart';

/// 3-tone color ramp (highlight, base, shadow) stored as ARGB ints.
final class ToneRamp {
  const ToneRamp({
    required this.highlight,
    required this.base,
    required this.shadow,
  });

  final int highlight;
  final int base;
  final int shadow;
}

/// Skin tone options with automatic 3-tone shading.
enum SkinTone {
  pale(
    ramp: ToneRamp(
      highlight: 0xFFF7DEC9,
      base: 0xFFE3BA9B,
      shadow: 0xFFB38262,
    ),
  ),
  fair(
    ramp: ToneRamp(
      highlight: 0xFFF2C299,
      base: 0xFFD99E72,
      shadow: 0xFFA46840,
    ),
  ),
  warm(
    ramp: ToneRamp(
      highlight: 0xFFE3AC7E,
      base: 0xFFC58657,
      shadow: 0xFF8F5530,
    ),
  ),
  olive(
    ramp: ToneRamp(
      highlight: 0xFFD4A070,
      base: 0xFFB37D4E,
      shadow: 0xFF7D4F2A,
    ),
  ),
  bronze(
    ramp: ToneRamp(
      highlight: 0xFFBA7C50,
      base: 0xFF945932,
      shadow: 0xFF613519,
    ),
  ),
  ebony(
    ramp: ToneRamp(
      highlight: 0xFF8A583A,
      base: 0xFF633A22,
      shadow: 0xFF3D2010,
    ),
  );

  const SkinTone({required this.ramp});
  final ToneRamp ramp;
}

/// Eye expression and scar style.
enum EyeStyle {
  /// Right eye closed with vertical battle scar + fierce left eye (Black Swordsman).
  scarredOneEye,

  /// Both eyes open with determined dark brow.
  determined,

  /// Narrowed tactical gaze.
  focused,

  /// Supernatural glowing eyes (no dark pupil, bright iris).
  glowing,

  /// Calm, meditative gaze.
  serene,
}

/// Iris / eye color options.
enum EyeColor {
  obsidian(argb: 0xFF231D20, glowArgb: 0xFF9E9FA5),
  crimson(argb: 0xFFD13438, glowArgb: 0xFFFF6B6E),
  amber(argb: 0xFFE5A93C, glowArgb: 0xFFFFD470),
  ashGrey(argb: 0xFF949CA8, glowArgb: 0xFFD5DCE6),
  emerald(argb: 0xFF38A36D, glowArgb: 0xFF7CE8B0),
  arcaneBlue(argb: 0xFF4789E8, glowArgb: 0xFF8FC0FF);

  const EyeColor({required this.argb, required this.glowArgb});
  final int argb;
  final int glowArgb;
}

/// Hair or headgear style.
enum HairStyle {
  /// Iconic swept spiky warrior hair.
  spikyBerserk,

  /// Spiky warrior hair with the front white streak.
  spikyWhiteStreak,

  /// Short disciplined military crop.
  shortCrop,

  /// Long flowing locks over the shoulders.
  longFlowing,

  /// Tied warrior topknot.
  topknot,

  /// Dark ranger/rogue hood casting a shadow over the brow.
  hooded,

  /// Forged iron knight visor helm.
  ironHelm,

  /// Clean-shaven head with brow highlight.
  bald,
}

/// Hair color options with 3-tone shading.
enum HairColor {
  ravenBlack(
    ramp: ToneRamp(
      highlight: 0xFF47414D,
      base: 0xFF2A252E,
      shadow: 0xFF17141A,
    ),
  ),
  darkBrown(
    ramp: ToneRamp(
      highlight: 0xFF6E4936,
      base: 0xFF4B2F20,
      shadow: 0xFF2D1B11,
    ),
  ),
  ashenGrey(
    ramp: ToneRamp(
      highlight: 0xFFA3A9B5,
      base: 0xFF747A86,
      shadow: 0xFF4A4F59,
    ),
  ),
  silverWhite(
    ramp: ToneRamp(
      highlight: 0xFFF2F4F8,
      base: 0xFFC8CED9,
      shadow: 0xFF8E96A3,
    ),
  ),
  emberRed(
    ramp: ToneRamp(
      highlight: 0xFFD9533D,
      base: 0xFF9E2A2B,
      shadow: 0xFF611617,
    ),
  ),
  goldenBlonde(
    ramp: ToneRamp(
      highlight: 0xFFF2CC74,
      base: 0xFFC79A42,
      shadow: 0xFF8A6320,
    ),
  );

  const HairColor({required this.ramp});
  final ToneRamp ramp;
}

/// Facial hair style.
enum BeardStyle {
  none,
  stubble,
  shortBeard,
  warlordBeard,
  goatee,
}

/// Torso / shirt / chest armor style.
enum TorsoStyle {
  /// Chestplate + layered shoulder pauldrons + diagonal leather strap + iron gauntlet.
  mercenaryArmor,

  /// Sleeveless martial training tunic with wrist wraps.
  trainingTunic,

  /// Bare chest with barbarian/monk wraps and battle scars.
  bareChestWraps,

  /// Studded brigandine coat with reinforced shoulders.
  crimsonBrigandine,

  /// High-collared arcane robe vestment with rune trim.
  arcaneRobes,

  /// Full forged knight breastplate with golden crest.
  royalPlate,
}

/// Pants / legwear style.
enum LegsStyle {
  /// Dark combat breeches with belt buckle and utility pouch.
  darkBreeches,

  /// Loose training trousers with tied waist sash.
  trainingPants,

  /// Armored steel thigh cuisses and knee guards.
  platedGreaves,

  /// Light monk trousers with bound cloth shin wraps.
  monkWraps,

  /// Long split battle-tunic over dark breeches.
  scholarTunic,

  /// Reinforced leather war breeches.
  crimsonCuisses,
}

/// Footwear / boots style.
enum BootsStyle {
  /// Heavy folded-cuff brown leather mercenary boots with polished toe highlight.
  cuffedMercenaryBoots,

  /// Heavy forged iron sabatons.
  ironSabaton,

  /// Cross-strapped martial sandals/wraps.
  strappedSandals,

  /// Sleek dark rogue stalker boots.
  shadowBoots,

  /// War greaves with crimson trim.
  crimsonGreaves,

  /// Ornate gilded paladin boots.
  gildedBoots,
}

/// Back-slot cape and/or strapped weapon.
enum BackStyle {
  /// Colossal broadsword strapped diagonally + tattered dark mercenary cape.
  dragonslayerCape,

  /// Jagged dark travelling cloak without back weapon.
  tatteredCloak,

  /// Runic quarterstaff/spear strapped across a scholar cloak.
  runicStaffCape,

  /// Twin rogue blades + light shadow mantle.
  twinDaggersCloak,

  /// High-collared paladin mantle + holy broadsword.
  paladinWingedMantle,

  /// No cape or back weapon.
  none,
}

/// Primary color scheme for armor/cloth/leather layers.
enum OutfitTint {
  /// Dark forged steel + rich brown leather + burnished gold accents (Black Swordsman).
  ironAndLeather(
    primary: ToneRamp(
      highlight: 0xFF9C9AA9,
      base: 0xFF696778,
      shadow: 0xFF43414F,
    ),
    secondary: ToneRamp(
      highlight: 0xFFB86B35,
      base: 0xFF8C4A20,
      shadow: 0xFF592B0F,
    ),
    cloth: ToneRamp(
      highlight: 0xFF474654,
      base: 0xFF31303B,
      shadow: 0xFF1F1E26,
    ),
    cape: ToneRamp(
      highlight: 0xFF664436,
      base: 0xFF4A3025,
      shadow: 0xFF2E1D16,
    ),
    accentArgb: 0xFFD99B26,
  ),
  crimsonWar(
    primary: ToneRamp(
      highlight: 0xFFD44648,
      base: 0xFF9E2A2B,
      shadow: 0xFF631718,
    ),
    secondary: ToneRamp(
      highlight: 0xFF8E9099,
      base: 0xFF5D5F68,
      shadow: 0xFF383A40,
    ),
    cloth: ToneRamp(
      highlight: 0xFF4A2528,
      base: 0xFF301719,
      shadow: 0xFF1C0D0E,
    ),
    cape: ToneRamp(
      highlight: 0xFF7A1F21,
      base: 0xFF521315,
      shadow: 0xFF300A0B,
    ),
    accentArgb: 0xFFE0A96D,
  ),
  emberGold(
    primary: ToneRamp(
      highlight: 0xFFF0C27B,
      base: 0xFFC99246,
      shadow: 0xFF875B21,
    ),
    secondary: ToneRamp(
      highlight: 0xFF7D4E2D,
      base: 0xFF57331B,
      shadow: 0xFF361E0E,
    ),
    cloth: ToneRamp(
      highlight: 0xFF423A35,
      base: 0xFF2B2522,
      shadow: 0xFF1A1614,
    ),
    cape: ToneRamp(
      highlight: 0xFF8F332A,
      base: 0xFF61201A,
      shadow: 0xFF3B110E,
    ),
    accentArgb: 0xFFFFE08A,
  ),
  obsidianShadow(
    primary: ToneRamp(
      highlight: 0xFF5C5A6B,
      base: 0xFF3B3946,
      shadow: 0xFF222029,
    ),
    secondary: ToneRamp(
      highlight: 0xFF6E5343,
      base: 0xFF4A362B,
      shadow: 0xFF2B1E17,
    ),
    cloth: ToneRamp(
      highlight: 0xFF363440,
      base: 0xFF23222B,
      shadow: 0xFF15141A,
    ),
    cape: ToneRamp(
      highlight: 0xFF383542,
      base: 0xFF24222B,
      shadow: 0xFF15141A,
    ),
    accentArgb: 0xFFB0B5C2,
  ),
  arcaneTwilight(
    primary: ToneRamp(
      highlight: 0xFF6882C4,
      base: 0xFF435891,
      shadow: 0xFF28365E,
    ),
    secondary: ToneRamp(
      highlight: 0xFFD9A75B,
      base: 0xFFA67832,
      shadow: 0xFF6E4B19,
    ),
    cloth: ToneRamp(
      highlight: 0xFF384369,
      base: 0xFF242C47,
      shadow: 0xFF151A2B,
    ),
    cape: ToneRamp(
      highlight: 0xFF443669,
      base: 0xFF2C2247,
      shadow: 0xFF19132B,
    ),
    accentArgb: 0xFF6CD4FF,
  ),
  forestRanger(
    primary: ToneRamp(
      highlight: 0xFF5E8C65,
      base: 0xFF3E6344,
      shadow: 0xFF253D29,
    ),
    secondary: ToneRamp(
      highlight: 0xFFA8683B,
      base: 0xFF7D4925,
      shadow: 0xFF4F2C14,
    ),
    cloth: ToneRamp(
      highlight: 0xFF3D4A3F,
      base: 0xFF283029,
      shadow: 0xFF181D18,
    ),
    cape: ToneRamp(
      highlight: 0xFF4A593D,
      base: 0xFF313B28,
      shadow: 0xFF1D2417,
    ),
    accentArgb: 0xFFD9A441,
  );

  const OutfitTint({
    required this.primary,
    required this.secondary,
    required this.cloth,
    required this.cape,
    required this.accentArgb,
  });

  /// Primary armor/torso ramp.
  final ToneRamp primary;

  /// Secondary leather/straps/boots ramp.
  final ToneRamp secondary;

  /// Pants/cloth ramp.
  final ToneRamp cloth;

  /// Back cloak/cape ramp.
  final ToneRamp cape;

  /// Metallic buckle / gem / highlight color.
  final int accentArgb;
}

/// Curated pre-made hero archetypes (1-tap presets in the customization UI).
enum HeroAppearancePreset {
  blackSwordsman,
  ironWarrior,
  ashenBarbarian,
  shadowRogue,
  arcaneScholar,
  crimsonPaladin,
  sereneMonk,
}

/// Complete modular Paper-Doll configuration for the player's hero.
final class HeroAppearance {
  const HeroAppearance({
    this.skinTone = SkinTone.fair,
    this.eyeStyle = EyeStyle.scarredOneEye,
    this.eyeColor = EyeColor.obsidian,
    this.hairStyle = HairStyle.spikyBerserk,
    this.hairColor = HairColor.ravenBlack,
    this.beardStyle = BeardStyle.none,
    this.torsoStyle = TorsoStyle.mercenaryArmor,
    this.legsStyle = LegsStyle.darkBreeches,
    this.bootsStyle = BootsStyle.cuffedMercenaryBoots,
    this.backStyle = BackStyle.dragonslayerCape,
    this.outfitTint = OutfitTint.ironAndLeather,
  });

  /// Default look inspired by the 16-bit Black Swordsman reference.
  static const HeroAppearance defaultAppearance = HeroAppearance();

  final SkinTone skinTone;
  final EyeStyle eyeStyle;
  final EyeColor eyeColor;
  final HairStyle hairStyle;
  final HairColor hairColor;
  final BeardStyle beardStyle;
  final TorsoStyle torsoStyle;
  final LegsStyle legsStyle;
  final BootsStyle bootsStyle;
  final BackStyle backStyle;
  final OutfitTint outfitTint;

  /// Returns a pre-made appearance for a given [preset].
  static HeroAppearance fromPreset(HeroAppearancePreset preset) {
    return switch (preset) {
      HeroAppearancePreset.blackSwordsman => const HeroAppearance(
          skinTone: SkinTone.fair,
          eyeStyle: EyeStyle.scarredOneEye,
          eyeColor: EyeColor.obsidian,
          hairStyle: HairStyle.spikyBerserk,
          hairColor: HairColor.ravenBlack,
          beardStyle: BeardStyle.none,
          torsoStyle: TorsoStyle.mercenaryArmor,
          legsStyle: LegsStyle.darkBreeches,
          bootsStyle: BootsStyle.cuffedMercenaryBoots,
          backStyle: BackStyle.dragonslayerCape,
          outfitTint: OutfitTint.ironAndLeather,
        ),
      HeroAppearancePreset.ironWarrior => const HeroAppearance(
          skinTone: SkinTone.warm,
          eyeStyle: EyeStyle.determined,
          eyeColor: EyeColor.amber,
          hairStyle: HairStyle.shortCrop,
          hairColor: HairColor.darkBrown,
          beardStyle: BeardStyle.shortBeard,
          torsoStyle: TorsoStyle.royalPlate,
          legsStyle: LegsStyle.platedGreaves,
          bootsStyle: BootsStyle.ironSabaton,
          backStyle: BackStyle.tatteredCloak,
          outfitTint: OutfitTint.crimsonWar,
        ),
      HeroAppearancePreset.ashenBarbarian => const HeroAppearance(
          skinTone: SkinTone.bronze,
          eyeStyle: EyeStyle.determined,
          eyeColor: EyeColor.crimson,
          hairStyle: HairStyle.longFlowing,
          hairColor: HairColor.ravenBlack,
          beardStyle: BeardStyle.warlordBeard,
          torsoStyle: TorsoStyle.bareChestWraps,
          legsStyle: LegsStyle.darkBreeches,
          bootsStyle: BootsStyle.cuffedMercenaryBoots,
          backStyle: BackStyle.dragonslayerCape,
          outfitTint: OutfitTint.crimsonWar,
        ),
      HeroAppearancePreset.shadowRogue => const HeroAppearance(
          skinTone: SkinTone.pale,
          eyeStyle: EyeStyle.focused,
          eyeColor: EyeColor.emerald,
          hairStyle: HairStyle.hooded,
          hairColor: HairColor.ashenGrey,
          beardStyle: BeardStyle.none,
          torsoStyle: TorsoStyle.crimsonBrigandine,
          legsStyle: LegsStyle.darkBreeches,
          bootsStyle: BootsStyle.shadowBoots,
          backStyle: BackStyle.twinDaggersCloak,
          outfitTint: OutfitTint.obsidianShadow,
        ),
      HeroAppearancePreset.arcaneScholar => const HeroAppearance(
          skinTone: SkinTone.fair,
          eyeStyle: EyeStyle.glowing,
          eyeColor: EyeColor.arcaneBlue,
          hairStyle: HairStyle.spikyWhiteStreak,
          hairColor: HairColor.silverWhite,
          beardStyle: BeardStyle.goatee,
          torsoStyle: TorsoStyle.arcaneRobes,
          legsStyle: LegsStyle.scholarTunic,
          bootsStyle: BootsStyle.gildedBoots,
          backStyle: BackStyle.runicStaffCape,
          outfitTint: OutfitTint.arcaneTwilight,
        ),
      HeroAppearancePreset.crimsonPaladin => const HeroAppearance(
          skinTone: SkinTone.olive,
          eyeStyle: EyeStyle.determined,
          eyeColor: EyeColor.amber,
          hairStyle: HairStyle.ironHelm,
          hairColor: HairColor.goldenBlonde,
          beardStyle: BeardStyle.none,
          torsoStyle: TorsoStyle.royalPlate,
          legsStyle: LegsStyle.platedGreaves,
          bootsStyle: BootsStyle.gildedBoots,
          backStyle: BackStyle.paladinWingedMantle,
          outfitTint: OutfitTint.emberGold,
        ),
      HeroAppearancePreset.sereneMonk => const HeroAppearance(
          skinTone: SkinTone.warm,
          eyeStyle: EyeStyle.serene,
          eyeColor: EyeColor.amber,
          hairStyle: HairStyle.topknot,
          hairColor: HairColor.ravenBlack,
          beardStyle: BeardStyle.stubble,
          torsoStyle: TorsoStyle.trainingTunic,
          legsStyle: LegsStyle.monkWraps,
          bootsStyle: BootsStyle.strappedSandals,
          backStyle: BackStyle.none,
          outfitTint: OutfitTint.forestRanger,
        ),
    };
  }

  /// Suggests a pre-made appearance matching a D&D 5e [CharacterClass].
  static HeroAppearance forCharacterClass(CharacterClass c) {
    return switch (c) {
      CharacterClass.adventurer ||
      CharacterClass.warrior =>
        fromPreset(HeroAppearancePreset.blackSwordsman),
      CharacterClass.barbarian =>
        fromPreset(HeroAppearancePreset.ashenBarbarian),
      CharacterClass.rogue ||
      CharacterClass.ranger ||
      CharacterClass.bard =>
        fromPreset(HeroAppearancePreset.shadowRogue),
      CharacterClass.mage ||
      CharacterClass.eldritchKnight ||
      CharacterClass.warlock ||
      CharacterClass.sorcerer ||
      CharacterClass.artificer =>
        fromPreset(HeroAppearancePreset.arcaneScholar),
      CharacterClass.paladin ||
      CharacterClass.templar ||
      CharacterClass.cleric =>
        fromPreset(HeroAppearancePreset.crimsonPaladin),
      CharacterClass.monk ||
      CharacterClass.druid =>
        fromPreset(HeroAppearancePreset.sereneMonk),
    };
  }

  HeroAppearance copyWith({
    SkinTone? skinTone,
    EyeStyle? eyeStyle,
    EyeColor? eyeColor,
    HairStyle? hairStyle,
    HairColor? hairColor,
    BeardStyle? beardStyle,
    TorsoStyle? torsoStyle,
    LegsStyle? legsStyle,
    BootsStyle? bootsStyle,
    BackStyle? backStyle,
    OutfitTint? outfitTint,
  }) {
    return HeroAppearance(
      skinTone: skinTone ?? this.skinTone,
      eyeStyle: eyeStyle ?? this.eyeStyle,
      eyeColor: eyeColor ?? this.eyeColor,
      hairStyle: hairStyle ?? this.hairStyle,
      hairColor: hairColor ?? this.hairColor,
      beardStyle: beardStyle ?? this.beardStyle,
      torsoStyle: torsoStyle ?? this.torsoStyle,
      legsStyle: legsStyle ?? this.legsStyle,
      bootsStyle: bootsStyle ?? this.bootsStyle,
      backStyle: backStyle ?? this.backStyle,
      outfitTint: outfitTint ?? this.outfitTint,
    );
  }

  /// Serializes this appearance into a compact `key=value;...` string for SQLite.
  String encode() {
    return [
      'skin=${skinTone.name}',
      'eye=${eyeStyle.name}',
      'eyeColor=${eyeColor.name}',
      'hair=${hairStyle.name}',
      'hairColor=${hairColor.name}',
      'beard=${beardStyle.name}',
      'torso=${torsoStyle.name}',
      'legs=${legsStyle.name}',
      'boots=${bootsStyle.name}',
      'back=${backStyle.name}',
      'tint=${outfitTint.name}',
    ].join(';');
  }

  /// Deserializes from a stored string, falling back to [defaultAppearance]
  /// for missing or unknown fields so schema evolution never breaks old rows.
  static HeroAppearance decode(String? raw) {
    if (raw == null || raw.trim().isEmpty) return defaultAppearance;
    final map = <String, String>{};
    for (final part in raw.split(';')) {
      final idx = part.indexOf('=');
      if (idx > 0 && idx < part.length - 1) {
        map[part.substring(0, idx).trim()] = part.substring(idx + 1).trim();
      }
    }
    return HeroAppearance(
      skinTone: _byName(SkinTone.values, map['skin'], defaultAppearance.skinTone),
      eyeStyle: _byName(EyeStyle.values, map['eye'], defaultAppearance.eyeStyle),
      eyeColor: _byName(EyeColor.values, map['eyeColor'], defaultAppearance.eyeColor),
      hairStyle: _byName(HairStyle.values, map['hair'], defaultAppearance.hairStyle),
      hairColor: _byName(HairColor.values, map['hairColor'], defaultAppearance.hairColor),
      beardStyle: _byName(BeardStyle.values, map['beard'], defaultAppearance.beardStyle),
      torsoStyle: _byName(TorsoStyle.values, map['torso'], defaultAppearance.torsoStyle),
      legsStyle: _byName(LegsStyle.values, map['legs'], defaultAppearance.legsStyle),
      bootsStyle: _byName(BootsStyle.values, map['boots'], defaultAppearance.bootsStyle),
      backStyle: _byName(BackStyle.values, map['back'], defaultAppearance.backStyle),
      outfitTint: _byName(OutfitTint.values, map['tint'], defaultAppearance.outfitTint),
    );
  }

  static T _byName<T extends Enum>(List<T> values, String? name, T fallback) {
    if (name == null) return fallback;
    for (final v in values) {
      if (v.name == name) return v;
    }
    return fallback;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeroAppearance &&
          skinTone == other.skinTone &&
          eyeStyle == other.eyeStyle &&
          eyeColor == other.eyeColor &&
          hairStyle == other.hairStyle &&
          hairColor == other.hairColor &&
          beardStyle == other.beardStyle &&
          torsoStyle == other.torsoStyle &&
          legsStyle == other.legsStyle &&
          bootsStyle == other.bootsStyle &&
          backStyle == other.backStyle &&
          outfitTint == other.outfitTint;

  @override
  int get hashCode => Object.hash(
        skinTone,
        eyeStyle,
        eyeColor,
        hairStyle,
        hairColor,
        beardStyle,
        torsoStyle,
        legsStyle,
        bootsStyle,
        backStyle,
        outfitTint,
      );
}
