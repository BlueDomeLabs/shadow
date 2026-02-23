// test/presentation/screens/notifications/quick_entry/vitals_quick_entry_sheet_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/fluids_entries/fluids_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/vitals_quick_entry_sheet.dart';

void main() {
  group('VitalsQuickEntrySheet', () {
    const profileId = 'profile-001';

    late int startOfToday;
    late int endOfToday;

    setUp(() {
      final now = DateTime.now();
      startOfToday = DateTime(
        now.year,
        now.month,
        now.day,
      ).millisecondsSinceEpoch;
      endOfToday = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
      ).millisecondsSinceEpoch;
    });

    Widget buildSheet({FluidsEntryList Function()? mockFactory}) =>
        ProviderScope(
          overrides: [
            fluidsEntryListProvider(
              profileId,
              startOfToday,
              endOfToday,
            ).overrideWith(mockFactory ?? _MockFluidsEntryList.new),
          ],
          child: const MaterialApp(
            home: Scaffold(body: VitalsQuickEntrySheet(profileId: profileId)),
          ),
        );

    testWidgets('renders BBT / Vitals title', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('BBT / Vitals'), findsOneWidget);
    });

    testWidgets('renders text fields for BBT and notes', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('renders Save Vitals button', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Save Vitals'), findsOneWidget);
    });

    testWidgets('renders BBT reminder text', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('measured before getting out of bed'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when BBT field is empty', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Vitals'));
      await tester.pump();

      expect(find.text('BBT temperature is required'), findsOneWidget);
    });

    testWidgets('shows error when BBT is non-numeric', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'not-a-number');
      await tester.tap(find.text('Save Vitals'));
      await tester.pump();

      expect(find.text('Enter a valid temperature'), findsOneWidget);
    });

    testWidgets('shows error when BBT is out of range', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '200');
      await tester.tap(find.text('Save Vitals'));
      await tester.pump();

      expect(find.text('Temperature appears out of range'), findsOneWidget);
    });

    testWidgets('calls log when valid BBT entered and save tapped', (
      tester,
    ) async {
      final mock = _MockFluidsEntryList();
      await tester.pumpWidget(buildSheet(mockFactory: () => mock));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '36.5');
      await tester.tap(find.text('Save Vitals'));
      await tester.pump();

      expect(mock.logCalled, isTrue);
    });

    testWidgets('passes BBT value to log input', (tester) async {
      final mock = _MockFluidsEntryList();
      await tester.pumpWidget(buildSheet(mockFactory: () => mock));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '36.8');
      await tester.tap(find.text('Save Vitals'));
      await tester.pump();

      expect(mock.lastInput?.basalBodyTemperature, equals(36.8));
    });

    testWidgets('shows error snackbar on save failure', (tester) async {
      await tester.pumpWidget(
        buildSheet(mockFactory: _ErrorFluidsEntryList.new),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '36.5');
      await tester.tap(find.text('Save Vitals'));
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
              w.properties.label == 'BBT and vitals quick-entry sheet',
        ),
        findsOneWidget,
      );
    });
  });
}

class _MockFluidsEntryList extends FluidsEntryList {
  bool logCalled = false;
  LogFluidsEntryInput? lastInput;

  @override
  Future<List<FluidsEntry>> build(
    String profileId,
    int startDate,
    int endDate,
  ) async => [];

  @override
  Future<void> log(LogFluidsEntryInput input) async {
    logCalled = true;
    lastInput = input;
  }
}

class _ErrorFluidsEntryList extends FluidsEntryList {
  @override
  Future<List<FluidsEntry>> build(
    String profileId,
    int startDate,
    int endDate,
  ) async => [];

  @override
  Future<void> log(LogFluidsEntryInput input) async {
    throw DatabaseError.insertFailed('fluids_entries');
  }
}
