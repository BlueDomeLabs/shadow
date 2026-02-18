# Shadow UI Field Specifications

**Version:** 1.0
**Last Updated:** January 31, 2026
**Purpose:** Complete field-by-field specifications for every screen

---

## 1. Overview

This document specifies every input field on every screen in the Shadow application, including:
- Field name and type
- Required vs optional
- Validation rules
- Default values
- Placeholder text
- Character limits
- Accessibility labels

---

## 2. Authentication Screens

### 2.1 Welcome Screen

**Purpose:** First-time launch, choose authentication method

| Element | Type | Description |
|---------|------|-------------|
| App Logo | Image | Shadow logo, 120x120px |
| Tagline | Text | "Your private health companion" |
| "Sign in with Apple" | Button | Primary CTA (Apple platforms) |
| "Sign in with Google" | Button | Primary CTA |
| "Continue Offline" | Button | Secondary, no account mode |
| "Learn More" | Link | Opens privacy/features page |

**Accessibility:**
- VoiceOver: "Shadow. Your private health companion. Sign in with Apple button. Sign in with Google button. Continue offline button."

### 2.2 Sign In Screen

**Purpose:** OAuth authentication

No input fields - handled by native OAuth sheets.

---

## 3. Profile Screens

### 3.1 Add/Edit Profile Screen

**Purpose:** Create or modify a health profile

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Profile Name | Text | Yes | Min 2 chars | - | "e.g., John Smith" | 100 |
| Birth Date | Date Picker | No | Must be past date | - | "Select date" | - |
| Biological Sex | Dropdown | No | Male/Female/Other/Prefer not to say | - | "Select" | - |
| Ethnicity | Text | No | - | - | "e.g., Caucasian" | 100 |
| Notes | Text Area | No | - | - | "Any additional notes about this profile" | 2000 |
| Diet Type | Dropdown | No | None/Vegan/Vegetarian/Paleo/Keto/Gluten-Free/Other | None | "Select diet" | - |
| Diet Description | Text | No | Only if Diet Type = Other | - | "Describe your diet" | 500 |
| Profile Photo | Image Picker | No | Max 5MB, JPEG/PNG | Initials avatar | - | - |

**Buttons:**
- Save (Primary) - Validates and saves
- Cancel (Secondary) - Discards changes with confirmation if dirty

**Validation Messages:**
- "Profile name is required"
- "Profile name must be at least 2 characters"
- "Birth date cannot be in the future"

---

## 4. Supplement Screens

### 4.1 Add/Edit Supplement Screen

**Purpose:** Create or modify a supplement

#### Basic Information Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Supplement Name | Text | Yes | Min 2 chars | - | "e.g., Vitamin D3" | 200 |
| Brand | Text | No | - | - | "e.g., NOW Foods" | 200 |
| Form | Dropdown | Yes | Capsule/Tablet/Powder/Liquid/Gummy/Spray/Other | Capsule | - | - |
| Custom Form | Text | Conditional | Only if Form = Other | - | "Describe form" | 100 |

#### Dosage Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Dosage Amount | Number | Yes | > 0, max 6 decimals | - | "e.g., 2000" | 15 |
| Dosage Unit | Dropdown | Yes | mg/mcg/g/IU/HDU/mL/drops/tsp/custom | mg | - | - |
| Custom Unit | Text | Conditional | Only if Unit = custom | - | "e.g., billion CFU" | 50 |
| Quantity Per Dose | Number | Yes | ≥ 1, integer | 1 | "1" | 5 |

#### Ingredients Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Ingredient List | Tag Input | No | - | [] | "Add ingredient..." | 100 per tag |

**Add Ingredient Flow:**
1. Type ingredient name
2. Press Enter or comma to add
3. Click X on tag to remove

#### Schedule Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Frequency | Dropdown | Yes | Daily/Every X Days/Specific Days | Daily | - | - |
| Every X Days | Number | Conditional | 2-365 | 2 | "2" | 3 |
| Specific Days | Multi-select | Conditional | At least 1 day | All selected | - | - |
| Anchor Event | Dropdown | Yes | With Breakfast/Lunch/Dinner/Morning/Evening/Bedtime/Specific Time | With Breakfast | - | - |
| Timing | Dropdown | Yes | With/Before/After | With | - | - |
| Offset Minutes | Number | Conditional | 5-120, step 5 | 30 | "30" | 3 |
| Specific Time | Time Picker | Conditional | - | 08:00 | "Select time" | - |
| Start Date | Date Picker | No | Today or future | Today | "Start date" | - |
| End Date | Date Picker | No | After start date | - | "End date (optional)" | - |

**Notes Field:**

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Notes | Text Area | No | - | - | "Any notes about this supplement" | 2000 |

---

### 4.2 Log Supplement Intake Screen

**Purpose:** Record taking/skipping a supplement

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Status | Segment | Yes | Taken/Skipped/Snoozed | Taken | - | - |
| Actual Time | Time Picker | Conditional | Required if Taken | Now | "Time taken" | - |
| Snooze Duration | Dropdown | Conditional | 5/10/15/30/60 min | 15 min | - | - |
| Skip Reason | Dropdown | Conditional | Forgot/Side Effects/Out of Stock/Other | - | "Select reason" | - |
| Custom Reason | Text | Conditional | Only if Reason = Other | - | "Describe reason" | 200 |
| Notes | Text | No | - | - | "Any additional notes" | 500 |

---

## 5. Food Screens

### 5.1 Log Food Screen

