# ADR 0003: OAuth 2.0 PKCE Flow for Cloud Synchronization

**Date**: 2026-01-13

**Status**: Accepted

**Decision Makers**: Development Team

---

## Context

The Shadow App implements bi-directional cloud synchronization using Google Drive as the storage provider. This requires secure authentication to:

1. Obtain user consent for Google Drive access
2. Retrieve OAuth tokens for API calls
3. Securely refresh tokens without user intervention
4. Support multiple platforms (iOS, macOS, Android, Windows)
5. Protect against authorization code interception attacks

### OAuth Requirements

1. **Secure Authentication**: No credentials stored in app
2. **Limited Scope**: Access only to app-created files (drive.file)
3. **Token Security**: Secure storage and automatic refresh
4. **Cross-Platform**: Same flow across all platforms
5. **Native Experience**: Use platform-appropriate OAuth libraries
6. **PKCE Support**: Required for mobile/desktop public clients

### Alternatives Considered

1. **Implicit Flow (OAuth 2.0 Legacy)**
   - Tokens returned directly in URL fragment
   - No refresh tokens
   - Deprecated by OAuth 2.1
   - Vulnerable to token leakage

2. **Authorization Code Flow (No PKCE)**
   - Traditional server-side flow
   - Requires client secret in app (security risk)
   - Vulnerable to authorization code interception
   - Not recommended for public clients

3. **Authorization Code Flow with PKCE**
   - Enhanced security for public clients
   - No client secret required in mobile apps
   - Protection against code interception
   - OAuth 2.1 recommended approach

4. **Device Authorization Flow**
   - Good for limited input devices
   - Requires user to visit separate URL
   - Poor UX for mobile/desktop apps
   - Unnecessary complexity

5. **Service Account (Machine-to-Machine)**
   - Server-side only
   - Cannot represent user identity
   - No user consent flow
   - Not applicable for client apps

---

## Decision

We adopt **OAuth 2.0 Authorization Code Flow with PKCE** (Proof Key for Code Exchange) using platform-native SDKs:

### Platform-Specific Implementations

| Platform | SDK/Library | OAuth Flow |
|----------|-------------|------------|
| iOS | `google_sign_in` + AppAuth | PKCE via ASWebAuthenticationSession |
| macOS | `AppAuth` (native) | PKCE via custom loopback server |
| Android | `google_sign_in` + AppAuth | PKCE via Chrome Custom Tabs |
| Windows | AppAuth (planned) | PKCE via loopback redirect |

### PKCE Flow Implementation

```
+--------+                                      +---------------+
|        |--(A)- Generate code_verifier ------->|               |
|        |       Generate code_challenge        |               |
|        |                                      |               |
|        |--(B)- Authorization Request -------->|               |
|        |       (code_challenge, scope)        |   Google      |
| Shadow |                                      |   OAuth 2.0   |
|  App   |<-(C)- Authorization Code ------------|   Server      |
|        |                                      |               |
|        |--(D)- Token Request ---------------->|               |
|        |       (code, code_verifier)          |               |
|        |                                      |               |
|        |<-(E)- Access Token + Refresh Token --|               |
+--------+                                      +---------------+
```

### PKCE Security Parameters

```dart
class PKCEParameters {
  /// Generate cryptographically random code verifier (43-128 chars)
  static String generateCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  /// Generate code challenge from verifier (S256 method)
  static String generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }
}

// PKCE parameters for authorization request
final codeVerifier = PKCEParameters.generateCodeVerifier();
final codeChallenge = PKCEParameters.generateCodeChallenge(codeVerifier);

// Authorization URL with PKCE
final authUrl = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
  'client_id': clientId,
  'redirect_uri': redirectUri,
  'response_type': 'code',
  'scope': 'email profile https://www.googleapis.com/auth/drive.file',
  'code_challenge': codeChallenge,
  'code_challenge_method': 'S256',
  'access_type': 'offline',
  'prompt': 'consent',
});
```

