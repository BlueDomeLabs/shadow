// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_conflict.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SyncConflict _$SyncConflictFromJson(Map<String, dynamic> json) {
  return _SyncConflict.fromJson(json);
}

/// @nodoc
mixin _$SyncConflict {
  String get id =>
      throw _privateConstructorUsedError; // Unique conflict identifier (UUID v4)
  String get entityType =>
      throw _privateConstructorUsedError; // Table name (e.g. 'supplements')
  String get entityId =>
      throw _privateConstructorUsedError; // The conflicting entity's ID
  String get profileId => throw _privateConstructorUsedError;
  int get localVersion =>
      throw _privateConstructorUsedError; // Local syncVersion at time of conflict
  int get remoteVersion =>
      throw _privateConstructorUsedError; // Remote syncVersion at time of conflict
  Map<String, dynamic> get localData =>
      throw _privateConstructorUsedError; // Full local entity JSON
  Map<String, dynamic> get remoteData =>
      throw _privateConstructorUsedError; // Full remote entity JSON
  int get detectedAt =>
      throw _privateConstructorUsedError; // Epoch ms when conflict was detected
  bool get isResolved => throw _privateConstructorUsedError;
  ConflictResolutionType? get resolution =>
      throw _privateConstructorUsedError; // How it was resolved (null if unresolved)
  int? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this SyncConflict to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncConflictCopyWith<SyncConflict> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncConflictCopyWith<$Res> {
  factory $SyncConflictCopyWith(
    SyncConflict value,
    $Res Function(SyncConflict) then,
  ) = _$SyncConflictCopyWithImpl<$Res, SyncConflict>;
  @useResult
  $Res call({
    String id,
    String entityType,
    String entityId,
    String profileId,
    int localVersion,
    int remoteVersion,
    Map<String, dynamic> localData,
    Map<String, dynamic> remoteData,
    int detectedAt,
    bool isResolved,
    ConflictResolutionType? resolution,
    int? resolvedAt,
  });
}

/// @nodoc
class _$SyncConflictCopyWithImpl<$Res, $Val extends SyncConflict>
    implements $SyncConflictCopyWith<$Res> {
  _$SyncConflictCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? profileId = null,
    Object? localVersion = null,
    Object? remoteVersion = null,
    Object? localData = null,
    Object? remoteData = null,
    Object? detectedAt = null,
    Object? isResolved = null,
    Object? resolution = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as String,
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            localVersion: null == localVersion
                ? _value.localVersion
                : localVersion // ignore: cast_nullable_to_non_nullable
                      as int,
            remoteVersion: null == remoteVersion
                ? _value.remoteVersion
                : remoteVersion // ignore: cast_nullable_to_non_nullable
                      as int,
            localData: null == localData
                ? _value.localData
                : localData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            remoteData: null == remoteData
                ? _value.remoteData
                : remoteData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            detectedAt: null == detectedAt
                ? _value.detectedAt
                : detectedAt // ignore: cast_nullable_to_non_nullable
                      as int,
            isResolved: null == isResolved
                ? _value.isResolved
                : isResolved // ignore: cast_nullable_to_non_nullable
                      as bool,
            resolution: freezed == resolution
                ? _value.resolution
                : resolution // ignore: cast_nullable_to_non_nullable
                      as ConflictResolutionType?,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncConflictImplCopyWith<$Res>
    implements $SyncConflictCopyWith<$Res> {
  factory _$$SyncConflictImplCopyWith(
    _$SyncConflictImpl value,
    $Res Function(_$SyncConflictImpl) then,
  ) = __$$SyncConflictImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String entityType,
    String entityId,
    String profileId,
    int localVersion,
    int remoteVersion,
    Map<String, dynamic> localData,
    Map<String, dynamic> remoteData,
    int detectedAt,
    bool isResolved,
    ConflictResolutionType? resolution,
    int? resolvedAt,
  });
}

