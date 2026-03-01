// test/presentation/screens/cloud_sync/cloud_sync_settings_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/cloud/google_drive_provider.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/domain/entities/sync_conflict.dart';
import 'package:shadow_app/domain/services/sync_service.dart';
import 'package:shadow_app/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_settings_screen.dart';

void main() {
  group('CloudSyncSettingsScreen', () {
    Widget buildScreen({
      CloudSyncAuthState authState = const CloudSyncAuthState(),
      SyncService? syncService,
      String? profileId,
    }) => ProviderScope(
      overrides: [
        cloudSyncAuthProvider.overrideWith(
          (ref) => _FakeCloudSyncAuthNotifier(authState),
        ),
        if (syncService != null)
          syncServiceProvider.overrideWithValue(syncService),
        if (profileId != null)
          profileProvider.overrideWith(
            (ref) => _FakeProfileNotifier(profileId),
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

    // D3 — Auto Sync / WiFi Only / Sync Frequency removed: Shadow uses manual sync.

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

      // Scroll down to reveal Device Info section
      await tester.scrollUntilVisible(
        find.text('Google Drive'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Google Drive'), findsOneWidget);
    });

    testWidgets('shows None as provider when not authenticated', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('None'), findsOneWidget);
    });

    testWidgets('shows Sync Now button when authenticated', (tester) async {
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

      expect(find.text('Sync Now'), findsOneWidget);
    });

    testWidgets('hides Sync Now button when not authenticated', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Sync Now'), findsNothing);
    });

    testWidgets('Sync Now shows no profile snackbar when no profile selected', (
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

      await tester.tap(find.text('Sync Now'));
      await tester.pumpAndSettle();

      expect(find.text('No profile selected'), findsOneWidget);
    });

    testWidgets('shows Never when no last sync time', (tester) async {
      await tester.pumpWidget(
        buildScreen(
          profileId: 'p1',
          syncService: const _FakeSyncService(
            lastSyncTime: null,
            conflictCount: 0,
          ),
        ),
      );
      // Wait for initState → addPostFrameCallback → _loadSyncStatus
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Never'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Never'), findsOneWidget);
    });

    testWidgets('shows formatted time when last sync is available', (
      tester,
    ) async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await tester.pumpWidget(
        buildScreen(
          profileId: 'p1',
          syncService: _FakeSyncService(lastSyncTime: now, conflictCount: 0),
        ),
      );
      await tester.pumpAndSettle();

      // 'Just now' appears for a timestamp equal to now
      await tester.scrollUntilVisible(
        find.text('Just now'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Just now'), findsOneWidget);
    });

    testWidgets('shows conflict warning when conflicts exist', (tester) async {
      await tester.pumpWidget(
        buildScreen(
          profileId: 'p1',
          syncService: const _FakeSyncService(
            lastSyncTime: null,
            conflictCount: 2,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2 conflicts need review'), findsOneWidget);
    });

    testWidgets('hides conflict warning when no conflicts', (tester) async {
      await tester.pumpWidget(
        buildScreen(
          profileId: 'p1',
          syncService: const _FakeSyncService(
            lastSyncTime: null,
            conflictCount: 0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('conflict'), findsNothing);
    });

    testWidgets('shows singular conflict message for 1 conflict', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildScreen(
          profileId: 'p1',
          syncService: const _FakeSyncService(
            lastSyncTime: null,
            conflictCount: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 conflict needs review'), findsOneWidget);
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

/// Minimal fake SyncService for testing sync status display.
class _FakeSyncService implements SyncService {
  final int? lastSyncTime;
  final int conflictCount;

  const _FakeSyncService({
    required this.lastSyncTime,
    required this.conflictCount,
  });

  @override
  Future<Result<int?, AppError>> getLastSyncTime(String profileId) async =>
      Success(lastSyncTime);

  @override
  Future<Result<int, AppError>> getConflictCount(String profileId) async =>
      Success(conflictCount);

  @override
  Future<Result<int, AppError>> getPendingChangesCount(
    String profileId,
  ) async => const Success(0);

  @override
  Future<Result<List<SyncChange>, AppError>> getPendingChanges(
    String profileId, {
    int limit = 500,
  }) async => const Success([]);

  @override
  Future<Result<PushChangesResult, AppError>> pushChanges(
    List<SyncChange> changes,
  ) async => const Success(
    PushChangesResult(pushedCount: 0, failedCount: 0, conflicts: []),
  );

  @override
  Future<void> pushPendingChanges() async {}

  @override
  Future<Result<List<SyncChange>, AppError>> pullChanges(
    String profileId, {
    int? sinceVersion,
    int limit = 500,
  }) async => const Success([]);

  @override
  Future<Result<PullChangesResult, AppError>> applyChanges(
    String profileId,
    List<SyncChange> changes,
  ) async => const Success(
    PullChangesResult(
      pulledCount: 0,
      appliedCount: 0,
      conflictCount: 0,
      conflicts: [],
      latestVersion: 0,
    ),
  );

  @override
  Future<Result<void, AppError>> resolveConflict(
    String conflictId,
    ConflictResolutionType resolution,
  ) async => const Success(null);

  @override
  Future<Result<int?, AppError>> getLastSyncVersion(String profileId) async =>
      const Success(null);

  @override
  Future<Result<List<SyncConflict>, AppError>> getUnresolvedConflicts(
    String profileId,
  ) async => const Success([]);
}

/// Fake ProfileNotifier that immediately holds a preset profileId.
///
/// Calls ProfileNotifier() (which starts async _load()), then immediately
/// overwrites state. Since SharedPreferences is empty in these tests, _load()
/// will not update state (it only updates when the profiles JSON key exists).
class _FakeProfileNotifier extends ProfileNotifier {
  _FakeProfileNotifier(String profileId) {
    state = ProfileState(currentProfileId: profileId);
  }
}
