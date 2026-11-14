import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../core/game/attributes.dart';
import '../core/game/hero_profile.dart';
import '../core/game/xp_event.dart';

part 'database.g.dart';

class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get muscleGroup => text()();
  TextColumn get equipment => text()();
  TextColumn get attribute => textEnum<Attribute>()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(WorkoutSessions, #id)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get setOrder => integer()();
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  RealColumn get rpe => real().withDefault(const Constant(8.0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isPersonalRecord => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class PersonalRecords extends Table {
  TextColumn get exerciseId => text().references(Exercises, #id)();
  RealColumn get maxWeightKg => real()();
  RealColumn get estimatedOneRepMax => real()();
  IntColumn get repsAtMaxWeight => integer()();
  DateTimeColumn get achievedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {exerciseId};
}

class Activities extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get attribute => textEnum<Attribute>()();
  RealColumn get durationMinutes => real()();
  RealColumn get intensity => real().withDefault(const Constant(1.0))();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class XpLedger extends Table {
  TextColumn get id => text()();
  TextColumn get attribute => textEnum<Attribute>()();
  RealColumn get amount => real()();
  TextColumn get source => textEnum<XpSource>()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class DailyQuestsTable extends Table {
  TextColumn get id => text()();
  TextColumn get dateStr => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get targetAttribute => textEnum<Attribute>()();
  RealColumn get targetValue => real()();
  RealColumn get currentValue => real()();
  TextColumn get unit => text()();
  RealColumn get bonusXp => real()();
  BoolColumn get grantsInspiration => boolean().withDefault(const Constant(true))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Perfil do herói (linha única, id = 1). Criado no onboarding.
@DataClassName('HeroRow')
class Heroes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get form => textEnum<HeroForm>()();
  TextColumn get origin => textEnum<HeroOrigin>()();
  TextColumn get oath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Heroes,
  Exercises,
  WorkoutSessions,
  WorkoutSets,
  PersonalRecords,
  Activities,
  XpLedger,
  DailyQuestsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v2: criação de personagem (tabela heroes).
          if (from < 2) {
            await m.createTable(heroes);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'grindheim_db',
      // Na web o Drift roda SQLite via WebAssembly. Os dois arquivos abaixo
      // ficam em `web/` e DEVEM ter versões compatíveis com o pubspec.lock:
      //   sqlite3.wasm    -> release do pacote `sqlite3` (atual: 3.9.1)
      //   drift_worker.js -> release do pacote `drift`   (atual: 2.35.4)
      // Ao atualizar drift/sqlite3, baixe novamente os dois arquivos.
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
