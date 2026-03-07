// test/unit/domain/usecases/bodily_output/log_bodily_output_use_case_test.dart

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
import 'package:shadow_app/domain/usecases/bodily_output/log_bodily_output_use_case.dart';

@GenerateMocks([BodilyOutputRepository, ProfileAuthorizationService])
import 'log_bodily_output_use_case_test.mocks.dart';

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

  group('LogBodilyOutputUseCase', () {
    late MockBodilyOutputRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late LogBodilyOutputUseCase useCase;

    const profileId = 'profile-001';
    final past = DateTime.now().millisecondsSinceEpoch - 60000;

    setUp(() {
      mockRepo = MockBodilyOutputRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = LogBodilyOutputUseCase(mockRepo, mockAuth);

      when(mockAuth.canWrite(profileId)).thenAnswer((_) async => true);
      when(mockRepo.log(any)).thenAnswer((_) async => const Success(null));
    });

    BodilyOutputLog makeInput({
      BodyOutputType outputType = BodyOutputType.urine,
      GasSeverity? gasSeverity,
      String? customTypeLabel,
      double? temperatureValue,
      UrineCondition? urineCondition,
      String? urineCustomCondition,
      BowelCondition? bowelCondition,
      String? bowelCustomCondition,
    }) => BodilyOutputLog(
      id: '',
      clientId: 'c',
      profileId: profileId,
      occurredAt: past,
      outputType: outputType,
      gasSeverity: gasSeverity,
      customTypeLabel: customTypeLabel,
      temperatureValue: temperatureValue,
      urineCondition: urineCondition,
      urineCustomCondition: urineCustomCondition,
      bowelCondition: bowelCondition,
      bowelCustomCondition: bowelCustomCondition,
      syncMetadata: const SyncMetadata(
        syncCreatedAt: 0,
        syncUpdatedAt: 0,
        syncDeviceId: '',
      ),
    );

    test('call_validUrineLog_returnsSuccess', () async {
      final result = await useCase(makeInput());
      expect(result.isSuccess, isTrue);
      verify(mockRepo.log(any)).called(1);
    });

    test('call_accessDenied_returnsAuthError', () async {
      when(mockAuth.canWrite(profileId)).thenAnswer((_) async => false);
      final result = await useCase(makeInput());
      expect(result.isFailure, isTrue);
      verifyNever(mockRepo.log(any));
    });

    test('call_gasEventWithoutSeverity_returnsValidationFailure', () async {
      final result = await useCase(makeInput(outputType: BodyOutputType.gas));
      expect(result.isFailure, isTrue);
      result.when(
        success: (_) => fail('Expected failure'),
        failure: (e) => expect(e, isA<ValidationError>()),
      );
    });

    test('call_gasEventWithSeverity_returnsSuccess', () async {
      final result = await useCase(
        makeInput(
          outputType: BodyOutputType.gas,
          gasSeverity: GasSeverity.moderate,
        ),
      );
      expect(result.isSuccess, isTrue);
    });

    test('call_customEventWithoutLabel_returnsValidationFailure', () async {
      final result = await useCase(
        makeInput(outputType: BodyOutputType.custom),
      );
      expect(result.isFailure, isTrue);
      result.when(
        success: (_) => fail('Expected failure'),
        failure: (e) => expect(e, isA<ValidationError>()),
      );
    });

    test('call_bbtEventWithoutTemperature_returnsValidationFailure', () async {
      final result = await useCase(makeInput(outputType: BodyOutputType.bbt));
      expect(result.isFailure, isTrue);
    });

    test(
      'call_urineCustomWithoutDescription_returnsValidationFailure',
      () async {
        final result = await useCase(
          makeInput(urineCondition: UrineCondition.custom),
        );
        expect(result.isFailure, isTrue);
      },
    );

    test(
      'call_bowelCustomWithoutDescription_returnsValidationFailure',
      () async {
        final result = await useCase(
          makeInput(
            outputType: BodyOutputType.bowel,
            bowelCondition: BowelCondition.custom,
          ),
        );
        expect(result.isFailure, isTrue);
      },
    );
  });
}
