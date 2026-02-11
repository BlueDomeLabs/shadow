// test/presentation/screens/journal_entries/journal_entry_edit_screen_test.dart
// Tests for JournalEntryEditScreen following ConditionEditScreen test pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/journal_entries/journal_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/journal_entries/journal_entry_edit_screen.dart';

void main() {
  group('JournalEntryEditScreen', () {
    const testProfileId = 'profile-001';

    JournalEntry createTestEntry({
      String id = 'entry-001',
      String content = 'My journal entry',
      String? title,
      int? mood,
      List<String>? tags,
    }) => JournalEntry(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      timestamp: DateTime(2024, 1, 15).millisecondsSinceEpoch,
      content: content,
      title: title,
      mood: mood,
      tags: tags,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildAddScreen() => ProviderScope(
      overrides: [
        journalEntryListProvider(
          testProfileId,
        ).overrideWith(() => _MockJournalEntryList([])),
      ],
      child: const MaterialApp(
        home: JournalEntryEditScreen(profileId: testProfileId),
      ),
    );

    Widget buildEditScreen(JournalEntry entry) => ProviderScope(
      overrides: [
        journalEntryListProvider(
          testProfileId,
        ).overrideWith(() => _MockJournalEntryList([entry])),
      ],
      child: MaterialApp(
        home: JournalEntryEditScreen(profileId: testProfileId, entry: entry),
      ),
    );

    Future<void> scrollToBottom(WidgetTester tester) async {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
    }

    group('add mode', () {
      testWidgets('renders New Entry title', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        expect(find.text('New Entry'), findsOneWidget);
      });

      testWidgets('renders all form fields', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        expect(find.text('Date & Time'), findsOneWidget);
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Content'), findsOneWidget);
        await scrollToBottom(tester);
        expect(find.text('Mood'), findsOneWidget);
        expect(find.text('Tags'), findsOneWidget);
      });

      testWidgets('renders Save and Cancel buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('renders mood slider', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.byType(Slider), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('content has semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Entry content, required',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('title has semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Entry title, optional',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('body has form semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'New journal entry form',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('validation', () {
      Finder findContentField() => find.descendant(
        of: find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Entry content, required',
        ),
        matching: find.byType(TextField),
      );

      testWidgets('shows error when content is too short', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter text shorter than min length
        await tester.enterText(findContentField(), 'Short');
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Content must be at least ${ValidationRules.journalContentMinLength} characters',
          ),
          findsOneWidget,
        );
      });

      testWidgets('clears error when content meets min length', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter short text to trigger error
        await tester.enterText(findContentField(), 'Short');
        await tester.pumpAndSettle();
        expect(
          find.text(
            'Content must be at least ${ValidationRules.journalContentMinLength} characters',
          ),
          findsOneWidget,
        );

        // Enter text that meets min length
        await tester.enterText(
          findContentField(),
          'A' * ValidationRules.journalContentMinLength,
        );
        await tester.pumpAndSettle();
        expect(
          find.text(
            'Content must be at least ${ValidationRules.journalContentMinLength} characters',
          ),
          findsNothing,
        );
      });

      testWidgets('content max length matches ValidationRules', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(findContentField());
        expect(textField.maxLength, ValidationRules.journalContentMaxLength);
      });
    });

    group('edit mode', () {
      testWidgets('renders Edit Entry title', (tester) async {
        final entry = createTestEntry();
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();
        expect(find.text('Edit Entry'), findsOneWidget);
      });

      testWidgets('populates content from entry', (tester) async {
        final entry = createTestEntry(content: 'Feeling great');
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();
        expect(find.text('Feeling great'), findsOneWidget);
      });

      testWidgets('populates title from entry', (tester) async {
        final entry = createTestEntry(title: 'My Day');
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();
        expect(find.text('My Day'), findsOneWidget);
      });

      testWidgets('shows Save Changes button in edit mode', (tester) async {
        final entry = createTestEntry();
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.text('Save Changes'), findsOneWidget);
      });

      testWidgets('body has edit mode semantic label', (tester) async {
        final entry = createTestEntry();
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Edit journal entry form',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('populates tags from entry', (tester) async {
        final entry = createTestEntry(tags: ['health', 'mood']);
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.text('health'), findsOneWidget);
        expect(find.text('mood'), findsOneWidget);
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
