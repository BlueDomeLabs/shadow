// test/presentation/screens/fluids_entries/fluids_entry_bbt_section_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/fluids_entries/fluids_entry_bbt_section.dart';

void main() {
  late TextEditingController bbtController;

  setUp(() {
    bbtController = TextEditingController();
  });

  tearDown(() {
    bbtController.dispose();
  });

  final baseTime = DateTime(2024, 6, 15, 8, 30);

  Widget buildWidget({
    bool useMetric = false,
    DateTime? recordedTime,
    String? bbtError,
    ValueChanged<bool>? onUnitChanged,
    void Function(DateTime)? onRecordedTimeChanged,
    VoidCallback? onBBTChanged,
  }) => MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: FluidsEntryBBTSection(
          bbtController: bbtController,
          useMetric: useMetric,
          recordedTime: recordedTime ?? baseTime,
          bbtError: bbtError,
          onUnitChanged: onUnitChanged ?? (_) {},
          onRecordedTimeChanged: onRecordedTimeChanged ?? (_) {},
          onBBTChanged: onBBTChanged ?? () {},
        ),
      ),
    ),
  );

  group('FluidsEntryBBTSection', () {
    group('rendering', () {
      testWidgets('shows Temperature field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Temperature'), findsOneWidget);
      });

      testWidgets('shows Unit dropdown', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Unit'), findsOneWidget);
      });

      testWidgets('shows Time Recorded picker', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Time Recorded'), findsOneWidget);
        expect(find.byIcon(Icons.access_time), findsOneWidget);
      });

      testWidgets('shows °F by default', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('°F'), findsOneWidget);
      });

      testWidgets('shows °C when useMetric is true', (tester) async {
        await tester.pumpWidget(buildWidget(useMetric: true));
        expect(find.text('°C'), findsOneWidget);
      });

      testWidgets('shows formatted time', (tester) async {
        await tester.pumpWidget(buildWidget(recordedTime: baseTime));
        // 8:30 AM
        expect(find.text('8:30 AM'), findsOneWidget);
      });

      testWidgets('shows bbtError when set', (tester) async {
        await tester.pumpWidget(
          buildWidget(bbtError: 'Must be between 95–105'),
        );
        expect(find.text('Must be between 95–105'), findsOneWidget);
      });
    });

    group('callbacks', () {
      testWidgets('unit toggle fires onUnitChanged with correct value', (
        tester,
      ) async {
        bool? received;
        await tester.pumpWidget(
          buildWidget(onUnitChanged: (val) => received = val),
        );
        // Default is °F (false); open dropdown and select °C
        await tester.tap(find.text('°F'));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        await tester.tap(find.text('°C').last);
        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(received, isTrue);
      });

      testWidgets('onBBTChanged fires when text changes', (tester) async {
        var called = false;
        await tester.pumpWidget(buildWidget(onBBTChanged: () => called = true));
        await tester.enterText(find.byType(TextField).first, '98.6');
        expect(called, isTrue);
      });
    });
  });
}
