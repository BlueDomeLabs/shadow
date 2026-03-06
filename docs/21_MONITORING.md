# Shadow Monitoring & Observability

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Application monitoring, metrics collection, alerting, and observability strategy

---

## Overview

Shadow requires comprehensive monitoring to ensure reliability, track user experience, and enable rapid incident response. This document defines the observability strategy for a health data application where reliability is critical.

---

## 1. Monitoring Architecture

### 1.1 Observability Pillars

| Pillar | Purpose | Tools |
|--------|---------|-------|
| **Metrics** | Quantitative measurements over time | Firebase Analytics, Custom events |
| **Logs** | Discrete events with context | Firebase Crashlytics, structured logging |
| **Traces** | Request flow through system | Custom trace IDs for sync operations |
| **Alerts** | Proactive notification of issues | Firebase alerts, custom thresholds |

### 1.2 Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                      Shadow Mobile App                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │   Metrics   │  │    Logs     │  │   Traces    │             │
│  │  Collector  │  │  Collector  │  │  Collector  │             │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘             │
│         │                │                │                     │
│         └────────────────┼────────────────┘                     │
│                          │                                      │
│                    ┌─────▼─────┐                                │
│                    │  Batching  │                               │
│                    │  & Queue   │                               │
│                    └─────┬─────┘                                │
│                          │                                      │
└──────────────────────────┼──────────────────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │   Firebase/Analytics   │
              │       Backend          │
              └───────────┬────────────┘
                          │
              ┌───────────┴───────────┐
              │                       │
              ▼                       ▼
     ┌────────────────┐      ┌────────────────┐
     │   Dashboards   │      │    Alerts      │
     │   & Reports    │      │   & PagerDuty  │
     └────────────────┘      └────────────────┘
```

---

## 2. Key Metrics

### 2.1 Application Health Metrics

| Metric | Description | Target | Alert Threshold |
|--------|-------------|--------|-----------------|
| **Crash-Free Users** | % of users without crashes | >99.5% | <99% |
| **Crash-Free Sessions** | % of sessions without crashes | >99.9% | <99.5% |
| **ANR Rate** (Android) | Application Not Responding rate | <0.1% | >0.5% |
| **App Launch Time** | Cold start to interactive | <2s | >4s |
| **Frame Rate** | Sustained frames per second | 60fps | <55fps |
| **Jank Rate** | Frames exceeding 16ms render time | <1% | >3% |
| **Memory Usage** | Peak memory consumption | <200MB | >300MB |
| **Battery Impact** | Background battery drain | <2%/hr | >5%/hr |

### 2.2 Feature Usage Metrics

| Metric | Description | Tracking Method |
|--------|-------------|-----------------|
| **DAU/MAU** | Daily/Monthly active users | Session start events |
| **Tab Engagement** | Time spent per module | Screen view duration |
| **Entry Creation Rate** | Entries per user per day | Create events |
| **Feature Adoption** | % using each feature | First use events |
| **Retention** | Day 1, 7, 30 retention | Cohort analysis |
| **Sync Success Rate** | Successful syncs / attempts | Sync events |

### 2.3 Fluids Feature Metrics

| Metric | Description | Target |
|--------|-------------|--------|
| **Menstruation Tracking Adoption** | % of users logging menstruation | Track weekly |
| **BBT Entry Rate** | BBT entries per user per week | Track trend |
| **BBT Chart Views** | Chart screen opens per user | Track engagement |
| **Fluids Tab Time** | Average time in Fluids tab | Compare to other tabs |

### 2.4 Notification Metrics

| Metric | Description | Target | Alert Threshold |
|--------|-------------|--------|-----------------|
| **Delivery Rate** | Notifications delivered / scheduled | >98% | <95% |
| **Open Rate** | Notifications opened / delivered | >30% | <10% |
| **Action Rate** | Actions taken after open | >50% | Track trend |
| **Opt-out Rate** | Users disabling notifications | <5%/week | >10%/week |
| **Permission Grant Rate** | Users granting permission | >70% | <50% |

### 2.5 Sync & Data Metrics

| Metric | Description | Target | Alert Threshold |
|--------|-------------|--------|-----------------|
| **Sync Success Rate** | Successful syncs / total attempts | >99% | <95% |
| **Sync Latency** | Time to complete sync | <5s | >15s |
| **Conflict Resolution Rate** | Conflicts auto-resolved | >95% | <80% |
| **Data Integrity Score** | Successful checksum validations | 100% | <99.9% |
| **Offline Queue Size** | Pending sync operations | <50 | >200 |

---

## 3. Error Tracking

### 3.1 Error Categories

| Category | Severity | Example | Response |
|----------|----------|---------|----------|
| **Fatal** | P0 | App crash, data loss | Immediate page |
| **Critical** | P1 | Sync failure, auth broken | 15 min response |
| **Major** | P2 | Feature broken, slow performance | 1 hour response |
| **Minor** | P3 | UI glitch, cosmetic issue | Next sprint |
| **Warning** | P4 | Deprecation, potential issue | Backlog |

### 3.2 Error Tracking Implementation

```dart
// lib/core/services/error_tracking_service.dart

