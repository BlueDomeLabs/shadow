// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fluids_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FluidsEntryImpl _$$FluidsEntryImplFromJson(Map<String, dynamic> json) =>
    _$FluidsEntryImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      entryDate: (json['entryDate'] as num).toInt(),
      waterIntakeMl: (json['waterIntakeMl'] as num?)?.toInt(),
      waterIntakeNotes: json['waterIntakeNotes'] as String?,
      bowelCondition: $enumDecodeNullable(
        _$BowelConditionEnumMap,
        json['bowelCondition'],
      ),
      bowelSize: $enumDecodeNullable(_$MovementSizeEnumMap, json['bowelSize']),
      bowelPhotoPath: json['bowelPhotoPath'] as String?,
      urineCondition: $enumDecodeNullable(
        _$UrineConditionEnumMap,
        json['urineCondition'],
      ),
      urineSize: $enumDecodeNullable(_$MovementSizeEnumMap, json['urineSize']),
      urinePhotoPath: json['urinePhotoPath'] as String?,
      menstruationFlow: $enumDecodeNullable(
        _$MenstruationFlowEnumMap,
        json['menstruationFlow'],
      ),
      basalBodyTemperature: (json['basalBodyTemperature'] as num?)?.toDouble(),
      bbtRecordedTime: (json['bbtRecordedTime'] as num?)?.toInt(),
      otherFluidName: json['otherFluidName'] as String?,
      otherFluidAmount: json['otherFluidAmount'] as String?,
      otherFluidNotes: json['otherFluidNotes'] as String?,
      importSource: json['importSource'] as String?,
      importExternalId: json['importExternalId'] as String?,
      cloudStorageUrl: json['cloudStorageUrl'] as String?,
      fileHash: json['fileHash'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
      isFileUploaded: json['isFileUploaded'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      photoIds:
          (json['photoIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$FluidsEntryImplToJson(_$FluidsEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'entryDate': instance.entryDate,
      'waterIntakeMl': instance.waterIntakeMl,
      'waterIntakeNotes': instance.waterIntakeNotes,
      'bowelCondition': _$BowelConditionEnumMap[instance.bowelCondition],
      'bowelSize': _$MovementSizeEnumMap[instance.bowelSize],
      'bowelPhotoPath': instance.bowelPhotoPath,
      'urineCondition': _$UrineConditionEnumMap[instance.urineCondition],
      'urineSize': _$MovementSizeEnumMap[instance.urineSize],
      'urinePhotoPath': instance.urinePhotoPath,
      'menstruationFlow': _$MenstruationFlowEnumMap[instance.menstruationFlow],
      'basalBodyTemperature': instance.basalBodyTemperature,
      'bbtRecordedTime': instance.bbtRecordedTime,
      'otherFluidName': instance.otherFluidName,
      'otherFluidAmount': instance.otherFluidAmount,
      'otherFluidNotes': instance.otherFluidNotes,
      'importSource': instance.importSource,
      'importExternalId': instance.importExternalId,
      'cloudStorageUrl': instance.cloudStorageUrl,
      'fileHash': instance.fileHash,
      'fileSizeBytes': instance.fileSizeBytes,
      'isFileUploaded': instance.isFileUploaded,
      'notes': instance.notes,
      'photoIds': instance.photoIds,
      'syncMetadata': instance.syncMetadata.toJson(),
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

const _$MovementSizeEnumMap = {
  MovementSize.tiny: 'tiny',
  MovementSize.small: 'small',
  MovementSize.medium: 'medium',
  MovementSize.large: 'large',
  MovementSize.huge: 'huge',
};

const _$UrineConditionEnumMap = {
  UrineCondition.clear: 'clear',
  UrineCondition.lightYellow: 'lightYellow',
  UrineCondition.darkYellow: 'darkYellow',
  UrineCondition.amber: 'amber',
  UrineCondition.brown: 'brown',
  UrineCondition.red: 'red',
  UrineCondition.custom: 'custom',
};

const _$MenstruationFlowEnumMap = {
  MenstruationFlow.none: 'none',
  MenstruationFlow.spotty: 'spotty',
  MenstruationFlow.light: 'light',
  MenstruationFlow.medium: 'medium',
  MenstruationFlow.heavy: 'heavy',
};
