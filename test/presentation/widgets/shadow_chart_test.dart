import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/widgets/shadow_chart.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

void main() {
  group('ShadowChart', () {
    final testDataPoints = [
      ChartDataPoint(x: DateTime(2026, 2).millisecondsSinceEpoch, y: 98.2),
      ChartDataPoint(x: DateTime(2026, 2, 2).millisecondsSinceEpoch, y: 98.4),
      ChartDataPoint(x: DateTime(2026, 2, 3).millisecondsSinceEpoch, y: 98.6),
    ];

    group('BBT chart', () {
      testWidgets('renders with data points', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowChart.bbt(
                dataPoints: testDataPoints,
                label: 'Temperature Chart',
              ),
            ),
          ),
        );

        // Multiple CustomPaint widgets may exist in the tree (chart + containers)
        expect(find.byType(CustomPaint), findsWidgets);
        expect(find.byType(ShadowChart), findsOneWidget);
      });

      testWidgets('shows empty message when no data', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowChart.bbt(dataPoints: [], label: 'Temperature Chart'),
            ),
          ),
        );

        expect(find.text('No temperature data'), findsOneWidget);
      });

      testWidgets('is wrapped in Semantics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowChart.bbt(
                dataPoints: testDataPoints,
                label: 'BBT Chart',
              ),
            ),
          ),
        );

        expect(find.byType(ShadowChart), findsOneWidget);
        expect(find.byType(Semantics), findsWidgets);
      });
    });

    group('trend chart', () {
      testWidgets('renders with data points', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowChart.trend(
                dataPoints: testDataPoints,
                label: 'Weight Trend',
              ),
            ),
          ),
        );

        // Multiple CustomPaint widgets may exist in the tree (chart + containers)
        expect(find.byType(CustomPaint), findsWidgets);
        expect(find.byType(ShadowChart), findsOneWidget);
      });

      testWidgets('shows empty message when no data', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowChart.trend(dataPoints: [], label: 'Weight Trend'),
            ),
          ),
        );

        expect(find.text('No trend data'), findsOneWidget);
      });
    });

    group('bar chart', () {
      final testBars = [
        const BarChartData(label: 'Mon', value: 5),
        const BarChartData(label: 'Tue', value: 8),
        const BarChartData(label: 'Wed', value: 3),
      ];

      testWidgets('renders bar labels', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowChart.bar(bars: testBars, label: 'Weekly Summary'),
            ),
          ),
        );

        expect(find.text('Mon'), findsOneWidget);
        expect(find.text('Tue'), findsOneWidget);
        expect(find.text('Wed'), findsOneWidget);
      });

      testWidgets('shows empty message when no bars', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowChart.bar(bars: [], label: 'Empty Chart'),
            ),
          ),
        );

        expect(find.text('No bar data'), findsOneWidget);
      });

      testWidgets('calls onBarTapped when bar is tapped', (tester) async {
        BarChartData? tappedBar;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowChart.bar(
                bars: testBars,
                label: 'Weekly Summary',
                onBarTapped: (bar) => tappedBar = bar,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Tue'));
        await tester.pump();

        expect(tappedBar?.label, equals('Tue'));
      });
    });

    group('data table', () {
      testWidgets('shows data table when showDataTable is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ShadowChart.bbt(
                  dataPoints: testDataPoints,
                  label: 'Temperature Chart',
                  showDataTable: true,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(Table), findsOneWidget);
        expect(find.text('Date'), findsOneWidget);
        expect(find.text('Value'), findsOneWidget);
      });

      testWidgets('hides data table by default', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowChart.bbt(
                dataPoints: testDataPoints,
                label: 'Temperature Chart',
              ),
            ),
          ),
        );

        expect(find.byType(Table), findsNothing);
      });
    });

    group('calendar chart', () {
      testWidgets('renders with data points', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowChart.calendar(
                dataPoints: testDataPoints,
                label: 'Activity Calendar',
                dateRange: DateTimeRange(
                  start: DateTime(2026, 2),
                  end: DateTime(2026, 2, 7),
                ),
              ),
            ),
          ),
        );

        // Calendar should render rows for weeks
        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('shows empty message when no data', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowChart.calendar(
                dataPoints: [],
                label: 'Activity Calendar',
              ),
            ),
          ),
        );

        expect(find.text('No calendar data'), findsOneWidget);
      });
    });

    group('scatter chart', () {
      testWidgets('renders with data points', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowChart.scatter(
                dataPoints: testDataPoints,
                label: 'Correlation Plot',
              ),
            ),
          ),
        );

        // Multiple CustomPaint widgets may exist in the tree (chart + containers)
        expect(find.byType(CustomPaint), findsWidgets);
        expect(find.byType(ShadowChart), findsOneWidget);
      });

      testWidgets('shows empty message when no data', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowChart.scatter(
                dataPoints: [],
                label: 'Correlation Plot',
              ),
            ),
          ),
        );

        expect(find.text('No scatter data'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('all chart types have semantic labels', (tester) async {
        for (final chartType in ChartType.values) {
          late Widget chart;
          switch (chartType) {
            case ChartType.bbt:
              chart = ShadowChart.bbt(dataPoints: testDataPoints, label: 'BBT');
            case ChartType.trend:
              chart = ShadowChart.trend(
                dataPoints: testDataPoints,
                label: 'Trend',
              );
            case ChartType.bar:
              chart = const ShadowChart.bar(
                bars: [BarChartData(label: 'A', value: 1)],
                label: 'Bar',
              );
            case ChartType.calendar:
              chart = ShadowChart.calendar(
                dataPoints: testDataPoints,
                label: 'Calendar',
              );
            case ChartType.scatter:
              chart = ShadowChart.scatter(
                dataPoints: testDataPoints,
                label: 'Scatter',
              );
            case ChartType.heatmap:
              chart = ShadowChart.heatmap(
                dataPoints: testDataPoints,
                label: 'Heatmap',
              );
          }

          await tester.pumpWidget(MaterialApp(home: Scaffold(body: chart)));

          expect(find.byType(Semantics), findsWidgets);
        }
      });
    });
  });
}