class ErrorTrackingService {
  final FirebaseCrashlytics _crashlytics;

  Future<void> recordError(
    dynamic error,
    StackTrace stackTrace, {
    ErrorSeverity severity = ErrorSeverity.major,
    Map<String, dynamic>? context,
  }) async {
    // Add context
    if (context != null) {
      for (final entry in context.entries) {
        _crashlytics.setCustomKey(entry.key, entry.value.toString());
      }
    }

    // Set severity
    _crashlytics.setCustomKey('severity', severity.name);

    // Record based on severity
    if (severity == ErrorSeverity.fatal) {
      await _crashlytics.recordError(
        error,
        stackTrace,
        fatal: true,
        reason: 'Fatal error: ${error.toString()}',
      );
    } else {
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: '${severity.name}: ${error.toString()}',
      );
    }
  }

  void setUserContext(String? userId, {Map<String, String>? properties}) {
    if (userId != null) {
      _crashlytics.setUserIdentifier(userId);
    }
    properties?.forEach((key, value) {
      _crashlytics.setCustomKey(key, value);
    });
  }
}
```

### 3.3 Error Context Requirements

Every error must include:

| Field | Description | Example |
|-------|-------------|---------|
| **error_type** | Error class name | `NetworkError.timeout` |
| **user_action** | What user was doing | `creating_fluids_entry` |
| **screen** | Current screen | `fluids_tab` |
| **feature_flags** | Active flags | `fluids_bbt_enabled=true` |
| **sync_state** | Current sync status | `syncing`, `idle`, `offline` |
| **data_state** | Relevant entity IDs | `entry_id=abc123` |

---

## 4. Logging Strategy

### 4.1 Log Levels

| Level | Use Case | Example | Persisted |
|-------|----------|---------|-----------|
| **DEBUG** | Development only | Variable values, flow tracing | No |
| **INFO** | Normal operations | User actions, state changes | Local only |
| **WARNING** | Potential issues | Retry attempts, degraded mode | Yes |
| **ERROR** | Failures | API errors, validation failures | Yes + remote |
| **FATAL** | App-breaking | Crashes, data corruption | Yes + remote |

### 4.2 Structured Logging Format

```dart
// Log entry structure
{
  "timestamp": "2026-01-30T14:32:15.123Z",
  "level": "ERROR",
  "message": "Sync failed for fluids entries",
  "context": {
    "user_id": "hashed_user_id",
    "session_id": "abc123",
    "screen": "fluids_tab",
    "action": "manual_sync"
  },
  "error": {
    "type": "NetworkError.timeout",
    "code": "TIMEOUT",
    "retry_count": 3
  },
  "metadata": {
    "app_version": "1.1.0",
    "platform": "ios",
    "os_version": "17.3"
  }
}
```

### 4.3 PII Handling in Logs

**Never log:**
- User names, emails, or identifiers (use hashed IDs)
- Health data values (menstruation flow, BBT readings)
- OAuth tokens or credentials
- Full file paths containing usernames

**Safe to log:**
- Hashed/anonymized user IDs
- Entry IDs and timestamps
- Error types and codes
- Feature flag states
- App version and platform info

---

## 5. Performance Monitoring

### 5.1 Key Performance Indicators

| Operation | Target | P95 Target | Alert Threshold |
|-----------|--------|------------|-----------------|
| **Cold Start** | <2s | <3s | >4s |
| **Warm Start** | <500ms | <1s | >2s |
| **Tab Switch** | <100ms | <200ms | >500ms |
| **Frame Rate** | 60fps | 55fps | <50fps |
| **Frame Render** | <16ms | <18ms | >20ms |
| **Entry Save** | <200ms | <500ms | >1s |
| **Sync Cycle** | <5s | <10s | >30s |
| **Chart Render** (BBT) | <500ms | <1s | >2s |
| **Photo Load** | <300ms | <500ms | >1s |

### 5.2 Performance Trace Implementation

```dart
// Custom performance traces
class PerformanceService {
  Future<T> trace<T>(
    String name,
    Future<T> Function() operation, {
    Map<String, String>? attributes,
  }) async {
    final trace = FirebasePerformance.instance.newTrace(name);

    attributes?.forEach((key, value) {
      trace.putAttribute(key, value);
    });

    await trace.start();

    try {
      final result = await operation();
      trace.putMetric('success', 1);
      return result;
    } catch (e) {
      trace.putMetric('success', 0);
      trace.putAttribute('error_type', e.runtimeType.toString());
      rethrow;
    } finally {
      await trace.stop();
    }
  }
}

