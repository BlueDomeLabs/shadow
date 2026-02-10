// lib/domain/repositories/flare_up_repository.dart
// Repository interface per 22_API_CONTRACTS.md Section 10.19

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository interface for FlareUp entities.
///
/// Per 22_API_CONTRACTS.md Section 10.19:
/// - Extends EntityRepository for standard CRUD and sync operations
/// - All methods return `Result<T, AppError>`
/// - All timestamps are int (epoch milliseconds)
abstract class FlareUpRepository implements EntityRepository<FlareUp, String> {
  /// Get flare-ups for a specific condition.
  Future<Result<List<FlareUp>, AppError>> getByCondition(
    String conditionId, {
    int? startDate,
    int? endDate,
    bool? ongoingOnly,
    int? limit,
    int? offset,
  });

  /// Get flare-ups for a profile.
  Future<Result<List<FlareUp>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    bool? ongoingOnly,
    int? limit,
    int? offset,
  });

  /// Get ongoing flare-ups for a profile.
  Future<Result<List<FlareUp>, AppError>> getOngoing(String profileId);

  /// Get trigger frequency counts for a condition within a date range.
  Future<Result<Map<String, int>, AppError>> getTriggerCounts(
    String conditionId, {
    required int startDate,
    required int endDate,
  });

  /// End a flare-up by setting the endDate.
  Future<Result<FlareUp, AppError>> endFlareUp(String id, int endDate);
}
