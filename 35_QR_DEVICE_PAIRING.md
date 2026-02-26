# Shadow QR Code & Device Pairing Specification

**Version:** 1.0
**Last Updated:** January 31, 2026
**Purpose:** Complete specification for device pairing, QR codes, and multi-device sync

> ⚠️ **SUPERSEDED DOCUMENT**
>
> This document describes a multi-device sync pairing system (QR codes + Diffie-Hellman key exchange) that was never implemented and has been replaced by the Guest Profile Access system.
> Active spec: See 56_GUEST_PROFILE_ACCESS.md — this is the implemented and complete system.
> This document is retained for historical reference only. Do not implement anything from this document.

> ⚠️ **SUPERSEDED — 2026-02-25**
>
> This document described a multi-device sync pairing system using QR codes and Diffie-Hellman key exchange that was **never implemented**. The QR code use case was replaced by the Guest Profile Access system (`56_GUEST_PROFILE_ACCESS.md`), which serves a different purpose: allowing a guest device to access a single host profile via a token-based invite, rather than pairing devices for full sync.
>
> The device pairing architecture described here (Websocket relay, Diffie-Hellman, master encryption key transfer) may be revisited in a future phase for multi-device sync. Until that phase is planned and approved, this document is **archived** and should not be used as a reference for implementation.

---

## 1. Overview

Shadow supports multiple devices per user account. Device pairing uses QR codes for secure key exchange, enabling end-to-end encrypted sync between devices without sharing encryption keys over the network.

---

## 2. Device Pairing Architecture

### 2.1 Pairing Flow Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                    DEVICE PAIRING FLOW                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  PRIMARY DEVICE (already set up)    NEW DEVICE (being added)       │
│                                                                     │
│  1. User navigates to                                               │
│     Settings → Devices → "Add Device"                              │
│                    │                                                │
│                    ▼                                                │
│  2. Generate pairing session                                        │
│     ├── Create session ID (UUID)                                   │
│     ├── Generate temp pairing key                                  │
│     └── Set expiration (5 minutes)                                 │
│                    │                                                │
│                    ▼                                                │
│  3. Display QR Code containing:       4. New device opens app      │
│     ├── Session ID                       └── Selects "Scan to Join"│
│     ├── User ID                                    │               │
│     ├── Pairing key (encrypted)                    │               │
│     └── Cloud provider type                        ▼               │
│                    │               5. Scans QR code                │
│                    │                  └── Decodes pairing data     │
│                    │                           │                   │
│                    ▼                           ▼                   │
│  6. Websocket connection established between devices               │
│     (via cloud relay OR local network)                             │
│                    │                                                │
│                    ▼                                                │
│  7. Key exchange (Diffie-Hellman)                                  │
│     ├── Both devices generate ephemeral key pairs                  │
│     ├── Exchange public keys                                       │
│     └── Derive shared secret                                       │
│                    │                                                │
│                    ▼                                                │
│  8. Primary device sends:                                          │
│     ├── Encrypted master encryption key                            │
│     ├── Account credentials (encrypted)                            │
│     └── Sync configuration                                         │
│                    │                                                │
│                    ▼                                                │
│  9. New device confirms receipt                                    │
│     ├── Stores encryption key in keychain                         │
│     ├── Registers with cloud provider                              │
│     └── Begins initial sync                                        │
│                    │                                                │
│                    ▼                                                │
│  10. Both devices show "Pairing Complete"                          │
│      └── New device appears in device list                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Security Model

| Layer | Protection |
|-------|------------|
| QR Code | Short-lived (5 min), single-use, contains encrypted data |
| Transport | TLS 1.3 for websocket, local network uses mDNS discovery |
| Key Exchange | X25519 Diffie-Hellman with ephemeral keys |
| Payload | AES-256-GCM encryption with derived shared secret |
| Verification | Both devices display matching 6-digit code for visual confirmation |

---

## 3. QR Code Specification

### 3.1 QR Code Data Format

```json
{
  "v": 1,                              // Protocol version
  "t": "pair",                         // Type: "pair" | "share"
  "sid": "550e8400-e29b-41d4-a716",    // Session ID (UUID)
  "uid": "user_abc123",                 // User identifier
  "pk": "base64_encoded_public_key",   // Ephemeral public key (X25519)
  "salt": "base64_encoded_16_bytes",   // HKDF session salt (16 bytes, REQUIRED for key derivation)
  "cp": "icloud",                       // Cloud provider: "icloud" | "gdrive" | "offline"
  "exp": 1706745600,                   // Expiration timestamp (Unix)
  "sig": "base64_signature"            // HMAC-SHA256 signature
}
```

**CRITICAL: Session Salt Field**
The `salt` field is essential for HKDF key derivation. Both devices MUST use the same salt to derive identical encryption keys from the Diffie-Hellman shared secret.

- **Generated by:** Primary device (QR code generator)
- **Size:** 16 bytes of cryptographically secure random data
- **Encoding:** Base64
- **Purpose:** HKDF-SHA256 salt for deriving AES-256-GCM encryption key

### 3.2 QR Code Generation

```dart
// lib/core/services/qr_pairing_service.dart

class QRPairingService {
  static const Duration sessionExpiry = Duration(minutes: 5);

  final CryptoService _cryptoService;
  final SecureStorage _secureStorage;
  final AuditLogService _auditLogService;  // REQUIRED: Audit logging for HIPAA

  Future<PairingSession> createPairingSession({
    required DeviceInfo deviceInfo,
    required String cloudProvider,
  }) async {
    // Generate session
    final sessionId = const Uuid().v4();
    final expiresAt = DateTime.now().add(sessionExpiry);

    // SEC-02: AUDIT LOG - Device pairing initiated (HIPAA CRITICAL)
    // Log BEFORE session creation to capture all attempts including failures
    await _auditLog.log(AuditEventType.devicePairingInitiated, {
      'sessionId': sessionId,
      'deviceId': deviceInfo.deviceId,
      'deviceName': deviceInfo.deviceName,
      'cloudProvider': cloudProvider,
      'expiresAt': expiresAt.toIso8601String(),
    });

    // Generate ephemeral X25519 key pair
    final keyPair = await _cryptoService.generateX25519KeyPair();

    // CRITICAL: Generate session salt for HKDF key derivation
    // This salt is shared via QR code so both devices derive the same key
    final sessionSalt = await _cryptoService.generateSecureRandom(16);

    // Get current user
    final userId = await _secureStorage.getUserId();
    final cloudProvider = await _secureStorage.getCloudProvider();

    // Create payload (includes salt for key derivation)
    final payload = PairingPayload(
      version: 1,
      type: 'pair',
      sessionId: sessionId,
      userId: userId,
      publicKey: base64Encode(keyPair.publicKey),
      salt: base64Encode(sessionSalt),  // REQUIRED for HKDF
      cloudProvider: cloudProvider,
      expiresAt: expiresAt.millisecondsSinceEpoch ~/ 1000,
    );

    // Sign payload (includes salt to prevent tampering)
    final signature = await _cryptoService.hmacSign(
      payload.toSignableString(),
      await _secureStorage.getDeviceKey(),
    );

    payload.signature = base64Encode(signature);

    // Generate QR code
    final qrData = json.encode(payload.toJson());

    return PairingSession(
      sessionId: sessionId,
      privateKey: keyPair.privateKey,
      sessionSalt: sessionSalt,  // Store for HKDF key derivation
      qrData: qrData,
      expiresAt: expiresAt,
    );
  }

  String generateQRCode(String data) {
    // Use qr_flutter package
    // Error correction: Level H (30% recovery)
    // Size: 300x300 minimum for reliable scanning
    return QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    ).toImageData(300);
  }
}

@freezed
class PairingPayload with _$PairingPayload {
  factory PairingPayload({
    required int version,
    required String type,
    required String sessionId,
    required String userId,
    required String publicKey,
    required String salt,          // REQUIRED: 16-byte session salt (base64)
    required String cloudProvider,
    required int expiresAt,
    String? signature,
  }) = _PairingPayload;

  factory PairingPayload.fromJson(Map<String, dynamic> json) =>
      _$PairingPayloadFromJson(json);

  String toSignableString() {
    // CRITICAL: Salt MUST be included in signature to prevent tampering
    return '$version:$type:$sessionId:$userId:$publicKey:$salt:$cloudProvider:$expiresAt';
  }
}

/// Pairing Session Entity (persisted to track QR code state)
@freezed
class PairingSession with _$PairingSession {
  factory PairingSession({
    required String sessionId,        // Same as sid in QR code
    required String initiatingDeviceId,
    required String initiatingUserId,
    required Uint8List privateKey,    // Ephemeral X25519 private key
    required Uint8List sessionSalt,   // HKDF salt for key derivation
    required String qrData,           // Encoded QR payload
    required int createdAt,           // Epoch ms
    required int expiresAt,           // Epoch ms
    int? scannedAt,                   // When QR was scanned
    String? scannedByDeviceId,        // Device that scanned
    int? completedAt,                 // When pairing finished
    int? failedAt,                    // If pairing failed
    String? failureReason,
    required PairingSessionStatus status,
  }) = _PairingSession;
}

enum PairingSessionStatus {
  pending,      // QR generated, waiting for scan
  scanned,      // QR scanned, key exchange in progress
  completed,    // Pairing successful
  expired,      // QR expired without use
  failed,       // Pairing failed
  cancelled,    // User cancelled
}

/// Pairing Session Repository Interface
abstract class PairingSessionRepository {
  /// Get session by ID (returns null if not found or expired)
  Future<PairingSession?> getBySessionId(String sessionId);

  /// Create new pairing session
  Future<void> create(PairingSession session);

  /// Mark session as scanned (single-use enforcement)
  Future<bool> markScannedAtomic(String sessionId, String deviceId, int scannedAt);

  /// Mark session as completed
  Future<void> markCompleted(String sessionId, int completedAt);

  /// Mark session as failed
  Future<void> markFailed(String sessionId, String reason, int failedAt);

  /// Delete expired sessions (run periodically)
  Future<int> cleanupExpired();

  /// Get active sessions for user (for device management UI)
  Future<List<PairingSession>> getActiveSessionsForUser(String userId);
}
```

