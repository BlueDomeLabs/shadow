// lib/data/datasources/local/database.dart - SHADOW-008 Implementation
// Implements AppDatabase with Drift ORM and SQLCipher encryption
// per 05_IMPLEMENTATION_ROADMAP.md and 10_DATABASE_SCHEMA.md

import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shadow_app/data/datasources/local/daos/activity_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/activity_log_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/condition_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/condition_log_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/fluids_entry_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/food_item_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/food_log_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/intake_log_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/sleep_entry_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/supplement_dao.dart';
import 'package:shadow_app/data/datasources/local/tables/activities_table.dart';
import 'package:shadow_app/data/datasources/local/tables/activity_logs_table.dart';
import 'package:shadow_app/data/datasources/local/tables/condition_logs_table.dart';
import 'package:shadow_app/data/datasources/local/tables/conditions_table.dart';
import 'package:shadow_app/data/datasources/local/tables/fluids_entries_table.dart';
import 'package:shadow_app/data/datasources/local/tables/food_items_table.dart';
import 'package:shadow_app/data/datasources/local/tables/food_logs_table.dart';
import 'package:shadow_app/data/datasources/local/tables/intake_logs_table.dart';
import 'package:shadow_app/data/datasources/local/tables/sleep_entries_table.dart';
import 'package:shadow_app/data/datasources/local/tables/supplements_table.dart';
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

/// Shadow App Database using Drift ORM with SQLCipher AES-256 encryption.
///
/// Schema version follows 10_DATABASE_SCHEMA.md: Version 7.
/// Tables are added incrementally as entities are implemented.
///
/// Security:
/// - AES-256 encryption via SQLCipher
/// - Encryption key stored in platform secure storage (Keychain/KeyStore)
/// - Foreign key constraints enabled
///
/// Usage:
/// ```dart
/// final database = AppDatabase(await DatabaseConnection.openConnection());
/// ```
@DriftDatabase(
  tables: [
    Supplements,
    IntakeLogs,
    Conditions,
    ConditionLogs,
    FluidsEntries,
    SleepEntries,
    Activities,
    ActivityLogs,
    FoodItems,
    FoodLogs,
  ],
  daos: [
    SupplementDao,
    IntakeLogDao,
    ConditionDao,
    ConditionLogDao,
    FluidsEntryDao,
    SleepEntryDao,
    ActivityDao,
    ActivityLogDao,
    FoodItemDao,
    FoodLogDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates an AppDatabase with the given query executor.
  ///
  /// For production use:
  /// ```dart
  /// final db = AppDatabase(await DatabaseConnection.openConnection());
  /// ```
  ///
  /// For testing:
  /// ```dart
  /// final db = AppDatabase(DatabaseConnection.inMemory());
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
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // Create all tables for fresh install
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
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
    },
  );

  /// Close the database connection.
  ///
  /// Call this when the app is being disposed to release resources.
  Future<void> closeDatabase() async {
    await close();
  }
}

/// Database connection configuration with SQLCipher encryption.
///
/// Provides platform-specific database file paths and encrypted connection setup.
/// Per 10_DATABASE_SCHEMA.md Section 1.1: SQLCipher with AES-256 encryption.
class DatabaseConnection {
  static const _databaseName = 'shadow.db';
  static const _encryptionKeyName = 'shadow_db_encryption_key';

  /// Opens an encrypted database connection for the current platform.
  ///
  /// Supports iOS, Android, and macOS per SHADOW-008 requirements.
  /// Uses SQLCipher for AES-256 encryption with key stored in secure storage.
  ///
  /// Returns a lazy database connection that opens on first query.
  static LazyDatabase openConnection() => LazyDatabase(() async {
    final dbFolder = await _getDatabaseDirectory();
    final file = File(p.join(dbFolder, _databaseName));
    final encryptionKey = await getOrCreateEncryptionKey();

    return NativeDatabase.createInBackground(
      file,
      setup: (database) {
        // Apply SQLCipher encryption key
        // Per 10_DATABASE_SCHEMA.md: AES-256 encryption
        database.execute("PRAGMA key = '$encryptionKey'");
      },
    );
  });

  /// Opens an encrypted database connection synchronously.
  ///
  /// Use this when you already have the encryption key.
  /// Prefer [openConnection] for lazy initialization.
  static NativeDatabase openConnectionSync(String encryptionKey) {
    // This is for cases where async initialization is not possible
    // In most cases, use openConnection() instead
    throw UnimplementedError(
      'Use openConnection() for async initialization with secure key storage',
    );
  }

  /// Creates an in-memory database for testing.
  ///
  /// Note: In-memory databases use a fixed test key for encryption
  /// to verify SQLCipher is working correctly.
  ///
  /// Usage in tests:
  /// ```dart
  /// final testDb = AppDatabase(DatabaseConnection.inMemory());
  /// ```
  static QueryExecutor inMemory() => NativeDatabase.memory(
    setup: (database) {
      // Use a fixed key for testing - NOT for production
      database.execute("PRAGMA key = 'test_encryption_key_for_unit_tests'");
    },
  );

  /// Creates an unencrypted in-memory database for testing.
  ///
  /// Use this only when testing non-encryption-related functionality
  /// and SQLCipher setup causes issues.
  static QueryExecutor inMemoryUnencrypted() => NativeDatabase.memory();

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
  /// Per 10_DATABASE_SCHEMA.md: 256-bit (32 bytes) key stored in Keychain/KeyStore.
  static Future<String> getOrCreateEncryptionKey() async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );

    // Try to read existing key
    var key = await storage.read(key: _encryptionKeyName);

    if (key == null) {
      // Generate new 256-bit key (32 bytes = 64 hex chars)
      key = _generateSecureKey();
      await storage.write(key: _encryptionKeyName, value: key);
    }

    return key;
  }

  /// Generates a cryptographically secure 256-bit encryption key.
  ///
  /// Uses Dart's secure random number generator for key generation.
  /// Returns a 64-character hex string (32 bytes = 256 bits).
  static String _generateSecureKey() {
    final secureRandom = Random.secure();
    final keyBytes = List<int>.generate(32, (_) => secureRandom.nextInt(256));
    return keyBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Deletes the database file (for testing or reset).
  ///
  /// Warning: This permanently deletes all data.
  /// The encryption key in secure storage is NOT deleted.
  static Future<void> deleteDatabase() async {
    final dbFolder = await _getDatabaseDirectory();
    final file = File(p.join(dbFolder, _databaseName));
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Deletes both the database file and the encryption key.
  ///
  /// Warning: This permanently deletes all data and the key.
  /// A new key will be generated on next database open.
  static Future<void> deleteDatabaseAndKey() async {
    await deleteDatabase();

    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    await storage.delete(key: _encryptionKeyName);
  }

  /// Verifies that SQLCipher encryption is active.
  ///
  /// Returns true if the database is using SQLCipher encryption.
  /// Useful for debugging and verification.
  static Future<bool> verifyEncryption(Database database) async {
    try {
      final result = database.select('PRAGMA cipher_version');
      // If cipher_version returns a value, SQLCipher is active
      return result.isNotEmpty && result.first['cipher_version'] != null;
    } on Exception {
      // If the pragma fails, SQLCipher is not available
      return false;
    }
  }
}
