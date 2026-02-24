// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_violation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DietViolationImpl _$$DietViolationImplFromJson(Map<String, dynamic> json) =>
    _$DietViolationImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      profileId: json['profileId'] as String,
      dietId: json['dietId'] as String,
      ruleId: json['ruleId'] as String,
      foodLogId: json['foodLogId'] as String?,
      foodName: json['foodName'] as String,
      ruleDescription: json['ruleDescription'] as String,
      wasOverridden: json['wasOverridden'] as bool? ?? false,
      timestamp: (json['timestamp'] as num).toInt(),
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$DietViolationImplToJson(_$DietViolationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'dietId': instance.dietId,
      'ruleId': instance.ruleId,
      'foodLogId': instance.foodLogId,
      'foodName': instance.foodName,
      'ruleDescription': instance.ruleDescription,
      'wasOverridden': instance.wasOverridden,
      'timestamp': instance.timestamp,
      'syncMetadata': instance.syncMetadata.toJson(),
    };
