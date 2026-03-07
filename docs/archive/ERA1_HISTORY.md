# Era 1 History — Blue Dome Labs Big-Team Planning Era

This document consolidates the planning documents written in January 2026
when Blue Dome Labs was initially designed as a full engineering organization.
These documents reflect the original vision before the project evolved into
the Architect + Shadow two-instance workflow.

They are preserved here as a historical record of how the project began.
The actual implementation diverged significantly from these plans, which is
documented in ROADMAP.md.

---

---
## [Original: 01_PRODUCT_SPECIFICATIONS.md]

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
- Riverpod for state management (code generation via @riverpod annotation)
- Dependency injection via Riverpod providers (not GetIt)

### 16.3 Database

- SQLite with SQLCipher (AES-256 encryption)
- Drift ORM for type-safe queries and code generation
- Soft delete via sync_deleted_at column
- Version tracking for sync via sync_version column

### 16.4 Cloud

- Google Drive API v3
- OAuth 2.0 with PKCE
- drive.file scope only
- client_secret embedded in app (acceptable for private beta; server-side proxy planned for production)

---

## 17. Third-Party Dependencies

### 17.1 Core Dependencies

| Package | Purpose | Version |
|---------|---------|---------|
| flutter | UI framework | SDK |
| riverpod / flutter_riverpod / riverpod_annotation | State management + DI | ^2.x |
| drift / drift_flutter | Type-safe SQLite ORM | ^2.14.1 |
| sqlcipher_flutter_libs | AES-256 database encryption | ^0.x |
| freezed_annotation / json_annotation | Immutable entity codegen | ^2.4.1 / ^4.8.1 |
| flutter_secure_storage | Keychain/Keystore token storage | ^9.x |
| google_sign_in / googleapis | Google OAuth + Drive API | ^6.x / ^11.x |
| uuid | UUID generation | ^4.x |
| intl | Internationalization | ^0.20.x |
| health | Apple HealthKit / Google Health Connect | ^13.3.1 |
| flutter_local_notifications | Local push notifications | ^18.x |
| timezone | Timezone-aware scheduling | ^0.10.x |
| image_picker | Photo capture | ^1.x |

---

## 18. Future Roadmap

### Phase 1: Core Features — COMPLETE
All basic tracking entities, repositories, use cases, and screens. Local encrypted database. Multi-profile support. Cloud sync (Google Drive). Notification system (25 types, anchor events). Diet tracking with compliance. Food database extension (barcode scanning, Open Food Facts). Supplement extension (NIH DSLD). Guest profile access (QR code invite system). Settings screens (units, security, health sync).

### Phase 2: In Progress
- AnchorEventName enum expansion (5→8 values, schema migration)
- FlareUpListScreen and Report Flare-Up flow
- Welcome Screen "Join Existing Account" deep link wiring

### Phase 3: Intelligence System — Fully Specified, Not Yet Built
See 42_INTELLIGENCE_SYSTEM.md. Pattern detection, trigger correlation, health insights, predictive alerts. All processing on-device. Requires 14-60 days of data minimum.

### Phase 4: Health Data Integration — Specified, Partially Built
See 43_WEARABLE_INTEGRATION.md. Apple HealthKit (Phase 16 complete for import). Google Health Connect (Phase 16 complete for import). Wearable devices (Apple Watch, Fitbit, Garmin, Oura, WHOOP) — not yet built. FHIR R4 export — not yet built.

### Phase 5: Platform Expansion — Future
Windows, Linux, and web versions.

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

---
## [Original: 05_IMPLEMENTATION_ROADMAP.md]

# Shadow Implementation Roadmap

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Step-by-step guide to build Shadow from scratch

---

## Overview

This roadmap provides a systematic approach to building the Shadow health tracking application from the ground up. Each phase builds upon the previous, ensuring a solid foundation before adding features.

---

## Phase 0: Technical Decisions & Modern Stack

### 0.1 Code Generation Strategy

Shadow uses code generation to eliminate boilerplate and ensure consistency across entities and models.

**Required Packages:**
```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  drift: ^2.14.1  # Type-safe SQL (replaces raw sqflite)
  riverpod_annotation: ^2.3.3
  device_info_plus: ^10.1.0  # Device identification for sync

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  drift_dev: ^2.14.1
  riverpod_generator: ^2.3.9
```

**Entity Generation with Freezed:**
```dart
// lib/domain/entities/supplement.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplement.freezed.dart';
part 'supplement.g.dart';

@freezed
class Supplement with _$Supplement {
  const factory Supplement({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    required SupplementForm form,
    required double dosageAmount,
    required DosageUnit dosageUnit,
    String? brand,
    String? notes,
    @Default([]) List<Ingredient> ingredients,
    required SyncMetadata syncMetadata,
  }) = _Supplement;

  factory Supplement.fromJson(Map<String, dynamic> json) =>
      _$SupplementFromJson(json);
}
```

**Database with Drift:**
```dart
// lib/data/datasources/local/database.dart

import 'package:drift/drift.dart';

part 'database.g.dart';

class Supplements extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().references(Profiles, #id)();
  TextColumn get name => text()();
  IntColumn get form => intEnum<SupplementForm>()();
  RealColumn get dosageAmount => real()();
  IntColumn get dosageUnit => intEnum<DosageUnit>()();
  TextColumn get brand => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get ingredients => text().map(const IngredientsConverter())();
  // Sync metadata columns...

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Supplements, Profiles, Conditions, /* ... */])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;
}
```

**Benefits:**
- Immutable entities with `copyWith` generated
- JSON serialization generated
- Type-safe SQL queries with compile-time verification
- Boilerplate reduction: ~60% less code per entity
- No manual toMap/fromMap methods
- Automatic equals/hashCode

### 0.2 State Management: Riverpod

Shadow uses Riverpod for state management, providing compile-time safety and better testability than Provider.

**Riverpod Provider Generation:**
```dart
// lib/presentation/providers/supplement_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supplement_provider.g.dart';

@riverpod
class SupplementNotifier extends _$SupplementNotifier {
  @override
  Future<List<Supplement>> build(String profileId) async {
    final getSupplements = ref.read(getSupplementsUseCaseProvider);
    final result = await getSupplements(profileId: profileId);

    return result.when(
      success: (supplements) => supplements,
      failure: (error) => throw error,
    );
  }

  Future<void> addSupplement(Supplement supplement) async {
    final createSupplement = ref.read(createSupplementUseCaseProvider);
    final result = await createSupplement(supplement);

    result.when(
      success: (_) => ref.invalidateSelf(),
      failure: (error) => throw error,
    );
  }
}

// Usage in widget
class SupplementsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplementsAsync = ref.watch(supplementNotifierProvider(profileId));

    return supplementsAsync.when(
      data: (supplements) => SupplementList(supplements: supplements),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorDisplay(error: error),
    );
  }
}
```

**Dependency Injection with Riverpod:**
```dart
// lib/injection_container.dart

@Riverpod(keepAlive: true)
AppDatabase database(DatabaseRef ref) => AppDatabase();

@Riverpod(keepAlive: true)
SupplementRepository supplementRepository(SupplementRepositoryRef ref) {
  return SupplementRepositoryImpl(
    ref.read(databaseProvider),
    ref.read(uuidProvider),
    ref.read(deviceInfoServiceProvider),
  );
}

@riverpod
GetSupplementsUseCase getSupplementsUseCase(GetSupplementsUseCaseRef ref) {
  return GetSupplementsUseCase(
    ref.read(supplementRepositoryProvider),
    ref.read(profileAuthorizationServiceProvider),
  );
}
```

**Benefits over Provider:**
- Compile-time safety: Missing providers caught at build time
- No BuildContext required for accessing providers
- Built-in async support (AsyncValue)
- Better testing: Providers can be overridden per-test
- Automatic disposal of unused providers
- Family providers for parameterized state

### 0.3 Code Generation Workflow

```bash
# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Watch mode during development
dart run build_runner watch --delete-conflicting-outputs

# Before commit
dart run build_runner build --delete-conflicting-outputs && flutter analyze
```

**Generated Files:**
```
lib/
├── domain/entities/
│   ├── supplement.dart
│   ├── supplement.freezed.dart  # Generated: copyWith, ==, hashCode
│   └── supplement.g.dart        # Generated: JSON serialization
├── data/datasources/local/
│   ├── database.dart
│   └── database.g.dart          # Generated: Drift queries
└── presentation/providers/
    ├── supplement_provider.dart
    └── supplement_provider.g.dart  # Generated: Riverpod providers
```

---

## Phase 1: Project Setup & Foundation (Week 1-2)

### 1.1 Initialize Flutter Project

```bash
# Create new Flutter project
flutter create --org com.bluedomecolorado shadow_app
cd shadow_app

# Enable required platforms
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop
```

### 1.2 Configure Project Structure

Create the Clean Architecture folder structure:

```
lib/
├── core/
│   ├── config/
│   ├── errors/
│   ├── services/
│   ├── utils/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/
│   ├── repositories/
│   ├── datasources/
│   │   ├── local/
│   │   └── remote/
│   ├── models/
│   └── cloud/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   ├── providers/
│   └── theme/
└── l10n/
```

### 1.3 Add Core Dependencies

Update `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management (Riverpod)
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

  # Database (Drift - type-safe SQL)
  drift: ^2.14.1
  sqlite3_flutter_libs: ^0.5.18
  path_provider: ^2.1.1
  path: ^1.8.3

  # Security
  flutter_secure_storage: ^9.0.0
  encrypt: ^5.0.3
  crypto: ^3.0.3
  pointycastle: ^3.7.3

  # Utilities
  uuid: ^4.2.1
  intl: ^0.18.1
  logger: ^2.0.2

  # Google Sign-In & Drive
  google_sign_in: ^6.1.6
  googleapis: ^12.0.0
  googleapis_auth: ^1.4.1
  http: ^1.1.2

  # UI Components
  cached_network_image: ^3.3.0
  image_picker: ^1.0.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  mockito: ^5.4.3
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  drift_dev: ^2.14.1
  riverpod_generator: ^2.3.9

flutter:
  uses-material-design: true
  generate: true  # Enable l10n generation
```

### 1.4 Configure Localization

Create `l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

Create initial ARB file `lib/l10n/app_en.arb`:

```json
{
  "@@locale": "en",
  "appTitle": "Shadow",
  "homeTab": "Home",
  "conditionsTab": "Conditions",
  "supplementsTab": "Supplements"
}
```

### 1.5 Set Up Dependency Injection

Create `lib/injection_container.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core Services
  sl.registerLazySingleton(() => const Uuid());

  // Database (to be added in Phase 2)
  // Repositories (to be added in Phase 3)
  // Providers (to be added in Phase 4)
}
```

### Deliverables - Phase 1

- [ ] Flutter project created and configured
- [ ] Folder structure established
- [ ] All dependencies added and resolved
- [ ] Localization configured
- [ ] Dependency injection skeleton in place
- [ ] Project builds successfully on all target platforms

---

## Phase 2: Database & Core Services (Week 3-4)

### 2.1 Create Exception Classes

`lib/core/errors/exceptions.dart`:

```dart
class EntityNotFoundException implements Exception {
  final String entityType;
  final String entityId;

  EntityNotFoundException({
    required this.entityType,
    required this.entityId,
  });

  @override
  String toString() => '$entityType with id $entityId not found';
}

class DatabaseException implements Exception {
  final String message;
  final String? operation;
  final dynamic originalError;

  DatabaseException({
    required this.message,
    this.operation,
    this.originalError,
  });
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}
```

### 2.2 Create Logger Service

`lib/core/services/logger_service.dart`:

```dart
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  late final Logger _logger;

  factory LoggerService() => _instance;

  LoggerService._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
      ),
      level: kDebugMode ? Level.debug : Level.info,
    );
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  ScopedLogger scope(String scope) => ScopedLogger(scope, this);
}

class ScopedLogger {
  final String scope;
  final LoggerService _logger;

  ScopedLogger(this.scope, this._logger);

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.debug('[$scope] $message', error, stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.info('[$scope] $message', error, stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.warning('[$scope] $message', error, stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.error('[$scope] $message', error, stackTrace);
  }
}

final logger = LoggerService();
```

### 2.3 Create Device Info Service

`lib/core/services/device_info_service.dart`:

```dart
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin;
  String? _deviceId;
  String? _deviceName;

  DeviceInfoService(this._deviceInfoPlugin);

  Future<String> getDeviceId() async {
    if (_deviceId != null) return _deviceId!;

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      _deviceId = iosInfo.identifierForVendor ??
          'ios-${iosInfo.model}-${iosInfo.name}';
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      _deviceId = androidInfo.id;
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfoPlugin.macOsInfo;
      _deviceId = macInfo.systemGUID ?? 'macos-${macInfo.computerName}';
    }

    return _deviceId!;
  }

  Future<String> getDeviceName() async {
    if (_deviceName != null) return _deviceName!;

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      _deviceName = '${iosInfo.name} (${iosInfo.model})';
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      _deviceName = '${androidInfo.brand} ${androidInfo.model}';
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfoPlugin.macOsInfo;
      _deviceName = macInfo.computerName;
    }

    return _deviceName!;
  }

  String getPlatform() {
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isMacOS) return 'macOS';
    return 'Unknown';
  }
}
```

### 2.4 Create Database Helper

`lib/data/datasources/local/database_helper.dart`:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shadow.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // User & Access tables
    await _createUserAccountsTable(db);
    await _createDeviceRegistrationsTable(db);
    await _createProfilesTable(db);
    await _createProfileAccessTable(db);

    // Health data tables (add as entities are created)
    await _createConditionsTable(db);
    await _createConditionLogsTable(db);
    await _createSupplementsTable(db);
    await _createIntakeLogsTable(db);
    // ... additional tables
  }

  Future<void> _createProfilesTable(Database db) async {
    await db.execute('''
      CREATE TABLE profiles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        birth_date TEXT,
        biological_sex TEXT,
        ethnicity TEXT,
        notes TEXT,
        owner_id TEXT NOT NULL,

        -- Sync metadata
        sync_created_at INTEGER NOT NULL,
        sync_updated_at INTEGER NOT NULL,
        sync_deleted_at INTEGER,
        sync_last_synced_at INTEGER,
        sync_status INTEGER NOT NULL DEFAULT 0,  -- 0=pending, 1=synced, 2=conflict, 3=error
        sync_version INTEGER NOT NULL DEFAULT 1,
        sync_is_dirty INTEGER NOT NULL DEFAULT 1,
        sync_created_by_device_id TEXT NOT NULL,
        sync_last_modified_by_device_id TEXT NOT NULL,

        FOREIGN KEY (owner_id) REFERENCES user_accounts(id)
      )
    ''');
    await db.execute('CREATE INDEX idx_profiles_owner_id ON profiles(owner_id)');
  }

  // Additional table creation methods...
}
```

### 2.5 Create SyncMetadata Entity

> **CANONICAL:** See `22_API_CONTRACTS.md` Section 3.1 for full @freezed definition.

`lib/domain/sync/sync_metadata.dart`:

```dart
/// Sync status values - MUST match database INTEGER values
enum SyncStatus {
  pending(0),    // Never synced
  synced(1),     // Successfully synced
  modified(2),   // Modified since last sync
  conflict(3),   // Conflict detected
  deleted(4);    // Marked for deletion

  final int value;
  const SyncStatus(this.value);

  static SyncStatus fromValue(int value) =>
    SyncStatus.values.firstWhere((e) => e.value == value, orElse: () => pending);
}

@freezed
class SyncMetadata with _$SyncMetadata {
  const SyncMetadata._();

  const factory SyncMetadata({
    required int syncCreatedAt,      // Epoch milliseconds
    required int syncUpdatedAt,      // Epoch milliseconds
    int? syncDeletedAt,              // Null = active
    @Default(SyncStatus.pending) SyncStatus syncStatus,
    @Default(1) int syncVersion,
    required String syncDeviceId,
    @Default(true) bool syncIsDirty,
    String? conflictData,
  }) = _SyncMetadata;

  factory SyncMetadata.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataFromJson(json);

  factory SyncMetadata.create({required String deviceId}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return SyncMetadata(
      syncCreatedAt: now,
      syncUpdatedAt: now,
      syncDeviceId: deviceId,
    );
  }

  bool get isDeleted => syncDeletedAt != null;

  SyncMetadata markModified(String deviceId) => copyWith(
    syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    syncDeviceId: deviceId,
    syncIsDirty: true,
    syncStatus: SyncStatus.modified,
    syncVersion: syncVersion + 1,
  );

  SyncMetadata markSynced() => copyWith(
    syncIsDirty: false,
    syncStatus: SyncStatus.synced,
  );

  SyncMetadata markDeleted(String deviceId) => copyWith(
    syncDeletedAt: DateTime.now().millisecondsSinceEpoch,
    syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    syncDeviceId: deviceId,
    syncIsDirty: true,
    syncStatus: SyncStatus.deleted,
    syncVersion: syncVersion + 1,
  );
}
```

### 2.6 Create BaseRepository

`lib/core/repositories/base_repository.dart`:

```dart
import 'package:uuid/uuid.dart';
import '../services/device_info_service.dart';
import '../../domain/sync/sync_metadata.dart';

/// Base class for all repositories with sync support.
/// ALL repository implementations MUST extend this class.
abstract class BaseRepository<T> {
  final Uuid _uuid;
  final DeviceInfoService _deviceInfoService;

  BaseRepository(this._uuid, this._deviceInfoService);

  /// Generate ID if not provided or empty
  String generateId(String? existingId) {
    return existingId?.isNotEmpty == true ? existingId! : _uuid.v4();
  }

  /// Create fresh SyncMetadata for new entities
  Future<SyncMetadata> createSyncMetadata() async {
    final deviceId = await _deviceInfoService.getDeviceId();
    return SyncMetadata.create(deviceId: deviceId);
  }

  /// Prepare entity for creation (generate ID, create sync metadata)
  /// NOTE: These helpers return the prepared entity; the calling repository
  /// method wraps the result in Result<T, AppError>
  Future<T> prepareForCreate<T>(
    T entity,
    T Function(String id, SyncMetadata syncMetadata) copyWith, {
    String? existingId,
  }) async {
    final id = generateId(existingId);
    final syncMetadata = await createSyncMetadata();
    return copyWith(id, syncMetadata);
  }

  /// Prepare entity for update (update sync metadata)
  /// NOTE: These helpers return the prepared entity; the calling repository
  /// method wraps the result in Result<T, AppError>
  Future<T> prepareForUpdate<T>(
    T entity,
    T Function(SyncMetadata syncMetadata) copyWith, {
    bool markDirty = true,
    required SyncMetadata Function(T) getSyncMetadata,
  }) async {
    if (!markDirty) return entity;

    final deviceId = await _deviceInfoService.getDeviceId();
    final existingMetadata = getSyncMetadata(entity);
    final updatedMetadata = existingMetadata.markModified(deviceId);
    return copyWith(updatedMetadata);
  }

  /// Prepare entity for soft delete
  /// NOTE: These helpers return the prepared entity; the calling repository
  /// method wraps the result in Result<T, AppError>
  Future<T> prepareForDelete<T>(
    T entity,
    T Function(SyncMetadata syncMetadata) copyWith, {
    required SyncMetadata Function(T) getSyncMetadata,
  }) async {
    final deviceId = await _deviceInfoService.getDeviceId();
    final existingMetadata = getSyncMetadata(entity);
    final deletedMetadata = existingMetadata.markDeleted(deviceId);
    return copyWith(deletedMetadata);
  }
}
```

### Deliverables - Phase 2

- [ ] Exception classes created
- [ ] Logger service implemented
- [ ] Device info service implemented
- [ ] Database helper with initial tables
- [ ] SyncMetadata entity defined
- [ ] BaseRepository with sync helpers
- [ ] All services registered in DI container
- [ ] Unit tests for all services (100% coverage)

---

## Phase 3: Domain Entities & Repositories (Week 5-8)

### 3.1 Create Profile Entity

`lib/domain/entities/profile.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// User health profile entity.
///
/// Each profile represents a person being tracked (self, family member, client).
@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String clientId,     // Required for database merging
    required String name,
    int? birthDate, // Epoch milliseconds
    String? biologicalSex,
    String? ethnicity,
    String? notes,
    required String ownerId,      // User who owns this profile
    @Default(DietType.none) DietType dietType,
    String? dietDescription,
    required SyncMetadata syncMetadata,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
```

### 3.2 Entity Creation Order

Create entities in this order (respecting dependencies):

1. **Core Entities** (no dependencies)
   - Profile
   - UserAccount
   - DeviceRegistration

2. **Standalone Health Entities**
   - Supplement
   - FoodItem
   - Activity
   - PhotoArea

3. **Dependent Health Entities**
   - Condition (references Profile)
   - ConditionLog (references Condition)
   - FlareUp (references Condition)
   - SupplementIntakeLog (references Supplement)
   - FoodLog (references FoodItem)
   - ActivityLog (references Activity)
   - PhotoEntry (references PhotoArea)
   - SleepEntry
   - FluidsEntry
   - JournalEntry
   - Document

4. **Access Control**
   - ProfileAccess (references Profile, UserAccount)

### 3.3 Repository Pattern for Each Entity

For each entity, create:

1. **Repository Interface** (`lib/domain/repositories/{entity}_repository.dart`)
2. **Local Data Source Interface** (`lib/data/datasources/local/{entity}_local_datasource.dart`)
3. **Local Data Source Implementation** (same file)
4. **Model Class** (`lib/data/models/{entity}_model.dart`)
5. **Repository Implementation** (`lib/data/repositories/{entity}_repository_impl.dart`)

### 3.4 Test Each Layer

For each entity, write tests:

```
test/domain/entities/{entity}_test.dart
test/data/models/{entity}_model_test.dart
test/data/datasources/local/{entity}_local_datasource_test.dart
test/data/repositories/{entity}_repository_impl_test.dart
```

### 3.5 New Entities for Phase 2 Features

In addition to the core 22 entities, create:

**FluidsEntry Entity** (replaces BowelUrineEntry):
```dart
enum MenstruationFlow { none, spotty, light, medium, heavy }

class FluidsEntry {
  // Existing bowel/urine fields...
  final MenstruationFlow? menstruationFlow;
  final double? basalBodyTemperature;  // °F or °C
  final DateTime? bbtRecordedTime;
}
```

**NotificationSchedule Entity**:
```dart
/// NotificationType: 25 values - See 22_API_CONTRACTS.md Section 3.2 for canonical definition
/// Includes: supplementIndividual(0)..inactivity(24)

class NotificationSchedule {
  final String id;
  final String? profileId;
  final NotificationType type;
  final String? entityId;
  final List<int> timesMinutesFromMidnight;
  final List<int> weekdays;
  final bool isEnabled;
  final String? customMessage;
  final SyncMetadata syncMetadata;
}
```

**Profile Entity Updates**:
```dart
enum DietType { none, vegan, vegetarian, paleo, keto, glutenFree, other }

class Profile {
  // Existing fields...
  final DietType? dietType;
  final String? dietDescription;  // For 'other' diet type
}
```

### Deliverables - Phase 3

- [ ] All 22+ entities created with proper structure (including FluidsEntry, NotificationSchedule)
- [ ] All repository interfaces defined
- [ ] All data sources implemented
- [ ] All models with JSON serialization
- [ ] All repository implementations
- [ ] Profile entity includes dietType, dietDescription fields
- [ ] FluidsEntry includes menstruation and BBT fields
- [ ] **Verify EVERY entity includes clientId field before repository creation**
- [ ] 100% test coverage on entities
- [ ] 100% test coverage on repositories

---

## Phase 4: UI Foundation & State Management (Week 9-12)

### 4.1 Create Theme Configuration

`lib/presentation/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
      // Define all theme properties...
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
      // Define all theme properties...
    );
  }
}
```

### 4.2 Create Accessible Widget Library

`lib/presentation/widgets/accessible_widgets.dart`:

Create base accessible components:
- AccessibleButton
- AccessibleCard
- AccessibleTextField
- AccessibleDropdown
- AccessibleSwitch
- AccessibleImage
- AccessibleLoadingIndicator
- AccessibleEmptyState

### 4.3 Riverpod Provider Pattern

**Shadow uses Riverpod with code generation for all state management.** No base provider class is needed - Riverpod's `@riverpod` annotation generates the boilerplate.

`lib/presentation/providers/supplement_provider.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/usecases/get_supplements_use_case.dart';

part 'supplement_provider.g.dart';

/// Profile-scoped async provider using family pattern
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    // Delegate to use case (authorization checked there)
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) => supplements,
      failure: (error) => throw error,  // AsyncValue handles error state
    );
  }

  /// Mutation methods return Result for explicit error handling
  Future<Result<Supplement, AppError>> add(CreateSupplementInput input) async {
    final useCase = ref.read(createSupplementUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      ref.invalidateSelf();  // Trigger refresh
    }

    return result;
  }
}
```

### 4.4 Create Feature Providers

Create providers for each feature domain:
- ProfileProvider
- ConditionProvider
- SupplementProvider
- FoodProvider
- ActivityProvider
- SleepProvider
- FluidsProvider
- PhotoProvider
- JournalProvider
- DocumentProvider
- AuthProvider
- SyncProvider

### 4.5 Create Main App Structure

`lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart' as di;
import 'presentation/screens/home_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const ShadowApp());
}

class ShadowApp extends StatelessWidget {
  const ShadowApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Riverpod ProviderScope wraps the entire app (in main.dart)
    // No manual provider registration needed - @riverpod generates them
    return MaterialApp(
      title: 'Shadow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

// In main.dart:
void main() {
  runApp(
    ProviderScope(  // Riverpod's root scope
      child: const ShadowApp(),
    ),
  );
}
```

### Deliverables - Phase 4

- [ ] Theme configuration complete
- [ ] Accessible widget library created
- [ ] All providers implemented
- [ ] Main app structure with provider setup
- [ ] Tab navigation working
- [ ] 100% test coverage on providers

---

## Phase 5: Core Screens & Features (Week 13-20)

### 5.1 Screen Development Order

Build screens in this order:

**Week 13-14: Profile & Authentication**
- Welcome Screen
- Sign In Screen
- Profiles Screen
- Add/Edit Profile Screen

**Week 15-16: Condition Tracking**
- Conditions Tab
- Add Condition Screen
- Condition Detail Screen
- Report Flare-Up Screen
- Flare-Ups List Screen

**Week 17-18: Supplement Management**
- Supplements Tab
- Add/Edit Supplement Screen
- Supplement Intake Logs Screen
- Report Supplements Screen

**Week 19-20: Additional Tracking**
- Food Tab + Log Food Screen
- Activities Tab + Add Activity Screen
- Sleep Tab + Add Sleep Entry Screen
- Bowels Tab + Add Entry Screen
- Photos Tab + Take Photo Screen
- Journal List + Add Entry Screen

### 5.2 Screen Template

Each screen follows this structure:

```dart
class AddSupplementScreen extends StatefulWidget {
  final Supplement? editingSupplement;

  const AddSupplementScreen({super.key, this.editingSupplement});

  @override
  State<AddSupplementScreen> createState() => _AddSupplementScreenState();
}

class _AddSupplementScreenState extends State<AddSupplementScreen> {
  static final _log = logger.scope('AddSupplementScreen');
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late TextEditingController _nameController;

  bool get _isEditing => widget.editingSupplement != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(
      text: widget.editingSupplement?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final provider = context.read<SupplementProvider>();
      // Save logic...
      Navigator.pop(context);
    } catch (e, stackTrace) {
      _log.error('Failed to save supplement', e, stackTrace);
      // Show error to user
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editSupplement : l10n.addSupplement),
      ),
      body: Form(
        key: _formKey,
        child: // Form content...
      ),
    );
  }
}
```

### Deliverables - Phase 5

- [ ] All 31+ screens implemented
- [ ] Full CRUD functionality for all entities
- [ ] Navigation working correctly
- [ ] Form validation on all inputs
- [ ] Loading and error states handled
- [ ] Widget tests for all screens (100% coverage)

---

## Phase 6: Cloud Sync & OAuth (Week 21-24)

### 6.1 OAuth Configuration

See [08_OAUTH_IMPLEMENTATION.md](./08_OAUTH_IMPLEMENTATION.md) for complete details.

**Key Configuration Values:**

```dart
// lib/core/config/google_oauth_config.dart
class GoogleOAuthConfig {
  // From .env or --dart-define
  static String get clientId =>
    const String.fromEnvironment('GOOGLE_OAUTH_CLIENT_ID');

  static const String authUri = 'https://accounts.google.com/o/oauth2/auth';
  static const String tokenUri = 'https://oauth2.googleapis.com/token';

  static const List<String> scopes = [
    'https://www.googleapis.com/auth/drive.file',
    'email',
    'profile',
  ];
}
```

### 6.2 Implement Cloud Storage Provider Interface

```dart
abstract class CloudStorageProvider {
  Future<bool> get isAuthenticated;
  Future<void> signIn();
  Future<void> signOut();
  Future<String> uploadJson(String path, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> downloadJson(String path);
  Future<String> uploadFile(String localPath, String cloudPath);
  Future<void> downloadFile(String cloudPath, String localPath);
  Future<void> deleteFile(String cloudPath);
  Future<List<String>> listFiles(String folder);
}
```

### 6.3 Implement Google Drive Provider

Complete implementation with:
- PKCE authentication flow
- Token management and refresh
- Rate limiting
- File upload/download
- JSON data sync

### 6.4 Implement Sync Service

```dart
class SyncService {
  Future<SyncResult> sync() async {
    // 1. Check connectivity
    // 2. Authenticate
    // 3. Upload dirty entities
    // 4. Download remote changes
    // 5. Resolve conflicts
    // 6. Sync files
    // 7. Update sync metadata
  }
}
```

### Deliverables - Phase 6

- [ ] OAuth flow working on all platforms
- [ ] Google Drive provider fully implemented
- [ ] Sync service orchestrating full sync
- [ ] Conflict resolution working
- [ ] File sync (photos, documents) working
- [ ] Multi-device pairing implemented
- [ ] Integration tests for sync flow

---

## Phase 7: Enhanced Features (Week 25-28)

### 7.1 Fluids Tab Enhancement

**Rename and Extend**:
1. Rename `bowels_urine_tab.dart` → `fluids_tab.dart`
2. Rename `BowelUrineProvider` → `FluidsProvider`
3. Add menstruation tracking section
4. Add BBT tracking section
5. Add BBT chart for cycle visualization

**UI Components**:
```dart
// Menstruation Flow Picker
FlowIntensityPicker(
  value: selectedFlow,
  onChanged: (flow) => setState(() => selectedFlow = flow),
)

// BBT Input
BBTInput(
  temperature: _temperature,
  recordedTime: _recordedTime,
  onTemperatureChanged: (temp) => setState(() => _temperature = temp),
  onTimeChanged: (time) => setState(() => _recordedTime = time),
)

// BBT Chart
BBTChart(
  entries: fluidsEntries,
  dateRange: DateRange(start: cycleStart, end: today),
)
```

### 7.2 Diet Type Feature

**Profile Updates**:
1. Add `DietType` dropdown to Add/Edit Profile screen
2. Add `dietDescription` text field (visible when dietType == other)
3. Display current diet type badge in Food tab header

**Food Tab Integration**:
```dart
// In FoodTab header
if (profile.dietType != null && profile.dietType != DietType.none)
  DietTypeBadge(dietType: profile.dietType!),
```

