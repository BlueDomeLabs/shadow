// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SyncMetadata _$SyncMetadataFromJson(Map<String, dynamic> json) {
  return _SyncMetadata.fromJson(json);
}

/// @nodoc
mixin _$SyncMetadata {
  // Dart field: syncCreatedAt → DB column: sync_created_at
  @JsonKey(name: 'sync_created_at')
  int get syncCreatedAt => throw _privateConstructorUsedError; // Epoch milliseconds
  // Dart field: syncUpdatedAt → DB column: sync_updated_at
  @JsonKey(name: 'sync_updated_at')
  int get syncUpdatedAt => throw _privateConstructorUsedError; // Epoch milliseconds
  // Dart field: syncDeletedAt → DB column: sync_deleted_at
  @JsonKey(name: 'sync_deleted_at')
  int? get syncDeletedAt => throw _privateConstructorUsedError; // Null = not deleted
  // Dart field: syncLastSyncedAt → DB column: sync_last_synced_at
  @JsonKey(name: 'sync_last_synced_at')
  int? get syncLastSyncedAt => throw _privateConstructorUsedError; // Last cloud sync
  // Dart field: syncStatus → DB column: sync_status
  @JsonKey(name: 'sync_status')
  SyncStatus get syncStatus => throw _privateConstructorUsedError; // Dart field: syncVersion → DB column: sync_version
  @JsonKey(name: 'sync_version')
  int get syncVersion => throw _privateConstructorUsedError; // Optimistic concurrency
  // Dart field: syncDeviceId → DB column: sync_device_id
  @JsonKey(name: 'sync_device_id')
  String get syncDeviceId => throw _privateConstructorUsedError; // Last modifying device
  // Dart field: syncIsDirty → DB column: sync_is_dirty
  @JsonKey(name: 'sync_is_dirty')
  bool get syncIsDirty => throw _privateConstructorUsedError; // Unsynchronized changes
  // Dart field: conflictData → DB column: conflict_data
  @JsonKey(name: 'conflict_data')
  String? get conflictData => throw _privateConstructorUsedError;

  /// Serializes this SyncMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncMetadataCopyWith<SyncMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncMetadataCopyWith<$Res> {
  factory $SyncMetadataCopyWith(
    SyncMetadata value,
    $Res Function(SyncMetadata) then,
  ) = _$SyncMetadataCopyWithImpl<$Res, SyncMetadata>;
  @useResult
  $Res call({
    @JsonKey(name: 'sync_created_at') int syncCreatedAt,
    @JsonKey(name: 'sync_updated_at') int syncUpdatedAt,
    @JsonKey(name: 'sync_deleted_at') int? syncDeletedAt,
    @JsonKey(name: 'sync_last_synced_at') int? syncLastSyncedAt,
    @JsonKey(name: 'sync_status') SyncStatus syncStatus,
    @JsonKey(name: 'sync_version') int syncVersion,
    @JsonKey(name: 'sync_device_id') String syncDeviceId,
    @JsonKey(name: 'sync_is_dirty') bool syncIsDirty,
    @JsonKey(name: 'conflict_data') String? conflictData,
  });
}

