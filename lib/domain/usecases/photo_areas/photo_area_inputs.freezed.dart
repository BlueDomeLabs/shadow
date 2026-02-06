// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_area_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreatePhotoAreaInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get consistencyNotes => throw _privateConstructorUsedError;

  /// Create a copy of CreatePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePhotoAreaInputCopyWith<CreatePhotoAreaInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePhotoAreaInputCopyWith<$Res> {
  factory $CreatePhotoAreaInputCopyWith(
    CreatePhotoAreaInput value,
    $Res Function(CreatePhotoAreaInput) then,
  ) = _$CreatePhotoAreaInputCopyWithImpl<$Res, CreatePhotoAreaInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String name,
    String? description,
    String? consistencyNotes,
  });
}

/// @nodoc
class _$CreatePhotoAreaInputCopyWithImpl<
  $Res,
  $Val extends CreatePhotoAreaInput
>
    implements $CreatePhotoAreaInputCopyWith<$Res> {
  _$CreatePhotoAreaInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? name = null,
    Object? description = freezed,
    Object? consistencyNotes = freezed,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            consistencyNotes: freezed == consistencyNotes
                ? _value.consistencyNotes
                : consistencyNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatePhotoAreaInputImplCopyWith<$Res>
    implements $CreatePhotoAreaInputCopyWith<$Res> {
  factory _$$CreatePhotoAreaInputImplCopyWith(
    _$CreatePhotoAreaInputImpl value,
    $Res Function(_$CreatePhotoAreaInputImpl) then,
  ) = __$$CreatePhotoAreaInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String name,
    String? description,
    String? consistencyNotes,
  });
}