**Database Schema for Pairing Sessions:**

```sql
-- Add to 10_DATABASE_SCHEMA.md
CREATE TABLE pairing_sessions (
  session_id TEXT PRIMARY KEY,
  initiating_device_id TEXT NOT NULL,
  initiating_user_id TEXT NOT NULL,
  private_key_encrypted TEXT NOT NULL,   -- Encrypted with device key
  session_salt TEXT NOT NULL,            -- Base64 encoded
  qr_data TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  expires_at INTEGER NOT NULL,
  scanned_at INTEGER,
  scanned_by_device_id TEXT,
  completed_at INTEGER,
  failed_at INTEGER,
  failure_reason TEXT,
  status INTEGER NOT NULL DEFAULT 0,

  FOREIGN KEY (initiating_user_id) REFERENCES user_accounts(id),
  FOREIGN KEY (initiating_device_id) REFERENCES device_registrations(id)
);

CREATE INDEX idx_pairing_user ON pairing_sessions(initiating_user_id, created_at DESC);
CREATE INDEX idx_pairing_status ON pairing_sessions(status, expires_at);
CREATE INDEX idx_pairing_cleanup ON pairing_sessions(expires_at) WHERE status = 0;
```

**Single-Use Enforcement:**

```dart
/// Atomic mark-as-scanned with race condition handling
Future<bool> markScannedAtomic(
  String sessionId,
  String deviceId,
  int scannedAt,
) async {
  final result = await _db.rawUpdate('''
    UPDATE pairing_sessions
    SET scanned_at = ?, scanned_by_device_id = ?, status = 1
    WHERE session_id = ? AND scanned_at IS NULL AND status = 0
  ''', [scannedAt, deviceId, sessionId]);
  return result > 0;  // true if row was updated (first scanner wins)
}
```

### 3.3 QR Code Display UI

```
┌─────────────────────────────────────────────────────────────────────┐
│                       ADD NEW DEVICE                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│              Scan this code with your new device                   │
│                                                                     │
│                    ┌───────────────────┐                           │
│                    │                   │                           │
│                    │    [QR CODE]      │                           │
│                    │    ████████████   │                           │
│                    │    ██        ██   │                           │
│                    │    ████████████   │                           │
│                    │                   │                           │
│                    └───────────────────┘                           │
│                                                                     │
│                    Expires in: 4:32                                │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  On your new device:                                               │
│  1. Install Shadow from the App Store                              │
│  2. Open the app and tap "I have an existing account"              │
│  3. Tap "Scan QR Code" and point camera at this code               │
│                                                                     │
│                      [Cancel]                                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 4. QR Code Scanning

### 4.1 Scanner Implementation

```dart
// lib/presentation/screens/scan_qr_screen.dart

class ScanQRScreen extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan to Join')),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              _handleScannedCode(barcode.rawValue!, ref);
            }
          }
        },
      ),
    );
  }

  Future<void> _handleScannedCode(String data, WidgetRef ref) async {
    // Validate QR code using Result pattern
    final validationResult = _validateQrCode(data);

    validationResult.when(
      success: (payload) async {
        // Proceed with pairing
        final pairingResult = await ref
            .read(pairingServiceProvider)
            .initiatePairing(payload);

        pairingResult.when(
          success: (_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PairingConfirmationScreen()),
            );
          },
          failure: (error) => _showError(error.userMessage),
        );
      },
      failure: (error) => _showError(error.userMessage),
    );
  }

  Result<PairingPayload, AppError> _validateQrCode(String data) {
    try {
      final payload = PairingPayload.fromJson(json.decode(data));

      // Validate version
      if (payload.version != 1) {
        return Failure(ValidationError.invalidFormat(
          'Unsupported QR code version',
        ));
      }

      // Validate type
      if (payload.type != 'pair') {
        return Failure(ValidationError.invalidFormat(
          'Invalid QR code type',
        ));
      }

      // Check expiration
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        payload.expiresAt * 1000,
      );
      if (DateTime.now().isAfter(expiresAt)) {
        return Failure(ValidationError.expired(
          'This QR code has expired. Please generate a new one.',
        ));
      }

      // Check single-use (CRITICAL: QR codes are single-use only)
      final session = await _sessionRepository.getBySessionId(payload.sessionId);
      if (session?.usedAt != null) {
        return Failure(ValidationError.alreadyUsed(
          'This QR code has already been used.',
        ));
      }

      return Success(payload);
    } catch (e) {
      return Failure(ValidationError.invalidFormat(
        'Invalid QR code format',
      ));
    }
  }

  /// Mark QR session as used (call immediately after successful validation)
  Future<void> markSessionUsed(String sessionId) async {
    await _sessionRepository.markUsed(sessionId, DateTime.now());
  }
}
```

### 4.2 Validation Rules

| Check | Failure Message |
|-------|-----------------|
| Version mismatch | "This QR code is from a newer version of Shadow. Please update the app." |
| Wrong type | "This QR code is not for device pairing." |
| Expired | "This QR code has expired. Please generate a new one on the primary device." |
| Invalid signature | "This QR code appears to be invalid. Please try again." |
| Already used | "This QR code has already been used." |
| Network unavailable | "Internet connection required to complete pairing." |

---

## 5. Key Exchange Protocol

### 5.1 Diffie-Hellman Key Exchange

```dart
// lib/core/services/key_exchange_service.dart

class KeyExchangeService {
  final CryptoService _cryptoService;
  final AuditLogService _auditLogService;  // REQUIRED: Audit logging for HIPAA

