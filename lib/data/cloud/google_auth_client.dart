// lib/data/cloud/google_auth_client.dart
// Authenticated HTTP client for Google Drive API calls.
// Adds OAuth Bearer token headers to all requests.

import 'package:http/http.dart' as http;

/// HTTP client that adds authentication headers to all requests.
///
/// Used by [GoogleDriveProvider] to make authenticated Google Drive
/// API calls. Wraps an inner [http.Client] and injects auth headers.
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  /// Creates an authenticated client with the given headers.
  ///
  /// Typically called with `{'Authorization': 'Bearer <access_token>'}`.
  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}
