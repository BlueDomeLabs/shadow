# 61 — Health Platform Integration (HealthKit & Health Connect)
**Status:** PLANNED — Not yet implemented
**Target Phase:** Phase 16
**Created:** 2026-02-22
**Depends on:** Phase 13 (Notification System complete), Phase 15b (Diet Tracking complete)

---

## Overview

Shadow imports health data from Apple HealthKit (iOS) and Google Health Connect (Android). This allows users to bring in vitals and activity data measured by wearables — Fitbit, Apple Watch, Garmin, Withings, and any other device that writes to the platform health aggregator — without Shadow needing individual device integrations.

Imported data is stored separately from user-entered Shadow data and is read-only within Shadow. Both sources are displayed together in reports and correlation views, clearly labeled by origin.

Sync is manual — the user taps a "Sync from Health" button. No background sync. This keeps the user in control and avoids battery and privacy concerns associated with background data access.

---

## Data Types Imported

| Data Type | Apple HealthKit Identifier | Google Health Connect Type |
|---|---|---|
| Heart Rate | HKQuantityTypeIdentifierHeartRate | HeartRate |
| Resting Heart Rate | HKQuantityTypeIdentifierRestingHeartRate | RestingHeartRate |
| Weight | HKQuantityTypeIdentifierBodyMass | Weight |
| Blood Pressure (Systolic) | HKQuantityTypeIdentifierBloodPressureSystolic | BloodPressure |
| Blood Pressure (Diastolic) | HKQuantityTypeIdentifierBloodPressureDiastolic | BloodPressure |
| Sleep (sessions) | HKCategoryTypeIdentifierSleepAnalysis | SleepSession |
| Steps | HKQuantityTypeIdentifierStepCount | Steps |
| Active Energy / Activity | HKQuantityTypeIdentifierActiveEnergyBurned | ActiveCaloriesBurned |
| Blood Oxygen (SpO2) | HKQuantityTypeIdentifierOxygenSaturation | OxygenSaturation |

---

## Data Storage

### Imported Vitals Entity
All imported health platform data is stored in a single `imported_vitals` table. Records are read-only — Shadow never modifies or deletes imported data after it is written. Re-syncing adds new records but does not overwrite existing ones.

```sql
CREATE TABLE imported_vitals (
  id TEXT PRIMARY KEY,
  profile_id TEXT NOT NULL,
  data_type TEXT NOT NULL,        -- heart_rate, resting_heart_rate, weight, bp_systolic,
                                  --   bp_diastolic, sleep_start, sleep_end, steps,
                                  --   active_calories, blood_oxygen
  value REAL NOT NULL,            -- numeric value in canonical unit
  unit TEXT NOT NULL,             -- canonical unit string (bpm, kg, mmHg, hours, steps, kcal, %)
  recorded_at TEXT NOT NULL,      -- ISO8601 timestamp from the source device
  source_platform TEXT NOT NULL,  -- "apple_health" or "google_health_connect"
  source_device TEXT,             -- device name if available (e.g. "Apple Watch Series 9")
  imported_at TEXT NOT NULL,      -- when Shadow imported this record
  FOREIGN KEY (profile_id) REFERENCES profiles(id)
);

CREATE INDEX idx_imported_vitals_profile ON imported_vitals(profile_id);
CREATE INDEX idx_imported_vitals_type_date ON imported_vitals(data_type, recorded_at);
```

### Canonical Units
All values stored in canonical units regardless of device or user unit preferences. Conversion to display units happens at render time per the Units Settings (spec 58).

| Data Type | Canonical Unit |
|---|---|
| Heart Rate | bpm |
| Resting Heart Rate | bpm |
| Weight | kg |
| Blood Pressure | mmHg |
| Sleep | hours |
| Steps | count |
| Active Calories | kcal |
| Blood Oxygen | percentage (0-100) |

### Blood Pressure Storage
Systolic and diastolic are stored as two separate records with data_type "bp_systolic" and "bp_diastolic" sharing the same recorded_at timestamp. They are paired at display time by matching timestamps.

### Sleep Data
Sleep sessions from HealthKit/Health Connect are stored as duration in hours. The start and end times are both stored (as separate records or as a duration from recorded_at) so Shadow can correlate sleep timing with supplement schedules and condition check-ins.

---

## Sync Flow

### Triggering a Sync
- A "Sync from Health" button appears in the Health Platform section of Settings (new section in the Settings screen, added in Phase 16)
- Tapping it opens a confirmation sheet showing which data types will be imported and the date range (default: last 30 days, configurable up to 90 days)
- User taps "Import" to proceed

### Permission Request
- On first sync attempt, Shadow requests read permissions for each data type from HealthKit or Health Connect
- Permissions are requested one platform at a time
- If the user denies any permission, Shadow imports only the permitted data types and notes which were skipped
- Permission status is shown in Settings so the user can see what Shadow has access to

### Import Process
1. Shadow reads all new records since the last successful import (stored as `last_imported_at` per data type)
2. Deduplication: records with the same data_type + recorded_at + source_platform are skipped
3. New records are written to imported_vitals table
4. last_imported_at is updated per data type
5. User sees a summary: "Imported 47 records — 12 heart rate, 8 weight, 15 sleep, 12 steps"

