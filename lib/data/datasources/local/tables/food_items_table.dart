// lib/data/datasources/local/tables/food_items_table.dart
// Drift table for food_items per 10_DATABASE_SCHEMA.md Section 5.1

import 'package:drift/drift.dart';

/// Drift table definition for food_items.
///
/// Maps to CREATE TABLE food_items in 10_DATABASE_SCHEMA.md Section 5.1.
/// Reusable food items with optional nutritional information.
@DataClassName('FoodItemRow')
class FoodItems extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  TextColumn get name => text()();
  IntColumn get type => integer().withDefault(
    const Constant(0),
  )(); // 0: simple, 1: composed, 2: packaged
  TextColumn get simpleItemIds =>
      text().named('simple_item_ids').nullable()(); // Comma-separated IDs
  BoolColumn get isUserCreated =>
      boolean().named('is_user_created').withDefault(const Constant(true))();
  BoolColumn get isArchived =>
      boolean().named('is_archived').withDefault(const Constant(false))();

  // Nutritional information (Version 5 additions)
  RealColumn get servingSize => real().named('serving_size').nullable()();
  TextColumn get servingUnit => text().named('serving_unit').nullable()();
  RealColumn get calories => real().nullable()();
  RealColumn get carbsGrams => real().named('carbs_grams').nullable()();
  RealColumn get fatGrams => real().named('fat_grams').nullable()();
  RealColumn get proteinGrams => real().named('protein_grams').nullable()();
  RealColumn get fiberGrams => real().named('fiber_grams').nullable()();
  RealColumn get sugarGrams => real().named('sugar_grams').nullable()();

  // Phase 15a additions (59a_FOOD_DATABASE_EXTENSION.md)
  RealColumn get sodiumMg => real().named('sodium_mg').nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get brand => text().nullable()();
  TextColumn get ingredientsText =>
      text().named('ingredients_text').nullable()();
  TextColumn get openFoodFactsId =>
      text().named('open_food_facts_id').nullable()();
  TextColumn get importSource => text().named('import_source').nullable()();
  TextColumn get imageUrl => text().named('image_url').nullable()();

  // Sync metadata columns (9 columns per 10_DATABASE_SCHEMA.md)
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
}
