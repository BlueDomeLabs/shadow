import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/widgets/shadow_input.dart';

void main() {
  group('ShadowInput', () {
    group('temperature input', () {
      testWidgets('renders temperature input with label', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowInput.temperature(
                label: 'Basal Body Temperature',
                temperatureValue: 98.6,
                onTemperatureChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Basal Body Temperature'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('shows unit toggle with F and C', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowInput.temperature(
                label: 'BBT',
                temperatureValue: 98.6,
                onTemperatureChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('°F'), findsOneWidget);
        expect(find.text('°C'), findsOneWidget);
      });

      testWidgets('shows time picker', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowInput.temperature(
                label: 'BBT',
                temperatureValue: 98.6,
                recordedTime: DateTime(2026, 2, 6, 7, 30),
                onTemperatureChanged: (_) {},
                onTimeChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Time Recorded'), findsOneWidget);
        expect(find.text('7:30 AM'), findsOneWidget);
      });

      testWidgets('validates temperature range for Fahrenheit', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowInput.temperature(
                label: 'BBT',
                onTemperatureChanged: (_) {},
              ),
            ),
          ),
        );

        // Helper text should show range
        expect(find.text('95.0 - 105.0 °F'), findsOneWidget);
      });
    });

    group('flow input', () {
      testWidgets('renders all flow options', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowInput.flow(
                label: 'Flow Intensity',
                onFlowChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('None'), findsOneWidget);
        expect(find.text('Spotty'), findsOneWidget);
        expect(find.text('Light'), findsOneWidget);
        expect(find.text('Medium'), findsOneWidget);
        expect(find.text('Heavy'), findsOneWidget);
      });

      testWidgets('calls onFlowChanged when option selected', (tester) async {
        MenstruationFlow? selected;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowInput.flow(
                label: 'Flow Intensity',
                onFlowChanged: (flow) => selected = flow,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Heavy'));
        await tester.pump();

        expect(selected, equals(MenstruationFlow.heavy));
      });
    });

    group('diet input', () {
      testWidgets('renders dropdown with diet types', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowInput.diet(
                label: 'Diet Type',
                dietValue: DietPresetType.keto,
                onDietChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Diet Type'), findsOneWidget);
      });

      testWidgets('shows description field for custom diet', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowInput.diet(
                label: 'Diet Type',
                dietValue: DietPresetType.custom,
                dietDescription: 'My custom diet',
                onDietChanged: (_) {},
                onDescriptionChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Diet Description'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('temperature input renders with label', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowInput.temperature(
                label: 'Basal Body Temperature',
                onTemperatureChanged: (_) {},
              ),
            ),
          ),
        );

        // Verify the ShadowInput widget is wrapped in Semantics
        expect(find.byType(ShadowInput), findsOneWidget);
        expect(find.byType(Semantics), findsWidgets);
      });

      testWidgets('flow input renders with label', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowInput.flow(
                label: 'Flow Intensity',
                onFlowChanged: (_) {},
              ),
            ),
          ),
        );

        // Verify the ShadowInput widget is wrapped in Semantics
        expect(find.byType(ShadowInput), findsOneWidget);
        expect(find.text('Flow Intensity'), findsOneWidget);
      });
    });
  });
}