  /// X25519 Diffie-Hellman key exchange
  /// SEC-03: All key exchange operations MUST be audit logged for HIPAA compliance
  Future<SharedSecret> performKeyExchange({
    required String sessionId,
    required String localDeviceId,
    required String remoteDeviceId,
    required Uint8List localPrivateKey,
    required Uint8List remotePublicKey,
    required Uint8List sessionSalt,
  }) async {
    // SEC-03: AUDIT LOG - Key exchange initiated (HIPAA CRITICAL)
    // Log BEFORE exchange to capture all attempts including failures
    await _auditLogService.log(AuditEntry(
      action: AuditAction.keyExchangeInitiated,
      entityType: 'PairingSession',
      entityId: sessionId,
      timestamp: DateTime.now(),
      metadata: {
        'localDeviceId': localDeviceId,
        'remoteDeviceId': remoteDeviceId,
        'exchangeProtocol': 'X25519-DH',
      },
    ));

    // Perform X25519 scalar multiplication
    final sharedSecret = await _cryptoService.x25519(
      localPrivateKey,
      remotePublicKey,
    );

    // Derive encryption key using HKDF
    // CRITICAL: Use the salt from QR code payload (both devices have same salt)
    // The salt was generated by the primary device and shared via QR code
    final derivedKey = await _cryptoService.hkdfDerive(
      inputKey: sharedSecret,
      salt: sessionSalt,  // From QR code payload (base64 decoded)
      info: utf8.encode('shadow-pair-v1-encryption'),  // Versioned info string
      length: 32, // 256 bits for AES-256-GCM
    );

    // Derive separate authentication key (defense in depth)
    final authKey = await _cryptoService.hkdfDerive(
      inputKey: sharedSecret,
      salt: sessionSalt,
      info: utf8.encode('shadow-pair-v1-authentication'),
      length: 32,
    );

    // SEC-03: AUDIT LOG - Key exchange completed successfully
    await _auditLogService.log(AuditEntry(
      action: AuditAction.keyExchangeCompleted,
      entityType: 'PairingSession',
      entityId: sessionId,
      timestamp: DateTime.now(),
      metadata: {
        'localDeviceId': localDeviceId,
        'remoteDeviceId': remoteDeviceId,
        // SECURITY: Never log the actual keys!
        'keyDerivationAlgorithm': 'HKDF-SHA256',
        'keyLength': 256,
      },
    ));

    return SharedSecret(
      encryptionKey: derivedKey,
      authenticationKey: authKey,
      createdAt: DateTime.now(),
    );
  }

  /// SEC-03: Log failed key exchange attempts
  Future<void> _logKeyExchangeFailure({
    required String sessionId,
    required String localDeviceId,
    required String? remoteDeviceId,
    required String failureReason,
  }) async {
    await _auditLogService.log(AuditEntry(
      action: AuditAction.keyExchangeFailed,
      entityType: 'PairingSession',
      entityId: sessionId,
      timestamp: DateTime.now(),
      result: AuditResult.failure,
      metadata: {
        'localDeviceId': localDeviceId,
        'remoteDeviceId': remoteDeviceId,
        'failureReason': failureReason,
      },
    ));
  }
}
```

### 5.2 Visual Verification

Both devices display a 6-digit verification code derived from the shared secret:

```dart
String generateVerificationCode(Uint8List sharedSecret) {
  // Take first 4 bytes of SHA-256 hash
  final hash = sha256.convert(sharedSecret);
  final bytes = hash.bytes.sublist(0, 4);

  // Convert to 6-digit number
  final number = ByteData.view(Uint8List.fromList(bytes).buffer).getUint32(0);
  return (number % 1000000).toString().padLeft(6, '0');
}
```

**Verification UI:**

```
┌─────────────────────────────────────────────────────────────────────┐
│                    VERIFY CONNECTION                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Verify this code matches on both devices:                         │
│                                                                     │
│                       ┌─────────────┐                              │
│                       │   847 293   │                              │
│                       └─────────────┘                              │
│                                                                     │
│  If the codes match, tap "Confirm" on both devices.               │
│  If they don't match, tap "Cancel" - someone may be               │
│  trying to intercept your connection.                              │
│                                                                     │
│           [Cancel]              [Confirm Match]                    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 6. Credential Transfer

### 6.1 Transferred Data

After successful key exchange, primary device sends:

```dart
@freezed
class PairingCredentials with _$PairingCredentials {
  factory PairingCredentials({
    required String masterEncryptionKey,     // AES-256 key for data encryption
    required String cloudAuthToken,          // OAuth token for cloud provider
    required String cloudRefreshToken,       // Refresh token
    required String userId,
    required String userEmail,
    required String userName,
    required List<String> profileIds,        // Accessible profiles
    required Map<String, String> profileKeys, // Per-profile encryption keys
    required SyncConfiguration syncConfig,
  }) = _PairingCredentials;
}
```

### 6.1.1 Credential Transfer Timeouts

**CRITICAL: All credential transfer operations have strict timeouts:**

| Phase | Timeout | Action on Timeout |
|-------|---------|-------------------|
| QR Code Validity | **5 minutes** | QR code expires, new one required |
| Key Exchange | **30 seconds** | Abort pairing, show error |
| Credential Transfer | **60 seconds** | Abort pairing, clear partial data |
| Full Pairing Process | **10 minutes** | Complete timeout, start over |

```dart
class PairingTimeouts {
  /// QR code expires after this duration
  static const Duration qrCodeValidity = Duration(minutes: 5);

  /// Key exchange must complete within this window
  static const Duration keyExchangeTimeout = Duration(seconds: 30);

  /// Credential transfer must complete within this window
  static const Duration credentialTransferTimeout = Duration(seconds: 60);

  /// Overall pairing process timeout
  static const Duration fullPairingTimeout = Duration(minutes: 10);

  /// Interval for showing "connecting..." status updates
  static const Duration progressUpdateInterval = Duration(seconds: 5);
}
```

**On Timeout Behavior:**
1. Cancel all pending operations
2. Clear any partially transferred credentials from memory
3. Log timeout event to audit (with timeout phase)
4. Display user-friendly error message
5. Offer option to restart pairing process

### 6.2 Secure Transfer

```dart
/// SEC-04: Credential transfer with comprehensive audit logging
/// All credential transfers MUST be logged for HIPAA compliance
Future<void> transferCredentials({
  required SharedSecret sharedSecret,
  required PairingCredentials credentials,
  required String sessionId,
  required String targetDeviceId,
  required String sourceDeviceId,
}) async {
  // SEC-04: AUDIT LOG - Credential transfer initiated (HIPAA CRITICAL)
  // Log BEFORE transfer - captures attempt even if transfer fails
  await _auditLogService.log(AuditEntry(
    action: AuditAction.credentialTransferInitiated,
    entityType: 'PairingSession',
    entityId: sessionId,
    timestamp: DateTime.now(),
    metadata: {
      'sourceDeviceId': sourceDeviceId,
      'targetDeviceId': targetDeviceId,
      'profileCount': credentials.profileIds.length,
      'profileIds': credentials.profileIds,  // Log which profiles are being transferred
      'hasEncryptionKey': true,  // SECURITY: Never log the actual key!
      'hasOAuthTokens': true,    // SECURITY: Never log the actual tokens!
      'transferProtocol': 'AES-256-GCM',
    },
  ));

  // Serialize credentials
  final jsonData = json.encode(credentials.toJson());

  // Encrypt with shared secret
  final encrypted = await _cryptoService.aesGcmEncrypt(
    plaintext: utf8.encode(jsonData),
    key: sharedSecret.encryptionKey,
  );

  // Send via secure channel
  await _pairingChannel.send(PairingMessage(
    type: 'credentials',
    payload: base64Encode(encrypted),
  ));

  // SEC-04: AUDIT LOG - Credential transfer completed successfully
  await _auditLogService.log(AuditEntry(
    action: AuditAction.credentialTransferCompleted,
    entityType: 'PairingSession',
    entityId: sessionId,
    timestamp: DateTime.now(),
    metadata: {
      'sourceDeviceId': sourceDeviceId,
      'targetDeviceId': targetDeviceId,
      'transferredProfiles': credentials.profileIds,
      'encryptedPayloadSize': encrypted.length,
    },
  ));
}

/// SEC-04: Log failed credential transfer attempts
Future<void> _logCredentialTransferFailure({
  required String sessionId,
  required String sourceDeviceId,
  required String targetDeviceId,
  required String failureReason,
}) async {
  await _auditLogService.log(AuditEntry(
    action: AuditAction.credentialTransferFailed,
    entityType: 'PairingSession',
    entityId: sessionId,
    timestamp: DateTime.now(),
    result: AuditResult.failure,
    metadata: {
      'sourceDeviceId': sourceDeviceId,
      'targetDeviceId': targetDeviceId,
      'failureReason': failureReason,
    },
  ));
}
```

### 6.3 Required Audit Actions for Device Pairing

The following `AuditAction` enum values MUST be defined in `22_API_CONTRACTS.md`:

