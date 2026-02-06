// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flare_up_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LogFlareUpInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get conditionId => throw _privateConstructorUsedError;
  int get startDate => throw _privateConstructorUsedError; // Epoch milliseconds
  int? get endDate => throw _privateConstructorUsedError; // Null = ongoing
  int get severity => throw _privateConstructorUsedError; // 1-10
  String? get notes => throw _privateConstructorUsedError;
  List<String> get triggers => throw _privateConstructorUsedError;
  String? get activityId => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError;

  /// Create a copy of LogFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogFlareUpInputCopyWith<LogFlareUpInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogFlareUpInputCopyWith<$Res> {
  factory $LogFlareUpInputCopyWith(
    LogFlareUpInput value,
    $Res Function(LogFlareUpInput) then,
  ) = _$LogFlareUpInputCopyWithImpl<$Res, LogFlareUpInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String conditionId,
    int startDate,
    int? endDate,
    int severity,
    String? notes,
    List<String> triggers,
    String? activityId,
    String? photoPath,
  });
}

/// @nodoc
class _$LogFlareUpInputCopyWithImpl<$Res, $Val extends LogFlareUpInput>
    implements $LogFlareUpInputCopyWith<$Res> {
  _$LogFlareUpInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? conditionId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? severity = null,
    Object? notes = freezed,
    Object? triggers = null,
    Object? activityId = freezed,
    Object? photoPath = freezed,
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
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            triggers: null == triggers
                ? _value.triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            activityId: freezed == activityId
                ? _value.activityId
                : activityId // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogFlareUpInputImplCopyWith<$Res>
    implements $LogFlareUpInputCopyWith<$Res> {
  factory _$$LogFlareUpInputImplCopyWith(
    _$LogFlareUpInputImpl value,
    $Res Function(_$LogFlareUpInputImpl) then,
  ) = __$$LogFlareUpInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String conditionId,
    int startDate,
    int? endDate,
    int severity,
    String? notes,
    List<String> triggers,
    String? activityId,
    String? photoPath,
  });
}

