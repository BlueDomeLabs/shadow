// test/presentation/screens/cloud_sync/cloud_sync_settings_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/cloud/google_drive_provider.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_settings_screen.dart';

void main() {
  group('CloudSyncSettingsScreen', () {
    Widget buildScreen({
      CloudSyncAuthState authState = const CloudSyncAuthState(),
    }) => ProviderScope(
      overrides: [
        cloudSyncAuthProvider.overrideWith(
          (ref) => _FakeCloudSyncAuthNotifier(authState),
        ),
      ],
      child: const MaterialApp(home: CloudSyncSettingsScreen()),
    );

    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Cloud Sync'), findsOneWidget);
    });

    testWidgets('renders sync status section', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Sync Status'), findsOneWidget);
      expect(find.text('Not configured'), findsOneWidget);
    });

    testWidgets('renders sync settings section', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Sync Settings'), findsOneWidget);
      expect(find.text('Auto Sync'), findsOneWidget);
      expect(find.text('WiFi Only'), findsOneWidget);
      expect(find.text('Sync Frequency'), findsOneWidget);
    });

    testWidgets('renders setup button when not authenticated', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Set Up Cloud Sync'), findsOneWidget);
    });

    testWidgets('renders device info section', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Device Info'), findsOneWidget);
      expect(find.text('Sync Provider'), findsOneWidget);
      expect(find.text('Last Sync'), findsOneWidget);
    });

    testWidgets('tapping Auto Sync shows Coming Soon', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      // Tap the switch for Auto Sync
      final switches = find.byType(Switch);
      expect(switches, findsWidgets);

      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      expect(find.text('Coming Soon'), findsOneWidget);
    });

    testWidgets('shows connected state when authenticated', (tester) async {
      await tester.pumpWidget(
        buildScreen(
          authState: const CloudSyncAuthState(
            isAuthenticated: true,
            userEmail: 'test@example.com',
            activeProvider: CloudProviderType.googleDrive,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Connected to Google Drive'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Manage Cloud Sync'), findsOneWidget);
    });

    testWidgets('shows Google Drive as provider when authenticated', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildScreen(
          authState: const CloudSyncAuthState(
            isAuthenticated: true,
            userEmail: 'test@example.com',
            activeProvider: CloudProviderType.googleDrive,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Google Drive'), findsOneWidget);
    });

    testWidgets('shows None as provider when not authenticated', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('None'), findsOneWidget);
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
class _FakeGoogleDriveProvider extends GoogleDriveProvider {
  _FakeGoogleDriveProvider() : super();

  @override
  Future<bool> isAuthenticated() async => false;
}
