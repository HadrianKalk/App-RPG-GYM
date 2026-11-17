import 'package:app/app/ui/paper_doll/chibi_layers.g.dart';
import 'package:app/app/ui/pixel_sprite.dart';
import 'package:app/core/game/hero_appearance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every appearance option and pose has a generated chibi layer', () {
    final keys = <String>[
      for (final p in ['idle', 'flex']) ...[
        'body.$p',
        for (final t in TorsoStyle.values) 'torso.${t.name}.$p',
      ],
      for (final v in LegsStyle.values) 'legs.${v.name}',
      for (final v in BootsStyle.values) 'boots.${v.name}',
      for (final v in EyeStyle.values) 'eyes.${v.name}',
      for (final v in BeardStyle.values) 'beard.${v.name}',
      for (final v in HairStyle.values) 'hair.${v.name}',
      for (final v in BackStyle.values) ...['back.${v.name}', 'backFront.${v.name}'],
      'back.drawnCloak',
      for (final w in ['greatsword', 'staff', 'daggers', 'bow', 'martial', 'holyBlade', 'shield']) 'weapon.$w',
      'aura',
    ];
    final missing = keys.where((k) => !chibiLayers.containsKey(k)).toList();
    expect(missing, isEmpty, reason: 'run: python3 tool/art/chibi_gen.py');
  });

  test('every preset/pose renders a full 28x36 sprite whose pixels all have colours', () {
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
        expect(painted, greaterThan(400), reason: '$preset/$pose looks empty');
      }
    }
  });
}
