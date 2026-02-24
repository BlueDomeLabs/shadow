// test/presentation/screens/diet/diet_list_screen_test.dart
// Tests for DietListScreen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/diet/diets_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/diet/diet_list_screen.dart';

void main() {
  group('DietListScreen', () {
    const testProfileId = 'profile-001';

    Diet createTestDiet({
      String id = 'diet-001',
      String name = 'My Custom Diet',
      bool isActive = false,
      DietPresetType presetType = DietPresetType.custom,
    }) => Diet(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      presetType: presetType,
      isActive: isActive,
      startDate: DateTime(2025).millisecondsSinceEpoch,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildScreen({List<Diet> diets = const [], bool error = false}) =>
        ProviderScope(
          overrides: [
            getDietsUseCaseProvider.overrideWithValue(
              error ? _ErrorGetDietsUseCase() : _FakeGetDietsUseCase(diets),
            ),
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
          child: const MaterialApp(
            home: DietListScreen(profileId: testProfileId),
          ),
        );

    testWidgets('renders app bar with "Diet" title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Diet'), findsOneWidget);
    });

    testWidgets('shows "No Diet Selected" when no active diet', (tester) async {
      await tester.pumpWidget(buildScreen(diets: [createTestDiet()]));
      await tester.pumpAndSettle();

      expect(find.text('No Diet Selected'), findsOneWidget);
    });

    testWidgets('shows active diet name when one is active', (tester) async {
      final activeDiet = createTestDiet(
        name: 'Keto Diet',
        isActive: true,
        presetType: DietPresetType.keto,
      );
      await tester.pumpWidget(buildScreen(diets: [activeDiet]));
      await tester.pumpAndSettle();

      expect(find.text('Keto Diet'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('shows preset diet section', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Preset Diets'), findsOneWidget);
    });

    testWidgets('shows custom diets section when custom diets exist', (
      tester,
    ) async {
      final customDiet = createTestDiet(name: 'My Custom');
      // Use a tall viewport so the custom diets section (after 19 preset cards)
      // is rendered in the widget tree.
      tester.view.physicalSize = const Size(800, 5000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildScreen(diets: [customDiet]));
      await tester.pumpAndSettle();

      expect(find.text('My Custom Diets'), findsOneWidget);
    });

    testWidgets('shows FAB for creating custom diet', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Custom Diet'), findsOneWidget);
    });

    testWidgets('shows error widget on load failure', (tester) async {
      await tester.pumpWidget(buildScreen(error: true));
      await tester.pumpAndSettle();

      expect(find.text('Could not load diets'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows "Current Diet" section header', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Current Diet'), findsOneWidget);
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
  _FakeCreateDietUseCase(this._diet);

  @override
  Future<Result<Diet, AppError>> call(CreateDietInput input) async =>
      Success(_diet);
}

class _FakeActivateDietUseCase implements ActivateDietUseCase {
  final Diet _diet;
  _FakeActivateDietUseCase(this._diet);

  @override
  Future<Result<Diet, AppError>> call(ActivateDietInput input) async =>
      Success(_diet);
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
