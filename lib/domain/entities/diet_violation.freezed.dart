// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_violation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DietViolation _$DietViolationFromJson(Map<String, dynamic> json) {
  return _DietViolation.fromJson(json);
}

/// @nodoc
mixin _$DietViolation {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get dietId => throw _privateConstructorUsedError;
  String get ruleId => throw _privateConstructorUsedError;
  String? get foodLogId =>
      throw _privateConstructorUsedError; // null if user cancelled (wasOverridden=false)
  String get foodName =>
      throw _privateConstructorUsedError; // Human-readable name of the food
  String get ruleDescription =>
      throw _privateConstructorUsedError; // Plain-English rule that was violated
  bool get wasOverridden =>
      throw _privateConstructorUsedError; // true = "Add Anyway", false = "Cancel"
  int get timestamp => throw _privateConstructorUsedError; // Epoch ms
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this DietViolation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DietViolation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DietViolationCopyWith<DietViolation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DietViolationCopyWith<$Res> {
  factory $DietViolationCopyWith(
    DietViolation value,
    $Res Function(DietViolation) then,
  ) = _$DietViolationCopyWithImpl<$Res, DietViolation>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String dietId,
    String ruleId,
    String? foodLogId,
    String foodName,
    String ruleDescription,
    bool wasOverridden,
    int timestamp,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$DietViolationCopyWithImpl<$Res, $Val extends DietViolation>
    implements $DietViolationCopyWith<$Res> {
  _$DietViolationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DietViolation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? dietId = null,
    Object? ruleId = null,
    Object? foodLogId = freezed,
    Object? foodName = null,
    Object? ruleDescription = null,
    Object? wasOverridden = null,
    Object? timestamp = null,
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
            dietId: null == dietId
                ? _value.dietId
                : dietId // ignore: cast_nullable_to_non_nullable
                      as String,
            ruleId: null == ruleId
                ? _value.ruleId
                : ruleId // ignore: cast_nullable_to_non_nullable
                      as String,
            foodLogId: freezed == foodLogId
                ? _value.foodLogId
                : foodLogId // ignore: cast_nullable_to_non_nullable
                      as String?,
            foodName: null == foodName
                ? _value.foodName
                : foodName // ignore: cast_nullable_to_non_nullable
                      as String,
            ruleDescription: null == ruleDescription
                ? _value.ruleDescription
                : ruleDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            wasOverridden: null == wasOverridden
                ? _value.wasOverridden
                : wasOverridden // ignore: cast_nullable_to_non_nullable
                      as bool,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of DietViolation
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
abstract class _$$DietViolationImplCopyWith<$Res>
    implements $DietViolationCopyWith<$Res> {
  factory _$$DietViolationImplCopyWith(
    _$DietViolationImpl value,
    $Res Function(_$DietViolationImpl) then,
  ) = __$$DietViolationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String dietId,
    String ruleId,
    String? foodLogId,
    String foodName,
    String ruleDescription,
    bool wasOverridden,
    int timestamp,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$DietViolationImplCopyWithImpl<$Res>
    extends _$DietViolationCopyWithImpl<$Res, _$DietViolationImpl>
    implements _$$DietViolationImplCopyWith<$Res> {
  __$$DietViolationImplCopyWithImpl(
    _$DietViolationImpl _value,
    $Res Function(_$DietViolationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DietViolation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? dietId = null,
    Object? ruleId = null,
    Object? foodLogId = freezed,
    Object? foodName = null,
    Object? ruleDescription = null,
    Object? wasOverridden = null,
    Object? timestamp = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$DietViolationImpl(
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
        dietId: null == dietId
            ? _value.dietId
            : dietId // ignore: cast_nullable_to_non_nullable
                  as String,
        ruleId: null == ruleId
            ? _value.ruleId
            : ruleId // ignore: cast_nullable_to_non_nullable
                  as String,
        foodLogId: freezed == foodLogId
            ? _value.foodLogId
            : foodLogId // ignore: cast_nullable_to_non_nullable
                  as String?,
        foodName: null == foodName
            ? _value.foodName
            : foodName // ignore: cast_nullable_to_non_nullable
                  as String,
        ruleDescription: null == ruleDescription
            ? _value.ruleDescription
            : ruleDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        wasOverridden: null == wasOverridden
            ? _value.wasOverridden
            : wasOverridden // ignore: cast_nullable_to_non_nullable
                  as bool,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$DietViolationImpl extends _DietViolation {
  const _$DietViolationImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.dietId,
    required this.ruleId,
    this.foodLogId,
    required this.foodName,
    required this.ruleDescription,
    this.wasOverridden = false,
    required this.timestamp,
    required this.syncMetadata,
  }) : super._();

  factory _$DietViolationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DietViolationImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final String dietId;
  @override
  final String ruleId;
  @override
  final String? foodLogId;
  // null if user cancelled (wasOverridden=false)
  @override
  final String foodName;
  // Human-readable name of the food
  @override
  final String ruleDescription;
  // Plain-English rule that was violated
  @override
  @JsonKey()
  final bool wasOverridden;
  // true = "Add Anyway", false = "Cancel"
  @override
  final int timestamp;
  // Epoch ms
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'DietViolation(id: $id, clientId: $clientId, profileId: $profileId, dietId: $dietId, ruleId: $ruleId, foodLogId: $foodLogId, foodName: $foodName, ruleDescription: $ruleDescription, wasOverridden: $wasOverridden, timestamp: $timestamp, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DietViolationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.dietId, dietId) || other.dietId == dietId) &&
            (identical(other.ruleId, ruleId) || other.ruleId == ruleId) &&
            (identical(other.foodLogId, foodLogId) ||
                other.foodLogId == foodLogId) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.ruleDescription, ruleDescription) ||
                other.ruleDescription == ruleDescription) &&
            (identical(other.wasOverridden, wasOverridden) ||
                other.wasOverridden == wasOverridden) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
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
    dietId,
    ruleId,
    foodLogId,
    foodName,
    ruleDescription,
    wasOverridden,
    timestamp,
    syncMetadata,
  );

  /// Create a copy of DietViolation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DietViolationImplCopyWith<_$DietViolationImpl> get copyWith =>
      __$$DietViolationImplCopyWithImpl<_$DietViolationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DietViolationImplToJson(this);
  }
}

abstract class _DietViolation extends DietViolation {
  const factory _DietViolation({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final String dietId,
    required final String ruleId,
    final String? foodLogId,
    required final String foodName,
    required final String ruleDescription,
    final bool wasOverridden,
    required final int timestamp,
    required final SyncMetadata syncMetadata,
  }) = _$DietViolationImpl;
  const _DietViolation._() : super._();

  factory _DietViolation.fromJson(Map<String, dynamic> json) =
      _$DietViolationImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  String get dietId;
  @override
  String get ruleId;
  @override
  String? get foodLogId; // null if user cancelled (wasOverridden=false)
  @override
  String get foodName; // Human-readable name of the food
  @override
  String get ruleDescription; // Plain-English rule that was violated
  @override
  bool get wasOverridden; // true = "Add Anyway", false = "Cancel"
  @override
  int get timestamp; // Epoch ms
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of DietViolation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DietViolationImplCopyWith<_$DietViolationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
