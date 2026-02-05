// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fluids_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FluidsEntry _$FluidsEntryFromJson(Map<String, dynamic> json) {
  return _FluidsEntry.fromJson(json);
}

/// @nodoc
mixin _$FluidsEntry {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  int get entryDate => throw _privateConstructorUsedError; // Epoch milliseconds
  // Water Intake
  int? get waterIntakeMl => throw _privateConstructorUsedError;
  String? get waterIntakeNotes =>
      throw _privateConstructorUsedError; // Bowel tracking
  BowelCondition? get bowelCondition => throw _privateConstructorUsedError;
  MovementSize? get bowelSize => throw _privateConstructorUsedError;
  String? get bowelPhotoPath =>
      throw _privateConstructorUsedError; // Urine tracking
  UrineCondition? get urineCondition => throw _privateConstructorUsedError;
  MovementSize? get urineSize => throw _privateConstructorUsedError;
  String? get urinePhotoPath =>
      throw _privateConstructorUsedError; // Menstruation
  MenstruationFlow? get menstruationFlow =>
      throw _privateConstructorUsedError; // BBT
  double? get basalBodyTemperature => throw _privateConstructorUsedError;
  int? get bbtRecordedTime =>
      throw _privateConstructorUsedError; // Epoch milliseconds
  // Customizable "Other" Fluid
  String? get otherFluidName => throw _privateConstructorUsedError;
  String? get otherFluidAmount => throw _privateConstructorUsedError;
  String? get otherFluidNotes =>
      throw _privateConstructorUsedError; // Import tracking (for wearable data)
  String? get importSource => throw _privateConstructorUsedError;
  String? get importExternalId =>
      throw _privateConstructorUsedError; // File sync metadata (for bowel/urine photos)
  String? get cloudStorageUrl => throw _privateConstructorUsedError;
  String? get fileHash => throw _privateConstructorUsedError;
  int? get fileSizeBytes => throw _privateConstructorUsedError;
  bool get isFileUploaded =>
      throw _privateConstructorUsedError; // General notes
  String get notes => throw _privateConstructorUsedError;
  List<String> get photoIds => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this FluidsEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FluidsEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FluidsEntryCopyWith<FluidsEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FluidsEntryCopyWith<$Res> {
  factory $FluidsEntryCopyWith(
    FluidsEntry value,
    $Res Function(FluidsEntry) then,
  ) = _$FluidsEntryCopyWithImpl<$Res, FluidsEntry>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    int entryDate,
    int? waterIntakeMl,
    String? waterIntakeNotes,
    BowelCondition? bowelCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,
    UrineCondition? urineCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,
    MenstruationFlow? menstruationFlow,
    double? basalBodyTemperature,
    int? bbtRecordedTime,
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,
    String? importSource,
    String? importExternalId,
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    bool isFileUploaded,
    String notes,
    List<String> photoIds,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$FluidsEntryCopyWithImpl<$Res, $Val extends FluidsEntry>
    implements $FluidsEntryCopyWith<$Res> {
  _$FluidsEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FluidsEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? entryDate = null,
    Object? waterIntakeMl = freezed,
    Object? waterIntakeNotes = freezed,
    Object? bowelCondition = freezed,
    Object? bowelSize = freezed,
    Object? bowelPhotoPath = freezed,
    Object? urineCondition = freezed,
    Object? urineSize = freezed,
    Object? urinePhotoPath = freezed,
    Object? menstruationFlow = freezed,
    Object? basalBodyTemperature = freezed,
    Object? bbtRecordedTime = freezed,
    Object? otherFluidName = freezed,
    Object? otherFluidAmount = freezed,
    Object? otherFluidNotes = freezed,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
    Object? cloudStorageUrl = freezed,
    Object? fileHash = freezed,
    Object? fileSizeBytes = freezed,
    Object? isFileUploaded = null,
    Object? notes = null,
    Object? photoIds = null,
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
            entryDate: null == entryDate
                ? _value.entryDate
                : entryDate // ignore: cast_nullable_to_non_nullable
                      as int,
            waterIntakeMl: freezed == waterIntakeMl
                ? _value.waterIntakeMl
                : waterIntakeMl // ignore: cast_nullable_to_non_nullable
                      as int?,
            waterIntakeNotes: freezed == waterIntakeNotes
                ? _value.waterIntakeNotes
                : waterIntakeNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            bowelCondition: freezed == bowelCondition
                ? _value.bowelCondition
                : bowelCondition // ignore: cast_nullable_to_non_nullable
                      as BowelCondition?,
            bowelSize: freezed == bowelSize
                ? _value.bowelSize
                : bowelSize // ignore: cast_nullable_to_non_nullable
                      as MovementSize?,
            bowelPhotoPath: freezed == bowelPhotoPath
                ? _value.bowelPhotoPath
                : bowelPhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            urineCondition: freezed == urineCondition
                ? _value.urineCondition
                : urineCondition // ignore: cast_nullable_to_non_nullable
                      as UrineCondition?,
            urineSize: freezed == urineSize
                ? _value.urineSize
                : urineSize // ignore: cast_nullable_to_non_nullable
                      as MovementSize?,
            urinePhotoPath: freezed == urinePhotoPath
                ? _value.urinePhotoPath
                : urinePhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            menstruationFlow: freezed == menstruationFlow
                ? _value.menstruationFlow
                : menstruationFlow // ignore: cast_nullable_to_non_nullable
                      as MenstruationFlow?,
            basalBodyTemperature: freezed == basalBodyTemperature
                ? _value.basalBodyTemperature
                : basalBodyTemperature // ignore: cast_nullable_to_non_nullable
                      as double?,
            bbtRecordedTime: freezed == bbtRecordedTime
                ? _value.bbtRecordedTime
                : bbtRecordedTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            otherFluidName: freezed == otherFluidName
                ? _value.otherFluidName
                : otherFluidName // ignore: cast_nullable_to_non_nullable
                      as String?,
            otherFluidAmount: freezed == otherFluidAmount
                ? _value.otherFluidAmount
                : otherFluidAmount // ignore: cast_nullable_to_non_nullable
                      as String?,
            otherFluidNotes: freezed == otherFluidNotes
                ? _value.otherFluidNotes
                : otherFluidNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            importSource: freezed == importSource
                ? _value.importSource
                : importSource // ignore: cast_nullable_to_non_nullable
                      as String?,
            importExternalId: freezed == importExternalId
                ? _value.importExternalId
                : importExternalId // ignore: cast_nullable_to_non_nullable
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
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            photoIds: null == photoIds
                ? _value.photoIds
                : photoIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of FluidsEntry
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
abstract class _$$FluidsEntryImplCopyWith<$Res>
    implements $FluidsEntryCopyWith<$Res> {
  factory _$$FluidsEntryImplCopyWith(
    _$FluidsEntryImpl value,
    $Res Function(_$FluidsEntryImpl) then,
  ) = __$$FluidsEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    int entryDate,
    int? waterIntakeMl,
    String? waterIntakeNotes,
    BowelCondition? bowelCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,
    UrineCondition? urineCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,
    MenstruationFlow? menstruationFlow,
    double? basalBodyTemperature,
    int? bbtRecordedTime,
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,
    String? importSource,
    String? importExternalId,
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    bool isFileUploaded,
    String notes,
    List<String> photoIds,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$FluidsEntryImplCopyWithImpl<$Res>
    extends _$FluidsEntryCopyWithImpl<$Res, _$FluidsEntryImpl>
    implements _$$FluidsEntryImplCopyWith<$Res> {
  __$$FluidsEntryImplCopyWithImpl(
    _$FluidsEntryImpl _value,
    $Res Function(_$FluidsEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FluidsEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? entryDate = null,
    Object? waterIntakeMl = freezed,
    Object? waterIntakeNotes = freezed,
    Object? bowelCondition = freezed,
    Object? bowelSize = freezed,
    Object? bowelPhotoPath = freezed,
    Object? urineCondition = freezed,
    Object? urineSize = freezed,
    Object? urinePhotoPath = freezed,
    Object? menstruationFlow = freezed,
    Object? basalBodyTemperature = freezed,
    Object? bbtRecordedTime = freezed,
    Object? otherFluidName = freezed,
    Object? otherFluidAmount = freezed,
    Object? otherFluidNotes = freezed,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
    Object? cloudStorageUrl = freezed,
    Object? fileHash = freezed,
    Object? fileSizeBytes = freezed,
    Object? isFileUploaded = null,
    Object? notes = null,
    Object? photoIds = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$FluidsEntryImpl(
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
        entryDate: null == entryDate
            ? _value.entryDate
            : entryDate // ignore: cast_nullable_to_non_nullable
                  as int,
        waterIntakeMl: freezed == waterIntakeMl
            ? _value.waterIntakeMl
            : waterIntakeMl // ignore: cast_nullable_to_non_nullable
                  as int?,
        waterIntakeNotes: freezed == waterIntakeNotes
            ? _value.waterIntakeNotes
            : waterIntakeNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        bowelCondition: freezed == bowelCondition
            ? _value.bowelCondition
            : bowelCondition // ignore: cast_nullable_to_non_nullable
                  as BowelCondition?,
        bowelSize: freezed == bowelSize
            ? _value.bowelSize
            : bowelSize // ignore: cast_nullable_to_non_nullable
                  as MovementSize?,
        bowelPhotoPath: freezed == bowelPhotoPath
            ? _value.bowelPhotoPath
            : bowelPhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        urineCondition: freezed == urineCondition
            ? _value.urineCondition
            : urineCondition // ignore: cast_nullable_to_non_nullable
                  as UrineCondition?,
        urineSize: freezed == urineSize
            ? _value.urineSize
            : urineSize // ignore: cast_nullable_to_non_nullable
                  as MovementSize?,
        urinePhotoPath: freezed == urinePhotoPath
            ? _value.urinePhotoPath
            : urinePhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        menstruationFlow: freezed == menstruationFlow
            ? _value.menstruationFlow
            : menstruationFlow // ignore: cast_nullable_to_non_nullable
                  as MenstruationFlow?,
        basalBodyTemperature: freezed == basalBodyTemperature
            ? _value.basalBodyTemperature
            : basalBodyTemperature // ignore: cast_nullable_to_non_nullable
                  as double?,
        bbtRecordedTime: freezed == bbtRecordedTime
            ? _value.bbtRecordedTime
            : bbtRecordedTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        otherFluidName: freezed == otherFluidName
            ? _value.otherFluidName
            : otherFluidName // ignore: cast_nullable_to_non_nullable
                  as String?,
        otherFluidAmount: freezed == otherFluidAmount
            ? _value.otherFluidAmount
            : otherFluidAmount // ignore: cast_nullable_to_non_nullable
                  as String?,
        otherFluidNotes: freezed == otherFluidNotes
            ? _value.otherFluidNotes
            : otherFluidNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        importSource: freezed == importSource
            ? _value.importSource
            : importSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        importExternalId: freezed == importExternalId
            ? _value.importExternalId
            : importExternalId // ignore: cast_nullable_to_non_nullable
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
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        photoIds: null == photoIds
            ? _value._photoIds
            : photoIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$FluidsEntryImpl extends _FluidsEntry {
  const _$FluidsEntryImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.entryDate,
    this.waterIntakeMl,
    this.waterIntakeNotes,
    this.bowelCondition,
    this.bowelSize,
    this.bowelPhotoPath,
    this.urineCondition,
    this.urineSize,
    this.urinePhotoPath,
    this.menstruationFlow,
    this.basalBodyTemperature,
    this.bbtRecordedTime,
    this.otherFluidName,
    this.otherFluidAmount,
    this.otherFluidNotes,
    this.importSource,
    this.importExternalId,
    this.cloudStorageUrl,
    this.fileHash,
    this.fileSizeBytes,
    this.isFileUploaded = false,
    this.notes = '',
    final List<String> photoIds = const [],
    required this.syncMetadata,
  }) : _photoIds = photoIds,
       super._();

  factory _$FluidsEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FluidsEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final int entryDate;
  // Epoch milliseconds
  // Water Intake
  @override
  final int? waterIntakeMl;
  @override
  final String? waterIntakeNotes;
  // Bowel tracking
  @override
  final BowelCondition? bowelCondition;
  @override
  final MovementSize? bowelSize;
  @override
  final String? bowelPhotoPath;
  // Urine tracking
  @override
  final UrineCondition? urineCondition;
  @override
  final MovementSize? urineSize;
  @override
  final String? urinePhotoPath;
  // Menstruation
  @override
  final MenstruationFlow? menstruationFlow;
  // BBT
  @override
  final double? basalBodyTemperature;
  @override
  final int? bbtRecordedTime;
  // Epoch milliseconds
  // Customizable "Other" Fluid
  @override
  final String? otherFluidName;
  @override
  final String? otherFluidAmount;
  @override
  final String? otherFluidNotes;
  // Import tracking (for wearable data)
  @override
  final String? importSource;
  @override
  final String? importExternalId;
  // File sync metadata (for bowel/urine photos)
  @override
  final String? cloudStorageUrl;
  @override
  final String? fileHash;
  @override
  final int? fileSizeBytes;
  @override
  @JsonKey()
  final bool isFileUploaded;
  // General notes
  @override
  @JsonKey()
  final String notes;
  final List<String> _photoIds;
  @override
  @JsonKey()
  List<String> get photoIds {
    if (_photoIds is EqualUnmodifiableListView) return _photoIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoIds);
  }

  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'FluidsEntry(id: $id, clientId: $clientId, profileId: $profileId, entryDate: $entryDate, waterIntakeMl: $waterIntakeMl, waterIntakeNotes: $waterIntakeNotes, bowelCondition: $bowelCondition, bowelSize: $bowelSize, bowelPhotoPath: $bowelPhotoPath, urineCondition: $urineCondition, urineSize: $urineSize, urinePhotoPath: $urinePhotoPath, menstruationFlow: $menstruationFlow, basalBodyTemperature: $basalBodyTemperature, bbtRecordedTime: $bbtRecordedTime, otherFluidName: $otherFluidName, otherFluidAmount: $otherFluidAmount, otherFluidNotes: $otherFluidNotes, importSource: $importSource, importExternalId: $importExternalId, cloudStorageUrl: $cloudStorageUrl, fileHash: $fileHash, fileSizeBytes: $fileSizeBytes, isFileUploaded: $isFileUploaded, notes: $notes, photoIds: $photoIds, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FluidsEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.waterIntakeMl, waterIntakeMl) ||
                other.waterIntakeMl == waterIntakeMl) &&
            (identical(other.waterIntakeNotes, waterIntakeNotes) ||
                other.waterIntakeNotes == waterIntakeNotes) &&
            (identical(other.bowelCondition, bowelCondition) ||
                other.bowelCondition == bowelCondition) &&
            (identical(other.bowelSize, bowelSize) ||
                other.bowelSize == bowelSize) &&
            (identical(other.bowelPhotoPath, bowelPhotoPath) ||
                other.bowelPhotoPath == bowelPhotoPath) &&
            (identical(other.urineCondition, urineCondition) ||
                other.urineCondition == urineCondition) &&
            (identical(other.urineSize, urineSize) ||
                other.urineSize == urineSize) &&
            (identical(other.urinePhotoPath, urinePhotoPath) ||
                other.urinePhotoPath == urinePhotoPath) &&
            (identical(other.menstruationFlow, menstruationFlow) ||
                other.menstruationFlow == menstruationFlow) &&
            (identical(other.basalBodyTemperature, basalBodyTemperature) ||
                other.basalBodyTemperature == basalBodyTemperature) &&
            (identical(other.bbtRecordedTime, bbtRecordedTime) ||
                other.bbtRecordedTime == bbtRecordedTime) &&
            (identical(other.otherFluidName, otherFluidName) ||
                other.otherFluidName == otherFluidName) &&
            (identical(other.otherFluidAmount, otherFluidAmount) ||
                other.otherFluidAmount == otherFluidAmount) &&
            (identical(other.otherFluidNotes, otherFluidNotes) ||
                other.otherFluidNotes == otherFluidNotes) &&
            (identical(other.importSource, importSource) ||
                other.importSource == importSource) &&
            (identical(other.importExternalId, importExternalId) ||
                other.importExternalId == importExternalId) &&
            (identical(other.cloudStorageUrl, cloudStorageUrl) ||
                other.cloudStorageUrl == cloudStorageUrl) &&
            (identical(other.fileHash, fileHash) ||
                other.fileHash == fileHash) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.isFileUploaded, isFileUploaded) ||
                other.isFileUploaded == isFileUploaded) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._photoIds, _photoIds) &&
            (identical(other.syncMetadata, syncMetadata) ||
                other.syncMetadata == syncMetadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    clientId,
    profileId,
    entryDate,
    waterIntakeMl,
    waterIntakeNotes,
    bowelCondition,
    bowelSize,
    bowelPhotoPath,
    urineCondition,
    urineSize,
    urinePhotoPath,
    menstruationFlow,
    basalBodyTemperature,
    bbtRecordedTime,
    otherFluidName,
    otherFluidAmount,
    otherFluidNotes,
    importSource,
    importExternalId,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    notes,
    const DeepCollectionEquality().hash(_photoIds),
    syncMetadata,
  ]);

  /// Create a copy of FluidsEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FluidsEntryImplCopyWith<_$FluidsEntryImpl> get copyWith =>
      __$$FluidsEntryImplCopyWithImpl<_$FluidsEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FluidsEntryImplToJson(this);
  }
}

