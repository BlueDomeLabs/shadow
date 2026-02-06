// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_log_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LogFoodInput {
  String get profileId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError; // Epoch milliseconds
  List<String> get foodItemIds => throw _privateConstructorUsedError;
  List<String> get adHocItems => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  /// Create a copy of LogFoodInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogFoodInputCopyWith<LogFoodInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogFoodInputCopyWith<$Res> {
  factory $LogFoodInputCopyWith(
    LogFoodInput value,
    $Res Function(LogFoodInput) then,
  ) = _$LogFoodInputCopyWithImpl<$Res, LogFoodInput>;
  @useResult
  $Res call({
    String profileId,
    String clientId,
    int timestamp,
    List<String> foodItemIds,
    List<String> adHocItems,
    String notes,
  });
}

/// @nodoc
class _$LogFoodInputCopyWithImpl<$Res, $Val extends LogFoodInput>
    implements $LogFoodInputCopyWith<$Res> {
  _$LogFoodInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogFoodInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? timestamp = null,
    Object? foodItemIds = null,
    Object? adHocItems = null,
    Object? notes = null,
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
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
            foodItemIds: null == foodItemIds
                ? _value.foodItemIds
                : foodItemIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            adHocItems: null == adHocItems
                ? _value.adHocItems
                : adHocItems // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogFoodInputImplCopyWith<$Res>
    implements $LogFoodInputCopyWith<$Res> {
  factory _$$LogFoodInputImplCopyWith(
    _$LogFoodInputImpl value,
    $Res Function(_$LogFoodInputImpl) then,
  ) = __$$LogFoodInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    String clientId,
    int timestamp,
    List<String> foodItemIds,
    List<String> adHocItems,
    String notes,
  });
}

/// @nodoc
class __$$LogFoodInputImplCopyWithImpl<$Res>
    extends _$LogFoodInputCopyWithImpl<$Res, _$LogFoodInputImpl>
    implements _$$LogFoodInputImplCopyWith<$Res> {
  __$$LogFoodInputImplCopyWithImpl(
    _$LogFoodInputImpl _value,
    $Res Function(_$LogFoodInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogFoodInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? clientId = null,
    Object? timestamp = null,
    Object? foodItemIds = null,
    Object? adHocItems = null,
    Object? notes = null,
  }) {
    return _then(
      _$LogFoodInputImpl(
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        foodItemIds: null == foodItemIds
            ? _value._foodItemIds
            : foodItemIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        adHocItems: null == adHocItems
            ? _value._adHocItems
            : adHocItems // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LogFoodInputImpl implements _LogFoodInput {
  const _$LogFoodInputImpl({
    required this.profileId,
    required this.clientId,
    required this.timestamp,
    final List<String> foodItemIds = const [],
    final List<String> adHocItems = const [],
    this.notes = '',
  }) : _foodItemIds = foodItemIds,
       _adHocItems = adHocItems;

  @override
  final String profileId;
  @override
  final String clientId;
  @override
  final int timestamp;
  // Epoch milliseconds
  final List<String> _foodItemIds;
  // Epoch milliseconds
  @override
  @JsonKey()
  List<String> get foodItemIds {
    if (_foodItemIds is EqualUnmodifiableListView) return _foodItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foodItemIds);
  }

  final List<String> _adHocItems;
  @override
  @JsonKey()
  List<String> get adHocItems {
    if (_adHocItems is EqualUnmodifiableListView) return _adHocItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adHocItems);
  }

  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'LogFoodInput(profileId: $profileId, clientId: $clientId, timestamp: $timestamp, foodItemIds: $foodItemIds, adHocItems: $adHocItems, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogFoodInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(
              other._foodItemIds,
              _foodItemIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._adHocItems,
              _adHocItems,
            ) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profileId,
    clientId,
    timestamp,
    const DeepCollectionEquality().hash(_foodItemIds),
    const DeepCollectionEquality().hash(_adHocItems),
    notes,
  );

  /// Create a copy of LogFoodInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogFoodInputImplCopyWith<_$LogFoodInputImpl> get copyWith =>
      __$$LogFoodInputImplCopyWithImpl<_$LogFoodInputImpl>(this, _$identity);
}

