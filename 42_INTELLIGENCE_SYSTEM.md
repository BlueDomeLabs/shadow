# 42. Intelligence System Specification

## Document Purpose

This document provides complete specifications for Phase 3 Intelligence features:
- Pattern Detection
- Trigger Correlation
- Health Insights
- Predictive Alerts

---

## Table of Contents

1. [Overview](#1-overview)
2. [Pattern Detection Engine](#2-pattern-detection-engine)
3. [Trigger Correlation System](#3-trigger-correlation-system)
4. [Health Insights Generator](#4-health-insights-generator)
5. [Predictive Alerts](#5-predictive-alerts)
6. [Machine Learning Models](#6-machine-learning-models)
7. [Data Requirements](#7-data-requirements)
8. [Database Schema](#8-database-schema)
9. [API Contracts](#9-api-contracts)
10. [UI Specifications](#10-ui-specifications)
11. [Privacy & Security](#11-privacy--security)
12. [Localization](#12-localization)
13. [Testing Strategy](#13-testing-strategy)
14. [Acceptance Criteria](#14-acceptance-criteria)

---

## 1. Overview

### 1.1 Purpose

The Intelligence System analyzes user health data to identify patterns, correlate triggers with symptoms, generate actionable insights, and predict potential health events before they occur.

### 1.2 Key Principles

| Principle | Description |
|-----------|-------------|
| **Privacy-First** | All analysis runs locally on-device; no health data sent to external servers |
| **Explainable** | Every insight shows the data that supports it |
| **Actionable** | Insights include specific recommendations |
| **Non-Diagnostic** | System provides observations, not medical diagnoses |
| **User-Controlled** | Users can disable any intelligence feature |

### 1.3 Feature Summary

| Feature | Description | Minimum Data Required |
|---------|-------------|----------------------|
| Pattern Detection | Identifies recurring patterns in health data | 14 days |
| Trigger Correlation | Links foods/activities to symptom changes | 30 days |
| Health Insights | Generates personalized observations | 7 days |
| Predictive Alerts | Warns of potential upcoming events | 60 days |

---

## 2. Pattern Detection Engine

### 2.1 Pattern Types

| Pattern Type | Description | Data Sources | Example |
|--------------|-------------|--------------|---------|
| **Temporal** | Time-based recurring patterns | All entities with timestamps | "Headaches occur 73% more often on Mondays" |
| **Cyclical** | Patterns following biological cycles | Menstruation, BBT, sleep | "Energy dips occur 2-3 days before menstruation" |
| **Sequential** | Events that follow other events | All entities | "Joint pain follows dairy consumption within 24 hours" |
| **Cluster** | Co-occurring symptoms/conditions | Conditions, symptoms | "Fatigue, brain fog, and joint pain occur together 68% of the time" |
| **Dosage** | Supplement dosage effectiveness | Supplements, conditions | "Magnesium at 400mg reduces migraine frequency more than 200mg" |

### 2.2 Temporal Pattern Detection

```dart
@freezed
class TemporalPattern with _$TemporalPattern {
  const factory TemporalPattern({
    required String id,
    required String profileId,
    required PatternType type,
    required String entityType,        // 'condition', 'food', 'sleep', etc.
    required String? entityId,         // Specific entity or null for category
    required TemporalUnit unit,        // hour, dayOfWeek, dayOfMonth, month
    required Map<int, double> distribution,  // {0: 0.15, 1: 0.23, ...} frequency by unit
    required double confidence,        // 0.0 - 1.0
    required int sampleSize,           // Number of data points analyzed
    required DateTime detectedAt,
    required DateTime dataRangeStart,
    required DateTime dataRangeEnd,
  }) = _TemporalPattern;
}

enum TemporalUnit {
  hourOfDay,      // 0-23
  dayOfWeek,      // 0-6 (Sunday = 0)
  dayOfMonth,     // 1-31
  weekOfMonth,    // 1-5
  month,          // 1-12
}

enum PatternType {
  temporal,
  cyclical,
  sequential,
  cluster,
  dosage,
}
```

### 2.3 Detection Algorithm

```dart
class TemporalPatternDetector {
  /// Minimum data points required for pattern detection
  static const int minDataPoints = 14;

  /// Minimum confidence threshold to report pattern
  static const double minConfidence = 0.65;

  /// Chi-square threshold for statistical significance (p < 0.05)
  static const double chiSquareThreshold = 11.07; // df=5

  Future<List<TemporalPattern>> detectPatterns({
    required String profileId,
    required String entityType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final entries = await _getEntries(profileId, entityType, startDate, endDate);

    if (entries.length < minDataPoints) {
      return []; // Insufficient data
    }

    final patterns = <TemporalPattern>[];

    // Analyze each temporal unit
    for (final unit in TemporalUnit.values) {
      final distribution = _calculateDistribution(entries, unit);
      final expectedUniform = 1.0 / _getUnitCount(unit);

      // Chi-square test for non-uniform distribution
      final chiSquare = _calculateChiSquare(distribution, expectedUniform);

      if (chiSquare > chiSquareThreshold) {
        final confidence = _calculateConfidence(chiSquare, entries.length);

        if (confidence >= minConfidence) {
          patterns.add(TemporalPattern(
            id: _uuid.v4(),
            profileId: profileId,
            type: PatternType.temporal,
            entityType: entityType,
            entityId: null,
            unit: unit,
            distribution: distribution,
            confidence: confidence,
            sampleSize: entries.length,
            detectedAt: DateTime.now(),
            dataRangeStart: startDate,
            dataRangeEnd: endDate,
          ));
        }
      }
    }

    return patterns;
  }

  Map<int, double> _calculateDistribution(List<TimestampedEntry> entries, TemporalUnit unit) {
    final counts = <int, int>{};
    final unitCount = _getUnitCount(unit);

    // Initialize all buckets
    for (int i = 0; i < unitCount; i++) {
      counts[i] = 0;
    }

    // Count occurrences
    for (final entry in entries) {
      final bucket = _getBucket(entry.timestamp, unit);
      counts[bucket] = (counts[bucket] ?? 0) + 1;
    }

    // Convert to frequencies
    final total = entries.length.toDouble();
    return counts.map((key, value) => MapEntry(key, value / total));
  }

  int _getUnitCount(TemporalUnit unit) {
    switch (unit) {
      case TemporalUnit.hourOfDay: return 24;
      case TemporalUnit.dayOfWeek: return 7;
      case TemporalUnit.dayOfMonth: return 31;
      case TemporalUnit.weekOfMonth: return 5;
      case TemporalUnit.month: return 12;
    }
  }

  int _getBucket(DateTime timestamp, TemporalUnit unit) {
    switch (unit) {
      case TemporalUnit.hourOfDay: return timestamp.hour;
      case TemporalUnit.dayOfWeek: return timestamp.weekday % 7;
      case TemporalUnit.dayOfMonth: return timestamp.day;
      case TemporalUnit.weekOfMonth: return ((timestamp.day - 1) ~/ 7) + 1;
      case TemporalUnit.month: return timestamp.month;
    }
  }

  double _calculateChiSquare(Map<int, double> observed, double expected) {
    double chiSquare = 0.0;
    for (final freq in observed.values) {
      chiSquare += pow(freq - expected, 2) / expected;
    }
    return chiSquare;
  }

  double _calculateConfidence(double chiSquare, int sampleSize) {
    // Convert chi-square to confidence score
    // Higher chi-square and larger sample = higher confidence
    final pValue = 1.0 - _chiSquareCDF(chiSquare, _getUnitCount(unit) - 1);
    final sampleFactor = min(1.0, sampleSize / 100.0);
    return (1.0 - pValue) * sampleFactor;
  }
}
```

### 2.4 Cyclical Pattern Detection (Menstrual Cycle)

```dart
class CyclicalPatternDetector {
  /// Minimum cycles required for pattern detection
  static const int minCycles = 3;

  Future<CyclicalPattern?> detectMenstrualPattern({
    required String profileId,
    required List<MenstruationEntry> entries,
  }) async {
    // Identify cycle start dates (first day of flow)
    final cycleStarts = _identifyCycleStarts(entries);

    if (cycleStarts.length < minCycles) {
      return null; // Insufficient cycles
    }

    // Calculate cycle lengths
    final cycleLengths = <int>[];
    for (int i = 1; i < cycleStarts.length; i++) {
      cycleLengths.add(cycleStarts[i].difference(cycleStarts[i-1]).inDays);
    }

    // Calculate statistics
    final avgLength = cycleLengths.average;
    final stdDev = cycleLengths.standardDeviation;
    final regularity = 1.0 - (stdDev / avgLength).clamp(0.0, 1.0);

    // Detect phase patterns if BBT data available
    final phases = await _detectPhases(profileId, cycleStarts);

    return CyclicalPattern(
      id: _uuid.v4(),
      profileId: profileId,
      cycleType: CycleType.menstrual,
      averageLengthDays: avgLength.round(),
      standardDeviationDays: stdDev,
      regularity: regularity,
      phases: phases,
      predictedNextStart: _predictNextCycleStart(cycleStarts, avgLength),
      confidence: _calculateCycleConfidence(cycleLengths),
      cycleCount: cycleStarts.length,
      detectedAt: DateTime.now(),
    );
  }

  List<CyclePhase> _detectPhases(String profileId, List<DateTime> cycleStarts) async {
    final bbtEntries = await _bbtRepository.getByDateRange(
      profileId: profileId,
      startDate: cycleStarts.first,
      endDate: DateTime.now(),
    );

    if (bbtEntries.length < 20) {
      return _defaultPhases(); // Use standard phases without BBT data
    }

    // Detect ovulation via BBT thermal shift
    final phases = <CyclePhase>[];

    for (int i = 0; i < cycleStarts.length - 1; i++) {
      final cycleStart = cycleStarts[i];
      final cycleEnd = cycleStarts[i + 1];
      final cycleBBT = bbtEntries.where((e) =>
        e.timestamp.isAfter(cycleStart) && e.timestamp.isBefore(cycleEnd)
      ).toList();

      final ovulationDay = _detectThermalShift(cycleBBT);

      phases.add(CyclePhase(
        cycleNumber: i + 1,
        follicularDays: ovulationDay ?? 14,
        lutealDays: cycleEnd.difference(cycleStart).inDays - (ovulationDay ?? 14),
        ovulationDetected: ovulationDay != null,
      ));
    }

    return phases;
  }

  int? _detectThermalShift(List<BBTEntry> entries) {
    if (entries.length < 10) return null;

    // Look for 0.2°F+ sustained rise over 3+ days
    final temps = entries.map((e) => e.temperature).toList();
    final baseline = temps.sublist(0, 6).average;

    for (int i = 6; i < temps.length - 3; i++) {
      final nextThree = temps.sublist(i, i + 3);
      if (nextThree.every((t) => t >= baseline + 0.2)) {
        return i; // Day of thermal shift
      }
    }

    return null;
  }
}

@freezed
class CyclicalPattern with _$CyclicalPattern {
  const factory CyclicalPattern({
    required String id,
    required String profileId,
    required CycleType cycleType,
    required int averageLengthDays,
    required double standardDeviationDays,
    required double regularity,           // 0.0 - 1.0
    required List<CyclePhase> phases,
    required DateTime? predictedNextStart,
    required double confidence,
    required int cycleCount,
    required DateTime detectedAt,
  }) = _CyclicalPattern;
}

enum CycleType {
  menstrual,
  sleepWake,
  flareRemission,
}
```

### 2.5 Sequential Pattern Detection

```dart
class SequentialPatternDetector {
  /// Time windows to check for sequential relationships
  static const List<Duration> timeWindows = [
    Duration(hours: 2),
    Duration(hours: 6),
    Duration(hours: 12),
    Duration(hours: 24),
    Duration(hours: 48),
    Duration(hours: 72),
  ];

  /// Minimum co-occurrence rate to consider a pattern
  static const double minCooccurrenceRate = 0.3;

  /// Minimum occurrences of antecedent event
  static const int minAntecedentCount = 5;

  Future<List<SequentialPattern>> detectPatterns({
    required String profileId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final patterns = <SequentialPattern>[];

    // Get all timestamped events
    final foods = await _foodRepository.getByDateRange(profileId, startDate, endDate);
    final conditions = await _conditionLogRepository.getByDateRange(profileId, startDate, endDate);
    final activities = await _activityLogRepository.getByDateRange(profileId, startDate, endDate);
    final supplements = await _intakeLogRepository.getByDateRange(profileId, startDate, endDate);

    // Check food → condition relationships
    for (final food in _groupByFoodItem(foods)) {
      if (food.occurrences.length < minAntecedentCount) continue;

      for (final condition in _groupByCondition(conditions)) {
        for (final window in timeWindows) {
          final cooccurrence = _calculateCooccurrence(
            antecedent: food.occurrences,
            consequent: condition.occurrences,
            window: window,
          );

          if (cooccurrence.rate >= minCooccurrenceRate) {
            patterns.add(SequentialPattern(
              id: _uuid.v4(),
              profileId: profileId,
              antecedentType: 'food',
              antecedentId: food.id,
              antecedentName: food.name,
              consequentType: 'condition',
              consequentId: condition.id,
              consequentName: condition.name,
              timeWindowHours: window.inHours,
              cooccurrenceRate: cooccurrence.rate,
              averageDelayHours: cooccurrence.averageDelay,
              antecedentCount: food.occurrences.length,
              consequentCount: condition.occurrences.length,
              cooccurrenceCount: cooccurrence.count,
              confidence: _calculateSequentialConfidence(cooccurrence, food.occurrences.length),
              detectedAt: DateTime.now(),
            ));
          }
        }
      }
    }

    // Check activity → condition relationships
    // Check supplement → condition relationships (positive correlations)
    // ... similar logic for other combinations

    return _filterOverlappingPatterns(patterns);
  }

  Cooccurrence _calculateCooccurrence({
    required List<DateTime> antecedent,
    required List<DateTime> consequent,
    required Duration window,
  }) {
    int count = 0;
    final delays = <double>[];

    for (final ante in antecedent) {
      final windowEnd = ante.add(window);
      final followingEvents = consequent.where((c) =>
        c.isAfter(ante) && c.isBefore(windowEnd)
      );

      if (followingEvents.isNotEmpty) {
        count++;
        final firstFollowing = followingEvents.first;
        delays.add(firstFollowing.difference(ante).inMinutes / 60.0);
      }
    }

    return Cooccurrence(
      count: count,
      rate: count / antecedent.length,
      averageDelay: delays.isNotEmpty ? delays.average : 0.0,
    );
  }
}

@freezed
class SequentialPattern with _$SequentialPattern {
  const factory SequentialPattern({
    required String id,
    required String profileId,
    required String antecedentType,
    required String antecedentId,
    required String antecedentName,
    required String consequentType,
    required String consequentId,
    required String consequentName,
    required int timeWindowHours,
    required double cooccurrenceRate,      // 0.0 - 1.0
    required double averageDelayHours,
    required int antecedentCount,
    required int consequentCount,
    required int cooccurrenceCount,
    required double confidence,
    required DateTime detectedAt,
  }) = _SequentialPattern;
}
```

### 2.6 Cluster Pattern Detection

```dart
class ClusterPatternDetector {
  /// Maximum time window for clustering co-occurring symptoms
  static const Duration clusterWindow = Duration(hours: 24);

  /// Minimum Jaccard similarity to consider a cluster
  static const double minJaccardSimilarity = 0.4;

  Future<List<ClusterPattern>> detectPatterns({
    required String profileId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final conditionLogs = await _conditionLogRepository.getByDateRange(
      profileId, startDate, endDate,
    );

    // Group logs by day
    final dailySymptoms = _groupByDay(conditionLogs);

    // Build co-occurrence matrix
    final cooccurrenceMatrix = _buildCooccurrenceMatrix(dailySymptoms);

    // Find clusters using hierarchical clustering
    final clusters = _hierarchicalClustering(cooccurrenceMatrix);

    return clusters.map((cluster) => ClusterPattern(
      id: _uuid.v4(),
      profileId: profileId,
      conditionIds: cluster.members,
      conditionNames: cluster.memberNames,
      cooccurrenceRate: cluster.similarity,
      dayCount: dailySymptoms.length,
      clusterDayCount: cluster.occurrenceCount,
      confidence: _calculateClusterConfidence(cluster),
      detectedAt: DateTime.now(),
    )).toList();
  }
}

@freezed
class ClusterPattern with _$ClusterPattern {
  const factory ClusterPattern({
    required String id,
    required String profileId,
    required List<String> conditionIds,
    required List<String> conditionNames,
    required double cooccurrenceRate,
    required int dayCount,
    required int clusterDayCount,
    required double confidence,
    required DateTime detectedAt,
  }) = _ClusterPattern;
}
```

---

## 3. Trigger Correlation System

### 3.1 Correlation Types

| Type | Description | Statistical Method |
|------|-------------|-------------------|
| **Positive** | Trigger increases symptom likelihood | Relative Risk > 1.5 |
| **Negative** | Factor decreases symptom likelihood | Relative Risk < 0.67 |
| **Neutral** | No significant relationship | 0.67 ≤ RR ≤ 1.5 |
| **Dose-Response** | Effect varies with amount/intensity | Linear regression |

### 3.2 Trigger Correlation Entity

```dart
@freezed
class TriggerCorrelation with _$TriggerCorrelation {
  const factory TriggerCorrelation({
    required String id,
    required String profileId,
    required String triggerId,
    required String triggerType,         // 'food', 'activity', 'supplement', 'sleep', 'weather'
    required String triggerName,
    required String outcomeId,
    required String outcomeType,         // 'condition', 'flare', 'symptom'
    required String outcomeName,
    required CorrelationType correlationType,
    required double relativeRisk,        // RR > 1 = increases risk, RR < 1 = decreases risk
    required double confidenceIntervalLow,
    required double confidenceIntervalHigh,
    required double pValue,
    required int triggerExposures,       // Times trigger occurred
    required int outcomeOccurrences,     // Times outcome occurred
    required int cooccurrences,          // Times both occurred within window
    required int timeWindowHours,
    required double averageLatencyHours, // Average time from trigger to outcome
    required double confidence,          // Overall confidence score
    required DateTime detectedAt,
    required DateTime dataRangeStart,
    required DateTime dataRangeEnd,
    String? doseResponseEquation,        // e.g., "severity = 2.3 * dose + 1.2"
  }) = _TriggerCorrelation;
}

enum CorrelationType {
  positive,      // Increases risk
  negative,      // Decreases risk (protective)
  neutral,       // No significant effect
  doseResponse,  // Effect varies with amount
}
```

### 3.3 Correlation Calculation

```dart
class TriggerCorrelationEngine {
  /// Minimum exposures to calculate correlation
  static const int minExposures = 10;

  /// P-value threshold for significance
  static const double significanceThreshold = 0.05;

  /// Time windows to analyze
  static const List<int> timeWindowsHours = [6, 12, 24, 48, 72];

  Future<List<TriggerCorrelation>> calculateCorrelations({
    required String profileId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final correlations = <TriggerCorrelation>[];

    // Get all potential triggers
    final foods = await _foodLogRepository.getByDateRange(profileId, startDate, endDate);
    final activities = await _activityLogRepository.getByDateRange(profileId, startDate, endDate);
    final supplements = await _intakeLogRepository.getByDateRange(profileId, startDate, endDate);
    final sleepEntries = await _sleepRepository.getByDateRange(profileId, startDate, endDate);

    // Get all outcomes
    final conditionLogs = await _conditionLogRepository.getByDateRange(profileId, startDate, endDate);
    final flareUps = await _flareUpRepository.getByDateRange(profileId, startDate, endDate);

    // Calculate food → condition correlations
    final foodGroups = _groupByFoodItem(foods);
    for (final food in foodGroups) {
      if (food.occurrences.length < minExposures) continue;

      for (final condition in _getUniqueConditions(conditionLogs)) {
        for (final windowHours in timeWindowsHours) {
          final correlation = _calculateRelativeRisk(
            trigger: food,
            outcome: condition,
            conditionLogs: conditionLogs,
            windowHours: windowHours,
            totalDays: endDate.difference(startDate).inDays,
          );

          if (correlation != null && correlation.pValue < significanceThreshold) {
            correlations.add(correlation);
          }
        }
      }
    }

    // Calculate sleep quality → condition correlations
    for (final condition in _getUniqueConditions(conditionLogs)) {
      final sleepCorrelation = _calculateSleepCorrelation(
        sleepEntries: sleepEntries,
        condition: condition,
        conditionLogs: conditionLogs,
      );

      if (sleepCorrelation != null) {
        correlations.add(sleepCorrelation);
      }
    }

    // Calculate supplement → condition correlations (looking for benefits)
    // ... similar logic

    return _rankAndFilterCorrelations(correlations);
  }

  TriggerCorrelation? _calculateRelativeRisk({
    required TriggerGroup trigger,
    required ConditionGroup outcome,
    required List<ConditionLog> conditionLogs,
    required int windowHours,
    required int totalDays,
  }) {
    // Build 2x2 contingency table
    //
    //                    Outcome Yes | Outcome No
    // Trigger Yes (a)       a             b
    // Trigger No  (c)       c             d

    int a = 0, b = 0, c = 0, d = 0;

    final triggerDays = trigger.occurrences.map((t) => _dateOnly(t)).toSet();
    final outcomeDays = conditionLogs
      .where((l) => l.conditionId == outcome.id)
      .map((l) => _dateOnly(l.timestamp))
      .toSet();

    for (int dayOffset = 0; dayOffset < totalDays; dayOffset++) {
      final day = startDate.add(Duration(days: dayOffset));
      final dayKey = _dateOnly(day);

      final hadTrigger = triggerDays.contains(dayKey);
      final hadOutcome = _hadOutcomeInWindow(dayKey, outcomeDays, windowHours);

      if (hadTrigger && hadOutcome) a++;
      else if (hadTrigger && !hadOutcome) b++;
      else if (!hadTrigger && hadOutcome) c++;
      else d++;
    }

    if (a + b < minExposures || c + d < 5) {
      return null; // Insufficient data
    }

    // Calculate relative risk
    final riskExposed = a / (a + b);
    final riskUnexposed = c / (c + d);

    if (riskUnexposed == 0) {
      return null; // Cannot calculate RR
    }

    final relativeRisk = riskExposed / riskUnexposed;

    // Calculate 95% confidence interval (log method)
    final logRR = log(relativeRisk);
    final se = sqrt((1/a) - (1/(a+b)) + (1/c) - (1/(c+d)));
    final ciLow = exp(logRR - 1.96 * se);
    final ciHigh = exp(logRR + 1.96 * se);

    // Calculate p-value using chi-square test
    final expected = [
      (a+b) * (a+c) / (a+b+c+d),
      (a+b) * (b+d) / (a+b+c+d),
      (c+d) * (a+c) / (a+b+c+d),
      (c+d) * (b+d) / (a+b+c+d),
    ];
    final observed = [a, b, c, d];
    final chiSquare = _calculateChiSquare(observed, expected);
    final pValue = 1 - _chiSquareCDF(chiSquare, 1);

    // Determine correlation type
    CorrelationType type;
    if (relativeRisk > 1.5 && ciLow > 1.0) {
      type = CorrelationType.positive;
    } else if (relativeRisk < 0.67 && ciHigh < 1.0) {
      type = CorrelationType.negative;
    } else {
      type = CorrelationType.neutral;
    }

    return TriggerCorrelation(
      id: _uuid.v4(),
      profileId: profileId,
      triggerId: trigger.id,
      triggerType: 'food',
      triggerName: trigger.name,
      outcomeId: outcome.id,
      outcomeType: 'condition',
      outcomeName: outcome.name,
      correlationType: type,
      relativeRisk: relativeRisk,
      confidenceIntervalLow: ciLow,
      confidenceIntervalHigh: ciHigh,
      pValue: pValue,
      triggerExposures: a + b,
      outcomeOccurrences: a + c,
      cooccurrences: a,
      timeWindowHours: windowHours,
      averageLatencyHours: _calculateAverageLatency(trigger, outcome, conditionLogs),
      confidence: _calculateCorrelationConfidence(pValue, a + b, relativeRisk),
      detectedAt: DateTime.now(),
      dataRangeStart: startDate,
      dataRangeEnd: endDate,
    );
  }
}
```

### 3.4 Dose-Response Analysis

```dart
class DoseResponseAnalyzer {
  Future<DoseResponseCorrelation?> analyzeDoseResponse({
    required String profileId,
    required String triggerId,
    required String triggerType,
    required String outcomeId,
    required List<TriggerLog> triggerLogs,
    required List<OutcomeLog> outcomeLogs,
  }) async {
    // Pair each trigger with subsequent outcome severity
    final pairs = <DoseOutcomePair>[];

    for (final trigger in triggerLogs) {
      final outcomeInWindow = outcomeLogs.firstWhereOrNull((o) =>
        o.timestamp.isAfter(trigger.timestamp) &&
        o.timestamp.isBefore(trigger.timestamp.add(Duration(hours: 48))) &&
        o.outcomeId == outcomeId
      );

      if (outcomeInWindow != null) {
        pairs.add(DoseOutcomePair(
          dose: trigger.amount ?? 1.0,
          severity: outcomeInWindow.severity,
        ));
      }
    }

    if (pairs.length < 15) return null;

    // Linear regression
    final regression = _linearRegression(pairs);

    // Check if slope is significant
    if (regression.pValue > 0.05 || regression.rSquared < 0.3) {
      return null;
    }

    return DoseResponseCorrelation(
      triggerId: triggerId,
      outcomeId: outcomeId,
      slope: regression.slope,
      intercept: regression.intercept,
      rSquared: regression.rSquared,
      pValue: regression.pValue,
      equation: 'severity = ${regression.slope.toStringAsFixed(2)} × dose + ${regression.intercept.toStringAsFixed(2)}',
      sampleSize: pairs.length,
    );
  }
}
```

---

## 4. Health Insights Generator

### 4.1 Insight Categories

| Category | Description | Frequency |
|----------|-------------|-----------|
| **Summary** | Overview of recent health trends | Daily |
| **Pattern** | Newly detected patterns | As detected |
| **Trigger** | Strong trigger correlations | As detected |
| **Progress** | Improvement or decline in conditions | Weekly |
| **Compliance** | Supplement/diet adherence | Daily |
| **Anomaly** | Unusual readings or changes | Immediate |
| **Milestone** | Streaks, goals achieved | As achieved |
| **Recommendation** | Actionable suggestions | Weekly |

### 4.2 Insight Entity

```dart
@freezed
class HealthInsight with _$HealthInsight {
  const factory HealthInsight({
    required String id,
    required String profileId,
    required InsightCategory category,
    required InsightPriority priority,
    required String title,
    required String description,
    required String? actionableRecommendation,
    required List<InsightEvidence> evidence,
    required DateTime generatedAt,
    required DateTime? expiresAt,
    required bool isDismissed,
    required DateTime? dismissedAt,
    String? relatedEntityType,
    String? relatedEntityId,
  }) = _HealthInsight;
}

enum InsightCategory {
  summary,
  pattern,
  trigger,
  progress,
  compliance,
  anomaly,
  milestone,
  recommendation,
}

enum InsightPriority {
  high,      // Requires attention
  medium,    // Informative
  low,       // Nice to know
}

@freezed
class InsightEvidence with _$InsightEvidence {
  const factory InsightEvidence({
    required String description,
    required String entityType,
    required String? entityId,
    required DateTime? timestamp,
    required Map<String, dynamic>? data,
  }) = _InsightEvidence;
}
```

### 4.3 Insight Templates

```dart
class InsightTemplates {
  // Pattern Insights
  static HealthInsight temporalPattern(TemporalPattern pattern) {
    final peakUnit = _getPeakUnit(pattern.distribution, pattern.unit);
    final peakLabel = _formatUnitLabel(peakUnit, pattern.unit);

    return HealthInsight(
      id: _uuid.v4(),
      profileId: pattern.profileId,
      category: InsightCategory.pattern,
      priority: InsightPriority.medium,
      title: '${pattern.entityType.capitalize()} timing pattern detected',
      description: 'Your ${pattern.entityType} occurs most frequently on $peakLabel '
          '(${(pattern.distribution[peakUnit]! * 100).toStringAsFixed(0)}% of occurrences). '
          'This is ${_formatConfidence(pattern.confidence)} based on ${pattern.sampleSize} data points.',
      actionableRecommendation: _getTemporalRecommendation(pattern),
      evidence: [
        InsightEvidence(
          description: 'Distribution analysis over ${pattern.sampleSize} occurrences',
          entityType: pattern.entityType,
          entityId: pattern.entityId,
          timestamp: null,
          data: {'distribution': pattern.distribution},
        ),
      ],
      generatedAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: 30)),
      isDismissed: false,
      dismissedAt: null,
      relatedEntityType: pattern.entityType,
      relatedEntityId: pattern.entityId,
    );
  }

  // Trigger Insights
  static HealthInsight triggerCorrelation(TriggerCorrelation correlation) {
    final riskText = correlation.correlationType == CorrelationType.positive
        ? '${(correlation.relativeRisk).toStringAsFixed(1)}x more likely'
        : '${((1 / correlation.relativeRisk) * 100).toStringAsFixed(0)}% less likely';

    return HealthInsight(
      id: _uuid.v4(),
      profileId: correlation.profileId,
      category: InsightCategory.trigger,
      priority: correlation.relativeRisk > 2.0 || correlation.relativeRisk < 0.5
          ? InsightPriority.high
          : InsightPriority.medium,
      title: correlation.correlationType == CorrelationType.positive
          ? '${correlation.triggerName} may trigger ${correlation.outcomeName}'
          : '${correlation.triggerName} may help with ${correlation.outcomeName}',
      description: 'When you have ${correlation.triggerName}, you are $riskText to experience '
          '${correlation.outcomeName} within ${correlation.timeWindowHours} hours. '
          'This pattern appeared in ${correlation.cooccurrences} of ${correlation.triggerExposures} cases.',
      actionableRecommendation: correlation.correlationType == CorrelationType.positive
          ? 'Consider reducing ${correlation.triggerName} intake and track if ${correlation.outcomeName} improves.'
          : 'Continue with ${correlation.triggerName} - it appears to have a positive effect.',
      evidence: [
        InsightEvidence(
          description: 'Relative Risk: ${correlation.relativeRisk.toStringAsFixed(2)} '
              '(95% CI: ${correlation.confidenceIntervalLow.toStringAsFixed(2)}-'
              '${correlation.confidenceIntervalHigh.toStringAsFixed(2)})',
          entityType: correlation.triggerType,
          entityId: correlation.triggerId,
          timestamp: null,
          data: {
            'exposures': correlation.triggerExposures,
            'cooccurrences': correlation.cooccurrences,
            'pValue': correlation.pValue,
          },
        ),
      ],
      generatedAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: 60)),
      isDismissed: false,
      dismissedAt: null,
      relatedEntityType: correlation.triggerType,
      relatedEntityId: correlation.triggerId,
    );
  }

  // Progress Insights
  static HealthInsight conditionProgress({
    required String profileId,
    required String conditionId,
    required String conditionName,
    required double previousAvgSeverity,
    required double currentAvgSeverity,
    required int daysPrevious,
    required int daysCurrent,
  }) {
    final change = currentAvgSeverity - previousAvgSeverity;
    final percentChange = (change / previousAvgSeverity * 100).abs();
    final improving = change < 0;

    return HealthInsight(
      id: _uuid.v4(),
      profileId: profileId,
      category: InsightCategory.progress,
      priority: percentChange > 20 ? InsightPriority.high : InsightPriority.medium,
      title: improving
          ? '$conditionName is improving'
          : '$conditionName severity has increased',
      description: 'Your average $conditionName severity has ${improving ? 'decreased' : 'increased'} '
          'by ${percentChange.toStringAsFixed(0)}% over the past $daysCurrent days '
          '(from ${previousAvgSeverity.toStringAsFixed(1)} to ${currentAvgSeverity.toStringAsFixed(1)} '
          'on a 1-10 scale).',
      actionableRecommendation: improving
          ? 'Great progress! Review what changes you made recently that may have helped.'
          : 'Consider reviewing recent trigger exposures and supplement compliance.',
      evidence: [
        InsightEvidence(
          description: 'Severity comparison: Previous $daysPrevious days vs. Current $daysCurrent days',
          entityType: 'condition',
          entityId: conditionId,
          timestamp: null,
          data: {
            'previousAvg': previousAvgSeverity,
            'currentAvg': currentAvgSeverity,
            'percentChange': percentChange,
          },
        ),
      ],
      generatedAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: 7)),
      isDismissed: false,
      dismissedAt: null,
      relatedEntityType: 'condition',
      relatedEntityId: conditionId,
    );
  }

  // Anomaly Insights
  static HealthInsight anomaly({
    required String profileId,
    required String entityType,
    required String entityId,
    required String entityName,
    required double currentValue,
    required double expectedValue,
    required double standardDeviation,
  }) {
    final deviations = (currentValue - expectedValue).abs() / standardDeviation;

    return HealthInsight(
      id: _uuid.v4(),
      profileId: profileId,
      category: InsightCategory.anomaly,
      priority: deviations > 3 ? InsightPriority.high : InsightPriority.medium,
      title: 'Unusual $entityName reading',
      description: 'Today\'s $entityName (${currentValue.toStringAsFixed(1)}) is ${deviations.toStringAsFixed(1)} '
          'standard deviations ${currentValue > expectedValue ? 'above' : 'below'} your average '
          '(${expectedValue.toStringAsFixed(1)} ± ${standardDeviation.toStringAsFixed(1)}).',
      actionableRecommendation: 'This may be worth monitoring. Consider factors that might explain this change.',
      evidence: [
        InsightEvidence(
          description: 'Statistical anomaly detection',
          entityType: entityType,
          entityId: entityId,
          timestamp: DateTime.now(),
          data: {
            'currentValue': currentValue,
            'expectedValue': expectedValue,
            'standardDeviation': standardDeviation,
            'deviations': deviations,
          },
        ),
      ],
      generatedAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: 3)),
      isDismissed: false,
      dismissedAt: null,
      relatedEntityType: entityType,
      relatedEntityId: entityId,
    );
  }
}
```

### 4.4 Insight Generation Schedule

| Insight Type | Trigger | Minimum Interval |
|--------------|---------|------------------|
| Daily Summary | 8 PM local time | 24 hours |
| Pattern Detection | New data entry | 7 days |
| Trigger Correlation | 30+ days of data | 14 days |
| Progress Report | Weekly | 7 days |
| Compliance Check | Daily at 9 PM | 24 hours |
| Anomaly Alert | Real-time | None (immediate) |
| Milestone | Achievement | None (immediate) |
| Weekly Recommendations | Sunday 8 AM | 7 days |

---

## 5. Predictive Alerts

### 5.1 Prediction Types

| Type | Description | Model | Advance Warning |
|------|-------------|-------|-----------------|
| **Flare Prediction** | Predicts condition flare-ups | Random Forest | 24-72 hours |
| **Cycle Prediction** | Predicts menstrual cycle events | Statistical | 1-7 days |
| **Trigger Warning** | Warns before high-risk activities | Rule-based | Immediate |
| **Supplement Reminder** | Predicts missed doses | Pattern-based | 15-30 minutes |

### 5.2 Predictive Alert Entity

```dart
@freezed
class PredictiveAlert with _$PredictiveAlert {
  const factory PredictiveAlert({
    required String id,
    required String profileId,
    required PredictionType type,
    required String title,
    required String description,
    required double probability,           // 0.0 - 1.0
    required DateTime predictedEventTime,
    required DateTime alertGeneratedAt,
    required List<PredictionFactor> factors,
    required String? preventiveAction,
    required bool isAcknowledged,
    required DateTime? acknowledgedAt,
    required bool eventOccurred,          // For model feedback
    required DateTime? eventOccurredAt,
  }) = _PredictiveAlert;
}

enum PredictionType {
  flareUp,
  menstrualStart,
  ovulation,
  triggerExposure,
  missedSupplement,
  poorSleep,
}

@freezed
class PredictionFactor with _$PredictionFactor {
  const factory PredictionFactor({
    required String name,
    required double contribution,   // How much this factor contributes to prediction
    required String description,
  }) = _PredictionFactor;
}
```

### 5.3 Flare Prediction Model

```dart
class FlarePredictionModel {
  /// Minimum historical flares for training
  static const int minFlares = 5;

  /// Features used for prediction
  static const List<String> features = [
    'days_since_last_flare',
    'avg_severity_last_7_days',
    'sleep_quality_last_3_days',
    'trigger_exposures_last_48h',
    'supplement_compliance_last_7_days',
    'stress_level_reported',
    'day_of_week',
    'days_in_menstrual_cycle',
    'weather_pressure_change',
  ];

  /// Prediction threshold to generate alert
  static const double alertThreshold = 0.6;

  Future<PredictiveAlert?> predictFlare({
    required String profileId,
    required String conditionId,
  }) async {
    // Get historical flares for this condition
    final flares = await _flareRepository.getByCondition(profileId, conditionId);

    if (flares.length < minFlares) {
      return null; // Insufficient training data
    }

    // Extract features for current state
    final currentFeatures = await _extractFeatures(profileId, conditionId);

    // Run prediction model
    final prediction = _model.predict(currentFeatures);

    if (prediction.probability < alertThreshold) {
      return null; // Below threshold
    }

    // Identify contributing factors
    final factors = _identifyTopFactors(currentFeatures, prediction);

    return PredictiveAlert(
      id: _uuid.v4(),
      profileId: profileId,
      type: PredictionType.flareUp,
      title: 'Possible ${_getConditionName(conditionId)} flare-up ahead',
      description: 'Based on your recent patterns, there\'s a '
          '${(prediction.probability * 100).toStringAsFixed(0)}% chance of a flare-up '
          'in the next ${prediction.windowHours} hours.',
      probability: prediction.probability,
      predictedEventTime: DateTime.now().add(Duration(hours: prediction.windowHours)),
      alertGeneratedAt: DateTime.now(),
      factors: factors,
      preventiveAction: _generatePreventiveAction(factors, conditionId),
      isAcknowledged: false,
      acknowledgedAt: null,
      eventOccurred: false,
      eventOccurredAt: null,
    );
  }

  Future<Map<String, double>> _extractFeatures(String profileId, String conditionId) async {
    final now = DateTime.now();

    // Days since last flare
    final lastFlare = await _flareRepository.getMostRecent(profileId, conditionId);
    final daysSinceFlare = lastFlare != null
        ? now.difference(lastFlare.startTime).inDays.toDouble()
        : 30.0;

    // Average severity last 7 days
    final recentLogs = await _conditionLogRepository.getByDateRange(
      profileId: profileId,
      conditionId: conditionId,
      startDate: now.subtract(Duration(days: 7)),
      endDate: now,
    );
    final avgSeverity = recentLogs.isNotEmpty
        ? recentLogs.map((l) => l.severity).average
        : 0.0;

    // Sleep quality last 3 days
    final recentSleep = await _sleepRepository.getByDateRange(
      profileId: profileId,
      startDate: now.subtract(Duration(days: 3)),
      endDate: now,
    );
    final avgSleepQuality = recentSleep.isNotEmpty
        ? recentSleep.map((s) => s.quality).average
        : 5.0;

    // Trigger exposures (known triggers)
    final triggers = await _triggerCorrelationRepository.getPositive(profileId, conditionId);
    final triggerExposures = await _countTriggerExposures(
      profileId, triggers, Duration(hours: 48),
    );

    // Supplement compliance
    final compliance = await _supplementComplianceService.getComplianceRate(
      profileId: profileId,
      days: 7,
    );

    return {
      'days_since_last_flare': daysSinceFlare,
      'avg_severity_last_7_days': avgSeverity,
      'sleep_quality_last_3_days': avgSleepQuality,
      'trigger_exposures_last_48h': triggerExposures.toDouble(),
      'supplement_compliance_last_7_days': compliance,
      'day_of_week': now.weekday.toDouble(),
      // ... additional features
    };
  }

  List<PredictionFactor> _identifyTopFactors(
    Map<String, double> features,
    Prediction prediction,
  ) {
    // Get feature importance from model
    final importance = _model.featureImportance;

    // Sort by contribution to this prediction
    final contributions = features.entries.map((e) {
      final imp = importance[e.key] ?? 0.0;
      final deviation = _getDeviation(e.key, e.value);
      return MapEntry(e.key, imp * deviation);
    }).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Return top 3 factors
    return contributions.take(3).map((e) => PredictionFactor(
      name: _formatFeatureName(e.key),
      contribution: e.value,
      description: _formatFactorDescription(e.key, features[e.key]!),
    )).toList();
  }

  String _generatePreventiveAction(List<PredictionFactor> factors, String conditionId) {
    final topFactor = factors.first.name.toLowerCase();

    if (topFactor.contains('sleep')) {
      return 'Prioritize good sleep tonight. Consider going to bed 30 minutes earlier.';
    } else if (topFactor.contains('trigger')) {
      return 'Avoid known triggers today if possible, especially in the evening.';
    } else if (topFactor.contains('supplement')) {
      return 'Make sure to take all scheduled supplements on time today.';
    } else if (topFactor.contains('stress')) {
      return 'Consider stress-reduction activities like meditation or a short walk.';
    }

    return 'Monitor symptoms closely and rest if needed.';
  }
}
```

### 5.4 Menstrual Cycle Prediction

```dart
class MenstrualCyclePredictionService {
  Future<List<PredictiveAlert>> generateCyclePredictions({
    required String profileId,
  }) async {
    final alerts = <PredictiveAlert>[];
    final pattern = await _cyclicalPatternRepository.getMenstrualPattern(profileId);

    if (pattern == null || pattern.confidence < 0.6) {
      return alerts;
    }

    // Predict next period start
    if (pattern.predictedNextStart != null) {
      final daysUntil = pattern.predictedNextStart!.difference(DateTime.now()).inDays;

      if (daysUntil <= 7 && daysUntil > 0) {
        alerts.add(PredictiveAlert(
          id: _uuid.v4(),
          profileId: profileId,
          type: PredictionType.menstrualStart,
          title: 'Period expected in $daysUntil days',
          description: 'Based on your ${pattern.averageLengthDays}-day cycle '
              '(${(pattern.regularity * 100).toStringAsFixed(0)}% regular), '
              'your next period is expected around '
              '${DateFormat.MMMd().format(pattern.predictedNextStart!)}.',
          probability: pattern.regularity,
          predictedEventTime: pattern.predictedNextStart!,
          alertGeneratedAt: DateTime.now(),
          factors: [
            PredictionFactor(
              name: 'Cycle Length',
              contribution: 0.6,
              description: 'Average ${pattern.averageLengthDays} days',
            ),
            PredictionFactor(
              name: 'Regularity',
              contribution: 0.3,
              description: '±${pattern.standardDeviationDays.toStringAsFixed(1)} days variation',
            ),
          ],
          preventiveAction: 'Stock up on supplies and plan for potential symptoms.',
          isAcknowledged: false,
          acknowledgedAt: null,
          eventOccurred: false,
          eventOccurredAt: null,
        ));
      }
    }

    // Predict ovulation (if BBT data available)
    if (pattern.phases.isNotEmpty) {
      final avgFollicular = pattern.phases.map((p) => p.follicularDays).average;
      final lastPeriod = await _fluidsRepository.getLastMenstruationStart(profileId);

      if (lastPeriod != null) {
        final predictedOvulation = lastPeriod.add(Duration(days: avgFollicular.round()));
        final daysUntil = predictedOvulation.difference(DateTime.now()).inDays;

        if (daysUntil <= 5 && daysUntil >= -1) {
          alerts.add(PredictiveAlert(
            id: _uuid.v4(),
            profileId: profileId,
            type: PredictionType.ovulation,
            title: daysUntil > 0
                ? 'Ovulation expected in $daysUntil days'
                : 'Ovulation window now',
            description: 'Based on your BBT patterns, ovulation is predicted around '
                '${DateFormat.MMMd().format(predictedOvulation)}. '
                'Look for a 0.2°F+ temperature rise to confirm.',
            probability: pattern.phases.where((p) => p.ovulationDetected).length /
                pattern.phases.length,
            predictedEventTime: predictedOvulation,
            alertGeneratedAt: DateTime.now(),
            factors: [
              PredictionFactor(
                name: 'Follicular Phase',
                contribution: 0.5,
                description: 'Average ${avgFollicular.toStringAsFixed(0)} days',
              ),
            ],
            preventiveAction: 'Record BBT each morning before getting up.',
            isAcknowledged: false,
            acknowledgedAt: null,
            eventOccurred: false,
            eventOccurredAt: null,
          ));
        }
      }
    }

    return alerts;
  }
}
```

### 5.5 Model Feedback Loop

```dart
class PredictionFeedbackService {
  /// Records whether a predicted event actually occurred
  Future<void> recordOutcome({
    required String alertId,
    required bool eventOccurred,
    required DateTime? eventTime,
  }) async {
    final alert = await _alertRepository.getById(alertId);

    if (alert == null) return;

    // Update alert with outcome
    await _alertRepository.update(alert.copyWith(
      eventOccurred: eventOccurred,
      eventOccurredAt: eventTime,
    ));

    // Add to training data for model improvement
    await _trainingDataRepository.addFeedback(PredictionFeedback(
      alertId: alertId,
      predictionType: alert.type,
      predictedProbability: alert.probability,
      actualOutcome: eventOccurred,
      predictionWindowHours: alert.predictedEventTime.difference(alert.alertGeneratedAt).inHours,
      actualLatencyHours: eventTime != null
          ? eventTime.difference(alert.alertGeneratedAt).inHours
          : null,
    ));

    // Trigger model retraining if enough new data
    final feedbackCount = await _trainingDataRepository.getRecentFeedbackCount(
      type: alert.type,
      days: 30,
    );

    if (feedbackCount >= 10) {
      await _scheduleModelRetraining(alert.type);
    }
  }
}
```

---

## 6. Machine Learning Models

### 6.1 Model Architecture

All models run locally on-device using TensorFlow Lite or ML Kit.

| Model | Algorithm | Input | Output | Size |
|-------|-----------|-------|--------|------|
| Flare Prediction | Random Forest | 9 features | Probability + window | ~500KB |
| Severity Forecast | LSTM | 14-day sequence | 7-day forecast | ~1MB |
| Trigger Ranking | Logistic Regression | Correlation features | Priority score | ~100KB |
| Anomaly Detection | Isolation Forest | Entity statistics | Anomaly score | ~200KB |

### 6.2 Model Training

```dart
class LocalModelTrainer {
  /// Minimum samples for initial training
  static const int minTrainingSamples = 50;

  /// Retrain when accuracy drops below threshold
  static const double retrainingThreshold = 0.7;

  Future<TrainingResult> trainFlareModel({
    required String profileId,
    required String conditionId,
  }) async {
    // Get historical data
    final flares = await _flareRepository.getAll(profileId, conditionId);
    final nonFlares = await _generateNegativeSamples(profileId, conditionId, flares);

    if (flares.length + nonFlares.length < minTrainingSamples) {
      return TrainingResult.insufficientData(
        required: minTrainingSamples,
        available: flares.length + nonFlares.length,
      );
    }

    // Prepare training data
    final trainingData = await _prepareTrainingData(flares, nonFlares);

    // Train model using TFLite
    final model = await _trainRandomForest(trainingData);

    // Evaluate with cross-validation
    final metrics = await _crossValidate(model, trainingData, folds: 5);

    // Save model if performance is acceptable
    if (metrics.accuracy >= retrainingThreshold) {
      await _saveModel(profileId, conditionId, model);
    }

    return TrainingResult.success(
      accuracy: metrics.accuracy,
      precision: metrics.precision,
      recall: metrics.recall,
      samplesUsed: trainingData.length,
    );
  }
}
```

### 6.3 Model Updates

| Update Type | Trigger | Action |
|-------------|---------|--------|
| Initial Training | 50+ relevant data points | Create model |
| Incremental Update | 10+ new feedback samples | Update weights |
| Full Retraining | Accuracy < 70% | Retrain from scratch |
| Model Reset | User request | Delete and retrain |

---

## 7. Data Requirements

### 7.1 Minimum Data for Features

| Feature | Minimum Data | Optimal Data |
|---------|--------------|--------------|
| Temporal Patterns | 14 days | 90 days |
| Trigger Correlations | 30 days, 10+ exposures | 90 days |
| Cyclical Patterns | 3 cycles | 6+ cycles |
| Flare Prediction | 5 flares | 15+ flares |
| Health Insights | 7 days | 30+ days |
| Dose-Response | 15 paired observations | 50+ observations |

### 7.2 Data Quality Indicators

```dart
class DataQualityService {
  Future<DataQualityReport> assessQuality(String profileId) async {
    final report = DataQualityReport();

    // Check data completeness
    report.supplementLogging = await _assessSupplementCompleteness(profileId);
    report.conditionTracking = await _assessConditionCompleteness(profileId);
    report.foodLogging = await _assessFoodCompleteness(profileId);
    report.sleepTracking = await _assessSleepCompleteness(profileId);

    // Check data consistency
    report.timestampConsistency = await _checkTimestampConsistency(profileId);
    report.duplicateRate = await _checkDuplicates(profileId);

    // Calculate overall score
    report.overallScore = _calculateOverallScore(report);

    // Generate recommendations
    report.recommendations = _generateRecommendations(report);

    return report;
  }
}

@freezed
class DataQualityReport with _$DataQualityReport {
  const factory DataQualityReport({
    required double supplementLogging,    // 0.0 - 1.0
    required double conditionTracking,
    required double foodLogging,
    required double sleepTracking,
    required double timestampConsistency,
    required double duplicateRate,
    required double overallScore,
    required List<String> recommendations,
  }) = _DataQualityReport;
}
```

---

## 8. Database Schema

### 8.1 New Tables

```sql
-- Detected patterns
CREATE TABLE patterns (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  pattern_type INTEGER NOT NULL,        -- 0: temporal, 1: cyclical, 2: sequential, 3: cluster, 4: dosage
  entity_type TEXT NOT NULL,
  entity_id TEXT,
  data_json TEXT NOT NULL,              -- Pattern-specific data as JSON
  confidence REAL NOT NULL,
  sample_size INTEGER NOT NULL,
  detected_at INTEGER NOT NULL,
  data_range_start INTEGER NOT NULL,
  data_range_end INTEGER NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1,

  -- Sync metadata
  sync_id TEXT NOT NULL,
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER NOT NULL,
  sync_deleted_at INTEGER,
  sync_status INTEGER NOT NULL DEFAULT 0,  -- 0=pending, 1=synced, 2=conflict, 3=error
  sync_version INTEGER NOT NULL DEFAULT 1,
  sync_device_id TEXT NOT NULL,
  is_dirty INTEGER NOT NULL DEFAULT 1,

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE INDEX idx_patterns_profile ON patterns(profile_id, pattern_type, is_active);
CREATE INDEX idx_patterns_entity ON patterns(entity_type, entity_id);

-- Trigger correlations
CREATE TABLE trigger_correlations (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  trigger_id TEXT NOT NULL,
  trigger_type TEXT NOT NULL,
  trigger_name TEXT NOT NULL,
  outcome_id TEXT NOT NULL,
  outcome_type TEXT NOT NULL,
  outcome_name TEXT NOT NULL,
  correlation_type INTEGER NOT NULL,    -- 0: positive, 1: negative, 2: neutral, 3: dose-response
  relative_risk REAL NOT NULL,
  ci_low REAL NOT NULL,
  ci_high REAL NOT NULL,
  p_value REAL NOT NULL,
  trigger_exposures INTEGER NOT NULL,
  outcome_occurrences INTEGER NOT NULL,
  cooccurrences INTEGER NOT NULL,
  time_window_hours INTEGER NOT NULL,
  average_latency_hours REAL NOT NULL,
  confidence REAL NOT NULL,
  detected_at INTEGER NOT NULL,
  data_range_start INTEGER NOT NULL,
  data_range_end INTEGER NOT NULL,
  dose_response_equation TEXT,
  is_active INTEGER NOT NULL DEFAULT 1,

  -- Sync metadata
  sync_id TEXT NOT NULL,
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER NOT NULL,
  sync_deleted_at INTEGER,
  sync_status INTEGER NOT NULL DEFAULT 0,  -- 0=pending, 1=synced, 2=conflict, 3=error
  sync_version INTEGER NOT NULL DEFAULT 1,
  sync_device_id TEXT NOT NULL,
  is_dirty INTEGER NOT NULL DEFAULT 1,

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE INDEX idx_correlations_profile ON trigger_correlations(profile_id, is_active);
CREATE INDEX idx_correlations_trigger ON trigger_correlations(trigger_type, trigger_id);
CREATE INDEX idx_correlations_outcome ON trigger_correlations(outcome_type, outcome_id);
CREATE INDEX idx_correlations_type ON trigger_correlations(correlation_type) WHERE is_active = 1;

-- Health insights
CREATE TABLE health_insights (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  category INTEGER NOT NULL,            -- InsightCategory enum
  priority INTEGER NOT NULL,            -- InsightPriority enum
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  recommendation TEXT,
  evidence_json TEXT NOT NULL,
  generated_at INTEGER NOT NULL,
  expires_at INTEGER,
  is_dismissed INTEGER NOT NULL DEFAULT 0,
  dismissed_at INTEGER,
  related_entity_type TEXT,
  related_entity_id TEXT,

  -- Sync metadata
  sync_id TEXT NOT NULL,
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER NOT NULL,
  sync_deleted_at INTEGER,
  sync_status INTEGER NOT NULL DEFAULT 0,  -- 0=pending, 1=synced, 2=conflict, 3=error
  sync_version INTEGER NOT NULL DEFAULT 1,
  sync_device_id TEXT NOT NULL,
  is_dirty INTEGER NOT NULL DEFAULT 1,

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE INDEX idx_insights_profile ON health_insights(profile_id, is_dismissed, category);
CREATE INDEX idx_insights_active ON health_insights(profile_id, expires_at) WHERE is_dismissed = 0;
CREATE INDEX idx_insights_entity ON health_insights(related_entity_type, related_entity_id);

-- Predictive alerts
CREATE TABLE predictive_alerts (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  prediction_type INTEGER NOT NULL,     -- PredictionType enum
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  probability REAL NOT NULL,
  predicted_event_time INTEGER NOT NULL,
  alert_generated_at INTEGER NOT NULL,
  factors_json TEXT NOT NULL,
  preventive_action TEXT,
  is_acknowledged INTEGER NOT NULL DEFAULT 0,
  acknowledged_at INTEGER,
  event_occurred INTEGER,               -- NULL = unknown, 0 = no, 1 = yes
  event_occurred_at INTEGER,

  -- Sync metadata
  sync_id TEXT NOT NULL,
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER NOT NULL,
  sync_deleted_at INTEGER,
  sync_status INTEGER NOT NULL DEFAULT 0,  -- 0=pending, 1=synced, 2=conflict, 3=error
  sync_version INTEGER NOT NULL DEFAULT 1,
  sync_device_id TEXT NOT NULL,
  is_dirty INTEGER NOT NULL DEFAULT 1,

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE INDEX idx_alerts_profile ON predictive_alerts(profile_id, is_acknowledged);
CREATE INDEX idx_alerts_pending ON predictive_alerts(profile_id, predicted_event_time)
  WHERE is_acknowledged = 0;
CREATE INDEX idx_alerts_feedback ON predictive_alerts(prediction_type, event_occurred)
  WHERE event_occurred IS NOT NULL;

-- ML model metadata
CREATE TABLE ml_models (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  model_type TEXT NOT NULL,             -- 'flare_prediction', 'severity_forecast', etc.
  condition_id TEXT,                    -- For condition-specific models
  model_path TEXT NOT NULL,             -- Path to model file
  accuracy REAL,
  precision_score REAL,
  recall_score REAL,
  training_samples INTEGER NOT NULL,
  trained_at INTEGER NOT NULL,
  last_used_at INTEGER,
  version INTEGER NOT NULL DEFAULT 1,

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX idx_models_unique ON ml_models(profile_id, model_type, condition_id);

-- Prediction feedback for model improvement
CREATE TABLE prediction_feedback (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  alert_id TEXT NOT NULL,
  prediction_type INTEGER NOT NULL,
  predicted_probability REAL NOT NULL,
  actual_outcome INTEGER NOT NULL,      -- 0 or 1
  prediction_window_hours INTEGER NOT NULL,
  actual_latency_hours INTEGER,
  recorded_at INTEGER NOT NULL,

  FOREIGN KEY (alert_id) REFERENCES predictive_alerts(id) ON DELETE CASCADE
);

CREATE INDEX idx_feedback_type ON prediction_feedback(prediction_type, recorded_at);
```

### 8.2 Migration (v5 → v6)

```sql
-- Migration 6: Intelligence System tables
-- Run after Diet System migration (v5)

CREATE TABLE patterns (...);
CREATE TABLE trigger_correlations (...);
CREATE TABLE health_insights (...);
CREATE TABLE predictive_alerts (...);
CREATE TABLE ml_models (...);
CREATE TABLE prediction_feedback (...);

-- Create all indexes as specified above
```

---

## 9. API Contracts

### 9.1 Repository Contracts

```dart
// Pattern Repository
abstract class PatternRepository {
  Future<Result<List<Pattern>, AppError>> getByProfile(
    String profileId, {
    PatternType? type,
    bool activeOnly = true,
  });

  Future<Result<List<Pattern>, AppError>> getByEntity(
    String entityType,
    String entityId,
  );

  Future<Result<Pattern, AppError>> create(Pattern pattern);
  Future<Result<Pattern, AppError>> update(Pattern pattern);
  Future<Result<void, AppError>> deactivate(String id);
}

// Trigger Correlation Repository
abstract class TriggerCorrelationRepository {
  Future<Result<List<TriggerCorrelation>, AppError>> getByProfile(
    String profileId, {
    CorrelationType? type,
    bool activeOnly = true,
  });

  Future<Result<List<TriggerCorrelation>, AppError>> getByTrigger(
    String triggerType,
    String triggerId,
  );

  Future<Result<List<TriggerCorrelation>, AppError>> getByOutcome(
    String outcomeType,
    String outcomeId,
  );

  Future<Result<List<TriggerCorrelation>, AppError>> getPositive(
    String profileId,
    String outcomeId,
  );

  Future<Result<TriggerCorrelation, AppError>> create(TriggerCorrelation correlation);
  Future<Result<void, AppError>> deactivate(String id);
}

// Health Insight Repository
abstract class HealthInsightRepository {
  Future<Result<List<HealthInsight>, AppError>> getActive(
    String profileId, {
    InsightCategory? category,
    InsightPriority? minPriority,
    int? limit,
  });

  Future<Result<List<HealthInsight>, AppError>> getByEntity(
    String entityType,
    String entityId,
  );

  Future<Result<HealthInsight, AppError>> create(HealthInsight insight);
  Future<Result<void, AppError>> dismiss(String id);
}

// Predictive Alert Repository
abstract class PredictiveAlertRepository {
  Future<Result<List<PredictiveAlert>, AppError>> getPending(
    String profileId, {
    PredictionType? type,
  });

  Future<Result<List<PredictiveAlert>, AppError>> getByDateRange(
    String profileId,
    DateTime startDate,
    DateTime endDate,
  );

  Future<Result<PredictiveAlert, AppError>> create(PredictiveAlert alert);
  Future<Result<void, AppError>> acknowledge(String id);
  Future<Result<void, AppError>> recordOutcome(
    String id,
    bool occurred,
    DateTime? occurredAt,
  );
}
```

### 9.2 Use Case Contracts

```dart
// Pattern Detection
class DetectPatternsUseCase {
  Future<Result<List<Pattern>, AppError>> call(DetectPatternsInput input);
}

@freezed
class DetectPatternsInput with _$DetectPatternsInput {
  const factory DetectPatternsInput({
    required String profileId,
    required PatternType type,
    String? entityType,
    String? entityId,
    DateTime? startDate,
    DateTime? endDate,
  }) = _DetectPatternsInput;
}

// Trigger Analysis
class AnalyzeTriggersUseCase {
  Future<Result<List<TriggerCorrelation>, AppError>> call(AnalyzeTriggersInput input);
}

@freezed
class AnalyzeTriggersInput with _$AnalyzeTriggersInput {
  const factory AnalyzeTriggersInput({
    required String profileId,
    required String outcomeType,
    required String outcomeId,
    DateTime? startDate,
    DateTime? endDate,
  }) = _AnalyzeTriggersInput;
}

// Insight Generation
class GenerateInsightsUseCase {
  Future<Result<List<HealthInsight>, AppError>> call(GenerateInsightsInput input);
}

@freezed
class GenerateInsightsInput with _$GenerateInsightsInput {
  const factory GenerateInsightsInput({
    required String profileId,
    List<InsightCategory>? categories,
    bool forceRefresh = false,
  }) = _GenerateInsightsInput;
}

// Predictive Alerts
class GeneratePredictiveAlertsUseCase {
  Future<Result<List<PredictiveAlert>, AppError>> call(String profileId);
}

// Data Quality Assessment
class AssessDataQualityUseCase {
  Future<Result<DataQualityReport, AppError>> call(String profileId);
}
```

---

## 10. UI Specifications

### 10.1 Insights Dashboard Screen

```
┌─────────────────────────────────────────────────────────────────────┐
│ ←  Health Insights                                            ⚙️   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  🔴 HIGH PRIORITY                                            │   │
│  │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │   │
│  │                                                              │   │
│  │  ⚠️ Dairy may trigger Joint Pain                            │   │
│  │  When you consume dairy, you are 2.3x more likely to        │   │
│  │  experience joint pain within 24 hours.                      │   │
│  │                                                              │   │
│  │  Evidence: 18 of 24 dairy exposures followed by symptoms    │   │
│  │                                                              │   │
│  │  💡 Consider reducing dairy intake to test this pattern     │   │
│  │                                                              │   │
│  │  [View Details]                           [Dismiss]          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  🟡 MEDIUM PRIORITY                                          │   │
│  │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │   │
│  │                                                              │   │
│  │  📊 Migraine frequency pattern detected                      │   │
│  │  Your migraines occur 68% more often on Mondays.            │   │
│  │  Based on 47 occurrences over 90 days.                      │   │
│  │                                                              │   │
│  │  [View Pattern]                           [Dismiss]          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  📈 Fatigue severity has improved                            │   │
│  │  Average severity decreased 28% over the past 14 days.      │   │
│  │                                                              │   │
│  │  [View Progress]                          [Dismiss]          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  🟢 LOW PRIORITY                                             │   │
│  │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │   │
│  │                                                              │   │
│  │  🎯 7-day supplement streak!                                 │   │
│  │  Keep up the great compliance.                              │   │
│  │                                                              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 10.2 Trigger Correlation Detail Screen

```
┌─────────────────────────────────────────────────────────────────────┐
│ ←  Dairy → Joint Pain                                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    CORRELATION STRENGTH                      │   │
│  │                                                              │   │
│  │         Weak        Moderate        Strong                   │   │
│  │    ○─────────────────────────●────────────────○              │   │
│  │                                                              │   │
│  │              2.3x more likely (p < 0.01)                     │   │
│  │              95% CI: 1.8 - 2.9                               │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                       STATISTICS                             │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │  Dairy Exposures:           24                               │   │
│  │  Followed by Joint Pain:    18 (75%)                         │   │
│  │  Average Time to Onset:     14.2 hours                       │   │
│  │  Analysis Period:           Jan 1 - Mar 31, 2026             │   │
│  │  Data Points:               2,847 entries                    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                     TIMELINE VIEW                            │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │                                                              │   │
│  │  Jan ▓▓░░▓▓▓░░▓░░░▓▓░░▓▓░░░▓░░▓▓░░                         │   │
│  │  Feb ░▓▓░░▓░░▓▓▓░░░▓░▓░░▓▓░░░▓░░░                          │   │
│  │  Mar ▓▓░▓░░░▓▓░░▓░▓░░░▓▓░░▓░░░▓▓░                          │   │
│  │                                                              │   │
│  │  ▓ = Dairy consumed, followed by joint pain                  │   │
│  │  ░ = Dairy consumed, no joint pain                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                   RECOMMENDATION                             │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │  Consider a 2-week dairy elimination trial to test if       │   │
│  │  joint pain symptoms improve.                               │   │
│  │                                                              │   │
│  │  [Start Elimination Trial]                                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│               [Add to Report]        [Share with Provider]          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 10.3 Predictive Alert Card

```
┌─────────────────────────────────────────────────────────────────────┐
│  ⚠️ FLARE-UP WARNING                                                │
│  ────────────────────────────────────────────────────────────────   │
│                                                                     │
│  Possible Migraine flare-up in next 24-48 hours                    │
│                                                                     │
│  Probability: ██████████░░░░░░░░░░ 68%                              │
│                                                                     │
│  Contributing factors:                                              │
│  • Poor sleep last 2 nights (5.2 hrs avg)                          │
│  • Trigger exposure: Red wine yesterday                             │
│  • High stress reported                                             │
│                                                                     │
│  💡 Suggestion: Prioritize rest tonight and avoid additional       │
│     triggers if possible.                                           │
│                                                                     │
│  [Got It]    [Remind Me Later]    [This Didn't Happen] ← (after)   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 10.4 Pattern Visualization Screen

```
┌─────────────────────────────────────────────────────────────────────┐
│ ←  Migraine Timing Pattern                                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                  DAY OF WEEK DISTRIBUTION                    │   │
│  │                                                              │   │
│  │  Mon  ████████████████████████████  28%                      │   │
│  │  Tue  ██████████████               14%                       │   │
│  │  Wed  ████████████                 12%                       │   │
│  │  Thu  ██████████████               14%                       │   │
│  │  Fri  ██████████                   10%                       │   │
│  │  Sat  ██████████                   10%                       │   │
│  │  Sun  ████████████                 12%                       │   │
│  │                                                              │   │
│  │  ⚡ Peak: Monday (2.3x higher than average)                  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                  TIME OF DAY DISTRIBUTION                    │   │
│  │                                                              │   │
│  │  12AM ░░░░░░░░░░░░                                           │   │
│  │  6AM  ░░░░██████████████                                     │   │
│  │  12PM ██████████████████████████████                         │   │
│  │  6PM  ████████████████████                                   │   │
│  │  12AM ░░░░░░░░░░                                             │   │
│  │                                                              │   │
│  │  ⚡ Peak: 11 AM - 2 PM (42% of occurrences)                  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  📊 Analysis Details                                         │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │  Sample Size:     47 migraine occurrences                    │   │
│  │  Date Range:      Jan 1 - Mar 31, 2026                       │   │
│  │  Confidence:      High (87%)                                 │   │
│  │  Statistical:     χ² = 18.4, p < 0.01                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│                     [Add to Report]                                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 10.5 Data Quality Screen

```
┌─────────────────────────────────────────────────────────────────────┐
│ ←  Data Quality                                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    OVERALL QUALITY                           │   │
│  │                                                              │   │
│  │                        78%                                   │   │
│  │                   ████████████░░░░                           │   │
│  │                                                              │   │
│  │           Good quality for pattern detection                 │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  TRACKING COMPLETENESS                                       │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │                                                              │   │
│  │  Supplements    ████████████████████  95%  ✅               │   │
│  │  Conditions     ██████████████████░░  88%  ✅               │   │
│  │  Food           ████████████████░░░░  78%  ⚠️               │   │
│  │  Sleep          ████████████░░░░░░░░  62%  ⚠️               │   │
│  │  Fluids         ████████░░░░░░░░░░░░  45%  ❌               │   │
│  │                                                              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  💡 RECOMMENDATIONS                                          │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │                                                              │   │
│  │  1. Log water intake more consistently                       │   │
│  │     Currently missing 55% of days                            │   │
│  │                                                              │   │
│  │  2. Track sleep every night                                  │   │
│  │     Missing 4 of last 10 nights                              │   │
│  │                                                              │   │
│  │  3. Log all meals, not just main meals                       │   │
│  │     Snacks help identify triggers                            │   │
│  │                                                              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  📈 FEATURE AVAILABILITY                                     │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │                                                              │   │
│  │  ✅ Temporal Patterns       (47 data points)                 │   │
│  │  ✅ Trigger Correlations    (38 food logs)                   │   │
│  │  ⚠️ Flare Prediction        (3 of 5 flares needed)          │   │
│  │  ⚠️ Cycle Predictions       (2 of 3 cycles needed)          │   │
│  │                                                              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 11. Privacy & Security

### 11.1 Local Processing

All intelligence processing occurs on-device:

| Operation | Location | Data Sent Externally |
|-----------|----------|---------------------|
| Pattern Detection | Device | None |
| Trigger Correlation | Device | None |
| ML Model Training | Device | None |
| Model Inference | Device | None |
| Insight Generation | Device | None |

### 11.2 Data Retention

| Data Type | Retention | User Control |
|-----------|-----------|--------------|
| Patterns | Until invalidated or deleted | Can delete anytime |
| Correlations | Until invalidated or deleted | Can delete anytime |
| Insights | 90 days or until dismissed | Can dismiss anytime |
| Alerts | 30 days after event time | Can delete anytime |
| ML Models | Until retrained or deleted | Can reset models |
| Feedback | 1 year | Included in data export |

### 11.3 User Consent

```dart
class IntelligenceConsentService {
  static const List<IntelligenceFeature> features = [
    IntelligenceFeature(
      id: 'pattern_detection',
      name: 'Pattern Detection',
      description: 'Automatically identify recurring patterns in your health data',
      defaultEnabled: true,
    ),
    IntelligenceFeature(
      id: 'trigger_correlation',
      name: 'Trigger Analysis',
      description: 'Find connections between foods, activities, and symptoms',
      defaultEnabled: true,
    ),
    IntelligenceFeature(
      id: 'predictive_alerts',
      name: 'Predictive Alerts',
      description: 'Get warnings before potential health events',
      defaultEnabled: false,  // Opt-in due to ML
    ),
    IntelligenceFeature(
      id: 'health_insights',
      name: 'Health Insights',
      description: 'Receive personalized observations and recommendations',
      defaultEnabled: true,
    ),
  ];
}
```

### 11.4 Disclaimers

All insight screens display:

```
┌─────────────────────────────────────────────────────────────────────┐
│  ℹ️ These insights are based on your logged data and are not       │
│     medical advice. Always consult a healthcare provider for        │
│     diagnosis and treatment decisions.                              │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 12. Localization

### 12.1 New Keys

```json
{
  "insights": "Insights",
  "healthInsights": "Health Insights",
  "patterns": "Patterns",
  "triggers": "Triggers",
  "predictions": "Predictions",
  "dataQuality": "Data Quality",

  "patternDetected": "Pattern detected",
  "triggerFound": "Trigger found",
  "insightGenerated": "New insight",
  "predictionAlert": "Prediction alert",

  "highPriority": "High priority",
  "mediumPriority": "Medium priority",
  "lowPriority": "Low priority",

  "correlationStrength": "Correlation strength",
  "weak": "Weak",
  "moderate": "Moderate",
  "strong": "Strong",

  "relativeRisk": "Relative risk",
  "timesMoreLikely": "{count}x more likely",
  "@timesMoreLikely": {"placeholders": {"count": {"type": "double"}}},
  "percentLessLikely": "{percent}% less likely",
  "@percentLessLikely": {"placeholders": {"percent": {"type": "int"}}},

  "confidenceInterval": "95% confidence interval",
  "statisticalSignificance": "Statistical significance",
  "sampleSize": "Sample size",
  "dataPoints": "{count} data points",
  "@dataPoints": {"placeholders": {"count": {"type": "int"}}},

  "temporalPattern": "Timing pattern",
  "cyclicalPattern": "Cycle pattern",
  "sequentialPattern": "Sequential pattern",
  "clusterPattern": "Cluster pattern",

  "dayOfWeek": "Day of week",
  "timeOfDay": "Time of day",
  "peakTime": "Peak time",

  "triggerExposures": "Trigger exposures",
  "followedBy": "Followed by",
  "averageOnset": "Average time to onset",
  "hoursLater": "{hours} hours later",
  "@hoursLater": {"placeholders": {"hours": {"type": "double"}}},

  "flarePrediction": "Flare-up prediction",
  "probabilityOfFlare": "Probability of flare",
  "contributingFactors": "Contributing factors",
  "preventiveAction": "Suggested action",

  "periodPrediction": "Period prediction",
  "ovulationPrediction": "Ovulation prediction",
  "expectedIn": "Expected in {days} days",
  "@expectedIn": {"placeholders": {"days": {"type": "int"}}},

  "dataQualityScore": "Data quality score",
  "trackingCompleteness": "Tracking completeness",
  "featureAvailability": "Feature availability",
  "needsMoreData": "Needs {count} more {type}",
  "@needsMoreData": {"placeholders": {"count": {"type": "int"}, "type": {"type": "String"}}},

  "dismiss": "Dismiss",
  "viewDetails": "View details",
  "viewPattern": "View pattern",
  "viewProgress": "View progress",
  "addToReport": "Add to report",
  "shareWithProvider": "Share with provider",

  "gotIt": "Got it",
  "remindMeLater": "Remind me later",
  "thisDidntHappen": "This didn't happen",
  "thisHappened": "This happened",

  "insufficientData": "Insufficient data",
  "needMoreDataFor": "Need more data for {feature}",
  "@needMoreDataFor": {"placeholders": {"feature": {"type": "String"}}},

  "insightDisclaimer": "These insights are based on your logged data and are not medical advice. Always consult a healthcare provider for diagnosis and treatment decisions.",

  "eliminationTrial": "Elimination trial",
  "startEliminationTrial": "Start elimination trial"
}
```

---

## 13. Testing Strategy

### 13.1 Unit Tests

```dart
group('TemporalPatternDetector', () {
  test('detects significant day-of-week pattern', () async {
    // Arrange: 70% of events on Monday
    final entries = [
      ...List.generate(14, (i) => TimestampedEntry(
        timestamp: DateTime(2026, 1, 6 + i * 7), // Mondays
      )),
      ...List.generate(6, (i) => TimestampedEntry(
        timestamp: DateTime(2026, 1, 8 + i * 7), // Wednesdays
      )),
    ];

    // Act
    final patterns = await detector.detectPatterns(
      entries: entries,
      minConfidence: 0.6,
    );

    // Assert
    expect(patterns, hasLength(1));
    expect(patterns.first.unit, TemporalUnit.dayOfWeek);
    expect(patterns.first.distribution[1], greaterThan(0.6)); // Monday
  });

  test('returns empty when distribution is uniform', () async {
    // Arrange: equal distribution across days
    final entries = List.generate(70, (i) => TimestampedEntry(
      timestamp: DateTime(2026, 1, 1).add(Duration(days: i)),
    ));

    // Act
    final patterns = await detector.detectPatterns(entries: entries);

    // Assert
    expect(patterns, isEmpty);
  });
});

group('TriggerCorrelationEngine', () {
  test('calculates correct relative risk', () async {
    // Arrange: 15/20 dairy days had symptoms, 10/40 non-dairy days
    final correlation = engine.calculateRelativeRisk(
      triggerDays: 20,
      triggerWithOutcome: 15,
      nonTriggerDays: 40,
      nonTriggerWithOutcome: 10,
    );

    // Assert
    // RR = (15/20) / (10/40) = 0.75 / 0.25 = 3.0
    expect(correlation.relativeRisk, closeTo(3.0, 0.01));
    expect(correlation.correlationType, CorrelationType.positive);
  });
});

group('FlarePredictionModel', () {
  test('predicts higher probability with poor sleep', () async {
    // Arrange
    final goodSleepFeatures = {'sleep_quality_last_3_days': 8.0, ...};
    final poorSleepFeatures = {'sleep_quality_last_3_days': 4.0, ...};

    // Act
    final goodSleepPrediction = model.predict(goodSleepFeatures);
    final poorSleepPrediction = model.predict(poorSleepFeatures);

    // Assert
    expect(poorSleepPrediction.probability,
      greaterThan(goodSleepPrediction.probability));
  });
});
```

### 13.2 Integration Tests

```dart
testWidgets('insights dashboard shows high priority first', (tester) async {
  // Arrange
  await tester.pumpWidget(ProviderScope(
    overrides: [
      healthInsightsProvider.overrideWith((ref) => [
        mockLowPriorityInsight,
        mockHighPriorityInsight,
        mockMediumPriorityInsight,
      ]),
    ],
    child: MaterialApp(home: InsightsDashboardScreen()),
  ));

  // Assert
  final cards = tester.widgetList(find.byType(InsightCard));
  expect(cards.first.priority, InsightPriority.high);
});

testWidgets('dismissing insight removes from list', (tester) async {
  // Arrange
  await tester.pumpWidget(/* ... */);

  // Act
  await tester.tap(find.text('Dismiss').first);
  await tester.pumpAndSettle();

  // Assert
  verify(mockRepository.dismiss(any)).called(1);
  expect(find.byType(InsightCard), findsNWidgets(2));
});
```

---

## 14. Acceptance Criteria

### 14.1 Pattern Detection

- [ ] Temporal patterns detected with ≥65% confidence
- [ ] Patterns based on minimum 14 data points
- [ ] Chi-square test confirms statistical significance (p < 0.05)
- [ ] Patterns include day-of-week, time-of-day, and monthly analysis
- [ ] Cyclical patterns detect menstrual cycles with ≥3 cycles of data
- [ ] Sequential patterns identify trigger → outcome relationships

### 14.2 Trigger Correlation

- [ ] Relative risk calculated with 95% confidence intervals
- [ ] P-value < 0.05 for reported correlations
- [ ] Multiple time windows analyzed (6h, 12h, 24h, 48h, 72h)
- [ ] Positive and negative correlations identified
- [ ] Dose-response relationships detected when applicable

### 14.3 Health Insights

- [ ] Daily summary generated at 8 PM local time
- [ ] High-priority insights shown prominently
- [ ] Evidence provided for each insight
- [ ] Actionable recommendations included
- [ ] Dismiss functionality works correctly
- [ ] Insights expire after specified duration

### 14.4 Predictive Alerts

- [ ] Flare predictions generated with ≥60% probability threshold
- [ ] Contributing factors identified and explained
- [ ] Preventive actions suggested
- [ ] Menstrual cycle predictions within ±3 days
- [ ] Ovulation detected via BBT thermal shift
- [ ] Feedback loop captures actual outcomes

### 14.5 Privacy & Performance

- [ ] All processing occurs on-device
- [ ] No health data sent to external servers
- [ ] Pattern detection completes in <5 seconds
- [ ] Correlation analysis completes in <10 seconds
- [ ] ML model inference in <100ms
- [ ] User can disable any intelligence feature

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-31 | Development Team | Initial Phase 3 specification |

---

## Related Documents

- [01_PRODUCT_SPECIFICATIONS.md](01_PRODUCT_SPECIFICATIONS.md) - Product overview
- [04_ARCHITECTURE.md](04_ARCHITECTURE.md) - System architecture
- [10_DATABASE_SCHEMA.md](10_DATABASE_SCHEMA.md) - Database design
- [22_API_CONTRACTS.md](22_API_CONTRACTS.md) - Interface definitions
- [37_NOTIFICATIONS.md](37_NOTIFICATIONS.md) - Notification system
- [40_REPORT_GENERATION.md](40_REPORT_GENERATION.md) - Report specifications
