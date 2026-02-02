# Shadow OAuth Implementation Guide

**Version:** 1.0
**Last Updated:** January 30, 2026
**Classification:** CONFIDENTIAL - Contains credential information

---

## Overview

Shadow uses Google OAuth 2.0 with PKCE (Proof Key for Code Exchange) for secure authentication. This document provides complete implementation details including actual credential values.

### Error Handling in OAuth

**Startup Exceptions (Acceptable):** Missing environment variables and invalid configuration at app startup may throw `StateError` since these are fatal configuration issues that prevent the app from running.

**Runtime Operations (Use Result Type):** All OAuth operations during normal app execution return `Result<T, AuthError>`:
- `signIn()` → `Result<AuthTokens, AuthError>`
- `refreshTokens()` → `Result<AuthTokens, AuthError>`
- `signOut()` → `Result<void, AuthError>`

```dart
// Runtime operations use Result type
Future<Result<AuthTokens, AuthError>> signIn() async {
  final result = await _performOAuthFlow();
  return result.when(
    success: (tokens) => Success(tokens),
    failure: (error) => Failure(AuthError.authenticationFailed(error.message)),
  );
}
```

---

## 1. OAuth Configuration

### 1.1 Current Credentials

**Google Cloud Project:** Shadow Health Tracker

**Client IDs by Platform:**

| Platform | Client ID |
|----------|-----------|
| Desktop/macOS | `656246118580-nvu5ckn9l7vst8hmj8no3t7cb10egui3.apps.googleusercontent.com` |
| iOS | `656246118580-s9p6jcg8pcumirbrp3pmed49uft43th2.apps.googleusercontent.com` |

### 1.2 OAuth Endpoints

```dart
static const String authUri = 'https://accounts.google.com/o/oauth2/auth';
static const String tokenUri = 'https://oauth2.googleapis.com/token';
static const String userInfoUri = 'https://www.googleapis.com/oauth2/v2/userinfo';
```

### 1.3 Scopes

```dart
static const List<String> scopes = [
  'https://www.googleapis.com/auth/drive.file',  // App-created files only
  'email',                                         // User identification
  'profile',                                       // Display name, photo
];
```

**Note:** `drive.file` scope is intentionally restrictive - it only allows access to files created by the app, not the user's entire Drive. This is a HIPAA compliance requirement.

### 1.4 Redirect URIs

| Platform | Redirect URI |
|----------|--------------|
| Desktop Development | `http://localhost:8080` |
| iOS | `com.googleusercontent.apps.656246118580-s9p6jcg8pcumirbrp3pmed49uft43th2:/oauth2redirect` |

---

## 2. Environment Configuration

### 2.1 Environment File (.env)

Create `.env` in project root:

```env
# Google OAuth Configuration
GOOGLE_OAUTH_CLIENT_ID=656246118580-nvu5ckn9l7vst8hmj8no3t7cb10egui3.apps.googleusercontent.com
OAUTH_REDIRECT_URI=http://localhost:8080
OAUTH_PROXY_BASE_URL=http://localhost:5000

# PDF API (if using external service)
PDF_API_BASE_URL=https://localhost:5000
```

### 2.2 Dart Define Flags

For production builds, pass credentials via `--dart-define`:

```bash
flutter run \
  --dart-define=GOOGLE_OAUTH_CLIENT_ID=656246118580-nvu5ckn9l7vst8hmj8no3t7cb10egui3.apps.googleusercontent.com \
  --dart-define=OAUTH_REDIRECT_URI=http://localhost:8080 \
  --dart-define=OAUTH_PROXY_BASE_URL=http://localhost:5000
```

### 2.3 VS Code Launch Configuration

`.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Shadow (Debug)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=GOOGLE_OAUTH_CLIENT_ID=656246118580-nvu5ckn9l7vst8hmj8no3t7cb10egui3.apps.googleusercontent.com",
        "--dart-define=OAUTH_REDIRECT_URI=http://localhost:8080",
        "--dart-define=OAUTH_PROXY_BASE_URL=http://localhost:5000"
      ]
    }
  ]
}
```

