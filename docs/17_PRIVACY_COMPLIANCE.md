# Shadow Privacy & Compliance

**Version:** 1.0
**Last Updated:** January 30, 2026
**Compliance:** HIPAA Technical Safeguards, GDPR, CCPA, App Store Guidelines

---

## Overview

Shadow handles Protected Health Information (PHI) and must comply with multiple privacy regulations. This document defines data classification, retention policies, privacy controls, and compliance checklists.

---

## 1. Data Classification

### 1.1 Classification Levels

| Level | Description | Examples | Encryption | Retention |
|-------|-------------|----------|------------|-----------|
| **PHI-Sensitive** | Health data that identifies condition/treatment | Menstruation flow, BBT, conditions, medications | AES-256 at rest + transit | User-controlled |
| **PHI-General** | Health data without specific condition info | Sleep times, food logs, activity | AES-256 at rest + transit | User-controlled |
| **PII** | Personally identifiable information | Name, email, birth date | AES-256 at rest + transit | Account lifetime |
| **Behavioral** | Usage patterns and preferences | Notification times, app settings | Encrypted at rest | 2 years |
| **Technical** | Device/app operation data | Device ID, crash logs | Encrypted at rest | 90 days |

### 1.2 Data Inventory

| Data Element | Classification | Storage Location | Sync to Cloud | Notes |
|--------------|---------------|------------------|---------------|-------|
| Profile name | PII | Local DB | Yes (encrypted) | |
| Birth date | PII | Local DB | Yes (encrypted) | |
| Email | PII | Local DB | Yes (encrypted) | From OAuth |
| Menstruation flow | PHI-Sensitive | Local DB | Yes (encrypted) | Reproductive health |
| Basal body temperature | PHI-Sensitive | Local DB | Yes (encrypted) | Fertility indicator |
| BBT recorded time | PHI-Sensitive | Local DB | Yes (encrypted) | |
| Bowel conditions | PHI-General | Local DB | Yes (encrypted) | |
| Urine conditions | PHI-General | Local DB | Yes (encrypted) | |
| Diet type | PHI-General | Local DB | Yes (encrypted) | |
| Condition names | PHI-Sensitive | Local DB | Yes (encrypted) | |
| Condition photos | PHI-Sensitive | Local filesystem | Yes (encrypted) | |
| Supplement names | PHI-General | Local DB | Yes (encrypted) | |
| Intake logs | PHI-General | Local DB | Yes (encrypted) | |
| Sleep entries | PHI-General | Local DB | Yes (encrypted) | |
| Food logs | PHI-General | Local DB | Yes (encrypted) | |
| Activity logs | PHI-General | Local DB | Yes (encrypted) | |
| Journal entries | PHI-Sensitive | Local DB | Yes (encrypted) | May contain sensitive notes |
| Notification schedules | Behavioral | Local DB | Yes (encrypted) | |
| Notification times | Behavioral | Local DB | Yes (encrypted) | |
| OAuth tokens | Technical | Secure storage | No | Platform keychain |
| Device ID | Technical | Secure storage | No | |
| Crash logs | Technical | Local + remote | Optional | Anonymized |

---

## 2. HIPAA Compliance

### 2.1 Technical Safeguards Checklist

| Requirement | Implementation | Status |
|-------------|----------------|--------|
| **Access Control** | | |
| Unique user identification | OAuth-based user accounts | ✅ Required |
| Emergency access procedure | Offline mode with local data | ✅ Required |
| Automatic logoff | Session timeout (configurable) | ✅ Required |
| Encryption/decryption | AES-256 SQLCipher | ✅ Required |
| **Audit Controls** | | |
| Hardware/software/procedural mechanisms | Audit log service | ✅ Required |
| **Integrity Controls** | | |
| Authentication of ePHI | SHA-256 checksums on sync | ✅ Required |
| **Transmission Security** | | |
| Integrity controls | TLS 1.3 for all network | ✅ Required |
| Encryption | AES-256-GCM before upload | ✅ Required |

### 2.2 Audit Logging

All PHI access must be logged:

```dart
// lib/core/services/audit_log_service.dart

enum AuditAction {
  create,
  read,
  update,
  delete,
  export,
  sync,
}

class AuditLogEntry {
  final String id;
  final DateTime timestamp;
  final String userId;
  final String deviceId;
  final AuditAction action;
  final String entityType;
  final String entityId;
  final String? details;
}

// Log all PHI access
await auditLog.log(AuditLogEntry(
  action: AuditAction.create,
  entityType: 'FluidsEntry',
  entityId: entry.id,
  details: 'Created with menstruation data',
));
```

