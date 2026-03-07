// test/unit/domain/usecases/voice_logging/save_session_turn_use_case_test.dart

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
import 'package:shadow_app/domain/usecases/voice_logging/save_session_turn_use_case.dart';

@GenerateMocks([VoiceLoggingRepository, ProfileAuthorizationService])
import 'save_session_turn_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<VoiceLoggingSettings?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<List<VoiceSessionTurn>, AppError>>(const Success([]));

  group('SaveSessionTurnUseCase', () {
    late MockVoiceLoggingRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late SaveSessionTurnUseCase useCase;

    const profileId = 'profile-001';
    const now = 1700000000000;

    const turn = VoiceSessionTurn(
      id: 'turn-001',
      profileId: profileId,
      sessionId: 'session-001',
      turnIndex: 0,
      role: VoiceTurnRole.assistant,
      content: 'Good morning!',
      createdAt: now,
    );

    setUp(() {
      mockRepo = MockVoiceLoggingRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = SaveSessionTurnUseCase(mockRepo, mockAuth);

      when(mockAuth.canWrite(profileId)).thenAnswer((_) async => true);
      when(mockRepo.saveTurn(any)).thenAnswer((_) async => const Success(null));
    });

    test('execute_success_callsRepo', () async {
      final result = await useCase.execute(turn);
      expect(result.isSuccess, isTrue);
      verify(mockRepo.saveTurn(turn)).called(1);
    });

    test('execute_accessDenied_returnsAuthError', () async {
      when(mockAuth.canWrite(profileId)).thenAnswer((_) async => false);
      final result = await useCase.execute(turn);
      expect(result.isFailure, isTrue);
      result.when(
        success: (_) => fail('Expected failure'),
        failure: (e) => expect(e, isA<AuthError>()),
      );
      verifyNever(mockRepo.saveTurn(any));
    });

    test('execute_repoFailure_propagatesError', () async {
      when(mockRepo.saveTurn(any)).thenAnswer(
        (_) async => Failure(
          DatabaseError.insertFailed(
            'voice_session_history',
            Exception('db error'),
            StackTrace.current,
          ),
        ),
      );
      final result = await useCase.execute(turn);
      expect(result.isFailure, isTrue);
    });
  });
}
