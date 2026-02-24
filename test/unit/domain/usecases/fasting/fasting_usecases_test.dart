// test/unit/domain/usecases/fasting/fasting_usecases_test.dart
// Tests for fasting use cases — Phase 15b-2

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/fasting_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/fasting/end_fast_use_case.dart';
import 'package:shadow_app/domain/usecases/fasting/fasting_types.dart';
import 'package:shadow_app/domain/usecases/fasting/get_active_fast_use_case.dart';
import 'package:shadow_app/domain/usecases/fasting/get_fasting_history_use_case.dart';
import 'package:shadow_app/domain/usecases/fasting/start_fast_use_case.dart';

@GenerateMocks([FastingRepository, ProfileAuthorizationService])
import 'fasting_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<FastingSession>, AppError>>(const Success([]));
  provideDummy<Result<FastingSession?, AppError>>(const Success(null));
  provideDummy<Result<FastingSession, AppError>>(
    const Success(
      FastingSession(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        protocol: DietPresetType.if168,
        startedAt: 0,
        targetHours: 16,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testSessionId = 'session-001';
  const now = 1000000;

  FastingSession makeSession({
    String id = testSessionId,
    String profileId = testProfileId,
    int? endedAt,
    bool isManualEnd = false,
  }) => FastingSession(
    id: id,
    clientId: 'client-001',
    profileId: profileId,
    protocol: DietPresetType.if168,
    startedAt: now,
    endedAt: endedAt,
    targetHours: 16,
    isManualEnd: isManualEnd,
    syncMetadata: const SyncMetadata(
      syncCreatedAt: now,
      syncUpdatedAt: now,
      syncDeviceId: 'device',
    ),
  );

  // ============================================================
  // StartFastUseCase
  // ============================================================

  group('StartFastUseCase', () {
    late MockFastingRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late StartFastUseCase useCase;

    setUp(() {
      mockRepo = MockFastingRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = StartFastUseCase(mockRepo, mockAuth);
    });

    test('call_whenAuthorized_andNoActiveFast_createsSession', () async {
      final session = makeSession();
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getActiveFast(testProfileId),
      ).thenAnswer((_) async => const Success(null));
      when(mockRepo.create(any)).thenAnswer((_) async => Success(session));

      final result = await useCase(
        const StartFastInput(
          profileId: testProfileId,
          clientId: 'client-001',
          protocol: DietPresetType.if168,
          startedAt: now,
          targetHours: 16,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepo.create(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const StartFastInput(
          profileId: testProfileId,
          clientId: 'client-001',
          protocol: DietPresetType.if168,
          startedAt: now,
          targetHours: 16,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepo.create(any));
    });

    test('call_whenActiveFastExists_returnsBusinessError', () async {
      final activeFast = makeSession();
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getActiveFast(testProfileId),
      ).thenAnswer((_) async => Success(activeFast));

      final result = await useCase(
        const StartFastInput(
          profileId: testProfileId,
          clientId: 'client-001',
          protocol: DietPresetType.if168,
          startedAt: now,
          targetHours: 16,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<BusinessError>());
      verifyNever(mockRepo.create(any));
    });

    test('call_propagatesRepositoryFailure', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getActiveFast(testProfileId),
      ).thenAnswer((_) async => Failure(DatabaseError.queryFailed('test')));

      final result = await useCase(
        const StartFastInput(
          profileId: testProfileId,
          clientId: 'client-001',
          protocol: DietPresetType.if168,
          startedAt: now,
          targetHours: 16,
        ),
      );

      expect(result.isFailure, isTrue);
    });
  });

  // ============================================================
  // EndFastUseCase
  // ============================================================

  group('EndFastUseCase', () {
    late MockFastingRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late EndFastUseCase useCase;

    setUp(() {
      mockRepo = MockFastingRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = EndFastUseCase(mockRepo, mockAuth);
    });

    test('call_whenAuthorized_endsActiveFast', () async {
      final session = makeSession();
      final endedSession = makeSession(endedAt: now + 1000);
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getById(testSessionId),
      ).thenAnswer((_) async => Success(session));
      when(
        mockRepo.endFast(testSessionId, any),
      ).thenAnswer((_) async => Success(endedSession));

      final result = await useCase(
        const EndFastInput(
          profileId: testProfileId,
          sessionId: testSessionId,
          endedAt: now + 1000,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepo.endFast(testSessionId, now + 1000)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const EndFastInput(
          profileId: testProfileId,
          sessionId: testSessionId,
          endedAt: now + 1000,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenSessionNotFound_returnsFailure', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockRepo.getById(testSessionId)).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('FastingSession', testSessionId)),
      );

      final result = await useCase(
        const EndFastInput(
          profileId: testProfileId,
          sessionId: testSessionId,
          endedAt: now + 1000,
        ),
      );

      expect(result.isFailure, isTrue);
    });

    test(
      'call_whenSessionBelongsToDifferentProfile_returnsAuthError',
      () async {
        final wrongSession = makeSession(profileId: 'other-profile');
        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(
          mockRepo.getById(testSessionId),
        ).thenAnswer((_) async => Success(wrongSession));

        final result = await useCase(
          const EndFastInput(
            profileId: testProfileId,
            sessionId: testSessionId,
            endedAt: now + 1000,
          ),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<AuthError>());
      },
    );

    test(
      'call_whenFastAlreadyEnded_returnsSuccessWithoutCallingEndFast',
      () async {
        final alreadyEnded = makeSession(endedAt: now + 500);
        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(
          mockRepo.getById(testSessionId),
        ).thenAnswer((_) async => Success(alreadyEnded));

        final result = await useCase(
          const EndFastInput(
            profileId: testProfileId,
            sessionId: testSessionId,
            endedAt: now + 1000,
          ),
        );

        expect(result.isSuccess, isTrue);
        verifyNever(mockRepo.endFast(any, any));
      },
    );

    test('call_withManualEnd_passesIsManualEndFlag', () async {
      final session = makeSession();
      final endedSession = makeSession(endedAt: now + 1000, isManualEnd: true);
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getById(testSessionId),
      ).thenAnswer((_) async => Success(session));
      when(
        mockRepo.endFast(testSessionId, any, isManualEnd: true),
      ).thenAnswer((_) async => Success(endedSession));

      await useCase(
        const EndFastInput(
          profileId: testProfileId,
          sessionId: testSessionId,
          endedAt: now + 1000,
          isManualEnd: true,
        ),
      );

      verify(
        mockRepo.endFast(testSessionId, now + 1000, isManualEnd: true),
      ).called(1);
    });
  });

  // ============================================================
  // GetActiveFastUseCase
  // ============================================================

  group('GetActiveFastUseCase', () {
    late MockFastingRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late GetActiveFastUseCase useCase;

    setUp(() {
      mockRepo = MockFastingRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = GetActiveFastUseCase(mockRepo, mockAuth);
    });

    test('call_whenAuthorized_returnsActiveFast', () async {
      final session = makeSession();
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getActiveFast(testProfileId),
      ).thenAnswer((_) async => Success(session));

      final result = await useCase(
        const GetActiveFastInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, session);
    });

    test('call_returnsNull_whenNoActiveFast', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getActiveFast(testProfileId),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const GetActiveFastInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isNull);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const GetActiveFastInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });

  // ============================================================
  // GetFastingHistoryUseCase
  // ============================================================

  group('GetFastingHistoryUseCase', () {
    late MockFastingRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late GetFastingHistoryUseCase useCase;

    setUp(() {
      mockRepo = MockFastingRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = GetFastingHistoryUseCase(mockRepo, mockAuth);
    });

    test('call_whenAuthorized_returnsFastingHistory', () async {
      final sessions = [makeSession(endedAt: now + 57600000)];
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(sessions));

      final result = await useCase(
        const GetFastingHistoryInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, sessions);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const GetFastingHistoryInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_passesLimitToRepository', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId, limit: 30),
      ).thenAnswer((_) async => const Success([]));

      await useCase(
        const GetFastingHistoryInput(profileId: testProfileId, limit: 30),
      );

      verify(mockRepo.getByProfile(testProfileId, limit: 30)).called(1);
    });

    test('call_propagatesRepositoryFailure', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => Failure(DatabaseError.queryFailed('test')));

      final result = await useCase(
        const GetFastingHistoryInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
    });
  });
}
