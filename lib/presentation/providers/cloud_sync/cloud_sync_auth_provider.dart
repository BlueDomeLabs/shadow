// lib/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart
// Cloud sync authentication state management.
//
// Wraps GoogleDriveProvider for the Cloud Sync Setup screen.
// Uses StateNotifier pattern (like ProfileProvider) since auth
// use cases are not yet implemented. Will be refactored to
// @riverpod + UseCase delegation when auth domain layer is built.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/data/cloud/google_drive_provider.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

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

/// Notifier managing cloud sync authentication state.
///
/// Wraps [GoogleDriveProvider] to provide sign-in/sign-out operations
/// and expose authentication state to the UI.
class CloudSyncAuthNotifier extends StateNotifier<CloudSyncAuthState> {
  final GoogleDriveProvider _provider;
  final ScopedLogger _log;

  CloudSyncAuthNotifier(this._provider)
    : _log = logger.scope('CloudSyncAuth'),
      super(const CloudSyncAuthState()) {
    _checkExistingSession();
  }

  /// Check if there's an existing authenticated session on startup.
  Future<void> _checkExistingSession() async {
    try {
      final authenticated = await _provider.isAuthenticated();
      if (authenticated) {
        state = state.copyWith(
          isAuthenticated: true,
          userEmail: _provider.userEmail,
          activeProvider: CloudProviderType.googleDrive,
        );
        _log.info('Existing session found');
      }
    } on Exception catch (e, stack) {
      _log.error('Failed to check existing session', e, stack);
      // Non-fatal: user can still sign in manually
    }
  }

  /// Sign in with Google Drive.
  ///
  /// Opens the browser for OAuth sign-in (macOS) or shows the
  /// Google Sign-In sheet (iOS). Updates state with result.
  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    _log.info('Starting Google sign-in...');
    final result = await _provider.authenticate();

    result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userEmail: _provider.userEmail,
          activeProvider: CloudProviderType.googleDrive,
        );
        _log.info('Google sign-in successful');
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: error.userMessage,
          clearUserEmail: true,
          clearActiveProvider: true,
        );
        _log.error('Google sign-in failed: ${error.message}');
      },
    );
  }

  /// Sign out from the current cloud provider.
  Future<void> signOut() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    _log.info('Signing out...');
    final result = await _provider.signOut();

    result.when(
      success: (_) {
        state = const CloudSyncAuthState();
        _log.info('Signed out successfully');
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.userMessage,
        );
        _log.error('Sign-out failed: ${error.message}');
      },
    );
  }

  /// Clear any error message displayed to the user.
  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }
}

/// Provider for cloud sync authentication state.
final cloudSyncAuthProvider =
    StateNotifierProvider<CloudSyncAuthNotifier, CloudSyncAuthState>(
      (ref) => CloudSyncAuthNotifier(ref.read(googleDriveProviderProvider)),
    );
