// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fasting_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FastingSession _$FastingSessionFromJson(Map<String, dynamic> json) {
  return _FastingSession.fromJson(json);
}

/// @nodoc
mixin _$FastingSession {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  DietPresetType get protocol =>
      throw _privateConstructorUsedError; // if168, if186, if204, omad, etc.
  int get startedAt =>
      throw _privateConstructorUsedError; // Epoch ms — when fast began
  int? get endedAt =>
      throw _privateConstructorUsedError; // Epoch ms — null if fast is still active
  double get targetHours =>
      throw _privateConstructorUsedError; // e.g. 16.0 for 16:8
  bool get isManualEnd =>
      throw _privateConstructorUsedError; // true if user stopped early
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this FastingSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FastingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FastingSessionCopyWith<FastingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FastingSessionCopyWith<$Res> {
  factory $FastingSessionCopyWith(
    FastingSession value,
    $Res Function(FastingSession) then,
  ) = _$FastingSessionCopyWithImpl<$Res, FastingSession>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    DietPresetType protocol,
    int startedAt,
    int? endedAt,
    double targetHours,
    bool isManualEnd,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$FastingSessionCopyWithImpl<$Res, $Val extends FastingSession>
    implements $FastingSessionCopyWith<$Res> {
  _$FastingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FastingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? protocol = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? targetHours = null,
    Object? isManualEnd = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            protocol: null == protocol
                ? _value.protocol
                : protocol // ignore: cast_nullable_to_non_nullable
                      as DietPresetType,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as int,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetHours: null == targetHours
                ? _value.targetHours
                : targetHours // ignore: cast_nullable_to_non_nullable
                      as double,
            isManualEnd: null == isManualEnd
                ? _value.isManualEnd
                : isManualEnd // ignore: cast_nullable_to_non_nullable
                      as bool,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of FastingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SyncMetadataCopyWith<$Res> get syncMetadata {
    return $SyncMetadataCopyWith<$Res>(_value.syncMetadata, (value) {
      return _then(_value.copyWith(syncMetadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FastingSessionImplCopyWith<$Res>
    implements $FastingSessionCopyWith<$Res> {
  factory _$$FastingSessionImplCopyWith(
    _$FastingSessionImpl value,
    $Res Function(_$FastingSessionImpl) then,
  ) = __$$FastingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    DietPresetType protocol,
    int startedAt,
    int? endedAt,
    double targetHours,
    bool isManualEnd,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$FastingSessionImplCopyWithImpl<$Res>
    extends _$FastingSessionCopyWithImpl<$Res, _$FastingSessionImpl>
    implements _$$FastingSessionImplCopyWith<$Res> {
  __$$FastingSessionImplCopyWithImpl(
    _$FastingSessionImpl _value,
    $Res Function(_$FastingSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FastingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? protocol = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? targetHours = null,
    Object? isManualEnd = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$FastingSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        protocol: null == protocol
            ? _value.protocol
            : protocol // ignore: cast_nullable_to_non_nullable
                  as DietPresetType,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as int,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetHours: null == targetHours
            ? _value.targetHours
            : targetHours // ignore: cast_nullable_to_non_nullable
                  as double,
        isManualEnd: null == isManualEnd
            ? _value.isManualEnd
            : isManualEnd // ignore: cast_nullable_to_non_nullable
                  as bool,
        syncMetadata: null == syncMetadata
            ? _value.syncMetadata
            : syncMetadata // ignore: cast_nullable_to_non_nullable
                  as SyncMetadata,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$FastingSessionImpl extends _FastingSession {
  const _$FastingSessionImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.protocol,
    required this.startedAt,
    this.endedAt,
    required this.targetHours,
    this.isManualEnd = false,
    required this.syncMetadata,
  }) : super._();

  factory _$FastingSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FastingSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final DietPresetType protocol;
  // if168, if186, if204, omad, etc.
  @override
  final int startedAt;
  // Epoch ms — when fast began
  @override
  final int? endedAt;
  // Epoch ms — null if fast is still active
  @override
  final double targetHours;
  // e.g. 16.0 for 16:8
  @override
  @JsonKey()
  final bool isManualEnd;
  // true if user stopped early
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'FastingSession(id: $id, clientId: $clientId, profileId: $profileId, protocol: $protocol, startedAt: $startedAt, endedAt: $endedAt, targetHours: $targetHours, isManualEnd: $isManualEnd, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FastingSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.targetHours, targetHours) ||
                other.targetHours == targetHours) &&
            (identical(other.isManualEnd, isManualEnd) ||
                other.isManualEnd == isManualEnd) &&
            (identical(other.syncMetadata, syncMetadata) ||
                other.syncMetadata == syncMetadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    clientId,
    profileId,
    protocol,
    startedAt,
    endedAt,
    targetHours,
    isManualEnd,
    syncMetadata,
  );

  /// Create a copy of FastingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FastingSessionImplCopyWith<_$FastingSessionImpl> get copyWith =>
      __$$FastingSessionImplCopyWithImpl<_$FastingSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FastingSessionImplToJson(this);
  }
}

abstract class _FastingSession extends FastingSession {
  const factory _FastingSession({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final DietPresetType protocol,
    required final int startedAt,
    final int? endedAt,
    required final double targetHours,
    final bool isManualEnd,
    required final SyncMetadata syncMetadata,
  }) = _$FastingSessionImpl;
  const _FastingSession._() : super._();

  factory _FastingSession.fromJson(Map<String, dynamic> json) =
      _$FastingSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  DietPresetType get protocol; // if168, if186, if204, omad, etc.
  @override
  int get startedAt; // Epoch ms — when fast began
  @override
  int? get endedAt; // Epoch ms — null if fast is still active
  @override
  double get targetHours; // e.g. 16.0 for 16:8
  @override
  bool get isManualEnd; // true if user stopped early
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of FastingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FastingSessionImplCopyWith<_$FastingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