// Usage
await performanceService.trace(
  'fluids_entry_save',
  () => repository.saveFluidsEntry(entry),
  attributes: {'has_bbt': entry.bbt != null ? 'true' : 'false'},
);
```

### 5.3 Memory Monitoring

```dart
// Track memory usage at key points
void trackMemoryUsage(String context) {
  final info = ProcessInfo.currentRss;
  analytics.logEvent(
    name: 'memory_usage',
    parameters: {
      'context': context,
      'rss_mb': (info / 1024 / 1024).round(),
    },
  );
}

// Call at key lifecycle points
trackMemoryUsage('app_launch');
trackMemoryUsage('after_sync');
trackMemoryUsage('bbt_chart_rendered');
```

---

## 6. Alerting Configuration

### 6.1 Alert Tiers

| Tier | Response Time | Notification | Escalation |
|------|---------------|--------------|------------|
| **P0 - Critical** | Immediate | Page on-call | Auto-escalate 15 min |
| **P1 - High** | 15 minutes | Slack + SMS | Escalate 1 hour |
| **P2 - Medium** | 1 hour | Slack only | Next business day |
| **P3 - Low** | 4 hours | Email digest | Weekly review |

### 6.2 Alert Definitions

```yaml
# alerting_rules.yaml

alerts:
  - name: high_crash_rate
    tier: P0
    condition: crash_free_users < 99%
    window: 1 hour
    message: "Crash rate exceeded threshold: {{value}}%"

  - name: sync_failures_spike
    tier: P1
    condition: sync_success_rate < 95%
    window: 15 minutes
    message: "Sync failure rate: {{value}}%"

  - name: auth_failures
    tier: P1
    condition: auth_error_rate > 5%
    window: 15 minutes
    message: "Auth failure spike: {{value}}%"

  - name: notification_delivery_drop
    tier: P2
    condition: notification_delivery_rate < 95%
    window: 1 hour
    message: "Notification delivery degraded: {{value}}%"

  - name: slow_app_start
    tier: P2
    condition: p95_cold_start > 4s
    window: 1 hour
    message: "App start time degraded: {{value}}s"

  - name: high_memory_usage
    tier: P2
    condition: p95_memory > 300MB
    window: 30 minutes
    message: "Memory usage elevated: {{value}}MB"
