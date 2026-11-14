import 'package:drift/drift.dart';
import '../../core/game/attributes.dart';
import '../../core/game/quest_generator.dart';
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
              title: q.title,
              description: q.description,
              targetAttribute: q.targetAttribute,
              targetValue: q.targetValue,
              currentValue: q.currentValue,
              unit: q.unit,
              bonusXp: q.bonusXp,
              grantsInspiration: Value(q.grantsInspiration),
              isCompleted: Value(q.isCompleted),
            ),
          ),
        );
      });
    }
  }

  /// Atualiza o progresso de missões vinculadas a um atributo e concede recompensas ao completar.
  Future<void> incrementProgress({
    required Attribute attribute,
    required double delta,
  }) async {
    final todayStr = _getTodayDateStr();
    final quests = await (_db.select(_db.dailyQuestsTable)
          ..where((tbl) => tbl.dateStr.equals(todayStr))
          ..where((tbl) => tbl.targetAttribute.equals(attribute.name))
          ..where((tbl) => tbl.isCompleted.equals(false)))
        .get();

    for (final q in quests) {
      final newCurrent = q.currentValue + delta;
      final completed = newCurrent >= q.targetValue;

      await (_db.update(_db.dailyQuestsTable)..where((tbl) => tbl.id.equals(q.id))).write(
        DailyQuestsTableCompanion(
          currentValue: Value(newCurrent),
          isCompleted: Value(completed),
        ),
      );

      if (completed) {
        // Concede bônus de XP da missão
        await _characterRepo.addXp(
          XpEvent(
            id: 'quest_reward_${q.id}',
            attribute: q.targetAttribute,
            amount: q.bonusXp,
            source: XpSource.dailyQuest,
            timestamp: DateTime.now(),
            description: 'Missão Cumprida: ${q.title} (+${q.bonusXp.toInt()} XP)',
          ),
        );
      }
    }
  }

  String _getTodayDateStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
