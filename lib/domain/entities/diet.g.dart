// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DietImpl _$$DietImplFromJson(Map<String, dynamic> json) => _$DietImpl(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  profileId: json['profileId'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  presetType: $enumDecodeNullable(_$DietPresetTypeEnumMap, json['presetType']),
  isActive: json['isActive'] as bool? ?? false,
  startDate: (json['startDate'] as num).toInt(),
  endDate: (json['endDate'] as num?)?.toInt(),
  isDraft: json['isDraft'] as bool? ?? false,
  syncMetadata: SyncMetadata.fromJson(
    json['syncMetadata'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$DietImplToJson(_$DietImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'name': instance.name,
      'description': instance.description,
      'presetType': _$DietPresetTypeEnumMap[instance.presetType],
      'isActive': instance.isActive,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'isDraft': instance.isDraft,
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
