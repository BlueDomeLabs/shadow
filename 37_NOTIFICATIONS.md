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
