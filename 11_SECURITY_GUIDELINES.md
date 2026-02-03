# Shadow Security Guidelines

**Version:** 1.0
**Last Updated:** January 30, 2026
**Compliance:** HIPAA, OWASP Mobile Top 10

---

## Overview

Shadow handles Protected Health Information (PHI) and must maintain the highest security standards. This document defines security requirements, implementations, and compliance measures.

---

## 1. Security Principles

### 1.1 Core Tenets

1. **Defense in Depth** - Multiple security layers; no single point of failure
2. **Least Privilege** - Minimum access required for functionality
3. **Fail-Secure** - Deny by default when security state is uncertain
4. **Zero Trust** - Verify everything; trust nothing by default
5. **Privacy by Design** - Security built in, not bolted on

### 1.2 HIPAA Requirements

| Requirement | Implementation |
|-------------|----------------|
| Access Controls | Profile-level authorization with role-based access |
| Audit Logs | Comprehensive PHI access logging with 7-year retention |
| Encryption at Rest | SQLCipher AES-256-GCM database encryption |
| Encryption in Transit | HTTPS/TLS 1.3 minimum for all network communication |
| Data Integrity | SHA-256 hashing for file verification |
| Authentication | OAuth 2.0 with PKCE |

---

## 2. Data Encryption

### 2.1 Database Encryption

**Algorithm:** AES-256-GCM via SQLCipher (GCM provides authenticated encryption)

```dart
// Database encryption key management
class DatabaseKeyService {
  static const int keyLengthBytes = 32;  // 256 bits

  // Key storage in platform secure storage
  // iOS: Keychain with first_unlock_this_device
  // Android: EncryptedSharedPreferences

  Future<String> getOrCreateMasterKey() async {
    var key = await _secureStorage.read(key: masterKeyStorageKey);
    if (key == null) {
      key = _generateSecureKey();
      await _secureStorage.write(key: masterKeyStorageKey, value: key);
    }
    return key;
  }
}
```

**Key Requirements:**
- 256-bit cryptographically secure random keys
- Keys stored only in platform secure storage
- Key rotation with version tracking (see below)
- Per-user derived keys for multi-user scenarios

### 2.1.1 Key Rotation Mechanism

**Rotation Schedule:**
- Annual rotation (mandatory)
- Immediate rotation on suspected compromise
- Rotation tracked via key version suffix

**Key Versioning:**
```dart
class KeyRotationService {
  static const String keyPrefix = 'dbMasterKey_v';

  /// Get current key version
  Future<int> getCurrentVersion() async {
    final version = await _secureStorage.read(key: 'keyVersion');
    return int.tryParse(version ?? '1') ?? 1;
  }

  /// Rotate to new key version
  Future<void> rotateKey() async {
    final currentVersion = await getCurrentVersion();
    final newVersion = currentVersion + 1;

    // 1. Generate new key
    final newKey = _generateSecureKey();
    await _secureStorage.write(
      key: '$keyPrefix$newVersion',
      value: newKey,
    );

    // 2. Re-encrypt database with new key
    await _reEncryptDatabase(
      oldKeyVersion: currentVersion,
      newKeyVersion: newVersion,
    );

    // 3. Update version pointer
    await _secureStorage.write(key: 'keyVersion', value: '$newVersion');

    // 4. Log rotation event
    await _auditLog.log(AuditEventType.encryptionKeyRotation, {
      'oldVersion': currentVersion,
      'newVersion': newVersion,
      'rotatedAt': DateTime.now().toIso8601String(),
    });

    // 5. Keep old key for 7 days (emergency rollback)
    await _scheduleOldKeyDeletion(currentVersion, Duration(days: 7));
  }

  /// Track rotation timestamp
  Future<DateTime?> getLastRotatedAt() async {
    final timestamp = await _secureStorage.read(key: 'keyLastRotatedAt');
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }
}
```

**Rotation Procedure:**
1. Generate new 256-bit key with incremented version
2. Re-encrypt all database content with new key
3. Update version pointer in secure storage
4. Log rotation to audit trail
5. Retain old key for 7 days (emergency rollback only)
6. Securely delete old key after retention period

### 2.2 Field-Level Encryption

**Algorithm:** AES-256-GCM (Galois/Counter Mode with authenticated encryption)

CRITICAL: Use GCM mode, NOT CBC. GCM provides:
- Authenticated encryption (integrity + confidentiality)
- Protection against padding oracle attacks
- Built-in message authentication code (MAC)

```dart
class EncryptionService {
  // AES-256-GCM with unique nonce per operation
  Future<String> encrypt(String plaintext) async {
    final nonce = Nonce.fromSecureRandom(12);  // 96-bit nonce for GCM
    final secretBox = await _algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: _secretKey,
      nonce: nonce,
    );
    // Format: nonce:ciphertext:mac (all base64 encoded)
    return '${base64Encode(nonce.bytes)}:${base64Encode(secretBox.cipherText)}:${base64Encode(secretBox.mac.bytes)}';
  }

  Future<String> decrypt(String encrypted) async {
    final parts = encrypted.split(':');
    if (parts.length != 3) throw DecryptionException('Invalid format');

    final nonce = Nonce(base64Decode(parts[0]));
    final cipherText = base64Decode(parts[1]);
    final mac = Mac(base64Decode(parts[2]));

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);
    final decrypted = await _algorithm.decrypt(secretBox, secretKey: _secretKey);
    return utf8.decode(decrypted);
  }
}
```

**Security Notes:**
- MUST use GCM mode (authenticated encryption)
- Never reuse nonce with same key
- Use 96-bit (12 byte) nonce for GCM
- MAC verification happens automatically during decrypt
- Reject any message with invalid MAC (tamper detection)

### 2.3 Hashing

**Algorithm:** SHA-256

```dart
// File integrity verification
String hashFile(File file) {
  final bytes = file.readAsBytesSync();
  return sha256.convert(bytes).toString();
}

// String hashing (non-reversible)
String hashString(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}
```

---

## 3. Authentication

### 3.1 OAuth 2.0 Implementation

**Standards Compliance:**
- RFC 7636 (PKCE)
- RFC 8252 (OAuth for Native Apps)

**Flow:** Authorization Code with PKCE

```dart
// PKCE parameters
class PKCEService {
  String generateCodeVerifier() {
    // 128 characters from secure random
    final random = Random.secure();
    final bytes = List.generate(96, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).substring(0, 128);
  }

  String generateCodeChallenge(String verifier) {
    // SHA-256 hash, base64url encoded
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');
  }
}
```

### 3.2 Token Management

**CRITICAL:** Client secrets are NEVER stored in the app.

```dart
// Token exchange via secure backend proxy
class OAuthProxyService {
  final String proxyBaseUrl;

  Future<TokenResponse> exchangeCode(String code, String codeVerifier) async {
    // Proxy handles client_secret injection
    final response = await http.post(
      Uri.parse('$proxyBaseUrl/oauth/token'),
      body: {
        'code': code,
        'code_verifier': codeVerifier,
        'redirect_uri': redirectUri,
      },
    );
    return TokenResponse.fromJson(jsonDecode(response.body));
  }
}
```

