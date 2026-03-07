// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bodily_output_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BodilyOutputLogImpl _$$BodilyOutputLogImplFromJson(
  Map<String, dynamic> json,
) => _$BodilyOutputLogImpl(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  profileId: json['profileId'] as String,
  occurredAt: (json['occurredAt'] as num).toInt(),
  outputType: $enumDecode(_$BodyOutputTypeEnumMap, json['outputType']),
  customTypeLabel: json['customTypeLabel'] as String?,
  urineCondition: $enumDecodeNullable(
    _$UrineConditionEnumMap,
    json['urineCondition'],
  ),
  urineCustomCondition: json['urineCustomCondition'] as String?,
  urineSize: $enumDecodeNullable(_$OutputSizeEnumMap, json['urineSize']),
  bowelCondition: $enumDecodeNullable(
    _$BowelConditionEnumMap,
    json['bowelCondition'],
  ),
  bowelCustomCondition: json['bowelCustomCondition'] as String?,
  bowelSize: $enumDecodeNullable(_$OutputSizeEnumMap, json['bowelSize']),
  gasSeverity: $enumDecodeNullable(_$GasSeverityEnumMap, json['gasSeverity']),
  menstruationFlow: $enumDecodeNullable(
    _$MenstruationFlowEnumMap,
    json['menstruationFlow'],
  ),
  temperatureValue: (json['temperatureValue'] as num?)?.toDouble(),
  temperatureUnit: $enumDecodeNullable(
    _$TemperatureUnitEnumMap,
    json['temperatureUnit'],
  ),
  notes: json['notes'] as String?,
  photoPath: json['photoPath'] as String?,
  cloudStorageUrl: json['cloudStorageUrl'] as String?,
  fileHash: json['fileHash'] as String?,
  fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
  isFileUploaded: json['isFileUploaded'] as bool? ?? false,
  importSource: json['importSource'] as String?,
  importExternalId: json['importExternalId'] as String?,
  syncMetadata: SyncMetadata.fromJson(
    json['syncMetadata'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$BodilyOutputLogImplToJson(
  _$BodilyOutputLogImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'profileId': instance.profileId,
  'occurredAt': instance.occurredAt,
  'outputType': _$BodyOutputTypeEnumMap[instance.outputType]!,
  'customTypeLabel': instance.customTypeLabel,
  'urineCondition': _$UrineConditionEnumMap[instance.urineCondition],
  'urineCustomCondition': instance.urineCustomCondition,
  'urineSize': _$OutputSizeEnumMap[instance.urineSize],
  'bowelCondition': _$BowelConditionEnumMap[instance.bowelCondition],
  'bowelCustomCondition': instance.bowelCustomCondition,
  'bowelSize': _$OutputSizeEnumMap[instance.bowelSize],
  'gasSeverity': _$GasSeverityEnumMap[instance.gasSeverity],
  'menstruationFlow': _$MenstruationFlowEnumMap[instance.menstruationFlow],
  'temperatureValue': instance.temperatureValue,
  'temperatureUnit': _$TemperatureUnitEnumMap[instance.temperatureUnit],
  'notes': instance.notes,
  'photoPath': instance.photoPath,
  'cloudStorageUrl': instance.cloudStorageUrl,
  'fileHash': instance.fileHash,
  'fileSizeBytes': instance.fileSizeBytes,
  'isFileUploaded': instance.isFileUploaded,
  'importSource': instance.importSource,
  'importExternalId': instance.importExternalId,
  'syncMetadata': instance.syncMetadata.toJson(),
};

const _$BodyOutputTypeEnumMap = {
  BodyOutputType.urine: 'urine',
  BodyOutputType.bowel: 'bowel',
  BodyOutputType.gas: 'gas',
  BodyOutputType.menstruation: 'menstruation',
  BodyOutputType.bbt: 'bbt',
  BodyOutputType.custom: 'custom',
};

const _$UrineConditionEnumMap = {
  UrineCondition.clear: 'clear',
  UrineCondition.lightYellow: 'lightYellow',
  UrineCondition.yellow: 'yellow',
  UrineCondition.darkYellow: 'darkYellow',
  UrineCondition.amber: 'amber',
  UrineCondition.brown: 'brown',
  UrineCondition.red: 'red',
  UrineCondition.custom: 'custom',
};

const _$OutputSizeEnumMap = {
  OutputSize.tiny: 'tiny',
  OutputSize.small: 'small',
  OutputSize.medium: 'medium',
  OutputSize.large: 'large',
  OutputSize.huge: 'huge',
};

const _$BowelConditionEnumMap = {
  BowelCondition.diarrhea: 'diarrhea',
  BowelCondition.runny: 'runny',
  BowelCondition.loose: 'loose',
  BowelCondition.normal: 'normal',
  BowelCondition.firm: 'firm',
  BowelCondition.hard: 'hard',
  BowelCondition.custom: 'custom',
};

const _$GasSeverityEnumMap = {
  GasSeverity.mild: 'mild',
  GasSeverity.moderate: 'moderate',
  GasSeverity.severe: 'severe',
};

const _$MenstruationFlowEnumMap = {
  MenstruationFlow.spotting: 'spotting',
  MenstruationFlow.light: 'light',
  MenstruationFlow.medium: 'medium',
  MenstruationFlow.heavy: 'heavy',
};

const _$TemperatureUnitEnumMap = {
  TemperatureUnit.celsius: 'celsius',
  TemperatureUnit.fahrenheit: 'fahrenheit',
};
