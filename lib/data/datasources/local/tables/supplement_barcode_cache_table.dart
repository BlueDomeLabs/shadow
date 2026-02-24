// lib/data/datasources/local/tables/supplement_barcode_cache_table.dart
// Phase 15a — Drift table for supplement_barcode_cache (NIH DSLD)
// Per 60_SUPPLEMENT_EXTENSION.md

import 'package:drift/drift.dart';

/// Cache table for NIH DSLD API responses.
///
/// Prevents redundant API calls to the Dietary Supplement Label Database.
/// Entries expire after 30 days (checked at read time).
/// Per 60_SUPPLEMENT_EXTENSION.md.
@DataClassName('SupplementBarcodeCacheRow')
class SupplementBarcodeCache extends Table {
  TextColumn get id => text()();
  TextColumn get barcode => text()();
  TextColumn get productName => text().named('product_name').nullable()();
  TextColumn get brand => text().nullable()();
  TextColumn get servingSize => text().named('serving_size').nullable()();
  RealColumn get servingsPerContainer =>
      real().named('servings_per_container').nullable()();
  TextColumn get ingredientsJson =>
      text().named('ingredients_json').nullable()(); // JSON array
  TextColumn get dsldId => text().named('dsld_id').nullable()();
  TextColumn get rawResponse =>
      text().named('raw_response').nullable()(); // Full JSON for re-parsing
  IntColumn get fetchedAt => integer().named('fetched_at')(); // Epoch ms
  IntColumn get expiresAt => integer().named('expires_at')(); // Epoch ms

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'supplement_barcode_cache';
}
