// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityLog _$ActivityLogFromJson(Map<String, dynamic> json) {
  return _ActivityLog.fromJson(json);
}

/// @nodoc
mixin _$ActivityLog {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError; // Epoch milliseconds
  List<String> get activityIds =>
      throw _privateConstructorUsedError; // References to Activity entities
  List<String> get adHocActivities =>
      throw _privateConstructorUsedError; // Free-form activity names
  int? get duration =>
      throw _privateConstructorUsedError; // Actual duration if different from planned
  String? get notes =>
      throw _privateConstructorUsedError; // Import tracking (for wearable data - HealthKit/Google Fit)
  String? get importSource =>
      throw _privateConstructorUsedError; // 'healthkit', 'googlefit', etc.
  String? get importExternalId =>
      throw _privateConstructorUsedError; // External record ID for deduplication
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this ActivityLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogCopyWith<ActivityLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogCopyWith<$Res> {
  factory $ActivityLogCopyWith(
    ActivityLog value,
    $Res Function(ActivityLog) then,
  ) = _$ActivityLogCopyWithImpl<$Res, ActivityLog>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    int timestamp,
    List<String> activityIds,
    List<String> adHocActivities,
    int? duration,
    String? notes,
    String? importSource,
    String? importExternalId,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$ActivityLogCopyWithImpl<$Res, $Val extends ActivityLog>
    implements $ActivityLogCopyWith<$Res> {
  _$ActivityLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? timestamp = null,
    Object? activityIds = null,
    Object? adHocActivities = null,
    Object? duration = freezed,
    Object? notes = freezed,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
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
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            importSource: freezed == importSource
                ? _value.importSource
                : importSource // ignore: cast_nullable_to_non_nullable
                      as String?,
            importExternalId: freezed == importExternalId
                ? _value.importExternalId
                : importExternalId // ignore: cast_nullable_to_non_nullable
                      as String?,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of ActivityLog
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
abstract class _$$ActivityLogImplCopyWith<$Res>
    implements $ActivityLogCopyWith<$Res> {
  factory _$$ActivityLogImplCopyWith(
    _$ActivityLogImpl value,
    $Res Function(_$ActivityLogImpl) then,
  ) = __$$ActivityLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    int timestamp,
    List<String> activityIds,
    List<String> adHocActivities,
    int? duration,
    String? notes,
    String? importSource,
    String? importExternalId,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$ActivityLogImplCopyWithImpl<$Res>
    extends _$ActivityLogCopyWithImpl<$Res, _$ActivityLogImpl>
    implements _$$ActivityLogImplCopyWith<$Res> {
  __$$ActivityLogImplCopyWithImpl(
    _$ActivityLogImpl _value,
    $Res Function(_$ActivityLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? timestamp = null,
    Object? activityIds = null,
    Object? adHocActivities = null,
    Object? duration = freezed,
    Object? notes = freezed,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$ActivityLogImpl(
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
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        importSource: freezed == importSource
            ? _value.importSource
            : importSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        importExternalId: freezed == importExternalId
            ? _value.importExternalId
            : importExternalId // ignore: cast_nullable_to_non_nullable
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
class _$ActivityLogImpl extends _ActivityLog {
  const _$ActivityLogImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.timestamp,
    final List<String> activityIds = const [],
    final List<String> adHocActivities = const [],
    this.duration,
    this.notes,
    this.importSource,
    this.importExternalId,
    required this.syncMetadata,
  }) : _activityIds = activityIds,
       _adHocActivities = adHocActivities,
       super._();

  factory _$ActivityLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
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

  // References to Activity entities
  final List<String> _adHocActivities;
  // References to Activity entities
  @override
  @JsonKey()
  List<String> get adHocActivities {
    if (_adHocActivities is EqualUnmodifiableListView) return _adHocActivities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adHocActivities);
  }

  // Free-form activity names
  @override
  final int? duration;
  // Actual duration if different from planned
  @override
  final String? notes;
  // Import tracking (for wearable data - HealthKit/Google Fit)
  @override
  final String? importSource;
  // 'healthkit', 'googlefit', etc.
  @override
  final String? importExternalId;
  // External record ID for deduplication
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'ActivityLog(id: $id, clientId: $clientId, profileId: $profileId, timestamp: $timestamp, activityIds: $activityIds, adHocActivities: $adHocActivities, duration: $duration, notes: $notes, importSource: $importSource, importExternalId: $importExternalId, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
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
                other.importExternalId == importExternalId) &&
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
    timestamp,
    const DeepCollectionEquality().hash(_activityIds),
    const DeepCollectionEquality().hash(_adHocActivities),
    duration,
    notes,
    importSource,
    importExternalId,
    syncMetadata,
  );

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogImplCopyWith<_$ActivityLogImpl> get copyWith =>
      __$$ActivityLogImplCopyWithImpl<_$ActivityLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogImplToJson(this);
  }
}

abstract class _ActivityLog extends ActivityLog {
  const factory _ActivityLog({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final int timestamp,
    final List<String> activityIds,
    final List<String> adHocActivities,
    final int? duration,
    final String? notes,
    final String? importSource,
    final String? importExternalId,
    required final SyncMetadata syncMetadata,
  }) = _$ActivityLogImpl;
  const _ActivityLog._() : super._();

  factory _ActivityLog.fromJson(Map<String, dynamic> json) =
      _$ActivityLogImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  int get timestamp; // Epoch milliseconds
  @override
  List<String> get activityIds; // References to Activity entities
  @override
  List<String> get adHocActivities; // Free-form activity names
  @override
  int? get duration; // Actual duration if different from planned
  @override
  String? get notes; // Import tracking (for wearable data - HealthKit/Google Fit)
  @override
  String? get importSource; // 'healthkit', 'googlefit', etc.
  @override
  String? get importExternalId; // External record ID for deduplication
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogImplCopyWith<_$ActivityLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
