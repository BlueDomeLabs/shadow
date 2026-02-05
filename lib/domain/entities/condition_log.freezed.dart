// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'condition_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConditionLog _$ConditionLogFromJson(Map<String, dynamic> json) {
  return _ConditionLog.fromJson(json);
}

/// @nodoc
mixin _$ConditionLog {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get conditionId => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError; // Epoch milliseconds
  int get severity => throw _privateConstructorUsedError; // 1-10 scale
  String? get notes => throw _privateConstructorUsedError;
  bool get isFlare => throw _privateConstructorUsedError;
  List<String> get flarePhotoIds =>
      throw _privateConstructorUsedError; // Comma-separated in DB
  String? get photoPath => throw _privateConstructorUsedError;
  String? get activityId => throw _privateConstructorUsedError;
  String? get triggers => throw _privateConstructorUsedError; // Comma-separated
  // File sync metadata
  String? get cloudStorageUrl => throw _privateConstructorUsedError;
  String? get fileHash => throw _privateConstructorUsedError;
  int? get fileSizeBytes => throw _privateConstructorUsedError;
  bool get isFileUploaded => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this ConditionLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConditionLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConditionLogCopyWith<ConditionLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConditionLogCopyWith<$Res> {
  factory $ConditionLogCopyWith(
    ConditionLog value,
    $Res Function(ConditionLog) then,
  ) = _$ConditionLogCopyWithImpl<$Res, ConditionLog>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String conditionId,
    int timestamp,
    int severity,
    String? notes,
    bool isFlare,
    List<String> flarePhotoIds,
    String? photoPath,
    String? activityId,
    String? triggers,
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    bool isFileUploaded,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$ConditionLogCopyWithImpl<$Res, $Val extends ConditionLog>
    implements $ConditionLogCopyWith<$Res> {
  _$ConditionLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConditionLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? conditionId = null,
    Object? timestamp = null,
    Object? severity = null,
    Object? notes = freezed,
    Object? isFlare = null,
    Object? flarePhotoIds = null,
    Object? photoPath = freezed,
    Object? activityId = freezed,
    Object? triggers = freezed,
    Object? cloudStorageUrl = freezed,
    Object? fileHash = freezed,
    Object? fileSizeBytes = freezed,
    Object? isFileUploaded = null,
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
            cloudStorageUrl: freezed == cloudStorageUrl
                ? _value.cloudStorageUrl
                : cloudStorageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileHash: freezed == fileHash
                ? _value.fileHash
                : fileHash // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileSizeBytes: freezed == fileSizeBytes
                ? _value.fileSizeBytes
                : fileSizeBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            isFileUploaded: null == isFileUploaded
                ? _value.isFileUploaded
                : isFileUploaded // ignore: cast_nullable_to_non_nullable
                      as bool,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of ConditionLog
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
abstract class _$$ConditionLogImplCopyWith<$Res>
    implements $ConditionLogCopyWith<$Res> {
  factory _$$ConditionLogImplCopyWith(
    _$ConditionLogImpl value,
    $Res Function(_$ConditionLogImpl) then,
  ) = __$$ConditionLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String conditionId,
    int timestamp,
    int severity,
    String? notes,
    bool isFlare,
    List<String> flarePhotoIds,
    String? photoPath,
    String? activityId,
    String? triggers,
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    bool isFileUploaded,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$ConditionLogImplCopyWithImpl<$Res>
    extends _$ConditionLogCopyWithImpl<$Res, _$ConditionLogImpl>
    implements _$$ConditionLogImplCopyWith<$Res> {
  __$$ConditionLogImplCopyWithImpl(
    _$ConditionLogImpl _value,
    $Res Function(_$ConditionLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConditionLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? conditionId = null,
    Object? timestamp = null,
    Object? severity = null,
    Object? notes = freezed,
    Object? isFlare = null,
    Object? flarePhotoIds = null,
    Object? photoPath = freezed,
    Object? activityId = freezed,
    Object? triggers = freezed,
    Object? cloudStorageUrl = freezed,
    Object? fileHash = freezed,
    Object? fileSizeBytes = freezed,
    Object? isFileUploaded = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$ConditionLogImpl(
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
        cloudStorageUrl: freezed == cloudStorageUrl
            ? _value.cloudStorageUrl
            : cloudStorageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileHash: freezed == fileHash
            ? _value.fileHash
            : fileHash // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileSizeBytes: freezed == fileSizeBytes
            ? _value.fileSizeBytes
            : fileSizeBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        isFileUploaded: null == isFileUploaded
            ? _value.isFileUploaded
            : isFileUploaded // ignore: cast_nullable_to_non_nullable
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
class _$ConditionLogImpl extends _ConditionLog {
  const _$ConditionLogImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.conditionId,
    required this.timestamp,
    required this.severity,
    this.notes,
    this.isFlare = false,
    final List<String> flarePhotoIds = const [],
    this.photoPath,
    this.activityId,
    this.triggers,
    this.cloudStorageUrl,
    this.fileHash,
    this.fileSizeBytes,
    this.isFileUploaded = false,
    required this.syncMetadata,
  }) : _flarePhotoIds = flarePhotoIds,
       super._();

  factory _$ConditionLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConditionLogImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final String conditionId;
  @override
  final int timestamp;
  // Epoch milliseconds
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

  // Comma-separated in DB
  @override
  final String? photoPath;
  @override
  final String? activityId;
  @override
  final String? triggers;
  // Comma-separated
  // File sync metadata
  @override
  final String? cloudStorageUrl;
  @override
  final String? fileHash;
  @override
  final int? fileSizeBytes;
  @override
  @JsonKey()
  final bool isFileUploaded;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'ConditionLog(id: $id, clientId: $clientId, profileId: $profileId, conditionId: $conditionId, timestamp: $timestamp, severity: $severity, notes: $notes, isFlare: $isFlare, flarePhotoIds: $flarePhotoIds, photoPath: $photoPath, activityId: $activityId, triggers: $triggers, cloudStorageUrl: $cloudStorageUrl, fileHash: $fileHash, fileSizeBytes: $fileSizeBytes, isFileUploaded: $isFileUploaded, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConditionLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
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
                other.triggers == triggers) &&
            (identical(other.cloudStorageUrl, cloudStorageUrl) ||
                other.cloudStorageUrl == cloudStorageUrl) &&
            (identical(other.fileHash, fileHash) ||
                other.fileHash == fileHash) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.isFileUploaded, isFileUploaded) ||
                other.isFileUploaded == isFileUploaded) &&
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
    conditionId,
    timestamp,
    severity,
    notes,
    isFlare,
    const DeepCollectionEquality().hash(_flarePhotoIds),
    photoPath,
    activityId,
    triggers,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    syncMetadata,
  );

  /// Create a copy of ConditionLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConditionLogImplCopyWith<_$ConditionLogImpl> get copyWith =>
      __$$ConditionLogImplCopyWithImpl<_$ConditionLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConditionLogImplToJson(this);
  }
}

abstract class _ConditionLog extends ConditionLog {
  const factory _ConditionLog({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final String conditionId,
    required final int timestamp,
    required final int severity,
    final String? notes,
    final bool isFlare,
    final List<String> flarePhotoIds,
    final String? photoPath,
    final String? activityId,
    final String? triggers,
    final String? cloudStorageUrl,
    final String? fileHash,
    final int? fileSizeBytes,
    final bool isFileUploaded,
    required final SyncMetadata syncMetadata,
  }) = _$ConditionLogImpl;
  const _ConditionLog._() : super._();

  factory _ConditionLog.fromJson(Map<String, dynamic> json) =
      _$ConditionLogImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  String get conditionId;
  @override
  int get timestamp; // Epoch milliseconds
  @override
  int get severity; // 1-10 scale
  @override
  String? get notes;
  @override
  bool get isFlare;
  @override
  List<String> get flarePhotoIds; // Comma-separated in DB
  @override
  String? get photoPath;
  @override
  String? get activityId;
  @override
  String? get triggers; // Comma-separated
  // File sync metadata
  @override
  String? get cloudStorageUrl;
  @override
  String? get fileHash;
  @override
  int? get fileSizeBytes;
  @override
  bool get isFileUploaded;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of ConditionLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConditionLogImplCopyWith<_$ConditionLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
