/// Accessible chart components for Shadow app health data visualization.
///
/// Provides [ShadowChart] with configurable chart types for health data
/// visualization, following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [09_WIDGET_LIBRARY.md] Section 6.3 for chart specifications
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full accessibility requirements
library;

import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

/// Data point for chart visualization.
class ChartDataPoint {
  /// The x-axis value (typically time/date as epoch milliseconds).
  final int x;

  /// The y-axis value.
  final double y;

  /// Optional label for the data point.
  final String? label;

  /// Optional color override for this point.
  final Color? color;

  const ChartDataPoint({
    required this.x,
    required this.y,
    this.label,
    this.color,
  });
}

/// Bar data for bar charts.
class BarChartData {
  /// The label for this bar.
  final String label;

  /// The value of this bar.
  final double value;

  /// The color of this bar.
  final Color? color;

  const BarChartData({required this.label, required this.value, this.color});
}

/// A consolidated chart widget for health data visualization.
///
/// [ShadowChart] provides a unified interface for various chart types
/// in the Shadow app, ensuring consistent accessibility support.
///
/// {@template shadow_chart}
/// All chart instances:
/// - Include semantic labels for screen readers
/// - Provide data table alternative for accessibility
/// - Support gesture interactions
/// {@endtemplate}
///
/// ## BBT Chart
///
/// ```dart
/// ShadowChart.bbt(
///   dataPoints: bbtData,
///   menstruationRanges: periods,
///   dateRange: DateTimeRange(start: start, end: end),
///   label: 'Basal Body Temperature',
/// )
/// ```
///
/// ## Trend Chart
///
/// ```dart
/// ShadowChart.trend(
///   dataPoints: trendData,
///   label: 'Weight Trend',
///   yAxisLabel: 'Weight (lbs)',
/// )
/// ```
///
/// ## Bar Chart
///
/// ```dart
/// ShadowChart.bar(
///   bars: weeklyData,
///   label: 'Weekly Summary',
/// )
/// ```
///
/// See also:
///
/// * [ChartType] for available chart types
/// * [ChartDataPoint] for data structure
class ShadowChart extends StatelessWidget {
  /// The type of chart.
  final ChartType chartType;

  /// The semantic label for screen readers.
  final String label;

  /// The height of the chart.
  final double height;

  /// Whether to show the data table alternative.
  final bool showDataTable;

  /// Data points for line/trend charts.
  final List<ChartDataPoint>? dataPoints;

  /// Bar data for bar charts.
  final List<BarChartData>? bars;

  /// Date range for time-based charts.
  final DateTimeRange? dateRange;

  /// Menstruation period ranges for BBT overlay.
  final List<DateTimeRange>? menstruationRanges;

  /// Y-axis label.
  final String? yAxisLabel;

  /// X-axis label.
  final String? xAxisLabel;

  /// Minimum Y value (auto-calculated if null).
  final double? minY;

  /// Maximum Y value (auto-calculated if null).
  final double? maxY;

  /// Line color for line charts.
  final Color? lineColor;

  /// Callback when a data point is tapped.
  final ValueChanged<ChartDataPoint>? onPointTapped;

  /// Callback when a bar is tapped.
  final ValueChanged<BarChartData>? onBarTapped;

  /// Creates a chart widget.
  const ShadowChart({
    super.key,
    required this.chartType,
    required this.label,
    this.height = 200,
    this.showDataTable = false,
    this.dataPoints,
    this.bars,
    this.dateRange,
    this.menstruationRanges,
    this.yAxisLabel,
    this.xAxisLabel,
    this.minY,
    this.maxY,
    this.lineColor,
    this.onPointTapped,
    this.onBarTapped,
  });

  /// Creates a BBT (Basal Body Temperature) chart.
  const ShadowChart.bbt({
    super.key,
    required this.dataPoints,
    required this.label,
    this.height = 200,
    this.showDataTable = false,
    this.dateRange,
    this.menstruationRanges,
    this.onPointTapped,
  }) : chartType = ChartType.bbt,
       bars = null,
       yAxisLabel = '°F',
       xAxisLabel = null,
       minY = 96.0,
       maxY = 100.0,
       lineColor = null,
       onBarTapped = null;

