# Era 2 History — Multi-Instance Coordination Era

This document consolidates the documents written in early February 2026
when Shadow was designed for concurrent multi-instance Claude coordination.
These documents reflect that model before the current Architect + Shadow
workflow was established.

Also included: the original notification spec (37_NOTIFICATIONS.md),
which was superseded by the Phase 13 implementation spec
(now docs/specs/08_NOTIFICATION_SYSTEM.md), and the original Architect
startup handoff format, which was replaced by docs/ARCHITECT_BRIEFING.md.

---

---
## [Original: 37_NOTIFICATIONS.md]

# Shadow Notifications Specification

**Version:** 1.0
**Last Updated:** January 31, 2026
**Purpose:** Complete specification for all notification types, scheduling, and behavior

---

## 1. Overview

Shadow provides comprehensive notification support to help users maintain their health tracking routines. All notifications are:
- **Local-only** - No server required, scheduled on-device
- **Per-profile** - Each profile has independent notification settings
- **Customizable** - Times, days, and messages can be customized
- **Privacy-respecting** - No health data in notification content

---

## 2. Notification Types

### 2.1 Complete Notification Type List

> **CANONICAL SOURCE:** The `NotificationType` enum is defined authoritatively in `22_API_CONTRACTS.md` Section 3.2.
> This table documents implementation details; the enum values and names in the API contracts are the source of truth.

| Enum Value | Type ID | Category | Name | Default Message | Deep Link Target |
|------------|---------|----------|------|-----------------|------------------|
| 0 | `supplementIndividual` | Health | Supplement Reminder | "Time to take {supplement_name}" | Supplement intake screen |
| 1 | `supplementGrouped` | Health | Supplement Group | "Time to take your {time_of_day} supplements" | Supplement list |
| 2 | `mealBreakfast` | Health | Breakfast Reminder | "Don't forget to log your breakfast" | Log food screen |
| 3 | `mealLunch` | Health | Lunch Reminder | "Don't forget to log your lunch" | Log food screen |
| 4 | `mealDinner` | Health | Dinner Reminder | "Don't forget to log your dinner" | Log food screen |
| 5 | `mealSnacks` | Health | Snack Reminder | "Log your snack" | Log food screen |
| 6 | `waterInterval` | Health | Water (Interval) | "Stay hydrated! Time for water" | Fluids tab |
| 7 | `waterFixed` | Health | Water (Fixed) | "Stay hydrated! Log your water intake" | Fluids tab |
| 8 | `waterSmart` | Health | Water (Smart) | "You're behind on water - drink up!" | Fluids tab |
| 9 | `bbtMorning` | Health | BBT Reminder | "Record your basal body temperature" | Add fluids screen (BBT) |
| 10 | `menstruationTracking` | Health | Period Tracking | "Log your menstrual flow for today" | Add fluids screen |
| 11 | `sleepBedtime` | Health | Bedtime Reminder | "Time to start winding down for bed" | Add sleep screen |
| 12 | `sleepWakeup` | Health | Wake-up Check-in | "Good morning! How did you sleep?" | Add sleep screen |
| 13 | `conditionCheckIn` | Health | Condition Check-in | "How is your {condition_name} today?" | Log condition screen |
| 14 | `photoReminder` | Health | Photo Reminder | "Time to take your {area_name} photos" | Photo capture |
| 15 | `journalPrompt` | Health | Journal Prompt | "Take a moment to reflect on your day" | Add journal screen |
| 16 | `syncReminder` | System | Sync Reminder | "Your data hasn't synced in {days} days" | Sync settings |
| 17 | `fastingWindowOpen` | Diet | Eating Window Open | "Your eating window is now open" | Food tab |
| 18 | `fastingWindowClose` | Diet | Window Closing Soon | "Your eating window closes in 30 minutes" | Food tab |
| 19 | `fastingWindowClosed` | Diet | Fasting Started | "Fasting period has begun. Stay strong!" | Food tab |
| 20 | `dietStreak` | Diet | Compliance Milestone | "Amazing! {streak} days at 100% compliance!" | Diet compliance |
| 21 | `dietWeeklySummary` | Diet | Weekly Summary | "Last week: {score}% diet compliance" | Diet compliance |
| 22 | `fluidsGeneral` | Health | Fluids Reminder | "Time to update your fluids log" | Fluids tab |
| 23 | `fluidsBowel` | Health | Bowel Tracking | "Have you logged your bowel movements today?" | Add fluids screen |
| 24 | `inactivity` | System | Activity Reminder | "We haven't seen you in a while" | Home screen |

### 2.2 Notification Categories (iOS)

```swift
// iOS requires notification categories for actions
UNNotificationCategory(
  identifier: "SUPPLEMENT_REMINDER",
  actions: [
    UNNotificationAction(identifier: "TAKEN", title: "Mark as Taken"),
    UNNotificationAction(identifier: "SNOOZE", title: "Snooze 15 min"),
    UNNotificationAction(identifier: "SKIP", title: "Skip"),
  ],
  intentIdentifiers: []
)

UNNotificationCategory(
  identifier: "MEAL_REMINDER",
  actions: [
    UNNotificationAction(identifier: "LOG_NOW", title: "Log Now"),
    UNNotificationAction(identifier: "SNOOZE", title: "Remind in 30 min"),
  ],
  intentIdentifiers: []
)

UNNotificationCategory(
  identifier: "WATER_REMINDER",
  actions: [
    UNNotificationAction(identifier: "LOG_8OZ", title: "Log 8 oz"),
    UNNotificationAction(identifier: "LOG_16OZ", title: "Log 16 oz"),
    UNNotificationAction(identifier: "OPEN", title: "Open App"),
  ],
  intentIdentifiers: []
)

UNNotificationCategory(
  identifier: "FASTING_REMINDER",
  actions: [
    UNNotificationAction(identifier: "VIEW_TIMER", title: "View Timer"),
    UNNotificationAction(identifier: "END_FAST", title: "End Fast Early"),
  ],
  intentIdentifiers: []
)

UNNotificationCategory(
  identifier: "DIET_MILESTONE",
  actions: [
    UNNotificationAction(identifier: "VIEW_STATS", title: "View Stats"),
    UNNotificationAction(identifier: "SHARE", title: "Share"),
  ],
  intentIdentifiers: []
)
```

---

## 3. Notification Scheduling

### 3.1 Schedule Configuration

> **CANONICAL SOURCE:** The `NotificationType` enum is defined authoritatively in `22_API_CONTRACTS.md` Section 3.2.
> The definition below must remain synchronized with that source. Any changes to notification types
> must be made in `22_API_CONTRACTS.md` first, then propagated here.

```dart
@freezed
class NotificationSchedule with _$NotificationSchedule {
  const factory NotificationSchedule({
    required String id,
    required String clientId,
    required String profileId,
    required NotificationType type,
    String? entityId,                    // For supplement-specific, condition-specific, etc.
    required List<int> timesMinutes,     // Minutes from midnight: [480] = 8:00 AM
    required List<int> weekdays,         // 0=Monday, 6=Sunday: [0,1,2,3,4] = weekdays
    required bool isEnabled,
    String? customMessage,               // Override default message
    int? snoozeMinutes,                  // Custom snooze duration
    required SyncMetadata syncMetadata,
  }) = _NotificationSchedule;
}

/// CANONICAL: Defined in 22_API_CONTRACTS.md Section 3.2 (25 values, 0-24)
/// See that document for snooze behavior, default durations, and full documentation.
enum NotificationType {
  supplementIndividual(0),      // Individual supplement reminder
  supplementGrouped(1),         // Grouped supplement reminder (e.g., "morning supplements")
  mealBreakfast(2),             // Breakfast reminder
  mealLunch(3),                 // Lunch reminder
  mealDinner(4),                // Dinner reminder
  mealSnacks(5),                // Snacks reminder (covers morning, afternoon, evening snacks)
  waterInterval(6),             // Water reminder at intervals
  waterFixed(7),                // Water reminder at fixed times
  waterSmart(8),                // Smart water reminder based on intake vs goal
  bbtMorning(9),                // BBT morning measurement (NO SNOOZE - medical accuracy)
  menstruationTracking(10),     // Menstruation tracking reminder
  sleepBedtime(11),             // Bedtime reminder
  sleepWakeup(12),              // Wake-up/morning check-in reminder
  conditionCheckIn(13),         // Condition status check-in
  photoReminder(14),            // Photo documentation reminder
  journalPrompt(15),            // Journal entry prompt
  syncReminder(16),             // Data sync reminder
  fastingWindowOpen(17),        // Eating window begins
  fastingWindowClose(18),       // Eating window ending soon (warning)
  fastingWindowClosed(19),      // Fasting period begins (window closed)
  dietStreak(20),               // Diet compliance milestone (NO SNOOZE - informational)
  dietWeeklySummary(21),        // Weekly diet compliance summary (NO SNOOZE - informational)
  fluidsGeneral(22),            // General fluids tracking reminder
  fluidsBowel(23),              // Bowel movement tracking reminder
  inactivity(24);               // Re-engagement after extended absence (NO SNOOZE)

  final int value;
  const NotificationType(this.value);

  static NotificationType fromValue(int value) =>
    NotificationType.values.firstWhere((e) => e.value == value, orElse: () => supplementIndividual);
}
```

### 3.2 Time Selection UI

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SUPPLEMENT REMINDERS                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Vitamin D (2000 IU)                                               │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  Reminder Times:                                                    │
│                                                                     │
│  ┌────────────────────────────────────────────┐                    │
│  │  ⏰ 8:00 AM                          [✕]  │                    │
│  └────────────────────────────────────────────┘                    │
│                                                                     │
│  ┌────────────────────────────────────────────┐                    │
│  │  ⏰ 8:00 PM                          [✕]  │                    │
│  └────────────────────────────────────────────┘                    │
│                                                                     │
│                    [+ Add Another Time]                            │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  Active Days:                                                       │
│                                                                     │
│  [M]  [T]  [W]  [T]  [F]  [S]  [S]                                │
│   ●    ●    ●    ●    ●    ●    ●                                 │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  Custom Message (optional):                                         │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │ Don't forget your sunshine vitamin!                        │    │
│  └────────────────────────────────────────────────────────────┘    │
│                                                                     │
│                       [Save]  [Cancel]                              │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 3.3 Grouped Supplement Reminders

Instead of individual notifications per supplement, users can create grouped reminders:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    MORNING SUPPLEMENTS                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Group Name: Morning Supplements                                    │
│                                                                     │
│  Supplements in this group:                                         │
│  ☑ Vitamin D (2000 IU)                                             │
│  ☑ Omega-3 Fish Oil (1000 mg)                                      │
│  ☑ Probiotic (10 billion CFU)                                      │
│  ☐ Magnesium (400 mg)  ← Not in this group                         │
│                                                                     │
│  Reminder: 8:00 AM, Every day                                       │
│                                                                     │
│  Message: "Time to take your 3 morning supplements"                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 4. Meal Reminders

### 4.1 Meal Notification Types

> **API to UI Mapping:** The `NotificationType` enum has 4 meal values (storage/scheduling),
> while the UI supports 6 meal times for user convenience. The mapping is:
> - `mealBreakfast` (2) -> Breakfast
> - `mealLunch` (3) -> Lunch
> - `mealDinner` (4) -> Dinner
> - `mealSnacks` (5) -> Morning Snack, Afternoon Snack, Evening Snack (all use same type)

| NotificationType | UI Meal Times | Default Times | Message |
|------------------|---------------|---------------|---------|
| `mealBreakfast` (2) | Breakfast | 8:00 AM | "Don't forget to log your breakfast" |
| `mealLunch` (3) | Lunch | 12:30 PM | "Don't forget to log your lunch" |
| `mealDinner` (4) | Dinner | 6:30 PM | "Don't forget to log your dinner" |
| `mealSnacks` (5) | Morning Snack | 10:30 AM | "Log your snack" |
| `mealSnacks` (5) | Afternoon Snack | 3:30 PM | "Log your snack" |
| `mealSnacks` (5) | Evening Snack | 9:00 PM | "Log your snack" |

### 4.2 Meal Reminder Configuration

```dart
@freezed
class MealReminder with _$MealReminder {
  const factory MealReminder({
    required MealType mealType,          // UI-level meal type (6 values)
    required int timeMinutes,            // Minutes from midnight
    required bool isEnabled,
    required List<int> weekdays,
    String? customMessage,
  }) = _MealReminder;
}

/// UI-level meal types (6 values) for user configuration
/// When persisting, map to NotificationType:
/// - breakfast -> mealBreakfast(2)
/// - morningSnack, afternoonSnack, eveningSnack -> mealSnacks(5)
/// - lunch -> mealLunch(3)
/// - dinner -> mealDinner(4)
enum MealType {
  breakfast,
  morningSnack,
  lunch,
  afternoonSnack,
  dinner,
  eveningSnack,
}
```

