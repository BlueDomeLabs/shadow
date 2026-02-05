// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intake_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IntakeLogImpl _$$IntakeLogImplFromJson(Map<String, dynamic> json) =>
    _$IntakeLogImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      supplementId: json['supplementId'] as String,
      scheduledTime: (json['scheduledTime'] as num).toInt(),
      actualTime: (json['actualTime'] as num?)?.toInt(),
      status:
          $enumDecodeNullable(_$IntakeLogStatusEnumMap, json['status']) ??
          IntakeLogStatus.pending,
      reason: json['reason'] as String?,
      note: json['note'] as String?,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$IntakeLogImplToJson(_$IntakeLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'supplementId': instance.supplementId,
      'scheduledTime': instance.scheduledTime,
      'actualTime': instance.actualTime,
      'status': _$IntakeLogStatusEnumMap[instance.status]!,
      'reason': instance.reason,
      'note': instance.note,
      'syncMetadata': instance.syncMetadata.toJson(),
    };

const _$IntakeLogStatusEnumMap = {
  IntakeLogStatus.pending: 'pending',
  IntakeLogStatus.taken: 'taken',
  IntakeLogStatus.skipped: 'skipped',
  IntakeLogStatus.missed: 'missed',
};