| Action | When Logged | Metadata |
|--------|-------------|----------|
| `devicePairingInitiated` | QR code generated | sessionId, expiresAt |
| `devicePairingScanned` | QR code scanned by new device | sessionId, newDeviceId |
| `keyExchangeInitiated` | DH key exchange started | sessionId, localDeviceId, remoteDeviceId |
| `keyExchangeCompleted` | DH key exchange successful | sessionId, bothDeviceIds, keyDerivationAlgorithm |
| `credentialTransferInitiated` | Before sending credentials | sessionId, targetDeviceId, profileCount |
| `credentialTransferCompleted` | After successful transfer | sessionId, profileIds |
| `devicePairingCompleted` | Full pairing complete | sessionId, newDeviceId, newDeviceName |
| `devicePairingFailed` | Any pairing failure | sessionId, errorCode, errorMessage |
| `deviceRevoked` | Device removed by user | deviceId, deviceName, revokedBy |
| `keyExchangeFailed` | Key exchange failure | sessionId, localDeviceId, remoteDeviceId, failureReason |
| `credentialTransferFailed` | Credential transfer failure | sessionId, sourceDeviceId, targetDeviceId, failureReason |
| `hipaaAuthorizationGranted` | HIPAA authorization created | authorizationId, profileId, grantedToUserId, scope, expiresAt |
| `hipaaAuthorizationRevoked` | HIPAA authorization revoked | authorizationId, profileId, revokedByUserId, revocationReason |
| `hipaaAuthorizationExpired` | HIPAA authorization auto-expired | authorizationId, profileId, expiredAt |
| `authorizationAccessDenied` | Failed authorization attempt | profileId, attemptedUserId, reason, attemptedAction |
| `authorizationCheckFailed` | Authorization validation error | profileId, userId, errorType |

---

## 7. Multi-Device Sync Protocol

### 7.1 Device Registration

Each device is registered in the cloud:

```dart
@freezed
class DeviceRegistration with _$DeviceRegistration {
  factory DeviceRegistration({
    required String id,               // Unique device ID
    required String userId,
    required String deviceName,       // "Reid's iPhone 15"
    required DeviceType deviceType,   // ios, android, macos
    required String osVersion,
    required String appVersion,
    required int registeredAt,        // Epoch milliseconds
    required int lastSeenAt,          // Epoch milliseconds
    required bool isActive,
    required String pushToken,        // For notifications
  }) = _DeviceRegistration;
}

/// CANONICAL: See 22_API_CONTRACTS.md
enum DeviceType {
  iOS(0),
  android(1),
  macOS(2),
  web(3);

  final int value;
  const DeviceType(this.value);
}
```

### 7.2 Sync Coordination

```
┌─────────────────────────────────────────────────────────────────────┐
│                    MULTI-DEVICE SYNC                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Device A (iPhone)        Cloud          Device B (Mac)            │
│        │                    │                   │                  │
│        │                    │                   │                  │
│  1. User creates           │                   │                  │
│     new supplement         │                   │                  │
│        │                    │                   │                  │
│        │  ──── Push change ────►               │                  │
│        │                    │                   │                  │
│        │                    │  ◄─── Notify ───  │                  │
│        │                    │     (push/poll)   │                  │
│        │                    │                   │                  │
│        │                    │  ──── Pull ────►  │                  │
│        │                    │                   │                  │
│        │                    │  ◄─── Changes ─── │                  │
│        │                    │                   │                  │
│        │                    │     2. Device B   │                  │
│        │                    │        receives   │                  │
│        │                    │        supplement │                  │
│        │                    │                   │                  │
│  3. Both devices now have same data            │                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 7.3 Conflict Resolution

When two devices modify the same entity:

```dart
/// CANONICAL: See 22_API_CONTRACTS.md
enum ConflictResolution {
  keepLocal,   // Use local version, overwrite remote
  keepRemote,  // Use remote version, overwrite local
  merge,       // Merge both versions (for compatible changes)
}

class ConflictResolver {
  Future<ResolvedEntity> resolve({
    required SyncEntity local,
    required SyncEntity remote,
    required ConflictResolution strategy,
  }) async {
    switch (strategy) {
      case ConflictResolution.keepLocal:
        return local; // Use local version, overwrite remote

      case ConflictResolution.keepRemote:
        return remote; // Use remote version, overwrite local

      case ConflictResolution.merge:
        // Merge both versions (for compatible changes)
        // Implementation depends on entity type - merge non-conflicting fields
        return _mergeEntities(local, remote);
    }
  }

  SyncEntity _mergeEntities(SyncEntity local, SyncEntity remote) {
    // Merge strategy: take most recent value for each field
    // Use remote as base, override with newer local fields
    if (local.modifiedAt.isAfter(remote.modifiedAt)) {
      return local;
    }
    return remote;
  }
}
```

---

## 8. Profile Sharing (Coach/Client)

### 8.1 Sharing Flow

Coaches can share specific profiles with clients:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SHARE PROFILE                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  COACH'S DEVICE                     CLIENT'S DEVICE                │
│                                                                     │
│  1. Select profile                                                  │
│     "Client: John Smith"                                           │
│        │                                                            │
│        ▼                                                            │
│  2. Tap "Share Access"                                             │
│        │                                                            │
│        ▼                                                            │
│  3. Set permissions:              4. Client opens "Join Profile"   │
│     ☑ Read own data                     │                          │
│     ☑ Add entries                       ▼                          │
│     ☐ Edit entries              5. Scans share QR code             │
│     ☐ Delete entries                    │                          │
│     ☑ View reports                      ▼                          │
│        │                        6. Receives profile access         │
│        ▼                           ├── Profile encryption key      │
│  4. Generate share code            ├── Permissions                 │
│     [QR CODE]                      └── Profile data syncs          │
│        │                                │                          │
│        ▼                                ▼                          │
│  7. Coach retains owner access   8. Client sees profile in app    │
│     ├── Full permissions            ├── Limited by permissions    │
│     ├── Can revoke access           └── Cannot share to others    │
│     └── Sees client's entries                                      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.2 Share QR Code Data

```json
{
  "v": 1,
  "t": "share",                        // Type: share (not pair)
  "pid": "profile_uuid",               // Profile ID
  "pn": "Client: John Smith",          // Profile name (for display)
  "pk": "encrypted_profile_key",       // Profile encryption key
  "perms": ["read", "add", "reports"], // Granted permissions
  "exp": 1706745600,                   // Expiration
  "gby": "coach_user_id",              // Granted by
  "sig": "signature"
}
```

### 8.3 Permission Levels

| Permission | Description | Coach | Client (Read-Write) | Client (Read-Only) |
|------------|-------------|-------|---------------------|-------------------|
| `read` | View all profile data | ✓ | ✓ | ✓ |
| `add` | Create new entries | ✓ | ✓ | ✗ |
| `edit` | Modify existing entries | ✓ | ✓ | ✗ |
| `delete` | Delete entries | ✓ | ✗ | ✗ |
| `reports` | Generate/export reports | ✓ | ✓ | ✓ |
| `share` | Share profile with others | ✓ | ✗ | ✗ |
| `settings` | Modify profile settings | ✓ | ✗ | ✗ |

### 8.4 HIPAA Authorization for Profile Sharing

When health data is shared with another person (coach, family member, caregiver), HIPAA requires explicit authorization from the data owner. Shadow implements this through a digital authorization flow.

#### 8.4.1 Authorization Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    HIPAA AUTHORIZATION FLOW                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  PROFILE OWNER                        RECIPIENT (Coach/Caregiver)  │
│                                                                     │
│  1. Initiates "Share Profile"                                       │
│        │                                                            │
│        ▼                                                            │
│  2. Reviews authorization form:                                     │
│     ┌─────────────────────────────────────────────────────────┐    │
│     │  AUTHORIZATION TO SHARE HEALTH INFORMATION              │    │
│     │                                                          │    │
│     │  I, [Profile Name], authorize Shadow to share my        │    │
│     │  health information with [Recipient Name/Email].        │    │
│     │                                                          │    │
│     │  Information to be shared:                               │    │
│     │  ☑ Health conditions and symptoms                       │    │
│     │  ☑ Supplement intake logs                                │    │
│     │  ☑ Food and diet records                                 │    │
│     │  ☑ Sleep data                                            │    │
│     │  ☑ Activity logs                                         │    │
│     │  ☐ Photos (optional - explicit consent required)        │    │
│     │  ☑ Journal entries                                       │    │
│     │                                                          │    │
│     │  Purpose: Health coaching and wellness support          │    │
│     │                                                          │    │
│     │  Duration: ○ Until I revoke  ○ 30 days  ○ 90 days      │    │
│     │                                                          │    │
│     │  I understand that:                                      │    │
│     │  • I can revoke this authorization at any time          │    │
│     │  • Revocation will not affect data already accessed     │    │
│     │  • The recipient may not re-share my data               │    │
│     │  • I will receive notifications when data is accessed   │    │
│     │                                                          │    │
│     │  [Cancel]                    [I Authorize This Sharing] │    │
│     └─────────────────────────────────────────────────────────┘    │
│        │                                                            │
│        ▼                                                            │
│  3. Digital signature captured:                                     │
│     ├── Timestamp (UTC)                                            │
│     ├── Device identifier                                          │
│     ├── IP address (for audit)                                     │
│     └── Biometric/PIN confirmation                                 │
│        │                                                            │
│        ▼                                                            │
│  4. QR code generated with authorization token                     │
│        │                                       │                   │
│        │                                       ▼                   │
│        │                        5. Recipient scans QR code         │
│        │                           ├── Receives authorization ID   │
│        │                           └── Access granted per scope    │
│        ▼                                       │                   │
│  6. Authorization record stored:               ▼                   │
│     ├── authorization_id               7. Recipient sees shared   │
│     ├── profile_id                        profile with limited    │
│     ├── granted_to_user_id                permissions              │
│     ├── granted_by_user_id                                         │
│     ├── scope (data types)                                         │
│     ├── purpose                                                    │
│     ├── expires_at                                                 │
│     ├── signature_timestamp                                        │
│     ├── device_id                                                  │
│     └── ip_address                                                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### 8.4.2 Authorization Entity

```dart
@freezed
class HipaaAuthorization with _$HipaaAuthorization {
  const factory HipaaAuthorization({
    required String id,
    required String clientId,
    required String profileId,
    required String grantedToUserId,
    required String grantedByUserId,
    required AccessLevel accessLevel,          // read_only or read_write
    required List<DataScope> scope,            // Which data types are shared
    required String purpose,                   // "Health coaching", "Family caregiver", etc.
    required AuthorizationDuration duration,
    required int authorizedAt,                 // Epoch ms
    int? expiresAt,                            // Epoch ms
    int? revokedAt,                            // Epoch ms
    String? revocationReason,
    required String signatureDeviceId,
    required String signatureIpAddress,
    required bool photosIncluded,              // Explicit consent for photos
    required SyncMetadata syncMetadata,
  }) = _HipaaAuthorization;

