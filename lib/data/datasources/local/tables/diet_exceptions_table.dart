// lib/data/datasources/local/tables/diet_exceptions_table.dart
// Phase 15b — Drift table for diet_exceptions
// Per 59_DIET_TRACKING.md

import 'package:drift/drift.dart';

/// Drift table definition for diet_exceptions.
///
/// Each row is an exception to a DietRule
/// (e.g. "No dairy — EXCEPT hard aged cheeses").
/// See 59_DIET_TRACKING.md for full feature spec.
@DataClassName('DietExceptionRow')
class DietExceptions extends Table {
  // Primary key
  TextColumn get id => text()();

  // Parent reference
  TextColumn get ruleId => text().named('rule_id')();

  // Exception description (free text)
  TextColumn get description => text()();

  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'diet_exceptions';
}
