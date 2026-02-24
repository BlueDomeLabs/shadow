// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GetImportedVitalsInput {
  String get profileId => throw _privateConstructorUsedError;
  int? get startEpoch =>
      throw _privateConstructorUsedError; // Epoch ms; null = no lower bound
  int? get endEpoch =>
      throw _privateConstructorUsedError; // Epoch ms; null = no upper bound
  HealthDataType? get dataType => throw _privateConstructorUsedError;

  /// Create a copy of GetImportedVitalsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetImportedVitalsInputCopyWith<GetImportedVitalsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetImportedVitalsInputCopyWith<$Res> {
  factory $GetImportedVitalsInputCopyWith(
    GetImportedVitalsInput value,
    $Res Function(GetImportedVitalsInput) then,
  ) = _$GetImportedVitalsInputCopyWithImpl<$Res, GetImportedVitalsInput>;
  @useResult
  $Res call({
    String profileId,
    int? startEpoch,
    int? endEpoch,
    HealthDataType? dataType,
  });
}

/// @nodoc
class _$GetImportedVitalsInputCopyWithImpl<
  $Res,
  $Val extends GetImportedVitalsInput
>
    implements $GetImportedVitalsInputCopyWith<$Res> {
  _$GetImportedVitalsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetImportedVitalsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startEpoch = freezed,
    Object? endEpoch = freezed,
    Object? dataType = freezed,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            startEpoch: freezed == startEpoch
                ? _value.startEpoch
                : startEpoch // ignore: cast_nullable_to_non_nullable
                      as int?,
            endEpoch: freezed == endEpoch
                ? _value.endEpoch
                : endEpoch // ignore: cast_nullable_to_non_nullable
                      as int?,
            dataType: freezed == dataType
                ? _value.dataType
                : dataType // ignore: cast_nullable_to_non_nullable
                      as HealthDataType?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetImportedVitalsInputImplCopyWith<$Res>
    implements $GetImportedVitalsInputCopyWith<$Res> {
  factory _$$GetImportedVitalsInputImplCopyWith(
    _$GetImportedVitalsInputImpl value,
    $Res Function(_$GetImportedVitalsInputImpl) then,
  ) = __$$GetImportedVitalsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    int? startEpoch,
    int? endEpoch,
    HealthDataType? dataType,
  });
}

/// @nodoc
class __$$GetImportedVitalsInputImplCopyWithImpl<$Res>
    extends
        _$GetImportedVitalsInputCopyWithImpl<$Res, _$GetImportedVitalsInputImpl>
    implements _$$GetImportedVitalsInputImplCopyWith<$Res> {
  __$$GetImportedVitalsInputImplCopyWithImpl(
    _$GetImportedVitalsInputImpl _value,
    $Res Function(_$GetImportedVitalsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetImportedVitalsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startEpoch = freezed,
    Object? endEpoch = freezed,
    Object? dataType = freezed,
  }) {
    return _then(
      _$GetImportedVitalsInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        startEpoch: freezed == startEpoch
            ? _value.startEpoch
            : startEpoch // ignore: cast_nullable_to_non_nullable
                  as int?,
        endEpoch: freezed == endEpoch
            ? _value.endEpoch
            : endEpoch // ignore: cast_nullable_to_non_nullable
                  as int?,
        dataType: freezed == dataType
            ? _value.dataType
            : dataType // ignore: cast_nullable_to_non_nullable
                  as HealthDataType?,
      ),
    );
  }
}

/// @nodoc

class _$GetImportedVitalsInputImpl implements _GetImportedVitalsInput {
  const _$GetImportedVitalsInputImpl({
    required this.profileId,
    this.startEpoch,
    this.endEpoch,
    this.dataType,
  });

  @override
  final String profileId;
  @override
  final int? startEpoch;
  // Epoch ms; null = no lower bound
  @override
  final int? endEpoch;
  // Epoch ms; null = no upper bound
  @override
  final HealthDataType? dataType;

