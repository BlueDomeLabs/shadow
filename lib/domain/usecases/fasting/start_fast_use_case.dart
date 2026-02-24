// lib/domain/usecases/fasting/start_fast_use_case.dart
// Phase 15b-2 — Start an intermittent fasting session
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/fasting_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/fasting/fasting_types.dart';
import 'package:uuid/uuid.dart';

/// Use case: start a new fasting session.
///
/// Fails if there is already an active fast for the profile.
/// The user must end the current fast before starting a new one.
class StartFastUseCase implements UseCase<StartFastInput, FastingSession> {
  final FastingRepository _repository;
  final ProfileAuthorizationService _authService;
  final Uuid _uuid;

  StartFastUseCase(
    this._repository,
    this._authService, [
    Uuid uuid = const Uuid(),
  ]) : _uuid = uuid;

  @override
  Future<Result<FastingSession, AppError>> call(StartFastInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Ensure no active fast already exists
    final activeResult = await _repository.getActiveFast(input.profileId);
    if (activeResult.isFailure) return Failure(activeResult.errorOrNull!);

    if (activeResult.valueOrNull != null) {
      return Failure(
        BusinessError.invalidState('FastingSession', 'active', 'none'),
      );
    }

    // 3. Create the fasting session
    final now = DateTime.now().millisecondsSinceEpoch;
    final session = FastingSession(
      id: _uuid.v4(),
      clientId: input.clientId,
      profileId: input.profileId,
      protocol: input.protocol,
      startedAt: input.startedAt,
      targetHours: input.targetHours,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Populated by repository
      ),
    );

    return _repository.create(session);
  }
}
