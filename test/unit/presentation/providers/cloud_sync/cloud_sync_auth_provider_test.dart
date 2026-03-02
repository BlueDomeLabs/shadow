// test/unit/presentation/providers/cloud_sync/cloud_sync_auth_provider_test.dart
// Tests for CloudSyncAuthProvider and CloudSyncAuthState.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/cloud/google_drive_provider.dart';
import 'package:shadow_app/data/cloud/icloud_provider.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart'
    show CloudProviderType, SyncChange;
import 'package:shadow_app/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart';

@GenerateMocks([GoogleDriveProvider, ICloudProvider, FlutterSecureStorage])
import 'cloud_sync_auth_provider_test.mocks.dart';

void main() {
  // Required: FlutterSecureStorage uses platform channels which need the binding
  TestWidgetsFlutterBinding.ensureInitialized();

  // Register dummy values for sealed Result types so Mockito can handle them
  setUpAll(() {
    provideDummy<Result<void, AppError>>(const Success(null));
    provideDummy<Result<Map<String, dynamic>?, AppError>>(const Success(null));
    provideDummy<Result<List<SyncChange>, AppError>>(const Success([]));
    provideDummy<Result<String, AppError>>(const Success(''));
  });

  group('CloudSyncAuthState', () {
    test('default state is not loading and not authenticated', () {
      const state = CloudSyncAuthState();
      expect(state.isLoading, false);
      expect(state.isAuthenticated, false);
      expect(state.userEmail, isNull);
      expect(state.activeProvider, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith preserves existing values', () {
      const state = CloudSyncAuthState(
        isLoading: true,
        isAuthenticated: true,
        userEmail: 'test@example.com',
        activeProvider: CloudProviderType.googleDrive,
        errorMessage: 'Some error',
      );

      final copied = state.copyWith();
      expect(copied.isLoading, true);
      expect(copied.isAuthenticated, true);
      expect(copied.userEmail, 'test@example.com');
      expect(copied.activeProvider, CloudProviderType.googleDrive);
      expect(copied.errorMessage, 'Some error');
    });

    test('copyWith replaces specified values', () {
      const state = CloudSyncAuthState(isLoading: true);

      final updated = state.copyWith(isLoading: false, isAuthenticated: true);
      expect(updated.isLoading, false);
      expect(updated.isAuthenticated, true);
    });

    test('copyWith clearUserEmail sets email to null', () {
      const state = CloudSyncAuthState(userEmail: 'test@example.com');
      final cleared = state.copyWith(clearUserEmail: true);
      expect(cleared.userEmail, isNull);
    });

    test('copyWith clearActiveProvider sets provider to null', () {
      const state = CloudSyncAuthState(
        activeProvider: CloudProviderType.googleDrive,
      );
      final cleared = state.copyWith(clearActiveProvider: true);
      expect(cleared.activeProvider, isNull);
    });

    test('copyWith clearErrorMessage sets error to null', () {
      const state = CloudSyncAuthState(errorMessage: 'Error');
      final cleared = state.copyWith(clearErrorMessage: true);
      expect(cleared.errorMessage, isNull);
    });

    test('copyWith new value overrides clear flag', () {
      const state = CloudSyncAuthState(userEmail: 'old@example.com');
      final updated = state.copyWith(userEmail: 'new@example.com');
      expect(updated.userEmail, 'new@example.com');
    });

    test('all fields settable via constructor', () {
      const state = CloudSyncAuthState(
        isLoading: true,
        isAuthenticated: true,
        userEmail: 'user@gmail.com',
        activeProvider: CloudProviderType.googleDrive,
        errorMessage: 'test error',
      );
      expect(state.isLoading, true);
      expect(state.isAuthenticated, true);
      expect(state.userEmail, 'user@gmail.com');
      expect(state.activeProvider, CloudProviderType.googleDrive);
      expect(state.errorMessage, 'test error');
    });
  });

  group('CloudSyncAuthNotifier', () {
    late MockGoogleDriveProvider mockProvider;
    late MockFlutterSecureStorage mockStorageForLegacy;
    late CloudSyncAuthNotifier notifier;

    setUp(() {
      mockProvider = MockGoogleDriveProvider();
      mockStorageForLegacy = MockFlutterSecureStorage();
      // Default: no existing session
      when(mockProvider.isAuthenticated()).thenAnswer((_) async => false);
      when(mockProvider.userEmail).thenReturn(null);
      // No stored preference → defaults to Google Drive session check
      when(
        mockStorageForLegacy.read(key: anyNamed('key')),
      ).thenAnswer((_) async => null);
      notifier = CloudSyncAuthNotifier(
        mockProvider,
        storage: mockStorageForLegacy,
      );
    });

    test('initial state is not authenticated and not loading', () {
      expect(notifier.state.isLoading, false);
      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.userEmail, isNull);
    });

    test('checks existing session on creation', () async {
      // Give time for async _checkExistingSession to complete
      await Future<void>.delayed(Duration.zero);
      verify(mockProvider.isAuthenticated()).called(1);
    });

    test('restores existing session if authenticated', () async {
      when(mockProvider.isAuthenticated()).thenAnswer((_) async => true);
      when(mockProvider.userEmail).thenReturn('restored@gmail.com');
      when(
        mockStorageForLegacy.read(key: anyNamed('key')),
      ).thenAnswer((_) async => null);

      final restoreNotifier = CloudSyncAuthNotifier(
        mockProvider,
        storage: mockStorageForLegacy,
      );
      // Wait for async init
      await Future<void>.delayed(Duration.zero);

      expect(restoreNotifier.state.isAuthenticated, true);
      expect(restoreNotifier.state.userEmail, 'restored@gmail.com');
      expect(
        restoreNotifier.state.activeProvider,
        CloudProviderType.googleDrive,
      );
    });

    group('signInWithGoogle', () {
      test('sets loading state while signing in', () async {
        when(mockProvider.authenticate()).thenAnswer((_) async {
          // Verify loading state during operation
          expect(notifier.state.isLoading, true);
          return const Success(null);
        });
        when(mockProvider.userEmail).thenReturn('new@gmail.com');

        await notifier.signInWithGoogle();
      });

      test('updates to authenticated state on success', () async {
        when(
          mockProvider.authenticate(),
        ).thenAnswer((_) async => const Success(null));
        when(mockProvider.userEmail).thenReturn('success@gmail.com');

        await notifier.signInWithGoogle();

        expect(notifier.state.isAuthenticated, true);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.userEmail, 'success@gmail.com');
        expect(notifier.state.activeProvider, CloudProviderType.googleDrive);
        expect(notifier.state.errorMessage, isNull);
      });

      test('sets error state on failure', () async {
        when(mockProvider.authenticate()).thenAnswer(
          (_) async => Failure(AuthError.signInFailed('User cancelled')),
        );

        await notifier.signInWithGoogle();

        expect(notifier.state.isAuthenticated, false);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.errorMessage, isNotNull);
        expect(notifier.state.userEmail, isNull);
        expect(notifier.state.activeProvider, isNull);
      });

      test('clears previous error when starting sign-in', () async {
        // Set up an error state first
        when(mockProvider.authenticate()).thenAnswer(
          (_) async => Failure(AuthError.signInFailed('First error')),
        );
        await notifier.signInWithGoogle();
        expect(notifier.state.errorMessage, isNotNull);

        // Now try again - error should clear during sign-in
        when(mockProvider.authenticate()).thenAnswer((_) async {
          expect(notifier.state.errorMessage, isNull);
          return const Success(null);
        });
        when(mockProvider.userEmail).thenReturn('user@gmail.com');

        await notifier.signInWithGoogle();
      });

      test('ignores concurrent sign-in attempts', () async {
        var callCount = 0;
        when(mockProvider.authenticate()).thenAnswer((_) async {
          callCount++;
          // Simulate slow operation
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return const Success(null);
        });
        when(mockProvider.userEmail).thenReturn('user@gmail.com');

        // Start first sign-in
        final future1 = notifier.signInWithGoogle();
        // Try concurrent sign-in (should be ignored since isLoading)
        final future2 = notifier.signInWithGoogle();
        await Future.wait([future1, future2]);

        expect(callCount, 1);
      });
    });

    group('signOut', () {
      test('resets state to default on success', () async {
        // First sign in
        when(
          mockProvider.authenticate(),
        ).thenAnswer((_) async => const Success(null));
        when(mockProvider.userEmail).thenReturn('user@gmail.com');
        await notifier.signInWithGoogle();
        expect(notifier.state.isAuthenticated, true);

        // Sign out
        when(
          mockProvider.signOut(),
        ).thenAnswer((_) async => const Success(null));
        await notifier.signOut();

        expect(notifier.state.isAuthenticated, false);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.userEmail, isNull);
        expect(notifier.state.activeProvider, isNull);
        expect(notifier.state.errorMessage, isNull);
      });

      test('sets error state on failure', () async {
        // First sign in
        when(
          mockProvider.authenticate(),
        ).thenAnswer((_) async => const Success(null));
        when(mockProvider.userEmail).thenReturn('user@gmail.com');
        await notifier.signInWithGoogle();

        // Sign out fails
        when(
          mockProvider.signOut(),
        ).thenAnswer((_) async => Failure(AuthError.signOutFailed()));
        await notifier.signOut();

        expect(notifier.state.isLoading, false);
        expect(notifier.state.errorMessage, isNotNull);
      });

      test('ignores concurrent sign-out attempts', () async {
        when(
          mockProvider.authenticate(),
        ).thenAnswer((_) async => const Success(null));
        when(mockProvider.userEmail).thenReturn('user@gmail.com');
        await notifier.signInWithGoogle();

        var callCount = 0;
        when(mockProvider.signOut()).thenAnswer((_) async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return const Success(null);
        });

        final future1 = notifier.signOut();
        final future2 = notifier.signOut();
        await Future.wait([future1, future2]);

        expect(callCount, 1);
      });
    });

    group('clearError', () {
      test('clears error message from state', () async {
        when(mockProvider.authenticate()).thenAnswer(
          (_) async => Failure(AuthError.signInFailed('Test error')),
        );
        await notifier.signInWithGoogle();
        expect(notifier.state.errorMessage, isNotNull);

        notifier.clearError();
        expect(notifier.state.errorMessage, isNull);
      });

      test('preserves other state when clearing error', () async {
        when(
          mockProvider.authenticate(),
        ).thenAnswer((_) async => const Success(null));
        when(mockProvider.userEmail).thenReturn('user@gmail.com');
        await notifier.signInWithGoogle();

        // Manually set error
        notifier.clearError();
        expect(notifier.state.isAuthenticated, true);
        expect(notifier.state.userEmail, 'user@gmail.com');
      });
    });

    test('handles exception in session check gracefully', () async {
      when(
        mockProvider.isAuthenticated(),
      ).thenThrow(Exception('Storage error'));
      when(
        mockStorageForLegacy.read(key: anyNamed('key')),
      ).thenAnswer((_) async => null);

      final errorNotifier = CloudSyncAuthNotifier(
        mockProvider,
        storage: mockStorageForLegacy,
      );
      // Should not throw - wait for async init
      await Future<void>.delayed(Duration.zero);

      expect(errorNotifier.state.isAuthenticated, false);
      expect(errorNotifier.state.isLoading, false);
    });
  });

  // ---------------------------------------------------------------------------
  // Phase 31b: iCloud support
  // ---------------------------------------------------------------------------

  group('iCloud support', () {
    late MockGoogleDriveProvider mockGoogleProvider;
    late MockICloudProvider mockICloudProvider;
    late MockFlutterSecureStorage mockStorage;
    late CloudSyncAuthNotifier notifier;

    setUp(() {
      mockGoogleProvider = MockGoogleDriveProvider();
      mockICloudProvider = MockICloudProvider();
      mockStorage = MockFlutterSecureStorage();
      // Default: no existing session, no stored preference
      when(mockGoogleProvider.isAuthenticated()).thenAnswer((_) async => false);
      when(mockGoogleProvider.userEmail).thenReturn(null);
      when(
        mockStorage.read(key: anyNamed('key')),
      ).thenAnswer((_) async => null);
      notifier = CloudSyncAuthNotifier(
        mockGoogleProvider,
        iCloudProvider: mockICloudProvider,
        storage: mockStorage,
      );
    });

    group('signInWithICloud', () {
      test(
        'updates to authenticated state with icloud provider on success',
        () async {
          when(
            mockICloudProvider.authenticate(),
          ).thenAnswer((_) async => const Success(null));

          await notifier.signInWithICloud();

          expect(notifier.state.isAuthenticated, true);
          expect(notifier.state.isLoading, false);
          expect(notifier.state.activeProvider, CloudProviderType.icloud);
          expect(notifier.state.userEmail, isNull); // iCloud has no email
          expect(notifier.state.errorMessage, isNull);
        },
      );

      test('sets error state on failure', () async {
        when(mockICloudProvider.authenticate()).thenAnswer(
          (_) async => Failure(AuthError.signInFailed('iCloud not available')),
        );

        await notifier.signInWithICloud();

        expect(notifier.state.isAuthenticated, false);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.activeProvider, isNull);
        expect(notifier.state.errorMessage, isNotNull);
      });

      test('ignores concurrent sign-in attempts', () async {
        var callCount = 0;
        when(mockICloudProvider.authenticate()).thenAnswer((_) async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return const Success(null);
        });

        final future1 = notifier.signInWithICloud();
        final future2 = notifier.signInWithICloud();
        await Future.wait([future1, future2]);

        expect(callCount, 1);
      });
    });

    group('switchProvider', () {
      test('authenticates new provider and updates state on success', () async {
        // Start: authenticated with Google Drive
        when(
          mockGoogleProvider.authenticate(),
        ).thenAnswer((_) async => const Success(null));
        when(mockGoogleProvider.userEmail).thenReturn('user@gmail.com');
        await notifier.signInWithGoogle();
        expect(notifier.state.activeProvider, CloudProviderType.googleDrive);

        // Switch to iCloud
        when(
          mockGoogleProvider.signOut(),
        ).thenAnswer((_) async => const Success(null));
        when(
          mockICloudProvider.authenticate(),
        ).thenAnswer((_) async => const Success(null));
        when(
          mockStorage.write(key: anyNamed('key'), value: anyNamed('value')),
        ).thenAnswer((_) async {});

        await notifier.switchProvider(CloudProviderType.icloud);

        expect(notifier.state.isAuthenticated, true);
        expect(notifier.state.activeProvider, CloudProviderType.icloud);
        expect(notifier.state.userEmail, isNull);
        expect(notifier.state.isLoading, false);
      });

      test('sets error state if new provider authentication fails', () async {
        when(mockICloudProvider.authenticate()).thenAnswer(
          (_) async => Failure(AuthError.signInFailed('iCloud not available')),
        );

        await notifier.switchProvider(CloudProviderType.icloud);

        expect(notifier.state.isAuthenticated, false);
        expect(notifier.state.errorMessage, isNotNull);
        expect(notifier.state.isLoading, false);
      });

      test('persists new provider type to storage on success', () async {
        when(
          mockICloudProvider.authenticate(),
        ).thenAnswer((_) async => const Success(null));
        when(
          mockStorage.write(key: anyNamed('key'), value: anyNamed('value')),
        ).thenAnswer((_) async {});

        await notifier.switchProvider(CloudProviderType.icloud);

        verify(
          mockStorage.write(
            key: 'cloud_provider_type',
            value: CloudProviderType.icloud.value.toString(),
          ),
        ).called(1);
      });
    });

    group('signOut dispatches to correct provider', () {
      test('calls iCloud signOut when active provider is iCloud', () async {
        // Sign in with iCloud first
        when(
          mockICloudProvider.authenticate(),
        ).thenAnswer((_) async => const Success(null));
        await notifier.signInWithICloud();

        when(
          mockICloudProvider.signOut(),
        ).thenAnswer((_) async => const Success(null));

        await notifier.signOut();

        verify(mockICloudProvider.signOut()).called(1);
        verifyNever(mockGoogleProvider.signOut());
        expect(notifier.state.isAuthenticated, false);
      });
    });
  });
}
