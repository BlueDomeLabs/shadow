# Cloud Sync Implementation Guide

## Overview
This document tracks the implementation of cloud synchronization for the Shadow health tracking app, supporting Google Drive and iCloud with end-to-end encryption.

## ✅ Completed Components

### 1. Dependencies (pubspec.yaml)
- ✅ google_sign_in: ^6.2.1
- ✅ googleapis: ^13.2.0
- ✅ googleapis_auth: ^1.6.0
- ✅ sign_in_with_apple: ^6.1.2
- ✅ encrypt: ^5.0.3
- ✅ crypto: ^3.0.3
- ✅ flutter_secure_storage: ^9.2.2
- ✅ workmanager: ^0.5.2
- ✅ connectivity_plus: ^6.0.5
- ✅ device_info_plus: ^10.1.2

### 2. Core Sync Models
- ✅ `lib/domain/sync/sync_metadata.dart` - SyncMetadata and FileSyncMetadata classes
- ✅ `lib/domain/sync/syncable.dart` - Syncable and SyncableWithFiles interfaces
- ✅ Enums: SyncStatus, CloudProvider, PhotoStorageStrategy

### 3. Core Services
- ✅ `lib/core/services/encryption_service.dart` - AES-256 encryption for health data
- ✅ `lib/core/services/device_info_service.dart` - Device identification and platform detection

## 🚧 In Progress / TODO

### Phase 1: Database Schema Updates (CRITICAL - Do First)

#### Files to Modify:
1. **lib/data/datasources/local/database_helper.dart**
   - Update database version from 12 to 13
   - Add migration logic to add sync columns to ALL tables

   **Columns to add to EVERY table:**
   ```sql
   ALTER TABLE {table_name} ADD COLUMN createdAt INTEGER;
   ALTER TABLE {table_name} ADD COLUMN updatedAt INTEGER;
   ALTER TABLE {table_name} ADD COLUMN deletedAt INTEGER;
   ALTER TABLE {table_name} ADD COLUMN lastSyncedAt INTEGER;
   ALTER TABLE {table_name} ADD COLUMN syncStatus INTEGER DEFAULT 0;
   ALTER TABLE {table_name} ADD COLUMN version INTEGER DEFAULT 1;
   ALTER TABLE {table_name} ADD COLUMN deviceId TEXT;
   ALTER TABLE {table_name} ADD COLUMN isDirty INTEGER DEFAULT 1;
   ALTER TABLE {table_name} ADD COLUMN conflictData TEXT;
   ```

   **Additional columns for tables with files (photo_entries, conditions, condition_logs, bowel_urine_entries):**
   ```sql
   ALTER TABLE {table_name} ADD COLUMN cloudStorageUrl TEXT;
   ALTER TABLE {table_name} ADD COLUMN fileHash TEXT;
   ALTER TABLE {table_name} ADD COLUMN fileSizeBytes INTEGER;
   ALTER TABLE {table_name} ADD COLUMN isFileUploaded INTEGER DEFAULT 0;
   ```

   **Tables to update:**
   - profiles
   - sleep_entries
   - activities
   - photo_areas
   - photo_entries (+ file columns)
   - food_items
   - food_logs
   - supplements
   - intake_logs
   - conditions (+ file columns)
   - condition_logs (+ file columns)
   - bowel_urine_entries (+ file columns)
   - condition_categories

### Phase 2: Entity Model Updates

**For EACH entity, add:**
1. SyncMetadata field
2. Implement Syncable interface
3. Update copyWith methods
4. Update toJson/fromJson methods
5. For entities with files: also implement SyncableWithFiles

**Priority order:**
1. ✅ Profile (most critical)
2. ✅ SleepEntry
3. Activity
4. PhotoArea
5. PhotoEntry (has files)
6. FoodItem
7. FoodLog
8. Supplement
9. SupplementIntakeLog
10. Condition (has files)
11. ConditionLog (has files)
12. BowelUrineEntry (has files)

### Phase 3: Cloud Storage Abstraction

**Create these files:**

1. **lib/domain/cloud/cloud_storage_provider.dart**
   ```dart
   abstract class CloudStorageProvider {
     Future<void> initialize();
     Future<bool> isAuthenticated();
     Future<void> signIn();
     Future<void> signOut();
     Future<void> uploadFile(String localPath, String remotePath);
     Future<String> downloadFile(String remotePath, String localPath);
     Future<void> deleteFile(String remotePath);
     Future<List<String>> listFiles(String folderPath);
     Future<void> uploadJson(String remotePath, Map<String, dynamic> data);
     Future<Map<String, dynamic>> downloadJson(String remotePath);
   }
   ```

2. **lib/data/cloud/google_drive_provider.dart**
   - Implements CloudStorageProvider
   - Uses googleapis and google_sign_in packages
   - Handles Google Drive authentication
   - Manages file upload/download to Google Drive

3. **lib/data/cloud/icloud_provider.dart**
   - Implements CloudStorageProvider
   - Uses platform channels for iOS/macOS iCloud integration
   - Note: iCloud requires native code in iOS/macOS directories

### Phase 4: Sync Engine

**Create:**
1. **lib/core/sync/sync_service.dart**
   - Main sync orchestrator
   - Handles upload/download of entities
   - Implements conflict resolution logic
   - Manages sync queue

