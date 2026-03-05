// test/unit/presentation/providers/cloud_sync/cloud_sync_auth_provider_test.dart
// Tests for CloudSyncAuthNotifier state transitions.
//
// After the AUDIT-01-004/01-005/01-007 refactor, CloudSyncAuthNotifier
// delegates all logic to CloudSyncAuthService. These tests verify that
// the notifier correctly handles Success/Failure from the service and
// updates state accordingly.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/services/cloud_sync_auth_service.dart';
import 'package:shadow_app/domain/services/cloud_sync_auth_state.dart';
import 'package:shadow_app/domain/sync/cloud_storage_provider.dart'
    show CloudProviderType;
import 'package:shadow_app/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart';

@GenerateMocks([CloudSyncAuthService])
import 'cloud_sync_auth_provider_test.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Result<CloudSyncAuthState, AppError>>(
      const Success(CloudSyncAuthState()),
    );
    provideDummy<Result<void, AppError>>(const Success(null));
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
    late MockCloudSyncAuthService mockService;
    late CloudSyncAuthNotifier notifier;

    setUp(() {
      mockService = MockCloudSyncAuthService();
      // Default: no existing session
      when(mockService.checkExistingSession()).thenAnswer((_) async => null);
      notifier = CloudSyncAuthNotifier(mockService);
    });

    test('initial state is not authenticated and not loading', () {
      expect(notifier.state.isLoading, false);
      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.userEmail, isNull);
    });

    test('checks existing session on creation', () async {
      await Future<void>.delayed(Duration.zero);
      verify(mockService.checkExistingSession()).called(1);
    });

    test('restores existing session if service returns state', () async {
      const restoredState = CloudSyncAuthState(
        isAuthenticated: true,
        userEmail: 'restored@gmail.com',
        activeProvider: CloudProviderType.googleDrive,
      );
      when(
        mockService.checkExistingSession(),
      ).thenAnswer((_) async => restoredState);

      final restoreNotifier = CloudSyncAuthNotifier(mockService);
      await Future<void>.delayed(Duration.zero);

      expect(restoreNotifier.state.isAuthenticated, true);
      expect(restoreNotifier.state.userEmail, 'restored@gmail.com');
      expect(
        restoreNotifier.state.activeProvider,
        CloudProviderType.googleDrive,
      );
    });

    test('handles exception in session check gracefully', () async {
      when(
        mockService.checkExistingSession(),
      ).thenThrow(Exception('Storage error'));

      final errorNotifier = CloudSyncAuthNotifier(mockService);
      await Future<void>.delayed(Duration.zero);

      expect(errorNotifier.state.isAuthenticated, false);
      expect(errorNotifier.state.isLoading, false);
    });

    group('signInWithGoogle', () {
      test('sets loading state while signing in', () async {
        when(mockService.signInWithGoogle()).thenAnswer((_) async {
          expect(notifier.state.isLoading, true);
          return const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.googleDrive,
            ),
          );
        });

        await notifier.signInWithGoogle();
      });

      test('updates to authenticated state on success', () async {
        const successState = CloudSyncAuthState(
          isAuthenticated: true,
          userEmail: 'success@gmail.com',
          activeProvider: CloudProviderType.googleDrive,
        );
        when(
          mockService.signInWithGoogle(),
        ).thenAnswer((_) async => const Success(successState));

        await notifier.signInWithGoogle();

        expect(notifier.state.isAuthenticated, true);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.userEmail, 'success@gmail.com');
        expect(notifier.state.activeProvider, CloudProviderType.googleDrive);
        expect(notifier.state.errorMessage, isNull);
      });

      test('sets error state on failure', () async {
        when(mockService.signInWithGoogle()).thenAnswer(
          (_) async => Failure(AuthError.signInFailed('User cancelled')),
        );

        await notifier.signInWithGoogle();

        expect(notifier.state.isAuthenticated, false);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.errorMessage, isNotNull);
      });

      test('clears previous error when starting sign-in', () async {
        when(mockService.signInWithGoogle()).thenAnswer(
          (_) async => Failure(AuthError.signInFailed('First error')),
        );
        await notifier.signInWithGoogle();
        expect(notifier.state.errorMessage, isNotNull);

        when(mockService.signInWithGoogle()).thenAnswer((_) async {
          expect(notifier.state.errorMessage, isNull);
          return const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.googleDrive,
            ),
          );
        });

        await notifier.signInWithGoogle();
      });

      test('ignores concurrent sign-in attempts', () async {
        var callCount = 0;
        when(mockService.signInWithGoogle()).thenAnswer((_) async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.googleDrive,
            ),
          );
        });

        final future1 = notifier.signInWithGoogle();
        final future2 = notifier.signInWithGoogle();
        await Future.wait([future1, future2]);

        expect(callCount, 1);
      });
    });

    group('signInWithICloud', () {
      test(
        'updates to authenticated state with icloud provider on success',
        () async {
          const successState = CloudSyncAuthState(
            isAuthenticated: true,
            activeProvider: CloudProviderType.icloud,
          );
          when(
            mockService.signInWithICloud(),
          ).thenAnswer((_) async => const Success(successState));

          await notifier.signInWithICloud();

          expect(notifier.state.isAuthenticated, true);
          expect(notifier.state.isLoading, false);
          expect(notifier.state.activeProvider, CloudProviderType.icloud);
          expect(notifier.state.userEmail, isNull);
          expect(notifier.state.errorMessage, isNull);
        },
      );

      test('sets error state on failure', () async {
        when(mockService.signInWithICloud()).thenAnswer(
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
        when(mockService.signInWithICloud()).thenAnswer((_) async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.icloud,
            ),
          );
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
        when(mockService.signInWithGoogle()).thenAnswer(
          (_) async => const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              userEmail: 'user@gmail.com',
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        await notifier.signInWithGoogle();
        expect(notifier.state.activeProvider, CloudProviderType.googleDrive);

        // Switch to iCloud
        const switchedState = CloudSyncAuthState(
          isAuthenticated: true,
          activeProvider: CloudProviderType.icloud,
        );
        when(
          mockService.switchProvider(
            CloudProviderType.icloud,
            CloudProviderType.googleDrive,
          ),
        ).thenAnswer((_) async => const Success(switchedState));

        await notifier.switchProvider(CloudProviderType.icloud);

        expect(notifier.state.isAuthenticated, true);
        expect(notifier.state.activeProvider, CloudProviderType.icloud);
        expect(notifier.state.userEmail, isNull);
        expect(notifier.state.isLoading, false);
      });

      test('sets error state if new provider authentication fails', () async {
        when(
          mockService.switchProvider(CloudProviderType.icloud, any),
        ).thenAnswer(
          (_) async => Failure(AuthError.signInFailed('iCloud not available')),
        );

        await notifier.switchProvider(CloudProviderType.icloud);

        expect(notifier.state.isAuthenticated, false);
        expect(notifier.state.errorMessage, isNotNull);
        expect(notifier.state.isLoading, false);
      });

      test('passes currentProvider from state to service', () async {
        // Set authenticated state with Google
        when(mockService.signInWithGoogle()).thenAnswer(
          (_) async => const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        await notifier.signInWithGoogle();

        when(
          mockService.switchProvider(
            CloudProviderType.icloud,
            CloudProviderType.googleDrive,
          ),
        ).thenAnswer(
          (_) async => const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.icloud,
            ),
          ),
        );

        await notifier.switchProvider(CloudProviderType.icloud);

        verify(
          mockService.switchProvider(
            CloudProviderType.icloud,
            CloudProviderType.googleDrive,
          ),
        ).called(1);
      });
    });

    group('signOut', () {
      test('resets state to default on success', () async {
        when(mockService.signInWithGoogle()).thenAnswer(
          (_) async => const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              userEmail: 'user@gmail.com',
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        await notifier.signInWithGoogle();
        expect(notifier.state.isAuthenticated, true);

        when(
          mockService.signOut(CloudProviderType.googleDrive),
        ).thenAnswer((_) async => const Success(null));
        await notifier.signOut();

        expect(notifier.state.isAuthenticated, false);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.userEmail, isNull);
        expect(notifier.state.activeProvider, isNull);
        expect(notifier.state.errorMessage, isNull);
      });

      test('sets error state on failure', () async {
        when(mockService.signInWithGoogle()).thenAnswer(
          (_) async => const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              userEmail: 'user@gmail.com',
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        await notifier.signInWithGoogle();

        when(
          mockService.signOut(CloudProviderType.googleDrive),
        ).thenAnswer((_) async => Failure(AuthError.signOutFailed()));
        await notifier.signOut();

        expect(notifier.state.isLoading, false);
        expect(notifier.state.errorMessage, isNotNull);
      });

      test('ignores concurrent sign-out attempts', () async {
        when(mockService.signInWithGoogle()).thenAnswer(
          (_) async => const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              userEmail: 'user@gmail.com',
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        await notifier.signInWithGoogle();

        var callCount = 0;
        when(mockService.signOut(any)).thenAnswer((_) async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return const Success(null);
        });

        final future1 = notifier.signOut();
        final future2 = notifier.signOut();
        await Future.wait([future1, future2]);

        expect(callCount, 1);
      });

      test('passes activeProvider from state to service', () async {
        when(mockService.signInWithICloud()).thenAnswer(
          (_) async => const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.icloud,
            ),
          ),
        );
        await notifier.signInWithICloud();

        when(
          mockService.signOut(CloudProviderType.icloud),
        ).thenAnswer((_) async => const Success(null));

        await notifier.signOut();

        verify(mockService.signOut(CloudProviderType.icloud)).called(1);
      });
    });

    group('clearError', () {
      test('clears error message from state', () async {
        when(mockService.signInWithGoogle()).thenAnswer(
          (_) async => Failure(AuthError.signInFailed('Test error')),
        );
        await notifier.signInWithGoogle();
        expect(notifier.state.errorMessage, isNotNull);

        notifier.clearError();
        expect(notifier.state.errorMessage, isNull);
      });

      test('preserves other state when clearing error', () async {
        when(mockService.signInWithGoogle()).thenAnswer(
          (_) async => const Success(
            CloudSyncAuthState(
              isAuthenticated: true,
              userEmail: 'user@gmail.com',
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        await notifier.signInWithGoogle();

        notifier.clearError();
        expect(notifier.state.isAuthenticated, true);
        expect(notifier.state.userEmail, 'user@gmail.com');
      });
    });
  });
}
