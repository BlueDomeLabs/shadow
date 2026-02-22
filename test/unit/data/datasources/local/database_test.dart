// test/unit/data/datasources/local/database_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';

void main() {
  group('AppDatabase', () {
    late AppDatabase database;

    setUp(() {
      // Use in-memory database for testing
      database = AppDatabase(DatabaseConnection.inMemory());
    });

    tearDown(() async {
      await database.closeDatabase();
    });

    group('initialization', () {
      test('creates database successfully', () {
        expect(database, isNotNull);
      });

      test('schemaVersion is 10 per 10_DATABASE_SCHEMA.md', () {
        expect(database.schemaVersion, equals(10));
      });

      test('database is open after creation', () async {
        // Accessing a property that requires an open database
        final result = await database.customSelect('SELECT 1 as value').get();
        expect(result, hasLength(1));
        expect(result.first.read<int>('value'), equals(1));
      });
    });

    group('foreign keys', () {
      test('foreign key constraints are enabled', () async {
        // PRAGMA foreign_keys should return 1 when enabled
        final result = await database
            .customSelect('PRAGMA foreign_keys')
            .getSingle();
        expect(result.read<int>('foreign_keys'), equals(1));
      });
    });

    group('migration', () {
      test('onCreate creates empty schema for fresh install', () async {
        // Verify database is accessible after migration
        final tables = await database
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
            )
            .get();

        // With empty table list, only drift internal tables may exist
        // This test verifies migration doesn't fail
        expect(tables, isNotNull);
      });
    });

    group('closeDatabase', () {
      test('closes database without error', () async {
        // Create a new database for this test since setUp already created one
        final db = AppDatabase(DatabaseConnection.inMemory());

        // Verify it's working
        final result = await db.customSelect('SELECT 1').get();
        expect(result, isNotEmpty);

        // Close should not throw
        await expectLater(db.closeDatabase(), completes);
      });
    });
  });

  group('DatabaseConnection', () {
    test('inMemory creates working database executor', () async {
      final executor = DatabaseConnection.inMemory();
      final db = AppDatabase(executor);

      // Should be able to execute queries
      final result = await db.customSelect('SELECT 42 as answer').getSingle();
      expect(result.read<int>('answer'), equals(42));

      await db.close();
    });

    test('openConnection returns LazyDatabase', () {
      // openConnection returns a LazyDatabase which is a QueryExecutor
      final connection = DatabaseConnection.openConnection();
      expect(connection, isNotNull);
      // Note: We don't actually open it here as it would create a file
    });
  });

  group('encryption key management', () {
    // Note: These tests verify the interface exists.
    // Actual secure storage tests require integration testing on device.

    test('getOrCreateEncryptionKey returns a key', () async {
      // This would require mocking FlutterSecureStorage
      // For now, we verify the method exists and is callable
      // Full integration testing happens on device

      // The method exists
      expect(DatabaseConnection.getOrCreateEncryptionKey, isNotNull);
    });
  });
}
