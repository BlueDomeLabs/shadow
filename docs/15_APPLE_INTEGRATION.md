# Shadow Apple Integration Specification

**Version:** 1.0
**Last Updated:** January 31, 2026
**Purpose:** Complete specification for Sign in with Apple and iCloud sync

---

## 1. Overview

Shadow supports two cloud providers for optional data synchronization:
- **Google Drive** (documented in 08_OAUTH_IMPLEMENTATION.md)
- **Apple iCloud** (documented here)

Users choose ONE cloud provider during setup. Both providers offer equivalent functionality with platform-appropriate implementation.

---

## 2. Sign in with Apple

### 2.1 Authentication Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SIGN IN WITH APPLE FLOW                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. User taps "Sign in with Apple" button                          │
│                    │                                                │
│                    ▼                                                │
│  2. System presents Apple Sign-In sheet (native)                   │
│     - Email sharing option (real or private relay)                 │
│     - Name sharing option                                          │
│                    │                                                │
│                    ▼                                                │
│  3. User authenticates with Face ID / Touch ID / Password          │
│                    │                                                │
│                    ▼                                                │
│  4. Apple returns authorization credential                         │
│     - identityToken (JWT)                                          │
│     - authorizationCode                                            │
│     - user (first sign-in only)                                    │
│                    │                                                │
│                    ▼                                                │
│  5. App validates identityToken                                    │
│     - Verify signature with Apple's public keys                    │
│     - Check issuer: https://appleid.apple.com                      │
│     - Verify audience matches app bundle ID                        │
│     - Check expiration                                             │
│                    │                                                │
│                    ▼                                                │
│  6. Extract user identifier (sub claim) - stable across sessions   │
│                    │                                                │
│                    ▼                                                │
│  7. Create/update local user account                               │
│     - Store Apple user ID in secure storage                        │
│     - Store refresh token securely                                 │
│                    │                                                │
│                    ▼                                                │
│  8. User authenticated - proceed to app                            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Required Capabilities

**Xcode Project Configuration:**
```xml
<!-- ios/Runner/Runner.entitlements -->
<key>com.apple.developer.applesignin</key>
<array>
  <string>Default</string>
</array>
```

**App Store Connect:**
- Enable "Sign in with Apple" capability
- Configure Services ID for web/Android fallback

### 2.3 Flutter Implementation

**Package:** `sign_in_with_apple: ^6.0.0`

```dart
// lib/data/cloud/apple_sign_in_service.dart

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInService {
  /// Check if Sign in with Apple is available on this device
  Future<bool> isAvailable() async {
    return await SignInWithApple.isAvailable();
  }

  /// Perform Sign in with Apple authentication
  Future<AppleAuthResult> signIn() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.bluedomecolorado.shadow.service',
        redirectUri: Uri.parse('https://shadow-oauth.bluedomecolorado.com/apple/callback'),
      ),
    );

    return AppleAuthResult(
      userIdentifier: credential.userIdentifier!,
      email: credential.email,
      givenName: credential.givenName,
      familyName: credential.familyName,
      identityToken: credential.identityToken!,
      authorizationCode: credential.authorizationCode,
    );
  }

  /// Validate identity token JWT
  Future<bool> validateToken(String identityToken) async {
    // Decode JWT without verification first
    final parts = identityToken.split('.');
    if (parts.length != 3) return false;

    final payload = json.decode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );

    // Verify claims
    if (payload['iss'] != 'https://appleid.apple.com') return false;
    if (payload['aud'] != 'com.bluedomecolorado.shadow') return false;

    final exp = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
    if (DateTime.now().isAfter(exp)) return false;

    // Full signature verification requires Apple's public keys
    return await _verifySignature(identityToken);
  }

  Future<bool> _verifySignature(String token) async {
    // Fetch Apple's public keys from https://appleid.apple.com/auth/keys
    // Verify JWT signature using RS256
    // Implementation uses pointycastle for RSA verification
    // ...
  }
}

@freezed
class AppleAuthResult with _$AppleAuthResult {
  const factory AppleAuthResult({
    required String userIdentifier,
    String? email,
    String? givenName,
    String? familyName,
    required String identityToken,
    required String authorizationCode,
  }) = _AppleAuthResult;
}
```