/// @nodoc
class _$SyncMetadataCopyWithImpl<$Res, $Val extends SyncMetadata>
    implements $SyncMetadataCopyWith<$Res> {
  _$SyncMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syncCreatedAt = null,
    Object? syncUpdatedAt = null,
    Object? syncDeletedAt = freezed,
    Object? syncLastSyncedAt = freezed,
    Object? syncStatus = null,
    Object? syncVersion = null,
    Object? syncDeviceId = null,
    Object? syncIsDirty = null,
    Object? conflictData = freezed,
  }) {
    return _then(
      _value.copyWith(
            syncCreatedAt: null == syncCreatedAt
                ? _value.syncCreatedAt
                : syncCreatedAt // ignore: cast_nullable_to_non_nullable
                      as int,
            syncUpdatedAt: null == syncUpdatedAt
                ? _value.syncUpdatedAt
                : syncUpdatedAt // ignore: cast_nullable_to_non_nullable
                      as int,
            syncDeletedAt: freezed == syncDeletedAt
                ? _value.syncDeletedAt
                : syncDeletedAt // ignore: cast_nullable_to_non_nullable
                      as int?,
            syncLastSyncedAt: freezed == syncLastSyncedAt
                ? _value.syncLastSyncedAt
                : syncLastSyncedAt // ignore: cast_nullable_to_non_nullable
                      as int?,
            syncStatus: null == syncStatus
                ? _value.syncStatus
                : syncStatus // ignore: cast_nullable_to_non_nullable
                      as SyncStatus,
            syncVersion: null == syncVersion
                ? _value.syncVersion
                : syncVersion // ignore: cast_nullable_to_non_nullable
                      as int,
            syncDeviceId: null == syncDeviceId
                ? _value.syncDeviceId
                : syncDeviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            syncIsDirty: null == syncIsDirty
                ? _value.syncIsDirty
                : syncIsDirty // ignore: cast_nullable_to_non_nullable
                      as bool,
            conflictData: freezed == conflictData
                ? _value.conflictData
                : conflictData // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncMetadataImplCopyWith<$Res>
    implements $SyncMetadataCopyWith<$Res> {
  factory _$$SyncMetadataImplCopyWith(
    _$SyncMetadataImpl value,
    $Res Function(_$SyncMetadataImpl) then,
  ) = __$$SyncMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'sync_created_at') int syncCreatedAt,
    @JsonKey(name: 'sync_updated_at') int syncUpdatedAt,
    @JsonKey(name: 'sync_deleted_at') int? syncDeletedAt,
    @JsonKey(name: 'sync_last_synced_at') int? syncLastSyncedAt,
    @JsonKey(name: 'sync_status') SyncStatus syncStatus,
    @JsonKey(name: 'sync_version') int syncVersion,
    @JsonKey(name: 'sync_device_id') String syncDeviceId,
    @JsonKey(name: 'sync_is_dirty') bool syncIsDirty,
    @JsonKey(name: 'conflict_data') String? conflictData,
  });
}

