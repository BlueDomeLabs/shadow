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
      sodiumMg: (json['sodiumMg'] as num?)?.toDouble(),
      barcode: json['barcode'] as String?,
      brand: json['brand'] as String?,
      ingredientsText: json['ingredientsText'] as String?,
      openFoodFactsId: json['openFoodFactsId'] as String?,
      importSource: json['importSource'] as String?,
      imageUrl: json['imageUrl'] as String?,
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
      'sodiumMg': instance.sodiumMg,
      'barcode': instance.barcode,
      'brand': instance.brand,
      'ingredientsText': instance.ingredientsText,
      'openFoodFactsId': instance.openFoodFactsId,
      'importSource': instance.importSource,
      'imageUrl': instance.imageUrl,
      'syncMetadata': instance.syncMetadata.toJson(),
    };

const _$FoodItemTypeEnumMap = {
  FoodItemType.simple: 'simple',
  FoodItemType.composed: 'composed',
  FoodItemType.packaged: 'packaged',
};
