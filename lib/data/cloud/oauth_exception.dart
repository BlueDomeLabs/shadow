// lib/data/cloud/oauth_exception.dart
// Data source level exceptions for OAuth operations.
// Per Coding Standards Section 4: data sources MAY throw exceptions.
// GoogleDriveProvider catches these and wraps in Result<T, AppError>.
// See 22_API_CONTRACTS.md Section 16.5 for error mapping.

/// Base exception for OAuth operations.
///
/// Thrown by [MacOSGoogleOAuth] and token exchange operations.
/// Caught by GoogleDriveProvider and mapped to [AuthError]/[NetworkError].
class OAuthException implements Exception {
  /// Human-readable error description.
  final String message;

  /// OAuth error code (e.g., 'access_denied', 'invalid_grant').
  final String? errorCode;

  /// Additional error details.
  final String? details;

  const OAuthException({required this.message, this.errorCode, this.details});

  @override
  String toString() =>
      'OAuthException: $message'
      '${errorCode != null ? ' [$errorCode]' : ''}'
      '${details != null ? ' - $details' : ''}';
}

/// OAuth state parameter mismatch - possible CSRF attack.
///
/// Thrown when the state parameter in the OAuth callback does not
/// match the state parameter sent in the authorization request.
class OAuthStateException extends OAuthException {
  /// The state value that was sent with the auth request.
  final String expectedState;

  /// The state value received in the callback.
  final String receivedState;

  const OAuthStateException({
    required super.message,
    required this.expectedState,
    required this.receivedState,
    super.errorCode = 'state_mismatch',
    super.details,
  });
}
