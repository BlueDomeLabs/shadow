// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Diet _$DietFromJson(Map<String, dynamic> json) {
  return _Diet.fromJson(json);
}

/// @nodoc
mixin _$Diet {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DietPresetType? get presetType =>
      throw _privateConstructorUsedError; // null = fully custom diet
  bool get isActive => throw _privateConstructorUsedError;
  int get startDate => throw _privateConstructorUsedError; // Epoch ms
  int? get endDate =>
      throw _privateConstructorUsedError; // Epoch ms, null = no end
  bool get isDraft => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this Diet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Diet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DietCopyWith<Diet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DietCopyWith<$Res> {
  factory $DietCopyWith(Diet value, $Res Function(Diet) then) =
      _$DietCopyWithImpl<$Res, Diet>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String name,
    String description,
    DietPresetType? presetType,
    bool isActive,
    int startDate,
    int? endDate,
    bool isDraft,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$DietCopyWithImpl<$Res, $Val extends Diet>
    implements $DietCopyWith<$Res> {
  _$DietCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Diet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? name = null,
    Object? description = null,
    Object? presetType = freezed,
    Object? isActive = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? isDraft = null,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            presetType: freezed == presetType
                ? _value.presetType
                : presetType // ignore: cast_nullable_to_non_nullable
                      as DietPresetType?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            isDraft: null == isDraft
                ? _value.isDraft
                : isDraft // ignore: cast_nullable_to_non_nullable
                      as bool,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of Diet
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
abstract class _$$DietImplCopyWith<$Res> implements $DietCopyWith<$Res> {
  factory _$$DietImplCopyWith(
    _$DietImpl value,
    $Res Function(_$DietImpl) then,
  ) = __$$DietImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String name,
    String description,
    DietPresetType? presetType,
    bool isActive,
    int startDate,
    int? endDate,
    bool isDraft,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$DietImplCopyWithImpl<$Res>
    extends _$DietCopyWithImpl<$Res, _$DietImpl>
    implements _$$DietImplCopyWith<$Res> {
  __$$DietImplCopyWithImpl(_$DietImpl _value, $Res Function(_$DietImpl) _then)
    : super(_value, _then);

  /// Create a copy of Diet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? name = null,
    Object? description = null,
    Object? presetType = freezed,
    Object? isActive = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? isDraft = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$DietImpl(
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
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        presetType: freezed == presetType
            ? _value.presetType
            : presetType // ignore: cast_nullable_to_non_nullable
                  as DietPresetType?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        isDraft: null == isDraft
            ? _value.isDraft
            : isDraft // ignore: cast_nullable_to_non_nullable
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
class _$DietImpl extends _Diet {
  const _$DietImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.name,
    this.description = '',
    this.presetType,
    this.isActive = false,
    required this.startDate,
    this.endDate,
    this.isDraft = false,
    required this.syncMetadata,
  }) : super._();

  factory _$DietImpl.fromJson(Map<String, dynamic> json) =>
      _$$DietImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  final DietPresetType? presetType;
  // null = fully custom diet
  @override
  @JsonKey()
  final bool isActive;
  @override
  final int startDate;
  // Epoch ms
  @override
  final int? endDate;
  // Epoch ms, null = no end
  @override
  @JsonKey()
  final bool isDraft;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'Diet(id: $id, clientId: $clientId, profileId: $profileId, name: $name, description: $description, presetType: $presetType, isActive: $isActive, startDate: $startDate, endDate: $endDate, isDraft: $isDraft, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DietImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.presetType, presetType) ||
                other.presetType == presetType) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isDraft, isDraft) || other.isDraft == isDraft) &&
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
    presetType,
    isActive,
    startDate,
    endDate,
    isDraft,
    syncMetadata,
  );

  /// Create a copy of Diet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DietImplCopyWith<_$DietImpl> get copyWith =>
      __$$DietImplCopyWithImpl<_$DietImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DietImplToJson(this);
  }
}

abstract class _Diet extends Diet {
  const factory _Diet({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final String name,
    final String description,
    final DietPresetType? presetType,
    final bool isActive,
    required final int startDate,
    final int? endDate,
    final bool isDraft,
    required final SyncMetadata syncMetadata,
  }) = _$DietImpl;
  const _Diet._() : super._();

  factory _Diet.fromJson(Map<String, dynamic> json) = _$DietImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  String get name;
  @override
  String get description;
  @override
  DietPresetType? get presetType; // null = fully custom diet
  @override
  bool get isActive;
  @override
  int get startDate; // Epoch ms
  @override
  int? get endDate; // Epoch ms, null = no end
  @override
  bool get isDraft;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of Diet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DietImplCopyWith<_$DietImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