### 2.4 Credential Revocation Handling

Apple requires apps to handle credential revocation:

```dart
// Listen for credential revocation
class AppleCredentialMonitor {
  void startMonitoring() {
    // Check credential state on app launch
    SignInWithApple.getCredentialState(userIdentifier).then((state) {
      switch (state) {
        case CredentialState.authorized:
          // User is still authorized
          break;
        case CredentialState.revoked:
          // User revoked authorization - sign out
          _handleRevocation();
          break;
        case CredentialState.notFound:
          // User never signed in with Apple
          break;
        case CredentialState.transferred:
          // User transferred to new team - re-authenticate
          _handleTransfer();
          break;
      }
    });
  }

  void _handleRevocation() {
    // Clear local credentials
    // Sign user out
    // Show re-authentication prompt
  }
}
```

### 2.5 Private Email Relay

When users choose "Hide My Email":
- Apple provides a private relay address: `abc123@privaterelay.appleid.com`
- App must configure email relay in App Store Connect
- Outbound emails must come from registered domain

**Configuration in App Store Connect:**
1. Certificates, Identifiers & Profiles → Services
2. Sign in with Apple for Email Communication
3. Register domain and email addresses

### 2.6 Security Requirements

| Requirement | Implementation |
|-------------|----------------|
| Token storage | iOS Keychain / Android Keystore |
| Token validation | Verify signature with Apple public keys |
| Credential monitoring | Check state on each app launch |
| Revocation handling | Immediate sign-out and data protection |
| HTTPS only | All Apple API calls over TLS 1.3 |

---

## 3. iCloud Storage Integration

### 3.1 iCloud Container Setup

**Entitlements:**
```xml
<!-- ios/Runner/Runner.entitlements -->
<key>com.apple.developer.icloud-container-identifiers</key>
<array>
  <string>iCloud.com.bluedomecolorado.shadowApp</string>
</array>
<key>com.apple.developer.icloud-services</key>
<array>
  <string>CloudDocuments</string>
</array>
<key>com.apple.developer.ubiquity-container-identifiers</key>
<array>
  <string>iCloud.com.bluedomecolorado.shadowApp</string>
</array>
```

### 3.2 CloudKit Database Structure

Shadow uses CloudKit's **Private Database** for user data (not shared/public):

```
┌─────────────────────────────────────────────────────────────────────┐
│                     CLOUDKIT RECORD TYPES                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ShadowProfile                                                      │
│  ├── profileId (STRING, indexed)                                   │
│  ├── clientId (STRING, indexed)                                    │
│  ├── encryptedData (BYTES) - AES-256 encrypted JSON                │
│  ├── dataHash (STRING) - SHA-256 for integrity                     │
│  ├── version (INT64) - optimistic concurrency                      │
│  └── modifiedAt (TIMESTAMP)                                        │
│                                                                     │
│  ShadowEntity                                                       │
│  ├── entityId (STRING, indexed)                                    │
│  ├── profileId (STRING, indexed)                                   │
│  ├── clientId (STRING, indexed)                                    │
│  ├── entityType (STRING) - "supplement", "condition", etc.         │
│  ├── encryptedData (BYTES)                                         │
│  ├── dataHash (STRING)                                             │
│  ├── version (INT64)                                               │
│  └── modifiedAt (TIMESTAMP)                                        │
│                                                                     │
│  ShadowFile                                                         │
│  ├── fileId (STRING, indexed)                                      │
│  ├── entityId (STRING, indexed)                                    │
│  ├── profileId (STRING, indexed)                                   │
│  ├── encryptedAsset (ASSET) - encrypted file data                  │
│  ├── fileHash (STRING)                                             │
│  ├── fileSizeBytes (INT64)                                         │
│  └── modifiedAt (TIMESTAMP)                                        │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 3.3 iCloud Provider Implementation

```dart
// lib/data/cloud/icloud_provider.dart