  factory HipaaAuthorization.fromJson(Map<String, dynamic> json) =>
      _$HipaaAuthorizationFromJson(json);
}

/// Access level for profile sharing - CANONICAL: See 22_API_CONTRACTS.md
enum AccessLevel {
  readOnly,   // Can only view data within scope
  readWrite,  // Can view and create/update data (no delete)
  owner,      // Full access (profile owner)
}

/// Write operation types for authorization checks
enum WriteOperation {
  create,      // Add new entry
  update,      // Modify existing entry
  softDelete,  // Mark as deleted (reversible)
  hardDelete;  // Permanently remove (requires owner)

  /// Map to access action for audit logging
  ProfileAccessAction toAccessAction() {
    return switch (this) {
      WriteOperation.create => ProfileAccessAction.addEntry,
      WriteOperation.update => ProfileAccessAction.editEntry,
      WriteOperation.softDelete => ProfileAccessAction.editEntry,
      WriteOperation.hardDelete => ProfileAccessAction.editEntry,
    };
  }
}

enum DataScope {
  conditions,        // Health conditions and symptom logs
  supplements,       // Supplement definitions and intake logs
  food,              // Food items and meal logs
  sleep,             // Sleep entries
  activities,        // Activity definitions and logs
  fluids,            // Fluids tracking (water, bowel, urine, menstruation, BBT)
  photos,            // Photo documentation (requires explicit consent)
  journal,           // Journal entries
  reports,           // Generated reports
  insights,          // Intelligence system insights and patterns
}

enum AuthorizationDuration {
  untilRevoked,      // No expiration
  days30,            // 30 days
  days90,            // 90 days
  days180,           // 6 months
  days365,           // 1 year
}
```

#### 8.4.3 Access Audit Log

All access to shared profiles is logged for HIPAA compliance:

```dart
@freezed
class ProfileAccessLog with _$ProfileAccessLog {
  const factory ProfileAccessLog({
    required String id,
    required String authorizationId,
    required String profileId,
    required String accessedByUserId,
    required String accessedByDeviceId,
    required AccessAction action,
    required String entityType,               // 'condition', 'supplement', etc.
    required String? entityId,
    required int accessedAt,                  // Epoch milliseconds
    required String ipAddress,
  }) = _ProfileAccessLog;
}

enum AccessAction {
  view,              // Viewed data
  export,            // Exported/downloaded data
  addEntry,          // Added new entry
  editEntry,         // Modified existing entry
}
```

#### 8.4.4 Revocation Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    REVOKE AUTHORIZATION                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Profile Owner selects "Manage Shared Access"                       │
│        │                                                            │
│        ▼                                                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  SHARED WITH                                                 │   │
│  │                                                              │   │
│  │  👤 Sarah Johnson (Health Coach)                            │   │
│  │     Authorized: Jan 15, 2026                                │   │
│  │     Expires: Until revoked                                   │   │
│  │     Last accessed: 2 hours ago                              │   │
│  │     Access scope: Conditions, Supplements, Food, Sleep      │   │
│  │                                                              │   │
│  │     [View Access Log]              [Revoke Access]          │   │
│  │                                                              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│        │                                                            │
│        ▼ (Revoke Access tapped)                                    │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  CONFIRM REVOCATION                                          │   │
│  │                                                              │   │
│  │  Are you sure you want to revoke Sarah Johnson's access?    │   │
│  │                                                              │   │
│  │  • They will no longer see your health data                 │   │
│  │  • They will be notified of the revocation                  │   │
│  │  • Data they already downloaded cannot be deleted           │   │
│  │                                                              │   │
│  │  Reason (optional): [________________________]              │   │
│  │                                                              │   │
│  │  [Cancel]                         [Revoke Access]           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│        │                                                            │
│        ▼                                                            │
│  1. Authorization marked as revoked                                 │
│  2. Recipient's access tokens invalidated                          │
│  3. Profile removed from recipient's device on next sync           │
│  4. Recipient receives notification: "Access revoked by [Name]"    │
│  5. Audit log records revocation event                             │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### 8.4.4a SEC-07: HIPAA Authorization Audit Logging Requirements

> **CRITICAL SECURITY REQUIREMENT (SEC-07):**
> ALL HIPAA authorization grant and revoke operations MUST be comprehensively logged.
> This is a legal requirement under HIPAA for tracking access to PHI.

**Grant Authorization Audit Logging:**

```dart
/// SEC-07: Grant HIPAA authorization with comprehensive audit logging
class HipaaAuthorizationService {
  final AuditLogService _auditLog;
  final HipaaAuthorizationRepository _repository;