### OAuth Configuration

**Location**: `lib/core/config/google_oauth_config.dart`

```dart
class GoogleOAuthConfig {
  /// OAuth Client IDs (public, per-platform)
  static const String iosClientId = 'XXX.apps.googleusercontent.com';
  static const String macosClientId = 'XXX.apps.googleusercontent.com';
  static const String androidClientId = 'XXX.apps.googleusercontent.com';
  static const String windowsClientId = 'XXX.apps.googleusercontent.com';

  /// Redirect URIs (platform-specific)
  static String get redirectUri {
    if (Platform.isIOS) {
      return 'com.googleusercontent.apps.XXX:/oauth2redirect';
    } else if (Platform.isMacOS) {
      return 'http://127.0.0.1:8080/oauth2callback';
    } else if (Platform.isAndroid) {
      return 'com.yourcompany.shadowapp:/oauth2redirect';
    } else {
      return 'http://127.0.0.1:8080/oauth2callback';
    }
  }

  /// OAuth Scopes (minimal required)
  static const List<String> scopes = [
    'email',                                    // User email for identity
    'profile',                                  // User name for display
    'https://www.googleapis.com/auth/drive.file', // App-created files only
  ];
}
```

### iOS/macOS Implementation (Google Sign-In)

```dart
class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: GoogleOAuthConfig.scopes,
    clientId: Platform.isIOS
        ? GoogleOAuthConfig.iosClientId
        : GoogleOAuthConfig.macosClientId,
  );

  Future<GoogleSignInAuthentication?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      return await account.authentication;
    } catch (e) {
      logger.error('Google Sign-In failed', error: e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
```

### macOS Custom Implementation (AppAuth)

**Location**: `lib/data/cloud/macos_google_oauth.dart`

```dart
class MacOSGoogleOAuth {
  static const _loopbackPort = 8080;
  HttpServer? _server;
  Completer<String>? _authCodeCompleter;

  /// Start OAuth flow on macOS using loopback server
  Future<OAuthTokens> authenticate() async {
    // 1. Generate PKCE parameters
    final verifier = PKCEParameters.generateCodeVerifier();
    final challenge = PKCEParameters.generateCodeChallenge(verifier);

    // 2. Start local HTTP server for callback
    _server = await HttpServer.bind('127.0.0.1', _loopbackPort);
    _authCodeCompleter = Completer<String>();

    // 3. Handle redirect callback
    _server!.listen((request) {
      if (request.uri.path == '/oauth2callback') {
        final code = request.uri.queryParameters['code'];
        if (code != null) {
          _authCodeCompleter!.complete(code);
          request.response
            ..statusCode = 200
            ..write('Authentication successful! You can close this window.')
            ..close();
        }
      }
    });

    // 4. Open browser with authorization URL
    final authUrl = _buildAuthUrl(challenge);
    await launchUrl(authUrl, mode: LaunchMode.externalApplication);

    // 5. Wait for authorization code
    final code = await _authCodeCompleter!.future.timeout(
      Duration(minutes: 5),
      onTimeout: () => throw AuthTimeoutException(),
    );

    // 6. Exchange code for tokens (with verifier)
    final tokens = await _exchangeCodeForTokens(code, verifier);

    // 7. Cleanup
    await _server?.close();
    return tokens;
  }

  Future<OAuthTokens> _exchangeCodeForTokens(
    String code,
    String verifier,
  ) async {
    final response = await http.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      body: {
        'client_id': GoogleOAuthConfig.macosClientId,
        'code': code,
        'code_verifier': verifier,
        'grant_type': 'authorization_code',
        'redirect_uri': GoogleOAuthConfig.redirectUri,
      },
    );

    if (response.statusCode != 200) {
      throw OAuthException('Token exchange failed: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return OAuthTokens(
      accessToken: data['access_token'],
      refreshToken: data['refresh_token'],
      expiresIn: data['expires_in'],
      tokenType: data['token_type'],
    );
  }
}
```

### Token Storage

