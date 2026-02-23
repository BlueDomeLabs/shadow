// test/presentation/screens/notifications/notification_settings_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/notification_permission_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/domain/usecases/notifications/get_anchor_event_times_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/get_notification_settings_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/notification_inputs.dart';
import 'package:shadow_app/domain/usecases/notifications/update_anchor_event_time_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/update_notification_category_settings_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/notifications/notification_settings_screen.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Test data
  // ---------------------------------------------------------------------------

  List<AnchorEventTime> makeAnchorTimes() => AnchorEventName.values
      .map(
        (name) => AnchorEventTime(
          id: 'anchor-${name.value}',
          name: name,
          timeOfDay: name.defaultTime,
        ),
      )
      .toList();

  List<NotificationCategorySettings> makeSettings({
    bool supplementsEnabled = false,
    NotificationSchedulingMode supplementsMode =
        NotificationSchedulingMode.anchorEvents,
  }) => NotificationCategory.values
      .map(
        (c) => NotificationCategorySettings(
          id: 'setting-${c.value}',
          category: c,
          schedulingMode: c == NotificationCategory.supplements
              ? supplementsMode
              : NotificationSchedulingMode.anchorEvents,
          isEnabled:
              c == NotificationCategory.supplements && supplementsEnabled,
        ),
      )
      .toList();

  Widget buildScreen({
    List<AnchorEventTime>? anchorTimes,
    List<NotificationCategorySettings>? settings,
  }) {
    final container = ProviderContainer(
      overrides: [
        getAnchorEventTimesUseCaseProvider.overrideWithValue(
          _FakeGetAnchorEventTimes(anchorTimes ?? makeAnchorTimes()),
        ),
        getNotificationSettingsUseCaseProvider.overrideWithValue(
          _FakeGetNotificationSettings(settings ?? makeSettings()),
        ),
        updateAnchorEventTimeUseCaseProvider.overrideWithValue(
          _FakeUpdateAnchorEventTime(),
        ),
        updateNotificationCategorySettingsUseCaseProvider.overrideWithValue(
          _FakeUpdateNotificationCategorySettings(),
        ),
        notificationPermissionServiceProvider.overrideWithValue(
          _FakeNotificationPermissionService(),
        ),
      ],
    );
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: NotificationSettingsScreen()),
    );
  }

  // ---------------------------------------------------------------------------
  // Section 1: Anchor Event Times
  // ---------------------------------------------------------------------------

  group('Anchor Event Times section', () {
    testWidgets('renders section header', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Anchor Event Times'), findsOneWidget);
    });

    testWidgets('shows all 5 anchor event names', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Wake'), findsOneWidget);
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);
      expect(find.text('Bedtime'), findsOneWidget);
    });

    testWidgets('shows formatted time for Wake event', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Wake default is 07:00 → "7:00 AM"
      expect(find.text('7:00 AM'), findsOneWidget);
    });

    testWidgets('shows enable/disable switch for each anchor event', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // 5 anchor event switches + potentially 8 category switches = at least 5
      final switches = tester.widgetList<Switch>(find.byType(Switch));
      expect(switches.length, greaterThanOrEqualTo(5));
    });
  });

  // ---------------------------------------------------------------------------
  // Section 2: Notification Reminders
  // ---------------------------------------------------------------------------

  group('Notification Reminders section', () {
    testWidgets('renders section header', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Notification Reminders'), findsOneWidget);
    });

    testWidgets('shows all 8 category names', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Supplements'), findsOneWidget);
      expect(find.text('Food & Meals'), findsOneWidget);
      expect(find.text('Fluids'), findsOneWidget);
      expect(find.text('Photos'), findsOneWidget);
      expect(find.text('Journal Entries'), findsOneWidget);
      expect(find.text('Activities'), findsOneWidget);
      expect(find.text('Condition Check-ins'), findsOneWidget);
      expect(find.text('BBT & Vitals'), findsOneWidget);
    });

    testWidgets('mode selector is hidden when category is disabled', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // SegmentedButton segments only appear when a category is enabled
      expect(find.text('Anchor'), findsNothing);
      expect(find.text('Interval'), findsNothing);
      expect(find.text('Specific'), findsNothing);
    });

    testWidgets('shows mode selector when supplements is enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildScreen(settings: makeSettings(supplementsEnabled: true)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Anchor'), findsOneWidget);
      expect(find.text('Interval'), findsOneWidget);
      expect(find.text('Specific'), findsOneWidget);
    });

    testWidgets('shows anchor event checkboxes when in anchor events mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildScreen(settings: makeSettings(supplementsEnabled: true)),
      );
      await tester.pumpAndSettle();

      // Anchor events config shows CheckboxListTile for each anchor event name
      expect(find.byType(CheckboxListTile), findsWidgets);
    });

    testWidgets('shows interval dropdown when in interval mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildScreen(
          settings: makeSettings(
            supplementsEnabled: true,
            supplementsMode: NotificationSchedulingMode.interval,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Repeat interval: '), findsOneWidget);
      expect(find.text('Start time'), findsOneWidget);
      expect(find.text('End time'), findsOneWidget);
    });

    testWidgets('shows add time button when in specific times mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildScreen(
          settings: makeSettings(
            supplementsEnabled: true,
            supplementsMode: NotificationSchedulingMode.specificTimes,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add time'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Section 3: General
  // ---------------------------------------------------------------------------

  group('General section', () {
    testWidgets('renders section header', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('General'), findsOneWidget);
    });

    testWidgets('shows notification expiry label', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Notification Expiry: '), findsOneWidget);
    });

    testWidgets('shows permission row', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Notification Permission'), findsOneWidget);
    });

    testWidgets('shows permission request subtitle', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Tap to request notification access'), findsOneWidget);
    });
  });
}

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeGetAnchorEventTimes implements GetAnchorEventTimesUseCase {
  final List<AnchorEventTime> _times;
  _FakeGetAnchorEventTimes(this._times);

  @override
  Future<Result<List<AnchorEventTime>, AppError>> call() async =>
      Success(_times);
}

class _FakeGetNotificationSettings implements GetNotificationSettingsUseCase {
  final List<NotificationCategorySettings> _settings;
  _FakeGetNotificationSettings(this._settings);

  @override
  Future<Result<List<NotificationCategorySettings>, AppError>> call() async =>
      Success(_settings);
}

class _FakeUpdateAnchorEventTime implements UpdateAnchorEventTimeUseCase {
  @override
  Future<Result<AnchorEventTime, AppError>> call(
    UpdateAnchorEventTimeInput input,
  ) async => Success(
    AnchorEventTime(
      id: input.id,
      name: AnchorEventName.wake,
      timeOfDay: input.timeOfDay ?? '07:00',
    ),
  );
}

class _FakeUpdateNotificationCategorySettings
    implements UpdateNotificationCategorySettingsUseCase {
  @override
  Future<Result<NotificationCategorySettings, AppError>> call(
    UpdateNotificationCategorySettingsInput input,
  ) async => Success(
    NotificationCategorySettings(
      id: input.id,
      category: NotificationCategory.supplements,
      schedulingMode:
          input.schedulingMode ?? NotificationSchedulingMode.anchorEvents,
    ),
  );
}

class _FakeNotificationPermissionService
    implements NotificationPermissionService {
  @override
  Future<bool> requestPermission() async => true;
}
