// lib/domain/entities/photo_area.dart
// PhotoArea entity per 22_API_CONTRACTS.md Section 10.17

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'photo_area.freezed.dart';
part 'photo_area.g.dart';

/// PhotoArea entity for named photo areas for body location tracking.
///
/// Per 22_API_CONTRACTS.md Section 10.17:
/// - consistencyNotes: Guidance for consistent photo positioning
/// - sortOrder: Display order
/// - isArchived: Soft delete flag
@Freezed(toJson: true, fromJson: true)
class PhotoArea with _$PhotoArea {
  const PhotoArea._();

  @JsonSerializable(explicitToJson: true)
  const factory PhotoArea({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    String? description,
    String? consistencyNotes,
    @Default(0) int sortOrder,
    @Default(false) bool isArchived,
    required SyncMetadata syncMetadata,
  }) = _PhotoArea;

  factory PhotoArea.fromJson(Map<String, dynamic> json) =>
      _$PhotoAreaFromJson(json);
}
