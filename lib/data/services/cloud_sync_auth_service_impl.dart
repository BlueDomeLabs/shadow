// lib/data/services/cloud_sync_auth_service_impl.dart
// Concrete implementation of CloudSyncAuthService.
//
// Holds GoogleDriveProvider, ICloudProvider, and FlutterSecureStorage.
// Extracted from CloudSyncAuthNotifier (AUDIT-01-004, 01-005, 01-007).

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/cloud/google_drive_provider.dart';
import 'package:shadow_app/data/cloud/icloud_provider.dart';
import 'package:shadow_app/domain/services/cloud_sync_auth_service.dart';
import 'package:shadow_app/domain/services/cloud_sync_auth_state.dart';
import 'package:shadow_app/domain/sync/cloud_storage_provider.dart';

/// Key used to persist the selected CloudProviderType in secure storage.
const _providerTypeKey = 'cloud_provider_type';

/// Concrete implementation of [CloudSyncAuthService].
class CloudSyncAuthServiceImpl implements CloudSyncAuthService {
  final GoogleDriveProvider _googleProvider;
  final ICloudProvider _iCloudProvider;
  final FlutterSecureStorage _storage;

  CloudSyncAuthServiceImpl(
    this._googleProvider,
    this._iCloudProvider,
    this._storage,
  );

  @override
  Future<CloudSyncAuthState?> checkExistingSession() async {
    try {
      final storedTypeRaw = await _storage.read(key: _providerTypeKey);
      final storedType = storedTypeRaw != null
          ? CloudProviderType.fromValue(int.tryParse(storedTypeRaw) ?? 0)
          : CloudProviderType.googleDrive;

      if (storedType == CloudProviderType.icloud) {
        final authenticated = await _iCloudProvider.isAuthenticated();
        if (authenticated) {
          return const CloudSyncAuthState(
            isAuthenticated: true,
            activeProvider: CloudProviderType.icloud,
          );
        }
      } else {
        final authenticated = await _googleProvider.isAuthenticated();
        if (authenticated) {
          return CloudSyncAuthState(
            isAuthenticated: true,
            userEmail: _googleProvider.userEmail,
            activeProvider: CloudProviderType.googleDrive,
          );
        }
      }
    } on Exception {
      // Non-fatal: user can still sign in manually
    }
    return null;
  }

  @override
  Future<Result<CloudSyncAuthState, AppError>> signInWithGoogle() async {
    final result = await _googleProvider.authenticate();
    return result.when(
      success: (_) => Success(
        CloudSyncAuthState(
          isAuthenticated: true,
          userEmail: _googleProvider.userEmail,
          activeProvider: CloudProviderType.googleDrive,
        ),
      ),
      failure: Failure.new,
    );
  }

  @override
  Future<Result<CloudSyncAuthState, AppError>> signInWithICloud() async {
    final result = await _iCloudProvider.authenticate();
    return result.when(
      success: (_) => const Success(
        CloudSyncAuthState(
          isAuthenticated: true,
          activeProvider: CloudProviderType.icloud,
        ),
      ),
      failure: Failure.new,
    );
  }

  @override
  Future<Result<CloudSyncAuthState, AppError>> switchProvider(
    CloudProviderType type,
    CloudProviderType? currentProvider,
  ) async {
    // Sign out of current provider (non-fatal if it fails)
    try {
      if (currentProvider == CloudProviderType.icloud) {
        await _iCloudProvider.signOut();
      } else if (currentProvider == CloudProviderType.googleDrive) {
        await _googleProvider.signOut();
      }
    } on Exception {
      // Non-fatal: still attempt to authenticate with new provider
    }

    // Authenticate with new provider
    final newProvider = type == CloudProviderType.icloud
        ? _iCloudProvider as CloudStorageProvider
        : _googleProvider;
    final result = await newProvider.authenticate();

    return result.when(
      success: (_) async {
        await _storage.write(
          key: _providerTypeKey,
          value: type.value.toString(),
        );
        return Success(
          CloudSyncAuthState(
            isAuthenticated: true,
            userEmail: type == CloudProviderType.googleDrive
                ? _googleProvider.userEmail
                : null,
            activeProvider: type,
          ),
        );
      },
      failure: (e) async => Failure(e),
    );
  }

  @override
  Future<Result<void, AppError>> signOut(
    CloudProviderType? activeProvider,
  ) async {
    final provider = activeProvider == CloudProviderType.icloud
        ? _iCloudProvider as CloudStorageProvider
        : _googleProvider;
    return provider.signOut();
  }
}
