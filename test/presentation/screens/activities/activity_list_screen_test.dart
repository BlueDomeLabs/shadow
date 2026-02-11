// test/presentation/screens/activities/activity_list_screen_test.dart
// Tests for ActivityListScreen following ConditionListScreen test pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/activities/activity_list_provider.dart';
import 'package:shadow_app/presentation/screens/activities/activity_list_screen.dart';

void main() {
  group('ActivityListScreen', () {
    const testProfileId = 'profile-001';

    Activity createTestActivity({
      String id = 'act-001',
      String name = 'Morning Run',
      int durationMinutes = 30,
      String? description,
      String? location,
      bool isArchived = false,
    }) => Activity(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      durationMinutes: durationMinutes,
      description: description,
      location: location,
      isArchived: isArchived,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildScreen([List<Activity> activities = const []]) => ProviderScope(
      overrides: [
        activityListProvider(
          testProfileId,
        ).overrideWith(() => _MockActivityList(activities)),
      ],
      child: const MaterialApp(
        home: ActivityListScreen(profileId: testProfileId),
      ),
    );

    testWidgets('renders app bar with title Activities', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Activities'), findsOneWidget);
    });

    testWidgets('renders FAB for adding activities', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders empty state when no activities', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('No activities yet'), findsOneWidget);
    });

    testWidgets('renders activity name and duration when data present', (
      tester,
    ) async {
      final activity = createTestActivity();
      await tester.pumpWidget(buildScreen([activity]));
      await tester.pumpAndSettle();
      expect(find.text('Morning Run'), findsOneWidget);
      expect(find.text('30 min'), findsOneWidget);
    });

    testWidgets('separates active and archived activities into sections', (
      tester,
    ) async {
      final active = createTestActivity();
      final archived = createTestActivity(
        id: 'act-002',
        name: 'Yoga',
        isArchived: true,
      );
      await tester.pumpWidget(buildScreen([active, archived]));
      await tester.pumpAndSettle();
      expect(find.text('Active Activities'), findsOneWidget);
      expect(find.text('Archived Activities'), findsOneWidget);
      expect(find.text('Morning Run'), findsOneWidget);
      expect(find.text('Yoga'), findsOneWidget);
    });

    testWidgets('section headers have header semantics', (tester) async {
      final activity = createTestActivity();
      await tester.pumpWidget(buildScreen([activity]));
      await tester.pumpAndSettle();
      final headerFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && (widget.properties.header ?? false),
      );
      expect(headerFinder, findsWidgets);
    });

    group('accessibility', () {
      testWidgets('FAB has semantic label Add new activity', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel('Add new activity'), findsOneWidget);
      });

      testWidgets('body has semantic label Activity list', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.label == 'Activity list',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('popup menu', () {
      testWidgets('shows Edit and Archive options', (tester) async {
        final activity = createTestActivity();
        await tester.pumpWidget(buildScreen([activity]));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Archive'), findsOneWidget);
      });

      testWidgets('shows Unarchive for archived activities', (tester) async {
        final archived = createTestActivity(isArchived: true);
        await tester.pumpWidget(buildScreen([archived]));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        expect(find.text('Unarchive'), findsOneWidget);
      });
    });

    group('loading and error states', () {
      testWidgets('error state renders with retry button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              activityListProvider(
                testProfileId,
              ).overrideWith(_ErrorActivityList.new),
            ],
            child: const MaterialApp(
              home: ActivityListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Failed to load activities'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });
  });
}

class _MockActivityList extends ActivityList {
  final List<Activity> _activities;
  _MockActivityList(this._activities);
  @override
  Future<List<Activity>> build(String profileId) async => _activities;
}

class _ErrorActivityList extends ActivityList {
  @override
  Future<List<Activity>> build(String profileId) async {
    throw Exception('Failed to load activities');
  }
}
