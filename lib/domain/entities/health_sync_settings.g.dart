// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_sync_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthSyncSettingsImpl _$$HealthSyncSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$HealthSyncSettingsImpl(
  id: json['id'] as String,
  profileId: json['profileId'] as String,
  enabledDataTypes:
      (json['enabledDataTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$HealthDataTypeEnumMap, e))
          .toList() ??
      const [],
  dateRangeDays: (json['dateRangeDays'] as num?)?.toInt() ?? 30,
);

Map<String, dynamic> _$$HealthSyncSettingsImplToJson(
  _$HealthSyncSettingsImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'profileId': instance.profileId,
  'enabledDataTypes': instance.enabledDataTypes
      .map((e) => _$HealthDataTypeEnumMap[e]!)
      .toList(),
  'dateRangeDays': instance.dateRangeDays,
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
