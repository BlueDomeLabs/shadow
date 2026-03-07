// test/unit/domain/usecases/voice_logging/prune_session_history_use_case_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_logging_settings.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_session_turn.dart';
import 'package:shadow_app/domain/repositories/voice_logging_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/voice_logging/prune_session_history_use_case.dart';

@GenerateMocks([VoiceLoggingRepository, ProfileAuthorizationService])
import 'prune_session_history_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<VoiceLoggingSettings?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<List<VoiceSessionTurn>, AppError>>(const Success([]));

  group('PruneSessionHistoryUseCase', () {
    late MockVoiceLoggingRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late PruneSessionHistoryUseCase useCase;

    const profileId = 'profile-001';

    setUp(() {
      mockRepo = MockVoiceLoggingRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = PruneSessionHistoryUseCase(mockRepo, mockAuth);

      when(mockAuth.canWrite(profileId)).thenAnswer((_) async => true);
      when(
        mockRepo.pruneOldTurns(profileId),
      ).thenAnswer((_) async => const Success(null));
    });

    test('execute_success_callsRepoPrune', () async {
      final result = await useCase.execute(profileId);
      expect(result.isSuccess, isTrue);
      verify(mockRepo.pruneOldTurns(profileId)).called(1);
    });

    test('execute_accessDenied_returnsAuthError', () async {
      when(mockAuth.canWrite(profileId)).thenAnswer((_) async => false);
      final result = await useCase.execute(profileId);
      expect(result.isFailure, isTrue);
      result.when(
        success: (_) => fail('Expected failure'),
        failure: (e) => expect(e, isA<AuthError>()),
      );
      verifyNever(mockRepo.pruneOldTurns(any));
    });

    test('execute_repoFailure_propagatesError', () async {
      when(mockRepo.pruneOldTurns(profileId)).thenAnswer(
        (_) async => Failure(
          DatabaseError.deleteFailed(
            'voice_session_history',
            profileId,
            Exception('db error'),
            StackTrace.current,
          ),
        ),
      );
      final result = await useCase.execute(profileId);
      expect(result.isFailure, isTrue);
    });
  });
}