### 7.3 Notifications System

**Implementation Order**:

1. **Add Dependencies**:
```yaml
flutter_local_notifications: ^18.0.1
timezone: ^0.10.0
```

2. **Platform Configuration**:
   - Android: Add permissions to AndroidManifest.xml
   - iOS: Add background modes to Info.plist
   - Initialize timezone database

3. **Create Entity Stack**:
   - `lib/domain/entities/notification_schedule.dart`
   - `lib/domain/repositories/notification_schedule_repository.dart`
   - `lib/data/models/notification_schedule_model.dart`
   - `lib/data/datasources/local/notification_schedule_local_datasource.dart`
   - `lib/data/repositories/notification_schedule_repository_impl.dart`

4. **Create Service**:
   - `lib/core/services/notification_service.dart`
   - Handle initialization, permissions, scheduling
   - Implement deep link handling

5. **Create UI**:
   - `lib/presentation/providers/notification_provider.dart`
   - `lib/presentation/screens/notification_settings_screen.dart`
   - Add entry point from profile/settings

**Notification Settings Screen Layout**:
```
┌─────────────────────────────────────────┐
│ Notification Settings                    │
├─────────────────────────────────────────┤
│ ◉ Supplement Reminders                   │
│   [Vitamin D] 8:00 AM, 8:00 PM          │
│   [Magnesium] 9:00 PM                    │
│   [+ Add Reminder]                       │
├─────────────────────────────────────────┤
│ ◉ Meal Reminders                         │
│   Breakfast: 8:00 AM                     │
│   Lunch: 12:00 PM                        │
│   Dinner: 6:00 PM                        │
│   [+ Add Time]                           │
├─────────────────────────────────────────┤
│ ◉ Fluids Reminders                       │
│   Morning: 7:00 AM                       │
│   [+ Add Time]                           │
├─────────────────────────────────────────┤
│ ◉ Sleep Reminders                        │
│   Bedtime: 10:00 PM                      │
│   Wake-up: 6:30 AM                       │
└─────────────────────────────────────────┘
```

### 7.4 Branding Update

**Logo Replacement**:
1. Generate shadow silhouette icons in all required sizes
2. Replace Android mipmap icons
3. Replace iOS AppIcon assets
4. Replace macOS AppIcon assets
5. Replace web icons and favicon

**Color Scheme Update**:
1. Update `AppColors.dart` with earth tone palette
2. Update `app_constants.dart` PDF colors
3. Update `web/manifest.json` theme colors
4. Find and replace hardcoded `Colors.*` with `AppColors.*`

### Deliverables - Phase 7

- [ ] Fluids tab with menstruation and BBT tracking
- [ ] BBT chart visualization
- [ ] Diet type selection on profile
- [ ] Diet type display in food tab
- [ ] Notification service implemented
- [ ] Notification settings screen
- [ ] Deep linking from notifications
- [ ] Shadow silhouette logo assets
- [ ] Earth tone color scheme applied
- [ ] All hardcoded colors refactored

---

## Phase 8: Polish & Production (Week 29-32)

### 8.1 Performance Optimization

- Profile app with DevTools
- Optimize database queries
- Implement image caching
- Lazy load heavy screens

### 8.2 Accessibility Audit

- Test with VoiceOver/TalkBack
- Verify all semantic labels
- Check focus order
- Test keyboard navigation

### 8.3 Security Hardening

- Enable code obfuscation
- Implement certificate pinning
- Audit all logs for PII
- Test encryption end-to-end

### 8.4 App Store Preparation

**iOS:**
- Create App Store Connect listing
- Prepare screenshots
- Write app description
- Create privacy policy URL
- Create PrivacyInfo.xcprivacy

**Android:**
- Create Play Console listing
- Prepare screenshots
- Write store description
- Create privacy policy URL

### 8.5 Final Testing

- Full regression test
- Performance benchmarking
- Security penetration testing
- Accessibility validation

### Deliverables - Phase 8

- [ ] Performance meets all targets
- [ ] WCAG 2.1 Level AA certified
- [ ] Security audit passed
- [ ] App Store listings prepared
- [ ] All tests passing (5000+ tests)
- [ ] Documentation complete

---

## Testing Requirements Throughout

### Test-As-You-Go Rule

**MANDATORY**: Every feature must have tests before it's considered complete.

```
For each entity/feature:
1. Write unit tests for entity
2. Write unit tests for model
3. Write unit tests for data source
4. Write unit tests for repository
5. Write unit tests for provider
6. Write widget tests for screens
7. Write integration tests for user flows
```

### Coverage Targets

| Phase | Minimum Coverage |
|-------|------------------|
| Phase 2 | 100% for services |
| Phase 3 | 100% for repositories |
| Phase 4 | 100% for providers |
| Phase 5 | 100% for screens |
| Phase 6 | 100% for sync |
| Phase 7 | 100% overall |

> **Note:** Per 02_CODING_STANDARDS.md Section 10.3, 100% test coverage is required for all code at all phases.

---

## Consistency Checklist

Before completing any phase, verify:

- [ ] All naming conventions followed (see 07_NAMING_CONVENTIONS.md)
- [ ] All coding standards met (see 02_CODING_STANDARDS.md)
- [ ] All tests passing
- [ ] Documentation updated
- [ ] Code reviewed
- [ ] No compiler warnings
- [ ] flutter analyze clean

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-01-30 | Added Phase 7 for enhanced features (Fluids, notifications, diet types, branding) |

---
## [Original: 20_CICD_PIPELINE.md]

# Shadow CI/CD Pipeline

**Version:** 1.0
**Last Updated:** January 30, 2026
**Platform:** GitHub Actions
**Purpose:** Automated build, test, and deployment pipeline

---

## Overview

Shadow uses GitHub Actions for continuous integration and deployment. All code changes must pass automated checks before merging, and releases are automated through the pipeline.

---

## 1. Pipeline Architecture

### 1.1 Pipeline Stages

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CI/CD Pipeline                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Pull Request                                                       │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  │
│  │  Lint   │→ │  Test   │→ │  Build  │→ │ Analyze │→ │ Preview │  │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘  │
│                                                                     │
│  Main Branch (merge)                                                │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────────────────┐    │
│  │  Test   │→ │  Build  │→ │ Sign    │→ │ Deploy to TestFlight │   │
│  └─────────┘  └─────────┘  └─────────┘  │ & Internal Track      │   │
│                                         └─────────────────────┘    │
│                                                                     │
│  Release Tag (v*)                                                   │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────────────────┐    │
│  │  Test   │→ │  Build  │→ │  Sign   │→ │ Deploy to App Store  │   │
│  └─────────┘  └─────────┘  └─────────┘  │ & Play Store          │   │
│                                         └─────────────────────┘    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 1.2 Trigger Rules

| Trigger | Workflow | Actions |
|---------|----------|---------|
| Pull Request (opened/sync) | `pr-checks.yml` | Lint, Test, Build, Analyze |
| Push to `main` | `deploy-beta.yml` | Test, Build, Deploy to TestFlight/Internal |
| Tag `v*` | `deploy-production.yml` | Test, Build, Deploy to stores |
| Manual | `deploy-manual.yml` | Selective deployment |
| Schedule (daily) | `nightly.yml` | Full test suite, dependency audit |

---

## 2. Pull Request Workflow

### 2.1 PR Checks Configuration

```yaml
# .github/workflows/pr-checks.yml

name: PR Checks

on:
  pull_request:
    branches: [main, develop]
    types: [opened, synchronize, reopened]

concurrency:
  group: pr-${{ github.event.pull_request.number }}
  cancel-in-progress: true

jobs:
  lint:
    name: Lint & Format
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Check formatting
        run: dart format --set-exit-if-changed .

      - name: Analyze code
        run: flutter analyze --fatal-infos

      - name: Check for unused code
        run: dart run dart_code_metrics:metrics analyze lib

  test:
    name: Test
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests with coverage
        run: flutter test --coverage --reporter=github

      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | awk '{print $2}' | tr -d '%')
          if (( $(echo "$COVERAGE < 100" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 100% threshold"
            exit 1
          fi

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: coverage/lcov.info

  build-android:
    name: Build Android
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Build APK
        run: flutter build apk --debug

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: debug-apk
          path: build/app/outputs/flutter-apk/app-debug.apk

  build-ios:
    name: Build iOS
    runs-on: macos-14
    needs: test
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Build iOS (no signing)
        run: flutter build ios --debug --no-codesign

  accessibility:
    name: Accessibility Audit
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Run accessibility tests
        run: flutter test test/accessibility/

  localization:
    name: Localization Check
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Check for missing translations
        run: |
          flutter gen-l10n
          git diff --exit-code lib/l10n/
```

### 2.2 Required Checks

All PRs require:

| Check | Requirement | Blocking |
|-------|-------------|----------|
| `lint` | Zero warnings | Yes |
| `test` | 100% pass | Yes |
| `coverage` | 100% lines | Yes |
| `build-android` | Successful | Yes |
| `build-ios` | Successful | Yes |
| `accessibility` | Zero failures | Yes |
| `localization` | No missing keys | Yes |
| Review | 1 approval | Yes |

---

## 3. Beta Deployment Workflow

### 3.1 Deploy to TestFlight & Internal Track

```yaml
# .github/workflows/deploy-beta.yml

name: Deploy Beta

on:
  push:
    branches: [main]

jobs:
  test:
    name: Test Suite
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true
      - run: flutter test

  build-and-deploy-ios:
    name: iOS TestFlight
    runs-on: macos-14
    needs: test
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Install Apple Certificate
        env:
          P12_CERTIFICATE: ${{ secrets.APPLE_P12_CERTIFICATE }}
          P12_PASSWORD: ${{ secrets.APPLE_P12_PASSWORD }}
          KEYCHAIN_PASSWORD: ${{ secrets.KEYCHAIN_PASSWORD }}
        run: |
          # Create keychain
          security create-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
          security default-keychain -s build.keychain
          security unlock-keychain -p "$KEYCHAIN_PASSWORD" build.keychain

          # Import certificate
          echo "$P12_CERTIFICATE" | base64 --decode > certificate.p12
          security import certificate.p12 -k build.keychain -P "$P12_PASSWORD" -T /usr/bin/codesign
          security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" build.keychain

      - name: Install Provisioning Profile
        env:
          PROVISIONING_PROFILE: ${{ secrets.APPLE_PROVISIONING_PROFILE }}
        run: |
          mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
          echo "$PROVISIONING_PROFILE" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/shadow_beta.mobileprovision

      - name: Build iOS
        run: |
          flutter build ipa \
            --release \
            --export-options-plist=ios/ExportOptions.plist \
            --build-number=${{ github.run_number }}

      - name: Upload to TestFlight
        env:
          APP_STORE_CONNECT_API_KEY: ${{ secrets.APP_STORE_CONNECT_API_KEY }}
        run: |
          xcrun altool --upload-app \
            --type ios \
            --file build/ios/ipa/Shadow.ipa \
            --apiKey $APP_STORE_CONNECT_API_KEY \
            --apiIssuer ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}

  build-and-deploy-android:
    name: Android Internal Track
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Decode keystore
        env:
          KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
        run: |
          echo "$KEYSTORE_BASE64" | base64 --decode > android/app/keystore.jks

      - name: Build App Bundle
        env:
          KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
          KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
          KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
        run: |
          flutter build appbundle \
            --release \
            --build-number=${{ github.run_number }}

      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.bluedomecolorado.shadow
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: internal
          status: completed
```

---

## 4. Production Deployment Workflow

### 4.1 Release Process

```yaml
# .github/workflows/deploy-production.yml

name: Deploy Production

on:
  push:
    tags:
      - 'v*'

jobs:
  validate-tag:
    name: Validate Release Tag
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Validate semver
        run: |
          TAG=${GITHUB_REF#refs/tags/}
          if [[ ! $TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "Invalid tag format: $TAG"
            exit 1
          fi

      - name: Check changelog
        run: |
          TAG=${GITHUB_REF#refs/tags/}
          if ! grep -q "## $TAG" CHANGELOG.md; then
            echo "No changelog entry for $TAG"
            exit 1
          fi

  test:
    name: Full Test Suite
    runs-on: ubuntu-latest
    needs: validate-tag
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true
      - run: flutter test --coverage
      - name: Integration tests
        run: flutter test integration_test/

  build-ios-production:
    name: iOS App Store
    runs-on: macos-14
    needs: test
    steps:
      # ... (similar to beta, with production provisioning)

      - name: Upload to App Store Connect
        run: |
          xcrun altool --upload-app \
            --type ios \
            --file build/ios/ipa/Shadow.ipa \
            --apiKey $APP_STORE_CONNECT_API_KEY \
            --apiIssuer $APP_STORE_CONNECT_ISSUER_ID

  build-android-production:
    name: Android Play Store
    runs-on: ubuntu-latest
    needs: test
    steps:
      # ... (similar to beta)

      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.bluedomecolorado.shadow
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: production
          status: draft  # Requires manual release

  create-github-release:
    name: GitHub Release
    runs-on: ubuntu-latest
    needs: [build-ios-production, build-android-production]
    steps:
      - uses: actions/checkout@v4

      - name: Extract changelog
        id: changelog
        run: |
          TAG=${GITHUB_REF#refs/tags/}
          CHANGELOG=$(sed -n "/## $TAG/,/## v/p" CHANGELOG.md | head -n -1)
          echo "changelog<<EOF" >> $GITHUB_OUTPUT
          echo "$CHANGELOG" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          body: ${{ steps.changelog.outputs.changelog }}
          draft: false
          prerelease: false
```

---

## 5. Version Management

### 5.1 Versioning Scheme

```
MAJOR.MINOR.PATCH+BUILD

Example: 1.2.3+456

MAJOR: Breaking changes, major features
MINOR: New features, non-breaking
PATCH: Bug fixes
BUILD: CI build number (auto-incremented)
```

### 5.2 Version Bump Script

```bash
#!/bin/bash
# scripts/bump-version.sh

BUMP_TYPE=$1  # major, minor, patch

# Read current version
CURRENT=$(grep 'version:' pubspec.yaml | sed 's/version: //' | cut -d'+' -f1)
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case $BUMP_TYPE in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Update pubspec.yaml
sed -i "s/version: .*/version: $NEW_VERSION+\$BUILD_NUMBER/" pubspec.yaml

echo "Version bumped to $NEW_VERSION"
```

---

## 6. Environment Configuration

### 6.1 Secrets Required

| Secret | Purpose | Rotation |
|--------|---------|----------|
| `APPLE_P12_CERTIFICATE` | iOS code signing | Annual |
| `APPLE_P12_PASSWORD` | Certificate password | With cert |
| `APPLE_PROVISIONING_PROFILE` | iOS provisioning | Annual |
| `APP_STORE_CONNECT_API_KEY` | App Store upload | 2 years |
| `APP_STORE_CONNECT_ISSUER_ID` | API authentication | N/A |
| `ANDROID_KEYSTORE_BASE64` | Android signing | Never |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password | Never |
| `ANDROID_KEY_ALIAS` | Key alias | Never |
| `ANDROID_KEY_PASSWORD` | Key password | Never |
| `GOOGLE_PLAY_SERVICE_ACCOUNT` | Play Store upload | 2 years |
| `GOOGLE_OAUTH_CLIENT_ID` | OAuth config | N/A |
| `CODECOV_TOKEN` | Coverage upload | N/A |

### 6.2 Build Arguments

```yaml
# Passed via --dart-define
GOOGLE_OAUTH_CLIENT_ID: OAuth client ID
GOOGLE_OAUTH_PROXY_URL: Token exchange proxy URL
ENVIRONMENT: development | staging | production
```

---

## 7. Monitoring & Alerts

### 7.1 Pipeline Notifications

| Event | Channel | Recipients |
|-------|---------|------------|
| PR check failed | GitHub | PR author |
| Main build failed | Slack #ci-alerts | Team |
| Production deploy | Slack #releases | Team |
| Deploy failed | Slack #ci-alerts + PagerDuty | On-call |

### 7.2 Slack Integration

```yaml
- name: Notify Slack
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    channel-id: 'C0123456789'
    slack-message: |
      :x: Build failed for ${{ github.repository }}
      Branch: ${{ github.ref }}
      Commit: ${{ github.sha }}
      Author: ${{ github.actor }}
      <${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}|View Run>
  env:
    SLACK_BOT_TOKEN: ${{ secrets.SLACK_BOT_TOKEN }}
```

---

## 8. Rollback Procedures

### 8.1 Quick Rollback

```bash
# Revert to previous version on TestFlight/Internal Track
# (Previous builds remain available)

# For App Store:
# 1. Remove current version from sale
# 2. Previous version automatically becomes available

# For Play Store:
# 1. Halt staged rollout
# 2. Rollback to previous release
```

### 8.2 Hotfix Process

```
1. Create branch from release tag
   git checkout -b hotfix/v1.2.4 v1.2.3

2. Apply fix

3. Bump patch version
   ./scripts/bump-version.sh patch

4. Create PR to main

5. After merge, tag release
   git tag v1.2.4
   git push origin v1.2.4

6. Pipeline deploys automatically
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 21_MONITORING.md]

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

---
## [Original: 23_ENGINEERING_GOVERNANCE.md]

# Shadow Engineering Governance

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Controls and processes for consistent multi-engineer development

---

## Overview

This document defines the governance structure, processes, and controls required to maintain consistency across a large engineering team. All engineers MUST follow these processes.

---

## 1. Team Structure

### 1.1 Code Ownership Model

```
Shadow Codebase
├── Core Team (3 engineers)
│   ├── lib/core/           - Error handling, services, utilities
│   ├── lib/domain/         - Entities, repositories, use cases
│   └── Database schema     - All migrations
│
├── Feature Teams (8 engineers each)
│   ├── Team Conditions     - Condition tracking features
│   ├── Team Supplements    - Supplement management
│   ├── Team Nutrition      - Food, diet types
│   ├── Team Wellness       - Sleep, fluids, activities
│   ├── Team Sync           - Cloud sync, conflict resolution
│   └── Team Platform       - Notifications, deep linking
│
├── UI/UX Team (4 engineers)
│   ├── lib/presentation/widgets/  - Consolidated widget library
│   └── lib/presentation/theme/    - Design system
│
└── Quality Team (2 engineers)
    ├── test/                       - Test infrastructure
    └── CI/CD                       - Pipeline maintenance
```

### 1.2 CODEOWNERS File

```
# .github/CODEOWNERS

# Core - requires Core Team approval
/lib/core/                    @shadow/core-team
/lib/domain/entities/         @shadow/core-team
/lib/domain/repositories/     @shadow/core-team
/lib/domain/usecases/         @shadow/core-team

# Database - requires Core Team + DBA
/lib/data/datasources/local/database*.dart  @shadow/core-team @shadow/dba

# Features - require feature team + core team
/lib/**/supplement*           @shadow/team-supplements @shadow/core-team
/lib/**/condition*            @shadow/team-conditions @shadow/core-team
/lib/**/food*                 @shadow/team-nutrition @shadow/core-team
/lib/**/fluids*               @shadow/team-wellness @shadow/core-team
/lib/**/sleep*                @shadow/team-wellness @shadow/core-team
/lib/**/sync*                 @shadow/team-sync @shadow/core-team
/lib/**/notification*         @shadow/team-platform @shadow/core-team

# Widgets - require UI team
/lib/presentation/widgets/    @shadow/ui-team
/lib/presentation/theme/      @shadow/ui-team

# Tests - require quality team
/test/                        @shadow/quality-team

# CI/CD - require quality team + tech lead
/.github/workflows/           @shadow/quality-team @shadow/tech-leads

# API Contracts - require architecture review
/docs/*_CONTRACTS.md          @shadow/architects
```

---

## 2. Development Workflow

### 2.1 Branch Strategy

```
main (protected)
  │
  ├── release/v1.1.0 (protected)
  │     │
  │     └── hotfix/v1.1.1-auth-fix
  │
  └── develop (protected)
        │
        ├── feature/SHADOW-123-fluids-bbt
        ├── feature/SHADOW-124-notification-deep-link
        └── feature/SHADOW-125-diet-type-selector
```

**Rules:**
- `main`: Production. Requires 2 approvals + passing CI + tech lead sign-off
- `release/*`: Release candidates. Requires 2 approvals + QA sign-off
- `develop`: Integration branch. Requires 2 approvals + passing CI
- `feature/*`: Feature work. Must include ticket number (SHADOW-XXX)
- `hotfix/*`: Emergency fixes. Requires tech lead approval

### 2.2 Commit Message Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]

SHADOW-XXX
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code change that neither fixes nor adds
- `test`: Adding tests
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `perf`: Performance improvement
- `chore`: Build process or auxiliary tool changes

**Example:**
```
feat(fluids): add BBT temperature input with validation

- Add BBTInputWidget with temperature range validation
- Support both Fahrenheit and Celsius units
- Include time picker for recording time

Acceptance criteria verified:
- [x] Temperature range validated (95-105°F)
- [x] Unit toggle works correctly
- [x] Time picker shows correct default

SHADOW-456
```

### 2.3 Pull Request Template

```markdown
## Description
<!-- What does this PR do? -->

## Related Issue
SHADOW-XXX

## Type of Change
- [ ] Feature
- [ ] Bug fix
- [ ] Refactor
- [ ] Documentation
- [ ] Test

## Checklist
### Code Quality
- [ ] Code follows API Contracts (22_API_CONTRACTS.md)
- [ ] All methods use Result type (no throwing)
- [ ] Validation rules from ValidationRules class used
- [ ] Error codes from defined constants used

### Testing
- [ ] Unit tests added/updated (coverage maintained)
- [ ] Widget tests for UI changes
- [ ] Integration tests for new flows
- [ ] Contract tests pass

### Documentation
- [ ] Code comments for complex logic
- [ ] API documentation updated if public interface changed
- [ ] Spec documents updated if behavior changed

### Accessibility
- [ ] Semantic labels on all interactive elements
- [ ] Touch targets minimum 48x48
- [ ] Screen reader tested (if UI change)

### Generated Code
- [ ] Ran `dart run build_runner build`
- [ ] Generated files committed

## Screenshots (if UI change)
<!-- Before/After screenshots -->

## Test Plan
<!-- How to verify this works -->
```

---

## 3. Quality Gates

### 3.1 Required Checks

| Check | Blocking | Details |
|-------|----------|---------|
| `flutter analyze` | Yes | Zero warnings, zero infos |
| `flutter test` | Yes | 100% pass rate |
| Coverage threshold | Yes | 100% for all code |
| Contract tests | Yes | All interface contracts valid |
| Build (iOS) | Yes | Successful build |
| Build (Android) | Yes | Successful build |
| Build (macOS) | Yes | Successful build |
| Lint rules | Yes | Custom lint rules pass |
| Commit format | Yes | Conventional commits |
| Generated files | Yes | Up to date |

### 3.2 Code Coverage Requirements

> **Canonical Source:** All coverage requirements are defined in `02_CODING_STANDARDS.md` Section 10.3.

| Area | Minimum | Target |
|------|---------|--------|
| Domain Entities | 100% | 100% |
| Data Models | 100% | 100% |
| Data Sources | 100% | 100% |
| Repositories | 100% | 100% |
| Services | 100% | 100% |
| Providers | 100% | 100% |
| Widgets | 100% | 100% |
| Screens | 100% | 100% |
| **Overall** | **100%** | **100%** |

### 3.3 Review Requirements

| Change Type | Reviewers Required | Special Approvers |
|-------------|-------------------|-------------------|
| Core/Domain | 2 | Core Team member |
| Database schema | 2 | DBA + Core Team |
| API Contracts | 3 | Architect + 2 Core |
| Feature code | 2 | Feature Team + Core |
| Widget library | 2 | UI Team member |
| CI/CD | 2 | Quality Team + Tech Lead |
| Security-related | 3 | Security Team + Core |

---

## 4. Architecture Decision Records (ADRs)

### 4.1 When ADR Required

An ADR is REQUIRED for:
- Any change to API Contracts
- New dependencies
- Database schema changes
- New architectural patterns
- Deviation from established conventions
- Performance optimizations affecting architecture
- Security-related changes

### 4.2 ADR Template

```markdown
# ADR-XXX: Title

## Status
Proposed | Accepted | Deprecated | Superseded by ADR-YYY

## Context
What is the issue motivating this decision?

## Decision
What is the change being proposed?

## Consequences
What are the positive and negative effects?

## Alternatives Considered
What other options were evaluated?

## References
- Related ADRs
- External documentation
```

### 4.3 ADR Process

```
1. Engineer identifies need for architectural decision
         │
         ▼
2. Create ADR in /docs/adr/ with status "Proposed"
         │
         ▼
3. Submit PR for ADR (separate from implementation)
         │
         ▼
4. Architecture review meeting (weekly)
         │
         ├── Approved → Status: "Accepted", merge ADR
         │
         └── Rejected → Update ADR with feedback, re-review
         │
         ▼
5. Implementation PR references ADR number
```

---

## 5. Contract Testing

### 5.1 Contract Test Requirements

Every repository and use case MUST have contract tests:

```dart
// test/contracts/repositories/supplement_repository_contract_test.dart

@Tags(['contract'])
void main() {
  group('SupplementRepository Contract', () {
    late SupplementRepository repository;

    setUp(() {
      repository = SupplementRepositoryImpl(/* ... */);
    });

    group('getAll', () {
      test('returns Result<List<Supplement>, AppError>', () async {
        final result = await repository.getAll();

        expect(result, isA<Result<List<Supplement>, AppError>>());
      });

      test('returns empty list when no supplements, not null', () async {
        final result = await repository.getAll(profileId: 'empty-profile');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
        expect(result.valueOrNull, isNotNull);
      });
    });

    group('getById', () {
      test('returns Failure with DatabaseError.notFound for missing id', () async {
        final result = await repository.getById('non-existent-id');

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
        expect((result.errorOrNull as DatabaseError).code,
            equals(DatabaseError.codeNotFound));
      });
    });

    group('create', () {
      test('returns created entity with generated ID', () async {
        final input = Supplement(id: '', /* ... */);
        final result = await repository.create(input);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, isNotEmpty);
        expect(result.valueOrNull!.id, isNot(equals('')));
      });

      test('returns created entity with sync metadata populated', () async {
        final input = Supplement(id: '', /* ... */);
        final result = await repository.create(input);

        expect(result.valueOrNull!.syncMetadata.createdAt, isNotNull);
        expect(result.valueOrNull!.syncMetadata.syncStatus, equals(SyncStatus.pending));
      });
    });
  });
}
```

### 5.2 Running Contract Tests

```bash
# Run all contract tests
flutter test --tags=contract

# Contract tests MUST pass before PR merge
# CI will run: flutter test --tags=contract --coverage
```

---

## 6. Consistency Enforcement

### 6.1 Pre-commit Hooks

**Installation:** `cp scripts/pre-commit .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit`

```bash
#!/bin/bash
# scripts/pre-commit - SHADOW-014 Implementation
# Pre-commit hook per 23_ENGINEERING_GOVERNANCE.md Section 6.1

set -e

echo "Running pre-commit checks..."

# 1. Ensure generated files are up to date
echo "Checking generated files..."
dart run build_runner build --delete-conflicting-outputs 2>/dev/null || {
  echo "WARNING: build_runner failed, skipping generated files check"
}

# Check for UNSTAGED changes to generated files
# git status --porcelain format: XY filename
#   X = index/staged status, Y = working tree status
# Only fail if Y (column 2) indicates unstaged changes (not a space)
# This allows committing newly staged generated files
#
# Examples:
#   "A  file.g.dart" - staged new file, working tree matches index -> OK
#   "M  file.g.dart" - staged modification, working tree matches index -> OK
#   " M file.g.dart" - unstaged modification -> FAIL
#   "AM file.g.dart" - staged new file with unstaged changes -> FAIL
#   "MM file.g.dart" - staged modification with more unstaged changes -> FAIL
if git status --porcelain | grep -E '\.(freezed|g)\.dart$' | grep -qE '^.[^ ]'; then
  echo ""
  echo "ERROR: Generated files have unstaged changes after running build_runner."
  echo "This means your source files have changes that require regeneration."
  echo ""
  echo "The following generated files have unstaged changes:"
  git status --porcelain | grep -E '\.(freezed|g)\.dart$' | grep -E '^.[^ ]'
  echo ""
  echo "To fix: git add <files> to stage them, or check if source files need staging first."
  exit 1
fi

# 2. Run analyzer
echo "Running analyzer..."
flutter analyze --fatal-infos --fatal-warnings || {
  echo ""
  echo "ERROR: flutter analyze found issues."
  echo "Please fix the issues above before committing."
  exit 1
}

# 3. Run format check
echo "Checking format..."
if ! dart format --set-exit-if-changed lib/ test/ 2>/dev/null; then
  echo ""
  echo "ERROR: Code is not properly formatted."
  echo "The following files need formatting:"
  dart format --output=none lib/ test/ 2>/dev/null | grep "Changed" || true
  echo ""
  echo "Run 'dart format lib/ test/' to fix formatting."
  exit 1
fi

echo ""
echo "All pre-commit checks passed!"
```

**Future Additions (not yet implemented):**
- Contract tests: `flutter test --tags=contract` (requires tests tagged with `@Tags(['contract'])`)
- Commit message format validation (requires conventional commit format)

### 6.2 Custom Lint Rules

```dart
// tool/custom_lints/lib/rules/require_result_type.dart

class RequireResultTypeForRepositories extends DartLintRule {
  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodDeclaration((node) {
      // Check if this is a repository method
      if (!_isRepositoryMethod(node)) return;

      // Check return type is Future<Result<...>>
      final returnType = node.returnType?.type;
      if (returnType == null) {
        reporter.reportErrorForNode(
          LintCode('require_result_type', 'Repository methods must return Future<Result<T, AppError>>'),
          node,
        );
        return;
      }

      if (!_isResultType(returnType)) {
        reporter.reportErrorForNode(
          LintCode('require_result_type', 'Repository methods must return Future<Result<T, AppError>>, got ${returnType}'),
          node,
        );
      }
    });
  }
}
```

### 6.3 CI Validation

```yaml
# .github/workflows/validate.yml

name: Validate

