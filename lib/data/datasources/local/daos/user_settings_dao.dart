// lib/data/datasources/local/daos/user_settings_dao.dart
// DAO for singleton user_settings row per 58_SETTINGS_SCREENS.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/user_settings_table.dart';
import 'package:shadow_app/domain/entities/user_settings.dart' as domain;
import 'package:shadow_app/domain/enums/settings_enums.dart';

part 'user_settings_dao.g.dart';

/// Data Access Object for the singleton user_settings table.
///
/// Always operates on the single row with id = 'singleton'. Creates defaults
/// on first access via [getOrCreate].
@DriftAccessor(tables: [UserSettingsTable])
class UserSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$UserSettingsDaoMixin {
  UserSettingsDao(super.db);

  static const _singletonId = 'singleton';

  /// Returns existing settings or inserts defaults and returns them.
  Future<Result<domain.UserSettings, AppError>> getOrCreate() async {
    try {
      final row = await _getRow();
      if (row != null) return Success(_rowToEntity(row));

      // Insert defaults on first call
      const defaults = domain.UserSettings.defaults;
      await into(userSettingsTable).insert(_entityToCompanion(defaults));
      final created = await _getRow();
      return Success(_rowToEntity(created!));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('user_settings', e.toString(), stack),
      );
    }
  }

  /// Updates the singleton row.
  Future<Result<domain.UserSettings, AppError>> updateEntity(
    domain.UserSettings entity,
  ) async {
    try {
      await (update(userSettingsTable)..where((t) => t.id.equals(_singletonId)))
          .write(_entityToCompanion(entity));
      final row = await _getRow();
      if (row == null) {
        return Failure(DatabaseError.notFound('UserSettings', _singletonId));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('user_settings', _singletonId, e, stack),
      );
    }
  }

  Future<UserSettingsRow?> _getRow() async {
    final query = select(userSettingsTable)
      ..where((t) => t.id.equals(_singletonId));
    return query.getSingleOrNull();
  }

  domain.UserSettings _rowToEntity(UserSettingsRow row) => domain.UserSettings(
    id: row.id,
    weightUnit: WeightUnit.fromValue(row.weightUnit),
    foodWeightUnit: FoodWeightUnit.fromValue(row.foodWeightUnit),
    fluidUnit: FluidUnit.fromValue(row.fluidUnit),
    temperatureUnit: TemperatureUnit.fromValue(row.temperatureUnit),
    energyUnit: EnergyUnit.fromValue(row.energyUnit),
    macroDisplay: MacroDisplay.fromValue(row.macroDisplay),
    appLockEnabled: row.appLockEnabled,
    biometricEnabled: row.biometricEnabled,
    autoLockDuration: AutoLockDuration.fromValue(row.autoLockMinutes),
    hideInAppSwitcher: row.hideInAppSwitcher,
    allowBiometricBypassPin: row.allowBiometricBypassPin,
  );

  UserSettingsTableCompanion _entityToCompanion(domain.UserSettings e) =>
      UserSettingsTableCompanion(
        id: Value(e.id),
        weightUnit: Value(e.weightUnit.value),
        foodWeightUnit: Value(e.foodWeightUnit.value),
        fluidUnit: Value(e.fluidUnit.value),
        temperatureUnit: Value(e.temperatureUnit.value),
        energyUnit: Value(e.energyUnit.value),
        macroDisplay: Value(e.macroDisplay.value),
        appLockEnabled: Value(e.appLockEnabled),
        biometricEnabled: Value(e.biometricEnabled),
        autoLockMinutes: Value(e.autoLockDuration.value),
        hideInAppSwitcher: Value(e.hideInAppSwitcher),
        allowBiometricBypassPin: Value(e.allowBiometricBypassPin),
      );
}