**Token Storage:**

```dart
class SecureStorageKeys {
  static const String googleDriveAccessToken = 'google_drive_access_token';
  static const String googleDriveRefreshToken = 'google_drive_refresh_token';
  static const String tokenExpiry = 'google_drive_token_expiry';
}
```

### 3.3 CSRF Protection

```dart
// State parameter generation
String generateState() {
  final random = Random.secure();
  final bytes = List.generate(32, (_) => random.nextInt(256));
  return base64UrlEncode(bytes);
}

// Validate on callback
void validateCallback(String returnedState, String originalState) {
  if (returnedState != originalState) {
    throw SecurityException('CSRF validation failed');
  }
}
```

---

## 4. Authorization

### 4.1 Profile Access Control

**Access Levels:**

| Level | Permissions |
|-------|-------------|
| `readOnly` | View profile data |
| `readWrite` | View and modify profile data |
| `owner` | Full control including sharing (profile creator) |

```dart
class ProfileAuthorizationService {
  Future<void> checkAccess(
    String userId,
    String profileId,
    ProfileAccessLevel requiredLevel,
  ) async {
    final access = await _accessRepository.getAccess(userId, profileId);

    if (access == null) {
      await _auditLog.logUnauthorizedAccess(userId, profileId, 'no_access');
      throw AuthorizationException('No access to profile');
    }

    if (access.expiresAt != null && access.expiresAt!.isBefore(DateTime.now())) {
      throw AuthorizationException('Access expired');
    }

    if (!_meetsAccessLevel(access.accessLevel, requiredLevel)) {
      await _auditLog.logUnauthorizedAccess(userId, profileId, 'insufficient_level');
      throw AuthorizationException('Insufficient access level');
    }
  }
}
```

### 4.2 Device Registration

```dart
// Multi-device access control
class DeviceRegistrationService {
  Future<void> registerDevice(String userId) async {
    final deviceInfo = await _deviceInfoService.getDeviceInfo();

    await _repository.addDeviceRegistration(DeviceRegistration(
      id: _uuid.v4(),
      userAccountId: userId,
      deviceId: deviceInfo.deviceId,
      deviceName: deviceInfo.deviceName,
      deviceType: deviceInfo.deviceType,
      registeredAt: DateTime.now(),
      lastSeenAt: DateTime.now(),
      isActive: true,
    ));
  }
}
```

### 4.3 SQL-Level Authorization (Defense in Depth)

**HIPAA Requirement:** Defense-in-depth requires authorization at multiple layers. Application-level authorization (ProfileAuthorizationService) MUST be supplemented by database-level controls.

**SQLite Trigger-Based Authorization:**

Since SQLite doesn't support Row-Level Security (RLS) natively, use triggers to enforce access control:

```sql
-- Prevent unauthorized profile access at database level
-- This is a backup control; application MUST also validate

-- Application context table (set by app before queries)
CREATE TABLE IF NOT EXISTS app_context (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

-- Trigger to validate profile access on INSERT
CREATE TRIGGER IF NOT EXISTS check_profile_access_insert
BEFORE INSERT ON condition_logs
BEGIN
  SELECT RAISE(ABORT, 'PROFILE_ACCESS_DENIED')
  WHERE NOT EXISTS (
    SELECT 1 FROM profile_access
    WHERE profile_id = NEW.profile_id
    AND user_id = (SELECT value FROM app_context WHERE key = 'current_user_id')
    AND (expires_at IS NULL OR expires_at > strftime('%s', 'now') * 1000)
  );
END;

-- Trigger to validate profile access on SELECT (via view)
CREATE VIEW authorized_condition_logs AS
SELECT cl.* FROM condition_logs cl
INNER JOIN profile_access pa ON cl.profile_id = pa.profile_id
WHERE pa.user_id = (SELECT value FROM app_context WHERE key = 'current_user_id')
  AND (pa.expires_at IS NULL OR pa.expires_at > strftime('%s', 'now') * 1000)
  AND cl.sync_deleted_at IS NULL;
```

**Application Context Setup:**

```dart
class DatabaseAuthorizationService {
  final Database _db;

  /// Set current user context before any data access
  /// MUST be called at start of every database session
  Future<void> setUserContext(String userId) async {
    await _db.execute('''
      INSERT OR REPLACE INTO app_context (key, value)
      VALUES ('current_user_id', ?)
    ''', [userId]);
  }

  /// Clear context on logout
  Future<void> clearUserContext() async {
    await _db.delete('app_context');
  }
}
```

**Enforcement Requirements:**

| Layer | Control | Required |
|-------|---------|----------|
| Application | ProfileAuthorizationService.checkAccess() | MANDATORY |
| Database | app_context user setup | MANDATORY |
| Database | Authorization triggers on write tables | MANDATORY |
| Database | Authorized views for read queries | RECOMMENDED |

---

## 5. Rate Limiting

### 5.1 Authentication Rate Limiting

**Configuration:**

| Setting | Value |
|---------|-------|
| Max Attempts | 5 |
| Initial Lockout | 1 minute |
| Escalated Lockout (7+ attempts) | 5 minutes |
| Max Lockout (10+ attempts) | 30 minutes |
| Reset Window | 1 hour |

**Rate Limiting Scope:**

Rate limiting applies at the following levels:

| Limit Type | Scope | Storage | Reset Behavior |
|------------|-------|---------|----------------|
| Authentication | **Per-device** (deviceId) | Local + sync to cloud | Resets after 1 hour of no attempts |
| QR Code Generation | **Per-user** (userId) | Cloud only | Resets after 5 minutes |
| Pairing Attempts | **Per-device** (deviceId) | Local only | Resets after 1 hour |
| API Operations | **Per-user-per-device** | Local with cloud backup | Resets per-window |
| Wearable Sync | **Per-user-per-platform** | Local | 5-minute cooldown |

**IMPORTANT:** Device-scoped limits are tracked by the unique device identifier stored in secure storage. This ensures rate limits persist across app restarts but reset when the app is reinstalled.

```dart
class RateLimitService {
  static const int maxAttempts = 5;
  static const Duration initialLockout = Duration(minutes: 1);
  static const Duration maxLockout = Duration(minutes: 30);

  /// Rate limit storage key includes scope identifier
  /// Format: "rate_limit:{operation}:{scopeId}"
  String _getStorageKey(RateLimitOperation operation, String scopeId) {
    return 'rate_limit:${operation.name}:$scopeId';
  }

  bool isLocked(String deviceId) {
    final attempts = _attempts[deviceId];
    if (attempts == null || attempts.count < maxAttempts) return false;

    final lockoutDuration = _calculateLockout(attempts.count);
    return DateTime.now().isBefore(attempts.lastAttempt.add(lockoutDuration));
  }

  Duration _calculateLockout(int attemptCount) {
    if (attemptCount < 7) return initialLockout;
    if (attemptCount < 10) return Duration(minutes: 5);
    return maxLockout;
  }
}
```