on: [pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Check generated files committed
        run: |
          if [[ -n $(git status --porcelain) ]]; then
            echo "Generated files not committed:"
            git status --porcelain
            exit 1
          fi

      - name: Analyze
        run: flutter analyze --fatal-infos --fatal-warnings

      - name: Format check
        run: dart format --set-exit-if-changed lib/ test/

      - name: Contract tests
        run: flutter test --tags=contract

      - name: All tests
        run: flutter test --coverage

      - name: Check coverage
        run: |
          # Parse coverage and fail if below 100% threshold
          ./scripts/check_coverage.sh 100
```

### 6.4 Coverage Check Script

```bash
#!/bin/bash
# scripts/check_coverage.sh
# Validates code coverage meets required threshold

set -e

THRESHOLD=${1:-100}
COVERAGE_FILE="coverage/lcov.info"

if [[ ! -f "$COVERAGE_FILE" ]]; then
  echo "ERROR: Coverage file not found: $COVERAGE_FILE"
  echo "Run 'flutter test --coverage' first"
  exit 1
fi

# Parse lcov.info to calculate coverage percentage
# LF = lines found (total), LH = lines hit (covered)
LINES_FOUND=$(grep -E "^LF:" "$COVERAGE_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')
LINES_HIT=$(grep -E "^LH:" "$COVERAGE_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')

if [[ -z "$LINES_FOUND" || "$LINES_FOUND" -eq 0 ]]; then
  echo "ERROR: No coverage data found in $COVERAGE_FILE"
  exit 1
fi

# Calculate percentage (integer math, floor)
COVERAGE=$((LINES_HIT * 100 / LINES_FOUND))

echo "Coverage: $COVERAGE% ($LINES_HIT/$LINES_FOUND lines)"
echo "Threshold: $THRESHOLD%"

if [[ "$COVERAGE" -lt "$THRESHOLD" ]]; then
  echo "FAILED: Coverage $COVERAGE% is below threshold $THRESHOLD%"
  exit 1
fi

echo "PASSED: Coverage meets threshold"
exit 0
```

### 6.5 Platform Build Configuration

Platform-specific build files MUST be configured exactly as specified below to ensure consistent builds across all environments.

#### Android Configuration

**File:** `android/app/build.gradle.kts`

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.bluedomecolorado.shadow_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // REQUIRED: Core library desugaring for Java 8+ APIs on older Android versions
        // This is required by flutter_local_notifications and other plugins
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.bluedomecolorado.shadow_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // REQUIRED: Desugaring library for Java 8+ API compatibility
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
```

**Key Requirements:**
| Setting | Value | Reason |
|---------|-------|--------|
| `isCoreLibraryDesugaringEnabled` | `true` | Required for flutter_local_notifications |
| `coreLibraryDesugaring` | `2.0.4+` | Provides Java 8+ APIs on older Android |
| `JavaVersion` | `VERSION_17` | Flutter 3.x requirement |
| `namespace` | `com.bluedomecolorado.shadow_app` | Matches applicationId |

#### iOS Configuration

iOS build settings are managed via Xcode and CocoaPods. Key requirements:
- Minimum iOS version: Defined in `ios/Podfile`
- Swift version: 5.0+
- Enable required capabilities in Xcode project

---

## 7. Documentation Requirements

### 7.1 Self-Documenting Code Rules

| Element | Documentation Required |
|---------|----------------------|
| Public API | Dartdoc with `///` |
| Use Case | Purpose, inputs, outputs, errors |
| Repository method | What it does, when to use |
| Entity | Field descriptions |
| Complex logic | Inline comments explaining why |
| Magic numbers | Named constants with explanation |

### 7.2 Documentation Sync

```bash
# Run weekly
./scripts/sync_documentation.sh

# Checks:
# 1. All public APIs have Dartdoc
# 2. README files exist for each feature
# 3. API Contracts match actual interfaces
# 4. No TODO comments older than 30 days
```

### 7.3 Living Documentation

```yaml
# docs/LIVING_DOCS.yml
# Auto-generated from code - DO NOT EDIT

entities:
  - name: Supplement
    file: lib/domain/entities/supplement.dart
    fields: 12
    methods: 3

repositories:
  - name: SupplementRepository
    file: lib/domain/repositories/supplement_repository.dart
    methods:
      - getAll: "Future<Result<List<Supplement>, AppError>>"
      - getById: "Future<Result<Supplement, AppError>>"
      # ...

usecases:
  - name: GetSupplementsUseCase
    input: GetSupplementsInput
    output: List<Supplement>
    errors: [AuthError.profileAccessDenied, DatabaseError.*]
```

---

## 8. Conflict Prevention

### 8.1 Interface Lock

When working on shared interfaces:

1. Create ADR proposing interface change
2. Get approval BEFORE implementing
3. Interface changes require Core Team approval
4. All implementations updated in same PR

### 8.2 Feature Flags for WIP

All work-in-progress features MUST be behind feature flags:

```dart
// All new features default to disabled
if (featureFlags.isEnabled(FeatureFlags.fluidsBbtEnabled)) {
  // New BBT code
}
```

This prevents partial features from breaking the build.

### 8.3 Integration Windows

```
Monday-Wednesday: Feature development
Thursday: Integration testing, conflict resolution
Friday: Code freeze, release prep (for release weeks)
```

---

## 9. Onboarding Checklist

New engineers MUST complete:

- [ ] Read all specification documents (01-25)
- [ ] Complete API Contracts quiz (100% required)
- [ ] Shadow a PR review
- [ ] Submit first PR with mentor review
- [ ] Pass contract test certification
- [ ] Complete accessibility training
- [ ] Set up local hooks and tooling

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-02-03 | Fixed pre-commit hook to only fail on unstaged generated file changes (Section 6.1) |
| 1.2 | 2026-02-03 | Added detailed examples and documentation for git porcelain format in pre-commit hook |
| 1.3 | 2026-02-03 | Removed unimplemented contract tests and commit message checks from pre-commit hook; documented as future additions |

---
## [Original: 24_CODE_REVIEW_CHECKLIST.md]

# Shadow Code Review Checklist

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Standardized review criteria for all pull requests

---

## Overview

Every pull request MUST be reviewed against this checklist. Reviewers should copy this checklist into their review and check off each item. Any unchecked item blocks merge.

### Coding Standards Cross-Reference

Each review category maps to a section in `02_CODING_STANDARDS.md`:

| Review Category | Coding Standards Section |
|-----------------|-------------------------|
| API Contracts | §3 Repository Pattern, §7 Error Handling |
| ProfileId Filtering | §4.3 Data Source Standards |
| Code Quality | §1 Philosophy, §14 Documentation |
| Specification Compliance | §5 Entity Standards, §8 Database Standards |
| Testing | §10 Testing Standards |
| Accessibility | §13 Accessibility Standards |
| Performance | §12 Performance Standards |
| Security | §11 Security Standards |
| Documentation | §14 Documentation Standards |
| Generated Code | §5.2 Freezed Annotations |
| Architecture | §2 Architecture Standards |
| Providers | §6 Provider Standards |

**When in doubt, consult the canonical source in 02_CODING_STANDARDS.md.**

---

## 1. Quick Reference Checklist

Copy this into your PR review:

```markdown
## Code Review Checklist

### Architecture (§2 of 02_CODING_STANDARDS)
- [ ] Clean Architecture layers respected (Presentation → Domain → Data)
- [ ] No imports from Presentation in Domain layer
- [ ] No imports from Data in Domain layer
- [ ] Repository interfaces defined in Domain, implementations in Data
- [ ] UseCases are single-responsibility (one public method)

### API Contracts (§3, §7 of 02_CODING_STANDARDS)
- [ ] Methods return `Result<T, AppError>` (not throwing)
- [ ] Error codes use defined constants (e.g., `DatabaseError.codeNotFound`)
- [ ] Use case checks authorization first
- [ ] Use case validates input before repository calls
- [ ] Repository interface matches 22_API_CONTRACTS.md
- [ ] AppError includes `isRecoverable` and `recoveryAction` properties

### Provider Standards (§6 of 02_CODING_STANDARDS)
- [ ] Providers delegate to UseCases (no direct repository calls)
- [ ] State is immutable (no mutation of existing state objects)
- [ ] Loading/error/data states handled via AsyncValue
- [ ] ProfileId passed to all data-fetching methods
- [ ] Riverpod code generation used (@riverpod annotation)

### ProfileId Filtering (MANDATORY - §4.3)
- [ ] ALL repository methods returning lists include `profileId` parameter
- [ ] Data source WHERE clause includes `profile_id = ?`
- [ ] Data source WHERE clause includes `sync_deleted_at IS NULL`
- [ ] UseCase checks authorization: `authService.canRead(profileId)`
- [ ] SQL validates profile ownership (JOIN profiles WHERE owner_id = ?)
- [ ] No methods return data from all profiles without admin role

### Code Quality
- [ ] No `print()` statements (use logger)
- [ ] No hardcoded strings (use l10n)
- [ ] No hardcoded colors (use AppColors)
- [ ] No magic numbers (use named constants)
- [ ] No duplicate code (extract to shared utility)
- [ ] No unused imports or variables
- [ ] No TODO comments without ticket reference (format: `// TODO(SHADOW-123): description`)

### Specification Compliance
- [ ] Form fields match 38_UI_FIELD_SPECIFICATIONS.md
- [ ] Entity fields match 22_API_CONTRACTS.md
- [ ] Validation uses ValidationRules constants (never hardcoded values)
- [ ] All validators return user-friendly messages (ValidationMessages class)
- [ ] Entity includes clientId field for database merging
- [ ] SyncMetadata included in all syncable entities
- [ ] Default values match spec
- [ ] ProfileId filtering applied to ALL data queries (where applicable)
- [ ] Boundary tests exist for numeric validations

### Testing
- [ ] Unit tests for new/changed logic
- [ ] Contract tests for interface changes
- [ ] Widget tests for UI changes
- [ ] Edge cases covered (empty, null, error)
- [ ] Test names describe behavior, not implementation
- [ ] Security tests for auth/encryption (if applicable)

### Accessibility
- [ ] Semantic labels on interactive elements (see list below)
- [ ] Touch targets >= 48x48 dp
- [ ] Focus order is logical (FocusTraversalGroup)
- [ ] State changes announced (loading, error)
- [ ] No color-only information (icons + text)

**Elements REQUIRING semantic labels:**
- Buttons, IconButtons, FABs
- TextFields, Dropdowns, Switches, Checkboxes
- Tappable cards/list items (onTap)
- Custom GestureDetectors

**Elements NOT requiring labels (decorative):**
- Dividers, background images
- Icons inside labeled buttons

### Performance
- [ ] Lists use `ListView.builder` (not `ListView(children:)`)
- [ ] itemBuilder creates const widgets where possible
- [ ] No expensive computations in build()
- [ ] Images specify cacheWidth/cacheHeight
- [ ] Database queries use indexes on filtered columns
- [ ] No N+1 queries in loops
- [ ] Large result sets (50+ items) paginated
- [ ] Providers scoped appropriately (no unnecessary rebuilds)

### Security
- [ ] No PII in logs (use masking functions from 02_CODING_STANDARDS.md §11.6)
- [ ] Inputs validated/sanitized
- [ ] No hardcoded secrets or tokens
- [ ] Authorization checked before data access
- [ ] SQL includes profile ownership validation
- [ ] AES-256-GCM used for sensitive data encryption (NOT CBC)

### Data Source Standards (§4)
- [ ] All queries include `sync_deleted_at IS NULL` filter
- [ ] Profile ownership validated with JOIN profiles WHERE owner_id = ?
- [ ] All parameters use parameterized queries (no string concatenation)
- [ ] Transaction boundaries clearly defined

### Sync System Standards (§9)
- [ ] SyncMetadata present on all syncable entities
- [ ] Sync status transitions match spec (pending → synced → modified → conflict)
- [ ] Conflict resolution strategy documented if applicable
- [ ] Exempt tables documented in 10_DATABASE_SCHEMA.md Section 2.7

### Documentation
- [ ] File header comment present (per Section 14.2)
- [ ] Public APIs have Dartdoc
- [ ] Complex logic has comments
- [ ] Breaking changes documented in PR

### Generated Code
- [ ] `build_runner` was run
- [ ] Generated files are committed
- [ ] Freezed entities have correct annotations
```

---

## 2. Detailed Review Criteria

### 2.1 API Contract Compliance

#### Result Type Usage

**CORRECT:**
```dart
// Method naming: getAll{Entity}s with required profileId
Future<Result<List<Supplement>, AppError>> getAllSupplements({
  required String profileId,
}) async {
  try {
    final data = await _datasource.query(profileId);
    return Success(data);
  } on DatabaseException catch (e, stack) {
    return Failure(DatabaseError.queryFailed(e.message, e, stack));
  }
}
```

**WRONG:**
```dart
// REJECT: Returns nullable instead of Result
Future<List<Supplement>?> getAllSupplements({required String profileId}) async {
  try {
    return await _datasource.query(profileId);
  } catch (e) {
    return null;  // Error information lost!
  }
}

// REJECT: Throws instead of returning Failure
Future<Result<Supplement?, AppError>> getById(String id) async {
  final data = await _datasource.find(id);
  if (data == null) {
    throw NotFoundException(id);  // Should return Failure(NotFound)
  }
  return Success(data);
}
```

#### Error Code Constants

**CORRECT:**
```dart
return Failure(DatabaseError._(
  code: DatabaseError.codeNotFound,  // Uses constant
  message: 'Supplement $id not found',
  userMessage: 'The supplement could not be found.',
));
```

**WRONG:**
```dart
return Failure(DatabaseError._(
  code: 'NOT_FOUND',  // REJECT: Hardcoded string
  message: 'Supplement $id not found',
  userMessage: 'The supplement could not be found.',
));
```

#### Use Case Authorization

**CORRECT:**
```dart
@override
Future<Result<List<Supplement>, AppError>> call(GetSupplementsInput input) async {
  // Authorization FIRST
  if (!await _authService.canRead(input.profileId)) {
    return Failure(AuthError.profileAccessDenied(input.profileId));
  }

  // Then business logic
  return _repository.getByProfile(input.profileId);
}
```

**WRONG:**
```dart
@override
Future<Result<List<Supplement>, AppError>> call(GetSupplementsInput input) async {
  // REJECT: No authorization check!
  return _repository.getByProfile(input.profileId);
}
```

#### ProfileId Filtering (MANDATORY)

Every data access method MUST filter by profileId and validate ownership.

**CORRECT - Repository:**
```dart
Future<Result<List<Supplement>, AppError>> getAllSupplements({
  required String profileId,  // REQUIRED parameter
}) async {
  try {
    final data = await _datasource.getAllSupplements(profileId: profileId);
    return Success(data);
  } catch (e, stack) {
    return Failure(DatabaseError.queryFailed(e.toString(), stack));
  }
}
```

**WRONG - Repository:**
```dart
// REJECT: profileId is optional
Future<Result<List<Supplement>, AppError>> getAllSupplements({
  String? profileId,  // Should be required!
}) async { ... }

// REJECT: No profileId parameter at all
Future<Result<List<Supplement>, AppError>> getAllSupplements() async { ... }
```

**CORRECT - Data Source SQL:**
```dart
Future<List<Supplement>> getAllSupplements({
  required String profileId,
  required String userId,  // Current authenticated user
}) async {
  final result = await db.rawQuery('''
    SELECT s.* FROM supplements s
    INNER JOIN profiles p ON s.profile_id = p.id
    WHERE s.profile_id = ?
      AND s.sync_deleted_at IS NULL      -- Filter soft deletes
      AND (p.owner_id = ?                 -- User owns profile
           OR EXISTS (                    -- OR has authorization
             SELECT 1 FROM hipaa_authorizations h
             WHERE h.profile_id = p.id
               AND h.granted_to_user_id = ?
               AND h.revoked_at IS NULL
           ))
    ORDER BY s.sync_created_at DESC
  ''', [profileId, userId, userId]);

  return result.map((map) => SupplementModel.fromMap(map).toEntity()).toList();
}
```

**WRONG - Data Source SQL:**
```dart
// REJECT: No profile ownership validation
Future<List<Supplement>> getAllSupplements({
  required String profileId,
}) async {
  final result = await db.query(
    'supplements',
    where: 'profile_id = ?',  // Missing ownership check!
    whereArgs: [profileId],
  );
  return result.map((map) => SupplementModel.fromMap(map).toEntity()).toList();
}
```

**Methods that MUST filter by profileId:**
- `getAll{Entity}s()`
- `search{Entity}s()`
- `get{Entity}sForDate()`
- `get{Entity}sInRange()`
- Any method returning `List<T>`

#### Specification Compliance

Every form and entity implementation MUST match the specification documents.

**UI Field Compliance (38_UI_FIELD_SPECIFICATIONS.md):**
```dart
// CORRECT: All fields from spec present with correct validation
class AddSupplementScreen extends ConsumerWidget {
  // Check these match spec:
  // - Field names and labels
  // - Required vs optional
  // - Validation rules and messages
  // - Default values
  // - Max lengths
  // - Semantic labels
}
```

**Entity Compliance (22_API_CONTRACTS.md):**
```dart
// CORRECT: Entity matches contract exactly
@freezed
class Supplement with _$Supplement {
  const factory Supplement({
    required String id,
    required String clientId,      // Must match contract
    required String profileId,
    required String name,          // Required in contract
    String? brand,                 // Optional in contract
    @Default([]) List<SupplementIngredient> ingredients,
    required SyncMetadata syncMetadata,
  }) = _Supplement;
}
```

**Review Checklist for Spec Compliance:**
- [ ] All required fields from spec are present in form
- [ ] Field labels exactly match spec (for localization consistency)
- [ ] Validation rules match spec (min length, max length, format)
- [ ] Default values match spec
- [ ] Error messages match spec validation messages
- [ ] Entity fields match 22_API_CONTRACTS.md exactly
- [ ] Semantic labels match 38_UI_FIELD_SPECIFICATIONS.md Section 16

---

### 2.2 Code Quality

#### Logging

**CORRECT:**
```dart
class SupplementProvider extends _$SupplementProvider {
  static final _log = logger.scope('SupplementProvider');

  Future<void> addSupplement(Supplement supplement) async {
    _log.info('Adding supplement: ${supplement.name}');
    // ...
    _log.error('Failed to add supplement', error, stackTrace);
  }
}
```

**WRONG:**
```dart
Future<void> addSupplement(Supplement supplement) async {
  print('Adding supplement: ${supplement.name}');  // REJECT: Use logger
  // ...
  print('Error: $error');  // REJECT: No structured logging
}
```

#### Localization

**CORRECT:**
```dart
Text(l10n.supplementName)  // Uses localization

// With interpolation
Text(l10n.itemCount(supplements.length))
```

**WRONG:**
```dart
Text('Supplement Name')  // REJECT: Hardcoded string
Text('${supplements.length} items')  // REJECT: Not localized
```

#### Colors

**CORRECT:**
```dart
Container(
  color: AppColors.supplements,  // Uses theme color
)
```

**WRONG:**
```dart
Container(
  color: Color(0xFF6B705C),  // REJECT: Hardcoded color
  // or
  color: Colors.green,  // REJECT: Not using AppColors
)
```

#### Magic Numbers

**CORRECT:**
```dart
if (temperature < ValidationRules.bbtMinFahrenheit ||
    temperature > ValidationRules.bbtMaxFahrenheit) {
  // ...
}
```

**WRONG:**
```dart
if (temperature < 95.0 || temperature > 105.0) {  // REJECT: Magic numbers
  // ...
}
```

---

### 2.3 Testing

#### Unit Test Structure

**CORRECT:**
```dart
group('LogFluidsEntryUseCase', () {
  group('when user is not authorized', () {
    test('returns AuthError.profileAccessDenied', () async {
      // Arrange
      when(authService.canWrite(any)).thenAnswer((_) async => false);

      // Act
      final result = await useCase(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      expect((result.errorOrNull as AuthError).code,
          equals(AuthError.codeProfileAccessDenied));
    });
  });

  group('when BBT is out of range', () {
    test('returns ValidationError with field error', () async {
      // Arrange
      when(authService.canWrite(any)).thenAnswer((_) async => true);
      final invalidInput = input.copyWith(basalBodyTemperature: 110.0);

      // Act
      final result = await useCase(invalidInput);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect((result.errorOrNull as ValidationError).fieldErrors,
          containsPair('basalBodyTemperature', isNotEmpty));
    });
  });
});
```

**WRONG:**
```dart
test('test1', () async {  // REJECT: Non-descriptive name
  final result = await useCase(input);
  expect(result.isSuccess, isTrue);  // REJECT: No arrange, minimal assert
});
```

#### Edge Cases Required

| Scenario | Must Test |
|----------|-----------|
| Empty input | Empty list returns `Success([])`, not null or error |
| Not found | Returns `Failure(DatabaseError.notFound)` |
| Unauthorized | Returns `Failure(AuthError.profileAccessDenied)` |
| Validation failure | Returns `Failure(ValidationError)` with field details |
| Database error | Returns `Failure(DatabaseError)` with context |

---

### 2.4 Accessibility

#### Semantic Labels

**CORRECT:**
```dart
ShadowButton(
  variant: ButtonVariant.icon,
  icon: Icons.delete,
  label: 'Delete ${supplement.name}',  // Specific, descriptive
  hint: 'Removes this supplement from your list',
  onPressed: () => delete(supplement),
)
```

**WRONG:**
```dart
IconButton(
  icon: Icon(Icons.delete),  // REJECT: No semantic label
  onPressed: () => delete(supplement),
)

ShadowButton(
  label: 'Delete',  // REJECT: Not specific enough for screen reader
  onPressed: () => delete(supplement),
)
```

#### Touch Targets

**CORRECT:**
```dart
GestureDetector(
  child: Container(
    width: 48,  // Minimum 48x48
    height: 48,
    child: Icon(Icons.close, size: 24),  // Icon can be smaller
  ),
  onTap: () => close(),
)
```

**WRONG:**
```dart
GestureDetector(
  child: Icon(Icons.close, size: 24),  // REJECT: Touch target only 24x24
  onTap: () => close(),
)
```

---

### 2.5 Performance

#### Database Queries

**CORRECT:**
```dart
// Single query with join
Future<Result<List<SupplementWithIntakes>, AppError>> getSupplementsWithIntakes(
  String profileId,
  DateTime date,
) async {
  final results = await db.customSelect('''
    SELECT s.*, i.* FROM supplements s
    LEFT JOIN intake_logs i ON s.id = i.supplement_id
    WHERE s.profile_id = ? AND i.logged_at >= ? AND i.logged_at < ?
  ''', variables: [profileId, date, date.add(Duration(days: 1))]).get();

  return Success(_mapToSupplementsWithIntakes(results));
}
```

**WRONG:**
```dart
// REJECT: N+1 queries
Future<Result<List<SupplementWithIntakes>, AppError>> getSupplementsWithIntakes(
  String profileId,
  DateTime date,
) async {
  final supplements = await _supplementRepo.getAllSupplements(profileId: profileId);

  for (final supplement in supplements.valueOrNull ?? []) {
    // REJECT: Query per supplement!
    final intakes = await _intakeRepo.getForSupplement(supplement.id, date);
    // ...
  }
}
```

#### Build Method

**CORRECT:**
```dart
class _MyWidgetState extends State<MyWidget> {
  late final List<Supplement> _sortedSupplements;

  @override
  void initState() {
    super.initState();
    _sortedSupplements = _sortSupplements(widget.supplements);  // Computed once
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _sortedSupplements.length,
      itemBuilder: (context, index) => SupplementTile(_sortedSupplements[index]),
    );
  }
}
```

**WRONG:**
```dart
@override
Widget build(BuildContext context) {
  // REJECT: Sorting on every rebuild!
  final sorted = widget.supplements.toList()..sort((a, b) => a.name.compareTo(b.name));

  return ListView.builder(
    itemCount: sorted.length,
    itemBuilder: (context, index) => SupplementTile(sorted[index]),
  );
}
```

---

### 2.6 Security

#### No PII in Logs

**CORRECT:**
```dart
_log.info('User logged in', {'userId': user.id.hashCode});  // Hashed ID
_log.info('Profile accessed', {'profileId': profileId});    // Non-PII identifier
```

**WRONG:**
```dart
_log.info('User logged in: ${user.email}');  // REJECT: PII in logs
_log.info('BBT recorded: ${entry.temperature}');  // REJECT: Health data in logs
```

#### Input Validation

**CORRECT:**
```dart
Future<Result<FluidsEntry, AppError>> call(LogFluidsEntryInput input) async {
  // Validate ALL inputs before any processing
  final validationError = _validate(input);
  if (validationError != null) {
    return Failure(validationError);
  }

  // Sanitize text inputs
  final sanitizedNotes = _sanitize(input.notes);

  // ...
}

String _sanitize(String? input) {
  if (input == null) return '';
  // Remove potential script injections, trim whitespace
  return input.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}
```

**WRONG:**
```dart
Future<Result<FluidsEntry, AppError>> call(LogFluidsEntryInput input) async {
  // REJECT: No validation, raw input used directly
  final entry = FluidsEntry(
    notes: input.notes,  // Could contain malicious content
    // ...
  );
  return _repository.create(entry);
}
```

---

## 3. Review Process

### 3.1 Review Steps

```
1. Check PR description
   └── Does it explain what and why?

2. Check linked ticket
   └── Does implementation match requirements?

3. Run tests locally
   └── flutter test

4. Check generated files
   └── Are freezed/drift files up to date?

5. Review code against checklist
   └── Go through each section

6. Test on device (if UI change)
   └── Verify accessibility, performance

7. Leave actionable feedback
   └── Specific, with examples

8. Approve only when ALL criteria met
```

### 3.2 Review Comments

**GOOD comment:**
```markdown
This repository method throws an exception instead of returning a Failure.

Per 22_API_CONTRACTS.md section 3.1, all repository methods must return
`Future<Result<T, AppError>>`.

Suggested fix:
```dart
} on DatabaseException catch (e, stack) {
  return Failure(DatabaseError.queryFailed(e.message, e, stack));
}
```
```

**BAD comment:**
```markdown
This is wrong.  // No explanation, not actionable
```

### 3.3 Blocking vs Non-blocking

| Blocking (Must Fix) | Non-blocking (Suggestion) |
|---------------------|---------------------------|
| API contract violation | Alternative implementation |
| Missing tests for new code | Additional test suggestions |
| Security issue | Performance optimization |
| Accessibility failure | Code style preference |
| Hardcoded strings/colors | Documentation improvement |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 25_DEFINITION_OF_DONE.md]

# Shadow Definition of Done

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Explicit criteria for when work items are complete

---

## Overview

Work is NOT complete until ALL applicable criteria in this document are met. No exceptions. Partial completion does not count as done.

---

## 1. Task Definition of Done

A **task** (single unit of work) is done when:

### 1.1 Code Complete
- [ ] Implementation matches acceptance criteria exactly
- [ ] Code follows API Contracts (22_API_CONTRACTS.md)
- [ ] All methods use Result type (no exceptions thrown for expected errors)
- [ ] ProfileId filtering implemented on all data queries (MANDATORY per 02_CODING_STANDARDS.md Section 4.3)
- [ ] SQL queries include `sync_deleted_at IS NULL` for soft delete filtering
- [ ] Code passes `flutter analyze` with zero warnings
- [ ] Code formatted with `dart format`
- [ ] Generated files updated (`build_runner build`)

### 1.2 Tests Complete
- [ ] Unit tests written for all new logic
- [ ] Contract tests written for interface changes
- [ ] Widget tests written for UI changes
- [ ] All tests pass locally
- [ ] Coverage meets minimum threshold (100% per 02_CODING_STANDARDS.md Section 10.3)

### 1.3 Documentation Complete
- [ ] Dartdoc added to public APIs
- [ ] Complex logic has inline comments
- [ ] Spec documents updated if behavior changed

### 1.4 Review Complete
- [ ] PR created with descriptive title and complete description
- [ ] Link to issue/ticket included in PR
- [ ] Screenshots attached for UI changes
- [ ] Test coverage report included
- [ ] All checklist items in PR template checked
- [ ] At least 2 approving reviews received
- [ ] All reviewer comments addressed (no unresolved comments)
- [ ] CI pipeline passes

---

## 2. User Story Definition of Done

A **user story** is done when:

### 2.1 All Tasks Complete
- [ ] Every task in the story meets Task DoD

### 2.2 Acceptance Criteria Met
- [ ] All acceptance criteria from 01_PRODUCT_SPECIFICATIONS.md verified
- [ ] Each criterion tested and documented
- [ ] Edge cases handled (empty state, error state, loading state)

### 2.3 Feature Flag Ready
- [ ] Feature behind appropriate feature flag (if new feature)
- [ ] Flag documented in 19_FEATURE_FLAGS.md
- [ ] Rollout plan defined

### 2.4 Accessibility Verified
- [ ] Screen reader tested (VoiceOver/TalkBack)
- [ ] Keyboard navigation works (desktop)
- [ ] Touch targets meet 48x48 minimum
- [ ] Color contrast meets WCAG AA

### 2.5 Performance Verified
- [ ] No regression in app launch time
- [ ] Feature responsive (<200ms for user actions)
- [ ] Memory usage within limits (<200MB total)

### 2.6 Localization Complete
- [ ] All user-facing strings in ARB files
- [ ] Tested in at least one RTL language (if applicable)
- [ ] Pluralization rules correct

---

## 3. Epic Definition of Done

An **epic** (collection of user stories) is done when:

### 3.1 All Stories Complete
- [ ] Every user story meets Story DoD

### 3.2 Integration Complete
- [ ] Integration tests pass for all flows
- [ ] No regressions in existing features
- [ ] Cross-feature interactions verified

### 3.3 Documentation Complete
- [ ] User flows documented (14_USER_FLOWS.md updated)
- [ ] Architecture documented (04_ARCHITECTURE.md updated)
- [ ] Release notes drafted

### 3.4 QA Sign-off
- [ ] Full QA test pass completed
- [ ] No P0 or P1 bugs outstanding
- [ ] P2 bugs documented with timeline

### 3.5 Stakeholder Review
- [ ] Demo completed for stakeholders
- [ ] Feedback addressed or documented

---

## 4. Release Definition of Done

A **release** is done when:

### 4.1 All Epics Complete
- [ ] Every epic meets Epic DoD

### 4.2 Quality Gates Passed
- [ ] All automated tests pass (100%)
- [ ] Code coverage meets threshold (100% per 02_CODING_STANDARDS.md Section 10.3)
- [ ] Security scan passed (no critical/high)
- [ ] Performance benchmarks met

### 4.3 Compliance Verified
- [ ] Privacy policy updated (if data collection changed)
- [ ] HIPAA checklist completed (17_PRIVACY_COMPLIANCE.md)
- [ ] App Store requirements met (privacy labels, descriptions)

### 4.4 Release Artifacts Ready
- [ ] Release notes finalized
- [ ] Version number incremented
- [ ] Build artifacts created (iOS, Android, macOS)
- [ ] TestFlight/Play Store beta uploaded
- [ ] Beta testing completed with sign-off

### 4.5 Rollout Plan Approved
- [ ] Feature flag rollout plan documented
- [ ] Monitoring dashboards configured
- [ ] Alerts configured for new features
- [ ] Rollback procedure documented and tested

### 4.6 Team Sign-offs
- [ ] Tech Lead approval
- [ ] QA Lead approval
- [ ] Product Owner approval
- [ ] Security review (if applicable)

---

## 5. Feature-Specific DoD

### 5.1 New Entity (e.g., FluidsEntry)

- [ ] Entity class created with @freezed annotation
- [ ] **All 4 required fields present:** id, clientId, profileId, syncMetadata (per 02_CODING_STANDARDS.md Section 5.1)
- [ ] Generated files committed (.freezed.dart, .g.dart)
- [ ] Repository interface defined (returns Result<T, AppError>)
- [ ] Repository implementation complete
- [ ] Local datasource implemented (includes sync_deleted_at IS NULL filtering)
- [ ] Database migration created with client_id column
- [ ] Contract tests pass
- [ ] Unit tests for entity logic (100% coverage)
- [ ] Registered in dependency injection

### 5.2 New Use Case

- [ ] Use case class created following pattern
- [ ] Input class defined with all required fields
- [ ] Authorization check implemented (first line)
- [ ] Validation implemented (after auth)
- [ ] All error paths return appropriate Failure
- [ ] Unit tests for all paths (100% coverage)
- [ ] Contract tests for return types

### 5.3 New Screen

- [ ] Screen widget created following template
- [ ] Uses consolidated widgets (ShadowButton, etc.)
- [ ] All strings localized
- [ ] All colors from AppColors
- [ ] Loading state implemented
- [ ] Error state implemented
- [ ] Empty state implemented
- [ ] Accessibility verified
- [ ] Widget tests written (100% coverage)
- [ ] Navigation registered in router

### 5.4 New Widget

- [ ] Added to consolidated widget (not separate class)
- [ ] Documented in 09_WIDGET_LIBRARY.md
- [ ] Semantic labels required
- [ ] Minimum touch target enforced
- [ ] Widget tests written

### 5.5 Database Schema Change

- [ ] Migration script created
- [ ] Migration tested (up and down)
- [ ] Schema documented in 10_DATABASE_SCHEMA.md
- [ ] ADR created for schema change
- [ ] Core Team approval received

---

## 6. DoD Verification Checklist

Before marking any work item as done, answer these questions:

```
□ Can I demo this feature to a stakeholder right now?
□ If someone else pulled this code, would it work perfectly?
□ Are there any "I'll fix it later" items?
□ Would I be comfortable on-call when this ships?
□ Is there anything I'm hoping reviewers won't notice?
```

If the answer to any question is "no" or uncertain, the work is **NOT done**.

---

## 7. What "Done" is NOT

### NOT Done:
- "It works on my machine" (must work in CI)
- "Tests are passing" (must also be reviewed)
- "Code is written" (must be tested)
- "PR is approved" (must be merged and deployed to staging)
- "Feature flag is on for me" (must be validated at each rollout stage)
- "I think it's accessible" (must be tested with assistive technology)

### Common Traps:
- "I'll add tests later" → Not done
- "Documentation can wait" → Not done
- "It's behind a flag so it's fine" → Still must meet quality standards
- "It's just a small change" → Same criteria apply

---

## 8. Enforcement

### 8.1 PR Merge Blocks

PRs cannot be merged without:
- All required reviewers approved
- All CI checks passing
- All checklist items verified

### 8.2 Sprint Completion Rules

Stories cannot be marked complete in sprint reviews without:
- All acceptance criteria demonstrated
- All DoD checklist items signed off

### 8.3 Release Gate

Releases cannot proceed without:
- Tech Lead sign-off that all release DoD criteria met
- QA sign-off on test completion
- Product Owner sign-off on feature completeness

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 26_TEAM_OPERATIONS.md]

# Shadow Team Operations

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Meeting cadence, communication protocols, and coordination mechanisms

> **CANONICAL SOURCE:** All implementation decisions must align with [02_CODING_STANDARDS.md](02_CODING_STANDARDS.md).
>
> **Key Patterns:**
> - Error Handling: All domain operations return `Result<T, AppError>` - never throw exceptions
> - Entities: Must have 4 required fields (id, clientId, profileId, syncMetadata)
> - Encryption: AES-256-GCM (not CBC)
> - Test Coverage: 100% required for all code

---

## 1. Organizational Structure

### 1.1 Team Hierarchy

```
Engineering Director
├── Tech Lead - Core Platform (3 engineers)
│   └── Core Team: Entities, repositories, use cases, database
│
├── Tech Lead - Features (48 engineers across 6 teams)
│   ├── Team Conditions (8 engineers)
│   ├── Team Supplements (8 engineers)
│   ├── Team Nutrition (8 engineers)
│   ├── Team Wellness (8 engineers)
│   ├── Team Sync (8 engineers)
│   └── Team Platform (8 engineers)
│
├── Tech Lead - UI/UX (4 engineers)
│   └── Design System, Widget Library, Accessibility
│
├── Tech Lead - Quality (4 engineers)
│   └── Test Infrastructure, CI/CD, Release Engineering
│
├── Engineering Manager - Operations (2 engineers)
│   └── On-call, Monitoring, Incident Response
│
└── Staff Engineers (3 - cross-cutting)
    └── Architecture, Performance, Security
```

### 1.2 Roles and Responsibilities

| Role | Count | Responsibilities |
|------|-------|------------------|
| Engineering Director | 1 | Strategy, hiring, cross-team coordination |
| Tech Lead | 4 | Technical direction, code quality, team growth |
| Staff Engineer | 3 | Architecture decisions, complex problems, mentoring |
| Engineering Manager | 1 | Operations, processes, people management |
| Senior Engineer | 30 | Feature ownership, code review, mentoring |
| Engineer | 40 | Feature implementation, testing |
| Associate Engineer | 20 | Learning, pair programming, small features |

### 1.3 Team Composition (Per Feature Team)

```
Feature Team (8 engineers)
├── Senior Engineer (Team Lead) - 1
├── Senior Engineers - 2
├── Engineers - 3
└── Associate Engineers - 2
```

---

## 2. Meeting Cadence

### 2.1 Daily Ceremonies

| Meeting | Time | Duration | Attendees | Purpose |
|---------|------|----------|-----------|---------|
| Team Standup | 9:00 AM | 15 min | Feature team | Blockers, daily plan |
| Cross-team Sync | 9:30 AM | 15 min | Team leads | Dependencies, escalations |

**Standup Format:**
```
1. What I completed yesterday
2. What I'm working on today
3. Blockers (if any)
4. Help needed (if any)
```

**Rules:**
- Start on time, end on time
- No problem-solving in standup (schedule follow-ups)
- Remote-first (video on, muted unless speaking)
- Async updates acceptable if timezone conflict

### 2.2 Weekly Ceremonies

| Meeting | Day | Duration | Attendees | Purpose |
|---------|-----|----------|-----------|---------|
| Sprint Planning | Monday | 2 hr | Feature team | Plan sprint work |
| Backlog Refinement | Wednesday | 1 hr | Team + PO | Clarify upcoming work |
| Architecture Review | Thursday | 1 hr | Leads + Staff | ADRs, design reviews |
| Demo & Retro | Friday | 1.5 hr | Feature team | Show work, improve process |

### 2.3 Bi-weekly Ceremonies

| Meeting | Duration | Attendees | Purpose |
|---------|----------|-----------|---------|
| All-Hands Engineering | 1 hr | All engineers | Announcements, demos, Q&A |
| Tech Lead Sync | 1 hr | Tech leads + Director | Cross-team planning |
| 1:1s | 30 min | Manager + Report | Career, feedback, blockers |

### 2.4 Monthly Ceremonies

| Meeting | Duration | Attendees | Purpose |
|---------|----------|-----------|---------|
| Architecture Deep Dive | 2 hr | All interested | Technical education |
| Blameless Postmortem Review | 1 hr | Leads + affected | Learn from incidents |
| Technical Debt Review | 1 hr | Leads + Staff | Prioritize debt paydown |
| Security Review | 1 hr | Security + Leads | Audit findings, updates |

### 2.5 Quarterly Ceremonies

| Meeting | Duration | Attendees | Purpose |
|---------|----------|-----------|---------|
| OKR Planning | Half day | Leads + Director | Set quarterly objectives |
| Team Health Survey | Async | All engineers | Anonymous feedback |
| Skills Assessment | 1 hr each | Manager + Engineer | Career development |

---

## 3. Communication Channels

### 3.1 Slack Channel Structure

```
#shadow-announcements      (read-only, company-wide)
#shadow-engineering        (all engineers, general discussion)
#shadow-engineering-leads  (tech leads + managers)
#shadow-architecture       (design discussions, ADRs)
#shadow-incidents          (active incidents only)
#shadow-releases           (release coordination)
#shadow-ci-cd              (build notifications)
#shadow-on-call            (on-call coordination)

#team-conditions           (team-specific)
#team-supplements
#team-nutrition
#team-wellness
#team-sync
#team-platform
#team-core
#team-ui
#team-quality

#help-flutter              (technical help)
#help-database
#help-testing
#help-accessibility
```

### 3.2 Communication Escalation

```
Level 1: Team Slack Channel
    │     Response: < 4 hours
    │
Level 2: Direct Message to Team Lead
    │     Response: < 2 hours
    │
Level 3: #shadow-engineering-leads
    │     Response: < 1 hour
    │
Level 4: Engineering Director DM
    │     Response: < 30 minutes
    │
Level 5: Phone/PagerDuty (incidents only)
          Response: < 15 minutes
```

### 3.3 Communication Norms

| Type | Channel | Response Time |
|------|---------|---------------|
| Question (non-urgent) | Team Slack | Within same day |
| Question (urgent) | DM + thread | Within 2 hours |
| Blocker | Standup mention + DM | Same day resolution |
| Incident | #shadow-incidents + PagerDuty | Immediate |
| FYI/Announcement | Team Slack | No response needed |
| Decision needed | Meeting or async doc | Within 48 hours |
| Code review | GitHub + Slack ping | Within 24 hours |

---

## 4. Decision-Making Framework

### 4.1 Decision Types

| Type | Examples | Who Decides | Process |
|------|----------|-------------|---------|
| **Team** | Implementation approach, test strategy | Team consensus | Discussion in standup/refinement |
| **Technical** | Library choice, pattern adoption | Tech Lead + Staff | ADR + Architecture Review |
| **Architectural** | New entity design, API contracts | Staff + Director | ADR + multiple reviews |
| **Process** | Sprint length, meeting changes | Eng Manager + leads | Proposal + retro discussion |
| **Strategic** | Roadmap, hiring, major rewrites | Director + stakeholders | OKR planning |

### 4.2 RAPID Decision Framework

For significant decisions, use RAPID:

| Role | Responsibility |
|------|----------------|
| **R**ecommend | Proposes solution, gathers input |
| **A**gree | Must agree (veto power) |
| **P**erform | Will implement the decision |
| **I**nput | Consulted for expertise |
| **D**ecide | Makes final call if no consensus |

**Example: Adding a New Database Table**

| Role | Person |
|------|--------|
| Recommend | Feature team engineer |
| Agree | Core Team lead (veto on schema) |
| Perform | Feature team |
| Input | DBA, Staff engineer |
| Decide | Core Team lead |

### 4.3 Disagreement Resolution

```
1. Discussion
   └── Engineers discuss in channel/meeting

2. Data
   └── Gather evidence, prototypes, benchmarks

3. Tech Lead Decision
   └── If consensus not reached, Tech Lead decides

4. Staff Engineer Escalation
   └── For cross-team or architectural disagreements

5. Director Final Call
   └── Rare - used only when significant impact
```

---

## 5. Dependency Management

### 5.1 Dependency Types

| Type | Example | Handling |
|------|---------|----------|
| **Intra-team** | Feature A needs Feature B | Handled in sprint planning |
| **Cross-team** | Team Wellness needs Core entity | Cross-team sync + tracking |
| **External** | Waiting on design/product | Escalate to Product Owner |
| **Technical** | Blocked by bug/infrastructure | Escalate to appropriate team |

### 5.2 Dependency Tracking

```yaml
# dependencies.yml - Updated weekly by Tech Leads

dependencies:
  - id: DEP-001
    blocker: "FluidsEntry entity definition"
    blocked_team: Team Wellness
    blocking_team: Core Team
    owner: "@core-lead"
    status: in_progress
    eta: 2026-02-05
    notes: "Schema finalized, implementation this sprint"

  - id: DEP-002
    blocker: "Notification deep linking"
    blocked_team: Team Wellness
    blocking_team: Team Platform
    owner: "@platform-lead"
    status: not_started
    eta: 2026-02-15
    notes: "Scheduled for Sprint 12"
```

### 5.3 Cross-team Dependency Protocol

```
1. Identify dependency during planning
         │
2. Create dependency ticket (DEP-XXX)
         │
3. Discuss in Cross-team Sync
         │
4. Blocking team adds to their backlog
         │
5. Track in dependencies.yml
         │
6. Weekly status in Cross-team Sync
         │
7. Escalate if at risk (48 hr before needed)
```

---

## 6. Risk Management

### 6.1 Risk Categories

| Category | Examples | Owner |
|----------|----------|-------|
| Technical | Performance, scalability, security | Staff Engineers |
| Schedule | Dependencies, complexity, availability | Tech Leads |
| Quality | Test coverage, bug rate, tech debt | Quality Team |
| People | Turnover, skill gaps, burnout | Eng Manager |
| External | Third-party APIs, App Store policies | Product + Eng |

### 6.2 Risk Register

```yaml
# risks.yml - Reviewed monthly

risks:
  - id: RISK-001
    category: technical
    description: "Drift database migration complexity"
    probability: medium
    impact: high
    mitigation: "Prototype migration with sample data first"
    owner: "@core-lead"
    status: monitoring

  - id: RISK-002
    category: schedule
    description: "Notification system depends on 3 teams"
    probability: high
    impact: medium
    mitigation: "Define interfaces first, parallelize work"
    owner: "@platform-lead"
    status: mitigating
```

### 6.3 Risk Response

| Risk Level | Response |
|------------|----------|
| Low (green) | Monitor, review monthly |
| Medium (yellow) | Active mitigation, review weekly |
| High (red) | Escalate to Director, daily tracking |
| Critical | All-hands focus until resolved |

---

## 7. Knowledge Management

### 7.1 Documentation Hierarchy

```
/docs
├── specifications/          # Product specs (01-25)
├── adr/                     # Architecture Decision Records
├── runbooks/                # Operational procedures
├── onboarding/              # New engineer materials
├── tutorials/               # How-to guides
└── rfcs/                    # Request for Comments (proposals)
```

### 7.2 Knowledge Sharing

| Activity | Frequency | Format |
|----------|-----------|--------|
| Tech Talks | Bi-weekly | 30 min presentation + Q&A |
| Brown Bags | Weekly | Informal lunch learning |
| Pair Programming | Daily | Encouraged for complex work |
| Code Review | Every PR | Async with discussion |
| Architecture Deep Dive | Monthly | 2 hr workshop |
| External Conference | Quarterly | Attendance + trip report |

### 7.3 Documentation Requirements

| Artifact | When Required | Owner |
|----------|---------------|-------|
| ADR | Any architectural decision | Proposing engineer |
| Runbook | Any new operational procedure | Implementing team |
| README | Every new module/package | Creating engineer |
| API docs | Every public interface | Implementing engineer |
| Tutorial | Every new developer workflow | Quality team |

---

## 8. Metrics & Reporting

### 8.1 Team Health Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Sprint Velocity | Stable ±20% | Points completed/sprint |
| Sprint Commitment | >85% | Completed/committed |
| Cycle Time | <5 days | Ticket start to done |
| PR Review Time | <24 hours | PR open to first review |
| PR Merge Time | <48 hours | PR open to merge |
| Bug Escape Rate | <5% | Bugs found post-release |
| Test Coverage | 100% | Overall code coverage (see 02_CODING_STANDARDS.md Section 10.3) |

### 8.2 Reporting Cadence

| Report | Frequency | Audience | Owner |
|--------|-----------|----------|-------|
| Sprint Report | Weekly | Team + stakeholders | Team Lead |
| Quality Report | Weekly | Engineering | Quality Lead |
| Velocity Trends | Bi-weekly | Leads | Eng Manager |
| OKR Progress | Monthly | All engineering | Director |
| Incident Report | Per incident | All engineering | On-call |

### 8.3 Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│                    Shadow Engineering Dashboard                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Sprint Progress                    Team Velocity               │
│  ████████████████░░░░ 78%          ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄    │
│  12 of 16 stories done              Avg: 45 pts | This: 48 pts │
│                                                                 │
│  PR Stats (This Week)               Build Health               │
│  ├── Open: 12                       ├── Main: ✅ Passing        │
│  ├── Avg Review Time: 18 hrs        ├── Develop: ✅ Passing     │
│  └── Avg Merge Time: 32 hrs         └── Coverage: 100%         │
│                                                                 │
│  Dependencies                       Risks                       │
│  ├── 🟢 On Track: 4                 ├── 🟢 Low: 3              │
│  ├── 🟡 At Risk: 1                  ├── 🟡 Medium: 2           │
│  └── 🔴 Blocked: 0                  └── 🔴 High: 0             │
│                                                                 │
│  On-Call Status: @alice (primary) @bob (secondary)             │
│  Active Incidents: 0                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 27_ONBOARDING_PROGRAM.md]

# Shadow Engineering Onboarding Program

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Structured onboarding for new engineers to reach full productivity

---

## Overview

New engineers complete a 4-week structured onboarding program. The goal is independent contribution by Week 5.

---

## 1. Onboarding Timeline

### Week 1: Foundation

| Day | Focus | Activities | Deliverable |
|-----|-------|------------|-------------|
| **Day 1** | Welcome | Orientation, equipment setup, access provisioning | All accounts active |
| **Day 2** | Environment | Dev environment setup, clone repos, first build | Successful local build |
| **Day 3** | Codebase | Architecture walkthrough, codebase tour | Architecture quiz (pass) |
| **Day 4** | Process | Git workflow, PR process, CI/CD overview | Practice PR submitted |
| **Day 5** | Team | Meet team, attend ceremonies, shadow pairing | Week 1 retrospective |

### Week 2: Deep Dive

| Day | Focus | Activities | Deliverable |
|-----|-------|------------|-------------|
| **Day 6** | Specs 1-5 | Read Product Specs, Architecture, Roadmap | Spec quiz 1 (pass) |
| **Day 7** | Specs 6-13 | Read Testing, Naming, Widget Library, DB Schema | Spec quiz 2 (pass) |
| **Day 8** | Specs 14-21 | Read User Flows, Error Handling, Privacy, Monitoring | Spec quiz 3 (pass) |
| **Day 9** | Specs 22-27 | Read API Contracts, Governance, Review Checklist, DoD | Spec quiz 4 (pass) |
| **Day 10** | Integration | Connect specs to codebase, trace a feature end-to-end | Feature trace document |

### Week 3: Contribution

| Day | Focus | Activities | Deliverable |
|-----|-------|------------|-------------|
| **Day 11** | First Issue | Pick "good first issue", pair with mentor | Issue assigned |
| **Day 12** | Implementation | Write code with mentor guidance | Code written |
| **Day 13** | Testing | Write tests, verify coverage | Tests passing |
| **Day 14** | Review | Submit PR, respond to feedback | PR submitted |
| **Day 15** | Merge | Address reviews, merge first PR | First PR merged ✅ |

### Week 4: Independence

| Day | Focus | Activities | Deliverable |
|-----|-------|------------|-------------|
| **Day 16** | Second Issue | Pick slightly harder issue, less mentor help | Issue assigned |
| **Day 17-18** | Solo Work | Implement independently, ask questions as needed | Implementation complete |
| **Day 19** | Review | Submit PR, lead review response | PR submitted |
| **Day 20** | Graduation | Merge PR, onboarding retrospective, team celebration | Onboarding complete ✅ |

---

## 2. Onboarding Checklist

### 2.1 Before Day 1 (Manager)

- [ ] Equipment ordered and configured
- [ ] Accounts created: GitHub, Slack, Jira, Google Workspace
- [ ] Mentor assigned
- [ ] Calendar invites sent for first week
- [ ] Onboarding buddy assigned
- [ ] Welcome Slack message drafted
- [ ] "Good first issues" identified (3-5)

### 2.2 Day 1 Checklist (New Engineer)

- [ ] Complete HR onboarding
- [ ] Receive equipment
- [ ] Access email and calendar
- [ ] Join Slack channels
- [ ] Access GitHub organization
- [ ] Meet manager (30 min)
- [ ] Meet mentor (30 min)
- [ ] Meet onboarding buddy (lunch)
- [ ] Read company handbook

### 2.3 Week 1 Checklist

- [ ] Clone all repositories
- [ ] Complete local development setup
- [ ] Successful build on all platforms (iOS, Android, macOS)
- [ ] Run test suite successfully
- [ ] Complete architecture quiz (100% required)
- [ ] Attend team standup (3+ times)
- [ ] Attend sprint ceremony (planning or retro)
- [ ] Submit practice PR (documentation fix or typo)
- [ ] 1:1 with mentor (30 min)
- [ ] 1:1 with manager (30 min)

### 2.4 Week 2 Checklist

- [ ] Read all specification documents (01-27)
- [ ] Pass all spec quizzes (100% required)
- [ ] Complete feature trace exercise
- [ ] Shadow a code review
- [ ] Attend architecture review
- [ ] 1:1 with mentor
- [ ] Meet 3 engineers from other teams

### 2.5 Week 3-4 Checklist

- [ ] Complete first real PR (merged)
- [ ] Complete second PR (merged)
- [ ] Lead a code review (with mentor oversight)
- [ ] Present feature trace at team meeting
- [ ] Complete onboarding retrospective
- [ ] Schedule ongoing 1:1 cadence with manager
- [ ] Added to on-call rotation (shadow only for first month)

---

## 3. Specification Quizzes

### 3.1 Quiz Format

- 20 questions per quiz
- Multiple choice and short answer
- 100% required to pass
- Unlimited retakes with 24-hour wait
- Questions from specification documents

### 3.2 Sample Questions

**Architecture Quiz:**
```
Q: What layer contains Use Cases in Clean Architecture?
A: Domain Layer

Q: What must every repository method return?
A: Future<Result<T, AppError>>

Q: What is the first thing a Use Case must check?
A: Authorization (canRead/canWrite)
```

**API Contracts Quiz:**
```
Q: What error code is used when an entity is not found?
A: DatabaseError.codeNotFound (or 'DB_NOT_FOUND')

Q: What pattern must all entities use for immutability?
A: Freezed (@freezed annotation)

Q: List the 5 error categories in the error handling system.
A: DatabaseError, AuthError, NetworkError, ValidationError, SyncError
```

**Process Quiz:**
```
Q: What is the minimum number of approving reviews for a PR to merge?
A: 2

Q: What file must be updated when changing a repository interface?
A: 22_API_CONTRACTS.md (requires ADR)

Q: What command must be run before committing changes to entities?
A: dart run build_runner build --delete-conflicting-outputs
```

**Coding Standards Quiz (02_CODING_STANDARDS.md):**
```
Q: What are the 4 required fields for all health data entities?
A: id, clientId, profileId, syncMetadata

Q: What pattern must all domain operations use for error handling?
A: Result<T, AppError> - never throw exceptions for expected errors

Q: What 3 properties must every AppError subclass implement for recovery?
A: isRecoverable, recoveryAction, originalError

Q: What must every data source query include for soft delete filtering?
A: sync_deleted_at IS NULL

Q: What must SQL queries include to validate profile ownership?
A: JOIN profiles WHERE owner_id = ? (current user's ID)

Q: What encryption algorithm is required for sensitive data?
A: AES-256-GCM (NOT CBC)

Q: What test coverage percentage is required for all layers?
A: 100%

Q: Name 4 masking functions required for PII protection.
A: maskUserId, maskProfileId, maskDeviceId, maskIpAddress, maskEmail, maskPhone, maskToken (any 4)

Q: What columns must every syncable table have?
A: id, client_id, profile_id, sync_created_at, sync_updated_at, sync_deleted_at,
   sync_last_synced_at, sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data

Q: What 8 values does the RecoveryAction enum have?
A: none, retry, refreshToken, reAuthenticate, goToSettings, contactSupport, checkConnection, freeStorage
```

---

## 4. Mentor Program

### 4.1 Mentor Responsibilities

| Responsibility | Time Investment |
|----------------|-----------------|
| Daily check-in (Week 1-2) | 15 min/day |
| Weekly check-in (Week 3-4) | 30 min/week |
| Pair programming sessions | 2-3 hrs/week |
| Code review guidance | 1 hr/week |
| Answer questions | As needed |
| Onboarding feedback to manager | Weekly |

### 4.2 Mentor Qualifications

- Senior Engineer or above
- 6+ months on Shadow project
- Completed mentor training
- Capacity for mentorship (not overloaded)
- Track record of helpful code reviews

### 4.3 Mentor Training Topics

- Effective pair programming
- Giving constructive feedback
- Recognizing when to help vs. let struggle
- Escalating concerns early
- Cultural onboarding

---

## 5. Good First Issues

### 5.1 Criteria

Good first issues should be:
- Isolated (minimal dependencies)
- Well-defined (clear acceptance criteria)
- Low risk (not critical path)
- Educational (teaches something)
- Completable in 1-2 days

### 5.2 Examples

| Issue Type | Example | Learning |
|------------|---------|----------|
| Bug fix | "BBT input doesn't clear on save" | Widget lifecycle |
| Enhancement | "Add loading state to supplement list" | State management |
| Test | "Add unit tests for FluidsEntry validation" | Testing patterns |
| Documentation | "Update API docs for notification repository" | Documentation |
| Refactor | "Extract common dialog to shared widget" | Widget patterns |

### 5.3 Tagging

Issues are tagged in Jira:
- `good-first-issue` - Suitable for Week 3
- `good-second-issue` - Suitable for Week 4
- `needs-mentor` - Requires pairing

---

## 6. Environment Setup

### 6.1 Required Tools

```bash
# Install Flutter
brew install flutter

# Install additional tools
brew install cocoapods
brew install --cask android-studio

# Clone repositories
git clone git@github.com:shadow-health/shadow-app.git
git clone git@github.com:shadow-health/shadow-specs.git

# Setup Flutter
flutter doctor
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Verify build
flutter build ios --debug
flutter build android --debug
flutter build macos --debug

# Run tests
flutter test
```

### 6.2 IDE Setup

**VS Code Extensions:**
- Dart
- Flutter
- Error Lens
- GitLens
- Bracket Pair Colorizer
- Better Comments

**Settings:**
```json
{
  "editor.formatOnSave": true,
  "editor.rulers": [80, 120],
  "dart.lineLength": 120,
  "dart.previewFlutterUiGuides": true
}
```

### 6.3 Git Configuration

```bash
# Configure git
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"

# Install pre-commit hooks
./scripts/install-hooks.sh

# Configure commit signing (optional but recommended)
git config --global commit.gpgsign true
```

---

## 7. 30-60-90 Day Goals

### 7.1 Day 30 (End of Onboarding)

- [ ] All onboarding checklists complete
- [ ] 2+ PRs merged
- [ ] All quizzes passed
- [ ] Comfortable with daily workflow
- [ ] Knows who to ask for help
- [ ] Attending all team ceremonies

### 7.2 Day 60

- [ ] 5+ PRs merged
- [ ] Completed a small feature independently
- [ ] Given helpful code reviews to others
- [ ] Presented at team meeting
- [ ] Identified improvement opportunity
- [ ] Shadow on-call rotation completed

### 7.3 Day 90

- [ ] 10+ PRs merged
- [ ] Owned a medium feature end-to-end
- [ ] Mentored another new engineer (informal)
- [ ] Contributed to team process improvement
- [ ] On-call rotation (with backup)
- [ ] Performance expectations met

---

## 8. Onboarding Feedback

### 8.1 Feedback Collection

| When | Type | Purpose |
|------|------|---------|
| Day 5 | Quick survey | Early issues |
| Day 20 | Retrospective | Improve program |
| Day 60 | Manager 1:1 | Progress check |
| Day 90 | Full review | Confirm success |

### 8.2 Retrospective Questions

1. What was most helpful in your onboarding?
2. What was most confusing or frustrating?
3. What information did you wish you had earlier?
4. How was your mentor experience?
5. What would you change for future new engineers?

### 8.3 Program Improvement

Onboarding feedback is reviewed monthly by:
- Engineering Manager
- Mentor representatives
- Recent new hires

Changes are made to:
- Checklist items
- Quiz questions
- Good first issues
- Documentation gaps
- Timeline adjustments

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 28_ENGINEERING_PRINCIPLES.md]

# Shadow Engineering Principles

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Core values and principles that guide engineering decisions and culture

---

## Overview

These principles define how we work, make decisions, and treat each other. They are non-negotiable. Every engineer is expected to embody these principles.

---

## 1. Core Principles

### 1.1 Quality is Non-Negotiable

> "Move fast with stable infrastructure."

- We don't ship broken code
- We don't skip tests to meet deadlines
- We don't accumulate tech debt without a plan
- We fix bugs before building features
- We maintain 100% code coverage (see 02_CODING_STANDARDS.md Section 10.3)

**In Practice:**
- Definition of Done is enforced, not optional
- PRs without tests are rejected
- Quality Team has veto power on releases
- Tech debt is tracked and paid down quarterly

### 1.2 Users Trust Us with Their Health

> "We handle health data like it's our own family's."

- Privacy is a feature, not a constraint
- Security is everyone's responsibility
- We encrypt everything, everywhere
- We collect only what we need
- We never sell or share user data

**In Practice:**
- HIPAA compliance is mandatory
- Security review for all data-touching changes
- PII never appears in logs
- Privacy impact assessment for new features

### 1.3 Accessibility is Not Optional

> "If it's not accessible, it's not done."

- Every user deserves full functionality
- Screen readers work perfectly
- Keyboard navigation works everywhere
- Color is never the only indicator
- Touch targets are never too small

**In Practice:**
- Accessibility testing in Definition of Done
- Quarterly VoiceOver/TalkBack audits
- Accessibility champions on each team
- No exceptions for "we'll fix it later"

### 1.4 Ownership, Not Territory

> "Own the outcome, not just the code."

- You own it until it works in production
- You're responsible for monitoring and alerts
- You fix the bugs you introduce
- You help others with "your" code
- Code ownership is about accountability, not control

**In Practice:**
- On-call for your features
- No "that's not my code" responses
- Help is always given, never gatekept
- Knowledge sharing is expected

### 1.5 Explicit Over Implicit

> "If it's not documented, it doesn't exist."

- Write it down, don't assume
- Decisions need ADRs
- Interfaces need contracts
- Processes need documentation
- Meetings need agendas and notes

**In Practice:**
- API Contracts for all interfaces
- README in every module
- Meeting notes within 24 hours
- Decision log maintained

---

## 2. Technical Principles

### 2.1 Design for Failure

> "Assume everything will fail, then make it not matter."

- Networks are unreliable
- Servers go down
- Databases corrupt
- Users lose connectivity
- Plan for graceful degradation

**Applied:**
```dart
// GOOD: Handles failure explicitly
final result = await repository.getSupplements(profileId);
return result.when(
  success: (supplements) => SupplementList(supplements),
  failure: (error) => ErrorState(error.userMessage),
);

// BAD: Assumes success
final supplements = await repository.getSupplements(profileId);
return SupplementList(supplements); // What if it fails?
```

### 2.2 Make It Obvious

> "Code should be boring to read."

- No clever tricks
- No hidden side effects
- No magic strings or numbers
- Method names tell you what they do
- Variable names tell you what they are

**Applied:**
```dart
// GOOD: Obvious
Future<Result<FluidsEntry, AppError>> logFluidsEntry(LogFluidsEntryInput input)

// BAD: Clever but confusing
Future<dynamic> log(Map<String, dynamic> data)
```

### 2.3 Fail Fast

> "Find problems in development, not production."

- Compile-time errors over runtime errors
- Strong types over dynamic types
- Validation at the boundary
- Assertions in development
- Crash early, crash loudly (in dev)

**Applied:**
```dart
// GOOD: Fails at compile time if missing field
@freezed
class Supplement with _$Supplement {
  const factory Supplement({
    required String id,        // Compile error if omitted
    required String clientId,  // Required for database merging
    required String profileId, // Profile scope
    required String name,
    required SyncMetadata syncMetadata,
  }) = _Supplement;
}

// BAD: Fails at runtime
class Supplement {
  final Map<String, dynamic> data;  // Anything could be missing
}
```

### 2.4 One Way to Do Things

> "Consistency beats perfection."

- Follow established patterns
- Don't invent new approaches
- If you must deviate, ADR first
- Code should look like one person wrote it
- New team members should predict the code

**Applied:**
- All entities use Freezed
- All repositories return Result
- All use cases check authorization first
- All widgets use consolidated library

### 2.5 Test the Contract, Not the Implementation

> "Tests should survive refactoring."

- Test behavior, not internals
- Test public interfaces
- Mock at boundaries, not everywhere
- Tests are documentation
- If a test breaks during refactor, it was a bad test

**Applied:**
```dart
// GOOD: Tests behavior
test('returns error when BBT is out of range', () async {
  final result = await useCase(LogFluidsEntryInput(bbt: 110.0));
  expect(result.isFailure, isTrue);
  expect(result.errorOrNull, isA<ValidationError>());
});

// BAD: Tests implementation
test('calls _validateBBT with temperature', () {
  // Testing private method - will break on refactor
});
```

---

## 3. Collaboration Principles

### 3.1 Assume Positive Intent

> "They're not trying to make your life harder."

- Questions are for learning, not attacking
- Feedback is for improvement, not criticism
- Different approaches aren't wrong, just different
- Give the benefit of the doubt
- Ask before assuming

**In Practice:**
- "Help me understand..." not "Why did you..."
- "What if we tried..." not "You should have..."
- Slack messages aren't attacks
- Code review comments aren't personal

### 3.2 Strong Opinions, Loosely Held

> "Have conviction, but be open to new information."

- Form a position, defend it
- But change when convinced
- Disagree, then commit
- Don't fight battles twice
- The goal is the best solution, not being right

**In Practice:**
- Debate in reviews, not after merge
- Once decided, execute together
- Track disagreement in ADRs, not Slack
- Revisit decisions with new data, not old arguments

### 3.3 Teach, Don't Tell

> "Give them fishing skills, not fish."

- Explain the why, not just the what
- Point to documentation, then explain
- Ask leading questions
- Let people figure things out (with guardrails)
- Celebrate learning moments

**In Practice:**
- Code review: explain why, link to docs
- Pairing: let them type
- Questions: guide to answer, don't give it
- Mistakes: learning opportunities

### 3.4 Transparent by Default

> "Information should flow freely unless there's a reason."

- Share context proactively
- Document decisions publicly
- Surface problems early
- Celebrate wins visibly
- Bad news travels fast

**In Practice:**
- Public Slack channels over DMs
- Shared documents over private notes
- Status updates in standup
- Blockers announced immediately

### 3.5 Blameless Problem Solving

> "Fix the system, not the person."

- Incidents are system failures
- Everyone makes mistakes
- Shame is not a motivator
- Ask "what failed" not "who failed"
- Learn and improve

**In Practice:**
- Blameless postmortems
- Focus on timeline and facts
- Action items are process changes
- No naming in incident reports

---

## 4. Decision Principles

### 4.1 Reversible vs. Irreversible

> "Move fast on reversible decisions, slow on irreversible ones."

| Reversible (Fast) | Irreversible (Slow) |
|-------------------|---------------------|
| Variable naming | Database schema |
| UI layout | API contracts |
| Test approach | Architecture patterns |
| Documentation style | Security mechanisms |

### 4.2 Data Over Opinions

> "In God we trust, all others bring data."

- Opinions start discussions
- Data ends discussions
- Benchmark before optimizing
- Measure before claiming
- Experiment before committing

### 4.3 Bias for Action

> "A good plan today is better than a perfect plan tomorrow."

- Start with 80% solution
- Iterate based on feedback
- Ship to learn
- Prototype to decide
- Perfect is the enemy of done

**Except for:**
- Security (never rush)
- Privacy (never compromise)
- Data integrity (never risk)

---

## 5. Growth Principles

### 5.1 Always Be Learning

> "The day you stop learning is the day you start declining."

- Read code you didn't write
- Try approaches you wouldn't choose
- Learn from incidents (yours and others')
- Attend tech talks
- Teach to learn

### 5.2 Feedback is a Gift

> "Feedback is how we get better. Seek it out."

- Ask for feedback explicitly
- Receive feedback gracefully
- Give feedback kindly
- Act on feedback visibly
- Thank people for feedback

### 5.3 Lift Others Up

> "Your success is measured by the success of those around you."

- Senior engineers create senior engineers
- Share knowledge freely
- Celebrate others' wins
- Take time to mentor
- No knowledge hoarding

---

## 6. Principle Violations

### 6.1 How to Handle

When you see a principle violation:

1. **Assume positive intent** - They may not know
2. **Address privately first** - DM or 1:1
3. **Reference the principle** - Be specific
4. **Offer to help** - Not just criticize
5. **Escalate if pattern** - Manager for repeated issues

### 6.2 Examples

| Violation | Response |
|-----------|----------|
| PR without tests | "Hey, I noticed tests are missing. DoD requires them. Need help writing them?" |
| Accessibility skipped | "This needs semantic labels per our accessibility principle. I can pair on this if helpful." |
| Blame in postmortem | "Let's focus on the system failure, not the individual. What process allowed this?" |
| Knowledge hoarding | "This seems like valuable info. Can you document it for the team?" |

---

## 7. Principle Poster

Print this for team spaces:

```
┌─────────────────────────────────────────────────────────────────┐
│                   SHADOW ENGINEERING PRINCIPLES                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ⚙️  Quality is Non-Negotiable                                  │
│      We don't ship broken code.                                 │
│                                                                 │
│  🔒 Users Trust Us with Their Health                           │
│      Privacy and security in everything.                        │
│                                                                 │
│  ♿ Accessibility is Not Optional                               │
│      If it's not accessible, it's not done.                     │
│                                                                 │
│  🎯 Ownership, Not Territory                                    │
│      Own the outcome, help others.                              │
│                                                                 │
│  📝 Explicit Over Implicit                                      │
│      Write it down.                                             │
│                                                                 │
│  🤝 Assume Positive Intent                                      │
│      Give the benefit of the doubt.                             │
│                                                                 │
│  🔄 Blameless Problem Solving                                   │
│      Fix the system, not the person.                            │
│                                                                 │
│  🚀 Bias for Action                                             │
│      Start with 80%, iterate.                                   │
│                                                                 │
│  📈 Lift Others Up                                              │
│      Your success = their success.                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 29_INCIDENT_MANAGEMENT.md]

# Shadow Incident Management

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Incident response, on-call rotation, and postmortem processes

---

## 1. Incident Severity Levels

### 1.1 Severity Definitions

| Severity | Definition | Examples | Response Time |
|----------|------------|----------|---------------|
| **SEV-1** | Complete outage or data loss | App crashes on launch, data corruption, PHI breach | Immediate |
| **SEV-2** | Major feature broken, degraded for all | Sync completely broken, can't log entries | 15 minutes |
| **SEV-3** | Feature broken for some users | Notifications not firing for subset | 1 hour |
| **SEV-4** | Minor issue, workaround exists | UI glitch, slow performance | 4 hours |

### 1.2 Severity Decision Tree

```
Is user health data at risk?
├── Yes → SEV-1
└── No → Can users use the core app?
         ├── No → SEV-1
         └── Yes → Is a major feature completely broken?
                  ├── Yes → SEV-2
                  └── No → Are many users affected?
                           ├── Yes → SEV-3
                           └── No → SEV-4
```

---

## 2. On-Call Rotation

### 2.1 Rotation Structure

```
Week 1: Team A Primary, Team B Secondary
Week 2: Team B Primary, Team C Secondary
Week 3: Team C Primary, Team D Secondary
... (rotating through all 6 feature teams)
```

**Rotation:**
- Primary: First responder, owns incident
- Secondary: Backup if primary unavailable
- Tertiary: Staff Engineer for escalation

### 2.2 On-Call Responsibilities

| Responsibility | Details |
|----------------|---------|
| **Monitor** | Check dashboards 3x during shift |
| **Respond** | Acknowledge alerts within SLA |
| **Communicate** | Update #shadow-incidents |
| **Resolve** | Drive to resolution or escalate |
| **Document** | Log actions in incident ticket |
| **Handoff** | Brief next on-call at shift end |

### 2.3 On-Call Schedule

| Period | Coverage | Expectation |
|--------|----------|-------------|
| Business hours (9-6) | Primary + team | Immediate response |
| After hours (6-10pm) | Primary | 30 min response |
| Night (10pm-9am) | Primary (pager) | SEV-1/2 only |
| Weekend | Primary (reduced) | SEV-1/2 only |

### 2.4 On-Call Compensation

| Tier | Compensation |
|------|--------------|
| On-call week | Flat stipend + comp time |
| Page answered | Per-page bonus |
| Incident worked | Hourly rate (after-hours) |
| Weekend incident | 2x hourly rate |

---

## 3. Incident Response

### 3.1 Response Workflow

```
Alert Triggered
      │
      ▼
Acknowledge (within SLA)
      │
      ▼
Assess Severity
      │
      ▼
┌─────┴─────┐
│           │
▼           ▼
SEV-1/2     SEV-3/4
    │           │
    ▼           ▼
Page secondary   Work during hours
Declare incident Track in ticket
Create war room  Update status
      │
      ▼
Investigate
      │
      ▼
Mitigate (stop bleeding)
      │
      ▼
Resolve (fix root cause)
      │
      ▼
Verify (confirm fixed)
      │
      ▼
Close Incident
      │
      ▼
Schedule Postmortem (SEV-1/2)
```

### 3.2 SEV-1/2 Response Protocol

**0-5 minutes:**
- Acknowledge page
- Join #shadow-incidents
- Post initial assessment

**5-15 minutes:**
- Declare incident formally
- Create incident ticket
- Page secondary if needed
- Start incident timeline

**15-30 minutes:**
- Identify scope
- Start mitigation
- Post update to stakeholders
- Consider feature flag rollback

**Every 30 minutes during incident:**
- Post status update
- Update ETA
- Evaluate escalation

### 3.3 Communication Template

```
🚨 INCIDENT DECLARED

Severity: SEV-2
Summary: Cloud sync failing for all users
Impact: Users cannot sync data across devices
Started: 2026-01-30 14:32 UTC
Status: Investigating

Current Actions:
- Checking Google Drive API status
- Reviewing error logs

Next Update: 15:00 UTC

Incident Commander: @alice
```

---

## 4. Incident Roles

### 4.1 Role Definitions

| Role | Responsibility | Who |
|------|----------------|-----|
| **Incident Commander (IC)** | Owns resolution, coordinates response | On-call primary |
| **Technical Lead** | Drives technical investigation | Senior engineer |
| **Scribe** | Documents timeline, actions | Volunteer or IC |
| **Communications** | Stakeholder updates | Eng Manager |

### 4.2 Incident Commander Duties

- Declare/close incident
- Assign roles
- Make decisions (or escalate)
- Ensure communication
- Call for help when needed
- Keep timeline updated
- Own postmortem scheduling

### 4.3 Escalation Path

```
On-Call Primary
      │ (15 min no progress)
      ▼
On-Call Secondary
      │ (15 min no progress)
      ▼
Staff Engineer
      │ (SEV-1 or no progress)
      ▼
Tech Lead
      │ (business impact)
      ▼
Engineering Director
      │ (company impact)
      ▼
Executive (CEO/CTO)
```

---

## 5. Postmortem Process

### 5.1 When Required

| Severity | Postmortem Required | Timeline |
|----------|---------------------|----------|
| SEV-1 | Always | Within 48 hours |
| SEV-2 | Always | Within 1 week |
| SEV-3 | If systemic | Within 2 weeks |
| SEV-4 | Optional | If valuable |

### 5.2 Postmortem Template

```markdown
# Postmortem: [Incident Title]

**Date:** 2026-01-30
**Severity:** SEV-2
**Duration:** 2 hours 15 minutes
**Author:** @incident-commander
**Reviewers:** @tech-lead, @staff-engineer

## Summary
Brief description of what happened and impact.

## Timeline
All times in UTC.

| Time | Event |
|------|-------|
| 14:32 | Alert triggered: Sync error rate > 5% |
| 14:35 | IC acknowledged, began investigation |
| 14:42 | Identified Google Drive API rate limiting |
| 14:55 | Implemented exponential backoff |
| 15:15 | Deployed fix to production |
| 15:45 | Error rate normalized |
| 16:47 | Incident closed |

## Root Cause
Our sync implementation was not rate-limited, causing us to exceed
Google Drive API quotas during peak usage.

## Impact
- Users affected: ~500
- Duration: 2 hours 15 minutes
- Data loss: None
- Revenue impact: None

## What Went Well
- Alert triggered quickly
- Team assembled within 10 minutes
- Fix deployed within 45 minutes of identification

## What Went Poorly
- No rate limiting in original implementation
- Took 20 minutes to identify root cause
- No runbook for Google Drive errors

## Action Items

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| Implement exponential backoff | @alice | Done | ✅ |
| Add rate limit monitoring | @bob | 2026-02-05 | 🔄 |
| Create Google Drive runbook | @charlie | 2026-02-10 | ⏳ |
| Add API quota alerts | @alice | 2026-02-07 | ⏳ |
| Load test sync with realistic traffic | @qa-lead | 2026-02-15 | ⏳ |

## Lessons Learned
1. Always implement rate limiting for external APIs
2. Load testing should include third-party API limits
3. Need better visibility into external dependency health
```

### 5.3 Postmortem Meeting

**Attendees:** IC, Tech Lead, affected team, optional observers
**Duration:** 1 hour max
**Agenda:**
1. Timeline review (15 min)
2. Root cause discussion (15 min)
3. Action item review (15 min)
4. Lessons learned (15 min)

**Rules:**
- Blameless (focus on systems, not people)
- Constructive (solutions, not complaints)
- Action-oriented (every finding needs an owner)
- Time-boxed (respect schedules)

---

## 6. Runbooks

### 6.1 Runbook Template

```markdown
# Runbook: [Issue Type]

**Last Updated:** 2026-01-30
**Owner:** @team-name

## Symptoms
- What alerts fire?
- What does the user see?
- What metrics indicate this issue?

## Likely Causes
1. Cause A (most common)
2. Cause B
3. Cause C

## Diagnosis Steps
1. Check X dashboard
2. Run Y query
3. Look for Z in logs

## Resolution Steps

### For Cause A
1. Step 1
2. Step 2
3. Step 3

### For Cause B
1. Step 1
2. Step 2

## Escalation
If not resolved in 30 minutes, escalate to @team-lead.

## Prevention
How to prevent this from recurring.

## Related
- Link to relevant docs
- Link to related runbooks
```

### 6.2 Required Runbooks

| Runbook | Owner |
|---------|-------|
| App Crash Investigation | Core Team |
| Sync Failures | Team Sync |
| Auth/OAuth Errors | Team Platform |
| Database Issues | Core Team |
| Notification Failures | Team Platform |
| Performance Degradation | Core Team |
| Feature Flag Emergency | All Leads |

---

## 7. Metrics & SLOs

### 7.1 Service Level Objectives

| Metric | SLO | Measurement |
|--------|-----|-------------|
| Availability | 99.9% | App launches successfully |
| Sync Success Rate | 99.5% | Syncs complete without error |
| Notification Delivery | 98% | Notifications delivered on time |
| P95 Response Time | <2s | Key user actions |
| Error Rate | <0.1% | Unhandled exceptions |

### 7.2 Error Budget

Monthly error budget = 100% - SLO

| SLO | Monthly Budget |
|-----|----------------|
| 99.9% | 43 minutes downtime |
| 99.5% | 3.6 hours issues |
| 98% | 14.4 hours issues |

When error budget exhausted:
- Freeze non-critical deployments
- Focus on reliability work
- Postmortem all incidents that month

### 7.3 Alerting

| Alert | Threshold | Severity |
|-------|-----------|----------|
| Error rate spike | >1% for 5 min | SEV-2 |
| Crash rate | >0.5% | SEV-1 |
| Sync failures | >5% for 10 min | SEV-2 |
| API latency | P95 >5s | SEV-3 |
| Memory usage | >300MB | SEV-3 |

---

## 8. Training

### 8.1 On-Call Training

Before joining rotation:
- [ ] Shadow on-call for 2 weeks
- [ ] Complete incident response training
- [ ] Review all runbooks
- [ ] Participate in incident drill
- [ ] Pass on-call certification quiz

### 8.2 Incident Drills

Quarterly game days:
- Simulated SEV-1 incident
- Practice response protocol
- Identify gaps in runbooks
- Build muscle memory

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 30_CAREER_DEVELOPMENT.md]

# Shadow Career Development Framework

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Career paths, skill expectations, and growth opportunities

---

## 1. Engineering Levels

### 1.1 Level Overview

| Level | Title | Years (Typical) | Scope |
|-------|-------|-----------------|-------|
| E1 | Associate Engineer | 0-2 | Tasks |
| E2 | Engineer | 2-4 | Features |
| E3 | Senior Engineer | 4-8 | Projects |
| E4 | Staff Engineer | 8+ | Team/Domain |
| E5 | Principal Engineer | 10+ | Organization |

### 1.2 Level Expectations

#### E1 - Associate Engineer

**Scope:** Individual tasks with guidance

| Dimension | Expectations |
|-----------|--------------|
| **Technical** | Learns codebase, follows patterns, needs code review guidance |
| **Execution** | Completes well-defined tasks, asks questions proactively |
| **Communication** | Updates on progress, asks for help when stuck |
| **Leadership** | N/A |
| **Impact** | Contributes to team goals |

**Typical work:**
- Bug fixes
- Small features with mentorship
- Test coverage improvements
- Documentation

#### E2 - Engineer

**Scope:** Features with some independence

| Dimension | Expectations |
|-----------|--------------|
| **Technical** | Solid understanding of stack, writes clean code, gives useful reviews |
| **Execution** | Owns features end-to-end, estimates accurately, handles ambiguity |
| **Communication** | Clear status updates, good documentation, participates in planning |
| **Leadership** | Helps E1s, shares knowledge |
| **Impact** | Delivers team roadmap items reliably |

**Typical work:**
- Medium features independently
- Cross-feature integration
- On-call participation
- Mentoring E1s informally

#### E3 - Senior Engineer

**Scope:** Projects spanning weeks/months

| Dimension | Expectations |
|-----------|--------------|
| **Technical** | Deep expertise in area, influences technical decisions, high code quality |
| **Execution** | Leads projects, breaks down complex work, unblocks team |
| **Communication** | Drives technical discussions, writes proposals, presents to team |
| **Leadership** | Mentors E1/E2, raises team's bar, on-call reliability |
| **Impact** | Key contributor to team OKRs |

**Typical work:**
- Lead medium projects
- Own subsystems
- Define technical approach for features
- Code review leadership
- Formal mentorship

#### E4 - Staff Engineer

**Scope:** Team or cross-team domain

| Dimension | Expectations |
|-----------|--------------|
| **Technical** | Authority in domain, defines architecture, solves hardest problems |
| **Execution** | Leads multi-team initiatives, removes organizational blockers |
| **Communication** | Influences org-wide decisions, clear technical writing, presents to leadership |
| **Leadership** | Grows senior engineers, defines team practices, culture carrier |
| **Impact** | Multiplies team effectiveness |

**Typical work:**
- Lead major system designs
- Cross-team technical coordination
- ADR authorship
- Engineering-wide improvements
- Interview and hiring

#### E5 - Principal Engineer

**Scope:** Organization-wide

| Dimension | Expectations |
|-----------|--------------|
| **Technical** | Industry-level expertise, shapes technical strategy, anticipates future needs |
| **Execution** | Drives multi-quarter initiatives, manages technical risk at org level |
| **Communication** | External representation, internal thought leadership |
| **Leadership** | Develops Staff engineers, influences company direction |
| **Impact** | Defines engineering trajectory |

---

## 2. Career Tracks

### 2.1 Individual Contributor Track

```
E1 → E2 → E3 → E4 → E5
Associate → Engineer → Senior → Staff → Principal
```

### 2.2 Management Track

```
E3 → M1 → M2 → M3
Senior → Engineering Manager → Senior EM → Director
```

### 2.3 Track Switching

| From | To | Requirements |
|------|-----|--------------|
| E3 → M1 | IC to Manager | Management training, demonstrated leadership |
| M1 → E3 | Manager to IC | Desire to return, technical skills current |
| E4 → M2 | Staff to Senior EM | Proven people skills, org leadership |

---

## 3. Skills Matrix

### 3.1 Technical Skills

| Skill | E1 | E2 | E3 | E4 |
|-------|----|----|----|----|
| Flutter/Dart | Learning | Proficient | Expert | Authority |
| Clean Architecture | Learning | Applying | Teaching | Defining |
| Testing | Basic | Comprehensive | Strategic | Org-wide |
| Database | Queries | Schema design | Optimization | Architecture |
| Security | Awareness | Application | Design | Governance |
| Accessibility | Awareness | Application | Expertise | Advocacy |

### 3.2 Soft Skills

| Skill | E1 | E2 | E3 | E4 |
|-------|----|----|----|----|
| Communication | Clear | Effective | Influential | Org-wide |
| Collaboration | Participates | Contributes | Leads | Multiplies |
| Problem-solving | Guided | Independent | Ambiguous | Novel |
| Mentoring | N/A | Informal | Formal | Developing mentors |
| Planning | Tasks | Features | Projects | Roadmaps |

---

## 4. Promotion Process

### 4.1 Promotion Criteria

To be promoted, an engineer must:
1. **Perform at next level** for 6+ months
2. **Demonstrate all dimensions** at next level
3. **Have sponsorship** from manager and skip-level
4. **Pass promotion committee** review

### 4.2 Promotion Packet

Contents:
- Self-assessment against level expectations
- 3-5 project examples demonstrating scope
- Feedback from peers (3+)
- Manager assessment
- Skip-level endorsement

### 4.3 Promotion Timeline

| Event | Timing |
|-------|--------|
| Discussion with manager | Ongoing |
| Formal nomination | Q1 or Q3 |
| Packet preparation | 2 weeks |
| Committee review | Q2 or Q4 |
| Decision communicated | Within 2 weeks |
| Effective date | Next quarter start |

### 4.4 Promotion Committee

- Engineering Director (chair)
- 2 Tech Leads (rotating)
- 1 Staff Engineer
- HR representative

Reviews:
- Packet completeness
- Evidence of level performance
- Consistency across org
- Calibration with peers

---

## 5. Performance Management

### 5.1 Review Cycle

| Event | Frequency | Purpose |
|-------|-----------|---------|
| 1:1s | Weekly/Bi-weekly | Ongoing feedback, blockers |
| Check-ins | Quarterly | OKR progress, development |
| Formal Review | Bi-annual | Performance rating, compensation |

### 5.2 Rating Scale

| Rating | Definition | Distribution |
|--------|------------|--------------|
| Exceptional | Consistently exceeds at level | ~10% |
| Strong | Meets and often exceeds | ~30% |
| Solid | Meets expectations | ~50% |
| Developing | Not yet meeting expectations | ~10% |
| Needs Improvement | Significant gaps, PIP candidate | Rare |

### 5.3 Feedback Framework

**SBI Model:**
- **Situation:** When/where did this happen?
- **Behavior:** What specifically did they do?
- **Impact:** What was the result?

**Example:**
> "In yesterday's architecture review (Situation), you presented the trade-offs clearly and facilitated a productive discussion (Behavior). This helped the team reach a decision 30 minutes early (Impact)."

### 5.4 Development Plans

Every engineer has a development plan:

| Component | Description |
|-----------|-------------|
| Strengths | Top 3 to leverage |
| Growth Areas | Top 2 to develop |
| Goals (6-month) | Specific, measurable objectives |
| Learning | Courses, books, conferences |
| Stretch Assignment | Project to develop growth areas |
| Support Needed | From manager, mentor, team |

---

## 6. Growth Opportunities

### 6.1 Stretch Assignments

| Assignment | Develops |
|------------|----------|
| Lead a project | Planning, coordination, communication |
| Own a subsystem | Technical depth, accountability |
| Mentor someone | Teaching, patience, leadership |
| On-call primary | Incident response, system knowledge |
| Present at all-hands | Communication, visibility |
| Write an ADR | Technical writing, influence |
| Cross-team project | Collaboration, org navigation |
| Interview panel | Evaluation skills, hiring bar |

### 6.2 Learning Budget

Each engineer receives annually:
- **$2,000** for conferences, courses, books
- **5 days** learning time (in addition to PTO)
- **Internal training** (workshops, tech talks)

### 6.3 Internal Mobility

After 12 months, engineers can:
- Move to different team (same role)
- Move to different track (IC ↔ Manager)
- Move to different domain

Process:
1. Discuss with current manager
2. Interview with new team
3. Transition plan (2-4 weeks overlap)

---

## 7. Recognition Programs

### 7.1 Formal Recognition

| Program | Criteria | Award |
|---------|----------|-------|
| Quarterly MVP | Outstanding contribution | $500 + spotlight |
| Annual Excellence | Year of exceptional impact | $2,000 + promotion consideration |
| Peer Award | Nominated by peers | $200 + recognition |

### 7.2 Informal Recognition

- Shout-outs in #shadow-kudos
- All-hands spotlight
- Manager 1:1 acknowledgment
- Team celebration

### 7.3 Recognition Best Practices

**Do:**
- Be specific about what was excellent
- Recognize promptly (same week)
- Make it public when appropriate
- Recognize different types of contributions

**Don't:**
- Only recognize "hero" behavior
- Overlook steady, reliable performers
- Wait for formal programs
- Recognize the same people repeatedly

---

## 8. 1:1 Framework

### 8.1 Meeting Structure

**Frequency:** Weekly (E1-E2), Bi-weekly (E3+)
**Duration:** 30 minutes
**Owner:** Direct report drives agenda

### 8.2 Sample Agenda

```
1. How are you doing? (5 min)
   - Personal check-in
   - Energy/morale

2. Wins and challenges (10 min)
   - What went well?
   - What's blocking you?

3. Development (10 min)
   - Progress on goals
   - Learning opportunities
   - Feedback exchange

4. Action items (5 min)
   - What do we each commit to?
   - Any escalations needed?
```

### 8.3 Questions to Ask

**Career:**
- What do you want to be doing in 2 years?
- What skills do you want to develop?
- What's holding you back from the next level?

**Engagement:**
- What's the best part of your job right now?
- What would you change if you could?
- Do you feel appropriately challenged?

**Feedback:**
- What should I do more/less of?
- Is there anything unsaid that should be said?
- How can I better support you?

---

## 9. Managing Underperformance

### 9.1 Early Intervention

When performance concerns arise:
1. **Document specifics** (dates, examples)
2. **Give feedback promptly** (within 1 week)
3. **Set clear expectations** (written)
4. **Check in frequently** (weekly)
5. **Escalate to HR** (if no improvement in 4 weeks)

### 9.2 Performance Improvement Plan (PIP)

| Component | Details |
|-----------|---------|
| Duration | 30-60 days |
| Goals | Specific, measurable, achievable |
| Support | Manager, mentor, resources |
| Check-ins | Weekly |
| Documentation | All conversations written |
| Outcome | Improvement or exit |

### 9.3 PIP Principles

- PIPs are not punitive; they're a last chance
- Goals must be fair and achievable
- Support must be genuine
- Documentation protects everyone
- Exit should not be a surprise

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 31_PROJECT_PLAN.md]

# Shadow Project Execution Plan

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Detailed work breakdown, timeline, and team coordination

---

## 1. Project Overview

### 1.1 Timeline Summary

| Phase | Duration | Teams Active | Key Deliverable |
|-------|----------|--------------|-----------------|
| **Phase 0** | Weeks 1-2 | Core (3) | Foundation, tooling, base classes |
| **Phase 1** | Weeks 3-6 | Core (3) + UI (4) | All entities, repositories, database |
| **Phase 2** | Weeks 7-12 | All teams (64) | Core features, screens, providers |
| **Phase 3** | Weeks 13-18 | All teams (64) | Enhanced features, sync, notifications |
| **Phase 4** | Weeks 19-22 | All + QA (4) | Integration, polish, beta |
| **Phase 5** | Weeks 23-26 | All (100) | Launch prep, rollout, monitoring |

### 1.2 Team Ramp-Up Schedule

```
Week 1-2:   Core Team (3)
Week 3-4:   + UI Team (4) = 7 engineers
Week 5-6:   + Quality Team (4) = 11 engineers
Week 7-8:   + Team Conditions (8) + Team Supplements (8) = 27 engineers
Week 9-10:  + Team Nutrition (8) + Team Wellness (8) = 43 engineers
Week 11-12: + Team Sync (8) + Team Platform (8) = 59 engineers
Week 13+:   + Staff Engineers (3) + Remaining (38) = 100 engineers
```

---

## 2. Work Breakdown Structure

### 2.1 Phase 0: Foundation (Weeks 1-2)

**Owner:** Core Team (3 engineers)

| ID | Task | Assignee | Duration | Dependencies | Deliverable |
|----|------|----------|----------|--------------|-------------|
| P0-001 | Project setup, Flutter config | Core-1 | 2 days | None | Running app shell |
| P0-002 | Folder structure per architecture | Core-1 | 1 day | P0-001 | Directory structure |
| P0-003 | Dependencies in pubspec.yaml | Core-2 | 1 day | P0-001 | All packages installed |
| P0-004 | Freezed/Drift/Riverpod setup | Core-2 | 2 days | P0-003 | Code gen working |
| P0-005 | Result type implementation | Core-1 | 1 day | P0-002 | lib/core/types/result.dart |
| P0-006 | AppError hierarchy | Core-1 | 2 days | P0-005 | All error classes |
| P0-007 | Base repository class | Core-2 | 1 day | P0-006 | BaseRepository |
| P0-008 | Database helper (Drift) | Core-3 | 3 days | P0-004 | AppDatabase class |
| P0-009 | Encryption service | Core-3 | 2 days | P0-002 | EncryptionService |
| P0-010 | Logger service | Core-1 | 1 day | P0-002 | LoggerService |
| P0-011 | Device info service | Core-2 | 1 day | P0-003 | DeviceInfoService |
| P0-012 | Localization setup | Core-3 | 1 day | P0-002 | l10n.yaml, base ARB |
| P0-013 | CI/CD pipeline setup | Core-3 | 2 days | P0-004 | GitHub Actions |
| P0-014 | Pre-commit hooks | Core-1 | 1 day | P0-013 | .git/hooks |
| P0-015 | Custom lint rules | Core-2 | 2 days | P0-004 | analysis_options.yaml |

**Milestone P0:** Foundation complete, code generation working, CI passing

---

### 2.2 Phase 1: Domain Layer (Weeks 3-6)

**Owners:** Core Team (3) + UI Team (4) joining Week 3

#### Week 3-4: Core Entities

| ID | Task | Assignee | Duration | Dependencies | Deliverable |
|----|------|----------|----------|--------------|-------------|
| P1-001 | SyncMetadata entity | Core-1 | 1 day | P0-005 | sync_metadata.dart |
| P1-002 | Profile entity + model | Core-1 | 2 days | P1-001 | profile.dart, profile.freezed.dart |
| P1-003 | Profile repository interface | Core-1 | 1 day | P1-002 | profile_repository.dart |
| P1-004 | Profile repository impl | Core-2 | 2 days | P1-003, P0-008 | profile_repository_impl.dart |
| P1-005 | Profile database table | Core-3 | 1 day | P0-008 | profiles table in Drift |
| P1-006 | Profile contract tests | Core-2 | 1 day | P1-004 | profile_contract_test.dart |
| P1-007 | UserAccount entity | Core-1 | 1 day | P1-001 | user_account.dart |
| P1-008 | DeviceRegistration entity | Core-2 | 1 day | P1-001 | device_registration.dart |
| P1-009 | ProfileAccess entity | Core-3 | 1 day | P1-002 | profile_access.dart |
| P1-010 | Auth repository interface | Core-1 | 1 day | P1-007 | auth_repository.dart |
| P1-011 | AppTheme setup | UI-1 | 2 days | P0-002 | app_theme.dart |
| P1-012 | AppColors (earth tones) | UI-1 | 1 day | P1-011 | app_colors.dart |
| P1-013 | ShadowButton widget | UI-2 | 2 days | P1-011 | shadow_button.dart |
| P1-014 | ShadowTextField widget | UI-2 | 2 days | P1-011 | shadow_text_field.dart |
| P1-015 | ShadowCard widget | UI-3 | 1 day | P1-011 | shadow_card.dart |
| P1-016 | ShadowImage widget | UI-3 | 1 day | P1-011 | shadow_image.dart |
| P1-017 | ShadowDialog widget | UI-4 | 2 days | P1-011 | shadow_dialog.dart |
| P1-018 | ShadowStatus widget | UI-4 | 1 day | P1-011 | shadow_status.dart |

#### Week 5-6: Health Entities

| ID | Task | Assignee | Duration | Dependencies | Deliverable |
|----|------|----------|----------|--------------|-------------|
| P1-019 | Condition entity | Core-1 | 2 days | P1-002 | condition.dart |
| P1-020 | Condition repository | Core-1 | 2 days | P1-019 | condition_repository.dart |
| P1-021 | Supplement entity | Core-2 | 2 days | P1-002 | supplement.dart |
| P1-022 | Supplement repository | Core-2 | 2 days | P1-021 | supplement_repository.dart |
| P1-023 | FoodItem entity | Core-3 | 2 days | P1-002 | food_item.dart |
| P1-024 | FoodLog entity | Core-3 | 1 day | P1-023 | food_log.dart |
| P1-025 | Activity entity | Core-1 | 1 day | P1-002 | activity.dart |
| P1-026 | SleepEntry entity | Core-2 | 1 day | P1-002 | sleep_entry.dart |
| P1-027 | FluidsEntry entity | Core-3 | 2 days | P1-002 | fluids_entry.dart |
| P1-028 | PhotoArea entity | Core-1 | 1 day | P1-002 | photo_area.dart |
| P1-029 | JournalEntry entity | Core-2 | 1 day | P1-002 | journal_entry.dart |
| P1-030 | NotificationSchedule entity | Core-3 | 2 days | P1-002 | notification_schedule.dart |
| P1-031 | All entity contract tests | Core-1,2,3 | 3 days | P1-019-030 | *_contract_test.dart |
| P1-032 | ShadowPicker widget | UI-1 | 3 days | P1-013 | shadow_picker.dart |
| P1-033 | ShadowChart widget | UI-2 | 3 days | P1-011 | shadow_chart.dart |
| P1-034 | ShadowInput widget | UI-3 | 2 days | P1-014 | shadow_input.dart |
| P1-035 | ShadowBadge widget | UI-4 | 1 day | P1-011 | shadow_badge.dart |
| P1-036 | Widget accessibility audit | UI-1 | 2 days | P1-032-035 | Audit report |

**Milestone P1:** All entities defined, all repositories interfaced, widget library complete

---

### 2.3 Phase 2: Core Features (Weeks 7-12)

**Owners:** All feature teams join

#### Week 7-8: Team Onboarding + First Features

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P2-001 | Team Conditions onboarding | Conditions | 3 days | P1 complete | Team productive |
| P2-002 | Team Supplements onboarding | Supplements | 3 days | P1 complete | Team productive |
| P2-003 | Condition use cases | Conditions | 3 days | P2-001 | GetConditions, CreateCondition |
| P2-004 | Condition provider | Conditions | 2 days | P2-003 | ConditionNotifier |
| P2-005 | Conditions tab screen | Conditions | 3 days | P2-004 | conditions_tab.dart |
| P2-006 | Add condition screen | Conditions | 3 days | P2-004 | add_condition_screen.dart |
| P2-007 | Supplement use cases | Supplements | 3 days | P2-002 | GetSupplements, CreateSupplement |
| P2-008 | Supplement provider | Supplements | 2 days | P2-007 | SupplementNotifier |
| P2-009 | Supplements tab screen | Supplements | 3 days | P2-008 | supplements_tab.dart |
| P2-010 | Add supplement screen | Supplements | 3 days | P2-008 | add_supplement_screen.dart |
| P2-011 | Home screen shell | UI | 2 days | P1-011 | home_screen.dart |
| P2-012 | Tab navigation | UI | 2 days | P2-011 | Bottom nav implementation |

#### Week 9-10: Nutrition + Wellness Teams

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P2-013 | Team Nutrition onboarding | Nutrition | 3 days | P1 complete | Team productive |
| P2-014 | Team Wellness onboarding | Wellness | 3 days | P1 complete | Team productive |
| P2-015 | Food use cases | Nutrition | 3 days | P2-013 | GetFoodItems, LogMeal |
| P2-016 | Food provider | Nutrition | 2 days | P2-015 | FoodNotifier |
| P2-017 | Food tab screen | Nutrition | 3 days | P2-016 | food_tab.dart |
| P2-018 | Log food screen | Nutrition | 3 days | P2-016 | log_food_screen.dart |
| P2-019 | Diet type selector | Nutrition | 2 days | P1-032 | diet_type_selector.dart |
| P2-020 | Sleep use cases | Wellness | 3 days | P2-014 | LogSleep, GetSleepEntries |
| P2-021 | Sleep provider | Wellness | 2 days | P2-020 | SleepNotifier |
| P2-022 | Sleep tab screen | Wellness | 3 days | P2-021 | sleep_tab.dart |
| P2-023 | Add sleep screen | Wellness | 3 days | P2-021 | add_sleep_screen.dart |
| P2-024 | Fluids use cases | Wellness | 3 days | P2-014 | LogFluids, GetFluidsEntries |
| P2-025 | Fluids provider | Wellness | 2 days | P2-024 | FluidsNotifier |
| P2-026 | Fluids tab screen | Wellness | 3 days | P2-025 | fluids_tab.dart |
| P2-027 | Menstruation picker | Wellness | 2 days | P1-032 | flow_intensity_picker.dart |
| P2-028 | BBT input widget | Wellness | 2 days | P1-034 | bbt_input_widget.dart |
| P2-029 | BBT chart | Wellness | 3 days | P1-033 | bbt_chart.dart |

#### Week 11-12: Sync + Platform Teams

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P2-030 | Team Sync onboarding | Sync | 3 days | P1 complete | Team productive |
| P2-031 | Team Platform onboarding | Platform | 3 days | P1 complete | Team productive |
| P2-032 | OAuth service | Sync | 4 days | P2-030 | oauth_service.dart |
| P2-033 | Google Drive provider | Sync | 5 days | P2-032 | google_drive_provider.dart |
| P2-034 | Sync service | Sync | 5 days | P2-033 | sync_service.dart |
| P2-035 | Conflict resolver | Sync | 3 days | P2-034 | conflict_resolver.dart |
| P2-036 | Sync provider | Sync | 2 days | P2-034 | SyncNotifier |
| P2-037 | Sync settings screen | Sync | 3 days | P2-036 | sync_settings_screen.dart |
| P2-038 | Notification service | Platform | 4 days | P2-031 | notification_service.dart |
| P2-039 | Notification use cases | Platform | 3 days | P2-038 | Schedule CRUD |
| P2-040 | Notification provider | Platform | 2 days | P2-039 | NotificationNotifier |
| P2-041 | Notification settings screen | Platform | 3 days | P2-040 | notification_settings_screen.dart |
| P2-042 | Deep link handler | Platform | 3 days | P2-038 | deep_link_handler.dart |
| P2-043 | Time picker widget | Platform | 2 days | P1-032 | notification_time_picker.dart |
| P2-044 | Weekday selector widget | Platform | 2 days | P1-032 | weekday_selector.dart |

**Milestone P2:** All core features functional, all tabs working, sync operational

---

### 2.4 Phase 3: Enhanced Features (Weeks 13-18)

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P3-001 | Condition logging flow | Conditions | 5 days | P2-006 | Full CRUD + photos |
| P3-002 | Flare-up reporting | Conditions | 4 days | P3-001 | Report flareup screen |
| P3-003 | Condition history view | Conditions | 3 days | P3-001 | History with charts |
| P3-004 | Intake logging flow | Supplements | 5 days | P2-010 | Full CRUD + scheduling |
| P3-005 | Intake history | Supplements | 3 days | P3-004 | Compliance tracking |
| P3-006 | Food library management | Nutrition | 4 days | P2-018 | Library CRUD |
| P3-007 | Composed dishes | Nutrition | 4 days | P3-006 | Recipe creation |
| P3-008 | Diet type in profile | Nutrition | 3 days | P2-019 | Profile + food integration |
| P3-009 | Activity tracking | Wellness | 5 days | P2-014 | Full activity flow |
| P3-010 | Photo documentation | Wellness | 5 days | P1-028 | Photo areas + capture |
| P3-011 | Journal entries | Wellness | 4 days | P1-029 | Journal CRUD |
| P3-012 | Multi-device sync | Sync | 5 days | P2-037 | QR pairing |
| P3-013 | Offline queue | Sync | 4 days | P2-034 | Offline-first |
| P3-014 | File sync (photos) | Sync | 5 days | P3-012 | Photo upload/download |
| P3-015 | Supplement reminders | Platform | 4 days | P2-041 | Per-supplement notifications |
| P3-016 | All notification types | Platform | 5 days | P3-015 | Food, fluids, sleep |
| P3-017 | Report generation | Core | 5 days | P3-001-016 | PDF export |
| P3-018 | Profile management | Core | 4 days | P1-004 | Multi-profile UI |

**Milestone P3:** All features complete, notifications working, multi-device sync

---

### 2.5 Phase 4: Integration & Polish (Weeks 19-22)

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P4-001 | Integration testing | Quality | 10 days | P3 complete | Integration test suite |
| P4-002 | Performance optimization | Core | 5 days | P3 complete | Meet perf targets |
| P4-003 | Accessibility audit | UI | 5 days | P3 complete | WCAG compliance |
| P4-004 | Security audit | Core | 5 days | P3 complete | Security sign-off |
| P4-005 | Localization complete | All | 5 days | P3 complete | All languages |
| P4-006 | Bug bash | All | 3 days | P4-001 | Bug fixes |
| P4-007 | Beta TestFlight build | Quality | 2 days | P4-006 | Beta available |
| P4-008 | Beta testing | All | 10 days | P4-007 | Beta feedback |
| P4-009 | Beta bug fixes | All | 5 days | P4-008 | Stable beta |

**Milestone P4:** Beta complete, all quality gates passed

---

### 2.6 Phase 5: Launch (Weeks 23-26)

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P5-001 | App Store assets | UI | 3 days | P4-009 | Screenshots, descriptions |
| P5-002 | Privacy policy | Core | 2 days | P4-004 | Published policy |
| P5-003 | Release candidate | Quality | 2 days | P4-009 | RC build |
| P5-004 | App Store submission | Quality | 3 days | P5-001-003 | Submitted |
| P5-005 | Feature flag rollout plan | All leads | 2 days | P5-003 | Rollout schedule |
| P5-006 | Monitoring setup | Core | 3 days | P5-003 | Dashboards live |
| P5-007 | On-call training | All | 2 days | P5-006 | Teams ready |
| P5-008 | Launch day | All | 1 day | P5-004 approved | App live |
| P5-009 | Post-launch monitoring | All | 5 days | P5-008 | Stable launch |

**Milestone P5:** App launched, monitoring active, on-call operational

---

## 3. Dependency Matrix

### 3.1 Team Dependencies

```
             Core  UI  Quality  Conditions  Supplements  Nutrition  Wellness  Sync  Platform
Core          -    →      →         →            →           →          →       →       →
UI            ←    -      ↔         →            →           →          →       →       →
Quality       ←    ↔      -         ↔            ↔           ↔          ↔       ↔       ↔
Conditions    ←    ←      ↔         -            ↔           ↔          ↔       →       →
Supplements   ←    ←      ↔         ↔            -           ↔          ↔       →       →
Nutrition     ←    ←      ↔         ↔            ↔           -          ↔       →       →
Wellness      ←    ←      ↔         ↔            ↔           ↔          -       →       →
Sync          ←    ←      ↔         ←            ←           ←          ←       -       ↔
Platform      ←    ←      ↔         ←            ←           ←          ←       ↔       -

Legend: → provides to, ← receives from, ↔ bidirectional
```

### 3.2 Critical Path

```
P0-001 → P0-004 → P0-008 → P1-002 → P1-004 → P2-003 → P2-034 → P3-012 → P4-007 → P5-008
  │                  │         │         │         │         │
  └─ Foundation      └─ DB     └─ Entity └─ Feature└─ Sync   └─ Multi-device
```

### 3.3 Blocking Dependencies

| Blocked Task | Blocking Task | Risk | Mitigation |
|--------------|---------------|------|------------|
| All features | P0-004 (Freezed setup) | High | Core starts Day 1 |
| All DB access | P0-008 (Drift setup) | High | Core priority |
| All features | P1-002 (Profile entity) | High | Core completes Week 3 |
| Sync | P2-032 (OAuth) | Medium | Start early Week 11 |
| Notifications | P2-038 (Service) | Medium | Platform starts Week 11 |
| Launch | P4-004 (Security audit) | High | Schedule external audit early |

---

## 4. Coordination Protocols

### 4.1 Daily Sync Points

| Time | Meeting | Attendees | Purpose |
|------|---------|-----------|---------|
| 9:00 AM | Team Standups | Each team | Daily progress |
| 9:30 AM | Cross-team Sync | Team leads | Dependencies, blockers |

### 4.2 Handoff Protocol

When Team A completes work that Team B depends on:

```
1. Team A completes task
   └── Verifies contract tests pass
   └── Merges to develop

2. Team A notifies Team B
   └── Slack: "@team-b [DEP-XXX] Profile entity ready for use"
   └── Update dependencies.yml

3. Team B acknowledges
   └── Pulls latest develop
   └── Verifies integration
   └── Responds: "Confirmed, integrating"

4. If issues found
   └── Team B creates bug ticket
   └── Tags Team A for resolution
   └── Blocks on resolution before proceeding
```

### 4.3 Interface Freeze Points

| Date | Interface | Owner | Consumers |
|------|-----------|-------|-----------|
| End of Week 4 | All entity interfaces | Core | All feature teams |
| End of Week 6 | Widget library API | UI | All feature teams |
| End of Week 10 | Sync service API | Sync | All feature teams |
| End of Week 12 | Notification service API | Platform | All feature teams |

After freeze: Changes require ADR + all consumer approval

---

## 5. Risk Mitigation

### 5.1 Schedule Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Core team delayed | Medium | Critical | Buffer in Phase 0, can extend |
| Team onboarding slow | Medium | High | Structured program, mentors ready |
| Integration issues | High | High | Continuous integration, contract tests |
| OAuth complexity | Medium | Medium | Start early, have fallback |
| App Store rejection | Low | High | Follow guidelines, pre-review |

### 5.2 Contingency Plans

| Scenario | Response |
|----------|----------|
| Core delayed 1 week | Feature teams start with mock repositories |
| Entity interface changes | ADR + emergency sync meeting |
| Critical bug in beta | Hotfix track, delay launch if needed |
| Security audit fails | Block launch, fix findings, re-audit |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 32_JOB_DESCRIPTIONS.md]

