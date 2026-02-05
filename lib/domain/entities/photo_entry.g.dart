// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoEntryImpl _$$PhotoEntryImplFromJson(Map<String, dynamic> json) =>
    _$PhotoEntryImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      photoAreaId: json['photoAreaId'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      filePath: json['filePath'] as String,
      notes: json['notes'] as String?,
      cloudStorageUrl: json['cloudStorageUrl'] as String?,
      fileHash: json['fileHash'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
      isFileUploaded: json['isFileUploaded'] as bool? ?? false,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$PhotoEntryImplToJson(_$PhotoEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'photoAreaId': instance.photoAreaId,
      'timestamp': instance.timestamp,
      'filePath': instance.filePath,
      'notes': instance.notes,
      'cloudStorageUrl': instance.cloudStorageUrl,
      'fileHash': instance.fileHash,
      'fileSizeBytes': instance.fileSizeBytes,
      'isFileUploaded': instance.isFileUploaded,
      'syncMetadata': instance.syncMetadata.toJson(),
    };
