// lib/data/cloud/google_drive_provider.dart
// Google Drive implementation of CloudStorageProvider.
// Implements 22_API_CONTRACTS.md Section 16.
//
// Authentication:
//   macOS: PKCE OAuth 2.0 via MacOSGoogleOAuth (loopback server)
//   iOS: google_sign_in package (native flow)
//
// All methods return Result<T, AppError> - never throws.
// OAuth exceptions are caught and mapped per Section 16.5.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:shadow_app/core/config/google_oauth_config.dart';
import 'package:shadow_app/core/config/secure_storage_keys.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/cloud/google_auth_client.dart';
import 'package:shadow_app/data/cloud/macos_google_oauth.dart';
import 'package:shadow_app/data/cloud/oauth_exception.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';

/// Google Drive implementation of [CloudStorageProvider].
///
/// Handles OAuth 2.0 authentication (PKCE on macOS, google_sign_in on iOS)
/// and file operations against the Google Drive API v3.
///
/// All methods return [Result] - never throws exceptions.
/// See 22_API_CONTRACTS.md Section 16 for the interface contract.
///
/// Folder structure per Section 16.4:
/// ```
/// shadow_app/
///   data/{entityType}/{entityId}.json   (entity envelopes)
///   files/{remotePath}                  (binary files)
/// ```
class GoogleDriveProvider implements CloudStorageProvider {
  /// Root folder for all Shadow data in Google Drive.
  static const String _dataFolder = 'shadow_app/data';

  /// Root folder for binary files (photos, etc.) in Google Drive.
  static const String _filesFolder = 'shadow_app/files';

  /// Refresh token 5 minutes before expiry to avoid mid-operation failures.
  static const Duration _tokenRefreshThreshold = Duration(minutes: 5);

  final FlutterSecureStorage _secureStorage;
  final ScopedLogger _log;

  // Google Drive API client
  drive.DriveApi? _driveApi;
  GoogleAuthClient? _authClient;

  // Mobile Google Sign-In
  GoogleSignIn? _googleSignIn;
  GoogleSignInAccount? _currentUser;

  // macOS PKCE token state
  String? _accessToken;
  String? _refreshToken;
  String? _userEmail;
  DateTime? _tokenExpiresAt;

  // Folder ID cache to avoid repeated Drive API lookups
  final Map<String, String> _folderIdCache = {};

  // Whether we've attempted to restore a previous session from storage
  bool _sessionRestoreAttempted = false;

