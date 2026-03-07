// test/unit/domain/usecases/voice_logging/get_voice_logging_settings_use_case_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_logging_settings.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/voice_logging_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/voice_logging/get_voice_logging_settings_use_case.dart';

@GenerateMocks([VoiceLoggingRepository, ProfileAuthorizationService])
import 'get_voice_logging_settings_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<VoiceLoggingSettings?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<List<dynamic>, AppError>>(const Success([]));

  group('GetVoiceLoggingSettingsUseCase', () {
    late MockVoiceLoggingRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late GetVoiceLoggingSettingsUseCase useCase;

    const profileId = 'profile-001';
    const now = 1700000000000;

    const existingSettings = VoiceLoggingSettings(
      id: profileId,
      profileId: profileId,
      closingStyle: ClosingStyle.fixed,
      fixedFarewell: 'Goodbye!',
      createdAt: now,
    );

    setUp(() {
      mockRepo = MockVoiceLoggingRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = GetVoiceLoggingSettingsUseCase(mockRepo, mockAuth);

      when(mockAuth.canRead(profileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getSettings(profileId),
      ).thenAnswer((_) async => const Success(null));
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

    test('execute_noRowInRepo_returnsDefaultSettings', () async {
      when(
        mockRepo.getSettings(profileId),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase.execute(profileId);
      expect(result.isSuccess, isTrue);
      final settings = result.valueOrNull!;
      expect(settings.profileId, profileId);
      expect(settings.closingStyle, ClosingStyle.random);
      expect(settings.categoryPriorityOrder, isNull);
    });

    test('execute_rowExists_returnsExistingSettings', () async {
      when(
        mockRepo.getSettings(profileId),
      ).thenAnswer((_) async => const Success(existingSettings));

      final result = await useCase.execute(profileId);
      expect(result.isSuccess, isTrue);
      final settings = result.valueOrNull!;
      expect(settings.closingStyle, ClosingStyle.fixed);
      expect(settings.fixedFarewell, 'Goodbye!');
    });

    test('execute_repoFailure_propagatesError', () async {
      when(mockRepo.getSettings(profileId)).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed(
            'voice_logging_settings',
            'oops',
            StackTrace.current,
          ),
        ),
      );
      final result = await useCase.execute(profileId);
      expect(result.isFailure, isTrue);
    });

    test('execute_defaultSettings_doesNotWriteToRepo', () async {
      when(
        mockRepo.getSettings(profileId),
      ).thenAnswer((_) async => const Success(null));

      await useCase.execute(profileId);
      verifyNever(mockRepo.saveSettings(any));
    });
  });
}
