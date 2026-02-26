// test/unit/domain/usecases/health/sync_from_health_platform_use_case_test.dart
// Phase 16b — Tests for SyncFromHealthPlatformUseCase
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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
import 'package:shadow_app/domain/usecases/health/health_types.dart';
import 'package:shadow_app/domain/usecases/health/sync_from_health_platform_use_case.dart';

@GenerateMocks([
  HealthPlatformService,
  HealthSyncSettingsRepository,
  HealthSyncStatusRepository,
  ImportedVitalRepository,
  ProfileAuthorizationService,
])
import 'sync_from_health_platform_use_case_test.mocks.dart';

void main() {
  // Dummy values required by mockito for return type inference.
  provideDummy<Result<HealthSyncSettings?, AppError>>(const Success(null));
  provideDummy<Result<HealthSyncSettings, AppError>>(
    const Success(HealthSyncSettings(id: 'dummy', profileId: 'dummy')),
  );
  provideDummy<Result<List<HealthDataType>, AppError>>(const Success([]));
  provideDummy<Result<List<HealthDataRecord>, AppError>>(const Success([]));
  provideDummy<Result<int?, AppError>>(const Success(null));
  provideDummy<Result<int, AppError>>(const Success(0));
  provideDummy<Result<HealthSyncStatus, AppError>>(
    const Success(
      HealthSyncStatus(
        id: 'dummy',
        profileId: 'dummy',
        dataType: HealthDataType.heartRate,
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';

  late MockHealthPlatformService mockPlatform;
  late MockHealthSyncSettingsRepository mockSettingsRepo;
  late MockHealthSyncStatusRepository mockStatusRepo;
  late MockImportedVitalRepository mockVitalRepo;
  late MockProfileAuthorizationService mockAuth;
  late SyncFromHealthPlatformUseCase useCase;

  setUp(() {
    mockPlatform = MockHealthPlatformService();
    mockSettingsRepo = MockHealthSyncSettingsRepository();
    mockStatusRepo = MockHealthSyncStatusRepository();
    mockVitalRepo = MockImportedVitalRepository();
    mockAuth = MockProfileAuthorizationService();
    useCase = SyncFromHealthPlatformUseCase(
      mockPlatform,
      mockSettingsRepo,
      mockStatusRepo,
      mockVitalRepo,
      mockAuth,
    );

    // Default: platform available, Apple Health
    when(mockPlatform.isAvailable()).thenAnswer((_) async => true);
    when(
      mockPlatform.currentPlatform,
    ).thenReturn(HealthSourcePlatform.appleHealth);
  });

  // ============================================================
  // Helpers
  // ============================================================

  HealthSyncSettings makeSettings({
    List<HealthDataType>? types,
    int dateRangeDays = 30,
  }) => HealthSyncSettings(
    id: testProfileId,
    profileId: testProfileId,
    enabledDataTypes:
        types ?? [HealthDataType.heartRate, HealthDataType.weight],
    dateRangeDays: dateRangeDays,
  );

  HealthDataRecord makeRecord({
    int recordedAt = 1704067200000,
    double value = 72.0,
    String? sourceDevice,
  }) => HealthDataRecord(
    recordedAt: recordedAt,
    value: value,
    sourceDevice: sourceDevice,
  );

  void stubBasicSuccess({
    List<HealthDataType>? enabledTypes,
    List<HealthDataType>? grantedTypes,
    Map<HealthDataType, List<HealthDataRecord>>? recordsByType,
    int importedPerType = 1,
  }) {
    final types =
        enabledTypes ?? [HealthDataType.heartRate, HealthDataType.weight];
    final granted = grantedTypes ?? types;

    when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
    when(
      mockSettingsRepo.getByProfile(testProfileId),
    ).thenAnswer((_) async => Success(makeSettings(types: types)));
    when(
      mockPlatform.requestPermissions(types),
    ).thenAnswer((_) async => Success(granted));

    for (final type in granted) {
      when(
        mockVitalRepo.getLastImportTime(testProfileId, type),
      ).thenAnswer((_) async => const Success(null));

      final records = recordsByType?[type] ?? [makeRecord()];
      when(
        mockPlatform.readRecords(type, any, any),
      ).thenAnswer((_) async => Success(records));

      when(
        mockVitalRepo.importBatch(any),
      ).thenAnswer((_) async => Success(importedPerType));

      when(mockStatusRepo.upsert(any)).thenAnswer(
        (inv) async => Success(inv.positionalArguments[0] as HealthSyncStatus),
      );
    }
  }

  // ============================================================
  // Authorization
  // ============================================================

  group('authorization', () {
    test('returns profile access denied when canWrite is false', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockPlatform.isAvailable());
    });
  });

  // ============================================================
  // Platform availability
  // ============================================================

  group('platform availability', () {
    test('returns platformUnavailable when platform not installed', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockPlatform.isAvailable()).thenAnswer((_) async => false);

      final result = await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.platformUnavailable, isTrue);
      expect(result.valueOrNull?.totalImported, 0);
      verifyNever(mockSettingsRepo.getByProfile(any));
    });

    test('proceeds normally when platform is available', () async {
      stubBasicSuccess();

      final result = await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.platformUnavailable, isFalse);
    });
  });

  // ============================================================
  // Successful sync with all data types
  // ============================================================

  group('successful sync with all data types', () {
    test('imports records for each granted type and returns summary', () async {
      const types = [
        HealthDataType.heartRate,
        HealthDataType.weight,
        HealthDataType.steps,
      ];
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockSettingsRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(makeSettings(types: types)));
      when(
        mockPlatform.requestPermissions(types),
      ).thenAnswer((_) async => const Success(types));

      for (final type in types) {
        when(
          mockVitalRepo.getLastImportTime(testProfileId, type),
        ).thenAnswer((_) async => const Success(null));
        when(
          mockPlatform.readRecords(type, any, any),
        ).thenAnswer((_) async => Success([makeRecord(value: 42)]));
        when(
          mockVitalRepo.importBatch(any),
        ).thenAnswer((_) async => const Success(1));
        when(mockStatusRepo.upsert(any)).thenAnswer(
          (inv) async =>
              Success(inv.positionalArguments[0] as HealthSyncStatus),
        );
      }

      final result = await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      final summary = result.valueOrNull!;
      expect(summary.importedCountByType.keys, containsAll(types));
      expect(summary.deniedTypes, isEmpty);
      expect(summary.platformUnavailable, isFalse);
      expect(summary.totalImported, 3);
    });

    test(
      'assigns correct data type, unit, and platform to each vital',
      () async {
        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(mockSettingsRepo.getByProfile(testProfileId)).thenAnswer(
          (_) async => Success(makeSettings(types: [HealthDataType.heartRate])),
        );
        when(
          mockPlatform.requestPermissions([HealthDataType.heartRate]),
        ).thenAnswer((_) async => const Success([HealthDataType.heartRate]));
        when(
          mockVitalRepo.getLastImportTime(
            testProfileId,
            HealthDataType.heartRate,
          ),
        ).thenAnswer((_) async => const Success(null));
        when(
          mockPlatform.readRecords(HealthDataType.heartRate, any, any),
        ).thenAnswer(
          (_) async => Success([
            makeRecord(value: 75, sourceDevice: 'Apple Watch Series 9'),
          ]),
        );

        // Capture the vitals written to the repository.
        List<ImportedVital>? capturedVitals;
        when(mockVitalRepo.importBatch(any)).thenAnswer((inv) async {
          capturedVitals = inv.positionalArguments[0] as List<ImportedVital>;
          return const Success(1);
        });
        when(mockStatusRepo.upsert(any)).thenAnswer(
          (inv) async =>
              Success(inv.positionalArguments[0] as HealthSyncStatus),
        );

        await useCase(
          const SyncFromHealthPlatformInput(profileId: testProfileId),
        );

        expect(capturedVitals, hasLength(1));
        final vital = capturedVitals!.first;
        expect(vital.dataType, HealthDataType.heartRate);
        expect(vital.unit, 'bpm');
        expect(vital.value, 75.0);
        expect(vital.sourcePlatform, HealthSourcePlatform.appleHealth);
        expect(vital.sourceDevice, 'Apple Watch Series 9');
        expect(vital.profileId, testProfileId);
      },
    );

    test('updates sync status with correct timestamp and count', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockSettingsRepo.getByProfile(testProfileId)).thenAnswer(
        (_) async => Success(makeSettings(types: [HealthDataType.steps])),
      );
      when(
        mockPlatform.requestPermissions([HealthDataType.steps]),
      ).thenAnswer((_) async => const Success([HealthDataType.steps]));
      when(
        mockVitalRepo.getLastImportTime(testProfileId, HealthDataType.steps),
      ).thenAnswer((_) async => const Success(null));
      when(
        mockPlatform.readRecords(HealthDataType.steps, any, any),
      ).thenAnswer((_) async => Success([makeRecord(), makeRecord()]));
      when(
        mockVitalRepo.importBatch(any),
      ).thenAnswer((_) async => const Success(2));

      // Capture the status written to the repository.
      HealthSyncStatus? capturedStatus;
      when(mockStatusRepo.upsert(any)).thenAnswer((inv) async {
        capturedStatus = inv.positionalArguments[0] as HealthSyncStatus;
        return Success(capturedStatus!);
      });

      await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );

      expect(capturedStatus, isNotNull);
      expect(capturedStatus!.dataType, HealthDataType.steps);
      expect(capturedStatus!.profileId, testProfileId);
      expect(capturedStatus!.recordCount, 2);
      expect(capturedStatus!.lastSyncedAt, isNotNull);
    });
  });

  // ============================================================
  // Partial permissions
  // ============================================================

  group('partial permissions', () {
    test('imports permitted types and records denied types', () async {
      const enabledTypes = [
        HealthDataType.heartRate,
        HealthDataType.weight,
        HealthDataType.steps,
      ];
      const grantedTypes = [HealthDataType.heartRate, HealthDataType.steps];
      const deniedTypes = [HealthDataType.weight];

      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockSettingsRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(makeSettings(types: enabledTypes)));
      when(
        mockPlatform.requestPermissions(enabledTypes),
      ).thenAnswer((_) async => const Success(grantedTypes));

      for (final type in grantedTypes) {
        when(
          mockVitalRepo.getLastImportTime(testProfileId, type),
        ).thenAnswer((_) async => const Success(null));
        when(
          mockPlatform.readRecords(type, any, any),
        ).thenAnswer((_) async => Success([makeRecord()]));
        when(
          mockVitalRepo.importBatch(any),
        ).thenAnswer((_) async => const Success(1));
        when(mockStatusRepo.upsert(any)).thenAnswer(
          (inv) async =>
              Success(inv.positionalArguments[0] as HealthSyncStatus),
        );
      }

      final result = await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      final summary = result.valueOrNull!;
      expect(summary.deniedTypes, containsAll(deniedTypes));
      expect(summary.importedCountByType.keys, containsAll(grantedTypes));
      expect(
        summary.importedCountByType.containsKey(HealthDataType.weight),
        isFalse,
      );
    });

    test(
      'returns success with denied types when all permissions denied',
      () async {
        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(mockSettingsRepo.getByProfile(testProfileId)).thenAnswer(
          (_) async => Success(makeSettings(types: [HealthDataType.heartRate])),
        );
        when(
          mockPlatform.requestPermissions(any),
        ).thenAnswer((_) async => const Success([]));

        final result = await useCase(
          const SyncFromHealthPlatformInput(profileId: testProfileId),
        );

        expect(result.isSuccess, isTrue);
        expect(
          result.valueOrNull?.deniedTypes,
          contains(HealthDataType.heartRate),
        );
        expect(result.valueOrNull?.totalImported, 0);
        verifyNever(mockVitalRepo.importBatch(any));
      },
    );
  });

  // ============================================================
  // Incremental sync
  // ============================================================

  group('incremental sync', () {
    test(
      'uses last import time as start of window when previously synced',
      () async {
        const lastImportMs = 1704067200000; // 2024-01-01

        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(mockSettingsRepo.getByProfile(testProfileId)).thenAnswer(
          (_) async => Success(makeSettings(types: [HealthDataType.heartRate])),
        );
        when(
          mockPlatform.requestPermissions(any),
        ).thenAnswer((_) async => const Success([HealthDataType.heartRate]));
        when(
          mockVitalRepo.getLastImportTime(
            testProfileId,
            HealthDataType.heartRate,
          ),
        ).thenAnswer((_) async => const Success(lastImportMs));
        when(
          mockPlatform.readRecords(HealthDataType.heartRate, any, any),
        ).thenAnswer((_) async => const Success([]));

        await useCase(
          const SyncFromHealthPlatformInput(profileId: testProfileId),
        );

        // Verify readRecords was called with lastImportMs as the start time.
        verify(
          mockPlatform.readRecords(HealthDataType.heartRate, lastImportMs, any),
        ).called(1);
      },
    );

    test('uses full date range when no previous import exists', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockSettingsRepo.getByProfile(testProfileId)).thenAnswer(
        (_) async => Success(makeSettings(types: [HealthDataType.heartRate])),
      );
      when(
        mockPlatform.requestPermissions(any),
      ).thenAnswer((_) async => const Success([HealthDataType.heartRate]));
      when(
        mockVitalRepo.getLastImportTime(
          testProfileId,
          HealthDataType.heartRate,
        ),
      ).thenAnswer((_) async => const Success(null));
      when(
        mockPlatform.readRecords(HealthDataType.heartRate, any, any),
      ).thenAnswer((_) async => const Success([]));

      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );
      final afterCall = DateTime.now().millisecondsSinceEpoch;

      // Verify the start time passed to readRecords was approximately 30 days ago.
      final captured =
          verify(
                mockPlatform.readRecords(
                  HealthDataType.heartRate,
                  captureAny,
                  any,
                ),
              ).captured.first
              as int;

      const thirtyDaysMs = 30 * 24 * 60 * 60 * 1000;
      final expectedStartMin = beforeCall - thirtyDaysMs - 5000; // 5s buffer
      final expectedStartMax = afterCall - thirtyDaysMs + 5000;
      expect(captured, greaterThanOrEqualTo(expectedStartMin));
      expect(captured, lessThanOrEqualTo(expectedStartMax));
    });
  });

  // ============================================================
  // Deduplication
  // ============================================================

  group('deduplication', () {
    test('delegates deduplication to repository importBatch', () async {
      // The use case passes ALL records to importBatch; the repository
      // skips duplicates and returns the count of NEW records only.
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockSettingsRepo.getByProfile(testProfileId)).thenAnswer(
        (_) async => Success(makeSettings(types: [HealthDataType.weight])),
      );
      when(
        mockPlatform.requestPermissions(any),
      ).thenAnswer((_) async => const Success([HealthDataType.weight]));
      when(
        mockVitalRepo.getLastImportTime(testProfileId, HealthDataType.weight),
      ).thenAnswer((_) async => const Success(null));

      // Platform returns 5 records.
      when(
        mockPlatform.readRecords(HealthDataType.weight, any, any),
      ).thenAnswer(
        (_) async => Success(
          List.generate(
            5,
            (i) => makeRecord(recordedAt: 1704067200000 + (i * 60000)),
          ),
        ),
      );

      // Repository says only 2 were new (3 were duplicates).
      when(
        mockVitalRepo.importBatch(any),
      ).thenAnswer((_) async => const Success(2));
      when(mockStatusRepo.upsert(any)).thenAnswer(
        (inv) async => Success(inv.positionalArguments[0] as HealthSyncStatus),
      );

      final result = await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );

      // Result reflects what the repository said was actually new.
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.importedCountByType[HealthDataType.weight], 2);
      // All 5 records were passed to importBatch.
      verify(mockVitalRepo.importBatch(argThat(hasLength(5)))).called(1);
    });
  });

  // ============================================================
  // Health Connect not installed (Android graceful failure)
  // ============================================================

  group('Health Connect not installed', () {
    test(
      'returns platformUnavailable=true without calling repositories',
      () async {
        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(mockPlatform.isAvailable()).thenAnswer((_) async => false);

        final result = await useCase(
          const SyncFromHealthPlatformInput(profileId: testProfileId),
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.platformUnavailable, isTrue);
        expect(result.valueOrNull?.totalImported, 0);
        expect(result.valueOrNull?.deniedTypes, isEmpty);

        verifyNever(mockSettingsRepo.getByProfile(any));
        verifyNever(mockPlatform.requestPermissions(any));
        verifyNever(mockVitalRepo.importBatch(any));
      },
    );
  });

  // ============================================================
  // Empty result (no new records since last sync)
  // ============================================================

  group('empty result', () {
    test(
      'returns zero count per type when platform returns no records',
      () async {
        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(mockSettingsRepo.getByProfile(testProfileId)).thenAnswer(
          (_) async => Success(
            makeSettings(
              types: [HealthDataType.heartRate, HealthDataType.steps],
            ),
          ),
        );
        when(mockPlatform.requestPermissions(any)).thenAnswer(
          (_) async =>
              const Success([HealthDataType.heartRate, HealthDataType.steps]),
        );

        for (final type in [HealthDataType.heartRate, HealthDataType.steps]) {
          when(
            mockVitalRepo.getLastImportTime(testProfileId, type),
          ).thenAnswer((_) async => const Success(null));
          when(
            mockPlatform.readRecords(type, any, any),
          ).thenAnswer((_) async => const Success([]));
        }

        final result = await useCase(
          const SyncFromHealthPlatformInput(profileId: testProfileId),
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.totalImported, 0);
        expect(
          result.valueOrNull?.importedCountByType[HealthDataType.heartRate],
          0,
        );
        expect(
          result.valueOrNull?.importedCountByType[HealthDataType.steps],
          0,
        );
        // importBatch should not be called when there are no records.
        verifyNever(mockVitalRepo.importBatch(any));
      },
    );

    test(
      'returns empty result when no data types are enabled in settings',
      () async {
        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(mockSettingsRepo.getByProfile(testProfileId)).thenAnswer(
          (_) async => const Success(
            HealthSyncSettings(id: testProfileId, profileId: testProfileId),
          ),
        );

        final result = await useCase(
          const SyncFromHealthPlatformInput(profileId: testProfileId),
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.totalImported, 0);
        verifyNever(mockPlatform.requestPermissions(any));
      },
    );
  });

  // ============================================================
  // Error propagation
  // ============================================================

  group('error propagation', () {
    test('propagates settings repository failure', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockSettingsRepo.getByProfile(testProfileId)).thenAnswer(
        (_) async =>
            Failure(DatabaseError.queryFailed('health_sync_settings', 'err')),
      );

      final result = await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
    });

    test('propagates importBatch failure', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockSettingsRepo.getByProfile(testProfileId)).thenAnswer(
        (_) async => Success(makeSettings(types: [HealthDataType.heartRate])),
      );
      when(
        mockPlatform.requestPermissions(any),
      ).thenAnswer((_) async => const Success([HealthDataType.heartRate]));
      when(
        mockVitalRepo.getLastImportTime(
          testProfileId,
          HealthDataType.heartRate,
        ),
      ).thenAnswer((_) async => const Success(null));
      when(
        mockPlatform.readRecords(HealthDataType.heartRate, any, any),
      ).thenAnswer((_) async => Success([makeRecord()]));
      when(mockVitalRepo.importBatch(any)).thenAnswer(
        (_) async => Failure(
          DatabaseError.insertFailed('imported_vitals', Exception('disk full')),
        ),
      );

      final result = await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
    });

    test(
      'skips data type on platform read failure, continues with others',
      () async {
        const types = [HealthDataType.heartRate, HealthDataType.weight];

        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(
          mockSettingsRepo.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(makeSettings(types: types)));
        when(
          mockPlatform.requestPermissions(types),
        ).thenAnswer((_) async => const Success(types));

        // heartRate read fails.
        when(
          mockVitalRepo.getLastImportTime(
            testProfileId,
            HealthDataType.heartRate,
          ),
        ).thenAnswer((_) async => const Success(null));
        when(
          mockPlatform.readRecords(HealthDataType.heartRate, any, any),
        ).thenAnswer(
          (_) async =>
              Failure(DatabaseError.queryFailed('healthkit', 'sensor error')),
        );

        // weight read succeeds.
        when(
          mockVitalRepo.getLastImportTime(testProfileId, HealthDataType.weight),
        ).thenAnswer((_) async => const Success(null));
        when(
          mockPlatform.readRecords(HealthDataType.weight, any, any),
        ).thenAnswer((_) async => Success([makeRecord(value: 80.5)]));
        when(
          mockVitalRepo.importBatch(any),
        ).thenAnswer((_) async => const Success(1));
        when(mockStatusRepo.upsert(any)).thenAnswer(
          (inv) async =>
              Success(inv.positionalArguments[0] as HealthSyncStatus),
        );

        final result = await useCase(
          const SyncFromHealthPlatformInput(profileId: testProfileId),
        );

        // Sync succeeds overall; heartRate shows 0, weight shows 1.
        expect(result.isSuccess, isTrue);
        expect(
          result.valueOrNull?.importedCountByType[HealthDataType.heartRate],
          0,
        );
        expect(
          result.valueOrNull?.importedCountByType[HealthDataType.weight],
          1,
        );
      },
    );

    test('uses default settings when settings repo returns null', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockSettingsRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => const Success(null));
      when(
        mockPlatform.requestPermissions(any),
      ).thenAnswer((_) async => const Success([])); // all denied for simplicity

      final result = await useCase(
        const SyncFromHealthPlatformInput(profileId: testProfileId),
      );

      // Falls back to HealthSyncSettings.defaultsForProfile — all 9 types.
      expect(result.isSuccess, isTrue);
      verify(
        mockPlatform.requestPermissions(
          argThat(hasLength(HealthDataType.values.length)),
        ),
      ).called(1);
    });
  });
}
