// lib/domain/usecases/supplements/archive_supplement_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.5

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/repositories/supplement_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/supplements/supplement_inputs.dart';

/// Use case to archive or unarchive a supplement.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Fetch existing - Get current entity
/// 3. Verify ownership - Ensure entity belongs to profile
/// 4. Update archive status
/// 5. Repository Call - Execute operation
class ArchiveSupplementUseCase
    implements UseCase<ArchiveSupplementInput, Supplement> {
  final SupplementRepository _repository;
  final ProfileAuthorizationService _authService;

  ArchiveSupplementUseCase(this._repository, this._authService);

  @override
  Future<Result<Supplement, AppError>> call(
    ArchiveSupplementInput input,
  ) async {
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
