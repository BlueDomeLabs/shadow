// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_category_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationCategorySettings _$NotificationCategorySettingsFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationCategorySettings.fromJson(json);
}

/// @nodoc
mixin _$NotificationCategorySettings {
  String get id => throw _privateConstructorUsedError;
  NotificationCategory get category => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  NotificationSchedulingMode get schedulingMode =>
      throw _privateConstructorUsedError; // Mode 1 — Anchor Events
  // JSON array of AnchorEventName.value ints, e.g. [1, 2, 3] for Breakfast/Lunch/Dinner
  List<int> get anchorEventValues =>
      throw _privateConstructorUsedError; // Mode 2A — Interval
  // Interval in whole hours: 1, 2, 3, 4, 6, 8, or 12
  int? get intervalHours =>
      throw _privateConstructorUsedError; // Active window times as "HH:mm" 24-hour strings, e.g. "08:00"
  String? get intervalStartTime => throw _privateConstructorUsedError;
  String? get intervalEndTime =>
      throw _privateConstructorUsedError; // Mode 2B — Specific Times
  // "HH:mm" 24-hour strings, up to 12 per category
  List<String> get specificTimes =>
      throw _privateConstructorUsedError; // How long (minutes) after scheduled time the notification expires
  int get expiresAfterMinutes => throw _privateConstructorUsedError;

  /// Serializes this NotificationCategorySettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationCategorySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationCategorySettingsCopyWith<NotificationCategorySettings>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationCategorySettingsCopyWith<$Res> {
  factory $NotificationCategorySettingsCopyWith(
    NotificationCategorySettings value,
    $Res Function(NotificationCategorySettings) then,
  ) =
      _$NotificationCategorySettingsCopyWithImpl<
        $Res,
        NotificationCategorySettings
      >;
  @useResult
  $Res call({
    String id,
    NotificationCategory category,
    bool isEnabled,
    NotificationSchedulingMode schedulingMode,
    List<int> anchorEventValues,
    int? intervalHours,
    String? intervalStartTime,
    String? intervalEndTime,
    List<String> specificTimes,
    int expiresAfterMinutes,
  });
}

/// @nodoc
class _$NotificationCategorySettingsCopyWithImpl<
  $Res,
  $Val extends NotificationCategorySettings
>
    implements $NotificationCategorySettingsCopyWith<$Res> {
  _$NotificationCategorySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationCategorySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? isEnabled = null,
    Object? schedulingMode = null,
    Object? anchorEventValues = null,
    Object? intervalHours = freezed,
    Object? intervalStartTime = freezed,
    Object? intervalEndTime = freezed,
    Object? specificTimes = null,
    Object? expiresAfterMinutes = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as NotificationCategory,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            schedulingMode: null == schedulingMode
                ? _value.schedulingMode
                : schedulingMode // ignore: cast_nullable_to_non_nullable
                      as NotificationSchedulingMode,
            anchorEventValues: null == anchorEventValues
                ? _value.anchorEventValues
                : anchorEventValues // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            intervalHours: freezed == intervalHours
                ? _value.intervalHours
                : intervalHours // ignore: cast_nullable_to_non_nullable
                      as int?,
            intervalStartTime: freezed == intervalStartTime
                ? _value.intervalStartTime
                : intervalStartTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            intervalEndTime: freezed == intervalEndTime
                ? _value.intervalEndTime
                : intervalEndTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            specificTimes: null == specificTimes
                ? _value.specificTimes
                : specificTimes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            expiresAfterMinutes: null == expiresAfterMinutes
                ? _value.expiresAfterMinutes
                : expiresAfterMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationCategorySettingsImplCopyWith<$Res>
    implements $NotificationCategorySettingsCopyWith<$Res> {
  factory _$$NotificationCategorySettingsImplCopyWith(
    _$NotificationCategorySettingsImpl value,
    $Res Function(_$NotificationCategorySettingsImpl) then,
  ) = __$$NotificationCategorySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    NotificationCategory category,
    bool isEnabled,
    NotificationSchedulingMode schedulingMode,
    List<int> anchorEventValues,
    int? intervalHours,
    String? intervalStartTime,
    String? intervalEndTime,
    List<String> specificTimes,
    int expiresAfterMinutes,
  });
}

