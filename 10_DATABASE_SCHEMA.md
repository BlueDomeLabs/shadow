# Shadow Database Schema

**Version:** 1.2
**Last Updated:** January 31, 2026
**Database:** SQLCipher (Encrypted SQLite)
**Current Schema Version:** 7

---

## Overview

Shadow uses SQLCipher for AES-256 encrypted local storage. The database contains 42 tables organized across user management, health tracking, intelligence, wearables, and synchronization.

---

## 1. Database Configuration

### 1.1 Encryption

```dart
// Database: SQLCipher with AES-256 encryption
// Key: 256-bit (32 bytes) stored in platform Keychain/KeyStore
// Database file: shadow.db
```

### 1.2 Initialization

```dart
// Foreign key constraints enabled
PRAGMA foreign_keys = ON;
```

---

## 2. Common Column Patterns

### 2.1 Client ID Column

All health data tables include a `client_id` column to identify the client/user account at a higher level than `profile_id`. This supports potential future database merging scenarios where multiple databases need to be combined while maintaining distinct client identities.

```sql
client_id TEXT NOT NULL,              -- Client identifier (higher level than profile)
```

**Purpose:**
- Identifies the client/user account across all their profiles
- Enables future database merging without ID conflicts
- Provides a consistent identifier for data ownership at the account level
- Different from `profile_id` which is for individual health data containers

**Usage:**
- Set to the `user_accounts.id` of the owning user when creating records
- Must be present on all health data tables
- Indexed for efficient querying by client

### 2.2 Sync Metadata Columns

All tables include these synchronization columns:

```sql
sync_created_at INTEGER NOT NULL,     -- Creation timestamp (ms since epoch)
sync_updated_at INTEGER,              -- Last update timestamp
sync_deleted_at INTEGER,              -- Soft delete marker (null = active)
sync_last_synced_at INTEGER,          -- Last cloud sync timestamp
sync_status INTEGER DEFAULT 0,        -- SyncStatus enum value
sync_version INTEGER DEFAULT 1,       -- Optimistic concurrency version
sync_device_id TEXT,                  -- Last modifying device
sync_is_dirty INTEGER DEFAULT 1,      -- Unsynchronized changes flag
conflict_data TEXT                    -- JSON of conflicting version
```

### 2.2 Sync Status Enum

CANONICAL: Must match 22_API_CONTRACTS.md SyncStatus enum exactly.

| Value | Status | Description |
|-------|--------|-------------|
| 0 | pending | Never synced or awaiting initial sync |
| 1 | synced | Successfully synced with cloud |
| 2 | modified | Modified locally since last sync |
| 3 | conflict | Conflict detected, needs resolution |
| 4 | deleted | Marked for deletion (soft delete) |

### 2.3 File Sync Columns

Tables with file attachments include:

```sql
cloud_storage_url TEXT,              -- Cloud storage URL
file_hash TEXT,                      -- SHA-256 hash for integrity
file_size_bytes INTEGER,             -- File size
is_file_uploaded INTEGER DEFAULT 0   -- Upload status
```

### 2.4 Conflict Resolution Strategy

When `sync_status = 2` (conflict), the following resolution strategies apply:

| Entity Type | Resolution Strategy | Rationale |
|-------------|---------------------|-----------|
| profiles | User choice required | Critical identity data |
| supplements | Last-write-wins (LWW) | Simple data, low conflict risk |
| intake_logs | Keep both | Historical records, merge possible |
| food_items | LWW | Reference data |
| food_logs | Keep both | Historical records |
| conditions | User choice required | Critical health data |
| condition_logs | Keep both | Historical records |
| activities | LWW | Reference data |
| activity_logs | Keep both | Historical records |
| sleep_entries | LWW | Single daily entry |
| journal_entries | Merge content | Append with separator |
| fluids_entries | LWW | Single daily entry |
| photo_entries | Keep both | Cannot merge images |
| notification_schedules | LWW | Configuration data |
| diets | LWW | Configuration data |
| hipaa_authorizations | Preserve restrictive | Security requirement |

**Conflict Resolution Process:**

```dart
// Resolution algorithm
if (localVersion.syncUpdatedAt > remoteVersion.syncUpdatedAt) {
  // Local wins, push to remote
  keepVersion = localVersion;
  discardVersion = remoteVersion;
} else {
  // Remote wins, overwrite local
  keepVersion = remoteVersion;
  discardVersion = localVersion;
}

// Store discarded version for 30 days
UPDATE entity SET
  conflict_data = jsonEncode(discardVersion),
  sync_status = 1  -- Mark as resolved
WHERE id = entityId;
```

**Manual Resolution Triggers:**

For entities marked "User choice required" (profiles, conditions), manual resolution triggers when:

1. **Both versions have meaningful changes** - Different fields modified on each device
2. **Critical data differs** - Names, primary identifiers, or severity levels differ
3. **Auto-resolution would lose data** - Both versions contain unique, non-mergeable content

```dart
class ConflictDetector {
  /// Determine if manual resolution is required
  bool requiresManualResolution<T extends Syncable>(T local, T remote) {
    // Always auto-resolve if timestamps differ by < 5 seconds (likely same edit)
    final timeDiff = (local.syncUpdatedAt - remote.syncUpdatedAt).abs();
    if (timeDiff < 5000) return false;

    // Check entity-specific rules
    return switch (T) {
      Profile => _profileConflict(local as Profile, remote as Profile),
      Condition => _conditionConflict(local as Condition, remote as Condition),
      _ => false, // Other entities use LWW
    };
  }

  bool _profileConflict(Profile local, Profile remote) {
    // Manual if name differs and both were modified
    return local.name != remote.name ||
           local.birthDate != remote.birthDate ||
           local.biologicalSex != remote.biologicalSex;
  }

  bool _conditionConflict(Condition local, Condition remote) {
    // Manual if name or severity logic differs
    return local.name != remote.name ||
           local.isActive != remote.isActive;
  }
}
```

**Conflict Resolution UI:**

When manual resolution is required, the app presents a side-by-side comparison:

```
┌─────────────────────────────────────────────────────────┐
│ Sync Conflict Detected                                   │
├─────────────────────────────────────────────────────────┤
│ Profile: John Doe                                        │
│                                                         │
│ ┌─────────────────────┐  ┌─────────────────────┐       │
│ │ This Device         │  │ Other Device        │       │
│ │ (Modified 2:30 PM)  │  │ (Modified 3:15 PM)  │       │
│ ├─────────────────────┤  ├─────────────────────┤       │
│ │ Name: John D.       │  │ Name: John Doe      │ ← Diff│
│ │ Birth: 1985-03-15   │  │ Birth: 1985-03-15   │       │
│ │ Notes: Updated diet │  │ Notes: Added allergy│ ← Diff│
│ └─────────────────────┘  └─────────────────────┘       │
│                                                         │
│ [Keep This Device]  [Keep Other Device]  [Merge Notes] │
└─────────────────────────────────────────────────────────┘
```

**Conflict Timeout:**

- Conflicts must be resolved within **7 days** of detection
- After 7 days, system auto-resolves using Last-Write-Wins
- User is notified before auto-resolution
- Discarded version stored in `conflict_data` for 30 additional days

### 2.5 Soft Delete Cascade Rules

When a parent entity is soft-deleted (`sync_deleted_at` set), child records are handled as follows:

| Parent Table | Child Table | Cascade Rule | Rationale |
|--------------|-------------|--------------|-----------|
| profiles | supplements | Soft delete children | Privacy: hide all profile data |
| profiles | conditions | Soft delete children | Privacy |
| profiles | food_items | Soft delete children | Privacy |
| profiles | activities | Soft delete children | Privacy |
| profiles | journal_entries | Soft delete children | Privacy |
| profiles | photo_areas | Soft delete children | Privacy |
| supplements | intake_logs | Keep (orphaned) | Historical records valuable |
| supplements | notification_schedules | Hard delete | Config tied to supplement |
| conditions | condition_logs | Keep (orphaned) | Historical records valuable |
| conditions | flare_ups | Soft delete | Related to condition |
| diets | diet_rules | Hard delete | Config tied to diet |
| diets | diet_violations | Keep (orphaned) | Historical compliance data |
| photo_areas | photo_entries | Soft delete | Related photos |

**Implementation:**

```sql
-- Example: Soft delete cascade trigger for profiles → supplements
CREATE TRIGGER soft_delete_profile_supplements
AFTER UPDATE ON profiles
WHEN NEW.sync_deleted_at IS NOT NULL AND OLD.sync_deleted_at IS NULL
BEGIN
  UPDATE supplements
  SET sync_deleted_at = NEW.sync_deleted_at,
      sync_updated_at = NEW.sync_updated_at,
      sync_is_dirty = 1
  WHERE profile_id = NEW.id AND sync_deleted_at IS NULL;
END;
```

### 2.6 Deletion Recovery Window

Soft-deleted records can be recovered within a defined window before permanent deletion:

| Recovery Window | Duration | Applies To |
|-----------------|----------|------------|
| User-initiated | 30 days | All PHI records (supplements, conditions, entries) |
| Profile deletion | 90 days | Entire profile and cascaded children |
| Account deletion | 90 days | User account and all owned profiles |
| Audit logs | Never deletable | Required for HIPAA compliance |

**Recovery Process:**

```dart
/// Recover a soft-deleted entity within the recovery window
Future<Result<void, AppError>> recoverEntity(String tableName, String id) async {
  // 1. Check if within recovery window (30 days for PHI)
  final deletedAt = await _getDeletedAt(tableName, id);
  if (deletedAt == null) {
    return Failure(EntityError.notFound(tableName, id));
  }

  final recoveryDeadline = deletedAt.add(Duration(days: 30));
  if (DateTime.now().isAfter(recoveryDeadline)) {
    return Failure(EntityError.recoveryWindowExpired());
  }

  // 2. Clear soft delete marker
  await _database.update(tableName,
    {'sync_deleted_at': null, 'sync_updated_at': DateTime.now().millisecondsSinceEpoch},
    where: 'id = ?', whereArgs: [id],
  );

  return Success(null);
}
```

**Permanent Deletion (After Recovery Window):**

```sql
-- Scheduled job: Permanently delete records past recovery window
DELETE FROM supplements
WHERE sync_deleted_at IS NOT NULL
  AND sync_deleted_at < (strftime('%s', 'now') - 30 * 24 * 60 * 60) * 1000;

-- For profiles (90-day window)
DELETE FROM profiles
WHERE sync_deleted_at IS NOT NULL
  AND sync_deleted_at < (strftime('%s', 'now') - 90 * 24 * 60 * 60) * 1000;
```

