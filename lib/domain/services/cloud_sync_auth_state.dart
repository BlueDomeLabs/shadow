// lib/domain/services/cloud_sync_auth_state.dart
// Domain-layer authentication state for cloud sync.

import 'package:shadow_app/domain/sync/cloud_storage_provider.dart';

/// Authentication state for cloud sync.
class CloudSyncAuthState {
  /// Whether a sign-in or sign-out operation is in progress.
  final bool isLoading;

  /// Whether the user is currently authenticated.
  final bool isAuthenticated;

  /// The authenticated user's email address.
  final String? userEmail;

  /// The active cloud provider type.
  final CloudProviderType? activeProvider;

  /// User-facing error message from the last operation.
  final String? errorMessage;

  const CloudSyncAuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userEmail,
    this.activeProvider,
    this.errorMessage,
  });

  /// Creates a copy with the given fields replaced.
  CloudSyncAuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? userEmail,
    CloudProviderType? activeProvider,
    String? errorMessage,
    bool clearUserEmail = false,
    bool clearActiveProvider = false,
    bool clearErrorMessage = false,
  }) => CloudSyncAuthState(
    isLoading: isLoading ?? this.isLoading,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    userEmail: clearUserEmail ? null : (userEmail ?? this.userEmail),
    activeProvider: clearActiveProvider
        ? null
        : (activeProvider ?? this.activeProvider),
    errorMessage: clearErrorMessage
        ? null
        : (errorMessage ?? this.errorMessage),
  );
}