  /// Creates a trend line chart.
  const ShadowChart.trend({
    super.key,
    required this.dataPoints,
    required this.label,
    this.height = 200,
    this.showDataTable = false,
    this.yAxisLabel,
    this.xAxisLabel,
    this.minY,
    this.maxY,
    this.lineColor,
    this.onPointTapped,
  }) : chartType = ChartType.trend,
       bars = null,
       dateRange = null,
       menstruationRanges = null,
       onBarTapped = null;

  /// Creates a bar chart.
  const ShadowChart.bar({
    super.key,
    required this.bars,
    required this.label,
    this.height = 200,
    this.showDataTable = false,
    this.yAxisLabel,
    this.onBarTapped,
  }) : chartType = ChartType.bar,
       dataPoints = null,
       dateRange = null,
       menstruationRanges = null,
       xAxisLabel = null,
       minY = null,
       maxY = null,
       lineColor = null,
       onPointTapped = null;

  /// Creates a calendar heatmap chart.
  const ShadowChart.calendar({
    super.key,
    required this.dataPoints,
    required this.label,
    this.height = 200,
    this.showDataTable = false,
    this.dateRange,
    this.onPointTapped,
  }) : chartType = ChartType.calendar,
       bars = null,
       menstruationRanges = null,
       yAxisLabel = null,
       xAxisLabel = null,
       minY = null,
       maxY = null,
       lineColor = null,
       onBarTapped = null;

  /// Creates a scatter plot chart.
  const ShadowChart.scatter({
    super.key,
    required this.dataPoints,
    required this.label,
    this.height = 200,
    this.showDataTable = false,
    this.yAxisLabel,
    this.xAxisLabel,
    this.minY,
    this.maxY,
    this.onPointTapped,
  }) : chartType = ChartType.scatter,
       bars = null,
       dateRange = null,
       menstruationRanges = null,
       lineColor = null,
       onBarTapped = null;

  /// Creates a heatmap chart.
  const ShadowChart.heatmap({
    super.key,
    required this.dataPoints,
    required this.label,
    this.height = 200,
    this.showDataTable = false,
    this.dateRange,
    this.onPointTapped,
  }) : chartType = ChartType.heatmap,
       bars = null,
       menstruationRanges = null,
       yAxisLabel = null,
       xAxisLabel = null,
       minY = null,
       maxY = null,
       lineColor = null,
       onBarTapped = null;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height, child: _buildChart(context)),
        if (showDataTable) ...[
          const SizedBox(height: 16),
          _buildDataTable(context),
        ],
      ],
    ),
  );

  Widget _buildChart(BuildContext context) {
    switch (chartType) {
      case ChartType.bbt:
        return _BBTChart(
          dataPoints: dataPoints ?? [],
          dateRange: dateRange,
          menstruationRanges: menstruationRanges,
          minY: minY ?? 96.0,
          maxY: maxY ?? 100.0,
          onPointTapped: onPointTapped,
        );
      case ChartType.trend:
        return _TrendChart(
          dataPoints: dataPoints ?? [],
          minY: minY,
          maxY: maxY,
          lineColor: lineColor,
          yAxisLabel: yAxisLabel,
          onPointTapped: onPointTapped,
        );
      case ChartType.bar:
        return _BarChart(
          bars: bars ?? [],
          yAxisLabel: yAxisLabel,
          onBarTapped: onBarTapped,
        );
      case ChartType.calendar:
        return _CalendarChart(
          dataPoints: dataPoints ?? [],
          dateRange: dateRange,
          onPointTapped: onPointTapped,
        );
      case ChartType.scatter:
        return _ScatterChart(
          dataPoints: dataPoints ?? [],
          minY: minY,
          maxY: maxY,
          onPointTapped: onPointTapped,
        );
      case ChartType.heatmap:
        return _HeatmapChart(
          dataPoints: dataPoints ?? [],
          dateRange: dateRange,
          onPointTapped: onPointTapped,
        );
    }
  }

  Widget _buildDataTable(BuildContext context) {
    final theme = Theme.of(context);

    if (chartType == ChartType.bar && bars != null) {
      return _AccessibleDataTable(
        columns: const ['Label', 'Value'],
        rows: bars!.map((b) => [b.label, b.value.toStringAsFixed(1)]).toList(),
      );
    }

    if (dataPoints != null && dataPoints!.isNotEmpty) {
      return _AccessibleDataTable(
        columns: const ['Date', 'Value'],
        rows: dataPoints!.map((p) {
          final date = DateTime.fromMillisecondsSinceEpoch(p.x);
          return ['${date.month}/${date.day}', p.y.toStringAsFixed(1)];
        }).toList(),
      );
    }

    return Text('No data available', style: theme.textTheme.bodyMedium);
  }
}