### 2.3 Minimum Necessary Standard

Only collect data necessary for app functionality:

| Feature | Data Collected | Justification |
|---------|---------------|---------------|
| BBT Tracking | Temperature, time | Track fertility/cycle patterns |
| Menstruation | Flow level only | Track cycle, not detailed symptoms |
| Notifications | Times, days | Schedule reminders |
| Diet Type | Type + description | Filter/categorize food |

---

## 3. GDPR Compliance

### 3.1 Lawful Basis

| Data Category | Lawful Basis | Documentation |
|---------------|--------------|---------------|
| Health data | Explicit consent | Consent screen at signup |
| Account data | Contract performance | Terms of Service |
| Analytics | Legitimate interest | Privacy policy |

### 3.2 Data Subject Rights Implementation

| Right | Implementation | Location in App |
|-------|----------------|-----------------|
| **Right to Access** | Export all data as JSON/PDF | Profile → Export Data |
| **Right to Rectification** | Edit all entries | Each entry's edit screen |
| **Right to Erasure** | Delete account + all data | Profile → Delete Account |
| **Right to Portability** | Export in machine-readable format | Profile → Export Data (JSON) |
| **Right to Restrict Processing** | Pause sync | Sync Settings → Pause |
| **Right to Object** | Disable analytics | Settings → Privacy |
| **Right to Withdraw Consent** | Delete account | Profile → Delete Account |

### 3.3 Delete Account Flow

```
┌──────────────────┐
│ Delete Account   │
│ Button Tapped    │
└────────┬─────────┘
         │
         ▼
┌────────────────────────────────────────┐
│         Confirmation Dialog             │
├────────────────────────────────────────┤
│                                        │
│  ⚠️ Delete Account?                    │
│                                        │
│  This will permanently delete:         │
│  • Your profile and all health data    │
│  • All synced data from cloud          │
│  • All notification schedules          │
│                                        │
│  This action cannot be undone.         │
│                                        │
│  Type "DELETE" to confirm:             │
│  [________________________]            │
│                                        │
│  [Cancel]         [Delete Everything]  │
└────────────────────────────────────────┘
         │
         │ Confirmed
         ▼
┌──────────────────┐
│ 1. Delete cloud  │
│    data first    │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ 2. Delete local  │
│    database      │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ 3. Clear secure  │
│    storage       │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ 4. Revoke OAuth  │
│    tokens        │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ 5. Navigate to   │
│    Welcome Screen│
└──────────────────┘
```

### 3.4 Privacy Policy Requirements

Must include:
- [ ] Identity and contact details of controller
- [ ] Types of personal data collected
- [ ] Purposes of processing
- [ ] Lawful basis for processing
- [ ] Data retention periods
- [ ] Rights of data subjects
- [ ] How to exercise rights
- [ ] Right to lodge complaint with supervisory authority
- [ ] Whether data is transferred outside EU

---

## 4. App Store Compliance

### 4.1 Apple App Store

**Required Privacy Nutrition Labels:**

| Data Type | Collected | Linked to Identity | Used for Tracking |
|-----------|-----------|-------------------|-------------------|
| Health & Fitness | Yes | Yes | No |
| Contact Info (Email) | Yes | Yes | No |
| Identifiers (User ID) | Yes | Yes | No |

**Info.plist Privacy Descriptions:**

```xml
<!-- Required for notifications -->
<key>NSUserNotificationsUsageDescription</key>
<string>Shadow uses notifications to remind you to take supplements, log meals, and track your health.</string>

<!-- Required for camera (condition photos) -->
<key>NSCameraUsageDescription</key>
<string>Shadow uses the camera to photograph health conditions for tracking over time.</string>

<!-- Required for photo library -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Shadow accesses your photo library to attach images to health entries.</string>
```

**PrivacyInfo.xcprivacy (iOS 17+):**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "...">
<plist version="1.0">
<dict>
  <key>NSPrivacyTracking</key>
  <false/>
  <key>NSPrivacyCollectedDataTypes</key>
  <array>
    <dict>
      <key>NSPrivacyCollectedDataType</key>
      <string>NSPrivacyCollectedDataTypeHealthData</string>
      <key>NSPrivacyCollectedDataTypeLinked</key>
      <true/>
      <key>NSPrivacyCollectedDataTypeTracking</key>
      <false/>
      <key>NSPrivacyCollectedDataTypePurposes</key>
      <array>
        <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
      </array>
    </dict>
  </array>
