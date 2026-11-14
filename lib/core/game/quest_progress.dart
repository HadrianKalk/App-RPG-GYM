import 'attributes.dart';
import 'xp_rules.dart';

/// Unidades de medida das missões diárias.
abstract final class QuestUnit {
  static const String sets = 'séries';
  static const String minutes = 'minutos';
}

/// Crédito de progresso de missão produzido por uma ação real do jogador.
///
/// O motor converte "o que o jogador fez" em crédito; o repositório aplica o
/// crédito às missões do dia de acordo com a unidade de cada missão.
final class QuestCredit {
  const QuestCredit({
    this.sets = const {},
    this.minutes = const {},
    this.completes = const {},
  });

  /// Séries efetivas por atributo (missões medidas em séries).
  final Map<Attribute, double> sets;

  /// Minutos por atributo (missões medidas em minutos).
  final Map<Attribute, double> minutes;

  /// Atributos cujas missões são concluídas por inteiro (ex.: 8h de sono).
  final Set<Attribute> completes;

  bool get isEmpty => sets.isEmpty && minutes.isEmpty && completes.isEmpty;
}

abstract final class QuestProgress {
  /// Crédito de um treino finalizado.
  ///
  /// - Missões em séries recebem o número de séries concluídas do atributo.
  /// - Missões em minutos recebem a duração do treino dividida entre os
  ///   atributos proporcionalmente às séries (limitada a
  ///   [XpRules.questMaxMinutesPerWorkout]).
  static QuestCredit fromWorkout({
    required Map<Attribute, int> completedSetsByAttribute,
    required Duration sessionDuration,
  }) {
    final totalSets =
        completedSetsByAttribute.values.fold<int>(0, (a, b) => a + b);
    if (totalSets <= 0) return const QuestCredit();

    final rawMinutes = sessionDuration.inSeconds / 60.0;
    final minutes = rawMinutes.clamp(0.0, XpRules.questMaxMinutesPerWorkout);

    final sets = <Attribute, double>{};
    final minutesByAttr = <Attribute, double>{};
    for (final entry in completedSetsByAttribute.entries) {
      if (entry.value <= 0) continue;
      sets[entry.key] = entry.value.toDouble();
      minutesByAttr[entry.key] = minutes * entry.value / totalSets;
    }
    return QuestCredit(sets: sets, minutes: minutesByAttr);
  }

  /// Crédito de uma atividade cronometrada (estudo, meditação, yoga...).
  static QuestCredit fromActivity({
    required Attribute attribute,
    required double durationMinutes,
  }) {
    if (durationMinutes <= 0) return const QuestCredit();
    return QuestCredit(minutes: {attribute: durationMinutes});
  }

  /// Crédito de uma noite de sono: a partir de
  /// [XpRules.questSleepHoursForCompletion] horas, conclui a missão de CON.
  static QuestCredit fromSleep({required double hoursSlept}) {
    if (hoursSlept >= XpRules.questSleepHoursForCompletion) {
      return const QuestCredit(completes: {Attribute.constitution});
    }
    return const QuestCredit();
  }

  /// Novo valor de progresso de uma missão após aplicar [credit].
  /// Nunca ultrapassa [targetValue] e nunca diminui.
  static double apply({
    required QuestCredit credit,
    required Attribute attribute,
    required String unit,
    required double currentValue,
    required double targetValue,
  }) {
    if (credit.completes.contains(attribute)) return targetValue;

    final delta = switch (unit) {
      QuestUnit.sets => credit.sets[attribute] ?? 0.0,
      QuestUnit.minutes => credit.minutes[attribute] ?? 0.0,
      _ => 0.0,
    };
    if (delta <= 0) return currentValue;
    final next = currentValue + delta;
    return next > targetValue ? targetValue : next;
  }
}
