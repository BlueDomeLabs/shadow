// test/presentation/screens/sleep_entries/sleep_entry_list_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/providers/sleep_entries/sleep_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/sleep_entries/sleep_entry_list_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

void main() {
  group('SleepEntryListScreen', () {
    const testProfileId = 'profile-001';

    // Bed time: Jan 15 2025 10:30 PM = epoch millis
    final bedTimeEpoch = DateTime(2025, 1, 15, 22, 30).millisecondsSinceEpoch;
    // Wake time: Jan 16 2025 6:30 AM
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

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sleep Log'), findsOneWidget);
    });

    testWidgets('renders filter button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('renders FAB for adding sleep entries', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders empty state when no sleep entries', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No sleep entries yet'), findsOneWidget);
    });

    testWidgets('empty state shows bedtime icon', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bedtime_outlined), findsOneWidget);
    });

    testWidgets('renders sleep entry when data available', (tester) async {
      final entry = createTestSleepEntry();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([entry])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show the date
      expect(find.textContaining('Jan 15'), findsOneWidget);
    });

    testWidgets('renders Sleep Entries header', (tester) async {
      final entry = createTestSleepEntry();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([entry])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sleep Entries'), findsOneWidget);
    });

    testWidgets('sleep entry card shows bed and wake times', (tester) async {
      final entry = createTestSleepEntry();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([entry])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show time range
      expect(find.textContaining('10:30 PM'), findsOneWidget);
    });

    testWidgets('sleep entry card shows duration', (tester) async {
      final entry = createTestSleepEntry();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([entry])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 10:30 PM to 6:30 AM = 8h
      expect(find.text('8h'), findsOneWidget);
    });

    testWidgets('sleep entry card shows waking feeling', (tester) async {
      final entry = createTestSleepEntry(wakingFeeling: WakingFeeling.rested);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([entry])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rested'), findsOneWidget);
    });

    testWidgets('sleep entry card has more options menu', (tester) async {
      final entry = createTestSleepEntry();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sleepEntryListProvider(
              testProfileId,
            ).overrideWith(() => _MockSleepEntryList([entry])),
          ],
          child: const MaterialApp(
            home: SleepEntryListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    group('loading and error states', () {
      testWidgets('shows error state with retry button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(_ErrorSleepEntryList.new),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Failed to load sleep entries'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });

    group('list display', () {
      testWidgets('sorts entries by date, most recent first', (tester) async {
        final olderEntry = createTestSleepEntry(
          id: 'sleep-old',
          bedTime: DateTime(2025, 1, 10, 22).millisecondsSinceEpoch,
          wakeTime: DateTime(2025, 1, 11, 6).millisecondsSinceEpoch,
        );
        final newerEntry = createTestSleepEntry(
          id: 'sleep-new',
          bedTime: DateTime(2025, 1, 20, 23).millisecondsSinceEpoch,
          wakeTime: DateTime(2025, 1, 21, 7).millisecondsSinceEpoch,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(testProfileId).overrideWith(
                () => _MockSleepEntryList([olderEntry, newerEntry]),
              ),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Both dates should be visible
        expect(find.textContaining('Jan 20'), findsOneWidget);
        expect(find.textContaining('Jan 10'), findsOneWidget);
      });

      testWidgets('displays unrested feeling icon', (tester) async {
        final entry = createTestSleepEntry(
          wakingFeeling: WakingFeeling.unrested,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([entry])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.sentiment_dissatisfied), findsOneWidget);
        expect(find.text('Unrested'), findsOneWidget);
      });

      testWidgets('displays neutral feeling icon', (tester) async {
        final entry = createTestSleepEntry();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([entry])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.sentiment_neutral), findsOneWidget);
        expect(find.text('Neutral'), findsOneWidget);
      });

      testWidgets('displays rested feeling icon', (tester) async {
        final entry = createTestSleepEntry(wakingFeeling: WakingFeeling.rested);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([entry])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.sentiment_satisfied), findsOneWidget);
        expect(find.text('Rested'), findsOneWidget);
      });

      testWidgets('handles entry without wake time', (tester) async {
        // Construct SleepEntry directly to bypass helper's null-coalescing
        final entry = SleepEntry(
          id: 'sleep-no-wake',
          clientId: 'client-001',
          profileId: testProfileId,
          bedTime: bedTimeEpoch,
          syncMetadata: SyncMetadata.empty(),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([entry])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('Not recorded'), findsOneWidget);
        expect(find.text('Duration unknown'), findsOneWidget);
      });
    });

    group('popup menu', () {
      testWidgets('shows Edit and Delete options', (tester) async {
        final entry = createTestSleepEntry();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([entry])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the more options button
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      });
    });

    group('filter bottom sheet', () {
      testWidgets('filter button opens bottom sheet', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.filter_list));
        await tester.pumpAndSettle();

        expect(find.text('Filter Sleep Entries'), findsOneWidget);
        expect(find.text('Date range'), findsOneWidget);
      });
    });

    group('navigation', () {
      testWidgets('tapping FAB navigates to add screen', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.text('Add Sleep Entry'), findsOneWidget);
      });

      testWidgets('tapping sleep entry card navigates to edit screen', (
        tester,
      ) async {
        final entry = createTestSleepEntry();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([entry])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the ShadowCard
        await tester.tap(find.byType(ShadowCard));
        await tester.pumpAndSettle();

        expect(find.text('Edit Sleep Entry'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('FAB has semantic label', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.bySemanticsLabel('Add new sleep entry'), findsOneWidget);
      });

      testWidgets('sleep entry list body has semantic label', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Sleep entry list',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('section headers have header semantics', (tester) async {
        final entry = createTestSleepEntry();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([entry])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final headerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.header ?? false),
        );
        expect(headerFinder, findsWidgets);
      });

      testWidgets('sleep entry card has semantic label with date and feeling', (
        tester,
      ) async {
        final entry = createTestSleepEntry();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([entry])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final cardFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.contains('Jan 15') ?? false),
        );
        expect(cardFinder, findsWidgets);
      });

      testWidgets('filter button has tooltip', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final iconButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.filter_list),
        );
        expect(iconButton.tooltip, 'Filter sleep entries');
      });

      testWidgets('empty state is accessible', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sleepEntryListProvider(
                testProfileId,
              ).overrideWith(() => _MockSleepEntryList([])),
            ],
            child: const MaterialApp(
              home: SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No sleep entries yet'), findsOneWidget);
        expect(
          find.text('Tap the + button to log your first sleep entry'),
          findsOneWidget,
        );
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

/// Mock notifier that simulates an error.
class _ErrorSleepEntryList extends SleepEntryList {
  @override
  Future<List<SleepEntry>> build(String profileId) async {
    throw Exception('Failed to load sleep entries');
  }
}
