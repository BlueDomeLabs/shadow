// test/unit/domain/usecases/food_logs/food_log_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/repositories/food_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/food_logs/delete_food_log_use_case.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_log_inputs.dart';
import 'package:shadow_app/domain/usecases/food_logs/get_food_logs_use_case.dart';
import 'package:shadow_app/domain/usecases/food_logs/log_food_use_case.dart';
import 'package:shadow_app/domain/usecases/food_logs/update_food_log_use_case.dart';

@GenerateMocks([
  FoodLogRepository,
  FoodItemRepository,
  ProfileAuthorizationService,
])
import 'food_log_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<FoodLog>, AppError>>(const Success([]));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testClientId = 'client-001';

  final now = DateTime.now().millisecondsSinceEpoch;
  final timestamp = now - (2 * 60 * 60 * 1000); // 2 hours ago

  FoodItem createTestFoodItem({
    String id = 'food-001',
    String profileId = testProfileId,
  }) => FoodItem(
    id: id,
    clientId: testClientId,
    profileId: profileId,
    name: 'Apple',
    syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
  );

  FoodLog createTestFoodLog({
    String id = 'log-001',
    String clientId = testClientId,
    String profileId = testProfileId,
    int? ts,
    List<String> foodItemIds = const ['food-001'],
    List<String> adHocItems = const [],
    String? notes,
    SyncMetadata? syncMetadata,
  }) => FoodLog(
    id: id,
    clientId: clientId,
    profileId: profileId,
    timestamp: ts ?? timestamp,
    foodItemIds: foodItemIds,
    adHocItems: adHocItems,
    notes: notes,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  provideDummy<Result<FoodLog, AppError>>(Success(createTestFoodLog()));
  provideDummy<Result<FoodItem, AppError>>(Success(createTestFoodItem()));

  group('LogFoodUseCase', () {
    late MockFoodLogRepository mockLogRepository;
    late MockFoodItemRepository mockFoodItemRepository;
    late MockProfileAuthorizationService mockAuthService;
    late LogFoodUseCase useCase;

    setUp(() {
      mockLogRepository = MockFoodLogRepository();
      mockFoodItemRepository = MockFoodItemRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = LogFoodUseCase(
        mockLogRepository,
        mockFoodItemRepository,
        mockAuthService,
      );
    });

    test('call_whenAuthorized_createsFoodLog', () async {
      final foodItem = createTestFoodItem();
      final expectedLog = createTestFoodLog();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockFoodItemRepository.getById('food-001'),
      ).thenAnswer((_) async => Success(foodItem));
      when(
        mockLogRepository.create(any),
      ).thenAnswer((_) async => Success(expectedLog));

      final result = await useCase(
        LogFoodInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          foodItemIds: const ['food-001'],
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockAuthService.canWrite(testProfileId)).called(1);
      verify(mockLogRepository.create(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        LogFoodInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          foodItemIds: const ['food-001'],
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockLogRepository.create(any));
    });

    test('call_whenNoFoodItems_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        LogFoodInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          // No food items provided
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockLogRepository.create(any));
    });

    test('call_withAdHocItems_createsLog', () async {
      final expectedLog = createTestFoodLog(
        foodItemIds: [],
        adHocItems: ['Homemade Smoothie'],
      );

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockLogRepository.create(any),
      ).thenAnswer((_) async => Success(expectedLog));

      final result = await useCase(
        LogFoodInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          adHocItems: const ['Homemade Smoothie'],
        ),
      );

      expect(result.isSuccess, isTrue);
    });

    test('call_whenTimestampTooFarInFuture_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final futureTimestamp = now + (2 * 60 * 60 * 1000); // 2 hours from now

      final result = await useCase(
        LogFoodInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: futureTimestamp,
          adHocItems: const ['Breakfast'],
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_whenFoodItemNotFound_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockFoodItemRepository.getById('food-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('FoodItem', 'food-001')),
      );

      final result = await useCase(
        LogFoodInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          foodItemIds: const ['food-001'],
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test(
      'call_whenFoodItemBelongsToDifferentProfile_returnsValidationError',
      () async {
        final otherProfileItem = createTestFoodItem(profileId: 'other-profile');

        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);
        when(
          mockFoodItemRepository.getById('food-001'),
        ).thenAnswer((_) async => Success(otherProfileItem));

        final result = await useCase(
          LogFoodInput(
            profileId: testProfileId,
            clientId: testClientId,
            timestamp: timestamp,
            foodItemIds: const ['food-001'],
          ),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<ValidationError>());
      },
    );
  });

  group('GetFoodLogsUseCase', () {
    late MockFoodLogRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetFoodLogsUseCase useCase;

    setUp(() {
      mockRepository = MockFoodLogRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetFoodLogsUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsLogs', () async {
      final logs = [createTestFoodLog()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(logs));

      final result = await useCase(
        const GetFoodLogsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, logs);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetFoodLogsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenStartDateAfterEndDate_returnsValidationError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        GetFoodLogsInput(
          profileId: testProfileId,
          startDate: timestamp + 1000,
          endDate: timestamp,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });

  group('UpdateFoodLogUseCase', () {
    late MockFoodLogRepository mockLogRepository;
    late MockFoodItemRepository mockFoodItemRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateFoodLogUseCase useCase;

    setUp(() {
      mockLogRepository = MockFoodLogRepository();
      mockFoodItemRepository = MockFoodItemRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateFoodLogUseCase(
        mockLogRepository,
        mockFoodItemRepository,
        mockAuthService,
      );
    });

    test('call_whenAuthorized_updatesLog', () async {
      final existing = createTestFoodLog();
      final foodItem = createTestFoodItem();
      final updated = existing.copyWith(notes: 'Updated notes');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockLogRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockFoodItemRepository.getById('food-001'),
      ).thenAnswer((_) async => Success(foodItem));
      when(
        mockLogRepository.update(any),
      ).thenAnswer((_) async => Success(updated));

      final result = await useCase(
        const UpdateFoodLogInput(
          id: 'log-001',
          profileId: testProfileId,
          notes: 'Updated notes',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockLogRepository.update(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const UpdateFoodLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenLogNotFound_returnsError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockLogRepository.getById('log-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('FoodLog', 'log-001')),
      );

      final result = await useCase(
        const UpdateFoodLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });
  });

  group('DeleteFoodLogUseCase', () {
    late MockFoodLogRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late DeleteFoodLogUseCase useCase;

    setUp(() {
      mockRepository = MockFoodLogRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = DeleteFoodLogUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_deletesLog', () async {
      final existing = createTestFoodLog();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.delete('log-001'),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const DeleteFoodLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.delete('log-001')).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const DeleteFoodLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenLogNotFound_returnsError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('log-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('FoodLog', 'log-001')),
      );

      final result = await useCase(
        const DeleteFoodLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });

    test('call_whenLogBelongsToDifferentProfile_returnsAuthError', () async {
      final existing = createTestFoodLog(profileId: 'other-profile');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const DeleteFoodLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });
}