---

## 3. Platform-Specific Configuration

### 3.1 iOS Configuration

**File:** `ios/Runner/Info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Google Sign-In Client ID -->
    <key>GIDClientID</key>
    <string>656246118580-s9p6jcg8pcumirbrp3pmed49uft43th2.apps.googleusercontent.com</string>

    <!-- URL Schemes for OAuth callback -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>com.googleusercontent.apps.656246118580-s9p6jcg8pcumirbrp3pmed49uft43th2</string>
            </array>
        </dict>
    </array>

    <!-- Other required keys... -->
</dict>
</plist>
```

### 3.2 macOS Configuration

**File:** `macos/Runner/Info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- URL Schemes for OAuth callback (desktop uses loopback) -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>com.bluedomecolorado.shadow</string>
            </array>
        </dict>
    </array>

    <!-- Required for network access -->
    <key>com.apple.security.network.client</key>
    <true/>
</dict>
</plist>
```

**File:** `macos/Runner/DebugProfile.entitlements` and `Release.entitlements`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <true/>
    <key>com.apple.security.network.server</key>
    <true/>
</dict>
</plist>
```

### 3.3 Android Configuration

**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Internet permission for OAuth -->
    <uses-permission android:name="android.permission.INTERNET"/>

    <application ...>
        <!-- Google Sign-In activity -->
        <activity
            android:name="com.google.android.gms.auth.api.signin.internal.SignInHubActivity"
            android:excludeFromRecents="true"
            android:exported="false"
            android:theme="@android:style/Theme.Translucent.NoTitleBar" />

        <!-- Main activity -->
        <activity
            android:name=".MainActivity"
            android:exported="true"
            ...>
        </activity>
    </application>
</manifest>
```

---

## 4. OAuth Configuration Class

**File:** `lib/core/config/google_oauth_config.dart`

