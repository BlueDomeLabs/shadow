// lib/data/cloud/macos_google_oauth.dart
// PKCE OAuth 2.0 flow for macOS desktop.
// Implements 08_OAUTH_IMPLEMENTATION.md Sections 5 and 10.
//
// Flow:
// 1. Generate PKCE code verifier + challenge
// 2. Start local HTTP server on port 8080
// 3. Open browser for Google sign-in
// 4. Receive OAuth callback with authorization code
// 5. Exchange code for tokens (direct, per Section 10)
// 6. Fetch user info

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shadow_app/core/config/google_oauth_config.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/data/cloud/oauth_exception.dart';
import 'package:url_launcher/url_launcher.dart';

/// Handles OAuth 2.0 authorization with PKCE for macOS desktop apps.
///
/// Opens the user's browser for Google sign-in, receives the callback
/// via a local HTTP server, and exchanges the authorization code for
/// tokens using direct PKCE exchange (no proxy needed).
///
/// Throws [OAuthException] or [OAuthStateException] on failure.
/// The calling code (GoogleDriveProvider) catches these and wraps
/// in [Result<T, AppError>] per 22_API_CONTRACTS.md Section 16.5.
class MacOSGoogleOAuth {
  MacOSGoogleOAuth._();

  static final _log = logger.scope('MacOSGoogleOAuth');

  /// Timeout for waiting for OAuth callback from browser.
  static const Duration _callbackTimeout = Duration(minutes: 5);

  /// HTTP timeout for token exchange and user info requests.
  static const Duration _httpTimeout = Duration(seconds: 30);

  /// Port for the local OAuth callback server.
  static const int _callbackPort = 8080;

