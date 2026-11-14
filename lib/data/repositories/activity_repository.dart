import 'package:drift/drift.dart';
import '../../core/game/attributes.dart';
import '../../core/game/quest_progress.dart';
import '../../core/game/xp_calculator.dart';
import '../../core/game/xp_event.dart';
import '../database.dart';
import 'character_repository.dart';
import 'quest_repository.dart';

class ActivityRepository {
  ActivityRepository(this._db, this._characterRepo, this._questRepo);

  final AppDatabase _db;
  final CharacterRepository _characterRepo;
  final QuestRepository _questRepo;

  /// Registra uma sessão de estudo focado (Pomodoro) gerando XP de Inteligência (INT).
  Future<double> logPomodoroStudy({
    required int durationMinutes,
    double intensity = 1.0,
    String? subject,
  }) async {
    return _logActivityInternal(
      type: 'Pomodoro: ${subject ?? "Estudo Geral"}',
      attribute: Attribute.intelligence,
      durationMinutes: durationMinutes.toDouble(),
      intensity: intensity,
      source: XpSource.pomodoroStudy,
      description: subject != null ? 'Foco em $subject' : 'Sessão de estudo focado',
    );
  }

  /// Registra uma noite de sono gerando XP de Constituição (CON).
  /// Dentro da meta saudável (7-9 horas), concede bônus de eficiência.
  Future<double> logSleep({
    required double hoursSlept,
    String? notes,
  }) async {
    // 7 a 9 horas = sono ideal (ganho cheio de 60 XP base)
    double calculatedMinutes = 0.0;
    if (hoursSlept >= 7.0 && hoursSlept <= 9.0) {
      calculatedMinutes = 60.0; // Ganho cheio ideal
    } else if (hoursSlept >= 5.0) {
      calculatedMinutes = 40.0;
    } else {
      calculatedMinutes = 20.0;
    }

    final xp = await _logActivityInternal(
      type: 'Sono Reparador (${hoursSlept.toStringAsFixed(1)}h)',
      attribute: Attribute.constitution,
      durationMinutes: calculatedMinutes,
      intensity: 1.0,
      source: XpSource.sleep,
      description: notes ?? 'Descanso e recuperação física',
      // Os "minutos" do sono são pontos de XP, não tempo acordado:
      // não contam para missões em minutos.
      creditQuests: false,
    );
    await _questRepo.applyCredit(QuestProgress.fromSleep(hoursSlept: hoursSlept));
    return xp;
  }

  /// Registra uma sessão de meditação / reflexão gerando XP de Sabedoria (SAB).
  Future<double> logMeditation({
    required int durationMinutes,
    String? notes,
  }) async {
    return _logActivityInternal(
      type: 'Meditação / Quietude',
      attribute: Attribute.wisdom,
      durationMinutes: durationMinutes.toDouble(),
      intensity: 1.0,
      source: XpSource.activity,
      description: notes ?? 'Prática de mindfulness e presença',
    );
  }

  /// Registra qualquer atividade genérica com atributo correspondente.
  Future<double> logGeneralActivity({
    required String title,
    required Attribute attribute,
    required double durationMinutes,
    double intensity = 1.0,
    String? notes,
  }) async {
    return _logActivityInternal(
      type: title,
      attribute: attribute,
      durationMinutes: durationMinutes,
      intensity: intensity,
      source: XpSource.activity,
      description: notes,
    );
  }

  Future<double> _logActivityInternal({
    required String type,
    required Attribute attribute,
    required double durationMinutes,
    required double intensity,
    required XpSource source,
    String? description,
    bool creditQuests = true,
  }) async {
    await _questRepo.ensureTodayQuests();
    final now = DateTime.now();
    final alreadyLoggedToday = await _characterRepo.getMinutesOrXpLoggedToday(attribute);

    final earnedXp = XpCalculator.calculateXpWithDiminishingReturns(
      minutesAlreadyLoggedToday: alreadyLoggedToday,
      additionalMinutes: durationMinutes,
      intensityMultiplier: intensity,
    );

    final id = 'act_${now.millisecondsSinceEpoch}';

    await _db.into(_db.activities).insert(
      ActivitiesCompanion.insert(
        id: id,
        type: type,
        attribute: attribute,
        durationMinutes: durationMinutes,
        intensity: Value(intensity),
        timestamp: now,
        notes: Value(description),
      ),
    );

    await _characterRepo.addXp(
      XpEvent(
        id: 'xp_$id',
        attribute: attribute,
        amount: earnedXp,
        source: source,
        timestamp: now,
        description: '$type (${durationMinutes.toInt()} min) -> +${earnedXp.toStringAsFixed(1)} XP',
      ),
    );

    if (creditQuests) {
      await _questRepo.applyCredit(
        QuestProgress.fromActivity(attribute: attribute, durationMinutes: durationMinutes),
      );
    }

    return earnedXp;
  }
}