```dart
import '../services/logger_service.dart';

/// Google OAuth 2.0 configuration for Shadow app.
///
/// Loads credentials from environment variables (--dart-define or .env).
/// Validates configuration on app startup.
class GoogleOAuthConfig {
  static final _log = logger.scope('GoogleOAuthConfig');

  // ============ OAuth Endpoints ============

  /// Google OAuth 2.0 authorization endpoint
  static const String authUri = 'https://accounts.google.com/o/oauth2/auth';

  /// Google OAuth 2.0 token endpoint
  static const String tokenUri = 'https://oauth2.googleapis.com/token';

  /// Google user info endpoint
  static const String userInfoUri = 'https://www.googleapis.com/oauth2/v2/userinfo';

  // ============ Client Configuration ============

  /// OAuth client ID from environment
  ///
  /// Set via: --dart-define=GOOGLE_OAUTH_CLIENT_ID=...
  /// Or: GOOGLE_OAUTH_CLIENT_ID in .env file
  static String get clientId {
    const fromEnvironment = String.fromEnvironment('GOOGLE_OAUTH_CLIENT_ID');

    if (fromEnvironment.isNotEmpty) {
      return fromEnvironment;
    }

    // In production, this is a fatal error
    const isProduction = bool.fromEnvironment('dart.vm.product');
    if (isProduction) {
      throw StateError(
        'GOOGLE_OAUTH_CLIENT_ID environment variable not set. '
        'Pass via --dart-define=GOOGLE_OAUTH_CLIENT_ID=your-client-id',
      );
    }

    // Development fallback - use default client ID
    _log.warning('Using default development OAuth client ID');
    return '656246118580-nvu5ckn9l7vst8hmj8no3t7cb10egui3.apps.googleusercontent.com';
  }

  /// OAuth redirect URI from environment
  static String get redirectUri {
    const fromEnvironment = String.fromEnvironment('OAUTH_REDIRECT_URI');

    if (fromEnvironment.isNotEmpty) {
      // SECURITY: Validate HTTPS in production
      const isProduction = bool.fromEnvironment('dart.vm.product');
      if (isProduction &&
          !fromEnvironment.startsWith('https://') &&
          !fromEnvironment.startsWith('com.')) {
        throw StateError(
          'OAUTH_REDIRECT_URI must use HTTPS or custom scheme in production.',
        );
      }
      return fromEnvironment;
    }

    // Development default: localhost loopback
    return 'http://localhost:8080';
  }

  /// OAuth proxy base URL (for token exchange)
  static String get proxyBaseUrl {
    const fromEnvironment = String.fromEnvironment('OAUTH_PROXY_BASE_URL');

    if (fromEnvironment.isNotEmpty) {
      return fromEnvironment;
    }

    // Development default
    return 'http://localhost:5000';
  }

  // ============ Scopes ============

  /// OAuth scopes requested
  ///
  /// - drive.file: Access only app-created files (HIPAA compliant)
  /// - email: User identification
  /// - profile: Display name and photo
  static const List<String> scopes = [
    'https://www.googleapis.com/auth/drive.file',
    'email',
    'profile',
  ];

  // ============ Validation ============

  /// Validates OAuth configuration on startup
  ///
  /// Call this in main() before using OAuth:
  /// ```dart
  /// void main() {
  ///   GoogleOAuthConfig.validate();
  ///   runApp(MyApp());
  /// }
  /// ```
  static void validate() {
    _log.info('Validating OAuth configuration...');

    // Validate client ID format
    final id = clientId;
    assert(
      id.isNotEmpty && id.contains('.apps.googleusercontent.com'),
      'Invalid OAuth clientId: must end in .apps.googleusercontent.com',
    );

    // Validate endpoints are HTTPS
    assert(
      authUri.startsWith('https://'),
      'authUri must be HTTPS',
    );
    assert(
      tokenUri.startsWith('https://'),
      'tokenUri must be HTTPS',
    );

    // Validate redirect URI format
    final redirect = redirectUri;
    assert(
      redirect.isNotEmpty,
      'redirectUri cannot be empty',
    );

    // Validate scopes include Drive
    assert(
      scopes.any((s) => s.contains('drive')),
      'scopes must include a Google Drive scope',
    );

    _log.info('✓ OAuth configuration valid');
    _log.debug('  Client ID: ${id.substring(0, 20)}...');
    _log.debug('  Redirect URI: $redirect');
    _log.debug('  Scopes: ${scopes.join(", ")}');
  }
}
```

---

## 5. PKCE Implementation

### 5.1 PKCE Flow Overview

```
1. Generate code_verifier (128 random chars)
2. Generate code_challenge = BASE64URL(SHA256(code_verifier))
3. Send code_challenge with authorization request
4. Receive authorization_code
5. Exchange code + code_verifier for tokens
6. Google validates SHA256(code_verifier) == code_challenge
```

### 5.2 PKCE Implementation

**File:** `lib/data/cloud/macos_google_oauth.dart`

```dart
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

class MacOSGoogleOAuth {
  static final _log = logger.scope('MacOSGoogleOAuth');

  /// Performs OAuth 2.0 authorization with PKCE.
  ///
  /// Returns map with access_token, refresh_token, and user info.
  static Future<Map<String, dynamic>> authorize() async {
    // Step 1: Generate PKCE code verifier and challenge
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);

    // Step 2: Generate state for CSRF protection
    final stateBytes = List.generate(32, (i) => Random.secure().nextInt(256));
    final state = base64Url.encode(stateBytes).replaceAll('=', '');

    // Step 3: Build authorization URL
    final authUrl = Uri.parse(GoogleOAuthConfig.authUri).replace(
      queryParameters: {
        'client_id': GoogleOAuthConfig.clientId,
        'redirect_uri': GoogleOAuthConfig.redirectUri,
        'response_type': 'code',
        'scope': GoogleOAuthConfig.scopes.join(' '),
        'state': state,
        'access_type': 'offline',    // Request refresh token
        'prompt': 'consent',          // Always show consent screen
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
      },
    );

    _log.info('Starting OAuth flow...');
    _log.debug('Auth URL: ${authUrl.toString().substring(0, 100)}...');

