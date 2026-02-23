// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$UserSettingsImpl(
  id: json['id'] as String,
  weightUnit:
      $enumDecodeNullable(_$WeightUnitEnumMap, json['weightUnit']) ??
      WeightUnit.kg,
  foodWeightUnit:
      $enumDecodeNullable(_$FoodWeightUnitEnumMap, json['foodWeightUnit']) ??
      FoodWeightUnit.grams,
  fluidUnit:
      $enumDecodeNullable(_$FluidUnitEnumMap, json['fluidUnit']) ??
      FluidUnit.ml,
  temperatureUnit:
      $enumDecodeNullable(_$TemperatureUnitEnumMap, json['temperatureUnit']) ??
      TemperatureUnit.celsius,
  energyUnit:
      $enumDecodeNullable(_$EnergyUnitEnumMap, json['energyUnit']) ??
      EnergyUnit.kcal,
  macroDisplay:
      $enumDecodeNullable(_$MacroDisplayEnumMap, json['macroDisplay']) ??
      MacroDisplay.grams,
  appLockEnabled: json['appLockEnabled'] as bool? ?? false,
  biometricEnabled: json['biometricEnabled'] as bool? ?? false,
  autoLockDuration:
      $enumDecodeNullable(
        _$AutoLockDurationEnumMap,
        json['autoLockDuration'],
      ) ??
      AutoLockDuration.fiveMinutes,
  hideInAppSwitcher: json['hideInAppSwitcher'] as bool? ?? true,
  allowBiometricBypassPin: json['allowBiometricBypassPin'] as bool? ?? false,
);

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weightUnit': _$WeightUnitEnumMap[instance.weightUnit]!,
      'foodWeightUnit': _$FoodWeightUnitEnumMap[instance.foodWeightUnit]!,
      'fluidUnit': _$FluidUnitEnumMap[instance.fluidUnit]!,
      'temperatureUnit': _$TemperatureUnitEnumMap[instance.temperatureUnit]!,
      'energyUnit': _$EnergyUnitEnumMap[instance.energyUnit]!,
      'macroDisplay': _$MacroDisplayEnumMap[instance.macroDisplay]!,
      'appLockEnabled': instance.appLockEnabled,
      'biometricEnabled': instance.biometricEnabled,
      'autoLockDuration': _$AutoLockDurationEnumMap[instance.autoLockDuration]!,
      'hideInAppSwitcher': instance.hideInAppSwitcher,
      'allowBiometricBypassPin': instance.allowBiometricBypassPin,
    };

const _$WeightUnitEnumMap = {WeightUnit.kg: 'kg', WeightUnit.lbs: 'lbs'};

const _$FoodWeightUnitEnumMap = {
  FoodWeightUnit.grams: 'grams',
  FoodWeightUnit.ounces: 'ounces',
};

const _$FluidUnitEnumMap = {FluidUnit.ml: 'ml', FluidUnit.flOz: 'flOz'};

const _$TemperatureUnitEnumMap = {
  TemperatureUnit.celsius: 'celsius',
  TemperatureUnit.fahrenheit: 'fahrenheit',
};

const _$EnergyUnitEnumMap = {EnergyUnit.kcal: 'kcal', EnergyUnit.kJ: 'kJ'};

const _$MacroDisplayEnumMap = {
  MacroDisplay.grams: 'grams',
  MacroDisplay.percentage: 'percentage',
};

const _$AutoLockDurationEnumMap = {
  AutoLockDuration.immediately: 'immediately',
  AutoLockDuration.oneMinute: 'oneMinute',
  AutoLockDuration.fiveMinutes: 'fiveMinutes',
  AutoLockDuration.fifteenMinutes: 'fifteenMinutes',
  AutoLockDuration.oneHour: 'oneHour',
};
