// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplement_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GetSupplementsInput {
  String get profileId => throw _privateConstructorUsedError;
  bool? get activeOnly => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;

  /// Create a copy of GetSupplementsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetSupplementsInputCopyWith<GetSupplementsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetSupplementsInputCopyWith<$Res> {
  factory $GetSupplementsInputCopyWith(
    GetSupplementsInput value,
    $Res Function(GetSupplementsInput) then,
  ) = _$GetSupplementsInputCopyWithImpl<$Res, GetSupplementsInput>;
  @useResult
  $Res call({String profileId, bool? activeOnly, int? limit, int? offset});
}

/// @nodoc
class _$GetSupplementsInputCopyWithImpl<$Res, $Val extends GetSupplementsInput>
    implements $GetSupplementsInputCopyWith<$Res> {
  _$GetSupplementsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetSupplementsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? activeOnly = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            activeOnly: freezed == activeOnly
                ? _value.activeOnly
                : activeOnly // ignore: cast_nullable_to_non_nullable
                      as bool?,
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
abstract class _$$GetSupplementsInputImplCopyWith<$Res>
    implements $GetSupplementsInputCopyWith<$Res> {
  factory _$$GetSupplementsInputImplCopyWith(
    _$GetSupplementsInputImpl value,
    $Res Function(_$GetSupplementsInputImpl) then,
  ) = __$$GetSupplementsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, bool? activeOnly, int? limit, int? offset});
}