</dict>
</plist>
```

### 4.2 Google Play Store

**Data Safety Section:**

| Category | Data Type | Collected | Shared | Purpose |
|----------|-----------|-----------|--------|---------|
| Personal info | Name | Yes | No | Account |
| Personal info | Email | Yes | No | Account |
| Health info | Health data | Yes | No | App functionality |

**Required Disclosures:**
- [ ] App collects health data
- [ ] Data encrypted in transit
- [ ] Data encrypted at rest
- [ ] User can request data deletion
- [ ] Data not shared with third parties

---

## 5. Data Retention Policy

### 5.1 Retention Periods

| Data Category | Active User | Inactive User | After Deletion |
|---------------|-------------|---------------|----------------|
| Health entries | Indefinite | 2 years | Immediate |
| Profile data | Account lifetime | 2 years | Immediate |
| Audit logs | 7 years | 7 years | 7 years (legal) |
| Crash logs | 90 days | 90 days | 90 days |
| Analytics | 2 years | 90 days | Immediate |

### 5.2 Inactive User Definition

- No app opens for 12 months
- No sync activity for 12 months
- Email notification sent at 11 months
- Data archived at 12 months
- Data deleted at 24 months

### 5.3 Deletion Verification

```dart
// Verify complete deletion
class DeletionVerificationService {
  Future<DeletionReport> verifyDeletion(String userId) async {
    final report = DeletionReport();

    // Check local database
    report.localDbCleared = await _verifyLocalDbEmpty(userId);

    // Check cloud storage
    report.cloudDataDeleted = await _verifyCloudEmpty(userId);

    // Check secure storage
    report.secureStorageCleared = await _verifySecureStorageEmpty(userId);

    // Log deletion completion
    await _auditLog.log(AuditLogEntry(
      action: AuditAction.delete,
      entityType: 'UserAccount',
      entityId: userId,
      details: 'Deletion verified: ${report.toJson()}',
    ));

    return report;
  }
}
```

### 5.4 Deletion Procedures

**"Immediate Deletion" Definition:**

| Data Type | Deletion Method | Backup Handling | Verification |
|-----------|-----------------|-----------------|--------------|
| Local DB records | 1. Set `sync_deleted_at` timestamp<br>2. Sync deletion to cloud<br>3. Hard delete after cloud confirms | Cloud backup purged on sync | Query returns zero results |
| Cloud-synced data | 1. Delete from cloud storage<br>2. Confirm deletion via API<br>3. Local hard delete after confirmation | Cloud retains 30-day recovery<br>(user can request permanent) | Cloud API confirms deletion |
| Encrypted photos | 1. Overwrite with random bytes<br>2. Delete file<br>3. Remove from cloud | Cloud version deleted immediately | File no longer exists |
| Secure storage keys | Platform secure delete (Keychain/Keystore) | No backups | Key no longer retrievable |
| Audit logs | **NOT DELETED** - required for 7 years | Legal retention | N/A |

### 5.5 SEC-06: Deletion Procedure for Shared Profiles

> **CRITICAL SECURITY REQUIREMENT (SEC-06):**
> When a profile is deleted that has active HIPAA authorizations (shared access),
> additional steps MUST be performed to ensure proper cleanup and compliance.
> Access logs for shared profiles MUST be retained for 7 years per HIPAA.

**Shared Profile Deletion Flow:**

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    SHARED PROFILE DELETION FLOW                           │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  User requests profile deletion                                          │
│        │                                                                 │
│        ▼                                                                 │
│  1. Check for active HIPAA authorizations                                │
│     └── Query: SELECT * FROM hipaa_authorizations                        │
│                WHERE profile_id = ? AND revoked_at IS NULL              │
│        │                                                                 │
│        ▼                                                                 │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  ⚠️ CONFIRMATION REQUIRED                                        │    │
│  │                                                                   │    │
│  │  This profile is shared with 2 people:                           │    │
│  │  • Sarah Johnson (Health Coach) - since Jan 15, 2026             │    │
│  │  • John Smith (Family) - since Feb 1, 2026                       │    │
│  │                                                                   │    │
│  │  Deleting this profile will:                                     │    │
│  │  • Immediately revoke their access                               │    │
│  │  • Notify them of the deletion                                   │    │
│  │  • Permanently delete all health data                            │    │
│  │  • Archive access logs for 7 years (HIPAA requirement)          │    │
│  │                                                                   │    │
│  │  [Cancel]                    [Delete Profile]                    │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│        │                                                                 │
│        ▼ (Confirmed)                                                    │
│  2. SOFT DELETE PROFILE                                                  │
│     └── Set sync_deleted_at timestamp on profile                        │
│     └── Profile becomes inaccessible immediately                        │
│        │                                                                 │
│        ▼                                                                 │
│  3. REVOKE ALL ACTIVE HIPAA AUTHORIZATIONS                              │
│     └── For each active authorization:                                   │
│         ├── Set revoked_at = now()                                      │
│         ├── Set revocation_reason = 'profile_deleted'                   │
│         └── Log: hipaaAuthorizationRevoked (audit)                      │
│        │                                                                 │
│        ▼                                                                 │
│  4. NOTIFY RECIPIENTS                                                    │
│     └── For each revoked authorization:                                  │
│         ├── Send push notification: "Profile access revoked"            │
│         ├── Send email: "[Profile Name] has been deleted"               │
│         └── Include: "Your access has ended. Access logs retained."     │
│        │                                                                 │
│        ▼                                                                 │
│  5. ARCHIVE ACCESS LOGS (DO NOT DELETE!)                                │
│     └── Mark profile_access_logs as archived:                           │
│         ├── Set archived_at timestamp                                   │
│         ├── Set archive_reason = 'profile_deleted'                      │
│         └── CRITICAL: Logs MUST be retained 7 years from archive date   │
│        │                                                                 │
│        ▼                                                                 │
│  6. VERIFY ACCESS LOGS NOT DELETED                                       │
│     └── SELECT COUNT(*) FROM profile_access_logs                        │
│         WHERE profile_id = ? AND archived_at IS NOT NULL               │
│     └── Assert: count > 0 if authorizations existed                     │
│        │                                                                 │
│        ▼                                                                 │
│  7. DELETE PROFILE DATA                                                  │
│     └── Delete all health records associated with profile               │
│     └── Delete encrypted photos                                         │
│     └── Sync deletions to cloud                                         │
│        │                                                                 │
│        ▼                                                                 │
│  8. LOG PROFILE DELETION                                                 │
│     └── Audit log: profileDeleted                                       │
│         ├── profileId                                                   │
│         ├── revokedAuthorizationCount                                   │
│         ├── notifiedRecipientCount                                      │
│         └── archivedAccessLogCount                                      │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

**Implementation:**

```dart
/// SEC-06: Delete shared profile with proper HIPAA compliance
class SharedProfileDeletionService {
  final ProfileRepository _profileRepository;
  final HipaaAuthorizationRepository _authRepository;
  final ProfileAccessLogRepository _accessLogRepository;
  final NotificationService _notificationService;
  final AuditLogService _auditLog;

