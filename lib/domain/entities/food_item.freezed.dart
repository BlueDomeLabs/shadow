// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) {
  return _FoodItem.fromJson(json);
}

/// @nodoc
mixin _$FoodItem {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  FoodItemType get type => throw _privateConstructorUsedError;
  List<String> get simpleItemIds =>
      throw _privateConstructorUsedError; // For complex items
  bool get isUserCreated => throw _privateConstructorUsedError;
  bool get isArchived =>
      throw _privateConstructorUsedError; // Nutritional information (optional)
  String? get servingSize =>
      throw _privateConstructorUsedError; // e.g., "1 cup", "100g"
  double? get calories =>
      throw _privateConstructorUsedError; // kcal per serving
  double? get carbsGrams =>
      throw _privateConstructorUsedError; // Carbohydrates in grams
  double? get fatGrams => throw _privateConstructorUsedError; // Fat in grams
  double? get proteinGrams =>
      throw _privateConstructorUsedError; // Protein in grams
  double? get fiberGrams =>
      throw _privateConstructorUsedError; // Fiber in grams
  double? get sugarGrams =>
      throw _privateConstructorUsedError; // Sugar in grams
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this FoodItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodItemCopyWith<FoodItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodItemCopyWith<$Res> {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) then) =
      _$FoodItemCopyWithImpl<$Res, FoodItem>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String name,
    FoodItemType type,
    List<String> simpleItemIds,
    bool isUserCreated,
    bool isArchived,
    String? servingSize,
    double? calories,
    double? carbsGrams,
    double? fatGrams,
    double? proteinGrams,
    double? fiberGrams,
    double? sugarGrams,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$FoodItemCopyWithImpl<$Res, $Val extends FoodItem>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? name = null,
    Object? type = null,
    Object? simpleItemIds = null,
    Object? isUserCreated = null,
    Object? isArchived = null,
    Object? servingSize = freezed,
    Object? calories = freezed,
    Object? carbsGrams = freezed,
    Object? fatGrams = freezed,
    Object? proteinGrams = freezed,
    Object? fiberGrams = freezed,
    Object? sugarGrams = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as FoodItemType,
            simpleItemIds: null == simpleItemIds
                ? _value.simpleItemIds
                : simpleItemIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isUserCreated: null == isUserCreated
                ? _value.isUserCreated
                : isUserCreated // ignore: cast_nullable_to_non_nullable
                      as bool,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
            servingSize: freezed == servingSize
                ? _value.servingSize
                : servingSize // ignore: cast_nullable_to_non_nullable
                      as String?,
            calories: freezed == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as double?,
            carbsGrams: freezed == carbsGrams
                ? _value.carbsGrams
                : carbsGrams // ignore: cast_nullable_to_non_nullable
                      as double?,
            fatGrams: freezed == fatGrams
                ? _value.fatGrams
                : fatGrams // ignore: cast_nullable_to_non_nullable
                      as double?,
            proteinGrams: freezed == proteinGrams
                ? _value.proteinGrams
                : proteinGrams // ignore: cast_nullable_to_non_nullable
                      as double?,
            fiberGrams: freezed == fiberGrams
                ? _value.fiberGrams
                : fiberGrams // ignore: cast_nullable_to_non_nullable
                      as double?,
            sugarGrams: freezed == sugarGrams
                ? _value.sugarGrams
                : sugarGrams // ignore: cast_nullable_to_non_nullable
                      as double?,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of FoodItem
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
abstract class _$$FoodItemImplCopyWith<$Res>
    implements $FoodItemCopyWith<$Res> {
  factory _$$FoodItemImplCopyWith(
    _$FoodItemImpl value,
    $Res Function(_$FoodItemImpl) then,
  ) = __$$FoodItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String name,
    FoodItemType type,
    List<String> simpleItemIds,
    bool isUserCreated,
    bool isArchived,
    String? servingSize,
    double? calories,
    double? carbsGrams,
    double? fatGrams,
    double? proteinGrams,
    double? fiberGrams,
    double? sugarGrams,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$FoodItemImplCopyWithImpl<$Res>
    extends _$FoodItemCopyWithImpl<$Res, _$FoodItemImpl>
    implements _$$FoodItemImplCopyWith<$Res> {
  __$$FoodItemImplCopyWithImpl(
    _$FoodItemImpl _value,
    $Res Function(_$FoodItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? name = null,
    Object? type = null,
    Object? simpleItemIds = null,
    Object? isUserCreated = null,
    Object? isArchived = null,
    Object? servingSize = freezed,
    Object? calories = freezed,
    Object? carbsGrams = freezed,
    Object? fatGrams = freezed,
    Object? proteinGrams = freezed,
    Object? fiberGrams = freezed,
    Object? sugarGrams = freezed,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$FoodItemImpl(
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
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as FoodItemType,
        simpleItemIds: null == simpleItemIds
            ? _value._simpleItemIds
            : simpleItemIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isUserCreated: null == isUserCreated
            ? _value.isUserCreated
            : isUserCreated // ignore: cast_nullable_to_non_nullable
                  as bool,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        servingSize: freezed == servingSize
            ? _value.servingSize
            : servingSize // ignore: cast_nullable_to_non_nullable
                  as String?,
        calories: freezed == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as double?,
        carbsGrams: freezed == carbsGrams
            ? _value.carbsGrams
            : carbsGrams // ignore: cast_nullable_to_non_nullable
                  as double?,
        fatGrams: freezed == fatGrams
            ? _value.fatGrams
            : fatGrams // ignore: cast_nullable_to_non_nullable
                  as double?,
        proteinGrams: freezed == proteinGrams
            ? _value.proteinGrams
            : proteinGrams // ignore: cast_nullable_to_non_nullable
                  as double?,
        fiberGrams: freezed == fiberGrams
            ? _value.fiberGrams
            : fiberGrams // ignore: cast_nullable_to_non_nullable
                  as double?,
        sugarGrams: freezed == sugarGrams
            ? _value.sugarGrams
            : sugarGrams // ignore: cast_nullable_to_non_nullable
                  as double?,
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
class _$FoodItemImpl extends _FoodItem {
  const _$FoodItemImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.name,
    this.type = FoodItemType.simple,
    final List<String> simpleItemIds = const [],
    this.isUserCreated = true,
    this.isArchived = false,
    this.servingSize,
    this.calories,
    this.carbsGrams,
    this.fatGrams,
    this.proteinGrams,
    this.fiberGrams,
    this.sugarGrams,
    required this.syncMetadata,
  }) : _simpleItemIds = simpleItemIds,
       super._();

  factory _$FoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodItemImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final String name;
  @override
  @JsonKey()
  final FoodItemType type;
  final List<String> _simpleItemIds;
  @override
  @JsonKey()
  List<String> get simpleItemIds {
    if (_simpleItemIds is EqualUnmodifiableListView) return _simpleItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_simpleItemIds);
  }

  // For complex items
  @override
  @JsonKey()
  final bool isUserCreated;
  @override
  @JsonKey()
  final bool isArchived;
  // Nutritional information (optional)
  @override
  final String? servingSize;
  // e.g., "1 cup", "100g"
  @override
  final double? calories;
  // kcal per serving
  @override
  final double? carbsGrams;
  // Carbohydrates in grams
  @override
  final double? fatGrams;
  // Fat in grams
  @override
  final double? proteinGrams;
  // Protein in grams
  @override
  final double? fiberGrams;
  // Fiber in grams
  @override
  final double? sugarGrams;
  // Sugar in grams
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'FoodItem(id: $id, clientId: $clientId, profileId: $profileId, name: $name, type: $type, simpleItemIds: $simpleItemIds, isUserCreated: $isUserCreated, isArchived: $isArchived, servingSize: $servingSize, calories: $calories, carbsGrams: $carbsGrams, fatGrams: $fatGrams, proteinGrams: $proteinGrams, fiberGrams: $fiberGrams, sugarGrams: $sugarGrams, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._simpleItemIds,
              _simpleItemIds,
            ) &&
            (identical(other.isUserCreated, isUserCreated) ||
                other.isUserCreated == isUserCreated) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.servingSize, servingSize) ||
                other.servingSize == servingSize) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.carbsGrams, carbsGrams) ||
                other.carbsGrams == carbsGrams) &&
            (identical(other.fatGrams, fatGrams) ||
                other.fatGrams == fatGrams) &&
            (identical(other.proteinGrams, proteinGrams) ||
                other.proteinGrams == proteinGrams) &&
            (identical(other.fiberGrams, fiberGrams) ||
                other.fiberGrams == fiberGrams) &&
            (identical(other.sugarGrams, sugarGrams) ||
                other.sugarGrams == sugarGrams) &&
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
    type,
    const DeepCollectionEquality().hash(_simpleItemIds),
    isUserCreated,
    isArchived,
    servingSize,
    calories,
    carbsGrams,
    fatGrams,
    proteinGrams,
    fiberGrams,
    sugarGrams,
    syncMetadata,
  );

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      __$$FoodItemImplCopyWithImpl<_$FoodItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodItemImplToJson(this);
  }
}

abstract class _FoodItem extends FoodItem {
  const factory _FoodItem({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final String name,
    final FoodItemType type,
    final List<String> simpleItemIds,
    final bool isUserCreated,
    final bool isArchived,
    final String? servingSize,
    final double? calories,
    final double? carbsGrams,
    final double? fatGrams,
    final double? proteinGrams,
    final double? fiberGrams,
    final double? sugarGrams,
    required final SyncMetadata syncMetadata,
  }) = _$FoodItemImpl;
  const _FoodItem._() : super._();

  factory _FoodItem.fromJson(Map<String, dynamic> json) =
      _$FoodItemImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  String get name;
  @override
  FoodItemType get type;
  @override
  List<String> get simpleItemIds; // For complex items
  @override
  bool get isUserCreated;
  @override
  bool get isArchived; // Nutritional information (optional)
  @override
  String? get servingSize; // e.g., "1 cup", "100g"
  @override
  double? get calories; // kcal per serving
  @override
  double? get carbsGrams; // Carbohydrates in grams
  @override
  double? get fatGrams; // Fat in grams
  @override
  double? get proteinGrams; // Protein in grams
  @override
  double? get fiberGrams; // Fiber in grams
  @override
  double? get sugarGrams; // Sugar in grams
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
