import 'package:drift/drift.dart';
import '../../core/game/quest_generator.dart';
import '../../core/game/quest_progress.dart';
import '../../core/game/xp_event.dart';
import '../database.dart';
import 'character_repository.dart';

class QuestRepository {
  QuestRepository(this._db, this._characterRepo);

  final AppDatabase _db;
  final CharacterRepository _characterRepo;

  /// Retorna e observa as missões de hoje.
  Stream<List<DailyQuestsTableData>> watchTodayQuests() {
    final todayStr = _getTodayDateStr();
    final query = _db.select(_db.dailyQuestsTable)
      ..where((tbl) => tbl.dateStr.equals(todayStr));
    return query.watch();
  }

  /// Assegura que as missões do dia atual existam geradas de forma determinística.
  Future<void> ensureTodayQuestsGenerated(CharacterState characterState) async {
    final todayStr = _getTodayDateStr();
    final existing = await (_db.select(_db.dailyQuestsTable)
          ..where((tbl) => tbl.dateStr.equals(todayStr)))
        .get();

    if (existing.isEmpty) {
      final quests = QuestGenerator.generateDailyQuests(
        date: DateTime.now(),
        characterClass: characterState.characterClass,
        currentXpMap: characterState.totalXpMap,
      );

      await _db.batch((batch) {
        batch.insertAll(
          _db.dailyQuestsTable,
          quests.map(
            (q) => DailyQuestsTableCompanion.insert(
              id: q.id,
              dateStr: todayStr,
              title: q.titleKey,
              description: q.descriptionKey,
              targetAttribute: q.targetAttribute,
              targetValue: q.targetValue,
              currentValue: q.currentValue,
              unit: q.unit,
              bonusXp: q.bonusXp,
              grantsInspiration: Value(q.grantsInspiration),
              isCompleted: Value(q.isCompleted),
            ),
          ),
          // Idempotente: se outra chamada já gerou as missões, ignora.
          mode: InsertMode.insertOrIgnore,
        );
      });
    }
  }

  /// Gera as missões de hoje a partir do estado atual do herói, se ainda
  /// não existirem. Deve ser chamado ANTES de registrar XP de uma ação, para
  /// que a primeira ação do dia não altere o sorteio das missões.
  Future<void> ensureTodayQuests() async {
    final character = await _characterRepo.watchCharacter().first;
    await ensureTodayQuestsGenerated(character);
  }

  /// Aplica às missões de hoje o crédito gerado por uma ação real
  /// (treino, atividade, sono) e concede as recompensas das que concluírem.
  ///
  /// Garante antes que as missões do dia existam, para que um treino feito
  /// antes de abrir a aba Missões não seja perdido.
  ///
  /// Returns the quests completed by this credit (for the rewards screen).
  Future<List<DailyQuestsTableData>> applyCredit(QuestCredit credit) async {
    if (credit.isEmpty) return const [];
    final completedNow = <DailyQuestsTableData>[];

    await ensureTodayQuests();

    final todayStr = _getTodayDateStr();
    final quests = await (_db.select(_db.dailyQuestsTable)
          ..where((tbl) => tbl.dateStr.equals(todayStr))
          ..where((tbl) => tbl.isCompleted.equals(false)))
        .get();

    for (final q in quests) {
      final newCurrent = QuestProgress.apply(
        credit: credit,
        attribute: q.targetAttribute,
        unit: q.unit,
        currentValue: q.currentValue,
        targetValue: q.targetValue,
      );
      if (newCurrent == q.currentValue) continue;

      final completed = newCurrent >= q.targetValue;
      await (_db.update(_db.dailyQuestsTable)..where((tbl) => tbl.id.equals(q.id))).write(
        DailyQuestsTableCompanion(
          currentValue: Value(newCurrent),
          isCompleted: Value(completed),
        ),
      );

      if (completed) {
        completedNow.add(q);
        await _characterRepo.addXp(
          XpEvent(
            id: 'quest_reward_${q.id}',
            attribute: q.targetAttribute,
            amount: q.bonusXp,
            source: XpSource.dailyQuest,
            timestamp: DateTime.now(),
            description: 'quest:${q.id}',
          ),
        );
      }
    }
    return completedNow;
  }

  String _getTodayDateStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