import 'package:icloud_storage/icloud_storage.dart';

class ICloudProvider implements CloudStorageProvider {
  static const String _containerIdentifier = 'iCloud.com.bluedomecolorado.shadowApp';

  final EncryptionService _encryptionService;

  ICloudProvider(this._encryptionService);

  @override
  Future<bool> isAvailable() async {
    // Check if iCloud is available and user is signed in
    return await ICloudStorage.isICloudAvailable();
  }

  @override
  Future<CloudSyncResult> uploadEntity({
    required String entityId,
    required String entityType,
    required String profileId,
    required String clientId,
    required Map<String, dynamic> data,
    required int version,
  }) async {
    // Encrypt data before upload
    final jsonData = json.encode(data);
    final encryptedData = await _encryptionService.encrypt(jsonData);
    final dataHash = _calculateHash(jsonData);

    // Create CloudKit record
    final record = CKRecord(
      recordType: 'ShadowEntity',
      recordId: CKRecordID(recordName: entityId),
      fields: {
        'entityId': entityId,
        'profileId': profileId,
        'clientId': clientId,
        'entityType': entityType,
        'encryptedData': encryptedData,
        'dataHash': dataHash,
        'version': version,
        'modifiedAt': DateTime.now().toIso8601String(),
      },
    );

    try {
      await _saveRecord(record);
      return CloudSyncResult.success(entityId: entityId, version: version);
    } on CKError catch (e) {
      if (e.code == CKErrorCode.serverRecordChanged) {
        // Conflict detected
        return CloudSyncResult.conflict(
          entityId: entityId,
          localVersion: version,
          serverVersion: e.serverRecord?['version'] as int?,
        );
      }
      return CloudSyncResult.error(entityId: entityId, message: e.message);
    }
  }

  @override
  Future<DownloadResult> downloadEntity({
    required String entityId,
  }) async {
    final record = await _fetchRecord(entityId);
    if (record == null) {
      return DownloadResult.notFound(entityId: entityId);
    }

    final encryptedData = record['encryptedData'] as Uint8List;
    final storedHash = record['dataHash'] as String;

    // Decrypt data
    final jsonData = await _encryptionService.decrypt(encryptedData);

    // Verify integrity
    final calculatedHash = _calculateHash(jsonData);
    if (calculatedHash != storedHash) {
      return DownloadResult.integrityError(entityId: entityId);
    }

    return DownloadResult.success(
      entityId: entityId,
      data: json.decode(jsonData),
      version: record['version'] as int,
    );
  }

  @override
  Future<FileUploadResult> uploadFile({
    required String fileId,
    required String entityId,
    required String profileId,
    required String localPath,
  }) async {
    // Read and encrypt file
    final file = File(localPath);
    final fileBytes = await file.readAsBytes();
    final encryptedBytes = await _encryptionService.encryptBytes(fileBytes);
    final fileHash = _calculateBytesHash(fileBytes);

    // Create CloudKit record with asset
    final record = CKRecord(
      recordType: 'ShadowFile',
      recordId: CKRecordID(recordName: fileId),
      fields: {
        'fileId': fileId,
        'entityId': entityId,
        'profileId': profileId,
        'encryptedAsset': CKAsset(data: encryptedBytes),
        'fileHash': fileHash,
        'fileSizeBytes': fileBytes.length,
        'modifiedAt': DateTime.now().toIso8601String(),
      },
    );

    await _saveRecord(record);
    return FileUploadResult.success(fileId: fileId, cloudUrl: 'icloud://$fileId');
  }

  @override
  Future<List<SyncChange>> getChangesSince(DateTime since) async {
    // Query for records modified since timestamp
    final query = CKQuery(
      recordType: 'ShadowEntity',
      predicate: CKPredicate(
        format: 'modifiedAt > %@',
        arguments: [since.toIso8601String()],
      ),
    );

    final records = await _performQuery(query);
    return records.map((r) => SyncChange(
      entityId: r['entityId'] as String,
      entityType: r['entityType'] as String,
      version: r['version'] as int,
      modifiedAt: DateTime.parse(r['modifiedAt'] as String),
      isDeleted: r['isDeleted'] as bool? ?? false,
    )).toList();
  }

