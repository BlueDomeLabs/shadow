// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flare_up.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlareUpImpl _$$FlareUpImplFromJson(Map<String, dynamic> json) =>
    _$FlareUpImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      conditionId: json['conditionId'] as String,
      startDate: (json['startDate'] as num).toInt(),
      endDate: (json['endDate'] as num?)?.toInt(),
      severity: (json['severity'] as num).toInt(),
      notes: json['notes'] as String?,
      triggers: (json['triggers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      activityId: json['activityId'] as String?,
      photoPath: json['photoPath'] as String?,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$FlareUpImplToJson(_$FlareUpImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'conditionId': instance.conditionId,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'severity': instance.severity,
      'notes': instance.notes,
      'triggers': instance.triggers,
      'activityId': instance.activityId,
      'photoPath': instance.photoPath,
      'syncMetadata': instance.syncMetadata.toJson(),
    };