/// @nodoc
class __$$GetSupplementsInputImplCopyWithImpl<$Res>
    extends _$GetSupplementsInputCopyWithImpl<$Res, _$GetSupplementsInputImpl>
    implements _$$GetSupplementsInputImplCopyWith<$Res> {
  __$$GetSupplementsInputImplCopyWithImpl(
    _$GetSupplementsInputImpl _value,
    $Res Function(_$GetSupplementsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetSupplementsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? activeOnly = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _$GetSupplementsInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        activeOnly: freezed == activeOnly
            ? _value.activeOnly
            : activeOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
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

class _$GetSupplementsInputImpl implements _GetSupplementsInput {
  const _$GetSupplementsInputImpl({
    required this.profileId,
    this.activeOnly,
    this.limit,
    this.offset,
  });

  @override
  final String profileId;
  @override
  final bool? activeOnly;
  @override
  final int? limit;
  @override
  final int? offset;

  @override
  String toString() {
    return 'GetSupplementsInput(profileId: $profileId, activeOnly: $activeOnly, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetSupplementsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.activeOnly, activeOnly) ||
                other.activeOnly == activeOnly) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, activeOnly, limit, offset);

  /// Create a copy of GetSupplementsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetSupplementsInputImplCopyWith<_$GetSupplementsInputImpl> get copyWith =>
      __$$GetSupplementsInputImplCopyWithImpl<_$GetSupplementsInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetSupplementsInput implements GetSupplementsInput {
  const factory _GetSupplementsInput({
    required final String profileId,
    final bool? activeOnly,
    final int? limit,
    final int? offset,
  }) = _$GetSupplementsInputImpl;

  @override
  String get profileId;
  @override
  bool? get activeOnly;
  @override
  int? get limit;
  @override
  int? get offset;

  /// Create a copy of GetSupplementsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetSupplementsInputImplCopyWith<_$GetSupplementsInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CreateSupplementInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  SupplementForm get form => throw _privateConstructorUsedError;
  String? get customForm => throw _privateConstructorUsedError;
  int get dosageQuantity => throw _privateConstructorUsedError;
  DosageUnit get dosageUnit => throw _privateConstructorUsedError;
  String? get customDosageUnit => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  List<SupplementIngredient> get ingredients =>
      throw _privateConstructorUsedError;
  List<SupplementSchedule> get schedules => throw _privateConstructorUsedError;
  int? get startDate => throw _privateConstructorUsedError;
  int? get endDate => throw _privateConstructorUsedError;

  /// Create a copy of CreateSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSupplementInputCopyWith<CreateSupplementInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSupplementInputCopyWith<$Res> {
  factory $CreateSupplementInputCopyWith(
    CreateSupplementInput value,
    $Res Function(CreateSupplementInput) then,
  ) = _$CreateSupplementInputCopyWithImpl<$Res, CreateSupplementInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String name,
    SupplementForm form,
    String? customForm,
    int dosageQuantity,
    DosageUnit dosageUnit,
    String? customDosageUnit,
    String brand,
    String notes,
    List<SupplementIngredient> ingredients,
    List<SupplementSchedule> schedules,
    int? startDate,
    int? endDate,
  });
}

/// @nodoc
class _$CreateSupplementInputCopyWithImpl<
  $Res,
  $Val extends CreateSupplementInput
>
    implements $CreateSupplementInputCopyWith<$Res> {
  _$CreateSupplementInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? name = null,
    Object? form = null,
    Object? customForm = freezed,
    Object? dosageQuantity = null,
    Object? dosageUnit = null,
    Object? customDosageUnit = freezed,
    Object? brand = null,
    Object? notes = null,
    Object? ingredients = null,
    Object? schedules = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            form: null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                      as SupplementForm,
            customForm: freezed == customForm
                ? _value.customForm
                : customForm // ignore: cast_nullable_to_non_nullable
                      as String?,
            dosageQuantity: null == dosageQuantity
                ? _value.dosageQuantity
                : dosageQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            dosageUnit: null == dosageUnit
                ? _value.dosageUnit
                : dosageUnit // ignore: cast_nullable_to_non_nullable
                      as DosageUnit,
            customDosageUnit: freezed == customDosageUnit
                ? _value.customDosageUnit
                : customDosageUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
            brand: null == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            ingredients: null == ingredients
                ? _value.ingredients
                : ingredients // ignore: cast_nullable_to_non_nullable
                      as List<SupplementIngredient>,
            schedules: null == schedules
                ? _value.schedules
                : schedules // ignore: cast_nullable_to_non_nullable
                      as List<SupplementSchedule>,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateSupplementInputImplCopyWith<$Res>
    implements $CreateSupplementInputCopyWith<$Res> {
  factory _$$CreateSupplementInputImplCopyWith(
    _$CreateSupplementInputImpl value,
    $Res Function(_$CreateSupplementInputImpl) then,
  ) = __$$CreateSupplementInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String name,
    SupplementForm form,
    String? customForm,
    int dosageQuantity,
    DosageUnit dosageUnit,
    String? customDosageUnit,
    String brand,
    String notes,
    List<SupplementIngredient> ingredients,
    List<SupplementSchedule> schedules,
    int? startDate,
    int? endDate,
  });
}

