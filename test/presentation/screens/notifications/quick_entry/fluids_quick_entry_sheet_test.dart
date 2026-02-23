// test/presentation/screens/notifications/quick_entry/fluids_quick_entry_sheet_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/fluids_entries/fluids_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/fluids_quick_entry_sheet.dart';

void main() {
  group('FluidsQuickEntrySheet', () {
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
            home: Scaffold(body: FluidsQuickEntrySheet(profileId: profileId)),
          ),
        );

    testWidgets('renders Log Fluids title', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Log Fluids'), findsWidgets);
    });

    testWidgets('renders water intake text field', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('renders Other Fluid section header', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Other Fluid'), findsOneWidget);
    });

    testWidgets('renders Log fluids button', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Log Fluids'), findsWidgets);
    });

    testWidgets('shows error when both water and other fluid are empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log Fluids').last);
      await tester.pump();

      expect(find.text('Enter water amount or an other fluid'), findsOneWidget);
    });

    testWidgets('shows error when water is not a positive number', (
      tester,
    ) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '-5');
      await tester.tap(find.text('Log Fluids').last);
      await tester.pump();

      expect(find.text('Enter a positive number of ml'), findsOneWidget);
    });

    testWidgets('calls log when water amount entered and save tapped', (
      tester,
    ) async {
      final mock = _MockFluidsEntryList();
      await tester.pumpWidget(buildSheet(mockFactory: () => mock));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '250');
      await tester.tap(find.text('Log Fluids').last);
      await tester.pump();

      expect(mock.logCalled, isTrue);
    });

    testWidgets('passes water amount to log input', (tester) async {
      final mock = _MockFluidsEntryList();
      await tester.pumpWidget(buildSheet(mockFactory: () => mock));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '350');
      await tester.tap(find.text('Log Fluids').last);
      await tester.pump();

      expect(mock.lastInput?.waterIntakeMl, equals(350));
    });

    testWidgets('shows error snackbar on save failure', (tester) async {
      await tester.pumpWidget(
        buildSheet(mockFactory: _ErrorFluidsEntryList.new),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '250');
      await tester.tap(find.text('Log Fluids').last);
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
              w.properties.label == 'Fluids quick-entry sheet',
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
