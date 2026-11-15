import 'package:drift/drift.dart';
import '../../core/game/attributes.dart';
import '../../core/game/class_resolver.dart';
import '../../core/game/progression.dart';
import '../../core/game/xp_event.dart';
import '../database.dart';

final class CharacterState {
  const CharacterState({
    required this.levelInfo,
    required this.characterClass,
    required this.attributeProgressions,
    required this.totalXpMap,
    required this.inspirationCount,
  });

  final CharacterLevelProgression levelInfo;
  final CharacterClass characterClass;
  final Map<Attribute, AttributeProgression> attributeProgressions;
  final Map<Attribute, double> totalXpMap;
  final int inspirationCount;

  static CharacterState initial() {
    final defaultMap = {for (var a in Attribute.values) a: 0.0};
    final progs = {for (var a in Attribute.values) a: Progression.calculateAttribute(a, 0.0)};
    return CharacterState(
      levelInfo: Progression.calculateLevel(0.0),
      characterClass: CharacterClass.adventurer,
      attributeProgressions: progs,
      totalXpMap: defaultMap,
      inspirationCount: 0,
    );
  }
}

class CharacterRepository {
  CharacterRepository(this._db);

  final AppDatabase _db;

  /// Registra um novo evento imutável de XP no livro-razão.
  Future<void> addXp(XpEvent event) async {
    await _db.into(_db.xpLedger).insert(
      XpLedgerCompanion.insert(
        id: event.id,
        attribute: event.attribute,
        amount: event.amount,
        source: event.source,
        timestamp: event.timestamp,
        description: Value(event.description),
      ),
    );
  }

  /// Observa em tempo real o estado completo do herói (XP, Nível, Atributos e Classe).
  Stream<CharacterState> watchCharacter() {
    return _db.select(_db.xpLedger).watch().map((events) {
      final xpMap = {for (var a in Attribute.values) a: 0.0};
      double totalXp = 0.0;

      var inspiration = 0;
      for (final event in events) {
        xpMap[event.attribute] = (xpMap[event.attribute] ?? 0.0) + event.amount;
        totalXp += event.amount;
        if (event.source == XpSource.dailyQuest) {
          inspiration++;
        } else if (event.source == XpSource.inspirationSpend) {
          inspiration--;
        }
      }
      if (inspiration < 0) inspiration = 0;

      final progressions = {
        for (final a in Attribute.values)
          a: Progression.calculateAttribute(a, xpMap[a] ?? 0.0),
      };

      final characterClass = ClassResolver.resolveClass(xpMap);
      final levelInfo = Progression.calculateLevel(totalXp);

      return CharacterState(
        levelInfo: levelInfo,
        characterClass: characterClass,
        attributeProgressions: progressions,
        totalXpMap: xpMap,
        inspirationCount: inspiration,
      );
    });
  }

  /// Retorna o XP total acumulado hoje em um atributo específico (usado para retornos decrescentes).
  Future<double> getMinutesOrXpLoggedToday(Attribute attribute) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final query = _db.select(_db.xpLedger)
      ..where((tbl) => tbl.attribute.equals(attribute.name))
      ..where((tbl) => tbl.timestamp.isBiggerOrEqualValue(startOfDay))
      ..where((tbl) => tbl.timestamp.isSmallerOrEqualValue(endOfDay));

    final records = await query.get();
    double total = 0.0;
    for (final r in records) {
      if (r.source.isEffort) {
        total += r.amount;
      }
    }
    return total;
  }
}
