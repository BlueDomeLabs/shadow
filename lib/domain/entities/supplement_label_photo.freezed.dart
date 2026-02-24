// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplement_label_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SupplementLabelPhoto {
  String get id => throw _privateConstructorUsedError;
  String get supplementId => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError; // Local file path
  int get capturedAt =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  int get sortOrder => throw _privateConstructorUsedError;

  /// Create a copy of SupplementLabelPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupplementLabelPhotoCopyWith<SupplementLabelPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplementLabelPhotoCopyWith<$Res> {
  factory $SupplementLabelPhotoCopyWith(
    SupplementLabelPhoto value,
    $Res Function(SupplementLabelPhoto) then,
  ) = _$SupplementLabelPhotoCopyWithImpl<$Res, SupplementLabelPhoto>;
  @useResult
  $Res call({
    String id,
    String supplementId,
    String filePath,
    int capturedAt,
    int sortOrder,
  });
}

/// @nodoc
class _$SupplementLabelPhotoCopyWithImpl<
  $Res,
  $Val extends SupplementLabelPhoto
>
    implements $SupplementLabelPhotoCopyWith<$Res> {
  _$SupplementLabelPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupplementLabelPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? supplementId = null,
    Object? filePath = null,
    Object? capturedAt = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            supplementId: null == supplementId
                ? _value.supplementId
                : supplementId // ignore: cast_nullable_to_non_nullable
                      as String,
            filePath: null == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                      as String,
            capturedAt: null == capturedAt
                ? _value.capturedAt
                : capturedAt // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$SupplementLabelPhotoImplCopyWith<$Res>
    implements $SupplementLabelPhotoCopyWith<$Res> {
  factory _$$SupplementLabelPhotoImplCopyWith(
    _$SupplementLabelPhotoImpl value,
    $Res Function(_$SupplementLabelPhotoImpl) then,
  ) = __$$SupplementLabelPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String supplementId,
    String filePath,
    int capturedAt,
    int sortOrder,
  });
}

/// @nodoc
class __$$SupplementLabelPhotoImplCopyWithImpl<$Res>
    extends _$SupplementLabelPhotoCopyWithImpl<$Res, _$SupplementLabelPhotoImpl>
    implements _$$SupplementLabelPhotoImplCopyWith<$Res> {
  __$$SupplementLabelPhotoImplCopyWithImpl(
    _$SupplementLabelPhotoImpl _value,
    $Res Function(_$SupplementLabelPhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupplementLabelPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? supplementId = null,
    Object? filePath = null,
    Object? capturedAt = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _$SupplementLabelPhotoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        supplementId: null == supplementId
            ? _value.supplementId
            : supplementId // ignore: cast_nullable_to_non_nullable
                  as String,
        filePath: null == filePath
            ? _value.filePath
            : filePath // ignore: cast_nullable_to_non_nullable
                  as String,
        capturedAt: null == capturedAt
            ? _value.capturedAt
            : capturedAt // ignore: cast_nullable_to_non_nullable
                  as int,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SupplementLabelPhotoImpl implements _SupplementLabelPhoto {
  const _$SupplementLabelPhotoImpl({
    required this.id,
    required this.supplementId,
    required this.filePath,
    required this.capturedAt,
    this.sortOrder = 0,
  });

  @override
  final String id;
  @override
  final String supplementId;
  @override
  final String filePath;
  // Local file path
  @override
  final int capturedAt;
  // Epoch milliseconds
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'SupplementLabelPhoto(id: $id, supplementId: $supplementId, filePath: $filePath, capturedAt: $capturedAt, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplementLabelPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.supplementId, supplementId) ||
                other.supplementId == supplementId) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.capturedAt, capturedAt) ||
                other.capturedAt == capturedAt) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    supplementId,
    filePath,
    capturedAt,
    sortOrder,
  );

  /// Create a copy of SupplementLabelPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplementLabelPhotoImplCopyWith<_$SupplementLabelPhotoImpl>
  get copyWith =>
      __$$SupplementLabelPhotoImplCopyWithImpl<_$SupplementLabelPhotoImpl>(
        this,
        _$identity,
      );
}

abstract class _SupplementLabelPhoto implements SupplementLabelPhoto {
  const factory _SupplementLabelPhoto({
    required final String id,
    required final String supplementId,
    required final String filePath,
    required final int capturedAt,
    final int sortOrder,
  }) = _$SupplementLabelPhotoImpl;

  @override
  String get id;
  @override
  String get supplementId;
  @override
  String get filePath; // Local file path
  @override
  int get capturedAt; // Epoch milliseconds
  @override
  int get sortOrder;

  /// Create a copy of SupplementLabelPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupplementLabelPhotoImplCopyWith<_$SupplementLabelPhotoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
