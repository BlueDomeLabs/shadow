// test/unit/data/migrations/v21_to_v22_migration_test.dart
// Verifies v21 → v22 migration adds default_input_mode column to
// voice_logging_settings with correct default value of 0.
//
// Strategy: fresh in-memory DB uses onCreate (wasCreated=true), which calls
// createAll() and creates all tables with v22 schema. We verify the new column
// exists and has the correct default.

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';

void main() {
  group('v21 → v22 migration schema', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    Future<List<String>> columnNames(String table) async {
      final result = await database
          .customSelect('PRAGMA table_info($table)')
          .get();
      return result.map((r) => r.data['name'] as String).toList();
    }

    test('voice_logging_settings_hasDefaultInputModeColumn', () async {
      final cols = await columnNames('voice_logging_settings');
      expect(cols, contains('default_input_mode'));
    });

    test('default_input_mode_defaultsToZero', () async {
      await database.customStatement('''
          INSERT INTO voice_logging_settings
          (id, profile_id, closing_style, created_at)
          VALUES ('p1', 'p1', 1, 1700000000000)
      ''');
      final result = await database
          .customSelect('SELECT default_input_mode FROM voice_logging_settings')
          .getSingle();
      expect(result.data['default_input_mode'], 0);
    });

    test('currentSchemaVersion_is22', () async {
      expect(database.schemaVersion, 22);
    });
  });
}
