// lib/domain/usecases/health/get_last_sync_status_use_case.dart
// Phase 16 — Get last sync status per data type for a profile
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart';
import 'package:shadow_app/domain/repositories/health_sync_status_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/health/health_types.dart';

/// Returns the last sync status for each health data type for a profile.
///
/// Used by the Settings screen to show "Last synced" timestamps and record
/// counts, and to drive incremental sync logic.
class GetLastSyncStatusUseCase
    implements UseCase<GetLastSyncStatusInput, List<HealthSyncStatus>> {
  final HealthSyncStatusRepository _repository;
  final ProfileAuthorizationService _authService;

  GetLastSyncStatusUseCase(this._repository, this._authService);

  @override
  Future<Result<List<HealthSyncStatus>, AppError>> call(
    GetLastSyncStatusInput input,
  ) async {
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    return _repository.getByProfile(input.profileId);
  }
}
