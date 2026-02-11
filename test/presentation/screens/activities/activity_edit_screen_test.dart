// test/presentation/screens/activities/activity_edit_screen_test.dart
// Tests for ActivityEditScreen following ConditionEditScreen test pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/activities/activity_list_provider.dart';
import 'package:shadow_app/presentation/screens/activities/activity_edit_screen.dart';

void main() {
  group('ActivityEditScreen', () {
    const testProfileId = 'profile-001';

    Activity createTestActivity({
      String id = 'act-001',
      String name = 'Morning Run',
      int durationMinutes = 30,
      String? description,
      String? location,
      String? triggers,
    }) => Activity(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      durationMinutes: durationMinutes,
      description: description,
      location: location,
      triggers: triggers,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildAddScreen() => ProviderScope(
      overrides: [
        activityListProvider(
          testProfileId,
        ).overrideWith(() => _MockActivityList([])),
      ],
      child: const MaterialApp(
        home: ActivityEditScreen(profileId: testProfileId),
      ),
    );

    Widget buildEditScreen(Activity activity) => ProviderScope(
      overrides: [
        activityListProvider(
          testProfileId,
        ).overrideWith(() => _MockActivityList([activity])),
      ],
      child: MaterialApp(
        home: ActivityEditScreen(profileId: testProfileId, activity: activity),
      ),
    );

    Future<void> scrollToBottom(WidgetTester tester) async {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
    }

    group('add mode', () {
      testWidgets('renders Add Activity title', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        expect(find.text('Add Activity'), findsOneWidget);
      });

      testWidgets('renders all form fields', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        expect(find.text('Activity Name'), findsOneWidget);
        expect(find.text('Duration (minutes)'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
        await scrollToBottom(tester);
        expect(find.text('Location'), findsOneWidget);
        expect(find.text('Triggers'), findsOneWidget);
      });

      testWidgets('renders Save and Cancel buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('renders section headers', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        expect(find.text('Basic Information'), findsOneWidget);
        await scrollToBottom(tester);
        expect(find.text('Details'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('activity name has semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Activity name, required',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('duration has semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Duration in minutes, required',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('body has form semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Add activity form',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('edit mode', () {
      testWidgets('renders Edit Activity title', (tester) async {
        final activity = createTestActivity();
        await tester.pumpWidget(buildEditScreen(activity));
        await tester.pumpAndSettle();
        expect(find.text('Edit Activity'), findsOneWidget);
      });

      testWidgets('populates name from activity', (tester) async {
        final activity = createTestActivity(name: 'Yoga');
        await tester.pumpWidget(buildEditScreen(activity));
        await tester.pumpAndSettle();
        expect(find.text('Yoga'), findsOneWidget);
      });

      testWidgets('populates duration from activity', (tester) async {
        final activity = createTestActivity(durationMinutes: 45);
        await tester.pumpWidget(buildEditScreen(activity));
        await tester.pumpAndSettle();
        expect(find.text('45'), findsOneWidget);
      });

      testWidgets('shows Save Changes button in edit mode', (tester) async {
        final activity = createTestActivity();
        await tester.pumpWidget(buildEditScreen(activity));
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.text('Save Changes'), findsOneWidget);
      });

      testWidgets('body has edit mode semantic label', (tester) async {
        final activity = createTestActivity();
        await tester.pumpWidget(buildEditScreen(activity));
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Edit activity form',
        );
        expect(semanticsFinder, findsOneWidget);
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