  String _calculateHash(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }

  Uint8List _calculateBytesHash(Uint8List data) {
    return Uint8List.fromList(sha256.convert(data).bytes);
  }
}
```

### 3.4 Sync Workflow (iCloud)

```
┌─────────────────────────────────────────────────────────────────────┐
│                     ICLOUD SYNC WORKFLOW                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. CHECK CONNECTIVITY                                              │
│     └── Verify iCloud available and signed in                      │
│                                                                     │
│  2. PUSH LOCAL CHANGES                                              │
│     ├── Query local DB for sync_is_dirty = 1                       │
│     ├── For each dirty entity:                                     │
│     │   ├── Encrypt data with user's encryption key                │
│     │   ├── Upload to CloudKit private database                    │
│     │   ├── Handle conflicts (server version wins by default)      │
│     │   └── Update local sync_status and sync_last_synced_at       │
│     └── Upload dirty files (photos, documents)                     │
│                                                                     │
│  3. PULL REMOTE CHANGES                                             │
│     ├── Query CloudKit for changes since last sync                 │
│     ├── For each remote change:                                    │
│     │   ├── Download encrypted data                                │
│     │   ├── Decrypt with user's encryption key                     │
│     │   ├── Verify integrity hash                                  │
│     │   ├── Apply to local database                                │
│     │   └── Download associated files if needed                    │
│     └── Update last sync timestamp                                 │
│                                                                     │
│  4. HANDLE CONFLICTS                                                │
│     ├── Default: Last-write-wins based on modifiedAt              │
│     ├── Store conflict data for user review (optional)            │
│     └── Log conflict for debugging                                 │
│                                                                     │
│  5. CLEANUP                                                         │
│     ├── Remove orphaned cloud files                                │
│     ├── Compact local sync metadata                                │
│     └── Schedule next sync (if background sync enabled)            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 3.5 Background Sync (iOS)

```dart
// Configure background app refresh for periodic sync
class ICloudBackgroundSync {
  static const String _backgroundTaskId = 'com.bluedomecolorado.shadow.sync';

  void registerBackgroundTask() {
    // iOS: Use BGTaskScheduler
    // Register in AppDelegate.swift:
    // BGTaskScheduler.shared.register(
    //   forTaskWithIdentifier: "com.bluedomecolorado.shadow.sync",
    //   using: nil
    // ) { task in
    //   self.handleBackgroundSync(task: task as! BGAppRefreshTask)
    // }
  }

  void scheduleBackgroundSync() {
    // Schedule sync to run when device is connected to power and WiFi
    // Minimum interval: 15 minutes (iOS enforced)
  }
}
```

### 3.6 iCloud Storage Limits

| Limit | Value | Handling |
|-------|-------|----------|
| Record size | 1 MB max | Split large data across records |
| Asset size | 250 MB max | Compress files before upload |
| Request rate | 40 requests/sec | Implement request throttling |
| Batch size | 400 records max | Paginate large syncs |

### 3.7 Error Handling

| Error | Cause | Recovery |
|-------|-------|----------|
| `CKErrorNotAuthenticated` | User not signed into iCloud | Prompt to sign in |
| `CKErrorQuotaExceeded` | iCloud storage full | Notify user, pause sync |
| `CKErrorNetworkUnavailable` | No internet | Queue for retry |
| `CKErrorServerRecordChanged` | Conflict | Apply conflict resolution |
| `CKErrorZoneBusy` | Rate limited | Exponential backoff |
| `CKErrorAssetFileNotFound` | File missing | Re-upload from local |

---

## 4. Cloud Provider Selection

### 4.1 User Interface

