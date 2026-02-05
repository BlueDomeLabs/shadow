// lib/domain/repositories/photo_entry_repository.dart
// Repository interface per 22_API_CONTRACTS.md Section 10.18

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository interface for PhotoEntry entities.
///
/// Per 22_API_CONTRACTS.md Section 10.18:
/// - Extends EntityRepository for standard CRUD and sync operations
/// - All methods return `Result<T, AppError>`
/// - All timestamps are int (epoch milliseconds)
abstract class PhotoEntryRepository
    implements EntityRepository<PhotoEntry, String> {
  /// Get photo entries for a specific area.
  Future<Result<List<PhotoEntry>, AppError>> getByArea(
    String photoAreaId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  });

  /// Get photo entries for a profile.
  Future<Result<List<PhotoEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  });

  /// Get entries pending upload to cloud.
  Future<Result<List<PhotoEntry>, AppError>> getPendingUpload();
}
