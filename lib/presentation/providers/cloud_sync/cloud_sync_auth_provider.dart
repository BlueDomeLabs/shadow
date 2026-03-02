// lib/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart
// Cloud sync authentication state management.
//
// Wraps GoogleDriveProvider and ICloudProvider for the Cloud Sync Setup screen.
// Uses StateNotifier pattern (like ProfileProvider) since auth
// use cases are not yet implemented. Will be refactored to
// @riverpod + UseCase delegation when auth domain layer is built.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/data/cloud/google_drive_provider.dart';
import 'package:shadow_app/data/cloud/icloud_provider.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

/// Key used to persist the selected CloudProviderType in secure storage.
const _providerTypeKey = 'cloud_provider_type';

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
/// Supports both Google Drive and iCloud as cloud storage providers.
/// Authentication state is persisted via FlutterSecureStorage so the correct
/// provider is selected at next app launch (via bootstrap).
///
/// NOTE: Switching providers (via [switchProvider]) requires an app restart
/// for the active sync provider to change. The auth state updates immediately
/// to reflect the new selection, but the SyncService continues using the
/// provider that was wired at bootstrap until restart.
class CloudSyncAuthNotifier extends StateNotifier<CloudSyncAuthState> {
  final GoogleDriveProvider _googleProvider;
  final ICloudProvider _iCloudProvider;
  final FlutterSecureStorage _storage;
  final ScopedLogger _log;

  CloudSyncAuthNotifier(
    this._googleProvider, {
    ICloudProvider? iCloudProvider,
    FlutterSecureStorage? storage,
  }) : _iCloudProvider = iCloudProvider ?? ICloudProvider(),
       _storage =
           storage ??
           const FlutterSecureStorage(
             mOptions: MacOsOptions(useDataProtectionKeyChain: false),
           ),
       _log = logger.scope('CloudSyncAuth'),
       super(const CloudSyncAuthState()) {
    _checkExistingSession();
  }

  /// Check if there's an existing authenticated session on startup.
  ///
  /// Reads the stored provider type preference and checks the appropriate
  /// provider for an existing authenticated session.
  Future<void> _checkExistingSession() async {
    try {
      final storedTypeRaw = await _storage.read(key: _providerTypeKey);
      final storedType = storedTypeRaw != null
          ? CloudProviderType.fromValue(int.tryParse(storedTypeRaw) ?? 0)
          : CloudProviderType.googleDrive;

      if (storedType == CloudProviderType.icloud) {
        final authenticated = await _iCloudProvider.isAuthenticated();
        if (authenticated) {
          state = state.copyWith(
            isAuthenticated: true,
            activeProvider: CloudProviderType.icloud,
          );
          _log.info('Existing iCloud session found');
        }
      } else {
        final authenticated = await _googleProvider.isAuthenticated();
        if (authenticated) {
          state = state.copyWith(
            isAuthenticated: true,
            userEmail: _googleProvider.userEmail,
            activeProvider: CloudProviderType.googleDrive,
          );
          _log.info('Existing Google Drive session found');
        }
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
    final result = await _googleProvider.authenticate();

    result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userEmail: _googleProvider.userEmail,
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

  /// Sign in with iCloud.
  ///
  /// iCloud authentication is OS-managed — no browser flow required.
  /// User must be signed into iCloud in device Settings.
  Future<void> signInWithICloud() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    _log.info('Checking iCloud availability...');
    final result = await _iCloudProvider.authenticate();

    result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          clearUserEmail: true, // iCloud has no user email in the app
          activeProvider: CloudProviderType.icloud,
        );
        _log.info('iCloud sign-in successful');
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: error.userMessage,
          clearUserEmail: true,
          clearActiveProvider: true,
        );
        _log.error('iCloud sign-in failed: ${error.message}');
      },
    );
  }

  /// Switch from the current provider to [type].
  ///
  /// Signs out of the current provider, authenticates with the new provider,
  /// and persists the preference so the next app launch wires the correct
  /// active sync provider.
  ///
  /// NOTE: The SyncService continues using the provider wired at bootstrap
  /// until the next app restart.
  Future<void> switchProvider(CloudProviderType type) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    _log.info('Switching to $type...');

    // Sign out of current provider
    try {
      if (state.activeProvider == CloudProviderType.icloud) {
        await _iCloudProvider.signOut();
      } else if (state.activeProvider == CloudProviderType.googleDrive) {
        await _googleProvider.signOut();
      }
    } on Exception catch (e, stack) {
      _log.error('Sign-out during switch failed (continuing)', e, stack);
      // Non-fatal: still attempt to authenticate with new provider
    }

    // Authenticate with new provider
    final newProvider = type == CloudProviderType.icloud
        ? _iCloudProvider
        : _googleProvider;
    final result = await newProvider.authenticate();

    await result.when(
      success: (_) async {
        await _storage.write(
          key: _providerTypeKey,
          value: type.value.toString(),
        );
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userEmail: type == CloudProviderType.googleDrive
              ? _googleProvider.userEmail
              : null,
          clearUserEmail: type == CloudProviderType.icloud,
          activeProvider: type,
        );
        _log.info('Switched to $type successfully');
      },
      failure: (error) async {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.userMessage,
        );
        _log.error('Switch to $type failed: ${error.message}');
      },
    );
  }

  /// Sign out from the current cloud provider.
  Future<void> signOut() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    _log.info('Signing out...');

    final provider = state.activeProvider == CloudProviderType.icloud
        ? _iCloudProvider
        : _googleProvider;
    final result = await provider.signOut();

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
      (ref) => CloudSyncAuthNotifier(
        ref.read(googleDriveProviderProvider),
        iCloudProvider: ref.read(iCloudProviderProvider),
      ),
    );
