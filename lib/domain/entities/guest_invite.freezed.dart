// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guest_invite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GuestInvite _$GuestInviteFromJson(Map<String, dynamic> json) {
  return _GuestInvite.fromJson(json);
}

/// @nodoc
mixin _$GuestInvite {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get token =>
      throw _privateConstructorUsedError; // Cryptographically secure token (UUID v4)
  String get label =>
      throw _privateConstructorUsedError; // e.g. "John's iPhone"
  int get createdAt => throw _privateConstructorUsedError; // Epoch ms
  int? get expiresAt =>
      throw _privateConstructorUsedError; // Epoch ms, null = no expiry
  bool get isRevoked => throw _privateConstructorUsedError;
  int? get lastSeenAt =>
      throw _privateConstructorUsedError; // Epoch ms, last guest sync
  String? get activeDeviceId => throw _privateConstructorUsedError;

  /// Serializes this GuestInvite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GuestInvite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuestInviteCopyWith<GuestInvite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuestInviteCopyWith<$Res> {
  factory $GuestInviteCopyWith(
    GuestInvite value,
    $Res Function(GuestInvite) then,
  ) = _$GuestInviteCopyWithImpl<$Res, GuestInvite>;
  @useResult
  $Res call({
    String id,
    String profileId,
    String token,
    String label,
    int createdAt,
    int? expiresAt,
    bool isRevoked,
    int? lastSeenAt,
    String? activeDeviceId,
  });
}

/// @nodoc
class _$GuestInviteCopyWithImpl<$Res, $Val extends GuestInvite>
    implements $GuestInviteCopyWith<$Res> {
  _$GuestInviteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuestInvite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? token = null,
    Object? label = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? isRevoked = null,
    Object? lastSeenAt = freezed,
    Object? activeDeviceId = freezed,
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
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as int,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as int?,
            isRevoked: null == isRevoked
                ? _value.isRevoked
                : isRevoked // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastSeenAt: freezed == lastSeenAt
                ? _value.lastSeenAt
                : lastSeenAt // ignore: cast_nullable_to_non_nullable
                      as int?,
            activeDeviceId: freezed == activeDeviceId
                ? _value.activeDeviceId
                : activeDeviceId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GuestInviteImplCopyWith<$Res>
    implements $GuestInviteCopyWith<$Res> {
  factory _$$GuestInviteImplCopyWith(
    _$GuestInviteImpl value,
    $Res Function(_$GuestInviteImpl) then,
  ) = __$$GuestInviteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    String token,
    String label,
    int createdAt,
    int? expiresAt,
    bool isRevoked,
    int? lastSeenAt,
    String? activeDeviceId,
  });
}

/// @nodoc
class __$$GuestInviteImplCopyWithImpl<$Res>
    extends _$GuestInviteCopyWithImpl<$Res, _$GuestInviteImpl>
    implements _$$GuestInviteImplCopyWith<$Res> {
  __$$GuestInviteImplCopyWithImpl(
    _$GuestInviteImpl _value,
    $Res Function(_$GuestInviteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GuestInvite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? token = null,
    Object? label = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? isRevoked = null,
    Object? lastSeenAt = freezed,
    Object? activeDeviceId = freezed,
  }) {
    return _then(
      _$GuestInviteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as int,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as int?,
        isRevoked: null == isRevoked
            ? _value.isRevoked
            : isRevoked // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastSeenAt: freezed == lastSeenAt
            ? _value.lastSeenAt
            : lastSeenAt // ignore: cast_nullable_to_non_nullable
                  as int?,
        activeDeviceId: freezed == activeDeviceId
            ? _value.activeDeviceId
            : activeDeviceId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$GuestInviteImpl extends _GuestInvite {
  const _$GuestInviteImpl({
    required this.id,
    required this.profileId,
    required this.token,
    this.label = '',
    required this.createdAt,
    this.expiresAt,
    this.isRevoked = false,
    this.lastSeenAt,
    this.activeDeviceId,
  }) : super._();

  factory _$GuestInviteImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuestInviteImplFromJson(json);

  @override
  final String id;
  @override
  final String profileId;
  @override
  final String token;
  // Cryptographically secure token (UUID v4)
  @override
  @JsonKey()
  final String label;
  // e.g. "John's iPhone"
  @override
  final int createdAt;
  // Epoch ms
  @override
  final int? expiresAt;
  // Epoch ms, null = no expiry
  @override
  @JsonKey()
  final bool isRevoked;
  @override
  final int? lastSeenAt;
  // Epoch ms, last guest sync
  @override
  final String? activeDeviceId;

  @override
  String toString() {
    return 'GuestInvite(id: $id, profileId: $profileId, token: $token, label: $label, createdAt: $createdAt, expiresAt: $expiresAt, isRevoked: $isRevoked, lastSeenAt: $lastSeenAt, activeDeviceId: $activeDeviceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuestInviteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isRevoked, isRevoked) ||
                other.isRevoked == isRevoked) &&
            (identical(other.lastSeenAt, lastSeenAt) ||
                other.lastSeenAt == lastSeenAt) &&
            (identical(other.activeDeviceId, activeDeviceId) ||
                other.activeDeviceId == activeDeviceId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    token,
    label,
    createdAt,
    expiresAt,
    isRevoked,
    lastSeenAt,
    activeDeviceId,
  );

  /// Create a copy of GuestInvite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuestInviteImplCopyWith<_$GuestInviteImpl> get copyWith =>
      __$$GuestInviteImplCopyWithImpl<_$GuestInviteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuestInviteImplToJson(this);
  }
}

abstract class _GuestInvite extends GuestInvite {
  const factory _GuestInvite({
    required final String id,
    required final String profileId,
    required final String token,
    final String label,
    required final int createdAt,
    final int? expiresAt,
    final bool isRevoked,
    final int? lastSeenAt,
    final String? activeDeviceId,
  }) = _$GuestInviteImpl;
  const _GuestInvite._() : super._();

  factory _GuestInvite.fromJson(Map<String, dynamic> json) =
      _$GuestInviteImpl.fromJson;

  @override
  String get id;
  @override
  String get profileId;
  @override
  String get token; // Cryptographically secure token (UUID v4)
  @override
  String get label; // e.g. "John's iPhone"
  @override
  int get createdAt; // Epoch ms
  @override
  int? get expiresAt; // Epoch ms, null = no expiry
  @override
  bool get isRevoked;
  @override
  int? get lastSeenAt; // Epoch ms, last guest sync
  @override
  String? get activeDeviceId;

  /// Create a copy of GuestInvite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuestInviteImplCopyWith<_$GuestInviteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
