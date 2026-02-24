// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateDietInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DietPresetType? get presetType =>
      throw _privateConstructorUsedError; // null = fully custom diet
  List<DietRule> get initialRules =>
      throw _privateConstructorUsedError; // Custom rules to add after creation
  bool get activateImmediately =>
      throw _privateConstructorUsedError; // true = deactivate current + activate this
  bool get isDraft => throw _privateConstructorUsedError;
  int? get startDateEpoch =>
      throw _privateConstructorUsedError; // Epoch ms; defaults to now
  int? get endDateEpoch => throw _privateConstructorUsedError;

  /// Create a copy of CreateDietInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateDietInputCopyWith<CreateDietInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateDietInputCopyWith<$Res> {
  factory $CreateDietInputCopyWith(
    CreateDietInput value,
    $Res Function(CreateDietInput) then,
  ) = _$CreateDietInputCopyWithImpl<$Res, CreateDietInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String name,
    String description,
    DietPresetType? presetType,
    List<DietRule> initialRules,
    bool activateImmediately,
    bool isDraft,
    int? startDateEpoch,
    int? endDateEpoch,
  });
}

/// @nodoc
class _$CreateDietInputCopyWithImpl<$Res, $Val extends CreateDietInput>
    implements $CreateDietInputCopyWith<$Res> {
  _$CreateDietInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateDietInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? name = null,
    Object? description = null,
    Object? presetType = freezed,
    Object? initialRules = null,
    Object? activateImmediately = null,
    Object? isDraft = null,
    Object? startDateEpoch = freezed,
    Object? endDateEpoch = freezed,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            presetType: freezed == presetType
                ? _value.presetType
                : presetType // ignore: cast_nullable_to_non_nullable
                      as DietPresetType?,
            initialRules: null == initialRules
                ? _value.initialRules
                : initialRules // ignore: cast_nullable_to_non_nullable
                      as List<DietRule>,
            activateImmediately: null == activateImmediately
                ? _value.activateImmediately
                : activateImmediately // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDraft: null == isDraft
                ? _value.isDraft
                : isDraft // ignore: cast_nullable_to_non_nullable
                      as bool,
            startDateEpoch: freezed == startDateEpoch
                ? _value.startDateEpoch
                : startDateEpoch // ignore: cast_nullable_to_non_nullable
                      as int?,
            endDateEpoch: freezed == endDateEpoch
                ? _value.endDateEpoch
                : endDateEpoch // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateDietInputImplCopyWith<$Res>
    implements $CreateDietInputCopyWith<$Res> {
  factory _$$CreateDietInputImplCopyWith(
    _$CreateDietInputImpl value,
    $Res Function(_$CreateDietInputImpl) then,
  ) = __$$CreateDietInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String name,
    String description,
    DietPresetType? presetType,
    List<DietRule> initialRules,
    bool activateImmediately,
    bool isDraft,
    int? startDateEpoch,
    int? endDateEpoch,
  });
}

/// @nodoc
class __$$CreateDietInputImplCopyWithImpl<$Res>
    extends _$CreateDietInputCopyWithImpl<$Res, _$CreateDietInputImpl>
    implements _$$CreateDietInputImplCopyWith<$Res> {
  __$$CreateDietInputImplCopyWithImpl(
    _$CreateDietInputImpl _value,
    $Res Function(_$CreateDietInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateDietInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? name = null,
    Object? description = null,
    Object? presetType = freezed,
    Object? initialRules = null,
    Object? activateImmediately = null,
    Object? isDraft = null,
    Object? startDateEpoch = freezed,
    Object? endDateEpoch = freezed,
  }) {
    return _then(
      _$CreateDietInputImpl(
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
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        presetType: freezed == presetType
            ? _value.presetType
            : presetType // ignore: cast_nullable_to_non_nullable
                  as DietPresetType?,
        initialRules: null == initialRules
            ? _value._initialRules
            : initialRules // ignore: cast_nullable_to_non_nullable
                  as List<DietRule>,
        activateImmediately: null == activateImmediately
            ? _value.activateImmediately
            : activateImmediately // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDraft: null == isDraft
            ? _value.isDraft
            : isDraft // ignore: cast_nullable_to_non_nullable
                  as bool,
        startDateEpoch: freezed == startDateEpoch
            ? _value.startDateEpoch
            : startDateEpoch // ignore: cast_nullable_to_non_nullable
                  as int?,
        endDateEpoch: freezed == endDateEpoch
            ? _value.endDateEpoch
            : endDateEpoch // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$CreateDietInputImpl implements _CreateDietInput {
  const _$CreateDietInputImpl({
    required this.profileId,
    required this.clientId,
    required this.name,
    this.description = '',
    this.presetType,
    final List<DietRule> initialRules = const [],
    this.activateImmediately = false,
    this.isDraft = false,
    this.startDateEpoch,
    this.endDateEpoch,
  }) : _initialRules = initialRules;

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  final DietPresetType? presetType;
  // null = fully custom diet
  final List<DietRule> _initialRules;
  // null = fully custom diet
  @override
  @JsonKey()
  List<DietRule> get initialRules {
    if (_initialRules is EqualUnmodifiableListView) return _initialRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_initialRules);
  }

  // Custom rules to add after creation
  @override
  @JsonKey()
  final bool activateImmediately;
  // true = deactivate current + activate this
  @override
  @JsonKey()
  final bool isDraft;
  @override
  final int? startDateEpoch;
  // Epoch ms; defaults to now
  @override
  final int? endDateEpoch;

  @override
  String toString() {
    return 'CreateDietInput(profileId: $profileId, clientId: $clientId, name: $name, description: $description, presetType: $presetType, initialRules: $initialRules, activateImmediately: $activateImmediately, isDraft: $isDraft, startDateEpoch: $startDateEpoch, endDateEpoch: $endDateEpoch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateDietInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.presetType, presetType) ||
                other.presetType == presetType) &&
            const DeepCollectionEquality().equals(
              other._initialRules,
              _initialRules,
            ) &&
            (identical(other.activateImmediately, activateImmediately) ||
                other.activateImmediately == activateImmediately) &&
            (identical(other.isDraft, isDraft) || other.isDraft == isDraft) &&
            (identical(other.startDateEpoch, startDateEpoch) ||
                other.startDateEpoch == startDateEpoch) &&
            (identical(other.endDateEpoch, endDateEpoch) ||
                other.endDateEpoch == endDateEpoch));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    name,
    description,
    presetType,
    const DeepCollectionEquality().hash(_initialRules),
    activateImmediately,
    isDraft,
    startDateEpoch,
    endDateEpoch,
  );

  /// Create a copy of CreateDietInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateDietInputImplCopyWith<_$CreateDietInputImpl> get copyWith =>
      __$$CreateDietInputImplCopyWithImpl<_$CreateDietInputImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateDietInput implements CreateDietInput {
  const factory _CreateDietInput({
    required final String profileId,
    required final String clientId,
    required final String name,
    final String description,
    final DietPresetType? presetType,
    final List<DietRule> initialRules,
    final bool activateImmediately,
    final bool isDraft,
    final int? startDateEpoch,
    final int? endDateEpoch,
  }) = _$CreateDietInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  String get name;
  @override
  String get description;
  @override
  DietPresetType? get presetType; // null = fully custom diet
  @override
  List<DietRule> get initialRules; // Custom rules to add after creation
  @override
  bool get activateImmediately; // true = deactivate current + activate this
  @override
  bool get isDraft;
  @override
  int? get startDateEpoch; // Epoch ms; defaults to now
  @override
  int? get endDateEpoch;

  /// Create a copy of CreateDietInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateDietInputImplCopyWith<_$CreateDietInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetDietsInput {
  String get profileId => throw _privateConstructorUsedError;
  bool get activeOnly => throw _privateConstructorUsedError;

  /// Create a copy of GetDietsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetDietsInputCopyWith<GetDietsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetDietsInputCopyWith<$Res> {
  factory $GetDietsInputCopyWith(
    GetDietsInput value,
    $Res Function(GetDietsInput) then,
  ) = _$GetDietsInputCopyWithImpl<$Res, GetDietsInput>;
  @useResult
  $Res call({String profileId, bool activeOnly});
}

/// @nodoc
class _$GetDietsInputCopyWithImpl<$Res, $Val extends GetDietsInput>
    implements $GetDietsInputCopyWith<$Res> {
  _$GetDietsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetDietsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? activeOnly = null}) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            activeOnly: null == activeOnly
                ? _value.activeOnly
                : activeOnly // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetDietsInputImplCopyWith<$Res>
    implements $GetDietsInputCopyWith<$Res> {
  factory _$$GetDietsInputImplCopyWith(
    _$GetDietsInputImpl value,
    $Res Function(_$GetDietsInputImpl) then,
  ) = __$$GetDietsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, bool activeOnly});
}

