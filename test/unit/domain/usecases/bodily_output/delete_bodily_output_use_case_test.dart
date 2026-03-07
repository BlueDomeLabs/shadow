// test/unit/domain/usecases/bodily_output/delete_bodily_output_use_case_test.dart

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
import 'package:shadow_app/domain/usecases/bodily_output/delete_bodily_output_use_case.dart';

@GenerateMocks([BodilyOutputRepository, ProfileAuthorizationService])
import 'delete_bodily_output_use_case_test.mocks.dart';

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

  group('DeleteBodilyOutputUseCase', () {
    late MockBodilyOutputRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late DeleteBodilyOutputUseCase useCase;

    const profileId = 'profile-001';
    const logId = 'log-001';

    setUp(() {
      mockRepo = MockBodilyOutputRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = DeleteBodilyOutputUseCase(mockRepo, mockAuth);

      when(mockAuth.canWrite(profileId)).thenAnswer((_) async => true);
      when(
        mockRepo.delete(profileId, logId),
      ).thenAnswer((_) async => const Success(null));
    });

    test('execute_validProfileAndId_returnsSuccess', () async {
      final result = await useCase.execute(profileId, logId);
      expect(result.isSuccess, isTrue);
      verify(mockRepo.delete(profileId, logId)).called(1);
    });

    test('execute_accessDenied_returnsAuthError', () async {
      when(mockAuth.canWrite(profileId)).thenAnswer((_) async => false);
      final result = await useCase.execute(profileId, logId);
      expect(result.isFailure, isTrue);
      result.when(
        success: (_) => fail('Expected failure'),
        failure: (e) => expect(e, isA<AuthError>()),
      );
      verifyNever(mockRepo.delete(any, any));
    });

    test('execute_repoFailure_propagatesError', () async {
      when(mockRepo.delete(profileId, logId)).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('BodilyOutputLog', logId)),
      );
      final result = await useCase.execute(profileId, logId);
      expect(result.isFailure, isTrue);
    });

    test('execute_emptyProfileId_callsRepoWithEmptyString', () async {
      when(mockAuth.canWrite('')).thenAnswer((_) async => false);
      final result = await useCase.execute('', logId);
      expect(result.isFailure, isTrue);
    });

    test('execute_success_doesNotCallGetById', () async {
      await useCase.execute(profileId, logId);
      verifyNever(mockRepo.getById(any));
    });
  });
}
