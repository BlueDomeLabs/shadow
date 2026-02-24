// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_item_component.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FoodItemComponent {
  String get id => throw _privateConstructorUsedError;
  String get composedFoodItemId => throw _privateConstructorUsedError;
  String get simpleFoodItemId => throw _privateConstructorUsedError;
  double get quantity =>
      throw _privateConstructorUsedError; // Servings of Simple item used
  int get sortOrder => throw _privateConstructorUsedError;

  /// Create a copy of FoodItemComponent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodItemComponentCopyWith<FoodItemComponent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodItemComponentCopyWith<$Res> {
  factory $FoodItemComponentCopyWith(
    FoodItemComponent value,
    $Res Function(FoodItemComponent) then,
  ) = _$FoodItemComponentCopyWithImpl<$Res, FoodItemComponent>;
  @useResult
  $Res call({
    String id,
    String composedFoodItemId,
    String simpleFoodItemId,
    double quantity,
    int sortOrder,
  });
}

/// @nodoc
class _$FoodItemComponentCopyWithImpl<$Res, $Val extends FoodItemComponent>
    implements $FoodItemComponentCopyWith<$Res> {
  _$FoodItemComponentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodItemComponent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? composedFoodItemId = null,
    Object? simpleFoodItemId = null,
    Object? quantity = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            composedFoodItemId: null == composedFoodItemId
                ? _value.composedFoodItemId
                : composedFoodItemId // ignore: cast_nullable_to_non_nullable
                      as String,
            simpleFoodItemId: null == simpleFoodItemId
                ? _value.simpleFoodItemId
                : simpleFoodItemId // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FoodItemComponentImplCopyWith<$Res>
    implements $FoodItemComponentCopyWith<$Res> {
  factory _$$FoodItemComponentImplCopyWith(
    _$FoodItemComponentImpl value,
    $Res Function(_$FoodItemComponentImpl) then,
  ) = __$$FoodItemComponentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String composedFoodItemId,
    String simpleFoodItemId,
    double quantity,
    int sortOrder,
  });
}

/// @nodoc
class __$$FoodItemComponentImplCopyWithImpl<$Res>
    extends _$FoodItemComponentCopyWithImpl<$Res, _$FoodItemComponentImpl>
    implements _$$FoodItemComponentImplCopyWith<$Res> {
  __$$FoodItemComponentImplCopyWithImpl(
    _$FoodItemComponentImpl _value,
    $Res Function(_$FoodItemComponentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FoodItemComponent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? composedFoodItemId = null,
    Object? simpleFoodItemId = null,
    Object? quantity = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _$FoodItemComponentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        composedFoodItemId: null == composedFoodItemId
            ? _value.composedFoodItemId
            : composedFoodItemId // ignore: cast_nullable_to_non_nullable
                  as String,
        simpleFoodItemId: null == simpleFoodItemId
            ? _value.simpleFoodItemId
            : simpleFoodItemId // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$FoodItemComponentImpl implements _FoodItemComponent {
  const _$FoodItemComponentImpl({
    required this.id,
    required this.composedFoodItemId,
    required this.simpleFoodItemId,
    this.quantity = 1,
    this.sortOrder = 0,
  });

  @override
  final String id;
  @override
  final String composedFoodItemId;
  @override
  final String simpleFoodItemId;
  @override
  @JsonKey()
  final double quantity;
  // Servings of Simple item used
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'FoodItemComponent(id: $id, composedFoodItemId: $composedFoodItemId, simpleFoodItemId: $simpleFoodItemId, quantity: $quantity, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodItemComponentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.composedFoodItemId, composedFoodItemId) ||
                other.composedFoodItemId == composedFoodItemId) &&
            (identical(other.simpleFoodItemId, simpleFoodItemId) ||
                other.simpleFoodItemId == simpleFoodItemId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    composedFoodItemId,
    simpleFoodItemId,
    quantity,
    sortOrder,
  );

  /// Create a copy of FoodItemComponent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodItemComponentImplCopyWith<_$FoodItemComponentImpl> get copyWith =>
      __$$FoodItemComponentImplCopyWithImpl<_$FoodItemComponentImpl>(
        this,
        _$identity,
      );
}

abstract class _FoodItemComponent implements FoodItemComponent {
  const factory _FoodItemComponent({
    required final String id,
    required final String composedFoodItemId,
    required final String simpleFoodItemId,
    final double quantity,
    final int sortOrder,
  }) = _$FoodItemComponentImpl;

  @override
  String get id;
  @override
  String get composedFoodItemId;
  @override
  String get simpleFoodItemId;
  @override
  double get quantity; // Servings of Simple item used
  @override
  int get sortOrder;

  /// Create a copy of FoodItemComponent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodItemComponentImplCopyWith<_$FoodItemComponentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