### 5.2 QR Code & Device Pairing Rate Limiting

**Configuration:**

| Operation | Limit | Window |
|-----------|-------|--------|
| QR Code Generation | 3 | 5 minutes |
| Pairing Attempts | 5 | 1 hour |
| Failed Pairing Lockout | 30 minutes | After 5 failures |

### 5.3 Token Rotation Policy

**Refresh Token Rules:**
- Refresh tokens are **single-use** - each use issues new refresh token
- Previous refresh tokens invalidated on rotation
- Refresh token lifetime: 30 days
- Access token lifetime: 15 minutes
- Force re-authentication after 90 days of inactivity

```dart
class TokenRotationPolicy {
  static const Duration accessTokenLifetime = Duration(minutes: 15);
  static const Duration refreshTokenLifetime = Duration(days: 30);
  static const Duration maxInactivity = Duration(days: 90);

  /// Refresh tokens are single-use; rotation happens on every refresh
  static const bool singleUseRefreshTokens = true;
}
```

**Token Family Tracking (Replay Attack Prevention):**

Token families detect stolen refresh tokens. When a token is reused, all tokens in the family are invalidated.

```dart
/// Token Rotation with Replay Detection
/// Implements "token family" tracking to detect stolen refresh tokens.
/// When a refresh token is used twice, entire family is invalidated.

class TokenRotationService {
  final TokenRepository _tokenRepository;
  final AuditLogService _auditLog;
  final PushService _pushService;
  final DeviceRepository _deviceRepository;

  /// Rotate tokens with replay detection
  Future<Result<TokenPair, AppError>> rotateTokens({
    required String refreshToken,
    required String deviceId,
  }) async {
    // 1. Decode and validate refresh token
    final tokenData = await _decodeRefreshToken(refreshToken);
    if (tokenData == null) {
      return Failure(AuthError.invalidToken());
    }

    // 2. Check if token was already used (replay attack)
    final usedAt = await _tokenRepository.getTokenUsedAt(tokenData.jti);
    if (usedAt != null) {
      // CRITICAL: Token reuse detected - invalidate entire family
      await _invalidateTokenFamily(tokenData.familyId);
      await _auditLog.log(AuditEntry(
        action: AuditAction.tokenReplayDetected,
        metadata: {
          'familyId': tokenData.familyId,
          'originalUseTime': usedAt,
          'replayAttemptDevice': deviceId,
        },
      ));
      return Failure(AuthError.tokenReplay());
    }

    // 3. Mark token as used (atomic operation)
    final marked = await _tokenRepository.markTokenUsedAtomic(
      tokenData.jti,
      DateTime.now().millisecondsSinceEpoch,
    );
    if (!marked) {
      // Race condition: another device used token first
      return Failure(AuthError.tokenAlreadyUsed());
    }

    // 4. Generate new token pair with same family ID
    final newRefreshToken = await _generateRefreshToken(
      userId: tokenData.userId,
      familyId: tokenData.familyId,  // Same family
      deviceId: deviceId,
    );

    final newAccessToken = await _generateAccessToken(
      userId: tokenData.userId,
      deviceId: deviceId,
    );

    // 5. Audit successful rotation
    await _auditLog.log(AuditEntry(
      action: AuditAction.tokenRotated,
      metadata: {
        'familyId': tokenData.familyId,
        'deviceId': deviceId,
      },
    ));

    return Success(TokenPair(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      accessTokenExpiresAt: DateTime.now().millisecondsSinceEpoch +
          TokenRotationPolicy.accessTokenLifetime.inMilliseconds,
      refreshTokenExpiresAt: DateTime.now().millisecondsSinceEpoch +
          TokenRotationPolicy.refreshTokenLifetime.inMilliseconds,
    ));
  }

  /// Invalidate all tokens in a family (used on compromise detection)
  Future<void> _invalidateTokenFamily(String familyId) async {
    await _tokenRepository.invalidateFamily(familyId);

    // Notify all devices in family to re-authenticate
    final devices = await _deviceRepository.getDevicesByFamily(familyId);
    for (final device in devices) {
      await _pushService.sendSecurityNotification(
        deviceId: device.id,
        type: SecurityNotificationType.forceReauth,
        message: 'Session expired for security. Please sign in again.',
      );
    }
  }
}

/// Token data structure for tracking
@freezed
class RefreshTokenData with _$RefreshTokenData {
  const factory RefreshTokenData({
    required String jti,       // Unique token ID
    required String familyId,  // Token family (from original login)
    required String userId,
    required String deviceId,
    required int issuedAt,
    required int expiresAt,
  }) = _RefreshTokenData;
}
```

**Database Schema for Token Management:**

```sql
-- Add to 10_DATABASE_SCHEMA.md
CREATE TABLE refresh_token_usage (
  jti TEXT PRIMARY KEY,             -- Unique token ID
  family_id TEXT NOT NULL,          -- Token family (from login)
  user_id TEXT NOT NULL,
  device_id TEXT NOT NULL,
  issued_at INTEGER NOT NULL,       -- Epoch ms
  expires_at INTEGER NOT NULL,      -- Epoch ms
  used_at INTEGER,                  -- NULL if not yet used
  invalidated_at INTEGER,           -- NULL if still valid

  FOREIGN KEY (user_id) REFERENCES user_accounts(id),
  FOREIGN KEY (device_id) REFERENCES device_registrations(id)
);

CREATE INDEX idx_token_family ON refresh_token_usage(family_id);
CREATE INDEX idx_token_user_device ON refresh_token_usage(user_id, device_id);
CREATE INDEX idx_token_expires ON refresh_token_usage(expires_at) WHERE used_at IS NULL;
```

**Race Condition Handling:**

When multiple devices attempt to refresh simultaneously:
1. Use atomic `UPDATE ... WHERE used_at IS NULL` to prevent double-use
2. First device wins; others receive `tokenAlreadyUsed` error
3. Losing devices should retry with delay (exponential backoff)

```dart
/// Atomic mark-as-used with race condition handling
Future<bool> markTokenUsedAtomic(String jti, int usedAt) async {
  final result = await _db.rawUpdate('''
    UPDATE refresh_token_usage
    SET used_at = ?
    WHERE jti = ? AND used_at IS NULL
  ''', [usedAt, jti]);
  return result > 0;  // true if row was updated
}
```

### 5.4 TLS Requirements

**Minimum Version:** TLS 1.3

All network connections MUST:
- Use TLS 1.3 or higher
- Reject TLS 1.2 and lower
- Use strong cipher suites only
- Implement certificate pinning for API endpoints

**Certificate Pinning Implementation:**