2. **lib/core/sync/conflict_resolver.dart**
   - Last-write-wins strategy
   - Version-based resolution
   - User resolution UI integration

3. **lib/core/sync/sync_queue.dart**
   - Offline operation queueing
   - Background sync scheduling
   - Retry logic

### Phase 5: Sync Settings & Preferences

**Create:**
1. **lib/data/datasources/local/sync_preferences.dart**
   - Store sync settings using SharedPreferences
   - Track selected cloud provider
   - Photo storage strategy per device
   - Sync frequency preferences
   - Last sync timestamp

2. **lib/domain/repositories/sync_repository.dart**
   - Interface for sync operations

3. **lib/data/repositories/sync_repository_impl.dart**
   - Implementation using local + cloud data sources

### Phase 6: UI Components

**Create:**
1. **lib/presentation/screens/cloud_sync_settings_screen.dart**
   - Cloud provider selection (Google Drive / iCloud)
   - Authentication status
   - Photo storage strategy toggle
   - Sync frequency settings
   - Manual sync trigger
   - View sync status

2. **lib/presentation/screens/conflict_resolution_screen.dart**
   - Show conflicting versions
   - Allow user to choose which version to keep
   - Show differences

3. **lib/presentation/widgets/sync_status_indicator.dart**
   - Small widget showing sync status
   - Add to app bar or bottom of screens
   - Show sync progress, errors, last sync time

4. **lib/presentation/providers/sync_provider.dart**
   - ChangeNotifier for sync state
   - Expose sync status to UI
   - Trigger manual syncs

### Phase 7: Background Sync

**Create:**
1. **lib/core/background/sync_worker.dart**
   - Uses workmanager package
   - Schedules periodic background sync
   - Checks connectivity before syncing

2. **lib/core/background/background_sync_setup.dart**
   - Initialize workmanager
   - Register periodic tasks
   - Handle platform-specific background execution

### Phase 8: Integration & Testing

**Steps:**
1. Update main.dart to initialize sync services
2. Update dependency injection (get_it setup)
3. Add sync settings to app settings screen
4. Test on multiple devices
5. Test offline scenarios
6. Test conflict resolution
7. Test photo upload/download

## Implementation Notes

### Encryption Strategy
- All health data encrypted before cloud storage using AES-256
- Encryption keys stored in secure storage (Keychain/KeyStore)
- Keys can be exported for multi-device setup
- Each JSON payload encrypted separately

### Conflict Resolution Rules
1. **Last-Write-Wins**: Default for most entities
   - Compare `updatedAt` timestamps
   - Newer version wins

2. **Version-Based**: For critical data
   - Increment `version` on each update
   - If versions differ by more than 1, flag for user resolution

3. **Soft Deletes**: Prevent deletion conflicts
   - Set `deletedAt` timestamp instead of hard delete
   - Purge old soft-deleted records after 30 days

4. **User Resolution**: When automatic resolution fails
   - Show both versions to user
   - Let user choose or merge

### File Sync Strategy
1. Upload photos to cloud storage first
2. Store cloud URL in database record
3. Download photos on-demand (lazy loading)
4. Cache downloaded photos locally
5. User can choose: local+cloud or cloud-only per device

### Sync Flow
1. **Upload:**
   - Get all entities where `isDirty = true`
   - Encrypt JSON data
   - Upload to cloud provider
   - Mark `isDirty = false`, update `lastSyncedAt`

2. **Download:**
   - Fetch cloud data newer than `lastSyncedAt`
   - Decrypt JSON data
   - Compare with local version
   - Resolve conflicts if any
   - Update local database

3. **Photo Upload:**
   - Hash file (SHA-256)
   - Check if already uploaded (compare hash)
   - If not, upload to cloud storage
   - Store cloud URL in database

## Setup Instructions for User

### Google Drive Setup:
1. Create Google Cloud Project
2. Enable Google Drive API
3. Create OAuth 2.0 credentials
4. Add credentials to Android (google-services.json) and iOS (GoogleService-Info.plist)
5. Update AndroidManifest.xml and Info.plist with permissions

### iCloud Setup:
1. Enable iCloud capability in Xcode
2. Configure iCloud container
3. Add entitlements
4. Update Info.plist

### Encryption Key Export/Import:
1. User can export keys for multi-device setup
2. Show QR code or secure share link
3. Import on new device to access encrypted data

## Security Considerations
- All health data encrypted at rest in cloud
- Encryption keys never leave device (except manual export)
- Use HTTPS for all cloud communication
- Validate data integrity with SHA-256 hashes
- Implement rate limiting for sync operations

## Performance Optimizations
- Batch sync operations
- Only sync changes (incremental sync)
- Compress JSON before encryption
- Use delta sync for large datasets
- Implement pagination for large lists

## Next Steps
1. Complete Phase 1 (Database Schema) - CRITICAL
2. Update Profile and SleepEntry entities
3. Implement Google Drive provider
4. Build basic sync service
5. Create settings UI
6. Test end-to-end sync

## Questions/Decisions Needed
- [x] Which cloud providers? → Google Drive + iCloud
- [x] Encryption? → Yes, AES-256
- [x] Offline support? → Yes, with queue
- [x] Photo strategy? → User choice per device
- [x] Sync frequency? → All options (auto/manual/on-launch)