  @override
  String toString() {
    return 'GetImportedVitalsInput(profileId: $profileId, startEpoch: $startEpoch, endEpoch: $endEpoch, dataType: $dataType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetImportedVitalsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.startEpoch, startEpoch) ||
                other.startEpoch == startEpoch) &&
            (identical(other.endEpoch, endEpoch) ||
                other.endEpoch == endEpoch) &&
            (identical(other.dataType, dataType) ||
                other.dataType == dataType));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, startEpoch, endEpoch, dataType);

  /// Create a copy of GetImportedVitalsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetImportedVitalsInputImplCopyWith<_$GetImportedVitalsInputImpl>
  get copyWith =>
      __$$GetImportedVitalsInputImplCopyWithImpl<_$GetImportedVitalsInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetImportedVitalsInput implements GetImportedVitalsInput {
  const factory _GetImportedVitalsInput({
    required final String profileId,
    final int? startEpoch,
    final int? endEpoch,
    final HealthDataType? dataType,
  }) = _$GetImportedVitalsInputImpl;

  @override
  String get profileId;
  @override
  int? get startEpoch; // Epoch ms; null = no lower bound
  @override
  int? get endEpoch; // Epoch ms; null = no upper bound
  @override
  HealthDataType? get dataType;

  /// Create a copy of GetImportedVitalsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetImportedVitalsInputImplCopyWith<_$GetImportedVitalsInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetLastSyncStatusInput {
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of GetLastSyncStatusInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetLastSyncStatusInputCopyWith<GetLastSyncStatusInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetLastSyncStatusInputCopyWith<$Res> {
  factory $GetLastSyncStatusInputCopyWith(
    GetLastSyncStatusInput value,
    $Res Function(GetLastSyncStatusInput) then,
  ) = _$GetLastSyncStatusInputCopyWithImpl<$Res, GetLastSyncStatusInput>;
  @useResult
  $Res call({String profileId});
}

/// @nodoc
class _$GetLastSyncStatusInputCopyWithImpl<
  $Res,
  $Val extends GetLastSyncStatusInput
>
    implements $GetLastSyncStatusInputCopyWith<$Res> {
  _$GetLastSyncStatusInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetLastSyncStatusInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null}) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetLastSyncStatusInputImplCopyWith<$Res>
    implements $GetLastSyncStatusInputCopyWith<$Res> {
  factory _$$GetLastSyncStatusInputImplCopyWith(
    _$GetLastSyncStatusInputImpl value,
    $Res Function(_$GetLastSyncStatusInputImpl) then,
  ) = __$$GetLastSyncStatusInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId});
}

