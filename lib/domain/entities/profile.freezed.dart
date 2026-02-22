// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _Profile.fromJson(json);
}

/// @nodoc
mixin _$Profile {
  String get id =>
      throw _privateConstructorUsedError; // This IS the profileId for child entities
  String get clientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get birthDate =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  BiologicalSex? get biologicalSex => throw _privateConstructorUsedError;

  /// Fully optional, self-reported, for the user's own records only.
  /// Never required, never used in logic or calculations.
  String? get ethnicity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get ownerId =>
      throw _privateConstructorUsedError; // FK to user_accounts
  /// Simple diet label for display purposes.
  /// For compliance tracking, create a Diet entity instead.
  ProfileDietType get dietType => throw _privateConstructorUsedError;
  String? get dietDescription =>
      throw _privateConstructorUsedError; // Custom description when dietType=other
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res, Profile>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String name,
    int? birthDate,
    BiologicalSex? biologicalSex,
    String? ethnicity,
    String? notes,
    String? ownerId,
    ProfileDietType dietType,
    String? dietDescription,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res, $Val extends Profile>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? name = null,
    Object? birthDate = freezed,
    Object? biologicalSex = freezed,
    Object? ethnicity = freezed,
    Object? notes = freezed,
    Object? ownerId = freezed,
    Object? dietType = null,
    Object? dietDescription = freezed,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            biologicalSex: freezed == biologicalSex
                ? _value.biologicalSex
                : biologicalSex // ignore: cast_nullable_to_non_nullable
                      as BiologicalSex?,
            ethnicity: freezed == ethnicity
                ? _value.ethnicity
                : ethnicity // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            dietType: null == dietType
                ? _value.dietType
                : dietType // ignore: cast_nullable_to_non_nullable
                      as ProfileDietType,
            dietDescription: freezed == dietDescription
                ? _value.dietDescription
                : dietDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of Profile
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
abstract class _$$ProfileImplCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$ProfileImplCopyWith(
    _$ProfileImpl value,
    $Res Function(_$ProfileImpl) then,
  ) = __$$ProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String name,
    int? birthDate,
    BiologicalSex? biologicalSex,
    String? ethnicity,
    String? notes,
    String? ownerId,
    ProfileDietType dietType,
    String? dietDescription,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$ProfileImplCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$ProfileImpl>
    implements _$$ProfileImplCopyWith<$Res> {
  __$$ProfileImplCopyWithImpl(
    _$ProfileImpl _value,
    $Res Function(_$ProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? name = null,
    Object? birthDate = freezed,
    Object? biologicalSex = freezed,
    Object? ethnicity = freezed,
    Object? notes = freezed,
    Object? ownerId = freezed,
    Object? dietType = null,
    Object? dietDescription = freezed,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$ProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        biologicalSex: freezed == biologicalSex
            ? _value.biologicalSex
            : biologicalSex // ignore: cast_nullable_to_non_nullable
                  as BiologicalSex?,
        ethnicity: freezed == ethnicity
            ? _value.ethnicity
            : ethnicity // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        dietType: null == dietType
            ? _value.dietType
            : dietType // ignore: cast_nullable_to_non_nullable
                  as ProfileDietType,
        dietDescription: freezed == dietDescription
            ? _value.dietDescription
            : dietDescription // ignore: cast_nullable_to_non_nullable
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
class _$ProfileImpl extends _Profile {
  const _$ProfileImpl({
    required this.id,
    required this.clientId,
    required this.name,
    this.birthDate,
    this.biologicalSex,
    this.ethnicity,
    this.notes,
    this.ownerId,
    this.dietType = ProfileDietType.none,
    this.dietDescription,
    required this.syncMetadata,
  }) : super._();

  factory _$ProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImplFromJson(json);

  @override
  final String id;
  // This IS the profileId for child entities
  @override
  final String clientId;
  @override
  final String name;
  @override
  final int? birthDate;
  // Epoch milliseconds
  @override
  final BiologicalSex? biologicalSex;

  /// Fully optional, self-reported, for the user's own records only.
  /// Never required, never used in logic or calculations.
  @override
  final String? ethnicity;
  @override
  final String? notes;
  @override
  final String? ownerId;
  // FK to user_accounts
  /// Simple diet label for display purposes.
  /// For compliance tracking, create a Diet entity instead.
  @override
  @JsonKey()
  final ProfileDietType dietType;
  @override
  final String? dietDescription;
  // Custom description when dietType=other
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'Profile(id: $id, clientId: $clientId, name: $name, birthDate: $birthDate, biologicalSex: $biologicalSex, ethnicity: $ethnicity, notes: $notes, ownerId: $ownerId, dietType: $dietType, dietDescription: $dietDescription, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.biologicalSex, biologicalSex) ||
                other.biologicalSex == biologicalSex) &&
            (identical(other.ethnicity, ethnicity) ||
                other.ethnicity == ethnicity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.dietType, dietType) ||
                other.dietType == dietType) &&
            (identical(other.dietDescription, dietDescription) ||
                other.dietDescription == dietDescription) &&
            (identical(other.syncMetadata, syncMetadata) ||
                other.syncMetadata == syncMetadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    clientId,
    name,
    birthDate,
    biologicalSex,
    ethnicity,
    notes,
    ownerId,
    dietType,
    dietDescription,
    syncMetadata,
  );

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      __$$ProfileImplCopyWithImpl<_$ProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImplToJson(this);
  }
}

abstract class _Profile extends Profile {
  const factory _Profile({
    required final String id,
    required final String clientId,
    required final String name,
    final int? birthDate,
    final BiologicalSex? biologicalSex,
    final String? ethnicity,
    final String? notes,
    final String? ownerId,
    final ProfileDietType dietType,
    final String? dietDescription,
    required final SyncMetadata syncMetadata,
  }) = _$ProfileImpl;
  const _Profile._() : super._();

  factory _Profile.fromJson(Map<String, dynamic> json) = _$ProfileImpl.fromJson;

  @override
  String get id; // This IS the profileId for child entities
  @override
  String get clientId;
  @override
  String get name;
  @override
  int? get birthDate; // Epoch milliseconds
  @override
  BiologicalSex? get biologicalSex;

  /// Fully optional, self-reported, for the user's own records only.
  /// Never required, never used in logic or calculations.
  @override
  String? get ethnicity;
  @override
  String? get notes;
  @override
  String? get ownerId; // FK to user_accounts
  /// Simple diet label for display purposes.
  /// For compliance tracking, create a Diet entity instead.
  @override
  ProfileDietType get dietType;
  @override
  String? get dietDescription; // Custom description when dietType=other
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
