// lib/data/datasources/local/tables/user_settings_table.dart
// Drift table for singleton user settings per 58_SETTINGS_SCREENS.md

import 'package:drift/drift.dart';

/// Drift table for the singleton user_settings row.
///
/// Always contains exactly one row with id = 'singleton'.
/// Unit enum values are stored as integers (see settings_enums.dart).
/// Security PIN hash is NOT stored here — it lives in flutter_secure_storage.
///
/// @DataClassName avoids conflict with domain entity UserSettings.
@DataClassName('UserSettingsRow')
class UserSettingsTable extends Table {
  // Primary key — always 'singleton'
  TextColumn get id => text()();

  // Unit settings (enum integer values — see settings_enums.dart)
  IntColumn get weightUnit =>
      integer().named('weight_unit').withDefault(const Constant(0))();
  IntColumn get foodWeightUnit =>
      integer().named('food_weight_unit').withDefault(const Constant(0))();
  IntColumn get fluidUnit =>
      integer().named('fluid_unit').withDefault(const Constant(0))();
  IntColumn get temperatureUnit =>
      integer().named('temperature_unit').withDefault(const Constant(0))();
  IntColumn get energyUnit =>
      integer().named('energy_unit').withDefault(const Constant(0))();
  IntColumn get macroDisplay =>
      integer().named('macro_display').withDefault(const Constant(0))();

  // Security settings
  BoolColumn get appLockEnabled =>
      boolean().named('app_lock_enabled').withDefault(const Constant(false))();
  BoolColumn get biometricEnabled =>
      boolean().named('biometric_enabled').withDefault(const Constant(false))();
  // Stores AutoLockDuration.value (0, 1, 5, 15, 60)
  IntColumn get autoLockMinutes =>
      integer().named('auto_lock_minutes').withDefault(const Constant(5))();
  BoolColumn get hideInAppSwitcher => boolean()
      .named('hide_in_app_switcher')
      .withDefault(const Constant(true))();
  BoolColumn get allowBiometricBypassPin => boolean()
      .named('allow_biometric_bypass_pin')
      .withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'user_settings';
}
