// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'condition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Condition _$ConditionFromJson(Map<String, dynamic> json) {
  return _Condition.fromJson(json);
}

/// @nodoc
mixin _$Condition {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get bodyLocations =>
      throw _privateConstructorUsedError; // JSON array in DB
  String? get description => throw _privateConstructorUsedError;
  String? get baselinePhotoPath => throw _privateConstructorUsedError;
  int get startTimeframe =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  int? get endDate => throw _privateConstructorUsedError; // Epoch milliseconds
  ConditionStatus get status => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  String? get activityId =>
      throw _privateConstructorUsedError; // FK to activities
  // File sync metadata
  String? get cloudStorageUrl => throw _privateConstructorUsedError;
  String? get fileHash => throw _privateConstructorUsedError;
  int? get fileSizeBytes => throw _privateConstructorUsedError;
  bool get isFileUploaded => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this Condition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Condition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConditionCopyWith<Condition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConditionCopyWith<$Res> {
  factory $ConditionCopyWith(Condition value, $Res Function(Condition) then) =
      _$ConditionCopyWithImpl<$Res, Condition>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String name,
    String category,
    List<String> bodyLocations,
    String? description,
    String? baselinePhotoPath,
    int startTimeframe,
    int? endDate,
    ConditionStatus status,
    bool isArchived,
    String? activityId,
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    bool isFileUploaded,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$ConditionCopyWithImpl<$Res, $Val extends Condition>
    implements $ConditionCopyWith<$Res> {
  _$ConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Condition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? name = null,
    Object? category = null,
    Object? bodyLocations = null,
    Object? description = freezed,
    Object? baselinePhotoPath = freezed,
    Object? startTimeframe = null,
    Object? endDate = freezed,
    Object? status = null,
    Object? isArchived = null,
    Object? activityId = freezed,
    Object? cloudStorageUrl = freezed,
    Object? fileHash = freezed,
    Object? fileSizeBytes = freezed,
    Object? isFileUploaded = null,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            bodyLocations: null == bodyLocations
                ? _value.bodyLocations
                : bodyLocations // ignore: cast_nullable_to_non_nullable
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ConditionStatus,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
            activityId: freezed == activityId
                ? _value.activityId
                : activityId // ignore: cast_nullable_to_non_nullable
                      as String?,
            cloudStorageUrl: freezed == cloudStorageUrl
                ? _value.cloudStorageUrl
                : cloudStorageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileHash: freezed == fileHash
                ? _value.fileHash
                : fileHash // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileSizeBytes: freezed == fileSizeBytes
                ? _value.fileSizeBytes
                : fileSizeBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            isFileUploaded: null == isFileUploaded
                ? _value.isFileUploaded
                : isFileUploaded // ignore: cast_nullable_to_non_nullable
                      as bool,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of Condition
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
abstract class _$$ConditionImplCopyWith<$Res>
    implements $ConditionCopyWith<$Res> {
  factory _$$ConditionImplCopyWith(
    _$ConditionImpl value,
    $Res Function(_$ConditionImpl) then,
  ) = __$$ConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String name,
    String category,
    List<String> bodyLocations,
    String? description,
    String? baselinePhotoPath,
    int startTimeframe,
    int? endDate,
    ConditionStatus status,
    bool isArchived,
    String? activityId,
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    bool isFileUploaded,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$ConditionImplCopyWithImpl<$Res>
    extends _$ConditionCopyWithImpl<$Res, _$ConditionImpl>
    implements _$$ConditionImplCopyWith<$Res> {
  __$$ConditionImplCopyWithImpl(
    _$ConditionImpl _value,
    $Res Function(_$ConditionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Condition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? name = null,
    Object? category = null,
    Object? bodyLocations = null,
    Object? description = freezed,
    Object? baselinePhotoPath = freezed,
    Object? startTimeframe = null,
    Object? endDate = freezed,
    Object? status = null,
    Object? isArchived = null,
    Object? activityId = freezed,
    Object? cloudStorageUrl = freezed,
    Object? fileHash = freezed,
    Object? fileSizeBytes = freezed,
    Object? isFileUploaded = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$ConditionImpl(
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
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        bodyLocations: null == bodyLocations
            ? _value._bodyLocations
            : bodyLocations // ignore: cast_nullable_to_non_nullable
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ConditionStatus,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        activityId: freezed == activityId
            ? _value.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cloudStorageUrl: freezed == cloudStorageUrl
            ? _value.cloudStorageUrl
            : cloudStorageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileHash: freezed == fileHash
            ? _value.fileHash
            : fileHash // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileSizeBytes: freezed == fileSizeBytes
            ? _value.fileSizeBytes
            : fileSizeBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        isFileUploaded: null == isFileUploaded
            ? _value.isFileUploaded
            : isFileUploaded // ignore: cast_nullable_to_non_nullable
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
class _$ConditionImpl extends _Condition {
  const _$ConditionImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.name,
    required this.category,
    required final List<String> bodyLocations,
    this.description,
    this.baselinePhotoPath,
    required this.startTimeframe,
    this.endDate,
    this.status = ConditionStatus.active,
    this.isArchived = false,
    this.activityId,
    this.cloudStorageUrl,
    this.fileHash,
    this.fileSizeBytes,
    this.isFileUploaded = false,
    required this.syncMetadata,
  }) : _bodyLocations = bodyLocations,
       super._();

  factory _$ConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConditionImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final String name;
  @override
  final String category;
  final List<String> _bodyLocations;
  @override
  List<String> get bodyLocations {
    if (_bodyLocations is EqualUnmodifiableListView) return _bodyLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bodyLocations);
  }

  // JSON array in DB
  @override
  final String? description;
  @override
  final String? baselinePhotoPath;
  @override
  final int startTimeframe;
  // Epoch milliseconds
  @override
  final int? endDate;
  // Epoch milliseconds
  @override
  @JsonKey()
  final ConditionStatus status;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  final String? activityId;
  // FK to activities
  // File sync metadata
  @override
  final String? cloudStorageUrl;
  @override
  final String? fileHash;
  @override
  final int? fileSizeBytes;
  @override
  @JsonKey()
  final bool isFileUploaded;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'Condition(id: $id, clientId: $clientId, profileId: $profileId, name: $name, category: $category, bodyLocations: $bodyLocations, description: $description, baselinePhotoPath: $baselinePhotoPath, startTimeframe: $startTimeframe, endDate: $endDate, status: $status, isArchived: $isArchived, activityId: $activityId, cloudStorageUrl: $cloudStorageUrl, fileHash: $fileHash, fileSizeBytes: $fileSizeBytes, isFileUploaded: $isFileUploaded, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConditionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(
              other._bodyLocations,
              _bodyLocations,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.baselinePhotoPath, baselinePhotoPath) ||
                other.baselinePhotoPath == baselinePhotoPath) &&
            (identical(other.startTimeframe, startTimeframe) ||
                other.startTimeframe == startTimeframe) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.cloudStorageUrl, cloudStorageUrl) ||
                other.cloudStorageUrl == cloudStorageUrl) &&
            (identical(other.fileHash, fileHash) ||
                other.fileHash == fileHash) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.isFileUploaded, isFileUploaded) ||
                other.isFileUploaded == isFileUploaded) &&
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
    category,
    const DeepCollectionEquality().hash(_bodyLocations),
    description,
    baselinePhotoPath,
    startTimeframe,
    endDate,
    status,
    isArchived,
    activityId,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    syncMetadata,
  );

  /// Create a copy of Condition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConditionImplCopyWith<_$ConditionImpl> get copyWith =>
      __$$ConditionImplCopyWithImpl<_$ConditionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConditionImplToJson(this);
  }
}

