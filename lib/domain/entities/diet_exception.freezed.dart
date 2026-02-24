// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DietException {
  String get id => throw _privateConstructorUsedError;
  String get ruleId => throw _privateConstructorUsedError;
  String get description =>
      throw _privateConstructorUsedError; // Free text (e.g. "Hard aged cheeses")
  int get sortOrder => throw _privateConstructorUsedError;

  /// Create a copy of DietException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DietExceptionCopyWith<DietException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DietExceptionCopyWith<$Res> {
  factory $DietExceptionCopyWith(
    DietException value,
    $Res Function(DietException) then,
  ) = _$DietExceptionCopyWithImpl<$Res, DietException>;
  @useResult
  $Res call({String id, String ruleId, String description, int sortOrder});
}

/// @nodoc
class _$DietExceptionCopyWithImpl<$Res, $Val extends DietException>
    implements $DietExceptionCopyWith<$Res> {
  _$DietExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DietException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ruleId = null,
    Object? description = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ruleId: null == ruleId
                ? _value.ruleId
                : ruleId // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$DietExceptionImplCopyWith<$Res>
    implements $DietExceptionCopyWith<$Res> {
  factory _$$DietExceptionImplCopyWith(
    _$DietExceptionImpl value,
    $Res Function(_$DietExceptionImpl) then,
  ) = __$$DietExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String ruleId, String description, int sortOrder});
}

/// @nodoc
class __$$DietExceptionImplCopyWithImpl<$Res>
    extends _$DietExceptionCopyWithImpl<$Res, _$DietExceptionImpl>
    implements _$$DietExceptionImplCopyWith<$Res> {
  __$$DietExceptionImplCopyWithImpl(
    _$DietExceptionImpl _value,
    $Res Function(_$DietExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DietException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ruleId = null,
    Object? description = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _$DietExceptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ruleId: null == ruleId
            ? _value.ruleId
            : ruleId // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DietExceptionImpl implements _DietException {
  const _$DietExceptionImpl({
    required this.id,
    required this.ruleId,
    required this.description,
    this.sortOrder = 0,
  });

  @override
  final String id;
  @override
  final String ruleId;
  @override
  final String description;
  // Free text (e.g. "Hard aged cheeses")
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'DietException(id: $id, ruleId: $ruleId, description: $description, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DietExceptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ruleId, ruleId) || other.ruleId == ruleId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, ruleId, description, sortOrder);

  /// Create a copy of DietException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DietExceptionImplCopyWith<_$DietExceptionImpl> get copyWith =>
      __$$DietExceptionImplCopyWithImpl<_$DietExceptionImpl>(this, _$identity);
}

abstract class _DietException implements DietException {
  const factory _DietException({
    required final String id,
    required final String ruleId,
    required final String description,
    final int sortOrder,
  }) = _$DietExceptionImpl;

  @override
  String get id;
  @override
  String get ruleId;
  @override
  String get description; // Free text (e.g. "Hard aged cheeses")
  @override
  int get sortOrder;

  /// Create a copy of DietException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DietExceptionImplCopyWith<_$DietExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