**Purpose:** Record a meal or snack

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Date & Time | DateTime Picker | Yes | Not future | Now | - | - |
| Meal Type | Segment | No | Breakfast/Lunch/Dinner/Snack | Auto-detect: Breakfast (5:00-10:59), Lunch (11:00-14:59), Dinner (15:00-20:59), Snack (other times) | - | - |
| Food Items | Multi-select | No | - | [] | "Search foods..." | - |
| Ad-hoc Items | Tag Input | No | - | [] | "Add item not in library..." | 100 per tag |
| Notes | Text Area | No | - | - | "Any notes about this meal" | 1000 |

**Food Search:**
- Searches user's food library
- Shows recent foods first
- Allows creating new food inline

---

### 5.2 Add/Edit Food Item Screen

**Purpose:** Add a food to the library

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Food Name | Text | Yes | Min 2 chars | - | "e.g., Grilled Chicken" | 200 |
| Type | Segment | Yes | Simple/Composed | Simple | - | - |
| Ingredients | Multi-select | Conditional | Required if Composed | [] | "Select ingredients..." | - |
| Notes | Text Area | No | - | - | "Notes about this food" | 1000 |

---

## 6. Fluids Screens

### 6.1 Add Fluids Entry Screen

**Purpose:** Log fluid-related health data

#### Header Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Date & Time | DateTime Picker | Yes | Not future | Now | - | - |

#### Water Intake Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Water Amount | Number + Unit | No | ≥ 0 | - | "Amount" | 10 |
| Water Unit | Dropdown | No | mL/fl oz | Based on preferences | - | - |
| Quick Add Buttons | Button Group | No | 8oz/12oz/16oz or 250/350/500 mL | - | - | - |
| Water Notes | Text | No | - | - | "e.g., with lemon" | 200 |

#### Bowel Movement Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Had Bowel Movement | Toggle | No | - | No | - | - |
| Condition | Dropdown | Conditional | Diarrhea/Runny/Loose/Normal/Firm/Hard/Custom | - | "Select" | - |
| Custom Condition | Text | Conditional | Only if Custom | - | "Describe" | 100 |
| Size | Dropdown | Conditional | Tiny/Small/Medium/Large/Huge | Medium | - | - |
| Add Photo | Image Picker | No | Max 10MB raw, 2MB after compression | - | "Add photo" | - |

#### Urine Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Had Urination | Toggle | No | - | No | - | - |
| Color | Dropdown | Conditional | Clear/Light Yellow/Yellow/Dark Yellow/Amber/Custom | - | "Select color" | - |
| Custom Color | Text | Conditional | Only if Custom | - | "Describe" | 100 |
| Size | Dropdown | Conditional | Small/Medium/Large | Medium | - | - |
| Urgency | Slider | Conditional | 1-5 scale | 3 | - | - |

#### Menstruation Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Flow Level | Segment | No | None/Spotty/Light/Medium/Heavy | None | - | - |

#### BBT Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Temperature | Number | No | 95-105°F or 35-40.5°C | - | "e.g., 98.6" | 6 |
| Temperature Unit | Dropdown | No | °F/°C | Based on preferences | - | - |
| Time Recorded | Time Picker | No | - | Now | "Time measured" | - |

#### Custom Fluid Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Fluid Name | Text + Autocomplete | No | - | - | "e.g., Sweat, Mucus" | 100 |
| Amount | Text | No | - | - | "e.g., Light, Heavy, 2 tbsp" | 100 |
| Notes | Text | No | - | - | "Additional details" | 500 |

---

## 7. Sleep Screens

### 7.1 Add/Edit Sleep Entry Screen

**Purpose:** Log a night's sleep

#### Time Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Sleep Date | Date Picker | Yes | Not future | Last night (date when sleep started; overnight sleep spans two calendar dates, use start date) | - | - |
| Bed Time | Time Picker | Yes | - | 10:30 PM | "When did you go to bed?" | - |
| Wake Time | Time Picker | Yes | After bed time | 6:30 AM | "When did you wake up?" | - |

#### Sleep Quality Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Time to Fall Asleep | Dropdown | No | Immediately/5 min/15 min/30 min/1 hour/1+ hours | - | "How long to fall asleep?" | - |
| Times Awakened | Number | No | 0-20, integer | 0 | "Number of times" | 2 |
| Time Awake During Night | Dropdown | No | None/A few min/15 min/30 min/1 hour/1+ hours | None | - | - |

#### Sleep Breakdown Section (Optional)

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Deep Sleep | Duration Picker | No | 0 - total sleep | - | "Hours of deep sleep" | - |
| Light Sleep | Duration Picker | No | 0 - total sleep | - | "Hours of light sleep" | - |
| Restless Sleep | Duration Picker | No | 0 - total sleep | - | "Hours of restless sleep" | - |

#### Waking Section

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Waking Feeling | Segment | No | Groggy/Neutral/Rested/Energized | Neutral | - | - |
| Dream Type | Dropdown | No | No Dreams/Vague/Vivid/Nightmares | No Dreams | - | - |
| Notes | Text Area | No | - | - | "Any notes about your sleep" | 1000 |

---

## 8. Condition Screens

### 8.1 Add Condition Screen

**Purpose:** Create a new health condition to track

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Condition Name | Text | Yes | Min 2 chars | - | "e.g., Eczema" | 200 |
| Category | Dropdown | Yes | Skin/Digestive/Respiratory/Autoimmune/Mental Health/Pain/Other | - | "Select category" | - |
| Body Locations | Multi-select | Yes | At least 1 | - | "Select affected areas" | - |
| Description | Text Area | No | - | - | "Describe the condition" | 2000 |
| Start Timeframe | Dropdown | Yes | This week/This month/This year/1-2 years/2-5 years/5+ years/Since birth/Unknown | - | - | - |
| Status | Segment | Yes | Active/Resolved | Active | - | - |
| Baseline Photo | Image Picker | No | Max 5MB | - | "Add baseline photo" | - |

