// lib/data/datasources/local/tables/food_barcode_cache_table.dart
// Phase 15a — Drift table for food_barcode_cache
// Per 59a_FOOD_DATABASE_EXTENSION.md

import 'package:drift/drift.dart';

/// Cache table for Open Food Facts API responses.
///
/// Prevents redundant API calls and enables offline access to previously
/// scanned products. Entries expire after 30 days (checked at read time).
/// Per 59a_FOOD_DATABASE_EXTENSION.md.
@DataClassName('FoodBarcodeCacheRow')
class FoodBarcodeCache extends Table {
  TextColumn get id => text()();
  TextColumn get barcode => text()();
  TextColumn get productName => text().named('product_name').nullable()();
  TextColumn get brand => text().nullable()();
  TextColumn get ingredientsText =>
      text().named('ingredients_text').nullable()();
  RealColumn get calories => real().nullable()();
  RealColumn get carbs => real().nullable()();
  RealColumn get fat => real().nullable()();
  RealColumn get protein => real().nullable()();
  RealColumn get fiber => real().nullable()();
  RealColumn get sugar => real().nullable()();
  RealColumn get sodiumMg => real().named('sodium_mg').nullable()();
  TextColumn get openFoodFactsId =>
      text().named('open_food_facts_id').nullable()();
  TextColumn get imageUrl => text().named('image_url').nullable()();
  TextColumn get rawResponse =>
      text().named('raw_response').nullable()(); // Full JSON for re-parsing
  IntColumn get fetchedAt => integer().named('fetched_at')(); // Epoch ms
  IntColumn get expiresAt => integer().named('expires_at')(); // Epoch ms

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'food_barcode_cache';
}
