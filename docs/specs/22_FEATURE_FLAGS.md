# Shadow Feature Flag Strategy

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Feature flag definitions, rollout rules, and implementation patterns

---

## Overview

Shadow uses feature flags to safely roll out new features, enable A/B testing, and provide kill switches for problematic functionality. All new features must be behind flags during initial rollout.

---

## 1. Feature Flag Architecture

### 1.1 Flag Types

| Type | Description | Use Case | Persistence |
|------|-------------|----------|-------------|
| **Release** | Controls feature visibility | New feature rollout | Remote config |
| **Ops** | Emergency kill switches | Disable broken features | Remote config |
| **Experiment** | A/B test variants | Test UI variations | Remote config |
| **Permission** | User-specific access | Beta testers, staff | User profile |
| **Development** | Local dev toggles | WIP features | Build config |

### 1.2 Flag Sources (Priority Order)

1. **Build-time** (`--dart-define`) - Highest priority, development overrides
2. **Remote Config** - Firebase Remote Config or equivalent
3. **User Profile** - User-specific flags from database
4. **Default Values** - Hardcoded fallbacks

```dart
// lib/core/services/feature_flag_service.dart

class FeatureFlagService {
  final RemoteConfigService _remoteConfig;
  final UserProfileService _userProfile;

  bool isEnabled(FeatureFlag flag) {
    // 1. Check build-time override
    final buildOverride = _getBuildOverride(flag);
    if (buildOverride != null) return buildOverride;

    // 2. Check remote config
    final remoteValue = _remoteConfig.getBool(flag.key);
    if (remoteValue != null) return remoteValue;

    // 3. Check user profile (for permission flags)
    if (flag.type == FlagType.permission) {
      final userValue = _userProfile.hasFlag(flag.key);
      if (userValue) return true;
    }

    // 4. Return default
    return flag.defaultValue;
  }
}
```

---

## 2. Feature Flag Definitions

### 2.1 Release Flags (New Features)

| Flag Key | Description | Default | Target Release |
|----------|-------------|---------|----------------|
| `fluids_menstruation_enabled` | Menstruation tracking in Fluids tab | false | v1.1 |
| `fluids_bbt_enabled` | Basal body temperature tracking | false | v1.1 |
| `fluids_bbt_chart_enabled` | BBT chart visualization | false | v1.1 |
| `notifications_enabled` | Full notification system | false | v1.1 |
| `notifications_supplement_enabled` | Supplement reminders | false | v1.1 |
| `notifications_meal_enabled` | Meal reminders | false | v1.1 |
| `notifications_fluids_enabled` | Fluids reminders | false | v1.1 |
| `notifications_sleep_enabled` | Sleep reminders | false | v1.1 |
| `diet_type_enabled` | Diet type selection | false | v1.1 |
| `diet_badge_enabled` | Diet badge in food tab | false | v1.1 |
| `earth_tones_enabled` | New earth tone color scheme | false | v1.1 |

### 2.2 Ops Flags (Kill Switches)

| Flag Key | Description | Default | Trigger Condition |
|----------|-------------|---------|-------------------|
| `sync_enabled` | Cloud sync functionality | true | Sync service outage |
| `notifications_delivery_enabled` | Send notifications | true | High failure rate |
| `photo_upload_enabled` | Photo sync to cloud | true | Storage issues |
| `oauth_enabled` | Google OAuth | true | Auth service issues |

### 2.3 Experiment Flags

| Flag Key | Description | Variants | Metric |
|----------|-------------|----------|--------|
| `onboarding_flow_variant` | Onboarding experience | `control`, `simplified`, `guided` | Completion rate |
| `notification_permission_prompt` | Permission ask timing | `immediate`, `delayed`, `contextual` | Grant rate |
| `bbt_input_style` | Temperature input UI | `numeric`, `slider`, `stepper` | Entry time |

### 2.4 Permission Flags

| Flag Key | Description | Grant Method |
|----------|-------------|--------------|
| `beta_tester` | Access to beta features | Manual assignment |
| `internal_user` | Staff/developer access | Domain check |
| `early_adopter` | Early access program | Signup |

---

## 3. Flag Implementation

### 3.1 Flag Definition