On first launch or in Settings:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    CLOUD SYNC SETUP                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Choose how to sync your health data:                              │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  [Apple Logo]  iCloud                                       │   │
│  │                                                              │   │
│  │  Sync with your iCloud account. Works seamlessly across     │   │
│  │  iPhone, iPad, and Mac.                                     │   │
│  │                                                              │   │
│  │  • End-to-end encrypted                                     │   │
│  │  • Uses your iCloud storage                                 │   │
│  │  • Automatic background sync                                │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  [Google Logo]  Google Drive                                │   │
│  │                                                              │   │
│  │  Sync with your Google account. Works on all devices.       │   │
│  │                                                              │   │
│  │  • End-to-end encrypted                                     │   │
│  │  • Uses your Google Drive storage                           │   │
│  │  • Cross-platform sync                                      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  [Device Icon]  Offline Only                                │   │
│  │                                                              │   │
│  │  Keep data only on this device. No cloud sync.              │   │
│  │                                                              │   │
│  │  • Maximum privacy                                          │   │
│  │  • No account required                                      │   │
│  │  • Data not backed up to cloud                              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  You can change this later in Settings.                            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 4.2 Provider Factory

```dart
// lib/data/cloud/cloud_provider_factory.dart

enum CloudProviderType { icloud, googleDrive, offline }

class CloudProviderFactory {
  final ICloudProvider _icloudProvider;
  final GoogleDriveProvider _googleDriveProvider;

  CloudStorageProvider? getProvider(CloudProviderType type) {
    switch (type) {
      case CloudProviderType.icloud:
        return _icloudProvider;
      case CloudProviderType.googleDrive:
        return _googleDriveProvider;
      case CloudProviderType.offline:
        return null; // No cloud provider
    }
  }

  Future<bool> isProviderAvailable(CloudProviderType type) async {
    switch (type) {
      case CloudProviderType.icloud:
        // Only available on Apple platforms
        if (!Platform.isIOS && !Platform.isMacOS) return false;
        return await _icloudProvider.isAvailable();
      case CloudProviderType.googleDrive:
        return true; // Available on all platforms
      case CloudProviderType.offline:
        return true; // Always available
    }
  }
}
```

### 4.3 Migration Between Providers

Users can switch cloud providers:

1. **Export from current provider** - Download all encrypted data
2. **Decrypt locally** - All data decrypted on device
3. **Re-encrypt for new provider** - Using same encryption key
4. **Upload to new provider** - Full sync to new cloud
5. **Delete from old provider** - Optional cleanup

```dart
Future<void> migrateCloudProvider({
  required CloudProviderType from,
  required CloudProviderType to,
}) async {
  // 1. Ensure all local data is synced with current provider
  await syncService.fullSync();

  // 2. Update provider preference
  await preferencesService.setCloudProvider(to);

  // 3. Full sync to new provider
  if (to != CloudProviderType.offline) {
    await syncService.fullSync();
  }

  // 4. Optionally delete from old provider
  // (User prompted separately)
}
```

---

## 5. Security Considerations

### 5.1 End-to-End Encryption

Both iCloud and Google Drive use the same encryption:
- **Algorithm:** AES-256-GCM
- **Key derivation:** PBKDF2 with 100,000 iterations
- **Key storage:** Platform keychain (never uploaded)
- **Apple/Google cannot decrypt:** They only see encrypted blobs

### 5.2 Token Security

| Token Type | Storage | Refresh |
|------------|---------|---------|
| Apple identity token | Keychain | Re-authenticate when expired |
| Apple refresh token | Keychain | Long-lived, monitor for revocation |
| Google access token | Keychain | Auto-refresh before expiry |
| Google refresh token | Keychain | 90-day lifetime |

### 5.3 Audit Logging

All cloud operations logged:
```dart
class CloudAuditLog {
  final String operation;    // 'upload', 'download', 'delete'
  final String provider;     // 'icloud', 'googleDrive'
  final String entityType;
  final String entityId;
  final DateTime timestamp;
  final bool success;
  final String? errorMessage;
}
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release - Sign in with Apple, iCloud integration |
