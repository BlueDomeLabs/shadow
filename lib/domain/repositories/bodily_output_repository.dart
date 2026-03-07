// lib/domain/repositories/bodily_output_repository.dart
// Repository interface per FLUIDS_RESTRUCTURING_SPEC.md Section 5

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';

/// Repository interface for bodily output log events.
abstract class BodilyOutputRepository {
  /// Log a new bodily output event.
  Future<Result<void, AppError>> log(BodilyOutputLog entry);

  /// Get all output events for a profile with optional filters.
  Future<Result<List<BodilyOutputLog>, AppError>> getAll(
    String profileId, {
    int? from,
    int? to,
    BodyOutputType? type,
  });

  /// Get a single output log by ID.
  Future<Result<BodilyOutputLog, AppError>> getById(String id);

  /// Update an existing output log.
  Future<Result<void, AppError>> update(BodilyOutputLog entry);

  /// Soft-delete an output log.
  Future<Result<void, AppError>> delete(String profileId, String id);
}