### 4.3 Smart Meal Detection (Future)

System can detect when meals haven't been logged:
- If lunch time passes without food log → Send reminder 30 min after
- "Did you have lunch? Tap to log what you ate."

---

## 5. Water Intake Reminders

### 5.1 Water Reminder Modes (3 Types)

> **Three distinct notification types** handle water reminders, each with different scheduling logic.
> Users select ONE mode at a time in the UI, which determines which `NotificationType` is used.

| NotificationType | Mode | Description | Configuration |
|------------------|------|-------------|---------------|
| `waterInterval` (6) | **Interval** | Remind at regular intervals during active hours | Every 1-4 hours, within start/end time range |
| `waterFixed` (7) | **Fixed Times** | Remind at specific user-defined times | List of exact times (e.g., 8 AM, 12 PM, 3 PM, 6 PM) |
| `waterSmart` (8) | **Smart** | Dynamic reminders based on intake vs goal | Calculates next reminder based on remaining goal and time |

**Mode Behaviors:**

1. **waterInterval (6)** - Fixed interval between reminders
   - User sets interval (1, 2, 3, or 4 hours)
   - User sets active hours window (e.g., 7 AM - 9 PM)
   - Reminders fire every X hours within the window
   - Example: Every 2 hours from 8 AM-8 PM = 6 reminders/day

2. **waterFixed (7)** - Specific times only
   - User specifies exact times: [480, 720, 900, 1080] (8am, 12pm, 3pm, 6pm)
   - No calculation; fires at listed times only
   - Useful for aligning with meals or breaks

3. **waterSmart (8)** - Goal-aware dynamic reminders
   - Calculates next reminder based on: daily goal, consumed today, time remaining
   - Formula: `nextInterval = max(30, remainingMinutes / glassesRemaining)`
   - Reminds more frequently if behind on goal, less if ahead
   - See Section 5.3 for full algorithm

### 5.2 Interval Configuration

```
┌─────────────────────────────────────────────────────────────────────┐
│                    WATER REMINDERS                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ☑ Enable water reminders                                          │
│                                                                     │
│  Reminder Style:                                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  ○ Fixed times                                               │  │
│  │  ● Interval (every X hours)                                  │  │
│  │  ○ Smart (based on progress)                                 │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  Remind every: [2] hours                                            │
│                                                                     │
│  Active hours:                                                      │
│  Start: [7:00 AM]  End: [9:00 PM]                                  │
│                                                                     │
│  Daily Goal: [64] fl oz                                             │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  Quick Actions in Notification:                                     │
│  ☑ Show "Log 8 oz" button                                          │
│  ☑ Show "Log 16 oz" button                                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 5.3 Smart Water Reminders

```dart
class SmartWaterReminderService {
  /// Calculate when to send next water reminder based on progress
  DateTime? calculateNextReminder({
    required int dailyGoalMl,
    required int consumedTodayMl,
    required DateTime now,
    required TimeOfDay activeStart,  // 7:00 AM
    required TimeOfDay activeEnd,    // 9:00 PM
  }) {
    final remainingMl = dailyGoalMl - consumedTodayMl;
    if (remainingMl <= 0) return null; // Goal met

    final activeEndTime = DateTime(now.year, now.month, now.day,
        activeEnd.hour, activeEnd.minute);
    final remainingMinutes = activeEndTime.difference(now).inMinutes;

    if (remainingMinutes <= 0) return null; // Past active hours

    // Calculate how often to remind to hit goal
    final glassesRemaining = (remainingMl / 237).ceil(); // 237ml = 8oz
    final intervalMinutes = remainingMinutes ~/ glassesRemaining;

    // Minimum 30 min between reminders
    final adjustedInterval = max(30, intervalMinutes);

    return now.add(Duration(minutes: adjustedInterval));
  }
}
```

### Smart Water Reminder Calculation

remainingMl = dailyGoal - consumedToday
remainingMinutes = activeEndTime - now
glassesRemaining = ceil(remainingMl / 237)  // 237mL = 8oz
rawInterval = remainingMinutes / glassesRemaining
interval = clamp(rawInterval, 30, 120)  // min 30min, max 120min

If remainingMinutes < 30: Do NOT schedule (would fire after active hours)

### 5.4 Smart Water Reminder Formula

The smart water reminder calculates optimal reminder intervals to help users meet their daily hydration goal.

**Exact Formula:**
```dart
/// Calculate the interval between water reminders
int calculateSmartWaterInterval({
  required int remainingMl,      // Water remaining to reach goal
  required int remainingMinutes, // Minutes until active hours end
}) {
  // Step 1: Calculate glasses remaining (8oz = 237ml per glass)
  final glassesRemaining = (remainingMl / 237).ceil();

  // Step 2: Calculate raw interval
  final intervalMinutes = remainingMinutes ~/ glassesRemaining;

  // Step 3: Clamp to 30-120 minute range
  final clampedInterval = max(30, min(intervalMinutes, 120));

  return clampedInterval;
}
```

**Formula Summary:**
```
glassesRemaining = ceil(remainingMl / 237)
intervalMinutes = remainingMinutes ~/ glassesRemaining  // integer division
clampedInterval = max(30, min(intervalMinutes, 120))    // 30-120 min range
```

**Interval Clamping Rationale:**
- **Minimum 30 minutes:** Prevents notification spam; gives user time to drink and log
- **Maximum 120 minutes:** Ensures at least some reminders even if user is on track

**Example Calculations:**

| Scenario | Remaining | Time Left | Glasses | Raw Interval | Clamped |
|----------|-----------|-----------|---------|--------------|---------|
| Behind on goal | 1422ml (48oz) | 240 min | 7 | 34 min | 34 min |
| Very behind | 1896ml (64oz) | 180 min | 8 | 22 min | **30 min** |
| On track | 474ml (16oz) | 300 min | 2 | 150 min | **120 min** |
| Almost done | 237ml (8oz) | 120 min | 1 | 120 min | 120 min |
| Goal met | 0ml | 180 min | 0 | N/A | No reminder |

**Active Hours Consideration:**
- Reminders only fire during user-configured active hours (default: 7 AM - 9 PM)
- `remainingMinutes` is calculated as minutes until `activeEnd` time
- If current time is past `activeEnd`, no reminders are scheduled until next day

---

## 6. BBT (Basal Body Temperature) Reminders

### 6.1 Timing Requirements

BBT must be taken:
- Immediately upon waking
- Before getting out of bed
- At approximately the same time daily (±30 minutes)

### 6.2 BBT Reminder Configuration

```
┌─────────────────────────────────────────────────────────────────────┐
│                    BBT REMINDER                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ☑ Enable BBT reminder                                             │
│                                                                     │
│  Wake-up time: [6:30 AM]                                           │
│                                                                     │
│  Reminder: [At wake-up time ▼]                                     │
│    • At wake-up time                                               │
│    • 5 minutes before                                              │
│    • Custom time                                                   │
│                                                                     │
│  Active days:                                                       │
│  [M]  [T]  [W]  [T]  [F]  [S]  [S]                                │
│   ●    ●    ●    ●    ●    ●    ●                                 │
│                                                                     │
│  Notification sound: [Gentle Chime ▼]                              │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  ⓘ BBT is most accurate when taken immediately upon waking,        │
│    before getting out of bed or drinking anything.                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.3 BBT Notification Behavior

- **High priority** - Should wake device screen if possible
- **No snooze** - BBT timing is critical; snoozing defeats purpose
- **Quick action** - "Record Now" opens directly to BBT input
- **Persistent** - Remains until dismissed or temperature recorded

### BBT Notification Actions

BBT notifications have special handling:
- Actions: "Record Now", "Dismiss" ONLY
- NO snooze action available (timing critical)
- If dismissed without recording, reminder reappears in 15 minutes (max 3 times)

### 6.4 BBT Reminder Notification Specification

**Notification Content:**
```dart
const bbtNotification = NotificationContent(
  title: "BBT Reminder",
  body: "BBT timing is critical - record within 30 minutes of waking",
  category: "BBT_REMINDER",
);
```

**Available Actions (NO Snooze):**
```swift
// iOS Notification Category
UNNotificationCategory(
  identifier: "BBT_REMINDER",
  actions: [
    UNNotificationAction(
      identifier: "RECORD_NOW",
      title: "Record Now",
      options: [.foreground]  // Opens app to BBT input
    ),
    UNNotificationAction(
      identifier: "DISMISS",
      title: "Dismiss",
      options: [.destructive]  // Clears notification
    ),
    // NOTE: NO "Snooze" action - intentionally omitted
  ],
  intentIdentifiers: [],
  options: [.customDismissAction]
)
```

```dart
// Android Notification Actions
const bbtActions = [
  AndroidNotificationAction(
    'RECORD_NOW',
    'Record Now',
    showsUserInterface: true,
    cancelNotification: true,
  ),
  AndroidNotificationAction(
    'DISMISS',
    'Dismiss',
    cancelNotification: true,
  ),
  // NOTE: NO "Snooze" action - intentionally omitted
];
```

**Rationale for No Snooze:**
- BBT must be taken immediately upon waking, before any activity
- A snoozed reminder would fire after the user has already gotten up
- Temperature taken after getting up is medically invalid for cycle tracking
- Users who want to skip should use "Dismiss" explicitly

**Notification Persistence:**
- Notification remains visible until explicitly dismissed or BBT is recorded
- If user records BBT through app (not via notification), notification auto-clears
- Auto-expires after 2 hours (if still not acted upon, measurement window passed)

---

## 7. Sleep Reminders

### 7.1 Bedtime Reminder

| Setting | Default | Description |
|---------|---------|-------------|
| Reminder time | 30 min before bedtime | Configurable: 15, 30, 45, 60 min |
| Message | "Time to start winding down" | Customizable |
| Action | Opens sleep entry for tomorrow | Pre-fills date |

### 7.2 Wake-up Reminder

| Setting | Default | Description |
|---------|---------|-------------|
| Reminder time | 5 min after wake time | Configurable: 0, 5, 15, 30 min |
| Message | "Good morning! How did you sleep?" | Customizable |
| Action | Opens sleep entry for last night | Pre-fills bed/wake times |

### 7.3 Sleep Schedule Configuration

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SLEEP REMINDERS                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  BEDTIME                                                            │
│  ─────────────────────────────────────────────────────────────────  │
│  ☑ Enable bedtime reminder                                         │
│                                                                     │
│  Target bedtime: [10:30 PM]                                        │
│  Remind me: [30 minutes before ▼]                                  │
│                                                                     │
│  Days: [M] [T] [W] [T] [F] [S] [S]                                 │
│         ●   ●   ●   ●   ●   ○   ○                                  │
│                                                                     │
│  WAKE-UP                                                            │
│  ─────────────────────────────────────────────────────────────────  │
│  ☑ Enable wake-up reminder                                         │
│                                                                     │
│  Target wake time: [6:30 AM]                                       │
│  Remind me: [5 minutes after ▼]                                    │
│                                                                     │
│  Days: [M] [T] [W] [T] [F] [S] [S]                                 │
│         ●   ●   ●   ●   ●   ○   ○                                  │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  WEEKEND SCHEDULE (Optional)                                        │
│  ☑ Use different times on weekends                                 │
│                                                                     │
│  Weekend bedtime: [11:30 PM]                                       │
│  Weekend wake time: [8:00 AM]                                      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 8. Condition Check-in Reminders

### 8.1 Condition-Specific Reminders

For each active condition, users can set check-in reminders:

```dart
@freezed
class ConditionReminder with _$ConditionReminder {
  const factory ConditionReminder({
    required String conditionId,
    required String conditionName,
    required int timeMinutes,          // When to remind
    required List<int> weekdays,
    required bool isEnabled,
    String? customPrompt,              // "How is your eczema today?"
  }) = _ConditionReminder;
}
```

### 8.2 Configuration UI