# Shadow Engineering Job Descriptions

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Hiring specifications for all engineering roles

---

## 1. Hiring Summary

### 1.1 Headcount by Phase

| Phase | Weeks | New Hires | Total |
|-------|-------|-----------|-------|
| Phase 0 | 1-2 | 3 (Core Team) | 3 |
| Phase 1 | 3-6 | 8 (UI + Quality) | 11 |
| Phase 2 | 7-12 | 48 (Feature Teams) | 59 |
| Phase 3+ | 13+ | 41 (Remaining + Staff) | 100 |

### 1.2 Role Distribution

| Role | Count | Level |
|------|-------|-------|
| Engineering Director | 1 | Director |
| Tech Lead | 4 | E4/Staff |
| Staff Engineer | 3 | E4 |
| Engineering Manager | 1 | M1 |
| Senior Engineer | 30 | E3 |
| Engineer | 40 | E2 |
| Associate Engineer | 20 | E1 |
| Quality Engineer | 4 | E2-E3 |

---

## 2. Core Team Roles (Hire Week 1)

### 2.1 Senior Engineer, Core Platform (3 positions)

**Team:** Core Team
**Reports to:** Tech Lead - Core Platform
**Level:** E3 (Senior)

#### Job Summary
Design and implement the foundational architecture for Shadow, including entities, repositories, database layer, and shared services. Your work enables all feature teams.