  /// Creates a GoogleDriveProvider.
  ///
  /// [secureStorage] can be injected for testing.
  GoogleDriveProvider({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
      _log = logger.scope('GoogleDriveProvider');

  @override
  CloudProviderType get providerType => CloudProviderType.googleDrive;

  // ==========================================================================
  // Authentication
  // ==========================================================================

  @override
  Future<Result<void, AppError>> authenticate() async {
    try {
      _log.info('Starting Google Drive authentication...');

      if (Platform.isMacOS) {
        return await _authenticateMacOS();
      }
      return await _authenticateMobile();
    } on OAuthStateException catch (e, stack) {
      // Section 16.5: State mismatch → AuthError.signInFailed
      _log.error('OAuth state mismatch', e, stack);
      return Failure(AuthError.signInFailed('State mismatch', e, stack));
    } on OAuthException catch (e, stack) {
      // Section 16.5: Map OAuth errors to AuthError
      _log.error('OAuth error during sign-in', e, stack);
      if (e.errorCode == 'access_denied') {
        return Failure(AuthError.signInFailed('User cancelled', e, stack));
      }
      return Failure(AuthError.signInFailed(e.message, e, stack));
    } on TimeoutException catch (e, stack) {
      // Section 16.5: Network timeout → NetworkError.timeout
      _log.error('Timeout during sign-in', e, stack);
      return Failure(NetworkError.timeout('OAuth sign-in'));
    } on SocketException catch (e, stack) {
      _log.error('Network error during sign-in', e, stack);
      return Failure(NetworkError.noConnection());
    } on Exception catch (e, stack) {
      _log.error('Unexpected error during sign-in', e, stack);
      return Failure(AuthError.signInFailed(e.toString(), e, stack));
    }
  }

  @override
  Future<Result<void, AppError>> signOut() async {
    try {
      _log.info('Signing out...');

      // Sign out from mobile Google Sign-In if applicable
      if (_googleSignIn != null) {
        try {
          await _googleSignIn!.signOut();
        } on Exception catch (e, stack) {
          _log.error('Error during Google Sign-In signOut', e, stack);
          // Continue with cleanup even if this fails
        }
      }

      // Clear all tokens and resources
      await _clearAll();

      _log.info('Signed out successfully');
      return const Success(null);
    } on Exception catch (e, stack) {
      _log.error('Error during sign-out', e, stack);
      return Failure(AuthError.signOutFailed(e, stack));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    // Try to restore session from storage on first check
    if (!_sessionRestoreAttempted) {
      await _tryRestoreSession();
    }

    if (_driveApi == null) {
      return false;
    }

    // For macOS PKCE tokens: authenticated if we have tokens
    // (refresh happens automatically before API calls)
    if (_accessToken != null) {
      return true;
    }

    // For mobile sign-in
    return _currentUser != null;
  }

  @override
  Future<bool> isAvailable() async =>
      Platform.isMacOS || Platform.isIOS || Platform.isAndroid;

  // ==========================================================================
  // Entity Operations (Section 16.3 + 16.4)
  // ==========================================================================

  @override
  Future<Result<void, AppError>> uploadEntity(
    String entityType,
    String entityId,
    String profileId,
    String clientId,
    Map<String, dynamic> json,
    int version,
  ) async {
    try {
      await _ensureValidToken();

      // Create cloud envelope per Section 16.4
      final envelope = <String, dynamic>{
        'entityType': entityType,
        'entityId': entityId,
        'version': version,
        'deviceId': clientId,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
        'encryptedData': jsonEncode(json),
      };

      // Upload to shadow_app/data/{entityType}/{entityId}.json
      final remotePath = '$_dataFolder/$entityType/$entityId.json';
      await _uploadJsonToPath(remotePath, envelope);

      _log.info('Uploaded entity: $entityType/$entityId (v$version)');
      return const Success(null);
    } on Exception catch (e, stack) {
      _log.error('Failed to upload entity: $entityType/$entityId', e, stack);
      return Failure(SyncError.uploadFailed(entityType, entityId, e, stack));
    }
  }

  @override
  Future<Result<Map<String, dynamic>?, AppError>> downloadEntity(
    String entityType,
    String entityId,
  ) async {
    try {
      await _ensureValidToken();

      final remotePath = '$_dataFolder/$entityType/$entityId.json';
      final envelope = await _downloadJsonFromPath(remotePath);

      if (envelope == null) {
        return const Success(null);
      }

      // Unwrap envelope - extract entity data from encryptedData field
      final encryptedData = envelope['encryptedData'] as String?;
      if (encryptedData == null) {
        return Failure(
          SyncError.corruptedData(
            entityType,
            entityId,
            'Missing encryptedData in envelope',
          ),
        );
      }

      final data = jsonDecode(encryptedData) as Map<String, dynamic>;
      return Success(data);
    } on FormatException catch (e, stack) {
      _log.error('Corrupted entity data: $entityType/$entityId', e, stack);
      return Failure(
        SyncError.corruptedData(entityType, entityId, 'Invalid JSON format'),
      );
    } on Exception catch (e, stack) {
      _log.error('Failed to download entity: $entityType/$entityId', e, stack);
      return Failure(SyncError.downloadFailed(entityType, e, stack));
    }
  }

  @override
  Future<Result<List<SyncChange>, AppError>> getChangesSince(
    int sinceTimestamp,
  ) async {
    try {
      await _ensureValidToken();

      final changes = <SyncChange>[];
      final sinceTime = DateTime.fromMillisecondsSinceEpoch(
        sinceTimestamp,
      ).toUtc().toIso8601String();

      // Get data folder ID
      final dataFolderId = await _getOrCreateFolderId(_dataFolder);

      // List entity type subfolders
      final folders = await _listSubfolders(dataFolderId);

      for (final folder in folders) {
        final entityType = folder.name ?? '';
        final folderId = folder.id;
        if (entityType.isEmpty || folderId == null) {
          continue;
        }

        // List files modified since timestamp
        final query =
            "'$folderId' in parents "
            "and modifiedTime > '$sinceTime' "
            'and trashed=false';

        final fileList = await _driveApi!.files.list(
          q: query,
          spaces: 'drive',
          $fields: 'files(id, name, modifiedTime)',
        );

        for (final file in fileList.files ?? <drive.File>[]) {
          final fileId = file.id;
          if (fileId == null) continue;

          // Download and parse file content
          final content = await _downloadTextById(fileId);
          if (content == null) continue;

          final envelope = jsonDecode(content) as Map<String, dynamic>;
          final encryptedData = envelope['encryptedData'] as String?;
          if (encryptedData == null) continue;

          final data = jsonDecode(encryptedData) as Map<String, dynamic>;

          changes.add(
            SyncChange(
              entityType: entityType,
              entityId: envelope['entityId'] as String? ?? '',
              profileId: data['profileId'] as String? ?? '',
              clientId: envelope['deviceId'] as String? ?? '',
              data: data,
              version: envelope['version'] as int? ?? 0,
              timestamp: envelope['updatedAt'] as int? ?? 0,
            ),
          );
        }
      }

      _log.info('Found ${changes.length} changes since $sinceTimestamp');
      return Success(changes);
    } on Exception catch (e, stack) {
      _log.error('Failed to get changes', e, stack);
      return Failure(SyncError.downloadFailed('changes', e, stack));
    }
  }

  @override
  Future<Result<void, AppError>> deleteEntity(
    String entityType,
    String entityId,
  ) async {
    try {
      await _ensureValidToken();

      final remotePath = '$_dataFolder/$entityType/$entityId.json';
      await _deleteRemoteFile(remotePath);

      _log.info('Deleted entity: $entityType/$entityId');
      return const Success(null);
    } on Exception catch (e, stack) {
      _log.error('Failed to delete entity: $entityType/$entityId', e, stack);
      return Failure(SyncError.uploadFailed(entityType, entityId, e, stack));
    }
  }

  // ==========================================================================
  // File Operations (Section 16.3)
  // ==========================================================================

  @override
  Future<Result<void, AppError>> uploadFile(
    String localPath,
    String remotePath,
  ) async {
    try {
      await _ensureValidToken();

      final file = File(localPath);
      if (!file.existsSync()) {
        return Failure(
          SyncError.uploadFailed(
            'file',
            remotePath,
            Exception('Local file does not exist: $localPath'),
          ),
        );
      }

      final fullRemotePath = '$_filesFolder/$remotePath';
      await _uploadBinaryFile(fullRemotePath, file);

      _log.info('Uploaded file: $remotePath');
      return const Success(null);
    } on Exception catch (e, stack) {
      _log.error('Failed to upload file: $remotePath', e, stack);
      return Failure(SyncError.uploadFailed('file', remotePath, e, stack));
    }
  }

  @override
  Future<Result<String, AppError>> downloadFile(
    String remotePath,
    String localPath,
  ) async {
    try {
      await _ensureValidToken();

      final fullRemotePath = '$_filesFolder/$remotePath';
      await _downloadBinaryFile(fullRemotePath, localPath);

      _log.info('Downloaded file: $remotePath');
      return Success(localPath);
    } on Exception catch (e, stack) {
      _log.error('Failed to download file: $remotePath', e, stack);
      return Failure(SyncError.downloadFailed('file', e, stack));
    }
  }

  // ==========================================================================
  // Private: Authentication Helpers
  // ==========================================================================

  Future<Result<void, AppError>> _authenticateMacOS() async {
    _log.info('Using macOS PKCE OAuth flow...');

    final result = await MacOSGoogleOAuth.authorize();

    _accessToken = result['access_token'] as String;
    _refreshToken = result['refresh_token'] as String;

    final userInfo = result['userInfo'] as Map<String, dynamic>;
    _userEmail = userInfo['email'] as String;

    // Calculate token expiration
    if (result.containsKey('expires_in')) {
      final expiresIn = result['expires_in'] as int;
      _tokenExpiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    } else {
      _tokenExpiresAt = DateTime.now().add(const Duration(hours: 1));
    }

    _log.info('Signed in as: ${_maskEmail(_userEmail)}');

    // Store tokens securely
    await _storeTokens();

    // Initialize Drive API
    _initializeDriveApi(_accessToken!);

    _log.info('Google Drive authenticated successfully');
    return const Success(null);
  }

  Future<Result<void, AppError>> _authenticateMobile() async {
    _log.info('Using mobile Google Sign-In flow...');

    _googleSignIn ??= GoogleSignIn(scopes: GoogleOAuthConfig.scopes);

    _currentUser = await _googleSignIn!.signIn();

    if (_currentUser == null) {
      return Failure(AuthError.signInFailed('User cancelled'));
    }

    _log.info('Signed in as: ${_maskEmail(_currentUser!.email)}');

    // Initialize Drive API with mobile auth headers
    final authHeaders = await _currentUser!.authHeaders;
    _initializeDriveApiWithHeaders(authHeaders);

    _log.info('Google Drive authenticated successfully');
    return const Success(null);
  }

  // ==========================================================================
  // Private: Token Management (Section 7 + 11.3)
  // ==========================================================================

  void _initializeDriveApi(String accessToken) {
    _authClient?.close();
    _authClient = GoogleAuthClient({'Authorization': 'Bearer $accessToken'});
    _driveApi = drive.DriveApi(_authClient!);
  }

  void _initializeDriveApiWithHeaders(Map<String, String> authHeaders) {
    _authClient?.close();
    _authClient = GoogleAuthClient(authHeaders);
    _driveApi = drive.DriveApi(_authClient!);
  }

  bool _isTokenExpired() {
    if (_tokenExpiresAt == null) return true;
    return _tokenExpiresAt!.isBefore(
      DateTime.now().add(_tokenRefreshThreshold),
    );
  }

  /// Ensure we have a valid, non-expired token before making API calls.
  ///
  /// For macOS: checks token expiry and refreshes if needed.
  /// For iOS: google_sign_in handles refresh internally.
  Future<void> _ensureValidToken() async {
    if (_driveApi == null) {
      throw const OAuthException(message: 'Not authenticated');
    }

    // For macOS PKCE tokens, check and refresh
    if (_accessToken != null && _isTokenExpired()) {
      _log.info('Token expired or expiring soon, refreshing...');
      await _refreshAccessToken();
    }
  }

  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null) {
      throw const OAuthException(
        message: 'No refresh token available',
        errorCode: 'no_refresh_token',
      );
    }

    final result = await MacOSGoogleOAuth.refreshToken(_refreshToken!);
    _accessToken = result['access_token'] as String;

    if (result.containsKey('expires_in')) {
      final expiresIn = result['expires_in'] as int;
      _tokenExpiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    }

    await _storeTokens();
    _initializeDriveApi(_accessToken!);
    _log.info('Token refreshed successfully');
  }

  /// Try to restore a previous session from secure storage.
  ///
  /// Called once from [isAuthenticated] on first check.
  /// Non-fatal: if restoration fails, user just needs to sign in again.
  Future<void> _tryRestoreSession() async {
    _sessionRestoreAttempted = true;

    try {
      final results = await Future.wait([
        _secureStorage.read(key: SecureStorageKeys.googleDriveAccessToken),
        _secureStorage.read(key: SecureStorageKeys.googleDriveRefreshToken),
        _secureStorage.read(key: SecureStorageKeys.googleDriveTokenExpiry),
        _secureStorage.read(key: SecureStorageKeys.googleDriveUserEmail),
      ]);

      final accessToken = results[0];
      final refreshToken = results[1];
      final expiryString = results[2];
      final userEmail = results[3];

      if (accessToken != null && refreshToken != null && expiryString != null) {
        _accessToken = accessToken;
        _refreshToken = refreshToken;
        _tokenExpiresAt = DateTime.parse(expiryString);
        _userEmail = userEmail;

        _initializeDriveApi(accessToken);
        _log.info('Session restored for: ${_maskEmail(userEmail)}');
      }
    } on Exception catch (e, stack) {
      _log.error('Failed to restore session', e, stack);
      // Non-fatal: user will need to sign in
    }
  }

  /// Store tokens in secure storage (Keychain on macOS/iOS).
  ///
  /// Per Coding Standards Section 11.3:
  /// - Separate keys for each token type
  /// - Uses FlutterSecureStorage (platform Keychain)
  Future<void> _storeTokens() async {
    try {
      await Future.wait([
        _secureStorage.write(
          key: SecureStorageKeys.googleDriveAccessToken,
          value: _accessToken,
        ),
        _secureStorage.write(
          key: SecureStorageKeys.googleDriveRefreshToken,
          value: _refreshToken,
        ),
        _secureStorage.write(
          key: SecureStorageKeys.googleDriveTokenExpiry,
          value: _tokenExpiresAt?.toIso8601String(),
        ),
        if (_userEmail != null)
          _secureStorage.write(
            key: SecureStorageKeys.googleDriveUserEmail,
            value: _userEmail,
          ),
      ]);
      _log.debug('Tokens stored in secure storage');
    } on Exception catch (e, stack) {
      _log.warning('Failed to store tokens in secure storage', e, stack);
      // Non-fatal: session works but won't persist across app restarts
    }
  }

  /// Clear all tokens and resources.
  ///
  /// Per Coding Standards Section 11.3: clear ALL tokens atomically.
  Future<void> _clearAll() async {
    // Clear in-memory state
    _accessToken = null;
    _refreshToken = null;
    _userEmail = null;
    _tokenExpiresAt = null;
    _currentUser = null;

    // Close HTTP client
    _authClient?.close();
    _authClient = null;
    _driveApi = null;

    // Clear caches
    _folderIdCache.clear();
    _sessionRestoreAttempted = false;

    // Clear secure storage
    await Future.wait([
      _secureStorage.delete(key: SecureStorageKeys.googleDriveAccessToken),
      _secureStorage.delete(key: SecureStorageKeys.googleDriveRefreshToken),
      _secureStorage.delete(key: SecureStorageKeys.googleDriveTokenExpiry),
      _secureStorage.delete(key: SecureStorageKeys.googleDriveUserEmail),
    ]);

    _log.debug('All tokens and resources cleared');
  }

  // ==========================================================================
  // Private: PII Masking (Section 11.1)
  // ==========================================================================

  /// Mask email for safe logging per Coding Standards Section 11.1.
  ///
  /// Pattern: first2***@domain (e.g., "jo***@gmail.com")
  String _maskEmail(String? email) {
    if (email == null || email.isEmpty) return '[no email]';
    final parts = email.split('@');
    if (parts.length != 2) return '[invalid email]';
    final name = parts[0];
    final masked = name.length > 2 ? '${name.substring(0, 2)}***' : '***';
    return '$masked@${parts[1]}';
  }

  // ==========================================================================
  // Private: Google Drive File Operations
  // ==========================================================================

  /// Get or create a folder path in Google Drive, returning the folder ID.
  ///
  /// Creates intermediate folders as needed.
  /// Results are cached in [_folderIdCache].
  Future<String> _getOrCreateFolderId(String folderPath) async {
    if (_folderIdCache.containsKey(folderPath)) {
      return _folderIdCache[folderPath]!;
    }

    final parts = folderPath.split('/').where((p) => p.isNotEmpty).toList();
    var parentId = 'root';

    for (final folderName in parts) {
      final query =
          "name='$folderName' and '$parentId' in parents "
          "and mimeType='application/vnd.google-apps.folder' "
          'and trashed=false';

      final fileList = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        $fields: 'files(id, name)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        parentId = fileList.files!.first.id!;
      } else {
        // Create the folder
        final folder = drive.File()
          ..name = folderName
          ..mimeType = 'application/vnd.google-apps.folder'
          ..parents = [parentId];

        final created = await _driveApi!.files.create(folder);
        parentId = created.id!;
        _log.debug('Created folder: $folderName (ID: $parentId)');
      }
    }

    _folderIdCache[folderPath] = parentId;
    return parentId;
  }

