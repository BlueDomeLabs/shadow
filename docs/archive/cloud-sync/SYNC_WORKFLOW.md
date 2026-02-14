# Cloud Synchronization Workflow

## Overview

The Shadow App implements a bi-directional cloud synchronization system that keeps health data synchronized across multiple devices using Google Drive as the cloud storage provider.

## Architecture

### Components

```
┌─────────────────┐
│   UI Layer      │
│  (Providers)    │
└────────┬────────┘
         │
┌────────▼────────┐
│  Sync Service   │  ← Orchestrates sync operations
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼──────────┐
│ Local │ │ Cloud       │
│  DB   │ │  Provider   │
└───────┘ └──┬──────────┘
              │
         ┌────▼────┐
         │ Google  │
         │  Drive  │
         └─────────┘
```

### Key Classes

- **SyncService**: Main orchestrator for sync operations
- **GoogleDriveProvider**: Platform-specific cloud storage implementation
- **SyncProvider**: UI state management for sync status
- **SyncPreferences**: Persists sync configuration
- **ConflictResolver**: Handles data conflicts

## Sync Metadata

Every syncable entity includes:

```dart
class SyncMetadata {
  DateTime sync_created_at;      // When entity was created
  DateTime sync_updated_at;      // Last modification time
  DateTime? sync_deleted_at;     // Soft delete timestamp
  DateTime? sync_last_synced_at; // Last successful sync
  SyncStatus sync_status;        // pending, synced, conflict, error
  int sync_version;              // Conflict resolution version
  String sync_device_id;         // Device that modified it
  bool sync_is_dirty;                 // Needs sync flag
  String? conflict_data;         // Conflicting version JSON
}
```

## Sync Workflow

### 1. Prerequisites Check

```dart
// Before starting sync
✓ Cloud provider configured (GoogleDrive, iCloud)
✓ User authenticated (OAuth token valid)
✓ Network connectivity available
✓ WiFi requirement met (if enabled)
```

### 2. Token Validation

```dart
// Automatic token refresh if needed
if (tokenExpiresIn < 5 minutes) {
  await refreshOAuthToken();
}
```

**Implementation**: `GoogleDriveProvider._ensureValidToken()`
- Checks token expiration with 5-minute threshold
- Automatically refreshes before API calls
- Handles 401 errors with retry + refresh

### 3. Download Cloud Data

```dart
for each entityType in [profiles, supplements, conditions, ...] {
  // List files from cloud path
  files = await cloudProvider.listFiles("shadow_app/data/{entityType}/");

  for each file in files {
    // Download and decrypt
    encryptedData = await cloudProvider.downloadFile(file.path);
    entityJson = decrypt(encryptedData);

    // Parse entity
    entity = EntityModel.fromCloudJson(entityJson);
    cloudEntities.add(entity);
  }
}
```

**Cloud Storage Structure**:
```
shadow_app/
  └── data/
      ├── profiles/
      │   ├── {uuid1}.json
      │   └── {uuid2}.json
      ├── supplements/
      │   ├── {uuid3}.json
      │   └── {uuid4}.json
      └── ... (one folder per entity type)
```

### 4. Compare Local vs Cloud

```dart
for each cloudEntity in cloudEntities {
  localEntity = await localDB.findById(cloudEntity.id);

  if (localEntity == null) {
    // New entity from cloud → download
    toDownload.add(cloudEntity);
  }
  else if (localEntity.sync_is_dirty && cloudEntity.sync_version > localEntity.sync_version) {
    // CONFLICT: Both modified
    conflicts.add({local: localEntity, cloud: cloudEntity});
  }
  else if (cloudEntity.sync_version > localEntity.sync_version) {
    // Cloud is newer → update local
    toUpdate.add(cloudEntity);
  }
  else if (localEntity.sync_is_dirty) {
    // Local is newer or same version → upload
    toUpload.add(localEntity);
  }
  // else: already synced, no action
}

// Check for local-only entities
for each localEntity in allLocalEntities {
  if (!cloudEntities.contains(localEntity.id) && localEntity.sync_is_dirty) {
    // New local entity → upload
    toUpload.add(localEntity);
  }
}
```

### 5. Conflict Resolution

```dart
// Strategy: Last Write Wins (based on sync_updated_at)
class ConflictResolver {
  Entity resolve(Entity local, Entity cloud, strategy) {
    switch (strategy) {
      case lastWriteWins:
        return cloud.sync_updated_at > local.sync_updated_at
          ? cloud
          : local;

      case clientWins:
        return local;

      case serverWins:
        return cloud;

      case requireManualResolution:
        // Store conflict for user review
        local.sync_status = SyncStatus.conflict;
        local.conflict_data = jsonEncode(cloud.toCloudJson());
        return local;
    }
  }
}
```

**Default Strategy**: `lastWriteWins`

### 6. Upload Local Changes

```dart
for each entity in toUpload {
  // Prepare cloud JSON
  cloudJson = entity.toCloudJson();

  // Encrypt
  encryptedData = encrypt(jsonEncode(cloudJson));

  // Upload to cloud
  cloudPath = "shadow_app/data/{entityType}/{entity.id}.json";
  await cloudProvider.uploadFile(cloudPath, encryptedData);

  // Update local sync metadata
  entity.sync_last_synced_at = DateTime.now();
  entity.sync_status = SyncStatus.synced;
  entity.sync_is_dirty = false;
  entity.sync_version++;

  await localDB.update(entity);
}
```

**File Format** (encrypted):
```json
{
  "id": "uuid",
  "data": { ... entity fields ... },
  "syncMetadata": {
    "sync_created_at": 1704502800000,
    "sync_updated_at": 1704502900000,
    "sync_version": 3,
    "sync_device_id": "device-abc-123"
  }
}
```

