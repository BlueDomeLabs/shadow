import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/google_oauth_config.dart';
import '../../core/errors/exceptions.dart';
import '../../core/services/logger_service.dart';
import '../../core/services/oauth_proxy_service.dart';

/// Desktop OAuth flow for macOS using PKCE (Proof Key for Code Exchange)
/// This implements RFC 7636 for enhanced security without requiring client_secret
class MacOSGoogleOAuth {
  static final _log = logger.scope('MacOSGoogleOAuth');

  /// Generates a cryptographically secure code_verifier for PKCE
  /// Length: 43-128 characters, using unreserved characters [A-Z, a-z, 0-9, -, ., _, ~]
  static String _generateCodeVerifier() {
    const charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    final codeVerifier = List.generate(
      128, // Maximum recommended length
      (i) => charset[random.nextInt(charset.length)],
    ).join();
    return codeVerifier;
  }

  /// Generates code_challenge from code_verifier using SHA256
  /// Returns base64url encoded hash (without padding)
  static String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    // Base64url encode (RFC 4648 Section 5) - replace +/ with -_ and remove padding
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  /// Starts the OAuth flow and returns access token
  static Future<Map<String, dynamic>> signIn() async {
    _log.info('Starting desktop OAuth flow with PKCE...');

    // Generate PKCE parameters
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);
    _log.debug('Generated PKCE code_challenge');

    // Generate state parameter for CSRF protection
    // RFC 6749 Section 10.12: Use cryptographically secure random value to prevent CSRF attacks
    // SECURITY: Using 32 cryptographically secure random bytes (256 bits of entropy)
    final stateBytes = List.generate(32, (i) => Random.secure().nextInt(256));
    final state =
        base64Url.encode(stateBytes).replaceAll('=', ''); // Remove padding

    // Build authorization URL with PKCE parameters
    final authUrl = Uri.parse(GoogleOAuthConfig.authUri).replace(
      queryParameters: {
        'client_id': GoogleOAuthConfig.clientId,
        'redirect_uri': GoogleOAuthConfig.redirectUri,
        'response_type': 'code',
        'scope': GoogleOAuthConfig.scopes.join(' '),
        'state': state,
        'access_type': 'offline',
        'prompt': 'consent',
        // PKCE parameters (RFC 7636)
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256', // SHA256
      },
    );

    _log.info('Opening browser for authorization...');
    // Auth URL intentionally not logged - contains sensitive OAuth parameters

    // Start local server to receive callback
    // Must use 'localhost' to match the redirect_uri registered in Google Cloud Console
    final server = await HttpServer.bind('localhost', 8080);
    _log.debug('Local server started on http://localhost:8080');

    // Open browser for user authorization
    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
    } else {
      throw OAuthAuthorizationException(
        message: 'Could not launch authorization URL',
        details: 'Browser failed to open for user authorization',
      );
    }

    // Wait for callback
    _log.debug('Waiting for OAuth callback...');
    final request = await server.first;

    // Extract authorization code from callback
    final queryParams = request.uri.queryParameters;
    final code = queryParams['code'];
    final receivedState = queryParams['state'];

    // Send success response to browser
    request.response
      ..statusCode = 200
      ..headers.set('Content-Type', 'text/html; charset=utf-8')
      ..write('''
        <!DOCTYPE html>
        <html>
          <head><title>Sign In Successful</title></head>
          <body style="font-family: sans-serif; text-align: center; padding: 50px;">
            <h1>✓ Sign in successful!</h1>
            <p>You can close this window and return to the Shadow app.</p>
          </body>
        </html>
      ''');
    await request.response.close();
    await server.close();

    if (code == null) {
      throw OAuthAuthorizationException(
        message: 'No authorization code received',
        details: 'OAuth callback did not include authorization code',
        errorCode: 'missing_code',
      );
    }

    if (receivedState != state) {
      throw OAuthStateException(
        message: 'State parameter mismatch - possible CSRF attack',
        expectedState: state,
        receivedState: receivedState,
      );
    }

    _log.info(
        'Authorization code received, exchanging for tokens with PKCE...');

    // Exchange authorization code for access token via OAuth proxy
    // SECURITY: The client_secret is kept server-side in the Python backend
    // This follows CODING_STANDARDS.md Section 15: "NEVER hardcode secrets in source code"
    _log.info('Exchanging authorization code for tokens via proxy...');

    _log.debug('Token exchange: client_id=${GoogleOAuthConfig.clientId.substring(0, 20)}..., redirect_uri=${GoogleOAuthConfig.redirectUri}');

    // Use the OAuth proxy service to exchange the code
    final oauthProxyService = GetIt.instance<OAuthProxyService>();
    final tokens = await oauthProxyService.exchangeCodeForTokens(
      code: code,
      codeVerifier: codeVerifier,
      redirectUri: GoogleOAuthConfig.redirectUri,
    );

    _log.info('Tokens received successfully');

    // Get user info with timeout
    final http.Response userInfoResponse;
    try {
      userInfoResponse = await http.get(
        Uri.parse('https://www.googleapis.com/oauth2/v2/userinfo'),
        headers: {'Authorization': 'Bearer ${tokens['access_token']}'},
      ).timeout(const Duration(seconds: 30));
    } on TimeoutException {
      throw OAuthException(
        message: 'User info request timed out',
        details: 'Google user info endpoint did not respond within 30 seconds',
        errorCode: 'timeout_error',
      );
    }

    if (userInfoResponse.statusCode != 200) {
      throw OAuthException(
        message: 'Failed to get user info',
        details:
            'User info endpoint returned status ${userInfoResponse.statusCode}',
        errorCode: 'userinfo_failed',
      );
    }

    final userInfo = jsonDecode(userInfoResponse.body) as Map<String, dynamic>;
    _log.info('User info retrieved successfully');
    // Email not logged for privacy

    return {
      ...tokens,
      'userInfo': userInfo,
    };
  }
}
