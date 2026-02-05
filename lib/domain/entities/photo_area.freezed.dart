// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_area.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PhotoArea _$PhotoAreaFromJson(Map<String, dynamic> json) {
  return _PhotoArea.fromJson(json);
}

/// @nodoc
mixin _$PhotoArea {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get consistencyNotes => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this PhotoArea to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoAreaCopyWith<PhotoArea> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoAreaCopyWith<$Res> {
  factory $PhotoAreaCopyWith(PhotoArea value, $Res Function(PhotoArea) then) =
      _$PhotoAreaCopyWithImpl<$Res, PhotoArea>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String name,
    String? description,
    String? consistencyNotes,
    int sortOrder,
    bool isArchived,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$PhotoAreaCopyWithImpl<$Res, $Val extends PhotoArea>
    implements $PhotoAreaCopyWith<$Res> {
  _$PhotoAreaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? name = null,
    Object? description = freezed,
    Object? consistencyNotes = freezed,
    Object? sortOrder = null,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            consistencyNotes: freezed == consistencyNotes
                ? _value.consistencyNotes
                : consistencyNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
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

  /// Create a copy of PhotoArea
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
abstract class _$$PhotoAreaImplCopyWith<$Res>
    implements $PhotoAreaCopyWith<$Res> {
  factory _$$PhotoAreaImplCopyWith(
    _$PhotoAreaImpl value,
    $Res Function(_$PhotoAreaImpl) then,
  ) = __$$PhotoAreaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String name,
    String? description,
    String? consistencyNotes,
    int sortOrder,
    bool isArchived,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$PhotoAreaImplCopyWithImpl<$Res>
    extends _$PhotoAreaCopyWithImpl<$Res, _$PhotoAreaImpl>
    implements _$$PhotoAreaImplCopyWith<$Res> {
  __$$PhotoAreaImplCopyWithImpl(
    _$PhotoAreaImpl _value,
    $Res Function(_$PhotoAreaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhotoArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? name = null,
    Object? description = freezed,
    Object? consistencyNotes = freezed,
    Object? sortOrder = null,
    Object? isArchived = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$PhotoAreaImpl(
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
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        consistencyNotes: freezed == consistencyNotes
            ? _value.consistencyNotes
            : consistencyNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$PhotoAreaImpl extends _PhotoArea {
  const _$PhotoAreaImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.name,
    this.description,
    this.consistencyNotes,
    this.sortOrder = 0,
    this.isArchived = false,
    required this.syncMetadata,
  }) : super._();

  factory _$PhotoAreaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoAreaImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? consistencyNotes;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'PhotoArea(id: $id, clientId: $clientId, profileId: $profileId, name: $name, description: $description, consistencyNotes: $consistencyNotes, sortOrder: $sortOrder, isArchived: $isArchived, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoAreaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.consistencyNotes, consistencyNotes) ||
                other.consistencyNotes == consistencyNotes) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
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
    description,
    consistencyNotes,
    sortOrder,
    isArchived,
    syncMetadata,
  );

  /// Create a copy of PhotoArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoAreaImplCopyWith<_$PhotoAreaImpl> get copyWith =>
      __$$PhotoAreaImplCopyWithImpl<_$PhotoAreaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoAreaImplToJson(this);
  }
}

abstract class _PhotoArea extends PhotoArea {
  const factory _PhotoArea({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final String name,
    final String? description,
    final String? consistencyNotes,
    final int sortOrder,
    final bool isArchived,
    required final SyncMetadata syncMetadata,
  }) = _$PhotoAreaImpl;
  const _PhotoArea._() : super._();

  factory _PhotoArea.fromJson(Map<String, dynamic> json) =
      _$PhotoAreaImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get consistencyNotes;
  @override
  int get sortOrder;
  @override
  bool get isArchived;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of PhotoArea
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoAreaImplCopyWith<_$PhotoAreaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