> **SEC-01: CRITICAL SECURITY NOTICE**
>
> The certificate hashes below are EXAMPLES ONLY and MUST be replaced with
> REAL fingerprints extracted from production certificates BEFORE deployment.
>
> **DEPLOYMENT BLOCKER:** Application MUST NOT be deployed to production
> until real certificate pins are extracted and verified using the
> extraction procedure documented below.
>
> **Pre-Deployment Checklist:**
> - [ ] Extract real pins using `openssl` commands below
> - [ ] Verify pins against live endpoints
> - [ ] Document certificate expiry dates
> - [ ] Set calendar reminders for rotation (45 days before expiry)
> - [ ] Include backup pins (minimum 2 per domain)
> - [ ] CI/CD pin validation gate passes

```dart
class CertificatePinning {
  // SEC-01: PLACEHOLDER VALUES - MUST BE REPLACED BEFORE PRODUCTION
  //
  // Pin to Root CA certificates (stable across certificate rotations)
  //
  // ⚠️  WARNING: These are EXAMPLE hashes for documentation purposes.
  // ⚠️  REAL fingerprints MUST be extracted before deployment.
  // ⚠️  See "Certificate Extraction Procedure" section below.
  //
  static const Map<String, List<String>> pinnedCertificates = {
    // Shadow API endpoints
    // TODO(SEC-01): Extract real pins during infrastructure setup
    'api.shadow.app': [
      'sha256/PLACEHOLDER_EXTRACT_REAL_PIN_BEFORE_DEPLOY_1=', // Primary - extract before deploy
      'sha256/PLACEHOLDER_EXTRACT_REAL_PIN_BEFORE_DEPLOY_2=', // Backup - extract before deploy
    ],

    // Google OAuth endpoints (Google Trust Services Root CAs)
    // TODO(SEC-01): Verify these pins against live Google endpoints
    'accounts.google.com': [
      'sha256/PLACEHOLDER_VERIFY_GOOGLE_PIN_1=', // GTS Root R1 - verify before deploy
      'sha256/PLACEHOLDER_VERIFY_GOOGLE_PIN_2=', // GTS Root R4 - verify before deploy
    ],
    'oauth2.googleapis.com': [
      'sha256/PLACEHOLDER_VERIFY_GOOGLE_PIN_1=', // GTS Root R1 - verify before deploy
      'sha256/PLACEHOLDER_VERIFY_GOOGLE_PIN_2=', // GTS Root R4 - verify before deploy
    ],
    'www.googleapis.com': [
      'sha256/PLACEHOLDER_VERIFY_GOOGLE_PIN_1=', // GTS Root R1 - verify before deploy
      'sha256/PLACEHOLDER_VERIFY_GOOGLE_PIN_2=', // GTS Root R4 - verify before deploy
    ],

    // Google Drive API (for cloud sync)
    'drive.googleapis.com': [
      'sha256/PLACEHOLDER_VERIFY_GOOGLE_PIN_1=', // GTS Root R1 - verify before deploy
      'sha256/PLACEHOLDER_VERIFY_GOOGLE_PIN_2=', // GTS Root R4 - verify before deploy
    ],

    // Apple endpoints (for Sign in with Apple, iCloud)
    // TODO(SEC-01): Verify these pins against live Apple endpoints
    'appleid.apple.com': [
      'sha256/PLACEHOLDER_VERIFY_APPLE_PIN_1=', // Apple Root CA - verify before deploy
      'sha256/PLACEHOLDER_VERIFY_APPLE_PIN_2=', // Backup CA - verify before deploy
    ],
    'api.apple-cloudkit.com': [
      'sha256/PLACEHOLDER_VERIFY_APPLE_PIN_1=', // Apple Root CA - verify before deploy
      'sha256/PLACEHOLDER_VERIFY_APPLE_PIN_2=', // Backup CA - verify before deploy
    ],

    // Third-party wearable APIs (Phase 4)
    // TODO(SEC-01): Extract and verify before Phase 4 launch
    'api.fitbit.com': [
      'sha256/PLACEHOLDER_EXTRACT_FITBIT_PIN_1=', // Extract before Phase 4
      'sha256/PLACEHOLDER_EXTRACT_FITBIT_PIN_2=', // Extract before Phase 4
    ],
    'connect.garmin.com': [
      'sha256/PLACEHOLDER_EXTRACT_GARMIN_PIN_1=', // Extract before Phase 4
      'sha256/PLACEHOLDER_EXTRACT_GARMIN_PIN_2=', // Extract before Phase 4
    ],
    'cloud.ouraring.com': [
      'sha256/PLACEHOLDER_EXTRACT_OURA_PIN_1=', // Extract before Phase 4
      'sha256/PLACEHOLDER_EXTRACT_OURA_PIN_2=', // Extract before Phase 4
    ],
    'api.prod.whoop.com': [
      'sha256/PLACEHOLDER_EXTRACT_WHOOP_PIN_1=', // Extract before Phase 4
      'sha256/PLACEHOLDER_EXTRACT_WHOOP_PIN_2=', // Extract before Phase 4
    ],
  };

  /// Validate server certificate against pins
  static bool validateCertificate(X509Certificate cert, String host) {
    final pins = pinnedCertificates[host];
    if (pins == null) return true; // No pin = trust system CA

    final certHash = sha256.convert(cert.der).toString();
    return pins.any((pin) => pin.endsWith(certHash));
  }
}
```

**PIN VERIFICATION NOTE:**
The SHA256 hashes above are production root CA pins. To verify or update pins, extract certificate fingerprints:
```bash
# Extract certificate fingerprint for a domain
openssl s_client -connect api.google.com:443 -servername api.google.com </dev/null 2>/dev/null | \
  openssl x509 -outform DER | \
  openssl dgst -sha256 -binary | base64

# For intermediate/root CA pinning (recommended for stability):
openssl s_client -connect api.google.com:443 -showcerts </dev/null 2>/dev/null | \
  awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print}' | \
  openssl x509 -outform DER | \
  openssl dgst -sha256 -binary | base64
```

**Certificate Extraction Procedure:**
1. **For each domain in pinnedCertificates:**
   ```bash
   DOMAIN="api.shadow.app"
   openssl s_client -connect $DOMAIN:443 -servername $DOMAIN </dev/null 2>/dev/null | \
     openssl x509 -outform DER | openssl dgst -sha256 -binary | base64
   ```
2. **Record both primary and backup pins** (intermediate CA preferred)
3. **Verify pins before deployment** using CI script below
4. **Document in deployment log** with extraction date and certificate expiry

**CI/CD Deployment Gate (MANDATORY):**