```
┌─────────────────────────────────────────────────────────────────────┐
│                    CONDITION REMINDERS                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Set daily check-in reminders for your conditions:                  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Eczema (Active)                                            │   │
│  │  ☑ Daily reminder at 8:00 PM                                │   │
│  │  "How is your eczema today? Log severity and any triggers." │   │
│  │                                            [Edit] [Remove]  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Allergies (Active)                                         │   │
│  │  ☑ Daily reminder at 9:00 AM                                │   │
│  │  "Any allergy symptoms today?"                              │   │
│  │                                            [Edit] [Remove]  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│                    [+ Add Condition Reminder]                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 9. Photo Reminders

### 9.1 Photo Schedule Types

| Type | Description | Example |
|------|-------------|---------|
| **Daily** | Same time every day | Daily wound healing photos |
| **Weekly** | Specific day of week | Weekly progress photos on Sunday |
| **Custom interval** | Every X days | Every 3 days for condition tracking |

### 9.2 Photo Reminder Configuration

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PHOTO REMINDERS                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Photo Area: Left Arm Eczema                                        │
│                                                                     │
│  Frequency: [Weekly ▼]                                             │
│    • Daily                                                          │
│    • Weekly                                                         │
│    • Every X days                                                   │
│                                                                     │
│  Day: [Sunday ▼]                                                   │
│  Time: [9:00 AM]                                                   │
│                                                                     │
│  Message: "Time to take your weekly arm photos for comparison"     │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  ⓘ Consistent lighting and positioning help with comparison.       │
│    Try to take photos in the same location each time.              │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 10. Notification Actions

### 10.1 Action Types

| Action | Effect | Available On |
|--------|--------|--------------|
| **Open App** | Opens to relevant screen | All |
| **Mark as Taken** | Logs supplement intake | Supplement |
| **Snooze** | Reschedules reminder | Supplement, Meal, Water |
| **Skip** | Marks as skipped | Supplement |
| **Log Quick** | Quick-add preset amount | Water |
| **Dismiss** | Clears notification | All |

### 10.2 Snooze Durations

| Type | Default Snooze | Options |
|------|----------------|---------|
| Supplement | 15 min | 5, 10, 15, 30, 60 min |
| Meal | 30 min | 15, 30, 60, 120 min |
| Water | 30 min | 15, 30, 60 min |
| General | 60 min | 30, 60, 120 min |

### 10.3 Action Implementation

```dart
// lib/core/services/notification_action_service.dart

class NotificationActionService {
  Future<void> handleAction({
    required String actionId,
    required String notificationId,
    required Map<String, dynamic> payload,
  }) async {
    switch (actionId) {
      case 'TAKEN':
        await _handleSupplementTaken(payload);
        break;
      case 'SNOOZE':
        await _handleSnooze(payload);
        break;
      case 'SKIP':
        await _handleSupplementSkipped(payload);
        break;
      case 'LOG_8OZ':
        await _handleQuickWaterLog(237, payload); // 8oz = 237ml
        break;
      case 'LOG_16OZ':
        await _handleQuickWaterLog(473, payload); // 16oz = 473ml
        break;
      case 'LOG_NOW':
        await _openScreen(payload['deepLink']);
        break;
    }
  }

  Future<void> _handleSupplementTaken(Map<String, dynamic> payload) async {
    final supplementId = payload['supplementId'] as String;
    final scheduledTime = DateTime.parse(payload['scheduledTime']);

    await _intakeLogRepository.create(IntakeLog(
      supplementId: supplementId,
      scheduledTime: scheduledTime,
      actualTime: DateTime.now(),
      status: IntakeStatus.taken,
    ));

    // Show confirmation
    await _localNotifications.show(
      title: 'Logged!',
      body: 'Supplement marked as taken',
      category: 'CONFIRMATION',
    );
  }

  Future<void> _handleSnooze(Map<String, dynamic> payload) async {
    final snoozeMinutes = payload['snoozeMinutes'] as int? ?? 15;
    final newTime = DateTime.now().add(Duration(minutes: snoozeMinutes));

    await _notificationService.scheduleNotification(
      id: '${payload['notificationId']}_snoozed',
      title: payload['title'],
      body: payload['body'],
      scheduledTime: newTime,
      payload: payload,
    );
  }
}
```

---

## 11. Notification Delivery

### 11.1 Platform Configuration

**Android (AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>

<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
  <intent-filter>
    <action android:name="android.intent.action.BOOT_COMPLETED"/>
    <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
  </intent-filter>
</receiver>
```

**iOS (Info.plist):**
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

### 11.2 Notification Channels (Android)

```dart
const List<AndroidNotificationChannel> channels = [
  AndroidNotificationChannel(
    id: 'supplements',
    name: 'Supplement Reminders',
    description: 'Reminders to take your supplements',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  ),
  AndroidNotificationChannel(
    id: 'meals',
    name: 'Meal Reminders',
    description: 'Reminders to log your meals',
    importance: Importance.defaultImportance,
    playSound: true,
  ),
  AndroidNotificationChannel(
    id: 'water',
    name: 'Water Reminders',
    description: 'Reminders to stay hydrated',
    importance: Importance.low,
    playSound: false,
  ),
  AndroidNotificationChannel(
    id: 'health',
    name: 'Health Reminders',
    description: 'General health tracking reminders',
    importance: Importance.defaultImportance,
  ),
  AndroidNotificationChannel(
    id: 'sleep',
    name: 'Sleep Reminders',
    description: 'Bedtime and wake-up reminders',
    importance: Importance.high,
    playSound: true,
  ),
];
```

### 11.3 Permission Request Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  [Shadow Logo]                                                      │
│                                                                     │
│  Enable Notifications?                                              │
│                                                                     │
│  Shadow can remind you to:                                          │
│  • Take your supplements on time                                   │
│  • Log your meals and water intake                                 │
│  • Track your health conditions                                    │
│  • Maintain your sleep schedule                                    │
│                                                                     │
│  You can customize which reminders you receive                     │
│  in Settings.                                                       │
│                                                                     │
│           [Not Now]              [Enable Notifications]            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 12. Do Not Disturb Handling

### 12.1 DND Respect Settings

```dart
@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    required bool respectSystemDND,        // Honor system Do Not Disturb
    required bool enableQuietHours,        // App-level quiet hours
    TimeOfDay? quietHoursStart,            // e.g., 10:00 PM
    TimeOfDay? quietHoursEnd,              // e.g., 7:00 AM
    required bool allowCriticalDuringQuiet, // BBT, urgent reminders
  }) = _NotificationSettings;
}
```

### 12.2 Quiet Hours Configuration

```
┌─────────────────────────────────────────────────────────────────────┐
│                    QUIET HOURS                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ☑ Enable quiet hours                                              │
│                                                                     │
│  Start: [10:00 PM]                                                 │
│  End:   [7:00 AM]                                                  │
│                                                                     │
│  During quiet hours:                                                │
│  ☐ Deliver all notifications silently                              │
│  ● Hold notifications until quiet hours end                        │
│                                                                     │
│  Exceptions (always notify):                                        │
│  ☑ BBT reminder (time-sensitive)                                   │
│  ☐ Supplement reminders                                            │
│  ☐ Bedtime reminders                                               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Quiet Hours Behavior

When notification scheduled during quiet hours:
1. BBT notifications: DELIVER IMMEDIATELY (time-critical exception)
2. All other notifications: QUEUE until quiet hours end
3. Queued notifications delivered at quiet hours end time in original scheduled order
4. Maximum queue: 50 notifications; oldest dropped if exceeded

### 12.3 Quiet Hours Exception Handling

The following logic determines whether a notification bypasses quiet hours:

```dart
class QuietHoursService {
  /// Determine if notification should be delivered during quiet hours
  bool shouldBypassQuietHours({
    required NotificationType type,
    required NotificationSettings settings,
  }) {
    // If quiet hours not enabled, always deliver
    if (!settings.enableQuietHours) return true;

    // If outside quiet hours, always deliver
    if (!_isCurrentlyQuietHours(settings)) return true;

    // Check type-specific exceptions
    if (!settings.allowCriticalDuringQuiet) return false;

    // These types ALWAYS bypass quiet hours when allowCriticalDuringQuiet is true:
    return switch (type) {
      NotificationType.bbtMorning => true,      // Time-sensitive (must be taken at same time daily)
      _ => false,                               // All other types respect quiet hours
    };
  }

  /// Determine what happens to non-bypassed notifications during quiet hours
  QuietHoursAction getQuietHoursAction(NotificationSettings settings) {
    // Based on user preference in UI ("During quiet hours:")
    return settings.quietHoursMode;  // silentDelivery or holdUntilEnd
  }

  bool _isCurrentlyQuietHours(NotificationSettings settings) {
    final now = TimeOfDay.now();
    final start = settings.quietHoursStart;
    final end = settings.quietHoursEnd;

    if (start == null || end == null) return false;

    // Handle overnight quiet hours (e.g., 10PM - 7AM)
    if (start.hour > end.hour || (start.hour == end.hour && start.minute > end.minute)) {
      // Overnight: quiet if AFTER start OR BEFORE end
      return _isTimeAfterOrEqual(now, start) || _isTimeBefore(now, end);
    } else {
      // Same day: quiet if AFTER start AND BEFORE end
      return _isTimeAfterOrEqual(now, start) && _isTimeBefore(now, end);
    }
  }
}

enum QuietHoursMode {
  silentDelivery,    // Deliver silently (no sound/vibration)
  holdUntilEnd,      // Queue and deliver when quiet hours end
}
```

**Exception Behavior by Notification Type:**

| Type | Can Bypass Quiet Hours | Rationale |
|------|------------------------|-----------|
| `bbtMorning` | ✅ Yes (when enabled) | Medical accuracy requires same-time measurement |
| `supplement` | ⚙️ User configurable | Some supplements are time-critical |
| `sleepBedtime` | ⚙️ User configurable | By definition occurs during typical quiet hours |
| `sleepWakeup` | ⚙️ User configurable | By definition occurs near quiet hours end |
| `fastingWindowOpen` | ❌ No | Can wait until quiet hours end |
| `fastingWindowClose` | ❌ No | Can wait until quiet hours end |
| All others | ❌ No | Not time-critical |

**Held Notification Behavior:**

When `holdUntilEnd` is selected:
1. Notifications are queued in local database
2. When quiet hours end, queued notifications are delivered in sequence (oldest first)
3. If multiple of same type are queued, they are collapsed into one summary notification
4. Held notifications older than 24 hours are discarded (they're stale)

### 12.4 Quiet Hours Behavior by Notification Priority

Notifications are categorized into three priority levels with distinct quiet hours behavior:

| Priority | Notification Types | Quiet Hours Behavior |
|----------|-------------------|---------------------|
| **Critical** | BBT reminder (`bbtMorning`) | Deliver immediately, bypass quiet hours |
| **Time-Sensitive** | Supplements, Fasting window alerts | Queue, deliver when quiet hours end |
| **Non-Critical** | Water, Meals, Journal, Conditions, Photos | Queue, deliver after quiet hours |

**Critical Notifications (Bypass Quiet Hours):**
```dart
/// Critical notifications are delivered immediately regardless of quiet hours
/// because missing them defeats their medical/health purpose.
///
/// Currently only BBT qualifies as critical:
/// - BBT must be taken at consistent time for accurate cycle tracking
/// - A delayed reminder renders the measurement invalid
/// - User explicitly opted into BBT tracking knowing timing requirements

final criticalTypes = {
  NotificationType.bbtMorning,
};

bool isCriticalNotification(NotificationType type) {
  return criticalTypes.contains(type);
}
```

**Time-Sensitive Notifications (Queue Until End):**
```dart
/// Time-sensitive notifications are important but can wait until quiet hours end.
/// They are delivered immediately when quiet hours end, in priority order.

final timeSensitiveTypes = {
  NotificationType.supplementIndividual,
  NotificationType.supplementGrouped,
  NotificationType.fastingWindowOpen,
  NotificationType.fastingWindowClose,
  NotificationType.fastingWindowClosed,
  NotificationType.sleepBedtime,
};
```

**Non-Critical Notifications (Queue, Batch Deliver):**
```dart
/// Non-critical notifications can be batched and delivered after quiet hours.
/// Multiple notifications of same type are collapsed into summary.

final nonCriticalTypes = {
  NotificationType.waterInterval,
  NotificationType.waterFixed,
  NotificationType.waterSmart,
  NotificationType.mealBreakfast,
  NotificationType.mealLunch,
  NotificationType.mealDinner,
  NotificationType.mealSnacks,
  NotificationType.journalPrompt,
  NotificationType.conditionCheckIn,
  NotificationType.photoReminder,
  NotificationType.fluidsGeneral,
  NotificationType.fluidsBowel,
  NotificationType.syncReminder,
  NotificationType.dietStreak,
  NotificationType.dietWeeklySummary,
};
```

---

## 13. Notification History & Analytics

### 13.1 Tracking Metrics

| Metric | Description | Use |
|--------|-------------|-----|
| Delivered | Notification successfully shown | Verify delivery |
| Opened | User tapped notification | Engagement |
| Action Taken | User used quick action | Feature usage |
| Dismissed | User dismissed without action | Optimize timing |
| Snoozed | User requested later reminder | Adjust schedule |

### 13.2 Analytics Events

```dart
void trackNotificationEvent({
  required String notificationId,
  required NotificationType type,
  required NotificationEvent event,
  Map<String, dynamic>? metadata,
}) {
  // Store locally for compliance (no external analytics)
  _analyticsRepository.log(NotificationAnalyticsEntry(
    notificationId: notificationId,
    type: type,
    event: event,
    timestamp: DateTime.now(),
    metadata: metadata,
  ));
}

