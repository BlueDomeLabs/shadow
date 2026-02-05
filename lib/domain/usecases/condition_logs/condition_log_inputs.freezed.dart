// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'condition_log_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GetConditionLogsInput {
  String get profileId => throw _privateConstructorUsedError;
  int? get startDate => throw _privateConstructorUsedError; // Epoch ms
  int? get endDate => throw _privateConstructorUsedError; // Epoch ms
  int? get limit => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;

  /// Create a copy of GetConditionLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetConditionLogsInputCopyWith<GetConditionLogsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetConditionLogsInputCopyWith<$Res> {
  factory $GetConditionLogsInputCopyWith(
    GetConditionLogsInput value,
    $Res Function(GetConditionLogsInput) then,
  ) = _$GetConditionLogsInputCopyWithImpl<$Res, GetConditionLogsInput>;
  @useResult
  $Res call({
    String profileId,
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class _$GetConditionLogsInputCopyWithImpl<
  $Res,
  $Val extends GetConditionLogsInput
>
    implements $GetConditionLogsInputCopyWith<$Res> {
  _$GetConditionLogsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetConditionLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            limit: freezed == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int?,
            offset: freezed == offset
                ? _value.offset
                : offset // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetConditionLogsInputImplCopyWith<$Res>
    implements $GetConditionLogsInputCopyWith<$Res> {
  factory _$$GetConditionLogsInputImplCopyWith(
    _$GetConditionLogsInputImpl value,
    $Res Function(_$GetConditionLogsInputImpl) then,
  ) = __$$GetConditionLogsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class __$$GetConditionLogsInputImplCopyWithImpl<$Res>
    extends
        _$GetConditionLogsInputCopyWithImpl<$Res, _$GetConditionLogsInputImpl>
    implements _$$GetConditionLogsInputImplCopyWith<$Res> {
  __$$GetConditionLogsInputImplCopyWithImpl(
    _$GetConditionLogsInputImpl _value,
    $Res Function(_$GetConditionLogsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetConditionLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _$GetConditionLogsInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        offset: freezed == offset
            ? _value.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$GetConditionLogsInputImpl implements _GetConditionLogsInput {
  const _$GetConditionLogsInputImpl({
    required this.profileId,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });

  @override
  final String profileId;
  @override
  final int? startDate;
  // Epoch ms
  @override
  final int? endDate;
  // Epoch ms
  @override
  final int? limit;
  @override
  final int? offset;

  @override
  String toString() {
    return 'GetConditionLogsInput(profileId: $profileId, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetConditionLogsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, startDate, endDate, limit, offset);

  /// Create a copy of GetConditionLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetConditionLogsInputImplCopyWith<_$GetConditionLogsInputImpl>
  get copyWith =>
      __$$GetConditionLogsInputImplCopyWithImpl<_$GetConditionLogsInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetConditionLogsInput implements GetConditionLogsInput {
  const factory _GetConditionLogsInput({
    required final String profileId,
    final int? startDate,
    final int? endDate,
    final int? limit,
    final int? offset,
  }) = _$GetConditionLogsInputImpl;

  @override
  String get profileId;
  @override
  int? get startDate; // Epoch ms
  @override
  int? get endDate; // Epoch ms
  @override
  int? get limit;
  @override
  int? get offset;

  /// Create a copy of GetConditionLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetConditionLogsInputImplCopyWith<_$GetConditionLogsInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LogConditionInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get conditionId => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError; // Epoch ms
  int get severity => throw _privateConstructorUsedError; // 1-10 scale
  String? get notes => throw _privateConstructorUsedError;
  bool get isFlare => throw _privateConstructorUsedError;
  List<String> get flarePhotoIds => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError;
  String? get activityId => throw _privateConstructorUsedError;
  String? get triggers => throw _privateConstructorUsedError;

  /// Create a copy of LogConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogConditionInputCopyWith<LogConditionInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogConditionInputCopyWith<$Res> {
  factory $LogConditionInputCopyWith(
    LogConditionInput value,
    $Res Function(LogConditionInput) then,
  ) = _$LogConditionInputCopyWithImpl<$Res, LogConditionInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String conditionId,
    int timestamp,
    int severity,
    String? notes,
    bool isFlare,
    List<String> flarePhotoIds,
    String? photoPath,
    String? activityId,
    String? triggers,
  });
}

/// @nodoc
class _$LogConditionInputCopyWithImpl<$Res, $Val extends LogConditionInput>
    implements $LogConditionInputCopyWith<$Res> {
  _$LogConditionInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? conditionId = null,
    Object? timestamp = null,
    Object? severity = null,
    Object? notes = freezed,
    Object? isFlare = null,
    Object? flarePhotoIds = null,
    Object? photoPath = freezed,
    Object? activityId = freezed,
    Object? triggers = freezed,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            conditionId: null == conditionId
                ? _value.conditionId
                : conditionId // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isFlare: null == isFlare
                ? _value.isFlare
                : isFlare // ignore: cast_nullable_to_non_nullable
                      as bool,
            flarePhotoIds: null == flarePhotoIds
                ? _value.flarePhotoIds
                : flarePhotoIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            activityId: freezed == activityId
                ? _value.activityId
                : activityId // ignore: cast_nullable_to_non_nullable
                      as String?,
            triggers: freezed == triggers
                ? _value.triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogConditionInputImplCopyWith<$Res>
    implements $LogConditionInputCopyWith<$Res> {
  factory _$$LogConditionInputImplCopyWith(
    _$LogConditionInputImpl value,
    $Res Function(_$LogConditionInputImpl) then,
  ) = __$$LogConditionInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String conditionId,
    int timestamp,
    int severity,
    String? notes,
    bool isFlare,
    List<String> flarePhotoIds,
    String? photoPath,
    String? activityId,
    String? triggers,
  });
}

/// @nodoc
class __$$LogConditionInputImplCopyWithImpl<$Res>
    extends _$LogConditionInputCopyWithImpl<$Res, _$LogConditionInputImpl>
    implements _$$LogConditionInputImplCopyWith<$Res> {
  __$$LogConditionInputImplCopyWithImpl(
    _$LogConditionInputImpl _value,
    $Res Function(_$LogConditionInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? conditionId = null,
    Object? timestamp = null,
    Object? severity = null,
    Object? notes = freezed,
    Object? isFlare = null,
    Object? flarePhotoIds = null,
    Object? photoPath = freezed,
    Object? activityId = freezed,
    Object? triggers = freezed,
  }) {
    return _then(
      _$LogConditionInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        conditionId: null == conditionId
            ? _value.conditionId
            : conditionId // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isFlare: null == isFlare
            ? _value.isFlare
            : isFlare // ignore: cast_nullable_to_non_nullable
                  as bool,
        flarePhotoIds: null == flarePhotoIds
            ? _value._flarePhotoIds
            : flarePhotoIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        activityId: freezed == activityId
            ? _value.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        triggers: freezed == triggers
            ? _value.triggers
            : triggers // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$LogConditionInputImpl implements _LogConditionInput {
  const _$LogConditionInputImpl({
    required this.profileId,
    required this.clientId,
    required this.conditionId,
    required this.timestamp,
    required this.severity,
    this.notes,
    this.isFlare = false,
    final List<String> flarePhotoIds = const [],
    this.photoPath,
    this.activityId,
    this.triggers,
  }) : _flarePhotoIds = flarePhotoIds;

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final String conditionId;
  @override
  final int timestamp;
  // Epoch ms
  @override
  final int severity;
  // 1-10 scale
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isFlare;
  final List<String> _flarePhotoIds;
  @override
  @JsonKey()
  List<String> get flarePhotoIds {
    if (_flarePhotoIds is EqualUnmodifiableListView) return _flarePhotoIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_flarePhotoIds);
  }

  @override
  final String? photoPath;
  @override
  final String? activityId;
  @override
  final String? triggers;

  @override
  String toString() {
    return 'LogConditionInput(profileId: $profileId, clientId: $clientId, conditionId: $conditionId, timestamp: $timestamp, severity: $severity, notes: $notes, isFlare: $isFlare, flarePhotoIds: $flarePhotoIds, photoPath: $photoPath, activityId: $activityId, triggers: $triggers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogConditionInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.conditionId, conditionId) ||
                other.conditionId == conditionId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isFlare, isFlare) || other.isFlare == isFlare) &&
            const DeepCollectionEquality().equals(
              other._flarePhotoIds,
              _flarePhotoIds,
            ) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.triggers, triggers) ||
                other.triggers == triggers));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    conditionId,
    timestamp,
    severity,
    notes,
    isFlare,
    const DeepCollectionEquality().hash(_flarePhotoIds),
    photoPath,
    activityId,
    triggers,
  );

  /// Create a copy of LogConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogConditionInputImplCopyWith<_$LogConditionInputImpl> get copyWith =>
      __$$LogConditionInputImplCopyWithImpl<_$LogConditionInputImpl>(
        this,
        _$identity,
      );
}

abstract class _LogConditionInput implements LogConditionInput {
  const factory _LogConditionInput({
    required final String profileId,
    required final String clientId,
    required final String conditionId,
    required final int timestamp,
    required final int severity,
    final String? notes,
    final bool isFlare,
    final List<String> flarePhotoIds,
    final String? photoPath,
    final String? activityId,
    final String? triggers,
  }) = _$LogConditionInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  String get conditionId;
  @override
  int get timestamp; // Epoch ms
  @override
  int get severity; // 1-10 scale
  @override
  String? get notes;
  @override
  bool get isFlare;
  @override
  List<String> get flarePhotoIds;
  @override
  String? get photoPath;
  @override
  String? get activityId;
  @override
  String? get triggers;

  /// Create a copy of LogConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogConditionInputImplCopyWith<_$LogConditionInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
