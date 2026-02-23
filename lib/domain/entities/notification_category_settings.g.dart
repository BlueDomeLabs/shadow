// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_category_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationCategorySettingsImpl _$$NotificationCategorySettingsImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationCategorySettingsImpl(
  id: json['id'] as String,
  category: $enumDecode(_$NotificationCategoryEnumMap, json['category']),
  isEnabled: json['isEnabled'] as bool? ?? false,
  schedulingMode: $enumDecode(
    _$NotificationSchedulingModeEnumMap,
    json['schedulingMode'],
  ),
  anchorEventValues:
      (json['anchorEventValues'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  intervalHours: (json['intervalHours'] as num?)?.toInt(),
  intervalStartTime: json['intervalStartTime'] as String?,
  intervalEndTime: json['intervalEndTime'] as String?,
  specificTimes:
      (json['specificTimes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  expiresAfterMinutes: (json['expiresAfterMinutes'] as num?)?.toInt() ?? 60,
);

Map<String, dynamic> _$$NotificationCategorySettingsImplToJson(
  _$NotificationCategorySettingsImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'category': _$NotificationCategoryEnumMap[instance.category]!,
  'isEnabled': instance.isEnabled,
  'schedulingMode':
      _$NotificationSchedulingModeEnumMap[instance.schedulingMode]!,
  'anchorEventValues': instance.anchorEventValues,
  'intervalHours': instance.intervalHours,
  'intervalStartTime': instance.intervalStartTime,
  'intervalEndTime': instance.intervalEndTime,
  'specificTimes': instance.specificTimes,
  'expiresAfterMinutes': instance.expiresAfterMinutes,
};

const _$NotificationCategoryEnumMap = {
  NotificationCategory.supplements: 'supplements',
  NotificationCategory.foodMeals: 'foodMeals',
  NotificationCategory.fluids: 'fluids',
  NotificationCategory.photos: 'photos',
  NotificationCategory.journalEntries: 'journalEntries',
  NotificationCategory.activities: 'activities',
  NotificationCategory.conditionCheckIns: 'conditionCheckIns',
  NotificationCategory.bbtVitals: 'bbtVitals',
};

const _$NotificationSchedulingModeEnumMap = {
  NotificationSchedulingMode.anchorEvents: 'anchorEvents',
  NotificationSchedulingMode.interval: 'interval',
  NotificationSchedulingMode.specificTimes: 'specificTimes',
};