**Cloud Storage Deletion:**

1. Mark local record as deleted (sync_deleted_at set)
2. Sync deletion to cloud on next sync
3. Cloud marks record with deletion timestamp
4. After recovery window, scheduled job permanently deletes from both local and cloud
5. Verify deletion succeeded before removing local record
6. Log deletion to audit table for HIPAA compliance

### 2.7 Sync Metadata Exemptions

The following tables are **exempt** from standard sync metadata columns and do NOT sync to cloud storage:

| Table | Reason | Columns Omitted |
|-------|--------|-----------------|
| `profile_access_logs` | Immutable audit trail - local-only for compliance | All sync_* columns |
| `imported_data_log` | Import deduplication only - device-specific | All sync_* columns |
| `refresh_token_usage` | Security artifact - device-local token tracking | All sync_* columns |
| `pairing_sessions` | Ephemeral - device-local session management | All sync_* columns |
| `fhir_exports` | Export metadata - device-specific record | All sync_* columns |
| `food_item_categories` | Junction table - syncs via parent food_items | All sync_* columns |

**Note:** `ml_models` and `prediction_feedback` tables DO have sync metadata columns and are syncable. They were previously listed here in error but are standard syncable tables.

**Rationale:**
- **Security tables** (`refresh_token_usage`, `pairing_sessions`): Security artifacts must not leave the device
- **Audit tables** (`profile_access_logs`): Immutable compliance records, write-once
- **Export tables** (`fhir_exports`): Records of what was exported from this device
- **Import tables** (`imported_data_log`): Deduplication for imports to this device
- **Junction tables** (`food_item_categories`): Follows parent entity sync via CASCADE delete

**Code Review Requirement:** Any new table without sync metadata MUST be added to this list with justification.

---

## 3. User & Access Control Tables

### 3.1 user_accounts

Stores user authentication and account information.

```sql
CREATE TABLE user_accounts (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,           -- Client identifier for database merging support
  email TEXT NOT NULL UNIQUE,
  display_name TEXT,
  photo_url TEXT,
  auth_provider INTEGER NOT NULL,    -- 0: google, 1: apple
  auth_provider_id TEXT NOT NULL,    -- External provider's user ID
  created_at INTEGER NOT NULL,       -- Milliseconds since epoch
  last_login_at INTEGER,
  is_active INTEGER DEFAULT 1,       -- Account active status
  deactivated_reason TEXT,           -- Reason if deactivated

  -- Sync metadata
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER,
  sync_deleted_at INTEGER,
  sync_last_synced_at INTEGER,
  sync_status INTEGER DEFAULT 0,
  sync_version INTEGER DEFAULT 1,
  sync_device_id TEXT,
  sync_is_dirty INTEGER DEFAULT 1,
  conflict_data TEXT
);

CREATE INDEX idx_user_accounts_email ON user_accounts(email);
CREATE INDEX idx_user_accounts_role ON user_accounts(role);
```

### 3.2 profiles

User health profiles containing all health tracking data.

```sql
CREATE TABLE profiles (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  name TEXT NOT NULL,
  birth_date INTEGER,              -- Milliseconds since epoch
  biological_sex INTEGER,          -- 0: male, 1: female, 2: other
  ethnicity TEXT,
  notes TEXT,
  owner_id TEXT,                   -- FK → user_accounts(id)
  diet_type INTEGER,               -- ProfileDietType enum: 0=none, 1=vegan, 2=vegetarian, 3=paleo, 4=keto, 5=glutenFree, 6=other
  diet_description TEXT,           -- Custom description when diet_type=6 (other)

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

  FOREIGN KEY (owner_id) REFERENCES user_accounts(id) ON DELETE SET NULL
);

CREATE INDEX idx_profiles_deleted ON profiles(sync_deleted_at);
CREATE INDEX idx_profiles_sync ON profiles(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
CREATE INDEX idx_profiles_owner ON profiles(owner_id);
```

### 3.3 profile_access

Manages shared access to profiles for multi-user scenarios.

```sql
CREATE TABLE profile_access (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  user_account_id TEXT NOT NULL,
  access_level TEXT NOT NULL,      -- 'readOnly' | 'readWrite' | 'owner'
  granted_at INTEGER NOT NULL,
  granted_by TEXT NOT NULL,
  expires_at INTEGER,
  notes TEXT,

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

  UNIQUE(profile_id, user_account_id),
  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (user_account_id) REFERENCES user_accounts(id) ON DELETE CASCADE
);

CREATE INDEX idx_profile_access_profile ON profile_access(profile_id, user_account_id);
CREATE INDEX idx_profile_access_user ON profile_access(user_account_id, access_level);
CREATE INDEX idx_profile_access_granted_by ON profile_access(granted_by);
CREATE INDEX idx_profile_access_client ON profile_access(client_id);
```

### 3.4 device_registrations

Tracks devices registered for multi-device access control.

```sql
CREATE TABLE device_registrations (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,           -- Client identifier for database merging support
  user_account_id TEXT NOT NULL,
  device_id TEXT NOT NULL,
  device_name TEXT NOT NULL,
  device_type TEXT NOT NULL,         -- 'ios' | 'android' | 'macos' | 'web'
  device_model TEXT,                 -- e.g., "iPhone 15 Pro", "Pixel 8"
  os_version TEXT,                   -- e.g., "iOS 17.2", "Android 14"
  app_version TEXT,                  -- e.g., "1.2.3" - Shadow app version
  push_token TEXT,                   -- FCM/APNs token for push notifications
  registered_at INTEGER NOT NULL,
  last_seen_at INTEGER NOT NULL,
  is_active INTEGER DEFAULT 1,

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

  UNIQUE(user_account_id, device_id),
  FOREIGN KEY (user_account_id) REFERENCES user_accounts(id) ON DELETE CASCADE
);

CREATE INDEX idx_device_registrations_client ON device_registrations(client_id);

CREATE INDEX idx_device_registrations_user ON device_registrations(user_account_id, is_active);
CREATE INDEX idx_device_registrations_device ON device_registrations(device_id);
```

---

## 4. Supplement Tracking Tables

### 4.1 supplements

Supplement products with detailed scheduling information.

```sql
CREATE TABLE supplements (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,              -- Supplement name (e.g., "Vitamin D3", "Magnesium Glycinate")
  form INTEGER NOT NULL,           -- SupplementForm enum: 0=capsule, 1=powder, 2=liquid, 3=tablet, 4=other
  custom_form TEXT,                -- User-defined form when form=4 (other)
  dosage_quantity INTEGER NOT NULL,-- Number of units per dose (e.g., 2 capsules)
  dosage_unit INTEGER NOT NULL,    -- DosageUnit enum: 0=g, 1=mg, 2=mcg, 3=IU, 4=HDU, 5=ml, 6=drops, 7=tsp, 8=custom
  brand TEXT DEFAULT '',           -- Brand name (optional)
  notes TEXT DEFAULT '',           -- User notes (optional)
  ingredients TEXT DEFAULT '[]',   -- JSON array of SupplementIngredient
  schedules TEXT DEFAULT '[]',     -- JSON array of SupplementSchedule
  start_date INTEGER,              -- Epoch ms - When to start taking (null = immediately)
  end_date INTEGER,                -- Epoch ms - When to stop taking (null = ongoing)
  is_archived INTEGER DEFAULT 0,   -- 0: active, 1: archived (temporarily stopped)

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

CREATE INDEX idx_supplements_profile ON supplements(profile_id, sync_deleted_at);
CREATE INDEX idx_supplements_active ON supplements(profile_id, is_archived)
  WHERE sync_deleted_at IS NULL AND is_archived = 0;
CREATE INDEX idx_supplements_sync ON supplements(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
CREATE INDEX idx_supplements_profile_active ON supplements(profile_id)
  WHERE sync_deleted_at IS NULL;
```

### 4.2 intake_logs

Supplement intake tracking.