```dart
// lib/core/config/feature_flags.dart

enum FlagType { release, ops, experiment, permission, development }

class FeatureFlag {
  final String key;
  final FlagType type;
  final bool defaultValue;
  final String description;

  const FeatureFlag({
    required this.key,
    required this.type,
    required this.defaultValue,
    required this.description,
  });
}

class FeatureFlags {
  // Release flags
  static const fluidsMenstruationEnabled = FeatureFlag(
    key: 'fluids_menstruation_enabled',
    type: FlagType.release,
    defaultValue: false,
    description: 'Menstruation tracking in Fluids tab',
  );

  static const fluidsBbtEnabled = FeatureFlag(
    key: 'fluids_bbt_enabled',
    type: FlagType.release,
    defaultValue: false,
    description: 'Basal body temperature tracking',
  );

  static const notificationsEnabled = FeatureFlag(
    key: 'notifications_enabled',
    type: FlagType.release,
    defaultValue: false,
    description: 'Full notification system',
  );

  static const dietTypeEnabled = FeatureFlag(
    key: 'diet_type_enabled',
    type: FlagType.release,
    defaultValue: false,
    description: 'Diet type selection on profile',
  );

  // Ops flags
  static const syncEnabled = FeatureFlag(
    key: 'sync_enabled',
    type: FlagType.ops,
    defaultValue: true,
    description: 'Kill switch for cloud sync',
  );
}
```

### 3.2 Usage in Code

```dart
// In widgets
class FluidsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flags = context.read<FeatureFlagService>();

    return Column(
      children: [
        // Always shown
        BowelSection(),
        UrineSection(),

        // Feature flagged
        if (flags.isEnabled(FeatureFlags.fluidsMenstruationEnabled))
          MenstruationSection(),

        if (flags.isEnabled(FeatureFlags.fluidsBbtEnabled))
          BBTSection(),

        if (flags.isEnabled(FeatureFlags.fluidsBbtEnabled) &&
            flags.isEnabled(FeatureFlags.fluidsBbtChartEnabled))
          BBTChartButton(),
      ],
    );
  }
}
```

### 3.3 Guarding Entire Screens

```dart
// Navigation guard
class FeatureFlagGuard extends StatelessWidget {
  final FeatureFlag flag;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final flags = context.read<FeatureFlagService>();

    if (flags.isEnabled(flag)) {
      return child;
    }

    return fallback ?? const FeatureNotAvailableScreen();
  }
}

// Usage in router
GoRoute(
  path: '/notifications/settings',
  builder: (context, state) => FeatureFlagGuard(
    flag: FeatureFlags.notificationsEnabled,
    child: NotificationSettingsScreen(),
  ),
),
```

---

## 4. Rollout Strategy

### 4.1 Rollout Stages

| Stage | Audience | Duration | Success Criteria |
|-------|----------|----------|------------------|
| **Internal** | Employees only | 1 week | No P0/P1 bugs |
| **Beta** | TestFlight/Internal Track | 2 weeks | <0.5% crash rate |
| **Canary** | 1% of users | 1 week | Metrics baseline |
| **Limited** | 10% of users | 1 week | No regression |
| **Broad** | 50% of users | 1 week | Confidence |
| **GA** | 100% of users | - | - |

### 4.2 Rollout Schedule for v1.1 Features

```
Week 1: Internal Testing
├── All flags enabled for @bluedomecolorado.com
├── QA testing cycle
└── Bug fixes

Week 2-3: Beta Testing
├── Enable for TestFlight users
├── Collect feedback
└── Iterate on UX

Week 4: Canary (1%)
├── Enable fluids_menstruation_enabled: 1%
├── Enable fluids_bbt_enabled: 1%
├── Monitor crash rate, error rate
└── Rollback if >1% crash rate

Week 5: Limited (10%)
├── Increase to 10% if Week 4 successful
├── Enable notifications_enabled: 10%
├── Enable diet_type_enabled: 10%
└── Monitor engagement metrics

Week 6: Broad (50%)
├── Increase all flags to 50%
├── Monitor support tickets
└── Prepare for GA

Week 7: GA (100%)
├── Enable all flags 100%
├── Remove flag checks from code (cleanup)
└── Document in release notes
```

### 4.3 Rollback Procedure

```
1. Identify issue (crash rate spike, error rate, user reports)
         │
         ▼
2. Disable flag in Remote Config
   - Immediate effect for new app launches
   - Within 12 hours for background fetches
         │
         ▼
3. For critical issues:
   - Push app update with flag hardcoded off
   - Use ops flag to kill related functionality
         │
         ▼
4. Investigate root cause
         │
         ▼
5. Fix and re-test
         │
         ▼
6. Re-rollout from earlier stage
```

---

## 5. Flag Hygiene

### 5.1 Flag Lifecycle

