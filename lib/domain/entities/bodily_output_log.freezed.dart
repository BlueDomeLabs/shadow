// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bodily_output_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BodilyOutputLog _$BodilyOutputLogFromJson(Map<String, dynamic> json) {
  return _BodilyOutputLog.fromJson(json);
}

/// @nodoc
mixin _$BodilyOutputLog {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  int get occurredAt =>
      throw _privateConstructorUsedError; // Epoch ms when event occurred
  BodyOutputType get outputType =>
      throw _privateConstructorUsedError; // Custom type (outputType = custom only)
  String? get customTypeLabel =>
      throw _privateConstructorUsedError; // Urine fields (outputType = urine)
  UrineCondition? get urineCondition => throw _privateConstructorUsedError;
  String? get urineCustomCondition => throw _privateConstructorUsedError;
  OutputSize? get urineSize =>
      throw _privateConstructorUsedError; // Bowel fields (outputType = bowel)
  BowelCondition? get bowelCondition => throw _privateConstructorUsedError;
  String? get bowelCustomCondition => throw _privateConstructorUsedError;
  OutputSize? get bowelSize =>
      throw _privateConstructorUsedError; // Gas fields (outputType = gas)
  // gasSeverity is required for gas — enforced in use case, not entity.
  // Default for migrated rows: moderate(1).
  GasSeverity? get gasSeverity =>
      throw _privateConstructorUsedError; // Menstruation fields (outputType = menstruation)
  MenstruationFlow? get menstruationFlow =>
      throw _privateConstructorUsedError; // BBT fields (outputType = bbt)
  double? get temperatureValue => throw _privateConstructorUsedError;
  TemperatureUnit? get temperatureUnit =>
      throw _privateConstructorUsedError; // Shared optional fields
  String? get notes => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError; // Photo sync
  String? get cloudStorageUrl => throw _privateConstructorUsedError;
  String? get fileHash => throw _privateConstructorUsedError;
  int? get fileSizeBytes => throw _privateConstructorUsedError;
  bool get isFileUploaded =>
      throw _privateConstructorUsedError; // Import tracking
  String? get importSource => throw _privateConstructorUsedError;
  String? get importExternalId => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this BodilyOutputLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodilyOutputLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodilyOutputLogCopyWith<BodilyOutputLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodilyOutputLogCopyWith<$Res> {
  factory $BodilyOutputLogCopyWith(
    BodilyOutputLog value,
    $Res Function(BodilyOutputLog) then,
  ) = _$BodilyOutputLogCopyWithImpl<$Res, BodilyOutputLog>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    int occurredAt,
    BodyOutputType outputType,
    String? customTypeLabel,
    UrineCondition? urineCondition,
    String? urineCustomCondition,
    OutputSize? urineSize,
    BowelCondition? bowelCondition,
    String? bowelCustomCondition,
    OutputSize? bowelSize,
    GasSeverity? gasSeverity,
    MenstruationFlow? menstruationFlow,
    double? temperatureValue,
    TemperatureUnit? temperatureUnit,
    String? notes,
    String? photoPath,
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    bool isFileUploaded,
    String? importSource,
    String? importExternalId,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$BodilyOutputLogCopyWithImpl<$Res, $Val extends BodilyOutputLog>
    implements $BodilyOutputLogCopyWith<$Res> {
  _$BodilyOutputLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodilyOutputLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? occurredAt = null,
    Object? outputType = null,
    Object? customTypeLabel = freezed,
    Object? urineCondition = freezed,
    Object? urineCustomCondition = freezed,
    Object? urineSize = freezed,
    Object? bowelCondition = freezed,
    Object? bowelCustomCondition = freezed,
    Object? bowelSize = freezed,
    Object? gasSeverity = freezed,
    Object? menstruationFlow = freezed,
    Object? temperatureValue = freezed,
    Object? temperatureUnit = freezed,
    Object? notes = freezed,
    Object? photoPath = freezed,
    Object? cloudStorageUrl = freezed,
    Object? fileHash = freezed,
    Object? fileSizeBytes = freezed,
    Object? isFileUploaded = null,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
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
            occurredAt: null == occurredAt
                ? _value.occurredAt
                : occurredAt // ignore: cast_nullable_to_non_nullable
                      as int,
            outputType: null == outputType
                ? _value.outputType
                : outputType // ignore: cast_nullable_to_non_nullable
                      as BodyOutputType,
            customTypeLabel: freezed == customTypeLabel
                ? _value.customTypeLabel
                : customTypeLabel // ignore: cast_nullable_to_non_nullable
                      as String?,
            urineCondition: freezed == urineCondition
                ? _value.urineCondition
                : urineCondition // ignore: cast_nullable_to_non_nullable
                      as UrineCondition?,
            urineCustomCondition: freezed == urineCustomCondition
                ? _value.urineCustomCondition
                : urineCustomCondition // ignore: cast_nullable_to_non_nullable
                      as String?,
            urineSize: freezed == urineSize
                ? _value.urineSize
                : urineSize // ignore: cast_nullable_to_non_nullable
                      as OutputSize?,
            bowelCondition: freezed == bowelCondition
                ? _value.bowelCondition
                : bowelCondition // ignore: cast_nullable_to_non_nullable
                      as BowelCondition?,
            bowelCustomCondition: freezed == bowelCustomCondition
                ? _value.bowelCustomCondition
                : bowelCustomCondition // ignore: cast_nullable_to_non_nullable
                      as String?,
            bowelSize: freezed == bowelSize
                ? _value.bowelSize
                : bowelSize // ignore: cast_nullable_to_non_nullable
                      as OutputSize?,
            gasSeverity: freezed == gasSeverity
                ? _value.gasSeverity
                : gasSeverity // ignore: cast_nullable_to_non_nullable
                      as GasSeverity?,
            menstruationFlow: freezed == menstruationFlow
                ? _value.menstruationFlow
                : menstruationFlow // ignore: cast_nullable_to_non_nullable
                      as MenstruationFlow?,
            temperatureValue: freezed == temperatureValue
                ? _value.temperatureValue
                : temperatureValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            temperatureUnit: freezed == temperatureUnit
                ? _value.temperatureUnit
                : temperatureUnit // ignore: cast_nullable_to_non_nullable
                      as TemperatureUnit?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
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
            importSource: freezed == importSource
                ? _value.importSource
                : importSource // ignore: cast_nullable_to_non_nullable
                      as String?,
            importExternalId: freezed == importExternalId
                ? _value.importExternalId
                : importExternalId // ignore: cast_nullable_to_non_nullable
                      as String?,
            syncMetadata: null == syncMetadata
                ? _value.syncMetadata
                : syncMetadata // ignore: cast_nullable_to_non_nullable
                      as SyncMetadata,
          )
          as $Val,
    );
  }

  /// Create a copy of BodilyOutputLog
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
abstract class _$$BodilyOutputLogImplCopyWith<$Res>
    implements $BodilyOutputLogCopyWith<$Res> {
  factory _$$BodilyOutputLogImplCopyWith(
    _$BodilyOutputLogImpl value,
    $Res Function(_$BodilyOutputLogImpl) then,
  ) = __$$BodilyOutputLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    int occurredAt,
    BodyOutputType outputType,
    String? customTypeLabel,
    UrineCondition? urineCondition,
    String? urineCustomCondition,
    OutputSize? urineSize,
    BowelCondition? bowelCondition,
    String? bowelCustomCondition,
    OutputSize? bowelSize,
    GasSeverity? gasSeverity,
    MenstruationFlow? menstruationFlow,
    double? temperatureValue,
    TemperatureUnit? temperatureUnit,
    String? notes,
    String? photoPath,
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    bool isFileUploaded,
    String? importSource,
    String? importExternalId,
    SyncMetadata syncMetadata,
  });

  @override
  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class __$$BodilyOutputLogImplCopyWithImpl<$Res>
    extends _$BodilyOutputLogCopyWithImpl<$Res, _$BodilyOutputLogImpl>
    implements _$$BodilyOutputLogImplCopyWith<$Res> {
  __$$BodilyOutputLogImplCopyWithImpl(
    _$BodilyOutputLogImpl _value,
    $Res Function(_$BodilyOutputLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BodilyOutputLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? occurredAt = null,
    Object? outputType = null,
    Object? customTypeLabel = freezed,
    Object? urineCondition = freezed,
    Object? urineCustomCondition = freezed,
    Object? urineSize = freezed,
    Object? bowelCondition = freezed,
    Object? bowelCustomCondition = freezed,
    Object? bowelSize = freezed,
    Object? gasSeverity = freezed,
    Object? menstruationFlow = freezed,
    Object? temperatureValue = freezed,
    Object? temperatureUnit = freezed,
    Object? notes = freezed,
    Object? photoPath = freezed,
    Object? cloudStorageUrl = freezed,
    Object? fileHash = freezed,
    Object? fileSizeBytes = freezed,
    Object? isFileUploaded = null,
    Object? importSource = freezed,
    Object? importExternalId = freezed,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$BodilyOutputLogImpl(
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
        occurredAt: null == occurredAt
            ? _value.occurredAt
            : occurredAt // ignore: cast_nullable_to_non_nullable
                  as int,
        outputType: null == outputType
            ? _value.outputType
            : outputType // ignore: cast_nullable_to_non_nullable
                  as BodyOutputType,
        customTypeLabel: freezed == customTypeLabel
            ? _value.customTypeLabel
            : customTypeLabel // ignore: cast_nullable_to_non_nullable
                  as String?,
        urineCondition: freezed == urineCondition
            ? _value.urineCondition
            : urineCondition // ignore: cast_nullable_to_non_nullable
                  as UrineCondition?,
        urineCustomCondition: freezed == urineCustomCondition
            ? _value.urineCustomCondition
            : urineCustomCondition // ignore: cast_nullable_to_non_nullable
                  as String?,
        urineSize: freezed == urineSize
            ? _value.urineSize
            : urineSize // ignore: cast_nullable_to_non_nullable
                  as OutputSize?,
        bowelCondition: freezed == bowelCondition
            ? _value.bowelCondition
            : bowelCondition // ignore: cast_nullable_to_non_nullable
                  as BowelCondition?,
        bowelCustomCondition: freezed == bowelCustomCondition
            ? _value.bowelCustomCondition
            : bowelCustomCondition // ignore: cast_nullable_to_non_nullable
                  as String?,
        bowelSize: freezed == bowelSize
            ? _value.bowelSize
            : bowelSize // ignore: cast_nullable_to_non_nullable
                  as OutputSize?,
        gasSeverity: freezed == gasSeverity
            ? _value.gasSeverity
            : gasSeverity // ignore: cast_nullable_to_non_nullable
                  as GasSeverity?,
        menstruationFlow: freezed == menstruationFlow
            ? _value.menstruationFlow
            : menstruationFlow // ignore: cast_nullable_to_non_nullable
                  as MenstruationFlow?,
        temperatureValue: freezed == temperatureValue
            ? _value.temperatureValue
            : temperatureValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        temperatureUnit: freezed == temperatureUnit
            ? _value.temperatureUnit
            : temperatureUnit // ignore: cast_nullable_to_non_nullable
                  as TemperatureUnit?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
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
        importSource: freezed == importSource
            ? _value.importSource
            : importSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        importExternalId: freezed == importExternalId
            ? _value.importExternalId
            : importExternalId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$BodilyOutputLogImpl extends _BodilyOutputLog {
  const _$BodilyOutputLogImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.occurredAt,
    required this.outputType,
    this.customTypeLabel,
    this.urineCondition,
    this.urineCustomCondition,
    this.urineSize,
    this.bowelCondition,
    this.bowelCustomCondition,
    this.bowelSize,
    this.gasSeverity,
    this.menstruationFlow,
    this.temperatureValue,
    this.temperatureUnit,
    this.notes,
    this.photoPath,
    this.cloudStorageUrl,
    this.fileHash,
    this.fileSizeBytes,
    this.isFileUploaded = false,
    this.importSource,
    this.importExternalId,
    required this.syncMetadata,
  }) : super._();

  factory _$BodilyOutputLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodilyOutputLogImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final int occurredAt;
  // Epoch ms when event occurred
  @override
  final BodyOutputType outputType;
  // Custom type (outputType = custom only)
  @override
  final String? customTypeLabel;
  // Urine fields (outputType = urine)
  @override
  final UrineCondition? urineCondition;
  @override
  final String? urineCustomCondition;
  @override
  final OutputSize? urineSize;
  // Bowel fields (outputType = bowel)
  @override
  final BowelCondition? bowelCondition;
  @override
  final String? bowelCustomCondition;
  @override
  final OutputSize? bowelSize;
  // Gas fields (outputType = gas)
  // gasSeverity is required for gas — enforced in use case, not entity.
  // Default for migrated rows: moderate(1).
  @override
  final GasSeverity? gasSeverity;
  // Menstruation fields (outputType = menstruation)
  @override
  final MenstruationFlow? menstruationFlow;
  // BBT fields (outputType = bbt)
  @override
  final double? temperatureValue;
  @override
  final TemperatureUnit? temperatureUnit;
  // Shared optional fields
  @override
  final String? notes;
  @override
  final String? photoPath;
  // Photo sync
  @override
  final String? cloudStorageUrl;
  @override
  final String? fileHash;
  @override
  final int? fileSizeBytes;
  @override
  @JsonKey()
  final bool isFileUploaded;
  // Import tracking
  @override
  final String? importSource;
  @override
  final String? importExternalId;
  @override
  final SyncMetadata syncMetadata;

  @override
  String toString() {
    return 'BodilyOutputLog(id: $id, clientId: $clientId, profileId: $profileId, occurredAt: $occurredAt, outputType: $outputType, customTypeLabel: $customTypeLabel, urineCondition: $urineCondition, urineCustomCondition: $urineCustomCondition, urineSize: $urineSize, bowelCondition: $bowelCondition, bowelCustomCondition: $bowelCustomCondition, bowelSize: $bowelSize, gasSeverity: $gasSeverity, menstruationFlow: $menstruationFlow, temperatureValue: $temperatureValue, temperatureUnit: $temperatureUnit, notes: $notes, photoPath: $photoPath, cloudStorageUrl: $cloudStorageUrl, fileHash: $fileHash, fileSizeBytes: $fileSizeBytes, isFileUploaded: $isFileUploaded, importSource: $importSource, importExternalId: $importExternalId, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodilyOutputLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.outputType, outputType) ||
                other.outputType == outputType) &&
            (identical(other.customTypeLabel, customTypeLabel) ||
                other.customTypeLabel == customTypeLabel) &&
            (identical(other.urineCondition, urineCondition) ||
                other.urineCondition == urineCondition) &&
            (identical(other.urineCustomCondition, urineCustomCondition) ||
                other.urineCustomCondition == urineCustomCondition) &&
            (identical(other.urineSize, urineSize) ||
                other.urineSize == urineSize) &&
            (identical(other.bowelCondition, bowelCondition) ||
                other.bowelCondition == bowelCondition) &&
            (identical(other.bowelCustomCondition, bowelCustomCondition) ||
                other.bowelCustomCondition == bowelCustomCondition) &&
            (identical(other.bowelSize, bowelSize) ||
                other.bowelSize == bowelSize) &&
            (identical(other.gasSeverity, gasSeverity) ||
                other.gasSeverity == gasSeverity) &&
            (identical(other.menstruationFlow, menstruationFlow) ||
                other.menstruationFlow == menstruationFlow) &&
            (identical(other.temperatureValue, temperatureValue) ||
                other.temperatureValue == temperatureValue) &&
            (identical(other.temperatureUnit, temperatureUnit) ||
                other.temperatureUnit == temperatureUnit) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            (identical(other.cloudStorageUrl, cloudStorageUrl) ||
                other.cloudStorageUrl == cloudStorageUrl) &&
            (identical(other.fileHash, fileHash) ||
                other.fileHash == fileHash) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.isFileUploaded, isFileUploaded) ||
                other.isFileUploaded == isFileUploaded) &&
            (identical(other.importSource, importSource) ||
                other.importSource == importSource) &&
            (identical(other.importExternalId, importExternalId) ||
                other.importExternalId == importExternalId) &&
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
    occurredAt,
    outputType,
    customTypeLabel,
    urineCondition,
    urineCustomCondition,
    urineSize,
    bowelCondition,
    bowelCustomCondition,
    bowelSize,
    gasSeverity,
    menstruationFlow,
    temperatureValue,
    temperatureUnit,
    notes,
    photoPath,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    importSource,
    importExternalId,
    syncMetadata,
  ]);

  /// Create a copy of BodilyOutputLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodilyOutputLogImplCopyWith<_$BodilyOutputLogImpl> get copyWith =>
      __$$BodilyOutputLogImplCopyWithImpl<_$BodilyOutputLogImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BodilyOutputLogImplToJson(this);
  }
}