### Incremental Sync
After the first full import, subsequent syncs only fetch records newer than last_imported_at. This keeps syncs fast.

---

## Display — Reports Integration

Imported vitals appear in Shadow's reports and correlation views alongside user-entered data. They are always clearly labeled by source.

### Labeling
- User-entered Shadow data: no special label
- Imported data: small platform badge — Apple Health logo or Google Health Connect logo
- Both are shown in the same charts and timelines

### Correlation Views (future reporting phase)
Imported vitals enable correlations that aren't possible with Shadow data alone:
- Resting heart rate over time vs supplement schedule changes
- Weight trend vs diet compliance
- Sleep duration vs condition severity
- Steps/activity vs energy levels (from journal entries)
- Blood oxygen vs sleep quality

These correlations are planned for the reporting phase (post Phase 15b) and are the primary reason for importing this data.

---

## Platform-Specific Implementation

### iOS — Apple HealthKit
- Framework: `health` Flutter plugin (wraps HealthKit natively)
- Entitlement required: `com.apple.developer.healthkit` — must be enabled in Xcode project capabilities
- Info.plist keys required:
  - `NSHealthShareUsageDescription` — explain why Shadow reads health data
  - `NSHealthUpdateUsageDescription` — required even if Shadow never writes (HealthKit requirement)
- Shadow requests read-only access — never writes to HealthKit
- HealthKit data is always per-device — Shadow reads from the local HealthKit store which aggregates from all connected sources (Apple Watch, Fitbit app, etc.)

### Android — Google Health Connect
- Framework: `health` Flutter plugin (same plugin, different platform implementation)
- Health Connect must be installed on the device (it is pre-installed on Android 14+, available as a separate app on Android 13)
- Permissions declared in AndroidManifest.xml for each data type
- Health Connect permission request uses the platform permission dialog
- Shadow requests read-only access

### Shared Flutter Plugin
Both platforms are handled by the `health` pub.dev package. This is the same plugin already used by many Flutter health apps and is well-maintained. Add to pubspec.yaml:
```yaml
health: ^10.0.0  # verify latest version at implementation time
```

---

## Settings Screen Addition (Phase 16)

A new "Health Platform" section is added to the Settings screen:

**Section: Health Data**
- Platform status row: "Apple Health — Connected" or "Google Health Connect — Connected" or "Not connected"
- "Sync from Health" button — triggers the import flow
- "Last synced" timestamp
- "Manage Permissions" button — opens platform permission settings
- Date range selector: "Import last 30 / 60 / 90 days"

**Per-data-type toggles:**
Each of the 9 data types has an individual toggle so users can choose which types Shadow imports. Defaults: all enabled.

---

## New Use Cases

- `SyncFromHealthPlatformUseCase` — orchestrates the full import flow
- `GetImportedVitalsUseCase` — retrieves imported vitals for a profile and date range
- `GetLastSyncStatusUseCase` — returns last sync timestamp and record counts per data type
- `UpdateHealthSyncSettingsUseCase` — saves user's data type preferences and date range

---

## New Entities

- `ImportedVital` — single imported measurement
- `HealthSyncSettings` — user's sync preferences (enabled data types, date range)
- `HealthSyncStatus` — last sync result per data type (timestamp, record count, error if any)

---

## Privacy Notes

- Shadow only reads from health platforms — never writes
- Imported data stays on device and syncs to the user's own Google Drive (same as all Shadow data)
- No imported data is sent to any third-party server
- The user controls which data types are imported via per-type toggles
- Permissions can be revoked at any time from the platform's own settings (Health app on iOS, Health Connect app on Android)
- Shadow's privacy policy (displayed in the app) should be updated to mention health platform data import

---

## Implementation Notes

- The `health` Flutter plugin handles most of the platform complexity — use it rather than writing native HealthKit/Health Connect code directly
- Test on real devices — health platform data is not available in simulators/emulators
- Handle the case where Health Connect is not installed on Android gracefully — show "Health Connect not available on this device" with a link to install it
- Blood pressure pairing (systolic + diastolic) should be matched by timestamp with a ±30 second tolerance to account for slight timing differences between records
- Sleep data from HealthKit includes "in bed" vs "asleep" stages — store total sleep duration (asleep only, not in bed) as the canonical value
- Steps are cumulative per day in HealthKit — store individual session records, not daily totals, so the data can be aggregated flexibly in reports

---

## Implementation Order

1. Add `health` Flutter plugin to pubspec.yaml
2. Configure iOS entitlements and Info.plist keys
3. Configure Android permissions in AndroidManifest.xml
4. Create imported_vitals database table and DAO (schema v12→v13 or incorporated into next available migration)
5. Create ImportedVital entity and HealthSyncSettings entity
6. Implement SyncFromHealthPlatformUseCase
7. Implement GetImportedVitalsUseCase
8. Add Health Data section to Settings screen
9. Write tests (note: platform integration tests require real devices — unit tests mock the health plugin)
10. Commit and push
