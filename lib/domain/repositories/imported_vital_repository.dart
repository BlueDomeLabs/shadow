// lib/domain/repositories/imported_vital_repository.dart
// Phase 16 — Repository interface for imported health vitals
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/imported_vital.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

/// Repository for managing imported health platform vitals.
///
/// Imported vitals are read-only after creation. Re-syncing adds new records
/// but never overwrites existing ones (deduplication by recordedAt + dataType
/// + sourcePlatform).
abstract class ImportedVitalRepository {
  /// Returns all imported vitals for a profile, optionally filtered by date
  /// range and/or data type.
  Future<Result<List<ImportedVital>, AppError>> getByProfile({
    required String profileId,
    int? startEpoch,
    int? endEpoch,
    HealthDataType? dataType,
  });

  /// Writes a batch of imported vitals, skipping any that would cause a
  /// duplicate (same dataType + recordedAt + sourcePlatform + profileId).
  /// Returns the number of records actually inserted.
  Future<Result<int, AppError>> importBatch(List<ImportedVital> vitals);

  /// Returns the epoch ms of the most recent importedAt timestamp for a
  /// specific (profileId, dataType) pair, or null if never imported.
  /// Used to determine the start point for incremental syncs.
  Future<Result<int?, AppError>> getLastImportTime(
    String profileId,
    HealthDataType dataType,
  );

  /// Returns records modified since the given epoch ms (for cloud sync).
  Future<Result<List<ImportedVital>, AppError>> getModifiedSince(int since);
}