```dart
class OAuthTokenStorage {
  static const _accessTokenKey = 'google_access_token';
  static const _refreshTokenKey = 'google_refresh_token';
  static const _expiryKey = 'google_token_expiry';

  final FlutterSecureStorage _storage;

  /// Store tokens securely
  Future<void> storeTokens(OAuthTokens tokens) async {
    await _storage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _storage.write(key: _refreshTokenKey, value: tokens.refreshToken);
    await _storage.write(
      key: _expiryKey,
      value: DateTime.now()
          .add(Duration(seconds: tokens.expiresIn))
          .toIso8601String(),
    );
  }

  /// Get valid access token, refreshing if needed
  Future<String?> getValidAccessToken() async {
    final expiry = await _storage.read(key: _expiryKey);
    if (expiry == null) return null;

    final expiryDate = DateTime.parse(expiry);
    final accessToken = await _storage.read(key: _accessTokenKey);

    // Refresh 5 minutes before expiry
    if (DateTime.now().isAfter(expiryDate.subtract(Duration(minutes: 5)))) {
      return await _refreshAccessToken();
    }

    return accessToken;
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (refreshToken == null) return null;

    try {
      final response = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        body: {
          'client_id': GoogleOAuthConfig.clientId,
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
        },
      );

      if (response.statusCode != 200) {
        // Refresh token invalid, require re-authentication
        await clearTokens();
        return null;
      }

      final data = jsonDecode(response.body);
      await storeTokens(OAuthTokens.fromRefresh(data));
      return data['access_token'];
    } catch (e) {
      logger.error('Token refresh failed', error: e);
      return null;
    }
  }
}
```

### Rate Limiting Integration

```dart
class AuthProvider extends ChangeNotifier {
  final RateLimitService _rateLimitService;

  Future<bool> signIn() async {
    // Check rate limit before attempting authentication
    final rateLimitResult = await _rateLimitService.checkRateLimit(
      'oauth_signin',
    );

    if (!rateLimitResult.allowed) {
      throw RateLimitException(
        'Too many sign-in attempts. Please wait ${rateLimitResult.retryAfter} seconds.',
      );
    }

    try {
      final result = await _googleSignIn.signIn();
      if (result != null) {
        await _rateLimitService.recordSuccessfulAuth('oauth_signin');
        return true;
      }
      return false;
    } catch (e) {
      await _rateLimitService.recordFailedAttempt('oauth_signin');
      rethrow;
    }
  }
}
```

---

## Consequences

### Positive

1. **Enhanced Security**
   - PKCE prevents authorization code interception
   - No client secret in mobile app binaries
   - Tokens stored in secure platform storage

2. **OAuth 2.1 Compliance**
   - PKCE is mandatory in OAuth 2.1
   - Future-proof implementation
   - Industry best practice

3. **Minimal Scope**
   - `drive.file` scope limits access to app-created files
   - User's other Drive files are protected
   - Principle of least privilege

4. **Native Experience**
   - Platform-appropriate authentication UI
   - iOS/Android: in-app browser tabs
   - macOS: default browser
   - Consistent with platform conventions

5. **Automatic Token Refresh**
   - Seamless background token refresh
   - No user intervention required
   - 5-minute pre-expiry refresh buffer

6. **Multi-Platform Support**
   - Same OAuth flow across all platforms
   - Platform-specific redirect handling
   - Unified token storage API

### Negative

1. **Implementation Complexity**
   - PKCE adds cryptographic steps
   - Platform-specific redirect handling
   - Custom loopback server for desktop

2. **Browser Dependency**
   - Requires system browser for OAuth
   - WebView restrictions on some platforms
   - Potential UX friction

3. **Network Dependency**
   - OAuth requires internet connectivity
   - Token refresh needs network
   - Graceful offline handling required

4. **Google Dependency**
   - Tightly coupled to Google OAuth
   - Adding other providers requires work
   - Google API availability

### Mitigations

