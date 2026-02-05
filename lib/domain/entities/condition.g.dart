// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConditionImpl _$$ConditionImplFromJson(Map<String, dynamic> json) =>
    _$ConditionImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      bodyLocations: (json['bodyLocations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      baselinePhotoPath: json['baselinePhotoPath'] as String?,
      startTimeframe: (json['startTimeframe'] as num).toInt(),
      endDate: (json['endDate'] as num?)?.toInt(),
      status:
          $enumDecodeNullable(_$ConditionStatusEnumMap, json['status']) ??
          ConditionStatus.active,
      isArchived: json['isArchived'] as bool? ?? false,
      activityId: json['activityId'] as String?,
      cloudStorageUrl: json['cloudStorageUrl'] as String?,
      fileHash: json['fileHash'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
      isFileUploaded: json['isFileUploaded'] as bool? ?? false,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$ConditionImplToJson(_$ConditionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'name': instance.name,
      'category': instance.category,
      'bodyLocations': instance.bodyLocations,
      'description': instance.description,
      'baselinePhotoPath': instance.baselinePhotoPath,
      'startTimeframe': instance.startTimeframe,
      'endDate': instance.endDate,
      'status': _$ConditionStatusEnumMap[instance.status]!,
      'isArchived': instance.isArchived,
      'activityId': instance.activityId,
      'cloudStorageUrl': instance.cloudStorageUrl,
      'fileHash': instance.fileHash,
      'fileSizeBytes': instance.fileSizeBytes,
      'isFileUploaded': instance.isFileUploaded,
      'syncMetadata': instance.syncMetadata.toJson(),
    };

const _$ConditionStatusEnumMap = {
  ConditionStatus.active: 'active',
  ConditionStatus.resolved: 'resolved',
};
