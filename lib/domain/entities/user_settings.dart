// lib/domain/entities/user_settings.dart
// Per 58_SETTINGS_SCREENS.md — units and security app-wide settings

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/settings_enums.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// App-wide user preferences for display units and security.
///
/// Stored as a single singleton row (id = 'singleton') in the user_settings
/// table. All unit conversions are applied at display time — raw data is always
/// stored in canonical units (grams, ml, Celsius, kcal).
///
/// Security fields (except pinHash) are stored here. The PIN hash itself is
/// stored in flutter_secure_storage by SecuritySettingsService.
///
/// See 58_SETTINGS_SCREENS.md for full spec.
@Freezed(toJson: true, fromJson: true)
class UserSettings with _$UserSettings {
  const factory UserSettings({
    required String id,

    // === Unit Settings ===
    @Default(WeightUnit.kg) WeightUnit weightUnit,
    @Default(FoodWeightUnit.grams) FoodWeightUnit foodWeightUnit,
    @Default(FluidUnit.ml) FluidUnit fluidUnit,
    @Default(TemperatureUnit.celsius) TemperatureUnit temperatureUnit,
    @Default(EnergyUnit.kcal) EnergyUnit energyUnit,
    @Default(MacroDisplay.grams) MacroDisplay macroDisplay,

    // === Security Settings ===
    @Default(false) bool appLockEnabled,
    @Default(false) bool biometricEnabled,
    @Default(AutoLockDuration.fiveMinutes) AutoLockDuration autoLockDuration,
    @Default(true) bool hideInAppSwitcher,
    @Default(false) bool allowBiometricBypassPin,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  /// Default settings for a fresh install.
  static const defaults = UserSettings(id: 'singleton');
}