1. **For Complexity**
   - Use well-tested OAuth libraries (AppAuth, google_sign_in)
   - Centralized OAuth configuration
   - Comprehensive error handling

2. **For Browser Dependency**
   - Clear user messaging about OAuth flow
   - Fallback options for restricted environments
   - Support for in-app browser tabs where allowed

3. **For Network Dependency**
   - Queue sync operations when offline
   - Cache tokens with appropriate expiry
   - Graceful degradation to offline mode

---

## Security Considerations

### Threat Model

| Threat | Mitigation |
|--------|------------|
| Code Interception | PKCE challenge/verifier |
| Token Theft | Secure platform storage |
| Replay Attack | Short-lived access tokens, single-use auth codes |
| MITM | HTTPS enforced, certificate validation |
| Brute Force | Rate limiting (5 attempts, exponential backoff) |

### Token Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                      Token Lifecycle                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────┐    ┌──────────┐    ┌─────────────┐                │
│  │  Auth   │───>│  Access  │───>│   Refresh   │                │
│  │  Code   │    │  Token   │    │   Token     │                │
│  └─────────┘    └──────────┘    └─────────────┘                │
│      │               │                │                         │
│      │               │                │                         │
│   Single          1 Hour           90 Days                      │
│    Use           Lifetime         Lifetime                      │
│                                                                 │
│  Security:       Stored in        Stored in                     │
│  Never stored    Secure Storage   Secure Storage                │
│  PKCE protected  Auto-refresh     Used to get                   │
│                  before expiry    new access token              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Scope Justification

| Scope | Purpose | Data Accessed |
|-------|---------|---------------|
| `email` | User identification | Email address only |
| `profile` | Display name | Name, profile photo |
| `drive.file` | Sync storage | Only app-created files |

**Note**: `drive.file` scope is critical for HIPAA compliance - the app cannot access any files it did not create, protecting user privacy.

---

## Implementation Files

| File | Purpose |
|------|---------|
| `lib/core/config/google_oauth_config.dart` | OAuth configuration |
| `lib/data/cloud/macos_google_oauth.dart` | macOS PKCE implementation |
| `lib/presentation/providers/auth_provider.dart` | Authentication state |
| `lib/data/services/oauth_token_service.dart` | Token management |
| `ios/Runner/Info.plist` | iOS URL scheme for redirect |
| `macos/Runner/Info.plist` | macOS URL scheme for redirect |
| `android/app/src/main/AndroidManifest.xml` | Android intent filter |

---

## Testing

### OAuth Flow Testing

```dart
group('OAuth PKCE Flow', () {
  test('generates valid code verifier', () {
    final verifier = PKCEParameters.generateCodeVerifier();
    expect(verifier.length, greaterThanOrEqualTo(43));
    expect(verifier.length, lessThanOrEqualTo(128));
  });

  test('generates valid S256 code challenge', () {
    final verifier = 'test_verifier_123';
    final challenge = PKCEParameters.generateCodeChallenge(verifier);
    expect(challenge, isNotEmpty);
    expect(challenge, isNot(contains('=')));  // No padding
  });

  test('rate limits excessive auth attempts', () async {
    for (int i = 0; i < 5; i++) {
      await rateLimitService.recordFailedAttempt('oauth_signin');
    }
    final result = await rateLimitService.checkRateLimit('oauth_signin');
    expect(result.allowed, isFalse);
  });
});
```

---

## References

- [RFC 7636 - PKCE](https://datatracker.ietf.org/doc/html/rfc7636)
- [OAuth 2.1 Draft](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-v2-1-07)
- [Google OAuth 2.0 for Mobile](https://developers.google.com/identity/protocols/oauth2/native-app)
- [AppAuth for iOS](https://github.com/openid/AppAuth-iOS)
- [google_sign_in Package](https://pub.dev/packages/google_sign_in)

---

## Revision History

| Date | Version | Description |
|------|---------|-------------|
| 2026-01-13 | 1.0 | Initial ADR documenting OAuth PKCE flow |
