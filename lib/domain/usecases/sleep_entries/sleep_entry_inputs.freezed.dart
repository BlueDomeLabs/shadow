// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_entry_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LogSleepEntryInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  int get bedTime => throw _privateConstructorUsedError; // Epoch milliseconds
  // Wake time is optional (user may log bed time first, wake time later)
  int? get wakeTime => throw _privateConstructorUsedError; // Epoch milliseconds
  // Sleep stages (optional, may come from wearable import)
  int get deepSleepMinutes => throw _privateConstructorUsedError;
  int get lightSleepMinutes => throw _privateConstructorUsedError;
  int get restlessSleepMinutes =>
      throw _privateConstructorUsedError; // Dream and feeling
  DreamType get dreamType => throw _privateConstructorUsedError;
  WakingFeeling get wakingFeeling =>
      throw _privateConstructorUsedError; // Notes
  String get notes =>
      throw _privateConstructorUsedError; // Import tracking (for wearable data)
  String? get importSource =>
      throw _privateConstructorUsedError; // 'healthkit', 'googlefit', 'apple_watch', etc.
  String? get importExternalId => throw _privateConstructorUsedError;

  /// Create a copy of LogSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogSleepEntryInputCopyWith<LogSleepEntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogSleepEntryInputCopyWith<$Res> {
  factory $LogSleepEntryInputCopyWith(
    LogSleepEntryInput value,
    $Res Function(LogSleepEntryInput) then,
  ) = _$LogSleepEntryInputCopyWithImpl<$Res, LogSleepEntryInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    int bedTime,
    int? wakeTime,
    int deepSleepMinutes,
    int lightSleepMinutes,
    int restlessSleepMinutes,
    DreamType dreamType,
    WakingFeeling wakingFeeling,
    String notes,
    String? importSource,
    String? importExternalId,
  });
}

/// @nodoc
class _$LogSleepEntryInputCopyWithImpl<$Res, $Val extends LogSleepEntryInput>
    implements $LogSleepEntryInputCopyWith<$Res> {
  _$LogSleepEntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? bedTime = null,
    Object? wakeTime = freezed,
    Object? deepSleepMinutes = null,
    Object? lightSleepMinutes = null,
    Object? restlessSleepMinutes = null,
    Object? dreamType = null,
    Object? wakingFeeling = null,
    Object? notes = null,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
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
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            importSource: freezed == importSource
                ? _value.importSource
                : importSource // ignore: cast_nullable_to_non_nullable
                      as String?,
            importExternalId: freezed == importExternalId
                ? _value.importExternalId
                : importExternalId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogSleepEntryInputImplCopyWith<$Res>
    implements $LogSleepEntryInputCopyWith<$Res> {
  factory _$$LogSleepEntryInputImplCopyWith(
    _$LogSleepEntryInputImpl value,
    $Res Function(_$LogSleepEntryInputImpl) then,
  ) = __$$LogSleepEntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    int bedTime,
    int? wakeTime,
    int deepSleepMinutes,
    int lightSleepMinutes,
    int restlessSleepMinutes,
    DreamType dreamType,
    WakingFeeling wakingFeeling,
    String notes,
    String? importSource,
    String? importExternalId,
  });
}

