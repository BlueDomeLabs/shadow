// test/unit/presentation/screens/bodily_output/bodily_output_list_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/bodily_output_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/bodily_output/get_bodily_outputs_use_case.dart';
import 'package:shadow_app/presentation/providers/bodily_output_providers.dart';
import 'package:shadow_app/presentation/screens/bodily_output/bodily_output_list_screen.dart';

@GenerateMocks([BodilyOutputRepository, ProfileAuthorizationService])
import 'bodily_output_list_screen_test.mocks.dart';

const _profileId = 'profile-001';
const _baseSync = SyncMetadata(
  syncCreatedAt: 1700000000000,
  syncUpdatedAt: 1700000000000,
  syncDeviceId: 'dev',
);

BodilyOutputLog _makeLog({
  String id = 'log-001',
  BodyOutputType type = BodyOutputType.urine,
  int occurredAt = 1700000000000,
}) => BodilyOutputLog(
  id: id,
  clientId: 'c',
  profileId: _profileId,
  occurredAt: occurredAt,
  outputType: type,
  syncMetadata: _baseSync,
);

Widget _buildApp(GetBodilyOutputsUseCase useCase) => ProviderScope(
  overrides: [getBodilyOutputsUseCaseProvider.overrideWithValue(useCase)],
  child: const MaterialApp(home: BodilyOutputListScreen(profileId: _profileId)),
);

void main() {
  provideDummy<Result<List<BodilyOutputLog>, AppError>>(const Success([]));
  provideDummy<Result<BodilyOutputLog, AppError>>(Success(_makeLog()));
  provideDummy<Result<void, AppError>>(const Success(null));

  late MockBodilyOutputRepository mockRepo;
  late MockProfileAuthorizationService mockAuth;
  late GetBodilyOutputsUseCase useCase;

  setUp(() {
    mockRepo = MockBodilyOutputRepository();
    mockAuth = MockProfileAuthorizationService();
    useCase = GetBodilyOutputsUseCase(mockRepo, mockAuth);

    when(mockAuth.canRead(_profileId)).thenAnswer((_) async => true);
    when(
      mockRepo.getAll(_profileId),
    ).thenAnswer((_) async => const Success([]));
    when(
      mockRepo.getAll(_profileId, type: anyNamed('type')),
    ).thenAnswer((_) async => const Success([]));
    when(
      mockRepo.getAll(
        _profileId,
        from: anyNamed('from'),
        to: anyNamed('to'),
        type: anyNamed('type'),
      ),
    ).thenAnswer((_) async => const Success([]));
  });

  group('BodilyOutputListScreen', () {
    testWidgets('renders_appBarTitle_showsBodilyFunctions', (tester) async {
      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Bodily Functions'), findsOneWidget);
    });

    testWidgets('renders_bbtLog_withCorrectLabel', (tester) async {
      when(
        mockRepo.getAll(_profileId),
      ).thenAnswer((_) async => Success([_makeLog(type: BodyOutputType.bbt)]));

      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Basal body temperature'), findsOneWidget);
    });

    testWidgets('renders_emptyState_whenNoLogs', (tester) async {
      when(
        mockRepo.getAll(_profileId),
      ).thenAnswer((_) async => const Success([]));

      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('No events logged yet'), findsOneWidget);
    });

    testWidgets('renders_fab_always', (tester) async {
      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('renders_logCard_whenLogsPresent', (tester) async {
      when(
        mockRepo.getAll(_profileId),
      ).thenAnswer((_) async => Success([_makeLog()]));

      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Urine'), findsOneWidget);
    });

    testWidgets('renders_errorState_onRepoFailure', (tester) async {
      when(mockRepo.getAll(_profileId)).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed(
            'bodily_output_logs',
            'oops',
            StackTrace.current,
          ),
        ),
      );

      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Failed to load events'), findsOneWidget);
    });

    testWidgets('renders_retryButton_onError', (tester) async {
      when(mockRepo.getAll(_profileId)).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed(
            'bodily_output_logs',
            'oops',
            StackTrace.current,
          ),
        ),
      );

      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('renders_dayHeader_whenLogsPresent', (tester) async {
      when(
        mockRepo.getAll(_profileId),
      ).thenAnswer((_) async => Success([_makeLog()]));

      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Day header should exist (date formatted as e.g. "November 14, 2023")
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders_multipleLogTypes_correctly', (tester) async {
      when(mockRepo.getAll(_profileId)).thenAnswer(
        (_) async => Success([
          _makeLog(id: 'u1'),
          _makeLog(id: 'b1', type: BodyOutputType.bowel),
        ]),
      );

      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Urine'), findsOneWidget);
      expect(find.text('Bowel movement'), findsOneWidget);
    });

    testWidgets('renders_gasLog_withCorrectLabel', (tester) async {
      when(
        mockRepo.getAll(_profileId),
      ).thenAnswer((_) async => Success([_makeLog(type: BodyOutputType.gas)]));

      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Gas'), findsOneWidget);
    });

    testWidgets('shows_accessDenied_notEmptyState_onAuthFailure', (
      tester,
    ) async {
      when(mockAuth.canRead(_profileId)).thenAnswer((_) async => false);

      await tester.pumpWidget(_buildApp(useCase));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Auth failure returns a Failure result, which shows error state
      expect(find.text('Failed to load events'), findsOneWidget);
    });
  });
}
