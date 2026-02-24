// lib/domain/repositories/supplement_label_photo_repository.dart
// Phase 15a — Repository interface for supplement label photos
// Per 60_SUPPLEMENT_EXTENSION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/supplement_label_photo.dart';

/// Repository interface for supplement label photos.
///
/// Photos are stored locally and not synced to Google Drive.
/// Up to 3 photos per supplement.
abstract class SupplementLabelPhotoRepository {
  /// Get all photos for a supplement, ordered by sort_order.
  Future<Result<List<SupplementLabelPhoto>, AppError>> getForSupplement(
    String supplementId,
  );

  /// Add a new label photo record.
  Future<Result<SupplementLabelPhoto, AppError>> add(
    SupplementLabelPhoto photo,
  );

  /// Delete a photo by ID.
  Future<Result<void, AppError>> deleteById(String id);

  /// Delete all photos for a supplement (called when supplement is deleted).
  Future<void> deleteForSupplement(String supplementId);
}
