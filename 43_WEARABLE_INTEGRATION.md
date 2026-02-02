# 43. Wearable & Health Platform Integration Specification

## Document Purpose

This document provides complete specifications for Phase 4 Health Data Integration:
- Apple HealthKit Integration
- Google Fit Integration
- Wearable Device Support (Apple Watch, Fitbit, Garmin, Oura, WHOOP)
- FHIR R4 Data Export

---

## Table of Contents

1. [Overview](#1-overview)
2. [Apple HealthKit Integration](#2-apple-healthkit-integration)
3. [Google Fit Integration](#3-google-fit-integration)
4. [Apple Watch Companion App](#4-apple-watch-companion-app)
5. [Third-Party Wearable APIs](#5-third-party-wearable-apis)
6. [FHIR R4 Data Export](#6-fhir-r4-data-export)
7. [Data Mapping](#7-data-mapping)
8. [Sync Architecture](#8-sync-architecture)
9. [Privacy & Permissions](#9-privacy--permissions)
10. [Database Schema](#10-database-schema)
11. [API Contracts](#11-api-contracts)
12. [UI Specifications](#12-ui-specifications)
13. [Localization](#13-localization)
14. [Testing Strategy](#14-testing-strategy)
15. [Acceptance Criteria](#15-acceptance-criteria)

---

## 1. Overview

### 1.1 Purpose

Shadow integrates with health platforms and wearable devices to:
1. **Import** activity, sleep, and vitals data automatically
2. **Export** Shadow data to health platforms for unified health view
3. **Provide** real-time tracking via companion apps
4. **Enable** data portability through FHIR standard export

### 1.2 Supported Platforms

| Platform | Direction | Method | Availability |
|----------|-----------|--------|--------------|
| Apple HealthKit | Bidirectional | Native API | iOS, watchOS |
| Google Fit | Bidirectional | REST API | Android, iOS |
| Apple Watch | Bidirectional | watchOS App | watchOS 10+ |
| Fitbit | Read-only | Web API | All platforms |
| Garmin | Read-only | Connect API | All platforms |
| Oura Ring | Read-only | Cloud API | All platforms |
| WHOOP | Read-only | Cloud API | All platforms |
| FHIR Export | Export-only | JSON Bundle | All platforms |

### 1.3 Key Principles

| Principle | Description |
|-----------|-------------|
| **User Control** | User explicitly enables each data type and direction |
| **Minimal Access** | Request only necessary permissions |
| **Conflict Resolution** | User data in Shadow takes precedence over imported data |
| **Offline First** | Queue sync operations when offline |
| **Battery Efficient** | Use background fetch judiciously |

---

## 2. Apple HealthKit Integration

### 2.1 Supported Data Types

#### Read from HealthKit

| HealthKit Type | Shadow Entity | Mapping |
|----------------|---------------|---------|
| `HKQuantityTypeIdentifierStepCount` | ActivityLog | steps → activity with type "Walking" |
| `HKQuantityTypeIdentifierHeartRate` | ConditionLog | Heart rate as vital sign |
| `HKQuantityTypeIdentifierRestingHeartRate` | ConditionLog | Resting HR as vital sign |
| `HKQuantityTypeIdentifierHeartRateVariabilitySDNN` | ConditionLog | HRV as vital sign |
| `HKCategoryTypeIdentifierSleepAnalysis` | SleepEntry | Sleep stages → sleep quality |
| `HKQuantityTypeIdentifierBodyMass` | Profile | Weight measurement |
| `HKQuantityTypeIdentifierHeight` | Profile | Height measurement |
| `HKQuantityTypeIdentifierBodyTemperature` | FluidsEntry | BBT reading |
| `HKQuantityTypeIdentifierOxygenSaturation` | ConditionLog | SpO2 as vital sign |
| `HKQuantityTypeIdentifierRespiratoryRate` | ConditionLog | Respiratory rate |
| `HKWorkoutType` | ActivityLog | Workout → activity session |
| `HKQuantityTypeIdentifierActiveEnergyBurned` | ActivityLog | Calories burned |
| `HKQuantityTypeIdentifierDistanceWalkingRunning` | ActivityLog | Distance covered |
| `HKQuantityTypeIdentifierDietaryWater` | FluidsEntry | Water intake |
| `HKCategoryTypeIdentifierMenstrualFlow` | FluidsEntry | Menstruation flow |

#### Write to HealthKit

| Shadow Entity | HealthKit Type | Mapping |
|---------------|----------------|---------|
| Supplement IntakeLog | `HKCorrelationTypeIdentifierFood` | Supplement as dietary supplement |
| FoodLog | `HKCorrelationTypeIdentifierFood` | Meal as nutrition data |
| SleepEntry | `HKCategoryTypeIdentifierSleepAnalysis` | Sleep record |
| ActivityLog | `HKWorkoutType` | Activity as workout |
| FluidsEntry (water) | `HKQuantityTypeIdentifierDietaryWater` | Water intake |
| FluidsEntry (BBT) | `HKQuantityTypeIdentifierBodyTemperature` | Basal body temperature |

### 2.2 HealthKit Service

```dart
class HealthKitService {
  static const List<HKQuantityType> readTypes = [
    HKQuantityType.stepCount,
    HKQuantityType.heartRate,
    HKQuantityType.restingHeartRate,
    HKQuantityType.heartRateVariabilitySDNN,
    HKQuantityType.bodyMass,
    HKQuantityType.height,
    HKQuantityType.basalBodyTemperature,
    HKQuantityType.oxygenSaturation,
    HKQuantityType.respiratoryRate,
    HKQuantityType.activeEnergyBurned,
    HKQuantityType.distanceWalkingRunning,
    HKQuantityType.dietaryWater,
  ];

  static const List<HKCategoryType> readCategoryTypes = [
    HKCategoryType.sleepAnalysis,
    HKCategoryType.menstrualFlow,
  ];

  static const List<HKQuantityType> writeTypes = [
    HKQuantityType.dietaryWater,
    HKQuantityType.basalBodyTemperature,
  ];

  /// Check if HealthKit is available on this device
  Future<bool> isAvailable() async {
    return await HealthKitService.isHealthDataAvailable();
  }

  /// Request authorization for specified data types
  Future<HealthKitAuthResult> requestAuthorization({
    required List<HealthKitDataType> readTypes,
    required List<HealthKitDataType> writeTypes,
  }) async {
    final status = await _healthKit.requestAuthorization(
      toShare: writeTypes.map((t) => t.hkType).toSet(),
      read: readTypes.map((t) => t.hkType).toSet(),
    );

    return HealthKitAuthResult(
      granted: status,
      readPermissions: await _checkReadPermissions(readTypes),
      writePermissions: await _checkWritePermissions(writeTypes),
    );
  }

  /// Fetch data from HealthKit for date range
  Future<List<HealthKitSample>> fetchData({
    required HealthKitDataType type,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final samples = await _healthKit.getHealthData(
      type: type.hkType,
      startDate: startDate,
      endDate: endDate,
    );

    return samples.map((s) => HealthKitSample.fromHK(s, type)).toList();
  }

  /// Write data to HealthKit
  Future<bool> writeData(HealthKitSample sample) async {
    return await _healthKit.writeHealthData(
      value: sample.value,
      type: sample.type.hkType,
      startTime: sample.startDate,
      endTime: sample.endDate,
    );
  }

  /// Set up background delivery for data type
  Future<void> enableBackgroundDelivery({
    required HealthKitDataType type,
    required HKUpdateFrequency frequency,
  }) async {
    await _healthKit.enableBackgroundDelivery(
      type: type.hkType,
      frequency: frequency,
    );
  }
}
```

### 2.3 Background Sync

```dart
class HealthKitBackgroundSync {
  /// Called by iOS when new HealthKit data is available
  Future<void> handleBackgroundDelivery(Set<HKQuantityType> types) async {
    for (final type in types) {
      final lastSync = await _getLastSyncTime(type);
      final samples = await _healthKitService.fetchData(
        type: HealthKitDataType.fromHK(type),
        startDate: lastSync ?? DateTime.now().subtract(Duration(days: 7)),
        endDate: DateTime.now(),
      );

      for (final sample in samples) {
        await _importSample(sample);
      }

      await _setLastSyncTime(type, DateTime.now());
    }
  }

  Future<void> _importSample(HealthKitSample sample) async {
    // Check for duplicates (same source and timestamp)
    final existing = await _findExistingEntry(sample);
    if (existing != null) {
      return; // Already imported
    }

    // Map to Shadow entity
    final entity = _mapToShadowEntity(sample);

    // Mark as imported from HealthKit
    entity.metadata['source'] = 'healthkit';
    entity.metadata['hk_uuid'] = sample.uuid;

    await _repository.create(entity);
  }
}
```

### 2.4 Info.plist Configuration

```xml
<!-- HealthKit capability -->
<key>UIRequiredDeviceCapabilities</key>
<array>
  <string>healthkit</string>
</array>

<!-- HealthKit entitlement -->
<key>com.apple.developer.healthkit</key>
<true/>

<key>com.apple.developer.healthkit.access</key>
<array>
  <string>health-records</string>
</array>

<!-- HealthKit usage descriptions -->
<key>NSHealthShareUsageDescription</key>
<string>Shadow reads your health data to provide insights about how your activities, sleep, and vitals relate to your health conditions.</string>

<key>NSHealthUpdateUsageDescription</key>
<string>Shadow writes your supplement intake, meals, and sleep data to Apple Health so you have a complete health picture in one place.</string>

<!-- Background modes -->
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>processing</string>
</array>
```

---

## 3. Google Fit Integration

### 3.1 Supported Data Types

#### Read from Google Fit

| Google Fit Data Type | Shadow Entity | Mapping |
|---------------------|---------------|---------|
| `com.google.step_count.delta` | ActivityLog | Steps as walking activity |
| `com.google.heart_rate.bpm` | ConditionLog | Heart rate vital |
| `com.google.sleep.segment` | SleepEntry | Sleep stages |
| `com.google.weight` | Profile | Body weight |
| `com.google.height` | Profile | Height |
| `com.google.body.temperature` | FluidsEntry | Body temperature |
| `com.google.oxygen_saturation` | ConditionLog | SpO2 vital |
| `com.google.activity.segment` | ActivityLog | Activity session |
| `com.google.calories.expended` | ActivityLog | Calories burned |
| `com.google.distance.delta` | ActivityLog | Distance |
| `com.google.hydration` | FluidsEntry | Water intake |
| `com.google.menstruation` | FluidsEntry | Menstruation |

#### Write to Google Fit

| Shadow Entity | Google Fit Data Type |
|---------------|---------------------|
| Supplement IntakeLog | `com.google.nutrition` |
| FoodLog | `com.google.nutrition` |
| SleepEntry | `com.google.sleep.segment` |
| ActivityLog | `com.google.activity.segment` |
| FluidsEntry (water) | `com.google.hydration` |

### 3.2 OAuth Configuration

```dart
class GoogleFitConfig {
  static const String clientId = 'YOUR_CLIENT_ID.apps.googleusercontent.com';

  static const List<String> scopes = [
    'https://www.googleapis.com/auth/fitness.activity.read',
    'https://www.googleapis.com/auth/fitness.activity.write',
    'https://www.googleapis.com/auth/fitness.body.read',
    'https://www.googleapis.com/auth/fitness.body.write',
    'https://www.googleapis.com/auth/fitness.sleep.read',
    'https://www.googleapis.com/auth/fitness.sleep.write',
    'https://www.googleapis.com/auth/fitness.heart_rate.read',
    'https://www.googleapis.com/auth/fitness.nutrition.read',
    'https://www.googleapis.com/auth/fitness.nutrition.write',
    'https://www.googleapis.com/auth/fitness.reproductive_health.read',
  ];
}
```

### 3.3 Google Fit Service

```dart
class GoogleFitService {
  final Dio _dio;
  final TokenManager _tokenManager;

  static const String baseUrl = 'https://www.googleapis.com/fitness/v1/users/me';

  /// Fetch data sources for a data type
  Future<List<DataSource>> getDataSources(String dataTypeName) async {
    final response = await _dio.get(
      '$baseUrl/dataSources',
      queryParameters: {'dataTypeName': dataTypeName},
      options: await _authOptions(),
    );

    return (response.data['dataSource'] as List)
        .map((d) => DataSource.fromJson(d))
        .toList();
  }

  /// Fetch data points for date range
  Future<List<DataPoint>> fetchData({
    required String dataSourceId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final startNanos = startTime.microsecondsSinceEpoch * 1000;
    final endNanos = endTime.microsecondsSinceEpoch * 1000;

    final response = await _dio.get(
      '$baseUrl/dataSources/$dataSourceId/datasets/$startNanos-$endNanos',
      options: await _authOptions(),
    );

    return (response.data['point'] as List? ?? [])
        .map((p) => DataPoint.fromJson(p))
        .toList();
  }

  /// Write data to Google Fit
  Future<void> writeData({
    required String dataSourceId,
    required List<DataPoint> points,
  }) async {
    final minTime = points.map((p) => p.startTimeNanos).reduce(min);
    final maxTime = points.map((p) => p.endTimeNanos).reduce(max);

    await _dio.patch(
      '$baseUrl/dataSources/$dataSourceId/datasets/$minTime-$maxTime',
      data: {
        'dataSourceId': dataSourceId,
        'minStartTimeNs': minTime,
        'maxEndTimeNs': maxTime,
        'point': points.map((p) => p.toJson()).toList(),
      },
      options: await _authOptions(),
    );
  }

  /// Aggregate data for period
  Future<AggregateResponse> aggregate({
    required List<String> dataTypeNames,
    required DateTime startTime,
    required DateTime endTime,
    required Duration bucketDuration,
  }) async {
    final response = await _dio.post(
      '$baseUrl/dataset:aggregate',
      data: {
        'aggregateBy': dataTypeNames.map((name) => {
          'dataTypeName': name,
        }).toList(),
        'bucketByTime': {
          'durationMillis': bucketDuration.inMilliseconds,
        },
        'startTimeMillis': startTime.millisecondsSinceEpoch,
        'endTimeMillis': endTime.millisecondsSinceEpoch,
      },
      options: await _authOptions(),
    );

    return AggregateResponse.fromJson(response.data);
  }

  Options _authOptions() async {
    final token = await _tokenManager.getValidToken();
    return Options(
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
```

---

## 4. Apple Watch Companion App

### 4.1 Features

| Feature | Description | Complexity |
|---------|-------------|------------|
| **Quick Log** | Log supplement intake with one tap | Low |
| **Condition Check** | Rate current symptom severity | Medium |
| **Water Tracking** | Add water intake | Low |
| **Complication** | Show today's supplement status | Medium |
| **Notifications** | Receive and respond to reminders | Low |
| **Heart Rate** | Capture current HR to condition log | Medium |
| **Sleep Sync** | Automatic sleep data from watch | Auto |

### 4.2 WatchKit Extension Structure

```
shadow_watch/
├── ShadowWatchApp.swift
├── ContentView.swift
├── Views/
│   ├── QuickLogView.swift
│   ├── SupplementListView.swift
│   ├── ConditionCheckView.swift
│   ├── WaterIntakeView.swift
│   └── SettingsView.swift
├── Complications/
│   ├── SupplementComplication.swift
│   └── WaterComplication.swift
├── Models/
│   ├── WatchSupplement.swift
│   └── WatchCondition.swift
├── Services/
│   ├── WatchConnectivityService.swift
│   ├── HealthKitWatchService.swift
│   └── NotificationService.swift
└── Extensions/
    └── Date+Extensions.swift
```

### 4.3 Watch Connectivity

```swift
class WatchConnectivityService: NSObject, WCSessionDelegate {
    static let shared = WatchConnectivityService()

    private var session: WCSession?

    func activate() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    // MARK: - Send to Phone

    func sendSupplementLog(_ log: SupplementIntakeLog) {
        guard let session = session, session.isReachable else {
            // Queue for later sync
            queueMessage(["type": "supplement_log", "data": log.toDict()])
            return
        }

        session.sendMessage(
            ["type": "supplement_log", "data": log.toDict()],
            replyHandler: { reply in
                // Log confirmed
            },
            errorHandler: { error in
                // Queue for retry
            }
        )
    }

    func sendConditionLog(_ log: ConditionLog) {
        // Similar implementation
    }

    func sendWaterIntake(_ amount: Int) {
        // Similar implementation
    }

    // MARK: - Receive from Phone

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        switch message["type"] as? String {
        case "supplements_update":
            // Update local supplement list
            let supplements = (message["data"] as? [[String: Any]])?.compactMap {
                WatchSupplement.fromDict($0)
            } ?? []
            SupplementStore.shared.update(supplements)

        case "conditions_update":
            // Update local conditions list
            let conditions = (message["data"] as? [[String: Any]])?.compactMap {
                WatchCondition.fromDict($0)
            } ?? []
            ConditionStore.shared.update(conditions)

        case "notification":
            // Handle notification action
            break

        default:
            break
        }
    }

    // MARK: - Background Transfer

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        // Handle background context updates
        if let supplements = applicationContext["supplements"] as? [[String: Any]] {
            SupplementStore.shared.update(supplements.compactMap { WatchSupplement.fromDict($0) })
        }
    }
}
```

### 4.4 Watch UI - Quick Log

```swift
struct QuickLogView: View {
    @StateObject private var store = SupplementStore.shared
    @State private var showingConfirmation = false
    @State private var loggedSupplement: WatchSupplement?

    var body: some View {
        NavigationView {
            List {
                Section("Due Now") {
                    ForEach(store.dueSupplements) { supplement in
                        Button(action: {
                            logSupplement(supplement)
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(supplement.name)
                                        .font(.headline)
                                    Text(supplement.dosage)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }

                Section("Upcoming") {
                    ForEach(store.upcomingSupplements) { supplement in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(supplement.name)
                                    .font(.headline)
                                Text("Due at \(supplement.nextDueTime, style: .time)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .opacity(0.6)
                    }
                }
            }
            .navigationTitle("Supplements")
        }
        .sheet(isPresented: $showingConfirmation) {
            if let supplement = loggedSupplement {
                ConfirmationView(supplement: supplement)
            }
        }
    }

    private func logSupplement(_ supplement: WatchSupplement) {
        let log = SupplementIntakeLog(
            supplementId: supplement.id,
            timestamp: Date(),
            status: .taken
        )

        WatchConnectivityService.shared.sendSupplementLog(log)

        loggedSupplement = supplement
        showingConfirmation = true

        WKInterfaceDevice.current().play(.success)
    }
}
```

### 4.5 Complication

```swift
struct SupplementComplication: Widget {
    let kind: String = "SupplementComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SupplementTimelineProvider()) { entry in
            SupplementComplicationView(entry: entry)
        }
        .configurationDisplayName("Supplements")
        .description("Shows supplement status for today")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline,
            .accessoryCorner,
        ])
    }
}

struct SupplementComplicationView: View {
    var entry: SupplementEntry

    var body: some View {
        switch entry.family {
        case .accessoryCircular:
            Gauge(value: entry.completionRate) {
                Image(systemName: "pill.fill")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(entry.completionRate == 1.0 ? .green : .orange)

        case .accessoryRectangular:
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "pill.fill")
                    Text("Supplements")
                        .font(.headline)
                }
                Text("\(entry.taken)/\(entry.total) taken")
                    .font(.caption)
                if let next = entry.nextDue {
                    Text("Next: \(next.name) at \(next.time, style: .time)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

        case .accessoryInline:
            Text("💊 \(entry.taken)/\(entry.total)")

        default:
            EmptyView()
        }
    }
}
```

---

## 5. Third-Party Wearable APIs

### 5.1 Fitbit Integration

```dart
class FitbitService {
  static const String authUrl = 'https://www.fitbit.com/oauth2/authorize';
  static const String tokenUrl = 'https://api.fitbit.com/oauth2/token';
  static const String apiUrl = 'https://api.fitbit.com/1/user/-';

  static const List<String> scopes = [
    'activity',
    'heartrate',
    'sleep',
    'weight',
    'profile',
  ];

  /// Fetch daily activity summary
  Future<FitbitActivitySummary> getActivitySummary(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final response = await _get('/activities/date/$dateStr.json');
    return FitbitActivitySummary.fromJson(response['summary']);
  }

  /// Fetch heart rate data for date
  Future<List<FitbitHeartRate>> getHeartRate(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final response = await _get('/activities/heart/date/$dateStr/1d/1min.json');
    return (response['activities-heart-intraday']['dataset'] as List)
        .map((d) => FitbitHeartRate.fromJson(d, date))
        .toList();
  }

  /// Fetch sleep data for date range
  Future<List<FitbitSleep>> getSleep(DateTime startDate, DateTime endDate) async {
    final start = DateFormat('yyyy-MM-dd').format(startDate);
    final end = DateFormat('yyyy-MM-dd').format(endDate);
    final response = await _get('/sleep/date/$start/$end.json');
    return (response['sleep'] as List)
        .map((s) => FitbitSleep.fromJson(s))
        .toList();
  }

  /// Fetch weight logs
  Future<List<FitbitWeight>> getWeight(DateTime startDate, DateTime endDate) async {
    final start = DateFormat('yyyy-MM-dd').format(startDate);
    final end = DateFormat('yyyy-MM-dd').format(endDate);
    final response = await _get('/body/log/weight/date/$start/$end.json');
    return (response['weight'] as List)
        .map((w) => FitbitWeight.fromJson(w))
        .toList();
  }
}
```

### 5.2 Garmin Integration

```dart
class GarminService {
  static const String authUrl = 'https://connect.garmin.com/oauthConfirm';
  static const String apiUrl = 'https://apis.garmin.com/wellness-api/rest';

  /// Fetch daily summaries
  Future<List<GarminDailySummary>> getDailySummaries({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _get('/dailies', params: {
      'uploadStartTimeInSeconds': startDate.secondsSinceEpoch,
      'uploadEndTimeInSeconds': endDate.secondsSinceEpoch,
    });
    return (response as List)
        .map((d) => GarminDailySummary.fromJson(d))
        .toList();
  }

  /// Fetch sleep data
  Future<List<GarminSleep>> getSleepData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _get('/sleeps', params: {
      'uploadStartTimeInSeconds': startDate.secondsSinceEpoch,
      'uploadEndTimeInSeconds': endDate.secondsSinceEpoch,
    });
    return (response as List)
        .map((s) => GarminSleep.fromJson(s))
        .toList();
  }

  /// Fetch activities
  Future<List<GarminActivity>> getActivities({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _get('/activities', params: {
      'uploadStartTimeInSeconds': startDate.secondsSinceEpoch,
      'uploadEndTimeInSeconds': endDate.secondsSinceEpoch,
    });
    return (response as List)
        .map((a) => GarminActivity.fromJson(a))
        .toList();
  }
}
```

### 5.3 Oura Ring Integration

```dart
class OuraService {
  static const String authUrl = 'https://cloud.ouraring.com/oauth/authorize';
  static const String apiUrl = 'https://api.ouraring.com/v2/usercollection';

  /// Fetch daily sleep data
  Future<List<OuraSleep>> getSleep({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _get('/daily_sleep', params: {
      'start_date': DateFormat('yyyy-MM-dd').format(startDate),
      'end_date': DateFormat('yyyy-MM-dd').format(endDate),
    });
    return (response['data'] as List)
        .map((s) => OuraSleep.fromJson(s))
        .toList();
  }

  /// Fetch daily readiness scores
  Future<List<OuraReadiness>> getReadiness({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _get('/daily_readiness', params: {
      'start_date': DateFormat('yyyy-MM-dd').format(startDate),
      'end_date': DateFormat('yyyy-MM-dd').format(endDate),
    });
    return (response['data'] as List)
        .map((r) => OuraReadiness.fromJson(r))
        .toList();
  }

  /// Fetch heart rate data
  Future<List<OuraHeartRate>> getHeartRate({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _get('/heartrate', params: {
      'start_datetime': startDate.toIso8601String(),
      'end_datetime': endDate.toIso8601String(),
    });
    return (response['data'] as List)
        .map((h) => OuraHeartRate.fromJson(h))
        .toList();
  }
}
```

### 5.4 WHOOP Integration

```dart
class WhoopService {
  static const String authUrl = 'https://api.prod.whoop.com/oauth/oauth2/auth';
  static const String apiUrl = 'https://api.prod.whoop.com/developer/v1';

  /// Fetch recovery data
  Future<List<WhoopRecovery>> getRecovery({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _get('/recovery', params: {
      'start': startDate.toIso8601String(),
      'end': endDate.toIso8601String(),
    });
    return (response['records'] as List)
        .map((r) => WhoopRecovery.fromJson(r))
        .toList();
  }

  /// Fetch sleep data
  Future<List<WhoopSleep>> getSleep({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _get('/activity/sleep', params: {
      'start': startDate.toIso8601String(),
      'end': endDate.toIso8601String(),
    });
    return (response['records'] as List)
        .map((s) => WhoopSleep.fromJson(s))
        .toList();
  }

  /// Fetch strain (workout) data
  Future<List<WhoopStrain>> getStrain({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _get('/cycle', params: {
      'start': startDate.toIso8601String(),
      'end': endDate.toIso8601String(),
    });
    return (response['records'] as List)
        .map((c) => WhoopStrain.fromJson(c))
        .toList();
  }
}
```

---

## 6. FHIR R4 Data Export

### 6.1 Supported FHIR Resources

| Shadow Entity | FHIR Resource | Notes |
|---------------|---------------|-------|
| Profile | Patient | Demographics, identifiers |
| Condition | Condition | Health conditions with SNOMED codes |
| ConditionLog | Observation | Symptom severity observations |
| Supplement | MedicationStatement | Supplement as medication |
| IntakeLog | MedicationAdministration | Supplement intake events |
| FoodItem | NutritionOrder | Food definitions |
| FoodLog | NutritionIntake | Meal records |
| SleepEntry | Observation | Sleep observations |
| ActivityLog | Observation | Activity observations |
| FluidsEntry | Observation | Vitals (BBT, HR) |

### 6.2 FHIR Bundle Export

```dart
class FhirExportService {
  /// Export profile data as FHIR Bundle
  Future<FhirBundle> exportProfile({
    required String profileId,
    required DateTime startDate,
    required DateTime endDate,
    required List<FhirResourceType> resourceTypes,
  }) async {
    final bundle = FhirBundle(
      type: BundleType.collection,
      timestamp: DateTime.now(),
      entry: [],
    );

    // Patient resource
    if (resourceTypes.contains(FhirResourceType.patient)) {
      final profile = await _profileRepository.getById(profileId);
      bundle.entry.add(BundleEntry(
        resource: _mapProfileToPatient(profile),
      ));
    }

    // Conditions
    if (resourceTypes.contains(FhirResourceType.condition)) {
      final conditions = await _conditionRepository.getByProfile(profileId);
      for (final condition in conditions) {
        bundle.entry.add(BundleEntry(
          resource: _mapConditionToFhir(condition),
        ));
      }
    }

    // Observations (condition logs, vitals, sleep, activities)
    if (resourceTypes.contains(FhirResourceType.observation)) {
      final conditionLogs = await _conditionLogRepository.getByDateRange(
        profileId: profileId,
        startDate: startDate,
        endDate: endDate,
      );
      for (final log in conditionLogs) {
        bundle.entry.add(BundleEntry(
          resource: _mapConditionLogToObservation(log),
        ));
      }

      // Add sleep, activity, fluids as observations...
    }

    // MedicationStatements (supplements)
    if (resourceTypes.contains(FhirResourceType.medicationStatement)) {
      final supplements = await _supplementRepository.getByProfile(profileId);
      for (final supplement in supplements) {
        bundle.entry.add(BundleEntry(
          resource: _mapSupplementToMedicationStatement(supplement),
        ));
      }
    }

    // MedicationAdministrations (intake logs)
    if (resourceTypes.contains(FhirResourceType.medicationAdministration)) {
      final intakeLogs = await _intakeLogRepository.getByDateRange(
        profileId: profileId,
        startDate: startDate,
        endDate: endDate,
      );
      for (final log in intakeLogs) {
        bundle.entry.add(BundleEntry(
          resource: _mapIntakeLogToMedicationAdministration(log),
        ));
      }
    }

    return bundle;
  }

  /// Map Shadow Condition to FHIR Condition
  FhirCondition _mapConditionToFhir(Condition condition) {
    return FhirCondition(
      resourceType: 'Condition',
      id: condition.id,
      clinicalStatus: CodeableConcept(
        coding: [
          Coding(
            system: 'http://terminology.hl7.org/CodeSystem/condition-clinical',
            code: condition.isActive ? 'active' : 'inactive',
          ),
        ],
      ),
      code: CodeableConcept(
        coding: condition.snomedCode != null ? [
          Coding(
            system: 'http://snomed.info/sct',
            code: condition.snomedCode,
            display: condition.name,
          ),
        ] : [],
        text: condition.name,
      ),
      onsetDateTime: condition.onsetDate?.toIso8601String(),
      recordedDate: condition.syncMetadata.createdAt.toIso8601String(),
      note: condition.notes != null ? [
        Annotation(text: condition.notes),
      ] : null,
    );
  }

  /// Map ConditionLog to FHIR Observation
  FhirObservation _mapConditionLogToObservation(ConditionLog log) {
    return FhirObservation(
      resourceType: 'Observation',
      id: log.id,
      status: 'final',
      category: [
        CodeableConcept(
          coding: [
            Coding(
              system: 'http://terminology.hl7.org/CodeSystem/observation-category',
              code: 'survey',
              display: 'Survey',
            ),
          ],
        ),
      ],
      code: CodeableConcept(
        coding: [
          Coding(
            system: 'http://loinc.org',
            code: '75325-1',
            display: 'Symptom severity',
          ),
        ],
        text: 'Symptom severity score',
      ),
      effectiveDateTime: log.timestamp.toIso8601String(),
      valueInteger: log.severity,
      note: log.notes != null ? [
        Annotation(text: log.notes),
      ] : null,
    );
  }
}
```

### 6.3 FHIR Export UI

```
┌─────────────────────────────────────────────────────────────────────┐
│ ←  Export Health Data                                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Export your health data in FHIR R4 format for use with            │
│  healthcare systems, research studies, or personal records.        │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  DATE RANGE                                                  │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │  From: [January 1, 2026        ▼]                           │   │
│  │  To:   [January 31, 2026       ▼]                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  DATA TO INCLUDE                                             │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │  ☑ Profile information (Patient)                            │   │
│  │  ☑ Health conditions (Condition)                            │   │
│  │  ☑ Symptom logs (Observation)                               │   │
│  │  ☑ Supplements (MedicationStatement)                        │   │
│  │  ☑ Supplement intake (MedicationAdministration)             │   │
│  │  ☑ Food logs (NutritionIntake)                              │   │
│  │  ☑ Sleep data (Observation)                                 │   │
│  │  ☑ Activity data (Observation)                              │   │
│  │  ☑ Vitals - BBT, etc. (Observation)                        │   │
│  │  ☐ Photos (DocumentReference) - Large file size            │   │
│  │  ☑ Journal entries (DocumentReference)                      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  EXPORT FORMAT                                               │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │  ○ FHIR JSON Bundle (.json)                                 │   │
│  │  ○ FHIR XML Bundle (.xml)                                   │   │
│  │  ○ FHIR NDJSON (Bulk Data)                                  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Estimated size: 2.4 MB                                            │
│                                                                     │
│                    [Export to Files]                                │
│                    [Share...]                                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 7. Data Mapping

### 7.1 Sleep Stage Mapping

| Source | Deep | Light | REM | Awake |
|--------|------|-------|-----|-------|
| Apple HealthKit | asleepDeep | asleepCore | asleepREM | awake |
| Google Fit | 5 | 4 | 6 | 1 |
| Fitbit | deep | light | rem | wake |
| Garmin | deepSleepSeconds | lightSleepSeconds | remSleepSeconds | awakeSleepSeconds |
| Oura | deep | light | rem | awake |
| WHOOP | slow_wave_sleep_time | light_sleep_time | rem_sleep_time | wake_time |
| Shadow | SleepStage.deep | SleepStage.light | SleepStage.rem | SleepStage.awake |

### 7.2 Activity Type Mapping

| Source Activity | Shadow Activity Type |
|-----------------|---------------------|
| Walking / Steps | Walking |
| Running | Running |
| Cycling | Cycling |
| Swimming | Swimming |
| Yoga | Yoga |
| Strength Training | Strength Training |
| HIIT | High Intensity |
| Other / Unknown | General Activity |

### 7.3 Sleep Quality Calculation

When importing sleep from wearables, calculate Shadow's 1-10 sleep quality:

```dart
int calculateSleepQuality(ImportedSleep sleep) {
  double score = 5.0; // Baseline

  // Duration factor (7-9 hours optimal)
  final hours = sleep.duration.inMinutes / 60.0;
  if (hours >= 7 && hours <= 9) {
    score += 2.0;
  } else if (hours >= 6 && hours < 7) {
    score += 1.0;
  } else if (hours < 6) {
    score -= 1.5;
  } else if (hours > 9) {
    score += 0.5;
  }

  // Sleep efficiency factor
  final efficiency = sleep.timeAsleep / sleep.timeInBed;
  if (efficiency >= 0.85) {
    score += 1.5;
  } else if (efficiency >= 0.75) {
    score += 0.5;
  } else {
    score -= 1.0;
  }

  // Deep sleep factor (15-25% optimal)
  final deepPercent = sleep.deepMinutes / sleep.duration.inMinutes;
  if (deepPercent >= 0.15 && deepPercent <= 0.25) {
    score += 1.0;
  } else if (deepPercent < 0.10) {
    score -= 1.0;
  }

  // REM factor (20-25% optimal)
  final remPercent = sleep.remMinutes / sleep.duration.inMinutes;
  if (remPercent >= 0.20 && remPercent <= 0.25) {
    score += 0.5;
  } else if (remPercent < 0.15) {
    score -= 0.5;
  }

  return score.clamp(1, 10).round();
}
```

---

## 8. Sync Architecture

### 8.1 Sync Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    WEARABLE SYNC ARCHITECTURE                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────┐    ┌──────────────────┐                      │
│  │   Apple Watch    │    │   Fitbit/Garmin  │                      │
│  │   (Companion)    │    │   (Cloud API)    │                      │
│  └────────┬─────────┘    └────────┬─────────┘                      │
│           │                       │                                 │
│           ▼                       ▼                                 │
│  ┌──────────────────┐    ┌──────────────────┐                      │
│  │  WatchKit Ext    │    │  API Service     │                      │
│  │  WCSession       │    │  OAuth + REST    │                      │
│  └────────┬─────────┘    └────────┬─────────┘                      │
│           │                       │                                 │
│           └───────────┬───────────┘                                │
│                       │                                             │
│                       ▼                                             │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                  IMPORT COORDINATOR                          │   │
│  │  ─────────────────────────────────────────────────────────  │   │
│  │  • Deduplicate by source + timestamp                        │   │
│  │  • Map to Shadow entities                                    │   │
│  │  • Mark source metadata                                      │   │
│  │  • Queue for local storage                                   │   │
│  └────────────────────────────┬────────────────────────────────┘   │
│                               │                                     │
│                               ▼                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                  LOCAL DATABASE                              │   │
│  │  ─────────────────────────────────────────────────────────  │   │
│  │  • activity_logs (with source='fitbit')                     │   │
│  │  • sleep_entries (with source='apple_watch')                │   │
│  │  • condition_logs (with source='oura')                      │   │
│  └────────────────────────────┬────────────────────────────────┘   │
│                               │                                     │
│                               ▼                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                  EXPORT COORDINATOR                          │   │
│  │  ─────────────────────────────────────────────────────────  │   │
│  │  • Filter Shadow-originated data only                       │   │
│  │  • Map to platform format                                    │   │
│  │  • Write to HealthKit/Google Fit                            │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.2 Duplicate Prevention

```dart
class ImportDeduplicator {
  /// Check if data point already exists
  Future<bool> isDuplicate(ImportedDataPoint point) async {
    // Strategy 1: Check by external ID
    if (point.externalId != null) {
      final existing = await _findByExternalId(
        source: point.source,
        externalId: point.externalId!,
      );
      if (existing != null) return true;
    }

    // Strategy 2: Check by timestamp and type (within 5 minute window)
    final window = Duration(minutes: 5);
    final existing = await _findByTimestampWindow(
      entityType: point.entityType,
      timestamp: point.timestamp,
      window: window,
    );

    if (existing != null) {
      // Check if values are similar enough to be duplicate
      return _valuesAreSimilar(existing, point);
    }

    return false;
  }

  bool _valuesAreSimilar(ShadowEntity existing, ImportedDataPoint point) {
    switch (point.entityType) {
      case 'sleep':
        // Same if duration within 15 minutes
        final existingSleep = existing as SleepEntry;
        final importedDuration = point.data['duration'] as Duration;
        return (existingSleep.duration - importedDuration).abs() < Duration(minutes: 15);

      case 'activity':
        // Same if steps within 10%
        final existingActivity = existing as ActivityLog;
        final importedSteps = point.data['steps'] as int;
        return (existingActivity.steps - importedSteps).abs() < (existingActivity.steps * 0.1);

      default:
        return false;
    }
  }
}
```

### 8.3 Sync Scheduling

| Platform | Sync Method | Frequency |
|----------|-------------|-----------|
| Apple HealthKit | Background Delivery | Real-time (when available) |
| Apple Watch | WCSession | Immediate (when reachable) |
| Google Fit | REST API polling | Every 15 minutes (background fetch) |
| Fitbit | REST API polling | Every hour |
| Garmin | REST API polling | Every hour |
| Oura | REST API polling | Every 6 hours |
| WHOOP | REST API polling | Every 6 hours |

---

## 9. Privacy & Permissions

### 9.1 Permission Model

```dart
class WearablePermissions {
  /// User-controlled permissions for each platform
  final Map<WearablePlatform, PlatformPermissions> permissions;

  /// Check if specific data type is enabled for reading
  bool canRead(WearablePlatform platform, DataType type) {
    return permissions[platform]?.readPermissions.contains(type) ?? false;
  }

  /// Check if specific data type is enabled for writing
  bool canWrite(WearablePlatform platform, DataType type) {
    return permissions[platform]?.writePermissions.contains(type) ?? false;
  }
}

class PlatformPermissions {
  final bool isConnected;
  final DateTime? connectedAt;
  final Set<DataType> readPermissions;
  final Set<DataType> writePermissions;
  final bool backgroundSyncEnabled;
  final DateTime? lastSyncAt;
}

enum DataType {
  steps,
  heartRate,
  sleep,
  weight,
  temperature,
  bloodOxygen,
  activities,
  nutrition,
  water,
  menstruation,
}
```

### 9.2 Permission Request UI

```
┌─────────────────────────────────────────────────────────────────────┐
│ ←  Connect Apple Health                                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Shadow would like to access your health data to provide           │
│  insights about how your activities and sleep affect your          │
│  health conditions.                                                 │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  READ FROM APPLE HEALTH                                      │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │  ☑ Steps and Distance                                       │   │
│  │  ☑ Heart Rate                                               │   │
│  │  ☑ Sleep Analysis                                           │   │
│  │  ☑ Workouts                                                 │   │
│  │  ☑ Body Measurements (weight, height)                       │   │
│  │  ☑ Body Temperature                                         │   │
│  │  ☐ Menstrual Cycle (optional)                               │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  WRITE TO APPLE HEALTH                                       │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │  ☑ Water Intake                                             │   │
│  │  ☑ Sleep Records                                            │   │
│  │  ☐ Supplement Intake (as dietary supplements)               │   │
│  │  ☐ Meals (as nutrition data)                                │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  ☑ Enable background sync                                   │   │
│  │     Automatically sync new data when available              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  You can change these settings at any time in the app.             │
│                                                                     │
│                    [Continue to Apple Health]                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 9.3 Data Retention

| Data Type | Retention in Shadow | Notes |
|-----------|---------------------|-------|
| Imported data | User-controlled | Can delete imported data without affecting source |
| Exported data | N/A | Written to platform, managed by platform |
| OAuth tokens | Until disconnected | Stored in secure keychain |
| Sync metadata | 90 days | For deduplication |

---

## 10. Database Schema

### 10.1 New Tables

```sql
-- Wearable platform connections
CREATE TABLE wearable_connections (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  platform TEXT NOT NULL,              -- 'healthkit', 'googlefit', 'fitbit', etc.
  is_connected INTEGER NOT NULL DEFAULT 0,
  connected_at INTEGER,
  disconnected_at INTEGER,
  read_permissions TEXT,               -- JSON array of DataType
  write_permissions TEXT,              -- JSON array of DataType
  background_sync_enabled INTEGER NOT NULL DEFAULT 1,
  last_sync_at INTEGER,
  last_sync_status TEXT,               -- 'success', 'partial', 'failed'
  oauth_refresh_token TEXT,            -- Encrypted, for cloud APIs only

  -- Sync metadata
  sync_id TEXT NOT NULL,
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER,
  sync_deleted_at INTEGER,
  sync_last_synced_at INTEGER,
  sync_status INTEGER DEFAULT 0,
  sync_version INTEGER DEFAULT 1,
  sync_device_id TEXT,
  sync_is_dirty INTEGER DEFAULT 1,
  conflict_data TEXT,

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX idx_wearable_connections_unique ON wearable_connections(profile_id, platform);
CREATE INDEX idx_wearable_connections_profile ON wearable_connections(profile_id, is_connected);

-- Imported data tracking (for deduplication)
CREATE TABLE imported_data_log (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  platform TEXT NOT NULL,
  external_id TEXT,                    -- ID from source platform
  entity_type TEXT NOT NULL,           -- 'sleep', 'activity', 'heart_rate', etc.
  entity_id TEXT NOT NULL,             -- Shadow entity ID
  imported_at INTEGER NOT NULL,
  data_timestamp INTEGER NOT NULL,     -- Original data timestamp

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE INDEX idx_imported_data_external ON imported_data_log(platform, external_id);
CREATE INDEX idx_imported_data_entity ON imported_data_log(entity_type, entity_id);
CREATE INDEX idx_imported_data_timestamp ON imported_data_log(profile_id, data_timestamp);

-- FHIR export history
CREATE TABLE fhir_exports (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  exported_at INTEGER NOT NULL,
  start_date INTEGER NOT NULL,
  end_date INTEGER NOT NULL,
  resource_types TEXT NOT NULL,        -- JSON array
  format TEXT NOT NULL,                -- 'json', 'xml', 'ndjson'
  file_size_bytes INTEGER,
  resource_count INTEGER,
  export_path TEXT,                    -- Temporary file path

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE INDEX idx_fhir_exports_profile ON fhir_exports(profile_id, exported_at DESC);
```

### 10.2 Entity Source Tracking

Add `import_source` and `import_id` columns to all importable entities:

```sql
-- Add to activity_logs, sleep_entries, condition_logs (for vitals)
ALTER TABLE activity_logs ADD COLUMN import_source TEXT;
ALTER TABLE activity_logs ADD COLUMN import_external_id TEXT;

ALTER TABLE sleep_entries ADD COLUMN import_source TEXT;
ALTER TABLE sleep_entries ADD COLUMN import_external_id TEXT;

-- Index for finding imported data
CREATE INDEX idx_activity_import ON activity_logs(import_source, import_external_id)
  WHERE import_source IS NOT NULL;
CREATE INDEX idx_sleep_import ON sleep_entries(import_source, import_external_id)
  WHERE import_source IS NOT NULL;
```

---

## 11. API Contracts

### 11.1 Wearable Service Contract

```dart
abstract class WearableService {
  /// Check if platform is available on this device
  Future<bool> isAvailable();

  /// Request authorization
  Future<AuthorizationResult> requestAuthorization(AuthorizationRequest request);

  /// Check current authorization status
  Future<AuthorizationStatus> getAuthorizationStatus();

  /// Fetch data from platform
  Future<Result<List<ImportedData>, WearableError>> fetchData({
    required DataType dataType,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Write data to platform
  Future<Result<void, WearableError>> writeData(ExportData data);

  /// Enable background sync
  Future<void> enableBackgroundSync(Set<DataType> dataTypes);

  /// Disable background sync
  Future<void> disableBackgroundSync();

  /// Disconnect from platform
  Future<void> disconnect();
}
```

### 11.2 Import Coordinator Contract

```dart
abstract class ImportCoordinator {
  /// Import data from all connected platforms
  Future<ImportResult> importAll({
    required String profileId,
    DateTime? since,
  });

  /// Import data from specific platform
  Future<ImportResult> importFromPlatform({
    required String profileId,
    required WearablePlatform platform,
    required Set<DataType> dataTypes,
    DateTime? since,
  });

  /// Check for and resolve duplicates
  Future<List<DuplicateRecord>> findDuplicates(String profileId);

  /// Get import history
  Future<List<ImportRecord>> getImportHistory({
    required String profileId,
    int? limit,
  });
}

class ImportResult {
  final int imported;
  final int skipped;          // Duplicates
  final int failed;
  final List<ImportError> errors;
  final DateTime syncedAt;
}
```

### 11.3 FHIR Export Contract

```dart
abstract class FhirExportService {
  /// Generate FHIR bundle
  Future<Result<FhirBundle, ExportError>> generateBundle({
    required String profileId,
    required DateTime startDate,
    required DateTime endDate,
    required Set<FhirResourceType> resourceTypes,
  });

  /// Export to file
  Future<Result<File, ExportError>> exportToFile({
    required FhirBundle bundle,
    required FhirFormat format,
  });

  /// Get export history
  Future<List<FhirExportRecord>> getExportHistory(String profileId);
}

enum FhirFormat { json, xml, ndjson }
```

---

## 12. UI Specifications

### 12.1 Connected Services Screen

```
┌─────────────────────────────────────────────────────────────────────┐
│ ←  Connected Services                                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  HEALTH PLATFORMS                                                   │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  ❤️ Apple Health                              [Connected ✓]  │   │
│  │     Last synced: 5 minutes ago                              │   │
│  │     Reading: Steps, Sleep, Heart Rate                       │   │
│  │     Writing: Water, Sleep                                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  🟢 Google Fit                                 [Connect]     │   │
│  │     Sync steps, workouts, and sleep from Android devices    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  WEARABLE DEVICES                                                   │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  ⌚ Apple Watch                               [Connected ✓]  │   │
│  │     Quick logging and complications enabled                  │   │
│  │     Last sync: Just now                                      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  💪 Fitbit                                    [Connected ✓]  │   │
│  │     Last synced: 45 minutes ago                             │   │
│  │     Reading: Steps, Sleep, Heart Rate, Weight               │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  🏃 Garmin                                     [Connect]     │   │
│  │     Import activities, sleep, and heart rate                │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  💍 Oura Ring                                  [Connect]     │   │
│  │     Import sleep, readiness, and heart rate                 │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  🔴 WHOOP                                      [Connect]     │   │
│  │     Import recovery, strain, and sleep                      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  DATA EXPORT                                                        │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  📄 FHIR Export                                              │   │
│  │     Export health data in standard medical format           │   │
│  │                                              [Export...]     │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 13. Localization

```json
{
  "connectedServices": "Connected Services",
  "healthPlatforms": "Health Platforms",
  "wearableDevices": "Wearable Devices",
  "dataExport": "Data Export",

  "connected": "Connected",
  "connect": "Connect",
  "disconnect": "Disconnect",
  "reconnect": "Reconnect",

  "lastSynced": "Last synced: {time}",
  "@lastSynced": {"placeholders": {"time": {"type": "String"}}},

  "reading": "Reading: {types}",
  "@reading": {"placeholders": {"types": {"type": "String"}}},

  "writing": "Writing: {types}",
  "@writing": {"placeholders": {"types": {"type": "String"}}},

  "appleHealth": "Apple Health",
  "googleFit": "Google Fit",
  "appleWatch": "Apple Watch",
  "fitbit": "Fitbit",
  "garmin": "Garmin",
  "ouraRing": "Oura Ring",
  "whoop": "WHOOP",

  "fhirExport": "FHIR Export",
  "exportHealthData": "Export Health Data",
  "exportFormat": "Export Format",
  "dateRange": "Date Range",
  "dataToInclude": "Data to Include",
  "estimatedSize": "Estimated size: {size}",
  "@estimatedSize": {"placeholders": {"size": {"type": "String"}}},

  "exportToFiles": "Export to Files",
  "share": "Share...",

  "steps": "Steps",
  "heartRate": "Heart Rate",
  "sleep": "Sleep",
  "workouts": "Workouts",
  "weight": "Weight",
  "temperature": "Temperature",
  "water": "Water",

  "backgroundSyncEnabled": "Background sync enabled",
  "enableBackgroundSync": "Enable background sync",

  "syncNow": "Sync Now",
  "syncing": "Syncing...",
  "syncComplete": "Sync complete",
  "syncFailed": "Sync failed",

  "importedFrom": "Imported from {source}",
  "@importedFrom": {"placeholders": {"source": {"type": "String"}}},

  "duplicateSkipped": "Duplicate data skipped",
  "newDataImported": "{count} new records imported",
  "@newDataImported": {"placeholders": {"count": {"type": "int"}}}
}
```

---

## 14. Testing Strategy

### 14.1 Unit Tests

```dart
group('HealthKitService', () {
  test('maps sleep stages correctly', () {
    final hkSleep = HKCategorySample(
      type: HKCategoryType.sleepAnalysis,
      value: HKCategoryValueSleepAnalysis.asleepDeep.rawValue,
      startDate: DateTime(2026, 1, 15, 23, 0),
      endDate: DateTime(2026, 1, 15, 23, 45),
    );

    final mapped = HealthKitMapper.mapSleepStage(hkSleep);

    expect(mapped.stage, SleepStage.deep);
    expect(mapped.duration, Duration(minutes: 45));
  });
});

group('ImportDeduplicator', () {
  test('detects duplicate by external ID', () async {
    // Insert existing
    await repository.insert(ActivityLog(
      importSource: 'fitbit',
      importExternalId: 'fitbit_123',
      steps: 5000,
    ));

    final isDupe = await deduplicator.isDuplicate(ImportedDataPoint(
      source: 'fitbit',
      externalId: 'fitbit_123',
      data: {'steps': 5000},
    ));

    expect(isDupe, true);
  });

  test('allows similar data from different sources', () async {
    await repository.insert(ActivityLog(
      importSource: 'healthkit',
      steps: 5000,
      timestamp: DateTime(2026, 1, 15, 12, 0),
    ));

    final isDupe = await deduplicator.isDuplicate(ImportedDataPoint(
      source: 'fitbit',
      data: {'steps': 5100},
      timestamp: DateTime(2026, 1, 15, 12, 0),
    ));

    expect(isDupe, false); // Different source = not duplicate
  });
});

group('FhirExportService', () {
  test('generates valid FHIR Condition resource', () {
    final condition = Condition(
      id: 'cond-001',
      name: 'Migraine',
      snomedCode: '37796009',
    );

    final fhirCondition = exporter.mapConditionToFhir(condition);

    expect(fhirCondition.resourceType, 'Condition');
    expect(fhirCondition.code.coding.first.system, 'http://snomed.info/sct');
    expect(fhirCondition.code.coding.first.code, '37796009');
  });
});
```

---

## 15. Acceptance Criteria

### 15.1 Apple HealthKit

- [ ] HealthKit available check works on iOS devices
- [ ] Authorization request shows correct data types
- [ ] Background delivery triggers on new data
- [ ] Sleep data imports with correct stage mapping
- [ ] Heart rate imports as vitals
- [ ] Steps import as walking activity
- [ ] Water intake exports to HealthKit
- [ ] Duplicate detection prevents reimporting same data

### 15.2 Google Fit

- [ ] OAuth flow completes successfully
- [ ] Token refresh works automatically
- [ ] Sleep data imports correctly
- [ ] Steps aggregate correctly
- [ ] Background polling respects rate limits
- [ ] Disconnect removes tokens

### 15.3 Apple Watch

- [ ] Companion app installs from parent app
- [ ] Quick log sends to phone immediately when reachable
- [ ] Quick log queues when phone unreachable
- [ ] Complication shows accurate supplement status
- [ ] Notification actions work on watch

### 15.4 Third-Party Wearables

- [ ] Fitbit OAuth and data fetch works
- [ ] Garmin OAuth and data fetch works
- [ ] Oura OAuth and data fetch works
- [ ] WHOOP OAuth and data fetch works
- [ ] All platforms handle token expiration gracefully

### 15.5 FHIR Export

- [ ] Bundle validates against FHIR R4 spec
- [ ] All resource types export correctly
- [ ] Date range filtering works
- [ ] JSON format is valid
- [ ] File size estimate is accurate
- [ ] Share sheet works on all platforms

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-31 | Development Team | Initial Phase 4 specification |

---

## Related Documents

- [01_PRODUCT_SPECIFICATIONS.md](01_PRODUCT_SPECIFICATIONS.md) - Product overview
- [04_ARCHITECTURE.md](04_ARCHITECTURE.md) - System architecture
- [10_DATABASE_SCHEMA.md](10_DATABASE_SCHEMA.md) - Database design
- [35_QR_DEVICE_PAIRING.md](35_QR_DEVICE_PAIRING.md) - Device pairing (includes HIPAA authorization)
- [37_NOTIFICATIONS.md](37_NOTIFICATIONS.md) - Notification system
