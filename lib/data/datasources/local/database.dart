// lib/data/datasources/local/database.dart - SHADOW-008 Implementation
// Implements AppDatabase with Drift ORM and SQLCipher encryption
// per 05_IMPLEMENTATION_ROADMAP.md and 10_DATABASE_SCHEMA.md

import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shadow_app/data/datasources/local/daos/activity_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/activity_log_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/anchor_event_time_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/condition_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/condition_log_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_exception_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_rule_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_violation_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/fasting_session_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/flare_up_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/fluids_entry_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/food_barcode_cache_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/food_item_component_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/food_item_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/food_log_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/guest_invite_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/health_sync_settings_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/health_sync_status_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/imported_vital_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/intake_log_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/journal_entry_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/notification_category_settings_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/photo_area_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/photo_entry_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/profile_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/sleep_entry_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/supplement_barcode_cache_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/supplement_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/supplement_label_photo_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/sync_conflict_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/user_settings_dao.dart';
import 'package:shadow_app/data/datasources/local/tables/activities_table.dart';
import 'package:shadow_app/data/datasources/local/tables/activity_logs_table.dart';
import 'package:shadow_app/data/datasources/local/tables/anchor_event_times_table.dart';
import 'package:shadow_app/data/datasources/local/tables/condition_logs_table.dart';
import 'package:shadow_app/data/datasources/local/tables/conditions_table.dart';
import 'package:shadow_app/data/datasources/local/tables/diet_exceptions_table.dart';
import 'package:shadow_app/data/datasources/local/tables/diet_rules_table.dart';
import 'package:shadow_app/data/datasources/local/tables/diet_violations_table.dart';
import 'package:shadow_app/data/datasources/local/tables/diets_table.dart';
import 'package:shadow_app/data/datasources/local/tables/fasting_sessions_table.dart';
import 'package:shadow_app/data/datasources/local/tables/flare_ups_table.dart';
import 'package:shadow_app/data/datasources/local/tables/fluids_entries_table.dart';
import 'package:shadow_app/data/datasources/local/tables/food_barcode_cache_table.dart';
import 'package:shadow_app/data/datasources/local/tables/food_item_components_table.dart';
import 'package:shadow_app/data/datasources/local/tables/food_items_table.dart';
import 'package:shadow_app/data/datasources/local/tables/food_logs_table.dart';
import 'package:shadow_app/data/datasources/local/tables/guest_invites_table.dart';
import 'package:shadow_app/data/datasources/local/tables/health_sync_settings_table.dart';
import 'package:shadow_app/data/datasources/local/tables/health_sync_status_table.dart';
import 'package:shadow_app/data/datasources/local/tables/imported_vitals_table.dart';
import 'package:shadow_app/data/datasources/local/tables/intake_logs_table.dart';
import 'package:shadow_app/data/datasources/local/tables/journal_entries_table.dart';
import 'package:shadow_app/data/datasources/local/tables/notification_category_settings_table.dart';
import 'package:shadow_app/data/datasources/local/tables/photo_areas_table.dart';
import 'package:shadow_app/data/datasources/local/tables/photo_entries_table.dart';
import 'package:shadow_app/data/datasources/local/tables/profiles_table.dart';
import 'package:shadow_app/data/datasources/local/tables/sleep_entries_table.dart';
import 'package:shadow_app/data/datasources/local/tables/supplement_barcode_cache_table.dart';
import 'package:shadow_app/data/datasources/local/tables/supplement_label_photos_table.dart';
import 'package:shadow_app/data/datasources/local/tables/supplements_table.dart';
import 'package:shadow_app/data/datasources/local/tables/sync_conflicts_table.dart';
import 'package:shadow_app/data/datasources/local/tables/user_settings_table.dart';
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
    FlareUps,
    FluidsEntries,
    SleepEntries,
    Activities,
    ActivityLogs,
    FoodItems,
    FoodItemComponents,
    FoodBarcodeCache,
    FoodLogs,
    JournalEntries,
    PhotoAreas,
    PhotoEntries,
    Profiles,
    GuestInvites,
    SupplementLabelPhotos,
    SupplementBarcodeCache,
    SyncConflicts,
    AnchorEventTimes,
    NotificationCategorySettings,
    UserSettingsTable,
    Diets,
    DietRules,
    DietExceptions,
    FastingSessions,
    DietViolations,
    ImportedVitals,
    HealthSyncSettingsTable,
    HealthSyncStatusTable,
  ],
  daos: [
    SupplementDao,
    IntakeLogDao,
    ConditionDao,
    ConditionLogDao,
    FlareUpDao,
    FluidsEntryDao,
    SleepEntryDao,
    ActivityDao,
    ActivityLogDao,
    FoodItemDao,
    FoodItemComponentDao,
    FoodBarcodeCacheDao,
    FoodLogDao,
    JournalEntryDao,
    PhotoAreaDao,
    PhotoEntryDao,
    ProfileDao,
    GuestInviteDao,
    SupplementLabelPhotoDao,
    SupplementBarcodeCacheDao,
    SyncConflictDao,
    AnchorEventTimeDao,
    NotificationCategorySettingsDao,
    UserSettingsDao,
    DietDao,
    DietRuleDao,
    DietExceptionDao,
    FastingSessionDao,
    DietViolationDao,
    ImportedVitalDao,
    HealthSyncSettingsDao,
    HealthSyncStatusDao,
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
  /// v8: Added sync_conflicts table (Phase 4b — conflict handling)
  /// v9: Added custom_dosage_unit column to supplements table
  /// v10: Added profiles table (Phase 11)
  /// v11: Added guest_invites table (Phase 12a)
  /// v12: Added anchor_event_times and notification_category_settings tables (Phase 13a)
  /// v13: Added user_settings table (Phase 14)
  /// v14: Food Database Extension + Supplement Extension (Phase 15a)
  ///      Added food_item_components, food_barcode_cache, supplement_label_photos,
  ///      supplement_barcode_cache tables. Added columns to food_items and supplements.
  /// v15: Diet Tracking data foundation (Phase 15b-1)
  ///      Added diets, diet_rules, diet_exceptions, fasting_sessions,
  ///      diet_violations tables. Added violation_flag column to food_logs.
  /// v16: Health Platform Integration data foundation (Phase 16a)
  ///      Added imported_vitals, health_sync_settings, health_sync_status tables.
  /// v17: AnchorEventName enum expansion 5→8 values (Phase 19)
  ///      Re-indexed lunch(2→3), dinner(3→5), bedtime(4→7). Added morning(2),
  ///      afternoon(4), evening(6). Migrated anchor_event_times.name and
  ///      notification_category_settings.anchor_event_values.
  @override
  int get schemaVersion => 17;

  /// Migration strategy for schema changes.
  ///
  /// Migrations are defined per version increment.
  /// See 02_CODING_STANDARDS.md Section 8.5 for migration requirements.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // Create all tables for fresh install
      try {
        await m.createAll();
        debugPrint('[Shadow DB] onCreate: All tables created successfully');
      } on Exception catch (e, stack) {
        debugPrint('[Shadow DB] onCreate FAILED: $e');
        debugPrint('[Shadow DB] Stack trace: $stack');
        rethrow;
      }
    },
    onUpgrade: (m, from, to) async {
      // Each migration is idempotent per 02_CODING_STANDARDS.md Section 8.5

      // v8: Add sync_conflicts table for Phase 4 conflict handling
      if (from < 8) {
        await m.createTable(syncConflicts);
      }

      // v9: Add custom_dosage_unit column to supplements
      if (from < 9) {
        await m.addColumn(supplements, supplements.customDosageUnit);
      }

      // v10: Add profiles table (Phase 11)
      if (from < 10) {
        await m.createTable(profiles);
      }

      // v11: Add guest_invites table (Phase 12a)
      if (from < 11) {
        await m.createTable(guestInvites);
      }

      // v12: Add notification tables (Phase 13a)
      if (from < 12) {
        await m.createTable(anchorEventTimes);
        await m.createTable(notificationCategorySettings);
      }

      // v13: Add user_settings table (Phase 14)
      if (from < 13) {
        await m.createTable(userSettingsTable);
      }

      // v14: Food Database Extension + Supplement Extension (Phase 15a)
      if (from < 14) {
        // Add new columns to food_items
        await m.addColumn(foodItems, foodItems.sodiumMg);
        await m.addColumn(foodItems, foodItems.barcode);
        await m.addColumn(foodItems, foodItems.brand);
        await m.addColumn(foodItems, foodItems.ingredientsText);
        await m.addColumn(foodItems, foodItems.openFoodFactsId);
        await m.addColumn(foodItems, foodItems.importSource);
        await m.addColumn(foodItems, foodItems.imageUrl);
        // Add new columns to supplements
        await m.addColumn(supplements, supplements.source);
        await m.addColumn(supplements, supplements.pricePaid);
        await m.addColumn(supplements, supplements.barcode);
        await m.addColumn(supplements, supplements.importSource);
        // Create new tables
        await m.createTable(foodItemComponents);
        await m.createTable(foodBarcodeCache);
        await m.createTable(supplementLabelPhotos);
        await m.createTable(supplementBarcodeCache);
        // Data migration: copy existing simpleItemIds JSON → food_item_components
        // with quantity=1.0 for each existing composed item component.
        // Uses raw SQL since Drift migration doesn't support complex read+insert.
        await customStatement('''
          INSERT INTO food_item_components (id, composed_food_item_id, simple_food_item_id, quantity, sort_order)
          SELECT
            lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' ||
            substr(lower(hex(randomblob(2))),2) || '-' ||
            substr('89ab',abs(random()) % 4 + 1, 1) ||
            substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))) AS id,
            fi.id AS composed_food_item_id,
            json_each.value AS simple_food_item_id,
            1.0 AS quantity,
            (json_each.key) AS sort_order
          FROM food_items fi, json_each(fi.simple_item_ids)
          WHERE fi.type = 1
            AND fi.simple_item_ids IS NOT NULL
            AND fi.simple_item_ids != '[]'
            AND fi.simple_item_ids != ''
        ''');
      }

      // v15: Diet Tracking data foundation (Phase 15b-1)
      if (from < 15) {
        // Add violation_flag column to food_logs
        await m.addColumn(foodLogs, foodLogs.violationFlag);
        // Create new diet tracking tables
        await m.createTable(diets);
        await m.createTable(dietRules);
        await m.createTable(dietExceptions);
        await m.createTable(fastingSessions);
        await m.createTable(dietViolations);
      }

      // v16: Health Platform Integration data foundation (Phase 16a)
      if (from < 16) {
        await m.createTable(importedVitals);
        await m.createTable(healthSyncSettingsTable);
        await m.createTable(healthSyncStatusTable);
      }

      // v17: AnchorEventName enum re-index (Phase 19)
      // Existing integer values: lunch=2, dinner=3, bedtime=4
      // New integer values:      lunch=3, dinner=5, bedtime=7
      // Run in reverse order (bedtime first) to avoid collision.
      if (from < 17) {
        // Migrate anchor_event_times.name (integer column)
        await customStatement(
          'UPDATE anchor_event_times SET name = 7 WHERE name = 4',
        );
        await customStatement(
          'UPDATE anchor_event_times SET name = 5 WHERE name = 3',
        );
        await customStatement(
          'UPDATE anchor_event_times SET name = 3 WHERE name = 2',
        );

        // Migrate notification_category_settings.anchor_event_values (JSON text column).
        // Values 2, 3, 4 may appear as array elements; handle all boundary positions
        // ([N], [N,, ,N], ,N,) to avoid partial-number replacement.
        // Apply in reverse order: bedtime(4→7), dinner(3→5), lunch(2→3).
        for (final step in [
          (old: '4', replacement: '7'),
          (old: '3', replacement: '5'),
          (old: '2', replacement: '3'),
        ]) {
          await customStatement(
            '''UPDATE notification_category_settings SET anchor_event_values = REPLACE(REPLACE(REPLACE(REPLACE(anchor_event_values, '[${step.old}]', '[${step.replacement}]'), '[${step.old},', '[${step.replacement},'), ',${step.old}]', ',${step.replacement}]'), ',${step.old},', ',${step.replacement},') WHERE anchor_event_values LIKE '%${step.old}%' ''',
          );
        }
      }
    },
    beforeOpen: (details) async {
      debugPrint(
        '[Shadow DB] beforeOpen: version=${details.versionNow}, '
        'wasCreated=${details.wasCreated}, '
        'hadUpgrade=${details.hadUpgrade}',
      );
      // Enable foreign key constraints per 10_DATABASE_SCHEMA.md Section 1.2
      try {
        await customStatement('PRAGMA foreign_keys = ON');
        debugPrint('[Shadow DB] Foreign keys enabled');
      } on Exception catch (e, stack) {
        debugPrint('[Shadow DB] PRAGMA foreign_keys FAILED: $e');
        debugPrint('[Shadow DB] This may indicate SQLCipher key mismatch');
        debugPrint('[Shadow DB] Stack trace: $stack');
        rethrow;
      }
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

    debugPrint('[Shadow DB] Database path: ${file.path}');
    debugPrint('[Shadow DB] Database file exists: ${file.existsSync()}');

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
      mOptions: MacOsOptions(
        accessibility: KeychainAccessibility.first_unlock,
        useDataProtectionKeyChain: false,
      ),
    );

    // Try to read existing key
    var key = await storage.read(key: _encryptionKeyName);

    if (key == null) {
      // Generate new 256-bit key (32 bytes = 64 hex chars)
      key = _generateSecureKey();
      await storage.write(key: _encryptionKeyName, value: key);
      debugPrint('[Shadow DB] Generated new encryption key');
    } else {
      debugPrint(
        '[Shadow DB] Using existing encryption key from secure storage',
      );
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
      mOptions: MacOsOptions(
        accessibility: KeychainAccessibility.first_unlock,
        useDataProtectionKeyChain: false,
      ),
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
