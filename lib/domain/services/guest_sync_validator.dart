/// Guest sync validation — checks token validity before each sync.
///
/// When the app is in guest mode, the sync process calls this
/// to verify the token is still valid before pushing/pulling data.
/// If invalid, sync is blocked and the app shows Access Revoked.
library;

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/services/guest_token_service.dart';

/// Validates guest token before allowing a sync operation.
class GuestSyncValidator {
  final GuestTokenService _tokenService;

  GuestSyncValidator(this._tokenService);

  /// Validate that the guest token is still active.
  ///
  /// Returns Success(true) if valid and sync should proceed.
  /// Returns Success(false) with rejection info if invalid.
  /// Returns Failure on system error.
  Future<Result<TokenValidationResult, AppError>> validateBeforeSync({
    required String token,
    required String deviceId,
  }) => _tokenService.validateOnly(token: token, deviceId: deviceId);
}
