// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PhotoEntry _$PhotoEntryFromJson(Map<String, dynamic> json) {
  return _PhotoEntry.fromJson(json);
}

/// @nodoc
mixin _$PhotoEntry {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get photoAreaId => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError; // Epoch milliseconds
  String get filePath => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // File sync metadata
  String? get cloudStorageUrl => throw _privateConstructorUsedError;
  String? get fileHash => throw _privateConstructorUsedError;
  int? get fileSizeBytes => throw _privateConstructorUsedError;
  bool get isFileUploaded => throw _privateConstructorUsedError;
  SyncMetadata get syncMetadata => throw _privateConstructorUsedError;

  /// Serializes this PhotoEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoEntryCopyWith<PhotoEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoEntryCopyWith<$Res> {
  factory $PhotoEntryCopyWith(
    PhotoEntry value,
    $Res Function(PhotoEntry) then,
  ) = _$PhotoEntryCopyWithImpl<$Res, PhotoEntry>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String photoAreaId,
    int timestamp,
    String filePath,
    String? notes,
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    bool isFileUploaded,
    SyncMetadata syncMetadata,
  });

  $SyncMetadataCopyWith<$Res> get syncMetadata;
}

/// @nodoc
class _$PhotoEntryCopyWithImpl<$Res, $Val extends PhotoEntry>
    implements $PhotoEntryCopyWith<$Res> {
  _$PhotoEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? photoAreaId = null,
    Object? timestamp = null,
    Object? filePath = null,
    Object? notes = freezed,
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
            photoAreaId: null == photoAreaId
                ? _value.photoAreaId
                : photoAreaId // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
            filePath: null == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of PhotoEntry
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
abstract class _$$PhotoEntryImplCopyWith<$Res>
    implements $PhotoEntryCopyWith<$Res> {
  factory _$$PhotoEntryImplCopyWith(
    _$PhotoEntryImpl value,
    $Res Function(_$PhotoEntryImpl) then,
  ) = __$$PhotoEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String profileId,
    String photoAreaId,
    int timestamp,
    String filePath,
    String? notes,
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
class __$$PhotoEntryImplCopyWithImpl<$Res>
    extends _$PhotoEntryCopyWithImpl<$Res, _$PhotoEntryImpl>
    implements _$$PhotoEntryImplCopyWith<$Res> {
  __$$PhotoEntryImplCopyWithImpl(
    _$PhotoEntryImpl _value,
    $Res Function(_$PhotoEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhotoEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? profileId = null,
    Object? photoAreaId = null,
    Object? timestamp = null,
    Object? filePath = null,
    Object? notes = freezed,
    Object? cloudStorageUrl = freezed,
    Object? fileHash = freezed,
    Object? fileSizeBytes = freezed,
    Object? isFileUploaded = null,
    Object? syncMetadata = null,
  }) {
    return _then(
      _$PhotoEntryImpl(
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
        photoAreaId: null == photoAreaId
            ? _value.photoAreaId
            : photoAreaId // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        filePath: null == filePath
            ? _value.filePath
            : filePath // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
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
class _$PhotoEntryImpl extends _PhotoEntry {
  const _$PhotoEntryImpl({
    required this.id,
    required this.clientId,
    required this.profileId,
    required this.photoAreaId,
    required this.timestamp,
    required this.filePath,
    this.notes,
    this.cloudStorageUrl,
    this.fileHash,
    this.fileSizeBytes,
    this.isFileUploaded = false,
    required this.syncMetadata,
  }) : super._();

  factory _$PhotoEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String profileId;
  @override
  final String photoAreaId;
  @override
  final int timestamp;
  // Epoch milliseconds
  @override
  final String filePath;
  @override
  final String? notes;
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
    return 'PhotoEntry(id: $id, clientId: $clientId, profileId: $profileId, photoAreaId: $photoAreaId, timestamp: $timestamp, filePath: $filePath, notes: $notes, cloudStorageUrl: $cloudStorageUrl, fileHash: $fileHash, fileSizeBytes: $fileSizeBytes, isFileUploaded: $isFileUploaded, syncMetadata: $syncMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.photoAreaId, photoAreaId) ||
                other.photoAreaId == photoAreaId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
    photoAreaId,
    timestamp,
    filePath,
    notes,
    cloudStorageUrl,
    fileHash,
    fileSizeBytes,
    isFileUploaded,
    syncMetadata,
  );

  /// Create a copy of PhotoEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoEntryImplCopyWith<_$PhotoEntryImpl> get copyWith =>
      __$$PhotoEntryImplCopyWithImpl<_$PhotoEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoEntryImplToJson(this);
  }
}

abstract class _PhotoEntry extends PhotoEntry {
  const factory _PhotoEntry({
    required final String id,
    required final String clientId,
    required final String profileId,
    required final String photoAreaId,
    required final int timestamp,
    required final String filePath,
    final String? notes,
    final String? cloudStorageUrl,
    final String? fileHash,
    final int? fileSizeBytes,
    final bool isFileUploaded,
    required final SyncMetadata syncMetadata,
  }) = _$PhotoEntryImpl;
  const _PhotoEntry._() : super._();

  factory _PhotoEntry.fromJson(Map<String, dynamic> json) =
      _$PhotoEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get profileId;
  @override
  String get photoAreaId;
  @override
  int get timestamp; // Epoch milliseconds
  @override
  String get filePath;
  @override
  String? get notes; // File sync metadata
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

  /// Create a copy of PhotoEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoEntryImplCopyWith<_$PhotoEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
