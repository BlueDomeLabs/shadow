// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityImpl _$$ActivityImplFromJson(Map<String, dynamic> json) =>
    _$ActivityImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      triggers: json['triggers'] as String?,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      isArchived: json['isArchived'] as bool? ?? false,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$ActivityImplToJson(_$ActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'triggers': instance.triggers,
      'durationMinutes': instance.durationMinutes,
      'isArchived': instance.isArchived,
      'syncMetadata': instance.syncMetadata.toJson(),
    };
