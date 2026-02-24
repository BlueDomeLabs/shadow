// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fasting_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FastingSessionImpl _$$FastingSessionImplFromJson(Map<String, dynamic> json) =>
    _$FastingSessionImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      protocol: $enumDecode(_$DietPresetTypeEnumMap, json['protocol']),
      startedAt: (json['startedAt'] as num).toInt(),
      endedAt: (json['endedAt'] as num?)?.toInt(),
      targetHours: (json['targetHours'] as num).toDouble(),
      isManualEnd: json['isManualEnd'] as bool? ?? false,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$FastingSessionImplToJson(
  _$FastingSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'profileId': instance.profileId,
  'protocol': _$DietPresetTypeEnumMap[instance.protocol]!,
  'startedAt': instance.startedAt,
  'endedAt': instance.endedAt,
  'targetHours': instance.targetHours,
  'isManualEnd': instance.isManualEnd,
  'syncMetadata': instance.syncMetadata.toJson(),
};

const _$DietPresetTypeEnumMap = {
  DietPresetType.vegan: 'vegan',
  DietPresetType.vegetarian: 'vegetarian',
  DietPresetType.pescatarian: 'pescatarian',
  DietPresetType.paleo: 'paleo',
  DietPresetType.keto: 'keto',
  DietPresetType.ketoStrict: 'ketoStrict',
  DietPresetType.lowCarb: 'lowCarb',
  DietPresetType.mediterranean: 'mediterranean',
  DietPresetType.whole30: 'whole30',
  DietPresetType.aip: 'aip',
  DietPresetType.lowFodmap: 'lowFodmap',
  DietPresetType.glutenFree: 'glutenFree',
  DietPresetType.dairyFree: 'dairyFree',
  DietPresetType.if168: 'if168',
  DietPresetType.if186: 'if186',
  DietPresetType.if204: 'if204',
  DietPresetType.omad: 'omad',
  DietPresetType.fiveTwoDiet: 'fiveTwoDiet',
  DietPresetType.zone: 'zone',
  DietPresetType.custom: 'custom',
};