**Body Location Options:**
Head, Face, Neck, Chest, Back, Stomach, Arms, Hands, Legs, Feet, Joints, Internal, Whole Body, Other

---

### 8.2 Log Condition Entry Screen

**Purpose:** Record daily condition status

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Date & Time | DateTime Picker | Yes | Not future | Now | - | - |
| Severity | Slider | Yes | 1-10 | 5 | - | - |
| Severity Labels | Display | - | 1=Minimal, 5=Moderate, 10=Severe | - | - | - |
| Is Flare-up | Toggle | No | - | No | - | - |
| Triggers | Multi-select | No | From condition's trigger list + Add new | [] | "Select triggers" | - |
| Add New Trigger | Text + Button | No | - | - | "Add new trigger" | 100 |
| Photos | Multi-Image Picker | No | Max 5 photos, 5MB each | - | "Add photos" | - |
| Notes | Text Area | No | - | - | "Notes about today" | 2000 |

---

## 9. Activity Screens

### 9.1 Add/Edit Activity Screen

**Purpose:** Create an activity template

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Activity Name | Text | Yes | Min 2 chars | - | "e.g., Morning Jog" | 200 |
| Description | Text Area | No | - | - | "Describe this activity" | 1000 |
| Default Duration | Duration Picker | Yes | 1 min - 24 hours | - | "Duration in minutes" | - |
| Location | Text | No | - | - | "e.g., Local park" | 200 |
| Potential Triggers | Text | No | - | - | "e.g., stress, weather" | 500 |

---

### 9.2 Log Activity Screen

**Purpose:** Record an activity instance

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Date & Time | DateTime Picker | Yes | Not future | Now | - | - |
| Activities | Multi-select | No | - | [] | "Select activities" | - |
| Ad-hoc Activities | Tag Input | No | - | [] | "Add unlisted activity" | 100 per tag |
| Actual Duration | Duration Picker | No | 1 min - 24 hours | From template | "Actual duration" | - |
| Notes | Text Area | No | - | - | "Notes about this activity" | 1000 |

---

## 10. Journal Screens

### 10.1 Add/Edit Journal Entry Screen

**Purpose:** Create a journal entry

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Date & Time | DateTime Picker | Yes | - | Now | - | - |
| Title | Text | No | - | - | "Entry title (optional)" | 200 |
| Content | Rich Text Area | Yes | Min 10 chars | - | "Write your thoughts..." | 50000 |
| Tags | Tag Input | No | - | [] | "Add tags" | 50 per tag |
| Mood | Slider | No | 1-10 | - | "How are you feeling?" | - |
| Audio Note | Audio Recorder | No | Max 5 min | - | "Record audio note" | - |

**Mood Scale:** 1 (Very Low) to 10 (Excellent)

---

## 11. Photo Screens

### 11.1 Add/Edit Photo Area Screen

**Purpose:** Define a body area for photos

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Area Name | Text | Yes | Min 2 chars | - | "e.g., Left Arm" | 200 |
| Description | Text Area | No | - | - | "Describe this area" | 500 |
| Consistency Notes | Text Area | No | - | - | "Tips for consistent photos (lighting, angle)" | 1000 |

---

### 11.2 Take Photo Screen

**Purpose:** Capture a photo for an area

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Photo | Camera/Gallery | Yes | Max 10MB raw, 2MB after compression | - | - | - |
| Date & Time | DateTime Picker | Yes | Not future | Now | - | - |
| Notes | Text | No | - | - | "Notes about this photo" | 500 |

---

## 12. Notification Settings Screen

### 12.1 Notification Preferences

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Enable All Notifications | Toggle | No | - | Yes | - | - |
| Supplement Reminders | Toggle | No | - | Yes | - | - |
| Meal Reminders | Toggle | No | - | No | - | - |
| Water Reminders | Toggle | No | - | No | - | - |
| Sleep Reminders | Toggle | No | - | No | - | - |
| Fluids Reminders | Toggle | No | - | No | - | - |
| Condition Check-ins | Toggle | No | - | No | - | - |
| Photo Reminders | Toggle | No | - | No | - | - |
| Quiet Hours Start | Time Picker | No | - | 10:00 PM | - | - |
| Quiet Hours End | Time Picker | No | - | 7:00 AM | - | - |
| Respect System DND | Toggle | No | - | Yes | - | - |

---

## 13. Settings Screens

### 13.1 Units Settings Screen

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Measurement System | Segment | Yes | Metric/Imperial | Based on locale | - | - |
| Temperature | Segment | Yes | °C/°F | Based on locale | - | - |
| Volume | Segment | Yes | mL, L / fl oz, gal | Based on system | - | - |
| Weight | Segment | Yes | g, kg / oz, lb | Based on system | - | - |

### 13.2 Cloud Sync Setup Screen

First-time cloud sync onboarding wizard. This screen has three visual states based on `CloudSyncAuthState` (see `22_API_CONTRACTS.md` Section 16.10).

**Screen route**: `CloudSyncSetupScreen` (`lib/presentation/screens/cloud_sync/cloud_sync_setup_screen.dart`)

**App bar title**: "Set Up Cloud Sync"

**Semantics**: Screen wrapped in `Semantics(label: 'Cloud sync setup screen')`. Skip button has `Semantics(label: 'Skip cloud sync setup')`.

#### 13.2.1 Initial State (Not Authenticated, Not Loading)

