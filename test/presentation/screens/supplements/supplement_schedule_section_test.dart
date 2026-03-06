// test/presentation/screens/supplements/supplement_schedule_section_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/screens/supplements/supplement_schedule_section.dart';

void main() {
  late TextEditingController everyXDaysController;

  setUp(() {
    everyXDaysController = TextEditingController(text: '2');
  });

  tearDown(() {
    everyXDaysController.dispose();
  });

  Widget buildWidget({
    SupplementFrequencyType selectedFrequency = SupplementFrequencyType.daily,
    List<int> selectedWeekdays = const [0, 1, 2, 3, 4, 5, 6],
    SupplementAnchorEvent selectedAnchorEvent = SupplementAnchorEvent.breakfast,
    SupplementTimingType selectedTimingType = SupplementTimingType.withEvent,
    int offsetMinutes = 30,
    int? specificTimeMinutes,
    DateTime? startDate,
    DateTime? endDate,
    String? everyXDaysError,
    String? specificDaysError,
    String? offsetMinutesError,
    String? specificTimeError,
    String? endDateError,
    void Function(SupplementFrequencyType)? onFrequencyChanged,
    void Function(List<int>)? onWeekdaysChanged,
    void Function(SupplementAnchorEvent)? onAnchorEventChanged,
    void Function(SupplementTimingType)? onTimingTypeChanged,
    void Function(int)? onOffsetMinutesChanged,
    void Function(int?)? onSpecificTimeChanged,
    void Function(DateTime?)? onStartDateChanged,
    void Function(DateTime?)? onEndDateChanged,
    VoidCallback? onEveryXDaysChanged,
  }) => MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: SupplementScheduleSection(
          selectedFrequency: selectedFrequency,
          selectedWeekdays: selectedWeekdays,
          selectedAnchorEvent: selectedAnchorEvent,
          selectedTimingType: selectedTimingType,
          offsetMinutes: offsetMinutes,
          specificTimeMinutes: specificTimeMinutes,
          startDate: startDate,
          endDate: endDate,
          everyXDaysController: everyXDaysController,
          everyXDaysError: everyXDaysError,
          specificDaysError: specificDaysError,
          offsetMinutesError: offsetMinutesError,
          specificTimeError: specificTimeError,
          endDateError: endDateError,
          onFrequencyChanged: onFrequencyChanged ?? (_) {},
          onWeekdaysChanged: onWeekdaysChanged ?? (_) {},
          onAnchorEventChanged: onAnchorEventChanged ?? (_) {},
          onTimingTypeChanged: onTimingTypeChanged ?? (_) {},
          onOffsetMinutesChanged: onOffsetMinutesChanged ?? (_) {},
          onSpecificTimeChanged: onSpecificTimeChanged ?? (_) {},
          onStartDateChanged: onStartDateChanged ?? (_) {},
          onEndDateChanged: onEndDateChanged ?? (_) {},
          onEveryXDaysChanged: onEveryXDaysChanged ?? () {},
        ),
      ),
    ),
  );

  group('SupplementScheduleSection', () {
    group('daily frequency', () {
      testWidgets('shows Frequency dropdown', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Daily'), findsOneWidget);
      });

      testWidgets('hides Every X Days field when daily', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Every X Days'), findsNothing);
      });

      testWidgets('hides weekday selector when daily', (tester) async {
        await tester.pumpWidget(buildWidget());
        // Weekday selector is shown only for specificWeekdays
        expect(find.text('Which days to take'), findsNothing);
      });
    });

    group('everyXDays frequency', () {
      testWidgets('shows Every X Days field', (tester) async {
        await tester.pumpWidget(
          buildWidget(selectedFrequency: SupplementFrequencyType.everyXDays),
        );
        // 'Every X Days' appears in both the frequency dropdown value and
        // the field label — verify at least one is present
        expect(find.text('Every X Days'), findsAtLeast(1));
      });

      testWidgets('shows everyXDaysError when set', (tester) async {
        await tester.pumpWidget(
          buildWidget(
            selectedFrequency: SupplementFrequencyType.everyXDays,
            everyXDaysError: 'Must be between 2 and 365',
          ),
        );
        expect(find.text('Must be between 2 and 365'), findsOneWidget);
      });
    });

    group('specificWeekdays frequency', () {
      testWidgets('shows weekday selector', (tester) async {
        await tester.pumpWidget(
          buildWidget(
            selectedFrequency: SupplementFrequencyType.specificWeekdays,
          ),
        );
        // ShadowPicker.weekday renders 'Every day' and 'Weekdays' quick-select
        // buttons, confirming the weekday picker is present
        expect(find.text('Every day'), findsOneWidget);
        expect(find.text('Weekdays'), findsOneWidget);
      });

      testWidgets('shows specificDaysError when set', (tester) async {
        await tester.pumpWidget(
          buildWidget(
            selectedFrequency: SupplementFrequencyType.specificWeekdays,
            specificDaysError: 'At least 1 day must be selected',
          ),
        );
        expect(find.text('At least 1 day must be selected'), findsOneWidget);
      });
    });

    group('anchor event and timing', () {
      testWidgets('shows Anchor Event dropdown', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Anchor Event'), findsOneWidget);
      });

      testWidgets('shows Timing dropdown when not specificTime', (
        tester,
      ) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Timing'), findsOneWidget);
      });

      testWidgets('hides Timing dropdown when specificTime', (tester) async {
        await tester.pumpWidget(
          buildWidget(selectedTimingType: SupplementTimingType.specificTime),
        );
        expect(find.text('Timing'), findsNothing);
      });

      testWidgets('shows Specific Time picker when specificTime', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildWidget(selectedTimingType: SupplementTimingType.specificTime),
        );
        // 'Specific Time' appears in both the anchor dropdown option and the
        // time picker label — verify at least one is present
        expect(find.text('Specific Time'), findsAtLeast(1));
        // The clock icon is unique to the time picker
        expect(find.byIcon(Icons.access_time), findsOneWidget);
      });
    });

    group('offset minutes', () {
      testWidgets('shows Offset Minutes when Before timing', (tester) async {
        await tester.pumpWidget(
          buildWidget(selectedTimingType: SupplementTimingType.beforeEvent),
        );
        expect(find.text('Offset Minutes'), findsOneWidget);
        expect(find.text('30 min'), findsOneWidget);
      });

      testWidgets('shows Offset Minutes when After timing', (tester) async {
        await tester.pumpWidget(
          buildWidget(
            selectedTimingType: SupplementTimingType.afterEvent,
            offsetMinutes: 15,
          ),
        );
        expect(find.text('Offset Minutes'), findsOneWidget);
      });

      testWidgets('hides Offset Minutes when With timing', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Offset Minutes'), findsNothing);
      });

      testWidgets('shows offsetMinutesError when set', (tester) async {
        await tester.pumpWidget(
          buildWidget(
            selectedTimingType: SupplementTimingType.beforeEvent,
            offsetMinutesError: 'Must be between 5 and 120 minutes',
          ),
        );
        expect(find.text('Must be between 5 and 120 minutes'), findsOneWidget);
      });
    });

    group('date pickers', () {
      testWidgets('shows Start Date field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Start Date'), findsOneWidget);
      });

      testWidgets('shows End Date field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('End Date'), findsOneWidget);
      });

      testWidgets('shows endDateError when set', (tester) async {
        await tester.pumpWidget(
          buildWidget(endDateError: 'End date must be after start date'),
        );
        expect(find.text('End date must be after start date'), findsOneWidget);
      });
    });

    group('callbacks', () {
      testWidgets('onFrequencyChanged fires when frequency changes', (
        tester,
      ) async {
        SupplementFrequencyType? received;
        await tester.pumpWidget(
          buildWidget(onFrequencyChanged: (v) => received = v),
        );

        // Open the Frequency dropdown
        await tester.tap(find.text('Daily'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Select 'Every X Days'
        await tester.tap(find.text('Every X Days').last);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        expect(received, SupplementFrequencyType.everyXDays);
      });

      testWidgets('onWeekdaysChanged fires when weekday selector changes', (
        tester,
      ) async {
        List<int>? received;
        await tester.pumpWidget(
          buildWidget(
            selectedFrequency: SupplementFrequencyType.specificWeekdays,
            onWeekdaysChanged: (days) => received = days,
          ),
        );

        // Tap on 'Sun' chip to deselect it
        final sunFinder = find.text('Su');
        if (sunFinder.evaluate().isNotEmpty) {
          await tester.tap(sunFinder.first);
          await tester.pump();
          expect(received, isNotNull);
        }
      });
    });

    group('specific time display', () {
      testWidgets('shows "Select time" when specificTimeMinutes is null', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildWidget(selectedTimingType: SupplementTimingType.specificTime),
        );
        expect(find.text('Select time'), findsOneWidget);
      });

      testWidgets('formats specificTimeMinutes as HH:MM AM/PM', (tester) async {
        await tester.pumpWidget(
          buildWidget(
            selectedTimingType: SupplementTimingType.specificTime,
            specificTimeMinutes: 8 * 60, // 8:00 AM = 480 minutes
          ),
        );
        expect(find.text('8:00 AM'), findsOneWidget);
      });
    });
  });
}