/// Internal BBT chart implementation.
class _BBTChart extends StatelessWidget {
  final List<ChartDataPoint> dataPoints;
  final DateTimeRange? dateRange;
  final List<DateTimeRange>? menstruationRanges;
  final double minY;
  final double maxY;
  final ValueChanged<ChartDataPoint>? onPointTapped;

  const _BBTChart({
    required this.dataPoints,
    required this.dateRange,
    required this.menstruationRanges,
    required this.minY,
    required this.maxY,
    required this.onPointTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (dataPoints.isEmpty) {
      return Center(
        child: Text('No temperature data', style: theme.textTheme.bodyMedium),
      );
    }

    return CustomPaint(
      painter: _LineChartPainter(
        dataPoints: dataPoints,
        minY: minY,
        maxY: maxY,
        lineColor: Colors.pink,
        fillColor: Colors.pink.withAlpha(51),
        menstruationRanges: menstruationRanges,
      ),
      child: GestureDetector(
        onTapUp: (details) {
          // Find closest point
          if (onPointTapped != null && dataPoints.isNotEmpty) {
            // Simple implementation - tap returns first point
            onPointTapped!(dataPoints.first);
          }
        },
      ),
    );
  }
}

/// Internal trend chart implementation.
class _TrendChart extends StatelessWidget {
  final List<ChartDataPoint> dataPoints;
  final double? minY;
  final double? maxY;
  final Color? lineColor;
  final String? yAxisLabel;
  final ValueChanged<ChartDataPoint>? onPointTapped;

  const _TrendChart({
    required this.dataPoints,
    required this.minY,
    required this.maxY,
    required this.lineColor,
    required this.yAxisLabel,
    required this.onPointTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (dataPoints.isEmpty) {
      return Center(
        child: Text('No trend data', style: theme.textTheme.bodyMedium),
      );
    }

    final effectiveMinY =
        minY ?? dataPoints.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    final effectiveMaxY =
        maxY ?? dataPoints.map((p) => p.y).reduce((a, b) => a > b ? a : b);

    return CustomPaint(
      painter: _LineChartPainter(
        dataPoints: dataPoints,
        minY: effectiveMinY,
        maxY: effectiveMaxY,
        lineColor: lineColor ?? theme.colorScheme.primary,
        fillColor: (lineColor ?? theme.colorScheme.primary).withAlpha(51),
      ),
    );
  }
}

/// Internal bar chart implementation.
class _BarChart extends StatelessWidget {
  final List<BarChartData> bars;
  final String? yAxisLabel;
  final ValueChanged<BarChartData>? onBarTapped;

