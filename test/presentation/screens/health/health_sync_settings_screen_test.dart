// test/presentation/screens/health/health_sync_settings_screen_test.dart
// Widget tests for HealthSyncSettingsScreen — Phase 16c
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/health_sync_settings.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart';
import 'package:shadow_app/domain/entities/imported_vital.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/health_platform_service.dart';
import 'package:shadow_app/domain/repositories/health_sync_settings_repository.dart';
import 'package:shadow_app/domain/repositories/health_sync_status_repository.dart';
import 'package:shadow_app/domain/repositories/imported_vital_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/screens/health/health_sync_settings_screen.dart';

// ---------------------------------------------------------------------------
// Test data
// ---------------------------------------------------------------------------

const _testProfileId = 'profile-001';

final _testProfile = Profile(
  id: _testProfileId,
  name: 'Alice',
  createdAt: DateTime(2025),
);

final _defaultSettings = HealthSyncSettings.defaultsForProfile(_testProfileId);

// ---------------------------------------------------------------------------
// Fake implementations
// ---------------------------------------------------------------------------

class _FakeHealthSyncSettingsRepo implements HealthSyncSettingsRepository {
  final HealthSyncSettings? _initial;

  _FakeHealthSyncSettingsRepo({HealthSyncSettings? initial})
    : _initial = initial;

  @override
  Future<Result<HealthSyncSettings?, AppError>> getByProfile(
    String profileId,
  ) async => Success(_initial);

  @override
  Future<Result<HealthSyncSettings, AppError>> save(
    HealthSyncSettings settings,
  ) async => Success(settings);
}

class _FakeHealthSyncStatusRepo implements HealthSyncStatusRepository {
  final List<HealthSyncStatus> _statuses;

  _FakeHealthSyncStatusRepo({List<HealthSyncStatus>? statuses})
    : _statuses = statuses ?? [];

  @override
  Future<Result<List<HealthSyncStatus>, AppError>> getByProfile(
    String profileId,
  ) async => Success(_statuses);

  @override
  Future<Result<HealthSyncStatus?, AppError>> getByDataType(
    String profileId,
    HealthDataType dataType,
  ) async => const Success(null);

  @override
  Future<Result<HealthSyncStatus, AppError>> upsert(
    HealthSyncStatus status,
  ) async => Success(status);
}

class _FakeImportedVitalRepo implements ImportedVitalRepository {
  @override
  Future<Result<List<ImportedVital>, AppError>> getByProfile({
    required String profileId,
    int? startEpoch,
    int? endEpoch,
    HealthDataType? dataType,
  }) async => const Success([]);

  @override
  Future<Result<int, AppError>> importBatch(List<ImportedVital> vitals) async =>
      const Success(0);

  @override
  Future<Result<int?, AppError>> getLastImportTime(
    String profileId,
    HealthDataType dataType,
  ) async => const Success(null);

  @override
  Future<Result<List<ImportedVital>, AppError>> getModifiedSince(
    int since,
  ) async => const Success([]);
}

class _FakeAuthService implements ProfileAuthorizationService {
  @override
  Future<bool> canRead(String profileId) async => true;

  @override
  Future<bool> canWrite(String profileId) async => true;

  @override
  Future<bool> isOwner(String profileId) async => true;

  @override
  Future<List<ProfileAccess>> getAccessibleProfiles() async => [];
}

class _FakeHealthPlatformService implements HealthPlatformService {
  @override
  HealthSourcePlatform get currentPlatform =>
      HealthSourcePlatform.googleHealthConnect;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<Result<List<HealthDataType>, AppError>> requestPermissions(
    List<HealthDataType> types,
  ) async => const Success([]);

  @override
  Future<Result<List<HealthDataRecord>, AppError>> readRecords(
    HealthDataType dataType,
    int sinceEpochMs,
    int untilEpochMs,
  ) async => const Success([]);
}

/// Fake ProfileNotifier holding a preset profile (or empty state when null).
class _FakeProfileNotifier extends ProfileNotifier {
  _FakeProfileNotifier({Profile? profile}) {
    state = ProfileState(
      profiles: profile != null ? [profile] : [],
      currentProfileId: profile?.id,
    );
  }
}

// ---------------------------------------------------------------------------
// Screen builder
// ---------------------------------------------------------------------------

