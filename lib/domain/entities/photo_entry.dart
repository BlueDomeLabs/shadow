// lib/domain/entities/photo_entry.dart
// PhotoEntry entity per 22_API_CONTRACTS.md Section 10.18

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'photo_entry.freezed.dart';
part 'photo_entry.g.dart';

/// PhotoEntry entity for individual photo instances.
///
/// Per 22_API_CONTRACTS.md Section 10.18:
/// - photoAreaId: FK to PhotoArea
/// - timestamp: Epoch milliseconds
/// - File sync metadata for cloud upload tracking
@Freezed(toJson: true, fromJson: true)
class PhotoEntry with _$PhotoEntry {
  const PhotoEntry._();

  @JsonSerializable(explicitToJson: true)
  const factory PhotoEntry({
    required String id,
    required String clientId,
    required String profileId,
    required String photoAreaId,
    required int timestamp, // Epoch milliseconds
    required String filePath,
    String? notes,
    // File sync metadata
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    @Default(false) bool isFileUploaded,
    required SyncMetadata syncMetadata,
  }) = _PhotoEntry;

  factory PhotoEntry.fromJson(Map<String, dynamic> json) =>
      _$PhotoEntryFromJson(json);

  /// Whether the photo has been uploaded to cloud.
  bool get isPendingUpload => !isFileUploaded;
}
