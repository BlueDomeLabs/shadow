# Cloud Sync Architecture for Multi-User, Multi-Profile Access

## Overview
This document outlines the architecture for supporting a counselor managing multiple client profiles, where:
- Counselors can view/edit all client profiles
- Clients can only view/edit their own profile
- Multiple devices per user account
- Secure cloud synchronization

## Architectural Layers

### 1. User Account Layer (NEW)
**Purpose:** Authentication and identity

```dart
class UserAccount {
  final String id;                    // Firebase/Google user ID
  final String email;                 // Google account email
  final String displayName;           // User's name
  final UserRole role;                // counselor or client
  final String? organizationId;       // Optional: for multi-org support
  final DateTime createdAt;
  final SyncMetadata syncMetadata;
}

enum UserRole {
  counselor,  // Full access to assigned profiles
  client,     // Access to only their profile
}
```

**Database Table:**
```sql
CREATE TABLE user_accounts (
  id TEXT PRIMARY KEY,              -- Google/Firebase UID
  email TEXT NOT NULL UNIQUE,
  displayName TEXT NOT NULL,
  role TEXT NOT NULL,               -- 'counselor' or 'client'
  organizationId TEXT,              -- Optional
  createdAt INTEGER NOT NULL,
  -- sync metadata fields
  UNIQUE(email)
);
```

### 2. Profile Layer (MODIFIED)
**Purpose:** Health data container (one per client being tracked)

```dart
class Profile {
  final String id;                    // UUID
  final String name;                  // Client's name
  final DateTime? birthDate;
  final BiologicalSex? biologicalSex;
  final String? ethnicity;
  final String? notes;
  final String ownerId;               // UserAccount.id of the counselor who created it
  final DateTime createdAt;
  final SyncMetadata syncMetadata;
}
```

**Changes:**
- Add `ownerId` field → the counselor who created/owns this profile
- Profile is NOT a user account, it's health data

**Database Table:**
```sql
CREATE TABLE profiles (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  birthDate TEXT,
  biologicalSex TEXT,
  ethnicity TEXT,
  notes TEXT,
  ownerId TEXT NOT NULL,            -- NEW: references user_accounts(id)
  createdAt TEXT NOT NULL,
  -- sync metadata fields
  FOREIGN KEY (ownerId) REFERENCES user_accounts(id) ON DELETE CASCADE
);
```

### 3. Profile Access Control Layer (NEW)
**Purpose:** Define which user accounts can access which profiles

```dart
class ProfileAccess {
  final String id;                    // UUID
  final String profileId;             // Profile being accessed
  final String userAccountId;         // User who has access
  final ProfileAccessLevel accessLevel;
  final DateTime grantedAt;
  final String grantedBy;             // UserAccount.id who granted access
  final DateTime? expiresAt;          // Optional: time-limited access
}

enum ProfileAccessLevel {
  readOnly,   // View only
  readWrite,  // View and edit
  owner,      // Full control (counselor)
}
```

**Database Table:**
```sql
CREATE TABLE profile_access (
  id TEXT PRIMARY KEY,
  profileId TEXT NOT NULL,
  userAccountId TEXT NOT NULL,
  accessLevel TEXT NOT NULL,        -- 'readOnly', 'readWrite', 'owner'
  grantedAt INTEGER NOT NULL,
  grantedBy TEXT NOT NULL,
  expiresAt INTEGER,
  FOREIGN KEY (profileId) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (userAccountId) REFERENCES user_accounts(id) ON DELETE CASCADE,
  FOREIGN KEY (grantedBy) REFERENCES user_accounts(id),
  UNIQUE(profileId, userAccountId)
);
```

### 4. Device Registration Layer (NEW)
**Purpose:** Track which devices are authorized for each user account

```dart
class DeviceRegistration {
  final String id;                    // UUID
  final String userAccountId;         // User who owns this device
  final String deviceId;              // Device unique ID
  final String deviceName;            // "John's iPhone"
  final String deviceType;            // "ios", "android", "macos", "web"
  final DateTime registeredAt;
  final DateTime lastSeenAt;
  final bool isActive;
}
```

**Database Table:**
```sql
CREATE TABLE device_registrations (
  id TEXT PRIMARY KEY,
  userAccountId TEXT NOT NULL,
  deviceId TEXT NOT NULL,
  deviceName TEXT NOT NULL,
  deviceType TEXT NOT NULL,
  registeredAt INTEGER NOT NULL,
  lastSeenAt INTEGER NOT NULL,
  isActive INTEGER DEFAULT 1,
  FOREIGN KEY (userAccountId) REFERENCES user_accounts(id) ON DELETE CASCADE,
  UNIQUE(userAccountId, deviceId)
);
```

## Data Flow

### User Authentication Flow
```
1. App Launch
   ↓
2. Check Local Auth Token
   ↓
3. If No Token → Show Sign-In Screen
   ↓
4. User Taps "Sign in with Google"
   ↓
5. Google OAuth Flow
   ↓
6. Receive Google Account (email, name, uid)
   ↓
7. Check if UserAccount exists in backend
   ↓
8. If New User → Create UserAccount (default role: client)
   ↓
9. If Existing User → Load UserAccount with role
   ↓
10. Load Profiles accessible to this UserAccount
```

