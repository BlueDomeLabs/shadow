// test/presentation/screens/notifications/quick_entry/journal_quick_entry_sheet_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/journal_entries/journal_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/journal_quick_entry_sheet.dart';

void main() {
  group('JournalQuickEntrySheet', () {
    const profileId = 'profile-001';

    Widget buildSheet({JournalEntryList Function()? mockFactory}) =>
        ProviderScope(
          overrides: [
            journalEntryListProvider(
              profileId,
            ).overrideWith(mockFactory ?? _MockJournalList.new),
          ],
          child: const MaterialApp(
            home: Scaffold(body: JournalQuickEntrySheet(profileId: profileId)),
          ),
        );

    testWidgets('renders Journal Entry title', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Journal Entry'), findsOneWidget);
    });

    testWidgets('renders content text field', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('renders Save Entry button', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Save Entry'), findsOneWidget);
    });

    testWidgets('renders today date label', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      final now = DateTime.now();
      final expectedDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      expect(find.text(expectedDate), findsOneWidget);
    });

    testWidgets('shows error snackbar when content is empty', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Entry'));
      await tester.pump();

      expect(find.text('Please enter some text before saving'), findsOneWidget);
    });

    testWidgets('calls create when content entered and save tapped', (
      tester,
    ) async {
      final mock = _MockJournalList();
      await tester.pumpWidget(buildSheet(mockFactory: () => mock));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Feeling great today');
      await tester.tap(find.text('Save Entry'));
      await tester.pump();

      expect(mock.createCalled, isTrue);
    });

    testWidgets('passes content to create input', (tester) async {
      final mock = _MockJournalList();
      await tester.pumpWidget(buildSheet(mockFactory: () => mock));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'My journal text');
      await tester.tap(find.text('Save Entry'));
      await tester.pump();

      expect(mock.lastInput?.content, equals('My journal text'));
    });

    testWidgets('shows error snackbar on save failure', (tester) async {
      await tester.pumpWidget(buildSheet(mockFactory: _ErrorJournalList.new));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Some content');
      await tester.tap(find.text('Save Entry'));
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
              w.properties.label == 'Journal entry quick-entry sheet',
        ),
        findsOneWidget,
      );
    });
  });
}

class _MockJournalList extends JournalEntryList {
  bool createCalled = false;
  CreateJournalEntryInput? lastInput;

  @override
  Future<List<JournalEntry>> build(String profileId) async => [];

  @override
  Future<void> create(CreateJournalEntryInput input) async {
    createCalled = true;
    lastInput = input;
  }
}

class _ErrorJournalList extends JournalEntryList {
  @override
  Future<List<JournalEntry>> build(String profileId) async => [];

  @override
  Future<void> create(CreateJournalEntryInput input) async {
    throw DatabaseError.insertFailed('journals');
  }
}
