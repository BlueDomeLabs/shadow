// lib/core/config/secure_storage_keys.dart
// Secure storage key constants for OAuth tokens.
// Implements 08_OAUTH_IMPLEMENTATION.md Section 7.1
//
// Tokens are stored in separate keys (not a single JSON blob)
// to reduce blast radius if one key is compromised.

/// Centralized secure storage keys for OAuth token persistence.
///
/// Uses [FlutterSecureStorage] which maps to:
/// - iOS/macOS: Keychain
/// - Android: Keystore
///
/// Per Coding Standards Section 11.3:
/// - Separate keys for each token type
/// - Clear ALL tokens atomically on sign-out
class SecureStorageKeys {
  SecureStorageKeys._();

  /// OAuth access token (short-lived, ~1 hour).
  static const String googleDriveAccessToken = 'google_drive_access_token';

  /// OAuth refresh token (long-lived, ~90 days).
  static const String googleDriveRefreshToken = 'google_drive_refresh_token';

  /// Token expiration timestamp (ISO 8601 string).
  static const String googleDriveTokenExpiry = 'google_drive_token_expiry';

  /// Authenticated user's email address.
  static const String googleDriveUserEmail = 'google_drive_user_email';

  /// Legacy key (for migration from older versions).
  static const String googleDriveLegacyTokens = 'google_drive_macos_tokens';

  /// Anthropic API key for Claude API calls (photo scanning use cases).
  static const String anthropicApiKey = 'anthropic_api_key';
}