#### Responsibilities
- Implement Clean Architecture patterns (entities, repositories, use cases)
- Design and maintain the Drift database schema
- Create Result type and error handling infrastructure
- Build shared services (encryption, logging, device info)
- Define API contracts for all repository interfaces
- Write contract tests verifying interface compliance
- Review PRs from feature teams touching core code
- Mentor engineers on architectural patterns

#### Requirements
**Must Have:**
- 5+ years software engineering experience
- 3+ years Flutter/Dart experience
- Experience with Clean Architecture or similar
- Strong SQL and database design skills
- Experience with code generation (build_runner, freezed)
- History of building foundational/platform code
- Excellent written communication (for documentation)

**Nice to Have:**
- Experience with SQLCipher or encrypted databases
- Healthcare/HIPAA experience
- Riverpod experience
- Drift ORM experience

#### Technical Assessment
1. Design a repository pattern for a health entity (whiteboard)
2. Implement Result type with error handling (live coding)
3. Review a PR with intentional issues (code review)

#### Interview Process
1. Recruiter screen (30 min)
2. Technical phone screen (60 min)
3. Onsite: System design (60 min)
4. Onsite: Live coding (60 min)
5. Onsite: Code review exercise (45 min)
6. Onsite: Values/culture (45 min)

---

## 3. UI Team Roles (Hire Week 3)

