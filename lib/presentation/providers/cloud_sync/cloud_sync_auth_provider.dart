// lib/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart
// Cloud sync authentication state management.
//
// CloudSyncAuthNotifier is a thin state-holder that delegates all
// business logic to CloudSyncAuthService (AUDIT-01-004, 01-005, 01-007).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/services/cloud_sync_auth_service.dart';
import 'package:shadow_app/domain/sync/cloud_storage_provider.dart';
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
/// Delegates all business logic to [CloudSyncAuthService].
/// The setup screen and other consumers are unchanged — only the
/// internal wiring has moved to the service layer.
///
/// NOTE: Switching providers (via [switchProvider]) requires an app restart
/// for the active sync provider to change. The auth state updates immediately
/// to reflect the new selection, but the SyncService continues using the
/// provider that was wired at bootstrap until restart.
class CloudSyncAuthNotifier extends StateNotifier<CloudSyncAuthState> {
  final CloudSyncAuthService _authService;
  final ScopedLogger _log;

  CloudSyncAuthNotifier(this._authService)
    : _log = logger.scope('CloudSyncAuth'),
      super(const CloudSyncAuthState()) {
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    try {
      final restored = await _authService.checkExistingSession();
      if (restored != null) state = restored;
    } on Exception catch (e, stack) {
      _log.error('Failed to check existing session', e, stack);
    }
  }

  /// Sign in with Google Drive.
  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    _log.info('Starting Google sign-in...');
    final result = await _authService.signInWithGoogle();
    result.when(
      success: (s) {
        state = s;
        _log.info('Google sign-in successful');
      },
      failure: (e) {
        state = state.copyWith(isLoading: false, errorMessage: e.userMessage);
        _log.error('Google sign-in failed: ${e.message}');
      },
    );
  }

  /// Sign in with iCloud.
  Future<void> signInWithICloud() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    _log.info('Checking iCloud availability...');
    final result = await _authService.signInWithICloud();
    result.when(
      success: (s) {
        state = s;
        _log.info('iCloud sign-in successful');
      },
      failure: (e) {
        state = state.copyWith(isLoading: false, errorMessage: e.userMessage);
        _log.error('iCloud sign-in failed: ${e.message}');
      },
    );
  }

  /// Switch from the current provider to [type].
  Future<void> switchProvider(CloudProviderType type) async {
    if (state.isLoading) return;
    final currentProvider = state.activeProvider;
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    _log.info('Switching to $type...');
    final result = await _authService.switchProvider(type, currentProvider);
    result.when(
      success: (s) {
        state = s;
        _log.info('Switched to $type successfully');
      },
      failure: (e) {
        state = state.copyWith(isLoading: false, errorMessage: e.userMessage);
        _log.error('Switch to $type failed: ${e.message}');
      },
    );
  }

  /// Sign out from the current cloud provider.
  Future<void> signOut() async {
    if (state.isLoading) return;
    final activeProvider = state.activeProvider;
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    _log.info('Signing out...');
    final result = await _authService.signOut(activeProvider);
    result.when(
      success: (_) {
        state = const CloudSyncAuthState();
        _log.info('Signed out successfully');
      },
      failure: (e) {
        state = state.copyWith(isLoading: false, errorMessage: e.userMessage);
        _log.error('Sign-out failed: ${e.message}');
      },
    );
  }

  /// Clear any error message displayed to the user.
  void clearError() => state = state.copyWith(clearErrorMessage: true);
}

/// Provider for cloud sync authentication state.
final cloudSyncAuthProvider =
    StateNotifierProvider<CloudSyncAuthNotifier, CloudSyncAuthState>(
      (ref) => CloudSyncAuthNotifier(ref.read(cloudSyncAuthServiceProvider)),
    );
