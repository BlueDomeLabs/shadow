// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoAreaImpl _$$PhotoAreaImplFromJson(Map<String, dynamic> json) =>
    _$PhotoAreaImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      consistencyNotes: json['consistencyNotes'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isArchived: json['isArchived'] as bool? ?? false,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$PhotoAreaImplToJson(_$PhotoAreaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'name': instance.name,
      'description': instance.description,
      'consistencyNotes': instance.consistencyNotes,
      'sortOrder': instance.sortOrder,
      'isArchived': instance.isArchived,
      'syncMetadata': instance.syncMetadata.toJson(),
    };
