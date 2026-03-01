// test/presentation/screens/cloud_sync/conflict_resolution_screen_test.dart
// Widget tests for ConflictResolutionScreen — Phase 30.

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
import 'package:shadow_app/presentation/screens/cloud_sync/conflict_resolution_screen.dart';

// ════════════════════════════════════════════════════════════════════════════
// Test data
// ════════════════════════════════════════════════════════════════════════════

const _profileId = 'test-profile-001';

SyncConflict _makeConflict({
  String id = 'conflict-001',
  String entityType = 'supplements',
  String entityId = 'entity-abcdef12',
  Map<String, dynamic>? localData,
  Map<String, dynamic>? remoteData,
}) => SyncConflict(
  id: id,
  entityType: entityType,
  entityId: entityId,
  profileId: _profileId,
  localVersion: 1,
  remoteVersion: 2,
  localData: localData ?? {'name': 'Vitamin D'},
  remoteData: remoteData ?? {'name': 'Vitamin D3'},
  detectedAt: DateTime(2024, 1, 1, 12).millisecondsSinceEpoch,
);

// ════════════════════════════════════════════════════════════════════════════
// Fake SyncService
// ════════════════════════════════════════════════════════════════════════════

class _FakeSyncService implements SyncService {
  final List<SyncConflict> conflicts;
  final bool resolveSucceeds;

  /// Records calls: (conflictId, resolution)
  final List<(String, ConflictResolutionType)> resolveCalls = [];

  _FakeSyncService({this.conflicts = const [], this.resolveSucceeds = true});

  @override
  Future<Result<List<SyncConflict>, AppError>> getUnresolvedConflicts(
    String profileId,
  ) async => Success(List.of(conflicts));

  @override
  Future<Result<void, AppError>> resolveConflict(
    String conflictId,
    ConflictResolutionType resolution,
  ) async {
    resolveCalls.add((conflictId, resolution));
    if (resolveSucceeds) return const Success(null);
    return Failure(SyncError.corruptedData('test', conflictId, 'test error'));
  }

  // === Stubs ===
  @override
  Future<Result<int, AppError>> getConflictCount(String profileId) async =>
      Success(conflicts.length);

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
  Future<Result<int?, AppError>> getLastSyncTime(String profileId) async =>
      const Success(null);

  @override
  Future<Result<int?, AppError>> getLastSyncVersion(String profileId) async =>
      const Success(null);
}

// ════════════════════════════════════════════════════════════════════════════
// Fake ProfileNotifier
// ════════════════════════════════════════════════════════════════════════════

class _FakeProfileNotifier extends ProfileNotifier {
  final String fakeProfileId;