    // Step 4: Start local server to receive callback
    final server = await HttpServer.bind('localhost', 8080);
    _log.info('Listening for OAuth callback on localhost:8080');

    // Step 5: Open browser for user authorization
    await launchUrl(authUrl, mode: LaunchMode.externalApplication);

    // Step 6: Wait for callback
    final request = await server.first;
    final uri = request.uri;

    // Step 7: Validate state parameter (CSRF protection)
    final receivedState = uri.queryParameters['state'];
    if (receivedState != state) {
      await _sendErrorResponse(request, 'State mismatch - possible CSRF attack');
      await server.close();
      throw OAuthStateException(
        message: 'State parameter mismatch',
        expectedState: state,
        receivedState: receivedState ?? '',
      );
    }

    // Step 8: Check for error
    final error = uri.queryParameters['error'];
    if (error != null) {
      await _sendErrorResponse(request, error);
      await server.close();
      throw OAuthException(
        message: 'Authorization failed',
        errorCode: error,
      );
    }

    // Step 9: Extract authorization code
    final code = uri.queryParameters['code'];
    if (code == null) {
      await _sendErrorResponse(request, 'No authorization code received');
      await server.close();
      throw OAuthException(message: 'No authorization code received');
    }

    // Step 10: Send success response to browser
    await _sendSuccessResponse(request);
    await server.close();

    _log.info('✓ Authorization code received');