### 7. Update Local Database

```dart
// Apply cloud changes
for each entity in toDownload {
  await localDB.insert(entity);
}

for each entity in toUpdate {
  await localDB.update(entity);
}

// Apply conflict resolutions
for each conflict in conflicts {
  resolved = conflictResolver.resolve(conflict.local, conflict.cloud);
  await localDB.update(resolved);
}
```

### 8. Refresh UI Providers

```dart
// CRITICAL: Refresh all providers after sync
await profileProvider.refresh();
await supplementProvider.refresh();
await conditionProvider.refresh();
await foodProvider.refresh();
await photoProvider.refresh();
await activityProvider.refresh();
await sleepProvider.refresh();
await journalProvider.refresh();
await documentProvider.refresh();
await bowelUrineProvider.refresh();
```

**Why**: Providers cache data in memory. Without refresh, UI shows stale data even though DB is updated.

## Error Handling

### Token Expiration (401 Errors)

```dart
Future<T> _executeWithRetry<T>(Future<T> Function() operation) async {
  try {
    return await operation();
  } on DetailedApiRequestError catch (e) {
    if (e.status == 401) {
      // Token expired, refresh and retry once
      await _refreshToken();
      return await operation(); // Retry
    }
    rethrow;
  }
}
```

### Network Failures

```dart
try {
  await syncService.sync();
} catch (e) {
  if (e is SocketException) {
    showError("No network connection");
  } else if (e is TimeoutException) {
    showError("Sync timed out");
  } else {
    showError("Sync failed: ${e.message}");
  }
  // Local data remains unchanged
}
```

### Partial Sync Failures

- Sync continues even if individual entities fail
- Failed entities remain `sync_is_dirty = 1`
- Will retry on next sync

## Sync Triggers

### Manual Sync
```dart
// User presses sync button
await syncService.sync();
```

### Automatic Sync
```dart
// On app startup (after authentication)
if (lastSyncAge > 1 hour) {
  await syncService.sync();
}

// After significant changes
await localDB.update(entity);
if (autoSyncEnabled) {
  syncService.scheduleSync(delay: 30 seconds);
}
```

### Background Sync
*Note: Currently not implemented. Future enhancement.*

## Sync Preferences

```dart
class SyncPreferences {
  CloudProvider cloudProvider;          // None, GoogleDrive, iCloud
  DateTime? lastSyncTimestamp;          // Last partial sync
  DateTime? lastFullSyncTimestamp;      // Last complete sync
  bool wifiOnlySync;                    // Require WiFi
  PhotoStorageStrategy photoStrategy;   // LocalAndCloud or CloudOnly
  String? cloudUserIdentifier;          // Currently authenticated user
}
```

## Security

### Encryption
- **AES-256-CBC** encryption for all cloud-stored data
- Keys stored in platform secure storage (Keychain on iOS/macOS)

### OAuth Tokens
- Stored in `FlutterSecureStorage`
- Automatically refreshed before expiration
- Supports QR code pairing for multi-device setup

### Data Privacy
- No PHI (Protected Health Information) stored in plaintext on cloud
- Device-level encryption required
- OAuth scopes limited to `drive.file` (app-created files only)

## Multi-Device Support

### Device Registration

```dart
// On first sign-in
await registerDevice({
  deviceId: platformDeviceId,
  deviceName: "Sarah's iPhone",
  deviceType: "ios",
  deviceModel: "iPhone 15 Pro",
  osVersion: "iOS 17.2"
});
```

### QR Code Pairing

```dart
// Desktop generates QR code with:
{
  "accessToken": "...",
  "refreshToken": "...",
  "userId": "...",
  "deviceId": "...",
  "passphrase": "..." // Security verification
}

// Mobile scans and stores tokens
await secureStorage.write("access_token", qrData.accessToken);
await secureStorage.write("refresh_token", qrData.refreshToken);

// Mobile can now sync without re-authenticating
```

## Performance Optimization

### Incremental Sync
- Only sync entities with `sync_is_dirty = 1`
- Filter by `WHERE sync_is_dirty = 1 AND sync_deleted_at IS NULL`

### Batch Operations
- Upload multiple files in parallel (max 5 concurrent)
- Use batch DB updates (single transaction)

### Indexes
```sql
-- Fast sync queries
CREATE INDEX idx_profiles_sync ON profiles(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

### Caching
- Provider-level caching reduces DB reads
- Cloud file list cached for 5 minutes

## Debugging

### Sync Logs
```dart
logger.info('Starting sync...');
logger.debug('Uploading entity ${entity.id}');
logger.warning('Conflict detected for ${entity.id}');
logger.error('Sync failed: ${e.message}');
```

### Sync Status UI
```dart
syncProvider.status  // idle, syncing, success, error
syncProvider.progress  // 0.0 to 1.0
syncProvider.lastSyncTime
syncProvider.errorMessage
```

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Sync never completes | Network timeout | Check connectivity, increase timeout |
| Data not appearing after sync | Providers not refreshed | Call refresh() on all providers |
| 401 errors | Expired token | Token should auto-refresh; check OAuth config |
| Conflicts every sync | Clock skew between devices | Check device time settings |
| Photos not syncing | Photo strategy not configured | Set PhotoStorageStrategy in preferences |

## Future Enhancements

- [ ] Conflict resolution UI for manual review
- [ ] Delta sync (only changed fields)
- [ ] Background sync with WorkManager
- [ ] Offline queue for pending changes
- [ ] Sync analytics and reporting
- [ ] Selective entity sync (sync only specific entity types)
- [ ] iCloud provider implementation