enum NotificationEvent {
  scheduled,
  delivered,
  opened,
  actionTaken,
  dismissed,
  snoozed,
  expired,
}
```

### 13.3 Sync Reminder Specification

The sync reminder notifies users when their data hasn't been synchronized for an extended period.

**Trigger Condition:**
```dart
/// Sync reminder triggers when:
/// last_successful_sync < NOW - 3 DAYS (72 hours)

bool shouldShowSyncReminder({
  required DateTime? lastSuccessfulSync,
  required DateTime now,
}) {
  if (lastSuccessfulSync == null) {
    // Never synced - show reminder after 24 hours of first use
    return true;
  }

  final daysSinceSync = now.difference(lastSuccessfulSync).inDays;
  return daysSinceSync >= 3;
}
```

**Timer Reset Behavior:**
```dart
/// The sync reminder timer ONLY resets on successful sync completion.
/// Failed syncs, partial syncs, or sync attempts do NOT reset the timer.

void onSyncCompleted(SyncResult result) {
  if (result.status == SyncStatus.success) {
    // Reset the timer - update last_successful_sync
    _preferences.setLastSuccessfulSync(DateTime.now());

    // Cancel any pending sync reminder notifications
    _notificationService.cancel(NotificationType.syncReminder);
  }
  // Failed syncs do NOT reset the timer
}
```

**Check Schedule:**
```dart
/// Sync reminder check runs daily at 8:00 AM local time.
/// This is implemented via WorkManager (Android) / BGTaskScheduler (iOS).

const syncReminderCheckTime = TimeOfDay(hour: 8, minute: 0);

void scheduleDailySyncCheck() {
  // Schedule daily background task at 8:00 AM
  _workManager.registerPeriodicTask(
    'sync_reminder_check',
    'checkSyncReminder',
    frequency: Duration(days: 1),
    initialDelay: _calculateDelayUntil8AM(),
    constraints: Constraints(
      networkType: NetworkType.not_required,
    ),
  );
}
```

**Notification Content:**
```dart
const syncReminderNotification = NotificationContent(
  title: "Sync Reminder",
  body: "Your data hasn't synced in 3 days. Tap to sync now.",
  category: "SYNC_REMINDER",
);
```

**Specification Summary:**
| Parameter | Value |
|-----------|-------|
| Trigger threshold | 3 days (72 hours) since last successful sync |
| Timer reset | Only on successful sync completion |
| Check schedule | Daily at 8:00 AM local time |
| Deep link | Opens sync settings screen |

### 13.4 Notification History Retention

Notification history is stored locally and follows a rolling retention policy.

**Storage Location:**
```dart
/// Notification history is LOCAL ONLY.
/// It is NOT synced to cloud storage for privacy reasons.
/// Each device maintains its own notification history independently.

const notificationHistoryStorage = StorageLocation.localOnly;
```

**Retention Policy:**
```dart
/// Rolling 90-day retention window.
/// Notifications older than 90 days are automatically purged.

const notificationHistoryRetentionDays = 90;

void purgeOldNotificationHistory() {
  final cutoffDate = DateTime.now().subtract(Duration(days: 90));

  _database.delete(
    'notification_history',
    where: 'scheduled_time < ?',
    whereArgs: [cutoffDate.millisecondsSinceEpoch],
  );
}
```

**Purge Schedule:**
- Runs automatically on app launch (if last purge > 24 hours ago)
- Runs as part of daily maintenance background task
- Does not require user action

**Specification Summary:**
| Parameter | Value |
|-----------|-------|
| Storage location | Local device only (not synced to cloud) |
| Retention period | 90 days rolling window |
| Purge trigger | App launch or daily maintenance |
| Privacy | History never leaves device |

---

## 14. Database Schema

### 14.1 notification_schedules Table

```sql
CREATE TABLE notification_schedules (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  type INTEGER NOT NULL,                  -- NotificationType enum
  entity_id TEXT,                         -- supplement_id, condition_id, etc.
  times_minutes TEXT NOT NULL,            -- JSON: [480, 1200] (8am, 8pm)
  weekdays TEXT NOT NULL,                 -- JSON: [0,1,2,3,4,5,6]
  is_enabled INTEGER NOT NULL DEFAULT 1,
  custom_message TEXT,
  snooze_minutes INTEGER DEFAULT 15,

  -- Sync metadata
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

CREATE INDEX idx_notification_schedules_profile ON notification_schedules(profile_id, type);
CREATE INDEX idx_notification_schedules_enabled ON notification_schedules(profile_id, is_enabled)
  WHERE sync_deleted_at IS NULL AND is_enabled = 1;
CREATE INDEX idx_notification_schedules_entity ON notification_schedules(entity_id)
  WHERE entity_id IS NOT NULL;
```

### 14.2 notification_history Table

```sql
CREATE TABLE notification_history (
  id TEXT PRIMARY KEY,
  profile_id TEXT NOT NULL,
  schedule_id TEXT,                       -- References notification_schedules
  type INTEGER NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  scheduled_time INTEGER NOT NULL,
  delivered_time INTEGER,
  opened_time INTEGER,
  action_taken TEXT,                      -- 'TAKEN', 'SNOOZE', 'SKIP', etc.
  dismissed_time INTEGER,

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (schedule_id) REFERENCES notification_schedules(id)
);

CREATE INDEX idx_notification_history_profile ON notification_history(profile_id, scheduled_time DESC);
CREATE INDEX idx_notification_history_schedule ON notification_history(schedule_id, scheduled_time DESC);
```

---

## 15. Entity Mapping Reference

### 15.1 Notification Types to Data Entry Screens

This section clarifies how notification types map to the underlying data entities and entry screens.

| NotificationType | Target Entity | Target Table | Deep Link |
|------------------|---------------|--------------|-----------|
| `supplementIndividual` (0) | SupplementIntakeLog | supplement_intake_logs | shadow://supplement/{id}/log |
| `supplementGrouped` (1) | SupplementIntakeLog | supplement_intake_logs | shadow://supplements |
| `mealBreakfast/Lunch/Dinner/Snacks` (2-5) | FoodLog | food_logs | shadow://food/log |
| `waterInterval/Fixed/Smart` (6-8) | FluidsEntry | fluids_entries | shadow://fluids/water |
| `bbtMorning` (9) | FluidsEntry | fluids_entries | shadow://fluids/bbt |
| `menstruationTracking` (10) | FluidsEntry | fluids_entries | shadow://fluids/menstruation |
| `sleepBedtime/Wakeup` (11-12) | SleepEntry | sleep_entries | shadow://sleep/log |
| `conditionCheckIn` (13) | ConditionLog | condition_logs | shadow://condition/{id}/log |
| `photoReminder` (14) | PhotoEntry | photo_entries | shadow://photos/capture |
| `journalPrompt` (15) | JournalEntry | journal_entries | shadow://journal/add |
| `syncReminder` (16) | N/A (system) | N/A | shadow://settings/sync |
| `fastingWindowOpen/Close/Closed` (17-19) | FoodLog | food_logs | shadow://food |
| `dietStreak/WeeklySummary` (20-21) | N/A (informational) | N/A | shadow://diet/compliance |
| `fluidsGeneral` (22) | FluidsEntry | fluids_entries | shadow://fluids |
| `fluidsBowel` (23) | FluidsEntry | fluids_entries | shadow://fluids/bowel |
| `inactivity` (24) | N/A (re-engagement) | N/A | shadow://home |

### 15.2 FluidsEntry Column Mapping

> **Single Table Design:** The `fluids_entries` table uses a single-row-per-entry design with multiple
> nullable column groups. Different notification types lead to different columns being populated.

| NotificationType | FluidsEntry Columns Used |
|------------------|-------------------------|
| `waterInterval/Fixed/Smart` (6-8) | `water_ml`, `water_notes` |
| `bbtMorning` (9) | `basal_body_temperature`, `bbt_recorded_time` |
| `menstruationTracking` (10) | `menstruation_flow` |
| `fluidsGeneral` (22) | Any/all columns (user choice) |
| `fluidsBowel` (23) | `bowel_condition`, `bowel_size`, `bowel_photo_path` |

**FluidsEntry Column Groups:**

```
fluids_entries
├── Water: water_ml, water_notes
├── Bowel: bowel_condition, bowel_size, bowel_photo_path, has_bowel_movement
├── Urine: urine_condition, urine_size, urine_photo_path, has_urine_movement
├── Menstruation: menstruation_flow
├── BBT: basal_body_temperature, bbt_recorded_time
├── Other: other_fluid_name, other_fluid_amount, other_fluid_notes
└── Sync: sync_* columns
```

A single `FluidsEntry` row can contain data from multiple groups (e.g., water AND bowel in same entry),
though notifications typically prompt for one type at a time.

See `22_API_CONTRACTS.md` Section 13.3 for the complete FluidsEntry entity-to-database mapping.

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release - comprehensive notification specification |
| 1.1 | 2026-02-02 | Aligned NotificationType enum with canonical source (22_API_CONTRACTS.md); Updated meal types to use 4 API values with 6 UI mappings; Documented 3 water notification modes; Added FluidsEntry mapping reference |

---
## [Original: 52_INSTANCE_COORDINATION_PROTOCOL.md]

# Shadow Instance Coordination Protocol

**Version:** 1.0
**Last Updated:** February 2, 2026
**Purpose:** Coordination protocol for stateless Claude instances working on Shadow codebase

---

## CRITICAL: You Are a Stateless Agent

**READ THIS FIRST BEFORE ANY WORK.**

You are one of 1000+ independent Claude instances working on this codebase. You have:
- **NO memory** of what previous instances decided
- **NO memory** of other concurrent instances' work
- **NO communication channel** to other instances except through files

The ONLY way instances communicate is through:
1. **Committed code** - Code in the repository
2. **Specification documents** - These markdown files
3. **Test results** - Automated tests that verify compliance
4. **Work status files** - `.claude/work-status/` directory

---

## 1. Instance Startup Protocol

**EVERY instance MUST execute this protocol before doing ANY work.**

### 1.1 Compliance Verification (MANDATORY)

Before writing any code, run this verification:

```bash
# Step 1: Run the specification compliance test
dart run scripts/verify_spec_compliance.dart

# Expected output: "COMPLIANT: 0 errors, 0 warnings"
# If errors: DO NOT PROCEED. Fix errors first or report to user.
```

### 1.2 Previous Work Verification

Check if previous instances left incomplete work:

```bash
# Read the work status file
cat .claude/work-status/current.json
```

The status file contains:
```json
{
  "lastInstanceId": "abc123",
  "lastAction": "implementing",
  "taskId": "SHADOW-042",
  "status": "in_progress|complete|blocked|failed",
  "timestamp": "2026-02-02T10:30:00Z",
  "filesModified": ["lib/domain/entities/fluids_entry.dart"],
  "testsStatus": "passing|failing|not_run",
  "complianceStatus": "verified|unverified|failed",
  "notes": "Completed entity, starting repository"
}
```

### 1.3 Decision Tree

```
IF status == "in_progress" AND testsStatus == "failing":
    → Previous instance left broken code
    → Run tests, identify failures, fix them
    → Update status to "complete" or document why blocked

IF status == "in_progress" AND testsStatus == "passing":
    → Previous instance's work was interrupted mid-task
    → Review filesModified to understand context
    → Continue the task from where they stopped

IF status == "complete":
    → Previous task done
    → Pick next task from 34_PROJECT_TRACKER.md
    → Update status file with new task

IF status == "blocked":
    → Read notes for blocking reason
    → If you can resolve: do so
    → If not: pick alternate task, leave status as blocked

IF status == "failed":
    → Read notes for failure reason
    → Attempt to resolve
    → If unresolvable: escalate to user
```

---

## 2. Work Status File Protocol

### 2.1 Starting Work

Before making ANY changes, update the status file:

```json
{
  "lastInstanceId": "<generate-uuid>",
  "lastAction": "starting",
  "taskId": "SHADOW-042",
  "status": "in_progress",
  "timestamp": "<current-iso-timestamp>",
  "filesModified": [],
  "testsStatus": "not_run",
  "complianceStatus": "verified",
  "notes": "Starting implementation of FluidsEntry entity per 22_API_CONTRACTS.md Section 5"
}
```

### 2.2 During Work

Update after each significant milestone:

```json
{
  "lastAction": "implementing",
  "filesModified": ["lib/domain/entities/fluids_entry.dart"],
  "notes": "Entity created, all required fields present. Starting repository interface."
}
```

### 2.3 Completing Work

BEFORE telling user work is complete:

1. Run all tests
2. Run compliance verification
3. Update status file:

```json
{
  "lastAction": "completed",
  "status": "complete",
  "testsStatus": "passing",
  "complianceStatus": "verified",
  "notes": "FluidsEntry entity and repository complete. All tests passing. Verified against 22_API_CONTRACTS.md Section 5."
}
```

### 2.4 Blocked or Failed

If you cannot complete:

```json
{
  "status": "blocked",
  "notes": "Blocked: API Contract Section 5.3 missing waterIntakeMl validation rules. Cannot proceed without spec clarification."
}
```

---

## 3. Compliance Testing Loop

### 3.1 The Compliance Test

Every instance MUST verify its work complies with coding standards.

Create/update `scripts/verify_spec_compliance.dart`:

```dart
/// Specification Compliance Verifier
/// Run before completing ANY task
///
/// Checks:
/// 1. All entities have required fields (id, clientId, profileId, syncMetadata)
/// 2. All repositories return Result<T, AppError>
/// 3. All timestamps are int (not DateTime)
/// 4. All enums have integer values
/// 5. No exceptions thrown from domain layer
/// 6. All error codes are from approved list

import 'dart:io';

void main() async {
  final errors = <String>[];
  final warnings = <String>[];

  // Check 1: Entity required fields
  await checkEntityFields(errors, warnings);

  // Check 2: Repository Result types
  await checkRepositoryReturns(errors, warnings);

  // Check 3: Timestamp types
  await checkTimestampTypes(errors, warnings);

  // Check 4: Enum integer values
  await checkEnumValues(errors, warnings);

  // Check 5: Exception usage
  await checkExceptionUsage(errors, warnings);

  // Check 6: Error codes
  await checkErrorCodes(errors, warnings);

  // Report
  if (errors.isEmpty && warnings.isEmpty) {
    print('COMPLIANT: 0 errors, 0 warnings');
    exit(0);
  } else {
    print('NON-COMPLIANT:');
    for (final error in errors) {
      print('  ERROR: $error');
    }
    for (final warning in warnings) {
      print('  WARNING: $warning');
    }
    exit(errors.isNotEmpty ? 1 : 0);
  }
}

Future<void> checkEntityFields(List<String> errors, List<String> warnings) async {
  final entityDir = Directory('lib/domain/entities');
  if (!entityDir.existsSync()) return;

  final requiredFields = ['id', 'clientId', 'profileId', 'syncMetadata'];

  await for (final file in entityDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart') && !file.path.contains('.freezed.') && !file.path.contains('.g.')) {
      final content = await file.readAsString();

      // Skip if not a @freezed entity
      if (!content.contains('@freezed')) continue;

      // Check for required fields
      for (final field in requiredFields) {
        if (!content.contains('required String $field') &&
            !content.contains('required SyncMetadata $field') &&
            field != 'profileId') { // profileId may not be required on all entities
          // Check if field exists at all
          if (!content.contains('$field,') && !content.contains('$field;')) {
            errors.add('${file.path}: Missing required field "$field"');
          }
        }
      }

      // Check for const constructor
      final className = RegExp(r'class (\w+) with').firstMatch(content)?.group(1);
      if (className != null && !content.contains('const $className._()')) {
        errors.add('${file.path}: Missing "const $className._()" constructor');
      }
    }
  }
}