/// @nodoc
class __$$SyncConflictImplCopyWithImpl<$Res>
    extends _$SyncConflictCopyWithImpl<$Res, _$SyncConflictImpl>
    implements _$$SyncConflictImplCopyWith<$Res> {
  __$$SyncConflictImplCopyWithImpl(
    _$SyncConflictImpl _value,
    $Res Function(_$SyncConflictImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? profileId = null,
    Object? localVersion = null,
    Object? remoteVersion = null,
    Object? localData = null,
    Object? remoteData = null,
    Object? detectedAt = null,
    Object? isResolved = null,
    Object? resolution = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _$SyncConflictImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        localVersion: null == localVersion
            ? _value.localVersion
            : localVersion // ignore: cast_nullable_to_non_nullable
                  as int,
        remoteVersion: null == remoteVersion
            ? _value.remoteVersion
            : remoteVersion // ignore: cast_nullable_to_non_nullable
                  as int,
        localData: null == localData
            ? _value._localData
            : localData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        remoteData: null == remoteData
            ? _value._remoteData
            : remoteData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        detectedAt: null == detectedAt
            ? _value.detectedAt
            : detectedAt // ignore: cast_nullable_to_non_nullable
                  as int,
        isResolved: null == isResolved
            ? _value.isResolved
            : isResolved // ignore: cast_nullable_to_non_nullable
                  as bool,
        resolution: freezed == resolution
            ? _value.resolution
            : resolution // ignore: cast_nullable_to_non_nullable
                  as ConflictResolutionType?,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncConflictImpl extends _SyncConflict {
  const _$SyncConflictImpl({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.profileId,
    required this.localVersion,
    required this.remoteVersion,
    required final Map<String, dynamic> localData,
    required final Map<String, dynamic> remoteData,
    required this.detectedAt,
    this.isResolved = false,
    this.resolution,
    this.resolvedAt,
  }) : _localData = localData,
       _remoteData = remoteData,
       super._();

  factory _$SyncConflictImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncConflictImplFromJson(json);

  @override
  final String id;
  // Unique conflict identifier (UUID v4)
  @override
  final String entityType;
  // Table name (e.g. 'supplements')
  @override
  final String entityId;
  // The conflicting entity's ID
  @override
  final String profileId;
  @override
  final int localVersion;
  // Local syncVersion at time of conflict
  @override
  final int remoteVersion;
  // Remote syncVersion at time of conflict
  final Map<String, dynamic> _localData;
  // Remote syncVersion at time of conflict
  @override
  Map<String, dynamic> get localData {
    if (_localData is EqualUnmodifiableMapView) return _localData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_localData);
  }

  // Full local entity JSON
  final Map<String, dynamic> _remoteData;
  // Full local entity JSON
  @override
  Map<String, dynamic> get remoteData {
    if (_remoteData is EqualUnmodifiableMapView) return _remoteData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_remoteData);
  }

  // Full remote entity JSON
  @override
  final int detectedAt;
  // Epoch ms when conflict was detected
  @override
  @JsonKey()
  final bool isResolved;
  @override
  final ConflictResolutionType? resolution;
  // How it was resolved (null if unresolved)
  @override
  final int? resolvedAt;

  @override
  String toString() {
    return 'SyncConflict(id: $id, entityType: $entityType, entityId: $entityId, profileId: $profileId, localVersion: $localVersion, remoteVersion: $remoteVersion, localData: $localData, remoteData: $remoteData, detectedAt: $detectedAt, isResolved: $isResolved, resolution: $resolution, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncConflictImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.localVersion, localVersion) ||
                other.localVersion == localVersion) &&
            (identical(other.remoteVersion, remoteVersion) ||
                other.remoteVersion == remoteVersion) &&
            const DeepCollectionEquality().equals(
              other._localData,
              _localData,
            ) &&
            const DeepCollectionEquality().equals(
              other._remoteData,
              _remoteData,
            ) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    entityType,
    entityId,
    profileId,
    localVersion,
    remoteVersion,
    const DeepCollectionEquality().hash(_localData),
    const DeepCollectionEquality().hash(_remoteData),
    detectedAt,
    isResolved,
    resolution,
    resolvedAt,
  );

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncConflictImplCopyWith<_$SyncConflictImpl> get copyWith =>
      __$$SyncConflictImplCopyWithImpl<_$SyncConflictImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncConflictImplToJson(this);
  }
}

abstract class _SyncConflict extends SyncConflict {
  const factory _SyncConflict({
    required final String id,
    required final String entityType,
    required final String entityId,
    required final String profileId,
    required final int localVersion,
    required final int remoteVersion,
    required final Map<String, dynamic> localData,
    required final Map<String, dynamic> remoteData,
    required final int detectedAt,
    final bool isResolved,
    final ConflictResolutionType? resolution,
    final int? resolvedAt,
  }) = _$SyncConflictImpl;
  const _SyncConflict._() : super._();

  factory _SyncConflict.fromJson(Map<String, dynamic> json) =
      _$SyncConflictImpl.fromJson;

  @override
  String get id; // Unique conflict identifier (UUID v4)
  @override
  String get entityType; // Table name (e.g. 'supplements')
  @override
  String get entityId; // The conflicting entity's ID
  @override
  String get profileId;
  @override
  int get localVersion; // Local syncVersion at time of conflict
  @override
  int get remoteVersion; // Remote syncVersion at time of conflict
  @override
  Map<String, dynamic> get localData; // Full local entity JSON
  @override
  Map<String, dynamic> get remoteData; // Full remote entity JSON
  @override
  int get detectedAt; // Epoch ms when conflict was detected
  @override
  bool get isResolved;
  @override
  ConflictResolutionType? get resolution; // How it was resolved (null if unresolved)
  @override
  int? get resolvedAt;

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncConflictImplCopyWith<_$SyncConflictImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
