// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flare_up.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FlareUp _$FlareUpFromJson(Map<String, dynamic> json) {
  return _FlareUp.fromJson(json);
}

/// @nodoc
mixin _$FlareUp {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get conditionId => throw _privateConstructorUsedError;
  int get startDate =>
      throw _privateConstructorUsedError; // Epoch milliseconds - flare-up start
  int? get endDate =>
      throw _privateConstructorUsedError; // Epoch milliseconds - flare-up end (null = ongoing)
  int get severity => throw _privateConstructorUsedError; // 1-10 scale
  String? get notes => throw _privateConstructorUsedError;
  List<String> get triggers =>
      throw _privateConstructorUsedError; // Trigger descriptions
  String? get activityId =>
      throw _privateConstructorUsedError; // Activity that may have triggered flare-up
  String? get photoPath => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this FlareUp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlareUp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlareUpCopyWith<FlareUp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlareUpCopyWith<$Res> {
  factory $FlareUpCopyWith(FlareUp value, $Res Function(FlareUp) then) =
      _$FlareUpCopyWithImpl<$Res, FlareUp>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String conditionId,
    int startDate,
    int? endDate,
    int severity,
    String? notes,
    List<String> triggers,
    String? activityId,
    String? photoPath,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$FlareUpCopyWithImpl<$Res, $Val extends FlareUp>
    implements $FlareUpCopyWith<$Res> {
  _$FlareUpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlareUp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? conditionId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? severity = null,
    Object? notes = freezed,
    Object? triggers = null,
    Object? activityId = freezed,
    Object? photoPath = freezed,
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
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            triggers: null == triggers
                ? _value.triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            activityId: freezed == activityId
                ? _value.activityId
                : activityId // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of FlareUp
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
abstract class _$$FlareUpImplCopyWith<$Res> implements $FlareUpCopyWith<$Res> {
  factory _$$FlareUpImplCopyWith(
    _$FlareUpImpl value,
    $Res Function(_$FlareUpImpl) then,
  ) = __$$FlareUpImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String conditionId,
    int startDate,
    int? endDate,
    int severity,
    String? notes,
    List<String> triggers,
    String? activityId,
    String? photoPath,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$FlareUpImplCopyWithImpl<$Res>
    extends _$FlareUpCopyWithImpl<$Res, _$FlareUpImpl>
    implements _$$FlareUpImplCopyWith<$Res> {
  __$$FlareUpImplCopyWithImpl(
    _$FlareUpImpl _value,
    $Res Function(_$FlareUpImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlareUp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? conditionId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? severity = null,
    Object? notes = freezed,
    Object? triggers = null,
    Object? activityId = freezed,
    Object? photoPath = freezed,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$FlareUpImpl(
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
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        triggers: null == triggers
            ? _value._triggers
            : triggers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        activityId: freezed == activityId
            ? _value.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
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
class _$FlareUpImpl extends _FlareUp {
  const _$FlareUpImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.conditionId,
    required this.startDate,
    this.endDate,
    required this.severity,
    this.notes,
    required final List<String> triggers,
    this.activityId,
    this.photoPath,
    required this.syncMetadata,
  }) : _triggers = triggers,
       super._();

  factory _$FlareUpImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlareUpImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final String conditionId;
  @override
  final int startDate;
  // Epoch milliseconds - flare-up start
  @override
  final int? endDate;
  // Epoch milliseconds - flare-up end (null = ongoing)
  @override
  final int severity;
  // 1-10 scale
  @override
  final String? notes;
  final List<String> _triggers;
  @override
  List<String> get triggers {
    if (_triggers is EqualUnmodifiableListView) return _triggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggers);
  }

  // Trigger descriptions
  @override
  final String? activityId;
  // Activity that may have triggered flare-up
  @override
  final String? photoPath;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'FlareUp(id: $id, clientId: $clientId, profileId: $profileId, conditionId: $conditionId, startDate: $startDate, endDate: $endDate, severity: $severity, notes: $notes, triggers: $triggers, activityId: $activityId, photoPath: $photoPath, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlareUpImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.conditionId, conditionId) ||
                other.conditionId == conditionId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._triggers, _triggers) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
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
    startDate,
    endDate,
    severity,
    notes,
    const DeepCollectionEquality().hash(_triggers),
    activityId,
    photoPath,
    syncMetadata,
  );

  /// Create a copy of FlareUp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlareUpImplCopyWith<_$FlareUpImpl> get copyWith =>
      __$$FlareUpImplCopyWithImpl<_$FlareUpImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlareUpImplToJson(this);
  }
}

abstract class _FlareUp extends FlareUp {
  const factory _FlareUp({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final String conditionId,
    required final int startDate,
    final int? endDate,
    required final int severity,
    final String? notes,
    required final List<String> triggers,
    final String? activityId,
    final String? photoPath,
    required final SyncMetadata syncMetadata,
  }) = _$FlareUpImpl;
  const _FlareUp._() : super._();

  factory _FlareUp.fromJson(Map<String, dynamic> json) = _$FlareUpImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  String get conditionId;
  @override
  int get startDate; // Epoch milliseconds - flare-up start
  @override
  int? get endDate; // Epoch milliseconds - flare-up end (null = ongoing)
  @override
  int get severity; // 1-10 scale
  @override
  String? get notes;
  @override
  List<String> get triggers; // Trigger descriptions
  @override
  String? get activityId; // Activity that may have triggered flare-up
  @override
  String? get photoPath;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of FlareUp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlareUpImplCopyWith<_$FlareUpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
