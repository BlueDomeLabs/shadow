// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SleepEntry _$SleepEntryFromJson(Map<String, dynamic> json) {
  return _SleepEntry.fromJson(json);
}

/// @nodoc
mixin _$SleepEntry {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  int get bedTime => throw _privateConstructorUsedError; // Epoch milliseconds
  int? get wakeTime => throw _privateConstructorUsedError; // Epoch milliseconds
  int get deepSleepMinutes => throw _privateConstructorUsedError;
  int get lightSleepMinutes => throw _privateConstructorUsedError;
  int get restlessSleepMinutes => throw _privateConstructorUsedError;
  DreamType get dreamType => throw _privateConstructorUsedError;
  WakingFeeling get wakingFeeling => throw _privateConstructorUsedError;
  String? get notes =>
      throw _privateConstructorUsedError; // Sleep quality fields
  String? get timeToFallAsleep => throw _privateConstructorUsedError;
  int? get timesAwakened => throw _privateConstructorUsedError;
  String? get timeAwakeDuringNight =>
      throw _privateConstructorUsedError; // Import tracking (for wearable data)
  String? get importSource => throw _privateConstructorUsedError;
  String? get importExternalId => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this SleepEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SleepEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SleepEntryCopyWith<SleepEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SleepEntryCopyWith<$Res> {
  factory $SleepEntryCopyWith(
    SleepEntry value,
    $Res Function(SleepEntry) then,
  ) = _$SleepEntryCopyWithImpl<$Res, SleepEntry>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    int bedTime,
    int? wakeTime,
    int deepSleepMinutes,
    int lightSleepMinutes,
    int restlessSleepMinutes,
    DreamType dreamType,
    WakingFeeling wakingFeeling,
    String? notes,
    String? timeToFallAsleep,
    int? timesAwakened,
    String? timeAwakeDuringNight,
    String? importSource,
    String? importExternalId,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$SleepEntryCopyWithImpl<$Res, $Val extends SleepEntry>
    implements $SleepEntryCopyWith<$Res> {
  _$SleepEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SleepEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? bedTime = null,
    Object? wakeTime = freezed,
    Object? deepSleepMinutes = null,
    Object? lightSleepMinutes = null,
    Object? restlessSleepMinutes = null,
    Object? dreamType = null,
    Object? wakingFeeling = null,
    Object? notes = freezed,
    Object? timeToFallAsleep = freezed,
    Object? timesAwakened = freezed,
    Object? timeAwakeDuringNight = freezed,
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
            bedTime: null == bedTime
                ? _value.bedTime
                : bedTime // ignore: cast_nullable_to_non_nullable
                      as int,
            wakeTime: freezed == wakeTime
                ? _value.wakeTime
                : wakeTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            deepSleepMinutes: null == deepSleepMinutes
                ? _value.deepSleepMinutes
                : deepSleepMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            lightSleepMinutes: null == lightSleepMinutes
                ? _value.lightSleepMinutes
                : lightSleepMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            restlessSleepMinutes: null == restlessSleepMinutes
                ? _value.restlessSleepMinutes
                : restlessSleepMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            dreamType: null == dreamType
                ? _value.dreamType
                : dreamType // ignore: cast_nullable_to_non_nullable
                      as DreamType,
            wakingFeeling: null == wakingFeeling
                ? _value.wakingFeeling
                : wakingFeeling // ignore: cast_nullable_to_non_nullable
                      as WakingFeeling,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            timeToFallAsleep: freezed == timeToFallAsleep
                ? _value.timeToFallAsleep
                : timeToFallAsleep // ignore: cast_nullable_to_non_nullable
                      as String?,
            timesAwakened: freezed == timesAwakened
                ? _value.timesAwakened
                : timesAwakened // ignore: cast_nullable_to_non_nullable
                      as int?,
            timeAwakeDuringNight: freezed == timeAwakeDuringNight
                ? _value.timeAwakeDuringNight
                : timeAwakeDuringNight // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of SleepEntry
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
abstract class _$$SleepEntryImplCopyWith<$Res>
    implements $SleepEntryCopyWith<$Res> {
  factory _$$SleepEntryImplCopyWith(
    _$SleepEntryImpl value,
    $Res Function(_$SleepEntryImpl) then,
  ) = __$$SleepEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    int bedTime,
    int? wakeTime,
    int deepSleepMinutes,
    int lightSleepMinutes,
    int restlessSleepMinutes,
    DreamType dreamType,
    WakingFeeling wakingFeeling,
    String? notes,
    String? timeToFallAsleep,
    int? timesAwakened,
    String? timeAwakeDuringNight,
    String? importSource,
    String? importExternalId,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$SleepEntryImplCopyWithImpl<$Res>
    extends _$SleepEntryCopyWithImpl<$Res, _$SleepEntryImpl>
    implements _$$SleepEntryImplCopyWith<$Res> {
  __$$SleepEntryImplCopyWithImpl(
    _$SleepEntryImpl _value,
    $Res Function(_$SleepEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SleepEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? bedTime = null,
    Object? wakeTime = freezed,
    Object? deepSleepMinutes = null,
    Object? lightSleepMinutes = null,
    Object? restlessSleepMinutes = null,
    Object? dreamType = null,
    Object? wakingFeeling = null,
    Object? notes = freezed,
    Object? timeToFallAsleep = freezed,
    Object? timesAwakened = freezed,
    Object? timeAwakeDuringNight = freezed,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$SleepEntryImpl(
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
        bedTime: null == bedTime
            ? _value.bedTime
            : bedTime // ignore: cast_nullable_to_non_nullable
                  as int,
        wakeTime: freezed == wakeTime
            ? _value.wakeTime
            : wakeTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        deepSleepMinutes: null == deepSleepMinutes
            ? _value.deepSleepMinutes
            : deepSleepMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        lightSleepMinutes: null == lightSleepMinutes
            ? _value.lightSleepMinutes
            : lightSleepMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        restlessSleepMinutes: null == restlessSleepMinutes
            ? _value.restlessSleepMinutes
            : restlessSleepMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        dreamType: null == dreamType
            ? _value.dreamType
            : dreamType // ignore: cast_nullable_to_non_nullable
                  as DreamType,
        wakingFeeling: null == wakingFeeling
            ? _value.wakingFeeling
            : wakingFeeling // ignore: cast_nullable_to_non_nullable
                  as WakingFeeling,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        timeToFallAsleep: freezed == timeToFallAsleep
            ? _value.timeToFallAsleep
            : timeToFallAsleep // ignore: cast_nullable_to_non_nullable
                  as String?,
        timesAwakened: freezed == timesAwakened
            ? _value.timesAwakened
            : timesAwakened // ignore: cast_nullable_to_non_nullable
                  as int?,
        timeAwakeDuringNight: freezed == timeAwakeDuringNight
            ? _value.timeAwakeDuringNight
            : timeAwakeDuringNight // ignore: cast_nullable_to_non_nullable
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
class _$SleepEntryImpl extends _SleepEntry {
  const _$SleepEntryImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.bedTime,
    this.wakeTime,
    this.deepSleepMinutes = 0,
    this.lightSleepMinutes = 0,
    this.restlessSleepMinutes = 0,
    this.dreamType = DreamType.noDreams,
    this.wakingFeeling = WakingFeeling.neutral,
    this.notes,
    this.timeToFallAsleep,
    this.timesAwakened,
    this.timeAwakeDuringNight,
    this.importSource,
    this.importExternalId,
    required this.syncMetadata,
  }) : super._();

  factory _$SleepEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SleepEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final int bedTime;
  // Epoch milliseconds
  @override
  final int? wakeTime;
  // Epoch milliseconds
  @override
  @JsonKey()
  final int deepSleepMinutes;
  @override
  @JsonKey()
  final int lightSleepMinutes;
  @override
  @JsonKey()
  final int restlessSleepMinutes;
  @override
  @JsonKey()
  final DreamType dreamType;
  @override
  @JsonKey()
  final WakingFeeling wakingFeeling;
  @override
  final String? notes;
  // Sleep quality fields
  @override
  final String? timeToFallAsleep;
  @override
  final int? timesAwakened;
  @override
  final String? timeAwakeDuringNight;
  // Import tracking (for wearable data)
  @override
  final String? importSource;
  @override
  final String? importExternalId;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'SleepEntry(id: $id, clientId: $clientId, profileId: $profileId, bedTime: $bedTime, wakeTime: $wakeTime, deepSleepMinutes: $deepSleepMinutes, lightSleepMinutes: $lightSleepMinutes, restlessSleepMinutes: $restlessSleepMinutes, dreamType: $dreamType, wakingFeeling: $wakingFeeling, notes: $notes, timeToFallAsleep: $timeToFallAsleep, timesAwakened: $timesAwakened, timeAwakeDuringNight: $timeAwakeDuringNight, importSource: $importSource, importExternalId: $importExternalId, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.bedTime, bedTime) || other.bedTime == bedTime) &&
            (identical(other.wakeTime, wakeTime) ||
                other.wakeTime == wakeTime) &&
            (identical(other.deepSleepMinutes, deepSleepMinutes) ||
                other.deepSleepMinutes == deepSleepMinutes) &&
            (identical(other.lightSleepMinutes, lightSleepMinutes) ||
                other.lightSleepMinutes == lightSleepMinutes) &&
            (identical(other.restlessSleepMinutes, restlessSleepMinutes) ||
                other.restlessSleepMinutes == restlessSleepMinutes) &&
            (identical(other.dreamType, dreamType) ||
                other.dreamType == dreamType) &&
            (identical(other.wakingFeeling, wakingFeeling) ||
                other.wakingFeeling == wakingFeeling) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.timeToFallAsleep, timeToFallAsleep) ||
                other.timeToFallAsleep == timeToFallAsleep) &&
            (identical(other.timesAwakened, timesAwakened) ||
                other.timesAwakened == timesAwakened) &&
            (identical(other.timeAwakeDuringNight, timeAwakeDuringNight) ||
                other.timeAwakeDuringNight == timeAwakeDuringNight) &&
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
    bedTime,
    wakeTime,
    deepSleepMinutes,
    lightSleepMinutes,
    restlessSleepMinutes,
    dreamType,
    wakingFeeling,
    notes,
    timeToFallAsleep,
    timesAwakened,
    timeAwakeDuringNight,
    importSource,
    importExternalId,
    syncMetadata,
  );

  /// Create a copy of SleepEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepEntryImplCopyWith<_$SleepEntryImpl> get copyWith =>
      __$$SleepEntryImplCopyWithImpl<_$SleepEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SleepEntryImplToJson(this);
  }
}

abstract class _SleepEntry extends SleepEntry {
  const factory _SleepEntry({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final int bedTime,
    final int? wakeTime,
    final int deepSleepMinutes,
    final int lightSleepMinutes,
    final int restlessSleepMinutes,
    final DreamType dreamType,
    final WakingFeeling wakingFeeling,
    final String? notes,
    final String? timeToFallAsleep,
    final int? timesAwakened,
    final String? timeAwakeDuringNight,
    final String? importSource,
    final String? importExternalId,
    required final SyncMetadata syncMetadata,
  }) = _$SleepEntryImpl;
  const _SleepEntry._() : super._();

  factory _SleepEntry.fromJson(Map<String, dynamic> json) =
      _$SleepEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  int get bedTime; // Epoch milliseconds
  @override
  int? get wakeTime; // Epoch milliseconds
  @override
  int get deepSleepMinutes;
  @override
  int get lightSleepMinutes;
  @override
  int get restlessSleepMinutes;
  @override
  DreamType get dreamType;
  @override
  WakingFeeling get wakingFeeling;
  @override
  String? get notes; // Sleep quality fields
  @override
  String? get timeToFallAsleep;
  @override
  int? get timesAwakened;
  @override
  String? get timeAwakeDuringNight; // Import tracking (for wearable data)
  @override
  String? get importSource;
  @override
  String? get importExternalId;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of SleepEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SleepEntryImplCopyWith<_$SleepEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
