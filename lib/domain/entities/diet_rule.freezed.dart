// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DietRule {
  String get id => throw _privateConstructorUsedError;
  String get dietId => throw _privateConstructorUsedError;
  DietRuleType get ruleType =>
      throw _privateConstructorUsedError; // What this rule applies to — only one of these is set per rule
  String? get targetFoodItemId =>
      throw _privateConstructorUsedError; // Specific food item ID
  String? get targetCategory =>
      throw _privateConstructorUsedError; // Food category (e.g. "dairy", "grains")
  String? get targetIngredient =>
      throw _privateConstructorUsedError; // Specific ingredient text (free-text)
  // Quantity constraints (for Limited and Required rule types)
  double? get minValue => throw _privateConstructorUsedError;
  double? get maxValue => throw _privateConstructorUsedError;
  String? get unit =>
      throw _privateConstructorUsedError; // "grams", "servings", "percent", "hours", "minutes"
  String? get frequency =>
      throw _privateConstructorUsedError; // "per_meal", "per_day", "per_week"
  // For time-based rules: minutes from midnight (e.g. 480 = 8:00 AM)
  int? get timeValue => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Create a copy of DietRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DietRuleCopyWith<DietRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DietRuleCopyWith<$Res> {
  factory $DietRuleCopyWith(DietRule value, $Res Function(DietRule) then) =
      _$DietRuleCopyWithImpl<$Res, DietRule>;
  @useResult
  $Res call({
    String id,
    String dietId,
    DietRuleType ruleType,
    String? targetFoodItemId,
    String? targetCategory,
    String? targetIngredient,
    double? minValue,
    double? maxValue,
    String? unit,
    String? frequency,
    int? timeValue,
    int sortOrder,
  });
}

/// @nodoc
class _$DietRuleCopyWithImpl<$Res, $Val extends DietRule>
    implements $DietRuleCopyWith<$Res> {
  _$DietRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DietRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dietId = null,
    Object? ruleType = null,
    Object? targetFoodItemId = freezed,
    Object? targetCategory = freezed,
    Object? targetIngredient = freezed,
    Object? minValue = freezed,
    Object? maxValue = freezed,
    Object? unit = freezed,
    Object? frequency = freezed,
    Object? timeValue = freezed,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            dietId: null == dietId
                ? _value.dietId
                : dietId // ignore: cast_nullable_to_non_nullable
                      as String,
            ruleType: null == ruleType
                ? _value.ruleType
                : ruleType // ignore: cast_nullable_to_non_nullable
                      as DietRuleType,
            targetFoodItemId: freezed == targetFoodItemId
                ? _value.targetFoodItemId
                : targetFoodItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetCategory: freezed == targetCategory
                ? _value.targetCategory
                : targetCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetIngredient: freezed == targetIngredient
                ? _value.targetIngredient
                : targetIngredient // ignore: cast_nullable_to_non_nullable
                      as String?,
            minValue: freezed == minValue
                ? _value.minValue
                : minValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxValue: freezed == maxValue
                ? _value.maxValue
                : maxValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
            frequency: freezed == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as String?,
            timeValue: freezed == timeValue
                ? _value.timeValue
                : timeValue // ignore: cast_nullable_to_non_nullable
                      as int?,
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
abstract class _$$DietRuleImplCopyWith<$Res>
    implements $DietRuleCopyWith<$Res> {
  factory _$$DietRuleImplCopyWith(
    _$DietRuleImpl value,
    $Res Function(_$DietRuleImpl) then,
  ) = __$$DietRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String dietId,
    DietRuleType ruleType,
    String? targetFoodItemId,
    String? targetCategory,
    String? targetIngredient,
    double? minValue,
    double? maxValue,
    String? unit,
    String? frequency,
    int? timeValue,
    int sortOrder,
  });
}