/// @nodoc
class __$$NotificationCategorySettingsImplCopyWithImpl<$Res>
    extends
        _$NotificationCategorySettingsCopyWithImpl<
          $Res,
          _$NotificationCategorySettingsImpl
        >
    implements _$$NotificationCategorySettingsImplCopyWith<$Res> {
  __$$NotificationCategorySettingsImplCopyWithImpl(
    _$NotificationCategorySettingsImpl _value,
    $Res Function(_$NotificationCategorySettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationCategorySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? isEnabled = null,
    Object? schedulingMode = null,
    Object? anchorEventValues = null,
    Object? intervalHours = freezed,
    Object? intervalStartTime = freezed,
    Object? intervalEndTime = freezed,
    Object? specificTimes = null,
    Object? expiresAfterMinutes = null,
  }) {
    return _then(
      _$NotificationCategorySettingsImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as NotificationCategory,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        schedulingMode: null == schedulingMode
            ? _value.schedulingMode
            : schedulingMode // ignore: cast_nullable_to_non_nullable
                  as NotificationSchedulingMode,
        anchorEventValues: null == anchorEventValues
            ? _value._anchorEventValues
            : anchorEventValues // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        intervalHours: freezed == intervalHours
            ? _value.intervalHours
            : intervalHours // ignore: cast_nullable_to_non_nullable
                  as int?,
        intervalStartTime: freezed == intervalStartTime
            ? _value.intervalStartTime
            : intervalStartTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        intervalEndTime: freezed == intervalEndTime
            ? _value.intervalEndTime
            : intervalEndTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        specificTimes: null == specificTimes
            ? _value._specificTimes
            : specificTimes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        expiresAfterMinutes: null == expiresAfterMinutes
            ? _value.expiresAfterMinutes
            : expiresAfterMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$NotificationCategorySettingsImpl extends _NotificationCategorySettings {
  const _$NotificationCategorySettingsImpl({
    required this.id,
    required this.category,
    this.isEnabled = false,
    required this.schedulingMode,
    final List<int> anchorEventValues = const [],
    this.intervalHours,
    this.intervalStartTime,
    this.intervalEndTime,
    final List<String> specificTimes = const [],
    this.expiresAfterMinutes = 60,
  }) : _anchorEventValues = anchorEventValues,
       _specificTimes = specificTimes,
       super._();

  factory _$NotificationCategorySettingsImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$NotificationCategorySettingsImplFromJson(json);

  @override
  final String id;
  @override
  final NotificationCategory category;
  @override
  @JsonKey()
  final bool isEnabled;
  @override
  final NotificationSchedulingMode schedulingMode;
  // Mode 1 — Anchor Events
  // JSON array of AnchorEventName.value ints, e.g. [1, 2, 3] for Breakfast/Lunch/Dinner
  final List<int> _anchorEventValues;
  // Mode 1 — Anchor Events
  // JSON array of AnchorEventName.value ints, e.g. [1, 2, 3] for Breakfast/Lunch/Dinner
  @override
  @JsonKey()
  List<int> get anchorEventValues {
    if (_anchorEventValues is EqualUnmodifiableListView)
      return _anchorEventValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_anchorEventValues);
  }

  // Mode 2A — Interval
  // Interval in whole hours: 1, 2, 3, 4, 6, 8, or 12
  @override
  final int? intervalHours;
  // Active window times as "HH:mm" 24-hour strings, e.g. "08:00"
  @override
  final String? intervalStartTime;
  @override
  final String? intervalEndTime;
  // Mode 2B — Specific Times
  // "HH:mm" 24-hour strings, up to 12 per category
  final List<String> _specificTimes;
  // Mode 2B — Specific Times
  // "HH:mm" 24-hour strings, up to 12 per category
  @override
  @JsonKey()
  List<String> get specificTimes {
    if (_specificTimes is EqualUnmodifiableListView) return _specificTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specificTimes);
  }

  // How long (minutes) after scheduled time the notification expires
  @override
  @JsonKey()
  final int expiresAfterMinutes;

  @override
  String toString() {
    return 'NotificationCategorySettings(id: $id, category: $category, isEnabled: $isEnabled, schedulingMode: $schedulingMode, anchorEventValues: $anchorEventValues, intervalHours: $intervalHours, intervalStartTime: $intervalStartTime, intervalEndTime: $intervalEndTime, specificTimes: $specificTimes, expiresAfterMinutes: $expiresAfterMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationCategorySettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.schedulingMode, schedulingMode) ||
                other.schedulingMode == schedulingMode) &&
            const DeepCollectionEquality().equals(
              other._anchorEventValues,
              _anchorEventValues,
            ) &&
            (identical(other.intervalHours, intervalHours) ||
                other.intervalHours == intervalHours) &&
            (identical(other.intervalStartTime, intervalStartTime) ||
                other.intervalStartTime == intervalStartTime) &&
            (identical(other.intervalEndTime, intervalEndTime) ||
                other.intervalEndTime == intervalEndTime) &&
            const DeepCollectionEquality().equals(
              other._specificTimes,
              _specificTimes,
            ) &&
            (identical(other.expiresAfterMinutes, expiresAfterMinutes) ||
                other.expiresAfterMinutes == expiresAfterMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    category,
    isEnabled,
    schedulingMode,
    const DeepCollectionEquality().hash(_anchorEventValues),
    intervalHours,
    intervalStartTime,
    intervalEndTime,
    const DeepCollectionEquality().hash(_specificTimes),
    expiresAfterMinutes,
  );

  /// Create a copy of NotificationCategorySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationCategorySettingsImplCopyWith<
    _$NotificationCategorySettingsImpl
  >
  get copyWith =>
      __$$NotificationCategorySettingsImplCopyWithImpl<
        _$NotificationCategorySettingsImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationCategorySettingsImplToJson(this);
  }
}

