// test/presentation/screens/activity_logs/activity_log_screen_test.dart
// Tests for ActivityLogScreen following FoodLogScreen test pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/activities/activity_list_provider.dart';
import 'package:shadow_app/presentation/providers/activity_logs/activity_log_list_provider.dart';
import 'package:shadow_app/presentation/screens/activity_logs/activity_log_screen.dart';

void main() {
  group('ActivityLogScreen', () {
    const testProfileId = 'profile-001';

    Activity createTestActivity({
      String id = 'act-001',
      String name = 'Morning Run',
      int durationMinutes = 30,
    }) => Activity(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      durationMinutes: durationMinutes,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildScreen({
      ActivityLog? activityLog,
      List<Activity> activities = const [],
    }) => ProviderScope(
      overrides: [
        activityLogListProvider(
          testProfileId,
        ).overrideWith(() => _MockActivityLogList([])),
        activityListProvider(
          testProfileId,
        ).overrideWith(() => _MockActivityList(activities)),
      ],
      child: MaterialApp(
        home: ActivityLogScreen(
          profileId: testProfileId,
          activityLog: activityLog,
        ),
      ),
    );

    testWidgets('renders Log Activity title in add mode', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Log Activity'), findsOneWidget);
    });

    testWidgets('renders date and time section', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Date & Time'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('renders Activities section header', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Activities'), findsOneWidget);
    });

    testWidgets('renders Ad-hoc Activities section header', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Ad-hoc Activities'), findsOneWidget);
    });

    testWidgets('renders activity chips when activities available', (
      tester,
    ) async {
      final activities = [
        createTestActivity(name: 'Running'),
        createTestActivity(id: 'act-002', name: 'Swimming'),
      ];
      await tester.pumpWidget(buildScreen(activities: activities));
      await tester.pumpAndSettle();
      expect(find.text('Running'), findsOneWidget);
      expect(find.text('Swimming'), findsOneWidget);
    });

    testWidgets('renders Save and Cancel buttons', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    group('accessibility', () {
      testWidgets('body has form semantic label', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Log activity form',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('edit mode', () {
      testWidgets('renders Edit Activity Log title', (tester) async {
        final log = ActivityLog(
          id: 'log-001',
          clientId: 'client-001',
          profileId: testProfileId,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          syncMetadata: SyncMetadata.empty(),
        );
        await tester.pumpWidget(buildScreen(activityLog: log));
        await tester.pumpAndSettle();
        expect(find.text('Edit Activity Log'), findsOneWidget);
      });
    });
  });
}

class _MockActivityLogList extends ActivityLogList {
  final List<ActivityLog> _logs;
  _MockActivityLogList(this._logs);
  @override
  Future<List<ActivityLog>> build(String profileId) async => _logs;
}

class _MockActivityList extends ActivityList {
  final List<Activity> _activities;
  _MockActivityList(this._activities);
  @override
  Future<List<Activity>> build(String profileId) async => _activities;
}
