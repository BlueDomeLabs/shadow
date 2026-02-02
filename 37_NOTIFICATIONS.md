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

| Type ID | Category | Name | Default Message | Deep Link Target |
|---------|----------|------|-----------------|------------------|
| `supplement` | Health | Supplement Reminder | "Time to take {supplement_name}" | Supplement intake screen |
| `supplement_group` | Health | Supplement Group | "Time to take your {time_of_day} supplements" | Supplement list |
| `food_meal` | Health | Meal Logging | "Don't forget to log your {meal_type}" | Log food screen |
| `food_general` | Health | Food Reminder | "Remember to log what you've eaten" | Log food screen |
| `water` | Health | Water Intake | "Stay hydrated! Log your water intake" | Fluids tab |
| `fluids_bowel` | Health | Bowel Tracking | "Have you logged your bowel movements today?" | Add fluids screen |
| `fluids_general` | Health | Fluids Reminder | "Time to update your fluids log" | Fluids tab |
| `bbt` | Health | BBT Reminder | "Record your basal body temperature" | Add fluids screen (BBT) |
| `menstruation` | Health | Period Tracking | "Log your menstrual flow for today" | Add fluids screen |
| `sleep_bedtime` | Health | Bedtime Reminder | "Time to start winding down for bed" | Add sleep screen |
| `sleep_wakeup` | Health | Wake-up Check-in | "Good morning! How did you sleep?" | Add sleep screen |
| `condition` | Health | Condition Check-in | "How is your {condition_name} today?" | Log condition screen |
| `photo` | Health | Photo Reminder | "Time to take your {area_name} photos" | Photo capture |
| `journal` | Health | Journal Prompt | "Take a moment to reflect on your day" | Add journal screen |
| `sync` | System | Sync Reminder | "Your data hasn't synced in {days} days" | Sync settings |
| `inactivity` | System | Activity Reminder | "We haven't seen you in a while" | Home screen |
| `fasting_window_open` | Diet | Eating Window Open | "Your eating window is now open" | Food tab |
| `fasting_window_closing` | Diet | Window Closing Soon | "Your eating window closes in 30 minutes" | Food tab |
| `fasting_window_closed` | Diet | Fasting Started | "Fasting period has begun. Stay strong!" | Food tab |
| `diet_streak` | Diet | Compliance Milestone | "Amazing! {streak} days at 100% compliance!" | Diet compliance |
| `diet_weekly` | Diet | Weekly Summary | "Last week: {score}% diet compliance" | Diet compliance |

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

/// CANONICAL: Must match 22_API_CONTRACTS.md exactly (25 values)
enum NotificationType {
  supplementIndividual(0),      // Individual supplement reminder
  supplementGrouped(1),         // Grouped supplement reminder (e.g., "morning supplements")
  mealBreakfast(2),             // Breakfast reminder
  mealLunch(3),                 // Lunch reminder
  mealDinner(4),                // Dinner reminder
  mealSnacks(5),                // Snacks reminder
  waterInterval(6),             // Water reminder at intervals
  waterFixed(7),                // Water reminder at fixed times
  waterSmart(8),                // Smart water reminder based on activity
  bbtMorning(9),                // BBT morning measurement reminder
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
  dietStreak(20),               // Diet compliance milestone
  dietWeeklySummary(21),        // Weekly diet compliance summary
  fluidsGeneral(22),            // General fluids tracking reminder
  fluidsBowel(23),              // Bowel movement tracking reminder
  inactivity(24);               // Re-engagement after extended absence

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

### 4.1 Meal Types

| Meal Type | Default Time | Message |
|-----------|--------------|---------|
| Breakfast | 8:00 AM | "Don't forget to log your breakfast" |
| Morning Snack | 10:30 AM | "Log your morning snack" |
| Lunch | 12:30 PM | "Don't forget to log your lunch" |
| Afternoon Snack | 3:30 PM | "Log your afternoon snack" |
| Dinner | 6:30 PM | "Don't forget to log your dinner" |
| Evening Snack | 9:00 PM | "Log your evening snack" |

### 4.2 Meal Reminder Configuration

```dart
@freezed
class MealReminder with _$MealReminder {
  const factory MealReminder({
    required MealType mealType,
    required int timeMinutes,        // Minutes from midnight
    required bool isEnabled,
    required List<int> weekdays,
    String? customMessage,
  }) = _MealReminder;
}

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

### 5.1 Water Reminder Modes

| Mode | Description | Configuration |
|------|-------------|---------------|
| **Interval** | Remind every X hours | Every 2 hours, 8 AM - 8 PM |
| **Specific Times** | Remind at set times | 8 AM, 12 PM, 3 PM, 6 PM |
| **Smart** | Based on intake vs goal | Remind when behind on goal |

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

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release - comprehensive notification specification |
