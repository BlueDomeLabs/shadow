// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FoodLog _$FoodLogFromJson(Map<String, dynamic> json) {
  return _FoodLog.fromJson(json);
}

/// @nodoc
mixin _$FoodLog {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError; // Epoch milliseconds
  MealType? get mealType =>
      throw _privateConstructorUsedError; // Breakfast/Lunch/Dinner/Snack
  List<String> get foodItemIds =>
      throw _privateConstructorUsedError; // References to FoodItem entities
  List<String> get adHocItems =>
      throw _privateConstructorUsedError; // Free-form food names (quick entry)
  String? get notes => throw _privateConstructorUsedError;
  bool get violationFlag =>
      throw _privateConstructorUsedError; // true = logged despite diet violation
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this FoodLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodLogCopyWith<FoodLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodLogCopyWith<$Res> {
  factory $FoodLogCopyWith(FoodLog value, $Res Function(FoodLog) then) =
      _$FoodLogCopyWithImpl<$Res, FoodLog>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    int timestamp,
    MealType? mealType,
    List<String> foodItemIds,
    List<String> adHocItems,
    String? notes,
    bool violationFlag,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$FoodLogCopyWithImpl<$Res, $Val extends FoodLog>
    implements $FoodLogCopyWith<$Res> {
  _$FoodLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? timestamp = null,
    Object? mealType = freezed,
    Object? foodItemIds = null,
    Object? adHocItems = null,
    Object? notes = freezed,
    Object? violationFlag = null,
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
            mealType: freezed == mealType
                ? _value.mealType
                : mealType // ignore: cast_nullable_to_non_nullable
                      as MealType?,
            foodItemIds: null == foodItemIds
                ? _value.foodItemIds
                : foodItemIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            adHocItems: null == adHocItems
                ? _value.adHocItems
                : adHocItems // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            violationFlag: null == violationFlag
                ? _value.violationFlag
                : violationFlag // ignore: cast_nullable_to_non_nullable
                      as bool,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of FoodLog
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
abstract class _$$FoodLogImplCopyWith<$Res> implements $FoodLogCopyWith<$Res> {
  factory _$$FoodLogImplCopyWith(
    _$FoodLogImpl value,
    $Res Function(_$FoodLogImpl) then,
  ) = __$$FoodLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    int timestamp,
    MealType? mealType,
    List<String> foodItemIds,
    List<String> adHocItems,
    String? notes,
    bool violationFlag,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$FoodLogImplCopyWithImpl<$Res>
    extends _$FoodLogCopyWithImpl<$Res, _$FoodLogImpl>
    implements _$$FoodLogImplCopyWith<$Res> {
  __$$FoodLogImplCopyWithImpl(
    _$FoodLogImpl _value,
    $Res Function(_$FoodLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FoodLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? timestamp = null,
    Object? mealType = freezed,
    Object? foodItemIds = null,
    Object? adHocItems = null,
    Object? notes = freezed,
    Object? violationFlag = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$FoodLogImpl(
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
        mealType: freezed == mealType
            ? _value.mealType
            : mealType // ignore: cast_nullable_to_non_nullable
                  as MealType?,
        foodItemIds: null == foodItemIds
            ? _value._foodItemIds
            : foodItemIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        adHocItems: null == adHocItems
            ? _value._adHocItems
            : adHocItems // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        violationFlag: null == violationFlag
            ? _value.violationFlag
            : violationFlag // ignore: cast_nullable_to_non_nullable
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
class _$FoodLogImpl extends _FoodLog {
  const _$FoodLogImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.timestamp,
    this.mealType,
    final List<String> foodItemIds = const [],
    final List<String> adHocItems = const [],
    this.notes,
    this.violationFlag = false,
    required this.syncMetadata,
  }) : _foodItemIds = foodItemIds,
       _adHocItems = adHocItems,
       super._();

  factory _$FoodLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodLogImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final int timestamp;
  // Epoch milliseconds
  @override
  final MealType? mealType;
  // Breakfast/Lunch/Dinner/Snack
  final List<String> _foodItemIds;
  // Breakfast/Lunch/Dinner/Snack
  @override
  @JsonKey()
  List<String> get foodItemIds {
    if (_foodItemIds is EqualUnmodifiableListView) return _foodItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foodItemIds);
  }

  // References to FoodItem entities
  final List<String> _adHocItems;
  // References to FoodItem entities
  @override
  @JsonKey()
  List<String> get adHocItems {
    if (_adHocItems is EqualUnmodifiableListView) return _adHocItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adHocItems);
  }

  // Free-form food names (quick entry)
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool violationFlag;
  // true = logged despite diet violation
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'FoodLog(id: $id, clientId: $clientId, profileId: $profileId, timestamp: $timestamp, mealType: $mealType, foodItemIds: $foodItemIds, adHocItems: $adHocItems, notes: $notes, violationFlag: $violationFlag, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            const DeepCollectionEquality().equals(
              other._foodItemIds,
              _foodItemIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._adHocItems,
              _adHocItems,
            ) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.violationFlag, violationFlag) ||
                other.violationFlag == violationFlag) &&
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
    mealType,
    const DeepCollectionEquality().hash(_foodItemIds),
    const DeepCollectionEquality().hash(_adHocItems),
    notes,
    violationFlag,
    syncMetadata,
  );

  /// Create a copy of FoodLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodLogImplCopyWith<_$FoodLogImpl> get copyWith =>
      __$$FoodLogImplCopyWithImpl<_$FoodLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodLogImplToJson(this);
  }
}

abstract class _FoodLog extends FoodLog {
  const factory _FoodLog({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final int timestamp,
    final MealType? mealType,
    final List<String> foodItemIds,
    final List<String> adHocItems,
    final String? notes,
    final bool violationFlag,
    required final SyncMetadata syncMetadata,
  }) = _$FoodLogImpl;
  const _FoodLog._() : super._();

  factory _FoodLog.fromJson(Map<String, dynamic> json) = _$FoodLogImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  int get timestamp; // Epoch milliseconds
  @override
  MealType? get mealType; // Breakfast/Lunch/Dinner/Snack
  @override
  List<String> get foodItemIds; // References to FoodItem entities
  @override
  List<String> get adHocItems; // Free-form food names (quick entry)
  @override
  String? get notes;
  @override
  bool get violationFlag; // true = logged despite diet violation
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of FoodLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodLogImplCopyWith<_$FoodLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
