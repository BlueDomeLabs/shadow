// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UpdateAnchorEventTimeInput {
  String get id =>
      throw _privateConstructorUsedError; // New time in "HH:mm" 24-hour format, e.g. "08:30"
  String? get timeOfDay => throw _privateConstructorUsedError;
  bool? get isEnabled => throw _privateConstructorUsedError;

  /// Create a copy of UpdateAnchorEventTimeInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateAnchorEventTimeInputCopyWith<UpdateAnchorEventTimeInput>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateAnchorEventTimeInputCopyWith<$Res> {
  factory $UpdateAnchorEventTimeInputCopyWith(
    UpdateAnchorEventTimeInput value,
    $Res Function(UpdateAnchorEventTimeInput) then,
  ) =
      _$UpdateAnchorEventTimeInputCopyWithImpl<
        $Res,
        UpdateAnchorEventTimeInput
      >;
  @useResult
  $Res call({String id, String? timeOfDay, bool? isEnabled});
}

/// @nodoc
class _$UpdateAnchorEventTimeInputCopyWithImpl<
  $Res,
  $Val extends UpdateAnchorEventTimeInput
>
    implements $UpdateAnchorEventTimeInputCopyWith<$Res> {
  _$UpdateAnchorEventTimeInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateAnchorEventTimeInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timeOfDay = freezed,
    Object? isEnabled = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            timeOfDay: freezed == timeOfDay
                ? _value.timeOfDay
                : timeOfDay // ignore: cast_nullable_to_non_nullable
                      as String?,
            isEnabled: freezed == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateAnchorEventTimeInputImplCopyWith<$Res>
    implements $UpdateAnchorEventTimeInputCopyWith<$Res> {
  factory _$$UpdateAnchorEventTimeInputImplCopyWith(
    _$UpdateAnchorEventTimeInputImpl value,
    $Res Function(_$UpdateAnchorEventTimeInputImpl) then,
  ) = __$$UpdateAnchorEventTimeInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? timeOfDay, bool? isEnabled});
}

