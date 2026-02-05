// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intake_log_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GetIntakeLogsInput {
  String get profileId => throw _privateConstructorUsedError;
  IntakeLogStatus? get status => throw _privateConstructorUsedError;
  int? get startDate => throw _privateConstructorUsedError; // Epoch ms
  int? get endDate => throw _privateConstructorUsedError; // Epoch ms
  int? get limit => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;

  /// Create a copy of GetIntakeLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetIntakeLogsInputCopyWith<GetIntakeLogsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetIntakeLogsInputCopyWith<$Res> {
  factory $GetIntakeLogsInputCopyWith(
    GetIntakeLogsInput value,
    $Res Function(GetIntakeLogsInput) then,
  ) = _$GetIntakeLogsInputCopyWithImpl<$Res, GetIntakeLogsInput>;
  @useResult
  $Res call({
    String profileId,
    IntakeLogStatus? status,
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class _$GetIntakeLogsInputCopyWithImpl<$Res, $Val extends GetIntakeLogsInput>
    implements $GetIntakeLogsInputCopyWith<$Res> {
  _$GetIntakeLogsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetIntakeLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? status = freezed,
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
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as IntakeLogStatus?,
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
abstract class _$$GetIntakeLogsInputImplCopyWith<$Res>
    implements $GetIntakeLogsInputCopyWith<$Res> {
  factory _$$GetIntakeLogsInputImplCopyWith(
    _$GetIntakeLogsInputImpl value,
    $Res Function(_$GetIntakeLogsInputImpl) then,
  ) = __$$GetIntakeLogsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    IntakeLogStatus? status,
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class __$$GetIntakeLogsInputImplCopyWithImpl<$Res>
    extends _$GetIntakeLogsInputCopyWithImpl<$Res, _$GetIntakeLogsInputImpl>
    implements _$$GetIntakeLogsInputImplCopyWith<$Res> {
  __$$GetIntakeLogsInputImplCopyWithImpl(
    _$GetIntakeLogsInputImpl _value,
    $Res Function(_$GetIntakeLogsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetIntakeLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? status = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _$GetIntakeLogsInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as IntakeLogStatus?,
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

class _$GetIntakeLogsInputImpl implements _GetIntakeLogsInput {
  const _$GetIntakeLogsInputImpl({
    required this.profileId,
    this.status,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });

  @override
  final String profileId;
  @override
  final IntakeLogStatus? status;
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
    return 'GetIntakeLogsInput(profileId: $profileId, status: $status, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetIntakeLogsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    status,
    startDate,
    endDate,
    limit,
    offset,
  );

  /// Create a copy of GetIntakeLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetIntakeLogsInputImplCopyWith<_$GetIntakeLogsInputImpl> get copyWith =>
      __$$GetIntakeLogsInputImplCopyWithImpl<_$GetIntakeLogsInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetIntakeLogsInput implements GetIntakeLogsInput {
  const factory _GetIntakeLogsInput({
    required final String profileId,
    final IntakeLogStatus? status,
    final int? startDate,
    final int? endDate,
    final int? limit,
    final int? offset,
  }) = _$GetIntakeLogsInputImpl;

  @override
  String get profileId;
  @override
  IntakeLogStatus? get status;
  @override
  int? get startDate; // Epoch ms
  @override
  int? get endDate; // Epoch ms
  @override
  int? get limit;
  @override
  int? get offset;

  /// Create a copy of GetIntakeLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetIntakeLogsInputImplCopyWith<_$GetIntakeLogsInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MarkTakenInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  int get actualTime => throw _privateConstructorUsedError;

  /// Create a copy of MarkTakenInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarkTakenInputCopyWith<MarkTakenInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarkTakenInputCopyWith<$Res> {
  factory $MarkTakenInputCopyWith(
    MarkTakenInput value,
    $Res Function(MarkTakenInput) then,
  ) = _$MarkTakenInputCopyWithImpl<$Res, MarkTakenInput>;
  @useResult
  $Res call({String id, String profileId, int actualTime});
}

/// @nodoc
class _$MarkTakenInputCopyWithImpl<$Res, $Val extends MarkTakenInput>
    implements $MarkTakenInputCopyWith<$Res> {
  _$MarkTakenInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarkTakenInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? actualTime = null,
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
            actualTime: null == actualTime
                ? _value.actualTime
                : actualTime // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarkTakenInputImplCopyWith<$Res>
    implements $MarkTakenInputCopyWith<$Res> {
  factory _$$MarkTakenInputImplCopyWith(
    _$MarkTakenInputImpl value,
    $Res Function(_$MarkTakenInputImpl) then,
  ) = __$$MarkTakenInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId, int actualTime});
}

/// @nodoc
class __$$MarkTakenInputImplCopyWithImpl<$Res>
    extends _$MarkTakenInputCopyWithImpl<$Res, _$MarkTakenInputImpl>
    implements _$$MarkTakenInputImplCopyWith<$Res> {
  __$$MarkTakenInputImplCopyWithImpl(
    _$MarkTakenInputImpl _value,
    $Res Function(_$MarkTakenInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarkTakenInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? actualTime = null,
  }) {
    return _then(
      _$MarkTakenInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        actualTime: null == actualTime
            ? _value.actualTime
            : actualTime // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$MarkTakenInputImpl implements _MarkTakenInput {
  const _$MarkTakenInputImpl({
    required this.id,
    required this.profileId,
    required this.actualTime,
  });

  @override
  final String id;
  @override
  final String profileId;
  @override
  final int actualTime;

  @override
  String toString() {
    return 'MarkTakenInput(id: $id, profileId: $profileId, actualTime: $actualTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarkTakenInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.actualTime, actualTime) ||
                other.actualTime == actualTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId, actualTime);

  /// Create a copy of MarkTakenInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarkTakenInputImplCopyWith<_$MarkTakenInputImpl> get copyWith =>
      __$$MarkTakenInputImplCopyWithImpl<_$MarkTakenInputImpl>(
        this,
        _$identity,
      );
}

abstract class _MarkTakenInput implements MarkTakenInput {
  const factory _MarkTakenInput({
    required final String id,
    required final String profileId,
    required final int actualTime,
  }) = _$MarkTakenInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  int get actualTime;

  /// Create a copy of MarkTakenInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarkTakenInputImplCopyWith<_$MarkTakenInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MarkSkippedInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Create a copy of MarkSkippedInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarkSkippedInputCopyWith<MarkSkippedInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarkSkippedInputCopyWith<$Res> {
  factory $MarkSkippedInputCopyWith(
    MarkSkippedInput value,
    $Res Function(MarkSkippedInput) then,
  ) = _$MarkSkippedInputCopyWithImpl<$Res, MarkSkippedInput>;
  @useResult
  $Res call({String id, String profileId, String? reason});
}

/// @nodoc
class _$MarkSkippedInputCopyWithImpl<$Res, $Val extends MarkSkippedInput>
    implements $MarkSkippedInputCopyWith<$Res> {
  _$MarkSkippedInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarkSkippedInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? reason = freezed,
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
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarkSkippedInputImplCopyWith<$Res>
    implements $MarkSkippedInputCopyWith<$Res> {
  factory _$$MarkSkippedInputImplCopyWith(
    _$MarkSkippedInputImpl value,
    $Res Function(_$MarkSkippedInputImpl) then,
  ) = __$$MarkSkippedInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId, String? reason});
}

/// @nodoc
class __$$MarkSkippedInputImplCopyWithImpl<$Res>
    extends _$MarkSkippedInputCopyWithImpl<$Res, _$MarkSkippedInputImpl>
    implements _$$MarkSkippedInputImplCopyWith<$Res> {
  __$$MarkSkippedInputImplCopyWithImpl(
    _$MarkSkippedInputImpl _value,
    $Res Function(_$MarkSkippedInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarkSkippedInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? reason = freezed,
  }) {
    return _then(
      _$MarkSkippedInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$MarkSkippedInputImpl implements _MarkSkippedInput {
  const _$MarkSkippedInputImpl({
    required this.id,
    required this.profileId,
    this.reason,
  });

  @override
  final String id;
  @override
  final String profileId;
  @override
  final String? reason;

  @override
  String toString() {
    return 'MarkSkippedInput(id: $id, profileId: $profileId, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarkSkippedInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId, reason);

  /// Create a copy of MarkSkippedInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarkSkippedInputImplCopyWith<_$MarkSkippedInputImpl> get copyWith =>
      __$$MarkSkippedInputImplCopyWithImpl<_$MarkSkippedInputImpl>(
        this,
        _$identity,
      );
}

abstract class _MarkSkippedInput implements MarkSkippedInput {
  const factory _MarkSkippedInput({
    required final String id,
    required final String profileId,
    final String? reason,
  }) = _$MarkSkippedInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  String? get reason;

  /// Create a copy of MarkSkippedInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarkSkippedInputImplCopyWith<_$MarkSkippedInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
