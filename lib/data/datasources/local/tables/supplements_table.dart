// lib/data/datasources/local/tables/supplements_table.dart
// Drift table definition for supplements per 10_DATABASE_SCHEMA.md Section 4.1

import 'package:drift/drift.dart';

/// Drift table definition for supplements.
///
/// Maps to database table `supplements` with all sync metadata columns.
/// See 10_DATABASE_SCHEMA.md Section 4.1 for schema definition.
///
/// NOTE: @DataClassName('SupplementRow') avoids conflict with domain entity Supplement.
@DataClassName('SupplementRow')
class Supplements extends Table {
  // Primary key
  TextColumn get id => text()();

  // Required fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  TextColumn get name => text()();
  IntColumn get form => integer()(); // SupplementForm enum
  IntColumn get dosageQuantity => integer().named('dosage_quantity')();
  IntColumn get dosageUnit =>
      integer().named('dosage_unit')(); // DosageUnit enum

  // Optional fields with defaults
  TextColumn get customForm => text().named('custom_form').nullable()();
  TextColumn get customDosageUnit =>
      text().named('custom_dosage_unit').nullable()();
  TextColumn get brand => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get ingredients =>
      text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get schedules =>
      text().withDefault(const Constant('[]'))(); // JSON array
  IntColumn get startDate => integer().named('start_date').nullable()();
  IntColumn get endDate => integer().named('end_date').nullable()();
  BoolColumn get isArchived =>
      boolean().named('is_archived').withDefault(const Constant(false))();

  // Phase 15a additions (60_SUPPLEMENT_EXTENSION.md)
  TextColumn get source => text().nullable()();
  RealColumn get pricePaid => real().named('price_paid').nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get importSource => text().named('import_source').nullable()();

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
  String get tableName => 'supplements';
}