  /// Grant authorization - MUST log before and after for HIPAA compliance
  Future<Result<HipaaAuthorization, AppError>> grantAuthorization({
    required String profileId,
    required String grantedToUserId,
    required String grantedByUserId,
    required List<DataScope> scope,
    required String purpose,
    required AuthorizationDuration duration,
    required String signatureDeviceId,
    required String signatureIpAddress,
    required bool photosIncluded,
  }) async {
    final authorizationId = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    // SEC-07: AUDIT LOG - Authorization grant attempt (log BEFORE)
    await _auditLog.log(AuditEntry(
      action: AuditAction.hipaaAuthorizationGrantInitiated,
      entityType: 'HipaaAuthorization',
      entityId: authorizationId,
      timestamp: DateTime.now(),
      metadata: {
        'profileId': profileId,
        'grantedToUserId': grantedToUserId,
        'grantedByUserId': grantedByUserId,
        'scope': scope.map((s) => s.name).toList(),
        'purpose': purpose,
        'duration': duration.name,
        'photosIncluded': photosIncluded,
        'signatureDeviceId': signatureDeviceId,
        'signatureIpAddress': signatureIpAddress,
      },
    ));

    try {
      // Calculate expiration
      final expiresAt = _calculateExpiration(duration, now);

      // Create authorization record
      final authorization = HipaaAuthorization(
        id: authorizationId,
        clientId: _clientId,
        profileId: profileId,
        grantedToUserId: grantedToUserId,
        grantedByUserId: grantedByUserId,
        accessLevel: AccessLevel.readWrite,
        scope: scope,
        purpose: purpose,
        duration: duration,
        authorizedAt: now,
        expiresAt: expiresAt,
        signatureDeviceId: signatureDeviceId,
        signatureIpAddress: signatureIpAddress,
        photosIncluded: photosIncluded,
        syncMetadata: SyncMetadata.create(),
      );

      await _repository.create(authorization);

      // SEC-07: AUDIT LOG - Authorization granted successfully
      await _auditLog.log(AuditEntry(
        action: AuditAction.hipaaAuthorizationGranted,
        entityType: 'HipaaAuthorization',
        entityId: authorizationId,
        timestamp: DateTime.now(),
        result: AuditResult.success,
        metadata: {
          'profileId': profileId,
          'grantedToUserId': grantedToUserId,
          'grantedByUserId': grantedByUserId,
          'scope': scope.map((s) => s.name).toList(),
          'purpose': purpose,
          'expiresAt': expiresAt,
          'photosIncluded': photosIncluded,
        },
      ));

      return Success(authorization);

    } catch (e) {
      // SEC-07 & SEC-11: AUDIT LOG - Authorization grant failed
      await _auditLog.log(AuditEntry(
        action: AuditAction.hipaaAuthorizationGrantFailed,
        entityType: 'HipaaAuthorization',
        entityId: authorizationId,
        timestamp: DateTime.now(),
        result: AuditResult.failure,
        metadata: {
          'profileId': profileId,
          'grantedToUserId': grantedToUserId,
          'grantedByUserId': grantedByUserId,
          'failureReason': e.toString(),
        },
      ));
      rethrow;
    }
  }
}
```

**Revoke Authorization Audit Logging:**

```dart
/// SEC-07: Revoke HIPAA authorization with comprehensive audit logging
Future<Result<void, AppError>> revokeAuthorization({
  required String authorizationId,
  required String revokedByUserId,
  String? revocationReason,
}) async {
  // Fetch existing authorization
  final existing = await _repository.getById(authorizationId);
  if (existing == null) {
    // SEC-11: Log failed attempt to revoke non-existent authorization
    await _auditLog.log(AuditEntry(
      action: AuditAction.hipaaAuthorizationRevokeFailed,
      entityType: 'HipaaAuthorization',
      entityId: authorizationId,
      timestamp: DateTime.now(),
      result: AuditResult.failure,
      metadata: {
        'revokedByUserId': revokedByUserId,
        'failureReason': 'authorization_not_found',
      },
    ));
    return Failure(NotFoundError.authorization(authorizationId));
  }

  // SEC-07: AUDIT LOG - Revocation attempt (log BEFORE)
  await _auditLog.log(AuditEntry(
    action: AuditAction.hipaaAuthorizationRevokeInitiated,
    entityType: 'HipaaAuthorization',
    entityId: authorizationId,
    timestamp: DateTime.now(),
    metadata: {
      'profileId': existing.profileId,
      'grantedToUserId': existing.grantedToUserId,
      'revokedByUserId': revokedByUserId,
      'revocationReason': revocationReason,
      'originalGrantedAt': existing.authorizedAt,
      'originalScope': existing.scope.map((s) => s.name).toList(),
    },
  ));

  try {
    // Mark as revoked
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repository.markRevoked(
      authorizationId: authorizationId,
      revokedAt: now,
      revocationReason: revocationReason,
    );

    // SEC-07: AUDIT LOG - Authorization revoked successfully
    await _auditLog.log(AuditEntry(
      action: AuditAction.hipaaAuthorizationRevoked,
      entityType: 'HipaaAuthorization',
      entityId: authorizationId,
      timestamp: DateTime.now(),
      result: AuditResult.success,
      metadata: {
        'profileId': existing.profileId,
        'grantedToUserId': existing.grantedToUserId,
        'revokedByUserId': revokedByUserId,
        'revocationReason': revocationReason,
        'revokedAt': now,
        'durationActiveMs': now - existing.authorizedAt,
      },
    ));

    // Notify recipient of revocation
    await _notificationService.notifyAuthorizationRevoked(
      userId: existing.grantedToUserId,
      profileName: await _getProfileName(existing.profileId),
    );

    return Success(null);

  } catch (e) {
    // SEC-07 & SEC-11: AUDIT LOG - Revocation failed
    await _auditLog.log(AuditEntry(
      action: AuditAction.hipaaAuthorizationRevokeFailed,
      entityType: 'HipaaAuthorization',
      entityId: authorizationId,
      timestamp: DateTime.now(),
      result: AuditResult.failure,
      metadata: {
        'profileId': existing.profileId,
        'revokedByUserId': revokedByUserId,
        'failureReason': e.toString(),
      },
    ));
    rethrow;
  }
}
```

**SEC-10: Authorization Expiration Checking:**

> **CRITICAL (SEC-10):** ALL data access points MUST check authorization expiration
> before allowing access. Expired authorizations MUST be treated as revoked.

```dart
/// SEC-10: Check authorization expiration at EVERY data access point
Future<HipaaAuthorization?> getActiveAuthorization(
  String profileId,
  String userId,
) async {
  final now = DateTime.now().millisecondsSinceEpoch;

  final auth = await _repository.getByProfileAndUser(profileId, userId);

  if (auth == null) return null;

  // SEC-10: Check revocation
  if (auth.revokedAt != null) return null;

  // SEC-10: Check expiration - CRITICAL
  if (auth.expiresAt != null && auth.expiresAt! <= now) {
    // Log expiration event (first time detected)
    await _auditLog.log(AuditEntry(
      action: AuditAction.hipaaAuthorizationExpired,
      entityType: 'HipaaAuthorization',
      entityId: auth.id,
      timestamp: DateTime.now(),
      metadata: {
        'profileId': profileId,
        'grantedToUserId': userId,
        'expiredAt': auth.expiresAt,
        'detectedAt': now,
      },
    ));
    return null;
  }

  return auth;
}
```

**SEC-11: Failed Authorization Attempt Logging:**

> **CRITICAL (SEC-11):** ALL failed authorization attempts MUST be logged,
> not just successful accesses. This is essential for security monitoring
> and HIPAA audit requirements.

```dart
/// SEC-11: Log ALL failed authorization attempts
Future<void> logFailedAuthorizationAttempt({
  required String profileId,
  required String attemptedUserId,
  required String attemptedAction,
  required AuthorizationFailureReason reason,
  Map<String, dynamic>? additionalMetadata,
}) async {
  await _auditLog.log(AuditEntry(
    action: AuditAction.authorizationAccessDenied,
    entityType: 'Profile',
    entityId: profileId,
    timestamp: DateTime.now(),
    result: AuditResult.failure,
    metadata: {
      'attemptedUserId': attemptedUserId,
      'attemptedAction': attemptedAction,
      'reason': reason.name,
      ...?additionalMetadata,
    },
  ));
}

/// Reasons for authorization failure
enum AuthorizationFailureReason {
  noAuthorization,         // No authorization record exists
  authorizationRevoked,    // Authorization was revoked
  authorizationExpired,    // Authorization has expired
  insufficientScope,       // Authorization doesn't cover requested data type
  insufficientAccessLevel, // readOnly trying to write
  ownerOnlyOperation,      // Non-owner attempting owner-only action
  profileNotFound,         // Profile doesn't exist
}
```

#### 8.4.5 Notification to Data Owner

When a recipient accesses shared data, the owner can optionally receive notifications:

```dart
// Settings for shared profile notifications
class SharedAccessNotificationSettings {
  final bool notifyOnFirstAccess;     // Default: true
  final bool notifyOnEachAccess;      // Default: false (can be noisy)
  final bool notifyOnExport;          // Default: true
  final bool notifyOnNewEntry;        // Default: true
  final bool dailyAccessSummary;      // Default: true
}
```

#### 8.4.6 Database Schema Addition

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

  -- Sync metadata
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

-- Access audit log
CREATE TABLE profile_access_logs (
  id TEXT PRIMARY KEY,
  authorization_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  accessed_by_user_id TEXT NOT NULL,
  accessed_by_device_id TEXT NOT NULL,
  action INTEGER NOT NULL,            -- AccessAction enum
  entity_type TEXT NOT NULL,
  entity_id TEXT,
  accessed_at INTEGER NOT NULL,
  ip_address TEXT NOT NULL,

  FOREIGN KEY (authorization_id) REFERENCES hipaa_authorizations(id) ON DELETE CASCADE
);

CREATE INDEX idx_access_logs_authorization ON profile_access_logs(authorization_id, accessed_at DESC);
CREATE INDEX idx_access_logs_profile ON profile_access_logs(profile_id, accessed_at DESC);
```