  /// List subfolders within a parent folder.
  Future<List<drive.File>> _listSubfolders(String parentId) async {
    final query =
        "'$parentId' in parents "
        "and mimeType='application/vnd.google-apps.folder' "
        'and trashed=false';

    final fileList = await _driveApi!.files.list(
      q: query,
      spaces: 'drive',
      $fields: 'files(id, name)',
    );

    return fileList.files ?? [];
  }

  /// Find a file's Drive ID by its path.
  ///
  /// Returns null if the file does not exist.
  Future<String?> _findFileId(String remotePath) async {
    final pathParts = remotePath.split('/');
    final fileName = pathParts.last;
    final folderPath = pathParts.sublist(0, pathParts.length - 1).join('/');

    final folderId = await _getOrCreateFolderId(folderPath);

    final query =
        "name='$fileName' and '$folderId' in parents and trashed=false";

    final fileList = await _driveApi!.files.list(
      q: query,
      spaces: 'drive',
      $fields: 'files(id)',
    );

    return fileList.files?.firstOrNull?.id;
  }

  /// Upload a JSON map as a file to the given path.
  Future<void> _uploadJsonToPath(
    String remotePath,
    Map<String, dynamic> data,
  ) async {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);

    final pathParts = remotePath.split('/');
    final fileName = pathParts.last;
    final folderPath = pathParts.sublist(0, pathParts.length - 1).join('/');
    final folderId = await _getOrCreateFolderId(folderPath);