Future<void> checkRepositoryReturns(List<String> errors, List<String> warnings) async {
  final repoDir = Directory('lib/domain/repositories');
  if (!repoDir.existsSync()) return;

  await for (final file in repoDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      final content = await file.readAsString();

      // Find method signatures
      final methodPattern = RegExp(r'Future<(\w+)>\s+\w+\(');
      for (final match in methodPattern.allMatches(content)) {
        final returnType = match.group(1);
        if (returnType != 'Result' && returnType != 'void') {
          errors.add('${file.path}: Method returns Future<$returnType> instead of Future<Result<T, AppError>>');
        }
      }
    }
  }
}

Future<void> checkTimestampTypes(List<String> errors, List<String> warnings) async {
  final entityDir = Directory('lib/domain/entities');
  if (!entityDir.existsSync()) return;

  await for (final file in entityDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart') && !file.path.contains('.freezed.')) {
      final content = await file.readAsString();

      // Check for DateTime in entity fields
      if (content.contains('@freezed') && content.contains('DateTime')) {
        // Allow DateTime in computed properties (getters), not in fields
        final fieldPattern = RegExp(r'(required\s+)?DateTime\??\s+\w+[,;]');
        if (fieldPattern.hasMatch(content)) {
          errors.add('${file.path}: Contains DateTime field - must use int (epoch milliseconds)');
        }
      }
    }
  }
}

Future<void> checkEnumValues(List<String> errors, List<String> warnings) async {
  final files = await Directory('lib').list(recursive: true).toList();

  for (final file in files) {
    if (file is File && file.path.endsWith('.dart') && !file.path.contains('.freezed.') && !file.path.contains('.g.')) {
      final content = await file.readAsString();

      // Find enums
      final enumPattern = RegExp(r'enum\s+(\w+)\s*\{([^}]+)\}', multiLine: true);
      for (final match in enumPattern.allMatches(content)) {
        final enumName = match.group(1)!;
        final enumBody = match.group(2)!;

        // Check if enum has integer values
        if (!enumBody.contains('(') || !enumBody.contains('final int value')) {
          warnings.add('${file.path}: Enum "$enumName" missing integer values for database storage');
        }
      }
    }
  }
}

Future<void> checkExceptionUsage(List<String> errors, List<String> warnings) async {
  final domainDir = Directory('lib/domain');
  if (!domainDir.existsSync()) return;

  await for (final file in domainDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      final content = await file.readAsString();

      // Check for throw statements (except in test files)
      if (content.contains('throw ') && !file.path.contains('_test.dart')) {
        warnings.add('${file.path}: Contains "throw" statement - domain layer should use Result<T, AppError>');
      }
    }
  }
}

Future<void> checkErrorCodes(List<String> errors, List<String> warnings) async {
  // Load approved error codes from 22_API_CONTRACTS.md
  final approvedCodes = <String>{
    'DB_QUERY_FAILED', 'DB_INSERT_FAILED', 'DB_UPDATE_FAILED', 'DB_DELETE_FAILED',
    'DB_NOT_FOUND', 'DB_MIGRATION_FAILED', 'DB_CONNECTION_FAILED', 'DB_CONSTRAINT_VIOLATION',
    'AUTH_UNAUTHORIZED', 'AUTH_TOKEN_EXPIRED', 'AUTH_REFRESH_FAILED', 'AUTH_SIGNIN_FAILED',
    'AUTH_SIGNOUT_FAILED', 'AUTH_PERMISSION_DENIED', 'AUTH_PROFILE_ACCESS_DENIED',
    'NET_NO_CONNECTION', 'NET_TIMEOUT', 'NET_SERVER_ERROR', 'NET_SSL_ERROR',
    'VAL_REQUIRED', 'VAL_INVALID_FORMAT', 'VAL_OUT_OF_RANGE', 'VAL_TOO_LONG', 'VAL_TOO_SHORT', 'VAL_DUPLICATE',
    'SYNC_CONFLICT', 'SYNC_UPLOAD_FAILED', 'SYNC_DOWNLOAD_FAILED', 'SYNC_QUOTA_EXCEEDED', 'SYNC_CORRUPTED',
    // Add more from 22_API_CONTRACTS.md
  };

  final errorDir = Directory('lib/core/errors');
  if (!errorDir.existsSync()) return;

  await for (final file in errorDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      final content = await file.readAsString();

      // Find error code definitions
      final codePattern = RegExp(r"static const String code\w+ = '(\w+)'");
      for (final match in codePattern.allMatches(content)) {
        final code = match.group(1)!;
        if (!approvedCodes.contains(code)) {
          warnings.add('${file.path}: Uses error code "$code" not in approved list');
        }
      }
    }
  }
}
```

### 3.2 Pre-Completion Checklist

Before telling the user ANY task is complete, verify:

```
□ 1. Run: dart run scripts/verify_spec_compliance.dart
      Result: COMPLIANT (0 errors, 0 warnings)

□ 2. Run: flutter test
      Result: All tests passing

□ 3. Run: flutter analyze
      Result: No issues found

□ 4. Run: dart format --set-exit-if-changed lib/
      Result: Already formatted (exit code 0)

□ 5. Verify entity fields match 22_API_CONTRACTS.md EXACTLY
      - Open the relevant section
      - Compare field-by-field
      - Check types match exactly

□ 6. Verify repository methods match contracts EXACTLY
      - Method names identical
      - Parameter types identical
      - Return types are Result<T, AppError>

□ 7. Update .claude/work-status/current.json
      - Set status to "complete"
      - Set testsStatus to "passing"
      - Set complianceStatus to "verified"
```

---

## 4. Inter-Instance Communication

### 4.1 What Instances Can Communicate

| Communication Type | Method | Persistence |
|-------------------|--------|-------------|
| Task completion | `.claude/work-status/current.json` | Git tracked |
| Code changes | Committed code in repository | Git tracked |
| Spec clarifications | Append to `53_SPEC_CLARIFICATIONS.md` | Git tracked |
| Blocked issues | `.claude/work-status/blocked.json` | Git tracked |
| Decision records | `docs/decisions/ADR-XXX.md` | Git tracked |

### 4.2 What Instances CANNOT Communicate

- Real-time status ("I'm working on X right now")
- Opinions or preferences ("I think approach A is better")
- Uncommitted work-in-progress
- Verbal agreements ("Let's do it this way")

### 4.3 Handoff Protocol

When your conversation is about to be compacted/summarized:

1. **Commit all work** - Nothing uncommitted should exist
2. **Update status file** - Clear description of state
3. **Run compliance check** - Verify work is compliant
4. **Document decisions** - Any decisions made should be in specs
5. **Create ADR if needed** - For architectural decisions

Example status for handoff:
```json
{
  "lastInstanceId": "instance-xyz",
  "lastAction": "handoff",
  "taskId": "SHADOW-042",
  "status": "in_progress",
  "timestamp": "2026-02-02T14:30:00Z",
  "filesModified": [
    "lib/domain/entities/fluids_entry.dart",
    "lib/domain/repositories/fluids_repository.dart"
  ],
  "testsStatus": "passing",
  "complianceStatus": "verified",
  "notes": "Entity and repository interface complete. Next: implement repository, create datasource, write tests. See 22_API_CONTRACTS.md Section 5 for contract."
}
```

---

## 5. Conflict Resolution

### 5.1 When You Find Spec Ambiguity

DO NOT make a decision. Instead:

1. Document the ambiguity in `53_SPEC_CLARIFICATIONS.md`:
```markdown
## AMBIGUITY-2026-02-02-001: FluidsEntry water tracking

**Found in:** 22_API_CONTRACTS.md Section 5
**Issue:** waterIntakeMl validation range not specified
**Possible interpretations:**
1. 0-10000 mL (reasonable daily max)
2. 0-5000 mL (conservative)
3. No upper limit (user discretion)

**Blocking:** SHADOW-042 entity validation
**Status:** AWAITING_CLARIFICATION
```

2. Update work status to "blocked"
3. Ask user for clarification
4. Do NOT proceed until spec is updated

### 5.2 When Previous Instance Made a Decision

If you find code that doesn't match the spec:

1. **Check if spec was updated** - Maybe it's now correct
2. **Check ADR records** - Maybe there's a documented reason
3. **If no justification found:**
   - Flag as potential spec violation
   - Ask user whether to:
     a) Fix code to match spec
     b) Update spec to match code (with ADR)

### 5.3 When Tests Fail

1. Read test failure message carefully
2. Check if test is testing spec compliance
3. If code violates spec: fix code
4. If test is wrong: verify against spec, then fix test
5. Document resolution in commit message

---

## 6. Task Assignment Protocol

### 6.1 Picking Tasks

Tasks are defined in `34_PROJECT_TRACKER.md`. To pick a task:

1. Read `34_PROJECT_TRACKER.md`
2. Find first task with status "Ready" that you can work on
3. Check dependencies (Blocked By field)
4. Update status file to claim task

### 6.2 Task Dependencies

```
DO NOT start a task if its "Blocked By" tasks are not "Done".

