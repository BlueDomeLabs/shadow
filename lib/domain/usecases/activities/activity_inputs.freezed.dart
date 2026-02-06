// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateActivityInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get triggers =>
      throw _privateConstructorUsedError; // Comma-separated trigger descriptions
  int get durationMinutes => throw _privateConstructorUsedError;

  /// Create a copy of CreateActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateActivityInputCopyWith<CreateActivityInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateActivityInputCopyWith<$Res> {
  factory $CreateActivityInputCopyWith(
    CreateActivityInput value,
    $Res Function(CreateActivityInput) then,
  ) = _$CreateActivityInputCopyWithImpl<$Res, CreateActivityInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String name,
    String? description,
    String? location,
    String? triggers,
    int durationMinutes,
  });
}

/// @nodoc
class _$CreateActivityInputCopyWithImpl<$Res, $Val extends CreateActivityInput>
    implements $CreateActivityInputCopyWith<$Res> {
  _$CreateActivityInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? name = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? triggers = freezed,
    Object? durationMinutes = null,
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
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            triggers: freezed == triggers
                ? _value.triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateActivityInputImplCopyWith<$Res>
    implements $CreateActivityInputCopyWith<$Res> {
  factory _$$CreateActivityInputImplCopyWith(
    _$CreateActivityInputImpl value,
    $Res Function(_$CreateActivityInputImpl) then,
  ) = __$$CreateActivityInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String name,
    String? description,
    String? location,
    String? triggers,
    int durationMinutes,
  });
}

