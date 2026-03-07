// test/unit/presentation/screens/settings/voice_logging_settings_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:shadow_app/domain/usecases/voice_logging/save_voice_logging_settings_use_case.dart';
import 'package:shadow_app/presentation/providers/voice_logging_providers.dart';
import 'package:shadow_app/presentation/screens/settings/voice_logging_settings_screen.dart';

@GenerateMocks([VoiceLoggingRepository, ProfileAuthorizationService])
import 'voice_logging_settings_screen_test.mocks.dart';

const _profileId = 'profile-001';
const _now = 1700000000000;

const _defaultSettings = VoiceLoggingSettings(
  id: _profileId,
  profileId: _profileId,
  closingStyle: ClosingStyle.random,
  createdAt: _now,
);

Widget _buildApp(
  GetVoiceLoggingSettingsUseCase getUseCase,
  SaveVoiceLoggingSettingsUseCase saveUseCase,
) => ProviderScope(
  overrides: [
    getVoiceLoggingSettingsUseCaseProvider.overrideWithValue(getUseCase),
    saveVoiceLoggingSettingsUseCaseProvider.overrideWithValue(saveUseCase),
  ],
  // Pass profileId directly — avoids needing to override profileProvider.
  child: const MaterialApp(
    home: VoiceLoggingSettingsScreen(profileId: _profileId),
  ),
);

void main() {
  provideDummy<Result<VoiceLoggingSettings?, AppError>>(const Success(null));
  provideDummy<Result<VoiceLoggingSettings, AppError>>(
    const Success(_defaultSettings),
  );
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<List<dynamic>, AppError>>(const Success([]));

  late MockVoiceLoggingRepository mockRepo;
  late MockProfileAuthorizationService mockAuth;
  late GetVoiceLoggingSettingsUseCase getUseCase;
  late SaveVoiceLoggingSettingsUseCase saveUseCase;

  setUp(() {
    mockRepo = MockVoiceLoggingRepository();
    mockAuth = MockProfileAuthorizationService();
    getUseCase = GetVoiceLoggingSettingsUseCase(mockRepo, mockAuth);
    saveUseCase = SaveVoiceLoggingSettingsUseCase(mockRepo, mockAuth);

    when(mockAuth.canRead(_profileId)).thenAnswer((_) async => true);
    when(mockAuth.canWrite(_profileId)).thenAnswer((_) async => true);
    when(
      mockRepo.getSettings(_profileId),
    ).thenAnswer((_) async => const Success(_defaultSettings));
    when(
      mockRepo.saveSettings(any),
    ).thenAnswer((_) async => const Success(null));
  });

  group('VoiceLoggingSettingsScreen', () {
    testWidgets('renders_withoutError', (tester) async {
      await tester.pumpWidget(_buildApp(getUseCase, saveUseCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(VoiceLoggingSettingsScreen), findsOneWidget);
    });

    testWidgets('shows_threeClosingStyleOptions', (tester) async {
      await tester.pumpWidget(_buildApp(getUseCase, saveUseCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text('No closing comment'), findsOneWidget);
      expect(find.text('Random farewell'), findsOneWidget);
      expect(find.text('Custom farewell'), findsOneWidget);
    });

    testWidgets('textField_appearsWhenCustomFarewellSelected', (tester) async {
      when(mockRepo.getSettings(_profileId)).thenAnswer(
        (_) async => const Success(
          VoiceLoggingSettings(
            id: _profileId,
            profileId: _profileId,
            closingStyle: ClosingStyle.fixed,
            createdAt: _now,
          ),
        ),
      );
      await tester.pumpWidget(_buildApp(getUseCase, saveUseCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows_inputModeToggle', (tester) async {
      await tester.pumpWidget(_buildApp(getUseCase, saveUseCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(SegmentedButton<DefaultInputMode>), findsOneWidget);
      expect(find.text('Voice'), findsOneWidget);
      expect(find.text('Text'), findsOneWidget);
    });

    testWidgets('shows_reorderablePriorityList', (tester) async {
      await tester.pumpWidget(_buildApp(getUseCase, saveUseCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(ReorderableListView), findsOneWidget);
      expect(find.text('Sleep'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
    });
  });
}
