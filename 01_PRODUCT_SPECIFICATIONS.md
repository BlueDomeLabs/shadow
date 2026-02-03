# Shadow Product Specifications

**Version:** 1.0
**Last Updated:** January 30, 2026
**Document Type:** Master Product Specification
**Classification:** Internal Development Reference

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Product Vision](#2-product-vision)
3. [Target Users](#3-target-users)
4. [Core Features](#4-core-features)
5. [Domain Model](#5-domain-model)
6. [User Interface Specifications](#6-user-interface-specifications)
7. [Data Architecture](#7-data-architecture)
8. [Cloud Sync System](#8-cloud-sync-system)
9. [Security & Privacy](#9-security--privacy)
10. [Authentication & Authorization](#10-authentication--authorization)
11. [Multi-Profile System](#11-multi-profile-system)
12. [Platform Support](#12-platform-support)
13. [Performance Requirements](#13-performance-requirements)
14. [Accessibility Requirements](#14-accessibility-requirements)
15. [Internationalization](#15-internationalization)
16. [Technical Constraints](#16-technical-constraints)
17. [Third-Party Dependencies](#17-third-party-dependencies)
18. [Future Roadmap](#18-future-roadmap)

---

## 1. Executive Summary

Shadow is a comprehensive health tracking application designed to help individuals monitor and manage chronic health conditions, supplements, dietary intake, sleep patterns, and overall wellness. The application emphasizes privacy, security, and HIPAA compliance, with all health data encrypted and stored locally by default, with optional encrypted cloud synchronization.

### Key Differentiators

- **Privacy-First Architecture**: All data stored locally with AES-256 encryption
- **Optional Cloud Sync**: End-to-end encrypted sync via Google Drive OR Apple iCloud
- **Multi-Profile Support**: Counselors can manage multiple client profiles
- **Comprehensive Tracking**: 8+ health domains in a single application
- **Offline-First**: Full functionality without internet connection
- **HIPAA Compliant**: Technical safeguards for protected health information
- **Accessibility**: WCAG 2.1 Level AA compliance
- **International Units**: Support for °F/°C, oz/mL, lb/kg based on locale

---

## 2. Product Vision

### Mission Statement

To provide individuals with a private, secure, and comprehensive tool for tracking their health journey, enabling better self-awareness and more informed conversations with healthcare providers.

### Vision Statement

Shadow empowers users to take control of their health data, providing insights through comprehensive tracking while maintaining the highest standards of privacy and security.

### Core Values

1. **Privacy**: User data belongs to the user alone
2. **Security**: Military-grade encryption for all health information
3. **Accessibility**: Usable by everyone, regardless of ability
4. **Simplicity**: Powerful features with intuitive interfaces
5. **Reliability**: Works offline, syncs when connected

---

## 3. Target Users

### Primary Users

#### Individual Health Trackers
- People managing chronic conditions (eczema, allergies, autoimmune disorders)
- Individuals tracking supplement regimens
- Users monitoring dietary impacts on health
- People seeking to understand health patterns

#### Health Counselors/Coaches
- Nutritional counselors managing client protocols
- Health coaches tracking client progress
- Wellness professionals requiring secure data access

### User Personas

#### Persona 1: The Self-Manager
- **Name**: Sarah, 34
- **Condition**: Eczema with suspected food triggers
- **Goals**: Track flare-ups, identify triggers, share data with dermatologist
- **Needs**: Photo documentation, correlation insights, exportable reports

#### Persona 2: The Health Professional
- **Name**: Dr. Michael, 45
- **Role**: Nutritional counselor
- **Goals**: Monitor multiple client supplement protocols
- **Needs**: Multi-profile access, progress tracking, secure data sharing

---

## 4. Core Features

### 4.1 Health Condition Tracking

**Purpose**: Track and monitor chronic health conditions over time.

**Capabilities**:
- Create and manage multiple conditions
- Categorize by type (skin, digestive, respiratory, neurological, musculoskeletal, cardiovascular, immune, endocrine, reproductive, urinary, mental health, other)
- Track body locations affected
- Log severity levels (1-10 scale)
- Document with photos
- Record triggers and notes
- Mark conditions as resolved
- Capture baseline photos for comparison

**Data Points**:
- Condition name and category
- Status (active/resolved)
- Start date and end date
- Body locations (list)
- Baseline photo references
- Severity history
- Trigger associations

**Acceptance Criteria**:
- [ ] User can create a new condition with name, category, and body locations
- [ ] User can log daily condition status with severity (1-10)
- [ ] User can attach photos to condition logs
- [ ] User can mark a condition as resolved with end date
- [ ] Condition history displays chronologically with severity trend
- [ ] User can define custom triggers and associate them with entries
- [ ] All condition data syncs across devices when cloud sync enabled
- [ ] User can archive conditions (in remission) without deleting
- [ ] User can view archived conditions separately and reactivate them

### 4.2 Supplement Management

**Purpose**: Comprehensive supplement tracking with scheduling.

**Capabilities**:
- Create detailed supplement profiles
- Track multiple ingredients per supplement
- Configure complex dosing schedules
- Log intake status (taken/missed/snoozed)
- Support multiple supplement forms
- Track dosage units and amounts

**Supplement Forms**:
- Capsule
- Tablet
- Powder
- Liquid
- Other (custom)

**Dosage Units**:
- Grams (g), Milligrams (mg), Micrograms (mcg)
- International Units (IU), Histamine Degrading Units (HDU)
- Milliliters (mL), Drops, Teaspoons (tsp)
- Custom units

**Scheduling Options**:
- Daily at specific times
- Every X days
- Specific weekdays
- Anchor events (with meals, before bed, etc.)
- Timing relative to events (before/after/with)

**Acceptance Criteria**:
- [ ] User can create a supplement with name, form, dosage, and ingredients
- [ ] User can configure complex dosing schedules (time, frequency, weekdays)
- [ ] User can log supplement intake as taken/missed/snoozed
- [ ] Intake history shows compliance percentage
- [ ] User can edit or delete supplements and view intake history
- [ ] Supplements display in recommended order based on schedule
- [ ] User can archive supplements (temporarily stop) without deleting
- [ ] User can view archived supplements separately and reactivate them

### 4.3 Food & Nutrition Tracking

**Purpose**: Monitor dietary intake and identify food-related triggers.

**Capabilities**:
- Create food library with custom items
- Log meals with timestamps
- Support simple ingredients and composed dishes
- Track ad-hoc food items
- Associate foods with health events
- Set dietary type on profile for alignment tracking
- Display current diet type in food tab header

**Food Item Types**:
- Simple (single ingredient)
- Composed (multiple ingredients/recipe)

**Diet Types** (20+ presets plus custom):
- Food Restriction: Vegan, Vegetarian, Pescatarian, Paleo, Gluten-Free, Dairy-Free
- Macronutrient: Keto, Strict Keto, Low-Carb, Zone
- Time Restriction: Intermittent Fasting (16:8, 18:6, 20:4, OMAD, 5:2)
- Elimination: Whole30, AIP, Low-FODMAP
- Combination: Mediterranean, Custom (user-defined rules)

**Diet Compliance Tracking**:
- Real-time compliance percentage (0-100%)
- Daily, weekly, monthly compliance scores
- Pre-log violation warnings with impact preview
- Fasting timer with eating window countdown
- Streak tracking with milestone notifications
- Per-rule compliance breakdown

See `41_DIET_SYSTEM.md` for complete diet specification including rule engine, compliance algorithms, and custom diet builder.

**Acceptance Criteria**:
- [ ] User can add food items to library with ingredients and category tags
- [ ] User can log meals with timestamp and food items
- [ ] User can select from 20+ preset diets or create custom diet
- [ ] User can combine diet types (e.g., Paleo + 16:8 fasting)
- [ ] Real-time compliance percentage displays in Food tab header
- [ ] Pre-log warning alerts user before adding violating foods
- [ ] Intermittent fasting shows live countdown timer
- [ ] User can create composed dishes from simple ingredients
- [ ] Food log displays chronologically with meal type grouping
- [ ] User can archive food items (e.g., during elimination diet) without deleting
- [ ] User can view archived food items separately and reactivate them
- [ ] Diet compliance report available as standalone PDF

### 4.4 Activity Tracking

**Purpose**: Log physical activities and their health impacts.

**Capabilities**:
- Create activity templates
- Log activity sessions
- Track duration and intensity
- Record location information
- Associate with triggers
- Support ad-hoc activities

### 4.5 Sleep Tracking

**Purpose**: Monitor sleep patterns and quality.

**Capabilities**:
- Log bedtime and wake time
- Track sleep quality breakdown
- Record waking feelings
- Document dream types
- Calculate sleep duration automatically

**Sleep Quality Metrics**:
- Time to fall asleep
- Number of awakenings
- Time awake during night
- Restfulness rating

**Waking Feelings**:
- Unrested (tired, groggy)
- Neutral (average)
- Rested (refreshed, energized)

**Dream Types**:
- No dreams
- Vague (light, unclear dreams)
- Vivid (clear, memorable dreams)
- Nightmares

### 4.6 Fluids Tracking

**Purpose**: Comprehensive fluid and reproductive health monitoring including water intake, bowel movements, urination patterns, menstruation, basal body temperature tracking, and customizable "other" fluid tracking.

**Capabilities**:
- Track daily water intake with volume logging
- Log bowel movements with Bristol scale
- Track urination patterns
- Document with photos
- Record associated symptoms
- Track urgency and completeness
- Track menstrual flow intensity
- Record basal body temperature (BBT) with timestamp
- View BBT chart for cycle tracking
- Track customizable "other" bodily fluids (user-defined)

**Water Intake**:
- Volume input in ml/oz
- Quick-add buttons: 8oz (237ml), 12oz (355ml), 16oz (473ml), 20oz (591ml), 32oz (946ml), 1L (1000ml), custom amount
- Daily total display and progress toward goal
- Notes for context

**Bowel Conditions**:
- Normal, Diarrhea, Constipation, Bloody, Mucusy, Custom

**Urine Conditions**:
- Clear, Light Yellow, Dark Yellow, Amber, Brown, Red, Custom

**Movement Sizes**:
- Small, Medium, Large

**Menstruation Flow Levels**:
- None (no flow)
- Spotty (minimal spotting)
- Light (light flow)
- Medium (moderate flow)
- Heavy (heavy flow)

**Basal Body Temperature**:
- Temperature input (°F or °C based on locale)
- Time of measurement (typically upon waking)
- Temperature trend chart for cycle tracking
- Integration with menstruation data for fertility awareness

> **Algorithm Reference:** For cycle tracking calculations (biphasic pattern detection, ovulation prediction, cycle length analysis), see `42_INTELLIGENCE_SYSTEM.md` Section 2.3 "Cyclical Pattern Detection". Minimum 10 consecutive BBT entries required for reliable pattern detection.

**Customizable "Other" Fluid Tracking**:
- User-defined fluid name (e.g., "Sweat", "Mucus", "Discharge", etc.)
- Amount description (user-defined)
- Notes for additional context
- Supports any bodily fluid the user wants to track

**Acceptance Criteria**:
- [ ] User can log water intake with volume and optional notes
- [ ] User can see daily water intake total and progress
- [ ] User can log bowel movements with Bristol scale, size, and symptoms
- [ ] User can log urination with color and frequency
- [ ] User can log menstruation flow level (none/spotty/light/medium/heavy)
- [ ] User can record BBT with temperature and timestamp
- [ ] BBT chart displays temperature trend over selected date range
- [ ] Menstruation periods shown as overlay on BBT chart
- [ ] User can log customizable "other" fluid with name, amount, and notes
- [ ] All fluids data syncs to cloud when enabled

### 4.7 Photo Documentation

**Purpose**: Visual documentation of health conditions over time.

**Capabilities**:
- Define photo areas (body regions)
- Capture photos per area
- Maintain chronological history
- Compare photos over time
- Associate with conditions

### 4.8 Flare-Up Reporting

**Purpose**: Document acute health events.

**Capabilities**:
- Quick flare-up logging
- Link to conditions
- Record severity levels
- Document triggers
- Capture photos
- Track duration

**Severity Levels**:
- Mild
- Moderate
- Severe
- Extreme

### 4.9 Journal & Notes

**Purpose**: Free-form health documentation.

**Capabilities**:
- Create text entries
- Add titles and tags
- Attach audio recordings
- Search and filter entries

### 4.10 Document Storage

**Purpose**: Store medical documents and records.

**Capabilities**:
- Upload PDFs and images
- Categorize by type
- Tag for organization
- Sync to cloud

**Document Types**:
- PDF
- Image
- Lab Result
- Medical Record
- Other

### 4.11 Report Generation

**Purpose**: Create shareable health summaries.

**Capabilities**:
- Generate PDF reports
- Select date ranges
- Choose data categories
- Include photos
- Export for healthcare providers

### 4.12 Notifications System

**Purpose**: Proactive reminders for health tracking activities.

**Capabilities**:
- Schedule supplement reminders at specific times
- Set meal/food logging reminders
- Configure fluids tracking reminders
- Set bedtime and wake-up reminders for sleep tracking
- Multiple reminder times per notification type
- Weekday-specific schedules (e.g., weekdays only)
- Enable/disable individual notification schedules
- Custom reminder messages
- Deep linking to relevant screens on notification tap

**Notification Types (25 total)** - See `22_API_CONTRACTS.md` Section 3.2 for canonical enum:
- `supplementIndividual` (0) - Individual supplement reminders linked to specific supplements
- `supplementGrouped` (1) - Grouped supplement reminders (e.g., "morning supplements")
- `mealBreakfast` (2) - Breakfast meal reminders
- `mealLunch` (3) - Lunch meal reminders
- `mealDinner` (4) - Dinner meal reminders
- `mealSnacks` (5) - Snack reminders (covers morning, afternoon, and evening snacks)
- `waterInterval` (6) - Water reminders at regular intervals (every 1-2 hours)
- `waterFixed` (7) - Water reminders at specific times (e.g., 9am, 12pm, 3pm)
- `waterSmart` (8) - Smart water reminders based on current intake vs daily goal
- `bbtMorning` (9) - Basal body temperature recording reminders (time-sensitive, no snooze)
- `menstruationTracking` (10) - Period/flow tracking reminders
- `sleepBedtime` (11) - Bedtime/wind-down reminders
- `sleepWakeup` (12) - Morning check-in reminders
- `conditionCheckIn` (13) - Condition status check-in reminders
- `photoReminder` (14) - Photo documentation reminders for specific body areas
- `journalPrompt` (15) - Journal/reflection prompts
- `syncReminder` (16) - System sync reminders (when data hasn't synced recently)
- `fastingWindowOpen` (17) - Alert when eating window begins
- `fastingWindowClose` (18) - Warning before eating window ends (15-30 min)
- `fastingWindowClosed` (19) - Alert when fasting period begins
- `dietStreak` (20) - Celebration of diet compliance milestones (7, 14, 30 days, no snooze)
- `dietWeeklySummary` (21) - Weekly diet compliance summary (no snooze)
- `fluidsGeneral` (22) - General fluids tracking reminders
- `fluidsBowel` (23) - Bowel movement tracking reminders
- `inactivity` (24) - Re-engagement reminders after extended absence (no snooze)

**Water Notification Modes** (3 distinct behaviors):
- `waterInterval` (6): Reminds at regular intervals (e.g., every 2 hours) within active hours
- `waterFixed` (7): Reminds at user-specified fixed times (e.g., 9am, 12pm, 3pm, 6pm)
- `waterSmart` (8): Dynamic reminders calculated based on remaining daily goal and time left in active hours. Formula: `nextInterval = max(30min, remainingMinutes / glassesRemaining)`

**Schedule Options**:
- Times of day (multiple per schedule)
- Active weekdays (any combination)
- Per-profile configuration
- Custom message override

**Platform Requirements**:
- Android: POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM, RECEIVE_BOOT_COMPLETED permissions
- iOS: Background fetch, remote notification capabilities
- Local notification scheduling (no server required)

**Acceptance Criteria**:
- [ ] User can request and grant notification permissions
- [ ] User can create reminder schedules for supplements, meals, fluids, sleep
- [ ] User can set multiple times per notification type
- [ ] User can select active weekdays for each schedule
- [ ] Notifications are delivered at scheduled times
- [ ] Tapping notification opens relevant screen (deep linking)
- [ ] Notifications persist after device restart
- [ ] User can enable/disable individual notification schedules

---

## 5. Domain Model

### 5.1 Entity Relationship Overview

```
UserAccount (Authentication)
    │
    ├── owns/manages ──► Profile (Health Data Container)
    │                        │
    │                        ├── Condition ──► ConditionLog
    │                        │                     │
    │                        │                     └── FlareUp
    │                        │
    │                        ├── Supplement ──► SupplementIntakeLog
    │                        │
    │                        ├── FoodItem ──► FoodLog
    │                        │
    │                        ├── Activity ──► ActivityLog
    │                        │
    │                        ├── SleepEntry
    │                        │
    │                        ├── FluidsEntry (water, bowel, urine, menstruation, BBT, custom)
    │                        │
    │                        ├── PhotoArea ──► PhotoEntry
    │                        │
    │                        ├── JournalEntry
    │                        │
    │                        ├── Document
    │                        │
    │                        └── NotificationSchedule
    │
    └── registered on ──► DeviceRegistration

ProfileAccess (Permission Junction)
    ├── UserAccount
    └── Profile
```

### 5.2 Core Entities

#### UserAccount
- **Purpose**: Authentication identity
- **Key Fields**: id, email, displayName, role, photoUrl, organizationId
- **Roles**: counselor, client

#### Client ID Concept
- **Purpose**: Higher-level identifier for database merging support
- **Key Fields**: clientId (present on all health data entities)
- **Description**: Every health data entity includes a `clientId` field that identifies the client/user account at a higher level than `profileId`. While a client can have multiple profiles, the `clientId` remains constant across all their data. This enables future database merging scenarios where multiple Shadow databases need to be combined while maintaining distinct client identities and preventing ID conflicts.
- **Use Cases**:
  - Merging databases from different devices or installations
  - Consolidating data from multiple Shadow instances
  - Data migration between accounts
  - Multi-tenant deployments

#### Profile
- **Purpose**: Health data container
- **Key Fields**: id, clientId, name, birthDate, biologicalSex, ethnicity, notes, ownerId, dietType, dietDescription
- **Relationships**: One-to-many with all health data entities

#### ProfileAccess
- **Purpose**: Permission management
- **Key Fields**: id, profileId, userId, accessLevel, grantedBy, expiresAt
- **Access Levels**: readOnly, readWrite, owner

#### DeviceRegistration
- **Purpose**: Multi-device tracking
- **Key Fields**: id, userId, deviceId, deviceName, deviceType, isActive, lastSeenAt
- **Device Types**: ios, android, macos, web

### 5.3 Health Data Entities

| Entity | Purpose | Key Relationships |
|--------|---------|-------------------|
| Condition | Chronic condition tracking | Has many ConditionLogs, FlareUps |
| ConditionLog | Individual condition entries | Belongs to Condition |
| FlareUp | Acute health events | Belongs to Condition |
| Supplement | Supplement definitions | Has many SupplementIntakeLogs |
| SupplementIntakeLog | Dose tracking | Belongs to Supplement |
| FoodItem | Food library entries | Referenced by FoodLogs |
| FoodLog | Meal tracking | References FoodItems |
| Activity | Activity templates | Has many ActivityLogs |
| ActivityLog | Activity sessions | References Activities |
| SleepEntry | Sleep records | Standalone |
| FluidsEntry | Comprehensive fluid tracking | Standalone (includes water intake, bowel, urine, menstruation, BBT, custom "other") |
| PhotoArea | Body regions | Has many PhotoEntries |
| PhotoEntry | Individual photos | Belongs to PhotoArea |
| JournalEntry | Free-form notes | Standalone |
| Document | File attachments | Standalone |
| NotificationSchedule | Reminder configurations | Belongs to Profile, optionally references Supplement |

### 5.4 Sync Infrastructure

#### SyncMetadata (Attached to all entities)
- **Fields**: createdAt, updatedAt, deletedAt, lastSyncedAt, syncStatus, version, createdByDeviceId, lastModifiedByDeviceId
- **Sync Status**: pending, synced, conflict, error

#### FileSyncMetadata (For file entities)
- **Fields**: localPath, cloudPath, fileHash, fileSize, uploadStatus

---

## 6. User Interface Specifications

### 6.1 Navigation Structure

**Primary Navigation**: Bottom Tab Bar (9 tabs)

| Tab | Icon | Purpose |
|-----|------|---------|
| Home | House | Dashboard and quick actions |
| Conditions | Heart | Condition management |
| Supplements | Pill | Supplement tracking |
| Food | Apple | Dietary logging (displays current diet type) |
| Activities | Running | Activity tracking |
| Sleep | Moon | Sleep monitoring |
| Fluids | Droplet | Comprehensive fluid tracking (water, bowel, urine, menstruation, BBT, custom) |
| Photos | Camera | Photo documentation |
| Reports | Document | Report generation |

### 6.2 Screen Inventory

**Total Screens**: 36+

#### Authentication & Onboarding
- Welcome Screen
- Sign In Screen

#### Main Navigation
- Home Screen (with tabs)

#### Data Entry Screens
- Add Condition Screen
- Add/Edit Supplement Screen
- Log Food Screen
- Add/Edit Activity Screen
- Add/Edit Sleep Entry Screen
- Add Fluids Entry Screen (water intake, bowel, urine, menstruation, BBT, custom "other")
- Add/Edit Journal Entry Screen
- Report Flare-Up Screen

#### Settings Screens
- Notification Settings Screen (reminder configuration)

#### List & Detail Screens
- Food Logs Screen
- Supplement Intake Logs Screen
- Sleep Logs Screen
- Flare-Ups List Screen
- Journal List Screen
- Photo Gallery Screen

#### Configuration Screens
- Manage Categories Screen
- Photo Areas Screen
- Food Library Screen
- Profiles Screen
- Add/Edit Profile Screen

#### Cloud & Sync Screens
- Cloud Sync Setup Screen
- Cloud Sync Settings Screen
- Pair Device Screen
- Scan QR Screen

#### Diet Screens
- Diet Selection Screen
- Custom Diet Builder Screen
- Diet Compliance Dashboard Screen
- Fasting Timer Screen
- Add Diet Rule Screen

#### Utility Screens
- Generate Report Screen
- Take Photo Screen
- Photo Round Screen

### 6.3 Design Principles

1. **Consistency**: All screens follow the same layout patterns
2. **Accessibility**: WCAG 2.1 Level AA minimum
3. **Efficiency**: Common actions require minimal taps
4. **Feedback**: Clear loading, success, and error states
5. **Progressive Disclosure**: Advanced options revealed as needed

### 6.4 Component Library

**Reusable Components**:
- AccessibleButton
- AccessibleCard
- AccessibleTextField
- AccessibleDropdown
- AccessibleSwitch
- AccessibleImage
- AccessibleLoadingIndicator
- AccessibleEmptyState
- SectionHeader
- ItemMenuButton
- CommonDialogs (delete confirmation, text input)

---

## 7. Data Architecture

### 7.1 Storage Strategy

**Primary Storage**: SQLite with SQLCipher encryption
- All data stored locally on device
- AES-256 encryption at rest
- No unencrypted data written to disk

**Cloud Storage**: Optional cloud sync (user's choice)
- **Google Drive**: OAuth 2.0 with PKCE, drive.file scope
- **Apple iCloud**: CloudKit integration for Apple ecosystem users
- End-to-end encryption before upload (both providers)
- User controls encryption keys
- User selects provider during setup (can switch later)

### 7.2 Database Design

**Naming Conventions**:
- Tables: snake_case plural (e.g., `supplements`, `food_logs`)
- Columns: snake_case (e.g., `created_at`, `profile_id`)
- Foreign Keys: `{referenced_table_singular}_id`

**Required Columns** (all tables):
- `id` TEXT PRIMARY KEY
- `client_id` TEXT (for health data tables - identifies client for database merging)
- `profile_id` TEXT (for health data tables - identifies the specific profile)
- `sync_created_at` TEXT (ISO 8601)
- `sync_updated_at` TEXT (ISO 8601)
- `sync_deleted_at` TEXT (ISO 8601, nullable)
- `sync_last_synced_at` TEXT (ISO 8601, nullable)
- `sync_status` TEXT
- `sync_version` INTEGER
- `sync_is_dirty` INTEGER
- `sync_created_by_device_id` TEXT
- `sync_last_modified_by_device_id` TEXT

### 7.3 Data Flow

```
UI Layer (Screens/Widgets)
        │
        ▼
State Management (Providers)
        │
        ▼
Domain Layer (Repository Interfaces)
        │
        ▼
Data Layer (Repository Implementations)
        │
        ▼
Data Sources (Local SQLite / Cloud Storage)
```

---

## 8. Cloud Sync System

### 8.1 Sync Architecture

**Components**:
- SyncService: Orchestrates sync operations
- CloudStorageProvider: Interface for cloud backends
- GoogleDriveProvider: Google Drive implementation
- SyncMetadata: Version tracking per entity
- ConflictResolver: Handles sync conflicts

### 8.2 Sync Workflow

1. **Check Connectivity**: Verify network available
2. **Authenticate**: Validate/refresh OAuth tokens
3. **Upload Changes**: Push dirty local entities
4. **Download Changes**: Pull remote updates
5. **Resolve Conflicts**: Apply conflict resolution strategy
6. **Upload Files**: Sync photos and documents
7. **Download Files**: Retrieve remote files
8. **Update Metadata**: Mark entities as synced

### 8.3 Conflict Resolution

**Default Strategy**: Last-Write-Wins
- Compare `sync_updated_at` timestamps
- Most recent modification wins
- User notified of resolved conflicts

**Future Strategy**: Manual resolution option

### 8.4 Multi-Device Support

- Devices paired via QR code
- Encryption keys shared securely
- Each device tracks its own sync state
- Devices can be remotely deactivated

---

## 9. Security & Privacy

### 9.1 Encryption

**Data at Rest**:
- SQLCipher with AES-256 encryption
- Database key stored in platform secure storage
- iOS: Keychain
- Android: Android Keystore
- macOS: Keychain

**Data in Transit**:
- AES-256-GCM encryption before cloud upload
- Encryption keys never leave device
- Server cannot decrypt user data

### 9.2 HIPAA Compliance

**Technical Safeguards**:
- Access controls (authentication, authorization)
- Audit logging (all data access tracked)
- Data integrity (checksums, version tracking)
- Encryption (PHI encrypted at rest and in transit)

### 9.3 Privacy Principles

1. **Local by Default**: No data leaves device without user action
2. **Minimal Collection**: Only collect necessary data
3. **User Control**: User can export or delete all data
4. **Transparency**: Clear privacy policy
5. **No Third-Party Sharing**: Data never sold or shared

### 9.4 Audit Logging

All data operations logged:
- CREATE: Entity created
- READ: Entity accessed
- UPDATE: Entity modified
- DELETE: Entity deleted

Log includes: timestamp, user, device, entity type, entity ID, operation

---

## 10. Authentication & Authorization

### 10.1 Authentication Methods

**Google OAuth 2.0**:
- Primary authentication method
- Uses PKCE for enhanced security
- Scopes: email, profile, drive.file

**Local Mode**:
- Optional anonymous usage
- No cloud sync available
- Data stays on device only

### 10.2 OAuth Implementation

**Security Features**:
- PKCE (Proof Key for Code Exchange)
- State parameter for CSRF protection
- Secure token storage
- Automatic token refresh

**Token Management**:
- Access token: 1 hour lifetime
- Refresh token: 90 days lifetime
- Proactive refresh: 5 minutes before expiry

### 10.3 Authorization Model

**Role-Based Access**:
- Counselor: Can manage multiple profiles
- Client: Single profile access

**Profile-Based Permissions**:
- Owner: Full access, can grant access to others
- ReadWrite: Can view and modify data
- ReadOnly: Can view data only

---

## 11. Multi-Profile System

### 11.1 Profile Architecture

**UserAccount** (Identity):
- Represents authenticated user
- Can own multiple profiles
- Can access shared profiles

**Profile** (Data Container):
- Contains all health data
- Has single owner
- Can be shared with other users

### 11.2 Use Cases

**Individual User**:
- Creates account
- Manages single profile
- Full owner access

**Health Counselor**:
- Creates counselor account
- Creates profiles for clients
- Grants read/write access to clients
- Maintains owner access for oversight

**Family Sharing**:
- Primary user creates profiles for family members
- Grants appropriate access levels
- Each family member can have their own account

### 11.3 Access Control

**Granting Access**:
1. Owner selects profile
2. Invites user by email
3. Sets access level
4. Optional expiration date

**Revoking Access**:
1. Owner opens profile settings
2. Views access list
3. Removes or modifies access

### 11.4 HIPAA Authorization (For Healthcare Use)

When profiles contain Protected Health Information (PHI), sharing requires formal HIPAA-compliant authorization.

**Digital Authorization Form**:
- Legally-binding digital consent form
- Clear disclosure of what data will be shared
- Purpose statement (healthcare, research, personal)
- Authorization duration selection

**Scope Selection**:
- Granular data type selection (conditions, supplements, food, photos, etc.)
- Option to include or exclude photos specifically
- Time-bound access (until revoked, 30/90/180/365 days)

**Signature Capture**:
- Digital signature timestamp
- Device identification for audit trail
- IP address logging (masked in audit views)
- Confirmation acknowledgment

**Authorization Workflow**:
1. Profile owner initiates sharing
2. Selects recipient (by email or QR pairing)
3. Chooses data scopes
4. Sets authorization duration
5. Reviews and signs authorization form
6. Recipient receives access notification

**Audit Trail Requirements**:
- All access logged with timestamp, action, and accessor
- Authorization creation, modification, revocation tracked
- 7-year retention for HIPAA compliance
- Export capability for legal/compliance review

**Revocation**:
- Immediate effect upon revocation
- Revocation reason captured (optional)
- Notification sent to affected parties
- Data remains in recipient's local cache marked as revoked

### 11.5 Profile Selection Behavior

**App Startup (No Profile Selected)**:
When the app launches with no active profile selected:
1. If user has exactly one owned profile: auto-select it
2. If user has multiple owned profiles: show profile selector
3. If user has no owned profiles: show "Create Profile" screen
4. If user only has shared (non-owned) profiles: show profile selector

**Profile-Requiring Screens**:
All data entry and viewing screens require an active profile. If accessed without a profile:
1. Show profile selector modal (non-dismissable)
2. User must select or create a profile to proceed
3. Selection persists across app restarts

**Profile Switching**:
- Available via profile icon in app header
- Switching clears in-progress unsaved edits (with confirmation)
- Notifications continue for all profiles regardless of selection

**Edge Cases**:
- Profile deleted while selected: switch to next available profile or show selector
- Shared access revoked while using profile: show "Access Revoked" message, switch profile
- Last profile deleted: show "Create Profile" screen

---

## 12. Platform Support

### 12.1 Supported Platforms

| Platform | Status | Min Version |
|----------|--------|-------------|
| iOS | Full Support | iOS 12.0+ |
| Android | Full Support | API 21+ (5.0) |
| macOS | Full Support | macOS 10.14+ |
| Windows | Planned | Windows 10+ |
| Linux | Planned | Ubuntu 18.04+ |
| Web | Planned | Modern browsers |

### 12.2 Platform-Specific Features

**iOS/macOS**:
- Keychain for secure storage
- Native Google Sign-In
- iCloud sync option

**Android**:
- Android Keystore for secure storage
- Native Google Sign-In
- Material Design components

**Desktop (macOS)**:
- Custom OAuth flow with loopback server
- Keyboard navigation support
- Large screen optimization

---

## 13. Performance Requirements

### 13.1 Response Time Targets

| Operation | Target | Maximum |
|-----------|--------|---------|
| App launch | < 2s | 3s |
| Screen navigation | < 100ms | 200ms |
| Data save | < 200ms | 500ms |
| List scroll | 60 FPS | 30 FPS |
| Cloud sync (small) | < 5s | 10s |
| Cloud sync (full) | < 30s | 60s |

### 13.2 Resource Limits

- **Memory**: < 200MB typical usage
- **Storage**: < 100MB app + user data
- **Battery**: Minimal background activity
- **Network**: Efficient sync, offline-first

### 13.3 Data Limits

- **Entities per type**: 10,000+ supported
- **Photos**: Unlimited (device storage)
- **Documents**: 50MB per file
- **Sync batch**: 500 entities per request (maxSyncBatchSize)

---

## 14. Accessibility Requirements

### 14.1 WCAG 2.1 Level AA Compliance

**Perceivable**:
- Text alternatives for images
- Captions for audio content
- Adaptable layouts
- Distinguishable content (contrast ratios)

**Operable**:
- Keyboard accessible
- Sufficient time to read
- No seizure-inducing content
- Navigable structure

**Understandable**:
- Readable text
- Predictable behavior
- Input assistance

**Robust**:
- Compatible with assistive technologies
- Valid markup

### 14.2 Screen Reader Support

- **iOS**: VoiceOver
- **Android**: TalkBack
- **macOS**: VoiceOver

**Requirements**:
- All interactive elements labeled
- Logical focus order
- State changes announced
- Headings and landmarks used

### 14.3 Touch Targets

- **Minimum size**: 44x44 points (iOS), 48x48 dp (Android)
- **Spacing**: Adequate between targets
- **Feedback**: Visual and haptic

---

## 15. Internationalization

### 15.1 Supported Languages

| Language | Code | Direction |
|----------|------|-----------|
| English | en | LTR |
| Spanish | es | LTR |
| French | fr | LTR |
| German | de | LTR |
| Chinese (Simplified) | zh | LTR |
| Arabic | ar | RTL |

### 15.2 Localization Requirements

- All user-facing strings externalized
- Date/time formatting localized
- Number formatting localized
- RTL layout support
- Pluralization rules supported

### 15.3 Implementation

- Flutter ARB file format
- AppLocalizations class
- l10n.yaml configuration
- Separate ARB file per language

---

## 16. Technical Constraints

### 16.1 Framework

- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Minimum Flutter SDK**: 3.0+

### 16.2 Architecture

- Clean Architecture pattern
- Repository pattern for data access
- Provider pattern for state management
- Dependency injection with GetIt

### 16.3 Database

- SQLite with SQLCipher
- No ORM (raw SQL with models)
- Soft delete (deletedAt column)
- Version tracking for sync

### 16.4 Cloud

- Google Drive API v3
- OAuth 2.0 with PKCE
- drive.file scope only
- Server-side OAuth proxy for secrets

---

## 17. Third-Party Dependencies

### 17.1 Core Dependencies

| Package | Purpose | Version |
|---------|---------|---------|
| flutter | UI framework | SDK |
| provider | State management | ^6.0.0 |
| get_it | Dependency injection | ^7.0.0 |
| sqflite | SQLite database | ^2.0.0 |
| google_sign_in | Google OAuth | ^6.0.0 |
| googleapis | Google APIs | ^11.0.0 |
| flutter_secure_storage | Secure storage | ^8.0.0 |
| uuid | ID generation | ^3.0.0 |
| intl | Internationalization | ^0.18.0 |

### 17.2 UI Dependencies

| Package | Purpose |
|---------|---------|
| cached_network_image | Image caching |
| image_picker | Photo capture |
| pdf | PDF generation |
| share_plus | Sharing functionality |
| flutter_local_notifications | Local push notifications |
| timezone | Timezone-aware scheduling |

### 17.3 Security Dependencies

| Package | Purpose |
|---------|---------|
| crypto | Cryptographic functions |
| encrypt | AES encryption |
| pointycastle | Encryption algorithms |

---

## 18. Future Roadmap

### Phase 1: Core Features (Complete)
- Health condition tracking
- Supplement management
- Food logging
- Activity tracking
- Sleep monitoring
- Photo documentation
- Local storage with encryption
- Google Drive sync

### Phase 2: Enhanced Features (Current)
- Report generation
- Multi-profile support
- Counselor workflows
- Advanced scheduling
- Fluids tracking (water intake, menstruation, BBT, customizable "other")
- Notification system with reminders
- Diet type tracking
- Earth tone visual rebrand
- Client ID for database merging support

### Phase 3: Intelligence (Fully Specified)

See [42_INTELLIGENCE_SYSTEM.md](42_INTELLIGENCE_SYSTEM.md) for complete specification.

**Pattern Detection**:
- Temporal patterns (day-of-week, time-of-day, monthly trends)
- Cyclical patterns (menstrual cycles, flare/remission cycles)
- Sequential patterns (trigger → outcome relationships)
- Cluster patterns (co-occurring symptoms)
- Dosage patterns (supplement effectiveness by dose)

**Trigger Correlation**:
- Relative risk calculation with 95% confidence intervals
- Positive correlations (triggers that increase symptom likelihood)
- Negative correlations (factors that decrease symptoms)
- Dose-response analysis for quantifiable triggers
- Multiple time windows (6h, 12h, 24h, 48h, 72h)

**Health Insights**:
- Daily summary insights
- Pattern-based insights (newly detected patterns)
- Trigger insights (significant correlations)
- Progress insights (improvement/decline tracking)
- Compliance insights (supplement/diet adherence)
- Anomaly alerts (unusual readings)
- Milestone celebrations (streaks, goals)
- Weekly recommendations

**Predictive Alerts**:
- Flare-up prediction (Random Forest model, 24-72 hour warning)
- Menstrual cycle prediction (period start, ovulation timing)
- Trigger exposure warnings (pre-consumption alerts)
- Missed supplement prediction (pattern-based reminders)

**Technical Requirements**:
- All processing on-device (no external data transmission)
- TensorFlow Lite for ML models (<2MB total)
- Minimum 14 days data for pattern detection
- Minimum 5 historical flares for prediction models
- Statistical significance (p < 0.05) for all correlations

### Phase 4: Health Data Integration (Fully Specified)

See [43_WEARABLE_INTEGRATION.md](43_WEARABLE_INTEGRATION.md) for complete specification.

**Wearable Device Integration**:
- Apple Watch (watchOS companion app)
- Fitbit (Web API integration)
- Garmin (Connect IQ + Health API)
- Oura Ring (Cloud API)
- WHOOP (API integration)
- Generic Bluetooth LE devices

**Apple Health Integration**:
- Read: steps, heart rate, sleep, workouts, body measurements
- Write: supplement intake, food logs, sleep entries
- Background sync with HealthKit
- Privacy: User controls exactly which data types sync

**Google Fit Integration**:
- Read: steps, heart rate, sleep, workouts, nutrition
- Write: supplement logs, activity sessions
- REST API with OAuth 2.0
- Android-first with cross-platform support

**Data Export (FHIR R4)**:
- Patient resource from profile
- Observation resources for conditions, vitals
- MedicationStatement for supplements
- NutritionOrder for diet data
- Export to JSON bundle for portability

### Phase 5: Platform Expansion (Future)
- Windows desktop app
- Linux desktop app
- Web application

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-30 | Development Team | Initial release |
| 1.1 | 2026-01-30 | Development Team | Added Fluids tab (menstruation, BBT), notifications system, diet types, earth tone rebrand |
| 1.2 | 2026-01-31 | Development Team | Added client_id for database merging support; Expanded Fluids to include water intake and customizable "other" fluid tracking |
| 1.3 | 2026-01-31 | Development Team | Phase 3 Intelligence System fully specified; Fixed iCloud "future" inconsistency |
| 1.4 | 2026-01-31 | Development Team | Phase 4 Health Data Integration fully specified; Removed healthcare provider sharing; Added HIPAA authorization to profile sharing |
| 1.5 | 2026-02-02 | Development Team | Aligned NotificationType names with canonical 22_API_CONTRACTS.md; Added water notification mode documentation (3 modes: interval, fixed, smart) |

---

## Related Documents

- [02_CODING_STANDARDS.md](./02_CODING_STANDARDS.md) - Development standards
- [03_DESIGN_POLICIES.md](./03_DESIGN_POLICIES.md) - UI/UX guidelines
- [04_ARCHITECTURE.md](./04_ARCHITECTURE.md) - Technical architecture
- [05_IMPLEMENTATION_ROADMAP.md](./05_IMPLEMENTATION_ROADMAP.md) - Build guide
- [06_TESTING_STRATEGY.md](./06_TESTING_STRATEGY.md) - Testing approach
- [07_NAMING_CONVENTIONS.md](./07_NAMING_CONVENTIONS.md) - Naming standards
- [08_OAUTH_IMPLEMENTATION.md](./08_OAUTH_IMPLEMENTATION.md) - OAuth details
- [09_WIDGET_LIBRARY.md](./09_WIDGET_LIBRARY.md) - Component library
- [10_DATABASE_SCHEMA.md](./10_DATABASE_SCHEMA.md) - Database design
- [11_SECURITY_GUIDELINES.md](./11_SECURITY_GUIDELINES.md) - Security standards
- [12_ACCESSIBILITY_GUIDELINES.md](./12_ACCESSIBILITY_GUIDELINES.md) - Accessibility
- [13_LOCALIZATION_GUIDE.md](./13_LOCALIZATION_GUIDE.md) - i18n guide
- [35_QR_DEVICE_PAIRING.md](./35_QR_DEVICE_PAIRING.md) - Device pairing and HIPAA-compliant profile sharing
- [40_REPORT_GENERATION.md](./40_REPORT_GENERATION.md) - PDF report specifications
- [41_DIET_SYSTEM.md](./41_DIET_SYSTEM.md) - Diet tracking and compliance
- [42_INTELLIGENCE_SYSTEM.md](./42_INTELLIGENCE_SYSTEM.md) - Phase 3: Pattern detection, trigger correlation, insights, predictions
- [43_WEARABLE_INTEGRATION.md](./43_WEARABLE_INTEGRATION.md) - Phase 4: HealthKit, Google Fit, wearables, FHIR export
