// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imported_vital.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImportedVitalImpl _$$ImportedVitalImplFromJson(Map<String, dynamic> json) =>
    _$ImportedVitalImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      dataType: $enumDecode(_$HealthDataTypeEnumMap, json['dataType']),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      recordedAt: (json['recordedAt'] as num).toInt(),
      sourcePlatform: $enumDecode(
        _$HealthSourcePlatformEnumMap,
        json['sourcePlatform'],
      ),
      sourceDevice: json['sourceDevice'] as String?,
      importedAt: (json['importedAt'] as num).toInt(),
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$ImportedVitalImplToJson(_$ImportedVitalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'dataType': _$HealthDataTypeEnumMap[instance.dataType]!,
      'value': instance.value,
      'unit': instance.unit,
      'recordedAt': instance.recordedAt,
      'sourcePlatform': _$HealthSourcePlatformEnumMap[instance.sourcePlatform]!,
      'sourceDevice': instance.sourceDevice,
      'importedAt': instance.importedAt,
      'syncMetadata': instance.syncMetadata,
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

const _$HealthSourcePlatformEnumMap = {
  HealthSourcePlatform.appleHealth: 'appleHealth',
  HealthSourcePlatform.googleHealthConnect: 'googleHealthConnect',
};