  /// Performs OAuth 2.0 authorization with PKCE.
  ///
  /// Opens the user's default browser for Google sign-in.
  /// Returns a map containing:
  /// - `access_token`: OAuth access token
  /// - `refresh_token`: OAuth refresh token
  /// - `expires_in`: Token lifetime in seconds
  /// - `userInfo`: Map with `email` and `name`
  ///
  /// Throws [OAuthException] on general failure.
  /// Throws [OAuthStateException] on CSRF mismatch.
  /// Throws [TimeoutException] if no callback within 5 minutes.
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
        'access_type': 'offline',
        'prompt': 'consent',
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
      },
    );

    _log
      ..info('Starting OAuth flow...')
      ..debug('Auth URL: ${authUrl.toString().substring(0, 100)}...');

    // Step 4: Start local server to receive callback
    final server = await HttpServer.bind('localhost', _callbackPort);
    _log.info('Listening for OAuth callback on localhost:$_callbackPort');

    try {
      // Step 5: Open browser for user authorization
      final launched = await launchUrl(
        authUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw const OAuthException(
          message: 'Failed to open browser for sign-in',
          errorCode: 'browser_launch_failed',
        );
      }

      // Step 6: Wait for OAuth callback (skip non-OAuth requests like favicon)
      final request = await _waitForOAuthCallback(server);
      final uri = request.uri;

      // Step 7: Validate state parameter (CSRF protection)
      final receivedState = uri.queryParameters['state'];
      if (receivedState != state) {
        await _sendErrorResponse(
          request,
          'State mismatch - possible CSRF attack',
        );
        throw OAuthStateException(
          message: 'State parameter mismatch',
          expectedState: state,
          receivedState: receivedState ?? '',
        );
      }

      // Step 8: Check for error response
      final error = uri.queryParameters['error'];
      if (error != null) {
        await _sendErrorResponse(request, error);
        throw OAuthException(
          message: 'Authorization failed',
          errorCode: error,
          details: uri.queryParameters['error_description'],
        );
      }

      // Step 9: Extract authorization code
      final code = uri.queryParameters['code'];
      if (code == null) {
        await _sendErrorResponse(request, 'No authorization code received');
        throw const OAuthException(
          message: 'No authorization code received',
          errorCode: 'no_code',
        );
      }

      // Step 10: Send success response to browser
      await _sendSuccessResponse(request);

      _log.info('Authorization code received');

      // Step 11: Exchange code for tokens (direct exchange per Section 10)
      final tokens = await _exchangeCodeForTokens(code, codeVerifier);

      // Step 12: Fetch user info
      final userInfo = await _fetchUserInfo(tokens['access_token'] as String);
      tokens['userInfo'] = userInfo;

      return tokens;
    } finally {
      await server.close();
    }
  }

  /// Refresh an access token using a refresh token.
  ///
  /// Returns map with new `access_token` and `expires_in`.
  /// Throws [OAuthException] on failure.
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    _log.info('Refreshing access token...');

    try {
      final response = await http
          .post(
            Uri.parse(GoogleOAuthConfig.tokenUri),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {
              'refresh_token': refreshToken,
              'client_id': GoogleOAuthConfig.clientId,
              'grant_type': 'refresh_token',
            },
          )
          .timeout(_httpTimeout);

      if (response.statusCode != 200) {
        final errorBody = _tryParseJson(response.body);
        throw OAuthException(
          message: 'Token refresh failed',
          errorCode: errorBody?['error'] as String? ?? 'refresh_failed',
          details: errorBody?['error_description'] as String?,
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _log.info('Token refreshed successfully');
      return data;
    } on TimeoutException {
      throw const OAuthException(
        message: 'Token refresh timed out',
        errorCode: 'timeout_error',
      );
    }
  }

  // ============ PKCE Helpers ============

  /// Generate cryptographically secure code verifier (RFC 7636).
  ///
  /// 128 characters from the unreserved character set.
  static String _generateCodeVerifier() {
    const charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(
      128,
      (i) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Generate code challenge from verifier using SHA256 (RFC 7636).
  ///
  /// code_challenge = BASE64URL(SHA256(code_verifier))
  static String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  // ============ Token Exchange ============

  /// Exchange authorization code for tokens directly with Google.
  ///
  /// Uses direct PKCE exchange per 08_OAUTH_IMPLEMENTATION.md Section 10.
  /// No proxy server needed - PKCE provides security for public clients.
  static Future<Map<String, dynamic>> _exchangeCodeForTokens(
    String code,
    String codeVerifier,
  ) async {
    _log.info('Exchanging authorization code for tokens...');

    try {
      final response = await http
          .post(
            Uri.parse(GoogleOAuthConfig.tokenUri),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {
              'code': code,
              'code_verifier': codeVerifier,
              'redirect_uri': GoogleOAuthConfig.redirectUri,
              'client_id': GoogleOAuthConfig.clientId,
              'grant_type': 'authorization_code',
            },
          )
          .timeout(_httpTimeout);

      if (response.statusCode != 200) {
        final errorBody = _tryParseJson(response.body);
        throw OAuthException(
          message: 'Token exchange failed',
          errorCode: errorBody?['error'] as String? ?? 'exchange_failed',
          details: errorBody?['error_description'] as String?,
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _log.info('Token exchange successful');
      return data;
    } on TimeoutException {
      throw const OAuthException(
        message: 'Token exchange timed out',
        errorCode: 'timeout_error',
      );
    }
  }

  // ============ User Info ============

  /// Fetch user info (email, name) using access token.
  static Future<Map<String, dynamic>> _fetchUserInfo(String accessToken) async {
    try {
      final response = await http
          .get(
            Uri.parse(GoogleOAuthConfig.userInfoUri),
            headers: {'Authorization': 'Bearer $accessToken'},
          )
          .timeout(_httpTimeout);

      if (response.statusCode != 200) {
        throw const OAuthException(
          message: 'Failed to fetch user info',
          errorCode: 'userinfo_failed',
        );
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } on TimeoutException {
      throw const OAuthException(
        message: 'User info request timed out',
        errorCode: 'timeout_error',
      );
    }
  }

  // ============ OAuth Callback Server ============

  /// Wait for the OAuth callback, ignoring non-OAuth requests (e.g. favicon).
  ///
  /// Listens on the HTTP server and returns the first request that contains
  /// OAuth parameters (code, error, or state). Non-OAuth requests get a 404.
  static Future<HttpRequest> _waitForOAuthCallback(HttpServer server) async {
    await for (final request in server.timeout(_callbackTimeout)) {
      final params = request.uri.queryParameters;
      if (params.containsKey('code') ||
          params.containsKey('error') ||
          params.containsKey('state')) {
        return request;
      }
      // Not the OAuth callback (favicon, etc.) - respond and keep listening
      request.response.statusCode = 404;
      await request.response.close();
    }

    // Stream ended without receiving OAuth callback
    throw const OAuthException(
      message: 'OAuth server closed without receiving callback',
      errorCode: 'stream_ended',
    );
  }

  // ============ HTTP Response Helpers ============

  static Future<void> _sendSuccessResponse(HttpRequest request) async {
    request.response
      ..statusCode = 200
      ..headers.contentType = ContentType.html
      ..write(
        '<!DOCTYPE html>\n'
        '<html><body style="font-family: -apple-system, sans-serif; '
        'text-align: center; padding: 50px;">\n'
        '<h1>Sign-in Successful</h1>\n'
        '<p>You can close this window and return to Shadow.</p>\n'
        '<script>setTimeout(() => window.close(), 2000);</script>\n'
        '</body></html>',
      );
    await request.response.close();
  }

  static Future<void> _sendErrorResponse(
    HttpRequest request,
    String error,
  ) async {
    request.response
      ..statusCode = 400
      ..headers.contentType = ContentType.html
      ..write(
        '<!DOCTYPE html>\n'
        '<html><body style="font-family: -apple-system, sans-serif; '
        'text-align: center; padding: 50px;">\n'
        '<h1>Sign-in Failed</h1>\n'
        '<p>Error: $error</p>\n'
        '<p>Please close this window and try again.</p>\n'
        '</body></html>',
      );
    await request.response.close();
  }

  /// Try to parse JSON, returning null on failure.
  static Map<String, dynamic>? _tryParseJson(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } on FormatException {
      return null;
    }
  }
}
