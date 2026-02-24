// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_sync_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HealthSyncSettings _$HealthSyncSettingsFromJson(Map<String, dynamic> json) {
  return _HealthSyncSettings.fromJson(json);
}

/// @nodoc
mixin _$HealthSyncSettings {
  /// Matches profileId — one settings record per profile.
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;

  /// Data types the user has enabled for import (default: all enabled).
  List<HealthDataType> get enabledDataTypes =>
      throw _privateConstructorUsedError;

  /// How many days back to import on first sync (30, 60, or 90).
  int get dateRangeDays => throw _privateConstructorUsedError;

  /// Serializes this HealthSyncSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthSyncSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthSyncSettingsCopyWith<HealthSyncSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthSyncSettingsCopyWith<$Res> {
  factory $HealthSyncSettingsCopyWith(
    HealthSyncSettings value,
    $Res Function(HealthSyncSettings) then,
  ) = _$HealthSyncSettingsCopyWithImpl<$Res, HealthSyncSettings>;
  @useResult
  $Res call({
    String id,
    String profileId,
    List<HealthDataType> enabledDataTypes,
    int dateRangeDays,
  });
}

/// @nodoc
class _$HealthSyncSettingsCopyWithImpl<$Res, $Val extends HealthSyncSettings>
    implements $HealthSyncSettingsCopyWith<$Res> {
  _$HealthSyncSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthSyncSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? enabledDataTypes = null,
    Object? dateRangeDays = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            enabledDataTypes: null == enabledDataTypes
                ? _value.enabledDataTypes
                : enabledDataTypes // ignore: cast_nullable_to_non_nullable
                      as List<HealthDataType>,
            dateRangeDays: null == dateRangeDays
                ? _value.dateRangeDays
                : dateRangeDays // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HealthSyncSettingsImplCopyWith<$Res>
    implements $HealthSyncSettingsCopyWith<$Res> {
  factory _$$HealthSyncSettingsImplCopyWith(
    _$HealthSyncSettingsImpl value,
    $Res Function(_$HealthSyncSettingsImpl) then,
  ) = __$$HealthSyncSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    List<HealthDataType> enabledDataTypes,
    int dateRangeDays,
  });
}

/// @nodoc
class __$$HealthSyncSettingsImplCopyWithImpl<$Res>
    extends _$HealthSyncSettingsCopyWithImpl<$Res, _$HealthSyncSettingsImpl>
    implements _$$HealthSyncSettingsImplCopyWith<$Res> {
  __$$HealthSyncSettingsImplCopyWithImpl(
    _$HealthSyncSettingsImpl _value,
    $Res Function(_$HealthSyncSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HealthSyncSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? enabledDataTypes = null,
    Object? dateRangeDays = null,
  }) {
    return _then(
      _$HealthSyncSettingsImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        enabledDataTypes: null == enabledDataTypes
            ? _value._enabledDataTypes
            : enabledDataTypes // ignore: cast_nullable_to_non_nullable
                  as List<HealthDataType>,
        dateRangeDays: null == dateRangeDays
            ? _value.dateRangeDays
            : dateRangeDays // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthSyncSettingsImpl extends _HealthSyncSettings {
  const _$HealthSyncSettingsImpl({
    required this.id,
    required this.profileId,
    final List<HealthDataType> enabledDataTypes = const [],
    this.dateRangeDays = 30,
  }) : _enabledDataTypes = enabledDataTypes,
       super._();

  factory _$HealthSyncSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthSyncSettingsImplFromJson(json);

  /// Matches profileId — one settings record per profile.
  @override
  final String id;
  @override
  final String profileId;

  /// Data types the user has enabled for import (default: all enabled).
  final List<HealthDataType> _enabledDataTypes;

  /// Data types the user has enabled for import (default: all enabled).
  @override
  @JsonKey()
  List<HealthDataType> get enabledDataTypes {
    if (_enabledDataTypes is EqualUnmodifiableListView)
      return _enabledDataTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_enabledDataTypes);
  }

  /// How many days back to import on first sync (30, 60, or 90).
  @override
  @JsonKey()
  final int dateRangeDays;

  @override
  String toString() {
    return 'HealthSyncSettings(id: $id, profileId: $profileId, enabledDataTypes: $enabledDataTypes, dateRangeDays: $dateRangeDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthSyncSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            const DeepCollectionEquality().equals(
              other._enabledDataTypes,
              _enabledDataTypes,
            ) &&
            (identical(other.dateRangeDays, dateRangeDays) ||
                other.dateRangeDays == dateRangeDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    const DeepCollectionEquality().hash(_enabledDataTypes),
    dateRangeDays,
  );

  /// Create a copy of HealthSyncSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthSyncSettingsImplCopyWith<_$HealthSyncSettingsImpl> get copyWith =>
      __$$HealthSyncSettingsImplCopyWithImpl<_$HealthSyncSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthSyncSettingsImplToJson(this);
  }
}

abstract class _HealthSyncSettings extends HealthSyncSettings {
  const factory _HealthSyncSettings({
    required final String id,
    required final String profileId,
    final List<HealthDataType> enabledDataTypes,
    final int dateRangeDays,
  }) = _$HealthSyncSettingsImpl;
  const _HealthSyncSettings._() : super._();

  factory _HealthSyncSettings.fromJson(Map<String, dynamic> json) =
      _$HealthSyncSettingsImpl.fromJson;

  /// Matches profileId — one settings record per profile.
  @override
  String get id;
  @override
  String get profileId;

  /// Data types the user has enabled for import (default: all enabled).
  @override
  List<HealthDataType> get enabledDataTypes;

  /// How many days back to import on first sync (30, 60, or 90).
  @override
  int get dateRangeDays;

  /// Create a copy of HealthSyncSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthSyncSettingsImplCopyWith<_$HealthSyncSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
