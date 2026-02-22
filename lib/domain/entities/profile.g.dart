// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      name: json['name'] as String,
      birthDate: (json['birthDate'] as num?)?.toInt(),
      biologicalSex: $enumDecodeNullable(
        _$BiologicalSexEnumMap,
        json['biologicalSex'],
      ),
      ethnicity: json['ethnicity'] as String?,
      notes: json['notes'] as String?,
      ownerId: json['ownerId'] as String?,
      dietType:
          $enumDecodeNullable(_$ProfileDietTypeEnumMap, json['dietType']) ??
          ProfileDietType.none,
      dietDescription: json['dietDescription'] as String?,
      syncMetadata: SyncMetadata.fromJson(
        json['syncMetadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'name': instance.name,
      'birthDate': instance.birthDate,
      'biologicalSex': _$BiologicalSexEnumMap[instance.biologicalSex],
      'ethnicity': instance.ethnicity,
      'notes': instance.notes,
      'ownerId': instance.ownerId,
      'dietType': _$ProfileDietTypeEnumMap[instance.dietType]!,
      'dietDescription': instance.dietDescription,
      'syncMetadata': instance.syncMetadata.toJson(),
    };

const _$BiologicalSexEnumMap = {
  BiologicalSex.male: 'male',
  BiologicalSex.female: 'female',
  BiologicalSex.other: 'other',
};

const _$ProfileDietTypeEnumMap = {
  ProfileDietType.none: 'none',
  ProfileDietType.vegan: 'vegan',
  ProfileDietType.vegetarian: 'vegetarian',
  ProfileDietType.paleo: 'paleo',
  ProfileDietType.keto: 'keto',
  ProfileDietType.glutenFree: 'glutenFree',
  ProfileDietType.other: 'other',
};