/// @nodoc
class __$$LogFlareUpInputImplCopyWithImpl<$Res>
    extends _$LogFlareUpInputCopyWithImpl<$Res, _$LogFlareUpInputImpl>
    implements _$$LogFlareUpInputImplCopyWith<$Res> {
  __$$LogFlareUpInputImplCopyWithImpl(
    _$LogFlareUpInputImpl _value,
    $Res Function(_$LogFlareUpInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? conditionId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? severity = null,
    Object? notes = freezed,
    Object? triggers = null,
    Object? activityId = freezed,
    Object? photoPath = freezed,
  }) {
    return _then(
      _$LogFlareUpInputImpl(
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
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        triggers: null == triggers
            ? _value._triggers
            : triggers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        activityId: freezed == activityId
            ? _value.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$LogFlareUpInputImpl implements _LogFlareUpInput {
  const _$LogFlareUpInputImpl({
    required this.profileId,
    required this.clientId,
    required this.conditionId,
    required this.startDate,
    this.endDate,
    required this.severity,
    this.notes,
    final List<String> triggers = const [],
    this.activityId,
    this.photoPath,
  }) : _triggers = triggers;

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final String conditionId;
  @override
  final int startDate;
  // Epoch milliseconds
  @override
  final int? endDate;
  // Null = ongoing
  @override
  final int severity;
  // 1-10
  @override
  final String? notes;
  final List<String> _triggers;
  @override
  @JsonKey()
  List<String> get triggers {
    if (_triggers is EqualUnmodifiableListView) return _triggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggers);
  }

  @override
  final String? activityId;
  @override
  final String? photoPath;

  @override
  String toString() {
    return 'LogFlareUpInput(profileId: $profileId, clientId: $clientId, conditionId: $conditionId, startDate: $startDate, endDate: $endDate, severity: $severity, notes: $notes, triggers: $triggers, activityId: $activityId, photoPath: $photoPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogFlareUpInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.conditionId, conditionId) ||
                other.conditionId == conditionId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._triggers, _triggers) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    conditionId,
    startDate,
    endDate,
    severity,
    notes,
    const DeepCollectionEquality().hash(_triggers),
    activityId,
    photoPath,
  );

  /// Create a copy of LogFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogFlareUpInputImplCopyWith<_$LogFlareUpInputImpl> get copyWith =>
      __$$LogFlareUpInputImplCopyWithImpl<_$LogFlareUpInputImpl>(
        this,
        _$identity,
      );
}

abstract class _LogFlareUpInput implements LogFlareUpInput {
  const factory _LogFlareUpInput({
    required final String profileId,
    required final String clientId,
    required final String conditionId,
    required final int startDate,
    final int? endDate,
    required final int severity,
    final String? notes,
    final List<String> triggers,
    final String? activityId,
    final String? photoPath,
  }) = _$LogFlareUpInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  String get conditionId;
  @override
  int get startDate; // Epoch milliseconds
  @override
  int? get endDate; // Null = ongoing
  @override
  int get severity; // 1-10
  @override
  String? get notes;
  @override
  List<String> get triggers;
  @override
  String? get activityId;
  @override
  String? get photoPath;

  /// Create a copy of LogFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogFlareUpInputImplCopyWith<_$LogFlareUpInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetFlareUpsInput {
  String get profileId => throw _privateConstructorUsedError;
  String? get conditionId => throw _privateConstructorUsedError;
  int? get startDate =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  int? get endDate => throw _privateConstructorUsedError; // Epoch milliseconds
  bool? get ongoingOnly => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;

  /// Create a copy of GetFlareUpsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetFlareUpsInputCopyWith<GetFlareUpsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetFlareUpsInputCopyWith<$Res> {
  factory $GetFlareUpsInputCopyWith(
    GetFlareUpsInput value,
    $Res Function(GetFlareUpsInput) then,
  ) = _$GetFlareUpsInputCopyWithImpl<$Res, GetFlareUpsInput>;
  @useResult
  $Res call({
    String profileId,
    String? conditionId,
    int? startDate,
    int? endDate,
    bool? ongoingOnly,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class _$GetFlareUpsInputCopyWithImpl<$Res, $Val extends GetFlareUpsInput>
    implements $GetFlareUpsInputCopyWith<$Res> {
  _$GetFlareUpsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetFlareUpsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? conditionId = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? ongoingOnly = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            conditionId: freezed == conditionId
                ? _value.conditionId
                : conditionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            ongoingOnly: freezed == ongoingOnly
                ? _value.ongoingOnly
                : ongoingOnly // ignore: cast_nullable_to_non_nullable
                      as bool?,
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
abstract class _$$GetFlareUpsInputImplCopyWith<$Res>
    implements $GetFlareUpsInputCopyWith<$Res> {
  factory _$$GetFlareUpsInputImplCopyWith(
    _$GetFlareUpsInputImpl value,
    $Res Function(_$GetFlareUpsInputImpl) then,
  ) = __$$GetFlareUpsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String? conditionId,
    int? startDate,
    int? endDate,
    bool? ongoingOnly,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class __$$GetFlareUpsInputImplCopyWithImpl<$Res>
    extends _$GetFlareUpsInputCopyWithImpl<$Res, _$GetFlareUpsInputImpl>
    implements _$$GetFlareUpsInputImplCopyWith<$Res> {
  __$$GetFlareUpsInputImplCopyWithImpl(
    _$GetFlareUpsInputImpl _value,
    $Res Function(_$GetFlareUpsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetFlareUpsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? conditionId = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? ongoingOnly = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _$GetFlareUpsInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        conditionId: freezed == conditionId
            ? _value.conditionId
            : conditionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        ongoingOnly: freezed == ongoingOnly
            ? _value.ongoingOnly
            : ongoingOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
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

class _$GetFlareUpsInputImpl implements _GetFlareUpsInput {
  const _$GetFlareUpsInputImpl({
    required this.profileId,
    this.conditionId,
    this.startDate,
    this.endDate,
    this.ongoingOnly,
    this.limit,
    this.offset,
  });

  @override
  final String profileId;
  @override
  final String? conditionId;
  @override
  final int? startDate;
  // Epoch milliseconds
  @override
  final int? endDate;
  // Epoch milliseconds
  @override
  final bool? ongoingOnly;
  @override
  final int? limit;
  @override
  final int? offset;

  @override
  String toString() {
    return 'GetFlareUpsInput(profileId: $profileId, conditionId: $conditionId, startDate: $startDate, endDate: $endDate, ongoingOnly: $ongoingOnly, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetFlareUpsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.conditionId, conditionId) ||
                other.conditionId == conditionId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.ongoingOnly, ongoingOnly) ||
                other.ongoingOnly == ongoingOnly) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    conditionId,
    startDate,
    endDate,
    ongoingOnly,
    limit,
    offset,
  );

  /// Create a copy of GetFlareUpsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetFlareUpsInputImplCopyWith<_$GetFlareUpsInputImpl> get copyWith =>
      __$$GetFlareUpsInputImplCopyWithImpl<_$GetFlareUpsInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetFlareUpsInput implements GetFlareUpsInput {
  const factory _GetFlareUpsInput({
    required final String profileId,
    final String? conditionId,
    final int? startDate,
    final int? endDate,
    final bool? ongoingOnly,
    final int? limit,
    final int? offset,
  }) = _$GetFlareUpsInputImpl;

  @override
  String get profileId;
  @override
  String? get conditionId;
  @override
  int? get startDate; // Epoch milliseconds
  @override
  int? get endDate; // Epoch milliseconds
  @override
  bool? get ongoingOnly;
  @override
  int? get limit;
  @override
  int? get offset;

  /// Create a copy of GetFlareUpsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetFlareUpsInputImplCopyWith<_$GetFlareUpsInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateFlareUpInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  int? get severity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get triggers => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError;

  /// Create a copy of UpdateFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateFlareUpInputCopyWith<UpdateFlareUpInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateFlareUpInputCopyWith<$Res> {
  factory $UpdateFlareUpInputCopyWith(
    UpdateFlareUpInput value,
    $Res Function(UpdateFlareUpInput) then,
  ) = _$UpdateFlareUpInputCopyWithImpl<$Res, UpdateFlareUpInput>;
  @useResult
  $Res call({
    String id,
    String profileId,
    int? severity,
    String? notes,
    List<String>? triggers,
    String? photoPath,
  });
}

/// @nodoc
class _$UpdateFlareUpInputCopyWithImpl<$Res, $Val extends UpdateFlareUpInput>
    implements $UpdateFlareUpInputCopyWith<$Res> {
  _$UpdateFlareUpInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? severity = freezed,
    Object? notes = freezed,
    Object? triggers = freezed,
    Object? photoPath = freezed,
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
            severity: freezed == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            triggers: freezed == triggers
                ? _value.triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateFlareUpInputImplCopyWith<$Res>
    implements $UpdateFlareUpInputCopyWith<$Res> {
  factory _$$UpdateFlareUpInputImplCopyWith(
    _$UpdateFlareUpInputImpl value,
    $Res Function(_$UpdateFlareUpInputImpl) then,
  ) = __$$UpdateFlareUpInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    int? severity,
    String? notes,
    List<String>? triggers,
    String? photoPath,
  });
}

/// @nodoc
class __$$UpdateFlareUpInputImplCopyWithImpl<$Res>
    extends _$UpdateFlareUpInputCopyWithImpl<$Res, _$UpdateFlareUpInputImpl>
    implements _$$UpdateFlareUpInputImplCopyWith<$Res> {
  __$$UpdateFlareUpInputImplCopyWithImpl(
    _$UpdateFlareUpInputImpl _value,
    $Res Function(_$UpdateFlareUpInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? severity = freezed,
    Object? notes = freezed,
    Object? triggers = freezed,
    Object? photoPath = freezed,
  }) {
    return _then(
      _$UpdateFlareUpInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        severity: freezed == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        triggers: freezed == triggers
            ? _value._triggers
            : triggers // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateFlareUpInputImpl implements _UpdateFlareUpInput {
  const _$UpdateFlareUpInputImpl({
    required this.id,
    required this.profileId,
    this.severity,
    this.notes,
    final List<String>? triggers,
    this.photoPath,
  }) : _triggers = triggers;

  @override
  final String id;
  @override
  final String profileId;
  @override
  final int? severity;
  @override
  final String? notes;
  final List<String>? _triggers;
  @override
  List<String>? get triggers {
    final value = _triggers;
    if (value == null) return null;
    if (_triggers is EqualUnmodifiableListView) return _triggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? photoPath;

  @override
  String toString() {
    return 'UpdateFlareUpInput(id: $id, profileId: $profileId, severity: $severity, notes: $notes, triggers: $triggers, photoPath: $photoPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateFlareUpInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._triggers, _triggers) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    severity,
    notes,
    const DeepCollectionEquality().hash(_triggers),
    photoPath,
  );

  /// Create a copy of UpdateFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateFlareUpInputImplCopyWith<_$UpdateFlareUpInputImpl> get copyWith =>
      __$$UpdateFlareUpInputImplCopyWithImpl<_$UpdateFlareUpInputImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateFlareUpInput implements UpdateFlareUpInput {
  const factory _UpdateFlareUpInput({
    required final String id,
    required final String profileId,
    final int? severity,
    final String? notes,
    final List<String>? triggers,
    final String? photoPath,
  }) = _$UpdateFlareUpInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  int? get severity;
  @override
  String? get notes;
  @override
  List<String>? get triggers;
  @override
  String? get photoPath;

  /// Create a copy of UpdateFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateFlareUpInputImplCopyWith<_$UpdateFlareUpInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EndFlareUpInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  int get endDate => throw _privateConstructorUsedError;

  /// Create a copy of EndFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EndFlareUpInputCopyWith<EndFlareUpInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EndFlareUpInputCopyWith<$Res> {
  factory $EndFlareUpInputCopyWith(
    EndFlareUpInput value,
    $Res Function(EndFlareUpInput) then,
  ) = _$EndFlareUpInputCopyWithImpl<$Res, EndFlareUpInput>;
  @useResult
  $Res call({String id, String profileId, int endDate});
}

/// @nodoc
class _$EndFlareUpInputCopyWithImpl<$Res, $Val extends EndFlareUpInput>
    implements $EndFlareUpInputCopyWith<$Res> {
  _$EndFlareUpInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EndFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? endDate = null,
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
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EndFlareUpInputImplCopyWith<$Res>
    implements $EndFlareUpInputCopyWith<$Res> {
  factory _$$EndFlareUpInputImplCopyWith(
    _$EndFlareUpInputImpl value,
    $Res Function(_$EndFlareUpInputImpl) then,
  ) = __$$EndFlareUpInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId, int endDate});
}

/// @nodoc
class __$$EndFlareUpInputImplCopyWithImpl<$Res>
    extends _$EndFlareUpInputCopyWithImpl<$Res, _$EndFlareUpInputImpl>
    implements _$$EndFlareUpInputImplCopyWith<$Res> {
  __$$EndFlareUpInputImplCopyWithImpl(
    _$EndFlareUpInputImpl _value,
    $Res Function(_$EndFlareUpInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EndFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? endDate = null,
  }) {
    return _then(
      _$EndFlareUpInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$EndFlareUpInputImpl implements _EndFlareUpInput {
  const _$EndFlareUpInputImpl({
    required this.id,
    required this.profileId,
    required this.endDate,
  });

  @override
  final String id;
  @override
  final String profileId;
  @override
  final int endDate;

  @override
  String toString() {
    return 'EndFlareUpInput(id: $id, profileId: $profileId, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EndFlareUpInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId, endDate);

  /// Create a copy of EndFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EndFlareUpInputImplCopyWith<_$EndFlareUpInputImpl> get copyWith =>
      __$$EndFlareUpInputImplCopyWithImpl<_$EndFlareUpInputImpl>(
        this,
        _$identity,
      );
}

abstract class _EndFlareUpInput implements EndFlareUpInput {
  const factory _EndFlareUpInput({
    required final String id,
    required final String profileId,
    required final int endDate,
  }) = _$EndFlareUpInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  int get endDate;

  /// Create a copy of EndFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EndFlareUpInputImplCopyWith<_$EndFlareUpInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeleteFlareUpInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of DeleteFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteFlareUpInputCopyWith<DeleteFlareUpInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteFlareUpInputCopyWith<$Res> {
  factory $DeleteFlareUpInputCopyWith(
    DeleteFlareUpInput value,
    $Res Function(DeleteFlareUpInput) then,
  ) = _$DeleteFlareUpInputCopyWithImpl<$Res, DeleteFlareUpInput>;
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class _$DeleteFlareUpInputCopyWithImpl<$Res, $Val extends DeleteFlareUpInput>
    implements $DeleteFlareUpInputCopyWith<$Res> {
  _$DeleteFlareUpInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteFlareUpInput
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
abstract class _$$DeleteFlareUpInputImplCopyWith<$Res>
    implements $DeleteFlareUpInputCopyWith<$Res> {
  factory _$$DeleteFlareUpInputImplCopyWith(
    _$DeleteFlareUpInputImpl value,
    $Res Function(_$DeleteFlareUpInputImpl) then,
  ) = __$$DeleteFlareUpInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class __$$DeleteFlareUpInputImplCopyWithImpl<$Res>
    extends _$DeleteFlareUpInputCopyWithImpl<$Res, _$DeleteFlareUpInputImpl>
    implements _$$DeleteFlareUpInputImplCopyWith<$Res> {
  __$$DeleteFlareUpInputImplCopyWithImpl(
    _$DeleteFlareUpInputImpl _value,
    $Res Function(_$DeleteFlareUpInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? profileId = null}) {
    return _then(
      _$DeleteFlareUpInputImpl(
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

class _$DeleteFlareUpInputImpl implements _DeleteFlareUpInput {
  const _$DeleteFlareUpInputImpl({required this.id, required this.profileId});

  @override
  final String id;
  @override
  final String profileId;

  @override
  String toString() {
    return 'DeleteFlareUpInput(id: $id, profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteFlareUpInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId);

  /// Create a copy of DeleteFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteFlareUpInputImplCopyWith<_$DeleteFlareUpInputImpl> get copyWith =>
      __$$DeleteFlareUpInputImplCopyWithImpl<_$DeleteFlareUpInputImpl>(
        this,
        _$identity,
      );
}

abstract class _DeleteFlareUpInput implements DeleteFlareUpInput {
  const factory _DeleteFlareUpInput({
    required final String id,
    required final String profileId,
  }) = _$DeleteFlareUpInputImpl;

  @override
  String get id;
  @override
  String get profileId;

  /// Create a copy of DeleteFlareUpInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteFlareUpInputImplCopyWith<_$DeleteFlareUpInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