abstract class _NotificationCategorySettings
    extends NotificationCategorySettings {
  const factory _NotificationCategorySettings({
    required final String id,
    required final NotificationCategory category,
    final bool isEnabled,
    required final NotificationSchedulingMode schedulingMode,
    final List<int> anchorEventValues,
    final int? intervalHours,
    final String? intervalStartTime,
    final String? intervalEndTime,
    final List<String> specificTimes,
    final int expiresAfterMinutes,
  }) = _$NotificationCategorySettingsImpl;
  const _NotificationCategorySettings._() : super._();

  factory _NotificationCategorySettings.fromJson(Map<String, dynamic> json) =
      _$NotificationCategorySettingsImpl.fromJson;

  @override
  String get id;
  @override
  NotificationCategory get category;
  @override
  bool get isEnabled;
  @override
  NotificationSchedulingMode get schedulingMode; // Mode 1 — Anchor Events
  // JSON array of AnchorEventName.value ints, e.g. [1, 2, 3] for Breakfast/Lunch/Dinner
  @override
  List<int> get anchorEventValues; // Mode 2A — Interval
  // Interval in whole hours: 1, 2, 3, 4, 6, 8, or 12
  @override
  int? get intervalHours; // Active window times as "HH:mm" 24-hour strings, e.g. "08:00"
  @override
  String? get intervalStartTime;
  @override
  String? get intervalEndTime; // Mode 2B — Specific Times
  // "HH:mm" 24-hour strings, up to 12 per category
  @override
  List<String> get specificTimes; // How long (minutes) after scheduled time the notification expires
  @override
  int get expiresAfterMinutes;

  /// Create a copy of NotificationCategorySettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationCategorySettingsImplCopyWith<
    _$NotificationCategorySettingsImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