| Phase | Duration | Action |
|-------|----------|--------|
| Created | 0 | Flag added to codebase |
| Testing | 1-4 weeks | Internal/beta testing |
| Rollout | 2-4 weeks | Gradual rollout |
| GA | - | 100% enabled |
| Cleanup | +2 weeks | Remove flag checks |
| Removed | +4 weeks | Delete flag definition |

### 5.2 Cleanup Checklist

Before removing a flag:
- [ ] Flag has been at 100% for 2+ weeks
- [ ] No rollback in last 2 weeks
- [ ] Remove all `isEnabled()` checks
- [ ] Remove flag from Remote Config
- [ ] Remove flag from `FeatureFlags` class
- [ ] Update documentation

### 5.3 Flag Inventory Review

Monthly review:
- [ ] List all active flags
- [ ] Identify flags ready for cleanup (GA > 4 weeks)
- [ ] Identify stale flags (no change in 3+ months)
- [ ] Create cleanup tasks

---

## 6. Testing with Flags

### 6.1 Unit Tests

```dart
void main() {
  group('FluidsTab', () {
    test('shows menstruation section when flag enabled', () {
      final mockFlags = MockFeatureFlagService();
      when(mockFlags.isEnabled(FeatureFlags.fluidsMenstruationEnabled))
        .thenReturn(true);

      final widget = ProviderScope(
        overrides: [featureFlagProvider.overrideWithValue(mockFlags)],
        child: FluidsTab(),
      );

      expect(find.byType(MenstruationSection), findsOneWidget);
    });

    test('hides menstruation section when flag disabled', () {
      final mockFlags = MockFeatureFlagService();
      when(mockFlags.isEnabled(FeatureFlags.fluidsMenstruationEnabled))
        .thenReturn(false);

      // ... same setup
      expect(find.byType(MenstruationSection), findsNothing);
    });
  });
}
```

### 6.2 Integration Tests

```dart
// Run tests with all flags enabled
flutter test --dart-define=FEATURE_FLAGS_ALL_ENABLED=true

// Run tests with specific flag
flutter test --dart-define=FLUIDS_MENSTRUATION_ENABLED=true
```

### 6.3 QA Test Matrix

| Scenario | Flag State | Expected |
|----------|------------|----------|
| New user, flags off | All disabled | Classic experience |
| New user, flags on | All enabled | Full new features |
| Upgrade, flags off | All disabled | No change |
| Upgrade, flags on | All enabled | New features appear |
| Flag toggled mid-session | Enabled → Disabled | Graceful hide |

---

## 7. Metrics & Monitoring

### 7.1 Flag-Specific Metrics

For each release flag, track:

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Feature usage rate | % of eligible users using feature | <10% after 2 weeks |
| Error rate delta | Errors compared to control | >2x baseline |
| Crash rate delta | Crashes compared to control | >0.1% increase |
| Session duration delta | Change in session length | >20% decrease |

### 7.2 Dashboard Requirements

```
┌────────────────────────────────────────────────────┐
│           Feature Flag Dashboard                    │
├────────────────────────────────────────────────────┤
│                                                    │
│  fluids_menstruation_enabled                       │
│  ├── Status: Rolling out (10%)                     │
│  ├── Users exposed: 1,234                          │
│  ├── Usage rate: 67%                               │
│  ├── Error rate: 0.02% (baseline: 0.01%)           │
│  └── Crash rate: 0.00%                             │
│                                                    │
│  fluids_bbt_enabled                                │
│  ├── Status: Rolling out (10%)                     │
│  ├── Users exposed: 1,234                          │
│  ├── Usage rate: 43%                               │
│  ├── Error rate: 0.01% (baseline: 0.01%)           │
│  └── Crash rate: 0.00%                             │
│                                                    │
│  [View All Flags]                                  │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 8. Remote Config Setup

### 8.1 Firebase Remote Config

```dart
// lib/core/services/remote_config_service.dart

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    // Set defaults
    await _remoteConfig.setDefaults({
      'fluids_menstruation_enabled': false,
      'fluids_bbt_enabled': false,
      'notifications_enabled': false,
      'diet_type_enabled': false,
      'sync_enabled': true,
    });

    // Fetch and activate
    await _remoteConfig.fetchAndActivate();
  }

  bool getBool(String key) => _remoteConfig.getBool(key);
}
```

### 8.2 Offline Behavior

When offline:
- Use last fetched values (cached)
- Fall back to defaults if never fetched
- Queue flag usage for analytics sync

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
