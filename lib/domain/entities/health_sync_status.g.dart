// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_sync_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthSyncStatusImpl _$$HealthSyncStatusImplFromJson(
  Map<String, dynamic> json,
) => _$HealthSyncStatusImpl(
  id: json['id'] as String,
  profileId: json['profileId'] as String,
  dataType: $enumDecode(_$HealthDataTypeEnumMap, json['dataType']),
  lastSyncedAt: (json['lastSyncedAt'] as num?)?.toInt(),
  recordCount: (json['recordCount'] as num?)?.toInt() ?? 0,
  lastError: json['lastError'] as String?,
);

Map<String, dynamic> _$$HealthSyncStatusImplToJson(
  _$HealthSyncStatusImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'profileId': instance.profileId,
  'dataType': _$HealthDataTypeEnumMap[instance.dataType]!,
  'lastSyncedAt': instance.lastSyncedAt,
  'recordCount': instance.recordCount,
  'lastError': instance.lastError,
};

const _$HealthDataTypeEnumMap = {
  HealthDataType.heartRate: 'heartRate',
  HealthDataType.restingHeartRate: 'restingHeartRate',
  HealthDataType.weight: 'weight',
  HealthDataType.bpSystolic: 'bpSystolic',
  HealthDataType.bpDiastolic: 'bpDiastolic',
  HealthDataType.sleepDuration: 'sleepDuration',
  HealthDataType.steps: 'steps',
  HealthDataType.activeCalories: 'activeCalories',
  HealthDataType.bloodOxygen: 'bloodOxygen',
};