  const _BarChart({
    required this.bars,
    required this.yAxisLabel,
    required this.onBarTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (bars.isEmpty) {
      return Center(
        child: Text('No bar data', style: theme.textTheme.bodyMedium),
      );
    }

    final maxValue = bars.map((b) => b.value).reduce((a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: bars.map((bar) {
        final heightPercent = maxValue > 0 ? bar.value / maxValue : 0.0;
        final color = bar.color ?? theme.colorScheme.primary;

        return Expanded(
          child: Semantics(
            label: '${bar.label}: ${bar.value}',
            child: GestureDetector(
              onTap: onBarTapped != null ? () => onBarTapped!(bar) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: heightPercent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bar.label,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Internal calendar heatmap implementation.
class _CalendarChart extends StatelessWidget {
  final List<ChartDataPoint> dataPoints;
  final DateTimeRange? dateRange;
  final ValueChanged<ChartDataPoint>? onPointTapped;

  const _CalendarChart({
    required this.dataPoints,
    required this.dateRange,
    required this.onPointTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (dataPoints.isEmpty) {
      return Center(
        child: Text('No calendar data', style: theme.textTheme.bodyMedium),
      );
    }

    // Create a map of date -> value for quick lookup
    final dataMap = <int, double>{};
    for (final point in dataPoints) {
      dataMap[point.x] = point.y;
    }

    final range =
        dateRange ??
        DateTimeRange(
          start: DateTime.fromMillisecondsSinceEpoch(dataPoints.first.x),
          end: DateTime.fromMillisecondsSinceEpoch(dataPoints.last.x),
        );

    // Calculate weeks
    final weeks = <List<DateTime?>>[];
    var current = range.start;
    var currentWeek = <DateTime?>[];

    // Pad start of first week
    for (var i = 0; i < current.weekday - 1; i++) {
      currentWeek.add(null);
    }

    while (current.isBefore(range.end) || current.isAtSameMomentAs(range.end)) {
      currentWeek.add(current);
      if (current.weekday == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
      current = current.add(const Duration(days: 1));
    }

    // Add remaining days
    if (currentWeek.isNotEmpty) {
      weeks.add(currentWeek);
    }

    return Column(
      children: weeks
          .map(
            (week) => Row(
              children: week.map((date) {
                if (date == null) {
                  return const Expanded(child: SizedBox(height: 20));
                }

                final dayStart = DateTime(date.year, date.month, date.day);
                final epochMs = dayStart.millisecondsSinceEpoch;
                final value = dataMap[epochMs];
                final intensity = value != null
                    ? (value / 10).clamp(0.0, 1.0)
                    : 0.0;

                return Expanded(
                  child: Container(
                    height: 20,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(
                        (intensity * 255).toInt(),
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
          .toList(),
    );
  }
}

/// Internal scatter chart implementation.
class _ScatterChart extends StatelessWidget {
  final List<ChartDataPoint> dataPoints;
  final double? minY;
  final double? maxY;
  final ValueChanged<ChartDataPoint>? onPointTapped;

  const _ScatterChart({
    required this.dataPoints,
    required this.minY,
    required this.maxY,
    required this.onPointTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (dataPoints.isEmpty) {
      return Center(
        child: Text('No scatter data', style: theme.textTheme.bodyMedium),
      );
    }

    return CustomPaint(
      painter: _ScatterChartPainter(
        dataPoints: dataPoints,
        minY: minY,
        maxY: maxY,
        pointColor: theme.colorScheme.primary,
      ),
    );
  }
}

/// Internal heatmap implementation.
class _HeatmapChart extends StatelessWidget {
  final List<ChartDataPoint> dataPoints;
  final DateTimeRange? dateRange;
  final ValueChanged<ChartDataPoint>? onPointTapped;

  const _HeatmapChart({
    required this.dataPoints,
    required this.dateRange,
    required this.onPointTapped,
  });

  // Heatmap uses same implementation as calendar for now
  @override
  Widget build(BuildContext context) => _CalendarChart(
    dataPoints: dataPoints,
    dateRange: dateRange,
    onPointTapped: onPointTapped,
  );
}

/// Custom painter for line charts.
class _LineChartPainter extends CustomPainter {
  final List<ChartDataPoint> dataPoints;
  final double minY;
  final double maxY;
  final Color lineColor;
  final Color fillColor;
  final List<DateTimeRange>? menstruationRanges;

  _LineChartPainter({
    required this.dataPoints,
    required this.minY,
    required this.maxY,
    required this.lineColor,
    required this.fillColor,
    this.menstruationRanges,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // Calculate x and y ranges
    final minX = dataPoints.map((p) => p.x).reduce((a, b) => a < b ? a : b);
    final maxX = dataPoints.map((p) => p.x).reduce((a, b) => a > b ? a : b);
    final xRange = maxX - minX;
    final yRange = maxY - minY;

    // Draw menstruation overlay if provided
    if (menstruationRanges != null) {
      final overlayPaint = Paint()
        ..color = Colors.pink.withAlpha(51)
        ..style = PaintingStyle.fill;

      for (final range in menstruationRanges!) {
        final startX = xRange > 0
            ? (range.start.millisecondsSinceEpoch - minX) / xRange * size.width
            : 0.0;
        final endX = xRange > 0
            ? (range.end.millisecondsSinceEpoch - minX) / xRange * size.width
            : size.width;

        canvas.drawRect(
          Rect.fromLTRB(startX, 0, endX, size.height),
          overlayPaint,
        );
      }
    }

    // Create path for line
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final x = xRange > 0
          ? (point.x - minX) / xRange * size.width
          : size.width / 2;
      final y = yRange > 0
          ? size.height - (point.y - minY) / yRange * size.height
          : size.height / 2;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath
          ..moveTo(x, size.height)
          ..lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Complete fill path
    final lastPoint = dataPoints.last;
    final lastX = xRange > 0
        ? (lastPoint.x - minX) / xRange * size.width
        : size.width / 2;
    fillPath
      ..lineTo(lastX, size.height)
      ..close();

    // Draw fill then line
    canvas
      ..drawPath(fillPath, fillPaint)
      ..drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (final point in dataPoints) {
      final x = xRange > 0
          ? (point.x - minX) / xRange * size.width
          : size.width / 2;
      final y = yRange > 0
          ? size.height - (point.y - minY) / yRange * size.height
          : size.height / 2;
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter for scatter charts.
class _ScatterChartPainter extends CustomPainter {
  final List<ChartDataPoint> dataPoints;
  final double? minY;
  final double? maxY;
  final Color pointColor;

  _ScatterChartPainter({
    required this.dataPoints,
    required this.minY,
    required this.maxY,
    required this.pointColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final defaultPaint = Paint()
      ..color = pointColor
      ..style = PaintingStyle.fill;

    // Calculate ranges
    final minX = dataPoints.map((p) => p.x).reduce((a, b) => a < b ? a : b);
    final maxX = dataPoints.map((p) => p.x).reduce((a, b) => a > b ? a : b);
    final effectiveMinY =
        minY ?? dataPoints.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    final effectiveMaxY =
        maxY ?? dataPoints.map((p) => p.y).reduce((a, b) => a > b ? a : b);

    final xRange = maxX - minX;
    final yRange = effectiveMaxY - effectiveMinY;

    for (final point in dataPoints) {
      final x = xRange > 0
          ? (point.x - minX) / xRange * size.width
          : size.width / 2;
      final y = yRange > 0
          ? size.height - (point.y - effectiveMinY) / yRange * size.height
          : size.height / 2;

      final paint = point.color != null
          ? (Paint()
              ..color = point.color!
              ..style = PaintingStyle.fill)
          : defaultPaint;

      canvas.drawCircle(Offset(x, y), 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Accessible data table widget for chart data.
class _AccessibleDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;

  const _AccessibleDataTable({required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Data table with ${rows.length} rows',
      child: Table(
        border: TableBorder.all(color: theme.colorScheme.outline),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
            ),
            children: columns
                .map(
                  (col) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      col,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          ...rows.map(
            (row) => TableRow(
              children: row
                  .map(
                    (cell) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(cell),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