abstract class _LogFoodInput implements LogFoodInput {
  const factory _LogFoodInput({
    required final String profileId,
    required final String clientId,
    required final int timestamp,
    final List<String> foodItemIds,
    final List<String> adHocItems,
    final String notes,
  }) = _$LogFoodInputImpl;

  @override
  String get profileId;
  @override
  String get clientId;
  @override
  int get timestamp; // Epoch milliseconds
  @override
  List<String> get foodItemIds;
  @override
  List<String> get adHocItems;
  @override
  String get notes;

  /// Create a copy of LogFoodInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogFoodInputImplCopyWith<_$LogFoodInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetFoodLogsInput {
  String get profileId => throw _privateConstructorUsedError;
  int? get startDate =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  int? get endDate => throw _privateConstructorUsedError; // Epoch milliseconds
  int? get limit => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;

  /// Create a copy of GetFoodLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetFoodLogsInputCopyWith<GetFoodLogsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetFoodLogsInputCopyWith<$Res> {
  factory $GetFoodLogsInputCopyWith(
    GetFoodLogsInput value,
    $Res Function(GetFoodLogsInput) then,
  ) = _$GetFoodLogsInputCopyWithImpl<$Res, GetFoodLogsInput>;
  @useResult
  $Res call({
    String profileId,
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class _$GetFoodLogsInputCopyWithImpl<$Res, $Val extends GetFoodLogsInput>
    implements $GetFoodLogsInputCopyWith<$Res> {
  _$GetFoodLogsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetFoodLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
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
abstract class _$$GetFoodLogsInputImplCopyWith<$Res>
    implements $GetFoodLogsInputCopyWith<$Res> {
  factory _$$GetFoodLogsInputImplCopyWith(
    _$GetFoodLogsInputImpl value,
    $Res Function(_$GetFoodLogsInputImpl) then,
  ) = __$$GetFoodLogsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String profileId,
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  });
}

/// @nodoc
class __$$GetFoodLogsInputImplCopyWithImpl<$Res>
    extends _$GetFoodLogsInputCopyWithImpl<$Res, _$GetFoodLogsInputImpl>
    implements _$$GetFoodLogsInputImplCopyWith<$Res> {
  __$$GetFoodLogsInputImplCopyWithImpl(
    _$GetFoodLogsInputImpl _value,
    $Res Function(_$GetFoodLogsInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetFoodLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
  }) {
    return _then(
      _$GetFoodLogsInputImpl(
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
        offset: freezed == offset
            ? _value.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$GetFoodLogsInputImpl implements _GetFoodLogsInput {
  const _$GetFoodLogsInputImpl({
    required this.profileId,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });

  @override
  final String profileId;
  @override
  final int? startDate;
  // Epoch milliseconds
  @override
  final int? endDate;
  // Epoch milliseconds
  @override
  final int? limit;
  @override
  final int? offset;

  @override
  String toString() {
    return 'GetFoodLogsInput(profileId: $profileId, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetFoodLogsInputImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profileId, startDate, endDate, limit, offset);

  /// Create a copy of GetFoodLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetFoodLogsInputImplCopyWith<_$GetFoodLogsInputImpl> get copyWith =>
      __$$GetFoodLogsInputImplCopyWithImpl<_$GetFoodLogsInputImpl>(
        this,
        _$identity,
      );
}

abstract class _GetFoodLogsInput implements GetFoodLogsInput {
  const factory _GetFoodLogsInput({
    required final String profileId,
    final int? startDate,
    final int? endDate,
    final int? limit,
    final int? offset,
  }) = _$GetFoodLogsInputImpl;

  @override
  String get profileId;
  @override
  int? get startDate; // Epoch milliseconds
  @override
  int? get endDate; // Epoch milliseconds
  @override
  int? get limit;
  @override
  int? get offset;

  /// Create a copy of GetFoodLogsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetFoodLogsInputImplCopyWith<_$GetFoodLogsInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateFoodLogInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  List<String>? get foodItemIds => throw _privateConstructorUsedError;
  List<String>? get adHocItems => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of UpdateFoodLogInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateFoodLogInputCopyWith<UpdateFoodLogInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateFoodLogInputCopyWith<$Res> {
  factory $UpdateFoodLogInputCopyWith(
    UpdateFoodLogInput value,
    $Res Function(UpdateFoodLogInput) then,
  ) = _$UpdateFoodLogInputCopyWithImpl<$Res, UpdateFoodLogInput>;
  @useResult
  $Res call({
    String id,
    String profileId,
    List<String>? foodItemIds,
    List<String>? adHocItems,
    String? notes,
  });
}

/// @nodoc
class _$UpdateFoodLogInputCopyWithImpl<$Res, $Val extends UpdateFoodLogInput>
    implements $UpdateFoodLogInputCopyWith<$Res> {
  _$UpdateFoodLogInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateFoodLogInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? foodItemIds = freezed,
    Object? adHocItems = freezed,
    Object? notes = freezed,
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
            foodItemIds: freezed == foodItemIds
                ? _value.foodItemIds
                : foodItemIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            adHocItems: freezed == adHocItems
                ? _value.adHocItems
                : adHocItems // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
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
abstract class _$$UpdateFoodLogInputImplCopyWith<$Res>
    implements $UpdateFoodLogInputCopyWith<$Res> {
  factory _$$UpdateFoodLogInputImplCopyWith(
    _$UpdateFoodLogInputImpl value,
    $Res Function(_$UpdateFoodLogInputImpl) then,
  ) = __$$UpdateFoodLogInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    List<String>? foodItemIds,
    List<String>? adHocItems,
    String? notes,
  });
}

/// @nodoc
class __$$UpdateFoodLogInputImplCopyWithImpl<$Res>
    extends _$UpdateFoodLogInputCopyWithImpl<$Res, _$UpdateFoodLogInputImpl>
    implements _$$UpdateFoodLogInputImplCopyWith<$Res> {
  __$$UpdateFoodLogInputImplCopyWithImpl(
    _$UpdateFoodLogInputImpl _value,
    $Res Function(_$UpdateFoodLogInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateFoodLogInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? foodItemIds = freezed,
    Object? adHocItems = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$UpdateFoodLogInputImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        foodItemIds: freezed == foodItemIds
            ? _value._foodItemIds
            : foodItemIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        adHocItems: freezed == adHocItems
            ? _value._adHocItems
            : adHocItems // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateFoodLogInputImpl implements _UpdateFoodLogInput {
  const _$UpdateFoodLogInputImpl({
    required this.id,
    required this.profileId,
    final List<String>? foodItemIds,
    final List<String>? adHocItems,
    this.notes,
  }) : _foodItemIds = foodItemIds,
       _adHocItems = adHocItems;

  @override
  final String id;
  @override
  final String profileId;
  final List<String>? _foodItemIds;
  @override
  List<String>? get foodItemIds {
    final value = _foodItemIds;
    if (value == null) return null;
    if (_foodItemIds is EqualUnmodifiableListView) return _foodItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _adHocItems;
  @override
  List<String>? get adHocItems {
    final value = _adHocItems;
    if (value == null) return null;
    if (_adHocItems is EqualUnmodifiableListView) return _adHocItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? notes;

  @override
  String toString() {
    return 'UpdateFoodLogInput(id: $id, profileId: $profileId, foodItemIds: $foodItemIds, adHocItems: $adHocItems, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateFoodLogInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            const DeepCollectionEquality().equals(
              other._foodItemIds,
              _foodItemIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._adHocItems,
              _adHocItems,
            ) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    const DeepCollectionEquality().hash(_foodItemIds),
    const DeepCollectionEquality().hash(_adHocItems),
    notes,
  );

  /// Create a copy of UpdateFoodLogInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateFoodLogInputImplCopyWith<_$UpdateFoodLogInputImpl> get copyWith =>
      __$$UpdateFoodLogInputImplCopyWithImpl<_$UpdateFoodLogInputImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateFoodLogInput implements UpdateFoodLogInput {
  const factory _UpdateFoodLogInput({
    required final String id,
    required final String profileId,
    final List<String>? foodItemIds,
    final List<String>? adHocItems,
    final String? notes,
  }) = _$UpdateFoodLogInputImpl;

  @override
  String get id;
  @override
  String get profileId;
  @override
  List<String>? get foodItemIds;
  @override
  List<String>? get adHocItems;
  @override
  String? get notes;

  /// Create a copy of UpdateFoodLogInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateFoodLogInputImplCopyWith<_$UpdateFoodLogInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeleteFoodLogInput {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;

  /// Create a copy of DeleteFoodLogInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteFoodLogInputCopyWith<DeleteFoodLogInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteFoodLogInputCopyWith<$Res> {
  factory $DeleteFoodLogInputCopyWith(
    DeleteFoodLogInput value,
    $Res Function(DeleteFoodLogInput) then,
  ) = _$DeleteFoodLogInputCopyWithImpl<$Res, DeleteFoodLogInput>;
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class _$DeleteFoodLogInputCopyWithImpl<$Res, $Val extends DeleteFoodLogInput>
    implements $DeleteFoodLogInputCopyWith<$Res> {
  _$DeleteFoodLogInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteFoodLogInput
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
abstract class _$$DeleteFoodLogInputImplCopyWith<$Res>
    implements $DeleteFoodLogInputCopyWith<$Res> {
  factory _$$DeleteFoodLogInputImplCopyWith(
    _$DeleteFoodLogInputImpl value,
    $Res Function(_$DeleteFoodLogInputImpl) then,
  ) = __$$DeleteFoodLogInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileId});
}

/// @nodoc
class __$$DeleteFoodLogInputImplCopyWithImpl<$Res>
    extends _$DeleteFoodLogInputCopyWithImpl<$Res, _$DeleteFoodLogInputImpl>
    implements _$$DeleteFoodLogInputImplCopyWith<$Res> {
  __$$DeleteFoodLogInputImplCopyWithImpl(
    _$DeleteFoodLogInputImpl _value,
    $Res Function(_$DeleteFoodLogInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteFoodLogInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? profileId = null}) {
    return _then(
      _$DeleteFoodLogInputImpl(
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

class _$DeleteFoodLogInputImpl implements _DeleteFoodLogInput {
  const _$DeleteFoodLogInputImpl({required this.id, required this.profileId});

  @override
  final String id;
  @override
  final String profileId;

  @override
  String toString() {
    return 'DeleteFoodLogInput(id: $id, profileId: $profileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteFoodLogInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileId);

  /// Create a copy of DeleteFoodLogInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteFoodLogInputImplCopyWith<_$DeleteFoodLogInputImpl> get copyWith =>
      __$$DeleteFoodLogInputImplCopyWithImpl<_$DeleteFoodLogInputImpl>(
        this,
        _$identity,
      );
}

abstract class _DeleteFoodLogInput implements DeleteFoodLogInput {
  const factory _DeleteFoodLogInput({
    required final String id,
    required final String profileId,
  }) = _$DeleteFoodLogInputImpl;

  @override
  String get id;
  @override
  String get profileId;

  /// Create a copy of DeleteFoodLogInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteFoodLogInputImplCopyWith<_$DeleteFoodLogInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