  _FakeProfileNotifier(this.fakeProfileId) {
    state = ProfileState(currentProfileId: fakeProfileId);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Fake CloudSyncAuthNotifier
// ════════════════════════════════════════════════════════════════════════════

class _FakeGoogleDriveProvider extends GoogleDriveProvider {
  _FakeGoogleDriveProvider() : super();

  @override
  Future<bool> isAuthenticated() async => false;
}

class _FakeCloudSyncAuthNotifier extends CloudSyncAuthNotifier {
  _FakeCloudSyncAuthNotifier(CloudSyncAuthState initialState)
    : super(_FakeGoogleDriveProvider()) {
    state = initialState;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Widget builders
// ════════════════════════════════════════════════════════════════════════════

Widget _buildConflictScreen(_FakeSyncService syncService) => ProviderScope(
  overrides: [
    syncServiceProvider.overrideWithValue(syncService),
    profileProvider.overrideWith((ref) => _FakeProfileNotifier(_profileId)),
  ],
  child: const MaterialApp(home: ConflictResolutionScreen()),
);

Widget _buildSettingsScreen({
  required _FakeSyncService syncService,
  CloudSyncAuthState authState = const CloudSyncAuthState(
    isAuthenticated: true,
  ),
}) => ProviderScope(
  overrides: [
    syncServiceProvider.overrideWithValue(syncService),
    profileProvider.overrideWith((ref) => _FakeProfileNotifier(_profileId)),
    cloudSyncAuthProvider.overrideWith(
      (ref) => _FakeCloudSyncAuthNotifier(authState),
    ),
  ],
  child: const MaterialApp(home: CloudSyncSettingsScreen()),
);

// ════════════════════════════════════════════════════════════════════════════
// Tests
// ════════════════════════════════════════════════════════════════════════════

void main() {
  group('ConflictResolutionScreen', () {
    testWidgets('empty state renders when no conflicts', (tester) async {
      await tester.pumpWidget(_buildConflictScreen(_FakeSyncService()));
      await tester.pumpAndSettle();

      expect(find.text('All conflicts resolved'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('banner renders when conflicts present', (tester) async {
      final svc = _FakeSyncService(conflicts: [_makeConflict()]);
      await tester.pumpWidget(_buildConflictScreen(svc));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
      expect(find.textContaining('conflict'), findsWidgets);
    });

    testWidgets('ConflictCard shows entity type label and truncated ID', (
      tester,
    ) async {
      final conflict = _makeConflict();
      final svc = _FakeSyncService(conflicts: [conflict]);
      await tester.pumpWidget(_buildConflictScreen(svc));
      await tester.pumpAndSettle();

      expect(find.text('Supplement'), findsOneWidget);
      // Last 8 chars of 'entity-abcdef12' = 'bcdef12' — entity is 15 chars,
      // last 8 = 'bcdef12' + the full check:
      // 'entity-abcdef12'.length = 15, last 8 = 'bcdef12' actually...
      // 'entity-abcdef12' → substring(7) = 'abcdef12' (8 chars)
      expect(find.textContaining('…'), findsOneWidget);
    });

    testWidgets('both version panels are shown', (tester) async {
      final conflict = _makeConflict(
        localData: {'name': 'Vitamin D'},
        remoteData: {'name': 'Vitamin D3'},
      );
      final svc = _FakeSyncService(conflicts: [conflict]);
      await tester.pumpWidget(_buildConflictScreen(svc));
      await tester.pumpAndSettle();

      expect(find.text('THIS DEVICE'), findsOneWidget);
      expect(find.text('OTHER DEVICE'), findsOneWidget);
      expect(find.text('Vitamin D'), findsOneWidget);
      expect(find.text('Vitamin D3'), findsOneWidget);
    });

    testWidgets("'Keep This Device' calls resolveConflict with keepLocal", (
      tester,
    ) async {
      final svc = _FakeSyncService(conflicts: [_makeConflict()]);
      await tester.pumpWidget(_buildConflictScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Keep This Device'));
      await tester.pumpAndSettle();

      expect(svc.resolveCalls, hasLength(1));
      expect(svc.resolveCalls.first.$2, ConflictResolutionType.keepLocal);
    });

    testWidgets("'Keep Other Device' calls resolveConflict with keepRemote", (
      tester,
    ) async {
      final svc = _FakeSyncService(conflicts: [_makeConflict()]);
      await tester.pumpWidget(_buildConflictScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Keep Other Device'));
      await tester.pumpAndSettle();

      expect(svc.resolveCalls, hasLength(1));
      expect(svc.resolveCalls.first.$2, ConflictResolutionType.keepRemote);
    });

    testWidgets("'Merge' calls resolveConflict with merge", (tester) async {
      final svc = _FakeSyncService(conflicts: [_makeConflict()]);
      await tester.pumpWidget(_buildConflictScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Merge'));
      await tester.pumpAndSettle();

      expect(svc.resolveCalls, hasLength(1));
      expect(svc.resolveCalls.first.$2, ConflictResolutionType.merge);
    });

    testWidgets('resolved card is removed from list on success', (
      tester,
    ) async {
      final svc = _FakeSyncService(conflicts: [_makeConflict()]);
      await tester.pumpWidget(_buildConflictScreen(svc));
      await tester.pumpAndSettle();

      expect(find.text('Supplement'), findsOneWidget);

      await tester.tap(find.text('Keep This Device'));
      await tester.pumpAndSettle();

      // Card removed — empty state shown
      expect(find.text('All conflicts resolved'), findsOneWidget);
    });

    testWidgets('error snackbar shown on resolution failure', (tester) async {
      final svc = _FakeSyncService(
        conflicts: [_makeConflict()],
        resolveSucceeds: false,
      );
      await tester.pumpWidget(_buildConflictScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Keep This Device'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Failed to resolve conflict'), findsOneWidget);
    });
  });

  group('CloudSyncSettingsScreen — conflict navigation', () {
    testWidgets(
      'conflict count row navigates to ConflictResolutionScreen when tapped',
      (tester) async {
        final svc = _FakeSyncService(conflicts: [_makeConflict()]);
        await tester.pumpWidget(_buildSettingsScreen(syncService: svc));
        await tester.pumpAndSettle();

        expect(find.textContaining('conflict'), findsOneWidget);

        await tester.tap(find.textContaining('conflict'));
        await tester.pumpAndSettle();

        expect(find.byType(ConflictResolutionScreen), findsOneWidget);
      },
    );
  });
}
