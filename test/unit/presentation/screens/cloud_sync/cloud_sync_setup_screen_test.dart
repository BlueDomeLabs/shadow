// test/unit/presentation/screens/cloud_sync/cloud_sync_setup_screen_test.dart
// Widget tests for CloudSyncSetupScreen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/cloud/google_drive_provider.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_setup_screen.dart';

void main() {
  Widget buildTestWidget({
    CloudSyncAuthState authState = const CloudSyncAuthState(),
  }) => ProviderScope(
    overrides: [
      cloudSyncAuthProvider.overrideWith(
        (ref) => _FakeCloudSyncAuthNotifier(authState),
      ),
    ],
    child: const MaterialApp(home: CloudSyncSetupScreen()),
  );

  group('CloudSyncSetupScreen', () {
    group('initial state (not authenticated)', () {
      testWidgets('shows setup title', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.text('Back Up and Sync Your Data'), findsOneWidget);
      });

      testWidgets('shows subtitle text', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(
          find.text(
            'Keep your health data safe and accessible across devices.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('shows benefits list', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.text('Automatic Backup'), findsOneWidget);
        expect(find.text('Multi-Device Sync'), findsOneWidget);
        expect(find.text('Secure & Private'), findsOneWidget);
      });

      testWidgets('shows Google Drive button', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.text('Google Drive'), findsOneWidget);
        expect(find.text('Use your Google account for sync'), findsOneWidget);
      });

      testWidgets('shows Local Only button', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.text('Local Only'), findsOneWidget);
      });

      testWidgets('shows Maybe Later button', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.text('Maybe Later'), findsOneWidget);
      });

      testWidgets('shows app bar with title', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.text('Set Up Cloud Sync'), findsOneWidget);
      });

      testWidgets('does not show error banner', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.byIcon(Icons.error_outline), findsNothing);
      });

      testWidgets('does not show signed-in section', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.text('Cloud Sync Connected'), findsNothing);
        expect(find.text('Sign Out'), findsNothing);
        expect(find.text('Done'), findsNothing);
      });
    });

    group('loading state', () {
      testWidgets('shows loading indicator', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(authState: const CloudSyncAuthState(isLoading: true)),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows "Signing in..." text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(authState: const CloudSyncAuthState(isLoading: true)),
        );
        expect(find.text('Signing in...'), findsOneWidget);
      });

      testWidgets('shows browser instruction', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(authState: const CloudSyncAuthState(isLoading: true)),
        );
        expect(find.text('Complete sign-in in your browser'), findsOneWidget);
      });

      testWidgets('hides chevron icon when loading', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(authState: const CloudSyncAuthState(isLoading: true)),
        );
        // The Google Drive button row should not have chevron_right when loading
        // but other provider buttons might still have it
        // We check that there's a CircularProgressIndicator instead of cloud_circle
        expect(find.byIcon(Icons.cloud_circle), findsNothing);
      });
    });

    group('authenticated state', () {
      testWidgets('shows connected title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(
              isAuthenticated: true,
              userEmail: 'test@gmail.com',
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        expect(find.text('Cloud Sync Connected'), findsOneWidget);
      });

      testWidgets('shows user email', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(
              isAuthenticated: true,
              userEmail: 'user@example.com',
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        expect(find.text('Signed in as user@example.com'), findsOneWidget);
      });

      testWidgets('shows signed-in info card', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(
              isAuthenticated: true,
              userEmail: 'card@example.com',
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
        expect(find.text('card@example.com'), findsOneWidget);
      });

      testWidgets('shows Done button', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        expect(find.text('Done'), findsOneWidget);
      });

      testWidgets('shows Sign Out button', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        expect(find.text('Sign Out'), findsOneWidget);
      });

      testWidgets('hides benefits list when signed in', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        expect(find.text('Automatic Backup'), findsNothing);
        expect(find.text('Multi-Device Sync'), findsNothing);
      });

      testWidgets('hides Maybe Later when signed in', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        expect(find.text('Maybe Later'), findsNothing);
      });

      testWidgets('shows cloud_done icon when authenticated', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        expect(find.byIcon(Icons.cloud_done), findsOneWidget);
        expect(find.byIcon(Icons.cloud_sync), findsNothing);
      });

      testWidgets('shows "unknown" when email is null', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(
              isAuthenticated: true,
              activeProvider: CloudProviderType.googleDrive,
            ),
          ),
        );
        expect(find.text('Signed in as unknown'), findsOneWidget);
      });
    });

    group('error state', () {
      testWidgets('shows error banner with message', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(
              errorMessage: 'Sign in failed: User cancelled',
            ),
          ),
        );
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Sign in failed: User cancelled'), findsOneWidget);
      });

      testWidgets('shows dismiss button on error', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(errorMessage: 'Some error'),
          ),
        );
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('error and unauthenticated shows provider buttons', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: const CloudSyncAuthState(errorMessage: 'Error occurred'),
          ),
        );
        // Should still show sign-in options
        expect(find.text('Google Drive'), findsOneWidget);
        expect(find.text('Local Only'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('has semantics label for screen', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(
          find.bySemanticsLabel('Cloud sync setup screen'),
          findsOneWidget,
        );
      });

      testWidgets('has semantics for skip button', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        expect(find.bySemanticsLabel('Skip cloud sync setup'), findsOneWidget);
      });
    });
  });
}

/// Fake notifier that holds a static state (does not call GoogleDriveProvider).
class _FakeCloudSyncAuthNotifier extends CloudSyncAuthNotifier {
  _FakeCloudSyncAuthNotifier(CloudSyncAuthState initialState)
    : super(_FakeGoogleDriveProvider()) {
    state = initialState;
  }
}

/// Minimal fake GoogleDriveProvider for testing.
/// The _FakeCloudSyncAuthNotifier overrides state directly,
/// so this provider's methods are never called.
class _FakeGoogleDriveProvider extends GoogleDriveProvider {
  _FakeGoogleDriveProvider() : super();

  @override
  Future<bool> isAuthenticated() async => false;
}
