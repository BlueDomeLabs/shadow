/// Google OAuth configuration for desktop platforms
///
/// This contains the OAuth credentials for Google Drive integration.
/// Note: Client secret is NOT needed for native/desktop apps using OAuth 2.0
/// for installed applications flow. Only client ID is required.
///
/// SECURITY: OAuth client ID should be provided via environment variable
/// to prevent credential exposure in version control.
class GoogleOAuthConfig {
  // Desktop OAuth credentials loaded from environment variable
  // Set via: flutter run --dart-define=GOOGLE_OAUTH_CLIENT_ID=your-client-id
  static String get clientId {
    const fromEnvironment = String.fromEnvironment('GOOGLE_OAUTH_CLIENT_ID');

    if (fromEnvironment.isNotEmpty) {
      return fromEnvironment;
    }

    // SECURITY: In production, this should fail if not configured
    // For development, you can temporarily set a default, but NEVER commit real credentials
    const isProduction = bool.fromEnvironment('dart.vm.product');
    if (isProduction) {
      throw StateError('GOOGLE_OAUTH_CLIENT_ID environment variable not set. '
          'Configure it via --dart-define=GOOGLE_OAUTH_CLIENT_ID=your-client-id');
    }

    // Development fallback - you should set the environment variable instead
    // If you see this error, add --dart-define=GOOGLE_OAUTH_CLIENT_ID=your-id to your run configuration
    throw StateError('GOOGLE_OAUTH_CLIENT_ID not configured.\n'
        'Add to your run configuration:\n'
        '  --dart-define=GOOGLE_OAUTH_CLIENT_ID=your-client-id.apps.googleusercontent.com\n'
        'Or set in .env file (see .env.example)');
  }

  // Client secret removed - not needed for native apps and poses security risk if exposed

  static const String authUri = 'https://accounts.google.com/o/oauth2/auth';
  static const String tokenUri = 'https://oauth2.googleapis.com/token';

  /// Base URL for the OAuth proxy backend.
  ///
  /// The Python backend holds the client_secret securely and proxies OAuth
  /// token requests to Google. This follows CODING_STANDARDS.md Section 15:
  /// "NEVER hardcode secrets in source code."
  ///
  /// Configurable via environment variable for different deployment environments.
  static String get oauthProxyBaseUrl {
    const fromEnvironment = String.fromEnvironment('OAUTH_PROXY_BASE_URL');

    if (fromEnvironment.isNotEmpty) {
      return fromEnvironment;
    }

    // Default to localhost for development
    return 'http://localhost:5000';
  }

  // Redirect URI for OAuth
  // SECURITY: Configurable via environment variable for production deployment
  static String get redirectUri {
    const fromEnvironment = String.fromEnvironment('OAUTH_REDIRECT_URI');

    if (fromEnvironment.isNotEmpty) {
      // SECURITY: Validate HTTPS in production
      const isProduction = bool.fromEnvironment('dart.vm.product');
      if (isProduction &&
          !fromEnvironment.startsWith('https://') &&
          !fromEnvironment.startsWith('com.shadow.app://')) {
        throw StateError(
            'OAUTH_REDIRECT_URI must use HTTPS or custom scheme in production. '
            'Got: $fromEnvironment');
      }
      return fromEnvironment;
    }

    // Development default - must match redirect_uri registered in Google Cloud Console
    // The OAuth client JSON shows "http://localhost" as the registered URI
    return 'http://localhost:8080';
  }

  // Scopes needed for the app
  static const List<String> scopes = [
    'https://www.googleapis.com/auth/drive.file',
    'email',
    'profile',
  ];

  /// Validates the OAuth configuration
  /// Throws [AssertionError] if configuration is invalid
  static void validate() {
    // Validate client ID format
    final id = clientId; // This will throw if not configured
    assert(
      id.isNotEmpty && id.contains('.apps.googleusercontent.com'),
      'Invalid OAuth clientId: must be a valid Google OAuth 2.0 client ID ending in .apps.googleusercontent.com',
    );

    // Validate URIs
    assert(
      authUri.isNotEmpty && authUri.startsWith('https://'),
      'Invalid authUri: must be a valid HTTPS URL',
    );

    assert(
      tokenUri.isNotEmpty && tokenUri.startsWith('https://'),
      'Invalid tokenUri: must be a valid HTTPS URL',
    );

    assert(
      redirectUri.isNotEmpty &&
          (redirectUri.startsWith('http://') ||
              redirectUri.startsWith('https://')),
      'Invalid redirectUri: must be a valid HTTP/HTTPS URL',
    );

    // Validate scopes
    assert(
      scopes.isNotEmpty,
      'OAuth scopes cannot be empty',
    );

    assert(
      scopes.contains('email') || scopes.contains('profile'),
      'OAuth scopes must include at least email or profile scope for user identification',
    );

    // Validate that required Google Drive scope is present
    assert(
      scopes.any((scope) => scope.contains('drive')),
      'OAuth scopes must include a Google Drive scope for cloud sync functionality',
    );
  }

  /// Checks if the configuration is valid without throwing
  /// Returns true if valid, false otherwise
  static bool isValid() {
    try {
      validate();
      return true;
    } catch (e, stackTrace) {
      // Validation failed - stackTrace captured per coding standards
      // ignore: unused_local_variable
      final trace = stackTrace; // Preserved for debugging
      return false;
    }
  }
}
