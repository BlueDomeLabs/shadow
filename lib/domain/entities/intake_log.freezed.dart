// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intake_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

IntakeLog _$IntakeLogFromJson(Map<String, dynamic> json) {
  return _IntakeLog.fromJson(json);
}

/// @nodoc
mixin _$IntakeLog {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get supplementId => throw _privateConstructorUsedError;
  int get scheduledTime =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  int? get actualTime =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  IntakeLogStatus get status => throw _privateConstructorUsedError;
  String? get reason =>
      throw _privateConstructorUsedError; // Why skipped/missed
  String? get note => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this IntakeLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IntakeLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IntakeLogCopyWith<IntakeLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntakeLogCopyWith<$Res> {
  factory $IntakeLogCopyWith(IntakeLog value, $Res Function(IntakeLog) then) =
      _$IntakeLogCopyWithImpl<$Res, IntakeLog>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String supplementId,
    int scheduledTime,
    int? actualTime,
    IntakeLogStatus status,
    String? reason,
    String? note,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$IntakeLogCopyWithImpl<$Res, $Val extends IntakeLog>
    implements $IntakeLogCopyWith<$Res> {
  _$IntakeLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IntakeLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? supplementId = null,
    Object? scheduledTime = null,
    Object? actualTime = freezed,
    Object? status = null,
    Object? reason = freezed,
    Object? note = freezed,
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
            supplementId: null == supplementId
                ? _value.supplementId
                : supplementId // ignore: cast_nullable_to_non_nullable
                      as String,
            scheduledTime: null == scheduledTime
                ? _value.scheduledTime
                : scheduledTime // ignore: cast_nullable_to_non_nullable
                      as int,
            actualTime: freezed == actualTime
                ? _value.actualTime
                : actualTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as IntakeLogStatus,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of IntakeLog
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
abstract class _$$IntakeLogImplCopyWith<$Res>
    implements $IntakeLogCopyWith<$Res> {
  factory _$$IntakeLogImplCopyWith(
    _$IntakeLogImpl value,
    $Res Function(_$IntakeLogImpl) then,
  ) = __$$IntakeLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String supplementId,
    int scheduledTime,
    int? actualTime,
    IntakeLogStatus status,
    String? reason,
    String? note,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$IntakeLogImplCopyWithImpl<$Res>
    extends _$IntakeLogCopyWithImpl<$Res, _$IntakeLogImpl>
    implements _$$IntakeLogImplCopyWith<$Res> {
  __$$IntakeLogImplCopyWithImpl(
    _$IntakeLogImpl _value,
    $Res Function(_$IntakeLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IntakeLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? supplementId = null,
    Object? scheduledTime = null,
    Object? actualTime = freezed,
    Object? status = null,
    Object? reason = freezed,
    Object? note = freezed,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$IntakeLogImpl(
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
        supplementId: null == supplementId
            ? _value.supplementId
            : supplementId // ignore: cast_nullable_to_non_nullable
                  as String,
        scheduledTime: null == scheduledTime
            ? _value.scheduledTime
            : scheduledTime // ignore: cast_nullable_to_non_nullable
                  as int,
        actualTime: freezed == actualTime
            ? _value.actualTime
            : actualTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as IntakeLogStatus,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$IntakeLogImpl extends _IntakeLog {
  const _$IntakeLogImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.supplementId,
    required this.scheduledTime,
    this.actualTime,
    this.status = IntakeLogStatus.pending,
    this.reason,
    this.note,
    required this.syncMetadata,
  }) : super._();

  factory _$IntakeLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntakeLogImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final String supplementId;
  @override
  final int scheduledTime;
  // Epoch milliseconds
  @override
  final int? actualTime;
  // Epoch milliseconds
  @override
  @JsonKey()
  final IntakeLogStatus status;
  @override
  final String? reason;
  // Why skipped/missed
  @override
  final String? note;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'IntakeLog(id: $id, clientId: $clientId, profileId: $profileId, supplementId: $supplementId, scheduledTime: $scheduledTime, actualTime: $actualTime, status: $status, reason: $reason, note: $note, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntakeLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.supplementId, supplementId) ||
                other.supplementId == supplementId) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.actualTime, actualTime) ||
                other.actualTime == actualTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.note, note) || other.note == note) &&
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
    supplementId,
    scheduledTime,
    actualTime,
    status,
    reason,
    note,
    syncMetadata,
  );

  /// Create a copy of IntakeLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IntakeLogImplCopyWith<_$IntakeLogImpl> get copyWith =>
      __$$IntakeLogImplCopyWithImpl<_$IntakeLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IntakeLogImplToJson(this);
  }
}

abstract class _IntakeLog extends IntakeLog {
  const factory _IntakeLog({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final String supplementId,
    required final int scheduledTime,
    final int? actualTime,
    final IntakeLogStatus status,
    final String? reason,
    final String? note,
    required final SyncMetadata syncMetadata,
  }) = _$IntakeLogImpl;
  const _IntakeLog._() : super._();

  factory _IntakeLog.fromJson(Map<String, dynamic> json) =
      _$IntakeLogImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  String get supplementId;
  @override
  int get scheduledTime; // Epoch milliseconds
  @override
  int? get actualTime; // Epoch milliseconds
  @override
  IntakeLogStatus get status;
  @override
  String? get reason; // Why skipped/missed
  @override
  String? get note;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of IntakeLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IntakeLogImplCopyWith<_$IntakeLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
