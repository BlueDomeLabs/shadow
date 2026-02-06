// lib/domain/usecases/photo_areas/archive_photo_area_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/repositories/photo_area_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_areas/photo_area_inputs.dart';

/// Use case to archive (soft delete) a photo area.
class ArchivePhotoAreaUseCase
    implements UseCase<ArchivePhotoAreaInput, PhotoArea> {
  final PhotoAreaRepository _repository;
  final ProfileAuthorizationService _authService;

  ArchivePhotoAreaUseCase(this._repository, this._authService);

  @override
  Future<Result<PhotoArea, AppError>> call(ArchivePhotoAreaInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing entity
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing = existingResult.valueOrNull!;

    // Verify the area belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Apply archive status
    final updated = existing.copyWith(isArchived: input.archive);

    // 4. Persist
    return _repository.update(updated);
  }
}
