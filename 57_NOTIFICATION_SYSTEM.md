# 57 — Notification System
**Status:** PLANNED — Not yet implemented
**Target Phase:** Phase 13
**Created:** 2026-02-22

---

## Overview

Shadow uses an active, two-way notification system that proactively prompts users to report health data at configured times. Notifications are actionable — tapping one opens the app briefly to a pre-populated quick-entry sheet. The user confirms with one tap and the app dismisses. No manual navigation required.

Each reporting category can be independently enabled or disabled, and each uses one of two scheduling modes depending on what fits that category best. Any category can use either mode.

---

## Scheduling Modes

Every notification category uses one of two scheduling modes. The user selects the mode per category in Notification Settings.

### Mode 1 — Anchor Events
The notification fires when a named daily event occurs (Wake, Breakfast, Lunch, Dinner, Bedtime). The user configures a clock time for each anchor event. Assigning a category to multiple anchor events produces one notification per assigned event per day.

**Best for:** Supplements, Food/Meals, BBT/Vitals, Condition Check-ins — things that naturally tie to daily events.

**Multiple daily notifications:** A category assigned to Breakfast, Lunch, and Dinner fires three times per day. There is no cap — the user assigns as many anchor events as they want.

### Mode 2 — Interval or Specific Times
The notification fires on a repeating interval or at specific clock times set by the user. Does not depend on anchor events at all.

**Option A — Repeat Interval:**
- User sets an interval (every 1 hour, every 2 hours, every 3 hours, every 4 hours, every 6 hours, every 8 hours, every 12 hours)
- User sets a start time and end time for the active window (e.g. every 2 hours between 8:00 AM and 10:00 PM)
- App calculates and schedules all notification times within the window automatically

**Option B — Specific Times:**
- User adds individual clock times (e.g. 9:00 AM, 1:00 PM, 5:00 PM, 9:00 PM)
- Up to 12 specific times per category per day
- Each time is added via a time picker and shown as a list
- Times can be removed individually

**Best for:** Fluids, Photos, Journal Entries, Activities — things that don't tie to meals and may need high-frequency or custom-timed reminders.

---

## Anchor Event Times

The user configures a clock time for each named anchor event in Notification Settings. These times are used by all categories running in Mode 1.

| Anchor Event | Default Time | Example Use |
|---|---|---|
| Wake | 7:00 AM | BBT/vitals, morning supplements |
| Breakfast | 8:00 AM | Food log, breakfast supplements |
| Lunch | 12:00 PM | Food log, midday supplements |
| Dinner | 6:00 PM | Food log, evening supplements |
| Bedtime | 10:00 PM | Evening supplements, journal |

Each anchor event can be enabled or disabled. Disabled anchor events are skipped for all categories using Mode 1. The user sets the time for each via a time picker.

---

## Notification Categories

Each category below can be independently enabled or disabled. When enabled, the user selects a scheduling mode and configures it. Default modes are noted but the user can switch any category to either mode.

**Multiple daily notifications per category are fully supported in both modes.** Mode 1 fires once per assigned anchor event. Mode 2 fires at every interval tick or specific time within the configured window.

### 1. Supplements
- **Default mode:** Mode 1 (Anchor Events)
- **Trigger:** Based on each supplement's configured anchor event assignment
- **Notification text:** "Time to take your [Supplement Name]. Did you take it?"
- **Response flow:** Tap notification → app opens to quick-entry sheet showing supplement name, dose, and two buttons: "Taken" and "Skip"
- **"Taken" action:** Logs supplement intake with current timestamp, dismisses sheet
- **"Skip" action:** Logs as skipped with current timestamp, dismisses sheet
- **Multiple supplements:** If multiple supplements are due at the same time, they are shown as a grouped list — user confirms each one individually or taps "Mark All Taken"
- **Per-supplement control:** Each supplement can have notifications enabled/disabled independently in the Supplement Edit Screen

### 2. Food / Meals
- **Default mode:** Mode 1 (Anchor Events — Breakfast, Lunch, Dinner)
- **Notification text:** "What did you have for [Anchor Event Name]?"
- **Response flow:** Tap notification → app opens to quick-entry food log sheet
- **Quick-entry sheet contains:**
  - Meal label (e.g. "Breakfast")
  - Searchable food list showing recently logged foods first
  - "Add new food" option if item not in list
  - Multi-select (user can select multiple foods)
  - "Log Meal" confirmation button
- **"Log Meal" action:** Creates food log entries for all selected items, dismisses sheet

### 3. Fluids
- **Default mode:** Mode 2 (Interval — every 2 hours between 8:00 AM and 10:00 PM)
- **Notification text:** "Time to log your fluids. What have you had?"
- **Response flow:** Tap notification → app opens to quick-entry fluids sheet
- **Quick-entry sheet contains:**
  - List of configured fluid types (water, coffee, tea, etc.)
  - Amount input per fluid type
  - "Log Fluids" confirmation button
- **"Log Fluids" action:** Creates fluid log entries, dismisses sheet

### 4. Photos
- **Default mode:** Mode 2 (Specific Times — user defines)
- **Notification text:** "Time for your photo check-in."
- **Response flow:** Tap notification → app opens directly to camera within the Photo Entry screen for the configured photo area
- **Post-capture:** Photo is saved to the configured area, sheet dismisses