/// @nodoc
class __$$GetLastSyncStatusInputImplCopyWithImpl<$Res>
    extends
        _$GetLastSyncStatusInputCopyWithImpl<$Res, _$GetLastSyncStatusInputImpl>
    implements _$$GetLastSyncStatusInputImplCopyWith<$Res> {
  __$$GetLastSyncStatusInputImplCopyWithImpl(
    _$GetLastSyncStatusInputImpl _value,
    $Res Function(_$GetLastSyncStatusInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetLastSyncStatusInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null}) {
    return _then(
      _$GetLastSyncStatusInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GetLastSyncStatusInputImpl implements _GetLastSyncStatusInput {
  const _$GetLastSyncStatusInputImpl({required this.profileId});

  @override
  final String profileId;

  @override
  String toString() {
    return 'GetLastSyncStatusInput(profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetLastSyncStatusInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId);

  /// Create a copy of GetLastSyncStatusInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetLastSyncStatusInputImplCopyWith<_$GetLastSyncStatusInputImpl>
  get copyWith =>
      __$$GetLastSyncStatusInputImplCopyWithImpl<_$GetLastSyncStatusInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetLastSyncStatusInput implements GetLastSyncStatusInput {
  const factory _GetLastSyncStatusInput({required final String profileId}) =
      _$GetLastSyncStatusInputImpl;

  @override
  String get profileId;

  /// Create a copy of GetLastSyncStatusInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetLastSyncStatusInputImplCopyWith<_$GetLastSyncStatusInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateHealthSyncSettingsInput {
  String get profileId => throw _privateConstructorUsedError;
  List<HealthDataType>? get enabledDataTypes =>
      throw _privateConstructorUsedError; // null = no change
  int? get dateRangeDays => throw _privateConstructorUsedError;

  /// Create a copy of UpdateHealthSyncSettingsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateHealthSyncSettingsInputCopyWith<UpdateHealthSyncSettingsInput>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateHealthSyncSettingsInputCopyWith<$Res> {
  factory $UpdateHealthSyncSettingsInputCopyWith(
    UpdateHealthSyncSettingsInput value,
    $Res Function(UpdateHealthSyncSettingsInput) then,
  ) =
      _$UpdateHealthSyncSettingsInputCopyWithImpl<
        $Res,
        UpdateHealthSyncSettingsInput
      >;
  @useResult
  $Res call({
    String profileId,
    List<HealthDataType>? enabledDataTypes,
    int? dateRangeDays,
  });
}

/// @nodoc
class _$UpdateHealthSyncSettingsInputCopyWithImpl<
  $Res,
  $Val extends UpdateHealthSyncSettingsInput
>
    implements $UpdateHealthSyncSettingsInputCopyWith<$Res> {
  _$UpdateHealthSyncSettingsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateHealthSyncSettingsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? enabledDataTypes = freezed,
    Object? dateRangeDays = freezed,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            enabledDataTypes: freezed == enabledDataTypes
                ? _value.enabledDataTypes
                : enabledDataTypes // ignore: cast_nullable_to_non_nullable
                      as List<HealthDataType>?,
            dateRangeDays: freezed == dateRangeDays
                ? _value.dateRangeDays
                : dateRangeDays // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateHealthSyncSettingsInputImplCopyWith<$Res>
    implements $UpdateHealthSyncSettingsInputCopyWith<$Res> {
  factory _$$UpdateHealthSyncSettingsInputImplCopyWith(
    _$UpdateHealthSyncSettingsInputImpl value,
    $Res Function(_$UpdateHealthSyncSettingsInputImpl) then,
  ) = __$$UpdateHealthSyncSettingsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    List<HealthDataType>? enabledDataTypes,
    int? dateRangeDays,
  });
}

/// @nodoc
class __$$UpdateHealthSyncSettingsInputImplCopyWithImpl<$Res>
    extends
        _$UpdateHealthSyncSettingsInputCopyWithImpl<
          $Res,
          _$UpdateHealthSyncSettingsInputImpl
        >
    implements _$$UpdateHealthSyncSettingsInputImplCopyWith<$Res> {
  __$$UpdateHealthSyncSettingsInputImplCopyWithImpl(
    _$UpdateHealthSyncSettingsInputImpl _value,
    $Res Function(_$UpdateHealthSyncSettingsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateHealthSyncSettingsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? enabledDataTypes = freezed,
    Object? dateRangeDays = freezed,
  }) {
    return _then(
      _$UpdateHealthSyncSettingsInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        enabledDataTypes: freezed == enabledDataTypes
            ? _value._enabledDataTypes
            : enabledDataTypes // ignore: cast_nullable_to_non_nullable
                  as List<HealthDataType>?,
        dateRangeDays: freezed == dateRangeDays
            ? _value.dateRangeDays
            : dateRangeDays // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateHealthSyncSettingsInputImpl
    implements _UpdateHealthSyncSettingsInput {
  const _$UpdateHealthSyncSettingsInputImpl({
    required this.profileId,
    final List<HealthDataType>? enabledDataTypes,
    this.dateRangeDays,
  }) : _enabledDataTypes = enabledDataTypes;

  @override
  final String profileId;
  final List<HealthDataType>? _enabledDataTypes;
  @override
  List<HealthDataType>? get enabledDataTypes {
    final value = _enabledDataTypes;
    if (value == null) return null;
    if (_enabledDataTypes is EqualUnmodifiableListView)
      return _enabledDataTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // null = no change
  @override
  final int? dateRangeDays;

  @override
  String toString() {
    return 'UpdateHealthSyncSettingsInput(profileId: $profileId, enabledDataTypes: $enabledDataTypes, dateRangeDays: $dateRangeDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateHealthSyncSettingsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            const DeepCollectionEquality().equals(
              other._enabledDataTypes,
              _enabledDataTypes,
            ) &&
            (identical(other.dateRangeDays, dateRangeDays) ||
                other.dateRangeDays == dateRangeDays));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    const DeepCollectionEquality().hash(_enabledDataTypes),
    dateRangeDays,
  );

  /// Create a copy of UpdateHealthSyncSettingsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateHealthSyncSettingsInputImplCopyWith<
    _$UpdateHealthSyncSettingsInputImpl
  >
  get copyWith =>
      __$$UpdateHealthSyncSettingsInputImplCopyWithImpl<
        _$UpdateHealthSyncSettingsInputImpl
      >(this, _$identity);
}

abstract class _UpdateHealthSyncSettingsInput
    implements UpdateHealthSyncSettingsInput {
  const factory _UpdateHealthSyncSettingsInput({
    required final String profileId,
    final List<HealthDataType>? enabledDataTypes,
    final int? dateRangeDays,
  }) = _$UpdateHealthSyncSettingsInputImpl;

  @override
  String get profileId;
  @override
  List<HealthDataType>? get enabledDataTypes; // null = no change
  @override
  int? get dateRangeDays;

  /// Create a copy of UpdateHealthSyncSettingsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateHealthSyncSettingsInputImplCopyWith<
    _$UpdateHealthSyncSettingsInputImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