```sql
CREATE TABLE intake_logs (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  supplement_id TEXT NOT NULL,
  scheduled_time INTEGER NOT NULL,
  actual_time INTEGER,
  status INTEGER NOT NULL,         -- 0: pending, 1: taken, 2: skipped, 3: missed, 4: snoozed
  reason TEXT,
  note TEXT,
  snooze_duration_minutes INTEGER, -- 5/10/15/30/60 min when status=snoozed

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

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (supplement_id) REFERENCES supplements(id) ON DELETE CASCADE
);

CREATE INDEX idx_intake_logs_scheduled ON intake_logs(scheduled_time DESC);
CREATE INDEX idx_intake_logs_profile_date ON intake_logs(profile_id, scheduled_time DESC);
CREATE INDEX idx_intake_logs_supplement ON intake_logs(supplement_id, scheduled_time DESC);
CREATE INDEX idx_intake_logs_status ON intake_logs(status, scheduled_time DESC);
CREATE INDEX idx_intake_logs_sync ON intake_logs(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

---

## 5. Food Tracking Tables

### 5.1 food_items

Reusable food items (simple or complex).

```sql
CREATE TABLE food_items (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,
  type INTEGER NOT NULL,           -- 0: simple, 1: complex
  simple_item_ids TEXT,            -- Comma-separated IDs (for complex items)
  is_user_created INTEGER NOT NULL DEFAULT 1,
  is_archived INTEGER DEFAULT 0,   -- 0: active, 1: archived (e.g., during elimination diet)

  -- Nutritional information (optional)
  serving_size REAL,               -- Numeric serving size value
  serving_unit TEXT,               -- Unit of serving (e.g., "cup", "g")
  calories REAL,                   -- kcal per serving
  carbs_grams REAL,                -- Carbohydrates in grams
  fat_grams REAL,                  -- Fat in grams
  protein_grams REAL,              -- Protein in grams
  fiber_grams REAL,                -- Fiber in grams
  sugar_grams REAL,                -- Sugar in grams

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

CREATE INDEX idx_food_items_profile ON food_items(profile_id, type);
CREATE INDEX idx_food_items_active ON food_items(profile_id, is_archived)
  WHERE sync_deleted_at IS NULL AND is_archived = 0;
CREATE INDEX idx_food_items_sync ON food_items(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

### 5.2 food_logs

Food consumption logs.

```sql
CREATE TABLE food_logs (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  meal_type INTEGER,               -- 0: breakfast, 1: lunch, 2: dinner, 3: snack (nullable)
  food_item_ids TEXT NOT NULL,     -- Comma-separated IDs
  ad_hoc_items TEXT NOT NULL,      -- Comma-separated names
  notes TEXT,

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

CREATE INDEX idx_food_logs_timestamp ON food_logs(timestamp DESC);
CREATE INDEX idx_food_logs_profile_date ON food_logs(profile_id, timestamp DESC);
CREATE INDEX idx_food_logs_sync ON food_logs(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

---

## 6. Activity Tracking Tables

### 6.1 activities

Reusable activity definitions.

```sql
CREATE TABLE activities (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  location TEXT,
  triggers TEXT,                   -- Comma-separated trigger descriptions
  duration_minutes INTEGER NOT NULL,
  is_archived INTEGER DEFAULT 0,   -- 0: active, 1: archived (seasonal/paused, can reactivate)

  -- Sync metadata (sync_created_at doubles as created_at)
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

CREATE INDEX idx_activities_profile_date ON activities(profile_id, sync_created_at DESC);
CREATE INDEX idx_activities_active ON activities(profile_id, is_archived)
  WHERE sync_deleted_at IS NULL AND is_archived = 0;
CREATE INDEX idx_activities_created ON activities(sync_created_at DESC);
CREATE INDEX idx_activities_sync ON activities(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

### 6.2 activity_logs

Activity instances (when activities were performed).

```sql
CREATE TABLE activity_logs (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  activity_ids TEXT NOT NULL,      -- Comma-separated IDs
  ad_hoc_activities TEXT NOT NULL, -- Comma-separated names
  duration INTEGER,                -- Actual duration if different
  notes TEXT,

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

CREATE INDEX idx_activity_logs_timestamp ON activity_logs(timestamp DESC);
CREATE INDEX idx_activity_logs_profile ON activity_logs(profile_id, timestamp DESC);
CREATE INDEX idx_activity_logs_sync ON activity_logs(sync_is_dirty, sync_status);
```

---

## 7. Sleep Tracking Table

### 7.1 sleep_entries

Sleep tracking data.

```sql
CREATE TABLE sleep_entries (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  bed_time INTEGER NOT NULL,
  wake_time INTEGER,
  deep_sleep_minutes INTEGER NOT NULL DEFAULT 0,
  light_sleep_minutes INTEGER NOT NULL DEFAULT 0,
  restless_sleep_minutes INTEGER NOT NULL DEFAULT 0,
  dream_type INTEGER NOT NULL DEFAULT 0,    -- 0: noDreams, 1: vague, 2: vivid, 3: nightmares
  waking_feeling INTEGER NOT NULL DEFAULT 1, -- 0: unrested, 1: neutral, 2: rested
  notes TEXT,

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

CREATE INDEX idx_sleep_entries_bed_time ON sleep_entries(bed_time DESC);
CREATE INDEX idx_sleep_entries_profile_date ON sleep_entries(profile_id, bed_time DESC);
CREATE INDEX idx_sleep_entries_sync ON sleep_entries(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

---

## 8. Journal & Documents Tables

### 8.1 journal_entries

User journal/notes.

```sql
CREATE TABLE journal_entries (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  content TEXT NOT NULL,
  title TEXT,
  mood INTEGER,                    -- Mood rating 1-10, optional
  tags TEXT,                       -- Comma-separated tags
  audio_url TEXT,

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

CREATE INDEX idx_journal_entries_timestamp ON journal_entries(timestamp DESC);
CREATE INDEX idx_journal_entries_profile_date ON journal_entries(profile_id, timestamp DESC);
CREATE INDEX idx_journal_entries_sync ON journal_entries(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

### 8.2 documents

Medical documents and files.

```sql
CREATE TABLE documents (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,           -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,                -- User-friendly document name
  document_type INTEGER NOT NULL,    -- DocumentType enum: 0: medical, 1: prescription, 2: lab, 3: insurance, 4: other
  notes TEXT,
  document_date INTEGER,             -- Date of the document (Epoch ms)
  uploaded_at INTEGER NOT NULL,      -- When uploaded to app (Epoch ms)
  file_path TEXT NOT NULL,           -- Local file path
  file_size_bytes INTEGER,
  mime_type TEXT,

  -- File sync metadata
  cloud_storage_url TEXT,
  file_hash TEXT,
  is_file_uploaded INTEGER DEFAULT 0,

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

CREATE INDEX idx_documents_profile_date ON documents(profile_id, uploaded_at DESC);
CREATE INDEX idx_documents_type ON documents(type, uploaded_at DESC);
CREATE INDEX idx_documents_sync ON documents(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

---

## 9. Condition Tracking Tables

### 9.1 conditions

Health conditions being tracked.

```sql
CREATE TABLE conditions (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  body_locations TEXT NOT NULL,    -- JSON array
  triggers TEXT DEFAULT '[]',     -- JSON array of predefined trigger strings
  description TEXT,
  baseline_photo_path TEXT,
  start_timeframe INTEGER NOT NULL,  -- Epoch milliseconds (consistent with other timestamps)
  end_date INTEGER,                   -- Epoch milliseconds
  status TEXT NOT NULL,            -- 'active' | 'resolved'
  is_archived INTEGER DEFAULT 0,   -- 0: active, 1: archived (in remission, can reactivate)
  activity_id TEXT,

  -- File sync metadata
  cloud_storage_url TEXT,
  file_hash TEXT,
  file_size_bytes INTEGER,
  is_file_uploaded INTEGER DEFAULT 0,

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

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE SET NULL
);

CREATE INDEX idx_conditions_profile_status ON conditions(profile_id, status);
CREATE INDEX idx_conditions_active ON conditions(profile_id, is_archived)
  WHERE sync_deleted_at IS NULL AND is_archived = 0;
CREATE INDEX idx_conditions_status ON conditions(status, sync_created_at DESC);
CREATE INDEX idx_conditions_sync ON conditions(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
CREATE INDEX idx_conditions_activity ON conditions(activity_id)
  WHERE activity_id IS NOT NULL;
```

### 9.2 condition_logs

Logs documenting condition episodes/severity.

```sql
CREATE TABLE condition_logs (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  condition_id TEXT NOT NULL,
  timestamp INTEGER NOT NULL,      -- Milliseconds since epoch (consistent with other tables)
  severity INTEGER NOT NULL,       -- 1-10 scale
  notes TEXT,
  is_flare INTEGER NOT NULL,
  flare_photo_ids TEXT NOT NULL,   -- Comma-separated photo entry IDs
  photo_path TEXT,
  activity_id TEXT,
  triggers TEXT,

  -- File sync metadata
  cloud_storage_url TEXT,
  file_hash TEXT,
  file_size_bytes INTEGER,
  is_file_uploaded INTEGER DEFAULT 0,

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

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (condition_id) REFERENCES conditions(id) ON DELETE CASCADE,
  FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE SET NULL
);

CREATE INDEX idx_condition_logs_condition_date ON condition_logs(condition_id, timestamp DESC);
CREATE INDEX idx_condition_logs_flare ON condition_logs(is_flare, timestamp DESC)
  WHERE is_flare = 1;
CREATE INDEX idx_condition_logs_profile_date ON condition_logs(profile_id, timestamp DESC);
CREATE INDEX idx_condition_logs_profile_flare ON condition_logs(profile_id, is_flare, timestamp DESC);
CREATE INDEX idx_condition_logs_sync ON condition_logs(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
CREATE INDEX idx_condition_logs_activity ON condition_logs(activity_id)
  WHERE activity_id IS NOT NULL;
```

### 9.3 flare_ups

Acute condition episodes.

```sql
CREATE TABLE flare_ups (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  condition_id TEXT NOT NULL,
  start_date INTEGER NOT NULL,     -- Epoch milliseconds - flare-up start
  end_date INTEGER,                -- Epoch milliseconds - flare-up end (null = ongoing)
  severity INTEGER NOT NULL,       -- 1-10 scale
  notes TEXT,
  triggers TEXT NOT NULL,          -- JSON array of trigger descriptions
  activity_id TEXT,                -- Activity that may have triggered flare-up
  photo_path TEXT,

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

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (condition_id) REFERENCES conditions(id) ON DELETE CASCADE,
  FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE SET NULL
);

CREATE INDEX idx_flare_ups_condition ON flare_ups(condition_id, start_date DESC);
CREATE INDEX idx_flare_ups_profile ON flare_ups(profile_id, start_date DESC);
CREATE INDEX idx_flare_ups_sync ON flare_ups(sync_is_dirty, sync_status);
CREATE INDEX idx_flare_ups_activity ON flare_ups(activity_id)
  WHERE activity_id IS NOT NULL;
```

### 9.4 condition_categories

Custom condition categories per profile.

```sql
CREATE TABLE condition_categories (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,

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

CREATE INDEX idx_condition_categories_profile ON condition_categories(profile_id, name);
```

---

## 10. Fluids Tracking Tables

### 10.1 fluids_entries (formerly bowel_urine_entries)

Comprehensive fluids tracking including water intake, bowel movements, urination, menstruation, basal body temperature, and customizable "other" fluids.

```sql
CREATE TABLE fluids_entries (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  entry_date INTEGER NOT NULL,     -- Epoch milliseconds (maps to entity field entryDate)

  -- Water intake tracking
  water_intake_ml INTEGER,         -- Water consumed in milliliters
  water_intake_notes TEXT,         -- Optional notes about water intake

  -- Bowel tracking
  has_bowel_movement INTEGER DEFAULT 0,
  bowel_condition INTEGER,         -- BowelCondition: 0=diarrhea, 1=runny, 2=loose, 3=normal, 4=firm, 5=hard, 6=custom
  bowel_custom_condition TEXT,
  bowel_size INTEGER,              -- 0: tiny, 1: small, 2: medium, 3: large, 4: huge
  bowel_photo_path TEXT,

  -- Urine tracking
  has_urine_movement INTEGER DEFAULT 0,
  urine_condition INTEGER,         -- UrineCondition: 0=clear, 1=lightYellow, 2=yellow, 3=darkYellow, 4=amber, 5=brown, 6=red, 7=custom
  urine_custom_condition TEXT,
  urine_size INTEGER,
  urine_photo_path TEXT,

  -- Menstruation tracking (new in v4)
  menstruation_flow INTEGER,       -- MenstruationFlow: 0=none, 1=spotty, 2=light, 3=medium, 4=heavy

  -- Basal body temperature tracking (new in v4)
  basal_body_temperature REAL,     -- Temperature in user's preferred unit (°F or °C)
  bbt_recorded_time INTEGER,       -- Time temperature was recorded (ms since epoch)

  -- Customizable "Other" fluid tracking (new in v4)
  other_fluid_name TEXT,           -- User-defined fluid name (free text, max 100 chars, e.g., "Sweat", "Mucus", "Discharge")
  other_fluid_amount TEXT,         -- User-defined amount description
  other_fluid_notes TEXT,          -- Notes about the custom fluid

  -- Import tracking
  import_source TEXT,              -- Source of imported data (e.g., wearable platform)
  import_external_id TEXT,         -- External ID from import source

  -- File sync metadata (for bowel/urine photos)
  cloud_storage_url TEXT,
  file_hash TEXT,
  file_size_bytes INTEGER,
  is_file_uploaded INTEGER DEFAULT 0,

  -- General
  notes TEXT DEFAULT '',           -- Free-text notes
  photo_ids TEXT DEFAULT '[]',     -- JSON array of photo IDs

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

CREATE INDEX idx_fluids_timestamp ON fluids_entries(entry_date DESC);
CREATE INDEX idx_fluids_profile_date ON fluids_entries(profile_id, entry_date DESC);
CREATE INDEX idx_fluids_sync ON fluids_entries(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
CREATE INDEX idx_fluids_menstruation ON fluids_entries(profile_id, menstruation_flow, entry_date DESC)
  WHERE menstruation_flow IS NOT NULL AND menstruation_flow > 0;
CREATE INDEX idx_fluids_bbt ON fluids_entries(profile_id, bbt_recorded_time DESC)
  WHERE basal_body_temperature IS NOT NULL;
```

### 10.2 bowel_urine_logs

Simplified bowel/urine logs.

```sql
CREATE TABLE bowel_urine_logs (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  type_id TEXT NOT NULL,
  note TEXT,

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

CREATE INDEX idx_bowel_urine_logs_timestamp ON bowel_urine_logs(timestamp DESC);
CREATE INDEX idx_bowel_urine_logs_profile ON bowel_urine_logs(profile_id, timestamp DESC);
CREATE INDEX idx_bowel_urine_logs_sync ON bowel_urine_logs(sync_is_dirty, sync_status);
```

---

## 11. Photo Tracking Tables

### 11.1 photo_areas

Named photo areas for body location tracking.

```sql
CREATE TABLE photo_areas (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,                -- Area description
  consistency_notes TEXT,          -- Guidance for consistent photo positioning
  sort_order INTEGER DEFAULT 0,    -- Display order
  is_archived INTEGER DEFAULT 0,   -- Soft delete flag

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

CREATE INDEX idx_photo_areas_profile ON photo_areas(profile_id);
CREATE INDEX idx_photo_areas_sync ON photo_areas(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

### 11.2 photo_entries

Individual photo instances.

```sql
CREATE TABLE photo_entries (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  area_id TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  file_path TEXT NOT NULL,
  notes TEXT,

  -- File sync metadata
  cloud_storage_url TEXT,
  file_hash TEXT,
  file_size_bytes INTEGER,
  is_file_uploaded INTEGER DEFAULT 0,

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

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (area_id) REFERENCES photo_areas(id) ON DELETE CASCADE
);

CREATE INDEX idx_photo_entries_area_date ON photo_entries(area_id, timestamp DESC);
CREATE INDEX idx_photo_entries_profile_date ON photo_entries(profile_id, timestamp DESC);
CREATE INDEX idx_photo_entries_upload ON photo_entries(is_file_uploaded, profile_id);
CREATE INDEX idx_photo_entries_sync ON photo_entries(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

---

## 12. Notification Schedules Table

### 12.1 notification_schedules

Notification reminder configurations per profile.

```sql
CREATE TABLE notification_schedules (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,         -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  type INTEGER NOT NULL,           -- NotificationType enum (25 values, see below)
  entity_id TEXT,                  -- Optional: linked entity (e.g., supplement_id for supplement reminders)
  times_minutes TEXT NOT NULL,     -- JSON array of minutes from midnight: [480, 720] = 8am, 12pm
  weekdays TEXT NOT NULL,          -- JSON array of weekdays: [0,1,2,3,4,5,6] = all days (0=Mon)
  is_enabled INTEGER NOT NULL DEFAULT 1,
  custom_message TEXT,             -- Optional custom notification message

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

-- NotificationType enum values (MUST match 22_API_CONTRACTS.md exactly):
-- 0  = supplementIndividual   -- Individual supplement reminder
-- 1  = supplementGrouped      -- Grouped supplement reminder (all due at same time)
-- 2  = mealBreakfast          -- Breakfast reminder
-- 3  = mealLunch              -- Lunch reminder
-- 4  = mealDinner             -- Dinner reminder
-- 5  = mealSnacks             -- Snack reminder
-- 6  = waterInterval          -- Water reminder at regular intervals
-- 7  = waterFixed             -- Water reminder at fixed times
-- 8  = waterSmart             -- Smart water reminder based on intake
-- 9  = bbtMorning             -- Basal body temperature reminder
-- 10 = menstruationTracking   -- Menstruation tracking reminder
-- 11 = sleepBedtime           -- Bedtime reminder
-- 12 = sleepWakeup            -- Wake-up reminder
-- 13 = conditionCheckIn       -- Condition severity check-in
-- 14 = photoReminder          -- Photo documentation reminder
-- 15 = journalPrompt          -- Journal entry prompt
-- 16 = syncReminder           -- Cloud sync reminder
-- 17 = fastingWindowOpen      -- Eating window opening (IF diets)
-- 18 = fastingWindowClose     -- Eating window closing (IF diets)
-- 19 = fastingWindowClosed    -- Alert when fasting period begins
-- 20 = dietStreak             -- Diet compliance streak notification
-- 21 = dietWeeklySummary      -- Weekly diet compliance summary
-- 22 = fluidsGeneral          -- General fluids tracking reminders
-- 23 = fluidsBowel            -- Bowel movement tracking reminders
-- 24 = inactivity             -- Re-engagement after extended absence

CREATE INDEX idx_notification_schedules_profile ON notification_schedules(profile_id, type);
CREATE INDEX idx_notification_schedules_enabled ON notification_schedules(profile_id, is_enabled)
  WHERE sync_deleted_at IS NULL AND is_enabled = 1;
CREATE INDEX idx_notification_schedules_entity ON notification_schedules(entity_id)
  WHERE entity_id IS NOT NULL;
CREATE INDEX idx_notification_schedules_sync ON notification_schedules(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

---

## 13. Entity Relationship Diagram

```
user_accounts (1) ─────────────────┬──────────────── (M) profiles [has client_id]
                                   │
                                   ├──────────────── (M) profile_access
                                   │
                                   └──────────────── (M) device_registrations

client_id ─────────────────────────┐
(from user_accounts.id)            │ All health data tables include client_id
                                   │ for future database merging support
                                   ▼

profiles (1) ──────────────────────┬──────────────── (M) supplements [has client_id]
                                   │                      │
                                   │                      └── (M) intake_logs [has client_id]
                                   │
                                   ├──────────────── (M) food_items [has client_id]
                                   │                      │
                                   ├──────────────── (M) food_logs [has client_id]
                                   │
                                   ├──────────────── (M) activities [has client_id]
                                   │                      │
                                   ├──────────────── (M) activity_logs [has client_id]
                                   │
                                   ├──────────────── (M) sleep_entries [has client_id]
                                   │
                                   ├──────────────── (M) journal_entries [has client_id]
                                   │
                                   ├──────────────── (M) documents [has client_id]
                                   │
                                   ├──────────────── (M) conditions [has client_id]
                                   │                      │
                                   │                      ├── (M) condition_logs [has client_id]
                                   │                      │
                                   │                      └── (M) flare_ups [has client_id]
                                   │
                                   ├──────────────── (M) condition_categories [has client_id]
                                   │
                                   ├──────────────── (M) fluids_entries [has client_id]
                                   │                      (water, bowel, urine, menstruation, BBT, other)
                                   │
                                   ├──────────────── (M) notification_schedules [has client_id]
                                   │
                                   ├──────────────── (M) diets [has client_id]
                                   │                      │
                                   │                      ├── (M) diet_rules [has client_id]
                                   │                      │
                                   │                      └── (M) diet_violations [has client_id]
                                   │
                                   └──────────────── (M) photo_areas [has client_id]
                                                          │
                                                          └── (M) photo_entries [has client_id]

food_items (1) ────────────────────── (M) food_item_categories
```

---

## 14. Migration History

### Version 1 → 2

Added `profile_id` to tables missing it:
- `flare_ups`
- `activity_logs`
- `bowel_urine_logs`

### Version 2 → 3

Renamed column across all tables:
- `is_dirty` → `sync_is_dirty`

Added foreign key indexes for performance.

### Version 3 → 4

**Client ID addition (for future database merging):**
- Added `client_id TEXT NOT NULL` column to all health data tables
- This identifies the client/user account at a higher level than profile_id
- Enables merging databases from multiple sources without ID conflicts

**Archive functionality (for temporary deactivation):**
- Added `is_archived INTEGER DEFAULT 0` to `supplements` table
- Added `is_archived INTEGER DEFAULT 0` to `food_items` table
- Added `is_archived INTEGER DEFAULT 0` to `conditions` table
- Added `is_archived INTEGER DEFAULT 0` to `activities` table
- Archive vs Delete: Archived items can be reactivated later; deleted items are permanently removed
- Use case: Supplements temporarily stopped, foods excluded during elimination diet, conditions in remission

**Fluids table enhancements:**
- Renamed `bowel_urine_entries` → `fluids_entries`
- Added `water_intake_ml INTEGER` column for water tracking
- Added `water_intake_notes TEXT` column
- Added `menstruation_flow INTEGER` column
- Added `basal_body_temperature REAL` column
- Added `bbt_recorded_time INTEGER` column
- Added `other_fluid_name TEXT` column for customizable fluid tracking
- Added `other_fluid_amount TEXT` column
- Added `other_fluid_notes TEXT` column
- Added indexes for menstruation, BBT, and water intake queries

**Profile enhancements:**
- Added `client_id TEXT NOT NULL` column
- Added `diet_type INTEGER` column
- Added `diet_description TEXT` column

**New table:**
- Created `notification_schedules` table for reminder configurations

**Migration SQL:**
```sql
-- Add client_id to all health data tables
ALTER TABLE profiles ADD COLUMN client_id TEXT;
UPDATE profiles SET client_id = owner_id WHERE client_id IS NULL;
ALTER TABLE supplements ADD COLUMN client_id TEXT;
UPDATE supplements SET client_id = (SELECT client_id FROM profiles WHERE profiles.id = supplements.profile_id);
-- Repeat for all health data tables...

-- Add is_archived to archivable tables (all default to 0 = active)
ALTER TABLE supplements ADD COLUMN is_archived INTEGER DEFAULT 0;
ALTER TABLE food_items ADD COLUMN is_archived INTEGER DEFAULT 0;
ALTER TABLE conditions ADD COLUMN is_archived INTEGER DEFAULT 0;
ALTER TABLE activities ADD COLUMN is_archived INTEGER DEFAULT 0;

-- Add client_id to profile_access for merge support
ALTER TABLE profile_access ADD COLUMN client_id TEXT;
UPDATE profile_access SET client_id = (SELECT client_id FROM profiles WHERE profiles.id = profile_access.profile_id);
CREATE INDEX idx_profile_access_client ON profile_access(client_id);

-- Fluids features (add to bowel_urine_entries, then rename)
ALTER TABLE bowel_urine_entries ADD COLUMN water_intake_ml INTEGER;
ALTER TABLE bowel_urine_entries ADD COLUMN water_intake_notes TEXT;
ALTER TABLE bowel_urine_entries ADD COLUMN menstruation_flow INTEGER;
ALTER TABLE bowel_urine_entries ADD COLUMN basal_body_temperature REAL;
ALTER TABLE bowel_urine_entries ADD COLUMN bbt_recorded_time INTEGER;
ALTER TABLE bowel_urine_entries ADD COLUMN other_fluid_name TEXT;
ALTER TABLE bowel_urine_entries ADD COLUMN other_fluid_amount TEXT;
ALTER TABLE bowel_urine_entries ADD COLUMN other_fluid_notes TEXT;
ALTER TABLE bowel_urine_entries ADD COLUMN client_id TEXT;
ALTER TABLE bowel_urine_entries RENAME TO fluids_entries;

-- Diet type (add to profiles)
ALTER TABLE profiles ADD COLUMN diet_type INTEGER;
ALTER TABLE profiles ADD COLUMN diet_description TEXT;

-- Notification schedules (new table)
-- See Section 12.1 for complete table definition
CREATE TABLE notification_schedules (...);  -- Definition in Section 12.1

-- New indexes
CREATE INDEX idx_fluids_water ON fluids_entries(profile_id, timestamp DESC)
  WHERE water_intake_ml IS NOT NULL;
CREATE INDEX idx_fluids_menstruation ON fluids_entries(profile_id, menstruation_flow, timestamp DESC)
  WHERE menstruation_flow IS NOT NULL AND menstruation_flow > 0;
CREATE INDEX idx_fluids_bbt ON fluids_entries(profile_id, bbt_recorded_time DESC)
  WHERE basal_body_temperature IS NOT NULL;
CREATE INDEX idx_fluids_other ON fluids_entries(profile_id, other_fluid_name, timestamp DESC)
  WHERE other_fluid_name IS NOT NULL;
CREATE INDEX idx_notification_schedules_profile ON notification_schedules(profile_id, type);
CREATE INDEX idx_notification_schedules_enabled ON notification_schedules(profile_id, is_enabled)
  WHERE sync_deleted_at IS NULL AND is_enabled = 1;
CREATE INDEX idx_client_id ON profiles(client_id);

-- Archive indexes (for efficient filtering of active vs archived items)
CREATE INDEX idx_supplements_active ON supplements(profile_id, is_archived)
  WHERE sync_deleted_at IS NULL AND is_archived = 0;
CREATE INDEX idx_food_items_active ON food_items(profile_id, is_archived)
  WHERE sync_deleted_at IS NULL AND is_archived = 0;
CREATE INDEX idx_conditions_active ON conditions(profile_id, is_archived)
  WHERE sync_deleted_at IS NULL AND is_archived = 0;
CREATE INDEX idx_activities_active ON activities(profile_id, is_archived)
  WHERE sync_deleted_at IS NULL AND is_archived = 0;
```

### Version 4 → 5

**Diet system (complete diet tracking with compliance):**
- Added `diets` table for diet configurations
- Added `diet_rules` table for custom diet rules
- Added `food_item_categories` junction table for food categorization
- Added `diet_violations` table for compliance tracking
- Added nutritional columns to `food_items` table

**Food items nutritional enhancement:**
- Added `serving_size REAL` column
- Added `serving_unit TEXT` column
- Added `calories REAL` column
- Added `carbs_grams REAL` column
- Added `fat_grams REAL` column
- Added `protein_grams REAL` column
- Added `fiber_grams REAL` column
- Added `sugar_grams REAL` column

**Migration SQL:**
```sql
-- Diet system tables (see Section 14 for complete definitions)
CREATE TABLE diets (...);       -- Full definition in Section 14.1
CREATE TABLE diet_rules (...);  -- Full definition in Section 14.2

CREATE TABLE food_item_categories (
  food_item_id TEXT NOT NULL,
  category INTEGER NOT NULL,
  PRIMARY KEY (food_item_id, category),
  FOREIGN KEY (food_item_id) REFERENCES food_items(id) ON DELETE CASCADE
);

CREATE TABLE diet_violations (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  diet_id TEXT NOT NULL,
  food_log_id TEXT NOT NULL,
  rule_id TEXT,
  rule_type INTEGER NOT NULL,
  severity INTEGER NOT NULL,
  message TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER,
  sync_deleted_at INTEGER,
  sync_last_synced_at INTEGER,
  sync_status INTEGER DEFAULT 0,
  sync_version INTEGER DEFAULT 1,
  sync_device_id TEXT,
  sync_is_dirty INTEGER DEFAULT 1,
  conflict_data TEXT,
  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (diet_id) REFERENCES diets(id) ON DELETE CASCADE,
  FOREIGN KEY (food_log_id) REFERENCES food_logs(id) ON DELETE CASCADE
);

-- Food items nutritional columns
ALTER TABLE food_items ADD COLUMN serving_size REAL;
ALTER TABLE food_items ADD COLUMN serving_unit TEXT;
ALTER TABLE food_items ADD COLUMN calories REAL;
ALTER TABLE food_items ADD COLUMN carbs_grams REAL;
ALTER TABLE food_items ADD COLUMN fat_grams REAL;
ALTER TABLE food_items ADD COLUMN protein_grams REAL;
ALTER TABLE food_items ADD COLUMN fiber_grams REAL;
ALTER TABLE food_items ADD COLUMN sugar_grams REAL;

-- Diet indexes
CREATE INDEX idx_diets_profile ON diets(profile_id, is_active);
CREATE INDEX idx_diets_client ON diets(client_id);
CREATE INDEX idx_diet_rules_diet ON diet_rules(diet_id);
CREATE INDEX idx_diet_rules_client ON diet_rules(client_id);
CREATE INDEX idx_food_categories_category ON food_item_categories(category);
CREATE INDEX idx_violations_diet ON diet_violations(diet_id, timestamp DESC);
CREATE INDEX idx_violations_profile ON diet_violations(profile_id, timestamp DESC);
CREATE INDEX idx_violations_client ON diet_violations(client_id);
```

### Version 5 → 6

**Intelligence System (pattern detection, triggers, insights, predictions):**
- Added `patterns` table for detected health patterns
- Added `trigger_correlations` table for trigger-outcome relationships
- Added `health_insights` table for generated insights
- Added `predictive_alerts` table for predictions and warnings
- Added `ml_models` table for machine learning model metadata
- Added `prediction_feedback` table for model improvement

See [42_INTELLIGENCE_SYSTEM.md](42_INTELLIGENCE_SYSTEM.md) for complete specification.

**Migration SQL:**
```sql
-- Detected patterns (temporal, cyclical, sequential, cluster, dosage)
CREATE TABLE patterns (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  pattern_type INTEGER NOT NULL,        -- 0: temporal, 1: cyclical, 2: sequential, 3: cluster, 4: dosage
  entity_type TEXT NOT NULL,
  entity_id TEXT,
  data_json TEXT NOT NULL,              -- Pattern-specific data as JSON
  confidence REAL NOT NULL,
  sample_size INTEGER NOT NULL,
  detected_at INTEGER NOT NULL,
  data_range_start INTEGER NOT NULL,
  data_range_end INTEGER NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1,
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

-- Trigger correlations (food/activity/supplement → condition relationships)
CREATE TABLE trigger_correlations (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  trigger_id TEXT NOT NULL,
  trigger_type TEXT NOT NULL,
  trigger_name TEXT NOT NULL,
  outcome_id TEXT NOT NULL,
  outcome_type TEXT NOT NULL,
  outcome_name TEXT NOT NULL,
  correlation_type INTEGER NOT NULL,    -- 0: positive, 1: negative, 2: neutral, 3: dose-response
  relative_risk REAL NOT NULL,
  ci_low REAL NOT NULL,
  ci_high REAL NOT NULL,
  p_value REAL NOT NULL,
  trigger_exposures INTEGER NOT NULL,
  outcome_occurrences INTEGER NOT NULL,
  cooccurrences INTEGER NOT NULL,
  time_window_hours INTEGER NOT NULL,
  average_latency_hours REAL NOT NULL,
  confidence REAL NOT NULL,
  detected_at INTEGER NOT NULL,
  data_range_start INTEGER NOT NULL,
  data_range_end INTEGER NOT NULL,
  dose_response_equation TEXT,
  is_active INTEGER NOT NULL DEFAULT 1,
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

-- Health insights (generated observations and recommendations)
CREATE TABLE health_insights (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  category INTEGER NOT NULL,            -- 0-7: summary, pattern, trigger, progress, compliance, anomaly, milestone, recommendation
  priority INTEGER NOT NULL,            -- 0: high, 1: medium, 2: low
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  recommendation TEXT,
  evidence_json TEXT NOT NULL,
  generated_at INTEGER NOT NULL,
  expires_at INTEGER,
  is_dismissed INTEGER NOT NULL DEFAULT 0,
  dismissed_at INTEGER,
  related_entity_type TEXT,
  related_entity_id TEXT,
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

-- Predictive alerts (flare predictions, cycle predictions, etc.)
CREATE TABLE predictive_alerts (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  prediction_type INTEGER NOT NULL,     -- 0-5: flareUp, menstrualStart, ovulation, triggerExposure, missedSupplement, poorSleep
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  probability REAL NOT NULL,
  predicted_event_time INTEGER NOT NULL,
  alert_generated_at INTEGER NOT NULL,
  factors_json TEXT NOT NULL,
  preventive_action TEXT,
  is_acknowledged INTEGER NOT NULL DEFAULT 0,
  acknowledged_at INTEGER,
  event_occurred INTEGER,               -- NULL = unknown, 0 = no, 1 = yes
  event_occurred_at INTEGER,
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

-- ML model metadata (for personalized prediction models)
CREATE TABLE ml_models (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  model_type TEXT NOT NULL,             -- 'flare_prediction', 'severity_forecast', etc.
  condition_id TEXT,                    -- For condition-specific models
  model_path TEXT NOT NULL,             -- Path to model file
  accuracy REAL,
  precision_score REAL,
  recall_score REAL,
  training_samples INTEGER NOT NULL,
  trained_at INTEGER NOT NULL,
  last_used_at INTEGER,

  -- Sync metadata (required for all health data tables)
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER,
  sync_deleted_at INTEGER,
  sync_last_synced_at INTEGER,
  sync_status INTEGER DEFAULT 0,        -- 0=pending, 1=synced, 2=conflict, 3=error
  sync_version INTEGER DEFAULT 1,
  sync_device_id TEXT,
  sync_is_dirty INTEGER DEFAULT 1,
  conflict_data TEXT,

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

-- Prediction feedback (for model improvement)
CREATE TABLE prediction_feedback (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  alert_id TEXT NOT NULL,
  prediction_type INTEGER NOT NULL,
  predicted_probability REAL NOT NULL,
  actual_outcome INTEGER NOT NULL,      -- 0 or 1
  prediction_window_hours INTEGER NOT NULL,
  actual_latency_hours INTEGER,
  recorded_at INTEGER NOT NULL,

  -- Sync metadata (required for all health data tables)
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER,
  sync_deleted_at INTEGER,
  sync_last_synced_at INTEGER,
  sync_status INTEGER DEFAULT 0,        -- 0=pending, 1=synced, 2=conflict, 3=error
  sync_version INTEGER DEFAULT 1,
  sync_device_id TEXT,
  sync_is_dirty INTEGER DEFAULT 1,
  conflict_data TEXT,

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (alert_id) REFERENCES predictive_alerts(id) ON DELETE CASCADE
);

-- Intelligence system indexes
CREATE INDEX idx_patterns_profile ON patterns(profile_id, pattern_type, is_active);
CREATE INDEX idx_patterns_entity ON patterns(entity_type, entity_id);
CREATE INDEX idx_patterns_client ON patterns(client_id);

CREATE INDEX idx_correlations_profile ON trigger_correlations(profile_id, is_active);
CREATE INDEX idx_correlations_trigger ON trigger_correlations(trigger_type, trigger_id);
CREATE INDEX idx_correlations_outcome ON trigger_correlations(outcome_type, outcome_id);
CREATE INDEX idx_correlations_type ON trigger_correlations(correlation_type) WHERE is_active = 1;
CREATE INDEX idx_correlations_client ON trigger_correlations(client_id);

CREATE INDEX idx_insights_profile ON health_insights(profile_id, is_dismissed, category);
CREATE INDEX idx_insights_active ON health_insights(profile_id, expires_at) WHERE is_dismissed = 0;
CREATE INDEX idx_insights_entity ON health_insights(related_entity_type, related_entity_id);
CREATE INDEX idx_insights_client ON health_insights(client_id);

CREATE INDEX idx_alerts_profile ON predictive_alerts(profile_id, is_acknowledged);
CREATE INDEX idx_alerts_pending ON predictive_alerts(profile_id, predicted_event_time) WHERE is_acknowledged = 0;
CREATE INDEX idx_alerts_feedback ON predictive_alerts(prediction_type, event_occurred) WHERE event_occurred IS NOT NULL;
CREATE INDEX idx_alerts_client ON predictive_alerts(client_id);

CREATE UNIQUE INDEX idx_models_unique ON ml_models(profile_id, model_type, condition_id);

CREATE INDEX idx_feedback_type ON prediction_feedback(prediction_type, recorded_at);
```

### Version 6 → 7

**HIPAA Authorization for Profile Sharing:**
- Added `hipaa_authorizations` table for digital authorization records
- Added `profile_access_logs` table for audit trail of shared data access

See [35_QR_DEVICE_PAIRING.md](35_QR_DEVICE_PAIRING.md) Section 8.4 for complete specification.

**Wearable Integration (Phase 4):**
- Added `wearable_connections` table for platform connection state
- Added `imported_data_log` table for deduplication tracking
- Added `fhir_exports` table for export history
- Added `import_source` and `import_external_id` columns to importable entities

See [43_WEARABLE_INTEGRATION.md](43_WEARABLE_INTEGRATION.md) for complete specification.

**Migration SQL:**
```sql
-- HIPAA authorizations for profile sharing
CREATE TABLE hipaa_authorizations (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  granted_to_user_id TEXT NOT NULL,
  granted_by_user_id TEXT NOT NULL,
  scope TEXT NOT NULL,                -- JSON array of DataScope values
  purpose TEXT NOT NULL,
  duration INTEGER NOT NULL,          -- AuthorizationDuration enum
  authorized_at INTEGER NOT NULL,
  expires_at INTEGER,
  revoked_at INTEGER,
  revocation_reason TEXT,
  signature_device_id TEXT NOT NULL,
  signature_ip_address TEXT NOT NULL,
  photos_included INTEGER NOT NULL DEFAULT 0,
  sync_id TEXT NOT NULL,
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

CREATE INDEX idx_authorizations_profile ON hipaa_authorizations(profile_id, revoked_at);
CREATE INDEX idx_authorizations_granted_to ON hipaa_authorizations(granted_to_user_id);
CREATE INDEX idx_authorizations_active ON hipaa_authorizations(profile_id, expires_at)
  WHERE revoked_at IS NULL;
CREATE INDEX idx_authorizations_client ON hipaa_authorizations(client_id);

-- Access audit log for shared profiles (immutable, no sync metadata per Section 2.7)
CREATE TABLE profile_access_logs (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,            -- Client identifier for audit trail ownership
  authorization_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  accessed_by_user_id TEXT NOT NULL,
  accessed_by_device_id TEXT NOT NULL,
  action INTEGER NOT NULL,            -- 0: view, 1: export, 2: addEntry, 3: editEntry
  entity_type TEXT NOT NULL,
  entity_id TEXT,
  accessed_at INTEGER NOT NULL,
  ip_address TEXT NOT NULL,
  FOREIGN KEY (authorization_id) REFERENCES hipaa_authorizations(id) ON DELETE CASCADE
);

CREATE INDEX idx_access_logs_client ON profile_access_logs(client_id);

CREATE INDEX idx_access_logs_authorization ON profile_access_logs(authorization_id, accessed_at DESC);
CREATE INDEX idx_access_logs_profile ON profile_access_logs(profile_id, accessed_at DESC);

-- Wearable platform connections
CREATE TABLE wearable_connections (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  platform TEXT NOT NULL,              -- 'healthkit', 'googlefit', 'fitbit', etc.
  is_connected INTEGER NOT NULL DEFAULT 0,
  connected_at INTEGER,
  disconnected_at INTEGER,
  read_permissions TEXT,               -- JSON array of DataType
  write_permissions TEXT,              -- JSON array of DataType
  background_sync_enabled INTEGER NOT NULL DEFAULT 1,
  last_sync_at INTEGER,
  last_sync_status TEXT,
  oauth_refresh_token TEXT,            -- Encrypted, for cloud APIs only
  sync_id TEXT NOT NULL,
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

CREATE UNIQUE INDEX idx_wearable_connections_unique ON wearable_connections(profile_id, platform);
CREATE INDEX idx_wearable_connections_profile ON wearable_connections(profile_id, is_connected);
CREATE INDEX idx_wearable_connections_client ON wearable_connections(client_id);

-- Imported data tracking for deduplication
CREATE TABLE imported_data_log (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  platform TEXT NOT NULL,
  external_id TEXT,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  imported_at INTEGER NOT NULL,
  data_timestamp INTEGER NOT NULL,
  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE INDEX idx_imported_data_external ON imported_data_log(platform, external_id);
CREATE INDEX idx_imported_data_entity ON imported_data_log(entity_type, entity_id);
CREATE INDEX idx_imported_data_timestamp ON imported_data_log(profile_id, data_timestamp);
CREATE INDEX idx_imported_data_client ON imported_data_log(client_id);

-- FHIR export history
CREATE TABLE fhir_exports (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  exported_at INTEGER NOT NULL,
  start_date INTEGER NOT NULL,
  end_date INTEGER NOT NULL,
  resource_types TEXT NOT NULL,        -- JSON array
  format TEXT NOT NULL,                -- 'json', 'xml', 'ndjson'
  file_size_bytes INTEGER,
  resource_count INTEGER,
  export_path TEXT,
  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE INDEX idx_fhir_exports_profile ON fhir_exports(profile_id, exported_at DESC);
CREATE INDEX idx_fhir_exports_client ON fhir_exports(client_id);

-- Add import source tracking to importable entities
ALTER TABLE activity_logs ADD COLUMN import_source TEXT;
ALTER TABLE activity_logs ADD COLUMN import_external_id TEXT;

ALTER TABLE sleep_entries ADD COLUMN import_source TEXT;
ALTER TABLE sleep_entries ADD COLUMN import_external_id TEXT;

ALTER TABLE fluids_entries ADD COLUMN import_source TEXT;
ALTER TABLE fluids_entries ADD COLUMN import_external_id TEXT;

-- Indexes for finding imported data
CREATE INDEX idx_activity_import ON activity_logs(import_source, import_external_id)
  WHERE import_source IS NOT NULL;
CREATE INDEX idx_sleep_import ON sleep_entries(import_source, import_external_id)
  WHERE import_source IS NOT NULL;
CREATE INDEX idx_fluids_import ON fluids_entries(import_source, import_external_id)
  WHERE import_source IS NOT NULL;
```

### Migration Rollback Procedures

Per coding standards, each migration requires a documented rollback procedure. SQLite does not support `DROP COLUMN` directly, so column-removal rollbacks require table recreation.

#### Rollback: Version 7 → 6

```sql
-- Remove import tracking columns (requires table recreation)
-- Step 1: Create temp tables without import columns
CREATE TABLE activity_logs_temp AS
  SELECT id, client_id, profile_id, timestamp, activity_ids, ad_hoc_activities, duration, notes,
         sync_created_at, sync_updated_at, sync_deleted_at,
         sync_last_synced_at, sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data
  FROM activity_logs;
DROP TABLE activity_logs;
ALTER TABLE activity_logs_temp RENAME TO activity_logs;

CREATE TABLE sleep_entries_temp AS
  SELECT id, client_id, profile_id, bed_time, wake_time,
         deep_sleep_minutes, light_sleep_minutes, restless_sleep_minutes,
         dream_type, waking_feeling, notes,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data
  FROM sleep_entries;
DROP TABLE sleep_entries;
ALTER TABLE sleep_entries_temp RENAME TO sleep_entries;

CREATE TABLE fluids_entries_temp AS
  SELECT id, client_id, profile_id, timestamp, water_intake_ml, water_intake_notes,
         has_bowel_movement, bowel_condition, bowel_custom_condition, bowel_size, bowel_photo_path,
         has_urine_movement, urine_condition, urine_custom_condition, urine_size, urine_photo_path,
         menstruation_flow, basal_body_temperature, bbt_recorded_time,
         other_fluid_name, other_fluid_amount, other_fluid_notes,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data
  FROM fluids_entries;
DROP TABLE fluids_entries;
ALTER TABLE fluids_entries_temp RENAME TO fluids_entries;

-- Recreate foreign keys and indexes for recreated tables
CREATE INDEX idx_activity_logs_profile ON activity_logs(profile_id);
CREATE INDEX idx_sleep_entries_profile ON sleep_entries(profile_id);
CREATE INDEX idx_fluids_entries_profile ON fluids_entries(profile_id);

-- Drop Phase 4 tables
DROP TABLE IF EXISTS fhir_exports;
DROP TABLE IF EXISTS imported_data_log;
DROP TABLE IF EXISTS wearable_connections;
DROP TABLE IF EXISTS profile_access_logs;
DROP TABLE IF EXISTS hipaa_authorizations;

-- Update version
PRAGMA user_version = 6;
```

#### Rollback: Version 6 → 5

```sql
-- Drop Intelligence System indexes
DROP INDEX IF EXISTS idx_feedback_type;
DROP INDEX IF EXISTS idx_models_unique;
DROP INDEX IF EXISTS idx_alerts_client;
DROP INDEX IF EXISTS idx_alerts_feedback;
DROP INDEX IF EXISTS idx_alerts_pending;
DROP INDEX IF EXISTS idx_alerts_profile;
DROP INDEX IF EXISTS idx_insights_client;
DROP INDEX IF EXISTS idx_insights_entity;
DROP INDEX IF EXISTS idx_insights_active;
DROP INDEX IF EXISTS idx_insights_profile;
DROP INDEX IF EXISTS idx_correlations_client;
DROP INDEX IF EXISTS idx_correlations_type;
DROP INDEX IF EXISTS idx_correlations_outcome;
DROP INDEX IF EXISTS idx_correlations_trigger;
DROP INDEX IF EXISTS idx_correlations_profile;
DROP INDEX IF EXISTS idx_patterns_client;
DROP INDEX IF EXISTS idx_patterns_entity;
DROP INDEX IF EXISTS idx_patterns_profile;

-- Drop Intelligence System tables
DROP TABLE IF EXISTS prediction_feedback;
DROP TABLE IF EXISTS ml_models;
DROP TABLE IF EXISTS predictive_alerts;
DROP TABLE IF EXISTS health_insights;
DROP TABLE IF EXISTS trigger_correlations;
DROP TABLE IF EXISTS patterns;

-- Update version
PRAGMA user_version = 5;
```

#### Rollback: Version 5 → 4

```sql
-- Drop Diet System indexes
DROP INDEX IF EXISTS idx_violations_client;
DROP INDEX IF EXISTS idx_violations_profile;
DROP INDEX IF EXISTS idx_violations_diet;
DROP INDEX IF EXISTS idx_food_categories_category;
DROP INDEX IF EXISTS idx_diet_rules_client;
DROP INDEX IF EXISTS idx_diet_rules_diet;
DROP INDEX IF EXISTS idx_diets_client;
DROP INDEX IF EXISTS idx_diets_profile;

-- Drop Diet System tables
DROP TABLE IF EXISTS diet_violations;
DROP TABLE IF EXISTS food_item_categories;
DROP TABLE IF EXISTS diet_rules;
DROP TABLE IF EXISTS diets;

-- Remove nutritional columns from food_items (requires table recreation)
CREATE TABLE food_items_temp AS
  SELECT id, client_id, profile_id, name, brand, description, is_archived,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data
  FROM food_items;
DROP TABLE food_items;
ALTER TABLE food_items_temp RENAME TO food_items;
CREATE INDEX idx_food_items_profile ON food_items(profile_id, is_archived);

-- Update version
PRAGMA user_version = 4;
```

#### Rollback: Version 4 → 3

```sql
-- Drop archive indexes
DROP INDEX IF EXISTS idx_activities_active;
DROP INDEX IF EXISTS idx_conditions_active;
DROP INDEX IF EXISTS idx_food_items_active;
DROP INDEX IF EXISTS idx_supplements_active;

-- Drop fluids-specific indexes
DROP INDEX IF EXISTS idx_client_id;
DROP INDEX IF EXISTS idx_notification_schedules_enabled;
DROP INDEX IF EXISTS idx_notification_schedules_profile;
DROP INDEX IF EXISTS idx_fluids_other;
DROP INDEX IF EXISTS idx_fluids_bbt;
DROP INDEX IF EXISTS idx_fluids_menstruation;
DROP INDEX IF EXISTS idx_fluids_water;
DROP INDEX IF EXISTS idx_profile_access_client;

-- Drop notification_schedules table
DROP TABLE IF EXISTS notification_schedules;

-- Rename fluids_entries back to bowel_urine_entries and remove new columns
ALTER TABLE fluids_entries RENAME TO bowel_urine_entries_temp;
CREATE TABLE bowel_urine_entries AS
  SELECT id, profile_id, timestamp,
         has_bowel_movement, bowel_condition, bowel_custom_condition, bowel_size, bowel_photo_path,
         has_urine_movement, urine_condition, urine_custom_condition, urine_size, urine_photo_path,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data
  FROM bowel_urine_entries_temp;
DROP TABLE bowel_urine_entries_temp;

-- Remove is_archived from archivable tables (requires recreation)
-- supplements
CREATE TABLE supplements_temp AS
  SELECT id, profile_id, name, dosage, dosage_unit, frequency, times_per_day, notes,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data
  FROM supplements;
DROP TABLE supplements;
ALTER TABLE supplements_temp RENAME TO supplements;

-- food_items
CREATE TABLE food_items_temp AS
  SELECT id, profile_id, name, brand, description,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data
  FROM food_items;
DROP TABLE food_items;
ALTER TABLE food_items_temp RENAME TO food_items;

-- conditions
CREATE TABLE conditions_temp AS
  SELECT id, profile_id, name, category_id, severity_scale, notes,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data
  FROM conditions;
DROP TABLE conditions;
ALTER TABLE conditions_temp RENAME TO conditions;

-- activities
CREATE TABLE activities_temp AS
  SELECT id, profile_id, name, category, default_duration_minutes,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, sync_is_dirty, conflict_data
  FROM activities;
DROP TABLE activities;
ALTER TABLE activities_temp RENAME TO activities;

-- Remove client_id and diet columns from profiles (requires recreation - too complex for rollback)
-- Note: client_id removal affects all tables; this rollback is NOT recommended for production
-- Consider backup restore instead

-- Recreate indexes for recreated tables
CREATE INDEX idx_supplements_profile ON supplements(profile_id);
CREATE INDEX idx_food_items_profile ON food_items(profile_id);
CREATE INDEX idx_conditions_profile ON conditions(profile_id);
CREATE INDEX idx_activities_profile ON activities(profile_id);
CREATE INDEX idx_bowel_urine_profile ON bowel_urine_entries(profile_id);

-- Update version
PRAGMA user_version = 3;
```

**Warning:** Version 4→3 rollback removes `client_id` from all tables. This is a destructive operation and database backup restore is recommended instead.

#### Rollback: Version 3 → 2

```sql
-- Rename sync_is_dirty back to is_dirty across all tables
-- This requires table recreation for each table
-- Example for profiles table:
CREATE TABLE profiles_temp AS SELECT * FROM profiles;
DROP TABLE profiles;
CREATE TABLE profiles (
  id TEXT PRIMARY KEY,
  -- ... all columns ...
  is_dirty INTEGER DEFAULT 1  -- Changed back from sync_is_dirty
);
INSERT INTO profiles SELECT * FROM profiles_temp;
DROP TABLE profiles_temp;

-- Repeat for all 42 tables (see Section 2 for complete list)
-- Due to complexity, backup restore is recommended for this rollback

-- Drop foreign key indexes added in v3
DROP INDEX IF EXISTS idx_intake_logs_supplement;
DROP INDEX IF EXISTS idx_food_logs_food_item;
DROP INDEX IF EXISTS idx_condition_logs_condition;
DROP INDEX IF EXISTS idx_activity_logs_activity;
DROP INDEX IF EXISTS idx_flare_ups_condition;

-- Update version
PRAGMA user_version = 2;
```

**Warning:** Version 3→2 rollback requires renaming columns in all 42 tables. Database backup restore is strongly recommended.

#### Rollback: Version 2 → 1

```sql
-- Remove profile_id from tables that had it added
-- flare_ups
CREATE TABLE flare_ups_temp AS
  SELECT id, condition_id, started_at, ended_at, severity, trigger_notes, notes,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, is_dirty, conflict_data
  FROM flare_ups;
DROP TABLE flare_ups;
ALTER TABLE flare_ups_temp RENAME TO flare_ups;

-- activity_logs
CREATE TABLE activity_logs_temp AS
  SELECT id, activity_id, started_at, ended_at, duration_minutes, intensity, notes,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, is_dirty, conflict_data
  FROM activity_logs;
DROP TABLE activity_logs;
ALTER TABLE activity_logs_temp RENAME TO activity_logs;

-- bowel_urine_logs
CREATE TABLE bowel_urine_logs_temp AS
  SELECT id, timestamp, has_bowel_movement, bowel_condition, bowel_size,
         has_urine_movement, urine_condition, urine_size, notes,
         sync_created_at, sync_updated_at, sync_deleted_at, sync_last_synced_at,
         sync_status, sync_version, sync_device_id, is_dirty, conflict_data
  FROM bowel_urine_logs;
DROP TABLE bowel_urine_logs;
ALTER TABLE bowel_urine_logs_temp RENAME TO bowel_urine_logs;

-- Recreate indexes
CREATE INDEX idx_flare_ups_condition ON flare_ups(condition_id);
CREATE INDEX idx_activity_logs_activity ON activity_logs(activity_id);
CREATE INDEX idx_bowel_urine_timestamp ON bowel_urine_logs(timestamp);

-- Update version
PRAGMA user_version = 1;
```

#### General Rollback Guidelines

1. **Always backup before rollback**: `sqlite3 shadow.db ".backup shadow_backup.db"`
2. **Test rollback on copy first**: Never run rollback SQL on production without testing
3. **Column removal requires table recreation**: SQLite lacks `DROP COLUMN` support
4. **Foreign key order**: Drop child tables before parent tables
5. **Index order**: Drop indexes before dropping tables they reference
6. **Version tracking**: Use `PRAGMA user_version` to track current schema version
7. **Prefer backup restore**: For complex rollbacks (v4→3, v3→2), restoring from backup is safer than SQL rollback

---

## 14. Diet System Tables

### 14.1 diets

User diet configurations (preset or custom).

```sql
CREATE TABLE diets (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,           -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,                -- Display name
  preset_id TEXT,                    -- NULL for custom, otherwise preset identifier
  is_active INTEGER NOT NULL DEFAULT 1,
  start_date INTEGER,                -- For fixed-duration diets (ms since epoch)
  end_date INTEGER,                  -- NULL for ongoing diets
  eating_window_start INTEGER,       -- Minutes from midnight (for IF diets)
  eating_window_end INTEGER,         -- Minutes from midnight

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

CREATE INDEX idx_diets_profile ON diets(profile_id, is_active);
CREATE INDEX idx_diets_client ON diets(client_id);
CREATE INDEX idx_diets_sync ON diets(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

### 14.2 diet_rules

Custom rules for diets (preset diets use code-defined rules).

```sql
CREATE TABLE diet_rules (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,           -- Client identifier for database merging support
  diet_id TEXT NOT NULL,
  rule_type INTEGER NOT NULL,        -- DietRuleType enum
  severity INTEGER NOT NULL,         -- 0: violation, 1: warning, 2: info
  category INTEGER,                  -- FoodCategory enum (for food rules)
  ingredient_name TEXT,              -- For ingredient-specific rules
  numeric_value REAL,                -- For limits (grams, percentages)
  time_value INTEGER,                -- Minutes from midnight (for time rules)
  days_of_week TEXT,                 -- Comma-separated 0-6 (for day-specific)
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

CREATE INDEX idx_diet_rules_diet ON diet_rules(diet_id);
CREATE INDEX idx_diet_rules_client ON diet_rules(client_id);
CREATE INDEX idx_diet_rules_sync ON diet_rules(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

### 14.3 food_item_categories

Junction table linking food items to their categories for diet rule matching.

```sql
CREATE TABLE food_item_categories (
  food_item_id TEXT NOT NULL,
  category INTEGER NOT NULL,         -- FoodCategory enum

  PRIMARY KEY (food_item_id, category),
  FOREIGN KEY (food_item_id) REFERENCES food_items(id) ON DELETE CASCADE
);

CREATE INDEX idx_food_categories_category ON food_item_categories(category);
```

### 14.4 diet_violations

Log of diet rule violations for compliance tracking.

```sql
CREATE TABLE diet_violations (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,           -- Client identifier for database merging support
  profile_id TEXT NOT NULL,
  diet_id TEXT NOT NULL,
  food_log_id TEXT NOT NULL,
  rule_id TEXT,                      -- NULL for preset rules
  rule_type INTEGER NOT NULL,        -- DietRuleType enum
  severity INTEGER NOT NULL,         -- 0: violation, 1: warning, 2: info
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

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (diet_id) REFERENCES diets(id) ON DELETE CASCADE,
  FOREIGN KEY (food_log_id) REFERENCES food_logs(id) ON DELETE CASCADE
);

CREATE INDEX idx_violations_diet ON diet_violations(diet_id, timestamp DESC);
CREATE INDEX idx_violations_profile ON diet_violations(profile_id, timestamp DESC);
CREATE INDEX idx_violations_client ON diet_violations(client_id);
CREATE INDEX idx_violations_sync ON diet_violations(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

### 14.5 Food Items Nutritional Columns

Added to existing `food_items` table for macro tracking:

```sql
-- Already in food_items table (added in v5 migration)
serving_size REAL,                   -- Serving size amount
serving_unit TEXT,                   -- 'g', 'oz', 'cup', 'piece'
calories REAL,                       -- Calories per serving
carbs_grams REAL,                    -- Carbohydrates per serving
fat_grams REAL,                      -- Fat per serving
protein_grams REAL,                  -- Protein per serving
fiber_grams REAL,                    -- Fiber per serving (for net carbs)
sugar_grams REAL,                    -- Sugar per serving
```

---

## 15. Security & Session Tables

### 15.1 refresh_token_usage

Tracks refresh token usage for replay attack prevention via token family tracking.

```sql
CREATE TABLE refresh_token_usage (
  jti TEXT PRIMARY KEY,              -- Unique token ID (JWT ID)
  family_id TEXT NOT NULL,           -- Token family (from original login)
  user_id TEXT NOT NULL,
  device_id TEXT NOT NULL,
  issued_at INTEGER NOT NULL,        -- Epoch ms
  expires_at INTEGER NOT NULL,       -- Epoch ms
  used_at INTEGER,                   -- NULL if not yet used, epoch ms when used
  invalidated_at INTEGER,            -- NULL if still valid, epoch ms when invalidated

  FOREIGN KEY (user_id) REFERENCES user_accounts(id) ON DELETE CASCADE,
  FOREIGN KEY (device_id) REFERENCES device_registrations(id) ON DELETE CASCADE
);

CREATE INDEX idx_token_family ON refresh_token_usage(family_id);
CREATE INDEX idx_token_user_device ON refresh_token_usage(user_id, device_id);
CREATE INDEX idx_token_expires ON refresh_token_usage(expires_at) WHERE used_at IS NULL;
CREATE INDEX idx_token_cleanup ON refresh_token_usage(expires_at) WHERE invalidated_at IS NOT NULL;
```

**Notes:**
- No sync metadata - tokens are device-local security artifacts
- `used_at IS NULL` indicates an unused (valid) token
- When `used_at` is set twice for same `jti`, it indicates replay attack
- Entire family invalidated on replay detection

### 15.2 pairing_sessions

Tracks QR code device pairing sessions for single-use enforcement.

```sql
CREATE TABLE pairing_sessions (
  session_id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,               -- Client identifier for audit trail
  initiating_device_id TEXT NOT NULL,
  initiating_user_id TEXT NOT NULL,
  private_key_encrypted TEXT NOT NULL,   -- Encrypted with device key
  session_salt TEXT NOT NULL,            -- Base64 encoded (16 bytes)
  qr_data TEXT NOT NULL,                 -- Full QR payload
  created_at INTEGER NOT NULL,           -- Epoch ms
  expires_at INTEGER NOT NULL,           -- Epoch ms (5 minutes from creation)
  scanned_at INTEGER,                    -- Epoch ms when QR was scanned
  scanned_by_device_id TEXT,             -- Device that scanned
  completed_at INTEGER,                  -- Epoch ms when pairing finished
  failed_at INTEGER,                     -- Epoch ms if pairing failed
  failure_reason TEXT,
  status INTEGER NOT NULL DEFAULT 0,     -- PairingSessionStatus enum

  FOREIGN KEY (initiating_user_id) REFERENCES user_accounts(id) ON DELETE CASCADE,
  FOREIGN KEY (initiating_device_id) REFERENCES device_registrations(id) ON DELETE CASCADE
);

CREATE INDEX idx_pairing_user ON pairing_sessions(initiating_user_id, created_at DESC);
CREATE INDEX idx_pairing_status ON pairing_sessions(status, expires_at);
CREATE INDEX idx_pairing_cleanup ON pairing_sessions(expires_at) WHERE status = 0;
```

**Notes:**
- No sync metadata - pairing sessions are ephemeral and device-local
- `status = 0` is pending (waiting for scan)
- Session expires after 5 minutes if not completed
- Single-use enforced via atomic `UPDATE ... WHERE scanned_at IS NULL`

---

## 16. Summary Statistics

| Category | Count |
|----------|-------|
| Total Tables | 42 |
| Total Indexes | 120+ |
| Tables with File Sync | 5 |
| Tables with client_id | 35 (all health data + profile_access + diet + intelligence + wearable tables) |
| Foreign Key Relationships | 35+ |
| Primary Key Type | TEXT (UUID) |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-01-30 | Added v3→v4 migration: fluids_entries (menstruation, BBT), diet_type on profiles, notification_schedules table |
| 1.2 | 2026-01-31 | Added client_id to all health data tables for database merging; Added water_intake and custom "other" fluid columns to fluids_entries |
| 1.3 | 2026-01-31 | Added v5→v6 migration: Intelligence System tables (patterns, trigger_correlations, health_insights, predictive_alerts, ml_models, prediction_feedback) |
| 1.4 | 2026-01-31 | Added v6→v7 migration: HIPAA authorization tables, wearable integration tables (wearable_connections, imported_data_log, fhir_exports), import source tracking columns |
| 1.5 | 2026-02-01 | Added Section 15: Security tables (refresh_token_usage, pairing_sessions) |
| 1.6 | 2026-02-01 | Added Section 2.7 Sync Metadata Exemptions (7 tables); Fixed V7→6 rollback column names; Corrected table count to 42 |
