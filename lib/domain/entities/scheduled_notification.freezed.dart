// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ScheduledNotification {
  /// Deterministic stable ID: `shadow_notif_{category.value}_{HHmm}`.
  ///
  /// Stability means rescheduling replaces existing notifications
  /// rather than adding duplicates.
  String get id => throw _privateConstructorUsedError;

  /// The category this notification belongs to.
  NotificationCategory get category => throw _privateConstructorUsedError;

  /// Time of day in 24-hour HH:mm format (e.g. "07:00", "22:00").
  String get timeOfDay => throw _privateConstructorUsedError;

  /// Short title shown in the notification header (category display name).
  String get title => throw _privateConstructorUsedError;

  /// Full notification body text from the spec.
  String get body => throw _privateConstructorUsedError;

  /// JSON payload passed to the app when the notification is tapped.
  ///
  /// Contains at minimum `{"category": N}`. Anchor-event notifications
  /// also include `{"anchorEvent": N}` for context.
  String get payload => throw _privateConstructorUsedError;

  /// How many minutes after firing before the notification expires.
  int get expiresAfterMinutes => throw _privateConstructorUsedError;

  /// Create a copy of ScheduledNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduledNotificationCopyWith<ScheduledNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduledNotificationCopyWith<$Res> {
  factory $ScheduledNotificationCopyWith(
    ScheduledNotification value,
    $Res Function(ScheduledNotification) then,
  ) = _$ScheduledNotificationCopyWithImpl<$Res, ScheduledNotification>;
  @useResult
  $Res call({
    String id,
    NotificationCategory category,
    String timeOfDay,
    String title,
    String body,
    String payload,
    int expiresAfterMinutes,
  });
}

/// @nodoc
class _$ScheduledNotificationCopyWithImpl<
  $Res,
  $Val extends ScheduledNotification
>
    implements $ScheduledNotificationCopyWith<$Res> {
  _$ScheduledNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduledNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? timeOfDay = null,
    Object? title = null,
    Object? body = null,
    Object? payload = null,
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
            timeOfDay: null == timeOfDay
                ? _value.timeOfDay
                : timeOfDay // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            payload: null == payload
                ? _value.payload
                : payload // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$ScheduledNotificationImplCopyWith<$Res>
    implements $ScheduledNotificationCopyWith<$Res> {
  factory _$$ScheduledNotificationImplCopyWith(
    _$ScheduledNotificationImpl value,
    $Res Function(_$ScheduledNotificationImpl) then,
  ) = __$$ScheduledNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    NotificationCategory category,
    String timeOfDay,
    String title,
    String body,
    String payload,
    int expiresAfterMinutes,
  });
}

/// @nodoc
class __$$ScheduledNotificationImplCopyWithImpl<$Res>
    extends
        _$ScheduledNotificationCopyWithImpl<$Res, _$ScheduledNotificationImpl>
    implements _$$ScheduledNotificationImplCopyWith<$Res> {
  __$$ScheduledNotificationImplCopyWithImpl(
    _$ScheduledNotificationImpl _value,
    $Res Function(_$ScheduledNotificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduledNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? timeOfDay = null,
    Object? title = null,
    Object? body = null,
    Object? payload = null,
    Object? expiresAfterMinutes = null,
  }) {
    return _then(
      _$ScheduledNotificationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as NotificationCategory,
        timeOfDay: null == timeOfDay
            ? _value.timeOfDay
            : timeOfDay // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        payload: null == payload
            ? _value.payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAfterMinutes: null == expiresAfterMinutes
            ? _value.expiresAfterMinutes
            : expiresAfterMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$ScheduledNotificationImpl extends _ScheduledNotification {
  const _$ScheduledNotificationImpl({
    required this.id,
    required this.category,
    required this.timeOfDay,
    required this.title,
    required this.body,
    required this.payload,
    required this.expiresAfterMinutes,
  }) : super._();

  /// Deterministic stable ID: `shadow_notif_{category.value}_{HHmm}`.
  ///
  /// Stability means rescheduling replaces existing notifications
  /// rather than adding duplicates.
  @override
  final String id;

  /// The category this notification belongs to.
  @override
  final NotificationCategory category;

  /// Time of day in 24-hour HH:mm format (e.g. "07:00", "22:00").
  @override
  final String timeOfDay;

  /// Short title shown in the notification header (category display name).
  @override
  final String title;

  /// Full notification body text from the spec.
  @override
  final String body;

  /// JSON payload passed to the app when the notification is tapped.
  ///
  /// Contains at minimum `{"category": N}`. Anchor-event notifications
  /// also include `{"anchorEvent": N}` for context.
  @override
  final String payload;

  /// How many minutes after firing before the notification expires.
  @override
  final int expiresAfterMinutes;

  @override
  String toString() {
    return 'ScheduledNotification(id: $id, category: $category, timeOfDay: $timeOfDay, title: $title, body: $body, payload: $payload, expiresAfterMinutes: $expiresAfterMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduledNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.timeOfDay, timeOfDay) ||
                other.timeOfDay == timeOfDay) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            (identical(other.expiresAfterMinutes, expiresAfterMinutes) ||
                other.expiresAfterMinutes == expiresAfterMinutes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    category,
    timeOfDay,
    title,
    body,
    payload,
    expiresAfterMinutes,
  );

  /// Create a copy of ScheduledNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduledNotificationImplCopyWith<_$ScheduledNotificationImpl>
  get copyWith =>
      __$$ScheduledNotificationImplCopyWithImpl<_$ScheduledNotificationImpl>(
        this,
        _$identity,
      );
}

abstract class _ScheduledNotification extends ScheduledNotification {
  const factory _ScheduledNotification({
    required final String id,
    required final NotificationCategory category,
    required final String timeOfDay,
    required final String title,
    required final String body,
    required final String payload,
    required final int expiresAfterMinutes,
  }) = _$ScheduledNotificationImpl;
  const _ScheduledNotification._() : super._();

  /// Deterministic stable ID: `shadow_notif_{category.value}_{HHmm}`.
  ///
  /// Stability means rescheduling replaces existing notifications
  /// rather than adding duplicates.
  @override
  String get id;

  /// The category this notification belongs to.
  @override
  NotificationCategory get category;

  /// Time of day in 24-hour HH:mm format (e.g. "07:00", "22:00").
  @override
  String get timeOfDay;

  /// Short title shown in the notification header (category display name).
  @override
  String get title;

  /// Full notification body text from the spec.
  @override
  String get body;

  /// JSON payload passed to the app when the notification is tapped.
  ///
  /// Contains at minimum `{"category": N}`. Anchor-event notifications
  /// also include `{"anchorEvent": N}` for context.
  @override
  String get payload;

  /// How many minutes after firing before the notification expires.
  @override
  int get expiresAfterMinutes;

  /// Create a copy of ScheduledNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduledNotificationImplCopyWith<_$ScheduledNotificationImpl>
  get copyWith => throw _privateConstructorUsedError;
}