### 3.1 Senior Engineer, Design Systems (1 position)

**Team:** UI Team
**Reports to:** Tech Lead - UI/UX
**Level:** E3 (Senior)

#### Job Summary
Own the Shadow design system and consolidated widget library. Ensure consistent, accessible UI components across the entire application.

#### Responsibilities
- Build and maintain consolidated widget library (15 core widgets)
- Implement earth tone theme and AppColors
- Ensure WCAG 2.1 Level AA compliance for all widgets
- Create widget documentation with usage examples
- Review all UI-related PRs for consistency
- Partner with design on component specifications
- Conduct accessibility audits
- Train feature teams on widget usage

#### Requirements
**Must Have:**
- 4+ years Flutter experience
- Deep understanding of Flutter widget lifecycle
- Experience building reusable component libraries
- Strong accessibility knowledge (WCAG, VoiceOver, TalkBack)
- Eye for design consistency
- Experience with theming and design tokens

**Nice to Have:**
- Experience with Storybook or widget catalogs
- Animation and motion design experience
- Previous design system ownership

---

### 3.2 Engineer, UI Components (3 positions)

**Team:** UI Team
**Reports to:** Senior Engineer, Design Systems
**Level:** E2 (Engineer)

#### Job Summary
Build accessible, reusable UI components following the design system. Implement complex widgets like charts and pickers.

#### Responsibilities
- Implement widget variants (buttons, inputs, cards)
- Build specialized widgets (BBT chart, flow picker, time selector)
- Write widget tests for all components
- Ensure semantic labels and accessibility
- Document widget APIs and usage
- Support feature teams with widget integration

#### Requirements
**Must Have:**
- 2+ years Flutter experience
- Understanding of widget composition
- Experience with custom painting/charts
- Accessibility awareness
- Testing experience (widget tests)

**Nice to Have:**
- Experience with fl_chart or similar
- Animation experience
- Previous component library work

---

## 4. Feature Team Roles (Hire Weeks 7-12)

### 4.1 Senior Engineer, Team Lead (6 positions)

**Teams:** Conditions, Supplements, Nutrition, Wellness, Sync, Platform
**Reports to:** Tech Lead - Features
**Level:** E3 (Senior)

#### Job Summary
Lead a feature team of 8 engineers. Own a vertical slice of the application from UI to data layer.

#### Responsibilities
- Lead technical direction for your domain
- Break down features into implementable tasks
- Conduct code reviews for team PRs
- Ensure team follows API contracts and patterns
- Mentor E1 and E2 engineers on your team
- Coordinate with other teams on dependencies
- Participate in architecture reviews
- Own on-call rotation for your domain

#### Requirements
**Must Have:**
- 5+ years software engineering experience
- 2+ years Flutter experience
- Previous tech lead or team lead experience
- Strong mentoring track record
- Experience with full-stack feature development
- Excellent communication skills

**Specific to Team:**
| Team | Additional Requirements |
|------|------------------------|
| Conditions | Experience with photo/image handling |
| Supplements | Experience with scheduling/calendar logic |
| Nutrition | Experience with search/filtering |
| Wellness | Experience with data visualization |
| Sync | Experience with distributed systems, conflict resolution |
| Platform | Experience with push notifications, deep linking |

---

### 4.2 Engineer, Feature Development (24 positions)

**Teams:** 4 per feature team
**Reports to:** Senior Engineer, Team Lead
**Level:** E2 (Engineer)

#### Job Summary
Build features end-to-end within your domain. Implement screens, providers, use cases, and tests.

#### Responsibilities
- Implement assigned features following specs
- Write use cases with Result type pattern
- Build screens using consolidated widgets
- Write unit and widget tests
- Participate in code reviews
- Update documentation for changes
- Participate in on-call rotation

#### Requirements
**Must Have:**
- 2+ years software engineering experience
- 1+ years Flutter experience
- Understanding of state management
- Experience with async programming
- Testing experience

**Nice to Have:**
- Experience with Riverpod
- Experience with code generation
- Mobile app deployment experience

---

### 4.3 Associate Engineer (12 positions)

**Teams:** 2 per feature team
**Reports to:** Senior Engineer, Team Lead
**Level:** E1 (Associate)

#### Job Summary
Learn and contribute to feature development with mentorship. Focus on smaller tasks and bug fixes while building skills.

#### Responsibilities
- Complete assigned tasks with mentor guidance
- Fix bugs in your team's domain
- Write tests for existing code
- Participate in code reviews (as learner)
- Ask questions and learn patterns
- Document learnings for future engineers

#### Requirements
**Must Have:**
- CS degree or equivalent experience
- Basic Flutter/Dart knowledge
- Eagerness to learn
- Good communication skills
- Ability to ask for help

**Nice to Have:**
- Personal Flutter projects
- Internship experience
- Open source contributions

---

## 5. Quality Team Roles (Hire Week 5)

### 5.1 Senior Quality Engineer (2 positions)

**Team:** Quality Team
**Reports to:** Tech Lead - Quality
**Level:** E3 (Senior)

#### Job Summary
Own test infrastructure, CI/CD pipelines, and release engineering. Ensure quality gates are enforced.

#### Responsibilities
- Maintain CI/CD pipelines (GitHub Actions)
- Build integration test framework
- Create and maintain contract test suite
- Define and enforce coverage thresholds
- Manage beta and production releases
- Conduct release readiness reviews
- Train teams on testing practices

#### Requirements
**Must Have:**
- 4+ years QA/SDET experience
- Experience with Flutter testing (unit, widget, integration)
- CI/CD pipeline experience (GitHub Actions preferred)
- Experience with test automation frameworks
- Release management experience

**Nice to Have:**
- Mobile app store release experience
- Experience with code coverage tools
- Performance testing experience

---

### 5.2 Quality Engineer (2 positions)

**Team:** Quality Team
**Reports to:** Senior Quality Engineer
**Level:** E2 (Engineer)

#### Job Summary
Build and maintain test automation. Support feature teams with testing best practices.

#### Responsibilities
- Write integration tests for user flows
- Maintain test data generators
- Monitor test health and fix flaky tests
- Support teams with testing questions
- Participate in bug bashes
- Document testing patterns

#### Requirements
**Must Have:**
- 2+ years QA experience
- Flutter testing experience
- Understanding of test pyramid
- Debugging skills

---

## 6. Leadership Roles

### 6.1 Tech Lead, Core Platform (1 position)

**Team:** Core Team
**Reports to:** Engineering Director
**Level:** E4 (Staff)

#### Job Summary
Own technical direction for Shadow's foundation. Lead the Core Team and guide architectural decisions.

#### Responsibilities
- Define and evolve Shadow architecture
- Lead ADR process and architecture reviews
- Own API contracts and interface definitions
- Manage Core Team (3 engineers)
- Coordinate with all feature teams
- Resolve technical disputes
- Represent engineering in planning

#### Requirements
**Must Have:**
- 8+ years software engineering experience
- 4+ years Flutter experience
- Previous architect or tech lead role
- Experience defining APIs and contracts
- Track record of cross-team leadership
- Excellent written documentation skills

---

### 6.2 Engineering Manager, Operations (1 position)

**Reports to:** Engineering Director
**Level:** M1

#### Job Summary
Own engineering operations, processes, and team health. Manage on-call, incidents, and operational excellence.

#### Responsibilities
- Own on-call rotation and incident process
- Manage postmortem process
- Define and track engineering metrics
- Own team health surveys and action items
- Coordinate cross-team processes
- Manage operations team (2 engineers)
- Partner with Tech Leads on career development

#### Requirements
**Must Have:**
- 5+ years engineering experience
- 2+ years people management experience
- Experience with incident management
- Strong process improvement skills
- Excellent communication skills
- Experience with engineering metrics

---

### 6.3 Staff Engineer (3 positions)

**Reports to:** Engineering Director
**Level:** E4 (Staff)

#### Job Summary
Cross-cutting technical leadership. Own specific domains (Architecture, Performance, Security) across all teams.

#### Responsibilities
- Solve hardest technical problems
- Define patterns for your domain
- Review cross-team technical decisions
- Mentor senior engineers toward staff
- Represent domain in architecture reviews
- Write RFCs and ADRs for major changes

#### Requirements
**Must Have:**
- 8+ years software engineering experience
- Deep expertise in assigned domain
- Cross-team influence experience
- Strong written communication
- Mentoring track record

**Domain-Specific:**

| Domain | Additional Requirements |
|--------|------------------------|
| Architecture | System design, API design, Clean Architecture |
| Performance | Profiling, optimization, mobile performance |
| Security | Encryption, HIPAA, mobile security |

---

## 7. Interview Rubrics

### 7.1 Technical Assessment (All Roles)

| Criteria | 1 (No Hire) | 2 (Weak) | 3 (Hire) | 4 (Strong Hire) |
|----------|-------------|----------|----------|-----------------|
| Problem Solving | Cannot approach problem | Needs heavy guidance | Solves with minor hints | Elegant solution independently |
| Code Quality | Messy, bugs | Works but poor style | Clean, follows patterns | Exemplary, teaches patterns |
| Testing | No testing mention | Basic tests | Comprehensive tests | TDD, edge cases |
| Communication | Cannot explain | Unclear explanation | Clear explanation | Teaches concept |

### 7.2 Values Assessment (All Roles)

| Value | Questions |
|-------|-----------|
| Quality | "Tell me about a time you pushed back on shipping something not ready" |
| Ownership | "Describe a time you owned a problem outside your job description" |
| Collaboration | "How do you handle disagreement with a teammate's approach?" |
| Growth | "What's something you learned recently and how did you learn it?" |

---

## 8. Onboarding Assignments

### 8.1 First Week Mentor Assignments

| New Hire Role | Mentor Role | Mentor Team |
|---------------|-------------|-------------|
| Core Engineer | Existing Core Engineer | Core |
| UI Engineer | Senior UI Engineer | UI |
| Feature Engineer | Team Lead | Their feature team |
| Quality Engineer | Senior Quality Engineer | Quality |

### 8.2 First Task Assignments

| Role | First Task | Complexity |
|------|-----------|-----------|
| Associate Engineer | Bug fix or test addition | Low |
| Engineer | Small feature or enhancement | Medium |
| Senior Engineer | Medium feature with design | Medium-High |
| Staff Engineer | Architecture review or ADR | High |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 33_SPRINT_ASSIGNMENTS.md]

# Shadow Sprint Assignments & Coordination

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Detailed task assignments with coordination instructions

---

## 0. Coding Standards Reference

**CRITICAL:** Before starting ANY task, review the applicable sections of `02_CODING_STANDARDS.md`:

| Task Type | Required Reading |
|-----------|------------------|
| Entity creation | §5 Entity Standards, §8 Database Standards |
| Repository implementation | §3 Repository Pattern, §4 Data Source Standards |
| Use Case implementation | §6 Provider Standards (UseCase delegation) |
| Provider/State management | §6 Provider Standards |
| Error handling | §7 Error Handling Standards |
| UI/Widget development | §12 Performance, §13 Accessibility |
| Database work | §8 Database Standards, §9 Sync System |
| Security features | §11 Security Standards |
| Any code | §10 Testing (100% coverage required) |

**Task-Specific Standards:**

| Task ID | Applies Coding Standards Sections |
|---------|----------------------------------|
| P0-005 Result type | §7.1 Result Pattern |
| P0-006 AppError hierarchy | §7.1 AppError Hierarchy (must include RecoveryAction) |
| P0-007 Base repository | §3 Repository Pattern |
| P0-008 Database helper | §8 Database Standards, §9 Sync System |
| P0-009 Encryption service | §11.4 Encryption Standards (AES-256-GCM) |
| P1-xxx Entity tasks | §5 Entity Standards (id, clientId, profileId, syncMetadata) |
| P2-xxx Repository tasks | §3 Repository Pattern, §4.3 ProfileId filtering |
| All tasks | §10.3 Test Coverage (100% required) |

---

## 1. Sprint Structure

### 1.1 Sprint Cadence

| Sprint | Weeks | Phase | Focus |
|--------|-------|-------|-------|
| Sprint 1 | 1-2 | Phase 0 | Foundation |
| Sprint 2 | 3-4 | Phase 1A | Core entities |
| Sprint 3 | 5-6 | Phase 1B | All entities + widgets |
| Sprint 4 | 7-8 | Phase 2A | First features |
| Sprint 5 | 9-10 | Phase 2B | More features |
| Sprint 6 | 11-12 | Phase 2C | Sync + Platform |
| Sprint 7 | 13-14 | Phase 3A | Enhanced features |
| Sprint 8 | 15-16 | Phase 3B | Enhanced features |
| Sprint 9 | 17-18 | Phase 3C | Final features |
| Sprint 10 | 19-20 | Phase 4A | Integration |
| Sprint 11 | 21-22 | Phase 4B | Beta |
| Sprint 12 | 23-24 | Phase 5A | Launch prep |
| Sprint 13 | 25-26 | Phase 5B | Launch + monitoring |

---

## 2. Sprint 1: Foundation (Weeks 1-2)

### 2.1 Team: Core (3 engineers)

