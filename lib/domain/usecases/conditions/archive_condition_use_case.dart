// lib/domain/usecases/conditions/archive_condition_use_case.dart
// Matches ArchiveSupplementUseCase reference pattern

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/repositories/condition_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/conditions/condition_inputs.dart';

/// Use case to archive or unarchive a condition.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Fetch existing - Get current entity
/// 3. Verify ownership - Ensure entity belongs to profile
/// 4. Update archive status
/// 5. Repository Call - Execute operation
class ArchiveConditionUseCase
    implements UseCase<ArchiveConditionInput, Condition> {
  final ConditionRepository _repository;
  final ProfileAuthorizationService _authService;

  ArchiveConditionUseCase(this._repository, this._authService);

  @override
  Future<Result<Condition, AppError>> call(ArchiveConditionInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }
    final existing = existingResult.valueOrNull!;

    // 3. Verify ownership
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 4. Update archive status
    final updated = existing.copyWith(
      isArchived: input.archive,
      syncMetadata: existing.syncMetadata.copyWith(
        syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
        syncVersion: existing.syncMetadata.syncVersion + 1,
        syncIsDirty: true,
      ),
    );

    // 5. Persist
    return _repository.update(updated);
  }
}
