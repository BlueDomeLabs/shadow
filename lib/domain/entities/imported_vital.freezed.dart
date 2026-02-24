// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imported_vital.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ImportedVital _$ImportedVitalFromJson(Map<String, dynamic> json) {
  return _ImportedVital.fromJson(json);
}

/// @nodoc
mixin _$ImportedVital {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;

  /// Type of health measurement (heart_rate, weight, etc.).
  HealthDataType get dataType => throw _privateConstructorUsedError;

  /// Numeric value in canonical unit (see [HealthDataType.canonicalUnit]).
  double get value => throw _privateConstructorUsedError;

  /// Canonical unit string (bpm, kg, mmHg, hours, steps, kcal, %).
  String get unit => throw _privateConstructorUsedError;

  /// When the measurement was recorded by the source device (epoch ms UTC).
  int get recordedAt => throw _privateConstructorUsedError;

  /// Source platform (Apple Health or Google Health Connect).
  HealthSourcePlatform get sourcePlatform => throw _privateConstructorUsedError;

  /// Device name if available (e.g. "Apple Watch Series 9").
  String? get sourceDevice => throw _privateConstructorUsedError;

  /// When Shadow imported this record (epoch ms UTC).
  int get importedAt => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this ImportedVital to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImportedVital
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImportedVitalCopyWith<ImportedVital> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportedVitalCopyWith<$Res> {
  factory $ImportedVitalCopyWith(
    ImportedVital value,
    $Res Function(ImportedVital) then,
  ) = _$ImportedVitalCopyWithImpl<$Res, ImportedVital>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    HealthDataType dataType,
    double value,
    String unit,
    int recordedAt,
    HealthSourcePlatform sourcePlatform,
    String? sourceDevice,
    int importedAt,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$ImportedVitalCopyWithImpl<$Res, $Val extends ImportedVital>
    implements $ImportedVitalCopyWith<$Res> {
  _$ImportedVitalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImportedVital
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? dataType = null,
    Object? value = null,
    Object? unit = null,
    Object? recordedAt = null,
    Object? sourcePlatform = null,
    Object? sourceDevice = freezed,
    Object? importedAt = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            dataType: null == dataType
                ? _value.dataType
                : dataType // ignore: cast_nullable_to_non_nullable
                      as HealthDataType,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            recordedAt: null == recordedAt
                ? _value.recordedAt
                : recordedAt // ignore: cast_nullable_to_non_nullable
                      as int,
            sourcePlatform: null == sourcePlatform
                ? _value.sourcePlatform
                : sourcePlatform // ignore: cast_nullable_to_non_nullable
                      as HealthSourcePlatform,
            sourceDevice: freezed == sourceDevice
                ? _value.sourceDevice
                : sourceDevice // ignore: cast_nullable_to_non_nullable
                      as String?,
            importedAt: null == importedAt
                ? _value.importedAt
                : importedAt // ignore: cast_nullable_to_non_nullable
                      as int,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of ImportedVital
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SyncMetadataCopyWith<$Res> get syncMetadata {
    return $SyncMetadataCopyWith<$Res>(_value.syncMetadata, (value) {
      return _then(_value.copyWith(syncMetadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ImportedVitalImplCopyWith<$Res>
    implements $ImportedVitalCopyWith<$Res> {
  factory _$$ImportedVitalImplCopyWith(
    _$ImportedVitalImpl value,
    $Res Function(_$ImportedVitalImpl) then,
  ) = __$$ImportedVitalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    HealthDataType dataType,
    double value,
    String unit,
    int recordedAt,
    HealthSourcePlatform sourcePlatform,
    String? sourceDevice,
    int importedAt,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$ImportedVitalImplCopyWithImpl<$Res>
    extends _$ImportedVitalCopyWithImpl<$Res, _$ImportedVitalImpl>
    implements _$$ImportedVitalImplCopyWith<$Res> {
  __$$ImportedVitalImplCopyWithImpl(
    _$ImportedVitalImpl _value,
    $Res Function(_$ImportedVitalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImportedVital
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? dataType = null,
    Object? value = null,
    Object? unit = null,
    Object? recordedAt = null,
    Object? sourcePlatform = null,
    Object? sourceDevice = freezed,
    Object? importedAt = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$ImportedVitalImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        dataType: null == dataType
            ? _value.dataType
            : dataType // ignore: cast_nullable_to_non_nullable
                  as HealthDataType,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        recordedAt: null == recordedAt
            ? _value.recordedAt
            : recordedAt // ignore: cast_nullable_to_non_nullable
                  as int,
        sourcePlatform: null == sourcePlatform
            ? _value.sourcePlatform
            : sourcePlatform // ignore: cast_nullable_to_non_nullable
                  as HealthSourcePlatform,
        sourceDevice: freezed == sourceDevice
            ? _value.sourceDevice
            : sourceDevice // ignore: cast_nullable_to_non_nullable
                  as String?,
        importedAt: null == importedAt
            ? _value.importedAt
            : importedAt // ignore: cast_nullable_to_non_nullable
                  as int,
        syncMetadata: null == syncMetadata
            ? _value.syncMetadata
            : syncMetadata // ignore: cast_nullable_to_non_nullable
                  as SyncMetadata,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImportedVitalImpl extends _ImportedVital {
  const _$ImportedVitalImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.dataType,
    required this.value,
    required this.unit,
    required this.recordedAt,
    required this.sourcePlatform,
    this.sourceDevice,
    required this.importedAt,
    required this.syncMetadata,
  }) : super._();

  factory _$ImportedVitalImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImportedVitalImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;

  /// Type of health measurement (heart_rate, weight, etc.).
  @override
  final HealthDataType dataType;

  /// Numeric value in canonical unit (see [HealthDataType.canonicalUnit]).
  @override
  final double value;

  /// Canonical unit string (bpm, kg, mmHg, hours, steps, kcal, %).
  @override
  final String unit;

  /// When the measurement was recorded by the source device (epoch ms UTC).
  @override
  final int recordedAt;

  /// Source platform (Apple Health or Google Health Connect).
  @override
  final HealthSourcePlatform sourcePlatform;

  /// Device name if available (e.g. "Apple Watch Series 9").
  @override
  final String? sourceDevice;

  /// When Shadow imported this record (epoch ms UTC).
  @override
  final int importedAt;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'ImportedVital(id: $id, clientId: $clientId, profileId: $profileId, dataType: $dataType, value: $value, unit: $unit, recordedAt: $recordedAt, sourcePlatform: $sourcePlatform, sourceDevice: $sourceDevice, importedAt: $importedAt, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportedVitalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.dataType, dataType) ||
                other.dataType == dataType) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.sourcePlatform, sourcePlatform) ||
                other.sourcePlatform == sourcePlatform) &&
            (identical(other.sourceDevice, sourceDevice) ||
                other.sourceDevice == sourceDevice) &&
            (identical(other.importedAt, importedAt) ||
                other.importedAt == importedAt) &&
            (identical(other.syncMetadata, syncMetadata) ||
                other.syncMetadata == syncMetadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    clientId,
    profileId,
    dataType,
    value,
    unit,
    recordedAt,
    sourcePlatform,
    sourceDevice,
    importedAt,
    syncMetadata,
  );

  /// Create a copy of ImportedVital
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportedVitalImplCopyWith<_$ImportedVitalImpl> get copyWith =>
      __$$ImportedVitalImplCopyWithImpl<_$ImportedVitalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImportedVitalImplToJson(this);
  }
}

abstract class _ImportedVital extends ImportedVital {
  const factory _ImportedVital({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final HealthDataType dataType,
    required final double value,
    required final String unit,
    required final int recordedAt,
    required final HealthSourcePlatform sourcePlatform,
    final String? sourceDevice,
    required final int importedAt,
    required final SyncMetadata syncMetadata,
  }) = _$ImportedVitalImpl;
  const _ImportedVital._() : super._();

  factory _ImportedVital.fromJson(Map<String, dynamic> json) =
      _$ImportedVitalImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;

  /// Type of health measurement (heart_rate, weight, etc.).
  @override
  HealthDataType get dataType;

  /// Numeric value in canonical unit (see [HealthDataType.canonicalUnit]).
  @override
  double get value;

  /// Canonical unit string (bpm, kg, mmHg, hours, steps, kcal, %).
  @override
  String get unit;

  /// When the measurement was recorded by the source device (epoch ms UTC).
  @override
  int get recordedAt;

  /// Source platform (Apple Health or Google Health Connect).
  @override
  HealthSourcePlatform get sourcePlatform;

  /// Device name if available (e.g. "Apple Watch Series 9").
  @override
  String? get sourceDevice;

  /// When Shadow imported this record (epoch ms UTC).
  @override
  int get importedAt;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of ImportedVital
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImportedVitalImplCopyWith<_$ImportedVitalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
