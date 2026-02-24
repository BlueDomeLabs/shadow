// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_sync_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HealthSyncStatus _$HealthSyncStatusFromJson(Map<String, dynamic> json) {
  return _HealthSyncStatus.fromJson(json);
}

/// @nodoc
mixin _$HealthSyncStatus {
  /// Composite key: "${profileId}_${dataType.value}"
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  HealthDataType get dataType => throw _privateConstructorUsedError;

  /// When this data type was last successfully synced (epoch ms UTC).
  /// Null if never synced.
  int? get lastSyncedAt => throw _privateConstructorUsedError;

  /// Number of records imported in the last sync.
  int get recordCount => throw _privateConstructorUsedError;

  /// Error message from the last failed sync, if any.
  String? get lastError => throw _privateConstructorUsedError;

  /// Serializes this HealthSyncStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthSyncStatusCopyWith<HealthSyncStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthSyncStatusCopyWith<$Res> {
  factory $HealthSyncStatusCopyWith(
    HealthSyncStatus value,
    $Res Function(HealthSyncStatus) then,
  ) = _$HealthSyncStatusCopyWithImpl<$Res, HealthSyncStatus>;
  @useResult
  $Res call({
    String id,
    String profileId,
    HealthDataType dataType,
    int? lastSyncedAt,
    int recordCount,
    String? lastError,
  });
}

/// @nodoc
class _$HealthSyncStatusCopyWithImpl<$Res, $Val extends HealthSyncStatus>
    implements $HealthSyncStatusCopyWith<$Res> {
  _$HealthSyncStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? dataType = null,
    Object? lastSyncedAt = freezed,
    Object? recordCount = null,
    Object? lastError = freezed,
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
            dataType: null == dataType
                ? _value.dataType
                : dataType // ignore: cast_nullable_to_non_nullable
                      as HealthDataType,
            lastSyncedAt: freezed == lastSyncedAt
                ? _value.lastSyncedAt
                : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                      as int?,
            recordCount: null == recordCount
                ? _value.recordCount
                : recordCount // ignore: cast_nullable_to_non_nullable
                      as int,
            lastError: freezed == lastError
                ? _value.lastError
                : lastError // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HealthSyncStatusImplCopyWith<$Res>
    implements $HealthSyncStatusCopyWith<$Res> {
  factory _$$HealthSyncStatusImplCopyWith(
    _$HealthSyncStatusImpl value,
    $Res Function(_$HealthSyncStatusImpl) then,
  ) = __$$HealthSyncStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    HealthDataType dataType,
    int? lastSyncedAt,
    int recordCount,
    String? lastError,
  });
}

/// @nodoc
class __$$HealthSyncStatusImplCopyWithImpl<$Res>
    extends _$HealthSyncStatusCopyWithImpl<$Res, _$HealthSyncStatusImpl>
    implements _$$HealthSyncStatusImplCopyWith<$Res> {
  __$$HealthSyncStatusImplCopyWithImpl(
    _$HealthSyncStatusImpl _value,
    $Res Function(_$HealthSyncStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HealthSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? dataType = null,
    Object? lastSyncedAt = freezed,
    Object? recordCount = null,
    Object? lastError = freezed,
  }) {
    return _then(
      _$HealthSyncStatusImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        dataType: null == dataType
            ? _value.dataType
            : dataType // ignore: cast_nullable_to_non_nullable
                  as HealthDataType,
        lastSyncedAt: freezed == lastSyncedAt
            ? _value.lastSyncedAt
            : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                  as int?,
        recordCount: null == recordCount
            ? _value.recordCount
            : recordCount // ignore: cast_nullable_to_non_nullable
                  as int,
        lastError: freezed == lastError
            ? _value.lastError
            : lastError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthSyncStatusImpl extends _HealthSyncStatus {
  const _$HealthSyncStatusImpl({
    required this.id,
    required this.profileId,
    required this.dataType,
    this.lastSyncedAt,
    this.recordCount = 0,
    this.lastError,
  }) : super._();

  factory _$HealthSyncStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthSyncStatusImplFromJson(json);

  /// Composite key: "${profileId}_${dataType.value}"
  @override
  final String id;
  @override
  final String profileId;
  @override
  final HealthDataType dataType;

  /// When this data type was last successfully synced (epoch ms UTC).
  /// Null if never synced.
  @override
  final int? lastSyncedAt;

  /// Number of records imported in the last sync.
  @override
  @JsonKey()
  final int recordCount;

  /// Error message from the last failed sync, if any.
  @override
  final String? lastError;

  @override
  String toString() {
    return 'HealthSyncStatus(id: $id, profileId: $profileId, dataType: $dataType, lastSyncedAt: $lastSyncedAt, recordCount: $recordCount, lastError: $lastError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthSyncStatusImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.dataType, dataType) ||
                other.dataType == dataType) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.recordCount, recordCount) ||
                other.recordCount == recordCount) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    dataType,
    lastSyncedAt,
    recordCount,
    lastError,
  );

  /// Create a copy of HealthSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthSyncStatusImplCopyWith<_$HealthSyncStatusImpl> get copyWith =>
      __$$HealthSyncStatusImplCopyWithImpl<_$HealthSyncStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthSyncStatusImplToJson(this);
  }
}

abstract class _HealthSyncStatus extends HealthSyncStatus {
  const factory _HealthSyncStatus({
    required final String id,
    required final String profileId,
    required final HealthDataType dataType,
    final int? lastSyncedAt,
    final int recordCount,
    final String? lastError,
  }) = _$HealthSyncStatusImpl;
  const _HealthSyncStatus._() : super._();

  factory _HealthSyncStatus.fromJson(Map<String, dynamic> json) =
      _$HealthSyncStatusImpl.fromJson;

  /// Composite key: "${profileId}_${dataType.value}"
  @override
  String get id;
  @override
  String get profileId;
  @override
  HealthDataType get dataType;

  /// When this data type was last successfully synced (epoch ms UTC).
  /// Null if never synced.
  @override
  int? get lastSyncedAt;

  /// Number of records imported in the last sync.
  @override
  int get recordCount;

  /// Error message from the last failed sync, if any.
  @override
  String? get lastError;

  /// Create a copy of HealthSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthSyncStatusImplCopyWith<_$HealthSyncStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