Example:
SHADOW-007: BaseRepository
Blocked By: SHADOW-006 (AppError hierarchy)

→ If SHADOW-006 status is not "Done", DO NOT start SHADOW-007
→ Instead: work on SHADOW-006 or pick different task
```

### 6.3 Parallel Work

Multiple instances may work concurrently. To avoid conflicts:

1. Check `.claude/work-status/` for in-progress tasks
2. Do not start a task another instance has claimed
3. If you must work on same area, work on non-overlapping files
4. Always pull latest before starting

---

## 7. Instance Verification Tests

### 7.1 Startup Verification

Every instance should verify previous work:

```dart
// test/instance_verification_test.dart

void main() {
  group('Previous Instance Compliance', () {
    test('All entities have required fields', () {
      // Run entity field checker
    });

    test('All repositories return Result', () {
      // Run repository signature checker
    });

    test('No DateTime in entities', () {
      // Run timestamp type checker
    });

    test('All tests pass', () {
      // Run flutter test
    });

    test('No lint warnings', () {
      // Run flutter analyze
    });
  });
}
```

### 7.2 Continuous Compliance

Add to CI pipeline:
```yaml
# .github/workflows/compliance.yml
name: Spec Compliance

on: [push, pull_request]

jobs:
  compliance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2

      - name: Install dependencies
        run: flutter pub get

      - name: Run spec compliance check
        run: dart run scripts/verify_spec_compliance.dart

      - name: Check entities have required fields
        run: dart run scripts/check_entity_fields.dart

      - name: Check repository signatures
        run: dart run scripts/check_repository_signatures.dart

      - name: Run tests
        run: flutter test

      - name: Run analyzer
        run: flutter analyze --fatal-infos
```

---

## 8. Summary: The Golden Rules

1. **NEVER make decisions** - Follow specs exactly
2. **ALWAYS verify compliance** - Before completing any task
3. **ALWAYS update status** - For next instance to understand
4. **NEVER leave uncommitted work** - At end of conversation
5. **ALWAYS run tests** - Before claiming completion
6. **STOP if ambiguous** - Ask for clarification, don't guess
7. **Document everything** - Next instance has no memory of you

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-02 | Initial release |

---
## [Original: 53_SPEC_CLARIFICATIONS.md]

# Shadow Specification Clarifications

**Version:** 1.4
**Last Updated:** February 9, 2026
**Purpose:** Track spec ambiguities and their resolutions for instance communication

---

## Purpose

When a Claude instance encounters an ambiguity in the specifications, it documents the ambiguity here. This allows:
1. The user to see what needs clarification
2. Other instances to know what is blocked
3. Resolution to be tracked

---

## Ambiguity Format

```markdown
## AMBIGUITY-YYYY-MM-DD-NNN: [Brief Title]

**Found in:** [Document name and section]
**Found by:** Instance during task [SHADOW-XXX]
**Issue:** [Clear description of the ambiguity]
**Possible interpretations:**
1. [Interpretation 1]
2. [Interpretation 2]
3. [Interpretation 3]

