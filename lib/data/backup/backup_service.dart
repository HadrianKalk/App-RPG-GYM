import 'dart:convert';

import 'package:drift/drift.dart';

import '../../features/settings/domain/app_settings.dart';
import '../database.dart';
import '../seed/exercise_seed.dart';
import 'backup_export_stub.dart'
    if (dart.library.js_interop) 'backup_export_web.dart';

/// Summary shown to the user before confirming a destructive backup restore.
final class BackupPreview {
  const BackupPreview({
    required this.formatVersion,
    required this.exportedAt,
    required this.heroName,
    required this.workoutCount,
    required this.xpEntryCount,
    required this.routineCount,
  });

  final int formatVersion;
  final DateTime? exportedAt;
  final String? heroName;
  final int workoutCount;
  final int xpEntryCount;
  final int routineCount;
}

/// Portable JSON backup and restore service for all Drift tables + preferences.
///
/// Designed especially so PWA users (e.g. iOS Safari) can safeguard their hero,
/// workout logs, XP ledger, and combat progression against browser storage clears.
class BackupService {
  BackupService(this._db);

  static const int currentFormatVersion = 1;

  final AppDatabase _db;

  /// Exports the full database snapshot and [settings] as formatted JSON.
  Future<String> exportJson({AppSettings? settings}) async {
    final heroesRows = await _db.select(_db.heroes).get();
    final exercisesRows = await _db.select(_db.exercises).get();
    final routinesRows = await _db.select(_db.routines).get();
    final routineExRows = await _db.select(_db.routineExercises).get();
    final sessionsRows = await _db.select(_db.workoutSessions).get();
    final setsRows = await _db.select(_db.workoutSets).get();
    final recordsRows = await _db.select(_db.personalRecords).get();
    final activitiesRows = await _db.select(_db.activities).get();
    final ledgerRows = await _db.select(_db.xpLedger).get();
    final questsRows = await _db.select(_db.dailyQuestsTable).get();
    final healthRows = await _db.select(_db.dailyHealthLogs).get();
    final arenaProgressRows = await _db.select(_db.arenaProgress).get();
    final arenaLogRows = await _db.select(_db.dailyArenaLogs).get();
    final storyRunsRows = await _db.select(_db.storyRuns).get();
    final storyChaptersRows = await _db.select(_db.storyChapters).get();

    final payload = <String, dynamic>{
      'formatVersion': currentFormatVersion,
      'schemaVersion': _db.schemaVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      if (settings != null)
        'settings': {
          'languageCode': settings.languageCode,
          'fontStyle': settings.fontStyle.name,
          'soundEnabled': settings.soundEnabled,
        },
      'tables': {
        'heroes': [for (final r in heroesRows) r.toJson()],
        'exercises': [for (final r in exercisesRows) r.toJson()],
        'routines': [for (final r in routinesRows) r.toJson()],
        'routine_exercises': [for (final r in routineExRows) r.toJson()],
        'workout_sessions': [for (final r in sessionsRows) r.toJson()],
        'workout_sets': [for (final r in setsRows) r.toJson()],
        'personal_records': [for (final r in recordsRows) r.toJson()],
        'activities': [for (final r in activitiesRows) r.toJson()],
        'xp_ledger': [for (final r in ledgerRows) r.toJson()],
        'daily_quests': [for (final r in questsRows) r.toJson()],
        'daily_health_logs': [for (final r in healthRows) r.toJson()],
        'arena_progress': [for (final r in arenaProgressRows) r.toJson()],
        'daily_arena_logs': [for (final r in arenaLogRows) r.toJson()],
        'story_runs': [for (final r in storyRunsRows) r.toJson()],
        'story_chapters': [for (final r in storyChaptersRows) r.toJson()],
      },
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Exports JSON, copies it to clipboard, and triggers file download on Web.
  Future<bool> exportAndShare({AppSettings? settings}) async {
    final json = await exportJson(settings: settings);
    final now = DateTime.now();
    final stamp =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return exportBackupPayload(
      filename: 'grindheim-backup-$stamp.json',
      jsonContent: json,
    );
  }

  /// Validates [rawJson] and extracts a preview without mutating the database.
  BackupPreview inspectJson(String rawJson) {
    final root = _decodeRoot(rawJson);
    final tables = root['tables'] as Map<String, dynamic>;
    final heroesList = _readList(tables, 'heroes');
    final heroName = heroesList.isNotEmpty
        ? (heroesList.first['name'] as String?)
        : null;
    final exportedStr = root['exportedAt'] as String?;
    return BackupPreview(
      formatVersion: (root['formatVersion'] as num?)?.toInt() ?? 1,
      exportedAt: exportedStr != null ? DateTime.tryParse(exportedStr) : null,
      heroName: heroName,
      workoutCount: _readList(tables, 'workout_sessions').length,
      xpEntryCount: _readList(tables, 'xp_ledger').length,
      routineCount: _readList(tables, 'routines').length,
    );
  }

  /// Atomically replaces all local database tables with the snapshot in [rawJson].
  ///
  /// Returns any saved [AppSettings] included in the snapshot, if present.
  Future<AppSettings?> restoreJson(String rawJson) async {
    final root = _decodeRoot(rawJson);
    final tables = root['tables'] as Map<String, dynamic>;

    final heroesRows =
        _readList(tables, 'heroes').map(HeroRow.fromJson).toList();
    final exerciseRows =
        _readList(tables, 'exercises').map(Exercise.fromJson).toList();
    final routineRows =
        _readList(tables, 'routines').map(RoutineRow.fromJson).toList();
    final routineExRows = _readList(tables, 'routine_exercises')
        .map(RoutineExerciseRow.fromJson)
        .toList();
    final sessionRows = _readList(tables, 'workout_sessions')
        .map(WorkoutSession.fromJson)
        .toList();
    final setRows =
        _readList(tables, 'workout_sets').map(WorkoutSet.fromJson).toList();
    final recordRows = _readList(tables, 'personal_records')
        .map(PersonalRecord.fromJson)
        .toList();
    final activityRows =
        _readList(tables, 'activities').map(Activity.fromJson).toList();
    final ledgerRows =
        _readList(tables, 'xp_ledger').map(XpLedgerData.fromJson).toList();
    final questRows = _readList(tables, 'daily_quests')
        .map(DailyQuestsTableData.fromJson)
        .toList();
    final healthRows = _readList(tables, 'daily_health_logs')
        .map(DailyHealthRow.fromJson)
        .toList();
    final arenaProgressRows = _readList(tables, 'arena_progress')
        .map(ArenaProgressRow.fromJson)
        .toList();
    final arenaLogRows = _readList(tables, 'daily_arena_logs')
        .map(DailyArenaLogRow.fromJson)
        .toList();
    final storyRunRows =
        _readList(tables, 'story_runs').map(StoryRunRow.fromJson).toList();
    final storyChapterRows = _readList(tables, 'story_chapters')
        .map(StoryChapterRow.fromJson)
        .toList();

    await _db.transaction(() async {
      // Clear tables in reverse foreign-key order.
      await _db.delete(_db.routineExercises).go();
      await _db.delete(_db.routines).go();
      await _db.delete(_db.workoutSets).go();
      await _db.delete(_db.personalRecords).go();
      await _db.delete(_db.workoutSessions).go();
      await _db.delete(_db.activities).go();
      await _db.delete(_db.xpLedger).go();
      await _db.delete(_db.dailyQuestsTable).go();
      await _db.delete(_db.dailyHealthLogs).go();
      await _db.delete(_db.arenaProgress).go();
      await _db.delete(_db.dailyArenaLogs).go();
      await _db.delete(_db.storyChapters).go();
      await _db.delete(_db.storyRuns).go();
      await _db.delete(_db.heroes).go();
      await _db.delete(_db.exercises).go();

      // Ensure catalog exercises always exist for any referenced foreign keys.
      await _db.batch((b) {
        b.insertAll(
          _db.exercises,
          [
            for (final item in ExerciseSeed.defaultExercises)
              ExercisesCompanion.insert(
                id: item.id,
                name: item.name,
                muscleGroup: item.muscle,
                equipment: item.equipment,
                attribute: item.attribute,
                tracking: Value(item.tracking),
              ),
          ],
          mode: InsertMode.insertOrReplace,
        );
        if (exerciseRows.isNotEmpty) {
          b.insertAll(
            _db.exercises,
            exerciseRows,
            mode: InsertMode.insertOrReplace,
          );
        }
        if (heroesRows.isNotEmpty) b.insertAll(_db.heroes, heroesRows);
        if (routineRows.isNotEmpty) b.insertAll(_db.routines, routineRows);
        if (routineExRows.isNotEmpty) {
          b.insertAll(_db.routineExercises, routineExRows);
        }
        if (sessionRows.isNotEmpty) {
          b.insertAll(_db.workoutSessions, sessionRows);
        }
        if (setRows.isNotEmpty) b.insertAll(_db.workoutSets, setRows);
        if (recordRows.isNotEmpty) b.insertAll(_db.personalRecords, recordRows);
        if (activityRows.isNotEmpty) b.insertAll(_db.activities, activityRows);
        if (ledgerRows.isNotEmpty) b.insertAll(_db.xpLedger, ledgerRows);
        if (questRows.isNotEmpty) b.insertAll(_db.dailyQuestsTable, questRows);
        if (healthRows.isNotEmpty) b.insertAll(_db.dailyHealthLogs, healthRows);
        if (arenaProgressRows.isNotEmpty) {
          b.insertAll(_db.arenaProgress, arenaProgressRows);
        }
        if (arenaLogRows.isNotEmpty) {
          b.insertAll(_db.dailyArenaLogs, arenaLogRows);
        }
        if (storyRunRows.isNotEmpty) {
          b.insertAll(_db.storyRuns, storyRunRows);
        }
        if (storyChapterRows.isNotEmpty) {
          b.insertAll(_db.storyChapters, storyChapterRows);
        }
      });
    });

    final settingsJson = root['settings'];
    if (settingsJson is Map<String, dynamic>) {
      final fontName = settingsJson['fontStyle'] as String?;
      final fontStyle = AppFontStyle.values.firstWhere(
        (e) => e.name == fontName,
        orElse: () => AppFontStyle.pixel,
      );
      return AppSettings(
        languageCode: settingsJson['languageCode'] as String?,
        fontStyle: fontStyle,
        soundEnabled: (settingsJson['soundEnabled'] as bool?) ?? true,
      );
    }
    return null;
  }

  Map<String, dynamic> _decodeRoot(String rawJson) {
    final decoded = jsonDecode(rawJson.trim());
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid backup root object.');
    }
    final formatVersion = (decoded['formatVersion'] as num?)?.toInt();
    final tables = decoded['tables'];
    if (formatVersion == null ||
        formatVersion > currentFormatVersion ||
        tables is! Map<String, dynamic>) {
      throw const FormatException('Unsupported backup format.');
    }
    return decoded;
  }

  List<Map<String, dynamic>> _readList(
    Map<String, dynamic> tables,
    String key,
  ) {
    final raw = tables[key];
    if (raw == null) return const [];
    if (raw is! List<dynamic>) {
      throw FormatException('Invalid table "$key" in backup.');
    }
    return raw.cast<Map<String, dynamic>>();
  }
}