```yaml
# .github/workflows/deploy.yml - Add to pre-deployment checks
- name: Verify Certificate Pins
  run: |
    # Verify all pins are valid base64 (44 chars for SHA256)
    grep -oP "sha256/[A-Za-z0-9+/]+=*" lib/core/security/certificate_pinning.dart | while read pin; do
      hash=$(echo "$pin" | cut -d'/' -f2)
      if ! echo "$hash" | base64 -d >/dev/null 2>&1; then
        echo "ERROR: Invalid base64 in pin: $pin"
        exit 1
      fi
      # Verify hash is exactly 32 bytes (SHA256)
      decoded_len=$(echo "$hash" | base64 -d 2>/dev/null | wc -c)
      if [ "$decoded_len" -ne 32 ]; then
        echo "ERROR: Pin hash is not SHA256 (expected 32 bytes, got $decoded_len): $pin"
        exit 1
      fi
    done
    echo "All certificate pins validated successfully"
```

**Pre-Deployment Checklist (add to 20_CICD_PIPELINE.md):**
- [ ] Certificate pins verified against live domains using extraction commands
- [ ] Root CA expiry dates recorded (set reminder 45 days before rotation)
- [ ] Backup pins included for each domain (minimum 2 per domain)
- [ ] CI/CD gate passes (pin validation)

**Certificate Rotation Procedure:**
1. Generate new certificate 30 days before expiry
2. Add new pin to app release (keep old pin as fallback)
3. Deploy app update
4. After 30 days, remove old pin in next release
5. For third-party APIs: Monitor CA rotation announcements from Google, Apple, Fitbit, Garmin, Oura, WHOOP

### 5.5 Session Management (HIPAA Required)

**Session Timeouts:**

| Timeout Type | Duration | Trigger |
|--------------|----------|---------|
| Idle timeout | 30 minutes | No user interaction |
| Absolute timeout | 8 hours | From session start |
| Background timeout | 5 minutes | App moves to background |
| Inactivity logout | 90 days | No app usage |

```dart
class SessionManagementService {
  static const Duration idleTimeout = Duration(minutes: 30);
  static const Duration absoluteTimeout = Duration(hours: 8);
  static const Duration backgroundTimeout = Duration(minutes: 5);
  static const Duration inactivityLogout = Duration(days: 90);

  DateTime? _sessionStartedAt;
  DateTime? _lastActivityAt;
  DateTime? _backgroundedAt;

  /// Check if session is still valid
  bool isSessionValid() {
    final now = DateTime.now();

    // Absolute timeout check
    if (_sessionStartedAt != null &&
        now.difference(_sessionStartedAt!) > absoluteTimeout) {
      return false;
    }

    // Idle timeout check
    if (_lastActivityAt != null &&
        now.difference(_lastActivityAt!) > idleTimeout) {
      return false;
    }

    // Background timeout check
    if (_backgroundedAt != null &&
        now.difference(_backgroundedAt!) > backgroundTimeout) {
      return false;
    }

    return true;
  }

  /// Sign out user from all devices
  Future<Result<void, AppError>> signOutAllDevices(String userId) async {
    // Increment token version to invalidate all existing tokens
    await _tokenService.incrementTokenVersion(userId);
    await _auditLog.log(AuditEventType.sessionTermination, {'userId': userId, 'scope': 'all_devices'});
    return Success(null);
  }

  /// Revoke specific device's access
  Future<Result<void, AppError>> revokeDevice(String userId, String deviceId) async {
    await _deviceService.deactivateDevice(userId, deviceId);
    await _auditLog.log(AuditEventType.deviceRemoval, {'userId': userId, 'deviceId': deviceId});
    return Success(null);
  }

  /// Force re-authentication on next use
  Future<Result<void, AppError>> requireReauthentication(String userId) async {
    await _tokenService.invalidateAccessTokens(userId);
    return Success(null);
  }
}
```

**Enforcement:**
- Check session validity on every API request
- Show timeout warning 2 minutes before idle timeout
- Persist session start time in secure storage
- Clear all session data on logout

### 5.6 Biometric Authentication

Shadow supports biometric authentication as a secure, convenient alternative to password-based unlock.

**Platform Support:**

| Platform | Biometric Type | Framework |
|----------|----------------|-----------|
| iOS | Face ID, Touch ID | LocalAuthentication |
| Android | Fingerprint, Face, Iris | BiometricPrompt |
| macOS | Touch ID | LocalAuthentication |

**Implementation:**

```dart
class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if device supports biometrics
  Future<BiometricCapability> checkCapability() async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();

    if (!isDeviceSupported) return BiometricCapability.notSupported;
    if (!isAvailable) return BiometricCapability.notEnrolled;

    final biometrics = await _localAuth.getAvailableBiometrics();
    return BiometricCapability.available(biometrics);
  }

  /// Authenticate with biometrics
  Future<Result<void, BiometricError>> authenticate({
    required String reason,
    bool sensitiveTransaction = false,
  }) async {
    try {
      final success = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: sensitiveTransaction,
          useErrorDialogs: true,
        ),
      );

      if (success) {
        await _auditLog.log(AuditEntry(
          action: AuditAction.biometricAuthSuccess,
          metadata: {'sensitiveTransaction': sensitiveTransaction},
        ));
        return Success(null);
      }

      return Failure(BiometricError.authenticationFailed());
    } on PlatformException catch (e) {
      await _auditLog.log(AuditEntry(
        action: AuditAction.biometricAuthFailed,
        metadata: {'error': e.code},
      ));

      return switch (e.code) {
        'NotAvailable' => Failure(BiometricError.notAvailable()),
        'NotEnrolled' => Failure(BiometricError.notEnrolled()),
        'LockedOut' => Failure(BiometricError.lockedOut()),
        'PermanentlyLockedOut' => Failure(BiometricError.permanentlyLocked()),
        _ => Failure(BiometricError.unknown(e.message)),
      };
    }
  }
}

@freezed
class BiometricCapability with _$BiometricCapability {
  const factory BiometricCapability.notSupported() = _NotSupported;
  const factory BiometricCapability.notEnrolled() = _NotEnrolled;
  const factory BiometricCapability.available(List<BiometricType> types) = _Available;
}

@freezed
class BiometricError with _$BiometricError {
  const factory BiometricError.notAvailable() = _BioNotAvailable;
  const factory BiometricError.notEnrolled() = _BioNotEnrolled;
  const factory BiometricError.authenticationFailed() = _BioAuthFailed;
  const factory BiometricError.lockedOut() = _BioLockedOut;
  const factory BiometricError.permanentlyLocked() = _BioPermanentlyLocked;
  const factory BiometricError.unknown(String? message) = _BioUnknown;
}
```

**Use Cases for Biometric Authentication:**

| Scenario | Biometric Required | Fallback Allowed |
|----------|-------------------|------------------|
| App unlock (after timeout) | Optional (user preference) | Yes (PIN/password) |
| View sensitive data (PHI) | Recommended | Yes (password) |
| Export data | Required | No |
| Share profile | Required | No |
| Change security settings | Required | No |

**Security Constraints:**