### 5. Journal Entries
- **Default mode:** Mode 2 (Specific Times — default 9:00 PM)
- **Notification text:** "How was your day? Add a journal entry."
- **Response flow:** Tap notification → app opens to quick-entry journal sheet
- **Quick-entry sheet contains:**
  - Date (pre-filled with today)
  - Text entry field with keyboard focus
  - "Save Entry" button
- **"Save Entry" action:** Creates journal entry, dismisses sheet

### 6. Activities
- **Default mode:** Mode 2 (Specific Times — user defines)
- **Notification text:** "Did you do any physical activity today?"
- **Response flow:** Tap notification → app opens to Activity Log quick-entry sheet
- **Quick-entry sheet contains:**
  - Activity type selector (recent activities shown first)
  - Duration input
  - Intensity selector
  - "Log Activity" button

### 7. Condition Check-ins
- **Default mode:** Mode 1 (Anchor Events — once daily, user picks event)
- **Notification text:** "How are your conditions today? Time for your check-in."
- **Response flow:** Tap notification → app opens to Condition Log quick-entry sheet
- **Quick-entry sheet contains:**
  - List of active (non-archived) conditions
  - Severity slider per condition (1-10)
  - Notes field (optional)
  - "Save Check-in" button
- **"Save Check-in" action:** Creates condition log entries for all conditions shown, dismisses sheet

### 8. BBT / Vitals
- **Default mode:** Mode 1 (Wake anchor event only — BBT must be measured before getting out of bed)
- **Notification text:** "Good morning. Time to log your BBT and vitals."
- **Response flow:** Tap notification → app opens to Vitals quick-entry sheet
- **Quick-entry sheet contains:**
  - BBT input (temperature, unit per settings)
  - Optional fields: blood pressure, heart rate, weight, notes
  - "Save Vitals" button
- **"Save Vitals" action:** Creates vitals log entry, dismisses sheet
- **BBT note:** A reminder is shown on this sheet that BBT should be measured before getting out of bed for accuracy
- **Mode note:** BBT/Vitals should remain on Mode 1 Wake only in most cases — measuring BBT multiple times per day is not medically meaningful. The mode can technically be changed but the UI should warn the user if they switch away from Wake-only.

---

## Quick-Entry Sheet Behavior

All quick-entry sheets follow these consistent rules:

- Sheet slides up from the bottom (modal bottom sheet pattern)
- App background is visible but dimmed behind the sheet
- Sheet dismisses automatically after successful save
- User can dismiss without saving by swiping down or tapping outside the sheet
- If dismissed without saving, no data is logged and no notification is marked as responded
- Sheet is pre-populated with sensible defaults where possible (today's date, last-used values, etc.)
- Sheet is accessible — all elements have proper labels for screen readers

---

## Notification Scheduling

- Notifications are scheduled locally on the device — no server required
- Scheduling recalculates whenever the user changes any setting (mode, times, intervals, anchor events, enabled/disabled)
- Mode 2 interval notifications: all times within the active window are pre-scheduled daily
- Mode 2 specific times: each listed time is scheduled as a daily repeating notification
- Missed notifications expire after 1 hour by default (configurable per category)
- Do Not Disturb: notifications respect the device's system-level Do Not Disturb settings
- Notification permissions must be granted by the user on first use

---

## Notification Permission Flow

1. On first launch, user reaches the Settings screen
2. App shows an explanation screen: "Shadow can send you reminders to log your health data. You can configure exactly what reminders you receive and when."
3. User taps "Enable Notifications" → system permission prompt appears
4. If denied: app continues without notifications, user can enable later from Settings
5. If granted: notification scheduling begins based on current settings

---

## Technical Implementation Notes

- Use Flutter Local Notifications plugin (`flutter_local_notifications`)
- iOS: requires `UNUserNotificationCenter` configuration in `AppDelegate.swift`
- Android: requires notification channel configuration in `AndroidManifest.xml`
- Mode 2 interval scheduling: calculate all notification times within the window at scheduling time, schedule each as a one-time notification, reschedule daily
- Mode 2 specific times: schedule each as a daily repeating notification
- Notification tap routing: notification payload includes category type and relevant entity IDs so the app knows which quick-entry sheet to open
- Background app refresh must be configured for iOS to allow daily rescheduling
- All notification scheduling logic lives in a `NotificationService` class in the domain layer
- `NotificationService` depends on `SupplementRepository`, `ConditionRepository`, etc. to know what to schedule

---

## New Spec / Database Changes Required

### New Database Table: `notification_category_settings`
- id, category (enum), is_enabled, scheduling_mode (enum: anchor_events / interval / specific_times), anchor_events (JSON array), interval_hours (integer, nullable), interval_start_time (nullable), interval_end_time (nullable), specific_times (JSON array of time strings), expires_after_minutes

### New Database Table: `anchor_event_times`
- id, name (wake/breakfast/lunch/dinner/bedtime), display_name, time_of_day, is_enabled

### New Entity: `NotificationCategorySettings`
### New Entity: `AnchorEventTime`
### New Use Cases: `GetNotificationSettings`, `UpdateNotificationCategorySettings`, `GetAnchorEventTimes`, `UpdateAnchorEventTime`, `ScheduleNotifications`, `CancelNotifications`
