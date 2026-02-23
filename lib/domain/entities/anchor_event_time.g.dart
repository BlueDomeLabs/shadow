// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anchor_event_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnchorEventTimeImpl _$$AnchorEventTimeImplFromJson(
  Map<String, dynamic> json,
) => _$AnchorEventTimeImpl(
  id: json['id'] as String,
  name: $enumDecode(_$AnchorEventNameEnumMap, json['name']),
  timeOfDay: json['timeOfDay'] as String,
  isEnabled: json['isEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$$AnchorEventTimeImplToJson(
  _$AnchorEventTimeImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': _$AnchorEventNameEnumMap[instance.name]!,
  'timeOfDay': instance.timeOfDay,
  'isEnabled': instance.isEnabled,
};

const _$AnchorEventNameEnumMap = {
  AnchorEventName.wake: 'wake',
  AnchorEventName.breakfast: 'breakfast',
  AnchorEventName.lunch: 'lunch',
  AnchorEventName.dinner: 'dinner',
  AnchorEventName.bedtime: 'bedtime',
};
