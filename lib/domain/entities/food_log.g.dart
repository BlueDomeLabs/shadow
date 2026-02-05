// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodLogImpl _$$FoodLogImplFromJson(Map<String, dynamic> json) =>
    _$FoodLogImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      foodItemIds:
          (json['foodItemIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      adHocItems:
          (json['adHocItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$FoodLogImplToJson(_$FoodLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'timestamp': instance.timestamp,
      'foodItemIds': instance.foodItemIds,
      'adHocItems': instance.adHocItems,
      'notes': instance.notes,
      'syncMetadata': instance.syncMetadata.toJson(),
    };
