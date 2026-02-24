// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fasting_types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StartFastInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  DietPresetType get protocol =>
      throw _privateConstructorUsedError; // e.g. DietPresetType.if168
  int get startedAt =>
      throw _privateConstructorUsedError; // Epoch ms — when fast begins
  double get targetHours => throw _privateConstructorUsedError;

  /// Create a copy of StartFastInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartFastInputCopyWith<StartFastInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartFastInputCopyWith<$Res> {
  factory $StartFastInputCopyWith(
    StartFastInput value,
    $Res Function(StartFastInput) then,
  ) = _$StartFastInputCopyWithImpl<$Res, StartFastInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    DietPresetType protocol,
    int startedAt,
    double targetHours,
  });
}

/// @nodoc
class _$StartFastInputCopyWithImpl<$Res, $Val extends StartFastInput>
    implements $StartFastInputCopyWith<$Res> {
  _$StartFastInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartFastInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? protocol = null,
    Object? startedAt = null,
    Object? targetHours = null,
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
            protocol: null == protocol
                ? _value.protocol
                : protocol // ignore: cast_nullable_to_non_nullable
                      as DietPresetType,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as int,
            targetHours: null == targetHours
                ? _value.targetHours
                : targetHours // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StartFastInputImplCopyWith<$Res>
    implements $StartFastInputCopyWith<$Res> {
  factory _$$StartFastInputImplCopyWith(
    _$StartFastInputImpl value,
    $Res Function(_$StartFastInputImpl) then,
  ) = __$$StartFastInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    DietPresetType protocol,
    int startedAt,
    double targetHours,
  });
}

/// @nodoc
class __$$StartFastInputImplCopyWithImpl<$Res>
    extends _$StartFastInputCopyWithImpl<$Res, _$StartFastInputImpl>
    implements _$$StartFastInputImplCopyWith<$Res> {
  __$$StartFastInputImplCopyWithImpl(
    _$StartFastInputImpl _value,
    $Res Function(_$StartFastInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StartFastInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? protocol = null,
    Object? startedAt = null,
    Object? targetHours = null,
  }) {
    return _then(
      _$StartFastInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        protocol: null == protocol
            ? _value.protocol
            : protocol // ignore: cast_nullable_to_non_nullable
                  as DietPresetType,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as int,
        targetHours: null == targetHours
            ? _value.targetHours
            : targetHours // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$StartFastInputImpl implements _StartFastInput {
  const _$StartFastInputImpl({
    required this.profileId,
    required this.clientId,
    required this.protocol,
    required this.startedAt,
    required this.targetHours,
  });

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final DietPresetType protocol;
  // e.g. DietPresetType.if168
  @override
  final int startedAt;
  // Epoch ms — when fast begins
  @override
  final double targetHours;

  @override
  String toString() {
    return 'StartFastInput(profileId: $profileId, clientId: $clientId, protocol: $protocol, startedAt: $startedAt, targetHours: $targetHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartFastInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.targetHours, targetHours) ||
                other.targetHours == targetHours));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    protocol,
    startedAt,
    targetHours,
  );

  /// Create a copy of StartFastInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartFastInputImplCopyWith<_$StartFastInputImpl> get copyWith =>
      __$$StartFastInputImplCopyWithImpl<_$StartFastInputImpl>(
        this,
        _$identity,
      );
}

abstract class _StartFastInput implements StartFastInput {
  const factory _StartFastInput({
    required final String profileId,
    required final String clientId,
    required final DietPresetType protocol,
    required final int startedAt,
    required final double targetHours,
  }) = _$StartFastInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  DietPresetType get protocol; // e.g. DietPresetType.if168
  @override
  int get startedAt; // Epoch ms — when fast begins
  @override
  double get targetHours;

  /// Create a copy of StartFastInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartFastInputImplCopyWith<_$StartFastInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EndFastInput {
  String get profileId => throw _privateConstructorUsedError;
  String get sessionId =>
      throw _privateConstructorUsedError; // ID of the active fasting session
  int get endedAt => throw _privateConstructorUsedError; // Epoch ms
  bool get isManualEnd => throw _privateConstructorUsedError;

