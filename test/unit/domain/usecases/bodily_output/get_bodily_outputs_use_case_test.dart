// test/unit/domain/usecases/bodily_output/get_bodily_outputs_use_case_test.dart

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

@GenerateMocks([BodilyOutputRepository, ProfileAuthorizationService])
import 'get_bodily_outputs_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<List<BodilyOutputLog>, AppError>>(const Success([]));
  provideDummy<Result<BodilyOutputLog, AppError>>(
    const Success(
      BodilyOutputLog(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        occurredAt: 0,
        outputType: BodyOutputType.urine,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: '',
        ),
      ),
    ),
  );

  group('GetBodilyOutputsUseCase', () {
    late MockBodilyOutputRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late GetBodilyOutputsUseCase useCase;

    const profileId = 'profile-001';

    setUp(() {
      mockRepo = MockBodilyOutputRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = GetBodilyOutputsUseCase(mockRepo, mockAuth);

      when(mockAuth.canRead(profileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getAll(profileId),
      ).thenAnswer((_) async => const Success([]));
      when(
        mockRepo.getAll(profileId, type: anyNamed('type')),
      ).thenAnswer((_) async => const Success([]));
      when(
        mockRepo.getAll(
          profileId,
          from: anyNamed('from'),
          to: anyNamed('to'),
          type: anyNamed('type'),
        ),
      ).thenAnswer((_) async => const Success([]));
    });

    test('execute_validProfile_returnsSuccess', () async {
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

    test('execute_withTypeFilter_passesTypeToRepo', () async {
      await useCase.execute(profileId, type: BodyOutputType.bowel);
      verify(mockRepo.getAll(profileId, type: BodyOutputType.bowel)).called(1);
    });

    test('execute_withDateRange_passesRangeToRepo', () async {
      await useCase.execute(profileId, from: 1000, to: 2000);
      verify(mockRepo.getAll(profileId, from: 1000, to: 2000)).called(1);
    });

    test('execute_repoFailure_propagatesError', () async {
      when(mockRepo.getAll(any)).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed(
            'bodily_output_logs',
            'oops',
            StackTrace.current,
          ),
        ),
      );
      final result = await useCase.execute(profileId);
      expect(result.isFailure, isTrue);
    });

    test('execute_emptyList_returnsEmptySuccess', () async {
      final result = await useCase.execute(profileId);
      result.when(
        success: (list) => expect(list, isEmpty),
        failure: (_) => fail('Expected success'),
      );
    });

    test('execute_populatedList_returnsAllEntries', () async {
      const logs = [
        BodilyOutputLog(
          id: 'a',
          clientId: 'c',
          profileId: profileId,
          occurredAt: 1000,
          outputType: BodyOutputType.urine,
          syncMetadata: SyncMetadata(
            syncCreatedAt: 0,
            syncUpdatedAt: 0,
            syncDeviceId: '',
          ),
        ),
      ];
      when(
        mockRepo.getAll(profileId),
      ).thenAnswer((_) async => const Success(logs));
      final result = await useCase.execute(profileId);
      result.when(
        success: (list) => expect(list.length, 1),
        failure: (_) => fail('Expected success'),
      );
    });

    test('execute_noFilters_callsRepoWithNulls', () async {
      await useCase.execute(profileId);
      verify(mockRepo.getAll(profileId)).called(1);
    });
  });
}