| Engineer | Task ID | Task | Days | Output | Coordination |
|----------|---------|------|------|--------|--------------|
| **Core-1** | P0-001 | Project setup | 2 | App shell running | None |
| | P0-002 | Folder structure | 1 | Directories created | After P0-001 |
| | P0-005 | Result type | 1 | result.dart | After P0-002 |
| | P0-006 | AppError hierarchy | 2 | All error classes | After P0-005 |
| | P0-010 | Logger service | 1 | LoggerService | After P0-002 |
| | P0-014 | Pre-commit hooks | 1 | Hooks installed | After P0-013 |
| **Core-2** | P0-003 | Dependencies | 1 | pubspec.yaml | After P0-001 |
| | P0-004 | Code gen setup | 2 | build_runner working | After P0-003 |
| | P0-007 | Base repository | 1 | BaseRepository | After P0-006 |
| | P0-011 | Device info service | 1 | DeviceInfoService | After P0-003 |
| | P0-015 | Custom lint rules | 2 | analysis_options | After P0-004 |
| **Core-3** | P0-008 | Database helper | 3 | AppDatabase | After P0-004 |
| | P0-009 | Encryption service | 2 | EncryptionService | After P0-002 |
| | P0-012 | Localization setup | 1 | l10n.yaml, base ARB | After P0-002 |
| | P0-013 | CI/CD pipeline | 2 | GitHub Actions | After P0-004 |

### 2.2 Coordination Instructions - Sprint 1

```
Day 1 Morning:
├── Core-1: Start P0-001 (project setup)
├── Core-2: WAIT for Core-1 to complete P0-001
└── Core-3: WAIT for Core-1 to complete P0-001

Day 1 Afternoon:
├── Core-1: Continue P0-001
├── Core-2: Start P0-003 once P0-001 merged
└── Core-3: WAIT

Day 2:
├── Core-1: Complete P0-001, start P0-002
├── Core-2: Complete P0-003, start P0-004
└── Core-3: Start P0-008 once P0-004 has Drift configured

Day 3-4:
├── Core-1: P0-005, P0-006 (Result type, errors)
├── Core-2: Complete P0-004, start P0-007
└── Core-3: Continue P0-008

Day 5-6:
├── Core-1: P0-010, P0-014
├── Core-2: P0-011, P0-015
└── Core-3: P0-009, P0-012, P0-013

HANDOFF: At end of Sprint 1, Core Team posts in #shadow-engineering:
"Sprint 1 Complete: Foundation ready. UI Team can begin Sprint 2."
```

### 2.3 Sprint 1 Checklist

- [ ] App builds on iOS, Android, macOS
- [ ] Code generation (freezed, drift, riverpod) working
- [ ] Pre-commit hooks installed and tested
- [ ] CI pipeline runs on PR
- [ ] Result type with all error classes
- [ ] Database helper with encryption
- [ ] Logger service with scoped logging

---

## 3. Sprint 2: Core Entities (Weeks 3-4)

### 3.1 Team: Core (3 engineers)

| Engineer | Task ID | Task | Days | Output |
|----------|---------|------|------|--------|
| **Core-1** | P1-001 | SyncMetadata entity | 1 | sync_metadata.dart |
| | P1-002 | Profile entity | 2 | profile.dart + .freezed |
| | P1-003 | Profile repository interface | 1 | profile_repository.dart |
| | P1-007 | UserAccount entity | 1 | user_account.dart |
| | P1-010 | Auth repository interface | 1 | auth_repository.dart |
| **Core-2** | P1-004 | Profile repository impl | 2 | profile_repository_impl.dart |
| | P1-006 | Profile contract tests | 1 | profile_contract_test.dart |
| | P1-008 | DeviceRegistration entity | 1 | device_registration.dart |
| **Core-3** | P1-005 | Profile database table | 1 | Drift table |
| | P1-009 | ProfileAccess entity | 1 | profile_access.dart |

### 3.2 Team: UI (4 engineers) - Joins Sprint 2

| Engineer | Task ID | Task | Days | Output |
|----------|---------|------|------|--------|
| **UI-1** | P1-011 | AppTheme setup | 2 | app_theme.dart |
| | P1-012 | AppColors | 1 | app_colors.dart |
| **UI-2** | P1-013 | ShadowButton | 2 | shadow_button.dart |
| | P1-014 | ShadowTextField | 2 | shadow_text_field.dart |
| **UI-3** | P1-015 | ShadowCard | 1 | shadow_card.dart |
| | P1-016 | ShadowImage | 1 | shadow_image.dart |
| **UI-4** | P1-017 | ShadowDialog | 2 | shadow_dialog.dart |
| | P1-018 | ShadowStatus | 1 | shadow_status.dart |

### 3.3 Coordination Instructions - Sprint 2

```
ONBOARDING: UI Team (Days 1-2)
├── Day 1 AM: Environment setup, read specs 01-10
├── Day 1 PM: Architecture walkthrough with Core-1
├── Day 2 AM: Read specs 11-25, quiz 1
└── Day 2 PM: Quiz 2, assign first tasks

PARALLEL WORK (Days 3-8):
├── Core Team: Entities (no UI dependency)
├── UI Team: Widgets (depends only on P0 foundation)
└── No blocking dependencies between teams

DAILY SYNC (9:30 AM):
├── Core-1 reports entity progress
├── UI-1 reports widget progress
└── Identify any blockers

END OF SPRINT:
├── Core posts: "Profile entity ready, interface frozen"
├── UI posts: "Widget library v1 ready for feature teams"
└── Both teams demo to Quality Team
```

### 3.4 Sprint 2 Acceptance Criteria

**Core Team Deliverables:**
- [ ] Profile entity with all fields (incl. dietType, dietDescription)
- [ ] Profile repository interface defined per 22_API_CONTRACTS.md
- [ ] Profile repository implementation with Result type
- [ ] Contract tests passing for Profile
- [ ] UserAccount, DeviceRegistration, ProfileAccess entities

**UI Team Deliverables:**
- [ ] AppTheme with earth tones
- [ ] ShadowButton with all variants
- [ ] ShadowTextField with accessibility
- [ ] ShadowCard, ShadowImage, ShadowDialog, ShadowStatus
- [ ] All widgets have semantic labels
- [ ] Widget tests for each widget

---

## 4. Sprint 4: First Features (Weeks 7-8)

### 4.1 Team Onboarding Schedule

| Day | Team | Activity |
|-----|------|----------|
| Day 1 | Conditions, Supplements | Environment setup, specs 01-15 |
| Day 2 | Conditions, Supplements | Specs 16-33, quizzes, architecture walkthrough |
| Day 3 | Conditions, Supplements | Quiz review, assign first tasks |
| Day 4-8 | All | Implementation |

### 4.2 Team: Conditions (8 engineers)

| Engineer | Task ID | Task | Days | Depends On |
|----------|---------|------|------|------------|
| **Cond-Lead** | - | Onboarding, planning | 3 | - |
| | P2-003 | Condition use cases | 3 | Onboarding |
| | - | Code reviews | Ongoing | - |
| **Cond-Sr1** | P2-004 | Condition provider | 2 | P2-003 |
| | P2-005a | Conditions tab UI | 2 | P2-004 |
| **Cond-Sr2** | P2-005b | Conditions tab logic | 2 | P2-004 |
| | - | Code reviews | Ongoing | - |
| **Cond-E1** | P2-006a | Add condition form | 2 | P2-004 |
| **Cond-E2** | P2-006b | Add condition validation | 2 | P2-006a |
| **Cond-E3** | Tests | Condition use case tests | 3 | P2-003 |
| **Cond-A1** | Tests | Condition provider tests | 2 | P2-004 |
| **Cond-A2** | Docs | Condition flow documentation | 2 | P2-005 |

### 4.3 Team: Supplements (8 engineers)

| Engineer | Task ID | Task | Days | Depends On |
|----------|---------|------|------|------------|
| **Supp-Lead** | - | Onboarding, planning | 3 | - |
| | P2-007 | Supplement use cases | 3 | Onboarding |
| | - | Code reviews | Ongoing | - |
| **Supp-Sr1** | P2-008 | Supplement provider | 2 | P2-007 |
| | P2-009a | Supplements tab UI | 2 | P2-008 |
| **Supp-Sr2** | P2-009b | Supplements tab logic | 2 | P2-008 |
| | - | Code reviews | Ongoing | - |
| **Supp-E1** | P2-010a | Add supplement form | 2 | P2-008 |
| **Supp-E2** | P2-010b | Ingredient management | 2 | P2-010a |
| **Supp-E3** | Tests | Supplement use case tests | 3 | P2-007 |
| **Supp-A1** | Tests | Supplement provider tests | 2 | P2-008 |
| **Supp-A2** | Docs | Supplement flow documentation | 2 | P2-009 |

### 4.4 Team: UI (4 engineers) - Continues

| Engineer | Task ID | Task | Days |
|----------|---------|------|------|
| **UI-1** | P2-011 | Home screen shell | 2 |
| | P2-012 | Tab navigation | 2 |
| **UI-2** | Support | Widget support for feature teams | Ongoing |
| **UI-3** | Support | Widget support for feature teams | Ongoing |
| **UI-4** | Refinement | Widget accessibility refinement | 3 |

### 4.5 Coordination Instructions - Sprint 4

```
ONBOARDING COORDINATION:
├── Core-1 leads architecture session (Day 2, 2 hrs)
├── UI-1 leads widget library demo (Day 2, 1 hr)
└── Quality leads testing patterns session (Day 3, 1 hr)

DEPENDENCY CHECK (Daily 9:30 AM):
├── Cond-Lead: "We need Profile repository - Core status?"
├── Core-1: "Profile ready on develop, pull and verify"
├── Supp-Lead: "We need ShadowTextField - UI status?"
└── UI-1: "ShadowTextField on develop, tests passing"

HANDOFF PROTOCOL:
When Cond-Lead completes P2-003 (use cases):
1. Merge to develop
2. Post: "@team-conditions P2-003 merged, providers can start"
3. Cond-Sr1 pulls develop, begins P2-004

BLOCKED RESOLUTION:
If Cond-E1 blocked waiting for P2-004:
1. Post in #team-conditions: "Blocked on P2-004"
2. Cond-Lead assigns alternate task from backlog
3. OR pairs Cond-E1 with Cond-Sr1 on P2-004

END OF SPRINT:
├── Demo: Conditions tab with add condition flow
├── Demo: Supplements tab with add supplement flow
├── Commit: All use cases, providers, screens merged
└── Handoff: "Ready for Nutrition and Wellness teams"
```

---

## 5. Sprint 6: Sync + Platform (Weeks 11-12)

### 5.1 Team: Sync (8 engineers)

| Engineer | Task ID | Task | Days | Critical Path |
|----------|---------|------|------|---------------|
| **Sync-Lead** | - | Onboarding | 3 | - |
| | P2-032 | OAuth service | 4 | YES - blocks all sync |
| **Sync-Sr1** | P2-033 | Google Drive provider | 5 | Needs P2-032 |
| **Sync-Sr2** | P2-034 | Sync service | 5 | Needs P2-033 |
| **Sync-E1** | P2-035 | Conflict resolver | 3 | Needs P2-034 |
| **Sync-E2** | P2-036 | Sync provider | 2 | Needs P2-034 |
| **Sync-E3** | P2-037 | Sync settings screen | 3 | Needs P2-036 |
| **Sync-A1** | Tests | OAuth tests | 3 | Needs P2-032 |
| **Sync-A2** | Tests | Sync service tests | 3 | Needs P2-034 |

### 5.2 Team: Platform (8 engineers)

| Engineer | Task ID | Task | Days | Critical Path |
|----------|---------|------|------|---------------|
| **Plat-Lead** | - | Onboarding | 3 | - |
| | P2-038 | Notification service | 4 | YES - blocks notifications |
| **Plat-Sr1** | P2-039 | Notification use cases | 3 | Needs P2-038 |
| **Plat-Sr2** | P2-042 | Deep link handler | 3 | Needs P2-038 |
| **Plat-E1** | P2-040 | Notification provider | 2 | Needs P2-039 |
| **Plat-E2** | P2-041 | Notification settings screen | 3 | Needs P2-040 |
| **Plat-E3** | P2-043 | Time picker widget | 2 | Uses ShadowPicker |
| | P2-044 | Weekday selector widget | 2 | Uses ShadowPicker |
| **Plat-A1** | Tests | Notification service tests | 3 | Needs P2-038 |
| **Plat-A2** | Tests | Deep link tests | 2 | Needs P2-042 |

### 5.3 Coordination Instructions - Sprint 6

```
CRITICAL PATH ALERT:
├── P2-032 (OAuth) is on critical path - PRIORITY
├── P2-038 (Notifications) is on critical path - PRIORITY
└── Both Lead engineers focus exclusively on these

CROSS-TEAM DEPENDENCIES:
├── ALL feature teams need P2-034 (Sync service) by Week 13
├── Wellness team needs P2-043/P2-044 for notification settings
└── Core team provides sync metadata helpers

DAILY SYNC (9:30 AM) - CRITICAL:
├── Sync-Lead: OAuth progress, blockers
├── Plat-Lead: Notification service progress
├── Core-Lead: Any support needed?
└── Escalate immediately if behind

INTERFACE FREEZE:
├── Week 12 End: Sync service interface FROZEN
├── Week 12 End: Notification service interface FROZEN
└── Changes after freeze require ADR + emergency approval

HANDOFF TO PHASE 3:
When P2-034 complete:
├── Post: "@all-feature-teams Sync service ready"
├── Document: Sync integration guide
└── Office hours: Sync team available for questions
```

---

## 6. Agent/Engineer Coordination Protocol

### 6.1 Before Starting Any Task

```
CHECKLIST:
□ Pull latest from develop branch
□ Check dependencies.yml for blocking issues
□ Verify dependent tasks are complete
□ Read the specification for this task
□ Understand acceptance criteria
□ Check API Contracts for interface requirements
```

### 6.2 During Task Execution

```
COORDINATION COMMANDS:

"I need {X} from {Team/Person}":
1. Check if X is complete (dependencies.yml, develop branch)
2. If not complete, post in their team channel
3. If blocked >4 hours, escalate to team lead
4. Pick up alternate task while waiting

"I completed {TaskID}":
1. Ensure all tests pass
2. Ensure contract tests pass
3. Create PR with complete description
4. Post: "@team {TaskID} ready for review"
5. Update dependencies.yml if this unblocks others
6. Notify blocked teams: "@{team} {TaskID} complete, you're unblocked"

"I'm blocked on {TaskID}":
1. Post in team channel immediately
2. Tag the blocking person/team
3. Escalate to team lead if no response in 2 hours
4. Team lead assigns alternate work

"I have a question about {interface/pattern}":
1. Check specs (01-33) first
2. Check API Contracts (22)
3. If not answered, ask in #shadow-architecture
4. If urgent, DM Core team lead
```

### 6.3 Cross-Team Coordination

```
REQUESTING WORK FROM ANOTHER TEAM:

1. Create ticket in their backlog (if not exists)
2. Post in their team channel with ticket link
3. Attend their standup to discuss (if >1 day effort)
4. Track in dependencies.yml

Example:
"@team-sync SHADOW-456: Wellness team needs sync metadata helpers for BBT entries.
Can this be prioritized this sprint? Blocks P3-029 due Week 15."

PROVIDING WORK TO ANOTHER TEAM:

1. Complete task with full tests
2. Document usage with examples
3. Post in their channel with location
4. Offer office hours for questions

Example:
"@team-wellness P2-043 (NotificationTimePicker) is on develop.
Usage: `NotificationTimePicker(times: [], onTimesChanged: (t) => {})`
Full docs in widget library. Ping me with questions."
```

### 6.4 End of Sprint Protocol

```
THURSDAY (2 days before sprint end):
□ All code PRs submitted
□ All PRs in review
□ Identify any at-risk items
□ Escalate blockers to leads

FRIDAY (1 day before):
□ All PRs merged or exception documented
□ Demo prepared for sprint review
□ Dependencies updated for next sprint
□ Handoff notes for consuming teams

SPRINT REVIEW:
□ Demo completed work
□ Document what didn't complete (and why)
□ Update next sprint assignments
□ Retro: What blocked us? How to improve?
```

---

## 7. Escalation Matrix

| Situation | Wait Time | Escalate To | Action |
|-----------|-----------|-------------|--------|
| Blocked by PR review | 24 hours | Team Lead | Reassign reviewer |
| Blocked by other team | 4 hours | Both Team Leads | Priority discussion |
| Unclear requirements | 2 hours | Product + Tech Lead | Clarification meeting |
| Technical disagreement | 1 meeting | Staff Engineer | Decision made |
| Critical path at risk | Immediate | Engineering Director | Resource reallocation |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |

---
## [Original: 34_PROJECT_TRACKER.md]

# Shadow Project Tracker

**Version:** 2.0
**Last Updated:** February 5, 2026
**Purpose:** Track project progress and next tasks

> **CANONICAL SOURCE:** All implementation details must follow [02_CODING_STANDARDS.md](02_CODING_STANDARDS.md). See [22_API_CONTRACTS.md](22_API_CONTRACTS.md) for exact interface specifications.

---

## Current Status Summary

| Phase | Status | Details |
|-------|--------|---------|
| Phase 0: Infrastructure | **COMPLETE** | All 15 SHADOW tickets done |
| Phase 1: Core Entities | **COMPLETE** | All entities implemented |
| Phase 2: Use Cases | **COMPLETE** | All 14 entity use cases done |
| Phase 3: UI/Presentation | **COMPLETE** | All screens, widgets, providers done |

---

## 1. Phase 0: Infrastructure (COMPLETE)

All infrastructure tasks completed. See git history for implementation details.

| Ticket | Description | Status |
|--------|-------------|--------|
| SHADOW-001 | Initialize Flutter Project | **DONE** |
| SHADOW-002 | Create Folder Structure | **DONE** |
| SHADOW-003 | Add Core Dependencies | **DONE** |
| SHADOW-004 | Configure Code Generation | **DONE** |
| SHADOW-005 | Implement Result Type | **DONE** |
| SHADOW-006 | Implement AppError Hierarchy | **DONE** |
| SHADOW-007 | Implement BaseRepository | **DONE** |
| SHADOW-008 | Implement Database (Drift/SQLCipher) | **DONE** |
| SHADOW-009 | Implement EncryptionService | **DONE** |
| SHADOW-010 | Implement LoggerService | **DONE** |
| SHADOW-011 | Implement DeviceInfoService | **DONE** |
| SHADOW-012 | Configure Localization | **DONE** |
| SHADOW-013 | Set Up CI/CD Pipeline | **DONE** |
| SHADOW-014 | Configure Pre-commit Hooks | **DONE** |
| SHADOW-015 | Create Custom Lint Rules | **DONE** |

---

## 2. Phase 1: Entity Implementation (COMPLETE)

All 14 entities implemented with full stack: Entity, Table, DAO, Repository Interface, Repository Impl.

| Entity | Entity | Table | DAO | Repo Interface | Repo Impl | Status |
|--------|--------|-------|-----|----------------|-----------|--------|
| Supplement | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| IntakeLog | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| Condition | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| ConditionLog | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| FlareUp | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| FluidsEntry | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| SleepEntry | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| Activity | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| ActivityLog | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| FoodItem | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| FoodLog | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| JournalEntry | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| PhotoArea | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |
| PhotoEntry | ✓ | ✓ | ✓ | ✓ | ✓ | **DONE** |

**Database Schema Version:** 7

---

## 3. Phase 2: Use Case Implementation (COMPLETE)

Use cases implement business logic with authorization checks.

| Entity | Use Cases | Status |
|--------|-----------|--------|
| Supplement | CreateSupplement, UpdateSupplement, GetSupplements, ArchiveSupplement | **DONE** |
| IntakeLog | MarkTaken, MarkSkipped, GetIntakeLogs | **DONE** |
| Condition | CreateCondition, GetConditions, ArchiveCondition | **DONE** |
| ConditionLog | LogCondition, GetConditionLogs | **DONE** |
| FluidsEntry | LogFluidsEntry, GetFluidsEntries, GetTodayEntry, GetBBT, GetMenstruation, Update, Delete | **DONE** |
| SleepEntry | LogSleepEntry, GetSleepEntries, GetForNight, GetAverages, Update, Delete | **DONE** |
| FlareUp | LogFlareUp, GetFlareUps, UpdateFlareUp, EndFlareUp, DeleteFlareUp | **DONE** |
| Activity | CreateActivity, UpdateActivity, GetActivities, ArchiveActivity | **DONE** |
| ActivityLog | LogActivity, GetActivityLogs, UpdateActivityLog, DeleteActivityLog | **DONE** |
| FoodItem | CreateFoodItem, UpdateFoodItem, GetFoodItems, SearchFoodItems, ArchiveFoodItem | **DONE** |
| FoodLog | LogFood, GetFoodLogs, UpdateFoodLog, DeleteFoodLog | **DONE** |
| JournalEntry | CreateJournalEntry, GetJournalEntries, SearchJournalEntries, UpdateJournalEntry, DeleteJournalEntry | **DONE** |
| PhotoArea | CreatePhotoArea, GetPhotoAreas, UpdatePhotoArea, ArchivePhotoArea | **DONE** |
| PhotoEntry | CreatePhotoEntry, GetPhotoEntriesByArea, GetPhotoEntries, DeletePhotoEntry | **DONE** |

### Use Case Implementation Status

All 14 entity use cases are complete. Each implementation:
- EXACTLY matches 22_API_CONTRACTS.md specifications
- Checks authorization FIRST
- Returns `Result<T, AppError>`
- Has comprehensive test coverage

---

## 4. Test Coverage

| Category | Tests | Status |
|----------|-------|--------|
| Core (Result, AppError) | 30+ | Passing |
| Services (Logger, Encryption, DeviceInfo) | 20+ | Passing |
| Entities | 140+ | Passing |
| DAOs | 280+ | Passing |
| Repositories | 280+ | Passing |
| Use Cases | 300+ | Passing |
| Providers | 135+ | Passing |
| Screens | 500+ | Passing |
| Widgets | 160+ | Passing |
| **Total** | **1919** | **ALL PASSING** |

---

## 5. Next Actions

### Phase 2 Complete - Ready for Phase 3

All entity use cases are implemented. Next steps:

### Phase 3: UI/Presentation Layer

1. **Riverpod Providers** ✅ **COMPLETE**
   - DI providers for all 51 use cases and 14 repositories
   - List providers for all 14 entities
   - Defense-in-depth authorization checks
   - All following 02_CODING_STANDARDS.md Section 6 exactly

2. **Core Widgets** ✅ **COMPLETE**
   - widget_enums.dart - All variant enums (ButtonVariant, InputType, etc.)
   - ShadowButton - Elevated/text/icon/fab/outlined variants
   - ShadowTextField - Text/numeric/password input types
   - ShadowCard - Standard/list item variants
   - ShadowDialog - Alert/confirm/input with helper functions
   - ShadowStatus - Loading/progress/status/sync indicators
   - All following 09_WIDGET_LIBRARY.md spec exactly

3. **Screen Implementation** ✅ **COMPLETE**
   - ✅ Home screen with tab navigation (Dashboard/Tracking/Food/Journal/Photos)
   - ✅ Supplement list + edit screens (23 tests)
   - ✅ Condition list + edit screens
   - ✅ Condition log screen
   - ✅ Food item edit screen
   - ✅ Food log screen
   - ✅ Fluids entry screen
   - ✅ Sleep entry edit screen
   - ✅ Intake log screen
   - ✅ Activity list + edit screens
   - ✅ Activity log screen
   - ✅ Journal entry list + edit screens (with min 10 chars content validation)
   - ✅ Photo area list + edit screens
   - ✅ Photo entry gallery screen (with Notes field + Date/Time picker dialog)
   - ✅ main.dart wired with navigation shell
   - ✅ All validation uses centralized ValidationRules constants (Coding Standard 7.2 Rule 7)

4. **Specialized Widgets** ✅ **COMPLETE**
   - ShadowPicker - Flow/weekday/dietType/time/date/multiSelect pickers
   - ShadowChart - BBT/trend/bar/calendar/scatter/heatmap charts
   - ShadowImage - Asset/file/network/picker image handling
   - ShadowInput - Temperature/diet/flow health inputs
   - ShadowBadge - Diet/status/count badges
   - All with tests and WCAG 2.1 Level AA accessibility

---

## 6. Verification Status

| Check | Result |
|-------|--------|
| `flutter test` | 1919 tests passing |
| `flutter analyze` | No errors/warnings (infos only) |
| Pre-commit hooks | Active |
| Spec compliance | **VERIFIED** (Full audit 2026-02-05, spec updates 2026-02-10) |
| Implementation compliance | **100%** - All 14 entities, repositories, use cases match specs exactly |
| Validation centralization | **COMPLETE** - All use cases and screens use ValidationRules constants |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release with Phase 0 planning |
| 2.0 | 2026-02-05 | Updated to reflect actual completion status |
| 2.1 | 2026-02-10 | Screen implementation progress, validation centralization, 1913 tests |

---
## [Original: 41_DIET_SYSTEM.md]

# Shadow Diet System Specification

**Version:** 1.0
**Last Updated:** January 31, 2026
**Purpose:** Complete specification for diet types, rules, compliance tracking, and violation alerts

---

## 1. Overview

Shadow provides comprehensive diet tracking that goes beyond simple food logging. The system:

- **Supports preset diets** with pre-configured rules
- **Allows custom diet creation** with user-defined restrictions
- **Tracks compliance in real-time** with percentage scoring
- **Alerts users to violations** as they log food
- **Handles time-based diets** (intermittent fasting)
- **Generates compliance reports** with trend analysis

---

## 2. Diet Categories

### 2.1 Diet Type Classification

| Category | Description | Examples |
|----------|-------------|----------|
| **Food Restriction** | Excludes specific food types | Vegan, Vegetarian, Paleo, Keto |
| **Time Restriction** | Controls when eating occurs | Intermittent Fasting (16:8, 18:6, OMAD) |
| **Macronutrient Ratio** | Specific macro percentages | Keto (75/20/5), Zone (40/30/30) |
| **Combination** | Both food and time rules | Paleo + 16:8, Clean Keto |
| **Elimination** | Temporary exclusions for testing | Whole30, AIP, Low-FODMAP |
| **Custom** | User-defined rules | Any combination |

### 2.2 Preset Diet Library

> **CANONICAL SOURCE:** The `DietPresetType` enum is defined authoritatively in `22_API_CONTRACTS.md` Section 3.2.
> Diet IDs below use camelCase to match the Dart enum values.

| Diet ID (DietPresetType) | Diet Name | Category | Key Rules |
|--------------------------|-----------|----------|-----------|
| `vegan` | Vegan | Food Restriction | No animal products |
| `vegetarian` | Vegetarian | Food Restriction | No meat/fish, allows dairy/eggs |
| `pescatarian` | Pescatarian | Food Restriction | No meat, allows fish/dairy/eggs |
| `paleo` | Paleo | Food Restriction | No grains, legumes, dairy, processed foods |
| `keto` | Ketogenic | Macronutrient | <20g net carbs, 70-75% fat |
| `ketoStrict` | Strict Keto | Macronutrient | <20g total carbs, 75% fat |
| `lowCarb` | Low Carb | Macronutrient | <100g carbs daily |
| `mediterranean` | Mediterranean | Food Preference | Emphasis on fish, olive oil, vegetables |
| `whole30` | Whole30 | Elimination | No sugar, grains, dairy, legumes, alcohol (30 days) |
| `aip` | Autoimmune Protocol | Elimination | Paleo + no nightshades, eggs, nuts, seeds |
| `lowFodmap` | Low-FODMAP | Elimination | No high-FODMAP foods |
| `glutenFree` | Gluten-Free | Food Restriction | No gluten-containing grains |
| `dairyFree` | Dairy-Free | Food Restriction | No dairy products |
| `if168` | Intermittent Fasting 16:8 | Time Restriction | 16hr fast, 8hr eating window |
| `if186` | Intermittent Fasting 18:6 | Time Restriction | 18hr fast, 6hr eating window |
| `if204` | Intermittent Fasting 20:4 | Time Restriction | 20hr fast, 4hr eating window |
| `omad` | One Meal A Day | Time Restriction | 23hr fast, 1hr eating window |
| `fiveTwoDiet` | 5:2 Diet | Time Restriction | 5 normal days, 2 fasting days (<500 cal) |
| `zone` | Zone Diet | Macronutrient | 40% carb, 30% protein, 30% fat |
| `custom` | Custom Diet | Custom | User-defined |

---

## 3. Diet Rule Engine

### 3.1 Rule Types

```dart
enum DietRuleType {
  // Food-based rules
  excludeCategory,      // Exclude entire food category
  excludeIngredient,    // Exclude specific ingredient
  requireCategory,      // Must include category (e.g., vegetables)
  limitCategory,        // Max servings per day/week

  // Macronutrient rules
  maxCarbs,             // Maximum carbs (grams)
  maxFat,               // Maximum fat (grams)
  maxProtein,           // Maximum protein (grams)
  minCarbs,             // Minimum carbs (grams)
  minFat,               // Minimum fat (grams)
  minProtein,           // Minimum protein (grams)
  carbPercentage,       // Carbs as % of calories
  fatPercentage,        // Fat as % of calories
  proteinPercentage,    // Protein as % of calories
  maxCalories,          // Maximum daily calories

  // Time-based rules
  eatingWindowStart,    // Earliest eating time
  eatingWindowEnd,      // Latest eating time
  fastingHours,         // Required consecutive fasting hours
  fastingDays,          // Specific fasting days (for 5:2)
  maxMealsPerDay,       // Maximum number of meals

  // Combination rules
  mealSpacing,          // Minimum hours between meals
  noEatingBefore,       // No food before time
  noEatingAfter,        // No food after time
}
```

### 3.2 Food Categories

```dart
enum FoodCategory {
  // Animal products
  meat,                 // Beef, pork, lamb, etc.
  poultry,              // Chicken, turkey, duck
  fish,                 // All fish and shellfish
  eggs,
  dairy,                // Milk, cheese, yogurt, butter

  // Plant-based
  vegetables,
  fruits,
  grains,               // Wheat, rice, oats, corn
  legumes,              // Beans, lentils, peanuts
  nuts,                 // Tree nuts
  seeds,

  // Specific restrictions
  gluten,               // Wheat, barley, rye
  nightshades,          // Tomatoes, peppers, eggplant, potatoes
  fodmaps,              // Fermentable carbs
  sugar,                // Added sugars
  alcohol,
  caffeine,
  processedFoods,
  artificialSweeteners,

  // Cooking methods
  friedFoods,
  rawFoods,
}
```

### 3.3 Diet Rule Definition

```dart
@freezed
class DietRule with _$DietRule {
  const factory DietRule({
    required String id,
    required DietRuleType type,
    required RuleSeverity severity,    // violation, warning, info
    FoodCategory? category,
    String? ingredientName,
    double? numericValue,              // For limits/percentages
    TimeOfDay? timeValue,              // For time-based rules
    List<int>? daysOfWeek,             // For day-specific rules
    String? description,               // Human-readable description
    String? violationMessage,          // Message shown on violation
  }) = _DietRule;
}

enum RuleSeverity {
  violation,    // Breaks the diet (red)
  warning,      // Discouraged but allowed (yellow)
  info,         // Informational tracking (blue)
}
```

### 3.4 Preset Diet Rule Definitions

