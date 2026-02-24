// lib/domain/usecases/health/get_imported_vitals_use_case.dart
// Phase 16 — Retrieve imported vitals for a profile
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/imported_vital.dart';
import 'package:shadow_app/domain/repositories/imported_vital_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/health/health_types.dart';

/// Returns imported health platform vitals for a profile.
///
/// Optionally filtered by date range and/or data type.
/// Results are ordered by recordedAt descending (newest first).
class GetImportedVitalsUseCase
    implements UseCase<GetImportedVitalsInput, List<ImportedVital>> {
  final ImportedVitalRepository _repository;
  final ProfileAuthorizationService _authService;

  GetImportedVitalsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<ImportedVital>, AppError>> call(
    GetImportedVitalsInput input,
  ) async {
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    return _repository.getByProfile(
      profileId: input.profileId,
      startEpoch: input.startEpoch,
      endEpoch: input.endEpoch,
      dataType: input.dataType,
    );
  }
}
