// test/presentation/providers/diet/fasting_session_provider_test.dart
// Tests for FastingSessionNotifier provider.

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
import 'package:shadow_app/presentation/providers/diet/fasting_session_provider.dart';

void main() {
  group('FastingSessionNotifier', () {
    const testProfileId = 'profile-001';

    FastingSession createTestSession({
      String id = 'session-001',
      bool isActive = true,
    }) => FastingSession(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      protocol: DietPresetType.if168,
      startedAt: DateTime(2025).millisecondsSinceEpoch,
      endedAt: isActive ? null : DateTime(2025, 1, 2).millisecondsSinceEpoch,
      targetHours: 16,
      syncMetadata: SyncMetadata.empty(),
    );

    ProviderContainer buildContainer({
      FastingSession? activeSession,
      bool canWrite = true,
    }) => ProviderContainer(
      overrides: [
        getActiveFastUseCaseProvider.overrideWithValue(
          _FakeGetActiveFastUseCase(activeSession),
        ),
        startFastUseCaseProvider.overrideWithValue(
          _FakeStartFastUseCase(createTestSession()),
        ),
        endFastUseCaseProvider.overrideWithValue(
          _FakeEndFastUseCase(createTestSession(isActive: false)),
        ),
        profileAuthorizationServiceProvider.overrideWithValue(
          _FakeAuthService(canWrite: canWrite),
        ),
      ],
    );

    test('build returns active session when present', () async {
      final session = createTestSession();
      final container = buildContainer(activeSession: session);
      addTearDown(container.dispose);

      final result = await container.read(
        fastingSessionNotifierProvider(testProfileId).future,
      );

      expect(result, isNotNull);
      expect(result!.id, 'session-001');
    });

    test('build returns null when no active fast', () async {
      final container = buildContainer();
      addTearDown(container.dispose);

      final result = await container.read(
        fastingSessionNotifierProvider(testProfileId).future,
      );

      expect(result, isNull);
    });

    test('build throws on use case failure', () async {
      final container = ProviderContainer(
        overrides: [
          getActiveFastUseCaseProvider.overrideWithValue(
            _ErrorGetActiveFastUseCase(),
          ),
          startFastUseCaseProvider.overrideWithValue(
            _FakeStartFastUseCase(createTestSession()),
          ),
          endFastUseCaseProvider.overrideWithValue(
            _FakeEndFastUseCase(createTestSession(isActive: false)),
          ),
          profileAuthorizationServiceProvider.overrideWithValue(
            _FakeAuthService(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(fastingSessionNotifierProvider(testProfileId).future),
        throwsA(isA<AppError>()),
      );
    });

    test('startFast calls use case and refreshes', () async {
      final fakeStart = _FakeStartFastUseCase(createTestSession());
      final container = ProviderContainer(
        overrides: [
          getActiveFastUseCaseProvider.overrideWithValue(
            _FakeGetActiveFastUseCase(null),
          ),
          startFastUseCaseProvider.overrideWithValue(fakeStart),
          endFastUseCaseProvider.overrideWithValue(
            _FakeEndFastUseCase(createTestSession(isActive: false)),
          ),
          profileAuthorizationServiceProvider.overrideWithValue(
            _FakeAuthService(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(
        fastingSessionNotifierProvider(testProfileId).future,
      );

      await container
          .read(fastingSessionNotifierProvider(testProfileId).notifier)
          .startFast(
            StartFastInput(
              profileId: testProfileId,
              clientId: 'client-001',
              protocol: DietPresetType.if168,
              startedAt: DateTime(2025).millisecondsSinceEpoch,
              targetHours: 16,
            ),
          );

      expect(fakeStart.wasCalled, isTrue);
    });

    test('startFast throws AuthError when write not allowed', () async {
      final container = buildContainer(canWrite: false);
      addTearDown(container.dispose);

      await container.read(
        fastingSessionNotifierProvider(testProfileId).future,
      );

      await expectLater(
        container
            .read(fastingSessionNotifierProvider(testProfileId).notifier)
            .startFast(
              StartFastInput(
                profileId: testProfileId,
                clientId: 'client-001',
                protocol: DietPresetType.if168,
                startedAt: DateTime(2025).millisecondsSinceEpoch,
                targetHours: 16,
              ),
            ),
        throwsA(isA<AuthError>()),
      );
    });

    test('endFast calls use case and refreshes', () async {
      final session = createTestSession();
      final fakeEnd = _FakeEndFastUseCase(createTestSession(isActive: false));
      final container = ProviderContainer(
        overrides: [
          getActiveFastUseCaseProvider.overrideWithValue(
            _FakeGetActiveFastUseCase(session),
          ),
          startFastUseCaseProvider.overrideWithValue(
            _FakeStartFastUseCase(session),
          ),
          endFastUseCaseProvider.overrideWithValue(fakeEnd),
          profileAuthorizationServiceProvider.overrideWithValue(
            _FakeAuthService(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(
        fastingSessionNotifierProvider(testProfileId).future,
      );

      await container
          .read(fastingSessionNotifierProvider(testProfileId).notifier)
          .endFast(
            EndFastInput(
              profileId: testProfileId,
              sessionId: session.id,
              endedAt: DateTime(2025, 1, 2).millisecondsSinceEpoch,
              isManualEnd: true,
            ),
          );

      expect(fakeEnd.wasCalled, isTrue);
    });

    test('endFast throws AuthError when write not allowed', () async {
      final session = createTestSession();
      final container = buildContainer(activeSession: session, canWrite: false);
      addTearDown(container.dispose);

      await container.read(
        fastingSessionNotifierProvider(testProfileId).future,
      );

      await expectLater(
        container
            .read(fastingSessionNotifierProvider(testProfileId).notifier)
            .endFast(
              EndFastInput(
                profileId: testProfileId,
                sessionId: session.id,
                endedAt: DateTime(2025, 1, 2).millisecondsSinceEpoch,
              ),
            ),
        throwsA(isA<AuthError>()),
      );
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
  bool wasCalled = false;
  _FakeStartFastUseCase(this._result);

  @override
  Future<Result<FastingSession, AppError>> call(StartFastInput input) async {
    wasCalled = true;
    return Success(_result);
  }
}

class _FakeEndFastUseCase implements EndFastUseCase {
  final FastingSession _result;
  bool wasCalled = false;
  _FakeEndFastUseCase(this._result);

  @override
  Future<Result<FastingSession, AppError>> call(EndFastInput input) async {
    wasCalled = true;
    return Success(_result);
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