| Element | Type | Content | Behavior |
|---------|------|---------|----------|
| Header Icon | Icon | `Icons.cloud_sync` (80px, primary color) | Circular container with `primaryContainer` background |
| Title | Heading | "Back Up and Sync Your Data" | `headlineMedium`, bold |
| Subtitle | Body Text | "Keep your health data safe and accessible across devices." | `bodyLarge`, grey |
| Benefit: Backup | Row | `Icons.backup` + "Automatic Backup" + "Never lose your data — automatic cloud backup" | Icon in rounded container |
| Benefit: Sync | Row | `Icons.sync` + "Multi-Device Sync" + "Access your data from any device" | Icon in rounded container |
| Benefit: Security | Row | `Icons.security` + "Secure & Private" + "End-to-end encrypted for your privacy" | Icon in rounded container |
| Google Drive Button | Card/InkWell | `Icons.cloud_circle` + "Google Drive" + "Use your Google account for sync" + chevron | Tapping calls `signInWithGoogle()` |
| iCloud Button | Card/InkWell | `Icons.cloud` + "iCloud" + "Use your Apple account for sync" + chevron | Only shown on iOS/macOS. Shows "Coming Soon" dialog |
| Local Only Button | Card/InkWell | `Icons.smartphone` + "Local Only" + "Store all data on this device only" + chevron | Tapping calls `Navigator.pop(context)` |
| Maybe Later | TextButton | "Maybe Later" | Tapping calls `Navigator.pop(context)` |

#### 13.2.2 Loading State (isLoading = true)

When the user taps Google Drive and sign-in is in progress:

| Element | Change from Initial State |
|---------|--------------------------|
| Google Drive Icon | Replaced with `CircularProgressIndicator` (32x32, strokeWidth 3) |
| Google Drive Title | Changes to "Signing in..." |
| Google Drive Subtitle | Changes to "Complete sign-in in your browser" |
| Chevron Icon | Hidden (not shown while loading) |
| Google Drive InkWell | `onTap` set to `null` (disabled) |

All other elements (benefits, Local Only, Maybe Later) remain visible.

#### 13.2.3 Authenticated State (isAuthenticated = true)

When sign-in completes successfully, the entire screen changes:

| Element | Type | Content | Behavior |
|---------|------|---------|----------|
| Header Icon | Icon | `Icons.cloud_done` (80px, green) | Circular container with green background |
| Title | Heading | "Cloud Sync Connected" | Replaces initial title |
| Subtitle | Body Text | "Signed in as {userEmail}" (or "Signed in as unknown" if email is null) | Shows user identity |
| Info Card | Card | `Icons.check_circle` (green) + "Google Drive" + user email (or "Connected") | Confirmation of provider and account |
| Done Button | ElevatedButton | "Done" | Full-width, primary color, calls `Navigator.pop(context)` |
| Sign Out Button | TextButton | "Sign Out" | Grey text, calls `signOut()`. Disabled while isLoading |

**Hidden in authenticated state**: Benefits list, Google Drive sign-in button, iCloud button, Local Only button, Maybe Later button.

#### 13.2.4 Error State (errorMessage != null)

An error banner appears above the provider buttons (or above the signed-in section if also authenticated):

| Element | Type | Content | Behavior |
|---------|------|---------|----------|
| Error Banner | Container | Red background with red border | `Semantics(liveRegion: true, label: 'Error: {message}')` |
| Error Icon | Icon | `Icons.error_outline` (red, 20px) | Left side of banner |
| Error Text | Text | The error message string | Red, 14px, expands to fill |
| Dismiss Button | IconButton | `Icons.close` (18px) | Calls `clearError()`, tooltip "Dismiss error" |

If the user is not authenticated, the provider buttons (Google Drive, Local Only, etc.) remain visible below the error banner so they can try again.

### 13.3 Cloud Sync Settings Screen

**Source:** `CloudSyncSettingsScreen` (`ConsumerWidget`) watches `cloudSyncAuthProvider` for real-time auth state.

#### 13.3.1 Not Authenticated State (isAuthenticated = false)

| Element | Type | Content | Notes |
|---------|------|---------|-------|
| App Bar Title | Text | "Cloud Sync" | - |
| Status Icon | Icon | `Icons.cloud_off` | Grey color |
| Status Label | Text | "Sync Status" | Bold |
| Status Value | Text | "Not configured" | Grey color |
| Auto Sync Toggle | Switch | Off | Tapping shows "Coming Soon" dialog |
| WiFi Only Toggle | Switch | On | Tapping shows "Coming Soon" dialog |
| Sync Frequency | ListTile | "Every 30 minutes" | Tapping shows "Coming Soon" dialog |
| Setup Button | ElevatedButton | "Set Up Cloud Sync" | Cloud sync icon; navigates to `CloudSyncSetupScreen` |
| Platform | Display | Current platform name | e.g., "macos" |
| Sync Provider | Display | "None" | - |
| Last Sync | Display | "Never" | - |

#### 13.3.2 Authenticated State (isAuthenticated = true)

| Element | Type | Content | Notes |
|---------|------|---------|-------|
| Status Icon | Icon | `Icons.cloud_done` | Green color |
| Status Value | Text | "Connected to Google Drive" | Green color |
| User Email | Text | User's email address | Grey, shown below status value |
| Setup Button | ElevatedButton | "Manage Cloud Sync" | Settings icon; navigates to `CloudSyncSetupScreen` |
| Sync Provider | Display | "Google Drive" | - |
| Last Sync | Display | "Never" | Updated when sync is implemented (Phase 4) |

All other elements (App Bar, toggles, frequency) remain the same as the not-authenticated state.

### 13.4 Security Settings Screen

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| App Lock | Toggle | No | - | No | - | - |
| Lock Method | Dropdown | Conditional | Biometric/PIN/Both | Biometric | - | - |
| PIN | Secure Text | Conditional | 4-6 digits | - | "Enter PIN" | 6 |
| Lock Timeout | Dropdown | Conditional | Immediately/1 min/5 min/15 min | Immediately | - | - |
| Show in Recent Apps | Toggle | No | - | Yes | - | - |

