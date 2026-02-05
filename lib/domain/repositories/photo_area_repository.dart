// lib/domain/repositories/photo_area_repository.dart
// Repository interface per 22_API_CONTRACTS.md Section 10.17

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository interface for PhotoArea entities.
///
/// Per 22_API_CONTRACTS.md Section 10.17:
/// - Extends EntityRepository for standard CRUD and sync operations
/// - All methods return `Result<T, AppError>`
abstract class PhotoAreaRepository
    implements EntityRepository<PhotoArea, String> {
  /// Get photo areas for a profile.
  Future<Result<List<PhotoArea>, AppError>> getByProfile(
    String profileId, {
    bool includeArchived = false,
  });

  /// Reorder photo areas by providing ordered list of IDs.
  Future<Result<void, AppError>> reorder(
    String profileId,
    List<String> areaIds,
  );

  /// Archive a photo area.
  Future<Result<void, AppError>> archive(String id);
}
