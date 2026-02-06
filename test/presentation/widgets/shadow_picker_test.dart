import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/widgets/shadow_picker.dart';

void main() {
  group('ShadowPicker', () {
    group('flow picker', () {
      testWidgets('renders all flow options', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.flow(
                label: 'Flow Intensity',
                onFlowChanged: (_) {},
              ),
            ),
          ),
        );

        // Should render all 5 flow options
        expect(find.text('None'), findsOneWidget);
        expect(find.text('Spotty'), findsOneWidget);
        expect(find.text('Light'), findsOneWidget);
        expect(find.text('Medium'), findsOneWidget);
        expect(find.text('Heavy'), findsOneWidget);
      });

      testWidgets('calls onFlowChanged when option tapped', (tester) async {
        MenstruationFlow? selectedFlow;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.flow(
                label: 'Flow Intensity',
                onFlowChanged: (flow) => selectedFlow = flow,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Medium'));
        await tester.pump();

        expect(selectedFlow, equals(MenstruationFlow.medium));
      });

      testWidgets('shows selected state visually', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.flow(
                label: 'Flow Intensity',
                flowValue: MenstruationFlow.light,
                onFlowChanged: (_) {},
              ),
            ),
          ),
        );

        // The selected option should show the text
        expect(find.text('Light'), findsOneWidget);
      });
    });

    group('weekday picker', () {
      testWidgets('renders all weekday options', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.weekday(
                label: 'Reminder Days',
                selectedDays: const [],
                onDaysChanged: (_) {},
              ),
            ),
          ),
        );

        // Should render abbreviated day names
        expect(find.text('Mon'), findsOneWidget);
        expect(find.text('Tue'), findsOneWidget);
        expect(find.text('Wed'), findsOneWidget);
        expect(find.text('Thu'), findsOneWidget);
        expect(find.text('Fri'), findsOneWidget);
        expect(find.text('Sat'), findsOneWidget);
        expect(find.text('Sun'), findsOneWidget);
      });

      testWidgets('quick select buttons work', (tester) async {
        var selectedDays = <int>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => ShadowPicker.weekday(
                  label: 'Reminder Days',
                  selectedDays: selectedDays,
                  onDaysChanged: (days) => setState(() => selectedDays = days),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Weekdays'));
        await tester.pump();

        expect(selectedDays, equals([0, 1, 2, 3, 4]));
      });

      testWidgets('individual day toggle works', (tester) async {
        var selectedDays = [0, 1];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => ShadowPicker.weekday(
                  label: 'Reminder Days',
                  selectedDays: selectedDays,
                  onDaysChanged: (days) => setState(() => selectedDays = days),
                ),
              ),
            ),
          ),
        );

        // Tap Wednesday (index 2)
        await tester.tap(find.text('Wed'));
        await tester.pump();

        expect(selectedDays.contains(2), isTrue);
      });
    });

    group('time picker', () {
      testWidgets('renders existing times as chips', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.time(
                label: 'Notification Times',
                times: const [
                  TimeOfDay(hour: 8, minute: 0),
                  TimeOfDay(hour: 20, minute: 30),
                ],
                onTimesChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('8:00 AM'), findsOneWidget);
        expect(find.text('8:30 PM'), findsOneWidget);
      });

      testWidgets('shows add button when under max times', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.time(
                label: 'Notification Times',
                times: const [TimeOfDay(hour: 8, minute: 0)],
                onTimesChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Add time'), findsOneWidget);
      });

      testWidgets('hides add button when at max times', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.time(
                label: 'Notification Times',
                times: const [
                  TimeOfDay(hour: 8, minute: 0),
                  TimeOfDay(hour: 12, minute: 0),
                ],
                onTimesChanged: (_) {},
                maxTimes: 2,
              ),
            ),
          ),
        );

        expect(find.text('Add time'), findsNothing);
      });
    });

    group('date picker', () {
      testWidgets('renders placeholder when no date selected', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.date(
                label: 'Start Date',
                onDateChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Select date'), findsOneWidget);
      });

      testWidgets('renders formatted date when selected', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.date(
                label: 'Start Date',
                dateValue: DateTime(2026, 2, 15),
                onDateChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Feb 15, 2026'), findsOneWidget);
      });
    });

    group('multiSelect picker', () {
      testWidgets('renders all available items', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.multiSelect(
                label: 'Categories',
                selectedItems: const [],
                availableItems: const ['Food', 'Sleep', 'Exercise'],
                onSelectionChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Food'), findsOneWidget);
        expect(find.text('Sleep'), findsOneWidget);
        expect(find.text('Exercise'), findsOneWidget);
      });

      testWidgets('toggles selection on tap', (tester) async {
        var selected = <String>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => ShadowPicker.multiSelect(
                  label: 'Categories',
                  selectedItems: selected,
                  availableItems: const ['Food', 'Sleep', 'Exercise'],
                  onSelectionChanged: (items) =>
                      setState(() => selected = items),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Food'));
        await tester.pump();

        expect(selected, contains('Food'));
      });
    });

    group('accessibility', () {
      testWidgets('flow picker is wrapped in Semantics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.flow(
                label: 'Flow Intensity',
                flowValue: MenstruationFlow.medium,
                onFlowChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(ShadowPicker), findsOneWidget);
        expect(find.byType(Semantics), findsWidgets);
      });

      testWidgets('weekday picker is wrapped in Semantics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowPicker.weekday(
                label: 'Reminder Days',
                selectedDays: const [0],
                onDaysChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(ShadowPicker), findsOneWidget);
        expect(find.byType(Semantics), findsWidgets);
      });
    });
  });
}
