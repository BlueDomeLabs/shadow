// lib/data/datasources/local/tables/notification_category_settings_table.dart
// Drift table definition for notification_category_settings per 57_NOTIFICATION_SYSTEM.md

import 'package:drift/drift.dart';

/// Drift table for per-category notification configuration.
///
/// One row per NotificationCategory (8 rows total).
/// Pre-populated at schema v12 migration with spec-recommended defaults.
///
/// JSON columns (anchorEventValues, specificTimes) store arrays as JSON text.
///
/// NOTE: @DataClassName avoids conflict with domain entity.
@DataClassName('NotificationCategorySettingsRow')
class NotificationCategorySettings extends Table {
  // Primary key
  TextColumn get id => text()();

  // NotificationCategory.value int (0-7)
  IntColumn get category => integer()();

  BoolColumn get isEnabled =>
      boolean().named('is_enabled').withDefault(const Constant(false))();

  // NotificationSchedulingMode.value int (0=anchorEvents, 1=interval, 2=specificTimes)
  IntColumn get schedulingMode => integer().named('scheduling_mode')();

  // Mode 1 — JSON array of AnchorEventName.value ints, e.g. "[1,2,3]"
  TextColumn get anchorEventValues =>
      text().named('anchor_event_values').withDefault(const Constant('[]'))();

  // Mode 2A — interval hours (1, 2, 3, 4, 6, 8, 12)
  IntColumn get intervalHours => integer().named('interval_hours').nullable()();

  // Mode 2A — active window start "HH:mm"
  TextColumn get intervalStartTime =>
      text().named('interval_start_time').nullable()();

  // Mode 2A — active window end "HH:mm"
  TextColumn get intervalEndTime =>
      text().named('interval_end_time').nullable()();

  // Mode 2B — JSON array of "HH:mm" strings, e.g. '["09:00","13:00","17:00"]'
  TextColumn get specificTimes =>
      text().named('specific_times').withDefault(const Constant('[]'))();

  // Minutes after scheduled time before notification expires (default 60)
  IntColumn get expiresAfterMinutes => integer()
      .named('expires_after_minutes')
      .withDefault(const Constant(60))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'notification_category_settings';
}
