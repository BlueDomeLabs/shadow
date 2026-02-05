// lib/data/datasources/local/tables/fluids_entries_table.dart
// Drift table definition for fluids_entries per 10_DATABASE_SCHEMA.md Section 10

import 'package:drift/drift.dart';

/// Drift table definition for fluids entries.
///
/// Maps to database table `fluids_entries` with all sync metadata columns.
/// See 10_DATABASE_SCHEMA.md Section 10 for schema definition.
@DataClassName('FluidsEntryRow')
class FluidsEntries extends Table {
  // Primary key
  TextColumn get id => text()();

  // Required fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  IntColumn get entryDate => integer().named('entry_date')(); // Epoch ms

  // Water intake tracking
  IntColumn get waterIntakeMl =>
      integer().named('water_intake_ml').nullable()();
  TextColumn get waterIntakeNotes =>
      text().named('water_intake_notes').nullable()();

  // Bowel tracking
  BoolColumn get hasBowelMovement => boolean()
      .named('has_bowel_movement')
      .withDefault(const Constant(false))();
  IntColumn get bowelCondition =>
      integer().named('bowel_condition').nullable()(); // BowelCondition enum
  TextColumn get bowelCustomCondition =>
      text().named('bowel_custom_condition').nullable()();
  IntColumn get bowelSize =>
      integer().named('bowel_size').nullable()(); // MovementSize enum
  TextColumn get bowelPhotoPath =>
      text().named('bowel_photo_path').nullable()();

  // Urine tracking
  BoolColumn get hasUrineMovement => boolean()
      .named('has_urine_movement')
      .withDefault(const Constant(false))();
  IntColumn get urineCondition =>
      integer().named('urine_condition').nullable()(); // UrineCondition enum
  TextColumn get urineCustomCondition =>
      text().named('urine_custom_condition').nullable()();
  IntColumn get urineSize =>
      integer().named('urine_size').nullable()(); // MovementSize enum
  TextColumn get urinePhotoPath =>
      text().named('urine_photo_path').nullable()();

  // Menstruation tracking
  IntColumn get menstruationFlow => integer()
      .named('menstruation_flow')
      .nullable()(); // MenstruationFlow enum

  // Basal body temperature tracking
  RealColumn get basalBodyTemperature =>
      real().named('basal_body_temperature').nullable()();
  IntColumn get bbtRecordedTime =>
      integer().named('bbt_recorded_time').nullable()(); // Epoch ms

  // Customizable "Other" fluid tracking
  TextColumn get otherFluidName =>
      text().named('other_fluid_name').nullable()();
  TextColumn get otherFluidAmount =>
      text().named('other_fluid_amount').nullable()();
  TextColumn get otherFluidNotes =>
      text().named('other_fluid_notes').nullable()();

  // Import tracking
  TextColumn get importSource => text().named('import_source').nullable()();
  TextColumn get importExternalId =>
      text().named('import_external_id').nullable()();

  // File sync metadata
  TextColumn get cloudStorageUrl =>
      text().named('cloud_storage_url').nullable()();
  TextColumn get fileHash => text().named('file_hash').nullable()();
  IntColumn get fileSizeBytes =>
      integer().named('file_size_bytes').nullable()();
  BoolColumn get isFileUploaded =>
      boolean().named('is_file_uploaded').withDefault(const Constant(false))();

  // General notes
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get photoIds => text()
      .named('photo_ids')
      .withDefault(const Constant('[]'))(); // JSON array

  // Sync metadata columns (required on all syncable entities)
  IntColumn get syncCreatedAt => integer().named('sync_created_at')();
  IntColumn get syncUpdatedAt =>
      integer().named('sync_updated_at').nullable()();
  IntColumn get syncDeletedAt =>
      integer().named('sync_deleted_at').nullable()();
  IntColumn get syncLastSyncedAt =>
      integer().named('sync_last_synced_at').nullable()();
  IntColumn get syncStatus =>
      integer().named('sync_status').withDefault(const Constant(0))();
  IntColumn get syncVersion =>
      integer().named('sync_version').withDefault(const Constant(1))();
  TextColumn get syncDeviceId => text().named('sync_device_id').nullable()();
  BoolColumn get syncIsDirty =>
      boolean().named('sync_is_dirty').withDefault(const Constant(true))();
  TextColumn get conflictData => text().named('conflict_data').nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'fluids_entries';
}