```

### 6.3 On-Call Runbook References

Each alert should link to a runbook:

| Alert | Runbook |
|-------|---------|
| high_crash_rate | `runbooks/crash_investigation.md` |
| sync_failures_spike | `runbooks/sync_troubleshooting.md` |
| auth_failures | `runbooks/auth_issues.md` |
| notification_delivery_drop | `runbooks/notification_debugging.md` |

---

## 7. Dashboards

### 7.1 Executive Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│                    Shadow Health - Executive                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  DAU: 12,345 (+5.2%)    MAU: 45,678 (+8.1%)    Retention: 67%  │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  30-Day Active Users                                     │   │
│  │  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Feature Adoption                    Crash-Free: 99.7%         │
│  ├── Fluids: 78%                     App Rating: 4.6 ★         │
│  ├── Notifications: 45%              NPS: +42                  │
│  └── Diet Type: 23%                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 7.2 Engineering Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│                    Shadow Health - Engineering                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  System Health                       Error Rate                 │
│  ├── Crash-Free: 99.7%              ├── Auth: 0.1%             │
│  ├── Sync Success: 99.2%            ├── Sync: 0.3%             │
│  └── Notif Delivery: 98.5%          └── DB: 0.01%              │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  P95 Response Times (ms)                                 │   │
│  │                                                          │   │
│  │  Cold Start  ████████████████████ 2,100ms               │   │
│  │  Tab Switch  ████ 150ms                                  │   │
│  │  Entry Save  ██████ 280ms                               │   │
│  │  Sync Cycle  ██████████████ 4,500ms                     │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Active Alerts: 0    Feature Flags: 4 rolling out              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 7.3 Feature Flag Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│                    Feature Flag Rollout Status                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  fluids_menstruation_enabled                                    │
│  ├── Status: Limited (10%)                                      │
│  ├── Exposed: 1,234 users                                       │
│  ├── Error Delta: +0.01% (within threshold)                    │
│  └── [Expand to 25%] [Rollback]                                │
│                                                                 │
│  fluids_bbt_enabled                                             │
│  ├── Status: Canary (1%)                                        │
│  ├── Exposed: 123 users                                         │
│  ├── Error Delta: +0.00%                                       │
│  └── [Expand to 10%] [Rollback]                                │
│                                                                 │
│  notifications_enabled                                          │
│  ├── Status: Beta (TestFlight only)                            │
│  ├── Exposed: 50 users                                          │
│  ├── Delivery Rate: 97.2%                                      │
│  └── [Begin Canary] [Pause]                                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 8. Analytics Events

### 8.1 Standard Event Schema

```dart
// All events follow this structure
class AnalyticsEvent {
  final String name;           // snake_case event name
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  // Standard parameters included automatically
  // - user_id (hashed)
  // - session_id
  // - app_version
  // - platform
  // - screen_name
}
```

### 8.2 Core Events

| Event | Trigger | Parameters |
|-------|---------|------------|
| `app_open` | App launched | `launch_type: cold/warm` |
| `screen_view` | Screen displayed | `screen_name`, `previous_screen` |
| `tab_switch` | Tab navigation | `from_tab`, `to_tab` |
| `entry_created` | Any entry saved | `entry_type`, `has_photo` |
| `entry_updated` | Entry modified | `entry_type`, `fields_changed` |
| `entry_deleted` | Entry removed | `entry_type` |
| `sync_started` | Sync initiated | `trigger: auto/manual` |
| `sync_completed` | Sync finished | `duration_ms`, `items_synced` |
| `sync_failed` | Sync error | `error_type`, `retry_count` |

### 8.3 Feature-Specific Events

| Event | Trigger | Parameters |
|-------|---------|------------|
| `fluids_menstruation_logged` | Menstruation saved | `flow_level` |
| `fluids_bbt_logged` | BBT saved | `has_time` |
| `fluids_bbt_chart_viewed` | Chart opened | `date_range_days` |
| `notification_scheduled` | Reminder created | `type`, `time_count` |
| `notification_received` | Notification shown | `type`, `was_tapped` |
| `notification_action` | Deep link followed | `type`, `action` |
| `diet_type_set` | Diet configured | `diet_type`, `has_description` |
| `profile_completed` | All profile fields set | `fields_completed` |

### 8.4 Funnel Events

```
Onboarding Funnel:
app_install → onboarding_started → profile_created → first_entry_created → day7_retention

