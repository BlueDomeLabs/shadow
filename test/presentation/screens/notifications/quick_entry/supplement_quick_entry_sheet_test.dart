// test/presentation/screens/notifications/quick_entry/supplement_quick_entry_sheet_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/intake_logs/intake_log_inputs.dart';
import 'package:shadow_app/presentation/providers/intake_logs/intake_log_list_provider.dart';
import 'package:shadow_app/presentation/providers/supplements/supplement_list_provider.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/supplement_quick_entry_sheet.dart';

void main() {
  group('SupplementQuickEntrySheet', () {
    const profileId = 'profile-001';

    IntakeLog createTestLog({
      String id = 'log-001',
      String supplementId = 'supp-001',
    }) => IntakeLog(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      supplementId: supplementId,
      scheduledTime: 0,
      syncMetadata: SyncMetadata.empty(),
    );

    Supplement createTestSupplement({
      String id = 'supp-001',
      String name = 'Vitamin D3',
    }) => Supplement(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      name: name,
      form: SupplementForm.capsule,
      dosageQuantity: 1000,
      dosageUnit: DosageUnit.iu,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildSheet({
      List<IntakeLog> pendingLogs = const [],
      List<Supplement> supplements = const [],
      IntakeLogList Function()? intakeMockFactory,
    }) => ProviderScope(
      overrides: [
        supplementListProvider(
          profileId,
        ).overrideWith(() => _MockSupplementList(supplements)),
        intakeLogListProvider(
          profileId,
        ).overrideWith(intakeMockFactory ?? _MockIntakeLogList.new),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SupplementQuickEntrySheet(
            profileId: profileId,
            pendingLogs: pendingLogs,
          ),
        ),
      ),
    );

    testWidgets('renders Supplement Check-in title', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Supplement Check-in'), findsOneWidget);
    });

    testWidgets('shows no supplements message when pending logs empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('No supplements due right now.'), findsOneWidget);
    });

    testWidgets('renders Mark All Taken button when logs pending', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSheet(
          pendingLogs: [createTestLog()],
          supplements: [createTestSupplement()],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mark All Taken'), findsOneWidget);
    });

    testWidgets('renders supplement name for each pending log', (tester) async {
      await tester.pumpWidget(
        buildSheet(
          pendingLogs: [createTestLog()],
          supplements: [createTestSupplement()],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Vitamin D3'), findsOneWidget);
    });

    testWidgets('renders Taken and Skip buttons for each log', (tester) async {
      await tester.pumpWidget(
        buildSheet(
          pendingLogs: [createTestLog()],
          supplements: [createTestSupplement()],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Taken'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('calls markTaken when Taken button tapped', (tester) async {
      final mock = _MockIntakeLogList();
      await tester.pumpWidget(
        buildSheet(
          pendingLogs: [createTestLog()],
          supplements: [createTestSupplement()],
          intakeMockFactory: () => mock,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Taken'));
      await tester.pump();

      expect(mock.markTakenCalled, isTrue);
    });

    testWidgets('calls markSkipped when Skip button tapped', (tester) async {
      final mock = _MockIntakeLogList();
      await tester.pumpWidget(
        buildSheet(
          pendingLogs: [createTestLog()],
          supplements: [createTestSupplement()],
          intakeMockFactory: () => mock,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Skip'));
      await tester.pump();

      expect(mock.markSkippedCalled, isTrue);
    });

    testWidgets('calls markTaken for all logs when Mark All Taken tapped', (
      tester,
    ) async {
      final mock = _MockIntakeLogList();
      await tester.pumpWidget(
        buildSheet(
          pendingLogs: [
            createTestLog(),
            createTestLog(id: 'log-002'),
          ],
          supplements: [createTestSupplement()],
          intakeMockFactory: () => mock,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mark All Taken'));
      await tester.pump();

      expect(mock.markTakenCount, equals(2));
    });

    testWidgets('shows error snackbar on markTaken failure', (tester) async {
      await tester.pumpWidget(
        buildSheet(
          pendingLogs: [createTestLog()],
          supplements: [createTestSupplement()],
          intakeMockFactory: _ErrorIntakeLogList.new,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Taken'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('sheet has correct semantic label', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label == 'Supplement intake quick-entry sheet',
        ),
        findsOneWidget,
      );
    });
  });
}

class _MockSupplementList extends SupplementList {
  final List<Supplement> _items;
  _MockSupplementList(this._items);

  @override
  Future<List<Supplement>> build(String profileId) async => _items;
}

class _MockIntakeLogList extends IntakeLogList {
  bool markTakenCalled = false;
  bool markSkippedCalled = false;
  int markTakenCount = 0;
  MarkTakenInput? lastTakenInput;

  @override
  Future<List<IntakeLog>> build(String profileId) async => [];

  @override
  Future<void> markTaken(MarkTakenInput input) async {
    markTakenCalled = true;
    markTakenCount++;
    lastTakenInput = input;
  }

  @override
  Future<void> markSkipped(MarkSkippedInput input) async {
    markSkippedCalled = true;
  }
}

class _ErrorIntakeLogList extends IntakeLogList {
  @override
  Future<List<IntakeLog>> build(String profileId) async => [];

  @override
  Future<void> markTaken(MarkTakenInput input) async {
    throw DatabaseError.insertFailed('intake_logs');
  }

  @override
  Future<void> markSkipped(MarkSkippedInput input) async {
    throw DatabaseError.insertFailed('intake_logs');
  }
}