---

## 14. Conditional Field Validation Rules

This section clarifies the behavior of conditional fields throughout the application.

### Conditional Field Validation Rules

When a conditional field becomes visible:
1. REQUIRED conditional fields MUST be validated immediately on visibility change
2. If conditional field has a default value, pre-populate it
3. Validation error shows if required field is visible but empty on form submit
4. When parent field changes making conditional hidden, clear conditional field value

Example: Supplement Timing
- IF timingType = 'beforeEvent' OR 'afterEvent', THEN offsetMinutes is REQUIRED
- IF timingType = 'specificTime', THEN specificTimeMinutes is REQUIRED
- IF timingType = 'withEvent', THEN neither is required

### 14.1 Conditional Field Visibility

Conditional fields are shown or hidden based on parent field values:

| Parent Field | Parent Value | Conditional Field | Behavior |
|--------------|--------------|-------------------|----------|
| Form | "Other" | Custom Form | SHOWN |
| Form | Any other value | Custom Form | HIDDEN |
| Dosage Unit | "custom" | Custom Unit | SHOWN |
| Dosage Unit | Any other value | Custom Unit | HIDDEN |
| Frequency | "Every X Days" | Every X Days | SHOWN |
| Frequency | "Specific Days" | Specific Days | SHOWN |
| Timing | "Before" or "After" | Offset Minutes | SHOWN |
| Timing | "With" | Offset Minutes | HIDDEN |
| Anchor Event | "Specific Time" | Specific Time | SHOWN |
| Diet Type | "Other" | Diet Description | SHOWN |
| Had Bowel Movement | true | Condition, Size, Photo | SHOWN |
| Had Urination | true | Color, Size, Urgency | SHOWN |
| App Lock | true | Lock Method, PIN, Lock Timeout | SHOWN |
| Enable Eating Window | true | Window Start, Window End | SHOWN |
| Enable Carb Limit | true | Max Carbs | SHOWN |
| Enable Calorie Limit | true | Max Calories | SHOWN |

### 14.2 Validation When Parent Condition is False

When a conditional field's parent condition evaluates to false:

1. **Validation is SKIPPED** - The field is not validated regardless of its value
2. **Field is not required** - Even if marked as "required when shown", the requirement is waived
3. **Server-side validation** - Backend ignores conditional fields when parent condition is false

**Example:**
- If `Form = "Capsule"`, the `Custom Form` field is hidden
- Even if `Custom Form` contains invalid data, the form saves successfully
- The invalid data in `Custom Form` is ignored during validation

### 14.3 Value Preservation vs Clearing

When a conditional field is hidden:

| Behavior | Fields | Rationale |
|----------|--------|-----------|
| **PRESERVED** | Custom Form, Custom Unit, Custom Condition, Custom Color, Diet Description, Custom Reason | User may switch back; preserves work |
| **CLEARED** | Offset Minutes (when switching to "With"), Specific Time (when switching away from "Specific Time"), Window Start/End (when disabling eating window) | Values become invalid in new context |

**Implementation Rule:**
- Text fields with user-entered custom values: PRESERVE
- Numeric/time fields that become contextually invalid: CLEAR
- On form submission: Only submit values for VISIBLE conditional fields

### 14.4 Field Requirement States

Fields have three possible requirement states:

| State | Symbol | Description | Validation Behavior |
|-------|--------|-------------|---------------------|
| **REQUIRED** | * | Must have value to save | Block save if empty; show error message |
| **OPTIONAL** | (none) | May be empty | No validation; save proceeds with null/empty |
| **CONDITIONAL_REQUIRED** | *† | Required IF condition met | Validate only when condition is true |

**CONDITIONAL_REQUIRED Field Specifications:**

| Field | Condition | Required When |
|-------|-----------|---------------|
| Custom Form | Form = "Other" | Always when visible |
| Custom Unit | Dosage Unit = "custom" | Always when visible |
| Every X Days | Frequency = "Every X Days" | Always when visible |
| Specific Days | Frequency = "Specific Days" | At least 1 day selected |
| Offset Minutes | Timing = "Before" OR "After" | Always when visible |
| Specific Time | Anchor Event = "Specific Time" | Always when visible |
| Diet Description | Diet Type = "Other" | Always when visible |
| Condition (bowel) | Had Bowel Movement = true | Always when visible |
| Color (urine) | Had Urination = true | Always when visible |
| Ingredients | Food Type = "Composed" | At least 1 ingredient |
| PIN | Lock Method = "PIN" OR "Both" | Always when visible |
| Window Start/End | Enable Eating Window = true | Always when visible |
| Max Carbs | Enable Carb Limit = true | Always when visible |
| Max Calories | Enable Calorie Limit = true | Always when visible |

---

## 15. Supplement Timing Field Dependencies

This section specifies the exact field dependencies for supplement scheduling based on timing type.

### 15.1 Timing Type Definitions

| timingType Value | Description | UI Label |
|------------------|-------------|----------|
| `withEvent` | Take at the same time as anchor event | "With" |
| `beforeEvent` | Take before anchor event | "Before" |
| `afterEvent` | Take after anchor event | "After" |
| `specificTime` | Take at a specific clock time | "At Specific Time" |

### 15.2 Field Requirements by Timing Type

#### When timingType = "withEvent"
```
anchorEvent:     REQUIRED (Breakfast/Lunch/Dinner/Morning/Evening/Bedtime)
offsetMinutes:   OPTIONAL (defaults to 0, field hidden in UI)
specificTimeMinutes: IGNORED (not applicable)
```

