// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Supplement _$SupplementFromJson(Map<String, dynamic> json) {
  return _Supplement.fromJson(json);
}

/// @nodoc
mixin _$Supplement {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
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
  bool get isArchived => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this Supplement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Supplement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupplementCopyWith<Supplement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplementCopyWith<$Res> {
  factory $SupplementCopyWith(
    Supplement value,
    $Res Function(Supplement) then,
  ) = _$SupplementCopyWithImpl<$Res, Supplement>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
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
    bool isArchived,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$SupplementCopyWithImpl<$Res, $Val extends Supplement>
    implements $SupplementCopyWith<$Res> {
  _$SupplementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Supplement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
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

  /// Create a copy of Supplement
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
abstract class _$$SupplementImplCopyWith<$Res>
    implements $SupplementCopyWith<$Res> {
  factory _$$SupplementImplCopyWith(
    _$SupplementImpl value,
    $Res Function(_$SupplementImpl) then,
  ) = __$$SupplementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
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
    bool isArchived,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$SupplementImplCopyWithImpl<$Res>
    extends _$SupplementCopyWithImpl<$Res, _$SupplementImpl>
    implements _$$SupplementImplCopyWith<$Res> {
  __$$SupplementImplCopyWithImpl(
    _$SupplementImpl _value,
    $Res Function(_$SupplementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Supplement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
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
    Object? isArchived = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$SupplementImpl(
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
class _$SupplementImpl extends _Supplement {
  const _$SupplementImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
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
    this.isArchived = false,
    required this.syncMetadata,
  }) : _ingredients = ingredients,
       _schedules = schedules,
       super._();

  factory _$SupplementImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupplementImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
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
  @JsonKey()
  final bool isArchived;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'Supplement(id: $id, clientId: $clientId, profileId: $profileId, name: $name, form: $form, customForm: $customForm, dosageQuantity: $dosageQuantity, dosageUnit: $dosageUnit, customDosageUnit: $customDosageUnit, brand: $brand, notes: $notes, ingredients: $ingredients, schedules: $schedules, startDate: $startDate, endDate: $endDate, isArchived: $isArchived, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
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
    syncMetadata,
  );

  /// Create a copy of Supplement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplementImplCopyWith<_$SupplementImpl> get copyWith =>
      __$$SupplementImplCopyWithImpl<_$SupplementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupplementImplToJson(this);
  }
}

abstract class _Supplement extends Supplement {
  const factory _Supplement({
    required final String id,
    required final String clientId,
    required final String profileId,
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
    final bool isArchived,
    required final SyncMetadata syncMetadata,
  }) = _$SupplementImpl;
  const _Supplement._() : super._();

  factory _Supplement.fromJson(Map<String, dynamic> json) =
      _$SupplementImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
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
  @override
  bool get isArchived;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of Supplement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupplementImplCopyWith<_$SupplementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SupplementIngredient _$SupplementIngredientFromJson(Map<String, dynamic> json) {
  return _SupplementIngredient.fromJson(json);
}

/// @nodoc
mixin _$SupplementIngredient {
  String get name => throw _privateConstructorUsedError;
  double? get quantity => throw _privateConstructorUsedError;
  DosageUnit? get unit => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this SupplementIngredient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SupplementIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupplementIngredientCopyWith<SupplementIngredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplementIngredientCopyWith<$Res> {
  factory $SupplementIngredientCopyWith(
    SupplementIngredient value,
    $Res Function(SupplementIngredient) then,
  ) = _$SupplementIngredientCopyWithImpl<$Res, SupplementIngredient>;
  @useResult
  $Res call({String name, double? quantity, DosageUnit? unit, String? notes});
}

/// @nodoc
class _$SupplementIngredientCopyWithImpl<
  $Res,
  $Val extends SupplementIngredient
>
    implements $SupplementIngredientCopyWith<$Res> {
  _$SupplementIngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupplementIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double?,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as DosageUnit?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SupplementIngredientImplCopyWith<$Res>
    implements $SupplementIngredientCopyWith<$Res> {
  factory _$$SupplementIngredientImplCopyWith(
    _$SupplementIngredientImpl value,
    $Res Function(_$SupplementIngredientImpl) then,
  ) = __$$SupplementIngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double? quantity, DosageUnit? unit, String? notes});
}

/// @nodoc
class __$$SupplementIngredientImplCopyWithImpl<$Res>
    extends _$SupplementIngredientCopyWithImpl<$Res, _$SupplementIngredientImpl>
    implements _$$SupplementIngredientImplCopyWith<$Res> {
  __$$SupplementIngredientImplCopyWithImpl(
    _$SupplementIngredientImpl _value,
    $Res Function(_$SupplementIngredientImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupplementIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$SupplementIngredientImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double?,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as DosageUnit?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SupplementIngredientImpl extends _SupplementIngredient {
  const _$SupplementIngredientImpl({
    required this.name,
    this.quantity,
    this.unit,
    this.notes,
  }) : super._();

  factory _$SupplementIngredientImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupplementIngredientImplFromJson(json);

  @override
  final String name;
  @override
  final double? quantity;
  @override
  final DosageUnit? unit;
  @override
  final String? notes;

  @override
  String toString() {
    return 'SupplementIngredient(name: $name, quantity: $quantity, unit: $unit, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplementIngredientImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, quantity, unit, notes);

  /// Create a copy of SupplementIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplementIngredientImplCopyWith<_$SupplementIngredientImpl>
  get copyWith =>
      __$$SupplementIngredientImplCopyWithImpl<_$SupplementIngredientImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SupplementIngredientImplToJson(this);
  }
}

abstract class _SupplementIngredient extends SupplementIngredient {
  const factory _SupplementIngredient({
    required final String name,
    final double? quantity,
    final DosageUnit? unit,
    final String? notes,
  }) = _$SupplementIngredientImpl;
  const _SupplementIngredient._() : super._();

  factory _SupplementIngredient.fromJson(Map<String, dynamic> json) =
      _$SupplementIngredientImpl.fromJson;

  @override
  String get name;
  @override
  double? get quantity;
  @override
  DosageUnit? get unit;
  @override
  String? get notes;

  /// Create a copy of SupplementIngredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupplementIngredientImplCopyWith<_$SupplementIngredientImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SupplementSchedule _$SupplementScheduleFromJson(Map<String, dynamic> json) {
  return _SupplementSchedule.fromJson(json);
}

/// @nodoc
mixin _$SupplementSchedule {
  SupplementAnchorEvent get anchorEvent => throw _privateConstructorUsedError;
  SupplementTimingType get timingType => throw _privateConstructorUsedError;
  int get offsetMinutes => throw _privateConstructorUsedError;
  int? get specificTimeMinutes => throw _privateConstructorUsedError;
  SupplementFrequencyType get frequencyType =>
      throw _privateConstructorUsedError;
  int get everyXDays => throw _privateConstructorUsedError;
  List<int> get weekdays => throw _privateConstructorUsedError;

  /// Serializes this SupplementSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SupplementSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupplementScheduleCopyWith<SupplementSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplementScheduleCopyWith<$Res> {
  factory $SupplementScheduleCopyWith(
    SupplementSchedule value,
    $Res Function(SupplementSchedule) then,
  ) = _$SupplementScheduleCopyWithImpl<$Res, SupplementSchedule>;
  @useResult
  $Res call({
    SupplementAnchorEvent anchorEvent,
    SupplementTimingType timingType,
    int offsetMinutes,
    int? specificTimeMinutes,
    SupplementFrequencyType frequencyType,
    int everyXDays,
    List<int> weekdays,
  });
}

/// @nodoc
class _$SupplementScheduleCopyWithImpl<$Res, $Val extends SupplementSchedule>
    implements $SupplementScheduleCopyWith<$Res> {
  _$SupplementScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupplementSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? anchorEvent = null,
    Object? timingType = null,
    Object? offsetMinutes = null,
    Object? specificTimeMinutes = freezed,
    Object? frequencyType = null,
    Object? everyXDays = null,
    Object? weekdays = null,
  }) {
    return _then(
      _value.copyWith(
            anchorEvent: null == anchorEvent
                ? _value.anchorEvent
                : anchorEvent // ignore: cast_nullable_to_non_nullable
                      as SupplementAnchorEvent,
            timingType: null == timingType
                ? _value.timingType
                : timingType // ignore: cast_nullable_to_non_nullable
                      as SupplementTimingType,
            offsetMinutes: null == offsetMinutes
                ? _value.offsetMinutes
                : offsetMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            specificTimeMinutes: freezed == specificTimeMinutes
                ? _value.specificTimeMinutes
                : specificTimeMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            frequencyType: null == frequencyType
                ? _value.frequencyType
                : frequencyType // ignore: cast_nullable_to_non_nullable
                      as SupplementFrequencyType,
            everyXDays: null == everyXDays
                ? _value.everyXDays
                : everyXDays // ignore: cast_nullable_to_non_nullable
                      as int,
            weekdays: null == weekdays
                ? _value.weekdays
                : weekdays // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SupplementScheduleImplCopyWith<$Res>
    implements $SupplementScheduleCopyWith<$Res> {
  factory _$$SupplementScheduleImplCopyWith(
    _$SupplementScheduleImpl value,
    $Res Function(_$SupplementScheduleImpl) then,
  ) = __$$SupplementScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SupplementAnchorEvent anchorEvent,
    SupplementTimingType timingType,
    int offsetMinutes,
    int? specificTimeMinutes,
    SupplementFrequencyType frequencyType,
    int everyXDays,
    List<int> weekdays,
  });
}

/// @nodoc
class __$$SupplementScheduleImplCopyWithImpl<$Res>
    extends _$SupplementScheduleCopyWithImpl<$Res, _$SupplementScheduleImpl>
    implements _$$SupplementScheduleImplCopyWith<$Res> {
  __$$SupplementScheduleImplCopyWithImpl(
    _$SupplementScheduleImpl _value,
    $Res Function(_$SupplementScheduleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupplementSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? anchorEvent = null,
    Object? timingType = null,
    Object? offsetMinutes = null,
    Object? specificTimeMinutes = freezed,
    Object? frequencyType = null,
    Object? everyXDays = null,
    Object? weekdays = null,
  }) {
    return _then(
      _$SupplementScheduleImpl(
        anchorEvent: null == anchorEvent
            ? _value.anchorEvent
            : anchorEvent // ignore: cast_nullable_to_non_nullable
                  as SupplementAnchorEvent,
        timingType: null == timingType
            ? _value.timingType
            : timingType // ignore: cast_nullable_to_non_nullable
                  as SupplementTimingType,
        offsetMinutes: null == offsetMinutes
            ? _value.offsetMinutes
            : offsetMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        specificTimeMinutes: freezed == specificTimeMinutes
            ? _value.specificTimeMinutes
            : specificTimeMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        frequencyType: null == frequencyType
            ? _value.frequencyType
            : frequencyType // ignore: cast_nullable_to_non_nullable
                  as SupplementFrequencyType,
        everyXDays: null == everyXDays
            ? _value.everyXDays
            : everyXDays // ignore: cast_nullable_to_non_nullable
                  as int,
        weekdays: null == weekdays
            ? _value._weekdays
            : weekdays // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SupplementScheduleImpl extends _SupplementSchedule {
  const _$SupplementScheduleImpl({
    required this.anchorEvent,
    required this.timingType,
    this.offsetMinutes = 0,
    this.specificTimeMinutes,
    required this.frequencyType,
    this.everyXDays = 1,
    final List<int> weekdays = const [0, 1, 2, 3, 4, 5, 6],
  }) : _weekdays = weekdays,
       super._();

  factory _$SupplementScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupplementScheduleImplFromJson(json);

  @override
  final SupplementAnchorEvent anchorEvent;
  @override
  final SupplementTimingType timingType;
  @override
  @JsonKey()
  final int offsetMinutes;
  @override
  final int? specificTimeMinutes;
  @override
  final SupplementFrequencyType frequencyType;
  @override
  @JsonKey()
  final int everyXDays;
  final List<int> _weekdays;
  @override
  @JsonKey()
  List<int> get weekdays {
    if (_weekdays is EqualUnmodifiableListView) return _weekdays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekdays);
  }

  @override
  String toString() {
    return 'SupplementSchedule(anchorEvent: $anchorEvent, timingType: $timingType, offsetMinutes: $offsetMinutes, specificTimeMinutes: $specificTimeMinutes, frequencyType: $frequencyType, everyXDays: $everyXDays, weekdays: $weekdays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplementScheduleImpl &&
            (identical(other.anchorEvent, anchorEvent) ||
                other.anchorEvent == anchorEvent) &&
            (identical(other.timingType, timingType) ||
                other.timingType == timingType) &&
            (identical(other.offsetMinutes, offsetMinutes) ||
                other.offsetMinutes == offsetMinutes) &&
            (identical(other.specificTimeMinutes, specificTimeMinutes) ||
                other.specificTimeMinutes == specificTimeMinutes) &&
            (identical(other.frequencyType, frequencyType) ||
                other.frequencyType == frequencyType) &&
            (identical(other.everyXDays, everyXDays) ||
                other.everyXDays == everyXDays) &&
            const DeepCollectionEquality().equals(other._weekdays, _weekdays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    anchorEvent,
    timingType,
    offsetMinutes,
    specificTimeMinutes,
    frequencyType,
    everyXDays,
    const DeepCollectionEquality().hash(_weekdays),
  );

  /// Create a copy of SupplementSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplementScheduleImplCopyWith<_$SupplementScheduleImpl> get copyWith =>
      __$$SupplementScheduleImplCopyWithImpl<_$SupplementScheduleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SupplementScheduleImplToJson(this);
  }
}

abstract class _SupplementSchedule extends SupplementSchedule {
  const factory _SupplementSchedule({
    required final SupplementAnchorEvent anchorEvent,
    required final SupplementTimingType timingType,
    final int offsetMinutes,
    final int? specificTimeMinutes,
    required final SupplementFrequencyType frequencyType,
    final int everyXDays,
    final List<int> weekdays,
  }) = _$SupplementScheduleImpl;
  const _SupplementSchedule._() : super._();

  factory _SupplementSchedule.fromJson(Map<String, dynamic> json) =
      _$SupplementScheduleImpl.fromJson;

  @override
  SupplementAnchorEvent get anchorEvent;
  @override
  SupplementTimingType get timingType;
  @override
  int get offsetMinutes;
  @override
  int? get specificTimeMinutes;
  @override
  SupplementFrequencyType get frequencyType;
  @override
  int get everyXDays;
  @override
  List<int> get weekdays;

  /// Create a copy of SupplementSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupplementScheduleImplCopyWith<_$SupplementScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