/// @nodoc
class __$$SyncMetadataImplCopyWithImpl<$Res>
    extends _$SyncMetadataCopyWithImpl<$Res, _$SyncMetadataImpl>
    implements _$$SyncMetadataImplCopyWith<$Res> {
  __$$SyncMetadataImplCopyWithImpl(
    _$SyncMetadataImpl _value,
    $Res Function(_$SyncMetadataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syncCreatedAt = null,
    Object? syncUpdatedAt = null,
    Object? syncDeletedAt = freezed,
    Object? syncLastSyncedAt = freezed,
    Object? syncStatus = null,
    Object? syncVersion = null,
    Object? syncDeviceId = null,
    Object? syncIsDirty = null,
    Object? conflictData = freezed,
  }) {
    return _then(
      _$SyncMetadataImpl(
        syncCreatedAt: null == syncCreatedAt
            ? _value.syncCreatedAt
            : syncCreatedAt // ignore: cast_nullable_to_non_nullable
                  as int,
        syncUpdatedAt: null == syncUpdatedAt
            ? _value.syncUpdatedAt
            : syncUpdatedAt // ignore: cast_nullable_to_non_nullable
                  as int,
        syncDeletedAt: freezed == syncDeletedAt
            ? _value.syncDeletedAt
            : syncDeletedAt // ignore: cast_nullable_to_non_nullable
                  as int?,
        syncLastSyncedAt: freezed == syncLastSyncedAt
            ? _value.syncLastSyncedAt
            : syncLastSyncedAt // ignore: cast_nullable_to_non_nullable
                  as int?,
        syncStatus: null == syncStatus
            ? _value.syncStatus
            : syncStatus // ignore: cast_nullable_to_non_nullable
                  as SyncStatus,
        syncVersion: null == syncVersion
            ? _value.syncVersion
            : syncVersion // ignore: cast_nullable_to_non_nullable
                  as int,
        syncDeviceId: null == syncDeviceId
            ? _value.syncDeviceId
            : syncDeviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        syncIsDirty: null == syncIsDirty
            ? _value.syncIsDirty
            : syncIsDirty // ignore: cast_nullable_to_non_nullable
                  as bool,
        conflictData: freezed == conflictData
            ? _value.conflictData
            : conflictData // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncMetadataImpl extends _SyncMetadata {
  const _$SyncMetadataImpl({
    @JsonKey(name: 'sync_created_at') required this.syncCreatedAt,
    @JsonKey(name: 'sync_updated_at') required this.syncUpdatedAt,
    @JsonKey(name: 'sync_deleted_at') this.syncDeletedAt,
    @JsonKey(name: 'sync_last_synced_at') this.syncLastSyncedAt,
    @JsonKey(name: 'sync_status') this.syncStatus = SyncStatus.pending,
    @JsonKey(name: 'sync_version') this.syncVersion = 1,
    @JsonKey(name: 'sync_device_id') required this.syncDeviceId,
    @JsonKey(name: 'sync_is_dirty') this.syncIsDirty = true,
    @JsonKey(name: 'conflict_data') this.conflictData,
  }) : super._();

  factory _$SyncMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncMetadataImplFromJson(json);

  // Dart field: syncCreatedAt → DB column: sync_created_at
  @override
  @JsonKey(name: 'sync_created_at')
  final int syncCreatedAt;
  // Epoch milliseconds
  // Dart field: syncUpdatedAt → DB column: sync_updated_at
  @override
  @JsonKey(name: 'sync_updated_at')
  final int syncUpdatedAt;
  // Epoch milliseconds
  // Dart field: syncDeletedAt → DB column: sync_deleted_at
  @override
  @JsonKey(name: 'sync_deleted_at')
  final int? syncDeletedAt;
  // Null = not deleted
  // Dart field: syncLastSyncedAt → DB column: sync_last_synced_at
  @override
  @JsonKey(name: 'sync_last_synced_at')
  final int? syncLastSyncedAt;
  // Last cloud sync
  // Dart field: syncStatus → DB column: sync_status
  @override
  @JsonKey(name: 'sync_status')
  final SyncStatus syncStatus;
  // Dart field: syncVersion → DB column: sync_version
  @override
  @JsonKey(name: 'sync_version')
  final int syncVersion;
  // Optimistic concurrency
  // Dart field: syncDeviceId → DB column: sync_device_id
  @override
  @JsonKey(name: 'sync_device_id')
  final String syncDeviceId;
  // Last modifying device
  // Dart field: syncIsDirty → DB column: sync_is_dirty
  @override
  @JsonKey(name: 'sync_is_dirty')
  final bool syncIsDirty;
  // Unsynchronized changes
  // Dart field: conflictData → DB column: conflict_data
  @override
  @JsonKey(name: 'conflict_data')
  final String? conflictData;

  @override
  String toString() {
    return 'SyncMetadata(syncCreatedAt: $syncCreatedAt, syncUpdatedAt: $syncUpdatedAt, syncDeletedAt: $syncDeletedAt, syncLastSyncedAt: $syncLastSyncedAt, syncStatus: $syncStatus, syncVersion: $syncVersion, syncDeviceId: $syncDeviceId, syncIsDirty: $syncIsDirty, conflictData: $conflictData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncMetadataImpl &&
            (identical(other.syncCreatedAt, syncCreatedAt) ||
                other.syncCreatedAt == syncCreatedAt) &&
            (identical(other.syncUpdatedAt, syncUpdatedAt) ||
                other.syncUpdatedAt == syncUpdatedAt) &&
            (identical(other.syncDeletedAt, syncDeletedAt) ||
                other.syncDeletedAt == syncDeletedAt) &&
            (identical(other.syncLastSyncedAt, syncLastSyncedAt) ||
                other.syncLastSyncedAt == syncLastSyncedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.syncVersion, syncVersion) ||
                other.syncVersion == syncVersion) &&
            (identical(other.syncDeviceId, syncDeviceId) ||
                other.syncDeviceId == syncDeviceId) &&
            (identical(other.syncIsDirty, syncIsDirty) ||
                other.syncIsDirty == syncIsDirty) &&
            (identical(other.conflictData, conflictData) ||
                other.conflictData == conflictData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    syncCreatedAt,
    syncUpdatedAt,
    syncDeletedAt,
    syncLastSyncedAt,
    syncStatus,
    syncVersion,
    syncDeviceId,
    syncIsDirty,
    conflictData,
  );

  /// Create a copy of SyncMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncMetadataImplCopyWith<_$SyncMetadataImpl> get copyWith =>
      __$$SyncMetadataImplCopyWithImpl<_$SyncMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncMetadataImplToJson(this);
  }
}

abstract class _SyncMetadata extends SyncMetadata {
  const factory _SyncMetadata({
    @JsonKey(name: 'sync_created_at') required final int syncCreatedAt,
    @JsonKey(name: 'sync_updated_at') required final int syncUpdatedAt,
    @JsonKey(name: 'sync_deleted_at') final int? syncDeletedAt,
    @JsonKey(name: 'sync_last_synced_at') final int? syncLastSyncedAt,
    @JsonKey(name: 'sync_status') final SyncStatus syncStatus,
    @JsonKey(name: 'sync_version') final int syncVersion,
    @JsonKey(name: 'sync_device_id') required final String syncDeviceId,
    @JsonKey(name: 'sync_is_dirty') final bool syncIsDirty,
    @JsonKey(name: 'conflict_data') final String? conflictData,
  }) = _$SyncMetadataImpl;
  const _SyncMetadata._() : super._();

  factory _SyncMetadata.fromJson(Map<String, dynamic> json) =
      _$SyncMetadataImpl.fromJson;

  // Dart field: syncCreatedAt → DB column: sync_created_at
  @override
  @JsonKey(name: 'sync_created_at')
  int get syncCreatedAt; // Epoch milliseconds
  // Dart field: syncUpdatedAt → DB column: sync_updated_at
  @override
  @JsonKey(name: 'sync_updated_at')
  int get syncUpdatedAt; // Epoch milliseconds
  // Dart field: syncDeletedAt → DB column: sync_deleted_at
  @override
  @JsonKey(name: 'sync_deleted_at')
  int? get syncDeletedAt; // Null = not deleted
  // Dart field: syncLastSyncedAt → DB column: sync_last_synced_at
  @override
  @JsonKey(name: 'sync_last_synced_at')
  int? get syncLastSyncedAt; // Last cloud sync
  // Dart field: syncStatus → DB column: sync_status
  @override
  @JsonKey(name: 'sync_status')
  SyncStatus get syncStatus; // Dart field: syncVersion → DB column: sync_version
  @override
  @JsonKey(name: 'sync_version')
  int get syncVersion; // Optimistic concurrency
  // Dart field: syncDeviceId → DB column: sync_device_id
  @override
  @JsonKey(name: 'sync_device_id')
  String get syncDeviceId; // Last modifying device
  // Dart field: syncIsDirty → DB column: sync_is_dirty
  @override
  @JsonKey(name: 'sync_is_dirty')
  bool get syncIsDirty; // Unsynchronized changes
  // Dart field: conflictData → DB column: conflict_data
  @override
  @JsonKey(name: 'conflict_data')
  String? get conflictData;

  /// Create a copy of SyncMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncMetadataImplCopyWith<_$SyncMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
