import 'package:app/app/ui/pixel_sprite.dart';
import 'package:app/core/game/class_resolver.dart';
import 'package:app/core/game/hero_appearance.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/data/database.dart';
import 'package:app/data/repositories/hero_repository.dart';
import 'package:app/data/repositories/providers.dart';
import 'package:app/features/character/presentation/character_screen.dart';
import 'package:app/l10n/l10n.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  group('HeroAppearance pure engine model', () {
    test('encodes and decodes all Paper-Doll slots losslessly', () {
      const custom = HeroAppearance(
        skinTone: SkinTone.bronze,
        eyeStyle: EyeStyle.glowing,
        eyeColor: EyeColor.crimson,
        hairStyle: HairStyle.spikyWhiteStreak,
        hairColor: HairColor.silverWhite,
        beardStyle: BeardStyle.warlordBeard,
        torsoStyle: TorsoStyle.royalPlate,
        legsStyle: LegsStyle.platedGreaves,
        bootsStyle: BootsStyle.gildedBoots,
        backStyle: BackStyle.paladinWingedMantle,
        outfitTint: OutfitTint.crimsonWar,
      );

      final encoded = custom.encode();
      final decoded = HeroAppearance.decode(encoded);
      expect(decoded, equals(custom));
    });

    test('decode falls back gracefully on null, empty, or partial strings', () {
      expect(HeroAppearance.decode(null), HeroAppearance.defaultAppearance);
      expect(HeroAppearance.decode(''), HeroAppearance.defaultAppearance);
      final partial = HeroAppearance.decode('skin=ebony;hair=hooded;unknown=123');
      expect(partial.skinTone, SkinTone.ebony);
      expect(partial.hairStyle, HairStyle.hooded);
      expect(partial.bootsStyle, HeroAppearance.defaultAppearance.bootsStyle);
    });

    test('presets and class mappings produce valid distinct appearances', () {
      final presets = {
        for (final p in HeroAppearancePreset.values) HeroAppearance.fromPreset(p),
      };
      expect(presets.length, HeroAppearancePreset.values.length);

      for (final c in CharacterClass.values) {
        final app = HeroAppearance.forCharacterClass(c);
        expect(app.encode(), isNotEmpty);
      }
    });

    test('resolveAttackAnimation selects specific animations for Mage staff, Rogue daggers, Ranger bow, Monk Ki, Paladin holy blade, and Greatsword', () {
      const def = HeroAppearance.defaultAppearance;
      expect(
        def.resolveAttackAnimation(characterClass: CharacterClass.mage),
        AttackAnimationKind.staffArcaneCast,
      );
      expect(
        def.resolveAttackAnimation(characterClass: CharacterClass.rogue),
        AttackAnimationKind.daggerShadowFlurry,
      );
      expect(
        def.resolveAttackAnimation(characterClass: CharacterClass.ranger),
        AttackAnimationKind.bowPiercingShot,
      );
      expect(
        def.resolveAttackAnimation(characterClass: CharacterClass.monk),
        AttackAnimationKind.martialKiStrike,
      );
      expect(
        def.resolveAttackAnimation(characterClass: CharacterClass.paladin),
        AttackAnimationKind.holyRadiantSmite,
      );
      expect(
        def.resolveAttackAnimation(characterClass: CharacterClass.eldritchKnight),
        AttackAnimationKind.eldritchRunicSlash,
      );
      expect(
        def.resolveAttackAnimation(characterClass: CharacterClass.druid),
        AttackAnimationKind.primalSongWave,
      );
      expect(
        def.resolveAttackAnimation(characterClass: CharacterClass.warrior),
        AttackAnimationKind.greatswordCleave,
      );
      expect(
        def.resolveAttackAnimation(
          characterClass: CharacterClass.warrior,
          isDefend: true,
        ),
        AttackAnimationKind.defensiveGuard,
      );

      // Warrior equipping a Runic Staff on back adapts basic attack to staff cast
      final staffWarrior = def.copyWith(backStyle: BackStyle.runicStaffCape);
      expect(
        staffWarrior.resolveAttackAnimation(characterClass: CharacterClass.warrior),
        AttackAnimationKind.staffArcaneCast,
      );
      // Class skill still uses Warrior's signature cleave
      expect(
        staffWarrior.resolveAttackAnimation(
          characterClass: CharacterClass.warrior,
          isClassSkill: true,
        ),
        AttackAnimationKind.greatswordCleave,
      );
    });
  });

  group('HeroPaperDoll 28x36 16-bit compositor', () {
    test('composes every preset and pose into a 28x36 grid with full palette coverage', () {
      for (final preset in HeroAppearancePreset.values) {
        for (final pose in HeroPose.values) {
          final app = HeroAppearance.fromPreset(preset);
          final sprite = HeroPaperDoll.compose(
            app,
            equippedCosmeticId: 'cosmetic_crimson_halo',
            pose: pose,
          );
          expect(sprite.rows.length, HeroPaperDoll.height);
          for (final row in sprite.rows) {
            expect(row.length, HeroPaperDoll.width);
            for (var i = 0; i < row.length; i++) {
              final ch = row[i];
              if (ch != '.') {
                expect(
                  sprite.palette.containsKey(ch),
                  isTrue,
                  reason: 'Missing palette key "$ch" in preset $preset ($pose)',
                );
              }
            }
          }
        }
      }
    });
  });

  testWidgets('CharacterScreen opens customization sheet and persists Paper-Doll changes', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() async {
      await HeroRepository(db).createHero(
        name: 'Guts',
        form: HeroForm.masculine,
        origin: HeroOrigin.soldier,
      );
    });

    Future<void> settle() async {
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          locale: Locale('pt'),
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CharacterScreen(),
        ),
      ),
    );
    await settle();

    expect(find.byType(HeroAvatar), findsOneWidget);

    // Open customization sheet via hero_customize_btn
    await tester.tap(find.byKey(const Key('hero_customize_btn')));
    await settle();

    // Select Arcane Scholar preset
    final presetChip = find.byKey(const Key('preset_arcaneScholar'));
    await tester.ensureVisible(presetChip);
    await settle();
    await tester.tap(presetChip);
    await settle();

    // Verify DB persisted the new appearance
    final hero = await tester.runAsync(() => HeroRepository(db).watchHero().first);
    expect(
      hero?.appearance,
      equals(HeroAppearance.fromPreset(HeroAppearancePreset.arcaneScholar)),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
    await tester.pump(const Duration(seconds: 1));
  });
}
