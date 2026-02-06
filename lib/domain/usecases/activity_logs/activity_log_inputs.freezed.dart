// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LogActivityInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError; // Epoch milliseconds
  List<String> get activityIds => throw _privateConstructorUsedError;
  List<String> get adHocActivities => throw _privateConstructorUsedError;
  int? get duration =>
      throw _privateConstructorUsedError; // Actual duration if different from planned
  String get notes => throw _privateConstructorUsedError;
  String? get importSource => throw _privateConstructorUsedError;
  String? get importExternalId => throw _privateConstructorUsedError;

  /// Create a copy of LogActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogActivityInputCopyWith<LogActivityInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogActivityInputCopyWith<$Res> {
  factory $LogActivityInputCopyWith(
    LogActivityInput value,
    $Res Function(LogActivityInput) then,
  ) = _$LogActivityInputCopyWithImpl<$Res, LogActivityInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    int timestamp,
    List<String> activityIds,
    List<String> adHocActivities,
    int? duration,
    String notes,
    String? importSource,
    String? importExternalId,
  });
}

/// @nodoc
class _$LogActivityInputCopyWithImpl<$Res, $Val extends LogActivityInput>
    implements $LogActivityInputCopyWith<$Res> {
  _$LogActivityInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? timestamp = null,
    Object? activityIds = null,
    Object? adHocActivities = null,
    Object? duration = freezed,
    Object? notes = null,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
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
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
            activityIds: null == activityIds
                ? _value.activityIds
                : activityIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            adHocActivities: null == adHocActivities
                ? _value.adHocActivities
                : adHocActivities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            importSource: freezed == importSource
                ? _value.importSource
                : importSource // ignore: cast_nullable_to_non_nullable
                      as String?,
            importExternalId: freezed == importExternalId
                ? _value.importExternalId
                : importExternalId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogActivityInputImplCopyWith<$Res>
    implements $LogActivityInputCopyWith<$Res> {
  factory _$$LogActivityInputImplCopyWith(
    _$LogActivityInputImpl value,
    $Res Function(_$LogActivityInputImpl) then,
  ) = __$$LogActivityInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    int timestamp,
    List<String> activityIds,
    List<String> adHocActivities,
    int? duration,
    String notes,
    String? importSource,
    String? importExternalId,
  });
}

/// @nodoc
class __$$LogActivityInputImplCopyWithImpl<$Res>
    extends _$LogActivityInputCopyWithImpl<$Res, _$LogActivityInputImpl>
    implements _$$LogActivityInputImplCopyWith<$Res> {
  __$$LogActivityInputImplCopyWithImpl(
    _$LogActivityInputImpl _value,
    $Res Function(_$LogActivityInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? timestamp = null,
    Object? activityIds = null,
    Object? adHocActivities = null,
    Object? duration = freezed,
    Object? notes = null,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
  }) {
    return _then(
      _$LogActivityInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        activityIds: null == activityIds
            ? _value._activityIds
            : activityIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        adHocActivities: null == adHocActivities
            ? _value._adHocActivities
            : adHocActivities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        importSource: freezed == importSource
            ? _value.importSource
            : importSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        importExternalId: freezed == importExternalId
            ? _value.importExternalId
            : importExternalId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$LogActivityInputImpl implements _LogActivityInput {
  const _$LogActivityInputImpl({
    required this.profileId,
    required this.clientId,
    required this.timestamp,
    final List<String> activityIds = const [],
    final List<String> adHocActivities = const [],
    this.duration,
    this.notes = '',
    this.importSource,
    this.importExternalId,
  }) : _activityIds = activityIds,
       _adHocActivities = adHocActivities;

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final int timestamp;
  // Epoch milliseconds
  final List<String> _activityIds;
  // Epoch milliseconds
  @override
  @JsonKey()
  List<String> get activityIds {
    if (_activityIds is EqualUnmodifiableListView) return _activityIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activityIds);
  }

  final List<String> _adHocActivities;
  @override
  @JsonKey()
  List<String> get adHocActivities {
    if (_adHocActivities is EqualUnmodifiableListView) return _adHocActivities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adHocActivities);
  }

  @override
  final int? duration;
  // Actual duration if different from planned
  @override
  @JsonKey()
  final String notes;
  @override
  final String? importSource;
  @override
  final String? importExternalId;

  @override
  String toString() {
    return 'LogActivityInput(profileId: $profileId, clientId: $clientId, timestamp: $timestamp, activityIds: $activityIds, adHocActivities: $adHocActivities, duration: $duration, notes: $notes, importSource: $importSource, importExternalId: $importExternalId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogActivityInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(
              other._activityIds,
              _activityIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._adHocActivities,
              _adHocActivities,
            ) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.importSource, importSource) ||
                other.importSource == importSource) &&
            (identical(other.importExternalId, importExternalId) ||
                other.importExternalId == importExternalId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    timestamp,
    const DeepCollectionEquality().hash(_activityIds),
    const DeepCollectionEquality().hash(_adHocActivities),
    duration,
    notes,
    importSource,
    importExternalId,
  );

  /// Create a copy of LogActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogActivityInputImplCopyWith<_$LogActivityInputImpl> get copyWith =>
      __$$LogActivityInputImplCopyWithImpl<_$LogActivityInputImpl>(
        this,
        _$identity,
      );
}

