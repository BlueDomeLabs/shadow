// test/unit/domain/usecases/health/health_usecases_test.dart
// Phase 16a — Tests for health platform use cases
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/health_sync_settings.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart';
import 'package:shadow_app/domain/entities/imported_vital.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/health_sync_settings_repository.dart';
import 'package:shadow_app/domain/repositories/health_sync_status_repository.dart';
import 'package:shadow_app/domain/repositories/imported_vital_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/health/get_imported_vitals_use_case.dart';
import 'package:shadow_app/domain/usecases/health/get_last_sync_status_use_case.dart';
import 'package:shadow_app/domain/usecases/health/health_types.dart';
import 'package:shadow_app/domain/usecases/health/update_health_sync_settings_use_case.dart';

@GenerateMocks([
  ImportedVitalRepository,
  HealthSyncStatusRepository,
  HealthSyncSettingsRepository,
  ProfileAuthorizationService,
])
import 'health_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<ImportedVital>, AppError>>(const Success([]));
  provideDummy<Result<List<HealthSyncStatus>, AppError>>(const Success([]));
  provideDummy<Result<HealthSyncSettings?, AppError>>(const Success(null));
  provideDummy<Result<HealthSyncSettings, AppError>>(
    const Success(HealthSyncSettings(id: 'dummy', profileId: 'dummy')),
  );
  provideDummy<Result<int?, AppError>>(const Success(null));
  provideDummy<Result<int, AppError>>(const Success(0));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';

  ImportedVital makeVital({
    String id = 'vital-001',
    HealthDataType dataType = HealthDataType.heartRate,
  }) => ImportedVital(
    id: id,
    clientId: 'client-001',
    profileId: testProfileId,
    dataType: dataType,
    value: 72,
    unit: 'bpm',
    recordedAt: 1704067200000,
    sourcePlatform: HealthSourcePlatform.appleHealth,
    importedAt: 1704067200000,
    syncMetadata: const SyncMetadata(
      syncCreatedAt: 1704067200000,
      syncUpdatedAt: 1704067200000,
      syncDeviceId: 'device',
    ),
  );

  HealthSyncStatus makeStatus({
    HealthDataType dataType = HealthDataType.heartRate,
    int? lastSyncedAt,
    int recordCount = 0,
  }) => HealthSyncStatus(
    id: HealthSyncStatus.makeId(testProfileId, dataType),
    profileId: testProfileId,
    dataType: dataType,
    lastSyncedAt: lastSyncedAt,
    recordCount: recordCount,
  );

  // ============================================================
  // GetImportedVitalsUseCase
  // ============================================================

  group('GetImportedVitalsUseCase', () {
    late MockImportedVitalRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late GetImportedVitalsUseCase useCase;

    setUp(() {
      mockRepo = MockImportedVitalRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = GetImportedVitalsUseCase(mockRepo, mockAuth);
    });

    test('returns access denied when profile not readable', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const GetImportedVitalsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      verifyNever(mockRepo.getByProfile(profileId: anyNamed('profileId')));
    });

    test('returns vitals for authorized profile', () async {
      final vitals = [makeVital(), makeVital(id: 'vital-002')];
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(profileId: testProfileId),
      ).thenAnswer((_) async => Success(vitals));

      final result = await useCase(
        const GetImportedVitalsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.length, 2);
    });

    test('passes all filters to repository', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(
          profileId: testProfileId,
          startEpoch: 1000,
          endEpoch: 2000,
          dataType: HealthDataType.weight,
        ),
      ).thenAnswer((_) async => const Success([]));

      await useCase(
        const GetImportedVitalsInput(
          profileId: testProfileId,
          startEpoch: 1000,
          endEpoch: 2000,
          dataType: HealthDataType.weight,
        ),
      );

      verify(
        mockRepo.getByProfile(
          profileId: testProfileId,
          startEpoch: 1000,
          endEpoch: 2000,
          dataType: HealthDataType.weight,
        ),
      ).called(1);
    });

    test('propagates repository failure', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(
          profileId: anyNamed('profileId'),
          startEpoch: anyNamed('startEpoch'),
          endEpoch: anyNamed('endEpoch'),
          dataType: anyNamed('dataType'),
        ),
      ).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed('imported_vitals', 'err', StackTrace.empty),
        ),
      );

      final result = await useCase(
        const GetImportedVitalsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
    });
  });

  // ============================================================
  // GetLastSyncStatusUseCase
  // ============================================================

  group('GetLastSyncStatusUseCase', () {
    late MockHealthSyncStatusRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late GetLastSyncStatusUseCase useCase;

    setUp(() {
      mockRepo = MockHealthSyncStatusRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = GetLastSyncStatusUseCase(mockRepo, mockAuth);
    });

    test('returns access denied when profile not readable', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const GetLastSyncStatusInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      verifyNever(mockRepo.getByProfile(any));
    });

    test('returns status list for authorized profile', () async {
      final statuses = [
        makeStatus(lastSyncedAt: 1000000),
        makeStatus(dataType: HealthDataType.weight, recordCount: 5),
      ];
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(statuses));

      final result = await useCase(
        const GetLastSyncStatusInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.length, 2);
    });

    test('returns empty list when no statuses exist', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => const Success([]));

      final result = await useCase(
        const GetLastSyncStatusInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isEmpty);
    });

    test('propagates repository failure', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(mockRepo.getByProfile(testProfileId)).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed(
            'health_sync_status',
            'err',
            StackTrace.empty,
          ),
        ),
      );

      final result = await useCase(
        const GetLastSyncStatusInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
    });
  });

  // ============================================================
  // UpdateHealthSyncSettingsUseCase
  // ============================================================

  group('UpdateHealthSyncSettingsUseCase', () {
    late MockHealthSyncSettingsRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late UpdateHealthSyncSettingsUseCase useCase;

    final defaultSettings = HealthSyncSettings(
      id: testProfileId,
      profileId: testProfileId,
      enabledDataTypes: HealthDataType.values.toList(),
    );

    setUp(() {
      mockRepo = MockHealthSyncSettingsRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = UpdateHealthSyncSettingsUseCase(mockRepo, mockAuth);
    });

    test('returns access denied when profile not writable', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const UpdateHealthSyncSettingsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      verifyNever(mockRepo.getByProfile(any));
      verifyNever(mockRepo.save(any));
    });

    test('creates default settings when none exist', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => const Success(null));
      when(
        mockRepo.save(any),
      ).thenAnswer((_) async => Success(defaultSettings));

      final result = await useCase(
        const UpdateHealthSyncSettingsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepo.save(any)).called(1);
    });

    test('updates enabledDataTypes when provided', () async {
      final existing = HealthSyncSettings(
        id: testProfileId,
        profileId: testProfileId,
        enabledDataTypes: HealthDataType.values.toList(),
      );
      final newTypes = [HealthDataType.heartRate, HealthDataType.weight];

      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(existing));
      when(mockRepo.save(any)).thenAnswer(
        (inv) async =>
            Success(inv.positionalArguments[0] as HealthSyncSettings),
      );

      final result = await useCase(
        UpdateHealthSyncSettingsInput(
          profileId: testProfileId,
          enabledDataTypes: newTypes,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.enabledDataTypes, newTypes);
    });

    test('updates dateRangeDays when provided', () async {
      const existing = HealthSyncSettings(
        id: testProfileId,
        profileId: testProfileId,
      );

      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => const Success(existing));
      when(mockRepo.save(any)).thenAnswer(
        (inv) async =>
            Success(inv.positionalArguments[0] as HealthSyncSettings),
      );

      final result = await useCase(
        const UpdateHealthSyncSettingsInput(
          profileId: testProfileId,
          dateRangeDays: 90,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.dateRangeDays, 90);
    });

    test('preserves existing values for null input fields', () async {
      const existing = HealthSyncSettings(
        id: testProfileId,
        profileId: testProfileId,
        enabledDataTypes: [HealthDataType.steps],
        dateRangeDays: 60,
      );

      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => const Success(existing));
      when(mockRepo.save(any)).thenAnswer(
        (inv) async =>
            Success(inv.positionalArguments[0] as HealthSyncSettings),
      );

      final result = await useCase(
        const UpdateHealthSyncSettingsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.enabledDataTypes, [HealthDataType.steps]);
      expect(result.valueOrNull?.dateRangeDays, 60);
    });

    test('propagates getByProfile failure', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockRepo.getByProfile(testProfileId)).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed(
            'health_sync_settings',
            'err',
            StackTrace.empty,
          ),
        ),
      );

      final result = await useCase(
        const UpdateHealthSyncSettingsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      verifyNever(mockRepo.save(any));
    });

    test('propagates save failure', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => const Success(null));
      when(mockRepo.save(any)).thenAnswer(
        (_) async => Failure(
          DatabaseError.insertFailed(
            'health_sync_settings',
            Exception('err'),
            StackTrace.empty,
          ),
        ),
      );

      final result = await useCase(
        const UpdateHealthSyncSettingsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
    });
  });
}