/// @nodoc
class __$$CreateActivityInputImplCopyWithImpl<$Res>
    extends _$CreateActivityInputCopyWithImpl<$Res, _$CreateActivityInputImpl>
    implements _$$CreateActivityInputImplCopyWith<$Res> {
  __$$CreateActivityInputImplCopyWithImpl(
    _$CreateActivityInputImpl _value,
    $Res Function(_$CreateActivityInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? name = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? triggers = freezed,
    Object? durationMinutes = null,
  }) {
    return _then(
      _$CreateActivityInputImpl(
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
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        triggers: freezed == triggers
            ? _value.triggers
            : triggers // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CreateActivityInputImpl implements _CreateActivityInput {
  const _$CreateActivityInputImpl({
    required this.profileId,
    required this.clientId,
    required this.name,
    this.description,
    this.location,
    this.triggers,
    required this.durationMinutes,
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
  final String? location;
  @override
  final String? triggers;
  // Comma-separated trigger descriptions
  @override
  final int durationMinutes;

  @override
  String toString() {
    return 'CreateActivityInput(profileId: $profileId, clientId: $clientId, name: $name, description: $description, location: $location, triggers: $triggers, durationMinutes: $durationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateActivityInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.triggers, triggers) ||
                other.triggers == triggers) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    name,
    description,
    location,
    triggers,
    durationMinutes,
  );

  /// Create a copy of CreateActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateActivityInputImplCopyWith<_$CreateActivityInputImpl> get copyWith =>
      __$$CreateActivityInputImplCopyWithImpl<_$CreateActivityInputImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateActivityInput implements CreateActivityInput {
  const factory _CreateActivityInput({
    required final String profileId,
    required final String clientId,
    required final String name,
    final String? description,
    final String? location,
    final String? triggers,
    required final int durationMinutes,
  }) = _$CreateActivityInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get location;
  @override
  String? get triggers; // Comma-separated trigger descriptions
  @override
  int get durationMinutes;

  /// Create a copy of CreateActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateActivityInputImplCopyWith<_$CreateActivityInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetActivitiesInput {
  String get profileId => throw _privateConstructorUsedError;
  bool get includeArchived => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;

  /// Create a copy of GetActivitiesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetActivitiesInputCopyWith<GetActivitiesInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetActivitiesInputCopyWith<$Res> {
  factory $GetActivitiesInputCopyWith(
    GetActivitiesInput value,
    $Res Function(GetActivitiesInput) then,
  ) = _$GetActivitiesInputCopyWithImpl<$Res, GetActivitiesInput>;
  @useResult
  $Res call({String profileId, bool includeArchived, int? limit, int? offset});
}

/// @nodoc
class _$GetActivitiesInputCopyWithImpl<$Res, $Val extends GetActivitiesInput>
    implements $GetActivitiesInputCopyWith<$Res> {
  _$GetActivitiesInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetActivitiesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? includeArchived = null,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
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
abstract class _$$GetActivitiesInputImplCopyWith<$Res>
    implements $GetActivitiesInputCopyWith<$Res> {
  factory _$$GetActivitiesInputImplCopyWith(
    _$GetActivitiesInputImpl value,
    $Res Function(_$GetActivitiesInputImpl) then,
  ) = __$$GetActivitiesInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, bool includeArchived, int? limit, int? offset});
}

/// @nodoc
class __$$GetActivitiesInputImplCopyWithImpl<$Res>
    extends _$GetActivitiesInputCopyWithImpl<$Res, _$GetActivitiesInputImpl>
    implements _$$GetActivitiesInputImplCopyWith<$Res> {
  __$$GetActivitiesInputImplCopyWithImpl(
    _$GetActivitiesInputImpl _value,
    $Res Function(_$GetActivitiesInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetActivitiesInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? includeArchived = null,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _$GetActivitiesInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        includeArchived: null == includeArchived
            ? _value.includeArchived
            : includeArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
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

class _$GetActivitiesInputImpl implements _GetActivitiesInput {
  const _$GetActivitiesInputImpl({
    required this.profileId,
    this.includeArchived = false,
    this.limit,
    this.offset,
  });

  @override
  final String profileId;
  @override
  @JsonKey()
  final bool includeArchived;
  @override
  final int? limit;
  @override
  final int? offset;

  @override
  String toString() {
    return 'GetActivitiesInput(profileId: $profileId, includeArchived: $includeArchived, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetActivitiesInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.includeArchived, includeArchived) ||
                other.includeArchived == includeArchived) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, includeArchived, limit, offset);

  /// Create a copy of GetActivitiesInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetActivitiesInputImplCopyWith<_$GetActivitiesInputImpl> get copyWith =>
      __$$GetActivitiesInputImplCopyWithImpl<_$GetActivitiesInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetActivitiesInput implements GetActivitiesInput {
  const factory _GetActivitiesInput({
    required final String profileId,
    final bool includeArchived,
    final int? limit,
    final int? offset,
  }) = _$GetActivitiesInputImpl;

  @override
  String get profileId;
  @override
  bool get includeArchived;
  @override
  int? get limit;
  @override
  int? get offset;

  /// Create a copy of GetActivitiesInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetActivitiesInputImplCopyWith<_$GetActivitiesInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateActivityInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get triggers => throw _privateConstructorUsedError;
  int? get durationMinutes => throw _privateConstructorUsedError;

  /// Create a copy of UpdateActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateActivityInputCopyWith<UpdateActivityInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateActivityInputCopyWith<$Res> {
  factory $UpdateActivityInputCopyWith(
    UpdateActivityInput value,
    $Res Function(UpdateActivityInput) then,
  ) = _$UpdateActivityInputCopyWithImpl<$Res, UpdateActivityInput>;
  @useResult
  $Res call({
    String id,
    String profileId,
    String? name,
    String? description,
    String? location,
    String? triggers,
    int? durationMinutes,
  });
}

/// @nodoc
class _$UpdateActivityInputCopyWithImpl<$Res, $Val extends UpdateActivityInput>
    implements $UpdateActivityInputCopyWith<$Res> {
  _$UpdateActivityInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? name = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? triggers = freezed,
    Object? durationMinutes = freezed,
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
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            triggers: freezed == triggers
                ? _value.triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationMinutes: freezed == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateActivityInputImplCopyWith<$Res>
    implements $UpdateActivityInputCopyWith<$Res> {
  factory _$$UpdateActivityInputImplCopyWith(
    _$UpdateActivityInputImpl value,
    $Res Function(_$UpdateActivityInputImpl) then,
  ) = __$$UpdateActivityInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    String? name,
    String? description,
    String? location,
    String? triggers,
    int? durationMinutes,
  });
}

/// @nodoc
class __$$UpdateActivityInputImplCopyWithImpl<$Res>
    extends _$UpdateActivityInputCopyWithImpl<$Res, _$UpdateActivityInputImpl>
    implements _$$UpdateActivityInputImplCopyWith<$Res> {
  __$$UpdateActivityInputImplCopyWithImpl(
    _$UpdateActivityInputImpl _value,
    $Res Function(_$UpdateActivityInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? name = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? triggers = freezed,
    Object? durationMinutes = freezed,
  }) {
    return _then(
      _$UpdateActivityInputImpl(
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
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        triggers: freezed == triggers
            ? _value.triggers
            : triggers // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMinutes: freezed == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateActivityInputImpl implements _UpdateActivityInput {
  const _$UpdateActivityInputImpl({
    required this.id,
    required this.profileId,
    this.name,
    this.description,
    this.location,
    this.triggers,
    this.durationMinutes,
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
  final String? location;
  @override
  final String? triggers;
  @override
  final int? durationMinutes;

  @override
  String toString() {
    return 'UpdateActivityInput(id: $id, profileId: $profileId, name: $name, description: $description, location: $location, triggers: $triggers, durationMinutes: $durationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateActivityInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.triggers, triggers) ||
                other.triggers == triggers) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    name,
    description,
    location,
    triggers,
    durationMinutes,
  );

  /// Create a copy of UpdateActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateActivityInputImplCopyWith<_$UpdateActivityInputImpl> get copyWith =>
      __$$UpdateActivityInputImplCopyWithImpl<_$UpdateActivityInputImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateActivityInput implements UpdateActivityInput {
  const factory _UpdateActivityInput({
    required final String id,
    required final String profileId,
    final String? name,
    final String? description,
    final String? location,
    final String? triggers,
    final int? durationMinutes,
  }) = _$UpdateActivityInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  String? get name;
  @override
  String? get description;
  @override
  String? get location;
  @override
  String? get triggers;
  @override
  int? get durationMinutes;

  /// Create a copy of UpdateActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateActivityInputImplCopyWith<_$UpdateActivityInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ArchiveActivityInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  bool get archive => throw _privateConstructorUsedError;

  /// Create a copy of ArchiveActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArchiveActivityInputCopyWith<ArchiveActivityInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchiveActivityInputCopyWith<$Res> {
  factory $ArchiveActivityInputCopyWith(
    ArchiveActivityInput value,
    $Res Function(ArchiveActivityInput) then,
  ) = _$ArchiveActivityInputCopyWithImpl<$Res, ArchiveActivityInput>;
  @useResult
  $Res call({String id, String profileId, bool archive});
}

/// @nodoc
class _$ArchiveActivityInputCopyWithImpl<
  $Res,
  $Val extends ArchiveActivityInput
>
    implements $ArchiveActivityInputCopyWith<$Res> {
  _$ArchiveActivityInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArchiveActivityInput
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
abstract class _$$ArchiveActivityInputImplCopyWith<$Res>
    implements $ArchiveActivityInputCopyWith<$Res> {
  factory _$$ArchiveActivityInputImplCopyWith(
    _$ArchiveActivityInputImpl value,
    $Res Function(_$ArchiveActivityInputImpl) then,
  ) = __$$ArchiveActivityInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId, bool archive});
}

/// @nodoc
class __$$ArchiveActivityInputImplCopyWithImpl<$Res>
    extends _$ArchiveActivityInputCopyWithImpl<$Res, _$ArchiveActivityInputImpl>
    implements _$$ArchiveActivityInputImplCopyWith<$Res> {
  __$$ArchiveActivityInputImplCopyWithImpl(
    _$ArchiveActivityInputImpl _value,
    $Res Function(_$ArchiveActivityInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArchiveActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? archive = null,
  }) {
    return _then(
      _$ArchiveActivityInputImpl(
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

class _$ArchiveActivityInputImpl implements _ArchiveActivityInput {
  const _$ArchiveActivityInputImpl({
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
    return 'ArchiveActivityInput(id: $id, profileId: $profileId, archive: $archive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchiveActivityInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.archive, archive) || other.archive == archive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId, archive);

  /// Create a copy of ArchiveActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchiveActivityInputImplCopyWith<_$ArchiveActivityInputImpl>
  get copyWith =>
      __$$ArchiveActivityInputImplCopyWithImpl<_$ArchiveActivityInputImpl>(
        this,
        _$identity,
      );
}

abstract class _ArchiveActivityInput implements ArchiveActivityInput {
  const factory _ArchiveActivityInput({
    required final String id,
    required final String profileId,
    final bool archive,
  }) = _$ArchiveActivityInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  bool get archive;

  /// Create a copy of ArchiveActivityInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArchiveActivityInputImplCopyWith<_$ArchiveActivityInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}
