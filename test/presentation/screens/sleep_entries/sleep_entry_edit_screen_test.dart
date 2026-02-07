// test/presentation/screens/sleep_entries/sleep_entry_edit_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/providers/sleep_entries/sleep_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/sleep_entries/sleep_entry_edit_screen.dart';

void main() {
  group('SleepEntryEditScreen', () {
    const testProfileId = 'profile-001';

    final bedTimeEpoch = DateTime(2025, 1, 15, 22, 30).millisecondsSinceEpoch;
    final wakeTimeEpoch = DateTime(2025, 1, 16, 6, 30).millisecondsSinceEpoch;

    SleepEntry createTestSleepEntry({
      String id = 'sleep-001',
      int? bedTime,
      int? wakeTime,
      WakingFeeling wakingFeeling = WakingFeeling.neutral,
      DreamType dreamType = DreamType.noDreams,
      String? notes,
    }) => SleepEntry(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      bedTime: bedTime ?? bedTimeEpoch,
      wakeTime: wakeTime ?? wakeTimeEpoch,
      wakingFeeling: wakingFeeling,
      dreamType: dreamType,
      notes: notes,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildEditScreen({SleepEntry? sleepEntry}) => ProviderScope(
      overrides: [
        sleepEntryListProvider(
          testProfileId,
        ).overrideWith(() => _MockSleepEntryList([])),
      ],
      child: MaterialApp(
        home: SleepEntryEditScreen(
          profileId: testProfileId,
          sleepEntry: sleepEntry,
        ),
      ),
    );

    /// Scrolls the form ListView down to make bottom widgets visible.
    Future<void> scrollToBottom(WidgetTester tester) async {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
    }

    group('add mode', () {
      testWidgets('renders app bar with Add Sleep Entry title', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('Add Sleep Entry'), findsOneWidget);
      });

      testWidgets('renders Save button', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets('renders Time section header', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('Time'), findsOneWidget);
      });

      testWidgets('renders Sleep Quality section header', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('Sleep Quality'), findsOneWidget);
      });

      testWidgets('renders Waking section header', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Waking'), findsOneWidget);
      });

      testWidgets('renders Sleep Date picker', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('Sleep Date'), findsOneWidget);
      });

      testWidgets('renders Bed Time picker', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('Bed Time'), findsOneWidget);
      });

      testWidgets('renders Wake Time picker', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('Wake Time'), findsOneWidget);
      });

      testWidgets('default bed time is 10:30 PM', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('10:30 PM'), findsOneWidget);
      });

      testWidgets('default wake time is 6:30 AM', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('6:30 AM'), findsOneWidget);
      });

      testWidgets('renders Time to Fall Asleep dropdown', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('Time to Fall Asleep'), findsOneWidget);
      });

      testWidgets('renders Times Awakened field', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('Times Awakened'), findsOneWidget);
      });

      testWidgets('default times awakened is 0', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        // The controller has text "0" - hintText is also "0" so both are in the tree
        expect(find.text('0'), findsWidgets);
      });

      testWidgets('renders Time Awake During Night dropdown', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.text('Time Awake During Night'), findsOneWidget);
      });

      testWidgets('renders Waking Feeling segment', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Waking Feeling'), findsOneWidget);
        expect(find.text('Groggy'), findsOneWidget);
        expect(find.text('Neutral'), findsOneWidget);
        expect(find.text('Rested'), findsOneWidget);
      });

      testWidgets('renders Dream Type dropdown', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Dream Type'), findsOneWidget);
      });

      testWidgets('renders Notes field', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Notes'), findsOneWidget);
      });

      testWidgets('notes field has correct placeholder', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Any notes about your sleep'), findsOneWidget);
      });

      testWidgets('renders bed time icon', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.bedtime), findsOneWidget);
      });

      testWidgets('renders wake time icon', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      });

      testWidgets('renders calendar icon for date', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      });
    });

    group('edit mode', () {
      testWidgets('renders app bar with Edit Sleep Entry title', (
        tester,
      ) async {
        final entry = createTestSleepEntry();
        await tester.pumpWidget(buildEditScreen(sleepEntry: entry));
        await tester.pumpAndSettle();

        expect(find.text('Edit Sleep Entry'), findsOneWidget);
      });

      testWidgets('populates bed time from existing entry', (tester) async {
        final entry = createTestSleepEntry();
        await tester.pumpWidget(buildEditScreen(sleepEntry: entry));
        await tester.pumpAndSettle();

        expect(find.text('10:30 PM'), findsOneWidget);
      });

      testWidgets('populates wake time from existing entry', (tester) async {
        final entry = createTestSleepEntry();
        await tester.pumpWidget(buildEditScreen(sleepEntry: entry));
        await tester.pumpAndSettle();

        expect(find.text('6:30 AM'), findsOneWidget);
      });

      testWidgets('populates notes from existing entry', (tester) async {
        final entry = createTestSleepEntry(notes: 'Had a good night');
        await tester.pumpWidget(buildEditScreen(sleepEntry: entry));
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Had a good night'), findsOneWidget);
      });

      testWidgets('populates date from existing entry', (tester) async {
        final entry = createTestSleepEntry();
        await tester.pumpWidget(buildEditScreen(sleepEntry: entry));
        await tester.pumpAndSettle();

        expect(find.textContaining('Jan 15'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('bed time picker has semantic label', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.contains('When you went to bed') ??
                  false),
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('wake time picker has semantic label', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.contains('When you woke up') ?? false),
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('times awakened has semantic label', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.contains('Number of wake-ups') ??
                  false),
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('notes field has semantic label', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.contains('Sleep notes') ?? false),
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('section headers have header semantics', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        final headerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.header ?? false),
        );
        // Time, Sleep Quality, Waking = 3 headers
        expect(headerFinder, findsNWidgets(3));
      });

      testWidgets('sleep date has required in semantic label', (tester) async {
        await tester.pumpWidget(buildEditScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.contains('required') ?? false) &&
              (widget.properties.label?.contains('Sleep date') ?? false),
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });
  });
}

/// Mock SleepEntryList notifier for testing.
class _MockSleepEntryList extends SleepEntryList {
  final List<SleepEntry> _entries;

  _MockSleepEntryList(this._entries);

  @override
  Future<List<SleepEntry>> build(String profileId) async => _entries;
}
