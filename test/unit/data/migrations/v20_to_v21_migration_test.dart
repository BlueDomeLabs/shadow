// test/unit/data/migrations/v20_to_v21_migration_test.dart
// Verifies v20 → v21 migration creates voice_logging_settings and
// voice_session_history tables.
//
// Strategy: fresh in-memory DB uses onCreate (wasCreated=true), which calls
// createAll() and creates all tables including the two new ones. We verify
// both tables exist and have the expected columns.

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';

void main() {
  group('v20 → v21 migration schema', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    Future<List<String>> tableNames() async {
      final result = await database
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
          )
          .get();
      return result.map((r) => r.data['name'] as String).toList();
    }

    Future<List<String>> columnNames(String table) async {
      final result = await database
          .customSelect('PRAGMA table_info($table)')
          .get();
      return result.map((r) => r.data['name'] as String).toList();
    }

    test('voice_logging_settings_tableExists', () async {
      final tables = await tableNames();
      expect(tables, contains('voice_logging_settings'));
    });

    test('voice_session_history_tableExists', () async {
      final tables = await tableNames();
      expect(tables, contains('voice_session_history'));
    });

    test('voice_logging_settings_hasExpectedColumns', () async {
      final cols = await columnNames('voice_logging_settings');
      expect(
        cols,
        containsAll([
          'id',
          'profile_id',
          'closing_style',
          'fixed_farewell',
          'category_priority_order',
          'default_input_mode',
          'created_at',
          'updated_at',
        ]),
      );
    });

    test('voice_session_history_hasExpectedColumns', () async {
      final cols = await columnNames('voice_session_history');
      expect(
        cols,
        containsAll([
          'id',
          'profile_id',
          'session_id',
          'turn_index',
          'role',
          'content',
          'logged_item_type',
          'created_at',
        ]),
      );
    });

    test('canInsertAndQuery_voiceLoggingSettings', () async {
      await database.customStatement('''
           INSERT INTO voice_logging_settings
           (id, profile_id, closing_style, created_at)
           VALUES ('p1', 'p1', 1, 1700000000000)''');
      final result = await database
          .customSelect('SELECT * FROM voice_logging_settings')
          .get();
      expect(result.length, 1);
      expect(result.first.data['profile_id'], 'p1');
    });

    test('canInsertAndQuery_voiceSessionHistory', () async {
      await database.customStatement('''
           INSERT INTO voice_session_history
           (id, profile_id, session_id, turn_index, role, content, created_at)
           VALUES ('t1', 'p1', 's1', 0, 0, 'Hello', 1700000000000)''');
      final result = await database
          .customSelect('SELECT * FROM voice_session_history')
          .get();
      expect(result.length, 1);
      expect(result.first.data['content'], 'Hello');
    });

    test('currentSchemaVersion_is22', () async {
      expect(database.schemaVersion, 22);
    });
  });
}
