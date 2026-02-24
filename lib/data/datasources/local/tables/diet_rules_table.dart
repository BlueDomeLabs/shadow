// lib/data/datasources/local/tables/diet_rules_table.dart
// Phase 15b — Drift table for diet_rules
// Per 59_DIET_TRACKING.md

import 'package:drift/drift.dart';

/// Drift table definition for diet_rules.
///
/// Each row is one compliance rule within a Diet.
/// Multiple rules can exist per diet.
/// See 59_DIET_TRACKING.md for full feature spec.
@DataClassName('DietRuleRow')
class DietRules extends Table {
  // Primary key
  TextColumn get id => text()();

  // Parent reference
  TextColumn get dietId => text().named('diet_id')();

  // Rule definition
  IntColumn get ruleType => integer().named('rule_type')();

  // What this rule applies to (only one set per rule)
  TextColumn get targetFoodItemId =>
      text().named('target_food_item_id').nullable()();
  TextColumn get targetCategory => text().named('target_category').nullable()();
  TextColumn get targetIngredient =>
      text().named('target_ingredient').nullable()();

  // Quantity constraints
  RealColumn get minValue => real().named('min_value').nullable()();
  RealColumn get maxValue => real().named('max_value').nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get frequency => text().nullable()();

  // Time-based rules (minutes from midnight)
  IntColumn get timeValue => integer().named('time_value').nullable()();

  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'diet_rules';
}