abstract class _BodilyOutputLog extends BodilyOutputLog {
  const factory _BodilyOutputLog({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final int occurredAt,
    required final BodyOutputType outputType,
    final String? customTypeLabel,
    final UrineCondition? urineCondition,
    final String? urineCustomCondition,
    final OutputSize? urineSize,
    final BowelCondition? bowelCondition,
    final String? bowelCustomCondition,
    final OutputSize? bowelSize,
    final GasSeverity? gasSeverity,
    final MenstruationFlow? menstruationFlow,
    final double? temperatureValue,
    final TemperatureUnit? temperatureUnit,
    final String? notes,
    final String? photoPath,
    final String? cloudStorageUrl,
    final String? fileHash,
    final int? fileSizeBytes,
    final bool isFileUploaded,
    final String? importSource,
    final String? importExternalId,
    required final SyncMetadata syncMetadata,
  }) = _$BodilyOutputLogImpl;
  const _BodilyOutputLog._() : super._();

  factory _BodilyOutputLog.fromJson(Map<String, dynamic> json) =
      _$BodilyOutputLogImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  int get occurredAt; // Epoch ms when event occurred
  @override
  BodyOutputType get outputType; // Custom type (outputType = custom only)
  @override
  String? get customTypeLabel; // Urine fields (outputType = urine)
  @override
  UrineCondition? get urineCondition;
  @override
  String? get urineCustomCondition;
  @override
  OutputSize? get urineSize; // Bowel fields (outputType = bowel)
  @override
  BowelCondition? get bowelCondition;
  @override
  String? get bowelCustomCondition;
  @override
  OutputSize? get bowelSize; // Gas fields (outputType = gas)
  // gasSeverity is required for gas — enforced in use case, not entity.
  // Default for migrated rows: moderate(1).
  @override
  GasSeverity? get gasSeverity; // Menstruation fields (outputType = menstruation)
  @override
  MenstruationFlow? get menstruationFlow; // BBT fields (outputType = bbt)
  @override
  double? get temperatureValue;
  @override
  TemperatureUnit? get temperatureUnit; // Shared optional fields
  @override
  String? get notes;
  @override
  String? get photoPath; // Photo sync
  @override
  String? get cloudStorageUrl;
  @override
  String? get fileHash;
  @override
  int? get fileSizeBytes;
  @override
  bool get isFileUploaded; // Import tracking
  @override
  String? get importSource;
  @override
  String? get importExternalId;
  @override
  SyncMetadata get syncMetadata;

  /// Create a copy of BodilyOutputLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodilyOutputLogImplCopyWith<_$BodilyOutputLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
