// test/unit/data/migrations/v19_to_v20_migration_test.dart
// Verifies v19 → v20 migration SQL per FLUIDS_RESTRUCTURING_SPEC.md Section 6.
//
// Strategy: fresh in-memory DBs run onCreate, not onUpgrade. To test migration
// SQL correctness, we seed fluids_entries then manually run the migration
// INSERT...SELECT statements and verify bodily_output_logs results.

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';

void main() {
  group('v19 → v20 migration SQL', () {
    late AppDatabase database;

    // UUID expression matching the one in database.dart migration
    const uuidExpr =
        "lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || "
        "substr(lower(hex(randomblob(2))),2) || '-' || "
        "substr('89ab', abs(random()) % 4 + 1, 1) || "
        "substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))";

    /// Seeds a fluids_entries row with the given values.
    /// Uses raw SQL since Drift generates code for v20 schema only.
    /// notes defaults to '' to satisfy the NOT NULL constraint with default.
    Future<void> seedFluidsEntry(
      AppDatabase db, {
      required String id,
      required String profileId,
      int? hasBowelMovement,
      int? bowelCondition,
      int? bowelSize,
      String? bowelPhotoPath,
      int? hasUrineMovement,
      int? urineCondition,
      int? urineSize,
      String? urinePhotoPath,
      int? menstruationFlow,
      double? basalBodyTemperature,
      int? bbtRecordedTime,
      String? otherFluidName,
      String? otherFluidAmount,
      String? otherFluidNotes,
      String? notes,
      int? waterIntakeMl,
    }) async {
      await db.customStatement(
        '''
        INSERT INTO fluids_entries (
          id, client_id, profile_id, entry_date,
          has_bowel_movement, bowel_condition, bowel_size, bowel_photo_path,
          has_urine_movement, urine_condition, urine_size, urine_photo_path,
          menstruation_flow,
          basal_body_temperature, bbt_recorded_time,
          other_fluid_name, other_fluid_amount, other_fluid_notes,
          notes, water_intake_ml,
          sync_created_at, sync_updated_at, sync_status, sync_version, sync_is_dirty
        ) VALUES (
          ?, 'client-001', ?, 1700000000000,
          ?, ?, ?, ?,
          ?, ?, ?, ?,
          ?,
          ?, ?,
          ?, ?, ?,
          ?, ?,
          1700000000000, 1700000000000, 0, 1, 1
        )
      ''',
        [
          id,
          profileId,
          hasBowelMovement ?? 0,
          bowelCondition,
          bowelSize,
          bowelPhotoPath,
          hasUrineMovement ?? 0,
          urineCondition,
          urineSize,
          urinePhotoPath,
          menstruationFlow,
          basalBodyTemperature,
          bbtRecordedTime,
          otherFluidName,
          otherFluidAmount,
          otherFluidNotes,
          notes ?? '',
          waterIntakeMl,
        ],
      );
    }

    /// Runs the v20 migration INSERT...SELECT statements against the live DB.
    /// This simulates what Drift would run during onUpgrade(from: 19, to: 20).
    Future<void> runMigrationSql(AppDatabase db) async {
      // 2a: Bowel movements
      await db.customStatement('''
        INSERT INTO bodily_output_logs (
          id, client_id, profile_id, occurred_at,
          output_type, bowel_condition, bowel_size,
          photo_path, notes,
          sync_created_at, sync_status, sync_is_dirty,
          sync_version
        )
        SELECT
          $uuidExpr, client_id, profile_id, entry_date,
          1, bowel_condition, bowel_size,
          bowel_photo_path, notes,
          sync_created_at, 0, 1,
          1
        FROM fluids_entries
        WHERE has_bowel_movement = 1 AND sync_deleted_at IS NULL
      ''');

      // 2b: Urine events
      await db.customStatement('''
        INSERT INTO bodily_output_logs (
          id, client_id, profile_id, occurred_at,
          output_type, urine_condition, urine_size,
          photo_path,
          sync_created_at, sync_status, sync_is_dirty,
          sync_version
        )
        SELECT
          $uuidExpr, client_id, profile_id, entry_date,
          0, urine_condition, urine_size,
          urine_photo_path,
          sync_created_at, 0, 1,
          1
        FROM fluids_entries
        WHERE has_urine_movement = 1 AND sync_deleted_at IS NULL
      ''');

      // 2c: Menstruation (with flow remapping)
      await db.customStatement('''
        INSERT INTO bodily_output_logs (
          id, client_id, profile_id, occurred_at,
          output_type, menstruation_flow,
          sync_created_at, sync_status, sync_is_dirty,
          sync_version
        )
        SELECT
          $uuidExpr, client_id, profile_id, entry_date,
          3,
          CASE menstruation_flow
            WHEN 1 THEN 0
            WHEN 2 THEN 1
            WHEN 3 THEN 2
            WHEN 4 THEN 3
            ELSE 0
          END,
          sync_created_at, 0, 1,
          1
        FROM fluids_entries
        WHERE menstruation_flow IS NOT NULL
          AND menstruation_flow > 0
          AND sync_deleted_at IS NULL
      ''');

      // 2d: BBT entries
      await db.customStatement('''
        INSERT INTO bodily_output_logs (
          id, client_id, profile_id, occurred_at,
          output_type, temperature_value,
          sync_created_at, sync_status, sync_is_dirty,
          sync_version
        )
        SELECT
          $uuidExpr, client_id, profile_id,
          COALESCE(bbt_recorded_time, entry_date),
          4, basal_body_temperature,
          sync_created_at, 0, 1,
          1
        FROM fluids_entries
        WHERE basal_body_temperature IS NOT NULL
          AND sync_deleted_at IS NULL
      ''');

      // 2e: Custom fluid entries
      await db.customStatement('''
        INSERT INTO bodily_output_logs (
          id, client_id, profile_id, occurred_at,
          output_type, custom_type_label, notes,
          sync_created_at, sync_status, sync_is_dirty,
          sync_version
        )
        SELECT
          $uuidExpr, client_id, profile_id, entry_date,
          5, other_fluid_name,
          CASE
            WHEN other_fluid_amount IS NOT NULL AND other_fluid_notes IS NOT NULL
              THEN other_fluid_amount || ' — ' || other_fluid_notes
            WHEN other_fluid_amount IS NOT NULL
              THEN other_fluid_amount
            ELSE other_fluid_notes
          END,
          sync_created_at, 0, 1,
          1
        FROM fluids_entries
        WHERE other_fluid_name IS NOT NULL
          AND sync_deleted_at IS NULL
      ''');
    }

    Future<List<Map<String, dynamic>>> queryBodilyOutputLogs(
      AppDatabase db,
    ) async {
      final result = await db
          .customSelect('SELECT * FROM bodily_output_logs ORDER BY occurred_at')
          .get();
      return result.map((r) => r.data).toList();
    }

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    test('migration_bowelRow_createsBodilyOutputRowWithType1', () async {
      await seedFluidsEntry(
        database,
        id: 'f-bowel',
        profileId: 'p1',
        hasBowelMovement: 1,
        bowelCondition: 3,
        bowelSize: 2,
        bowelPhotoPath: '/photos/bowel.jpg',
        notes: 'normal day',
      );
      await runMigrationSql(database);

      final rows = await queryBodilyOutputLogs(database);
      final bowelRows = rows.where((r) => r['output_type'] == 1).toList();
      expect(bowelRows.length, 1);
      expect(bowelRows.first['bowel_condition'], 3);
      expect(bowelRows.first['bowel_size'], 2);
      expect(bowelRows.first['photo_path'], '/photos/bowel.jpg');
      expect(bowelRows.first['notes'], 'normal day');
    });

    test('migration_urineRow_createsBodilyOutputRowWithType0', () async {
      await seedFluidsEntry(
        database,
        id: 'f-urine',
        profileId: 'p1',
        hasUrineMovement: 1,
        urineCondition: 2,
        urineSize: 1,
        urinePhotoPath: '/photos/urine.jpg',
      );
      await runMigrationSql(database);

      final rows = await queryBodilyOutputLogs(database);
      final urineRows = rows.where((r) => r['output_type'] == 0).toList();
      expect(urineRows.length, 1);
      expect(urineRows.first['urine_condition'], 2);
      expect(urineRows.first['urine_size'], 1);
      expect(urineRows.first['photo_path'], '/photos/urine.jpg');
    });

    test('migration_menstruationRow_createsBodilyOutputRowWithType3', () async {
      // Legacy: light=2 → new: light=1
      await seedFluidsEntry(
        database,
        id: 'f-mens',
        profileId: 'p1',
        menstruationFlow: 2, // light in legacy (old=2 → new=1)
      );
      await runMigrationSql(database);

      final rows = await queryBodilyOutputLogs(database);
      final mensRows = rows.where((r) => r['output_type'] == 3).toList();
      expect(mensRows.length, 1);
      expect(mensRows.first['menstruation_flow'], 1); // mapped 2→1 (light)
    });

    test('migration_bbtRow_createsBodilyOutputRowWithType4', () async {
      await seedFluidsEntry(
        database,
        id: 'f-bbt',
        profileId: 'p1',
        basalBodyTemperature: 36.8,
        bbtRecordedTime: 1700001000000,
      );
      await runMigrationSql(database);

      final rows = await queryBodilyOutputLogs(database);
      final bbtRows = rows.where((r) => r['output_type'] == 4).toList();
      expect(bbtRows.length, 1);
      expect(bbtRows.first['temperature_value'], closeTo(36.8, 0.01));
      // occurred_at = bbt_recorded_time since it's not null
      expect(bbtRows.first['occurred_at'], 1700001000000);
    });

    test('migration_customFluidRow_createsBodilyOutputRowWithType5', () async {
      await seedFluidsEntry(
        database,
        id: 'f-custom',
        profileId: 'p1',
        otherFluidName: 'Kombucha',
        otherFluidAmount: '250ml',
        otherFluidNotes: 'after lunch',
      );
      await runMigrationSql(database);

      final rows = await queryBodilyOutputLogs(database);
      final customRows = rows.where((r) => r['output_type'] == 5).toList();
      expect(customRows.length, 1);
      expect(customRows.first['custom_type_label'], 'Kombucha');
      expect(customRows.first['notes'], '250ml — after lunch');
    });

    test('migration_waterIntakeMl_isNotMigratedToBodilyOutputLogs', () async {
      await seedFluidsEntry(
        database,
        id: 'f-water',
        profileId: 'p1',
        waterIntakeMl: 500,
      );
      await runMigrationSql(database);

      final rows = await queryBodilyOutputLogs(database);
      // Water intake creates no bodily output row
      expect(rows, isEmpty);
    });

    test('migration_fluidsMenstruationNone_notMigrated', () async {
      // Legacy menstruation_flow = 0 (none) should NOT be migrated
      // The spec says: migrate if menstruation_flow IS NOT NULL AND > 0
      await seedFluidsEntry(
        database,
        id: 'f-no-mens',
        profileId: 'p1',
        menstruationFlow: 0,
      );
      await runMigrationSql(database);

      final rows = await queryBodilyOutputLogs(database);
      final mensRows = rows.where((r) => r['output_type'] == 3).toList();
      expect(mensRows, isEmpty);
    });

    test('migration_fluidsEntriesTableStillExists', () async {
      // fluids_entries must NOT be dropped — it's a tombstone
      final result = await database
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='fluids_entries'",
          )
          .get();
      expect(result.length, 1);
    });
  });
}
