# 58 — Settings Screens
**Status:** COMPLETE — Phase 14 implemented
**Target Phase:** Phase 14
**Created:** 2026-02-22
**Completed:** 2026-02-24

---

## Overview

Shadow has three settings screens beyond Cloud Sync (already built): Notification Settings, Units Settings, and Security Settings. All security features are optional — the app is fully usable without enabling any of them. Settings are stored locally in the database and synced to Google Drive as part of the user's profile data.

---

## Settings Navigation

Settings are accessible from the main navigation. The Settings section contains:
- Cloud Sync Settings (already built — Phase 4)
- Notification Settings
- Units Settings
- Security Settings

---

## Screen 1: Notification Settings

### Purpose
Configure anchor event times and enable/disable notification prompts per reporting category.

### Section 1: Anchor Event Times
A list of all 8 anchor events with their configured times. Each row shows:
- Event name (Wake, Breakfast, Morning, Lunch, Afternoon, Dinner, Evening, Bedtime)
- Configured time (e.g. "7:00 AM")
- Enable/disable toggle
- Tap to edit time via time picker

No custom/user-defined anchor events. The 8 named events are fixed. See DECISIONS.md 2026-02-25 for the rationale and the enum migration requirement.

### Section 2: Notification Categories
A list of all reporting categories. Each row shows:
- Category name and icon
- Master enable/disable toggle
- When enabled: expandable sub-section showing which anchor events trigger this category
- Supplement category: additional note that per-supplement control is available in Supplement Edit

**Categories listed:**
1. Supplements
2. Food / Meals
3. Fluids
4. Photos
5. Journal Entries
6. Activities
7. Condition Check-ins
8. BBT / Vitals

### Section 3: General Notification Settings
- **Notification expiry:** How long after scheduled time a notification remains actionable (default: 60 minutes). Options: 30 min, 60 min, 2 hours, Until dismissed.
- **Permission status:** Shows current notification permission status. If denied, shows "Open System Settings" button.

---

## Screen 2: Units Settings

### Purpose
Configure display units for all measurements in the app. Changes apply globally — all existing data is displayed in the new unit (conversion happens at display time, raw data is always stored in a canonical unit).

### Section 1: Weight
- **Body weight:** kg / lbs (toggle)
- **Food weight:** grams / ounces (toggle)

### Section 2: Volume
- **Fluids:** ml / fl oz (toggle)

### Section 3: Temperature
- **Body temperature:** Celsius / Fahrenheit (toggle)
- Note shown: "For accurate BBT tracking, always use the same unit consistently."

### Section 4: Nutritional Values
- **Energy:** Calories (kcal) / Kilojoules (kJ) (toggle)
- **Macro display:** Grams / Percentage of daily target (toggle — only relevant when macro targets are set)

### Canonical Storage Units
These are stored in the database regardless of display setting:
- Weight: grams
- Volume: milliliters
- Temperature: Celsius
- Energy: kilocalories

---

## Screen 3: Security Settings

### Purpose
Optionally protect the app with a PIN or biometric authentication. All features on this screen are opt-in. The app works fully without any security enabled.

### Section 1: App Lock
- **Enable App Lock** — master toggle (default: OFF)
- When OFF: all options below are hidden/disabled
- When ON: reveals the following options:

### Section 2: Authentication Method (shown when App Lock is ON)
- **Biometric authentication** — toggle (Face ID / fingerprint, depending on device)
  - If device does not support biometrics: option is shown as unavailable with explanation
  - If enabled: biometric is used as primary authentication method
- **PIN / Passcode** — always available as fallback or primary method
  - "Set PIN" button → opens PIN entry flow (enter 6-digit PIN, confirm PIN)
  - "Change PIN" button (shown when PIN is already set)
  - "Remove PIN" button (shown when PIN is already set, requires current PIN to confirm)

### Section 3: Auto-Lock Timing (shown when App Lock is ON)
- **Lock after:** Immediately / 1 minute / 5 minutes / 15 minutes / 1 hour
- Default: 5 minutes
- "Immediately" means app locks as soon as it goes to background

### Section 4: Additional Options (shown when App Lock is ON)
- **Hide content in app switcher** — toggle (default: ON when App Lock is enabled)
  - When ON: app shows a blank screen in the iOS/Android app switcher instead of the last viewed screen
- **Allow biometric bypass of PIN** — toggle (shown only when both biometric and PIN are enabled)

### Lock Screen Behavior
- When app is locked: shows a lock screen with Shadow logo and authentication prompt
- Biometric prompt appears automatically if biometric is enabled
- PIN entry shown as fallback or primary
- "Forgot PIN" option: requires user to sign in with Google to reset (verifies identity via existing OAuth)
- While locked: no app content is visible, notifications still fire normally

### First-Time PIN Setup Flow
1. User taps "Enable App Lock"
2. App prompts: "Set a PIN to secure Shadow"
3. User enters 6-digit PIN
4. User re-enters PIN to confirm
5. App Lock is now enabled with PIN
6. If device supports biometrics: "Would you also like to enable Face ID / fingerprint?" prompt appears

### Technical Implementation Notes
- Use `local_auth` Flutter plugin for biometric authentication
- PIN stored as bcrypt hash in secure storage (`flutter_secure_storage`), never in plain text
- Auto-lock implemented via `AppLifecycleState` listener
- App switcher content hiding: iOS uses `UIApplication.ignoreSnapshotOnNextApplicationLaunch`, Android uses `FLAG_SECURE` window flag
