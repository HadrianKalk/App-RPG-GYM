import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/progress_diff.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('detects attribute score and level increases', () {
    final diff = ProgressDiff.between(
      {Attribute.strength: 250},
      {Attribute.strength: 450},
    );
    expect(diff.attributes.single.attribute, Attribute.strength);
    expect(diff.attributes.single.from, 10);
    expect(diff.attributes.single.to, 11);
    expect(diff.leveledUp, isTrue); // 380 XP = level 2
  });

  test('no change -> nothing to celebrate', () {
    final diff = ProgressDiff.between({Attribute.wisdom: 10}, {Attribute.wisdom: 20});
    expect(diff.attributes, isEmpty);
    expect(diff.leveledUp, isFalse);
  });
}
