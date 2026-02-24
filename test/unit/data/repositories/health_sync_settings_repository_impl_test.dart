// test/unit/data/repositories/health_sync_settings_repository_impl_test.dart
// Phase 16a — Tests for HealthSyncSettingsRepositoryImpl
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/health_sync_settings_dao.dart';
import 'package:shadow_app/data/repositories/health_sync_settings_repository_impl.dart';
import 'package:shadow_app/domain/entities/health_sync_settings.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

@GenerateMocks([HealthSyncSettingsDao])
import 'health_sync_settings_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<HealthSyncSettings?, AppError>>(const Success(null));
  provideDummy<Result<HealthSyncSettings, AppError>>(
    const Success(HealthSyncSettings(id: 'dummy', profileId: 'dummy')),
  );

  group('HealthSyncSettingsRepositoryImpl', () {
    late MockHealthSyncSettingsDao mockDao;
    late HealthSyncSettingsRepositoryImpl repository;

    const testProfileId = 'profile-001';

    const testSettings = HealthSyncSettings(
      id: testProfileId,
      profileId: testProfileId,
      enabledDataTypes: [HealthDataType.heartRate, HealthDataType.weight],
    );

    final testAppError = DatabaseError.queryFailed(
      'health_sync_settings',
      'test error',
      StackTrace.empty,
    );

    setUp(() {
      mockDao = MockHealthSyncSettingsDao();
      repository = HealthSyncSettingsRepositoryImpl(mockDao);
    });

    group('getByProfile', () {
      test('delegates to DAO and returns settings when found', () async {
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => const Success(testSettings));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, testSettings);
      });

      test('returns null when no settings exist', () async {
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });

      test('propagates DAO failure', () async {
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Failure(testAppError));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isFailure, isTrue);
      });
    });

    group('save', () {
      test('delegates to DAO and returns saved settings', () async {
        when(
          mockDao.save(testSettings),
        ).thenAnswer((_) async => const Success(testSettings));

        final result = await repository.save(testSettings);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, testSettings);
      });

      test('propagates DAO failure', () async {
        when(mockDao.save(any)).thenAnswer((_) async => Failure(testAppError));

        final result = await repository.save(testSettings);

        expect(result.isFailure, isTrue);
      });

      test('passes settings to DAO without modification', () async {
        when(
          mockDao.save(testSettings),
        ).thenAnswer((_) async => const Success(testSettings));

        await repository.save(testSettings);

        verify(mockDao.save(testSettings)).called(1);
      });
    });
  });
}
