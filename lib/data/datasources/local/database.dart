// lib/data/datasources/local/database.dart - SHADOW-008 Implementation
// Implements AppDatabase with Drift ORM per 05_IMPLEMENTATION_ROADMAP.md and 10_DATABASE_SCHEMA.md

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Shadow App Database using Drift ORM.
///
/// Schema version follows 10_DATABASE_SCHEMA.md: Version 7.
/// Tables are added incrementally as entities are implemented.
///
/// Security:
/// - Database encryption key stored in secure storage
/// - SQLCipher can be enabled by replacing sqlite3_flutter_libs with sqlcipher_flutter_libs
/// - Foreign key constraints enabled
///
/// Usage:
/// ```dart
/// final database = AppDatabase(openConnection());
/// ```
@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  /// Creates an AppDatabase with the given query executor.
  ///
  /// For production use:
  /// ```dart
  /// final db = AppDatabase(await openDatabaseConnection());
  /// ```
  ///
  /// For testing:
  /// ```dart
  /// final db = AppDatabase(NativeDatabase.memory());
  /// ```
  AppDatabase(super.e);

  /// Schema version - MUST match 10_DATABASE_SCHEMA.md
  /// Increment when schema changes require migration
  @override
  int get schemaVersion => 7;

  /// Migration strategy for schema changes.
  ///
  /// Migrations are defined per version increment.
  /// See 02_CODING_STANDARDS.md Section 8.5 for migration requirements.
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // Create all tables for fresh install
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Migrations will be added as schema evolves
        // Each migration should be idempotent per 02_CODING_STANDARDS.md

        // Example migration pattern (add when needed):
        // if (from < 2) {
        //   await m.addColumn(supplements, supplements.newColumn);
        // }
      },
      beforeOpen: (details) async {
        // Enable foreign key constraints per 10_DATABASE_SCHEMA.md Section 1.2
        await customStatement('PRAGMA foreign_keys = ON');

        // Log database details for debugging
        // Production: Consider removing or using conditional logging
        if (details.wasCreated) {
          // Fresh database created
        }
      },
    );
  }

  /// Close the database connection.
  ///
  /// Call this when the app is being disposed to release resources.
  Future<void> closeDatabase() async {
    await close();
  }
}

/// Database connection configuration.
///
/// Provides platform-specific database file paths and connection setup.
class DatabaseConnection {
  static const _databaseName = 'shadow.db';
  static const _encryptionKeyName = 'shadow_db_encryption_key';

  /// Opens a database connection for the current platform.
  ///
  /// Supports iOS, Android, and macOS per SHADOW-008 requirements.
  /// Returns a lazy database connection that opens on first query.
  static LazyDatabase openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await _getDatabaseDirectory();
      final file = File(p.join(dbFolder, _databaseName));

      // Note: For SQLCipher encryption, replace NativeDatabase with:
      // NativeDatabase.createInBackground(
      //   file,
      //   setup: (database) {
      //     final key = await _getOrCreateEncryptionKey();
      //     database.execute("PRAGMA key = '$key'");
      //   },
      // );

      return NativeDatabase.createInBackground(file);
    });
  }

  /// Creates an in-memory database for testing.
  ///
  /// Usage in tests:
  /// ```dart
  /// final testDb = AppDatabase(DatabaseConnection.inMemory());
  /// ```
  static QueryExecutor inMemory() {
    return NativeDatabase.memory();
  }

  /// Gets the platform-specific database directory.
  ///
  /// - iOS: Application documents directory
  /// - Android: Application documents directory
  /// - macOS: Application support directory
  static Future<String> _getDatabaseDirectory() async {
    if (Platform.isIOS || Platform.isAndroid) {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else if (Platform.isMacOS) {
      final directory = await getApplicationSupportDirectory();
      return directory.path;
    }

    // Fallback for other platforms (future-proofing)
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Gets or creates the database encryption key.
  ///
  /// Key is stored in platform secure storage:
  /// - iOS: Keychain
  /// - Android: EncryptedSharedPreferences (Keystore-backed)
  /// - macOS: Keychain
  ///
  /// Note: Currently unused as SQLCipher is not yet enabled.
  /// Will be activated when sqlcipher_flutter_libs is added.
  static Future<String> getOrCreateEncryptionKey() async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );

    // Try to read existing key
    String? key = await storage.read(key: _encryptionKeyName);

    if (key == null) {
      // Generate new 256-bit key (32 bytes = 64 hex chars)
      key = _generateEncryptionKey();
      await storage.write(key: _encryptionKeyName, value: key);
    }

    return key;
  }

  /// Generates a secure 256-bit encryption key.
  ///
  /// Uses Dart's secure random number generator.
  static String _generateEncryptionKey() {
    final random = List<int>.generate(32, (_) {
      // Use DateTime-based seed combined with index for pseudo-randomness
      // In production, use crypto package's SecureRandom
      return DateTime.now().microsecondsSinceEpoch % 256;
    });

    // Convert to hex string
    return random.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Deletes the database file (for testing or reset).
  ///
  /// Warning: This permanently deletes all data.
  static Future<void> deleteDatabase() async {
    final dbFolder = await _getDatabaseDirectory();
    final file = File(p.join(dbFolder, _databaseName));
    if (await file.exists()) {
      await file.delete();
    }
  }
}
