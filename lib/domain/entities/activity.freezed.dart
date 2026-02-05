// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return _Activity.fromJson(json);
}

/// @nodoc
mixin _$Activity {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get triggers =>
      throw _privateConstructorUsedError; // Comma-separated trigger descriptions
  int get durationMinutes => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this Activity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityCopyWith<Activity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityCopyWith<$Res> {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) then) =
      _$ActivityCopyWithImpl<$Res, Activity>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String name,
    String? description,
    String? location,
    String? triggers,
    int durationMinutes,
    bool isArchived,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$ActivityCopyWithImpl<$Res, $Val extends Activity>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? name = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? triggers = freezed,
    Object? durationMinutes = null,
    Object? isArchived = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            triggers: freezed == triggers
                ? _value.triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of Activity
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
abstract class _$$ActivityImplCopyWith<$Res>
    implements $ActivityCopyWith<$Res> {
  factory _$$ActivityImplCopyWith(
    _$ActivityImpl value,
    $Res Function(_$ActivityImpl) then,
  ) = __$$ActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String name,
    String? description,
    String? location,
    String? triggers,
    int durationMinutes,
    bool isArchived,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$ActivityImplCopyWithImpl<$Res>
    extends _$ActivityCopyWithImpl<$Res, _$ActivityImpl>
    implements _$$ActivityImplCopyWith<$Res> {
  __$$ActivityImplCopyWithImpl(
    _$ActivityImpl _value,
    $Res Function(_$ActivityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? name = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? triggers = freezed,
    Object? durationMinutes = null,
    Object? isArchived = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$ActivityImpl(
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
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        triggers: freezed == triggers
            ? _value.triggers
            : triggers // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
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
class _$ActivityImpl extends _Activity {
  const _$ActivityImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.name,
    this.description,
    this.location,
    this.triggers,
    required this.durationMinutes,
    this.isArchived = false,
    required this.syncMetadata,
  }) : super._();

  factory _$ActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? location;
  @override
  final String? triggers;
  // Comma-separated trigger descriptions
  @override
  final int durationMinutes;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'Activity(id: $id, clientId: $clientId, profileId: $profileId, name: $name, description: $description, location: $location, triggers: $triggers, durationMinutes: $durationMinutes, isArchived: $isArchived, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.triggers, triggers) ||
                other.triggers == triggers) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
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
    name,
    description,
    location,
    triggers,
    durationMinutes,
    isArchived,
    syncMetadata,
  );

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      __$$ActivityImplCopyWithImpl<_$ActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityImplToJson(this);
  }
}

abstract class _Activity extends Activity {
  const factory _Activity({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final String name,
    final String? description,
    final String? location,
    final String? triggers,
    required final int durationMinutes,
    final bool isArchived,
    required final SyncMetadata syncMetadata,
  }) = _$ActivityImpl;
  const _Activity._() : super._();

  factory _Activity.fromJson(Map<String, dynamic> json) =
      _$ActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get location;
  @override
  String? get triggers; // Comma-separated trigger descriptions
  @override
  int get durationMinutes;
  @override
  bool get isArchived;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
