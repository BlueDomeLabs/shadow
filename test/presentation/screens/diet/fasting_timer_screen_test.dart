// test/presentation/screens/diet/fasting_timer_screen_test.dart
// Tests for FastingTimerScreen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/fasting/fasting_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/diet/fasting_timer_screen.dart';

void main() {
  group('FastingTimerScreen', () {
    const testProfileId = 'profile-001';

    FastingSession createActiveSession() => FastingSession(
      id: 'session-001',
      clientId: 'client-001',
      profileId: testProfileId,
      protocol: DietPresetType.if168,
      startedAt: DateTime.now()
          .subtract(const Duration(hours: 2))
          .millisecondsSinceEpoch,
      targetHours: 16,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildScreen({FastingSession? activeSession, bool error = false}) =>
        ProviderScope(
          overrides: [
            getActiveFastUseCaseProvider.overrideWithValue(
              error
                  ? _ErrorGetActiveFastUseCase()
                  : _FakeGetActiveFastUseCase(activeSession),
            ),
            startFastUseCaseProvider.overrideWithValue(
              _FakeStartFastUseCase(createActiveSession()),
            ),
            endFastUseCaseProvider.overrideWithValue(
              _FakeEndFastUseCase(
                FastingSession(
                  id: 'session-001',
                  clientId: 'client-001',
                  profileId: testProfileId,
                  protocol: DietPresetType.if168,
                  startedAt: DateTime.now()
                      .subtract(const Duration(hours: 16))
                      .millisecondsSinceEpoch,
                  endedAt: DateTime.now().millisecondsSinceEpoch,
                  targetHours: 16,
                  syncMetadata: SyncMetadata.empty(),
                ),
              ),
            ),
            profileAuthorizationServiceProvider.overrideWithValue(
              _FakeAuthService(),
            ),
          ],
          child: const MaterialApp(
            home: FastingTimerScreen(profileId: testProfileId),
          ),
        );

    testWidgets('renders app bar with "Fasting Timer" title', (tester) async {
      // Use a tall viewport to avoid overflow in the protocol selector column
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Fasting Timer'), findsOneWidget);
    });

    testWidgets('shows "No active fast" when no fast in progress', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('No active fast'), findsOneWidget);
    });

    testWidgets('shows "Start Fast" button when no fast in progress', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Start Fast'), findsOneWidget);
    });

    testWidgets('shows protocol selector when no fast in progress', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Select protocol:'), findsOneWidget);
    });

    testWidgets('shows "Fasting" label when fast is active', (tester) async {
      await tester.pumpWidget(
        buildScreen(activeSession: createActiveSession()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Fasting'), findsOneWidget);
    });

    testWidgets('shows "End Fast" button when fast is active', (tester) async {
      await tester.pumpWidget(
        buildScreen(activeSession: createActiveSession()),
      );
      await tester.pumpAndSettle();

      expect(find.text('End Fast'), findsOneWidget);
    });

    testWidgets('shows timer display when fast is active', (tester) async {
      await tester.pumpWidget(
        buildScreen(activeSession: createActiveSession()),
      );
      await tester.pumpAndSettle();

      // Timer shows HH:MM:SS; session started 2 hours ago so time > "02:00:00"
      expect(find.textContaining('02:'), findsOneWidget);
    });

    testWidgets('shows error widget on load failure', (tester) async {
      await tester.pumpWidget(buildScreen(error: true));
      await tester.pumpAndSettle();

      expect(find.text('Could not load fasting status'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

// Fake use cases

class _FakeGetActiveFastUseCase implements GetActiveFastUseCase {
  final FastingSession? _session;
  _FakeGetActiveFastUseCase(this._session);

  @override
  Future<Result<FastingSession?, AppError>> call(
    GetActiveFastInput input,
  ) async => Success(_session);
}

class _ErrorGetActiveFastUseCase implements GetActiveFastUseCase {
  @override
  Future<Result<FastingSession?, AppError>> call(
    GetActiveFastInput input,
  ) async => Failure(DatabaseError.queryFailed('test'));
}

class _FakeStartFastUseCase implements StartFastUseCase {
  final FastingSession _result;
  _FakeStartFastUseCase(this._result);

  @override
  Future<Result<FastingSession, AppError>> call(StartFastInput input) async =>
      Success(_result);
}

class _FakeEndFastUseCase implements EndFastUseCase {
  final FastingSession _result;
  _FakeEndFastUseCase(this._result);

  @override
  Future<Result<FastingSession, AppError>> call(EndFastInput input) async =>
      Success(_result);
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
