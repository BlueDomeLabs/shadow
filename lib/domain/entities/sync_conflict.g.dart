// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_conflict.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncConflictImpl _$$SyncConflictImplFromJson(Map<String, dynamic> json) =>
    _$SyncConflictImpl(
      id: json['id'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      profileId: json['profileId'] as String,
      localVersion: (json['localVersion'] as num).toInt(),
      remoteVersion: (json['remoteVersion'] as num).toInt(),
      localData: json['localData'] as Map<String, dynamic>,
      remoteData: json['remoteData'] as Map<String, dynamic>,
      detectedAt: (json['detectedAt'] as num).toInt(),
      isResolved: json['isResolved'] as bool? ?? false,
      resolution: $enumDecodeNullable(
        _$ConflictResolutionTypeEnumMap,
        json['resolution'],
      ),
      resolvedAt: (json['resolvedAt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SyncConflictImplToJson(_$SyncConflictImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'profileId': instance.profileId,
      'localVersion': instance.localVersion,
      'remoteVersion': instance.remoteVersion,
      'localData': instance.localData,
      'remoteData': instance.remoteData,
      'detectedAt': instance.detectedAt,
      'isResolved': instance.isResolved,
      'resolution': _$ConflictResolutionTypeEnumMap[instance.resolution],
      'resolvedAt': instance.resolvedAt,
    };

const _$ConflictResolutionTypeEnumMap = {
  ConflictResolutionType.keepLocal: 'keepLocal',
  ConflictResolutionType.keepRemote: 'keepRemote',
  ConflictResolutionType.merge: 'merge',
};
