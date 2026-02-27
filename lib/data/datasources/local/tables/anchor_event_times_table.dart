// lib/data/datasources/local/tables/anchor_event_times_table.dart
// Drift table definition for anchor_event_times per 57_NOTIFICATION_SYSTEM.md

import 'package:drift/drift.dart';

/// Drift table for the 8 named anchor events
/// (Wake, Breakfast, Morning, Lunch, Afternoon, Dinner, Evening, Bedtime).
///
/// Pre-populated at schema v12 migration with spec defaults.
/// Expanded to 8 values at schema v17 (Phase 19).
/// Users adjust times and enable/disable events via Notification Settings.
///
/// NOTE: @DataClassName avoids conflict with domain entity AnchorEventTime.
@DataClassName('AnchorEventTimeRow')
class AnchorEventTimes extends Table {
  // Primary key
  TextColumn get id => text()();

  // AnchorEventName.value int
  // (0=wake,1=breakfast,2=morning,3=lunch,4=afternoon,5=dinner,6=evening,7=bedtime)
  IntColumn get name => integer()();

  // "HH:mm" 24-hour time string, e.g. "07:00"
  TextColumn get timeOfDay => text().named('time_of_day')();

  BoolColumn get isEnabled =>
      boolean().named('is_enabled').withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'anchor_event_times';
}
