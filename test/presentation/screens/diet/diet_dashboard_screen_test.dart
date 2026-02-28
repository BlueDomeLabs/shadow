// test/presentation/screens/diet/diet_dashboard_screen_test.dart
// Tests for DietDashboardScreen.

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
import 'package:shadow_app/presentation/screens/diet/diet_dashboard_screen.dart';

void main() {
  group('DietDashboardScreen', () {
    const testProfileId = 'profile-001';

    Diet createTestDiet({
      String id = 'diet-001',
      String name = 'My Keto',
      bool isActive = true,
    }) => Diet(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      presetType: DietPresetType.keto,
      isActive: isActive,
      startDate: DateTime(2025).millisecondsSinceEpoch,
      syncMetadata: SyncMetadata.empty(),
    );

    const testStats = ComplianceStats(
      overallScore: 85,
      dailyScore: 90,
      weeklyScore: 80,
      monthlyScore: 85,
      currentStreak: 5,
      longestStreak: 10,
      totalViolations: 2,
      totalWarnings: 1,
      complianceByRule: {},
      recentViolations: [],
      dailyTrend: [],
    );

    Widget buildScreen({
      List<Diet> diets = const [],
      bool dietError = false,
      ComplianceStats? stats,
      bool statsError = false,
    }) => ProviderScope(
      overrides: [
        getDietsUseCaseProvider.overrideWithValue(
          dietError ? _ErrorGetDietsUseCase() : _FakeGetDietsUseCase(diets),
        ),
        createDietUseCaseProvider.overrideWithValue(
          _FakeCreateDietUseCase(createTestDiet()),
        ),
        activateDietUseCaseProvider.overrideWithValue(
          _FakeActivateDietUseCase(createTestDiet()),
        ),
        getComplianceStatsUseCaseProvider.overrideWithValue(
          statsError
              ? _ErrorGetComplianceStatsUseCase()
              : _FakeGetComplianceStatsUseCase(stats ?? testStats),
        ),
        profileAuthorizationServiceProvider.overrideWithValue(
          _FakeAuthService(),
        ),
      ],
      child: const MaterialApp(
        home: DietDashboardScreen(profileId: testProfileId),
      ),
    );

    testWidgets('renders app bar with "Diet Dashboard" title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Diet Dashboard'), findsOneWidget);
    });

    testWidgets('shows "No Active Diet" when no active diet', (tester) async {
      await tester.pumpWidget(buildScreen(diets: []));
      await tester.pumpAndSettle();

      expect(find.text('No Active Diet'), findsOneWidget);
    });

    testWidgets('shows active diet name when one is active', (tester) async {
      final activeDiet = createTestDiet();
      await tester.pumpWidget(buildScreen(diets: [activeDiet]));
      await tester.pumpAndSettle();

      expect(find.text('My Keto'), findsOneWidget);
    });

    testWidgets('shows error widget on diet load failure', (tester) async {
      await tester.pumpWidget(buildScreen(dietError: true));
      await tester.pumpAndSettle();

      expect(find.text('Could not load diet data'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows compliance score sections when stats load', (
      tester,
    ) async {
      final activeDiet = createTestDiet();
      await tester.pumpWidget(buildScreen(diets: [activeDiet]));
      await tester.pumpAndSettle();

      expect(find.text('Compliance Scores'), findsOneWidget);
    });

    testWidgets('shows streak section when stats load', (tester) async {
      final activeDiet = createTestDiet();
      await tester.pumpWidget(buildScreen(diets: [activeDiet]));
      await tester.pumpAndSettle();

      expect(find.text('Streak'), findsOneWidget);
    });

    testWidgets('shows streak count when stats load', (tester) async {
      final activeDiet = createTestDiet();
      await tester.pumpWidget(buildScreen(diets: [activeDiet]));
      await tester.pumpAndSettle();

      expect(find.text('5 day streak'), findsOneWidget);
    });

    testWidgets('shows empty state when stats fail', (tester) async {
      final activeDiet = createTestDiet();
      await tester.pumpWidget(
        buildScreen(diets: [activeDiet], statsError: true),
      );
      await tester.pumpAndSettle();

      expect(find.text('No compliance data yet'), findsOneWidget);
    });

    testWidgets(
      'shows 30-Day Compliance Trend section when dailyTrend non-empty',
      (tester) async {
        final activeDiet = createTestDiet();
        const statsWithTrend = ComplianceStats(
          overallScore: 85,
          dailyScore: 90,
          weeklyScore: 80,
          monthlyScore: 85,
          currentStreak: 5,
          longestStreak: 10,
          totalViolations: 2,
          totalWarnings: 1,
          complianceByRule: {},
          recentViolations: [],
          dailyTrend: [
            DailyCompliance(
              dateEpoch: 1735689600000, // 2025-01-01
              score: 80,
              violations: 0,
              warnings: 0,
            ),
            DailyCompliance(
              dateEpoch: 1735776000000, // 2025-01-02
              score: 90,
              violations: 0,
              warnings: 0,
            ),
          ],
        );
        await tester.pumpWidget(
          buildScreen(diets: [activeDiet], stats: statsWithTrend),
        );
        await tester.pumpAndSettle();

        expect(find.text('30-Day Compliance Trend'), findsOneWidget);
      },
    );

    testWidgets(
      'hides 30-Day Compliance Trend section when dailyTrend is empty',
      (tester) async {
        final activeDiet = createTestDiet();
        // testStats has dailyTrend: [] — the default.
        await tester.pumpWidget(buildScreen(diets: [activeDiet]));
        await tester.pumpAndSettle();

        expect(find.text('30-Day Compliance Trend'), findsNothing);
      },
    );

    testWidgets('no-active-diet empty state renders correctly', (tester) async {
      await tester.pumpWidget(buildScreen(diets: []));
      await tester.pumpAndSettle();

      expect(find.text('No Active Diet'), findsOneWidget);
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

class _FakeGetComplianceStatsUseCase implements GetComplianceStatsUseCase {
  final ComplianceStats _stats;
  _FakeGetComplianceStatsUseCase(this._stats);

  @override
  Future<Result<ComplianceStats, AppError>> call(
    GetComplianceStatsInput input,
  ) async => Success(_stats);
}

class _ErrorGetComplianceStatsUseCase implements GetComplianceStatsUseCase {
  @override
  Future<Result<ComplianceStats, AppError>> call(
    GetComplianceStatsInput input,
  ) async => Failure(DatabaseError.queryFailed('test'));
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
