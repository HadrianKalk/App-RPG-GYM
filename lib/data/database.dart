import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../core/game/attributes.dart';
import '../core/game/exercise_taxonomy.dart';
import '../core/game/hero_profile.dart';
import '../core/game/xp_event.dart';

part 'database.g.dart';

class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get muscleGroup => textEnum<MuscleGroup>()();
  TextColumn get equipment => textEnum<Equipment>()();
  TextColumn get attribute => textEnum<Attribute>()();
  TextColumn get tracking =>
      textEnum<SetTracking>().withDefault(Constant(SetTracking.weightReps.name))();
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

  /// Routine this session was started from (template or custom id), if any.
  TextColumn get routineId => text().nullable()();

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

  /// Duration of timed sets (planks, cardio). 0 for weight/reps sets.
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
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

  /// Typed origin name/story when `origin` is custom (schema v4).
  TextColumn get customOriginName => text().nullable()();
  TextColumn get customOriginStory => text().nullable()();

  /// Training days per week the player aims for (schema v5).
  IntColumn get weeklyGoal => integer().withDefault(const Constant(3))();

  @override
  Set<Column> get primaryKey => {id};
}

/// User-created routines (templates live in code: `RoutineSeed`).
@DataClassName('RoutineRow')
class Routines extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Ordered exercise targets of a custom routine.
@DataClassName('RoutineExerciseRow')
class RoutineExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get routineId => text().references(Routines, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get sets => integer()();
  IntColumn get repsMin => integer().nullable()();
  IntColumn get repsMax => integer().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  BoolColumn get toFailure => boolean().withDefault(const Constant(false))();
  IntColumn get restSeconds => integer().withDefault(const Constant(90))();
}

@DriftDatabase(tables: [
  Routines,
  RoutineExercises,
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
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v2: criação de personagem (tabela heroes).
          if (from < 2) {
            await m.createTable(heroes);
          }
          // v3: normalized exercise taxonomy. Old rows stored Portuguese
          // labels; convert them to enum names so textEnum can read them.
          // The catalog sync on startup then fixes per-exercise details.
          if (from < 3) {
            await m.addColumn(exercises, exercises.tracking);
            for (final entry in _legacyMuscleGroups.entries) {
              await customStatement(
                'UPDATE exercises SET muscle_group = ? WHERE muscle_group = ?',
                [entry.value.name, entry.key],
              );
            }
            for (final entry in _legacyEquipment.entries) {
              await customStatement(
                'UPDATE exercises SET equipment = ? WHERE equipment = ?',
                [entry.value.name, entry.key],
              );
            }
            // Anything unknown (should not exist) falls back to safe values.
            final muscles = MuscleGroup.values.map((e) => "'${e.name}'").join(',');
            final equipment = Equipment.values.map((e) => "'${e.name}'").join(',');
            await customStatement(
              "UPDATE exercises SET muscle_group = 'fullBody' WHERE muscle_group NOT IN ($muscles)",
            );
            await customStatement(
              "UPDATE exercises SET equipment = 'other' WHERE equipment NOT IN ($equipment)",
            );
          }
          // v4: routines, timed sets, custom hero origin.
          if (from < 4) {
            await m.createTable(routines);
            await m.createTable(routineExercises);
            await m.addColumn(workoutSessions, workoutSessions.routineId);
            await m.addColumn(workoutSets, workoutSets.durationSeconds);
            await m.addColumn(heroes, heroes.customOriginName);
            await m.addColumn(heroes, heroes.customOriginStory);
          }
          // v5: weekly goal (consistency bonuses).
          if (from < 5) {
            await m.addColumn(heroes, heroes.weeklyGoal);
          }
        },
        // SQLite needs this to honor ON DELETE CASCADE (routine exercises).
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
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

/// Portuguese muscle-group labels used before schema v3.
const Map<String, MuscleGroup> _legacyMuscleGroups = {
  'Peitoral': MuscleGroup.chest,
  'Dorsal': MuscleGroup.back,
  'Costas / Cadeia Posterior': MuscleGroup.back,
  'Deltoides': MuscleGroup.shoulders,
  'Deltoides Posterior': MuscleGroup.shoulders,
  'Trapézio': MuscleGroup.traps,
  'Bíceps': MuscleGroup.biceps,
  'Bíceps / Braquiorradial': MuscleGroup.biceps,
  'Antebraço': MuscleGroup.forearms,
  'Tríceps': MuscleGroup.triceps,
  'Quadríceps / Glúteos': MuscleGroup.quads,
  'Quadríceps': MuscleGroup.quads,
  'Pernas': MuscleGroup.quads,
  'Pernas / Glúteos': MuscleGroup.quads,
  'Isquiotibiais': MuscleGroup.hamstrings,
  'Isquiotibiais / Glúteos': MuscleGroup.hamstrings,
  'Glúteos': MuscleGroup.glutes,
  'Panturrilhas': MuscleGroup.calves,
  'Core / Abdômen': MuscleGroup.core,
  'Abdômen': MuscleGroup.core,
  'Core': MuscleGroup.core,
  'Cardiovascular': MuscleGroup.cardio,
  'Pernas / Cardiovascular': MuscleGroup.cardio,
  'Membros Inferiores': MuscleGroup.mobility,
  'Corpo Inteiro': MuscleGroup.fullBody,
};

/// Portuguese equipment labels used before schema v3.
const Map<String, Equipment> _legacyEquipment = {
  'Barra': Equipment.barbell,
  'Halter': Equipment.dumbbell,
  'Máquina': Equipment.machine,
  'Polia': Equipment.cable,
  'Peso Corporal': Equipment.bodyweight,
  'Outro': Equipment.other,
};
