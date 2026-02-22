// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'condition_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GetConditionsInput {
  String get profileId => throw _privateConstructorUsedError;
  ConditionStatus? get status => throw _privateConstructorUsedError;
  bool get includeArchived => throw _privateConstructorUsedError;

  /// Create a copy of GetConditionsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetConditionsInputCopyWith<GetConditionsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetConditionsInputCopyWith<$Res> {
  factory $GetConditionsInputCopyWith(
    GetConditionsInput value,
    $Res Function(GetConditionsInput) then,
  ) = _$GetConditionsInputCopyWithImpl<$Res, GetConditionsInput>;
  @useResult
  $Res call({String profileId, ConditionStatus? status, bool includeArchived});
}

/// @nodoc
class _$GetConditionsInputCopyWithImpl<$Res, $Val extends GetConditionsInput>
    implements $GetConditionsInputCopyWith<$Res> {
  _$GetConditionsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetConditionsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? status = freezed,
    Object? includeArchived = null,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ConditionStatus?,
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
abstract class _$$GetConditionsInputImplCopyWith<$Res>
    implements $GetConditionsInputCopyWith<$Res> {
  factory _$$GetConditionsInputImplCopyWith(
    _$GetConditionsInputImpl value,
    $Res Function(_$GetConditionsInputImpl) then,
  ) = __$$GetConditionsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, ConditionStatus? status, bool includeArchived});
}

/// @nodoc
class __$$GetConditionsInputImplCopyWithImpl<$Res>
    extends _$GetConditionsInputCopyWithImpl<$Res, _$GetConditionsInputImpl>
    implements _$$GetConditionsInputImplCopyWith<$Res> {
  __$$GetConditionsInputImplCopyWithImpl(
    _$GetConditionsInputImpl _value,
    $Res Function(_$GetConditionsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetConditionsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? status = freezed,
    Object? includeArchived = null,
  }) {
    return _then(
      _$GetConditionsInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ConditionStatus?,
        includeArchived: null == includeArchived
            ? _value.includeArchived
            : includeArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GetConditionsInputImpl implements _GetConditionsInput {
  const _$GetConditionsInputImpl({
    required this.profileId,
    this.status,
    this.includeArchived = false,
  });

  @override
  final String profileId;
  @override
  final ConditionStatus? status;
  @override
  @JsonKey()
  final bool includeArchived;

  @override
  String toString() {
    return 'GetConditionsInput(profileId: $profileId, status: $status, includeArchived: $includeArchived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetConditionsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.includeArchived, includeArchived) ||
                other.includeArchived == includeArchived));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, status, includeArchived);

  /// Create a copy of GetConditionsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetConditionsInputImplCopyWith<_$GetConditionsInputImpl> get copyWith =>
      __$$GetConditionsInputImplCopyWithImpl<_$GetConditionsInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetConditionsInput implements GetConditionsInput {
  const factory _GetConditionsInput({
    required final String profileId,
    final ConditionStatus? status,
    final bool includeArchived,
  }) = _$GetConditionsInputImpl;

  @override
  String get profileId;
  @override
  ConditionStatus? get status;
  @override
  bool get includeArchived;

  /// Create a copy of GetConditionsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetConditionsInputImplCopyWith<_$GetConditionsInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CreateConditionInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get bodyLocations => throw _privateConstructorUsedError;
  List<String> get triggers => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get baselinePhotoPath => throw _privateConstructorUsedError;
  int get startTimeframe => throw _privateConstructorUsedError; // Epoch ms
  int? get endDate => throw _privateConstructorUsedError; // Epoch ms
  String? get activityId => throw _privateConstructorUsedError;

  /// Create a copy of CreateConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateConditionInputCopyWith<CreateConditionInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateConditionInputCopyWith<$Res> {
  factory $CreateConditionInputCopyWith(
    CreateConditionInput value,
    $Res Function(CreateConditionInput) then,
  ) = _$CreateConditionInputCopyWithImpl<$Res, CreateConditionInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String name,
    String category,
    List<String> bodyLocations,
    List<String> triggers,
    String? description,
    String? baselinePhotoPath,
    int startTimeframe,
    int? endDate,
    String? activityId,
  });
}

/// @nodoc
class _$CreateConditionInputCopyWithImpl<
  $Res,
  $Val extends CreateConditionInput