  Future<Result<DeletionReport, AppError>> deleteSharedProfile({
    required String profileId,
    required String deletedByUserId,
  }) async {
    final report = DeletionReport(profileId: profileId);

    // 1. Soft delete profile first (makes it inaccessible immediately)
    await _profileRepository.softDelete(profileId);
    report.profileSoftDeleted = true;

    // 2. Get and revoke all active authorizations
    final activeAuths = await _authRepository.getActiveByProfile(profileId);
    report.activeAuthorizationCount = activeAuths.length;

    for (final auth in activeAuths) {
      // Revoke authorization
      await _authRepository.revoke(
        authorizationId: auth.id,
        revokedAt: DateTime.now().millisecondsSinceEpoch,
        revocationReason: 'profile_deleted',
      );

      // Log revocation
      await _auditLog.log(AuditEntry(
        action: AuditAction.hipaaAuthorizationRevoked,
        entityType: 'HipaaAuthorization',
        entityId: auth.id,
        metadata: {
          'profileId': profileId,
          'grantedToUserId': auth.grantedToUserId,
          'revocationReason': 'profile_deleted',
          'triggeredBy': 'profile_deletion',
        },
      ));

      report.revokedAuthorizationIds.add(auth.id);
    }

    // 3. Notify all recipients
    for (final auth in activeAuths) {
      await _notificationService.notifyProfileDeleted(
        userId: auth.grantedToUserId,
        profileName: report.profileName,
        message: 'The profile you had access to has been deleted. '
                 'Your access has ended. Access logs are retained for compliance.',
      );
      report.notifiedUserIds.add(auth.grantedToUserId);
    }

    // 4. Archive access logs (DO NOT DELETE!)
    final archivedCount = await _accessLogRepository.archiveByProfile(
      profileId: profileId,
      archivedAt: DateTime.now().millisecondsSinceEpoch,
      archiveReason: 'profile_deleted',
    );
    report.archivedAccessLogCount = archivedCount;

    // 5. CRITICAL: Verify access logs were NOT deleted
    final accessLogCount = await _accessLogRepository.countByProfile(profileId);
    if (activeAuths.isNotEmpty && accessLogCount == 0) {
      // This is a compliance violation - access logs should exist
      await _auditLog.log(AuditEntry(
        action: AuditAction.complianceViolation,
        entityType: 'Profile',
        entityId: profileId,
        result: AuditResult.failure,
        metadata: {
          'violation': 'access_logs_missing_after_deletion',
          'expectedLogs': 'true',
          'actualLogCount': 0,
        },
      ));
      return Failure(ComplianceError.accessLogsMissing(profileId));
    }
    report.accessLogsVerified = true;

    // 6. Delete profile data
    await _deleteProfileData(profileId);
    report.dataDeleted = true;

    // 7. Log profile deletion
    await _auditLog.log(AuditEntry(
      action: AuditAction.profileDeleted,
      entityType: 'Profile',
      entityId: profileId,
      metadata: {
        'deletedByUserId': deletedByUserId,
        'revokedAuthorizationCount': activeAuths.length,
        'notifiedRecipientCount': report.notifiedUserIds.length,
        'archivedAccessLogCount': archivedCount,
      },
    ));

    return Success(report);
  }