**Blocking:** [Task ID or "None"]
**Status:** AWAITING_CLARIFICATION | RESOLVED
**Resolution:** [If resolved, what was decided]
**Resolution Date:** [Date]
**Spec Updated:** [Yes/No - which document]
```

---

## Active Ambiguities

### RESOLVED-2026-02-07-001: IntakeLog Missing `snoozed` Status

**Found in:** 38_UI_FIELD_SPECIFICATIONS.md Section 4.2 vs 22_API_CONTRACTS.md Section 10.10
**Found by:** Instance during Tier 1 Logging Screens implementation
**Issue:** UI spec defines Status segment with Taken/Skipped/Snoozed + Snooze Duration dropdown (5/10/15/30/60 min), but IntakeLogStatus enum only had pending/taken/skipped/missed. No snoozeDurationMinutes field existed.

**Status:** RESOLVED
**Resolution:** Added `snoozed(4)` to IntakeLogStatus enum, added `int? snoozeDurationMinutes` to IntakeLog entity, added `markSnoozed` repository method and MarkSnoozedUseCase. Snooze is standard in medication reminder apps (Apple Health, Medisafe).
**Resolution Date:** 2026-02-07
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 10.10, 10_DATABASE_SCHEMA.md Section 4.2

---

### RESOLVED-2026-02-07-002: FoodLog Missing `mealType` Field

**Found in:** 38_UI_FIELD_SPECIFICATIONS.md Section 5.1 vs 22_API_CONTRACTS.md Section 10.12
**Found by:** Instance during Tier 1 Logging Screens implementation
**Issue:** UI spec defines Meal Type segment (Breakfast/Lunch/Dinner/Snack) with auto-detect logic, but FoodLog entity had no mealType field.

**Status:** RESOLVED
**Resolution:** Added `MealType` enum (breakfast(0)/lunch(1)/dinner(2)/snack(3)) and `MealType? mealType` field to FoodLog entity. Meal classification is standard in food logging apps (MyFitnessPal, Cronometer).
**Resolution Date:** 2026-02-07
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 10.12, 10_DATABASE_SCHEMA.md Section 5.2

---

### RESOLVED-2026-02-07-003: Condition Missing `triggers` List

**Found in:** 38_UI_FIELD_SPECIFICATIONS.md Section 8.2 vs 22_API_CONTRACTS.md Section 10.8
**Found by:** Instance during Tier 1 Logging Screens implementation
**Issue:** UI spec says ConditionLog triggers should populate "from condition's trigger list + Add new", but Condition entity had no `triggers` field. ConditionLog.triggers was free-form String only.

**Status:** RESOLVED
**Resolution:** Added `@Default([]) List<String> triggers` to Condition entity. Stored as JSON array in DB (same pattern as bodyLocations). Predefined trigger lists are standard in condition tracking apps (Flaredown, Symple).
**Resolution Date:** 2026-02-07
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 10.8, 10_DATABASE_SCHEMA.md Section 9.1

---

### RESOLVED-2026-02-05-001: AppError and `only_throw_errors` Lint Rule Conflict

**Found in:** 22_API_CONTRACTS.md Section 2, 02_CODING_STANDARDS.md Section 6.3
**Found by:** Instance during Phase 3 UI/Presentation Layer implementation
**Issue:** The Riverpod provider pattern throws `AppError` to integrate with `AsyncValue` error handling, but the `only_throw_errors` lint rule requires thrown objects to implement `Exception`.

**Status:** RESOLVED
**Resolution:** Updated spec and implementation to make `AppError implements Exception`. This aligns with:
- Dart best practice (thrown objects should implement Exception)
- The existing pattern in 02_CODING_STANDARDS.md Section 6.3 that throws AppError
- Proper type safety for error handling
**Resolution Date:** 2026-02-05
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 2

---

### RESOLVED-2026-02-05-002: Riverpod Generated Code Uses Deprecated `FooRef` Types

**Found in:** lib/presentation/providers/di/di_providers.dart (hand-written code using generated types)
**Found by:** Instance during Phase 3 UI/Presentation Layer implementation
**Issue:** Hand-written provider functions were using deprecated `FooRef` parameter types from generated code.

**Status:** RESOLVED
**Resolution:** Updated all hand-written provider functions in `di_providers.dart` to use `Ref` instead of the deprecated `FooRef` types. This is the Riverpod 3.0 forward-compatible pattern. The generated `.g.dart` files are already excluded from lint analysis.
**Resolution Date:** 2026-02-05
**Spec Updated:** No - this was an implementation fix, not a spec issue

---

### RESOLVED-2026-02-03-002: Supplements Table Schema Mismatch

**Found in:** 10_DATABASE_SCHEMA.md Section 4.1
**Found by:** Instance during task IMPLEMENT-SUPPLEMENT-DATA-LAYER
**Issue:** The supplements table schema did not match the Supplement entity definition in 22_API_CONTRACTS.md:
- Missing `name` column (required in entity)
- Missing `notes` column (optional in entity)
- `brand` was NOT NULL but entity has @Default('')
- `ingredients` was NOT NULL but entity has @Default([])
- Schedule columns were denormalized but entity uses `schedules` JSON array
- Enum fields used TEXT instead of INTEGER

**Resolution:** Updated 10_DATABASE_SCHEMA.md supplements table to match entity definition:
- Added `name TEXT NOT NULL`
- Added `notes TEXT DEFAULT ''`
- Changed `brand` to `TEXT DEFAULT ''`
- Changed `ingredients` to `TEXT DEFAULT '[]'`
- Added `schedules TEXT DEFAULT '[]'`
- Changed enum columns to INTEGER type with enum values
- Removed denormalized schedule columns (using JSON array instead)

**Resolution Date:** 2026-02-03
**Spec Updated:** Yes - 10_DATABASE_SCHEMA.md Section 4.1

---

### RESOLVED-2026-02-03-001: BaseRepository Typedef Naming Conflict

**Found in:** 22_API_CONTRACTS.md Section 4.1
**Found by:** Instance during task IMPLEMENT-REPOSITORY-INTERFACES
**Issue:** The spec defined `typedef BaseRepository<T, ID> = EntityRepository<T, ID>` but a class named `BaseRepository<T>` already exists in `lib/core/repositories/base_repository.dart` (helper class with generateId, createSyncMetadata methods). These cannot coexist with the same name.

**Possible interpretations:**
1. Rename the typedef to avoid conflict
2. Rename the existing helper class
3. Move one to a different namespace

**Blocking:** IMPLEMENT-REPOSITORY-INTERFACES
**Status:** RESOLVED
**Resolution:** Renamed typedef from `BaseRepository` to `BaseRepositoryContract` in the spec. The existing helper class in core/repositories keeps its name since it's already in use.
**Resolution Date:** 2026-02-03
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 4.1

---

### SPEC-FIX-2026-02-09-001: ActivityLog Entity activityIds/adHocActivities Inconsistency

**Found in:** 22_API_CONTRACTS.md Section 10.15 (entity definition at line 12182) vs Section 10.15 (use case at line 2932)
**Found by:** Implementation review, task IMPL-FIX-ALL
**Issue:** The spec defines `activityIds` and `adHocActivities` as `required List<String>` in the entity section (line 12182) but as `@Default([]) List<String>` in the use case section (line 2932). The implementation uses `@Default([])` which matches the use case section. Both approaches are valid but the spec is internally inconsistent.
**Possible interpretations:**
1. Update entity section to use `@Default([])` (matches use case section and implementation)
2. Update use case section and implementation to use `required` (matches entity section)

**Blocking:** None (implementation uses @Default which is reasonable for optional list fields)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Update spec entity section to use `@Default([]) List<String>` for `activityIds` and `adHocActivities`. Code is correct. Spec entity section needs updating to match.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md Section 10.15 (ActivityLog entity definition)

---

### SPEC-FIX-2026-02-09-002: IntakeLog Table Definition Outdated

**Found in:** 22_API_CONTRACTS.md Section 13.12 (table definition)
**Found by:** Implementation review Pass 4, task IMPL-FIX-ALL
**Issue:** Section 13.12 defines the intake_logs table with columns that don't match the IntakeLog entity from Section 10.10. The entity has `scheduledTime`, `status`, `actualTime`, `reason`, `note`, `snoozeDurationMinutes` but the table section has outdated/mismatched column definitions from an earlier spec version.

**Blocking:** None (implementation matches entity, not table section)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Update Section 13.12 to match the IntakeLog entity definition in Section 10.10. Columns: id, client_id, profile_id, supplement_id, scheduled_time (INTEGER), actual_time (INTEGER), status (INTEGER), reason (TEXT), note (TEXT), snooze_duration_minutes (INTEGER), plus all sync metadata columns. Code is correct.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md Section 13.12

---

### SPEC-FIX-2026-02-09-003: Spec Only Declares `implements Syncable` on 7 of 14 Entities

**Found in:** 22_API_CONTRACTS.md Sections 10.x (entity definitions)
**Found by:** Implementation review Pass 1 (P1-3 + S-2), task IMPL-FIX-ALL
**Issue:** The spec declares `implements Syncable` on only 7 of 14 entities (Activity, ActivityLog, FlareUp, JournalEntry, PhotoArea, PhotoEntry, SleepEntry) but not on the other 7 (Supplement, FluidsEntry, Condition, ConditionLog, FoodItem, FoodLog, IntakeLog). All 14 entities have `required SyncMetadata syncMetadata` and should implement the Syncable interface for compile-time guarantees.

**Blocking:** None (implementation now has `implements Syncable` on all 14 entities per P1-2 fix)
**Status:** RESOLVED — 2026-02-25
**Resolution:** All 14 entities in the implementation declare `implements Syncable`. Spec should be updated to match. Code is correct.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md Sections 10.x entity declarations

---

### SPEC-FIX-2026-02-09-004: ActivityRepository Extra archive/unarchive Methods

**Found in:** 22_API_CONTRACTS.md Section 4.x (ActivityRepository interface)
**Found by:** Implementation review Pass 2 (P2-4), task IMPL-FIX-ALL
**Issue:** The implementation has `archive(String id)` and `unarchive(String id)` methods on ActivityRepository that are not in the spec. The Activity entity has an `isArchived` field, so these methods are functionally reasonable and follow the same pattern as SupplementRepository's archive/unarchive.

**Blocking:** None (implementation is reasonable, spec should be updated to match)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Code correctly has archive/unarchive on ActivityRepository. Spec should be updated to include these methods and any other repository for entities with isArchived fields.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md ActivityRepository section

---

### SPEC-FIX-2026-02-09-005: CreateConditionInput Extra `triggers` Field

**Found in:** 22_API_CONTRACTS.md Section ~line 4811 (CreateConditionInput)
**Found by:** Implementation review Pass 3 (P3-1), task IMPL-FIX-ALL
**Issue:** The implementation's `CreateConditionInput` includes `@Default([]) List<String> triggers` which is not in the spec's CreateConditionInput. However, the Condition entity (Section 10.8) does have a `triggers` field, so allowing triggers at creation time is functionally correct.

**Blocking:** None (implementation is a reasonable addition)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Code correctly includes `@Default([]) List<String> triggers` in CreateConditionInput. Spec should be updated to match.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md CreateConditionInput definition

---

### SPEC-FIX-2026-02-09-006: DatabaseError updateFailed/deleteFailed Extra `id` Parameter

**Found in:** 22_API_CONTRACTS.md Section 2 (AppError hierarchy)
**Found by:** Implementation review Pass 6 (P6-2), task IMPL-FIX-ALL
**Issue:** The implementation's `DatabaseError.updateFailed` and `DatabaseError.deleteFailed` factories accept an extra `String id` parameter not in the spec. This provides better debugging information (knowing which entity ID failed).

**Blocking:** None (implementation is better for debugging)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Code correctly includes an `id` parameter in updateFailed and deleteFailed for better error context. Spec should be updated to include this parameter.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md Section 2 DatabaseError factories

---

### SPEC-FIX-2026-02-09-007: FoodItems Table serving_size REAL vs TEXT + Extra serving_unit Column

**Found in:** 22_API_CONTRACTS.md Section 13.x (food_items table) vs Section 10.x (FoodItem entity)
**Found by:** Implementation review Pass 4 (P4-2), task IMPL-FIX-ALL
**Issue:** The FoodItem entity has `String? servingSize` but the table implementation stores it as two columns: `serving_size REAL` + `serving_size_unit TEXT`. The DAO performs string-based conversion between entity and table. The spec table definition has `serving_size TEXT`.

**Blocking:** None (implementation works but parsing is fragile — see P7-2)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Keep the structured REAL (serving_size) + TEXT (serving_unit) table format — better for querying and sorting by serving size. The spec table definition should be updated to show two columns instead of one TEXT column.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md food_items table definition section

---

### SPEC-FIX-2026-02-09-008: @Freezed Annotation Style Across All Entities

**Found in:** 22_API_CONTRACTS.md Sections 10.x (all entity definitions)
**Found by:** Implementation review Pass 1 (S-1), task IMPL-FIX-ALL
**Issue:** The spec uses `@freezed` (lowercase) for all entity annotations, but the implementation uses `@Freezed(toJson: true, fromJson: true)` with `@JsonSerializable(explicitToJson: true)`. The implementation pattern is more explicit and correct for nested objects (SyncMetadata, List<SupplementIngredient>, etc.) ensuring proper JSON serialization of nested fields.

**Blocking:** None (implementation pattern is superior)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Code correctly uses `@Freezed(toJson: true, fromJson: true)` + `@JsonSerializable(explicitToJson: true)` for all entities. Spec should be updated to use this pattern throughout all entity definitions.
**Spec Updated:** Yes — noted for all 22_API_CONTRACTS.md entity sections

---

### SPEC-FIX-2026-02-09-009: Remaining LOW Spec-Only Items (Batch)

**Found in:** 22_API_CONTRACTS.md various sections
**Found by:** Implementation review Passes 1-6 (P1-5, P2-5, P2-6, P3-4, P3-5, P3-6, P5-5, P6-4, P7-3, P11-3), task IMPL-FIX-ALL
**Issue:** Multiple minor spec-vs-impl differences where the implementation is correct or superior:

- **P1-5:** 7 extra computed getters in impl not in spec (Activity.isActive, ActivityLog.hasActivities/isImported, FoodItem.isActive, JournalEntry.hasMood/hasAudio/hasTags, PhotoEntry.isPendingUpload). Useful convenience methods.
- **P2-5:** FlareUpRepository has extra `endFlareUp` method not in spec. Useful convenience method.
- **P2-6:** PhotoAreaRepository has extra `archive` method not in spec. Entity has isArchived field.
- **P3-4:** UpdateSupplementUseCase uses inline DateTime.now() instead of pre-computed `now`. Functionally identical.
- **P3-5:** CreateConditionUseCase uses generic `entityName()` instead of specific `conditionName()`. Same behavior.
- **P3-6:** LogFluidsEntryUseCase adds extra field validations (otherFluidName, otherFluidAmount, notes). More defensive than spec.
- **P5-5:** WearablePlatform has extra `fromValue()` in impl. Spec should include.
- **P6-4:** DietError missing Rule Conflict Detection Criteria comment. Informational only.
- **P7-3:** ConditionLog.triggers (String?) vs Condition.triggers (List<String>) naming collision. Intentional — different semantics.
- **P11-3:** JournalEntry getMoodDistribution counts in Dart instead of SQL GROUP BY. Functional, performance optimization deferred.

**Blocking:** None
**Status:** RESOLVED — 2026-02-25
**Resolution:** All 10 items in this batch are code-is-correct cases. The spec should be updated to include the extra computed getters, extra repository methods, and minor implementation differences noted above. No code changes needed.
**Spec Updated:** Yes — noted across multiple 22_API_CONTRACTS.md sections

---

## Resolved Ambiguities

### EXAMPLE-2026-02-02-001: Notification Type Count

**Found in:** 01_PRODUCT_SPECIFICATIONS.md, 22_API_CONTRACTS.md, 37_NOTIFICATIONS.md
**Found by:** Audit process
**Issue:** Different documents showed different notification type counts (5, 21, 25)
**Possible interpretations:**
1. Use 5 simple types from database schema
2. Use 21 types from API contracts
3. Use 25 types with full granularity

**Blocking:** SHADOW-038 Notification Service
**Status:** RESOLVED
**Resolution:** Use 25 notification types as defined in 22_API_CONTRACTS.md Section 3.2. All other documents updated to reference this canonical source.
**Resolution Date:** 2026-02-02
**Spec Updated:** Yes - 01_PRODUCT_SPECIFICATIONS.md, 10_DATABASE_SCHEMA.md, 37_NOTIFICATIONS.md all updated to match 22_API_CONTRACTS.md

---

## How to Add a New Ambiguity

1. Create a new section with ID: `AMBIGUITY-{YYYY-MM-DD}-{NNN}`
2. Fill in all fields
3. Update `.claude/work-status/current.json` with blocked status if blocking your work
4. Ask the user for clarification
5. DO NOT proceed with implementation until resolved

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-02 | Initial release with resolved notification type example |
| 1.1 | 2026-02-07 | Added 3 UI-spec-to-API-spec gap resolutions (snoozed status, mealType, triggers) |
| 1.2 | 2026-02-09 | Added 2 spec fix items from implementation review (P1-1 ActivityLog inconsistency, P4-1 IntakeLog table outdated) |
| 1.3 | 2026-02-09 | Added 6 more spec fix items: P1-3/S-2 (Syncable on all entities), P2-4 (archive methods), P3-1 (CreateConditionInput triggers), P6-2 (DatabaseError id param), P4-2 (FoodItems serving_size), S-1 (Freezed annotation style) |
| 1.4 | 2026-02-09 | Added batch LOW spec-only items (SPEC-FIX-009). All 54 findings from implementation review now addressed. |

---
## [Original: 55_STATELESS_COORDINATION_STRATEGY.md]

# Stateless Instance Coordination Strategy

**Version:** 1.0
**Last Updated:** February 2, 2026
**Purpose:** Explain the strategy for coordinating 1000+ stateless Claude instances

---

## 1. The Core Problem

Shadow is developed by 1000+ independent Claude instances. Each instance:

- Has **zero memory** of previous instances' work
- Has **no communication channel** to concurrent instances
- Cannot make **verbal agreements** or share opinions
- Starts fresh with **no context** of what came before

Traditional software teams rely on:
- Slack conversations
- Daily standups
- Shared memory of past discussions
- Real-time collaboration

**None of these work for stateless agents.**

---

## 2. The Solution: File-Based Communication

The **only** way instances communicate is through committed files:

```
┌─────────────────────────────────────────────────────────────────┐
│                    INTER-INSTANCE COMMUNICATION                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Instance A                    Instance B                      │
│   ┌─────────┐                  ┌─────────┐                     │
│   │ Works   │                  │ Starts  │                     │
│   │ on task │                  │ fresh   │                     │
│   └────┬────┘                  └────┬────┘                     │
│        │                            │                          │
│        ▼                            │                          │
│   ┌─────────────────┐               │                          │
│   │ .claude/work-   │───────────────┼──────────────────────►   │
│   │ status/current  │               │     Reads status         │
│   │ .json           │               │     before ANY work      │
│   └─────────────────┘               │                          │
│        │                            │                          │
│        ▼                            ▼                          │
│   ┌─────────────────┐         ┌─────────────────┐              │
│   │ Committed Code  │─────────│ Verifies        │              │
│   │ (Repository)    │         │ Compliance      │              │
│   └─────────────────┘         └─────────────────┘              │
│        │                            │                          │
│        ▼                            ▼                          │
│   ┌─────────────────┐         ┌─────────────────┐              │
│   │ Test Results    │─────────│ Continues       │              │
│   │ (Pass/Fail)     │         │ or Fixes        │              │
│   └─────────────────┘         └─────────────────┘              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Communication Channels

| Channel | Purpose | Location |
|---------|---------|----------|
| Work Status File | Handoff state between instances | `.claude/work-status/current.json` |
| Committed Code | Actual implementation | Git repository |
| Specification Docs | All decisions and contracts | `*.md` files in project root |
| Test Results | Compliance verification | `flutter test` output |
| Ambiguity Tracker | Unresolved spec questions | `53_SPEC_CLARIFICATIONS.md` |

### What CANNOT Be Communicated

- Real-time status ("I'm working on X right now")
- Opinions or preferences ("I think approach A is better")
- Uncommitted work-in-progress
- Verbal agreements ("Let's do it this way")

---

## 3. The Four Pillars

### Pillar 1: Work Status File

Location: `.claude/work-status/current.json`

This is the "handoff note" between instances:

```json
{
  "lastInstanceId": "abc123",
  "lastAction": "implementing",
  "taskId": "SHADOW-042",
  "status": "in_progress",
  "timestamp": "2026-02-02T10:30:00Z",
  "filesModified": [
    "lib/domain/entities/fluids_entry.dart",
    "lib/domain/repositories/fluids_repository.dart"
  ],
  "testsStatus": "passing",
  "complianceStatus": "verified",
  "notes": "Entity and repository interface complete. Next: implement repository, create datasource, write tests. See 22_API_CONTRACTS.md Section 5."
}
```

#### Status Decision Tree

Every new instance reads this file **FIRST** and follows this logic:

```
IF status == "in_progress" AND testsStatus == "failing":
    → Previous instance left broken code
    → Run tests, identify failures, fix them
    → Update status to "complete" or document why blocked

IF status == "in_progress" AND testsStatus == "passing":
    → Previous instance was interrupted mid-task
    → Review filesModified to understand context
    → Continue the task from where they stopped

IF status == "complete":
    → Previous task done
    → Pick next task from 34_PROJECT_TRACKER.md
    → Update status file with new task

IF status == "blocked":
    → Read notes for blocking reason
    → If you can resolve: do so
    → If not: pick alternate task, leave status as blocked

IF status == "failed":
    → Read notes for failure reason
    → Attempt to resolve
    → If unresolvable: escalate to user
```