/// @nodoc
class __$$UpdateAnchorEventTimeInputImplCopyWithImpl<$Res>
    extends
        _$UpdateAnchorEventTimeInputCopyWithImpl<
          $Res,
          _$UpdateAnchorEventTimeInputImpl
        >
    implements _$$UpdateAnchorEventTimeInputImplCopyWith<$Res> {
  __$$UpdateAnchorEventTimeInputImplCopyWithImpl(
    _$UpdateAnchorEventTimeInputImpl _value,
    $Res Function(_$UpdateAnchorEventTimeInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateAnchorEventTimeInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timeOfDay = freezed,
    Object? isEnabled = freezed,
  }) {
    return _then(
      _$UpdateAnchorEventTimeInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        timeOfDay: freezed == timeOfDay
            ? _value.timeOfDay
            : timeOfDay // ignore: cast_nullable_to_non_nullable
                  as String?,
        isEnabled: freezed == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateAnchorEventTimeInputImpl implements _UpdateAnchorEventTimeInput {
  const _$UpdateAnchorEventTimeInputImpl({
    required this.id,
    this.timeOfDay,
    this.isEnabled,
  });

  @override
  final String id;
  // New time in "HH:mm" 24-hour format, e.g. "08:30"
  @override
  final String? timeOfDay;
  @override
  final bool? isEnabled;

  @override
  String toString() {
    return 'UpdateAnchorEventTimeInput(id: $id, timeOfDay: $timeOfDay, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateAnchorEventTimeInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timeOfDay, timeOfDay) ||
                other.timeOfDay == timeOfDay) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, timeOfDay, isEnabled);

  /// Create a copy of UpdateAnchorEventTimeInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateAnchorEventTimeInputImplCopyWith<_$UpdateAnchorEventTimeInputImpl>
  get copyWith =>
      __$$UpdateAnchorEventTimeInputImplCopyWithImpl<
        _$UpdateAnchorEventTimeInputImpl
      >(this, _$identity);
}

abstract class _UpdateAnchorEventTimeInput
    implements UpdateAnchorEventTimeInput {
  const factory _UpdateAnchorEventTimeInput({
    required final String id,
    final String? timeOfDay,
    final bool? isEnabled,
  }) = _$UpdateAnchorEventTimeInputImpl;

  @override
  String get id; // New time in "HH:mm" 24-hour format, e.g. "08:30"
  @override
  String? get timeOfDay;
  @override
  bool? get isEnabled;

  /// Create a copy of UpdateAnchorEventTimeInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateAnchorEventTimeInputImplCopyWith<_$UpdateAnchorEventTimeInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateNotificationCategorySettingsInput {
  String get id => throw _privateConstructorUsedError;
  bool? get isEnabled => throw _privateConstructorUsedError;
  NotificationSchedulingMode? get schedulingMode =>
      throw _privateConstructorUsedError;
  List<int>? get anchorEventValues => throw _privateConstructorUsedError;
  int? get intervalHours => throw _privateConstructorUsedError;
  String? get intervalStartTime => throw _privateConstructorUsedError;
  String? get intervalEndTime => throw _privateConstructorUsedError;
  List<String>? get specificTimes => throw _privateConstructorUsedError;
  int? get expiresAfterMinutes => throw _privateConstructorUsedError;

  /// Create a copy of UpdateNotificationCategorySettingsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateNotificationCategorySettingsInputCopyWith<
    UpdateNotificationCategorySettingsInput
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateNotificationCategorySettingsInputCopyWith<$Res> {
  factory $UpdateNotificationCategorySettingsInputCopyWith(
    UpdateNotificationCategorySettingsInput value,
    $Res Function(UpdateNotificationCategorySettingsInput) then,
  ) =
      _$UpdateNotificationCategorySettingsInputCopyWithImpl<
        $Res,
        UpdateNotificationCategorySettingsInput
      >;
  @useResult
  $Res call({
    String id,
    bool? isEnabled,
    NotificationSchedulingMode? schedulingMode,
    List<int>? anchorEventValues,
    int? intervalHours,
    String? intervalStartTime,
    String? intervalEndTime,
    List<String>? specificTimes,
    int? expiresAfterMinutes,
  });
}

/// @nodoc
class _$UpdateNotificationCategorySettingsInputCopyWithImpl<
  $Res,
  $Val extends UpdateNotificationCategorySettingsInput
>
    implements $UpdateNotificationCategorySettingsInputCopyWith<$Res> {
  _$UpdateNotificationCategorySettingsInputCopyWithImpl(
    this._value,
    this._then,
  );

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateNotificationCategorySettingsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isEnabled = freezed,
    Object? schedulingMode = freezed,
    Object? anchorEventValues = freezed,
    Object? intervalHours = freezed,
    Object? intervalStartTime = freezed,
    Object? intervalEndTime = freezed,
    Object? specificTimes = freezed,
    Object? expiresAfterMinutes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            isEnabled: freezed == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool?,
            schedulingMode: freezed == schedulingMode
                ? _value.schedulingMode
                : schedulingMode // ignore: cast_nullable_to_non_nullable
                      as NotificationSchedulingMode?,
            anchorEventValues: freezed == anchorEventValues
                ? _value.anchorEventValues
                : anchorEventValues // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
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
            specificTimes: freezed == specificTimes
                ? _value.specificTimes
                : specificTimes // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            expiresAfterMinutes: freezed == expiresAfterMinutes
                ? _value.expiresAfterMinutes
                : expiresAfterMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateNotificationCategorySettingsInputImplCopyWith<$Res>
    implements $UpdateNotificationCategorySettingsInputCopyWith<$Res> {
  factory _$$UpdateNotificationCategorySettingsInputImplCopyWith(
    _$UpdateNotificationCategorySettingsInputImpl value,
    $Res Function(_$UpdateNotificationCategorySettingsInputImpl) then,
  ) = __$$UpdateNotificationCategorySettingsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    bool? isEnabled,
    NotificationSchedulingMode? schedulingMode,
    List<int>? anchorEventValues,
    int? intervalHours,
    String? intervalStartTime,
    String? intervalEndTime,
    List<String>? specificTimes,
    int? expiresAfterMinutes,
  });
}

/// @nodoc
class __$$UpdateNotificationCategorySettingsInputImplCopyWithImpl<$Res>
    extends
        _$UpdateNotificationCategorySettingsInputCopyWithImpl<
          $Res,
          _$UpdateNotificationCategorySettingsInputImpl
        >
    implements _$$UpdateNotificationCategorySettingsInputImplCopyWith<$Res> {
  __$$UpdateNotificationCategorySettingsInputImplCopyWithImpl(
    _$UpdateNotificationCategorySettingsInputImpl _value,
    $Res Function(_$UpdateNotificationCategorySettingsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateNotificationCategorySettingsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isEnabled = freezed,
    Object? schedulingMode = freezed,
    Object? anchorEventValues = freezed,
    Object? intervalHours = freezed,
    Object? intervalStartTime = freezed,
    Object? intervalEndTime = freezed,
    Object? specificTimes = freezed,
    Object? expiresAfterMinutes = freezed,
  }) {
    return _then(
      _$UpdateNotificationCategorySettingsInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        isEnabled: freezed == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        schedulingMode: freezed == schedulingMode
            ? _value.schedulingMode
            : schedulingMode // ignore: cast_nullable_to_non_nullable
                  as NotificationSchedulingMode?,
        anchorEventValues: freezed == anchorEventValues
            ? _value._anchorEventValues
            : anchorEventValues // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
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
        specificTimes: freezed == specificTimes
            ? _value._specificTimes
            : specificTimes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        expiresAfterMinutes: freezed == expiresAfterMinutes
            ? _value.expiresAfterMinutes
            : expiresAfterMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateNotificationCategorySettingsInputImpl
    implements _UpdateNotificationCategorySettingsInput {
  const _$UpdateNotificationCategorySettingsInputImpl({
    required this.id,
    this.isEnabled,
    this.schedulingMode,
    final List<int>? anchorEventValues,
    this.intervalHours,
    this.intervalStartTime,
    this.intervalEndTime,
    final List<String>? specificTimes,
    this.expiresAfterMinutes,
  }) : _anchorEventValues = anchorEventValues,
       _specificTimes = specificTimes;

  @override
  final String id;
  @override
  final bool? isEnabled;
  @override
  final NotificationSchedulingMode? schedulingMode;
  final List<int>? _anchorEventValues;
  @override
  List<int>? get anchorEventValues {
    final value = _anchorEventValues;
    if (value == null) return null;
    if (_anchorEventValues is EqualUnmodifiableListView)
      return _anchorEventValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? intervalHours;
  @override
  final String? intervalStartTime;
  @override
  final String? intervalEndTime;
  final List<String>? _specificTimes;
  @override
  List<String>? get specificTimes {
    final value = _specificTimes;
    if (value == null) return null;
    if (_specificTimes is EqualUnmodifiableListView) return _specificTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? expiresAfterMinutes;

  @override
  String toString() {
    return 'UpdateNotificationCategorySettingsInput(id: $id, isEnabled: $isEnabled, schedulingMode: $schedulingMode, anchorEventValues: $anchorEventValues, intervalHours: $intervalHours, intervalStartTime: $intervalStartTime, intervalEndTime: $intervalEndTime, specificTimes: $specificTimes, expiresAfterMinutes: $expiresAfterMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateNotificationCategorySettingsInputImpl &&
            (identical(other.id, id) || other.id == id) &&
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

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    isEnabled,
    schedulingMode,
    const DeepCollectionEquality().hash(_anchorEventValues),
    intervalHours,
    intervalStartTime,
    intervalEndTime,
    const DeepCollectionEquality().hash(_specificTimes),
    expiresAfterMinutes,
  );

  /// Create a copy of UpdateNotificationCategorySettingsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateNotificationCategorySettingsInputImplCopyWith<
    _$UpdateNotificationCategorySettingsInputImpl
  >
  get copyWith =>
      __$$UpdateNotificationCategorySettingsInputImplCopyWithImpl<
        _$UpdateNotificationCategorySettingsInputImpl
      >(this, _$identity);
}

abstract class _UpdateNotificationCategorySettingsInput
    implements UpdateNotificationCategorySettingsInput {
  const factory _UpdateNotificationCategorySettingsInput({
    required final String id,
    final bool? isEnabled,
    final NotificationSchedulingMode? schedulingMode,
    final List<int>? anchorEventValues,
    final int? intervalHours,
    final String? intervalStartTime,
    final String? intervalEndTime,
    final List<String>? specificTimes,
    final int? expiresAfterMinutes,
  }) = _$UpdateNotificationCategorySettingsInputImpl;

  @override
  String get id;
  @override
  bool? get isEnabled;
  @override
  NotificationSchedulingMode? get schedulingMode;
  @override
  List<int>? get anchorEventValues;
  @override
  int? get intervalHours;
  @override
  String? get intervalStartTime;
  @override
  String? get intervalEndTime;
  @override
  List<String>? get specificTimes;
  @override
  int? get expiresAfterMinutes;

  /// Create a copy of UpdateNotificationCategorySettingsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateNotificationCategorySettingsInputImplCopyWith<
    _$UpdateNotificationCategorySettingsInputImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
