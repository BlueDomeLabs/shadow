// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guest_invite_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateGuestInviteInput {
  String get profileId => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  int? get expiresAt => throw _privateConstructorUsedError;

  /// Create a copy of CreateGuestInviteInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateGuestInviteInputCopyWith<CreateGuestInviteInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateGuestInviteInputCopyWith<$Res> {
  factory $CreateGuestInviteInputCopyWith(
    CreateGuestInviteInput value,
    $Res Function(CreateGuestInviteInput) then,
  ) = _$CreateGuestInviteInputCopyWithImpl<$Res, CreateGuestInviteInput>;
  @useResult
  $Res call({String profileId, String label, int? expiresAt});
}

/// @nodoc
class _$CreateGuestInviteInputCopyWithImpl<
  $Res,
  $Val extends CreateGuestInviteInput
>
    implements $CreateGuestInviteInputCopyWith<$Res> {
  _$CreateGuestInviteInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateGuestInviteInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? label = null,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateGuestInviteInputImplCopyWith<$Res>
    implements $CreateGuestInviteInputCopyWith<$Res> {
  factory _$$CreateGuestInviteInputImplCopyWith(
    _$CreateGuestInviteInputImpl value,
    $Res Function(_$CreateGuestInviteInputImpl) then,
  ) = __$$CreateGuestInviteInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, String label, int? expiresAt});
}

