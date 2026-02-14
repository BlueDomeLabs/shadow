import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/logger_service.dart';

/// Manages OAuth credentials securely using Flutter Secure Storage
///
/// This service stores sensitive OAuth credentials (like client_secret)
/// in platform-native secure storage (Keychain on macOS/iOS).
///
/// IMPORTANT: Client secret should NEVER be hardcoded or committed to git.
/// For production, inject via environment variables or secure config system.
class OAuthCredentialsService {
  static final _log = logger.scope('OAuthCredentialsService');
  static const _storage = FlutterSecureStorage();

  // Storage keys
  static const _clientSecretKey = 'google_oauth_client_secret';
  static const _isInitializedKey = 'oauth_credentials_initialized';

  /// Initialize OAuth credentials on first run
  ///
  /// RFC 8252: Native apps use PKCE and treat client as "public client".
  /// Client secret is OPTIONAL for native/desktop apps with PKCE.
  ///
  /// If clientSecret is provided, it's stored securely in platform Keychain.
  /// If null, the app operates as a public client using PKCE for security.
  ///
  /// NEVER hardcode secrets in source files - pass via environment variable.
  static Future<void> initialize({String? clientSecret}) async {
    try {
      // Check if already initialized
      final initialized = await _storage.read(key: _isInitializedKey);
      if (initialized == 'true') {
        _log.debug('OAuth credentials already initialized');
        return;
      }

      // Store client secret securely (if provided)
      // For native apps with PKCE, client secret is optional
      if (clientSecret != null && clientSecret.isNotEmpty) {
        await _storage.write(key: _clientSecretKey, value: clientSecret);
        _log.info('OAuth credentials initialized securely with client secret');
      } else {
        _log.info(
            'OAuth initialized as public client (PKCE only, no client secret)');
      }

      await _storage.write(key: _isInitializedKey, value: 'true');
    } catch (e, stackTrace) {
      _log.error('Failed to initialize OAuth credentials', e, stackTrace);
      rethrow;
    }
  }

  /// Retrieve the client secret from secure storage
  ///
  /// Returns null if not initialized or if storage fails.
  static Future<String?> getClientSecret() async {
    try {
      final secret = await _storage.read(key: _clientSecretKey);
      if (secret == null) {
        _log.warning('Client secret not found in secure storage');
      }
      return secret;
    } catch (e, stackTrace) {
      _log.error('Failed to retrieve client secret', e, stackTrace);
      return null;
    }
  }

  /// Check if credentials have been initialized
  static Future<bool> isInitialized() async {
    try {
      final initialized = await _storage.read(key: _isInitializedKey);
      return initialized == 'true';
    } catch (e, stackTrace) {
      _log.error('Failed to check initialization status', e, stackTrace);
      return false;
    }
  }

  /// Clear all stored credentials (for testing or re-initialization)
  static Future<void> clearCredentials() async {
    try {
      await _storage.delete(key: _clientSecretKey);
      await _storage.delete(key: _isInitializedKey);
      _log.info('OAuth credentials cleared');
    } catch (e, stackTrace) {
      _log.error('Failed to clear credentials', e, stackTrace);
      rethrow;
    }
  }

  /// Update the client secret
  ///
  /// Use this if the secret needs to be rotated or updated.
  static Future<void> updateClientSecret(String newSecret) async {
    try {
      await _storage.write(key: _clientSecretKey, value: newSecret);
      _log.info('Client secret updated');
    } catch (e, stackTrace) {
      _log.error('Failed to update client secret', e, stackTrace);
      rethrow;
    }
  }
}