#### 8.4.7 Scoped Data Filtering for Shared Profiles

**CRITICAL: All queries for shared profile data MUST filter by authorization scope.**

When a user accesses a shared profile (not their own), data MUST be filtered to only include
data types specified in their `HipaaAuthorization.scope` array.

**Mapping DataScope to Database Tables:**

| DataScope | Tables Accessible |
|-----------|-------------------|
| `conditions` | conditions, condition_logs, flare_ups |
| `supplements` | supplements, intake_logs |
| `food` | food_items, food_logs |
| `sleep` | sleep_entries |
| `activities` | activities, activity_logs |
| `fluids` | fluids_entries |
| `photos` | photo_areas, photo_entries, condition photos |
| `journal` | journal_entries |
| `reports` | (generated on-demand, not stored) |
| `insights` | patterns, trigger_correlations, health_insights |

**SQL Example - Fetching Conditions for Shared Profile:**

```sql
-- CORRECT: Filter by authorization scope
SELECT c.* FROM conditions c
INNER JOIN hipaa_authorizations h ON h.profile_id = c.profile_id
WHERE c.profile_id = :profileId
  AND c.sync_deleted_at IS NULL
  AND h.granted_to_user_id = :currentUserId
  AND h.revoked_at IS NULL
  AND (h.expires_at IS NULL OR h.expires_at > :nowEpoch)
  AND h.scope LIKE '%"conditions"%'  -- JSON array contains 'conditions'
ORDER BY c.sync_created_at DESC;

-- INCORRECT: No scope filtering (security vulnerability!)
SELECT * FROM conditions WHERE profile_id = :profileId;
```

**Implementation in Repository:**

```dart
class SharedProfileDataSource {
  /// Get conditions for a shared profile, filtered by authorization scope
  Future<Result<List<Condition>, AppError>> getConditionsForSharedProfile({
    required String profileId,
    required String currentUserId,
  }) async {
    // 1. Get authorization and verify scope includes 'conditions'
    final auth = await _getActiveAuthorization(profileId, currentUserId);
    if (auth == null) {
      return Failure(AuthError.profileAccessDenied(profileId));
    }
    if (!auth.scope.contains(DataScope.conditions)) {
      return Failure(AuthError.insufficientScope('conditions'));
    }

    // 2. Log access for HIPAA compliance
    await _auditLog.logAccess(
      authorizationId: auth.id,
      profileId: profileId,
      entityType: 'conditions',
      action: AccessAction.view,
    );

    // 3. Fetch data
    final conditions = await _conditionDataSource.getByProfile(profileId);
    return Success(conditions);
  }

  /// Verify user has active authorization with required scope
  Future<HipaaAuthorization?> _getActiveAuthorization(
    String profileId,
    String userId,
  ) async {
    final db = await _db.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final result = await db.query(
      'hipaa_authorizations',
      where: '''
        profile_id = ? AND
        granted_to_user_id = ? AND
        revoked_at IS NULL AND
        (expires_at IS NULL OR expires_at > ?)
      ''',
      whereArgs: [profileId, userId, now],
    );

    if (result.isEmpty) return null;
    return HipaaAuthorizationModel.fromMap(result.first).toEntity();
  }
}
```

**Scope Enforcement at UseCase Level:**

```dart
class GetConditionsUseCase {
  Future<Result<List<Condition>, AppError>> call(GetConditionsInput input) async {
    // Check if user owns profile or has authorized access
    final isOwner = await _authService.isProfileOwner(input.profileId);

    if (isOwner) {
      // Owner: Full access, no scope filtering
      return _conditionRepository.getByProfile(input.profileId);
    } else {
      // Shared access: Must filter by scope
      return _sharedProfileDataSource.getConditionsForSharedProfile(
        profileId: input.profileId,
        currentUserId: input.currentUserId,
      );
    }
  }
}
```

**Write Access for Shared Profiles:**

> ⚠️ **CRITICAL SECURITY REQUIREMENT:** ALL write operations (create, update, delete) for
> shared profiles MUST verify both access level AND scope BEFORE any database modification.
> Failure to check is a HIPAA violation and security vulnerability.

| AccessLevel | Create | Read | Update | Delete | Soft Delete |
|-------------|--------|------|--------|--------|-------------|
| `readOnly` | ❌ | ✅ (scoped) | ❌ | ❌ | ❌ |
| `readWrite` | ✅ (scoped) | ✅ (scoped) | ✅ (scoped) | ❌ | ✅ (scoped) |
| `owner` | ✅ | ✅ | ✅ | ✅ | ✅ |

**Write Permission Validation Checklist:**

For EVERY repository method that modifies data, implement these checks in order:

```dart
/// Standard authorization check for all write operations on shared profiles
/// Returns null if authorized, or an error if not
Future<AppError?> checkWriteAuthorization({
  required String profileId,
  required String currentUserId,
  required DataScope requiredScope,
  required WriteOperation operation,  // create, update, softDelete, hardDelete
}) async {
  // 1. Check if user owns profile
  final isOwner = await _authService.isProfileOwner(profileId);
  if (isOwner) return null; // Owners have full access

  // 2. Get authorization for shared profile
  final auth = await _getActiveAuthorization(profileId, currentUserId);
  if (auth == null) {
    return AuthError.profileAccessDenied(profileId);
  }

  // 3. Check access level
  if (auth.accessLevel == AccessLevel.readOnly) {
    return AuthError.writeAccessRequired();
  }

  // 4. Hard delete is NEVER allowed for shared profiles (even readWrite)
  if (operation == WriteOperation.hardDelete) {
    return AuthError.hardDeleteNotAllowed(profileId);
  }

  // 5. Check scope includes this data type
  if (!auth.scope.contains(requiredScope)) {
    return AuthError.insufficientScope(requiredScope.name);
  }

  // 6. Audit log the write attempt BEFORE proceeding
  await _auditLog.logAccess(
    authorizationId: auth.id,
    profileId: profileId,
    entityType: requiredScope.name,
    action: operation.toAccessAction(),
    metadata: {'timestamp': DateTime.now().toIso8601String()},
  );

  return null; // Authorized
}
```

**Example: Condition Log Create with Full Authorization:**

```dart
// Write operations must check authorization, scope, AND audit
Future<Result<ConditionLog, AppError>> addConditionLog(
  ConditionLogInput input,
) async {
  // Use standard authorization check
  final authError = await checkWriteAuthorization(
    profileId: input.profileId,
    currentUserId: _currentUserId,
    requiredScope: DataScope.conditions,
    operation: WriteOperation.create,
  );

  if (authError != null) {
    return Failure(authError);
  }

  // Proceed with create...
  return _conditionLogRepository.create(input.toEntity());
}
```

**Example: Update Operation:**

```dart
Future<Result<Condition, AppError>> updateCondition(
  UpdateConditionInput input,
) async {
  final authError = await checkWriteAuthorization(
    profileId: input.profileId,
    currentUserId: _currentUserId,
    requiredScope: DataScope.conditions,
    operation: WriteOperation.update,
  );

  if (authError != null) return Failure(authError);

  return _conditionRepository.update(input.toEntity());
}
```

**Example: Soft Delete Operation:**

```dart
Future<Result<void, AppError>> archiveCondition(String conditionId) async {
  // First fetch to get profileId
  final condition = await _conditionRepository.getById(conditionId);
  if (condition.isFailure) return condition.map((_) {});

  final authError = await checkWriteAuthorization(
    profileId: condition.value.profileId,
    currentUserId: _currentUserId,
    requiredScope: DataScope.conditions,
    operation: WriteOperation.softDelete,
  );

  if (authError != null) return Failure(authError);

  return _conditionRepository.delete(conditionId); // Soft delete
}
```

#### 8.4.8 SEC-05: Scope Filtering Requirements for ALL Write Operations

