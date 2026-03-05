// test/presentation/screens/cloud_sync/cloud_sync_setup_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/services/cloud_sync_auth_service.dart';
import 'package:shadow_app/domain/services/cloud_sync_auth_state.dart';
import 'package:shadow_app/domain/sync/cloud_storage_provider.dart';
import 'package:shadow_app/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_setup_screen.dart';

void main() {
  group('CloudSyncSetupScreen', () {
    Widget buildScreen({
      CloudSyncAuthState authState = const CloudSyncAuthState(),
    }) => ProviderScope(
      overrides: [
        cloudSyncAuthProvider.overrideWith(
          (ref) => _FakeCloudSyncAuthNotifier(authState),
        ),
      ],
      child: const MaterialApp(home: CloudSyncSetupScreen()),
    );

    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Set Up Cloud Sync'), findsOneWidget);
    });

    testWidgets('renders header title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Back Up and Sync Your Data'), findsOneWidget);
    });

    testWidgets('renders benefit items', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Automatic Backup'), findsOneWidget);
      expect(find.text('Multi-Device Sync'), findsOneWidget);
      expect(find.text('Secure & Private'), findsOneWidget);
    });

    testWidgets('renders Google Drive provider button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Google Drive'), findsOneWidget);
    });

    testWidgets('renders Local Only provider button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Local Only'), findsOneWidget);
    });

    testWidgets('renders Maybe Later skip button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Maybe Later'), findsOneWidget);
    });

    testWidgets('Google Drive button triggers sign-in', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      // Scroll to make Google Drive visible
      await tester.scrollUntilVisible(
        find.text('Google Drive'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      // Google Drive button now triggers sign-in (not "Coming Soon")
      expect(find.text('Google Drive'), findsOneWidget);
      expect(find.text('Use your Google account for sync'), findsOneWidget);
    });

    testWidgets('Local Only button exists', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      // Scroll to make Local Only visible
      await tester.scrollUntilVisible(
        find.text('Local Only'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Local Only'), findsOneWidget);
    });
  });
}

/// Fake notifier that holds a static state (does not call any provider).
class _FakeCloudSyncAuthNotifier extends CloudSyncAuthNotifier {
  _FakeCloudSyncAuthNotifier(CloudSyncAuthState initialState)
    : super(_FakeCloudSyncAuthService()) {
    state = initialState;
  }
}

/// Minimal fake CloudSyncAuthService for testing — returns no session.
class _FakeCloudSyncAuthService implements CloudSyncAuthService {
  @override
  Future<CloudSyncAuthState?> checkExistingSession() async => null;

  @override
  Future<Result<CloudSyncAuthState, AppError>> signInWithGoogle() async =>
      throw UnimplementedError();

  @override
  Future<Result<CloudSyncAuthState, AppError>> signInWithICloud() async =>
      throw UnimplementedError();

  @override
  Future<Result<CloudSyncAuthState, AppError>> switchProvider(
    CloudProviderType type,
    CloudProviderType? currentProvider,
  ) async => throw UnimplementedError();

  @override
  Future<Result<void, AppError>> signOut(
    CloudProviderType? activeProvider,
  ) async => throw UnimplementedError();
}
