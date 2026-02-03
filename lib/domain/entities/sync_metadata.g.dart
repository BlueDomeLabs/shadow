// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncMetadataImpl _$$SyncMetadataImplFromJson(Map<String, dynamic> json) =>
    _$SyncMetadataImpl(
      syncCreatedAt: (json['sync_created_at'] as num).toInt(),
      syncUpdatedAt: (json['sync_updated_at'] as num).toInt(),
      syncDeletedAt: (json['sync_deleted_at'] as num?)?.toInt(),
      syncLastSyncedAt: (json['sync_last_synced_at'] as num?)?.toInt(),
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['sync_status']) ??
          SyncStatus.pending,
      syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
      syncDeviceId: json['sync_device_id'] as String,
      syncIsDirty: json['sync_is_dirty'] as bool? ?? true,
      conflictData: json['conflict_data'] as String?,
    );

Map<String, dynamic> _$$SyncMetadataImplToJson(_$SyncMetadataImpl instance) =>
    <String, dynamic>{
      'sync_created_at': instance.syncCreatedAt,
      'sync_updated_at': instance.syncUpdatedAt,
      'sync_deleted_at': instance.syncDeletedAt,
      'sync_last_synced_at': instance.syncLastSyncedAt,
      'sync_status': _$SyncStatusEnumMap[instance.syncStatus]!,
      'sync_version': instance.syncVersion,
      'sync_device_id': instance.syncDeviceId,
      'sync_is_dirty': instance.syncIsDirty,
      'conflict_data': instance.conflictData,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'pending',
  SyncStatus.synced: 'synced',
  SyncStatus.modified: 'modified',
  SyncStatus.conflict: 'conflict',
  SyncStatus.deleted: 'deleted',
};
