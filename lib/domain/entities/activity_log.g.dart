// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityLogImpl _$$ActivityLogImplFromJson(Map<String, dynamic> json) =>
    _$ActivityLogImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      activityIds:
          (json['activityIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      adHocActivities:
          (json['adHocActivities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      duration: (json['duration'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      importSource: json['importSource'] as String?,
      importExternalId: json['importExternalId'] as String?,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$ActivityLogImplToJson(_$ActivityLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'timestamp': instance.timestamp,
      'activityIds': instance.activityIds,
      'adHocActivities': instance.adHocActivities,
      'duration': instance.duration,
      'notes': instance.notes,
      'importSource': instance.importSource,
      'importExternalId': instance.importExternalId,
      'syncMetadata': instance.syncMetadata.toJson(),
    };
