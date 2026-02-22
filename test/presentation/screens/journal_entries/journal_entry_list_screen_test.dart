// test/presentation/screens/journal_entries/journal_entry_list_screen_test.dart
// Tests for JournalEntryListScreen following ConditionListScreen test pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/journal_entries/journal_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/journal_entries/journal_entry_list_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

void main() {
  group('JournalEntryListScreen', () {
    const testProfileId = 'profile-001';

    JournalEntry createTestEntry({
      String id = 'entry-001',
      String content = 'Today was a good day',
      String? title,
      int? mood,
      List<String>? tags,
      int? timestamp,
    }) => JournalEntry(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      timestamp: timestamp ?? DateTime(2024, 1, 15).millisecondsSinceEpoch,
      content: content,
      title: title,
      mood: mood,
      tags: tags,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildScreen([List<JournalEntry> entries = const []]) =>
        ProviderScope(
          overrides: [
            journalEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockJournalEntryList(entries)),
          ],
          child: const MaterialApp(
            home: JournalEntryListScreen(profileId: testProfileId),
          ),
        );

    testWidgets('renders app bar with title Journal', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Journal'), findsOneWidget);
    });

    testWidgets('renders FAB for adding entries', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders empty state when no entries', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('No journal entries yet'), findsOneWidget);
    });

    testWidgets('renders entry content snippet', (tester) async {
      final entry = createTestEntry(content: 'My thoughts for today');
      await tester.pumpWidget(buildScreen([entry]));
      await tester.pumpAndSettle();
      expect(find.text('My thoughts for today'), findsOneWidget);
    });

    testWidgets('renders entry title when present', (tester) async {
      final entry = createTestEntry(title: 'Daily Reflection');
      await tester.pumpWidget(buildScreen([entry]));
      await tester.pumpAndSettle();
      expect(find.text('Daily Reflection'), findsOneWidget);
    });

    testWidgets('renders mood rating when present', (tester) async {
      final entry = createTestEntry(mood: 8);
      await tester.pumpWidget(buildScreen([entry]));
      await tester.pumpAndSettle();
      expect(find.text('Mood: 8/10'), findsOneWidget);
    });

    testWidgets('renders tags as chips when present', (tester) async {
      final entry = createTestEntry(tags: ['gratitude', 'health']);
      await tester.pumpWidget(buildScreen([entry]));
      await tester.pumpAndSettle();
      expect(find.text('gratitude'), findsOneWidget);
      expect(find.text('health'), findsOneWidget);
    });

    group('navigation', () {
      testWidgets('tapping FAB navigates to add screen', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(find.text('New Entry'), findsOneWidget);
      });

      testWidgets('tapping entry card navigates to edit screen', (
        tester,
      ) async {
        final entry = createTestEntry();
        await tester.pumpWidget(buildScreen([entry]));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ShadowCard));
        await tester.pumpAndSettle();
        expect(find.text('Edit Entry'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('FAB has semantic label Add new journal entry', (
        tester,
      ) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel('Add new journal entry'), findsOneWidget);
      });

      testWidgets('body has semantic label Journal entry list', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Journal entry list',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('entry card has semantic label', (tester) async {
        final entry = createTestEntry(title: 'Daily Reflection');
        await tester.pumpWidget(buildScreen([entry]));
        await tester.pumpAndSettle();
        final cardFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.contains('Daily Reflection') ?? false),
        );
        expect(cardFinder, findsWidgets);
      });

      testWidgets('empty state is accessible', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        expect(find.text('No journal entries yet'), findsOneWidget);
        expect(
          find.text('Tap the + button to write your first entry'),
          findsOneWidget,
        );
      });
    });

    group('popup menu', () {
      testWidgets('shows Edit and Delete options', (tester) async {
        final entry = createTestEntry();
        await tester.pumpWidget(buildScreen([entry]));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      });
    });

    group('loading and error states', () {
      testWidgets('error state renders with retry button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              journalEntryListProvider(
                testProfileId,
              ).overrideWith(_ErrorJournalEntryList.new),
            ],
            child: const MaterialApp(
              home: JournalEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Failed to load journal entries'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });
  });
}

class _MockJournalEntryList extends JournalEntryList {
  final List<JournalEntry> _entries;
  _MockJournalEntryList(this._entries);
  @override
  Future<List<JournalEntry>> build(String profileId) async => _entries;
}

class _ErrorJournalEntryList extends JournalEntryList {
  @override
  Future<List<JournalEntry>> build(String profileId) async {
    throw Exception('Failed to load journal entries');
  }
}
