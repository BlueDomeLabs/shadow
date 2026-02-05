// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodItemImpl _$$FoodItemImplFromJson(Map<String, dynamic> json) =>
    _$FoodItemImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      name: json['name'] as String,
      type:
          $enumDecodeNullable(_$FoodItemTypeEnumMap, json['type']) ??
          FoodItemType.simple,
      simpleItemIds:
          (json['simpleItemIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isUserCreated: json['isUserCreated'] as bool? ?? true,
      isArchived: json['isArchived'] as bool? ?? false,
      servingSize: json['servingSize'] as String?,
      calories: (json['calories'] as num?)?.toDouble(),
      carbsGrams: (json['carbsGrams'] as num?)?.toDouble(),
      fatGrams: (json['fatGrams'] as num?)?.toDouble(),
      proteinGrams: (json['proteinGrams'] as num?)?.toDouble(),
      fiberGrams: (json['fiberGrams'] as num?)?.toDouble(),
      sugarGrams: (json['sugarGrams'] as num?)?.toDouble(),
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$FoodItemImplToJson(_$FoodItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'name': instance.name,
      'type': _$FoodItemTypeEnumMap[instance.type]!,
      'simpleItemIds': instance.simpleItemIds,
      'isUserCreated': instance.isUserCreated,
      'isArchived': instance.isArchived,
      'servingSize': instance.servingSize,
      'calories': instance.calories,
      'carbsGrams': instance.carbsGrams,
      'fatGrams': instance.fatGrams,
      'proteinGrams': instance.proteinGrams,
      'fiberGrams': instance.fiberGrams,
      'sugarGrams': instance.sugarGrams,
      'syncMetadata': instance.syncMetadata.toJson(),
    };

const _$FoodItemTypeEnumMap = {
  FoodItemType.simple: 'simple',
  FoodItemType.complex: 'complex',
};
