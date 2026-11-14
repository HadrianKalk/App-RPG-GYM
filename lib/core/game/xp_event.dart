import 'attributes.dart';

/// Tipo de atividade ou conquista que originou o XP.
enum XpSource {
  workoutSet,
  personalRecord,
  pomodoroStudy,
  sleep,
  activity,
  dailyQuest,
  penaltyAtrophy,
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