  /// Create a copy of EndFastInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EndFastInputCopyWith<EndFastInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EndFastInputCopyWith<$Res> {
  factory $EndFastInputCopyWith(
    EndFastInput value,
    $Res Function(EndFastInput) then,
  ) = _$EndFastInputCopyWithImpl<$Res, EndFastInput>;
  @useResult
  $Res call({
    String profileId,
    String sessionId,
    int endedAt,
    bool isManualEnd,
  });
}

/// @nodoc
class _$EndFastInputCopyWithImpl<$Res, $Val extends EndFastInput>
    implements $EndFastInputCopyWith<$Res> {
  _$EndFastInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EndFastInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? sessionId = null,
    Object? endedAt = null,
    Object? isManualEnd = null,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            endedAt: null == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as int,
            isManualEnd: null == isManualEnd
                ? _value.isManualEnd
                : isManualEnd // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EndFastInputImplCopyWith<$Res>
    implements $EndFastInputCopyWith<$Res> {
  factory _$$EndFastInputImplCopyWith(
    _$EndFastInputImpl value,
    $Res Function(_$EndFastInputImpl) then,
  ) = __$$EndFastInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String sessionId,
    int endedAt,
    bool isManualEnd,
  });
}

/// @nodoc
class __$$EndFastInputImplCopyWithImpl<$Res>
    extends _$EndFastInputCopyWithImpl<$Res, _$EndFastInputImpl>
    implements _$$EndFastInputImplCopyWith<$Res> {
  __$$EndFastInputImplCopyWithImpl(
    _$EndFastInputImpl _value,
    $Res Function(_$EndFastInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EndFastInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? sessionId = null,
    Object? endedAt = null,
    Object? isManualEnd = null,
  }) {
    return _then(
      _$EndFastInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        endedAt: null == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as int,
        isManualEnd: null == isManualEnd
            ? _value.isManualEnd
            : isManualEnd // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$EndFastInputImpl implements _EndFastInput {
  const _$EndFastInputImpl({
    required this.profileId,
    required this.sessionId,
    required this.endedAt,
    this.isManualEnd = false,
  });

  @override
  final String profileId;
  @override
  final String sessionId;
  // ID of the active fasting session
  @override
  final int endedAt;
  // Epoch ms
  @override
  @JsonKey()
  final bool isManualEnd;

  @override
  String toString() {
    return 'EndFastInput(profileId: $profileId, sessionId: $sessionId, endedAt: $endedAt, isManualEnd: $isManualEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EndFastInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.isManualEnd, isManualEnd) ||
                other.isManualEnd == isManualEnd));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, sessionId, endedAt, isManualEnd);

  /// Create a copy of EndFastInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EndFastInputImplCopyWith<_$EndFastInputImpl> get copyWith =>
      __$$EndFastInputImplCopyWithImpl<_$EndFastInputImpl>(this, _$identity);
}

abstract class _EndFastInput implements EndFastInput {
  const factory _EndFastInput({
    required final String profileId,
    required final String sessionId,
    required final int endedAt,
    final bool isManualEnd,
  }) = _$EndFastInputImpl;

  @override
  String get profileId;
  @override
  String get sessionId; // ID of the active fasting session
  @override
  int get endedAt; // Epoch ms
  @override
  bool get isManualEnd;

