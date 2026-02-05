// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SleepEntryImpl _$$SleepEntryImplFromJson(Map<String, dynamic> json) =>
    _$SleepEntryImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      bedTime: (json['bedTime'] as num).toInt(),
      wakeTime: (json['wakeTime'] as num?)?.toInt(),
      deepSleepMinutes: (json['deepSleepMinutes'] as num?)?.toInt() ?? 0,
      lightSleepMinutes: (json['lightSleepMinutes'] as num?)?.toInt() ?? 0,
      restlessSleepMinutes:
          (json['restlessSleepMinutes'] as num?)?.toInt() ?? 0,
      dreamType:
          $enumDecodeNullable(_$DreamTypeEnumMap, json['dreamType']) ??
          DreamType.noDreams,
      wakingFeeling:
          $enumDecodeNullable(_$WakingFeelingEnumMap, json['wakingFeeling']) ??
          WakingFeeling.neutral,
      notes: json['notes'] as String?,
      importSource: json['importSource'] as String?,
      importExternalId: json['importExternalId'] as String?,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$SleepEntryImplToJson(_$SleepEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'bedTime': instance.bedTime,
      'wakeTime': instance.wakeTime,
      'deepSleepMinutes': instance.deepSleepMinutes,
      'lightSleepMinutes': instance.lightSleepMinutes,
      'restlessSleepMinutes': instance.restlessSleepMinutes,
      'dreamType': _$DreamTypeEnumMap[instance.dreamType]!,
      'wakingFeeling': _$WakingFeelingEnumMap[instance.wakingFeeling]!,
      'notes': instance.notes,
      'importSource': instance.importSource,
      'importExternalId': instance.importExternalId,
      'syncMetadata': instance.syncMetadata.toJson(),
    };

const _$DreamTypeEnumMap = {
  DreamType.noDreams: 'noDreams',
  DreamType.vague: 'vague',
  DreamType.vivid: 'vivid',
  DreamType.nightmares: 'nightmares',
};

const _$WakingFeelingEnumMap = {
  WakingFeeling.unrested: 'unrested',
  WakingFeeling.neutral: 'neutral',
  WakingFeeling.rested: 'rested',
};