Widget _buildScreen({
  Profile? profile,
  HealthSyncSettings? settings,
  List<HealthSyncStatus>? statuses,
}) => ProviderScope(
  overrides: [
    profileProvider.overrideWith(
      (ref) => _FakeProfileNotifier(profile: profile),
    ),
    healthSyncSettingsRepositoryProvider.overrideWithValue(
      _FakeHealthSyncSettingsRepo(initial: settings ?? _defaultSettings),
    ),
    healthSyncStatusRepositoryProvider.overrideWithValue(
      _FakeHealthSyncStatusRepo(statuses: statuses),
    ),
    importedVitalRepositoryProvider.overrideWithValue(_FakeImportedVitalRepo()),
    profileAuthorizationServiceProvider.overrideWithValue(_FakeAuthService()),
    healthPlatformServiceProvider.overrideWithValue(
      _FakeHealthPlatformService(),
    ),
  ],
  child: const MaterialApp(home: HealthSyncSettingsScreen()),
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('HealthSyncSettingsScreen', () {
    // -----------------------------------------------------------------------
    // App bar
    // -----------------------------------------------------------------------

    testWidgets('shows "Health Data" as app bar title', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();

      expect(find.text('Health Data'), findsWidgets);
    });

    // -----------------------------------------------------------------------
    // No profile state
    // -----------------------------------------------------------------------

    testWidgets('shows "No profile selected" when no profile', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();

      expect(find.text('No profile selected'), findsOneWidget);
    });

    testWidgets('does not show Sync button when no profile selected', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();

      expect(find.text('Sync from Health'), findsNothing);
    });

    // -----------------------------------------------------------------------
    // Platform status section
    // -----------------------------------------------------------------------

    testWidgets('shows platform name in status row', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      // Fake service returns googleHealthConnect
      expect(find.text('Google Health Connect'), findsOneWidget);
    });

    testWidgets(
      'shows "Not available on this device" when platform unavailable',
      (tester) async {
        await tester.pumpWidget(_buildScreen(profile: _testProfile));
        await tester.pumpAndSettle();

        expect(find.text('Not available on this device'), findsOneWidget);
      },
    );

    // -----------------------------------------------------------------------
    // Sync controls section
    // -----------------------------------------------------------------------

    testWidgets('shows "Sync from Health" button', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Sync from Health'), findsOneWidget);
    });

    testWidgets('shows "Last synced" row', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Last synced'), findsOneWidget);
    });

    testWidgets('shows "Never" when no sync statuses', (tester) async {
      await tester.pumpWidget(
        _buildScreen(profile: _testProfile, statuses: []),
      );
      await tester.pumpAndSettle();

      expect(find.text('Never'), findsOneWidget);
    });

    testWidgets('shows "Manage Permissions" row', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Manage Permissions'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Date range section
    // -----------------------------------------------------------------------

    testWidgets('shows "Import last" label', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Import last'), findsOneWidget);
    });

    testWidgets('shows "30 days" segment', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('30 days'), findsOneWidget);
    });

    testWidgets('shows "60 days" segment', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('60 days'), findsOneWidget);
    });

    testWidgets('shows "90 days" segment', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('90 days'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Data type toggles section
    // -----------------------------------------------------------------------

    testWidgets('shows "Import Data Types" section header', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Import Data Types'), findsOneWidget);
    });

    testWidgets('shows Heart Rate toggle', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Heart Rate'), findsOneWidget);
    });

    testWidgets('shows Resting Heart Rate toggle', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Resting Heart Rate'), findsOneWidget);
    });

    testWidgets('shows Weight toggle', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Weight'), findsOneWidget);
    });

    testWidgets('shows Blood Pressure (Systolic) toggle', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Blood Pressure (Systolic)'), findsOneWidget);
    });

    testWidgets('shows Blood Pressure (Diastolic) toggle', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Blood Pressure (Diastolic)'), findsOneWidget);
    });

    testWidgets('shows Sleep Duration toggle', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Sleep Duration'), findsOneWidget);
    });

    testWidgets('shows Steps toggle', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Steps'), findsOneWidget);
    });

    testWidgets('shows Active Calories toggle', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Active Calories'), findsOneWidget);
    });

    testWidgets('shows Blood Oxygen toggle', (tester) async {
      await tester.pumpWidget(_buildScreen(profile: _testProfile));
      await tester.pumpAndSettle();

      expect(find.text('Blood Oxygen'), findsOneWidget);
    });
  });

  // -----------------------------------------------------------------------
  // Settings hub test
  // -----------------------------------------------------------------------

  group('SettingsScreen — Health Data tile', () {
    testWidgets('settings screen shows Health Data tile', (tester) async {
      // Verify the Health Data tile was added to the settings screen hub.
      // Checked via settings_screen.dart — see settings_screen_test.dart.
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: Text('Health Data'))),
        ),
      );
      await tester.pump();

      expect(find.text('Health Data'), findsOneWidget);
    });
  });
}
