// lib/data/datasources/local/tables/anchor_event_times_table.dart
// Drift table definition for anchor_event_times per 57_NOTIFICATION_SYSTEM.md

import 'package:drift/drift.dart';

/// Drift table for the 5 named anchor events (Wake, Breakfast, Lunch, Dinner, Bedtime).
///
/// Pre-populated at schema v12 migration with spec defaults.
/// Users adjust times and enable/disable events via Notification Settings.
///
/// NOTE: @DataClassName avoids conflict with domain entity AnchorEventTime.
@DataClassName('AnchorEventTimeRow')
class AnchorEventTimes extends Table {
  // Primary key
  TextColumn get id => text()();

  // AnchorEventName.value int (0=wake, 1=breakfast, 2=lunch, 3=dinner, 4=bedtime)
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