>
    implements $CreateConditionInputCopyWith<$Res> {
  _$CreateConditionInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? name = null,
    Object? category = null,
    Object? bodyLocations = null,
    Object? triggers = null,
    Object? description = freezed,
    Object? baselinePhotoPath = freezed,
    Object? startTimeframe = null,
    Object? endDate = freezed,
    Object? activityId = freezed,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            bodyLocations: null == bodyLocations
                ? _value.bodyLocations
                : bodyLocations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            triggers: null == triggers
                ? _value.triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            baselinePhotoPath: freezed == baselinePhotoPath
                ? _value.baselinePhotoPath
                : baselinePhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            startTimeframe: null == startTimeframe
                ? _value.startTimeframe
                : startTimeframe // ignore: cast_nullable_to_non_nullable
                      as int,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            activityId: freezed == activityId
                ? _value.activityId
                : activityId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateConditionInputImplCopyWith<$Res>
    implements $CreateConditionInputCopyWith<$Res> {
  factory _$$CreateConditionInputImplCopyWith(
    _$CreateConditionInputImpl value,
    $Res Function(_$CreateConditionInputImpl) then,
  ) = __$$CreateConditionInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String name,
    String category,
    List<String> bodyLocations,
    List<String> triggers,
    String? description,
    String? baselinePhotoPath,
    int startTimeframe,
    int? endDate,
    String? activityId,
  });
}

/// @nodoc
class __$$CreateConditionInputImplCopyWithImpl<$Res>
    extends _$CreateConditionInputCopyWithImpl<$Res, _$CreateConditionInputImpl>
    implements _$$CreateConditionInputImplCopyWith<$Res> {
  __$$CreateConditionInputImplCopyWithImpl(
    _$CreateConditionInputImpl _value,
    $Res Function(_$CreateConditionInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? name = null,
    Object? category = null,
    Object? bodyLocations = null,
    Object? triggers = null,
    Object? description = freezed,
    Object? baselinePhotoPath = freezed,
    Object? startTimeframe = null,
    Object? endDate = freezed,
    Object? activityId = freezed,
  }) {
    return _then(
      _$CreateConditionInputImpl(
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
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        bodyLocations: null == bodyLocations
            ? _value._bodyLocations
            : bodyLocations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        triggers: null == triggers
            ? _value._triggers
            : triggers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        baselinePhotoPath: freezed == baselinePhotoPath
            ? _value.baselinePhotoPath
            : baselinePhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        startTimeframe: null == startTimeframe
            ? _value.startTimeframe
            : startTimeframe // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        activityId: freezed == activityId
            ? _value.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CreateConditionInputImpl implements _CreateConditionInput {
  const _$CreateConditionInputImpl({
    required this.profileId,
    required this.clientId,
    required this.name,
    required this.category,
    final List<String> bodyLocations = const [],
    final List<String> triggers = const [],
    this.description,
    this.baselinePhotoPath,
    required this.startTimeframe,
    this.endDate,
    this.activityId,
  }) : _bodyLocations = bodyLocations,
       _triggers = triggers;

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final String name;
  @override
  final String category;
  final List<String> _bodyLocations;
  @override
  @JsonKey()
  List<String> get bodyLocations {
    if (_bodyLocations is EqualUnmodifiableListView) return _bodyLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bodyLocations);
  }

  final List<String> _triggers;
  @override
  @JsonKey()
  List<String> get triggers {
    if (_triggers is EqualUnmodifiableListView) return _triggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggers);
  }

  @override
  final String? description;
  @override
  final String? baselinePhotoPath;
  @override
  final int startTimeframe;
  // Epoch ms
  @override
  final int? endDate;
  // Epoch ms
  @override
  final String? activityId;

  @override
  String toString() {
    return 'CreateConditionInput(profileId: $profileId, clientId: $clientId, name: $name, category: $category, bodyLocations: $bodyLocations, triggers: $triggers, description: $description, baselinePhotoPath: $baselinePhotoPath, startTimeframe: $startTimeframe, endDate: $endDate, activityId: $activityId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateConditionInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(
              other._bodyLocations,
              _bodyLocations,
            ) &&
            const DeepCollectionEquality().equals(other._triggers, _triggers) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.baselinePhotoPath, baselinePhotoPath) ||
                other.baselinePhotoPath == baselinePhotoPath) &&
            (identical(other.startTimeframe, startTimeframe) ||
                other.startTimeframe == startTimeframe) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    name,
    category,
    const DeepCollectionEquality().hash(_bodyLocations),
    const DeepCollectionEquality().hash(_triggers),
    description,
    baselinePhotoPath,
    startTimeframe,
    endDate,
    activityId,
  );

  /// Create a copy of CreateConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateConditionInputImplCopyWith<_$CreateConditionInputImpl>
  get copyWith =>
      __$$CreateConditionInputImplCopyWithImpl<_$CreateConditionInputImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateConditionInput implements CreateConditionInput {
  const factory _CreateConditionInput({
    required final String profileId,
    required final String clientId,
    required final String name,
    required final String category,
    final List<String> bodyLocations,
    final List<String> triggers,
    final String? description,
    final String? baselinePhotoPath,
    required final int startTimeframe,
    final int? endDate,
    final String? activityId,
  }) = _$CreateConditionInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  String get name;
  @override
  String get category;
  @override
  List<String> get bodyLocations;
  @override
  List<String> get triggers;
  @override
  String? get description;
  @override
  String? get baselinePhotoPath;
  @override
  int get startTimeframe; // Epoch ms
  @override
  int? get endDate; // Epoch ms
  @override
  String? get activityId;

  /// Create a copy of CreateConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateConditionInputImplCopyWith<_$CreateConditionInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ArchiveConditionInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  bool get archive => throw _privateConstructorUsedError;

  /// Create a copy of ArchiveConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArchiveConditionInputCopyWith<ArchiveConditionInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchiveConditionInputCopyWith<$Res> {
  factory $ArchiveConditionInputCopyWith(
    ArchiveConditionInput value,
    $Res Function(ArchiveConditionInput) then,
  ) = _$ArchiveConditionInputCopyWithImpl<$Res, ArchiveConditionInput>;
  @useResult
  $Res call({String id, String profileId, bool archive});
}