/// @nodoc
class __$$CreateSupplementInputImplCopyWithImpl<$Res>
    extends
        _$CreateSupplementInputCopyWithImpl<$Res, _$CreateSupplementInputImpl>
    implements _$$CreateSupplementInputImplCopyWith<$Res> {
  __$$CreateSupplementInputImplCopyWithImpl(
    _$CreateSupplementInputImpl _value,
    $Res Function(_$CreateSupplementInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? name = null,
    Object? form = null,
    Object? customForm = freezed,
    Object? dosageQuantity = null,
    Object? dosageUnit = null,
    Object? customDosageUnit = freezed,
    Object? brand = null,
    Object? notes = null,
    Object? ingredients = null,
    Object? schedules = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _$CreateSupplementInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        form: null == form
            ? _value.form
            : form // ignore: cast_nullable_to_non_nullable
                  as SupplementForm,
        customForm: freezed == customForm
            ? _value.customForm
            : customForm // ignore: cast_nullable_to_non_nullable
                  as String?,
        dosageQuantity: null == dosageQuantity
            ? _value.dosageQuantity
            : dosageQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        dosageUnit: null == dosageUnit
            ? _value.dosageUnit
            : dosageUnit // ignore: cast_nullable_to_non_nullable
                  as DosageUnit,
        customDosageUnit: freezed == customDosageUnit
            ? _value.customDosageUnit
            : customDosageUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
        brand: null == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        ingredients: null == ingredients
            ? _value._ingredients
            : ingredients // ignore: cast_nullable_to_non_nullable
                  as List<SupplementIngredient>,
        schedules: null == schedules
            ? _value._schedules
            : schedules // ignore: cast_nullable_to_non_nullable
                  as List<SupplementSchedule>,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$CreateSupplementInputImpl implements _CreateSupplementInput {
  const _$CreateSupplementInputImpl({
    required this.profileId,
    required this.clientId,
    required this.name,
    required this.form,
    this.customForm,
    required this.dosageQuantity,
    required this.dosageUnit,
    this.customDosageUnit,
    this.brand = '',
    this.notes = '',
    final List<SupplementIngredient> ingredients = const [],
    final List<SupplementSchedule> schedules = const [],
    this.startDate,
    this.endDate,
  }) : _ingredients = ingredients,
       _schedules = schedules;

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final String name;
  @override
  final SupplementForm form;
  @override
  final String? customForm;
  @override
  final int dosageQuantity;
  @override
  final DosageUnit dosageUnit;
  @override
  final String? customDosageUnit;
  @override
  @JsonKey()
  final String brand;
  @override
  @JsonKey()
  final String notes;
  final List<SupplementIngredient> _ingredients;
  @override
  @JsonKey()
  List<SupplementIngredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<SupplementSchedule> _schedules;
  @override
  @JsonKey()
  List<SupplementSchedule> get schedules {
    if (_schedules is EqualUnmodifiableListView) return _schedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedules);
  }

  @override
  final int? startDate;
  @override
  final int? endDate;

  @override
  String toString() {
    return 'CreateSupplementInput(profileId: $profileId, clientId: $clientId, name: $name, form: $form, customForm: $customForm, dosageQuantity: $dosageQuantity, dosageUnit: $dosageUnit, customDosageUnit: $customDosageUnit, brand: $brand, notes: $notes, ingredients: $ingredients, schedules: $schedules, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSupplementInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.customForm, customForm) ||
                other.customForm == customForm) &&
            (identical(other.dosageQuantity, dosageQuantity) ||
                other.dosageQuantity == dosageQuantity) &&
            (identical(other.dosageUnit, dosageUnit) ||
                other.dosageUnit == dosageUnit) &&
            (identical(other.customDosageUnit, customDosageUnit) ||
                other.customDosageUnit == customDosageUnit) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(
              other._ingredients,
              _ingredients,
            ) &&
            const DeepCollectionEquality().equals(
              other._schedules,
              _schedules,
            ) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    name,
    form,
    customForm,
    dosageQuantity,
    dosageUnit,
    customDosageUnit,
    brand,
    notes,
    const DeepCollectionEquality().hash(_ingredients),
    const DeepCollectionEquality().hash(_schedules),
    startDate,
    endDate,
  );

  /// Create a copy of CreateSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSupplementInputImplCopyWith<_$CreateSupplementInputImpl>
  get copyWith =>
      __$$CreateSupplementInputImplCopyWithImpl<_$CreateSupplementInputImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateSupplementInput implements CreateSupplementInput {
  const factory _CreateSupplementInput({
    required final String profileId,
    required final String clientId,
    required final String name,
    required final SupplementForm form,
    final String? customForm,
    required final int dosageQuantity,
    required final DosageUnit dosageUnit,
    final String? customDosageUnit,
    final String brand,
    final String notes,
    final List<SupplementIngredient> ingredients,
    final List<SupplementSchedule> schedules,
    final int? startDate,
    final int? endDate,
  }) = _$CreateSupplementInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  String get name;
  @override
  SupplementForm get form;
  @override
  String? get customForm;
  @override
  int get dosageQuantity;
  @override
  DosageUnit get dosageUnit;
  @override
  String? get customDosageUnit;
  @override
  String get brand;
  @override
  String get notes;
  @override
  List<SupplementIngredient> get ingredients;
  @override
  List<SupplementSchedule> get schedules;
  @override
  int? get startDate;
  @override
  int? get endDate;

  /// Create a copy of CreateSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSupplementInputImplCopyWith<_$CreateSupplementInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateSupplementInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  SupplementForm? get form => throw _privateConstructorUsedError;
  String? get customForm => throw _privateConstructorUsedError;
  int? get dosageQuantity => throw _privateConstructorUsedError;
  DosageUnit? get dosageUnit => throw _privateConstructorUsedError;
  String? get customDosageUnit => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<SupplementIngredient>? get ingredients =>
      throw _privateConstructorUsedError;
  List<SupplementSchedule>? get schedules => throw _privateConstructorUsedError;
  int? get startDate => throw _privateConstructorUsedError;
  int? get endDate => throw _privateConstructorUsedError;
  bool? get isArchived => throw _privateConstructorUsedError;

  /// Create a copy of UpdateSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateSupplementInputCopyWith<UpdateSupplementInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateSupplementInputCopyWith<$Res> {
  factory $UpdateSupplementInputCopyWith(
    UpdateSupplementInput value,
    $Res Function(UpdateSupplementInput) then,
  ) = _$UpdateSupplementInputCopyWithImpl<$Res, UpdateSupplementInput>;
  @useResult
  $Res call({
    String id,
    String profileId,
    String? name,
    SupplementForm? form,
    String? customForm,
    int? dosageQuantity,
    DosageUnit? dosageUnit,
    String? customDosageUnit,
    String? brand,
    String? notes,
    List<SupplementIngredient>? ingredients,
    List<SupplementSchedule>? schedules,
    int? startDate,
    int? endDate,
    bool? isArchived,
  });
}

/// @nodoc
class _$UpdateSupplementInputCopyWithImpl<
  $Res,
  $Val extends UpdateSupplementInput
>
    implements $UpdateSupplementInputCopyWith<$Res> {
  _$UpdateSupplementInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? name = freezed,
    Object? form = freezed,
    Object? customForm = freezed,
    Object? dosageQuantity = freezed,
    Object? dosageUnit = freezed,
    Object? customDosageUnit = freezed,
    Object? brand = freezed,
    Object? notes = freezed,
    Object? ingredients = freezed,
    Object? schedules = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isArchived = freezed,
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
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            form: freezed == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                      as SupplementForm?,
            customForm: freezed == customForm
                ? _value.customForm
                : customForm // ignore: cast_nullable_to_non_nullable
                      as String?,
            dosageQuantity: freezed == dosageQuantity
                ? _value.dosageQuantity
                : dosageQuantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            dosageUnit: freezed == dosageUnit
                ? _value.dosageUnit
                : dosageUnit // ignore: cast_nullable_to_non_nullable
                      as DosageUnit?,
            customDosageUnit: freezed == customDosageUnit
                ? _value.customDosageUnit
                : customDosageUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            ingredients: freezed == ingredients
                ? _value.ingredients
                : ingredients // ignore: cast_nullable_to_non_nullable
                      as List<SupplementIngredient>?,
            schedules: freezed == schedules
                ? _value.schedules
                : schedules // ignore: cast_nullable_to_non_nullable
                      as List<SupplementSchedule>?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            isArchived: freezed == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateSupplementInputImplCopyWith<$Res>
    implements $UpdateSupplementInputCopyWith<$Res> {
  factory _$$UpdateSupplementInputImplCopyWith(
    _$UpdateSupplementInputImpl value,
    $Res Function(_$UpdateSupplementInputImpl) then,
  ) = __$$UpdateSupplementInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    String? name,
    SupplementForm? form,
    String? customForm,
    int? dosageQuantity,
    DosageUnit? dosageUnit,
    String? customDosageUnit,
    String? brand,
    String? notes,
    List<SupplementIngredient>? ingredients,
    List<SupplementSchedule>? schedules,
    int? startDate,
    int? endDate,
    bool? isArchived,
  });
}

/// @nodoc
class __$$UpdateSupplementInputImplCopyWithImpl<$Res>
    extends
        _$UpdateSupplementInputCopyWithImpl<$Res, _$UpdateSupplementInputImpl>
    implements _$$UpdateSupplementInputImplCopyWith<$Res> {
  __$$UpdateSupplementInputImplCopyWithImpl(
    _$UpdateSupplementInputImpl _value,
    $Res Function(_$UpdateSupplementInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? name = freezed,
    Object? form = freezed,
    Object? customForm = freezed,
    Object? dosageQuantity = freezed,
    Object? dosageUnit = freezed,
    Object? customDosageUnit = freezed,
    Object? brand = freezed,
    Object? notes = freezed,
    Object? ingredients = freezed,
    Object? schedules = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isArchived = freezed,
  }) {
    return _then(
      _$UpdateSupplementInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        form: freezed == form
            ? _value.form
            : form // ignore: cast_nullable_to_non_nullable
                  as SupplementForm?,
        customForm: freezed == customForm
            ? _value.customForm
            : customForm // ignore: cast_nullable_to_non_nullable
                  as String?,
        dosageQuantity: freezed == dosageQuantity
            ? _value.dosageQuantity
            : dosageQuantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        dosageUnit: freezed == dosageUnit
            ? _value.dosageUnit
            : dosageUnit // ignore: cast_nullable_to_non_nullable
                  as DosageUnit?,
        customDosageUnit: freezed == customDosageUnit
            ? _value.customDosageUnit
            : customDosageUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        ingredients: freezed == ingredients
            ? _value._ingredients
            : ingredients // ignore: cast_nullable_to_non_nullable
                  as List<SupplementIngredient>?,
        schedules: freezed == schedules
            ? _value._schedules
            : schedules // ignore: cast_nullable_to_non_nullable
                  as List<SupplementSchedule>?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        isArchived: freezed == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateSupplementInputImpl implements _UpdateSupplementInput {
  const _$UpdateSupplementInputImpl({
    required this.id,
    required this.profileId,
    this.name,
    this.form,
    this.customForm,
    this.dosageQuantity,
    this.dosageUnit,
    this.customDosageUnit,
    this.brand,
    this.notes,
    final List<SupplementIngredient>? ingredients,
    final List<SupplementSchedule>? schedules,
    this.startDate,
    this.endDate,
    this.isArchived,
  }) : _ingredients = ingredients,
       _schedules = schedules;

  @override
  final String id;
  @override
  final String profileId;
  @override
  final String? name;
  @override
  final SupplementForm? form;
  @override
  final String? customForm;
  @override
  final int? dosageQuantity;
  @override
  final DosageUnit? dosageUnit;
  @override
  final String? customDosageUnit;
  @override
  final String? brand;
  @override
  final String? notes;
  final List<SupplementIngredient>? _ingredients;
  @override
  List<SupplementIngredient>? get ingredients {
    final value = _ingredients;
    if (value == null) return null;
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SupplementSchedule>? _schedules;
  @override
  List<SupplementSchedule>? get schedules {
    final value = _schedules;
    if (value == null) return null;
    if (_schedules is EqualUnmodifiableListView) return _schedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? startDate;
  @override
  final int? endDate;
  @override
  final bool? isArchived;

  @override
  String toString() {
    return 'UpdateSupplementInput(id: $id, profileId: $profileId, name: $name, form: $form, customForm: $customForm, dosageQuantity: $dosageQuantity, dosageUnit: $dosageUnit, customDosageUnit: $customDosageUnit, brand: $brand, notes: $notes, ingredients: $ingredients, schedules: $schedules, startDate: $startDate, endDate: $endDate, isArchived: $isArchived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSupplementInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.customForm, customForm) ||
                other.customForm == customForm) &&
            (identical(other.dosageQuantity, dosageQuantity) ||
                other.dosageQuantity == dosageQuantity) &&
            (identical(other.dosageUnit, dosageUnit) ||
                other.dosageUnit == dosageUnit) &&
            (identical(other.customDosageUnit, customDosageUnit) ||
                other.customDosageUnit == customDosageUnit) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(
              other._ingredients,
              _ingredients,
            ) &&
            const DeepCollectionEquality().equals(
              other._schedules,
              _schedules,
            ) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    name,
    form,
    customForm,
    dosageQuantity,
    dosageUnit,
    customDosageUnit,
    brand,
    notes,
    const DeepCollectionEquality().hash(_ingredients),
    const DeepCollectionEquality().hash(_schedules),
    startDate,
    endDate,
    isArchived,
  );

  /// Create a copy of UpdateSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSupplementInputImplCopyWith<_$UpdateSupplementInputImpl>
  get copyWith =>
      __$$UpdateSupplementInputImplCopyWithImpl<_$UpdateSupplementInputImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateSupplementInput implements UpdateSupplementInput {
  const factory _UpdateSupplementInput({
    required final String id,
    required final String profileId,
    final String? name,
    final SupplementForm? form,
    final String? customForm,
    final int? dosageQuantity,
    final DosageUnit? dosageUnit,
    final String? customDosageUnit,
    final String? brand,
    final String? notes,
    final List<SupplementIngredient>? ingredients,
    final List<SupplementSchedule>? schedules,
    final int? startDate,
    final int? endDate,
    final bool? isArchived,
  }) = _$UpdateSupplementInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  String? get name;
  @override
  SupplementForm? get form;
  @override
  String? get customForm;
  @override
  int? get dosageQuantity;
  @override
  DosageUnit? get dosageUnit;
  @override
  String? get customDosageUnit;
  @override
  String? get brand;
  @override
  String? get notes;
  @override
  List<SupplementIngredient>? get ingredients;
  @override
  List<SupplementSchedule>? get schedules;
  @override
  int? get startDate;
  @override
  int? get endDate;
  @override
  bool? get isArchived;

  /// Create a copy of UpdateSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSupplementInputImplCopyWith<_$UpdateSupplementInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ArchiveSupplementInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  bool get archive => throw _privateConstructorUsedError;

  /// Create a copy of ArchiveSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArchiveSupplementInputCopyWith<ArchiveSupplementInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchiveSupplementInputCopyWith<$Res> {
  factory $ArchiveSupplementInputCopyWith(
    ArchiveSupplementInput value,
    $Res Function(ArchiveSupplementInput) then,
  ) = _$ArchiveSupplementInputCopyWithImpl<$Res, ArchiveSupplementInput>;
  @useResult
  $Res call({String id, String profileId, bool archive});
}

/// @nodoc
class _$ArchiveSupplementInputCopyWithImpl<
  $Res,
  $Val extends ArchiveSupplementInput
>
    implements $ArchiveSupplementInputCopyWith<$Res> {
  _$ArchiveSupplementInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArchiveSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? archive = null,
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
            archive: null == archive
                ? _value.archive
                : archive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArchiveSupplementInputImplCopyWith<$Res>
    implements $ArchiveSupplementInputCopyWith<$Res> {
  factory _$$ArchiveSupplementInputImplCopyWith(
    _$ArchiveSupplementInputImpl value,
    $Res Function(_$ArchiveSupplementInputImpl) then,
  ) = __$$ArchiveSupplementInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId, bool archive});
}

/// @nodoc
class __$$ArchiveSupplementInputImplCopyWithImpl<$Res>
    extends
        _$ArchiveSupplementInputCopyWithImpl<$Res, _$ArchiveSupplementInputImpl>
    implements _$$ArchiveSupplementInputImplCopyWith<$Res> {
  __$$ArchiveSupplementInputImplCopyWithImpl(
    _$ArchiveSupplementInputImpl _value,
    $Res Function(_$ArchiveSupplementInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArchiveSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? archive = null,
  }) {
    return _then(
      _$ArchiveSupplementInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        archive: null == archive
            ? _value.archive
            : archive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ArchiveSupplementInputImpl implements _ArchiveSupplementInput {
  const _$ArchiveSupplementInputImpl({
    required this.id,
    required this.profileId,
    required this.archive,
  });

  @override
  final String id;
  @override
  final String profileId;
  @override
  final bool archive;

  @override
  String toString() {
    return 'ArchiveSupplementInput(id: $id, profileId: $profileId, archive: $archive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchiveSupplementInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.archive, archive) || other.archive == archive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId, archive);

  /// Create a copy of ArchiveSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchiveSupplementInputImplCopyWith<_$ArchiveSupplementInputImpl>
  get copyWith =>
      __$$ArchiveSupplementInputImplCopyWithImpl<_$ArchiveSupplementInputImpl>(
        this,
        _$identity,
      );
}

abstract class _ArchiveSupplementInput implements ArchiveSupplementInput {
  const factory _ArchiveSupplementInput({
    required final String id,
    required final String profileId,
    required final bool archive,
  }) = _$ArchiveSupplementInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  bool get archive;

  /// Create a copy of ArchiveSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArchiveSupplementInputImplCopyWith<_$ArchiveSupplementInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeleteSupplementInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of DeleteSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteSupplementInputCopyWith<DeleteSupplementInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteSupplementInputCopyWith<$Res> {
  factory $DeleteSupplementInputCopyWith(
    DeleteSupplementInput value,
    $Res Function(DeleteSupplementInput) then,
  ) = _$DeleteSupplementInputCopyWithImpl<$Res, DeleteSupplementInput>;
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class _$DeleteSupplementInputCopyWithImpl<
  $Res,
  $Val extends DeleteSupplementInput
>
    implements $DeleteSupplementInputCopyWith<$Res> {
  _$DeleteSupplementInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteSupplementInput
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
abstract class _$$DeleteSupplementInputImplCopyWith<$Res>
    implements $DeleteSupplementInputCopyWith<$Res> {
  factory _$$DeleteSupplementInputImplCopyWith(
    _$DeleteSupplementInputImpl value,
    $Res Function(_$DeleteSupplementInputImpl) then,
  ) = __$$DeleteSupplementInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class __$$DeleteSupplementInputImplCopyWithImpl<$Res>
    extends
        _$DeleteSupplementInputCopyWithImpl<$Res, _$DeleteSupplementInputImpl>
    implements _$$DeleteSupplementInputImplCopyWith<$Res> {
  __$$DeleteSupplementInputImplCopyWithImpl(
    _$DeleteSupplementInputImpl _value,
    $Res Function(_$DeleteSupplementInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? profileId = null}) {
    return _then(
      _$DeleteSupplementInputImpl(
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

class _$DeleteSupplementInputImpl implements _DeleteSupplementInput {
  const _$DeleteSupplementInputImpl({
    required this.id,
    required this.profileId,
  });

  @override
  final String id;
  @override
  final String profileId;

  @override
  String toString() {
    return 'DeleteSupplementInput(id: $id, profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteSupplementInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId);

  /// Create a copy of DeleteSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteSupplementInputImplCopyWith<_$DeleteSupplementInputImpl>
  get copyWith =>
      __$$DeleteSupplementInputImplCopyWithImpl<_$DeleteSupplementInputImpl>(
        this,
        _$identity,
      );
}

abstract class _DeleteSupplementInput implements DeleteSupplementInput {
  const factory _DeleteSupplementInput({
    required final String id,
    required final String profileId,
  }) = _$DeleteSupplementInputImpl;

  @override
  String get id;
  @override
  String get profileId;

  /// Create a copy of DeleteSupplementInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteSupplementInputImplCopyWith<_$DeleteSupplementInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}