    // Step 11: Exchange code for tokens (via proxy)
    return await _exchangeCodeForTokens(code, codeVerifier);
  }

  /// Generate cryptographically secure code verifier (RFC 7636)
  static String _generateCodeVerifier() {
    const charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(
      128, // Maximum recommended length
      (i) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Generate code challenge from verifier using SHA256 (RFC 7636)
  static String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    // Base64url encode without padding
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  /// Exchange authorization code for tokens via OAuth proxy
  static Future<Map<String, dynamic>> _exchangeCodeForTokens(
    String code,
    String codeVerifier,
  ) async {
    final oauthProxy = GetIt.instance<OAuthProxyService>();

    final tokens = await oauthProxy.exchangeCode(
      code: code,
      codeVerifier: codeVerifier,
      redirectUri: GoogleOAuthConfig.redirectUri,
    );

    _log.info('✓ Tokens received from proxy');
    return tokens;
  }

  static Future<void> _sendSuccessResponse(HttpRequest request) async {
    request.response
      ..statusCode = 200
      ..headers.contentType = ContentType.html
      ..write('''
        <!DOCTYPE html>
        <html>
        <body style="font-family: -apple-system, sans-serif; text-align: center; padding: 50px;">
          <h1>✓ Sign-in Successful</h1>
          <p>You can close this window and return to Shadow.</p>
          <script>setTimeout(() => window.close(), 2000);</script>
        </body>
        </html>
      ''');
    await request.response.close();
  }

  static Future<void> _sendErrorResponse(HttpRequest request, String error) async {
    request.response
      ..statusCode = 400
      ..headers.contentType = ContentType.html
      ..write('''
        <!DOCTYPE html>
        <html>
        <body style="font-family: -apple-system, sans-serif; text-align: center; padding: 50px;">
          <h1>✗ Sign-in Failed</h1>
          <p>Error: $error</p>
          <p>Please close this window and try again.</p>
        </body>
        </html>
      ''');
    await request.response.close();
  }
}
```

---

## 6. OAuth Proxy Service

### 6.1 Why Use a Proxy?

The client secret should NEVER be stored in the mobile/desktop app binary. Instead:

1. App sends authorization code to proxy server
2. Proxy adds client_secret and calls Google
3. Proxy returns tokens to app
4. Client secret remains server-side only

### 6.2 Proxy Service Implementation

**File:** `lib/core/services/oauth_proxy_service.dart`

```dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/google_oauth_config.dart';
import 'logger_service.dart';

/// Default timeout for HTTP requests to OAuth proxy
const _httpTimeout = Duration(seconds: 30);

/// Service for OAuth token operations via backend proxy.
///
/// The proxy server holds the client_secret, keeping it out of the app binary.
class OAuthProxyService {
  static final _log = logger.scope('OAuthProxyService');

  /// Exchange authorization code for tokens.
  ///
  /// The proxy adds the client_secret before calling Google.
  Future<Map<String, dynamic>> exchangeCode({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) async {
    _log.info('Exchanging authorization code for tokens...');

    final uri = Uri.parse('${GoogleOAuthConfig.proxyBaseUrl}/api/oauth/token');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'code_verifier': codeVerifier,
          'redirect_uri': redirectUri,
          'client_id': GoogleOAuthConfig.clientId,
        }),
      ).timeout(_httpTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _log.info('✓ Token exchange successful');
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw OAuthException(
          message: 'Token exchange failed',
          errorCode: error['error'] ?? 'unknown',
          details: error['error_description'],
        );
      }
    } on TimeoutException catch (e, stackTrace) {
      _log.error('Timeout during token exchange', e, stackTrace);
      throw OAuthException(
        message: 'Token exchange timed out',
        errorCode: 'timeout_error',
        details: 'Server did not respond within ${_httpTimeout.inSeconds} seconds',
      );
    } on http.ClientException catch (e, stackTrace) {
      _log.error('Network error during token exchange', e, stackTrace);
      throw OAuthException(
        message: 'Network error during token exchange',
        errorCode: 'network_error',
        details: e.message,
      );
    }
  }

  /// Refresh access token using refresh token.
  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    _log.info('Refreshing access token...');

    final uri = Uri.parse('${GoogleOAuthConfig.proxyBaseUrl}/api/oauth/refresh');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refresh_token': refreshToken,
          'client_id': GoogleOAuthConfig.clientId,
        }),
      ).timeout(_httpTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _log.info('✓ Token refresh successful');
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw OAuthException(
          message: 'Token refresh failed',
          errorCode: error['error'] ?? 'unknown',
          details: error['error_description'],
        );
      }
    } on TimeoutException catch (e, stackTrace) {
      _log.error('Timeout during token refresh', e, stackTrace);
      throw OAuthException(
        message: 'Token refresh timed out',
        errorCode: 'timeout_error',
        details: 'Server did not respond within ${_httpTimeout.inSeconds} seconds',
      );
    }
  }
}
```

---

## 7. Token Storage

### 7.1 Secure Storage Keys

**File:** `lib/core/config/app_constants.dart`

```dart
class SecureStorageKeys {
  // Google Drive OAuth Tokens (separate keys for security)
  static const String googleDriveAccessToken = 'google_drive_access_token';
  static const String googleDriveRefreshToken = 'google_drive_refresh_token';
  static const String googleDriveTokenExpiry = 'google_drive_token_expiry';
  static const String googleDriveUserEmail = 'google_drive_user_email';

  // Legacy key (for migration from older versions)
  static const String googleDriveLegacyTokens = 'google_drive_macos_tokens';
}
```

### 7.2 Token Management

```dart
class TokenManager {
  final FlutterSecureStorage _storage;

