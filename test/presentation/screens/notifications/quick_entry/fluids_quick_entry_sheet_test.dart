// test/presentation/screens/notifications/quick_entry/fluids_quick_entry_sheet_test.dart
// Updated for new bodily-output quick-entry sheet (P-015).

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
import 'package:shadow_app/domain/usecases/bodily_output/log_bodily_output_use_case.dart';
import 'package:shadow_app/presentation/providers/bodily_output_providers.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/fluids_quick_entry_sheet.dart';

@GenerateMocks([BodilyOutputRepository, ProfileAuthorizationService])
import 'fluids_quick_entry_sheet_test.mocks.dart';

const _profileId = 'profile-001';

void main() {
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<BodilyOutputLog, AppError>>(
    const Success(
      BodilyOutputLog(
        id: 'd',
        clientId: 'd',
        profileId: 'd',
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
  provideDummy<Result<List<BodilyOutputLog>, AppError>>(const Success([]));

  late MockBodilyOutputRepository mockRepo;
  late MockProfileAuthorizationService mockAuth;
  late LogBodilyOutputUseCase useCase;

  setUp(() {
    mockRepo = MockBodilyOutputRepository();
    mockAuth = MockProfileAuthorizationService();
    useCase = LogBodilyOutputUseCase(mockRepo, mockAuth);

    when(mockAuth.canWrite(_profileId)).thenAnswer((_) async => true);
    when(mockRepo.log(any)).thenAnswer((_) async => const Success(null));
  });

  Widget buildSheet() => ProviderScope(
    overrides: [logBodilyOutputUseCaseProvider.overrideWithValue(useCase)],
    child: const MaterialApp(
      home: Scaffold(body: FluidsQuickEntrySheet(profileId: _profileId)),
    ),
  );

  group('FluidsQuickEntrySheet', () {
    testWidgets('renders_title_logBodyOutput', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Log Body Output'), findsOneWidget);
    });

    testWidgets('renders_typeChips_urineSelected_byDefault', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Urine'), findsOneWidget);
    });

    testWidgets('renders_bowelChip', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Bowel'), findsOneWidget);
    });

    testWidgets('renders_gasChip', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Gas'), findsOneWidget);
    });

    testWidgets('renders_logButton', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Log'), findsOneWidget);
    });

    testWidgets('shows_severityChips_whenGasSelected', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.text('Gas'));
      await tester.pump();

      expect(find.text('Mild'), findsOneWidget);
      expect(find.text('Moderate'), findsOneWidget);
      expect(find.text('Severe'), findsOneWidget);
    });

    testWidgets('hides_severityChips_whenUrineSelected', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Select Gas first, then switch back to Urine
      await tester.tap(find.text('Gas'));
      await tester.pump();
      await tester.tap(find.text('Urine'));
      await tester.pump();

      expect(find.text('Mild'), findsNothing);
    });

    testWidgets('calls_logUseCase_onSave', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.text('Log'));
      await tester.pump();

      verify(mockRepo.log(any)).called(1);
    });

    testWidgets('logs_gasEvent_withSeverity', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.text('Gas'));
      await tester.pump();
      await tester.tap(find.text('Severe'));
      await tester.pump();
      await tester.tap(find.text('Log'));
      await tester.pump();

      final captured =
          verify(mockRepo.log(captureAny)).captured.first as BodilyOutputLog;
      expect(captured.outputType, BodyOutputType.gas);
      expect(captured.gasSeverity, GasSeverity.severe);
    });

    testWidgets('sheet_has_correct_semantic_label', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label == 'Body output quick-entry sheet',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows_snackbar_on_auth_failure', (tester) async {
      when(mockAuth.canWrite(_profileId)).thenAnswer((_) async => false);

      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.text('Log'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
