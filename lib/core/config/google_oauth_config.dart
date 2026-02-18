// lib/core/config/google_oauth_config.dart
// Google OAuth 2.0 configuration for Shadow app.
// Implements 08_OAUTH_IMPLEMENTATION.md Section 4.

import 'package:shadow_app/core/services/logger_service.dart';

/// Google OAuth 2.0 configuration for Shadow app.
///
/// Loads credentials from environment variables (--dart-define or .env).
/// Validates configuration on app startup.
class GoogleOAuthConfig {
  GoogleOAuthConfig._();

  static final _log = logger.scope('GoogleOAuthConfig');

  // ============ OAuth Endpoints ============

  /// Google OAuth 2.0 authorization endpoint.
  static const String authUri = 'https://accounts.google.com/o/oauth2/auth';

  /// Google OAuth 2.0 token endpoint.
  static const String tokenUri = 'https://oauth2.googleapis.com/token';

  /// Google user info endpoint.
  static const String userInfoUri =
      'https://www.googleapis.com/oauth2/v2/userinfo';

  // ============ Client Configuration ============

  /// OAuth client ID from environment.
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
    return '656246118580-nvu5ckn9l7vst8hmj8no3t7cb10egui3'
        '.apps.googleusercontent.com';
  }

  /// OAuth client secret from environment.
  ///
  /// Set via: --dart-define=GOOGLE_OAUTH_CLIENT_SECRET=...
  /// Or: GOOGLE_OAUTH_CLIENT_SECRET in .env file
  ///
  /// Required for Google Desktop OAuth clients. Per Google's documentation,
  /// desktop client secrets are not considered truly confidential (the app
  /// binary can be decompiled), but Google still requires them in token
  /// exchange requests.
  static String get clientSecret {
    const fromEnvironment = String.fromEnvironment(
      'GOOGLE_OAUTH_CLIENT_SECRET',
    );

    if (fromEnvironment.isNotEmpty) {
      return fromEnvironment;
    }

    // In production, this is a fatal error
    const isProduction = bool.fromEnvironment('dart.vm.product');
    if (isProduction) {
      throw StateError(
        'GOOGLE_OAUTH_CLIENT_SECRET environment variable not set. '
        'Pass via --dart-define=GOOGLE_OAUTH_CLIENT_SECRET=your-secret',
      );
    }

    // Development fallback - use default client secret
    _log.warning('Using default development OAuth client secret');
    return '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';
  }

  /// OAuth redirect URI from environment.
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

  /// OAuth proxy base URL (for token exchange).
  ///
  /// Per 08_OAUTH_IMPLEMENTATION.md Section 6: the proxy holds the
  /// client_secret server-side. In development, direct exchange is used
  /// instead (Section 10), but the config still provides this value.
  static String get proxyBaseUrl {
    const fromEnvironment = String.fromEnvironment('OAUTH_PROXY_BASE_URL');

    if (fromEnvironment.isNotEmpty) {
      return fromEnvironment;
    }

    // Development default
    return 'http://localhost:5000';
  }

  // ============ Scopes ============

  /// OAuth scopes requested.
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

  /// Validates OAuth configuration on startup.
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

    // Validate client secret is present
    final secret = clientSecret;
    assert(secret.isNotEmpty, 'OAuth clientSecret cannot be empty');

    // Validate endpoints are HTTPS
    assert(authUri.startsWith('https://'), 'authUri must be HTTPS');
    assert(tokenUri.startsWith('https://'), 'tokenUri must be HTTPS');

    // Validate redirect URI format
    final redirect = redirectUri;
    assert(redirect.isNotEmpty, 'redirectUri cannot be empty');

    // Validate scopes include Drive
    assert(
      scopes.any((s) => s.contains('drive')),
      'scopes must include a Google Drive scope',
    );

    _log
      ..info('OAuth configuration valid')
      ..debug('  Client ID: ${id.substring(0, 20)}...')
      ..debug('  Client Secret: ${secret.substring(0, 8)}...')
      ..debug('  Redirect URI: $redirect')
      ..debug('  Scopes: ${scopes.join(", ")}');
  }
}