/// @nodoc
class __$$CreatePhotoAreaInputImplCopyWithImpl<$Res>
    extends _$CreatePhotoAreaInputCopyWithImpl<$Res, _$CreatePhotoAreaInputImpl>
    implements _$$CreatePhotoAreaInputImplCopyWith<$Res> {
  __$$CreatePhotoAreaInputImplCopyWithImpl(
    _$CreatePhotoAreaInputImpl _value,
    $Res Function(_$CreatePhotoAreaInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? name = null,
    Object? description = freezed,
    Object? consistencyNotes = freezed,
  }) {
    return _then(
      _$CreatePhotoAreaInputImpl(
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
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        consistencyNotes: freezed == consistencyNotes
            ? _value.consistencyNotes
            : consistencyNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CreatePhotoAreaInputImpl implements _CreatePhotoAreaInput {
  const _$CreatePhotoAreaInputImpl({
    required this.profileId,
    required this.clientId,
    required this.name,
    this.description,
    this.consistencyNotes,
  });

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? consistencyNotes;

  @override
  String toString() {
    return 'CreatePhotoAreaInput(profileId: $profileId, clientId: $clientId, name: $name, description: $description, consistencyNotes: $consistencyNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePhotoAreaInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.consistencyNotes, consistencyNotes) ||
                other.consistencyNotes == consistencyNotes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    name,
    description,
    consistencyNotes,
  );

  /// Create a copy of CreatePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePhotoAreaInputImplCopyWith<_$CreatePhotoAreaInputImpl>
  get copyWith =>
      __$$CreatePhotoAreaInputImplCopyWithImpl<_$CreatePhotoAreaInputImpl>(
        this,
        _$identity,
      );
}

abstract class _CreatePhotoAreaInput implements CreatePhotoAreaInput {
  const factory _CreatePhotoAreaInput({
    required final String profileId,
    required final String clientId,
    required final String name,
    final String? description,
    final String? consistencyNotes,
  }) = _$CreatePhotoAreaInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get consistencyNotes;

  /// Create a copy of CreatePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePhotoAreaInputImplCopyWith<_$CreatePhotoAreaInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetPhotoAreasInput {
  String get profileId => throw _privateConstructorUsedError;
  bool get includeArchived => throw _privateConstructorUsedError;

  /// Create a copy of GetPhotoAreasInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetPhotoAreasInputCopyWith<GetPhotoAreasInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetPhotoAreasInputCopyWith<$Res> {
  factory $GetPhotoAreasInputCopyWith(
    GetPhotoAreasInput value,
    $Res Function(GetPhotoAreasInput) then,
  ) = _$GetPhotoAreasInputCopyWithImpl<$Res, GetPhotoAreasInput>;
  @useResult
  $Res call({String profileId, bool includeArchived});
}

/// @nodoc
class _$GetPhotoAreasInputCopyWithImpl<$Res, $Val extends GetPhotoAreasInput>
    implements $GetPhotoAreasInputCopyWith<$Res> {
  _$GetPhotoAreasInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetPhotoAreasInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? includeArchived = null}) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            includeArchived: null == includeArchived
                ? _value.includeArchived
                : includeArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetPhotoAreasInputImplCopyWith<$Res>
    implements $GetPhotoAreasInputCopyWith<$Res> {
  factory _$$GetPhotoAreasInputImplCopyWith(
    _$GetPhotoAreasInputImpl value,
    $Res Function(_$GetPhotoAreasInputImpl) then,
  ) = __$$GetPhotoAreasInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, bool includeArchived});
}

/// @nodoc
class __$$GetPhotoAreasInputImplCopyWithImpl<$Res>
    extends _$GetPhotoAreasInputCopyWithImpl<$Res, _$GetPhotoAreasInputImpl>
    implements _$$GetPhotoAreasInputImplCopyWith<$Res> {
  __$$GetPhotoAreasInputImplCopyWithImpl(
    _$GetPhotoAreasInputImpl _value,
    $Res Function(_$GetPhotoAreasInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetPhotoAreasInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? includeArchived = null}) {
    return _then(
      _$GetPhotoAreasInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        includeArchived: null == includeArchived
            ? _value.includeArchived
            : includeArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GetPhotoAreasInputImpl implements _GetPhotoAreasInput {
  const _$GetPhotoAreasInputImpl({
    required this.profileId,
    this.includeArchived = false,
  });

  @override
  final String profileId;
  @override
  @JsonKey()
  final bool includeArchived;

  @override
  String toString() {
    return 'GetPhotoAreasInput(profileId: $profileId, includeArchived: $includeArchived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetPhotoAreasInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.includeArchived, includeArchived) ||
                other.includeArchived == includeArchived));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, includeArchived);

  /// Create a copy of GetPhotoAreasInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetPhotoAreasInputImplCopyWith<_$GetPhotoAreasInputImpl> get copyWith =>
      __$$GetPhotoAreasInputImplCopyWithImpl<_$GetPhotoAreasInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetPhotoAreasInput implements GetPhotoAreasInput {
  const factory _GetPhotoAreasInput({
    required final String profileId,
    final bool includeArchived,
  }) = _$GetPhotoAreasInputImpl;

  @override
  String get profileId;
  @override
  bool get includeArchived;

  /// Create a copy of GetPhotoAreasInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetPhotoAreasInputImplCopyWith<_$GetPhotoAreasInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdatePhotoAreaInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get consistencyNotes => throw _privateConstructorUsedError;

  /// Create a copy of UpdatePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdatePhotoAreaInputCopyWith<UpdatePhotoAreaInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePhotoAreaInputCopyWith<$Res> {
  factory $UpdatePhotoAreaInputCopyWith(
    UpdatePhotoAreaInput value,
    $Res Function(UpdatePhotoAreaInput) then,
  ) = _$UpdatePhotoAreaInputCopyWithImpl<$Res, UpdatePhotoAreaInput>;
  @useResult
  $Res call({
    String id,
    String profileId,
    String? name,
    String? description,
    String? consistencyNotes,
  });
}

/// @nodoc
class _$UpdatePhotoAreaInputCopyWithImpl<
  $Res,
  $Val extends UpdatePhotoAreaInput
>
    implements $UpdatePhotoAreaInputCopyWith<$Res> {
  _$UpdatePhotoAreaInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdatePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? name = freezed,
    Object? description = freezed,
    Object? consistencyNotes = freezed,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            consistencyNotes: freezed == consistencyNotes
                ? _value.consistencyNotes
                : consistencyNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdatePhotoAreaInputImplCopyWith<$Res>
    implements $UpdatePhotoAreaInputCopyWith<$Res> {
  factory _$$UpdatePhotoAreaInputImplCopyWith(
    _$UpdatePhotoAreaInputImpl value,
    $Res Function(_$UpdatePhotoAreaInputImpl) then,
  ) = __$$UpdatePhotoAreaInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    String? name,
    String? description,
    String? consistencyNotes,
  });
}

/// @nodoc
class __$$UpdatePhotoAreaInputImplCopyWithImpl<$Res>
    extends _$UpdatePhotoAreaInputCopyWithImpl<$Res, _$UpdatePhotoAreaInputImpl>
    implements _$$UpdatePhotoAreaInputImplCopyWith<$Res> {
  __$$UpdatePhotoAreaInputImplCopyWithImpl(
    _$UpdatePhotoAreaInputImpl _value,
    $Res Function(_$UpdatePhotoAreaInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdatePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? name = freezed,
    Object? description = freezed,
    Object? consistencyNotes = freezed,
  }) {
    return _then(
      _$UpdatePhotoAreaInputImpl(
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
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        consistencyNotes: freezed == consistencyNotes
            ? _value.consistencyNotes
            : consistencyNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdatePhotoAreaInputImpl implements _UpdatePhotoAreaInput {
  const _$UpdatePhotoAreaInputImpl({
    required this.id,
    required this.profileId,
    this.name,
    this.description,
    this.consistencyNotes,
  });

  @override
  final String id;
  @override
  final String profileId;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? consistencyNotes;

  @override
  String toString() {
    return 'UpdatePhotoAreaInput(id: $id, profileId: $profileId, name: $name, description: $description, consistencyNotes: $consistencyNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePhotoAreaInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.consistencyNotes, consistencyNotes) ||
                other.consistencyNotes == consistencyNotes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    name,
    description,
    consistencyNotes,
  );

  /// Create a copy of UpdatePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePhotoAreaInputImplCopyWith<_$UpdatePhotoAreaInputImpl>
  get copyWith =>
      __$$UpdatePhotoAreaInputImplCopyWithImpl<_$UpdatePhotoAreaInputImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdatePhotoAreaInput implements UpdatePhotoAreaInput {
  const factory _UpdatePhotoAreaInput({
    required final String id,
    required final String profileId,
    final String? name,
    final String? description,
    final String? consistencyNotes,
  }) = _$UpdatePhotoAreaInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  String? get name;
  @override
  String? get description;
  @override
  String? get consistencyNotes;

  /// Create a copy of UpdatePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdatePhotoAreaInputImplCopyWith<_$UpdatePhotoAreaInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ArchivePhotoAreaInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  bool get archive => throw _privateConstructorUsedError;

  /// Create a copy of ArchivePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArchivePhotoAreaInputCopyWith<ArchivePhotoAreaInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchivePhotoAreaInputCopyWith<$Res> {
  factory $ArchivePhotoAreaInputCopyWith(
    ArchivePhotoAreaInput value,
    $Res Function(ArchivePhotoAreaInput) then,
  ) = _$ArchivePhotoAreaInputCopyWithImpl<$Res, ArchivePhotoAreaInput>;
  @useResult
  $Res call({String id, String profileId, bool archive});
}

/// @nodoc
class _$ArchivePhotoAreaInputCopyWithImpl<
  $Res,
  $Val extends ArchivePhotoAreaInput
>
    implements $ArchivePhotoAreaInputCopyWith<$Res> {
  _$ArchivePhotoAreaInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArchivePhotoAreaInput
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
abstract class _$$ArchivePhotoAreaInputImplCopyWith<$Res>
    implements $ArchivePhotoAreaInputCopyWith<$Res> {
  factory _$$ArchivePhotoAreaInputImplCopyWith(
    _$ArchivePhotoAreaInputImpl value,
    $Res Function(_$ArchivePhotoAreaInputImpl) then,
  ) = __$$ArchivePhotoAreaInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId, bool archive});
}

/// @nodoc
class __$$ArchivePhotoAreaInputImplCopyWithImpl<$Res>
    extends
        _$ArchivePhotoAreaInputCopyWithImpl<$Res, _$ArchivePhotoAreaInputImpl>
    implements _$$ArchivePhotoAreaInputImplCopyWith<$Res> {
  __$$ArchivePhotoAreaInputImplCopyWithImpl(
    _$ArchivePhotoAreaInputImpl _value,
    $Res Function(_$ArchivePhotoAreaInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArchivePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? archive = null,
  }) {
    return _then(
      _$ArchivePhotoAreaInputImpl(
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

class _$ArchivePhotoAreaInputImpl implements _ArchivePhotoAreaInput {
  const _$ArchivePhotoAreaInputImpl({
    required this.id,
    required this.profileId,
    this.archive = true,
  });

  @override
  final String id;
  @override
  final String profileId;
  @override
  @JsonKey()
  final bool archive;

  @override
  String toString() {
    return 'ArchivePhotoAreaInput(id: $id, profileId: $profileId, archive: $archive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchivePhotoAreaInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.archive, archive) || other.archive == archive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId, archive);

  /// Create a copy of ArchivePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchivePhotoAreaInputImplCopyWith<_$ArchivePhotoAreaInputImpl>
  get copyWith =>
      __$$ArchivePhotoAreaInputImplCopyWithImpl<_$ArchivePhotoAreaInputImpl>(
        this,
        _$identity,
      );
}

abstract class _ArchivePhotoAreaInput implements ArchivePhotoAreaInput {
  const factory _ArchivePhotoAreaInput({
    required final String id,
    required final String profileId,
    final bool archive,
  }) = _$ArchivePhotoAreaInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  bool get archive;

  /// Create a copy of ArchivePhotoAreaInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArchivePhotoAreaInputImplCopyWith<_$ArchivePhotoAreaInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}
