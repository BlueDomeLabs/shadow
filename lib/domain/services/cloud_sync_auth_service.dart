// lib/domain/services/cloud_sync_auth_service.dart
// Domain interface for cloud sync authentication operations.
//
// Extracts auth business logic out of the presentation layer (AUDIT-01-004).
// Concrete implementation lives in data/services/cloud_sync_auth_service_impl.dart.

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/services/cloud_sync_auth_state.dart';
import 'package:shadow_app/domain/sync/cloud_storage_provider.dart';

/// Domain service interface for cloud sync authentication.
abstract class CloudSyncAuthService {
  /// Check for an existing authenticated session on app start.
  ///
  /// Reads the stored provider preference and checks the appropriate provider.
  /// Returns the restored state, or null if no session found.
  Future<CloudSyncAuthState?> checkExistingSession();

  /// Sign in with Google Drive.
  Future<Result<CloudSyncAuthState, AppError>> signInWithGoogle();

  /// Sign in with iCloud.
  Future<Result<CloudSyncAuthState, AppError>> signInWithICloud();

  /// Switch from the current provider to a new one.
  ///
  /// Signs out of [currentProvider], authenticates with [type],
  /// and persists the preference for the next app launch.
  Future<Result<CloudSyncAuthState, AppError>> switchProvider(
    CloudProviderType type,
    CloudProviderType? currentProvider,
  );

  /// Sign out from the current cloud provider.
  Future<Result<void, AppError>> signOut(CloudProviderType? activeProvider);
}
