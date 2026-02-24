// lib/domain/entities/supplement_label_photo.dart
// Phase 15a — Supplement Extension label photo entity
// Per 60_SUPPLEMENT_EXTENSION.md

import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplement_label_photo.freezed.dart';

/// A label photo attached to a supplement record.
///
/// Stores a local file path to a photo of the supplement label,
/// prescription label, or bottle for visual documentation.
/// Up to 3 photos per supplement.
///
/// Per 60_SUPPLEMENT_EXTENSION.md — stored locally, not synced to Drive.
@freezed
class SupplementLabelPhoto with _$SupplementLabelPhoto {
  const factory SupplementLabelPhoto({
    required String id,
    required String supplementId,
    required String filePath, // Local file path
    required int capturedAt, // Epoch milliseconds
    @Default(0) int sortOrder,
  }) = _SupplementLabelPhoto;
}