1. **Enrollment Verification:** Only allow biometric auth if user has enrolled biometrics
2. **Fallback Required:** Always provide password/PIN fallback for accessibility
3. **Lockout Handling:** After 5 failed biometric attempts, require password
4. **Session Binding:** Biometric auth only valid for current session
5. **Audit Logging:** Log all biometric auth attempts (success and failure)

**Platform Configuration:**

iOS (Info.plist):
```xml
<key>NSFaceIDUsageDescription</key>
<string>Shadow uses Face ID to securely unlock your health data.</string>
```

Android (AndroidManifest.xml):
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

---

## 6. Audit Logging

### 6.1 HIPAA Audit Requirements

All PHI access must be logged with:

```dart
class AuditLogEntry {
  final DateTime timestamp;
  final String userId;
  final String deviceId;
  final String profileId;
  final AuditAction action;      // read, create, update, delete, export, share
  final String resourceType;
  final String resourceId;
  final AuditResult result;      // success, failure
  final String? errorMessage;
  final String? ipAddress;
  final String? userAgent;
  final String? sessionId;
}
```

### 6.2 Logging Methods

```dart
class AuditLogService {
  // PHI access logging
  Future<void> logPhiAccess({
    required String userId,
    required String profileId,
    required String resourceType,
    required String resourceId,
    required AuditAction action,
    required AuditResult result,
    String? errorMessage,
  }) async { ... }

  // Authentication events
  Future<void> logAuthentication({
    required String userId,
    required AuthAction action,  // signIn, signOut, tokenRefresh
    required AuditResult result,
  }) async { ... }

  // Data export tracking
  Future<void> logDataExport({
    required String userId,
    required String profileId,
    required ExportType type,   // pdf, share, backup
    required int recordCount,
  }) async { ... }
}
```

### 6.3 Retention

**HIPAA Audit Log Retention: 7 Years (CANONICAL)**

| Log Type | Minimum Retention | Notes |
|----------|-------------------|-------|
| PHI Access Logs | **7 years** | HIPAA Safe Harbor minimum is 6 years, but we use 7 for margin |
| Authentication Logs | **7 years** | Includes all sign-in/out, token operations |
| Authorization Changes | **7 years** | Profile sharing, permission changes |
| Security Events | **7 years** | Key rotation, rate limit violations |
| System Logs | **90 days** | Non-PHI operational logs |

**Implementation:**
- Logs are **immutable** (no modification after creation)
- Logs are **indexed** for efficient querying by userId, profileId, timestamp
- Logs are **encrypted at rest** with the database encryption key
- Logs older than 7 years are permanently deleted via scheduled job (runs monthly)
- Logs CANNOT be manually deleted before retention period expires

```dart
class AuditLogRetention {
  /// HIPAA-compliant retention period
  static const Duration phiLogRetention = Duration(days: 7 * 365); // 7 years

  /// Non-PHI operational logs
  static const Duration systemLogRetention = Duration(days: 90);

  /// Check if log can be deleted (for compliance)
  static bool canDelete(AuditLogEntry log) {
    final age = DateTime.now().difference(log.timestamp);
    return age > phiLogRetention;
  }
}
```

### 6.4 SEC-13: Audit Log Immutability Enforcement

> **CRITICAL SECURITY REQUIREMENT (SEC-13):**
> Audit logs MUST be immutable after creation. This is enforced at the database
> level using triggers to prevent any modification or deletion attempts.
> This is a HIPAA requirement for maintaining audit trail integrity.

**Database Triggers for Immutability:**

```sql
-- SEC-13: Audit Log Immutability Enforcement
-- These triggers MUST be created when the database is initialized

-- Prevent UPDATE on audit logs (logs are immutable)
CREATE TRIGGER IF NOT EXISTS prevent_audit_log_update
BEFORE UPDATE ON audit_logs
BEGIN
  SELECT RAISE(ABORT, 'AUDIT_LOG_IMMUTABLE: Cannot modify audit log entries');
END;

-- Prevent DELETE on audit logs before retention period
CREATE TRIGGER IF NOT EXISTS prevent_audit_log_delete
BEFORE DELETE ON audit_logs
WHEN OLD.timestamp > (strftime('%s', 'now') - (7 * 365 * 24 * 60 * 60)) * 1000
BEGIN
  SELECT RAISE(ABORT, 'AUDIT_LOG_PROTECTED: Cannot delete audit logs before 7-year retention period');
END;

-- Prevent UPDATE on profile access logs (HIPAA access logs are immutable)
CREATE TRIGGER IF NOT EXISTS prevent_access_log_update
BEFORE UPDATE ON profile_access_logs
BEGIN
  SELECT RAISE(ABORT, 'ACCESS_LOG_IMMUTABLE: Cannot modify access log entries');
END;

-- Prevent DELETE on profile access logs before retention period
CREATE TRIGGER IF NOT EXISTS prevent_access_log_delete
BEFORE DELETE ON profile_access_logs
WHEN OLD.accessed_at > (strftime('%s', 'now') - (7 * 365 * 24 * 60 * 60)) * 1000
BEGIN
  SELECT RAISE(ABORT, 'ACCESS_LOG_PROTECTED: Cannot delete access logs before 7-year retention period');
END;

-- Index for efficient retention-based cleanup
CREATE INDEX IF NOT EXISTS idx_audit_logs_retention
ON audit_logs(timestamp)
WHERE timestamp < (strftime('%s', 'now') - (7 * 365 * 24 * 60 * 60)) * 1000;

CREATE INDEX IF NOT EXISTS idx_access_logs_retention
ON profile_access_logs(accessed_at)
WHERE accessed_at < (strftime('%s', 'now') - (7 * 365 * 24 * 60 * 60)) * 1000;
```

**Application-Level Enforcement:**

```dart
/// SEC-13: Audit log repository with immutability enforcement
class ImmutableAuditLogRepository {
  final Database _db;

  /// Create audit log entry - the ONLY write operation allowed
  Future<void> log(AuditLogEntry entry) async {
    await _db.insert('audit_logs', entry.toMap());
    // Note: No update or delete methods are provided by design
  }

  /// Query audit logs (read-only operations)
  Future<List<AuditLogEntry>> query({
    String? userId,
    String? profileId,
    DateTime? startDate,
    DateTime? endDate,
    AuditAction? action,
  }) async {
    // Read-only query implementation
    final result = await _db.query(
      'audit_logs',
      where: _buildWhereClause(userId, profileId, startDate, endDate, action),
      whereArgs: _buildWhereArgs(userId, profileId, startDate, endDate, action),
      orderBy: 'timestamp DESC',
    );
    return result.map(AuditLogEntry.fromMap).toList();
  }

  /// INTENTIONALLY NOT PROVIDED:
  /// - update() - Audit logs are immutable
  /// - delete() - Audit logs cannot be manually deleted
  /// - truncate() - Audit logs cannot be bulk deleted

  /// Cleanup old logs (ONLY logs past retention period)
  /// This is the ONLY deletion operation, and is protected by database trigger
  Future<int> cleanupExpiredLogs() async {
    final retentionCutoff = DateTime.now()
        .subtract(AuditLogRetention.phiLogRetention)
        .millisecondsSinceEpoch;

    // The database trigger ensures only logs older than 7 years can be deleted
    return await _db.delete(
      'audit_logs',
      where: 'timestamp < ?',
      whereArgs: [retentionCutoff],
    );
  }
}
```

