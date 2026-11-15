import 'attributes.dart';
import 'progression.dart';

/// An attribute whose score went up.
final class AttributeIncrease {
  const AttributeIncrease({required this.attribute, required this.from, required this.to});

  final Attribute attribute;
  final int from;
  final int to;
}

/// What changed on the hero between two XP snapshots (used to celebrate
/// level-ups and attribute increases after a workout or activity).
final class ProgressDiff {
  const ProgressDiff({required this.levelBefore, required this.levelAfter, required this.attributes});

  /// Compares per-attribute XP totals before and after.
  factory ProgressDiff.between(Map<Attribute, double> before, Map<Attribute, double> after) {
    double total(Map<Attribute, double> m) => m.values.fold(0.0, (a, b) => a + b);
    final increases = <AttributeIncrease>[];
    for (final a in Attribute.values) {
      final from = Progression.calculateAttribute(a, before[a] ?? 0).score;
      final to = Progression.calculateAttribute(a, after[a] ?? 0).score;
      if (to > from) increases.add(AttributeIncrease(attribute: a, from: from, to: to));
    }
    return ProgressDiff(
      levelBefore: Progression.calculateLevel(total(before)).level,
      levelAfter: Progression.calculateLevel(total(after)).level,
      attributes: increases,
    );
  }

  final int levelBefore;
  final int levelAfter;
  final List<AttributeIncrease> attributes;

  bool get leveledUp => levelAfter > levelBefore;
}
