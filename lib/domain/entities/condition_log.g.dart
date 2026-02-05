// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConditionLogImpl _$$ConditionLogImplFromJson(Map<String, dynamic> json) =>
    _$ConditionLogImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      conditionId: json['conditionId'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      severity: (json['severity'] as num).toInt(),
      notes: json['notes'] as String?,
      isFlare: json['isFlare'] as bool? ?? false,
      flarePhotoIds:
          (json['flarePhotoIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      photoPath: json['photoPath'] as String?,
      activityId: json['activityId'] as String?,
      triggers: json['triggers'] as String?,
      cloudStorageUrl: json['cloudStorageUrl'] as String?,
      fileHash: json['fileHash'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
      isFileUploaded: json['isFileUploaded'] as bool? ?? false,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$ConditionLogImplToJson(_$ConditionLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'conditionId': instance.conditionId,
      'timestamp': instance.timestamp,
      'severity': instance.severity,
      'notes': instance.notes,
      'isFlare': instance.isFlare,
      'flarePhotoIds': instance.flarePhotoIds,
      'photoPath': instance.photoPath,
      'activityId': instance.activityId,
      'triggers': instance.triggers,
      'cloudStorageUrl': instance.cloudStorageUrl,
      'fileHash': instance.fileHash,
      'fileSizeBytes': instance.fileSizeBytes,
      'isFileUploaded': instance.isFileUploaded,
      'syncMetadata': instance.syncMetadata.toJson(),
    };