> **CRITICAL SECURITY REQUIREMENT (SEC-05):**
> ALL write operations (create, update, delete) on shared profile data MUST verify
> BOTH authorization AND scope BEFORE any database modification.

**Mandatory Scope Checks for Write Operations:**

Every repository method that modifies data for shared profiles MUST:

1. **Verify active authorization exists** - Check `hipaa_authorizations` table
2. **Check authorization not expired** - `expires_at IS NULL OR expires_at > now`
3. **Check authorization not revoked** - `revoked_at IS NULL`
4. **Verify scope includes data type** - `scope` JSON array contains required DataScope
5. **Verify access level permits operation** - `readWrite` for create/update, `owner` for hard delete
6. **Log the authorization check** - Audit both success AND failure

**Write Operation Scope Matrix:**

| Operation | Required Access Level | Scope Check Required | Audit Log |
|-----------|----------------------|---------------------|-----------|
| Create | `readWrite` or `owner` | YES - scope must include data type | YES - log before AND after |
| Update | `readWrite` or `owner` | YES - scope must include data type | YES - log before AND after |
| Soft Delete | `readWrite` or `owner` | YES - scope must include data type | YES - log before AND after |
| Hard Delete | `owner` ONLY | YES - owners have full scope | YES - log before AND after |

**Implementation Pattern for ALL Write Operations:**

```dart
/// SEC-05: Standard pattern for write operations on shared profiles
/// MUST be used by ALL repository write methods
Future<Result<T, AppError>> secureWriteOperation<T>({
  required String profileId,
  required String currentUserId,
  required DataScope requiredScope,
  required WriteOperation operation,
  required Future<Result<T, AppError>> Function() performWrite,
}) async {
  // 1. Check ownership first (owners bypass scope checks)
  final isOwner = await _authService.isProfileOwner(profileId, currentUserId);

  if (!isOwner) {
    // 2. Get and validate authorization for non-owners
    final auth = await _getActiveAuthorization(profileId, currentUserId);

    if (auth == null) {
      // SEC-11: Log failed authorization attempt
      await _auditLog.log(AuditEntry(
        action: AuditAction.authorizationAccessDenied,
        entityType: 'Profile',
        entityId: profileId,
        result: AuditResult.failure,
        metadata: {
          'attemptedUserId': currentUserId,
          'attemptedOperation': operation.name,
          'reason': 'no_active_authorization',
        },
      ));
      return Failure(AuthError.profileAccessDenied(profileId));
    }

    // 3. Check access level
    if (auth.accessLevel == AccessLevel.readOnly) {
      await _auditLog.log(AuditEntry(
        action: AuditAction.authorizationAccessDenied,
        entityType: 'Profile',
        entityId: profileId,
        result: AuditResult.failure,
        metadata: {
          'attemptedUserId': currentUserId,
          'attemptedOperation': operation.name,
          'reason': 'read_only_access',
          'authorizationId': auth.id,
        },
      ));
      return Failure(AuthError.writeAccessRequired());
    }

    // 4. Hard delete restricted to owners
    if (operation == WriteOperation.hardDelete) {
      await _auditLog.log(AuditEntry(
        action: AuditAction.authorizationAccessDenied,
        entityType: 'Profile',
        entityId: profileId,
        result: AuditResult.failure,
        metadata: {
          'attemptedUserId': currentUserId,
          'attemptedOperation': 'hardDelete',
          'reason': 'owner_only_operation',
          'authorizationId': auth.id,
        },
      ));
      return Failure(AuthError.hardDeleteNotAllowed(profileId));
    }

    // 5. Check scope includes required data type
    if (!auth.scope.contains(requiredScope)) {
      await _auditLog.log(AuditEntry(
        action: AuditAction.authorizationAccessDenied,
        entityType: 'Profile',
        entityId: profileId,
        result: AuditResult.failure,
        metadata: {
          'attemptedUserId': currentUserId,
          'attemptedOperation': operation.name,
          'attemptedScope': requiredScope.name,
          'authorizedScopes': auth.scope.map((s) => s.name).toList(),
          'reason': 'insufficient_scope',
          'authorizationId': auth.id,
        },
      ));
      return Failure(AuthError.insufficientScope(requiredScope.name));
    }

    // SEC-10: Check authorization expiration (defense in depth)
    if (auth.expiresAt != null &&
        DateTime.now().millisecondsSinceEpoch > auth.expiresAt!) {
      await _auditLog.log(AuditEntry(
        action: AuditAction.hipaaAuthorizationExpired,
        entityType: 'HipaaAuthorization',
        entityId: auth.id,
        metadata: {
          'profileId': profileId,
          'expiredAt': auth.expiresAt,
        },
      ));
      return Failure(AuthError.authorizationExpired());
    }
  }

  // 6. Log authorized write attempt
  await _auditLog.log(AuditEntry(
    action: AuditAction.profileDataModification,
    entityType: 'Profile',
    entityId: profileId,
    metadata: {
      'userId': currentUserId,
      'operation': operation.name,
      'scope': requiredScope.name,
      'isOwner': isOwner,
    },
  ));

  // 7. Perform the actual write operation
  return performWrite();
}
```

**Tables Requiring Scope-Checked Write Operations:**

| Table | DataScope Required | Notes |
|-------|-------------------|-------|
| `conditions` | `DataScope.conditions` | |
| `condition_logs` | `DataScope.conditions` | |
| `flare_ups` | `DataScope.conditions` | |
| `supplements` | `DataScope.supplements` | |
| `intake_logs` | `DataScope.supplements` | |
| `food_items` | `DataScope.food` | |
| `food_logs` | `DataScope.food` | |
| `sleep_entries` | `DataScope.sleep` | |
| `activities` | `DataScope.activities` | |
| `activity_logs` | `DataScope.activities` | |
| `fluids_entries` | `DataScope.fluids` | |
| `photo_areas` | `DataScope.photos` | Requires explicit photo consent |
| `photo_entries` | `DataScope.photos` | Requires explicit photo consent |
| `journal_entries` | `DataScope.journal` | |
| `patterns` | `DataScope.insights` | |
| `trigger_correlations` | `DataScope.insights` | |
| `health_insights` | `DataScope.insights` | |

---

## 9. Device Management

### 9.1 Device List UI

```
┌─────────────────────────────────────────────────────────────────────┐
│                    YOUR DEVICES                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  📱 Reid's iPhone 15 Pro                    [This device]   │   │
│  │     Last active: Now                                        │   │
│  │     iOS 18.2 • Shadow 1.5.0                                │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  💻 Reid's MacBook Pro                                      │   │
│  │     Last active: 5 minutes ago                              │   │
│  │     macOS 15.1 • Shadow 1.5.0                              │   │
│  │                                              [Remove]       │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  📱 Reid's iPad                                             │   │
│  │     Last active: 3 days ago                                 │   │
│  │     iPadOS 18.2 • Shadow 1.4.2      [Update Available]     │   │
│  │                                              [Remove]       │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│                      [+ Add New Device]                            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 9.2 Remote Device Removal

When a device is removed:

1. Mark device as inactive in cloud
2. Revoke cloud access tokens for that device
3. Device's local data remains but cannot sync
4. Next time removed device opens app:
   - Show "This device has been removed"
   - Offer to set up as new device or sign out

---

## 10. Error Handling

| Error | Cause | User Action |
|-------|-------|-------------|
| QR expired | 5+ minutes elapsed | "QR code expired. Tap to generate a new one." |
| Camera denied | No camera permission | "Camera access required. Open Settings to enable." |
| Network error | No internet during pairing | "Internet connection required. Check your connection." |
| Verification failed | Codes don't match | "Pairing cancelled for security. Please try again." |
| Device limit | Max 10 devices | "Maximum devices reached. Remove a device first." |
| Already paired | Device already registered | "This device is already connected to your account." |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release - QR pairing, multi-device sync, profile sharing |
| 1.1 | 2026-02-02 | SEC-02: Added audit logging to createPairingSession; SEC-03: Enhanced key exchange audit logging; SEC-04: Added credential transfer audit logging with failure tracking; SEC-05: Added scope filtering requirements for ALL write operations; SEC-07: Added comprehensive HIPAA authorization grant/revoke audit logging; SEC-10: Added authorization expiration checking requirements; SEC-11: Added failed authorization attempt logging |