/// @nodoc
class __$$DietRuleImplCopyWithImpl<$Res>
    extends _$DietRuleCopyWithImpl<$Res, _$DietRuleImpl>
    implements _$$DietRuleImplCopyWith<$Res> {
  __$$DietRuleImplCopyWithImpl(
    _$DietRuleImpl _value,
    $Res Function(_$DietRuleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DietRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dietId = null,
    Object? ruleType = null,
    Object? targetFoodItemId = freezed,
    Object? targetCategory = freezed,
    Object? targetIngredient = freezed,
    Object? minValue = freezed,
    Object? maxValue = freezed,
    Object? unit = freezed,
    Object? frequency = freezed,
    Object? timeValue = freezed,
    Object? sortOrder = null,
  }) {
    return _then(
      _$DietRuleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        dietId: null == dietId
            ? _value.dietId
            : dietId // ignore: cast_nullable_to_non_nullable
                  as String,
        ruleType: null == ruleType
            ? _value.ruleType
            : ruleType // ignore: cast_nullable_to_non_nullable
                  as DietRuleType,
        targetFoodItemId: freezed == targetFoodItemId
            ? _value.targetFoodItemId
            : targetFoodItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetCategory: freezed == targetCategory
            ? _value.targetCategory
            : targetCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetIngredient: freezed == targetIngredient
            ? _value.targetIngredient
            : targetIngredient // ignore: cast_nullable_to_non_nullable
                  as String?,
        minValue: freezed == minValue
            ? _value.minValue
            : minValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxValue: freezed == maxValue
            ? _value.maxValue
            : maxValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
        frequency: freezed == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String?,
        timeValue: freezed == timeValue
            ? _value.timeValue
            : timeValue // ignore: cast_nullable_to_non_nullable
                  as int?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DietRuleImpl implements _DietRule {
  const _$DietRuleImpl({
    required this.id,
    required this.dietId,
    required this.ruleType,
    this.targetFoodItemId,
    this.targetCategory,
    this.targetIngredient,
    this.minValue,
    this.maxValue,
    this.unit,
    this.frequency,
    this.timeValue,
    this.sortOrder = 0,
  });

  @override
  final String id;
  @override
  final String dietId;
  @override
  final DietRuleType ruleType;
  // What this rule applies to — only one of these is set per rule
  @override
  final String? targetFoodItemId;
  // Specific food item ID
  @override
  final String? targetCategory;
  // Food category (e.g. "dairy", "grains")
  @override
  final String? targetIngredient;
  // Specific ingredient text (free-text)
  // Quantity constraints (for Limited and Required rule types)
  @override
  final double? minValue;
  @override
  final double? maxValue;
  @override
  final String? unit;
  // "grams", "servings", "percent", "hours", "minutes"
  @override
  final String? frequency;
  // "per_meal", "per_day", "per_week"
  // For time-based rules: minutes from midnight (e.g. 480 = 8:00 AM)
  @override
  final int? timeValue;
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'DietRule(id: $id, dietId: $dietId, ruleType: $ruleType, targetFoodItemId: $targetFoodItemId, targetCategory: $targetCategory, targetIngredient: $targetIngredient, minValue: $minValue, maxValue: $maxValue, unit: $unit, frequency: $frequency, timeValue: $timeValue, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DietRuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dietId, dietId) || other.dietId == dietId) &&
            (identical(other.ruleType, ruleType) ||
                other.ruleType == ruleType) &&
            (identical(other.targetFoodItemId, targetFoodItemId) ||
                other.targetFoodItemId == targetFoodItemId) &&
            (identical(other.targetCategory, targetCategory) ||
                other.targetCategory == targetCategory) &&
            (identical(other.targetIngredient, targetIngredient) ||
                other.targetIngredient == targetIngredient) &&
            (identical(other.minValue, minValue) ||
                other.minValue == minValue) &&
            (identical(other.maxValue, maxValue) ||
                other.maxValue == maxValue) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.timeValue, timeValue) ||
                other.timeValue == timeValue) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    dietId,
    ruleType,
    targetFoodItemId,
    targetCategory,
    targetIngredient,
    minValue,
    maxValue,
    unit,
    frequency,
    timeValue,
    sortOrder,
  );

  /// Create a copy of DietRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DietRuleImplCopyWith<_$DietRuleImpl> get copyWith =>
      __$$DietRuleImplCopyWithImpl<_$DietRuleImpl>(this, _$identity);
}

abstract class _DietRule implements DietRule {
  const factory _DietRule({
    required final String id,
    required final String dietId,
    required final DietRuleType ruleType,
    final String? targetFoodItemId,
    final String? targetCategory,
    final String? targetIngredient,
    final double? minValue,
    final double? maxValue,
    final String? unit,
    final String? frequency,
    final int? timeValue,
    final int sortOrder,
  }) = _$DietRuleImpl;

  @override
  String get id;
  @override
  String get dietId;
  @override
  DietRuleType get ruleType; // What this rule applies to — only one of these is set per rule
  @override
  String? get targetFoodItemId; // Specific food item ID
  @override
  String? get targetCategory; // Food category (e.g. "dairy", "grains")
  @override
  String? get targetIngredient; // Specific ingredient text (free-text)
  // Quantity constraints (for Limited and Required rule types)
  @override
  double? get minValue;
  @override
  double? get maxValue;
  @override
  String? get unit; // "grams", "servings", "percent", "hours", "minutes"
  @override
  String? get frequency; // "per_meal", "per_day", "per_week"
  // For time-based rules: minutes from midnight (e.g. 480 = 8:00 AM)
  @override
  int? get timeValue;
  @override
  int get sortOrder;

  /// Create a copy of DietRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DietRuleImplCopyWith<_$DietRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