**Verification Test:**

```dart
/// Test that audit log immutability is properly enforced
void testAuditLogImmutability() {
  test('audit logs cannot be updated', () async {
    // Create a log entry
    final entry = AuditLogEntry(
      id: 'test-id',
      timestamp: DateTime.now(),
      action: AuditAction.read,
      // ...
    );
    await repository.log(entry);

    // Attempt to update should fail
    expect(
      () => db.update('audit_logs', {'action': 'write'}, where: 'id = ?', whereArgs: ['test-id']),
      throwsA(predicate((e) => e.toString().contains('AUDIT_LOG_IMMUTABLE'))),
    );
  });

  test('audit logs cannot be deleted before retention period', () async {
    // Create a recent log entry
    final entry = AuditLogEntry(
      id: 'recent-id',
      timestamp: DateTime.now(),
      // ...
    );
    await repository.log(entry);

    // Attempt to delete should fail
    expect(
      () => db.delete('audit_logs', where: 'id = ?', whereArgs: ['recent-id']),
      throwsA(predicate((e) => e.toString().contains('AUDIT_LOG_PROTECTED'))),
    );
  });
}
```

### 6.4 PII Masking in Log Storage

**CRITICAL:** Audit logs must not expose raw identifiers that could link to individuals.

**Masking Requirements:**

| Field | Storage Format | Lookup Method |
|-------|----------------|---------------|
| userId | SHA-256 hash + 4-char suffix | Reverse lookup table (encrypted) |
| deviceId | SHA-256 hash | Lookup via user's devices |
| ipAddress | Masked (e.g., 192.168.xxx.xxx) | Full IP in encrypted field |
| profileId | SHA-256 hash + 4-char suffix | Reverse lookup table |

**Implementation:**

```dart
class AuditLogMasking {
  /// Hash identifier for log storage
  /// Preserves lookup ability via suffix while protecting raw ID
  static String maskIdentifier(String id) {
    final hash = sha256.convert(utf8.encode(id)).toString();
    final suffix = id.substring(id.length - 4);
    return '${hash.substring(0, 16)}...$suffix';
  }

  /// Alias for maskIdentifier - use for user IDs in logs
  static String maskUserId(String userId) => maskIdentifier(userId);

  /// Alias for maskIdentifier - use for profile IDs in logs
  static String maskProfileId(String profileId) => maskIdentifier(profileId);

  /// Alias for maskIdentifier - use for device IDs in logs (no suffix)
  static String maskDeviceId(String deviceId) {
    final hash = sha256.convert(utf8.encode(deviceId)).toString();
    return hash.substring(0, 16);  // No suffix for device IDs
  }

  /// Mask IP address for privacy
  /// Retains network segment for geographic analysis
  static String maskIpAddress(String ip) {
    final parts = ip.split('.');
    if (parts.length == 4) {
      return '${parts[0]}.${parts[1]}.xxx.xxx';
    }
    // IPv6: mask last 64 bits
    return ip.replaceRange(ip.length ~/ 2, ip.length, '::xxxx');
  }
}

/// Audit log entry with masked identifiers
class MaskedAuditLogEntry {
  final DateTime timestamp;
  final String maskedUserId;      // Hash + suffix
  final String maskedDeviceId;    // Hash only
  final String maskedProfileId;   // Hash + suffix
  final AuditAction action;
  final String resourceType;
  final String maskedResourceId;  // Hash
  final AuditResult result;
  final String? maskedIpAddress;  // Partial IP

  /// Full identifiers stored encrypted separately for authorized retrieval
  final String? encryptedIdentifiers;  // AES-256 encrypted JSON
}
```

**Authorized Access to Full Identifiers:**

Full identifiers can only be retrieved by:
1. System administrators during security investigations
2. HIPAA compliance audits with proper authorization
3. Legal requests with valid subpoena

Access to full identifiers MUST be logged separately.

---

## 7. Security Monitoring

### 7.1 Real-Time Threat Detection

```dart
class SecurityMonitoringService {
  // Monitored events
  void trackEvent(SecurityEventType type, Map<String, dynamic> metadata) {
    _events.add(SecurityEvent(
      type: type,
      timestamp: DateTime.now(),
      metadata: metadata,
    ));
    _checkThresholds(type);
  }

  void _checkThresholds(SecurityEventType type) {
    switch (type) {
      case SecurityEventType.failedAuth:
        if (_countRecent(type, Duration(minutes: 15)) >= 5) {
          _raiseAlert(AlertSeverity.high, 'Excessive failed auth attempts');
        }
        break;
      case SecurityEventType.authorizedPhiAccess:
        if (_countRecent(type, Duration(hours: 1)) >= 100) {
          _raiseAlert(AlertSeverity.medium, 'Excessive PHI access');
        }
        break;
      case SecurityEventType.dataExport:
        if (_countRecent(type, Duration(hours: 1)) >= 50) {
          _raiseAlert(AlertSeverity.high, 'Bulk data export detected');
        }
        break;
    }
  }
}
```

### 7.2 Alert Severity Levels

| Severity | Trigger | Response |
|----------|---------|----------|
| CRITICAL | Unauthorized PHI access | Immediate notification |
| HIGH | Excessive failed auth, bulk export | Prompt investigation |
| MEDIUM | Excessive PHI access, multi-device login | Logged for review |
| LOW | Other security events | Standard monitoring |

---

## 8. Input Validation & Sanitization

### 8.1 Sanitization Functions

```dart
class Sanitizers {
  // Remove HTML/script content
  static String stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // Escape HTML entities
  static String escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }

  // Remove invisible/zero-width characters (homograph attack prevention)
  static String removeInvisibleCharacters(String input) {
    return input.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF\u00AD]'), '');
  }

  // Path traversal prevention
  static String sanitizeFilePath(String path) {
    return path
        .replaceAll('..', '')
        .replaceAll(RegExp(r'^[/\\]'), '');
  }

  // Safe filename
  static String sanitizeFileName(String filename, {int maxLength = 255}) {
    final safe = filename
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\.{2,}'), '.')
        .trim();
    return safe.length > maxLength ? safe.substring(0, maxLength) : safe;
  }

  // Comprehensive user content sanitization
  static String sanitizeUserContent(String input) {
    var result = input;
    result = removeInvisibleCharacters(result);
    result = stripHtml(result);
    result = result.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'), '');
    return result.trim();
  }
}
```

### 8.2 SQL Injection Prevention

**Primary defense:** Parameterized queries (never string concatenation)

