// test/presentation/screens/diet/diet_edit_screen_test.dart
// Tests for DietEditScreen.

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
import 'package:shadow_app/presentation/screens/diet/diet_edit_screen.dart';

void main() {
  group('DietEditScreen', () {
    const testProfileId = 'profile-001';

    Diet createTestDiet({
      String id = 'diet-001',
      String name = 'My Custom Diet',
    }) => Diet(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      presetType: DietPresetType.custom,
      startDate: DateTime(2025).millisecondsSinceEpoch,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildCreateScreen() => ProviderScope(
      overrides: [
        getDietsUseCaseProvider.overrideWithValue(_FakeGetDietsUseCase([])),
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
      child: const MaterialApp(home: DietEditScreen(profileId: testProfileId)),
    );

    Widget buildEditScreen() => ProviderScope(
      overrides: [
        getDietsUseCaseProvider.overrideWithValue(_FakeGetDietsUseCase([])),
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
      child: MaterialApp(
        home: DietEditScreen(
          profileId: testProfileId,
          existingDiet: createTestDiet(),
        ),
      ),
    );

    testWidgets('renders "Custom Diet" title when creating', (tester) async {
      await tester.pumpWidget(buildCreateScreen());
      await tester.pumpAndSettle();

      expect(find.text('Custom Diet'), findsOneWidget);
    });

    testWidgets('renders "Edit Diet" title when editing', (tester) async {
      await tester.pumpWidget(buildEditScreen());
      await tester.pumpAndSettle();

      expect(find.text('Edit Diet'), findsOneWidget);
    });

    testWidgets('shows "Diet Name" section header', (tester) async {
      await tester.pumpWidget(buildCreateScreen());
      await tester.pumpAndSettle();

      expect(find.text('Diet Name'), findsOneWidget);
    });

    testWidgets('shows description field', (tester) async {
      await tester.pumpWidget(buildCreateScreen());
      await tester.pumpAndSettle();

      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('shows eating window section', (tester) async {
      await tester.pumpWidget(buildCreateScreen());
      await tester.pumpAndSettle();

      expect(find.text('Eating Window'), findsOneWidget);
    });

    testWidgets('shows food exclusions section', (tester) async {
      await tester.pumpWidget(buildCreateScreen());
      await tester.pumpAndSettle();

      expect(find.text('Food Exclusions'), findsOneWidget);
    });

    testWidgets('pre-fills name when editing', (tester) async {
      await tester.pumpWidget(buildEditScreen());
      await tester.pumpAndSettle();

      expect(find.text('My Custom Diet'), findsOneWidget);
    });

    testWidgets('shows validation error when name is too short', (
      tester,
    ) async {
      await tester.pumpWidget(buildCreateScreen());
      await tester.pumpAndSettle();

      // Entering a single character triggers validation via onChanged
      await tester.enterText(
        find.widgetWithText(TextField, 'e.g. My Keto Plan'),
        'a',
      );
      await tester.pump();

      expect(find.textContaining('at least'), findsOneWidget);
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