Notification Setup Funnel:
notification_prompt_shown → permission_granted → first_schedule_created → notification_received → notification_action

BBT Tracking Funnel:
bbt_feature_discovered → first_bbt_logged → bbt_chart_viewed → 7_day_bbt_streak
```

---

## 9. Privacy-Compliant Analytics

### 9.1 Data Minimization

| Data Type | Collected | Justification |
|-----------|-----------|---------------|
| Hashed User ID | Yes | Attribution without PII |
| Device Model | Yes | Performance analysis |
| OS Version | Yes | Compatibility tracking |
| App Version | Yes | Version adoption |
| Screen Names | Yes | UX optimization |
| Feature Usage | Yes | Product decisions |
| Health Data Values | **No** | PHI - never logged |
| Entry Content | **No** | Privacy |
| User Names | **No** | PII |

### 9.2 User Controls

```
Settings → Privacy → Analytics

┌────────────────────────────────────────┐
│  Analytics Preferences                  │
├────────────────────────────────────────┤
│                                        │
│  Usage Analytics               [ON]    │
│  Help improve Shadow by sharing        │
│  anonymous usage data                  │
│                                        │
│  Crash Reports                 [ON]    │
│  Send crash reports to fix bugs        │
│                                        │
│  [What data is collected?]             │
│                                        │
└────────────────────────────────────────┘
```

### 9.3 Analytics Opt-Out Implementation

```dart
class AnalyticsService {
  bool _analyticsEnabled = true;
  bool _crashReportingEnabled = true;

  Future<void> logEvent(String name, Map<String, dynamic> params) async {
    if (!_analyticsEnabled) return;

    // Sanitize parameters
    final sanitized = _sanitizeParams(params);

    await _analytics.logEvent(name: name, parameters: sanitized);
  }

  Map<String, dynamic> _sanitizeParams(Map<String, dynamic> params) {
    final result = Map<String, dynamic>.from(params);

    // Remove any accidentally included PII
    result.remove('email');
    result.remove('name');
    result.remove('user_name');

    // Ensure no health values
    result.remove('temperature');
    result.remove('flow_value');

    return result;
  }
}
```

---

## 10. Incident Response Integration

### 10.1 Monitoring → Incident Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Anomaly    │     │    Alert     │     │   Incident   │
│   Detected   │────▶│   Triggered  │────▶│   Created    │
└──────────────┘     └──────────────┘     └──────────────┘
                                                 │
                                                 ▼
                                          ┌──────────────┐
                                          │   On-Call    │
                                          │   Notified   │
                                          └──────┬───────┘
                                                 │
              ┌──────────────────────────────────┼───────────┐
              │                                  │           │
              ▼                                  ▼           ▼
       ┌──────────────┐                   ┌──────────┐ ┌──────────┐
       │  Investigate │                   │   Fix    │ │ Feature  │
       │   & Triage   │                   │  Deploy  │ │   Flag   │
       └──────────────┘                   └──────────┘ │ Rollback │
                                                       └──────────┘
```

### 10.2 Post-Incident Metrics

After each incident, track:
- Time to Detection (TTD)
- Time to Acknowledgment (TTA)
- Time to Resolution (TTR)
- User Impact (affected users count)
- Root Cause Category
- Prevention Actions

---

## 11. Implementation Checklist

### 11.1 Pre-Launch

- [ ] Firebase Analytics configured
- [ ] Firebase Crashlytics configured
- [ ] Firebase Performance Monitoring configured
- [ ] Custom events defined and documented
- [ ] Error tracking service implemented
- [ ] Performance traces added to critical paths
- [ ] Dashboards created
- [ ] Alerts configured with escalation paths
- [ ] On-call rotation established
- [ ] Runbooks written for common alerts

### 11.2 Post-Launch

- [ ] Daily: Review crash reports
- [ ] Weekly: Analyze feature metrics
- [ ] Weekly: Review alert fatigue
- [ ] Monthly: Dashboard accuracy check
- [ ] Quarterly: SLO/SLA review
- [ ] Quarterly: Monitoring coverage audit

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