abstract class _LogActivityInput implements LogActivityInput {
  const factory _LogActivityInput({
    required final String profileId,
    required final String clientId,
    required final int timestamp,
    final List<String> activityIds,
    final List<String> adHocActivities,
    final int? duration,
    final String notes,
    final String? importSource,
    final String? importExternalId,
  }) = _$LogActivityInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  int get timestamp; // Epoch milliseconds
  @override
  List<String> get activityIds;
  @override
  List<String> get adHocActivities;
  @override
  int? get duration; // Actual duration if different from planned
  @override
  String get notes;
  @override
  String? get importSource;
  @override
  String? get importExternalId;

  /// Create a copy of LogActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogActivityInputImplCopyWith<_$LogActivityInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetActivityLogsInput {
  String get profileId => throw _privateConstructorUsedError;
  int? get startDate =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  int? get endDate => throw _privateConstructorUsedError; // Epoch milliseconds
  int? get limit => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;

  /// Create a copy of GetActivityLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetActivityLogsInputCopyWith<GetActivityLogsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetActivityLogsInputCopyWith<$Res> {
  factory $GetActivityLogsInputCopyWith(
    GetActivityLogsInput value,
    $Res Function(GetActivityLogsInput) then,
  ) = _$GetActivityLogsInputCopyWithImpl<$Res, GetActivityLogsInput>;
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
class _$GetActivityLogsInputCopyWithImpl<
  $Res,
  $Val extends GetActivityLogsInput
>
    implements $GetActivityLogsInputCopyWith<$Res> {
  _$GetActivityLogsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetActivityLogsInput
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
abstract class _$$GetActivityLogsInputImplCopyWith<$Res>
    implements $GetActivityLogsInputCopyWith<$Res> {
  factory _$$GetActivityLogsInputImplCopyWith(
    _$GetActivityLogsInputImpl value,
    $Res Function(_$GetActivityLogsInputImpl) then,
  ) = __$$GetActivityLogsInputImplCopyWithImpl<$Res>;
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
class __$$GetActivityLogsInputImplCopyWithImpl<$Res>
    extends _$GetActivityLogsInputCopyWithImpl<$Res, _$GetActivityLogsInputImpl>
    implements _$$GetActivityLogsInputImplCopyWith<$Res> {
  __$$GetActivityLogsInputImplCopyWithImpl(
    _$GetActivityLogsInputImpl _value,
    $Res Function(_$GetActivityLogsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetActivityLogsInput
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
      _$GetActivityLogsInputImpl(
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

class _$GetActivityLogsInputImpl implements _GetActivityLogsInput {
  const _$GetActivityLogsInputImpl({
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
  // Epoch milliseconds
  @override
  final int? endDate;
  // Epoch milliseconds
  @override
  final int? limit;
  @override
  final int? offset;

  @override
  String toString() {
    return 'GetActivityLogsInput(profileId: $profileId, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetActivityLogsInputImpl &&
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

  /// Create a copy of GetActivityLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetActivityLogsInputImplCopyWith<_$GetActivityLogsInputImpl>
  get copyWith =>
      __$$GetActivityLogsInputImplCopyWithImpl<_$GetActivityLogsInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetActivityLogsInput implements GetActivityLogsInput {
  const factory _GetActivityLogsInput({
    required final String profileId,
    final int? startDate,
    final int? endDate,
    final int? limit,
    final int? offset,
  }) = _$GetActivityLogsInputImpl;

  @override
  String get profileId;
  @override
  int? get startDate; // Epoch milliseconds
  @override
  int? get endDate; // Epoch milliseconds
  @override
  int? get limit;
  @override
  int? get offset;

  /// Create a copy of GetActivityLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetActivityLogsInputImplCopyWith<_$GetActivityLogsInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateActivityLogInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  List<String>? get activityIds => throw _privateConstructorUsedError;
  List<String>? get adHocActivities => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of UpdateActivityLogInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateActivityLogInputCopyWith<UpdateActivityLogInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateActivityLogInputCopyWith<$Res> {
  factory $UpdateActivityLogInputCopyWith(
    UpdateActivityLogInput value,
    $Res Function(UpdateActivityLogInput) then,
  ) = _$UpdateActivityLogInputCopyWithImpl<$Res, UpdateActivityLogInput>;
  @useResult
  $Res call({
    String id,
    String profileId,
    List<String>? activityIds,
    List<String>? adHocActivities,
    int? duration,
    String? notes,
  });
}

/// @nodoc
class _$UpdateActivityLogInputCopyWithImpl<
  $Res,
  $Val extends UpdateActivityLogInput
>
    implements $UpdateActivityLogInputCopyWith<$Res> {
  _$UpdateActivityLogInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateActivityLogInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? activityIds = freezed,
    Object? adHocActivities = freezed,
    Object? duration = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            activityIds: freezed == activityIds
                ? _value.activityIds
                : activityIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            adHocActivities: freezed == adHocActivities
                ? _value.adHocActivities
                : adHocActivities // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateActivityLogInputImplCopyWith<$Res>
    implements $UpdateActivityLogInputCopyWith<$Res> {
  factory _$$UpdateActivityLogInputImplCopyWith(
    _$UpdateActivityLogInputImpl value,
    $Res Function(_$UpdateActivityLogInputImpl) then,
  ) = __$$UpdateActivityLogInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    List<String>? activityIds,
    List<String>? adHocActivities,
    int? duration,
    String? notes,
  });
}

/// @nodoc
class __$$UpdateActivityLogInputImplCopyWithImpl<$Res>
    extends
        _$UpdateActivityLogInputCopyWithImpl<$Res, _$UpdateActivityLogInputImpl>
    implements _$$UpdateActivityLogInputImplCopyWith<$Res> {
  __$$UpdateActivityLogInputImplCopyWithImpl(
    _$UpdateActivityLogInputImpl _value,
    $Res Function(_$UpdateActivityLogInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateActivityLogInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? activityIds = freezed,
    Object? adHocActivities = freezed,
    Object? duration = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$UpdateActivityLogInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        activityIds: freezed == activityIds
            ? _value._activityIds
            : activityIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        adHocActivities: freezed == adHocActivities
            ? _value._adHocActivities
            : adHocActivities // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateActivityLogInputImpl implements _UpdateActivityLogInput {
  const _$UpdateActivityLogInputImpl({
    required this.id,
    required this.profileId,
    final List<String>? activityIds,
    final List<String>? adHocActivities,
    this.duration,
    this.notes,
  }) : _activityIds = activityIds,
       _adHocActivities = adHocActivities;

  @override
  final String id;
  @override
  final String profileId;
  final List<String>? _activityIds;
  @override
  List<String>? get activityIds {
    final value = _activityIds;
    if (value == null) return null;
    if (_activityIds is EqualUnmodifiableListView) return _activityIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _adHocActivities;
  @override
  List<String>? get adHocActivities {
    final value = _adHocActivities;
    if (value == null) return null;
    if (_adHocActivities is EqualUnmodifiableListView) return _adHocActivities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? duration;
  @override
  final String? notes;

  @override
  String toString() {
    return 'UpdateActivityLogInput(id: $id, profileId: $profileId, activityIds: $activityIds, adHocActivities: $adHocActivities, duration: $duration, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateActivityLogInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            const DeepCollectionEquality().equals(
              other._activityIds,
              _activityIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._adHocActivities,
              _adHocActivities,
            ) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    const DeepCollectionEquality().hash(_activityIds),
    const DeepCollectionEquality().hash(_adHocActivities),
    duration,
    notes,
  );

  /// Create a copy of UpdateActivityLogInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateActivityLogInputImplCopyWith<_$UpdateActivityLogInputImpl>
  get copyWith =>
      __$$UpdateActivityLogInputImplCopyWithImpl<_$UpdateActivityLogInputImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateActivityLogInput implements UpdateActivityLogInput {
  const factory _UpdateActivityLogInput({
    required final String id,
    required final String profileId,
    final List<String>? activityIds,
    final List<String>? adHocActivities,
    final int? duration,
    final String? notes,
  }) = _$UpdateActivityLogInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  List<String>? get activityIds;
  @override
  List<String>? get adHocActivities;
  @override
  int? get duration;
  @override
  String? get notes;

  /// Create a copy of UpdateActivityLogInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateActivityLogInputImplCopyWith<_$UpdateActivityLogInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeleteActivityLogInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of DeleteActivityLogInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteActivityLogInputCopyWith<DeleteActivityLogInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteActivityLogInputCopyWith<$Res> {
  factory $DeleteActivityLogInputCopyWith(
    DeleteActivityLogInput value,
    $Res Function(DeleteActivityLogInput) then,
  ) = _$DeleteActivityLogInputCopyWithImpl<$Res, DeleteActivityLogInput>;
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class _$DeleteActivityLogInputCopyWithImpl<
  $Res,
  $Val extends DeleteActivityLogInput
>
    implements $DeleteActivityLogInputCopyWith<$Res> {
  _$DeleteActivityLogInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteActivityLogInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? profileId = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeleteActivityLogInputImplCopyWith<$Res>
    implements $DeleteActivityLogInputCopyWith<$Res> {
  factory _$$DeleteActivityLogInputImplCopyWith(
    _$DeleteActivityLogInputImpl value,
    $Res Function(_$DeleteActivityLogInputImpl) then,
  ) = __$$DeleteActivityLogInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class __$$DeleteActivityLogInputImplCopyWithImpl<$Res>
    extends
        _$DeleteActivityLogInputCopyWithImpl<$Res, _$DeleteActivityLogInputImpl>
    implements _$$DeleteActivityLogInputImplCopyWith<$Res> {
  __$$DeleteActivityLogInputImplCopyWithImpl(
    _$DeleteActivityLogInputImpl _value,
    $Res Function(_$DeleteActivityLogInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteActivityLogInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? profileId = null}) {
    return _then(
      _$DeleteActivityLogInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteActivityLogInputImpl implements _DeleteActivityLogInput {
  const _$DeleteActivityLogInputImpl({
    required this.id,
    required this.profileId,
  });

  @override
  final String id;
  @override
  final String profileId;

  @override
  String toString() {
    return 'DeleteActivityLogInput(id: $id, profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteActivityLogInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId);

  /// Create a copy of DeleteActivityLogInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteActivityLogInputImplCopyWith<_$DeleteActivityLogInputImpl>
  get copyWith =>
      __$$DeleteActivityLogInputImplCopyWithImpl<_$DeleteActivityLogInputImpl>(
        this,
        _$identity,
      );
}

abstract class _DeleteActivityLogInput implements DeleteActivityLogInput {
  const factory _DeleteActivityLogInput({
    required final String id,
    required final String profileId,
  }) = _$DeleteActivityLogInputImpl;

  @override
  String get id;
  @override
  String get profileId;

  /// Create a copy of DeleteActivityLogInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteActivityLogInputImplCopyWith<_$DeleteActivityLogInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}
