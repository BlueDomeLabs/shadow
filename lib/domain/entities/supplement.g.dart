// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupplementImpl _$$SupplementImplFromJson(
  Map<String, dynamic> json,
) => _$SupplementImpl(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  profileId: json['profileId'] as String,
  name: json['name'] as String,
  form: $enumDecode(_$SupplementFormEnumMap, json['form']),
  customForm: json['customForm'] as String?,
  dosageQuantity: (json['dosageQuantity'] as num).toInt(),
  dosageUnit: $enumDecode(_$DosageUnitEnumMap, json['dosageUnit']),
  brand: json['brand'] as String? ?? '',
  notes: json['notes'] as String? ?? '',
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => SupplementIngredient.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  schedules:
      (json['schedules'] as List<dynamic>?)
          ?.map((e) => SupplementSchedule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  startDate: (json['startDate'] as num?)?.toInt(),
  endDate: (json['endDate'] as num?)?.toInt(),
  isArchived: json['isArchived'] as bool? ?? false,
  syncMetadata: SyncMetadata.fromJson(
    json['syncMetadata'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$SupplementImplToJson(_$SupplementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'profileId': instance.profileId,
      'name': instance.name,
      'form': _$SupplementFormEnumMap[instance.form]!,
      'customForm': instance.customForm,
      'dosageQuantity': instance.dosageQuantity,
      'dosageUnit': _$DosageUnitEnumMap[instance.dosageUnit]!,
      'brand': instance.brand,
      'notes': instance.notes,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'isArchived': instance.isArchived,
      'syncMetadata': instance.syncMetadata.toJson(),
    };

const _$SupplementFormEnumMap = {
  SupplementForm.capsule: 'capsule',
  SupplementForm.powder: 'powder',
  SupplementForm.liquid: 'liquid',
  SupplementForm.tablet: 'tablet',
  SupplementForm.other: 'other',
};

const _$DosageUnitEnumMap = {
  DosageUnit.g: 'g',
  DosageUnit.mg: 'mg',
  DosageUnit.mcg: 'mcg',
  DosageUnit.iu: 'iu',
  DosageUnit.hdu: 'hdu',
  DosageUnit.ml: 'ml',
  DosageUnit.drops: 'drops',
  DosageUnit.tsp: 'tsp',
  DosageUnit.custom: 'custom',
};

_$SupplementIngredientImpl _$$SupplementIngredientImplFromJson(
  Map<String, dynamic> json,
) => _$SupplementIngredientImpl(
  name: json['name'] as String,
  quantity: (json['quantity'] as num?)?.toDouble(),
  unit: $enumDecodeNullable(_$DosageUnitEnumMap, json['unit']),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$SupplementIngredientImplToJson(
  _$SupplementIngredientImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'quantity': instance.quantity,
  'unit': _$DosageUnitEnumMap[instance.unit],
  'notes': instance.notes,
};

_$SupplementScheduleImpl _$$SupplementScheduleImplFromJson(
  Map<String, dynamic> json,
) => _$SupplementScheduleImpl(
  anchorEvent: $enumDecode(_$SupplementAnchorEventEnumMap, json['anchorEvent']),
  timingType: $enumDecode(_$SupplementTimingTypeEnumMap, json['timingType']),
  offsetMinutes: (json['offsetMinutes'] as num?)?.toInt() ?? 0,
  specificTimeMinutes: (json['specificTimeMinutes'] as num?)?.toInt(),
  frequencyType: $enumDecode(
    _$SupplementFrequencyTypeEnumMap,
    json['frequencyType'],
  ),
  everyXDays: (json['everyXDays'] as num?)?.toInt() ?? 1,
  weekdays:
      (json['weekdays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [0, 1, 2, 3, 4, 5, 6],
);

Map<String, dynamic> _$$SupplementScheduleImplToJson(
  _$SupplementScheduleImpl instance,
) => <String, dynamic>{
  'anchorEvent': _$SupplementAnchorEventEnumMap[instance.anchorEvent]!,
  'timingType': _$SupplementTimingTypeEnumMap[instance.timingType]!,
  'offsetMinutes': instance.offsetMinutes,
  'specificTimeMinutes': instance.specificTimeMinutes,
  'frequencyType': _$SupplementFrequencyTypeEnumMap[instance.frequencyType]!,
  'everyXDays': instance.everyXDays,
  'weekdays': instance.weekdays,
};

const _$SupplementAnchorEventEnumMap = {
  SupplementAnchorEvent.wake: 'wake',
  SupplementAnchorEvent.breakfast: 'breakfast',
  SupplementAnchorEvent.lunch: 'lunch',
  SupplementAnchorEvent.dinner: 'dinner',
  SupplementAnchorEvent.bed: 'bed',
};

const _$SupplementTimingTypeEnumMap = {
  SupplementTimingType.withEvent: 'withEvent',
  SupplementTimingType.beforeEvent: 'beforeEvent',
  SupplementTimingType.afterEvent: 'afterEvent',
  SupplementTimingType.specificTime: 'specificTime',
};

const _$SupplementFrequencyTypeEnumMap = {
  SupplementFrequencyType.daily: 'daily',
  SupplementFrequencyType.everyXDays: 'everyXDays',
  SupplementFrequencyType.specificWeekdays: 'specificWeekdays',
};
