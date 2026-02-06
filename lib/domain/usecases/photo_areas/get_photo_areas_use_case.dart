// lib/domain/usecases/photo_areas/get_photo_areas_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/repositories/photo_area_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_areas/photo_area_inputs.dart';

/// Use case to get photo areas for a profile.
class GetPhotoAreasUseCase
    implements UseCase<GetPhotoAreasInput, List<PhotoArea>> {
  final PhotoAreaRepository _repository;
  final ProfileAuthorizationService _authService;

  GetPhotoAreasUseCase(this._repository, this._authService);

  @override
  Future<Result<List<PhotoArea>, AppError>> call(
    GetPhotoAreasInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch from repository
    return _repository.getByProfile(
      input.profileId,
      includeArchived: input.includeArchived,
    );
  }
}
