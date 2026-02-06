// lib/domain/usecases/photo_entries/get_photo_entries_by_area_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/repositories/photo_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_entries/photo_entry_inputs.dart';

/// Use case to get photo entries for a specific area.
class GetPhotoEntriesByAreaUseCase
    implements UseCase<GetPhotoEntriesByAreaInput, List<PhotoEntry>> {
  final PhotoEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetPhotoEntriesByAreaUseCase(this._repository, this._authService);

  @override
  Future<Result<List<PhotoEntry>, AppError>> call(
    GetPhotoEntriesByAreaInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch from repository
    return _repository.getByArea(
      input.photoAreaId,
      startDate: input.startDate,
      endDate: input.endDate,
      limit: input.limit,
      offset: input.offset,
    );
  }
}
