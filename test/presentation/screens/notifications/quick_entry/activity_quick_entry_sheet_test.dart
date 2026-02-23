// test/presentation/screens/notifications/quick_entry/activity_quick_entry_sheet_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/usecases/activity_logs/activity_log_inputs.dart';
import 'package:shadow_app/presentation/providers/activities/activity_list_provider.dart';
import 'package:shadow_app/presentation/providers/activity_logs/activity_log_list_provider.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/activity_quick_entry_sheet.dart';

void main() {
  group('ActivityQuickEntrySheet', () {
    const profileId = 'profile-001';

    Activity createTestActivity({
      String id = 'act-001',
      String name = 'Running',
    }) => Activity(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      name: name,
      durationMinutes: 30,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildSheet({
      List<Activity> activities = const [],
      ActivityLogList Function()? logMockFactory,
    }) => ProviderScope(
      overrides: [
        activityListProvider(
          profileId,
        ).overrideWith(() => _MockActivityList(activities)),
        activityLogListProvider(
          profileId,
        ).overrideWith(logMockFactory ?? _MockActivityLogList.new),
      ],
      child: const MaterialApp(
        home: Scaffold(body: ActivityQuickEntrySheet(profileId: profileId)),
      ),
    );

    testWidgets('renders Log Activity title', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Log Activity'), findsWidgets);
    });

    testWidgets('renders duration text field', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('renders Log Activity button', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Log Activity'), findsWidgets);
    });

    testWidgets('renders intensity segmented button', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Moderate'), findsOneWidget);
    });

    testWidgets('renders activity type dropdown when activities defined', (
      tester,
    ) async {
      await tester.pumpWidget(buildSheet(activities: [createTestActivity()]));
      await tester.pumpAndSettle();

      expect(find.text('Activity Type'), findsOneWidget);
    });

    testWidgets('shows no activities message when empty', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('No activities defined yet.'), findsOneWidget);
    });

    testWidgets('shows error when duration is empty', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log Activity').last);
      await tester.pump();

      expect(find.text('Duration is required'), findsOneWidget);
    });

    testWidgets('shows error when duration is not a positive number', (
      tester,
    ) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '0');
      await tester.tap(find.text('Log Activity').last);
      await tester.pump();

      expect(find.text('Enter a positive number of minutes'), findsOneWidget);
    });

    testWidgets('calls log when duration entered and save tapped', (
      tester,
    ) async {
      final mock = _MockActivityLogList();
      await tester.pumpWidget(buildSheet(logMockFactory: () => mock));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '30');
      await tester.tap(find.text('Log Activity').last);
      await tester.pump();

      expect(mock.logCalled, isTrue);
    });

    testWidgets('passes duration to log input', (tester) async {
      final mock = _MockActivityLogList();
      await tester.pumpWidget(buildSheet(logMockFactory: () => mock));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '45');
      await tester.tap(find.text('Log Activity').last);
      await tester.pump();

      expect(mock.lastInput?.duration, equals(45));
    });

    testWidgets('shows error snackbar on save failure', (tester) async {
      await tester.pumpWidget(
        buildSheet(logMockFactory: _ErrorActivityLogList.new),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '30');
      await tester.tap(find.text('Log Activity').last);
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
              w.properties.label == 'Activity log quick-entry sheet',
        ),
        findsOneWidget,
      );
    });
  });
}

class _MockActivityList extends ActivityList {
  final List<Activity> _items;
  _MockActivityList(this._items);

  @override
  Future<List<Activity>> build(String profileId) async => _items;
}

class _MockActivityLogList extends ActivityLogList {
  bool logCalled = false;
  LogActivityInput? lastInput;

  @override
  Future<List<ActivityLog>> build(String profileId) async => [];

  @override
  Future<void> log(LogActivityInput input) async {
    logCalled = true;
    lastInput = input;
  }
}

class _ErrorActivityLogList extends ActivityLogList {
  @override
  Future<List<ActivityLog>> build(String profileId) async => [];

  @override
  Future<void> log(LogActivityInput input) async {
    throw DatabaseError.insertFailed('activity_logs');
  }
}