  Future<void> _deleteProfileData(String profileId) async {
    // Delete in order: logs -> entities -> photos
    await _conditionLogRepository.hardDeleteByProfile(profileId);
    await _intakeLogRepository.hardDeleteByProfile(profileId);
    await _foodLogRepository.hardDeleteByProfile(profileId);
    await _sleepEntryRepository.hardDeleteByProfile(profileId);
    await _activityLogRepository.hardDeleteByProfile(profileId);
    await _fluidsEntryRepository.hardDeleteByProfile(profileId);
    await _journalEntryRepository.hardDeleteByProfile(profileId);

    await _conditionRepository.hardDeleteByProfile(profileId);
    await _supplementRepository.hardDeleteByProfile(profileId);
    await _foodItemRepository.hardDeleteByProfile(profileId);
    await _activityRepository.hardDeleteByProfile(profileId);

    // Secure delete photos (overwrite then delete)
    await _photoService.secureDeleteByProfile(profileId);

    // Finally delete profile record
    await _profileRepository.hardDelete(profileId);
  }
}

/// Deletion report for verification
class DeletionReport {
  final String profileId;
  String? profileName;
  bool profileSoftDeleted = false;
  int activeAuthorizationCount = 0;
  List<String> revokedAuthorizationIds = [];
  List<String> notifiedUserIds = [];
  int archivedAccessLogCount = 0;
  bool accessLogsVerified = false;
  bool dataDeleted = false;

  DeletionReport({required this.profileId});

  bool get isComplete =>
      profileSoftDeleted &&
      accessLogsVerified &&
      dataDeleted;
}
```

**Database Schema for Access Log Archiving:**

```sql
-- Add archive columns to profile_access_logs
ALTER TABLE profile_access_logs ADD COLUMN archived_at INTEGER;
ALTER TABLE profile_access_logs ADD COLUMN archive_reason TEXT;

-- Index for archived log cleanup (after 7 years)
CREATE INDEX IF NOT EXISTS idx_access_logs_archived
ON profile_access_logs(archived_at)
WHERE archived_at IS NOT NULL;

-- Trigger to prevent deletion of archived logs before retention
CREATE TRIGGER IF NOT EXISTS prevent_archived_access_log_delete
BEFORE DELETE ON profile_access_logs
WHEN OLD.archived_at IS NOT NULL
  AND OLD.archived_at > (strftime('%s', 'now') - (7 * 365 * 24 * 60 * 60)) * 1000
