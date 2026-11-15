import 'attributes.dart';

/// What produced an XP entry. Stored by name: only APPEND new values.
enum XpSource {
  workoutSet,
  personalRecord,
  pomodoroStudy,
  sleep,
  activity,
  dailyQuest,
  penaltyAtrophy,

  /// Weekly consistency bonuses (goal met, beyond duty, flame).
  weeklyBonus,

  /// Daily hydration (water cups & daily goal bonus).
  hydration,

  /// Daily nutrition / diet adherence check-in.
  nutrition,

  /// Append-only entry recording 1 spent Heroic Inspiration (0 XP).
  inspirationSpend;

  /// True for daily effort sources that count toward and are subject to the
  /// per-attribute daily diminishing-returns curve.
  ///
  /// Motivational milestones (personal records, daily quests, weekly bonuses)
  /// are exempt so they never lose value or eat into the player's effort pool.
  bool get isEffort => switch (this) {
        XpSource.workoutSet ||
        XpSource.pomodoroStudy ||
        XpSource.sleep ||
        XpSource.activity ||
        XpSource.hydration ||
        XpSource.nutrition =>
          true,
        XpSource.personalRecord ||
        XpSource.dailyQuest ||
        XpSource.weeklyBonus ||
        XpSource.penaltyAtrophy ||
        XpSource.inspirationSpend =>
          false,
      };
}

/// Representa uma transação imutável no "Livro-Razão" de XP do herói.
///
/// Como o personagem é a soma dos seus eventos de XP, podemos recalcular
/// atributos a qualquer momento se o balanceamento mudar ou auditar de onde veio cada ponto.
final class XpEvent {
  const XpEvent({
    required this.id,
    required this.attribute,
    required this.amount,
    required this.source,
    required this.timestamp,
    this.description,
  });

  final String id;
  final Attribute attribute;
  final double amount;
  final XpSource source;
  final DateTime timestamp;
  final String? description;

  Map<String, dynamic> toMap() => {
    'id': id,
    'attribute': attribute.name,
    'amount': amount,
    'source': source.name,
    'timestamp': timestamp.toIso8601String(),
    'description': description,
  };

  factory XpEvent.fromMap(Map<String, dynamic> map) => XpEvent(
    id: map['id'] as String,
    attribute: Attribute.values.byName(map['attribute'] as String),
    amount: (map['amount'] as num).toDouble(),
    source: XpSource.values.byName(map['source'] as String),
    timestamp: DateTime.parse(map['timestamp'] as String),
    description: map['description'] as String?,
  );
}