    // Delete existing file if present
    await _deleteFileByName(fileName, folderId);

    // Create and upload
    final driveFile = drive.File()
      ..name = fileName
      ..parents = [folderId];

    final media = drive.Media(Stream.value(bytes), bytes.length);

    await _driveApi!.files.create(driveFile, uploadMedia: media);
  }

  /// Download a JSON file from the given path.
  ///
  /// Returns null if the file does not exist.
  Future<Map<String, dynamic>?> _downloadJsonFromPath(String remotePath) async {
    final fileId = await _findFileId(remotePath);
    if (fileId == null) return null;

    final content = await _downloadTextById(fileId);
    if (content == null) return null;

    return jsonDecode(content) as Map<String, dynamic>;
  }

  /// Download a file's text content by its Drive ID.
  Future<String?> _downloadTextById(String fileId) async {
    final media =
        await _driveApi!.files.get(
              fileId,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;

    final chunks = <List<int>>[];
    await for (final chunk in media.stream) {
      chunks.add(chunk);
    }

    final allBytes = chunks.expand((c) => c).toList();
    return utf8.decode(allBytes);
  }

  /// Delete a file at the given remote path.
  Future<void> _deleteRemoteFile(String remotePath) async {
    final fileId = await _findFileId(remotePath);
    if (fileId != null) {
      await _driveApi!.files.delete(fileId);
    }
  }

  /// Delete file(s) by name within a folder (best-effort cleanup).
  Future<void> _deleteFileByName(String fileName, String parentId) async {
    try {
      final query =
          "name='$fileName' and '$parentId' in parents and trashed=false";

      final fileList = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        $fields: 'files(id)',
      );

      for (final file in fileList.files ?? <drive.File>[]) {
        if (file.id != null) {
          await _driveApi!.files.delete(file.id!);
        }
      }
    } on Exception catch (e) {
      // Best-effort: log but don't fail the parent operation
      _log.debug('Best-effort file deletion failed: $e');
    }
  }

  /// Upload a binary file to the given remote path.
  Future<void> _uploadBinaryFile(String remotePath, File localFile) async {
    final pathParts = remotePath.split('/');
    final fileName = pathParts.last;
    final folderPath = pathParts.sublist(0, pathParts.length - 1).join('/');
    final folderId = await _getOrCreateFolderId(folderPath);

    // Delete existing file if present
    await _deleteFileByName(fileName, folderId);

    final driveFile = drive.File()
      ..name = fileName
      ..parents = [folderId];

    final media = drive.Media(localFile.openRead(), await localFile.length());

    await _driveApi!.files.create(driveFile, uploadMedia: media);
  }

  /// Download a binary file to a local path.
  Future<void> _downloadBinaryFile(String remotePath, String localPath) async {
    final fileId = await _findFileId(remotePath);
    if (fileId == null) {
      throw Exception('File not found: $remotePath');
    }

    final media =
        await _driveApi!.files.get(
              fileId,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;

    final file = File(localPath);
    final sink = file.openWrite();

    await for (final chunk in media.stream) {
      sink.add(chunk);
    }

    await sink.close();
  }
}