abstract class _FluidsEntry extends FluidsEntry {
  const factory _FluidsEntry({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final int entryDate,
    final int? waterIntakeMl,
    final String? waterIntakeNotes,
    final BowelCondition? bowelCondition,
    final MovementSize? bowelSize,
    final String? bowelPhotoPath,
    final UrineCondition? urineCondition,
    final MovementSize? urineSize,
    final String? urinePhotoPath,
    final MenstruationFlow? menstruationFlow,
    final double? basalBodyTemperature,
    final int? bbtRecordedTime,
    final String? otherFluidName,
    final String? otherFluidAmount,
    final String? otherFluidNotes,
    final String? importSource,
    final String? importExternalId,
    final String? cloudStorageUrl,
    final String? fileHash,
    final int? fileSizeBytes,
    final bool isFileUploaded,
    final String notes,
    final List<String> photoIds,
    required final SyncMetadata syncMetadata,
  }) = _$FluidsEntryImpl;
  const _FluidsEntry._() : super._();

  factory _FluidsEntry.fromJson(Map<String, dynamic> json) =
      _$FluidsEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  int get entryDate; // Epoch milliseconds
  // Water Intake
  @override
  int? get waterIntakeMl;
  @override
  String? get waterIntakeNotes; // Bowel tracking
  @override
  BowelCondition? get bowelCondition;
  @override
  MovementSize? get bowelSize;
  @override
  String? get bowelPhotoPath; // Urine tracking
  @override
  UrineCondition? get urineCondition;
  @override
  MovementSize? get urineSize;
  @override
  String? get urinePhotoPath; // Menstruation
  @override
  MenstruationFlow? get menstruationFlow; // BBT
  @override
  double? get basalBodyTemperature;
  @override
  int? get bbtRecordedTime; // Epoch milliseconds
  // Customizable "Other" Fluid
  @override
  String? get otherFluidName;
  @override
  String? get otherFluidAmount;
  @override
  String? get otherFluidNotes; // Import tracking (for wearable data)
  @override
  String? get importSource;
  @override
  String? get importExternalId; // File sync metadata (for bowel/urine photos)
  @override
  String? get cloudStorageUrl;
  @override
  String? get fileHash;
  @override
  int? get fileSizeBytes;
  @override
  bool get isFileUploaded; // General notes
  @override
  String get notes;
  @override
  List<String> get photoIds;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of FluidsEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FluidsEntryImplCopyWith<_$FluidsEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
