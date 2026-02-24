// lib/data/datasources/local/tables/food_item_components_table.dart
// Phase 15a — Drift table for food_item_components join table
// Per 59a_FOOD_DATABASE_EXTENSION.md

import 'package:drift/drift.dart';

/// Drift table for food_item_components.
///
/// Replaces the JSON simpleItemIds array on food_items with a proper
/// join table that supports quantity multipliers.
/// Per 59a_FOOD_DATABASE_EXTENSION.md.
@DataClassName('FoodItemComponentRow')
class FoodItemComponents extends Table {
  TextColumn get id => text()();
  TextColumn get composedFoodItemId => text().named('composed_food_item_id')();
  TextColumn get simpleFoodItemId => text().named('simple_food_item_id')();
  RealColumn get quantity =>
      real().withDefault(const Constant(1))(); // Serving multiplier
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'food_item_components';
}
