// test/unit/domain/usecases/voice_logging/get_recent_session_turns_use_case_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_logging_settings.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_session_turn.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/voice_logging_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/voice_logging/get_recent_session_turns_use_case.dart';

@GenerateMocks([VoiceLoggingRepository, ProfileAuthorizationService])
import 'get_recent_session_turns_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<VoiceLoggingSettings?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<List<VoiceSessionTurn>, AppError>>(const Success([]));

  group('GetRecentSessionTurnsUseCase', () {
    late MockVoiceLoggingRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late GetRecentSessionTurnsUseCase useCase;

    const profileId = 'profile-001';
    const now = 1700000000000;

    const sampleTurn = VoiceSessionTurn(
      id: 'turn-001',
      profileId: profileId,
      sessionId: 'session-001',
      turnIndex: 0,
      role: VoiceTurnRole.assistant,
      content: 'Hello!',
      createdAt: now,
    );

    setUp(() {
      mockRepo = MockVoiceLoggingRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = GetRecentSessionTurnsUseCase(mockRepo, mockAuth);

      when(mockAuth.canRead(profileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getRecentTurns(profileId),
      ).thenAnswer((_) async => const Success([]));
      when(
        mockRepo.getRecentTurns(profileId, daysBack: anyNamed('daysBack')),
      ).thenAnswer((_) async => const Success([]));
    });

    test('execute_returnsSuccess_forValidProfile', () async {
      final result = await useCase.execute(profileId);
      expect(result.isSuccess, isTrue);
    });

    test('execute_accessDenied_returnsAuthError', () async {
      when(mockAuth.canRead(profileId)).thenAnswer((_) async => false);
      final result = await useCase.execute(profileId);
      expect(result.isFailure, isTrue);
      result.when(
        success: (_) => fail('Expected failure'),
        failure: (e) => expect(e, isA<AuthError>()),
      );
    });

    test('execute_withDaysBack_passesToRepo', () async {
      await useCase.execute(profileId, daysBack: 7);
      verify(mockRepo.getRecentTurns(profileId, daysBack: 7)).called(1);
    });

    test('execute_defaultDaysBack_passes14', () async {
      await useCase.execute(profileId);
      verify(mockRepo.getRecentTurns(profileId)).called(1);
    });

    test('execute_returnsPopulatedList', () async {
      when(
        mockRepo.getRecentTurns(profileId),
      ).thenAnswer((_) async => const Success([sampleTurn]));
      final result = await useCase.execute(profileId);
      result.when(
        success: (list) => expect(list.length, 1),
        failure: (_) => fail('Expected success'),
      );
    });

    test('execute_repoFailure_propagatesError', () async {
      when(mockRepo.getRecentTurns(profileId)).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed(
            'voice_session_history',
            'oops',
            StackTrace.current,
          ),
        ),
      );
      final result = await useCase.execute(profileId);
      expect(result.isFailure, isTrue);
    });
  });
}