#### Vegan
```dart
const veganRules = [
  DietRule(type: excludeCategory, category: meat, severity: violation,
    violationMessage: "Meat is not allowed on a vegan diet"),
  DietRule(type: excludeCategory, category: poultry, severity: violation,
    violationMessage: "Poultry is not allowed on a vegan diet"),
  DietRule(type: excludeCategory, category: fish, severity: violation,
    violationMessage: "Fish is not allowed on a vegan diet"),
  DietRule(type: excludeCategory, category: eggs, severity: violation,
    violationMessage: "Eggs are not allowed on a vegan diet"),
  DietRule(type: excludeCategory, category: dairy, severity: violation,
    violationMessage: "Dairy is not allowed on a vegan diet"),
];
```

#### Keto
```dart
const ketoRules = [
  DietRule(type: maxCarbs, numericValue: 20, severity: violation,
    violationMessage: "Daily carbs exceed 20g keto limit"),
  DietRule(type: fatPercentage, numericValue: 70, severity: warning,
    violationMessage: "Fat intake below 70% target"),
  DietRule(type: excludeCategory, category: sugar, severity: violation,
    violationMessage: "Added sugar not allowed on keto"),
  DietRule(type: excludeCategory, category: grains, severity: violation,
    violationMessage: "Grains not allowed on keto"),
  DietRule(type: limitCategory, category: fruits, numericValue: 1, severity: warning,
    violationMessage: "Limit fruit to 1 serving on keto"),
];
```

#### Intermittent Fasting 16:8
```dart
const if168Rules = [
  DietRule(type: fastingHours, numericValue: 16, severity: violation,
    violationMessage: "Eating outside your 8-hour window"),
  DietRule(type: eatingWindowStart, timeValue: TimeOfDay(12, 0), severity: info,
    description: "Default eating window starts at 12:00 PM"),
  DietRule(type: eatingWindowEnd, timeValue: TimeOfDay(20, 0), severity: info,
    description: "Default eating window ends at 8:00 PM"),
];
```

#### Paleo
```dart
const paleoRules = [
  DietRule(type: excludeCategory, category: grains, severity: violation,
    violationMessage: "Grains not allowed on paleo"),
  DietRule(type: excludeCategory, category: legumes, severity: violation,
    violationMessage: "Legumes not allowed on paleo"),
  DietRule(type: excludeCategory, category: dairy, severity: violation,
    violationMessage: "Dairy not allowed on paleo"),
  DietRule(type: excludeCategory, category: processedFoods, severity: violation,
    violationMessage: "Processed foods not allowed on paleo"),
  DietRule(type: excludeCategory, category: sugar, severity: violation,
    violationMessage: "Added sugar not allowed on paleo"),
];
```

#### Mediterranean
```dart
const mediterraneanRules = [
  DietRule(type: requireCategory, category: vegetables, numericValue: 3, severity: warning,
    violationMessage: "Try to eat at least 3 servings of vegetables"),
  DietRule(type: requireCategory, category: fish, numericValue: 2, severity: warning,
    violationMessage: "Include fish at least 2x per week"),
  DietRule(type: limitCategory, category: meat, numericValue: 2, severity: warning,
    violationMessage: "Limit red meat to 2 servings per week"),
  DietRule(type: excludeCategory, category: processedFoods, severity: warning,
    violationMessage: "Minimize processed foods"),
];
```

---

## 4. Food Item Tagging

### 4.1 Food Item Categories

Each food item in the library must be tagged with applicable categories:

```dart
@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    required FoodItemType type,
    required Set<FoodCategory> categories,  // NEW: Category tags

    // Nutritional info (optional but enables macro tracking)
    NutritionalInfo? nutrition,

    // For composed items
    List<String>? ingredientIds,

    // Sync metadata
    required SyncMetadata syncMetadata,
  }) = _FoodItem;
}

@freezed
class NutritionalInfo with _$NutritionalInfo {
  const factory NutritionalInfo({
    required double servingSize,
    required String servingUnit,      // "g", "oz", "cup", "piece"
    required double calories,
    required double carbsGrams,
    required double fatGrams,
    required double proteinGrams,
    double? fiberGrams,               // For net carbs calculation
    double? sugarGrams,
    double? sodiumMg,
  }) = _NutritionalInfo;
}
```

### 4.2 Auto-Categorization

Common foods are pre-tagged in the system database:

```dart
// Example food item definitions
const chickenBreast = FoodItem(
  name: "Chicken Breast",
  categories: {FoodCategory.poultry, FoodCategory.meat},
  nutrition: NutritionalInfo(
    servingSize: 100, servingUnit: "g",
    calories: 165, carbsGrams: 0, fatGrams: 3.6, proteinGrams: 31,
  ),
);

const brownRice = FoodItem(
  name: "Brown Rice",
  categories: {FoodCategory.grains},
  nutrition: NutritionalInfo(
    servingSize: 100, servingUnit: "g",
    calories: 112, carbsGrams: 24, fatGrams: 0.8, proteinGrams: 2.3,
    fiberGrams: 1.8,
  ),
);

const almonds = FoodItem(
  name: "Almonds",
  categories: {FoodCategory.nuts},
  nutrition: NutritionalInfo(
    servingSize: 28, servingUnit: "g",
    calories: 164, carbsGrams: 6, fatGrams: 14, proteinGrams: 6,
    fiberGrams: 3.5,
  ),
);
```

### 4.3 User Category Override

Users can adjust categories if auto-detection is incorrect:

```
┌─────────────────────────────────────────────────────────────────────┐
│  EDIT FOOD ITEM                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Name: Almond Milk                                                  │
│                                                                     │
│  Categories (select all that apply):                                │
│                                                                     │
│  ☐ Meat      ☐ Poultry    ☐ Fish       ☐ Eggs                     │
│  ☐ Dairy     ☑ Nuts       ☐ Grains     ☐ Legumes                  │
│  ☐ Sugar     ☐ Gluten     ☐ Processed  ☐ Alcohol                  │
│                                                                     │
│  Note: Almond milk is nut-based, not dairy                         │
│                                                                     │
│                    [Save Changes]                                   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 5. Compliance Calculation

### 5.1 Meal Definition

> **IMPORTANT CLARIFICATION:** For compliance calculation purposes, a "meal" is defined as:
> - ANY FoodLog entry, regardless of meal type (breakfast, lunch, dinner, snack)
> - Each food log is counted as ONE compliance opportunity
> - Individual food items within a log are checked for violations, but the log itself is the unit of measurement
> - A single FoodLog with multiple violating items counts as ONE violation (not multiple)
> - Snacks count equally with main meals for compliance scoring

**Example:**
- User logs breakfast with 3 foods: 2 compliant, 1 violating → 1 violation
- User logs lunch with 5 foods: all compliant → 0 violations
- User logs snack with 1 violating food → 1 violation
- Daily score: (3 meals - 2 violations) / 3 meals = 33.3% compliance

### 5.2 Compliance Score Algorithm

```dart
class DietComplianceCalculator {
  /// Calculate compliance score for a date range
  /// Returns 0-100 percentage
  ///
  /// IMPORTANT: Each FoodLog counts as one "meal" for scoring purposes.
  /// A log with ANY violation counts as 1 violation, regardless of how
  /// many violating items it contains.
  double calculateCompliance(
    Diet diet,
    List<FoodLog> logs,
    DateTimeRange range,
  ) {
    final rules = diet.rules;
    final violations = <RuleViolation>[];

    // Check each rule type
    for (final rule in rules) {
      switch (rule.type) {
        case DietRuleType.excludeCategory:
          violations.addAll(_checkExclusionRule(rule, logs));
          break;
        case DietRuleType.maxCarbs:
          violations.addAll(_checkMacroLimit(rule, logs, range));
          break;
        case DietRuleType.eatingWindowStart:
        case DietRuleType.eatingWindowEnd:
          violations.addAll(_checkTimeRule(rule, logs));
          break;
        // ... handle all rule types
      }
    }

    // Calculate score
    final totalMeals = logs.length;
    final violationCount = violations.where((v) =>
      v.severity == RuleSeverity.violation
    ).length;

    if (totalMeals == 0) return 100.0;

    // Each violation reduces score proportionally
    final score = ((totalMeals - violationCount) / totalMeals) * 100;
    return score.clamp(0.0, 100.0);
  }

  List<RuleViolation> _checkExclusionRule(DietRule rule, List<FoodLog> logs) {
    final violations = <RuleViolation>[];

    for (final log in logs) {
      for (final foodItem in log.foodItems) {
        if (foodItem.categories.contains(rule.category)) {
          violations.add(RuleViolation(
            rule: rule,
            foodLog: log,
            foodItem: foodItem,
            message: rule.violationMessage ??
              '${foodItem.name} contains ${rule.category.name}',
          ));
        }
      }
    }

    return violations;
  }

  List<RuleViolation> _checkTimeRule(DietRule rule, List<FoodLog> logs) {
    final violations = <RuleViolation>[];

    for (final log in logs) {
      final logTime = TimeOfDay.fromDateTime(log.timestamp);

      if (rule.type == DietRuleType.eatingWindowStart) {
        if (_isTimeBefore(logTime, rule.timeValue!)) {
          violations.add(RuleViolation(
            rule: rule,
            foodLog: log,
            message: 'Eating before ${_formatTime(rule.timeValue!)} '
              'breaks your fasting window',
          ));
        }
      }

      if (rule.type == DietRuleType.eatingWindowEnd) {
        if (_isTimeAfter(logTime, rule.timeValue!)) {
          violations.add(RuleViolation(
            rule: rule,
            foodLog: log,
            message: 'Eating after ${_formatTime(rule.timeValue!)} '
              'breaks your fasting window',
          ));
        }
      }
    }

    return violations;
  }
}
```

### Compliance Score Calculation (Exact Formula)

daily_compliance = ((total_rules - violations) / total_rules) * 100

Where:
- total_rules: Count of active diet rules for the day
- violations: Count of logged violations for that day
- Result: Integer percentage 0-100

Streak Calculation:
- Streak starts at 0 on diet activation
- Streak increments by 1 at end of each day with 100% compliance
- Streak resets to 0 when daily_compliance < 100%
- Days with no food logged count as 100% (no violations occurred)

### 5.2 Exact Compliance Score Formula

The daily compliance score is calculated using a severity-weighted violation impact formula:

```dart
/// Calculate daily compliance score (0-100%)
double calculateDailyCompliance({
  required List<RuleViolation> violations,
}) {
  // Sum all violation impacts
  double totalImpact = 0.0;

  for (final violation in violations) {
    final severityWeight = _getSeverityWeight(violation.severity);
    final portionFactor = violation.portionFactor ?? 1.0; // 1.0 = full serving

    totalImpact += severityWeight * portionFactor;
  }

  // Calculate compliance: 100 - sum of impacts, clamped to 0-100
  final compliance = (100.0 - totalImpact).clamp(0.0, 100.0);
  return compliance;
}

/// Severity weights determine impact per violation
double _getSeverityWeight(RuleSeverity severity) {
  return switch (severity) {
    RuleSeverity.critical => 25.0,  // Severe diet break (e.g., allergen for allergy diet)
    RuleSeverity.high => 15.0,      // Major violation (e.g., meat on vegan diet)
    RuleSeverity.medium => 10.0,    // Moderate violation (e.g., grains on paleo)
    RuleSeverity.low => 5.0,        // Minor violation (e.g., slightly over carb limit)
  };
}
```

**Formula Summary:**
```
daily_compliance = 100 - (sum of violation_impacts)
violation_impact = rule_severity_weight x portion_factor

Rule Severity Weights:
- critical = 25 points
- high = 15 points
- medium = 10 points
- low = 5 points

Portion Factor:
- 1.0 = full serving (default)
- 0.5 = half serving
- 2.0 = double serving (impact scales proportionally)
```

**Examples:**
| Scenario | Calculation | Result |
|----------|-------------|--------|
| No violations | 100 - 0 | 100% |
| 1 high violation | 100 - 15 | 85% |
| 2 medium violations | 100 - (10 + 10) | 80% |
| 1 critical + 1 low | 100 - (25 + 5) | 70% |
| Half serving of high violation food | 100 - (15 x 0.5) | 92.5% |

### 5.3 Violation Severity Mapping

| Severity | Weight | Use Cases |
|----------|--------|-----------|
| Critical (25) | Allergen exposure, medical restriction break | AIP nightshade, celiac gluten |
| High (15) | Core diet principle violation | Meat on vegan, dairy on paleo |
| Medium (10) | Standard rule violation | Grains on keto, legumes on paleo |
| Low (5) | Minor overage, warning-level | Slightly over carb limit, extra fruit |

### 5.4 Daily vs Weekly vs Monthly Compliance

```dart
class ComplianceMetrics {
  final double dailyScore;        // Today's compliance
  final double weeklyScore;       // Last 7 days average
  final double monthlyScore;      // Last 30 days average
  final int currentStreak;        // Days at 100% compliance
  final int longestStreak;        // Best streak ever
  final List<RuleViolation> recentViolations;
  final Map<DietRuleType, int> violationsByType;
}
```

### 5.5 Streak Calculation Rules

Compliance streaks track consecutive days of perfect (100%) diet adherence.

**Streak Break Conditions:**
```dart
/// A streak breaks when:
/// 1. daily_compliance < 100% (any violation occurred)
/// 2. The day boundary is crossed with imperfect compliance

bool checkStreakBroken(double dailyCompliance) {
  // Streak breaks on ANY violation, regardless of severity
  return dailyCompliance < 100.0;
}
```

**Day Boundary Definition:**
- A "day" is defined as a calendar day in the user's local timezone
- Day starts at 00:00:00 and ends at 23:59:59 local time
- Food logs are assigned to days based on their timestamp, not when logged
- Example: Food eaten at 11:30 PM on Monday counts toward Monday's compliance

**No Food Logged Behavior:**
```dart
/// When no food is logged for a day:
/// - Compliance = 100% (no violations possible)
/// - Streak CONTINUES (user maintained their diet by not eating violations)
/// - This handles fasting days, travel days, etc.

double getComplianceForDay(List<FoodLog> logsForDay) {
  if (logsForDay.isEmpty) {
    return 100.0; // No food = no violations = perfect compliance
  }
  return calculateDailyCompliance(logsForDay);
}
```

**Streak Calculation Algorithm:**
```dart
int calculateCurrentStreak({
  required String profileId,
  required DateTime today,
  required String userTimezone,
}) {
  int streak = 0;
  DateTime checkDate = today;

  while (true) {
    final dayStart = _startOfDayInTimezone(checkDate, userTimezone);
    final dayEnd = _endOfDayInTimezone(checkDate, userTimezone);

    final logsForDay = _getLogsInRange(profileId, dayStart, dayEnd);
    final compliance = getComplianceForDay(logsForDay);

    if (compliance < 100.0) {
      break; // Streak broken
    }

    streak++;
    checkDate = checkDate.subtract(Duration(days: 1));

    // Don't count before diet start date
    if (checkDate.isBefore(diet.startDate)) break;
  }

  return streak;
}
```

**Edge Cases:**
| Scenario | Streak Behavior |
|----------|-----------------|
| Diet started today, no logs yet | Streak = 1 (today is compliant) |
| Diet started today, 1 violation | Streak = 0 |
| Yesterday: 100%, Today: violation | Streak = 0 (resets today) |
| Fasting day (no food logged) | Streak continues |
| Backdated violation entry | Recalculates; may break historical streak |

---

## 6. Real-Time Violation Alerts

### 6.1 Pre-Log Warning

When user selects a food item, check against diet rules BEFORE logging:

```
┌─────────────────────────────────────────────────────────────────────┐
│  ⚠️  DIET ALERT                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  "Cheese Pizza" may conflict with your Paleo diet:                 │
│                                                                     │
│  ❌ Contains DAIRY (cheese)                                         │
│  ❌ Contains GRAINS (wheat crust)                                   │
│                                                                     │
│  Logging this will reduce today's compliance by ~15%               │
│                                                                     │
│  Current compliance: 92%                                            │
│  After logging: ~77%                                                │
│                                                                     │
│        [Cancel]        [Log Anyway]        [Find Alternative]      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.2 Time-Based Warning (Intermittent Fasting)

```
┌─────────────────────────────────────────────────────────────────────┐
│  ⏰  FASTING WINDOW ALERT                                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Your eating window hasn't started yet.                            │
│                                                                     │
│  Current time: 10:30 AM                                            │
│  Eating window: 12:00 PM - 8:00 PM                                 │
│                                                                     │
│  Time until eating window: 1 hour 30 minutes                       │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 🌙 FASTING ░░░░░░░░░░░░░░░│ 🍽️ EATING ░░░░░░░░│ 🌙 FASTING │   │
│  │ 12AM          8AM    12PM              8PM          12AM    │   │
│  │                 ▲                                            │   │
│  │              You are here                                    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│        [Cancel]        [Log Anyway (Breaks Fast)]                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.3 Macro Limit Warning (Keto)

```
┌─────────────────────────────────────────────────────────────────────┐
│  🥑  CARB LIMIT WARNING                                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Adding "Apple (medium)" will exceed your daily carb limit.        │
│                                                                     │
│  Carbs in this item: 25g                                           │
│  Already consumed today: 12g                                       │
│  Daily limit: 20g                                                  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Current: ████████████░░░░░░░░░░░░░░░░░░░░  12g / 20g (60%) │   │
│  │ After:   ██████████████████████████████████████  37g (185%)│   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Keto-friendly alternatives:                                        │
│  • Berries (1/2 cup) - 6g carbs                                    │
│  • Avocado - 2g carbs                                              │
│                                                                     │
│        [Cancel]        [Log Anyway]        [View Alternatives]     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 7. Compliance Dashboard

### 7.1 Food Tab Header with Compliance

```
┌─────────────────────────────────────────────────────────────────────┐
│  FOOD                                               [+ Log Food]    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  🥗 PALEO DIET                           Today: 92%         │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │                                                             │   │
│  │  ████████████████████████████████████████████░░░░  92%     │   │
│  │                                                             │   │
│  │  This Week: 88%    This Month: 91%    Streak: 5 days       │   │
│  │                                                             │   │
│  │  ⚠️ 1 violation today: Cheese (dairy) at lunch             │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  TODAY'S MEALS                                                      │
│  ─────────────                                                      │
│  ...                                                                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 7.2 Detailed Compliance View

```
┌─────────────────────────────────────────────────────────────────────┐
│  PALEO DIET COMPLIANCE                              [Edit Diet]     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  OVERALL SCORE                                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                                                             │   │
│  │                        ┌───────┐                            │   │
│  │                        │       │                            │   │
│  │                        │  91%  │                            │   │
│  │                        │       │                            │   │
│  │                        └───────┘                            │   │
│  │                      Last 30 Days                           │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  TREND                                                              │
│  ─────                                                              │
│  100%│          ●───●                    ●───●───●                 │
│   90%│     ●───●     ╲          ●───●───●                          │
│   80%│────●           ╲────●───●                                   │
│   70%│                                                              │
│      └──────────────────────────────────────────────────────────   │
│       Wk1    Wk2    Wk3    Wk4    Wk5    Wk6    Wk7    Wk8        │
│                                                                     │
│  RULE COMPLIANCE                                                    │
│  ───────────────                                                    │
│  ✓ No grains              100%  ████████████████████████████████   │
│  ✓ No legumes             100%  ████████████████████████████████   │
│  ⚠️ No dairy               85%  ███████████████████████████░░░░░   │
│  ✓ No processed foods      98%  ███████████████████████████████░   │
│  ✓ No added sugar         100%  ████████████████████████████████   │
│                                                                     │
│  RECENT VIOLATIONS                                                  │
│  ─────────────────                                                  │
│  • Jan 31, 12:30 PM - Cheese (dairy)                               │
│  • Jan 28, 7:00 PM - Ice cream (dairy, sugar)                      │
│  • Jan 25, 1:15 PM - Bread (grains)                                │
│                                                                     │
│  STREAK                                                             │
│  ──────                                                             │
│  Current: 2 days    Best: 14 days (Jan 5-18)                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 7.3 Intermittent Fasting Dashboard

```
┌─────────────────────────────────────────────────────────────────────┐
│  16:8 INTERMITTENT FASTING                          [Edit Window]   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  TODAY'S FASTING TIMER                                              │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                                                             │   │
│  │  🌙 CURRENTLY FASTING                                       │   │
│  │                                                             │   │
│  │                    14:32:17                                 │   │
│  │                  Hours Fasted                               │   │
│  │                                                             │   │
│  │  ████████████████████████████████████░░░░░░░░░░  14.5/16h  │   │
│  │                                                             │   │
│  │  Eating window opens in: 1h 28m                             │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  TODAY'S TIMELINE                                                   │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                                                             │   │
│  │  12AM    4AM    8AM    12PM    4PM    8PM    12AM          │   │
│  │  │░░░░░░░░░░░░░░░░░░░│████████████████████│░░░░░░░│        │   │
│  │  └── Last meal ──────┘└── Window open ────┘                │   │
│  │      8:00 PM              12:00 PM - 8:00 PM               │   │
│  │                                                             │   │
│  │  ▼ Now (10:32 AM)                                          │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  THIS WEEK                                                          │
│  ─────────                                                          │
│  Mon: ✓ 16.2h    Tue: ✓ 17.0h    Wed: ✓ 16.5h    Thu: ⏳          │
│  Fri: -          Sat: -          Sun: -                            │
│                                                                     │
│  Weekly Compliance: 100% (3/3 days)                                │
│  Average Fast: 16.6 hours                                          │
│  Current Streak: 12 days                                           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 8. Custom Diet Creation

### 8.1 Diet Builder UI

```
┌─────────────────────────────────────────────────────────────────────┐
│  CREATE CUSTOM DIET                                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Diet Name: [My Elimination Diet                    ]               │
│                                                                     │
│  Start From:                                                        │
│  ○ Blank (no rules)                                                │
│  ● Preset: [Paleo ▼] (then customize)                              │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  FOOD RESTRICTIONS                                                  │
│                                                                     │
│  Exclude completely:                                                │
│  ☑ Grains    ☑ Dairy    ☑ Legumes    ☑ Sugar                      │
│  ☑ Eggs      ☑ Nightshades    ☐ Nuts    ☐ Seeds                   │
│                                                                     │
│  Limit (servings per day):                                          │
│  Fruits: [1 ▼]    Nuts: [Unlimited ▼]                              │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  TIME RESTRICTIONS                                                  │
│                                                                     │
│  ☑ Enable eating window                                            │
│     Start: [12:00 PM ▼]    End: [8:00 PM ▼]                        │
│                                                                     │
│  ☐ Fasting days (for 5:2 style)                                    │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  MACRO LIMITS (optional)                                            │
│                                                                     │
│  ☐ Limit carbs: [    ] g/day                                       │
│  ☐ Limit calories: [    ] cal/day                                  │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  Duration:                                                          │
│  ○ Ongoing                                                          │
│  ● Fixed period: [30 ▼] days (for elimination diets)               │
│                                                                     │
│                    [Cancel]        [Save Diet]                      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.2 Add Custom Rule

```
┌─────────────────────────────────────────────────────────────────────┐
│  ADD CUSTOM RULE                                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Rule Type: [Exclude specific ingredient ▼]                        │
│                                                                     │
│  Ingredient Name: [Histamine-rich foods            ]               │
│                                                                     │
│  Examples (for matching):                                           │
│  [aged cheese, fermented foods, wine, cured meats  ]               │
│                                                                     │
│  Severity:                                                          │
│  ● Violation (strict - affects compliance score)                   │
│  ○ Warning (discouraged but allowed)                               │
│  ○ Info (tracking only)                                            │
│                                                                     │
│  Custom message when violated:                                      │
│  [This food may trigger histamine reactions        ]               │
│                                                                     │
│                    [Cancel]        [Add Rule]                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 9. Diet Reports

### 9.1 Compliance Report (PDF)

```
┌─────────────────────────────────────────────────────────────────────┐
│  DIET COMPLIANCE REPORT                                             │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  Profile: [Name]                                                    │
│  Diet: Paleo + 16:8 Intermittent Fasting                           │
│  Period: January 1-31, 2026                                        │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════   │
│                                                                     │
│  EXECUTIVE SUMMARY                                                  │
│  ─────────────────                                                  │
│                                                                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                │
│  │   OVERALL   │  │    FOOD     │  │   TIMING    │                │
│  │             │  │   RULES     │  │   RULES     │                │
│  │    88%      │  │    91%      │  │    85%      │                │
│  │  Compliance │  │  Compliance │  │  Compliance │                │
│  └─────────────┘  └─────────────┘  └─────────────┘                │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════   │
│                                                                     │
│  FOOD RULE COMPLIANCE                                               │
│  ─────────────────────                                              │
│                                                                     │
│  Rule                    Compliance    Violations                   │
│  ────────────────────────────────────────────────                  │
│  No grains               100%          0                           │
│  No legumes              100%          0                           │
│  No dairy                 85%          5                           │
│  No processed foods       98%          1                           │
│  No added sugar          100%          0                           │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════   │
│                                                                     │
│  FASTING COMPLIANCE                                                 │
│  ───────────────────                                                │
│                                                                     │
│  Days with 16+ hour fast: 26/31 (84%)                              │
│  Average fasting duration: 16.2 hours                              │
│  Longest fast: 18.5 hours (Jan 15)                                 │
│  Eating window violations: 5                                        │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════   │
│                                                                     │
│  VIOLATION LOG                                                      │
│  ─────────────                                                      │
│                                                                     │
│  Date       Time     Violation                                      │
│  ─────────────────────────────────────────────                     │
│  Jan 31    12:30 PM  Cheese (dairy)                                │
│  Jan 28     7:00 PM  Ice cream (dairy, sugar)                      │
│  Jan 25     1:15 PM  Bread (grains)                                │
│  Jan 22    10:30 AM  Coffee with cream before window               │
│  Jan 18     9:45 PM  Late snack outside eating window              │
│  ...                                                                │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════   │
│                                                                     │
│  TRENDS                                                             │
│  ──────                                                             │
│                                                                     │
│  [Weekly compliance trend chart]                                    │
│                                                                     │
│  Improvement: +8% from previous month                              │
│  Best week: Week 3 (96% compliance)                                │
│  Worst week: Week 1 (78% compliance)                               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 10. Database Schema

### 10.1 New Tables

```sql
-- Diet definitions
CREATE TABLE diets (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,
  preset_id TEXT,                    -- NULL for custom diets
  is_active INTEGER NOT NULL DEFAULT 1,
  start_date INTEGER,                -- For fixed-duration diets
  end_date INTEGER,
  eating_window_start INTEGER,       -- Minutes from midnight
  eating_window_end INTEGER,

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

-- Diet rules (for custom diets)
CREATE TABLE diet_rules (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  diet_id TEXT NOT NULL,
  rule_type INTEGER NOT NULL,        -- DietRuleType enum
  severity INTEGER NOT NULL,         -- RuleSeverity enum
  category INTEGER,                  -- FoodCategory enum (if applicable)
  ingredient_name TEXT,              -- For ingredient-specific rules
  numeric_value REAL,                -- For limits
  time_value INTEGER,                -- Minutes from midnight
  days_of_week TEXT,                 -- Comma-separated (for day-specific)
  description TEXT,
  violation_message TEXT,

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

  FOREIGN KEY (diet_id) REFERENCES diets(id) ON DELETE CASCADE
);

-- Food item category tags
CREATE TABLE food_item_categories (
  food_item_id TEXT NOT NULL,
  category INTEGER NOT NULL,         -- FoodCategory enum

  PRIMARY KEY (food_item_id, category),
  FOREIGN KEY (food_item_id) REFERENCES food_items(id) ON DELETE CASCADE
);

-- Diet violations log
CREATE TABLE diet_violations (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  diet_id TEXT NOT NULL,
  food_log_id TEXT NOT NULL,
  rule_id TEXT,                      -- NULL for preset rules
  rule_type INTEGER NOT NULL,
  severity INTEGER NOT NULL,
  message TEXT NOT NULL,
  timestamp INTEGER NOT NULL,

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

  FOREIGN KEY (diet_id) REFERENCES diets(id) ON DELETE CASCADE,
  FOREIGN KEY (food_log_id) REFERENCES food_logs(id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_diets_profile ON diets(profile_id, is_active);
CREATE INDEX idx_diet_rules_diet ON diet_rules(diet_id);
CREATE INDEX idx_food_categories_item ON food_item_categories(food_item_id);
CREATE INDEX idx_diet_violations_diet ON diet_violations(diet_id, timestamp DESC);
CREATE INDEX idx_diet_violations_profile ON diet_violations(profile_id, timestamp DESC);
```

### 10.2 Food Items Update

```sql
-- Add nutritional info columns to food_items
ALTER TABLE food_items ADD COLUMN serving_size REAL;
ALTER TABLE food_items ADD COLUMN serving_unit TEXT;
ALTER TABLE food_items ADD COLUMN calories REAL;
ALTER TABLE food_items ADD COLUMN carbs_grams REAL;
ALTER TABLE food_items ADD COLUMN fat_grams REAL;
ALTER TABLE food_items ADD COLUMN protein_grams REAL;
ALTER TABLE food_items ADD COLUMN fiber_grams REAL;
ALTER TABLE food_items ADD COLUMN sugar_grams REAL;
```

---

## 11. Notifications Integration

### 11.1 Diet-Related Notifications

> **CANONICAL SOURCE:** NotificationType enum is defined in `22_API_CONTRACTS.md` Section 3.2.

| NotificationType (value) | Trigger | Message |
|--------------------------|---------|---------|
| `fastingWindowOpen` (17) | Eating window opens | "Your eating window is now open (12 PM - 8 PM)" |
| `fastingWindowClose` (18) | 30 min before close | "Your eating window closes in 30 minutes" |
| `fastingWindowClosed` (19) | Window closes | "Fasting period has begun. Stay strong!" |
| `dietStreak` (20) | Milestone reached | "Amazing! You've been 100% compliant for 7 days!" |
| `dietWeeklySummary` (21) | Weekly | "Last week: 92% diet compliance. Great work!" |

---

## 12. Acceptance Criteria

### Diet Setup
- [ ] User can select from 20+ preset diets
- [ ] User can create custom diet with food/time/macro rules
- [ ] User can combine multiple diet types (e.g., Paleo + 16:8)
- [ ] User can set diet duration (ongoing or fixed period)
- [ ] User can modify eating window times

### Food Tagging
- [ ] Food items have category tags (meat, dairy, grains, etc.)
- [ ] Common foods are pre-tagged in system database
- [ ] User can edit category tags on custom food items
- [ ] Nutritional info is optional but enables macro tracking

### Compliance Tracking
- [ ] Real-time compliance percentage displayed
- [ ] Daily, weekly, monthly compliance scores calculated
- [ ] Compliance streak tracking with milestone alerts
- [ ] Trend charts show compliance over time

### Violation Alerts
- [ ] Pre-log warning shows before adding violating food
- [ ] Warning shows impact on compliance score
- [ ] Fasting window violations show countdown timer
- [ ] Macro limit warnings show current vs limit
- [ ] User can choose to log anyway or find alternatives

### Intermittent Fasting
- [ ] Live fasting timer shows hours/minutes fasted
- [ ] Visual timeline shows fasting vs eating periods
- [ ] "Current status" shows fasting or eating mode
- [ ] Weekly fasting log shows each day's fast duration

### Reporting
- [ ] Diet compliance report available as standalone PDF
- [ ] Report shows rule-by-rule compliance breakdown
- [ ] Report includes violation log with dates/times
- [ ] Report shows trend analysis and improvement

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release |
| 1.1 | 2026-02-02 | Updated Diet IDs to camelCase to match DietPresetType enum in 22_API_CONTRACTS.md |
