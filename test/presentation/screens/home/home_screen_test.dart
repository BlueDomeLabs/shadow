// test/presentation/screens/home/home_screen_test.dart
// Tests for HomeScreen 9-tab navigation shell.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/notification_tap_handler.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';
import 'package:shadow_app/domain/repositories/bodily_output_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart'
    show ProfileAccess, ProfileAuthorizationService;
import 'package:shadow_app/domain/usecases/bodily_output/get_bodily_outputs_use_case.dart';
import 'package:shadow_app/presentation/providers/bodily_output_providers.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HomeScreen', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    const testProfileId = 'test-profile-001';

    Widget buildScreen() => ProviderScope(
      overrides: [
        notificationTapHandlerProvider.overrideWithValue(
          NotificationTapHandler(),
        ),
        // Always override profileProvider — avoids UnimplementedError from
        // repository/service providers not wired in tests.
        profileProvider.overrideWith(
          (ref) => ProfileNotifier.forTesting(
            const ProfileState(currentProfileId: testProfileId),
          ),
        ),
        // Override bodily output use case so BodilyOutputListScreen doesn't
        // throw UnimplementedError from the uninitialized repository.
        getBodilyOutputsUseCaseProvider.overrideWithValue(
          _StubGetBodilyOutputsUseCase(),
        ),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );

    testWidgets('renders bottom navigation with 9 tabs', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Supplements'), findsWidgets);
      expect(find.text('Photos'), findsOneWidget);
      expect(find.text('Food'), findsWidgets);
      expect(find.text('Conditions'), findsWidgets);
      expect(find.text('Bodily Functions'), findsOneWidget);
      expect(find.text('Activities'), findsWidgets);
      expect(find.text('Sleep'), findsWidgets);
      expect(find.text('Reports'), findsWidgets);
    });

    testWidgets('shows Home tab by default', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      // Home tab shows Shadow branding and quick action buttons
      expect(find.text('Shadow'), findsOneWidget);
      expect(find.text('Personal Health Tracking'), findsOneWidget);
    });

    testWidgets('shows quick action buttons on Home tab', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Report a Flare-Up'), findsOneWidget);
      expect(find.text('Report Supplements'), findsOneWidget);
      expect(find.text('Log Food'), findsOneWidget);
      expect(find.text('Log Body Output'), findsOneWidget);
      expect(find.text('Journal'), findsOneWidget);
    });

    testWidgets('switches to Supplements tab on tap', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      // Tap Supplements in the bottom nav
      await tester.tap(find.text('Supplements').last);
      await tester.pump();

      expect(find.text('Daily Protocol'), findsOneWidget);
    });

    testWidgets('switches to Food tab on tap', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      // Tap Food in the bottom nav
      await tester.tap(find.text('Food').last);
      await tester.pump();

      expect(find.text('Food Library'), findsOneWidget);
    });

    group('guest mode', () {
      testWidgets('guest mode hides profile card and shows guest header', (
        tester,
      ) async {
        final container = ProviderContainer(
          overrides: [
            notificationTapHandlerProvider.overrideWithValue(
              NotificationTapHandler(),
            ),
            profileProvider.overrideWith(
              (ref) => ProfileNotifier.forTesting(
                const ProfileState(currentProfileId: testProfileId),
              ),
            ),
            getBodilyOutputsUseCaseProvider.overrideWithValue(
              _StubGetBodilyOutputsUseCase(),
            ),
          ],
        );
        addTearDown(container.dispose);

        // Activate guest mode
        container
            .read(guestModeProvider.notifier)
            .activateGuestMode(
              profileId: 'guest-profile-001',
              token: 'guest-token-abc',
            );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: HomeScreen()),
          ),
        );
        await tester.pump();

        // Guest header should be visible
        expect(find.textContaining('Guest Access'), findsOneWidget);

        // Profile card with "Tap to switch profile" should be hidden
        expect(find.text('Tap to switch profile'), findsNothing);
      });

      testWidgets('guest mode hides cloud sync button', (tester) async {
        final container = ProviderContainer(
          overrides: [
            notificationTapHandlerProvider.overrideWithValue(
              NotificationTapHandler(),
            ),
            profileProvider.overrideWith(
              (ref) => ProfileNotifier.forTesting(
                const ProfileState(currentProfileId: testProfileId),
              ),
            ),
            getBodilyOutputsUseCaseProvider.overrideWithValue(
              _StubGetBodilyOutputsUseCase(),
            ),
          ],
        );
        addTearDown(container.dispose);

        // Activate guest mode
        container
            .read(guestModeProvider.notifier)
            .activateGuestMode(
              profileId: 'guest-profile-001',
              token: 'guest-token-abc',
            );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: HomeScreen()),
          ),
        );
        await tester.pump();

        // Cloud sync icon should be hidden
        expect(find.byIcon(Icons.cloud_sync), findsNothing);
      });

      testWidgets('host mode shows profile card normally', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pump();

        // Profile card should be visible (no guest header)
        expect(find.textContaining('Guest Access'), findsNothing);
      });
    });
  });
}

/// Stub use case that always returns an empty list — avoids wiring the
/// bodily output repository in home_screen widget tests.
class _StubGetBodilyOutputsUseCase extends GetBodilyOutputsUseCase {
  _StubGetBodilyOutputsUseCase()
    : super(_StubBodilyOutputRepository(), _StubAuthService());

  @override
  Future<Result<List<BodilyOutputLog>, AppError>> execute(
    String profileId, {
    int? from,
    int? to,
    BodyOutputType? type,
  }) async => const Success([]);
}

class _StubBodilyOutputRepository implements BodilyOutputRepository {
  @override
  Future<Result<void, AppError>> log(BodilyOutputLog entry) async =>
      const Success(null);

  @override
  Future<Result<List<BodilyOutputLog>, AppError>> getAll(
    String profileId, {
    int? from,
    int? to,
    BodyOutputType? type,
  }) async => const Success([]);

  @override
  Future<Result<BodilyOutputLog, AppError>> getById(String id) async => Failure(
    DatabaseError.queryFailed(
      'bodily_output_logs',
      'not found',
      StackTrace.empty,
    ),
  );

  @override
  Future<Result<void, AppError>> update(BodilyOutputLog entry) async =>
      const Success(null);

  @override
  Future<Result<void, AppError>> delete(String profileId, String id) async =>
      const Success(null);
}

class _StubAuthService implements ProfileAuthorizationService {
  @override
  Future<bool> canRead(String profileId) async => true;

  @override
  Future<bool> canWrite(String profileId) async => true;

  @override
  Future<bool> isOwner(String profileId) async => true;

  @override
  Future<List<ProfileAccess>> getAccessibleProfiles() async => [];
}