#### When timingType = "beforeEvent" or "afterEvent"
```
anchorEvent:     REQUIRED (Breakfast/Lunch/Dinner/Morning/Evening/Bedtime)
offsetMinutes:   REQUIRED (5-120 minutes, step of 5)
specificTimeMinutes: IGNORED (not applicable)
```

#### When timingType = "specificTime"
```
anchorEvent:     IGNORED (field hidden, value not used in scheduling)
offsetMinutes:   IGNORED (not applicable)
specificTimeMinutes: REQUIRED (0-1439, represents minutes from midnight)
```

### 15.3 Validation Rules

```dart
void validateSupplementTiming(Supplement supplement) {
  switch (supplement.timingType) {
    case TimingType.withEvent:
      assert(supplement.anchorEvent != null, 'anchorEvent required for withEvent');
      // offsetMinutes defaults to 0 if not provided
      break;

    case TimingType.beforeEvent:
    case TimingType.afterEvent:
      assert(supplement.anchorEvent != null, 'anchorEvent required for before/afterEvent');
      assert(supplement.offsetMinutes != null, 'offsetMinutes required for before/afterEvent');
      assert(supplement.offsetMinutes! >= 5 && supplement.offsetMinutes! <= 120,
             'offsetMinutes must be 5-120');
      break;

    case TimingType.specificTime:
      assert(supplement.specificTimeMinutes != null, 'specificTimeMinutes required for specificTime');
      assert(supplement.specificTimeMinutes! >= 0 && supplement.specificTimeMinutes! < 1440,
             'specificTimeMinutes must be 0-1439');
      // anchorEvent value is ignored even if present
      break;
  }
}
```

### 15.4 UI Behavior

| User Selects | Fields Shown | Fields Hidden |
|--------------|--------------|---------------|
| "With Breakfast" | (none additional) | Offset Minutes, Specific Time |
| "30 min Before Lunch" | Offset Minutes dropdown | Specific Time |
| "15 min After Dinner" | Offset Minutes dropdown | Specific Time |
| "At Specific Time" | Time Picker | Anchor Event, Offset Minutes |

---

## 16. Common Field Behaviors

### 16.1 Date/Time Picker Defaults

| Context | Date Default | Time Default |
|---------|--------------|--------------|
| Logging past event | Today | Current time |
| Scheduling future | Today | Next hour |
| Sleep (bed time) | Last night | 10:30 PM |
| Sleep (wake time) | Today | 6:30 AM |
| BBT | Today | Current time |

### 16.2 Validation Timing

- **On blur:** Validate when user leaves field
- **On submit:** Full form validation
- **Real-time:** Character counts, format hints

### 16.3 Error Display

- Red border on invalid field
- Error message below field
- Scroll to first error on submit
- Clear error when user starts typing

---

## 17. Diet Screens

### 15.1 Diet Selection Screen

**Purpose:** Choose and activate a diet

| Field | Type | Required | Validation | Default | Placeholder |
|-------|------|----------|------------|---------|-------------|
| Search | Text | No | None | Empty | "Search diets..." |
| Diet List | Selection | Yes | One selected | None | - |
| Diet Category Filter | Segmented | No | None | "All" | - |

**Diet Categories (complete list):**
- All
- Food Restriction: Vegan, Vegetarian, Pescatarian, Paleo, Mediterranean
- Time-Based: IF 16:8, IF 18:6, IF 20:4, OMAD, 5:2
- Macronutrient: Keto (Strict), Keto (Standard), Low-Carb, Zone
- Elimination: Whole30, AIP, Low-FODMAP, Gluten-Free, Dairy-Free

See 41_DIET_SYSTEM.md Section 2.2 for complete preset library.

### 17.2 Custom Diet Builder Screen

**Purpose:** Create or edit custom diet

| Field | Type | Required | Validation | Default | Placeholder | Max Length |
|-------|------|----------|------------|---------|-------------|------------|
| Diet Name | Text | Yes | Min 2 chars | Empty | "My Diet" | 50 |
| Start From | Picker | No | Valid preset | "Blank" | - | - |
| Start Date | Date | No | Not in past | Today | "Select date" | - |
| End Date | Date | No | After start | None | "Ongoing" | - |
| Enable Eating Window | Switch | No | None | Off | - | - |
| Window Start | Time | Conditional* | Valid time | 12:00 PM | "Select time" | - |
| Window End | Time | Conditional* | After start | 8:00 PM | "Select time" | - |

*Required if "Enable Eating Window" is on (see Section 14.4 CONDITIONAL_REQUIRED)

**Food Exclusion Section:**

| Field | Type | Required | Default |
|-------|------|----------|---------|
| Exclude Meat | Checkbox | No | Off |
| Exclude Poultry | Checkbox | No | Off |
| Exclude Fish | Checkbox | No | Off |
| Exclude Eggs | Checkbox | No | Off |
| Exclude Dairy | Checkbox | No | Off |
| Exclude Grains | Checkbox | No | Off |
| Exclude Legumes | Checkbox | No | Off |
| Exclude Nuts | Checkbox | No | Off |
| Exclude Sugar | Checkbox | No | Off |
| Exclude Gluten | Checkbox | No | Off |
| Exclude Processed | Checkbox | No | Off |
| Exclude Alcohol | Checkbox | No | Off |

**Macro Limits Section:**

| Field | Type | Required | Validation | Default | Unit |
|-------|------|----------|------------|---------|------|
| Enable Carb Limit | Switch | No | None | Off | - |
| Max Carbs | Number | Conditional | 1-500 | 20 | grams |
| Enable Calorie Limit | Switch | No | None | Off | - |
| Max Calories | Number | Conditional | 500-5000 | 2000 | kcal |