/// @nodoc
class __$$LogSleepEntryInputImplCopyWithImpl<$Res>
    extends _$LogSleepEntryInputCopyWithImpl<$Res, _$LogSleepEntryInputImpl>
    implements _$$LogSleepEntryInputImplCopyWith<$Res> {
  __$$LogSleepEntryInputImplCopyWithImpl(
    _$LogSleepEntryInputImpl _value,
    $Res Function(_$LogSleepEntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? bedTime = null,
    Object? wakeTime = freezed,
    Object? deepSleepMinutes = null,
    Object? lightSleepMinutes = null,
    Object? restlessSleepMinutes = null,
    Object? dreamType = null,
    Object? wakingFeeling = null,
    Object? notes = null,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
  }) {
    return _then(
      _$LogSleepEntryInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
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
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        importSource: freezed == importSource
            ? _value.importSource
            : importSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        importExternalId: freezed == importExternalId
            ? _value.importExternalId
            : importExternalId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$LogSleepEntryInputImpl implements _LogSleepEntryInput {
  const _$LogSleepEntryInputImpl({
    required this.profileId,
    required this.clientId,
    required this.bedTime,
    this.wakeTime,
    this.deepSleepMinutes = 0,
    this.lightSleepMinutes = 0,
    this.restlessSleepMinutes = 0,
    this.dreamType = DreamType.noDreams,
    this.wakingFeeling = WakingFeeling.neutral,
    this.notes = '',
    this.importSource,
    this.importExternalId,
  });

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final int bedTime;
  // Epoch milliseconds
  // Wake time is optional (user may log bed time first, wake time later)
  @override
  final int? wakeTime;
  // Epoch milliseconds
  // Sleep stages (optional, may come from wearable import)
  @override
  @JsonKey()
  final int deepSleepMinutes;
  @override
  @JsonKey()
  final int lightSleepMinutes;
  @override
  @JsonKey()
  final int restlessSleepMinutes;
  // Dream and feeling
  @override
  @JsonKey()
  final DreamType dreamType;
  @override
  @JsonKey()
  final WakingFeeling wakingFeeling;
  // Notes
  @override
  @JsonKey()
  final String notes;
  // Import tracking (for wearable data)
  @override
  final String? importSource;
  // 'healthkit', 'googlefit', 'apple_watch', etc.
  @override
  final String? importExternalId;

  @override
  String toString() {
    return 'LogSleepEntryInput(profileId: $profileId, clientId: $clientId, bedTime: $bedTime, wakeTime: $wakeTime, deepSleepMinutes: $deepSleepMinutes, lightSleepMinutes: $lightSleepMinutes, restlessSleepMinutes: $restlessSleepMinutes, dreamType: $dreamType, wakingFeeling: $wakingFeeling, notes: $notes, importSource: $importSource, importExternalId: $importExternalId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogSleepEntryInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
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
            (identical(other.importSource, importSource) ||
                other.importSource == importSource) &&
            (identical(other.importExternalId, importExternalId) ||
                other.importExternalId == importExternalId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    bedTime,
    wakeTime,
    deepSleepMinutes,
    lightSleepMinutes,
    restlessSleepMinutes,
    dreamType,
    wakingFeeling,
    notes,
    importSource,
    importExternalId,
  );

  /// Create a copy of LogSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogSleepEntryInputImplCopyWith<_$LogSleepEntryInputImpl> get copyWith =>
      __$$LogSleepEntryInputImplCopyWithImpl<_$LogSleepEntryInputImpl>(
        this,
        _$identity,
      );
}

abstract class _LogSleepEntryInput implements LogSleepEntryInput {
  const factory _LogSleepEntryInput({
    required final String profileId,
    required final String clientId,
    required final int bedTime,
    final int? wakeTime,
    final int deepSleepMinutes,
    final int lightSleepMinutes,
    final int restlessSleepMinutes,
    final DreamType dreamType,
    final WakingFeeling wakingFeeling,
    final String notes,
    final String? importSource,
    final String? importExternalId,
  }) = _$LogSleepEntryInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  int get bedTime; // Epoch milliseconds
  // Wake time is optional (user may log bed time first, wake time later)
  @override
  int? get wakeTime; // Epoch milliseconds
  // Sleep stages (optional, may come from wearable import)
  @override
  int get deepSleepMinutes;
  @override
  int get lightSleepMinutes;
  @override
  int get restlessSleepMinutes; // Dream and feeling
  @override
  DreamType get dreamType;
  @override
  WakingFeeling get wakingFeeling; // Notes
  @override
  String get notes; // Import tracking (for wearable data)
  @override
  String? get importSource; // 'healthkit', 'googlefit', 'apple_watch', etc.
  @override
  String? get importExternalId;

  /// Create a copy of LogSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogSleepEntryInputImplCopyWith<_$LogSleepEntryInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetSleepEntriesInput {
  String get profileId => throw _privateConstructorUsedError;
  int? get startDate =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  int? get endDate => throw _privateConstructorUsedError; // Epoch milliseconds
  int? get limit => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;

  /// Create a copy of GetSleepEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetSleepEntriesInputCopyWith<GetSleepEntriesInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetSleepEntriesInputCopyWith<$Res> {
  factory $GetSleepEntriesInputCopyWith(
    GetSleepEntriesInput value,
    $Res Function(GetSleepEntriesInput) then,
  ) = _$GetSleepEntriesInputCopyWithImpl<$Res, GetSleepEntriesInput>;
  @useResult
  $Res call({
    String profileId,
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class _$GetSleepEntriesInputCopyWithImpl<
  $Res,
  $Val extends GetSleepEntriesInput
>
    implements $GetSleepEntriesInputCopyWith<$Res> {
  _$GetSleepEntriesInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetSleepEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
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
abstract class _$$GetSleepEntriesInputImplCopyWith<$Res>
    implements $GetSleepEntriesInputCopyWith<$Res> {
  factory _$$GetSleepEntriesInputImplCopyWith(
    _$GetSleepEntriesInputImpl value,
    $Res Function(_$GetSleepEntriesInputImpl) then,
  ) = __$$GetSleepEntriesInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class __$$GetSleepEntriesInputImplCopyWithImpl<$Res>
    extends _$GetSleepEntriesInputCopyWithImpl<$Res, _$GetSleepEntriesInputImpl>
    implements _$$GetSleepEntriesInputImplCopyWith<$Res> {
  __$$GetSleepEntriesInputImplCopyWithImpl(
    _$GetSleepEntriesInputImpl _value,
    $Res Function(_$GetSleepEntriesInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetSleepEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _$GetSleepEntriesInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
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

class _$GetSleepEntriesInputImpl implements _GetSleepEntriesInput {
  const _$GetSleepEntriesInputImpl({
    required this.profileId,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });

  @override
  final String profileId;
  @override
  final int? startDate;
  // Epoch milliseconds
  @override
  final int? endDate;
  // Epoch milliseconds
  @override
  final int? limit;
  @override
  final int? offset;

  @override
  String toString() {
    return 'GetSleepEntriesInput(profileId: $profileId, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetSleepEntriesInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, startDate, endDate, limit, offset);

  /// Create a copy of GetSleepEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetSleepEntriesInputImplCopyWith<_$GetSleepEntriesInputImpl>
  get copyWith =>
      __$$GetSleepEntriesInputImplCopyWithImpl<_$GetSleepEntriesInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetSleepEntriesInput implements GetSleepEntriesInput {
  const factory _GetSleepEntriesInput({
    required final String profileId,
    final int? startDate,
    final int? endDate,
    final int? limit,
    final int? offset,
  }) = _$GetSleepEntriesInputImpl;

  @override
  String get profileId;
  @override
  int? get startDate; // Epoch milliseconds
  @override
  int? get endDate; // Epoch milliseconds
  @override
  int? get limit;
  @override
  int? get offset;

  /// Create a copy of GetSleepEntriesInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetSleepEntriesInputImplCopyWith<_$GetSleepEntriesInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetSleepEntryForNightInput {
  String get profileId => throw _privateConstructorUsedError;
  int get date => throw _privateConstructorUsedError;

  /// Create a copy of GetSleepEntryForNightInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetSleepEntryForNightInputCopyWith<GetSleepEntryForNightInput>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetSleepEntryForNightInputCopyWith<$Res> {
  factory $GetSleepEntryForNightInputCopyWith(
    GetSleepEntryForNightInput value,
    $Res Function(GetSleepEntryForNightInput) then,
  ) =
      _$GetSleepEntryForNightInputCopyWithImpl<
        $Res,
        GetSleepEntryForNightInput
      >;
  @useResult
  $Res call({String profileId, int date});
}

/// @nodoc
class _$GetSleepEntryForNightInputCopyWithImpl<
  $Res,
  $Val extends GetSleepEntryForNightInput
>
    implements $GetSleepEntryForNightInputCopyWith<$Res> {
  _$GetSleepEntryForNightInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetSleepEntryForNightInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? date = null}) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetSleepEntryForNightInputImplCopyWith<$Res>
    implements $GetSleepEntryForNightInputCopyWith<$Res> {
  factory _$$GetSleepEntryForNightInputImplCopyWith(
    _$GetSleepEntryForNightInputImpl value,
    $Res Function(_$GetSleepEntryForNightInputImpl) then,
  ) = __$$GetSleepEntryForNightInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, int date});
}

/// @nodoc
class __$$GetSleepEntryForNightInputImplCopyWithImpl<$Res>
    extends
        _$GetSleepEntryForNightInputCopyWithImpl<
          $Res,
          _$GetSleepEntryForNightInputImpl
        >
    implements _$$GetSleepEntryForNightInputImplCopyWith<$Res> {
  __$$GetSleepEntryForNightInputImplCopyWithImpl(
    _$GetSleepEntryForNightInputImpl _value,
    $Res Function(_$GetSleepEntryForNightInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetSleepEntryForNightInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? date = null}) {
    return _then(
      _$GetSleepEntryForNightInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$GetSleepEntryForNightInputImpl implements _GetSleepEntryForNightInput {
  const _$GetSleepEntryForNightInputImpl({
    required this.profileId,
    required this.date,
  });

  @override
  final String profileId;
  @override
  final int date;

  @override
  String toString() {
    return 'GetSleepEntryForNightInput(profileId: $profileId, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetSleepEntryForNightInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, date);

  /// Create a copy of GetSleepEntryForNightInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetSleepEntryForNightInputImplCopyWith<_$GetSleepEntryForNightInputImpl>
  get copyWith =>
      __$$GetSleepEntryForNightInputImplCopyWithImpl<
        _$GetSleepEntryForNightInputImpl
      >(this, _$identity);
}

abstract class _GetSleepEntryForNightInput
    implements GetSleepEntryForNightInput {
  const factory _GetSleepEntryForNightInput({
    required final String profileId,
    required final int date,
  }) = _$GetSleepEntryForNightInputImpl;

  @override
  String get profileId;
  @override
  int get date;

  /// Create a copy of GetSleepEntryForNightInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetSleepEntryForNightInputImplCopyWith<_$GetSleepEntryForNightInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetSleepAveragesInput {
  String get profileId => throw _privateConstructorUsedError;
  int get startDate => throw _privateConstructorUsedError; // Epoch milliseconds
  int get endDate => throw _privateConstructorUsedError;

  /// Create a copy of GetSleepAveragesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetSleepAveragesInputCopyWith<GetSleepAveragesInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetSleepAveragesInputCopyWith<$Res> {
  factory $GetSleepAveragesInputCopyWith(
    GetSleepAveragesInput value,
    $Res Function(GetSleepAveragesInput) then,
  ) = _$GetSleepAveragesInputCopyWithImpl<$Res, GetSleepAveragesInput>;
  @useResult
  $Res call({String profileId, int startDate, int endDate});
}

/// @nodoc
class _$GetSleepAveragesInputCopyWithImpl<
  $Res,
  $Val extends GetSleepAveragesInput
>
    implements $GetSleepAveragesInputCopyWith<$Res> {
  _$GetSleepAveragesInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetSleepAveragesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$GetSleepAveragesInputImplCopyWith<$Res>
    implements $GetSleepAveragesInputCopyWith<$Res> {
  factory _$$GetSleepAveragesInputImplCopyWith(
    _$GetSleepAveragesInputImpl value,
    $Res Function(_$GetSleepAveragesInputImpl) then,
  ) = __$$GetSleepAveragesInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, int startDate, int endDate});
}

/// @nodoc
class __$$GetSleepAveragesInputImplCopyWithImpl<$Res>
    extends
        _$GetSleepAveragesInputCopyWithImpl<$Res, _$GetSleepAveragesInputImpl>
    implements _$$GetSleepAveragesInputImplCopyWith<$Res> {
  __$$GetSleepAveragesInputImplCopyWithImpl(
    _$GetSleepAveragesInputImpl _value,
    $Res Function(_$GetSleepAveragesInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetSleepAveragesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _$GetSleepAveragesInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$GetSleepAveragesInputImpl implements _GetSleepAveragesInput {
  const _$GetSleepAveragesInputImpl({
    required this.profileId,
    required this.startDate,
    required this.endDate,
  });

  @override
  final String profileId;
  @override
  final int startDate;
  // Epoch milliseconds
  @override
  final int endDate;

  @override
  String toString() {
    return 'GetSleepAveragesInput(profileId: $profileId, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetSleepAveragesInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, startDate, endDate);

  /// Create a copy of GetSleepAveragesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetSleepAveragesInputImplCopyWith<_$GetSleepAveragesInputImpl>
  get copyWith =>
      __$$GetSleepAveragesInputImplCopyWithImpl<_$GetSleepAveragesInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetSleepAveragesInput implements GetSleepAveragesInput {
  const factory _GetSleepAveragesInput({
    required final String profileId,
    required final int startDate,
    required final int endDate,
  }) = _$GetSleepAveragesInputImpl;

  @override
  String get profileId;
  @override
  int get startDate; // Epoch milliseconds
  @override
  int get endDate;

  /// Create a copy of GetSleepAveragesInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetSleepAveragesInputImplCopyWith<_$GetSleepAveragesInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateSleepEntryInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId =>
      throw _privateConstructorUsedError; // All fields optional for partial update
  int? get bedTime => throw _privateConstructorUsedError; // Epoch milliseconds
  int? get wakeTime => throw _privateConstructorUsedError; // Epoch milliseconds
  int? get deepSleepMinutes => throw _privateConstructorUsedError;
  int? get lightSleepMinutes => throw _privateConstructorUsedError;
  int? get restlessSleepMinutes => throw _privateConstructorUsedError;
  DreamType? get dreamType => throw _privateConstructorUsedError;
  WakingFeeling? get wakingFeeling => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get importSource => throw _privateConstructorUsedError;
  String? get importExternalId => throw _privateConstructorUsedError;

  /// Create a copy of UpdateSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateSleepEntryInputCopyWith<UpdateSleepEntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateSleepEntryInputCopyWith<$Res> {
  factory $UpdateSleepEntryInputCopyWith(
    UpdateSleepEntryInput value,
    $Res Function(UpdateSleepEntryInput) then,
  ) = _$UpdateSleepEntryInputCopyWithImpl<$Res, UpdateSleepEntryInput>;
  @useResult
  $Res call({
    String id,
    String profileId,
    int? bedTime,
    int? wakeTime,
    int? deepSleepMinutes,
    int? lightSleepMinutes,
    int? restlessSleepMinutes,
    DreamType? dreamType,
    WakingFeeling? wakingFeeling,
    String? notes,
    String? importSource,
    String? importExternalId,
  });
}

/// @nodoc
class _$UpdateSleepEntryInputCopyWithImpl<
  $Res,
  $Val extends UpdateSleepEntryInput
>
    implements $UpdateSleepEntryInputCopyWith<$Res> {
  _$UpdateSleepEntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? bedTime = freezed,
    Object? wakeTime = freezed,
    Object? deepSleepMinutes = freezed,
    Object? lightSleepMinutes = freezed,
    Object? restlessSleepMinutes = freezed,
    Object? dreamType = freezed,
    Object? wakingFeeling = freezed,
    Object? notes = freezed,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
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
            bedTime: freezed == bedTime
                ? _value.bedTime
                : bedTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            wakeTime: freezed == wakeTime
                ? _value.wakeTime
                : wakeTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            deepSleepMinutes: freezed == deepSleepMinutes
                ? _value.deepSleepMinutes
                : deepSleepMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            lightSleepMinutes: freezed == lightSleepMinutes
                ? _value.lightSleepMinutes
                : lightSleepMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            restlessSleepMinutes: freezed == restlessSleepMinutes
                ? _value.restlessSleepMinutes
                : restlessSleepMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            dreamType: freezed == dreamType
                ? _value.dreamType
                : dreamType // ignore: cast_nullable_to_non_nullable
                      as DreamType?,
            wakingFeeling: freezed == wakingFeeling
                ? _value.wakingFeeling
                : wakingFeeling // ignore: cast_nullable_to_non_nullable
                      as WakingFeeling?,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateSleepEntryInputImplCopyWith<$Res>
    implements $UpdateSleepEntryInputCopyWith<$Res> {
  factory _$$UpdateSleepEntryInputImplCopyWith(
    _$UpdateSleepEntryInputImpl value,
    $Res Function(_$UpdateSleepEntryInputImpl) then,
  ) = __$$UpdateSleepEntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    int? bedTime,
    int? wakeTime,
    int? deepSleepMinutes,
    int? lightSleepMinutes,
    int? restlessSleepMinutes,
    DreamType? dreamType,
    WakingFeeling? wakingFeeling,
    String? notes,
    String? importSource,
    String? importExternalId,
  });
}

/// @nodoc
class __$$UpdateSleepEntryInputImplCopyWithImpl<$Res>
    extends
        _$UpdateSleepEntryInputCopyWithImpl<$Res, _$UpdateSleepEntryInputImpl>
    implements _$$UpdateSleepEntryInputImplCopyWith<$Res> {
  __$$UpdateSleepEntryInputImplCopyWithImpl(
    _$UpdateSleepEntryInputImpl _value,
    $Res Function(_$UpdateSleepEntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? bedTime = freezed,
    Object? wakeTime = freezed,
    Object? deepSleepMinutes = freezed,
    Object? lightSleepMinutes = freezed,
    Object? restlessSleepMinutes = freezed,
    Object? dreamType = freezed,
    Object? wakingFeeling = freezed,
    Object? notes = freezed,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
  }) {
    return _then(
      _$UpdateSleepEntryInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        bedTime: freezed == bedTime
            ? _value.bedTime
            : bedTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        wakeTime: freezed == wakeTime
            ? _value.wakeTime
            : wakeTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        deepSleepMinutes: freezed == deepSleepMinutes
            ? _value.deepSleepMinutes
            : deepSleepMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        lightSleepMinutes: freezed == lightSleepMinutes
            ? _value.lightSleepMinutes
            : lightSleepMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        restlessSleepMinutes: freezed == restlessSleepMinutes
            ? _value.restlessSleepMinutes
            : restlessSleepMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        dreamType: freezed == dreamType
            ? _value.dreamType
            : dreamType // ignore: cast_nullable_to_non_nullable
                  as DreamType?,
        wakingFeeling: freezed == wakingFeeling
            ? _value.wakingFeeling
            : wakingFeeling // ignore: cast_nullable_to_non_nullable
                  as WakingFeeling?,
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
      ),
    );
  }
}

/// @nodoc

class _$UpdateSleepEntryInputImpl implements _UpdateSleepEntryInput {
  const _$UpdateSleepEntryInputImpl({
    required this.id,
    required this.profileId,
    this.bedTime,
    this.wakeTime,
    this.deepSleepMinutes,
    this.lightSleepMinutes,
    this.restlessSleepMinutes,
    this.dreamType,
    this.wakingFeeling,
    this.notes,
    this.importSource,
    this.importExternalId,
  });

  @override
  final String id;
  @override
  final String profileId;
  // All fields optional for partial update
  @override
  final int? bedTime;
  // Epoch milliseconds
  @override
  final int? wakeTime;
  // Epoch milliseconds
  @override
  final int? deepSleepMinutes;
  @override
  final int? lightSleepMinutes;
  @override
  final int? restlessSleepMinutes;
  @override
  final DreamType? dreamType;
  @override
  final WakingFeeling? wakingFeeling;
  @override
  final String? notes;
  @override
  final String? importSource;
  @override
  final String? importExternalId;

  @override
  String toString() {
    return 'UpdateSleepEntryInput(id: $id, profileId: $profileId, bedTime: $bedTime, wakeTime: $wakeTime, deepSleepMinutes: $deepSleepMinutes, lightSleepMinutes: $lightSleepMinutes, restlessSleepMinutes: $restlessSleepMinutes, dreamType: $dreamType, wakingFeeling: $wakingFeeling, notes: $notes, importSource: $importSource, importExternalId: $importExternalId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSleepEntryInputImpl &&
            (identical(other.id, id) || other.id == id) &&
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
            (identical(other.importSource, importSource) ||
                other.importSource == importSource) &&
            (identical(other.importExternalId, importExternalId) ||
                other.importExternalId == importExternalId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    bedTime,
    wakeTime,
    deepSleepMinutes,
    lightSleepMinutes,
    restlessSleepMinutes,
    dreamType,
    wakingFeeling,
    notes,
    importSource,
    importExternalId,
  );

  /// Create a copy of UpdateSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSleepEntryInputImplCopyWith<_$UpdateSleepEntryInputImpl>
  get copyWith =>
      __$$UpdateSleepEntryInputImplCopyWithImpl<_$UpdateSleepEntryInputImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateSleepEntryInput implements UpdateSleepEntryInput {
  const factory _UpdateSleepEntryInput({
    required final String id,
    required final String profileId,
    final int? bedTime,
    final int? wakeTime,
    final int? deepSleepMinutes,
    final int? lightSleepMinutes,
    final int? restlessSleepMinutes,
    final DreamType? dreamType,
    final WakingFeeling? wakingFeeling,
    final String? notes,
    final String? importSource,
    final String? importExternalId,
  }) = _$UpdateSleepEntryInputImpl;

  @override
  String get id;
  @override
  String get profileId; // All fields optional for partial update
  @override
  int? get bedTime; // Epoch milliseconds
  @override
  int? get wakeTime; // Epoch milliseconds
  @override
  int? get deepSleepMinutes;
  @override
  int? get lightSleepMinutes;
  @override
  int? get restlessSleepMinutes;
  @override
  DreamType? get dreamType;
  @override
  WakingFeeling? get wakingFeeling;
  @override
  String? get notes;
  @override
  String? get importSource;
  @override
  String? get importExternalId;

  /// Create a copy of UpdateSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSleepEntryInputImplCopyWith<_$UpdateSleepEntryInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeleteSleepEntryInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of DeleteSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteSleepEntryInputCopyWith<DeleteSleepEntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteSleepEntryInputCopyWith<$Res> {
  factory $DeleteSleepEntryInputCopyWith(
    DeleteSleepEntryInput value,
    $Res Function(DeleteSleepEntryInput) then,
  ) = _$DeleteSleepEntryInputCopyWithImpl<$Res, DeleteSleepEntryInput>;
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class _$DeleteSleepEntryInputCopyWithImpl<
  $Res,
  $Val extends DeleteSleepEntryInput
>
    implements $DeleteSleepEntryInputCopyWith<$Res> {
  _$DeleteSleepEntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteSleepEntryInput
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
abstract class _$$DeleteSleepEntryInputImplCopyWith<$Res>
    implements $DeleteSleepEntryInputCopyWith<$Res> {
  factory _$$DeleteSleepEntryInputImplCopyWith(
    _$DeleteSleepEntryInputImpl value,
    $Res Function(_$DeleteSleepEntryInputImpl) then,
  ) = __$$DeleteSleepEntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class __$$DeleteSleepEntryInputImplCopyWithImpl<$Res>
    extends
        _$DeleteSleepEntryInputCopyWithImpl<$Res, _$DeleteSleepEntryInputImpl>
    implements _$$DeleteSleepEntryInputImplCopyWith<$Res> {
  __$$DeleteSleepEntryInputImplCopyWithImpl(
    _$DeleteSleepEntryInputImpl _value,
    $Res Function(_$DeleteSleepEntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? profileId = null}) {
    return _then(
      _$DeleteSleepEntryInputImpl(
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

class _$DeleteSleepEntryInputImpl implements _DeleteSleepEntryInput {
  const _$DeleteSleepEntryInputImpl({
    required this.id,
    required this.profileId,
  });

  @override
  final String id;
  @override
  final String profileId;

  @override
  String toString() {
    return 'DeleteSleepEntryInput(id: $id, profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteSleepEntryInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId);

  /// Create a copy of DeleteSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteSleepEntryInputImplCopyWith<_$DeleteSleepEntryInputImpl>
  get copyWith =>
      __$$DeleteSleepEntryInputImplCopyWithImpl<_$DeleteSleepEntryInputImpl>(
        this,
        _$identity,
      );
}

abstract class _DeleteSleepEntryInput implements DeleteSleepEntryInput {
  const factory _DeleteSleepEntryInput({
    required final String id,
    required final String profileId,
  }) = _$DeleteSleepEntryInputImpl;

  @override
  String get id;
  @override
  String get profileId;

  /// Create a copy of DeleteSleepEntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteSleepEntryInputImplCopyWith<_$DeleteSleepEntryInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}