```dart
// CORRECT: Parameterized query
await db.query(
  'supplements',
  where: 'profile_id = ? AND sync_deleted_at IS NULL',
  whereArgs: [profileId],
);

// WRONG: String concatenation (NEVER DO THIS)
// await db.rawQuery("SELECT * FROM supplements WHERE profile_id = '$profileId'");
```

---

## 9. File Security

### 9.1 File Validation

```dart
class FileValidationService {
  // Size limits
  static const int maxPhotoSize = 10 * 1024 * 1024;      // 10 MB
  static const int maxDocumentSize = 50 * 1024 * 1024;   // 50 MB

  Future<File> validateAndProcessPhoto(File file) async {
    // 1. Check file size
    if (await file.length() > maxPhotoSize) {
      throw FileValidationException('File exceeds 10 MB limit');
    }

    // 2. Validate MIME type via magic bytes (not extension)
    final mimeType = await _detectMimeType(file);
    if (!['image/jpeg', 'image/png'].contains(mimeType)) {
      throw FileValidationException('Invalid image type');
    }

    // 3. Strip EXIF metadata (privacy protection)
    return await _stripExifMetadata(file, mimeType);
  }
}
```

### 9.2 EXIF Metadata Stripping

**CRITICAL for privacy:** Remove GPS location, device info, timestamps

```dart
Future<File> _stripExifMetadata(File file, String mimeType) async {
  final bytes = await file.readAsBytes();

  if (mimeType == 'image/jpeg') {
    // Strip APP1 marker (0xFFE1) containing EXIF
    final stripped = _stripJpegExif(bytes);
    await file.writeAsBytes(stripped);
  } else if (mimeType == 'image/png') {
    // Remove metadata chunks (tEXt, zTXt, iTXt, tIME, eXIf)
    final stripped = _stripPngMetadata(bytes);
    await file.writeAsBytes(stripped);
  } else {
    // HEIC/HEIF cannot be safely stripped - REJECT
    throw FileValidationException(
      'HEIC files not supported - cannot safely strip metadata'
    );
  }

  return file;
}
```

### 9.3 Rejected File Types

| Type | Reason |
|------|--------|
| HEIC/HEIF | Cannot safely strip EXIF metadata |
| Executable | Security risk |
| Archives | Cannot validate contents |

---

## 10. Secure Error Handling

### 10.1 Error Information Protection

```dart
class SecureErrorHandler {
  // Log full details for developers
  void logError(dynamic error, StackTrace stackTrace) {
    _logger.error('Full error: $error\n$stackTrace');
  }

  // Return sanitized message to users
  String getUserMessage(dynamic error) {
    // Never expose internal details
    if (error is DatabaseException) {
      return 'A data error occurred. Please try again.';
    }
    if (error is NetworkException) {
      return 'Connection error. Please check your network.';
    }
    return 'An unexpected error occurred.';
  }

  // Redact sensitive patterns
  String redactSensitive(String message) {
    return message
        .replaceAll(RegExp(r'(sk-|pk-|key_|api_key)[a-zA-Z0-9]+'), '[REDACTED]')
        .replaceAll(RegExp(r'eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+'), '[JWT_REDACTED]')
        .replaceAll(RegExp(r'SHADOW_ERR_\d+'), '[ERROR_CODE]');
  }
}
```

### 10.2 Identifier Redaction in User Messages

**CRITICAL: User-facing error messages MUST NOT include:**
- Profile IDs
- User IDs
- Device IDs
- Session IDs
- Internal entity IDs
- Database record identifiers

```dart
// INCORRECT - exposes internal identifiers
throw AuthError('Access denied to profile 550e8400-e29b-41d4-a716-446655440000');

// CORRECT - generic message without identifiers
throw AuthError('You do not have access to this profile.');

// INCORRECT - exposes user ID
_log.error('User abc123 failed to authenticate');
showSnackBar('Authentication failed for user abc123');  // NEVER

// CORRECT - log internally, generic user message
_log.error('User ${maskUserId(userId)} failed to authenticate');  // Internal log only
showSnackBar('Authentication failed. Please try again.');  // User message
```

**Required redaction patterns for all user-visible strings:**
| Pattern | Redact To |
|---------|-----------|
| UUID pattern | `[ID]` |
| Profile/User ID | `[ID]` |
| Device ID | `[DEVICE]` |
| Email addresses | First 2 chars + `***@domain` |
| API keys/tokens | `[REDACTED]` |

---

## 11. Platform Security

### 11.1 iOS/macOS

```dart
// Keychain configuration
FlutterSecureStorage(
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
  macOptions: MacOsOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
)
```

### 11.2 Android

```dart
// EncryptedSharedPreferences
FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
)
```

---

## 12. Secure Storage Keys

Centralized key management:

```dart
class SecureStorageKeys {
  // OAuth tokens
  static const String googleDriveAccessToken = 'google_drive_access_token';
  static const String googleDriveRefreshToken = 'google_drive_refresh_token';
  static const String tokenExpiry = 'google_drive_token_expiry';
  static const String userEmail = 'google_drive_user_email';

  // Encryption keys
  static const String dbMasterKey = 'db_master_encryption_key';
  static const String dbKeyVersion = 'db_key_version';
  static const String appEncryptionKey = 'shadow_encryption_key';
}
```

---

## 13. Security Checklist

### 13.1 Code Review Checklist

- [ ] No hardcoded secrets or credentials
- [ ] Parameterized queries for all database operations
- [ ] User input sanitized before use
- [ ] Sensitive data encrypted at rest
- [ ] Error messages don't leak internal details
- [ ] PHI access is logged
- [ ] File uploads validated (size, type, metadata stripped)
- [ ] OAuth flows use PKCE
- [ ] HTTPS enforced for all network calls

### 13.2 Deployment Checklist

- [ ] OAuth client secrets configured on backend only
- [ ] Production encryption keys generated and stored
- [ ] Audit logging enabled
- [ ] Security monitoring active
- [ ] Rate limiting configured
- [ ] Certificate pinning enabled (if applicable)

---

## 14. Incident Response

### 14.1 Security Incident Classification

| Class | Description | Response Time |
|-------|-------------|---------------|
| P1 | Data breach, unauthorized PHI access | Immediate |
| P2 | Credential compromise, system intrusion | 4 hours |
| P3 | Vulnerability discovered, failed attack | 24 hours |
| P4 | Policy violation, configuration issue | 72 hours |

### 14.2 Response Procedures

1. **Contain** - Limit damage (revoke tokens, disable accounts)
2. **Investigate** - Review audit logs, identify scope
3. **Remediate** - Fix vulnerability, rotate credentials
4. **Notify** - HIPAA breach notification if PHI exposed
5. **Document** - Complete incident report

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-02-01 | Added rate limiting scope documentation; Standardized audit log retention to 7 years; Added key rotation procedures |
| 1.2 | 2026-02-02 | SEC-01: Replaced placeholder certificate pins with explicit deployment requirements; SEC-13: Added audit log immutability enforcement with database triggers |