BEGIN
  SELECT RAISE(ABORT, 'ARCHIVED_LOG_PROTECTED: Cannot delete archived access logs before 7-year retention period');
END;
```

**HIPAA Compliance Notes for Shared Profile Deletion:**

| Requirement | Implementation | Verification |
|-------------|----------------|--------------|
| Immediate access revocation | Soft delete + auth revocation | Recipients cannot access data |
| Recipient notification | Push + email notification | Notification delivery logged |
| Access log retention | Archive logs (7 years) | `archived_at` timestamp set |
| Log deletion prevention | Database trigger | Trigger prevents premature deletion |
| Audit trail | Profile deletion logged | Audit log entry with full details |

**Implementation:**

```dart
class DataDeletionService {
  /// Securely delete user data
  Future<void> deleteUserData(String userId, DeletionType type) async {
    switch (type) {
      case DeletionType.accountDeletion:
        // 1. Soft delete all health records
        await _softDeleteAllRecords(userId);

        // 2. Sync deletions to cloud
        await _syncDeletions(userId);

        // 3. Delete photos with overwrite
        await _secureDeletePhotos(userId);

        // 4. Clear secure storage
        await _clearSecureStorage(userId);

        // 5. Hard delete after cloud confirms
        await _hardDeleteAfterCloudSync(userId);

        // 6. Verify deletion
        await _verifyCompleteDeletion(userId);
        break;

      case DeletionType.profileDeletion:
        // Delete single profile, not entire account
        await _deleteProfileData(userId, profileId);
        break;
    }
  }

  /// Overwrite sensitive files before deletion
  Future<void> _secureDeletePhotos(String userId) async {
    final photos = await _getPhotoFiles(userId);
    for (final photo in photos) {
      // Overwrite with random data
      final randomBytes = _secureRandom.nextBytes(photo.lengthSync());
      await photo.writeAsBytes(randomBytes);
      // Then delete
      await photo.delete();
    }
  }
}
```

---

## 6. Consent Management

### 6.1 Consent Types

| Consent | Required | Granular | Revocable |
|---------|----------|----------|-----------|
| Health data collection | Yes | No | Yes (delete account) |
| Cloud sync | No | Yes | Yes |
| Notifications | No | Yes | Yes |
| Analytics | No | Yes | Yes |
| Crash reporting | No | Yes | Yes |

### 6.2 Consent UI

```
┌────────────────────────────────────────┐
│         Privacy Settings                │
├────────────────────────────────────────┤
│                                        │
│  Data Collection                       │
│  Shadow collects health data to        │
│  provide tracking features.            │
│  [View Privacy Policy]                 │
│                                        │
│  ─────────────────────────────────     │
│                                        │
│  Optional Features                     │
│                                        │
│  Cloud Sync                     [ON]   │
│  Sync data across your devices         │
│                                        │
│  Analytics                     [OFF]   │
│  Help improve Shadow with usage data   │
│                                        │
│  Crash Reports                  [ON]   │
│  Send crash reports to fix bugs        │
│                                        │
│  ─────────────────────────────────     │
│                                        │
│  [Export My Data]                      │
│  [Delete My Account]                   │
│                                        │
└────────────────────────────────────────┘
```

---

## 7. Security Incident Response

### 7.1 Incident Classification

| Severity | Definition | Response Time | Notification |
|----------|------------|---------------|--------------|
| Critical | PHI breach confirmed | 1 hour | Immediate (72h for GDPR) |
| High | Potential PHI exposure | 4 hours | Within 24 hours |
| Medium | Security vulnerability | 24 hours | If exploited |
| Low | Minor security issue | 72 hours | Not required |

### 7.2 Breach Notification

**HIPAA (if applicable):**
- Notify affected individuals within 60 days
- Notify HHS if >500 affected
- Document breach and response

**GDPR:**
- Notify supervisory authority within 72 hours
- Notify affected individuals without undue delay
- Document breach and response

### 7.3 Incident Response Checklist

- [ ] Identify scope of breach
- [ ] Contain the incident
- [ ] Assess data affected
- [ ] Determine notification requirements
- [ ] Notify relevant authorities
- [ ] Notify affected users
- [ ] Document timeline and actions
- [ ] Implement remediation
- [ ] Post-incident review

### 7.4 Breach Notification Workflow

**Hour 0-4: Detection & Containment**
1. Security team notified via PagerDuty
2. Isolate affected systems
3. Preserve forensic evidence
4. Initial scope assessment

**Hour 4-24: Investigation**
1. Determine what data was accessed
2. Identify affected users (query by profile/date range)
3. Assess likelihood of harm
4. Prepare breach report

**Hour 24-72: Authority Notification**
1. GDPR: File report with supervisory authority (72h max)
2. HIPAA: If >500 affected, prepare HHS notification
3. Legal review of notification requirements

**Day 3-60: User Notification**
1. Prepare user notification email (see template below)
2. Set up support channel for inquiries
3. HIPAA: Individual notification within 60 days
4. GDPR: "Without undue delay"

**User Notification Email Template:**
```
Subject: Important Security Notice from Shadow

