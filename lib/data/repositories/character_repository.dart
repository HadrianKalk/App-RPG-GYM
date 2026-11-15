import 'package:drift/drift.dart';
import '../../core/game/attributes.dart';
import '../../core/game/class_resolver.dart';
import '../../core/game/progression.dart';
import '../../core/game/xp_event.dart';
import '../../core/game/xp_rules.dart';
import '../database.dart';

final class CharacterState {
  const CharacterState({
    required this.levelInfo,
    required this.characterClass,
    required this.attributeProgressions,
    required this.totalXpMap,
    required this.inspirationCount,
    this.emergentClass = CharacterClass.adventurer,
    this.unlockedClasses = const {CharacterClass.adventurer},
  });

  final CharacterLevelProgression levelInfo;

  /// Active class (either the player's unlocked selection or [emergentClass]).
  final CharacterClass characterClass;

  /// Natural class derived strictly from the top two attributes.
  final CharacterClass emergentClass;

  /// All classes currently unlocked by the hero's real-world attribute scores.
  final Set<CharacterClass> unlockedClasses;

  final Map<Attribute, AttributeProgression> attributeProgressions;
  final Map<Attribute, double> totalXpMap;
  final int inspirationCount;

  static CharacterState initial() {
    final defaultMap = {for (var a in Attribute.values) a: 0.0};
    final progs = {for (var a in Attribute.values) a: Progression.calculateAttribute(a, 0.0)};
    return CharacterState(
      levelInfo: Progression.calculateLevel(0.0),
      characterClass: CharacterClass.adventurer,
      emergentClass: CharacterClass.adventurer,
      unlockedClasses: const {CharacterClass.adventurer},
      attributeProgressions: progs,
      totalXpMap: defaultMap,
      inspirationCount: 0,
    );
  }

  /// Builds an in-memory sandbox [CharacterState] for Tester Mode from custom
  /// attribute scores (`8..30`), without mutating `xp_ledger`.
  factory CharacterState.fromOverrideScores({
    required Map<Attribute, int> scores,
    required int inspirationCount,
    CharacterClass? selectedClass,
  }) {
    final xpMap = <Attribute, double>{
      for (final a in Attribute.values)
        a: Progression.xpForAttributeScore(
          (scores[a] ?? XpRules.baseAttributeScore).clamp(8, 30),
        ),
    };
    final totalXp = xpMap.values.fold<double>(0.0, (sum, v) => sum + v);
    final progressions = <Attribute, AttributeProgression>{
      for (final a in Attribute.values)
        a: () {
          final targetScore =
              (scores[a] ?? XpRules.baseAttributeScore).clamp(8, 30);
          final xp = xpMap[a] ?? 0.0;
          return AttributeProgression(
            attribute: a,
            score: targetScore,
            modifier: Progression.calculateModifier(targetScore),
            currentXp: xp,
            xpForNextPoint: Progression.xpCostForScore(targetScore),
            progressPercent: 0.0,
          );
        }(),
    };
    final emergent = ClassResolver.resolveClass(xpMap);
    final unlocked = ClassResolver.unlockedClasses(xpMap);
    final effective = ClassResolver.effectiveClass(
      attributeXpMap: xpMap,
      selectedClass: selectedClass,
    );
    return CharacterState(
      levelInfo: Progression.calculateLevel(totalXp),
      characterClass: effective,
      emergentClass: emergent,
      unlockedClasses: unlocked,
      attributeProgressions: progressions,
      totalXpMap: xpMap,
      inspirationCount: inspirationCount,
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

  /// Watches the complete hero state (XP, Level, Attributes, and active/unlocked Classes).
  Stream<CharacterState> watchCharacter() {
    final trigger = _db.customSelect(
      'SELECT 1',
      readsFrom: {_db.xpLedger, _db.heroes},
    ).watch();

    return trigger.asyncMap((_) async {
      final events = await _db.select(_db.xpLedger).get();
      final heroRow = await (_db.select(_db.heroes)
            ..where((t) => t.id.equals(1)))
          .getSingleOrNull();

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

      final emergentClass = ClassResolver.resolveClass(xpMap);
      final unlockedClasses = ClassResolver.unlockedClasses(xpMap);
      final characterClass = ClassResolver.effectiveClass(
        attributeXpMap: xpMap,
        selectedClass: heroRow?.selectedClass,
      );
      final levelInfo = Progression.calculateLevel(totalXp);

      return CharacterState(
        levelInfo: levelInfo,
        characterClass: characterClass,
        emergentClass: emergentClass,
        unlockedClasses: unlockedClasses,
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