  /// Create a copy of EndFastInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EndFastInputImplCopyWith<_$EndFastInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetActiveFastInput {
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of GetActiveFastInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetActiveFastInputCopyWith<GetActiveFastInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetActiveFastInputCopyWith<$Res> {
  factory $GetActiveFastInputCopyWith(
    GetActiveFastInput value,
    $Res Function(GetActiveFastInput) then,
  ) = _$GetActiveFastInputCopyWithImpl<$Res, GetActiveFastInput>;
  @useResult
  $Res call({String profileId});
}

/// @nodoc
class _$GetActiveFastInputCopyWithImpl<$Res, $Val extends GetActiveFastInput>
    implements $GetActiveFastInputCopyWith<$Res> {
  _$GetActiveFastInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetActiveFastInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null}) {
    return _then(
      _value.copyWith(
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
abstract class _$$GetActiveFastInputImplCopyWith<$Res>
    implements $GetActiveFastInputCopyWith<$Res> {
  factory _$$GetActiveFastInputImplCopyWith(
    _$GetActiveFastInputImpl value,
    $Res Function(_$GetActiveFastInputImpl) then,
  ) = __$$GetActiveFastInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId});
}

/// @nodoc
class __$$GetActiveFastInputImplCopyWithImpl<$Res>
    extends _$GetActiveFastInputCopyWithImpl<$Res, _$GetActiveFastInputImpl>
    implements _$$GetActiveFastInputImplCopyWith<$Res> {
  __$$GetActiveFastInputImplCopyWithImpl(
    _$GetActiveFastInputImpl _value,
    $Res Function(_$GetActiveFastInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetActiveFastInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null}) {
    return _then(
      _$GetActiveFastInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GetActiveFastInputImpl implements _GetActiveFastInput {
  const _$GetActiveFastInputImpl({required this.profileId});

  @override
  final String profileId;

  @override
  String toString() {
    return 'GetActiveFastInput(profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetActiveFastInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId);

  /// Create a copy of GetActiveFastInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetActiveFastInputImplCopyWith<_$GetActiveFastInputImpl> get copyWith =>
      __$$GetActiveFastInputImplCopyWithImpl<_$GetActiveFastInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetActiveFastInput implements GetActiveFastInput {
  const factory _GetActiveFastInput({required final String profileId}) =
      _$GetActiveFastInputImpl;

  @override
  String get profileId;

  /// Create a copy of GetActiveFastInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetActiveFastInputImplCopyWith<_$GetActiveFastInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetFastingHistoryInput {
  String get profileId => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;

  /// Create a copy of GetFastingHistoryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetFastingHistoryInputCopyWith<GetFastingHistoryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetFastingHistoryInputCopyWith<$Res> {
  factory $GetFastingHistoryInputCopyWith(
    GetFastingHistoryInput value,
    $Res Function(GetFastingHistoryInput) then,
  ) = _$GetFastingHistoryInputCopyWithImpl<$Res, GetFastingHistoryInput>;
  @useResult
  $Res call({String profileId, int? limit});
}

/// @nodoc
class _$GetFastingHistoryInputCopyWithImpl<
  $Res,
  $Val extends GetFastingHistoryInput
>
    implements $GetFastingHistoryInputCopyWith<$Res> {
  _$GetFastingHistoryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetFastingHistoryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? limit = freezed}) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            limit: freezed == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetFastingHistoryInputImplCopyWith<$Res>
    implements $GetFastingHistoryInputCopyWith<$Res> {
  factory _$$GetFastingHistoryInputImplCopyWith(
    _$GetFastingHistoryInputImpl value,
    $Res Function(_$GetFastingHistoryInputImpl) then,
  ) = __$$GetFastingHistoryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, int? limit});
}

/// @nodoc
class __$$GetFastingHistoryInputImplCopyWithImpl<$Res>
    extends
        _$GetFastingHistoryInputCopyWithImpl<$Res, _$GetFastingHistoryInputImpl>
    implements _$$GetFastingHistoryInputImplCopyWith<$Res> {
  __$$GetFastingHistoryInputImplCopyWithImpl(
    _$GetFastingHistoryInputImpl _value,
    $Res Function(_$GetFastingHistoryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetFastingHistoryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? limit = freezed}) {
    return _then(
      _$GetFastingHistoryInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$GetFastingHistoryInputImpl implements _GetFastingHistoryInput {
  const _$GetFastingHistoryInputImpl({required this.profileId, this.limit});

  @override
  final String profileId;
  @override
  final int? limit;

  @override
  String toString() {
    return 'GetFastingHistoryInput(profileId: $profileId, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetFastingHistoryInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, limit);

  /// Create a copy of GetFastingHistoryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetFastingHistoryInputImplCopyWith<_$GetFastingHistoryInputImpl>
  get copyWith =>
      __$$GetFastingHistoryInputImplCopyWithImpl<_$GetFastingHistoryInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetFastingHistoryInput implements GetFastingHistoryInput {
  const factory _GetFastingHistoryInput({
    required final String profileId,
    final int? limit,
  }) = _$GetFastingHistoryInputImpl;

  @override
  String get profileId;
  @override
  int? get limit;

  /// Create a copy of GetFastingHistoryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetFastingHistoryInputImplCopyWith<_$GetFastingHistoryInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}
