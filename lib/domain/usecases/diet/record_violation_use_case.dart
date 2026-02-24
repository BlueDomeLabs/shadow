// lib/domain/usecases/diet/record_violation_use_case.dart
// Phase 15b-2 — Record a diet violation event
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/diet_violation_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';
import 'package:uuid/uuid.dart';

/// Use case: record a diet violation event.
///
/// Called after [CheckComplianceUseCase] detects a violation. Records
/// whether the user chose "Add Anyway" (wasOverridden=true) or "Cancel"
/// (wasOverridden=false).
class RecordViolationUseCase
    implements UseCase<RecordViolationInput, DietViolation> {
  final DietViolationRepository _repository;
  final ProfileAuthorizationService _authService;
  final Uuid _uuid;

  RecordViolationUseCase(
    this._repository,
    this._authService, [
    Uuid uuid = const Uuid(),
  ]) : _uuid = uuid;

  @override
  Future<Result<DietViolation, AppError>> call(
    RecordViolationInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Create violation entity
    final now = DateTime.now().millisecondsSinceEpoch;
    final violation = DietViolation(
      id: _uuid.v4(),
      clientId: input.clientId,
      profileId: input.profileId,
      dietId: input.dietId,
      ruleId: input.ruleId,
      foodLogId: input.foodLogId,
      foodName: input.foodName,
      ruleDescription: input.ruleDescription,
      wasOverridden: input.wasOverridden,
      timestamp: input.timestamp,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Populated by repository
      ),
    );

    return _repository.create(violation);
  }
}