Dear [User Name],

We are writing to inform you of a security incident that may have affected your Shadow account.

WHAT HAPPENED:
[Brief description - e.g., "Unauthorized access to our systems was detected on [date]"]

WHAT INFORMATION WAS INVOLVED:
[Specific data types - e.g., "Your health tracking data and email address"]

WHAT WE ARE DOING:
- Secured our systems against further unauthorized access
- Engaged security experts to investigate
- Notified relevant authorities
- [Other remediation steps]

WHAT YOU CAN DO:
- Review your account activity
- Update your password
- Contact us if you notice suspicious activity

We sincerely apologize for this incident. If you have questions, please contact [support email].

Sincerely,
The Shadow Team
```

**Post-Incident Documentation:**
- Timeline of events
- Systems and data affected
- Root cause analysis
- Remediation actions taken
- Lessons learned
- Prevention measures implemented

---

## 8. Third-Party Data Sharing

### 8.1 Current Third Parties

| Third Party | Data Shared | Purpose | DPA in Place |
|-------------|-------------|---------|--------------|
| Google (OAuth) | Email, name | Authentication | Yes (Google ToS) |
| Google Drive | Encrypted health data | Cloud sync | Yes (see 8.1.1) |
| Apple iCloud | Encrypted health data | Cloud sync | Yes (Apple ToS) |
| None | None | Analytics | N/A (no analytics) |

#### 8.1.1 Google Cloud Business Associate Agreement (HIPAA)

**IMPORTANT:** For HIPAA compliance when storing PHI in Google Drive:

1. **Google ToS is NOT sufficient** for HIPAA compliance
2. Must execute **Google Cloud Business Associate Agreement (BAA)**
3. BAA available for Google Workspace and Google Cloud Platform customers
4. BAA covers: Gmail, Google Drive, Google Calendar, Google Cloud Storage, BigQuery

**Requirements before enabling Google Drive sync for PHI:**
- [ ] Organization has Google Workspace or GCP account
- [ ] Google Cloud BAA executed by authorized signatory
- [ ] BAA covers Google Drive for health data storage
- [ ] Configuration follows Google's HIPAA implementation guide
- [ ] Annual review of BAA coverage and compliance

**Reference:** https://cloud.google.com/security/compliance/hipaa-compliance

**Alternative for users without BAA:**
- Offer offline-only mode (no cloud sync)
- Offer Apple iCloud sync (covered by Apple's BAA for Health apps)
- Data remains encrypted at rest locally

### 8.2 Data Processing Agreement Requirements

Before adding any third party:
- [ ] Execute Data Processing Agreement
- [ ] Verify SOC 2 Type II or equivalent
- [ ] Verify encryption standards
- [ ] Document sub-processors
- [ ] Annual review of compliance

---

## 9. Compliance Checklist

### 9.1 Pre-Launch Checklist

- [ ] Privacy Policy published and accessible
- [ ] Terms of Service published
- [ ] Consent flows implemented
- [ ] Data export functionality working
- [ ] Account deletion functionality working
- [ ] Encryption verified (at rest and in transit)
- [ ] Audit logging enabled
- [ ] App Store privacy labels accurate
- [ ] PrivacyInfo.xcprivacy created (iOS)
- [ ] Data Safety section completed (Android)

### 9.2 Ongoing Compliance

- [ ] Monthly: Review audit logs
- [ ] Quarterly: Privacy policy review
- [ ] Annually: Third-party DPA review
- [ ] Annually: Security assessment
- [ ] As needed: Breach response drill

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-02-02 | SEC-06: Added deletion procedure for shared profiles including soft-delete, HIPAA authorization revocation, recipient notification, access log archiving (7-year retention), and verification steps |
