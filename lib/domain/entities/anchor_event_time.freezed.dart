// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anchor_event_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnchorEventTime _$AnchorEventTimeFromJson(Map<String, dynamic> json) {
  return _AnchorEventTime.fromJson(json);
}

/// @nodoc
mixin _$AnchorEventTime {
  String get id => throw _privateConstructorUsedError;
  AnchorEventName get name =>
      throw _privateConstructorUsedError; // wake / breakfast / lunch / dinner / bedtime
  String get timeOfDay =>
      throw _privateConstructorUsedError; // "HH:mm" 24-hour format, e.g. "07:00"
  bool get isEnabled => throw _privateConstructorUsedError;

  /// Serializes this AnchorEventTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnchorEventTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnchorEventTimeCopyWith<AnchorEventTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnchorEventTimeCopyWith<$Res> {
  factory $AnchorEventTimeCopyWith(
    AnchorEventTime value,
    $Res Function(AnchorEventTime) then,
  ) = _$AnchorEventTimeCopyWithImpl<$Res, AnchorEventTime>;
  @useResult
  $Res call({
    String id,
    AnchorEventName name,
    String timeOfDay,
    bool isEnabled,
  });
}

/// @nodoc
class _$AnchorEventTimeCopyWithImpl<$Res, $Val extends AnchorEventTime>
    implements $AnchorEventTimeCopyWith<$Res> {
  _$AnchorEventTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnchorEventTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? timeOfDay = null,
    Object? isEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as AnchorEventName,
            timeOfDay: null == timeOfDay
                ? _value.timeOfDay
                : timeOfDay // ignore: cast_nullable_to_non_nullable
                      as String,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnchorEventTimeImplCopyWith<$Res>
    implements $AnchorEventTimeCopyWith<$Res> {
  factory _$$AnchorEventTimeImplCopyWith(
    _$AnchorEventTimeImpl value,
    $Res Function(_$AnchorEventTimeImpl) then,
  ) = __$$AnchorEventTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    AnchorEventName name,
    String timeOfDay,
    bool isEnabled,
  });
}

/// @nodoc
class __$$AnchorEventTimeImplCopyWithImpl<$Res>
    extends _$AnchorEventTimeCopyWithImpl<$Res, _$AnchorEventTimeImpl>
    implements _$$AnchorEventTimeImplCopyWith<$Res> {
  __$$AnchorEventTimeImplCopyWithImpl(
    _$AnchorEventTimeImpl _value,
    $Res Function(_$AnchorEventTimeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnchorEventTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? timeOfDay = null,
    Object? isEnabled = null,
  }) {
    return _then(
      _$AnchorEventTimeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as AnchorEventName,
        timeOfDay: null == timeOfDay
            ? _value.timeOfDay
            : timeOfDay // ignore: cast_nullable_to_non_nullable
                  as String,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$AnchorEventTimeImpl extends _AnchorEventTime {
  const _$AnchorEventTimeImpl({
    required this.id,
    required this.name,
    required this.timeOfDay,
    this.isEnabled = true,
  }) : super._();

  factory _$AnchorEventTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnchorEventTimeImplFromJson(json);

  @override
  final String id;
  @override
  final AnchorEventName name;
  // wake / breakfast / lunch / dinner / bedtime
  @override
  final String timeOfDay;
  // "HH:mm" 24-hour format, e.g. "07:00"
  @override
  @JsonKey()
  final bool isEnabled;

  @override
  String toString() {
    return 'AnchorEventTime(id: $id, name: $name, timeOfDay: $timeOfDay, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnchorEventTimeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.timeOfDay, timeOfDay) ||
                other.timeOfDay == timeOfDay) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, timeOfDay, isEnabled);

  /// Create a copy of AnchorEventTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnchorEventTimeImplCopyWith<_$AnchorEventTimeImpl> get copyWith =>
      __$$AnchorEventTimeImplCopyWithImpl<_$AnchorEventTimeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnchorEventTimeImplToJson(this);
  }
}

abstract class _AnchorEventTime extends AnchorEventTime {
  const factory _AnchorEventTime({
    required final String id,
    required final AnchorEventName name,
    required final String timeOfDay,
    final bool isEnabled,
  }) = _$AnchorEventTimeImpl;
  const _AnchorEventTime._() : super._();

  factory _AnchorEventTime.fromJson(Map<String, dynamic> json) =
      _$AnchorEventTimeImpl.fromJson;

  @override
  String get id;
  @override
  AnchorEventName get name; // wake / breakfast / lunch / dinner / bedtime
  @override
  String get timeOfDay; // "HH:mm" 24-hour format, e.g. "07:00"
  @override
  bool get isEnabled;

  /// Create a copy of AnchorEventTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnchorEventTimeImplCopyWith<_$AnchorEventTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
