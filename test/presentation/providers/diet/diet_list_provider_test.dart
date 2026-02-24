// test/presentation/providers/diet/diet_list_provider_test.dart
// Tests for DietList provider.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/diet/activate_diet_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/create_diet_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';
import 'package:shadow_app/domain/usecases/diet/get_diets_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/diet/diet_list_provider.dart';

void main() {
  group('DietList', () {
    const testProfileId = 'profile-001';

    Diet createTestDiet({
      String id = 'diet-001',
      String name = 'My Custom Diet',
      bool isActive = false,
    }) => Diet(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      presetType: DietPresetType.custom,
      isActive: isActive,
      startDate: DateTime(2025).millisecondsSinceEpoch,
      syncMetadata: SyncMetadata.empty(),
    );

    ProviderContainer buildContainer({
      required List<Diet> diets,
      bool canWrite = true,
    }) => ProviderContainer(
      overrides: [
        getDietsUseCaseProvider.overrideWithValue(_FakeGetDietsUseCase(diets)),
        createDietUseCaseProvider.overrideWithValue(
          _FakeCreateDietUseCase(createTestDiet()),
        ),
        activateDietUseCaseProvider.overrideWithValue(
          _FakeActivateDietUseCase(createTestDiet()),
        ),
        profileAuthorizationServiceProvider.overrideWithValue(
          _FakeAuthService(canWrite: canWrite),
        ),
      ],
    );

    test('build loads diets for profile', () async {
      final diets = [createTestDiet(), createTestDiet(id: 'diet-002')];
      final container = buildContainer(diets: diets);
      addTearDown(container.dispose);

      final result = await container.read(
        dietListProvider(testProfileId).future,
      );

      expect(result, hasLength(2));
      expect(result.first.id, 'diet-001');
    });

    test('build returns empty list when no diets', () async {
      final container = buildContainer(diets: []);
      addTearDown(container.dispose);

      final result = await container.read(
        dietListProvider(testProfileId).future,
      );

      expect(result, isEmpty);
    });

    test('build throws on use case failure', () async {
      final container = ProviderContainer(
        overrides: [
          getDietsUseCaseProvider.overrideWithValue(_ErrorGetDietsUseCase()),
          createDietUseCaseProvider.overrideWithValue(
            _FakeCreateDietUseCase(createTestDiet()),
          ),
          activateDietUseCaseProvider.overrideWithValue(
            _FakeActivateDietUseCase(createTestDiet()),
          ),
          profileAuthorizationServiceProvider.overrideWithValue(
            _FakeAuthService(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(dietListProvider(testProfileId).future),
        throwsA(isA<AppError>()),
      );
    });

    test('create calls use case and refreshes', () async {
      final fakeCreate = _FakeCreateDietUseCase(createTestDiet());
      final container = ProviderContainer(
        overrides: [
          getDietsUseCaseProvider.overrideWithValue(_FakeGetDietsUseCase([])),
          createDietUseCaseProvider.overrideWithValue(fakeCreate),
          activateDietUseCaseProvider.overrideWithValue(
            _FakeActivateDietUseCase(createTestDiet()),
          ),
          profileAuthorizationServiceProvider.overrideWithValue(
            _FakeAuthService(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(dietListProvider(testProfileId).future);

      await container
          .read(dietListProvider(testProfileId).notifier)
          .create(
            const CreateDietInput(
              profileId: testProfileId,
              clientId: 'client-001',
              name: 'Test Diet',
              presetType: DietPresetType.custom,
            ),
          );

      expect(fakeCreate.wasCalled, isTrue);
    });

    test('create throws AuthError when write not allowed', () async {
      final container = buildContainer(diets: [], canWrite: false);
      addTearDown(container.dispose);

      await container.read(dietListProvider(testProfileId).future);

      await expectLater(
        container
            .read(dietListProvider(testProfileId).notifier)
            .create(
              const CreateDietInput(
                profileId: testProfileId,
                clientId: 'client-001',
                name: 'Test',
                presetType: DietPresetType.custom,
              ),
            ),
        throwsA(isA<AuthError>()),
      );
    });

    test('activate calls use case and refreshes', () async {
      final testDiet = createTestDiet();
      final fakeActivate = _FakeActivateDietUseCase(testDiet);
      final container = ProviderContainer(
        overrides: [
          getDietsUseCaseProvider.overrideWithValue(
            _FakeGetDietsUseCase([testDiet]),
          ),
          createDietUseCaseProvider.overrideWithValue(
            _FakeCreateDietUseCase(testDiet),
          ),
          activateDietUseCaseProvider.overrideWithValue(fakeActivate),
          profileAuthorizationServiceProvider.overrideWithValue(
            _FakeAuthService(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(dietListProvider(testProfileId).future);

      await container
          .read(dietListProvider(testProfileId).notifier)
          .activate(
            const ActivateDietInput(
              profileId: testProfileId,
              dietId: 'diet-001',
            ),
          );

      expect(fakeActivate.wasCalled, isTrue);
    });

    test('activate throws AuthError when write not allowed', () async {
      final container = buildContainer(diets: [], canWrite: false);
      addTearDown(container.dispose);

      await container.read(dietListProvider(testProfileId).future);

      await expectLater(
        container
            .read(dietListProvider(testProfileId).notifier)
            .activate(
              const ActivateDietInput(
                profileId: testProfileId,
                dietId: 'diet-001',
              ),
            ),
        throwsA(isA<AuthError>()),
      );
    });
  });
}

// Fake use cases

class _FakeGetDietsUseCase implements GetDietsUseCase {
  final List<Diet> _diets;
  _FakeGetDietsUseCase(this._diets);

  @override
  Future<Result<List<Diet>, AppError>> call(GetDietsInput input) async =>
      Success(_diets);
}

class _ErrorGetDietsUseCase implements GetDietsUseCase {
  @override
  Future<Result<List<Diet>, AppError>> call(GetDietsInput input) async =>
      Failure(DatabaseError.queryFailed('test'));
}

class _FakeCreateDietUseCase implements CreateDietUseCase {
  final Diet _diet;
  bool wasCalled = false;
  _FakeCreateDietUseCase(this._diet);

  @override
  Future<Result<Diet, AppError>> call(CreateDietInput input) async {
    wasCalled = true;
    return Success(_diet);
  }
}

class _FakeActivateDietUseCase implements ActivateDietUseCase {
  final Diet _diet;
  bool wasCalled = false;
  _FakeActivateDietUseCase(this._diet);

  @override
  Future<Result<Diet, AppError>> call(ActivateDietInput input) async {
    wasCalled = true;
    return Success(_diet);
  }
}

class _FakeAuthService implements ProfileAuthorizationService {
  final bool _canWrite;
  _FakeAuthService({bool canWrite = true}) : _canWrite = canWrite;

  @override
  Future<bool> canRead(String profileId) async => true;

  @override
  Future<bool> canWrite(String profileId) async => _canWrite;

  @override
  Future<bool> isOwner(String profileId) async => true;

  @override
  Future<List<ProfileAccess>> getAccessibleProfiles() async => [];
}