  /// Store tokens after successful authentication
  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String userEmail,
  }) async {
    await Future.wait([
      _storage.write(
        key: SecureStorageKeys.googleDriveAccessToken,
        value: accessToken,
      ),
      _storage.write(
        key: SecureStorageKeys.googleDriveRefreshToken,
        value: refreshToken,
      ),
      _storage.write(
        key: SecureStorageKeys.googleDriveTokenExpiry,
        value: expiresAt.toIso8601String(),
      ),
      _storage.write(
        key: SecureStorageKeys.googleDriveUserEmail,
        value: userEmail,
      ),
    ]);
  }

  /// Clear all tokens on sign-out
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: SecureStorageKeys.googleDriveAccessToken),
      _storage.delete(key: SecureStorageKeys.googleDriveRefreshToken),
      _storage.delete(key: SecureStorageKeys.googleDriveTokenExpiry),
      _storage.delete(key: SecureStorageKeys.googleDriveUserEmail),
    ]);
  }

  /// Check if token needs refresh (5 min before expiry)
  bool needsRefresh(DateTime expiresAt) {
    final threshold = DateTime.now().add(Duration(minutes: 5));
    return expiresAt.isBefore(threshold);
  }
}
```

### 7.3 Token Refresh Failure Handling

When token refresh fails, handle gracefully based on the error type:

| Error Code | Cause | Recovery Action |
|------------|-------|-----------------|
| `invalid_grant` | Refresh token revoked or expired | Clear tokens, require re-authentication |
| `invalid_client` | Client credentials changed | Clear tokens, require re-authentication |
| `timeout_error` | Network timeout | Retry with exponential backoff (max 3 attempts) |
| `network_error` | No internet connection | Queue sync, retry when online |
| Other errors | Server error | Retry once, then fail sync and notify user |

**Implementation:**

```dart
class TokenRefreshHandler {
  static const int maxRetries = 3;
  static const Duration baseDelay = Duration(seconds: 2);

  Future<Map<String, dynamic>?> refreshWithRetry(String refreshToken) async {
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      try {
        return await _oAuthService.refreshAccessToken(refreshToken);
      } on OAuthException catch (e) {
        if (_isPermanentError(e.errorCode)) {
          // Clear tokens and require re-auth
          await _tokenManager.clearTokens();
          throw AuthenticationRequiredException(
            message: 'Session expired. Please sign in again.',
          );
        }
        if (attempt < maxRetries - 1) {
          await Future.delayed(baseDelay * pow(2, attempt));
          continue;
        }
        rethrow;
      }
    }
    return null;
  }

  bool _isPermanentError(String? errorCode) {
    return errorCode == 'invalid_grant' ||
           errorCode == 'invalid_client' ||
           errorCode == 'access_denied';
  }
}
```

**User Experience:**
- On permanent failure: Show "Session expired" dialog with "Sign In" button
- On temporary failure: Show sync status indicator, retry in background
- Never silently fail - user should always know sync status

---

## 8. Python Backend Proxy (Reference)

### 8.1 Flask Implementation

```python
from flask import Flask, request, jsonify
import requests
import os

app = Flask(__name__)

# Client secret stored server-side only
CLIENT_SECRET = os.environ.get('GOOGLE_CLIENT_SECRET')
TOKEN_URI = 'https://oauth2.googleapis.com/token'

@app.route('/api/oauth/token', methods=['POST'])
def exchange_token():
    """Exchange authorization code for tokens."""
    data = request.json

    # Add client_secret before calling Google
    payload = {
        'code': data['code'],
        'code_verifier': data['code_verifier'],
        'redirect_uri': data['redirect_uri'],
        'client_id': data['client_id'],
        'client_secret': CLIENT_SECRET,  # Added server-side
        'grant_type': 'authorization_code',
    }

    response = requests.post(TOKEN_URI, data=payload)
    return jsonify(response.json()), response.status_code

@app.route('/api/oauth/refresh', methods=['POST'])
def refresh_token():
    """Refresh access token."""
    data = request.json

    payload = {
        'refresh_token': data['refresh_token'],
        'client_id': data['client_id'],
        'client_secret': CLIENT_SECRET,  # Added server-side
        'grant_type': 'refresh_token',
    }

    response = requests.post(TOKEN_URI, data=payload)
    return jsonify(response.json()), response.status_code

if __name__ == '__main__':
    app.run(port=5000)
```

---

## 9. Security Checklist

Before deploying OAuth:

- [ ] Client ID loaded from environment, not hardcoded
- [ ] Client secret NEVER in app code (proxy only)
- [ ] PKCE implemented with SHA256
- [ ] State parameter validates on callback
- [ ] Tokens stored in platform secure storage
- [ ] Token refresh implemented before expiry
- [ ] All HTTP calls have timeouts
- [ ] Error handling doesn't expose sensitive details
- [ ] Logs mask email addresses and tokens
- [ ] HTTPS enforced in production

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
