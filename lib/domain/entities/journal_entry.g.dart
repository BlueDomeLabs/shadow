// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JournalEntryImpl _$$JournalEntryImplFromJson(Map<String, dynamic> json) =>
    _$JournalEntryImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      content: json['content'] as String,
      title: json['title'] as String?,
      mood: (json['mood'] as num?)?.toInt(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      audioUrl: json['audioUrl'] as String?,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$JournalEntryImplToJson(_$JournalEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'timestamp': instance.timestamp,
      'content': instance.content,
      'title': instance.title,
      'mood': instance.mood,
      'tags': instance.tags,
      'audioUrl': instance.audioUrl,
      'syncMetadata': instance.syncMetadata.toJson(),
    };