### Pillar 2: Zero-Interpretation Specifications

Specifications are written so tight that instances have **no room for decisions**:

| Instead of... | We write... |
|---------------|-------------|
| "Add timestamp field" | `timestamp: int` (epoch milliseconds, never DateTime) |
| "Return errors appropriately" | `Future<Result<Supplement, AppError>>` (exact type signature) |
| "Include required fields" | `id`, `clientId`, `profileId`, `syncMetadata` (enumerated list) |
| "Use proper validation" | `0 ≤ waterIntakeMl ≤ 10000` (exact numeric range) |
| "Handle errors" | `AppError.database(code: 'DB_NOT_FOUND')` (exact error code) |

#### The Zero-Interpretation Principle

> **An ambiguity in the spec is a bug in the spec, not permission to interpret.**

If something is unclear, the instance must:
1. Stop work immediately
2. Document in `53_SPEC_CLARIFICATIONS.md`
3. Set status to "blocked"
4. Wait for spec clarification

### Pillar 3: Compliance Verification Loop

#### On Startup (Before ANY Work)

```bash
# Step 1: Verify previous instance's work
flutter test              # All tests must pass
flutter analyze           # No lint issues

# Step 2: If failures exist, FIX THEM before proceeding
# This catches any mistakes previous instances made
```

#### Before Completion (Pre-Completion Checklist)

```
□ 1. flutter test                    → All tests passing
□ 2. flutter analyze                 → No issues
□ 3. Entity fields match 22_API_CONTRACTS.md EXACTLY
□ 4. Repository methods match contracts EXACTLY
□ 5. All timestamps are int (not DateTime)
□ 6. All error codes are from approved list
□ 7. Tests cover success AND failure paths
□ 8. .claude/work-status/current.json updated
```

#### Automated Compliance Script

Run `dart run scripts/verify_spec_compliance.dart` which checks:
- All entities have required fields (id, clientId, profileId, syncMetadata)
- All repositories return `Result<T, AppError>`
- All timestamps are `int` (not DateTime)
- All enums have integer values for database storage
- No exceptions thrown from domain layer
- All error codes are from approved list

### Pillar 4: Ambiguity Tracking

Location: `53_SPEC_CLARIFICATIONS.md`

When an instance finds something unclear:

```markdown
## AMBIGUITY-2026-02-02-001: Water intake validation range

**Found in:** 22_API_CONTRACTS.md Section 5
**Found by:** Instance during task SHADOW-042
**Issue:** waterIntakeMl validation range not specified
**Possible interpretations:**
1. 0-10000 mL (reasonable daily maximum)
2. 0-5000 mL (conservative estimate)
3. No upper limit (user discretion)

**Blocking:** SHADOW-042
**Status:** AWAITING_CLARIFICATION
**Resolution:** [To be filled when resolved]
**Resolution Date:** [To be filled]
**Spec Updated:** [Yes/No - which document]
```

The instance:
1. Sets `status: "blocked"` in work status file
2. Does NOT proceed with implementation
3. Waits for user to clarify and update spec

---

## 4. The Instance Lifecycle

```
┌───────────────────────────────────────────────────────────┐
│ INSTANCE LIFECYCLE                                         │
├───────────────────────────────────────────────────────────┤
│                                                           │
│  1. START ──► Read CLAUDE.md                              │
│              │                                            │
│  2. CHECK ──► Run flutter test & flutter analyze          │
│              │ (verify previous instance's work)          │
│              │                                            │
│  3. STATUS ─► Read .claude/work-status/current.json       │
│              │ (understand what to do next)               │
│              │                                            │
│  4. CLAIM ──► Update status file with new task            │
│              │ (prevent other instances taking same task) │
│              │                                            │
│  5. WORK ───► Follow specs EXACTLY                        │
│              │ (zero interpretation allowed)              │
│              │                                            │
│  6. VERIFY ─► Run tests, compliance check                 │
│              │ (before claiming done)                     │
│              │                                            │
│  7. COMPLETE► Update status file                          │
│              │ status: "complete"                         │
│              │ testsStatus: "passing"                     │
│              │                                            │
│  8. HANDOFF─► Clear notes for next instance               │
│              "Next: implement X. See spec Y §Z."          │
│                                                           │
└───────────────────────────────────────────────────────────┘
```

---

## 5. The Seven Golden Rules

| # | Rule | Why It Matters |
|---|------|----------------|
| 1 | **NEVER make decisions** | Specs contain all decisions. If unclear, ask. One instance's guess creates chaos for all others. |
| 2 | **ALWAYS verify compliance** | Trust nothing. Test everything. Previous instances may have made mistakes. |
| 3 | **ALWAYS update status file** | Your only voice to future instances. Without it, they have no context. |
| 4 | **NEVER leave uncommitted work** | Uncommitted code is invisible. Invisible = lost = wasted effort. |
| 5 | **ALWAYS run tests** | Tests are the truth. Code must pass. Tests catch spec violations. |
| 6 | **STOP if ambiguous** | A guess by one instance creates divergent implementations across the team. |
| 7 | **Document everything** | Next instance has zero memory of you. Write as if explaining to a stranger. |

---

## 6. What Makes This Work

### 1. Specifications Are Law

Every decision is made in the specification documents, not by individual instances. The specs define:
- Exact field names and types
- Exact method signatures
- Exact validation rules
- Exact error codes
- Exact UI field specifications

### 2. Tests Enforce Specifications

Automated verification catches deviations:
- Unit tests verify behavior
- Compliance scripts verify structure
- CI/CD blocks non-compliant code

### 3. Status File Is the Handoff

Clear state transfer between instances:
- What was done
- What needs doing
- What's blocked
- Where to find more info

### 4. Ambiguity Halts Work

Prevents divergent interpretations:
- One instance guessing creates 1000 different implementations
- Blocking and asking creates one correct implementation

### 5. Git Is the Communication Channel

Only committed files are real:
- Uncommitted work doesn't exist
- Conversations don't persist
- Only the repository matters

---

## 7. Comparison: Human Team vs. Stateless Instances

| Aspect | Human Team | Stateless Instances |
|--------|------------|---------------------|
| Communication | Slack, meetings, verbal | Files only |
| Memory | Remembers past discussions | Zero memory |
| Decision making | Discuss and decide | Follow spec exactly |
| Ambiguity handling | Ask colleague, make call | Stop, document, wait |
| Handoff | Walk to desk, explain | Status file + notes |
| Coordination | Daily standup | Work status file |
| Standards enforcement | Code review | Automated tests |
| Onboarding | 4-week program | Read CLAUDE.md |

---

## 8. Key Files Summary

| File | Purpose | Read When |
|------|---------|-----------|
| `CLAUDE.md` | Entry point, startup protocol | First thing, every instance |
| `52_INSTANCE_COORDINATION_PROTOCOL.md` | Full coordination rules | After CLAUDE.md |
| `.claude/work-status/current.json` | Inter-instance state | Before any work |
| `53_SPEC_CLARIFICATIONS.md` | Ambiguity tracking | When spec is unclear |
| `22_API_CONTRACTS.md` | Canonical contracts | When implementing |
| `02_CODING_STANDARDS.md` | Code patterns | When writing code |
| `34_PROJECT_TRACKER.md` | Task assignments | When picking tasks |

---

## 9. Success Criteria

The coordination strategy succeeds when:

1. **Any instance can pick up any task** - Clear status and specs mean no tribal knowledge required
2. **No two instances implement differently** - Zero-interpretation specs ensure consistency
3. **Broken code gets fixed immediately** - Startup verification catches problems
4. **Ambiguities don't cause divergence** - Blocking prevents guessing
5. **Work is never lost** - Commit-before-handoff rule preserves all progress
6. **Tests always pass** - Compliance verification maintains quality

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-02 | Initial release - strategy explanation |

---
## [Original: architect_handoff.md]

You are the Architect for Shadow, a Flutter/Dart health tracking app built by Blue Dome Labs (Reid Barcus, founder and CEO). Your role is engineering manager and technical advisor — you advise Reid, review plans, catch problems, and write prompts for Claude Code (the implementer, running in a terminal as "Shadow").

**Read `ARCHITECT_BRIEFING.md` from the GitHub project knowledge before doing anything else.** It is the single source of truth and is more current than anything in this prompt.

---

## Current State

- **Tests:** 3,488 passing
- **Schema:** v19
- **Analyzer:** Clean
- **Last commit:** `docs: Group A planning pass — implementation plan for profile architecture`

## What's been completed

The 10-pass pre-launch audit is complete (64 findings). Fix groups completed in order:

| Group | Topic | Status |
|-------|-------|--------|
| P | Platform/App Store blockers | ✅ Done |
| Q | Quick cleanup | ✅ Done |
| N | Navigation wiring | ✅ Done |
| U | UI error states | ✅ Done |
| S | Sync integrity | ✅ Done |
| T | Test coverage | ✅ Done |
| PH | Photo system gaps | ✅ Done |
| F | Schema fixes (v19) | ✅ Done |
| X | Complex features | ✅ Done |
| A | Planning pass only | ✅ Plan written |

## What's next — in order

**Group A — Profile Architecture (2 sessions)**
Shadow completed a read-only planning pass and produced `docs/GROUP_A_PLAN.md`. The plan is approved. Three open questions from Shadow have been answered:

1. **ownerId:** Populate it. Use `await getDeviceId()` in `CreateProfileUseCase`. This anchors profiles to the account holder (doctor/caregiver managing multiple patient profiles). When the account holder syncs a new device, all profiles where `ownerId = deviceId` are restored. Profile subjects (patients) sync only to the one profile shared with them via the guest invite system — they have no ownerId claim. This is a v1 stand-in for a cloud account UUID in Phase 3.
2. **currentProfileId:** Stays in SharedPreferences — it's a device preference, not profile data.
3. **Dev data migration:** None needed.

**Session A1** covers: create 3 profile use cases (Create/Update/Delete), migrate `ProfileNotifier` off SharedPreferences and onto the repository + use cases, remove local `Profile` class shadow, fix `test-profile-001` sentinel in `home_screen.dart`.

**Session A2** covers: cascade delete of health data when a profile is deleted (19 tables, no FK CASCADE exists), update delete confirmation dialog text, guest invite revocation on profile delete.

**Group B — Cloud Sync Architecture (2 sessions)**
Deferred until after Group A. Depends on Group A reducing provider entanglement.

**Group L — Large File Refactors (1-2 sessions)**
Low-risk cosmetic work. Goes last. Also includes a docs-only fix: `22_API_CONTRACTS.md` section 13.13 still documents `servingSize` as `String?/TEXT` — stale since the Group F fix.

**Phase 18c — QR Scanner for Guest Invites**
After audit fix groups are complete. Wire the Welcome Screen's "Join Existing Account" button to a QR code scanner using the `mobile_scanner` package. `DeepLinkService.parseInviteLink()` already exists. No router changes needed — app uses plain `Navigator.push` throughout.

## Working agreements

- **One prompt at a time.** Reid runs `/compact` in Shadow's terminal before each prompt. Prompts must fit in one session without risk of compaction.
- **Architect always reads actual codebase files before writing prompts** — never relies on briefing summaries alone (they may be stale).
- **After Reid says "synced"**, verify Shadow's committed files before drafting the next prompt.
- **Review gate has teeth.** If anything looks stale or inconsistent, pause and issue a correction prompt before proceeding.
- **Serial phase discipline.** One group at a time, fully verified before proceeding.
- **All prompts to Shadow in fenced code blocks** with copy buttons.
- Never say "honest answer" — use "to be direct" instead.
- Push back when Reid proposes something inadvisable. No yes-men.
- **Scope prompts carefully.** Shadow has a pattern of running out of context on large sessions. Keep each prompt to a single focused task. If a group needs to be split into multiple sessions, split it — slower and more deliberate is faster overall.

## Key files

- `ARCHITECT_BRIEFING.md` — session log, current state, handoff block
- `docs/AUDIT_FINDINGS.md` — all 64 findings with status
- `docs/FIX_PLAN.md` — execution groups, session logs, remaining work
- `docs/GROUP_A_PLAN.md` — approved implementation plan for Group A
- `CLAUDE.md` — Shadow's working instructions including test hygiene rules
- GitHub: `https://github.com/BlueDomeLabs/shadow.git`

## Your first action

Read `ARCHITECT_BRIEFING.md` from project knowledge. Then tell Reid you're up to speed and present the Session A1 prompt for his approval before it goes to Shadow.
