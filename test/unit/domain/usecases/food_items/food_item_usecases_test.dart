// test/unit/domain/usecases/food_items/food_item_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/food_items/archive_food_item_use_case.dart';
import 'package:shadow_app/domain/usecases/food_items/create_food_item_use_case.dart';
import 'package:shadow_app/domain/usecases/food_items/food_item_inputs.dart';
import 'package:shadow_app/domain/usecases/food_items/get_food_items_use_case.dart';
import 'package:shadow_app/domain/usecases/food_items/search_food_items_use_case.dart';
import 'package:shadow_app/domain/usecases/food_items/update_food_item_use_case.dart';

@GenerateMocks([FoodItemRepository, ProfileAuthorizationService])
import 'food_item_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<FoodItem>, AppError>>(const Success([]));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testClientId = 'client-001';

  FoodItem createTestFoodItem({
    String id = 'food-001',
    String clientId = testClientId,
    String profileId = testProfileId,
    String name = 'Apple',
    FoodItemType type = FoodItemType.simple,
    List<String> simpleItemIds = const [],
    bool isArchived = false,
    double? calories,
    SyncMetadata? syncMetadata,
  }) => FoodItem(
    id: id,
    clientId: clientId,
    profileId: profileId,
    name: name,
    type: type,
    simpleItemIds: simpleItemIds,
    isArchived: isArchived,
    calories: calories,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  provideDummy<Result<FoodItem, AppError>>(Success(createTestFoodItem()));

  group('CreateFoodItemUseCase', () {
    late MockFoodItemRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late CreateFoodItemUseCase useCase;

    setUp(() {
      mockRepository = MockFoodItemRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = CreateFoodItemUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_createsFoodItem', () async {
      final expectedItem = createTestFoodItem();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.create(any),
      ).thenAnswer((_) async => Success(expectedItem));

      final result = await useCase(
        const CreateFoodItemInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'Apple',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockAuthService.canWrite(testProfileId)).called(1);
      verify(mockRepository.create(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const CreateFoodItemInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'Apple',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenNameTooShort_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateFoodItemInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'A', // Too short
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test(
      'call_whenComplexItemWithoutComponents_returnsValidationError',
      () async {
        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);

        final result = await useCase(
          const CreateFoodItemInput(
            profileId: testProfileId,
            clientId: testClientId,
            name: 'Salad Bowl',
            type: FoodItemType.complex,
            // Complex item without components - simpleItemIds defaults to []
          ),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<ValidationError>());
      },
    );

    test('call_whenSimpleItemWithComponents_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateFoodItemInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'Apple',
          // type defaults to FoodItemType.simple
          simpleItemIds: ['item-1'], // Simple item should not have components
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_whenNegativeCalories_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateFoodItemInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'Apple',
          calories: -10, // Negative calories
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });

  group('GetFoodItemsUseCase', () {
    late MockFoodItemRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetFoodItemsUseCase useCase;

    setUp(() {
      mockRepository = MockFoodItemRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetFoodItemsUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsFoodItems', () async {
      final items = [createTestFoodItem()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(items));

      final result = await useCase(
        const GetFoodItemsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, items);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetFoodItemsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });

  group('SearchFoodItemsUseCase', () {
    late MockFoodItemRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late SearchFoodItemsUseCase useCase;

    setUp(() {
      mockRepository = MockFoodItemRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = SearchFoodItemsUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_searchesFoodItems', () async {
      final items = [createTestFoodItem()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.search(testProfileId, 'apple'),
      ).thenAnswer((_) async => Success(items));

      final result = await useCase(
        const SearchFoodItemsInput(profileId: testProfileId, query: 'apple'),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, items);
    });

    test('call_whenEmptyQuery_returnsValidationError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const SearchFoodItemsInput(
          profileId: testProfileId,
          query: '   ', // Empty/whitespace query
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });

  group('UpdateFoodItemUseCase', () {
    late MockFoodItemRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateFoodItemUseCase useCase;

    setUp(() {
      mockRepository = MockFoodItemRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateFoodItemUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_updatesFoodItem', () async {
      final existing = createTestFoodItem();
      final updated = existing.copyWith(name: 'Green Apple');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('food-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(updated));

      final result = await useCase(
        const UpdateFoodItemInput(
          id: 'food-001',
          profileId: testProfileId,
          name: 'Green Apple',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.update(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const UpdateFoodItemInput(id: 'food-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenItemNotFound_returnsError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('food-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('FoodItem', 'food-001')),
      );

      final result = await useCase(
        const UpdateFoodItemInput(id: 'food-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });

    test('call_whenItemBelongsToDifferentProfile_returnsAuthError', () async {
      final existing = createTestFoodItem(profileId: 'other-profile');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('food-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateFoodItemInput(id: 'food-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });

  group('ArchiveFoodItemUseCase', () {
    late MockFoodItemRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late ArchiveFoodItemUseCase useCase;

    setUp(() {
      mockRepository = MockFoodItemRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = ArchiveFoodItemUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_archivesFoodItem', () async {
      final existing = createTestFoodItem();
      final archived = existing.copyWith(isArchived: true);

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('food-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(archived));

      final result = await useCase(
        const ArchiveFoodItemInput(id: 'food-001', profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.update(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const ArchiveFoodItemInput(id: 'food-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_withArchiveFalse_unarchivesFoodItem', () async {
      final existing = createTestFoodItem(isArchived: true);
      final unarchived = existing.copyWith(isArchived: false);

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('food-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(unarchived));

      final result = await useCase(
        const ArchiveFoodItemInput(
          id: 'food-001',
          profileId: testProfileId,
          archive: false,
        ),
      );

      expect(result.isSuccess, isTrue);
    });
  });
}