/// @nodoc
class __$$CreateGuestInviteInputImplCopyWithImpl<$Res>
    extends
        _$CreateGuestInviteInputCopyWithImpl<$Res, _$CreateGuestInviteInputImpl>
    implements _$$CreateGuestInviteInputImplCopyWith<$Res> {
  __$$CreateGuestInviteInputImplCopyWithImpl(
    _$CreateGuestInviteInputImpl _value,
    $Res Function(_$CreateGuestInviteInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateGuestInviteInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? label = null,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _$CreateGuestInviteInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$CreateGuestInviteInputImpl implements _CreateGuestInviteInput {
  const _$CreateGuestInviteInputImpl({
    required this.profileId,
    this.label = '',
    this.expiresAt,
  });

  @override
  final String profileId;
  @override
  @JsonKey()
  final String label;
  @override
  final int? expiresAt;

  @override
  String toString() {
    return 'CreateGuestInviteInput(profileId: $profileId, label: $label, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateGuestInviteInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, label, expiresAt);

  /// Create a copy of CreateGuestInviteInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateGuestInviteInputImplCopyWith<_$CreateGuestInviteInputImpl>
  get copyWith =>
      __$$CreateGuestInviteInputImplCopyWithImpl<_$CreateGuestInviteInputImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateGuestInviteInput implements CreateGuestInviteInput {
  const factory _CreateGuestInviteInput({
    required final String profileId,
    final String label,
    final int? expiresAt,
  }) = _$CreateGuestInviteInputImpl;

  @override
  String get profileId;
  @override
  String get label;
  @override
  int? get expiresAt;

  /// Create a copy of CreateGuestInviteInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateGuestInviteInputImplCopyWith<_$CreateGuestInviteInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RevokeGuestInviteInput {
  String get inviteId => throw _privateConstructorUsedError;

  /// Create a copy of RevokeGuestInviteInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevokeGuestInviteInputCopyWith<RevokeGuestInviteInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevokeGuestInviteInputCopyWith<$Res> {
  factory $RevokeGuestInviteInputCopyWith(
    RevokeGuestInviteInput value,
    $Res Function(RevokeGuestInviteInput) then,
  ) = _$RevokeGuestInviteInputCopyWithImpl<$Res, RevokeGuestInviteInput>;
  @useResult
  $Res call({String inviteId});
}

/// @nodoc
class _$RevokeGuestInviteInputCopyWithImpl<
  $Res,
  $Val extends RevokeGuestInviteInput
>
    implements $RevokeGuestInviteInputCopyWith<$Res> {
  _$RevokeGuestInviteInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevokeGuestInviteInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? inviteId = null}) {
    return _then(
      _value.copyWith(
            inviteId: null == inviteId
                ? _value.inviteId
                : inviteId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RevokeGuestInviteInputImplCopyWith<$Res>
    implements $RevokeGuestInviteInputCopyWith<$Res> {
  factory _$$RevokeGuestInviteInputImplCopyWith(
    _$RevokeGuestInviteInputImpl value,
    $Res Function(_$RevokeGuestInviteInputImpl) then,
  ) = __$$RevokeGuestInviteInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String inviteId});
}

/// @nodoc
class __$$RevokeGuestInviteInputImplCopyWithImpl<$Res>
    extends
        _$RevokeGuestInviteInputCopyWithImpl<$Res, _$RevokeGuestInviteInputImpl>
    implements _$$RevokeGuestInviteInputImplCopyWith<$Res> {
  __$$RevokeGuestInviteInputImplCopyWithImpl(
    _$RevokeGuestInviteInputImpl _value,
    $Res Function(_$RevokeGuestInviteInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RevokeGuestInviteInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? inviteId = null}) {
    return _then(
      _$RevokeGuestInviteInputImpl(
        inviteId: null == inviteId
            ? _value.inviteId
            : inviteId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RevokeGuestInviteInputImpl implements _RevokeGuestInviteInput {
  const _$RevokeGuestInviteInputImpl({required this.inviteId});

  @override
  final String inviteId;

  @override
  String toString() {
    return 'RevokeGuestInviteInput(inviteId: $inviteId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevokeGuestInviteInputImpl &&
            (identical(other.inviteId, inviteId) ||
                other.inviteId == inviteId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, inviteId);

  /// Create a copy of RevokeGuestInviteInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevokeGuestInviteInputImplCopyWith<_$RevokeGuestInviteInputImpl>
  get copyWith =>
      __$$RevokeGuestInviteInputImplCopyWithImpl<_$RevokeGuestInviteInputImpl>(
        this,
        _$identity,
      );
}

abstract class _RevokeGuestInviteInput implements RevokeGuestInviteInput {
  const factory _RevokeGuestInviteInput({required final String inviteId}) =
      _$RevokeGuestInviteInputImpl;

  @override
  String get inviteId;

  /// Create a copy of RevokeGuestInviteInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevokeGuestInviteInputImplCopyWith<_$RevokeGuestInviteInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ValidateGuestTokenInput {
  String get token => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;

  /// Create a copy of ValidateGuestTokenInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValidateGuestTokenInputCopyWith<ValidateGuestTokenInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidateGuestTokenInputCopyWith<$Res> {
  factory $ValidateGuestTokenInputCopyWith(
    ValidateGuestTokenInput value,
    $Res Function(ValidateGuestTokenInput) then,
  ) = _$ValidateGuestTokenInputCopyWithImpl<$Res, ValidateGuestTokenInput>;
  @useResult
  $Res call({String token, String deviceId});
}

/// @nodoc
class _$ValidateGuestTokenInputCopyWithImpl<
  $Res,
  $Val extends ValidateGuestTokenInput
>
    implements $ValidateGuestTokenInputCopyWith<$Res> {
  _$ValidateGuestTokenInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValidateGuestTokenInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null, Object? deviceId = null}) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceId: null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ValidateGuestTokenInputImplCopyWith<$Res>
    implements $ValidateGuestTokenInputCopyWith<$Res> {
  factory _$$ValidateGuestTokenInputImplCopyWith(
    _$ValidateGuestTokenInputImpl value,
    $Res Function(_$ValidateGuestTokenInputImpl) then,
  ) = __$$ValidateGuestTokenInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String deviceId});
}

/// @nodoc
class __$$ValidateGuestTokenInputImplCopyWithImpl<$Res>
    extends
        _$ValidateGuestTokenInputCopyWithImpl<
          $Res,
          _$ValidateGuestTokenInputImpl
        >
    implements _$$ValidateGuestTokenInputImplCopyWith<$Res> {
  __$$ValidateGuestTokenInputImplCopyWithImpl(
    _$ValidateGuestTokenInputImpl _value,
    $Res Function(_$ValidateGuestTokenInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ValidateGuestTokenInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null, Object? deviceId = null}) {
    return _then(
      _$ValidateGuestTokenInputImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceId: null == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ValidateGuestTokenInputImpl implements _ValidateGuestTokenInput {
  const _$ValidateGuestTokenInputImpl({
    required this.token,
    required this.deviceId,
  });

  @override
  final String token;
  @override
  final String deviceId;

  @override
  String toString() {
    return 'ValidateGuestTokenInput(token: $token, deviceId: $deviceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidateGuestTokenInputImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, deviceId);

  /// Create a copy of ValidateGuestTokenInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidateGuestTokenInputImplCopyWith<_$ValidateGuestTokenInputImpl>
  get copyWith =>
      __$$ValidateGuestTokenInputImplCopyWithImpl<
        _$ValidateGuestTokenInputImpl
      >(this, _$identity);
}

abstract class _ValidateGuestTokenInput implements ValidateGuestTokenInput {
  const factory _ValidateGuestTokenInput({
    required final String token,
    required final String deviceId,
  }) = _$ValidateGuestTokenInputImpl;

  @override
  String get token;
  @override
  String get deviceId;

  /// Create a copy of ValidateGuestTokenInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidateGuestTokenInputImplCopyWith<_$ValidateGuestTokenInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RemoveGuestDeviceInput {
  String get inviteId => throw _privateConstructorUsedError;

  /// Create a copy of RemoveGuestDeviceInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RemoveGuestDeviceInputCopyWith<RemoveGuestDeviceInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoveGuestDeviceInputCopyWith<$Res> {
  factory $RemoveGuestDeviceInputCopyWith(
    RemoveGuestDeviceInput value,
    $Res Function(RemoveGuestDeviceInput) then,
  ) = _$RemoveGuestDeviceInputCopyWithImpl<$Res, RemoveGuestDeviceInput>;
  @useResult
  $Res call({String inviteId});
}

/// @nodoc
class _$RemoveGuestDeviceInputCopyWithImpl<
  $Res,
  $Val extends RemoveGuestDeviceInput
>
    implements $RemoveGuestDeviceInputCopyWith<$Res> {
  _$RemoveGuestDeviceInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RemoveGuestDeviceInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? inviteId = null}) {
    return _then(
      _value.copyWith(
            inviteId: null == inviteId
                ? _value.inviteId
                : inviteId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RemoveGuestDeviceInputImplCopyWith<$Res>
    implements $RemoveGuestDeviceInputCopyWith<$Res> {
  factory _$$RemoveGuestDeviceInputImplCopyWith(
    _$RemoveGuestDeviceInputImpl value,
    $Res Function(_$RemoveGuestDeviceInputImpl) then,
  ) = __$$RemoveGuestDeviceInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String inviteId});
}

/// @nodoc
class __$$RemoveGuestDeviceInputImplCopyWithImpl<$Res>
    extends
        _$RemoveGuestDeviceInputCopyWithImpl<$Res, _$RemoveGuestDeviceInputImpl>
    implements _$$RemoveGuestDeviceInputImplCopyWith<$Res> {
  __$$RemoveGuestDeviceInputImplCopyWithImpl(
    _$RemoveGuestDeviceInputImpl _value,
    $Res Function(_$RemoveGuestDeviceInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RemoveGuestDeviceInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? inviteId = null}) {
    return _then(
      _$RemoveGuestDeviceInputImpl(
        inviteId: null == inviteId
            ? _value.inviteId
            : inviteId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RemoveGuestDeviceInputImpl implements _RemoveGuestDeviceInput {
  const _$RemoveGuestDeviceInputImpl({required this.inviteId});

  @override
  final String inviteId;

  @override
  String toString() {
    return 'RemoveGuestDeviceInput(inviteId: $inviteId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoveGuestDeviceInputImpl &&
            (identical(other.inviteId, inviteId) ||
                other.inviteId == inviteId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, inviteId);

  /// Create a copy of RemoveGuestDeviceInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoveGuestDeviceInputImplCopyWith<_$RemoveGuestDeviceInputImpl>
  get copyWith =>
      __$$RemoveGuestDeviceInputImplCopyWithImpl<_$RemoveGuestDeviceInputImpl>(
        this,
        _$identity,
      );
}

abstract class _RemoveGuestDeviceInput implements RemoveGuestDeviceInput {
  const factory _RemoveGuestDeviceInput({required final String inviteId}) =
      _$RemoveGuestDeviceInputImpl;

  @override
  String get inviteId;

  /// Create a copy of RemoveGuestDeviceInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoveGuestDeviceInputImplCopyWith<_$RemoveGuestDeviceInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}
