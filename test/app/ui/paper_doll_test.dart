import 'package:app/app/ui/paper_doll/paper_doll_shader.dart';
import 'package:app/app/ui/pixel_sprite.dart';
import 'package:app/core/game/hero_appearance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('generated catalog', () {
    test('every appearance option and pose has a generated layer', () {
      final keys = <String>[
        for (final p in ['idle', 'flex', 'action']) ...[
          'body.$p',
          for (final t in TorsoStyle.values) 'torso.${t.name}.$p',
        ],
        for (final v in LegsStyle.values) 'legs.${v.name}',
        for (final v in BootsStyle.values) 'boots.${v.name}',
        for (final v in EyeStyle.values) 'eyes.${v.name}',
        for (final v in BeardStyle.values) 'beard.${v.name}',
        for (final v in HairStyle.values) 'hair.${v.name}',
        for (final v in BackStyle.values) 'back.${v.name}',
        'back.drawnCloak',
        for (final w in ['greatsword', 'staff', 'daggers', 'bow', 'martial', 'holyBlade', 'shield']) 'weapon.$w',
        'aura',
      ];
      final missing = keys.where((k) => !PaperDollShader.hasLayer(k)).toList();
      expect(missing, isEmpty, reason: 'run: python3 tool/art/paper_doll_gen.py');
    });
  });

  group('compose + palette', () {
    test('every pose of every preset yields a full 64x72 sprite with colours for all pixels', () {
      for (final preset in HeroAppearancePreset.values) {
        final appearance = HeroAppearance.fromPreset(preset);
        for (final pose in HeroPose.values) {
          final sprite = HeroPaperDoll.compose(appearance, pose: pose, equippedCosmeticId: 'cosmetic_x');
          expect(sprite.rows, hasLength(HeroPaperDoll.height));
          var painted = 0;
          for (final row in sprite.rows) {
            expect(row.length, HeroPaperDoll.width);
            for (final ch in row.split('')) {
              if (ch == '.') continue;
              painted++;
              expect(sprite.palette.containsKey(ch), isTrue, reason: '$preset/$pose token "$ch" has no colour');
            }
          }
          expect(painted, greaterThan(800), reason: '$preset/$pose looks empty');
        }
      }
    });
  });

  group('shader rules', () {
    test('silhouette pixels are outlined and the interior is shaded', () {
      final rows = PaperDollShader.compose(['body.idle']);
      // Top of the head (first non-transparent pixel of the column) is outline.
      final col = [for (final r in rows) r[32]];
      final first = col.indexWhere((c) => c != '.');
      expect(col[first], 'K');
      // Somewhere inside the face there is a skin base tone.
      expect(rows[24].contains(PaperDollTokens.of(PaperDollMaterial.skin, PaperDollTone.base)), isTrue);
    });

    test('same material from different layers is separated by a deep line', () {
      // Hood (cape material, hair layer) over robes (cape material, torso layer).
      final rows = PaperDollShader.compose(['body.idle', 'torso.arcaneRobes.idle', 'hair.hooded']);
      final deep = PaperDollTokens.of(PaperDollMaterial.cape, PaperDollTone.deep);
      expect(rows.any((r) => r.contains(deep)), isTrue);
    });
  });
}
