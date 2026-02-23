// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  String get id => throw _privateConstructorUsedError; // === Unit Settings ===
  WeightUnit get weightUnit => throw _privateConstructorUsedError;
  FoodWeightUnit get foodWeightUnit => throw _privateConstructorUsedError;
  FluidUnit get fluidUnit => throw _privateConstructorUsedError;
  TemperatureUnit get temperatureUnit => throw _privateConstructorUsedError;
  EnergyUnit get energyUnit => throw _privateConstructorUsedError;
  MacroDisplay get macroDisplay =>
      throw _privateConstructorUsedError; // === Security Settings ===
  bool get appLockEnabled => throw _privateConstructorUsedError;
  bool get biometricEnabled => throw _privateConstructorUsedError;
  AutoLockDuration get autoLockDuration => throw _privateConstructorUsedError;
  bool get hideInAppSwitcher => throw _privateConstructorUsedError;
  bool get allowBiometricBypassPin => throw _privateConstructorUsedError;

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
    UserSettings value,
    $Res Function(UserSettings) then,
  ) = _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call({
    String id,
    WeightUnit weightUnit,
    FoodWeightUnit foodWeightUnit,
    FluidUnit fluidUnit,
    TemperatureUnit temperatureUnit,
    EnergyUnit energyUnit,
    MacroDisplay macroDisplay,
    bool appLockEnabled,
    bool biometricEnabled,
    AutoLockDuration autoLockDuration,
    bool hideInAppSwitcher,
    bool allowBiometricBypassPin,
  });
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weightUnit = null,
    Object? foodWeightUnit = null,
    Object? fluidUnit = null,
    Object? temperatureUnit = null,
    Object? energyUnit = null,
    Object? macroDisplay = null,
    Object? appLockEnabled = null,
    Object? biometricEnabled = null,
    Object? autoLockDuration = null,
    Object? hideInAppSwitcher = null,
    Object? allowBiometricBypassPin = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            weightUnit: null == weightUnit
                ? _value.weightUnit
                : weightUnit // ignore: cast_nullable_to_non_nullable
                      as WeightUnit,
            foodWeightUnit: null == foodWeightUnit
                ? _value.foodWeightUnit
                : foodWeightUnit // ignore: cast_nullable_to_non_nullable
                      as FoodWeightUnit,
            fluidUnit: null == fluidUnit
                ? _value.fluidUnit
                : fluidUnit // ignore: cast_nullable_to_non_nullable
                      as FluidUnit,
            temperatureUnit: null == temperatureUnit
                ? _value.temperatureUnit
                : temperatureUnit // ignore: cast_nullable_to_non_nullable
                      as TemperatureUnit,
            energyUnit: null == energyUnit
                ? _value.energyUnit
                : energyUnit // ignore: cast_nullable_to_non_nullable
                      as EnergyUnit,
            macroDisplay: null == macroDisplay
                ? _value.macroDisplay
                : macroDisplay // ignore: cast_nullable_to_non_nullable
                      as MacroDisplay,
            appLockEnabled: null == appLockEnabled
                ? _value.appLockEnabled
                : appLockEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            biometricEnabled: null == biometricEnabled
                ? _value.biometricEnabled
                : biometricEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            autoLockDuration: null == autoLockDuration
                ? _value.autoLockDuration
                : autoLockDuration // ignore: cast_nullable_to_non_nullable
                      as AutoLockDuration,
            hideInAppSwitcher: null == hideInAppSwitcher
                ? _value.hideInAppSwitcher
                : hideInAppSwitcher // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowBiometricBypassPin: null == allowBiometricBypassPin
                ? _value.allowBiometricBypassPin
                : allowBiometricBypassPin // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
    _$UserSettingsImpl value,
    $Res Function(_$UserSettingsImpl) then,
  ) = __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    WeightUnit weightUnit,
    FoodWeightUnit foodWeightUnit,
    FluidUnit fluidUnit,
    TemperatureUnit temperatureUnit,
    EnergyUnit energyUnit,
    MacroDisplay macroDisplay,
    bool appLockEnabled,
    bool biometricEnabled,
    AutoLockDuration autoLockDuration,
    bool hideInAppSwitcher,
    bool allowBiometricBypassPin,
  });
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
    _$UserSettingsImpl _value,
    $Res Function(_$UserSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weightUnit = null,
    Object? foodWeightUnit = null,
    Object? fluidUnit = null,
    Object? temperatureUnit = null,
    Object? energyUnit = null,
    Object? macroDisplay = null,
    Object? appLockEnabled = null,
    Object? biometricEnabled = null,
    Object? autoLockDuration = null,
    Object? hideInAppSwitcher = null,
    Object? allowBiometricBypassPin = null,
  }) {
    return _then(
      _$UserSettingsImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        weightUnit: null == weightUnit
            ? _value.weightUnit
            : weightUnit // ignore: cast_nullable_to_non_nullable
                  as WeightUnit,
        foodWeightUnit: null == foodWeightUnit
            ? _value.foodWeightUnit
            : foodWeightUnit // ignore: cast_nullable_to_non_nullable
                  as FoodWeightUnit,
        fluidUnit: null == fluidUnit
            ? _value.fluidUnit
            : fluidUnit // ignore: cast_nullable_to_non_nullable
                  as FluidUnit,
        temperatureUnit: null == temperatureUnit
            ? _value.temperatureUnit
            : temperatureUnit // ignore: cast_nullable_to_non_nullable
                  as TemperatureUnit,
        energyUnit: null == energyUnit
            ? _value.energyUnit
            : energyUnit // ignore: cast_nullable_to_non_nullable
                  as EnergyUnit,
        macroDisplay: null == macroDisplay
            ? _value.macroDisplay
            : macroDisplay // ignore: cast_nullable_to_non_nullable
                  as MacroDisplay,
        appLockEnabled: null == appLockEnabled
            ? _value.appLockEnabled
            : appLockEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        biometricEnabled: null == biometricEnabled
            ? _value.biometricEnabled
            : biometricEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        autoLockDuration: null == autoLockDuration
            ? _value.autoLockDuration
            : autoLockDuration // ignore: cast_nullable_to_non_nullable
                  as AutoLockDuration,
        hideInAppSwitcher: null == hideInAppSwitcher
            ? _value.hideInAppSwitcher
            : hideInAppSwitcher // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowBiometricBypassPin: null == allowBiometricBypassPin
            ? _value.allowBiometricBypassPin
            : allowBiometricBypassPin // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSettingsImpl implements _UserSettings {
  const _$UserSettingsImpl({
    required this.id,
    this.weightUnit = WeightUnit.kg,
    this.foodWeightUnit = FoodWeightUnit.grams,
    this.fluidUnit = FluidUnit.ml,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.energyUnit = EnergyUnit.kcal,
    this.macroDisplay = MacroDisplay.grams,
    this.appLockEnabled = false,
    this.biometricEnabled = false,
    this.autoLockDuration = AutoLockDuration.fiveMinutes,
    this.hideInAppSwitcher = true,
    this.allowBiometricBypassPin = false,
  });

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  @override
  final String id;
  // === Unit Settings ===
  @override
  @JsonKey()
  final WeightUnit weightUnit;
  @override
  @JsonKey()
  final FoodWeightUnit foodWeightUnit;
  @override
  @JsonKey()
  final FluidUnit fluidUnit;
  @override
  @JsonKey()
  final TemperatureUnit temperatureUnit;
  @override
  @JsonKey()
  final EnergyUnit energyUnit;
  @override
  @JsonKey()
  final MacroDisplay macroDisplay;
  // === Security Settings ===
  @override
  @JsonKey()
  final bool appLockEnabled;
  @override
  @JsonKey()
  final bool biometricEnabled;
  @override
  @JsonKey()
  final AutoLockDuration autoLockDuration;
  @override
  @JsonKey()
  final bool hideInAppSwitcher;
  @override
  @JsonKey()
  final bool allowBiometricBypassPin;

  @override
  String toString() {
    return 'UserSettings(id: $id, weightUnit: $weightUnit, foodWeightUnit: $foodWeightUnit, fluidUnit: $fluidUnit, temperatureUnit: $temperatureUnit, energyUnit: $energyUnit, macroDisplay: $macroDisplay, appLockEnabled: $appLockEnabled, biometricEnabled: $biometricEnabled, autoLockDuration: $autoLockDuration, hideInAppSwitcher: $hideInAppSwitcher, allowBiometricBypassPin: $allowBiometricBypassPin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weightUnit, weightUnit) ||
                other.weightUnit == weightUnit) &&
            (identical(other.foodWeightUnit, foodWeightUnit) ||
                other.foodWeightUnit == foodWeightUnit) &&
            (identical(other.fluidUnit, fluidUnit) ||
                other.fluidUnit == fluidUnit) &&
            (identical(other.temperatureUnit, temperatureUnit) ||
                other.temperatureUnit == temperatureUnit) &&
            (identical(other.energyUnit, energyUnit) ||
                other.energyUnit == energyUnit) &&
            (identical(other.macroDisplay, macroDisplay) ||
                other.macroDisplay == macroDisplay) &&
            (identical(other.appLockEnabled, appLockEnabled) ||
                other.appLockEnabled == appLockEnabled) &&
            (identical(other.biometricEnabled, biometricEnabled) ||
                other.biometricEnabled == biometricEnabled) &&
            (identical(other.autoLockDuration, autoLockDuration) ||
                other.autoLockDuration == autoLockDuration) &&
            (identical(other.hideInAppSwitcher, hideInAppSwitcher) ||
                other.hideInAppSwitcher == hideInAppSwitcher) &&
            (identical(
                  other.allowBiometricBypassPin,
                  allowBiometricBypassPin,
                ) ||
                other.allowBiometricBypassPin == allowBiometricBypassPin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    weightUnit,
    foodWeightUnit,
    fluidUnit,
    temperatureUnit,
    energyUnit,
    macroDisplay,
    appLockEnabled,
    biometricEnabled,
    autoLockDuration,
    hideInAppSwitcher,
    allowBiometricBypassPin,
  );

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(this);
  }
}

abstract class _UserSettings implements UserSettings {
  const factory _UserSettings({
    required final String id,
    final WeightUnit weightUnit,
    final FoodWeightUnit foodWeightUnit,
    final FluidUnit fluidUnit,
    final TemperatureUnit temperatureUnit,
    final EnergyUnit energyUnit,
    final MacroDisplay macroDisplay,
    final bool appLockEnabled,
    final bool biometricEnabled,
    final AutoLockDuration autoLockDuration,
    final bool hideInAppSwitcher,
    final bool allowBiometricBypassPin,
  }) = _$UserSettingsImpl;

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  String get id; // === Unit Settings ===
  @override
  WeightUnit get weightUnit;
  @override
  FoodWeightUnit get foodWeightUnit;
  @override
  FluidUnit get fluidUnit;
  @override
  TemperatureUnit get temperatureUnit;
  @override
  EnergyUnit get energyUnit;
  @override
  MacroDisplay get macroDisplay; // === Security Settings ===
  @override
  bool get appLockEnabled;
  @override
  bool get biometricEnabled;
  @override
  AutoLockDuration get autoLockDuration;
  @override
  bool get hideInAppSwitcher;
  @override
  bool get allowBiometricBypassPin;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