/// @nodoc
class _$ArchiveConditionInputCopyWithImpl<
  $Res,
  $Val extends ArchiveConditionInput
>
    implements $ArchiveConditionInputCopyWith<$Res> {
  _$ArchiveConditionInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArchiveConditionInput
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
abstract class _$$ArchiveConditionInputImplCopyWith<$Res>
    implements $ArchiveConditionInputCopyWith<$Res> {
  factory _$$ArchiveConditionInputImplCopyWith(
    _$ArchiveConditionInputImpl value,
    $Res Function(_$ArchiveConditionInputImpl) then,
  ) = __$$ArchiveConditionInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId, bool archive});
}

/// @nodoc
class __$$ArchiveConditionInputImplCopyWithImpl<$Res>
    extends
        _$ArchiveConditionInputCopyWithImpl<$Res, _$ArchiveConditionInputImpl>
    implements _$$ArchiveConditionInputImplCopyWith<$Res> {
  __$$ArchiveConditionInputImplCopyWithImpl(
    _$ArchiveConditionInputImpl _value,
    $Res Function(_$ArchiveConditionInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArchiveConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? archive = null,
  }) {
    return _then(
      _$ArchiveConditionInputImpl(
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

class _$ArchiveConditionInputImpl implements _ArchiveConditionInput {
  const _$ArchiveConditionInputImpl({
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
    return 'ArchiveConditionInput(id: $id, profileId: $profileId, archive: $archive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchiveConditionInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.archive, archive) || other.archive == archive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId, archive);

  /// Create a copy of ArchiveConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchiveConditionInputImplCopyWith<_$ArchiveConditionInputImpl>
  get copyWith =>
      __$$ArchiveConditionInputImplCopyWithImpl<_$ArchiveConditionInputImpl>(
        this,
        _$identity,
      );
}

abstract class _ArchiveConditionInput implements ArchiveConditionInput {
  const factory _ArchiveConditionInput({
    required final String id,
    required final String profileId,
    required final bool archive,
  }) = _$ArchiveConditionInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  bool get archive;

  /// Create a copy of ArchiveConditionInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArchiveConditionInputImplCopyWith<_$ArchiveConditionInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}