### 17.3 Diet Compliance Dashboard Screen

**Purpose:** View diet compliance stats

| Element | Type | Description |
|---------|------|-------------|
| Overall Score | Gauge | 0-100% circular gauge |
| Daily Score | Text | "Today: XX%" |
| Weekly Score | Text | "This Week: XX%" |
| Monthly Score | Text | "This Month: XX%" |
| Current Streak | Badge | "X days" with flame icon |
| Trend Chart | Chart | Line chart of daily compliance |
| Rule Breakdown | List | Per-rule compliance bars |
| Recent Violations | List | Last 10 violations with dates |

### 17.4 Fasting Timer Screen

**Purpose:** Intermittent fasting status and timer

| Element | Type | Description |
|---------|------|-------------|
| Status Label | Text | "Currently Fasting" or "Eating Window" |
| Timer Display | Large Text | "14:32:17" hours:minutes:seconds |
| Progress Bar | Progress | Visual of fasting progress |
| Countdown | Text | "Window opens in X:XX" |
| Timeline | Visual | 24-hour visual with fasting/eating zones |
| End Fast Button | Button | Only during fasting, ends fast early |
| Weekly Log | Grid | Mon-Sun with checkmarks/times |

### 17.5 Diet Violation Alert (Modal)

**Purpose:** Warn before logging violating food

| Element | Type | Description |
|---------|------|-------------|
| Title | Text | "Diet Alert" with warning icon |
| Food Name | Text | Name of food being logged |
| Violations List | List | Each rule violated with icon |
| Impact Preview | Text | "Compliance will drop from 92% to 77%" |
| Impact Bar | Progress | Visual before/after comparison |
| Cancel Button | Button | Cancel logging |
| Log Anyway Button | Button | Secondary, proceeds with log |
| Find Alternatives | Button | Opens compliant alternatives |

### 17.6 Add Custom Diet Rule Screen

**Purpose:** Create individual diet rules

| Field | Type | Required | Validation | Default | Options |
|-------|------|----------|------------|---------|---------|
| Rule Type | Picker | Yes | Valid type | - | Exclude Category, Limit Category, Max Carbs, etc. |
| Category | Picker | Conditional | Valid category | - | Meat, Dairy, Grains, etc. |
| Ingredient | Text | Conditional | Min 2 chars | Empty | "e.g., peanuts" |
| Limit Value | Number | Conditional | > 0 | - | - |
| Severity | Segmented | Yes | Valid option | Violation | Violation, Warning, Info |
| Description | Text | No | None | Empty | "Why this rule?" |
| Violation Message | Text | No | None | Auto-generated | "Custom message" |

---

## 18. Accessibility Field Specifications

**MANDATORY:** All interactive elements MUST have semantic labels for screen reader support per WCAG 2.1 Level AA (4.1.2 Name, Role, Value).

### 18.1 Semantic Label Pattern

Format: `"{Field name}, {required|optional}, {context if needed}"`

### 18.2 Profile Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Profile Name | "Profile name, required" |
| Birth Date | "Birth date, optional, select date" |
| Biological Sex | "Biological sex, optional, select from list" |
| Ethnicity | "Ethnicity, optional" |
| Notes | "Profile notes, optional, 2000 character limit" |
| Diet Type | "Diet type, optional, select from list" |
| Diet Description | "Diet description, required when other diet selected" |
| Profile Photo | "Profile photo, optional, tap to select image" |
| Save Button | "Save profile" |
| Cancel Button | "Cancel and discard changes" |

### 18.3 Supplement Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Supplement Name | "Supplement name, required" |
| Brand | "Brand name, optional" |
| Form | "Supplement form, required, capsule tablet powder or other" |
| Dosage Amount | "Dosage amount, required, enter number" |
| Dosage Unit | "Dosage unit, required, select unit" |
| Quantity Per Dose | "Quantity per dose, required, default is 1" |
| Frequency | "How often to take, required" |
| Time(s) | "Reminder time, tap to add time" |
| Specific Days | "Which days to take, optional" |
| Take With Food | "Take with food, optional toggle" |
| Notes | "Supplement notes, optional" |
| Is Archived | "Archive supplement, hides from active list" |

### 18.4 Food Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Search | "Search food items" |
| Food Name | "Food name, required" |
| Category | "Food category, optional" |
| Calories | "Calories, optional, enter number" |
| Protein | "Protein grams, optional" |
| Carbs | "Carbohydrates grams, optional" |
| Fat | "Fat grams, optional" |
| Fiber | "Fiber grams, optional" |
| Sodium | "Sodium milligrams, optional" |
| Serving Size | "Serving size, optional" |
| Notes | "Food notes, optional" |
| Date/Time | "When eaten, required" |
| Meal Type | "Meal type, optional" |

### 18.5 Fluids Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Water Amount Quick Add 8oz | "Add 8 ounces water" |
| Water Amount Quick Add 12oz | "Add 12 ounces water" |
| Water Amount Quick Add 16oz | "Add 16 ounces water" |
| Water Amount Custom | "Custom water amount, enter ounces" |
| Water Notes | "Water intake notes, optional" |
| Bowel Movement Toggle | "Had bowel movement, toggle" |
| Bristol Scale | "Bristol stool scale, 1 to 7, required if bowel movement" |
| Bowel Size | "Movement size, small medium or large" |
| Bowel Photo | "Take photo of bowel movement, optional" |
| Urine Toggle | "Had urination, toggle" |
| Urine Color | "Urine color, select from scale" |
| Urine Size | "Urination volume, small medium or large" |
| Menstruation Flow | "Menstruation flow intensity, none to heavy" |
| BBT Value | "Basal body temperature, required, degrees" |
| BBT Time | "Temperature recorded time" |
| Other Fluid Name | "Other fluid name, optional" |
| Other Fluid Amount | "Other fluid amount, optional" |
| Other Fluid Notes | "Other fluid notes, optional" |