/// @nodoc
class __$$GetDietsInputImplCopyWithImpl<$Res>
    extends _$GetDietsInputCopyWithImpl<$Res, _$GetDietsInputImpl>
    implements _$$GetDietsInputImplCopyWith<$Res> {
  __$$GetDietsInputImplCopyWithImpl(
    _$GetDietsInputImpl _value,
    $Res Function(_$GetDietsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetDietsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? activeOnly = null}) {
    return _then(
      _$GetDietsInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        activeOnly: null == activeOnly
            ? _value.activeOnly
            : activeOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GetDietsInputImpl implements _GetDietsInput {
  const _$GetDietsInputImpl({required this.profileId, this.activeOnly = false});

  @override
  final String profileId;
  @override
  @JsonKey()
  final bool activeOnly;

  @override
  String toString() {
    return 'GetDietsInput(profileId: $profileId, activeOnly: $activeOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetDietsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.activeOnly, activeOnly) ||
                other.activeOnly == activeOnly));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, activeOnly);

  /// Create a copy of GetDietsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetDietsInputImplCopyWith<_$GetDietsInputImpl> get copyWith =>
      __$$GetDietsInputImplCopyWithImpl<_$GetDietsInputImpl>(this, _$identity);
}

abstract class _GetDietsInput implements GetDietsInput {
  const factory _GetDietsInput({
    required final String profileId,
    final bool activeOnly,
  }) = _$GetDietsInputImpl;

  @override
  String get profileId;
  @override
  bool get activeOnly;

  /// Create a copy of GetDietsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetDietsInputImplCopyWith<_$GetDietsInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetActiveDietInput {
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of GetActiveDietInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetActiveDietInputCopyWith<GetActiveDietInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetActiveDietInputCopyWith<$Res> {
  factory $GetActiveDietInputCopyWith(
    GetActiveDietInput value,
    $Res Function(GetActiveDietInput) then,
  ) = _$GetActiveDietInputCopyWithImpl<$Res, GetActiveDietInput>;
  @useResult
  $Res call({String profileId});
}

/// @nodoc
class _$GetActiveDietInputCopyWithImpl<$Res, $Val extends GetActiveDietInput>
    implements $GetActiveDietInputCopyWith<$Res> {
  _$GetActiveDietInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetActiveDietInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null}) {
    return _then(
      _value.copyWith(
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
abstract class _$$GetActiveDietInputImplCopyWith<$Res>
    implements $GetActiveDietInputCopyWith<$Res> {
  factory _$$GetActiveDietInputImplCopyWith(
    _$GetActiveDietInputImpl value,
    $Res Function(_$GetActiveDietInputImpl) then,
  ) = __$$GetActiveDietInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId});
}

/// @nodoc
class __$$GetActiveDietInputImplCopyWithImpl<$Res>
    extends _$GetActiveDietInputCopyWithImpl<$Res, _$GetActiveDietInputImpl>
    implements _$$GetActiveDietInputImplCopyWith<$Res> {
  __$$GetActiveDietInputImplCopyWithImpl(
    _$GetActiveDietInputImpl _value,
    $Res Function(_$GetActiveDietInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetActiveDietInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null}) {
    return _then(
      _$GetActiveDietInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GetActiveDietInputImpl implements _GetActiveDietInput {
  const _$GetActiveDietInputImpl({required this.profileId});

  @override
  final String profileId;

  @override
  String toString() {
    return 'GetActiveDietInput(profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetActiveDietInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId);

  /// Create a copy of GetActiveDietInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetActiveDietInputImplCopyWith<_$GetActiveDietInputImpl> get copyWith =>
      __$$GetActiveDietInputImplCopyWithImpl<_$GetActiveDietInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetActiveDietInput implements GetActiveDietInput {
  const factory _GetActiveDietInput({required final String profileId}) =
      _$GetActiveDietInputImpl;

  @override
  String get profileId;

  /// Create a copy of GetActiveDietInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetActiveDietInputImplCopyWith<_$GetActiveDietInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ActivateDietInput {
  String get profileId => throw _privateConstructorUsedError;
  String get dietId => throw _privateConstructorUsedError;

  /// Create a copy of ActivateDietInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivateDietInputCopyWith<ActivateDietInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivateDietInputCopyWith<$Res> {
  factory $ActivateDietInputCopyWith(
    ActivateDietInput value,
    $Res Function(ActivateDietInput) then,
  ) = _$ActivateDietInputCopyWithImpl<$Res, ActivateDietInput>;
  @useResult
  $Res call({String profileId, String dietId});
}

/// @nodoc
class _$ActivateDietInputCopyWithImpl<$Res, $Val extends ActivateDietInput>
    implements $ActivateDietInputCopyWith<$Res> {
  _$ActivateDietInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivateDietInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? dietId = null}) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            dietId: null == dietId
                ? _value.dietId
                : dietId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivateDietInputImplCopyWith<$Res>
    implements $ActivateDietInputCopyWith<$Res> {
  factory _$$ActivateDietInputImplCopyWith(
    _$ActivateDietInputImpl value,
    $Res Function(_$ActivateDietInputImpl) then,
  ) = __$$ActivateDietInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, String dietId});
}

/// @nodoc
class __$$ActivateDietInputImplCopyWithImpl<$Res>
    extends _$ActivateDietInputCopyWithImpl<$Res, _$ActivateDietInputImpl>
    implements _$$ActivateDietInputImplCopyWith<$Res> {
  __$$ActivateDietInputImplCopyWithImpl(
    _$ActivateDietInputImpl _value,
    $Res Function(_$ActivateDietInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivateDietInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profileId = null, Object? dietId = null}) {
    return _then(
      _$ActivateDietInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        dietId: null == dietId
            ? _value.dietId
            : dietId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ActivateDietInputImpl implements _ActivateDietInput {
  const _$ActivateDietInputImpl({
    required this.profileId,
    required this.dietId,
  });

  @override
  final String profileId;
  @override
  final String dietId;

  @override
  String toString() {
    return 'ActivateDietInput(profileId: $profileId, dietId: $dietId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivateDietInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.dietId, dietId) || other.dietId == dietId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileId, dietId);

  /// Create a copy of ActivateDietInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivateDietInputImplCopyWith<_$ActivateDietInputImpl> get copyWith =>
      __$$ActivateDietInputImplCopyWithImpl<_$ActivateDietInputImpl>(
        this,
        _$identity,
      );
}

abstract class _ActivateDietInput implements ActivateDietInput {
  const factory _ActivateDietInput({
    required final String profileId,
    required final String dietId,
  }) = _$ActivateDietInputImpl;

  @override
  String get profileId;
  @override
  String get dietId;

  /// Create a copy of ActivateDietInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivateDietInputImplCopyWith<_$ActivateDietInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CheckComplianceInput {
  String get profileId => throw _privateConstructorUsedError;
  String get dietId => throw _privateConstructorUsedError;
  FoodItem get foodItem => throw _privateConstructorUsedError;
  int get logTimeEpoch => throw _privateConstructorUsedError;

  /// Create a copy of CheckComplianceInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckComplianceInputCopyWith<CheckComplianceInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckComplianceInputCopyWith<$Res> {
  factory $CheckComplianceInputCopyWith(
    CheckComplianceInput value,
    $Res Function(CheckComplianceInput) then,
  ) = _$CheckComplianceInputCopyWithImpl<$Res, CheckComplianceInput>;
  @useResult
  $Res call({
    String profileId,
    String dietId,
    FoodItem foodItem,
    int logTimeEpoch,
  });

  $FoodItemCopyWith<$Res> get foodItem;
}

/// @nodoc
class _$CheckComplianceInputCopyWithImpl<
  $Res,
  $Val extends CheckComplianceInput
>
    implements $CheckComplianceInputCopyWith<$Res> {
  _$CheckComplianceInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckComplianceInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? dietId = null,
    Object? foodItem = null,
    Object? logTimeEpoch = null,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            dietId: null == dietId
                ? _value.dietId
                : dietId // ignore: cast_nullable_to_non_nullable
                      as String,
            foodItem: null == foodItem
                ? _value.foodItem
                : foodItem // ignore: cast_nullable_to_non_nullable
                      as FoodItem,
            logTimeEpoch: null == logTimeEpoch
                ? _value.logTimeEpoch
                : logTimeEpoch // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of CheckComplianceInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodItemCopyWith<$Res> get foodItem {
    return $FoodItemCopyWith<$Res>(_value.foodItem, (value) {
      return _then(_value.copyWith(foodItem: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckComplianceInputImplCopyWith<$Res>
    implements $CheckComplianceInputCopyWith<$Res> {
  factory _$$CheckComplianceInputImplCopyWith(
    _$CheckComplianceInputImpl value,
    $Res Function(_$CheckComplianceInputImpl) then,
  ) = __$$CheckComplianceInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String dietId,
    FoodItem foodItem,
    int logTimeEpoch,
  });

  @override
  $FoodItemCopyWith<$Res> get foodItem;
}

/// @nodoc
class __$$CheckComplianceInputImplCopyWithImpl<$Res>
    extends _$CheckComplianceInputCopyWithImpl<$Res, _$CheckComplianceInputImpl>
    implements _$$CheckComplianceInputImplCopyWith<$Res> {
  __$$CheckComplianceInputImplCopyWithImpl(
    _$CheckComplianceInputImpl _value,
    $Res Function(_$CheckComplianceInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckComplianceInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? dietId = null,
    Object? foodItem = null,
    Object? logTimeEpoch = null,
  }) {
    return _then(
      _$CheckComplianceInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        dietId: null == dietId
            ? _value.dietId
            : dietId // ignore: cast_nullable_to_non_nullable
                  as String,
        foodItem: null == foodItem
            ? _value.foodItem
            : foodItem // ignore: cast_nullable_to_non_nullable
                  as FoodItem,
        logTimeEpoch: null == logTimeEpoch
            ? _value.logTimeEpoch
            : logTimeEpoch // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CheckComplianceInputImpl implements _CheckComplianceInput {
  const _$CheckComplianceInputImpl({
    required this.profileId,
    required this.dietId,
    required this.foodItem,
    required this.logTimeEpoch,
  });

  @override
  final String profileId;
  @override
  final String dietId;
  @override
  final FoodItem foodItem;
  @override
  final int logTimeEpoch;

  @override
  String toString() {
    return 'CheckComplianceInput(profileId: $profileId, dietId: $dietId, foodItem: $foodItem, logTimeEpoch: $logTimeEpoch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckComplianceInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.dietId, dietId) || other.dietId == dietId) &&
            (identical(other.foodItem, foodItem) ||
                other.foodItem == foodItem) &&
            (identical(other.logTimeEpoch, logTimeEpoch) ||
                other.logTimeEpoch == logTimeEpoch));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, dietId, foodItem, logTimeEpoch);

  /// Create a copy of CheckComplianceInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckComplianceInputImplCopyWith<_$CheckComplianceInputImpl>
  get copyWith =>
      __$$CheckComplianceInputImplCopyWithImpl<_$CheckComplianceInputImpl>(
        this,
        _$identity,
      );
}

abstract class _CheckComplianceInput implements CheckComplianceInput {
  const factory _CheckComplianceInput({
    required final String profileId,
    required final String dietId,
    required final FoodItem foodItem,
    required final int logTimeEpoch,
  }) = _$CheckComplianceInputImpl;

  @override
  String get profileId;
  @override
  String get dietId;
  @override
  FoodItem get foodItem;
  @override
  int get logTimeEpoch;

  /// Create a copy of CheckComplianceInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckComplianceInputImplCopyWith<_$CheckComplianceInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ComplianceCheckResult {
  bool get isCompliant => throw _privateConstructorUsedError;
  List<DietRule> get violatedRules => throw _privateConstructorUsedError;
  double get complianceImpact =>
      throw _privateConstructorUsedError; // Estimated % reduction in daily compliance
  List<FoodItem> get alternatives => throw _privateConstructorUsedError;

  /// Create a copy of ComplianceCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComplianceCheckResultCopyWith<ComplianceCheckResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComplianceCheckResultCopyWith<$Res> {
  factory $ComplianceCheckResultCopyWith(
    ComplianceCheckResult value,
    $Res Function(ComplianceCheckResult) then,
  ) = _$ComplianceCheckResultCopyWithImpl<$Res, ComplianceCheckResult>;
  @useResult
  $Res call({
    bool isCompliant,
    List<DietRule> violatedRules,
    double complianceImpact,
    List<FoodItem> alternatives,
  });
}

/// @nodoc
class _$ComplianceCheckResultCopyWithImpl<
  $Res,
  $Val extends ComplianceCheckResult
>
    implements $ComplianceCheckResultCopyWith<$Res> {
  _$ComplianceCheckResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComplianceCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCompliant = null,
    Object? violatedRules = null,
    Object? complianceImpact = null,
    Object? alternatives = null,
  }) {
    return _then(
      _value.copyWith(
            isCompliant: null == isCompliant
                ? _value.isCompliant
                : isCompliant // ignore: cast_nullable_to_non_nullable
                      as bool,
            violatedRules: null == violatedRules
                ? _value.violatedRules
                : violatedRules // ignore: cast_nullable_to_non_nullable
                      as List<DietRule>,
            complianceImpact: null == complianceImpact
                ? _value.complianceImpact
                : complianceImpact // ignore: cast_nullable_to_non_nullable
                      as double,
            alternatives: null == alternatives
                ? _value.alternatives
                : alternatives // ignore: cast_nullable_to_non_nullable
                      as List<FoodItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ComplianceCheckResultImplCopyWith<$Res>
    implements $ComplianceCheckResultCopyWith<$Res> {
  factory _$$ComplianceCheckResultImplCopyWith(
    _$ComplianceCheckResultImpl value,
    $Res Function(_$ComplianceCheckResultImpl) then,
  ) = __$$ComplianceCheckResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isCompliant,
    List<DietRule> violatedRules,
    double complianceImpact,
    List<FoodItem> alternatives,
  });
}

/// @nodoc
class __$$ComplianceCheckResultImplCopyWithImpl<$Res>
    extends
        _$ComplianceCheckResultCopyWithImpl<$Res, _$ComplianceCheckResultImpl>
    implements _$$ComplianceCheckResultImplCopyWith<$Res> {
  __$$ComplianceCheckResultImplCopyWithImpl(
    _$ComplianceCheckResultImpl _value,
    $Res Function(_$ComplianceCheckResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ComplianceCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCompliant = null,
    Object? violatedRules = null,
    Object? complianceImpact = null,
    Object? alternatives = null,
  }) {
    return _then(
      _$ComplianceCheckResultImpl(
        isCompliant: null == isCompliant
            ? _value.isCompliant
            : isCompliant // ignore: cast_nullable_to_non_nullable
                  as bool,
        violatedRules: null == violatedRules
            ? _value._violatedRules
            : violatedRules // ignore: cast_nullable_to_non_nullable
                  as List<DietRule>,
        complianceImpact: null == complianceImpact
            ? _value.complianceImpact
            : complianceImpact // ignore: cast_nullable_to_non_nullable
                  as double,
        alternatives: null == alternatives
            ? _value._alternatives
            : alternatives // ignore: cast_nullable_to_non_nullable
                  as List<FoodItem>,
      ),
    );
  }
}

/// @nodoc

class _$ComplianceCheckResultImpl implements _ComplianceCheckResult {
  const _$ComplianceCheckResultImpl({
    required this.isCompliant,
    required final List<DietRule> violatedRules,
    required this.complianceImpact,
    required final List<FoodItem> alternatives,
  }) : _violatedRules = violatedRules,
       _alternatives = alternatives;

  @override
  final bool isCompliant;
  final List<DietRule> _violatedRules;
  @override
  List<DietRule> get violatedRules {
    if (_violatedRules is EqualUnmodifiableListView) return _violatedRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_violatedRules);
  }

  @override
  final double complianceImpact;
  // Estimated % reduction in daily compliance
  final List<FoodItem> _alternatives;
  // Estimated % reduction in daily compliance
  @override
  List<FoodItem> get alternatives {
    if (_alternatives is EqualUnmodifiableListView) return _alternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternatives);
  }

  @override
  String toString() {
    return 'ComplianceCheckResult(isCompliant: $isCompliant, violatedRules: $violatedRules, complianceImpact: $complianceImpact, alternatives: $alternatives)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComplianceCheckResultImpl &&
            (identical(other.isCompliant, isCompliant) ||
                other.isCompliant == isCompliant) &&
            const DeepCollectionEquality().equals(
              other._violatedRules,
              _violatedRules,
            ) &&
            (identical(other.complianceImpact, complianceImpact) ||
                other.complianceImpact == complianceImpact) &&
            const DeepCollectionEquality().equals(
              other._alternatives,
              _alternatives,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isCompliant,
    const DeepCollectionEquality().hash(_violatedRules),
    complianceImpact,
    const DeepCollectionEquality().hash(_alternatives),
  );

  /// Create a copy of ComplianceCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComplianceCheckResultImplCopyWith<_$ComplianceCheckResultImpl>
  get copyWith =>
      __$$ComplianceCheckResultImplCopyWithImpl<_$ComplianceCheckResultImpl>(
        this,
        _$identity,
      );
}

abstract class _ComplianceCheckResult implements ComplianceCheckResult {
  const factory _ComplianceCheckResult({
    required final bool isCompliant,
    required final List<DietRule> violatedRules,
    required final double complianceImpact,
    required final List<FoodItem> alternatives,
  }) = _$ComplianceCheckResultImpl;

  @override
  bool get isCompliant;
  @override
  List<DietRule> get violatedRules;
  @override
  double get complianceImpact; // Estimated % reduction in daily compliance
  @override
  List<FoodItem> get alternatives;

  /// Create a copy of ComplianceCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComplianceCheckResultImplCopyWith<_$ComplianceCheckResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RecordViolationInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get dietId => throw _privateConstructorUsedError;
  String get ruleId => throw _privateConstructorUsedError;
  String get foodName => throw _privateConstructorUsedError;
  String get ruleDescription => throw _privateConstructorUsedError;
  bool get wasOverridden =>
      throw _privateConstructorUsedError; // true = "Add Anyway", false = "Cancel"
  int get timestamp => throw _privateConstructorUsedError; // Epoch ms
  String? get foodLogId => throw _privateConstructorUsedError;

  /// Create a copy of RecordViolationInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordViolationInputCopyWith<RecordViolationInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordViolationInputCopyWith<$Res> {
  factory $RecordViolationInputCopyWith(
    RecordViolationInput value,
    $Res Function(RecordViolationInput) then,
  ) = _$RecordViolationInputCopyWithImpl<$Res, RecordViolationInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String dietId,
    String ruleId,
    String foodName,
    String ruleDescription,
    bool wasOverridden,
    int timestamp,
    String? foodLogId,
  });
}

/// @nodoc
class _$RecordViolationInputCopyWithImpl<
  $Res,
  $Val extends RecordViolationInput
>
    implements $RecordViolationInputCopyWith<$Res> {
  _$RecordViolationInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordViolationInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? dietId = null,
    Object? ruleId = null,
    Object? foodName = null,
    Object? ruleDescription = null,
    Object? wasOverridden = null,
    Object? timestamp = null,
    Object? foodLogId = freezed,
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
            dietId: null == dietId
                ? _value.dietId
                : dietId // ignore: cast_nullable_to_non_nullable
                      as String,
            ruleId: null == ruleId
                ? _value.ruleId
                : ruleId // ignore: cast_nullable_to_non_nullable
                      as String,
            foodName: null == foodName
                ? _value.foodName
                : foodName // ignore: cast_nullable_to_non_nullable
                      as String,
            ruleDescription: null == ruleDescription
                ? _value.ruleDescription
                : ruleDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            wasOverridden: null == wasOverridden
                ? _value.wasOverridden
                : wasOverridden // ignore: cast_nullable_to_non_nullable
                      as bool,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
            foodLogId: freezed == foodLogId
                ? _value.foodLogId
                : foodLogId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecordViolationInputImplCopyWith<$Res>
    implements $RecordViolationInputCopyWith<$Res> {
  factory _$$RecordViolationInputImplCopyWith(
    _$RecordViolationInputImpl value,
    $Res Function(_$RecordViolationInputImpl) then,
  ) = __$$RecordViolationInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    String dietId,
    String ruleId,
    String foodName,
    String ruleDescription,
    bool wasOverridden,
    int timestamp,
    String? foodLogId,
  });
}

/// @nodoc
class __$$RecordViolationInputImplCopyWithImpl<$Res>
    extends _$RecordViolationInputCopyWithImpl<$Res, _$RecordViolationInputImpl>
    implements _$$RecordViolationInputImplCopyWith<$Res> {
  __$$RecordViolationInputImplCopyWithImpl(
    _$RecordViolationInputImpl _value,
    $Res Function(_$RecordViolationInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordViolationInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? dietId = null,
    Object? ruleId = null,
    Object? foodName = null,
    Object? ruleDescription = null,
    Object? wasOverridden = null,
    Object? timestamp = null,
    Object? foodLogId = freezed,
  }) {
    return _then(
      _$RecordViolationInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        dietId: null == dietId
            ? _value.dietId
            : dietId // ignore: cast_nullable_to_non_nullable
                  as String,
        ruleId: null == ruleId
            ? _value.ruleId
            : ruleId // ignore: cast_nullable_to_non_nullable
                  as String,
        foodName: null == foodName
            ? _value.foodName
            : foodName // ignore: cast_nullable_to_non_nullable
                  as String,
        ruleDescription: null == ruleDescription
            ? _value.ruleDescription
            : ruleDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        wasOverridden: null == wasOverridden
            ? _value.wasOverridden
            : wasOverridden // ignore: cast_nullable_to_non_nullable
                  as bool,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        foodLogId: freezed == foodLogId
            ? _value.foodLogId
            : foodLogId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$RecordViolationInputImpl implements _RecordViolationInput {
  const _$RecordViolationInputImpl({
    required this.profileId,
    required this.clientId,
    required this.dietId,
    required this.ruleId,
    required this.foodName,
    required this.ruleDescription,
    this.wasOverridden = false,
    required this.timestamp,
    this.foodLogId,
  });

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final String dietId;
  @override
  final String ruleId;
  @override
  final String foodName;
  @override
  final String ruleDescription;
  @override
  @JsonKey()
  final bool wasOverridden;
  // true = "Add Anyway", false = "Cancel"
  @override
  final int timestamp;
  // Epoch ms
  @override
  final String? foodLogId;

  @override
  String toString() {
    return 'RecordViolationInput(profileId: $profileId, clientId: $clientId, dietId: $dietId, ruleId: $ruleId, foodName: $foodName, ruleDescription: $ruleDescription, wasOverridden: $wasOverridden, timestamp: $timestamp, foodLogId: $foodLogId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordViolationInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.dietId, dietId) || other.dietId == dietId) &&
            (identical(other.ruleId, ruleId) || other.ruleId == ruleId) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.ruleDescription, ruleDescription) ||
                other.ruleDescription == ruleDescription) &&
            (identical(other.wasOverridden, wasOverridden) ||
                other.wasOverridden == wasOverridden) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.foodLogId, foodLogId) ||
                other.foodLogId == foodLogId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    dietId,
    ruleId,
    foodName,
    ruleDescription,
    wasOverridden,
    timestamp,
    foodLogId,
  );

  /// Create a copy of RecordViolationInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordViolationInputImplCopyWith<_$RecordViolationInputImpl>
  get copyWith =>
      __$$RecordViolationInputImplCopyWithImpl<_$RecordViolationInputImpl>(
        this,
        _$identity,
      );
}

abstract class _RecordViolationInput implements RecordViolationInput {
  const factory _RecordViolationInput({
    required final String profileId,
    required final String clientId,
    required final String dietId,
    required final String ruleId,
    required final String foodName,
    required final String ruleDescription,
    final bool wasOverridden,
    required final int timestamp,
    final String? foodLogId,
  }) = _$RecordViolationInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  String get dietId;
  @override
  String get ruleId;
  @override
  String get foodName;
  @override
  String get ruleDescription;
  @override
  bool get wasOverridden; // true = "Add Anyway", false = "Cancel"
  @override
  int get timestamp; // Epoch ms
  @override
  String? get foodLogId;

  /// Create a copy of RecordViolationInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordViolationInputImplCopyWith<_$RecordViolationInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetViolationsInput {
  String get profileId => throw _privateConstructorUsedError;
  int? get startDate => throw _privateConstructorUsedError; // Epoch ms
  int? get endDate => throw _privateConstructorUsedError; // Epoch ms
  int? get limit => throw _privateConstructorUsedError;

  /// Create a copy of GetViolationsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetViolationsInputCopyWith<GetViolationsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetViolationsInputCopyWith<$Res> {
  factory $GetViolationsInputCopyWith(
    GetViolationsInput value,
    $Res Function(GetViolationsInput) then,
  ) = _$GetViolationsInputCopyWithImpl<$Res, GetViolationsInput>;
  @useResult
  $Res call({String profileId, int? startDate, int? endDate, int? limit});
}

/// @nodoc
class _$GetViolationsInputCopyWithImpl<$Res, $Val extends GetViolationsInput>
    implements $GetViolationsInputCopyWith<$Res> {
  _$GetViolationsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetViolationsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? limit = freezed,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            limit: freezed == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetViolationsInputImplCopyWith<$Res>
    implements $GetViolationsInputCopyWith<$Res> {
  factory _$$GetViolationsInputImplCopyWith(
    _$GetViolationsInputImpl value,
    $Res Function(_$GetViolationsInputImpl) then,
  ) = __$$GetViolationsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileId, int? startDate, int? endDate, int? limit});
}

/// @nodoc
class __$$GetViolationsInputImplCopyWithImpl<$Res>
    extends _$GetViolationsInputCopyWithImpl<$Res, _$GetViolationsInputImpl>
    implements _$$GetViolationsInputImplCopyWith<$Res> {
  __$$GetViolationsInputImplCopyWithImpl(
    _$GetViolationsInputImpl _value,
    $Res Function(_$GetViolationsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetViolationsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? limit = freezed,
  }) {
    return _then(
      _$GetViolationsInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$GetViolationsInputImpl implements _GetViolationsInput {
  const _$GetViolationsInputImpl({
    required this.profileId,
    this.startDate,
    this.endDate,
    this.limit,
  });

  @override
  final String profileId;
  @override
  final int? startDate;
  // Epoch ms
  @override
  final int? endDate;
  // Epoch ms
  @override
  final int? limit;

  @override
  String toString() {
    return 'GetViolationsInput(profileId: $profileId, startDate: $startDate, endDate: $endDate, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetViolationsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, startDate, endDate, limit);

  /// Create a copy of GetViolationsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetViolationsInputImplCopyWith<_$GetViolationsInputImpl> get copyWith =>
      __$$GetViolationsInputImplCopyWithImpl<_$GetViolationsInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetViolationsInput implements GetViolationsInput {
  const factory _GetViolationsInput({
    required final String profileId,
    final int? startDate,
    final int? endDate,
    final int? limit,
  }) = _$GetViolationsInputImpl;

  @override
  String get profileId;
  @override
  int? get startDate; // Epoch ms
  @override
  int? get endDate; // Epoch ms
  @override
  int? get limit;

  /// Create a copy of GetViolationsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetViolationsInputImplCopyWith<_$GetViolationsInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetComplianceStatsInput {
  String get profileId => throw _privateConstructorUsedError;
  String get dietId => throw _privateConstructorUsedError;
  int get startDateEpoch => throw _privateConstructorUsedError; // Epoch ms
  int get endDateEpoch => throw _privateConstructorUsedError;

  /// Create a copy of GetComplianceStatsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetComplianceStatsInputCopyWith<GetComplianceStatsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetComplianceStatsInputCopyWith<$Res> {
  factory $GetComplianceStatsInputCopyWith(
    GetComplianceStatsInput value,
    $Res Function(GetComplianceStatsInput) then,
  ) = _$GetComplianceStatsInputCopyWithImpl<$Res, GetComplianceStatsInput>;
  @useResult
  $Res call({
    String profileId,
    String dietId,
    int startDateEpoch,
    int endDateEpoch,
  });
}

/// @nodoc
class _$GetComplianceStatsInputCopyWithImpl<
  $Res,
  $Val extends GetComplianceStatsInput
>
    implements $GetComplianceStatsInputCopyWith<$Res> {
  _$GetComplianceStatsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetComplianceStatsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? dietId = null,
    Object? startDateEpoch = null,
    Object? endDateEpoch = null,
  }) {
    return _then(
      _value.copyWith(
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            dietId: null == dietId
                ? _value.dietId
                : dietId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDateEpoch: null == startDateEpoch
                ? _value.startDateEpoch
                : startDateEpoch // ignore: cast_nullable_to_non_nullable
                      as int,
            endDateEpoch: null == endDateEpoch
                ? _value.endDateEpoch
                : endDateEpoch // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetComplianceStatsInputImplCopyWith<$Res>
    implements $GetComplianceStatsInputCopyWith<$Res> {
  factory _$$GetComplianceStatsInputImplCopyWith(
    _$GetComplianceStatsInputImpl value,
    $Res Function(_$GetComplianceStatsInputImpl) then,
  ) = __$$GetComplianceStatsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String dietId,
    int startDateEpoch,
    int endDateEpoch,
  });
}

/// @nodoc
class __$$GetComplianceStatsInputImplCopyWithImpl<$Res>
    extends
        _$GetComplianceStatsInputCopyWithImpl<
          $Res,
          _$GetComplianceStatsInputImpl
        >
    implements _$$GetComplianceStatsInputImplCopyWith<$Res> {
  __$$GetComplianceStatsInputImplCopyWithImpl(
    _$GetComplianceStatsInputImpl _value,
    $Res Function(_$GetComplianceStatsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetComplianceStatsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? dietId = null,
    Object? startDateEpoch = null,
    Object? endDateEpoch = null,
  }) {
    return _then(
      _$GetComplianceStatsInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        dietId: null == dietId
            ? _value.dietId
            : dietId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDateEpoch: null == startDateEpoch
            ? _value.startDateEpoch
            : startDateEpoch // ignore: cast_nullable_to_non_nullable
                  as int,
        endDateEpoch: null == endDateEpoch
            ? _value.endDateEpoch
            : endDateEpoch // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$GetComplianceStatsInputImpl implements _GetComplianceStatsInput {
  const _$GetComplianceStatsInputImpl({
    required this.profileId,
    required this.dietId,
    required this.startDateEpoch,
    required this.endDateEpoch,
  });

  @override
  final String profileId;
  @override
  final String dietId;
  @override
  final int startDateEpoch;
  // Epoch ms
  @override
  final int endDateEpoch;

  @override
  String toString() {
    return 'GetComplianceStatsInput(profileId: $profileId, dietId: $dietId, startDateEpoch: $startDateEpoch, endDateEpoch: $endDateEpoch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetComplianceStatsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.dietId, dietId) || other.dietId == dietId) &&
            (identical(other.startDateEpoch, startDateEpoch) ||
                other.startDateEpoch == startDateEpoch) &&
            (identical(other.endDateEpoch, endDateEpoch) ||
                other.endDateEpoch == endDateEpoch));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, dietId, startDateEpoch, endDateEpoch);

  /// Create a copy of GetComplianceStatsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetComplianceStatsInputImplCopyWith<_$GetComplianceStatsInputImpl>
  get copyWith =>
      __$$GetComplianceStatsInputImplCopyWithImpl<
        _$GetComplianceStatsInputImpl
      >(this, _$identity);
}

abstract class _GetComplianceStatsInput implements GetComplianceStatsInput {
  const factory _GetComplianceStatsInput({
    required final String profileId,
    required final String dietId,
    required final int startDateEpoch,
    required final int endDateEpoch,
  }) = _$GetComplianceStatsInputImpl;

  @override
  String get profileId;
  @override
  String get dietId;
  @override
  int get startDateEpoch; // Epoch ms
  @override
  int get endDateEpoch;

  /// Create a copy of GetComplianceStatsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetComplianceStatsInputImplCopyWith<_$GetComplianceStatsInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DailyCompliance {
  int get dateEpoch =>
      throw _privateConstructorUsedError; // Epoch ms (midnight of day)
  double get score => throw _privateConstructorUsedError; // 0-100
  int get violations =>
      throw _privateConstructorUsedError; // Hard violations (user cancelled)
  int get warnings => throw _privateConstructorUsedError;

  /// Create a copy of DailyCompliance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyComplianceCopyWith<DailyCompliance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyComplianceCopyWith<$Res> {
  factory $DailyComplianceCopyWith(
    DailyCompliance value,
    $Res Function(DailyCompliance) then,
  ) = _$DailyComplianceCopyWithImpl<$Res, DailyCompliance>;
  @useResult
  $Res call({int dateEpoch, double score, int violations, int warnings});
}

/// @nodoc
class _$DailyComplianceCopyWithImpl<$Res, $Val extends DailyCompliance>
    implements $DailyComplianceCopyWith<$Res> {
  _$DailyComplianceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyCompliance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateEpoch = null,
    Object? score = null,
    Object? violations = null,
    Object? warnings = null,
  }) {
    return _then(
      _value.copyWith(
            dateEpoch: null == dateEpoch
                ? _value.dateEpoch
                : dateEpoch // ignore: cast_nullable_to_non_nullable
                      as int,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double,
            violations: null == violations
                ? _value.violations
                : violations // ignore: cast_nullable_to_non_nullable
                      as int,
            warnings: null == warnings
                ? _value.warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyComplianceImplCopyWith<$Res>
    implements $DailyComplianceCopyWith<$Res> {
  factory _$$DailyComplianceImplCopyWith(
    _$DailyComplianceImpl value,
    $Res Function(_$DailyComplianceImpl) then,
  ) = __$$DailyComplianceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int dateEpoch, double score, int violations, int warnings});
}

/// @nodoc
class __$$DailyComplianceImplCopyWithImpl<$Res>
    extends _$DailyComplianceCopyWithImpl<$Res, _$DailyComplianceImpl>
    implements _$$DailyComplianceImplCopyWith<$Res> {
  __$$DailyComplianceImplCopyWithImpl(
    _$DailyComplianceImpl _value,
    $Res Function(_$DailyComplianceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyCompliance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateEpoch = null,
    Object? score = null,
    Object? violations = null,
    Object? warnings = null,
  }) {
    return _then(
      _$DailyComplianceImpl(
        dateEpoch: null == dateEpoch
            ? _value.dateEpoch
            : dateEpoch // ignore: cast_nullable_to_non_nullable
                  as int,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double,
        violations: null == violations
            ? _value.violations
            : violations // ignore: cast_nullable_to_non_nullable
                  as int,
        warnings: null == warnings
            ? _value.warnings
            : warnings // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DailyComplianceImpl extends _DailyCompliance {
  const _$DailyComplianceImpl({
    required this.dateEpoch,
    required this.score,
    required this.violations,
    required this.warnings,
  }) : super._();

  @override
  final int dateEpoch;
  // Epoch ms (midnight of day)
  @override
  final double score;
  // 0-100
  @override
  final int violations;
  // Hard violations (user cancelled)
  @override
  final int warnings;

  @override
  String toString() {
    return 'DailyCompliance(dateEpoch: $dateEpoch, score: $score, violations: $violations, warnings: $warnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyComplianceImpl &&
            (identical(other.dateEpoch, dateEpoch) ||
                other.dateEpoch == dateEpoch) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.violations, violations) ||
                other.violations == violations) &&
            (identical(other.warnings, warnings) ||
                other.warnings == warnings));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, dateEpoch, score, violations, warnings);

  /// Create a copy of DailyCompliance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyComplianceImplCopyWith<_$DailyComplianceImpl> get copyWith =>
      __$$DailyComplianceImplCopyWithImpl<_$DailyComplianceImpl>(
        this,
        _$identity,
      );
}

abstract class _DailyCompliance extends DailyCompliance {
  const factory _DailyCompliance({
    required final int dateEpoch,
    required final double score,
    required final int violations,
    required final int warnings,
  }) = _$DailyComplianceImpl;
  const _DailyCompliance._() : super._();

  @override
  int get dateEpoch; // Epoch ms (midnight of day)
  @override
  double get score; // 0-100
  @override
  int get violations; // Hard violations (user cancelled)
  @override
  int get warnings;

  /// Create a copy of DailyCompliance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyComplianceImplCopyWith<_$DailyComplianceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ComplianceStats {
  double get overallScore =>
      throw _privateConstructorUsedError; // 0-100 for requested date range
  double get dailyScore => throw _privateConstructorUsedError; // Today's score
  double get weeklyScore => throw _privateConstructorUsedError; // Last 7 days
  double get monthlyScore => throw _privateConstructorUsedError; // Last 30 days
  int get currentStreak =>
      throw _privateConstructorUsedError; // Consecutive days ≥80% compliant
  int get longestStreak =>
      throw _privateConstructorUsedError; // Best streak in range
  int get totalViolations =>
      throw _privateConstructorUsedError; // Cancelled entries (wasOverridden=false)
  int get totalWarnings =>
      throw _privateConstructorUsedError; // Added-anyway entries (wasOverridden=true)
  Map<DietRuleType, double> get complianceByRule =>
      throw _privateConstructorUsedError;
  List<DietViolation> get recentViolations =>
      throw _privateConstructorUsedError; // Last 10
  List<DailyCompliance> get dailyTrend => throw _privateConstructorUsedError;

  /// Create a copy of ComplianceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComplianceStatsCopyWith<ComplianceStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComplianceStatsCopyWith<$Res> {
  factory $ComplianceStatsCopyWith(
    ComplianceStats value,
    $Res Function(ComplianceStats) then,
  ) = _$ComplianceStatsCopyWithImpl<$Res, ComplianceStats>;
  @useResult
  $Res call({
    double overallScore,
    double dailyScore,
    double weeklyScore,
    double monthlyScore,
    int currentStreak,
    int longestStreak,
    int totalViolations,
    int totalWarnings,
    Map<DietRuleType, double> complianceByRule,
    List<DietViolation> recentViolations,
    List<DailyCompliance> dailyTrend,
  });
}

/// @nodoc
class _$ComplianceStatsCopyWithImpl<$Res, $Val extends ComplianceStats>
    implements $ComplianceStatsCopyWith<$Res> {
  _$ComplianceStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComplianceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overallScore = null,
    Object? dailyScore = null,
    Object? weeklyScore = null,
    Object? monthlyScore = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? totalViolations = null,
    Object? totalWarnings = null,
    Object? complianceByRule = null,
    Object? recentViolations = null,
    Object? dailyTrend = null,
  }) {
    return _then(
      _value.copyWith(
            overallScore: null == overallScore
                ? _value.overallScore
                : overallScore // ignore: cast_nullable_to_non_nullable
                      as double,
            dailyScore: null == dailyScore
                ? _value.dailyScore
                : dailyScore // ignore: cast_nullable_to_non_nullable
                      as double,
            weeklyScore: null == weeklyScore
                ? _value.weeklyScore
                : weeklyScore // ignore: cast_nullable_to_non_nullable
                      as double,
            monthlyScore: null == monthlyScore
                ? _value.monthlyScore
                : monthlyScore // ignore: cast_nullable_to_non_nullable
                      as double,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            totalViolations: null == totalViolations
                ? _value.totalViolations
                : totalViolations // ignore: cast_nullable_to_non_nullable
                      as int,
            totalWarnings: null == totalWarnings
                ? _value.totalWarnings
                : totalWarnings // ignore: cast_nullable_to_non_nullable
                      as int,
            complianceByRule: null == complianceByRule
                ? _value.complianceByRule
                : complianceByRule // ignore: cast_nullable_to_non_nullable
                      as Map<DietRuleType, double>,
            recentViolations: null == recentViolations
                ? _value.recentViolations
                : recentViolations // ignore: cast_nullable_to_non_nullable
                      as List<DietViolation>,
            dailyTrend: null == dailyTrend
                ? _value.dailyTrend
                : dailyTrend // ignore: cast_nullable_to_non_nullable
                      as List<DailyCompliance>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ComplianceStatsImplCopyWith<$Res>
    implements $ComplianceStatsCopyWith<$Res> {
  factory _$$ComplianceStatsImplCopyWith(
    _$ComplianceStatsImpl value,
    $Res Function(_$ComplianceStatsImpl) then,
  ) = __$$ComplianceStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double overallScore,
    double dailyScore,
    double weeklyScore,
    double monthlyScore,
    int currentStreak,
    int longestStreak,
    int totalViolations,
    int totalWarnings,
    Map<DietRuleType, double> complianceByRule,
    List<DietViolation> recentViolations,
    List<DailyCompliance> dailyTrend,
  });
}

/// @nodoc
class __$$ComplianceStatsImplCopyWithImpl<$Res>
    extends _$ComplianceStatsCopyWithImpl<$Res, _$ComplianceStatsImpl>
    implements _$$ComplianceStatsImplCopyWith<$Res> {
  __$$ComplianceStatsImplCopyWithImpl(
    _$ComplianceStatsImpl _value,
    $Res Function(_$ComplianceStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ComplianceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overallScore = null,
    Object? dailyScore = null,
    Object? weeklyScore = null,
    Object? monthlyScore = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? totalViolations = null,
    Object? totalWarnings = null,
    Object? complianceByRule = null,
    Object? recentViolations = null,
    Object? dailyTrend = null,
  }) {
    return _then(
      _$ComplianceStatsImpl(
        overallScore: null == overallScore
            ? _value.overallScore
            : overallScore // ignore: cast_nullable_to_non_nullable
                  as double,
        dailyScore: null == dailyScore
            ? _value.dailyScore
            : dailyScore // ignore: cast_nullable_to_non_nullable
                  as double,
        weeklyScore: null == weeklyScore
            ? _value.weeklyScore
            : weeklyScore // ignore: cast_nullable_to_non_nullable
                  as double,
        monthlyScore: null == monthlyScore
            ? _value.monthlyScore
            : monthlyScore // ignore: cast_nullable_to_non_nullable
                  as double,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        totalViolations: null == totalViolations
            ? _value.totalViolations
            : totalViolations // ignore: cast_nullable_to_non_nullable
                  as int,
        totalWarnings: null == totalWarnings
            ? _value.totalWarnings
            : totalWarnings // ignore: cast_nullable_to_non_nullable
                  as int,
        complianceByRule: null == complianceByRule
            ? _value._complianceByRule
            : complianceByRule // ignore: cast_nullable_to_non_nullable
                  as Map<DietRuleType, double>,
        recentViolations: null == recentViolations
            ? _value._recentViolations
            : recentViolations // ignore: cast_nullable_to_non_nullable
                  as List<DietViolation>,
        dailyTrend: null == dailyTrend
            ? _value._dailyTrend
            : dailyTrend // ignore: cast_nullable_to_non_nullable
                  as List<DailyCompliance>,
      ),
    );
  }
}

/// @nodoc

class _$ComplianceStatsImpl implements _ComplianceStats {
  const _$ComplianceStatsImpl({
    required this.overallScore,
    required this.dailyScore,
    required this.weeklyScore,
    required this.monthlyScore,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalViolations,
    required this.totalWarnings,
    required final Map<DietRuleType, double> complianceByRule,
    required final List<DietViolation> recentViolations,
    required final List<DailyCompliance> dailyTrend,
  }) : _complianceByRule = complianceByRule,
       _recentViolations = recentViolations,
       _dailyTrend = dailyTrend;

  @override
  final double overallScore;
  // 0-100 for requested date range
  @override
  final double dailyScore;
  // Today's score
  @override
  final double weeklyScore;
  // Last 7 days
  @override
  final double monthlyScore;
  // Last 30 days
  @override
  final int currentStreak;
  // Consecutive days ≥80% compliant
  @override
  final int longestStreak;
  // Best streak in range
  @override
  final int totalViolations;
  // Cancelled entries (wasOverridden=false)
  @override
  final int totalWarnings;
  // Added-anyway entries (wasOverridden=true)
  final Map<DietRuleType, double> _complianceByRule;
  // Added-anyway entries (wasOverridden=true)
  @override
  Map<DietRuleType, double> get complianceByRule {
    if (_complianceByRule is EqualUnmodifiableMapView) return _complianceByRule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_complianceByRule);
  }

  final List<DietViolation> _recentViolations;
  @override
  List<DietViolation> get recentViolations {
    if (_recentViolations is EqualUnmodifiableListView)
      return _recentViolations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentViolations);
  }

  // Last 10
  final List<DailyCompliance> _dailyTrend;
  // Last 10
  @override
  List<DailyCompliance> get dailyTrend {
    if (_dailyTrend is EqualUnmodifiableListView) return _dailyTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyTrend);
  }

  @override
  String toString() {
    return 'ComplianceStats(overallScore: $overallScore, dailyScore: $dailyScore, weeklyScore: $weeklyScore, monthlyScore: $monthlyScore, currentStreak: $currentStreak, longestStreak: $longestStreak, totalViolations: $totalViolations, totalWarnings: $totalWarnings, complianceByRule: $complianceByRule, recentViolations: $recentViolations, dailyTrend: $dailyTrend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComplianceStatsImpl &&
            (identical(other.overallScore, overallScore) ||
                other.overallScore == overallScore) &&
            (identical(other.dailyScore, dailyScore) ||
                other.dailyScore == dailyScore) &&
            (identical(other.weeklyScore, weeklyScore) ||
                other.weeklyScore == weeklyScore) &&
            (identical(other.monthlyScore, monthlyScore) ||
                other.monthlyScore == monthlyScore) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.totalViolations, totalViolations) ||
                other.totalViolations == totalViolations) &&
            (identical(other.totalWarnings, totalWarnings) ||
                other.totalWarnings == totalWarnings) &&
            const DeepCollectionEquality().equals(
              other._complianceByRule,
              _complianceByRule,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentViolations,
              _recentViolations,
            ) &&
            const DeepCollectionEquality().equals(
              other._dailyTrend,
              _dailyTrend,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    overallScore,
    dailyScore,
    weeklyScore,
    monthlyScore,
    currentStreak,
    longestStreak,
    totalViolations,
    totalWarnings,
    const DeepCollectionEquality().hash(_complianceByRule),
    const DeepCollectionEquality().hash(_recentViolations),
    const DeepCollectionEquality().hash(_dailyTrend),
  );

  /// Create a copy of ComplianceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComplianceStatsImplCopyWith<_$ComplianceStatsImpl> get copyWith =>
      __$$ComplianceStatsImplCopyWithImpl<_$ComplianceStatsImpl>(
        this,
        _$identity,
      );
}

abstract class _ComplianceStats implements ComplianceStats {
  const factory _ComplianceStats({
    required final double overallScore,
    required final double dailyScore,
    required final double weeklyScore,
    required final double monthlyScore,
    required final int currentStreak,
    required final int longestStreak,
    required final int totalViolations,
    required final int totalWarnings,
    required final Map<DietRuleType, double> complianceByRule,
    required final List<DietViolation> recentViolations,
    required final List<DailyCompliance> dailyTrend,
  }) = _$ComplianceStatsImpl;

  @override
  double get overallScore; // 0-100 for requested date range
  @override
  double get dailyScore; // Today's score
  @override
  double get weeklyScore; // Last 7 days
  @override
  double get monthlyScore; // Last 30 days
  @override
  int get currentStreak; // Consecutive days ≥80% compliant
  @override
  int get longestStreak; // Best streak in range
  @override
  int get totalViolations; // Cancelled entries (wasOverridden=false)
  @override
  int get totalWarnings; // Added-anyway entries (wasOverridden=true)
  @override
  Map<DietRuleType, double> get complianceByRule;
  @override
  List<DietViolation> get recentViolations; // Last 10
  @override
  List<DailyCompliance> get dailyTrend;

  /// Create a copy of ComplianceStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComplianceStatsImplCopyWith<_$ComplianceStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