### Profile Access Logic

**For Counselors:**
```dart
// Counselor sees:
// 1. Profiles they own (created by them)
// 2. Profiles shared with them by other counselors
Future<List<Profile>> getAccessibleProfiles(String userAccountId) async {
  // Get all profile_access records for this user
  final accessRecords = await getProfileAccessForUser(userAccountId);

  // Load all profiles from those access records
  final profileIds = accessRecords.map((a) => a.profileId).toList();
  return await getProfilesByIds(profileIds);
}
```

**For Clients:**
```dart
// Client sees:
// 1. Only profiles explicitly shared with them (usually just 1)
Future<List<Profile>> getAccessibleProfiles(String userAccountId) async {
  final accessRecords = await getProfileAccessForUser(userAccountId);
  final profileIds = accessRecords.map((a) => a.profileId).toList();
  return await getProfilesByIds(profileIds);
}
```

### Cloud Sync Strategy

**Current Problem:** Sync is device-based → any device can access all data

**New Strategy:** Account-based sync with access control

```
User's Google Drive Structure:
/ShadowApp/
  /users/
    /{userAccountId}/
      account.json              # UserAccount data
      /devices/
        /{deviceId}.json        # Device registration
  /profiles/
    /{profileId}/
      profile.json              # Profile metadata
      /conditions/
      /supplements/
      /photos/
      /data/
```

**Access Rules:**
- UserAccount can only sync profiles they have access to
- Profile data is stored in shared location
- Access control enforced at API level, not storage level

## Implementation Plan

### Phase 1: Add User Account System (Week 1)
1. Create UserAccount entity and repository
2. Create DeviceRegistration entity and repository
3. Create ProfileAccess entity and repository
4. Add user_accounts, device_registrations, profile_access tables
5. Add ownerId to profiles table

### Phase 2: Authentication UI (Week 1)
1. Create SignInScreen with Google Sign-In button
2. Add AuthProvider to manage authentication state
3. Update main.dart to show SignInScreen if not authenticated
4. Add user profile switcher for counselors

### Phase 3: Access Control (Week 2)
1. Implement getAccessibleProfiles() in ProfileRepository
2. Update all queries to filter by accessible profiles only
3. Add role checking for sensitive operations
4. Add "Share Profile" UI for counselors to invite clients

### Phase 4: Cloud Sync Migration (Week 2)
1. Update sync service to use user account ID instead of device ID
2. Migrate existing data to new structure
3. Implement profile sharing via cloud storage permissions
4. Add conflict resolution for multi-device edits

### Phase 5: Multi-Device Support (Week 3)
1. Implement device registration on login
2. Add "My Devices" management screen
3. Add remote device logout/deauthorization
4. Test sync across multiple devices per user

## Security Considerations

### Authentication
- Use Google Sign-In for OAuth2 authentication
- Store OAuth tokens securely in platform keychain
- Implement token refresh logic
- Add session timeout (e.g., 30 days)

### Authorization
- All data access must check ProfileAccess table
- Never expose profile data without access verification
- Counselors can't access profiles they don't own/share
- Clients can't see other clients' profiles

### Data Privacy
- End-to-end encryption for sensitive data (optional enhancement)
- Audit log for profile access (who viewed what, when)
- HIPAA compliance considerations if medical data involved

## Alternative: Firebase Backend (Recommended)

Instead of pure Google Drive storage, consider Firebase:

**Benefits:**
- Built-in authentication with Google Sign-In
- Firestore for real-time sync and access control
- Security Rules for server-side access control
- Better conflict resolution
- Offline support with automatic sync

**Firestore Structure:**
```
/users/{userId}
  - email, displayName, role, etc.

/profiles/{profileId}
  - name, birthDate, ownerId, etc.
  - /access/{userId} → { level: 'readWrite' }

/profiles/{profileId}/conditions/{conditionId}
  - condition data

/profiles/{profileId}/supplements/{supplementId}
  - supplement data
```

**Security Rules:**
```javascript
// Only allow access to profiles you have permission for
match /profiles/{profileId} {
  allow read: if exists(/databases/$(database)/documents/profiles/$(profileId)/access/$(request.auth.uid));
  allow write: if get(/databases/$(database)/documents/profiles/$(profileId)/access/$(request.auth.uid)).data.level in ['readWrite', 'owner'];
}
```

## Decision Point

**Option A: Pure Google Drive**
- ✅ No backend server needed
- ✅ Simple file-based storage
- ❌ Complex access control implementation
- ❌ Manual conflict resolution
- ❌ Slower sync (file-based)

**Option B: Firebase + Google Drive (Hybrid)**
- ✅ Firebase for authentication + metadata + access control
- ✅ Google Drive for large files (photos)
- ✅ Real-time sync
- ✅ Built-in security rules
- ❌ Requires Firebase project setup
- ✅ Better scalability

**Recommendation:** Go with Firebase (Option B) for a production-ready solution.

---

## Next Steps

1. **Decide:** Pure Google Drive vs Firebase backend
2. **Design Review:** Review this architecture with team
3. **Implementation:** Follow the phased plan above
4. **Testing:** Multi-user, multi-device testing
5. **Migration:** Plan for existing users if any