### 18.6 Sleep Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Bed Time | "When you went to bed, required" |
| Wake Time | "When you woke up, required" |
| Sleep Quality | "Sleep quality, 1 to 5 stars" |
| Interruptions | "Number of wake-ups, optional" |
| Dreams | "Dream notes, optional" |
| Notes | "Sleep notes, optional" |

### 18.7 Condition Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Condition Name | "Condition name, required" |
| Category | "Condition category, optional" |
| Severity Slider | "Current severity, 1 minimal to 10 severe, required" |
| Baseline Photo | "Baseline photo for comparison, optional" |
| Log Date | "Date of this log entry" |
| Flare Toggle | "Currently in flare-up, toggle" |
| Flare Start | "When flare-up started" |
| Flare End | "When flare-up ended, leave empty if ongoing" |
| Flare Notes | "Flare-up notes, optional" |
| Log Notes | "Condition log notes, optional" |

### 18.8 Activity Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Activity Name | "Activity name, required" |
| Category | "Activity category, optional" |
| Duration | "Duration in minutes, optional" |
| Intensity | "Activity intensity, low medium or high" |
| Distance | "Distance, optional" |
| Calories Burned | "Calories burned, optional" |
| Heart Rate | "Average heart rate, optional" |
| Notes | "Activity notes, optional" |
| Date/Time | "When activity occurred, required" |

### 18.9 Journal Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Journal Entry | "Journal entry text, required, no character limit" |
| Mood | "Current mood, optional" |
| Tags | "Entry tags, optional, add multiple" |
| Date | "Entry date, defaults to today" |

### 18.10 Photo Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Photo Area Name | "Photo tracking area name, required" |
| Description | "Area description, optional" |
| Take Photo Button | "Take new photo" |
| Select Photo Button | "Choose from photo library" |
| Photo Notes | "Photo notes, optional" |
| Photo Date | "Photo date, required" |

### 18.11 Notification Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Notifications Toggle | "Enable notifications, master toggle" |
| Supplement Reminders | "Supplement reminder notifications, toggle" |
| Meal Reminders | "Meal reminder notifications, toggle" |
| Water Reminders | "Water reminder notifications, toggle" |
| Sleep Reminders | "Sleep reminder notifications, toggle" |
| Add Time Button | "Add reminder time" |
| Remove Time Button | "Remove this reminder time" |
| Quiet Hours Toggle | "Enable quiet hours, toggle" |
| Quiet Start | "Quiet hours start time" |
| Quiet End | "Quiet hours end time" |

### 18.12 Diet Screen Semantic Labels

| Field | Semantic Label |
|-------|----------------|
| Diet Search | "Search diets" |
| Diet Name | "Custom diet name, required" |
| Start Date | "Diet start date, optional" |
| End Date | "Diet end date, optional, leave empty for ongoing" |
| Eating Window Toggle | "Enable eating window for intermittent fasting" |
| Window Start | "Eating window start time" |
| Window End | "Eating window end time" |
| Exclude Checkbox | "Exclude {category} from diet" |
| Carb Limit Toggle | "Enable daily carb limit" |
| Max Carbs | "Maximum carbs per day in grams" |
| Calorie Limit Toggle | "Enable daily calorie limit" |
| Max Calories | "Maximum calories per day" |
| Compliance Gauge | "Overall diet compliance, {percent} percent" |
| Fasting Timer | "Fasting timer, {hours} hours {minutes} minutes elapsed" |
| End Fast Button | "End fast early" |

### 18.13 Touch Target Requirements

**MANDATORY:** All interactive elements minimum 48x48 dp per WCAG 2.1 Level AA.

| Element | Minimum Size | Notes |
|---------|--------------|-------|
| Buttons | 48x48 dp | Use `minimumSize: Size(48, 48)` |
| Icon buttons | 48x48 dp container | Icon can be 24px inside |
| Checkboxes | 48x48 dp tap area | Flutter default is compliant |
| Switches | 48 dp height | Flutter default is compliant |
| List items | 48 dp height minimum | `ListTile` default is compliant |
| Form fields | 48 dp height | Standard `TextField` is compliant |
| Dropdown items | 48 dp height | Per Material Design |

### 18.14 Focus Order by Screen

Focus traversal must follow logical reading order. Use `FocusTraversalGroup` with `OrderedTraversalPolicy`.

**Add/Edit Supplement Screen Focus Order:**
1. Supplement Name → 2. Brand → 3. Form → 4. Dosage Amount → 5. Dosage Unit → 6. Quantity → 7. Frequency → 8. Add Time → 9. Notes → 10. Save → 11. Cancel

**Add/Edit Profile Screen Focus Order:**
1. Profile Name → 2. Birth Date → 3. Biological Sex → 4. Ethnicity → 5. Diet Type → 6. Diet Description → 7. Notes → 8. Photo → 9. Save → 10. Cancel

**Custom Diet Builder Focus Order:**
1. Diet Name → 2. Start From → 3. Start Date → 4. End Date → 5. Eating Window Toggle → 6. Window Start → 7. Window End → 8. Food Exclusions (top to bottom) → 9. Macro Toggles → 10. Save → 11. Cancel

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release - complete UI field specifications |
| 1.1 | 2026-02-14 | Added Section 13.2 Cloud Sync Setup Screen (initial, loading, authenticated, error states); renumbered 13.3→13.4 |
| 1.2 | 2026-02-17 | Updated Section 13.3 Cloud Sync Settings Screen: now watches auth state, shows connected/not-configured states with user email |