abstract class _Condition extends Condition {
  const factory _Condition({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final String name,
    required final String category,
    required final List<String> bodyLocations,
    final String? description,
    final String? baselinePhotoPath,
    required final int startTimeframe,
    final int? endDate,
    final ConditionStatus status,
    final bool isArchived,
    final String? activityId,
    final String? cloudStorageUrl,
    final String? fileHash,
    final int? fileSizeBytes,
    final bool isFileUploaded,
    required final SyncMetadata syncMetadata,
  }) = _$ConditionImpl;
  const _Condition._() : super._();

  factory _Condition.fromJson(Map<String, dynamic> json) =
      _$ConditionImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  String get name;
  @override
  String get category;
  @override
  List<String> get bodyLocations; // JSON array in DB
  @override
  String? get description;
  @override
  String? get baselinePhotoPath;
  @override
  int get startTimeframe; // Epoch milliseconds
  @override
  int? get endDate; // Epoch milliseconds
  @override
  ConditionStatus get status;
  @override
  bool get isArchived;
  @override
  String? get activityId; // FK to activities
  // File sync metadata
  @override
  String? get cloudStorageUrl;
  @override
  String? get fileHash;
  @override
  int? get fileSizeBytes;
  @override
  bool get isFileUploaded;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of Condition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConditionImplCopyWith<_$ConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
