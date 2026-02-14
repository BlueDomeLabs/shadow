import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/cloud/cloud_storage_provider.dart';
import '../../core/services/logger_service.dart';
import '../../core/services/oauth_proxy_service.dart';
import '../../core/config/app_constants.dart';
import '../../core/errors/exceptions.dart';
import 'macos_google_oauth.dart';

/// Google Drive implementation of CloudStorageProvider
class GoogleDriveProvider implements CloudStorageProvider {
  final _log = logger.scope('GoogleDriveProvider');

  // OAuth Configuration
  // SECURITY: Use GoogleOAuthConfig for consistent OAuth client ID management
  // Client ID comes from environment variable via --dart-define
  // This prevents configuration drift and keeps OAuth settings centralized

  static const List<String> _scopes = [
    drive.DriveApi.driveFileScope,
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);
  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;
  _GoogleAuthClient? _authClient; // Track HTTP client for proper cleanup

  // For macOS desktop OAuth flow
  String? _macOSAccessToken;
  String? _macOSRefreshToken;
  String? _macOSUserEmail;
  DateTime? _tokenExpiresAt;

  // Secure storage for token persistence
  // SECURITY: Separate storage keys to reduce concentration risk
  // Keys are centralized in app_constants.dart for easier management
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Token refresh threshold: refresh if token expires within 5 minutes
  static const Duration _tokenRefreshThreshold = Duration(minutes: 5);

  // Rate limiting for OAuth retries to prevent rapid retry loops
  // SECURITY: Prevents DoS from retry storms and API rate limit violations
  DateTime? _lastRetryTime;
  int _retryCount = 0;
  static const Duration _retryWindow = Duration(seconds: 60);
  static const Duration _minRetryDelay = Duration(seconds: 2);
  static const int _maxRetriesPerWindow = 3;

  // Cache for folder IDs to avoid repeated lookups
  final Map<String, String> _folderIdCache = {};

  /// Mask email address for safe logging (PII protection)
  /// SECURITY: Prevents full email addresses from appearing in logs
  String _maskEmail(String? email) {
    if (email == null || email.isEmpty) return '[no email]';
    final parts = email.split('@');
    if (parts.length != 2) return '[invalid email]';
    final name = parts[0];
    final domain = parts[1];
    final maskedName = name.length > 2
        ? '${name[0]}***${name[name.length - 1]}'
        : '***';
    return '$maskedName@$domain';
  }

  /// Store OAuth tokens separately in secure storage
  /// SECURITY: Separates tokens to reduce blast radius of compromise
  Future<void> _storeTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String userEmail,
  }) async {
    await Future.wait([
      _secureStorage.write(
          key: SecureStorageKeys.googleDriveAccessToken, value: accessToken),
      _secureStorage.write(
          key: SecureStorageKeys.googleDriveRefreshToken, value: refreshToken),
      _secureStorage.write(
          key: SecureStorageKeys.googleDriveTokenExpiry,
          value: expiresAt.toIso8601String()),
      _secureStorage.write(
          key: SecureStorageKeys.googleDriveUserEmail, value: userEmail),
    ]);
    _log.debug('Tokens stored separately in secure storage');
  }

  /// Load OAuth tokens from separate secure storage locations
  /// SECURITY: Tokens retrieved from separate keys
  Future<bool> _loadTokens() async {
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

      if (accessToken != null &&
          refreshToken != null &&
          expiryString != null &&
          userEmail != null) {
        _macOSAccessToken = accessToken;
        _macOSRefreshToken = refreshToken;
        _tokenExpiresAt = DateTime.parse(expiryString);
        _macOSUserEmail = userEmail;
        _log.debug('Loaded tokens from separate storage for: ${_maskEmail(userEmail)}');
        return true;
      }

      return false;
    } on FormatException catch (e, stackTrace) {
      _log.error('Failed to parse token expiry date', e, stackTrace);
      return false;
    } on PlatformException catch (e, stackTrace) {
      _log.error('Platform error loading tokens from secure storage', e, stackTrace);
      return false;
    } catch (e, stackTrace) {
      _log.error('Unexpected error loading tokens from storage', e, stackTrace);
      return false;
    }
  }

  /// Migrate from legacy combined token storage to separate storage
  /// SECURITY: Migration ensures existing users get security improvements
  Future<void> _migrateFromLegacyStorage() async {
    try {
      final legacyTokensJson = await _secureStorage.read(
          key: SecureStorageKeys.googleDriveLegacyTokens);
      if (legacyTokensJson != null) {
        _log.info('Found legacy token storage, migrating...');
        final legacyTokens =
            jsonDecode(legacyTokensJson) as Map<String, dynamic>;

        final accessToken = legacyTokens['access_token'] as String?;
        final refreshToken = legacyTokens['refresh_token'] as String?;
        final userEmail = legacyTokens['userInfo']?['email'] as String?;
        final expiresAt = legacyTokens.containsKey('expires_at')
            ? DateTime.fromMillisecondsSinceEpoch(
                legacyTokens['expires_at'] as int)
            : DateTime.now().add(const Duration(hours: 1)); // Default fallback

        if (accessToken != null && refreshToken != null && userEmail != null) {
          await _storeTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: expiresAt,
            userEmail: userEmail,
          );

          // Delete legacy storage after successful migration
          await _secureStorage.delete(
              key: SecureStorageKeys.googleDriveLegacyTokens);
          _log.info('✅ Migration complete, legacy storage deleted');
        }
      }
    } on FormatException catch (e, stackTrace) {
      _log.error('Failed to parse legacy token data during migration', e, stackTrace);
      // Don't fail initialization if migration fails
    } on PlatformException catch (e, stackTrace) {
      _log.error('Platform error during token migration', e, stackTrace);
      // Don't fail initialization if migration fails
    } catch (e, stackTrace) {
      _log.error('Unexpected error during token migration', e, stackTrace);
      // Don't fail initialization if migration fails
    }
  }

  /// Clear all stored tokens from secure storage
  /// SECURITY: Ensures complete token cleanup on sign-out
  Future<void> _clearStoredTokens() async {
    await Future.wait([
      _secureStorage.delete(key: SecureStorageKeys.googleDriveAccessToken),
      _secureStorage.delete(key: SecureStorageKeys.googleDriveRefreshToken),
      _secureStorage.delete(key: SecureStorageKeys.googleDriveTokenExpiry),
      _secureStorage.delete(key: SecureStorageKeys.googleDriveUserEmail),
      _secureStorage.delete(
          key: SecureStorageKeys.googleDriveLegacyTokens), // Also clear legacy
    ]);
    _log.debug('All tokens cleared from secure storage');
  }

  /// Comprehensive token and resource cleanup
  /// SECURITY: Centralized cleanup ensures no tokens remain in memory
  ///
  /// This method handles:
  /// - Clearing all in-memory token variables (set to null for GC)
  /// - Closing HTTP client to prevent token leakage in active connections
  /// - Clearing DriveAPI instance
  /// - Clearing folder ID cache which may contain sensitive paths
  /// - Optionally clearing secure storage
  ///
  /// Note: While Dart strings are immutable and cannot be overwritten,
  /// setting to null allows garbage collection to reclaim memory.
  /// This minimizes the window where tokens exist in memory.
  Future<void> _clearTokensAndResources({bool clearStorage = false}) async {
    // Clear in-memory tokens immediately
    _macOSAccessToken = null;
    _macOSRefreshToken = null;
    _macOSUserEmail = null;
    _tokenExpiresAt = null;

    // Close HTTP client (may contain cached auth headers)
    _authClient?.close();
    _authClient = null;

    // Clear DriveAPI instance
    _driveApi = null;

    // Clear folder cache (may contain sensitive folder IDs/paths)
    _folderIdCache.clear();

    // Clear secure storage if requested
    if (clearStorage) {
      await _clearStoredTokens();
      _log.debug('Tokens cleared from both memory and secure storage');
    } else {
      _log.debug('Tokens cleared from memory');
    }
  }

  @override
  Future<void> initialize() async {
    // For macOS, try to load stored tokens
    if (Platform.isMacOS) {
      try {
        _log.debug('Checking for stored tokens...');

        // First, try migration from legacy storage
        await _migrateFromLegacyStorage();

        // Load tokens from separate storage
        final tokensLoaded = await _loadTokens();

        if (tokensLoaded && _macOSAccessToken != null) {
          _log.info('Found stored tokens for: ${_maskEmail(_macOSUserEmail)}');
          _log.debug('Token expires at: $_tokenExpiresAt');

          await _initializeDriveApiWithTokens(_macOSAccessToken!);
          _log.info('Successfully restored session');
        } else {
          _log.debug('No stored tokens found');
        }
      } on IOException catch (e, stackTrace) {
        _log.error('I/O error loading stored tokens', e, stackTrace);
        // Clear invalid tokens from memory and storage
        await _clearTokensAndResources(clearStorage: true);
      } on PlatformException catch (e, stackTrace) {
        _log.error('Platform error loading stored tokens', e, stackTrace);
        // Clear invalid tokens from memory and storage
        await _clearTokensAndResources(clearStorage: true);
      } catch (e, stackTrace) {
        _log.error('Unexpected error loading stored tokens', e, stackTrace);
        // Clear invalid tokens from memory and storage
        await _clearTokensAndResources(clearStorage: true);
      }
      return;
    }

    // For mobile platforms, check for stored tokens first (from QR pairing)
    try {
      // First, try migration from legacy storage
      await _migrateFromLegacyStorage();

      // Load tokens from separate storage
      final tokensLoaded = await _loadTokens();

      if (tokensLoaded && _macOSAccessToken != null) {
        _log.info('iOS: Found stored tokens for: ${_maskEmail(_macOSUserEmail)}');
        _log.debug('Token expires at: $_tokenExpiresAt');

        await _initializeDriveApiWithTokens(_macOSAccessToken!);
        _log.info('iOS: Successfully restored session from QR pairing');
        return;
      }

      // Fallback: Try silent sign-in with google_sign_in package
      _currentUser = await _googleSignIn.signInSilently();
      if (_currentUser != null) {
        await _initializeDriveApi();
      }
    } on IOException catch (e, stackTrace) {
      _log.error('iOS: I/O error during initialization', e, stackTrace);
      // Silent sign-in failed, user needs to sign in explicitly
    } on PlatformException catch (e, stackTrace) {
      _log.error('iOS: Platform error during initialization', e, stackTrace);
      // Silent sign-in failed, user needs to sign in explicitly
    } catch (e, stackTrace) {
      _log.error('iOS: Unexpected error during initialization', e, stackTrace);
      // Silent sign-in failed, user needs to sign in explicitly
    }
  }

  Future<void> _initializeDriveApi() async {
    if (_currentUser == null) return;

    // Close old client before creating new one
    _authClient?.close();

    final authHeaders = await _currentUser!.authHeaders;
    _authClient = _GoogleAuthClient(authHeaders);
    _driveApi = drive.DriveApi(_authClient!);
  }

  /// Initialize Drive API with macOS OAuth tokens
  Future<void> _initializeDriveApiWithTokens(String accessToken) async {
    // Close old client before creating new one
    _authClient?.close();

    final authHeaders = {'Authorization': 'Bearer $accessToken'};
    _authClient = _GoogleAuthClient(authHeaders);
    _driveApi = drive.DriveApi(_authClient!);
  }

  @override
  Future<bool> isAuthenticated() async {
    if (Platform.isMacOS) {
      // Check token exists, API is initialized, AND token is not expired
      if (_macOSAccessToken == null || _driveApi == null) {
        return false;
      }
      // If token is expired, we're not really authenticated
      return !_isTokenExpired();
    }
    // On iOS, check both traditional sign-in and QR pairing tokens
    if ((_currentUser != null || _macOSAccessToken != null) &&
        _driveApi != null) {
      // If using macOS tokens on iOS (QR pairing), also check expiration
      if (_macOSAccessToken != null && _currentUser == null) {
        return !_isTokenExpired();
      }
      return true;
    }
    return false;
  }

  @override
  Future<void> signIn() async {
    try {
      _log.info('Starting Google Sign-In...');
      _log.debug('Current platform: ${Platform.operatingSystem}');

      // Use custom OAuth flow for macOS (supports client secret)
      if (Platform.isMacOS) {
        _log.info('Using macOS desktop OAuth flow with client secret...');
        final result = await MacOSGoogleOAuth.signIn();

        _macOSAccessToken = result['access_token'] as String;
        _macOSRefreshToken = result['refresh_token'] as String;
        _macOSUserEmail = result['userInfo']['email'] as String;

        _log.info('Signed in as: ${_maskEmail(_macOSUserEmail)}');

        // Calculate token expiration time
        if (result.containsKey('expires_in')) {
          final expiresIn = result['expires_in'] as int; // seconds
          _tokenExpiresAt = DateTime.now().add(Duration(seconds: expiresIn));
          _log.debug('Token expires at: $_tokenExpiresAt');
        } else {
          _tokenExpiresAt = DateTime.now().add(const Duration(hours: 1));
        }

        // Save tokens to separate secure storage locations (security improvement)
        try {
          await _storeTokens(
            accessToken: _macOSAccessToken!,
            refreshToken: _macOSRefreshToken!,
            expiresAt: _tokenExpiresAt!,
            userEmail: _macOSUserEmail!,
          );
          _log.info('✅ Tokens saved to separate secure storage');
        } catch (e, stackTrace) {
          _log.warning('Failed to save tokens', e, stackTrace);
        }

        // Initialize Drive API with macOS tokens
        await _initializeDriveApiWithTokens(_macOSAccessToken!);
        _log.info('✅ Drive API initialized successfully');
        return;
      }

      // Use google_sign_in for iOS/mobile platforms
      _log.info('Using mobile Google Sign-In flow...');
      _log.debug('Scopes requested: $_scopes');

      _currentUser = await _googleSignIn.signIn();

      _log.debug('Sign-in returned: ${_currentUser != null}');
      if (_currentUser != null) {
        _log.info('Signed in as: ${_maskEmail(_currentUser!.email)}');
      } else {
        _log.warning(
            'Sign-in returned null - user cancelled or error occurred');
      }

      if (_currentUser == null) {
        throw CloudStorageException('Google Sign-In was cancelled');
      }

      _log.debug('Initializing Drive API...');
      await _initializeDriveApi();
      _log.info('✅ Drive API initialized successfully');
    } catch (e, stackTrace) {
      _log.error('❌ Sign-in error', e, stackTrace);

      // Check if it's a configuration error
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('gidclientid') ||
          errorString.contains('info.plist') ||
          errorString.contains('nsinvalidargumentexception')) {
        throw CloudStorageException(
          'Google Drive is not configured. Please set up OAuth credentials in macos/Runner/Info.plist. '
          'See GOOGLE_DRIVE_SETUP.md for instructions.',
        );
      }
      throw CloudStorageException(
          'Failed to sign in to Google Drive: ${e.toString()}');
    }
  }

  /// Refresh the macOS OAuth access token using refresh token
  /// SECURITY: Uses OAuth proxy to keep client_secret server-side
  /// per CODING_STANDARDS.md Section 15
  Future<void> _refreshMacOSToken() async {
    if (_macOSRefreshToken == null) {
      throw CloudStorageException('No refresh token available');
    }

    _log.info('Refreshing access token via proxy...');

    // Use the OAuth proxy service to refresh the token
    // SECURITY: The client_secret is kept server-side in the Python backend
    final oauthProxyService = GetIt.instance<OAuthProxyService>();
    final newTokens = await oauthProxyService.refreshToken(
      refreshToken: _macOSRefreshToken!,
    );

    _log.info('✓ Token refreshed successfully');

    // Update access token (refresh token stays the same)
    _macOSAccessToken = newTokens['access_token'] as String;

    // Calculate token expiration time
    final expiresIn = newTokens['expires_in'] as int; // seconds
    _tokenExpiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    _log.debug('Token expires at: $_tokenExpiresAt');

    // Save updated tokens to separate secure storage (security improvement)
    await _storeTokens(
      accessToken: _macOSAccessToken!,
      refreshToken: _macOSRefreshToken!,
      expiresAt: _tokenExpiresAt!,
      userEmail: _macOSUserEmail!,
    );
    _log.debug('Updated tokens saved to separate secure storage');

    // Re-initialize Drive API with new access token
    await _initializeDriveApiWithTokens(_macOSAccessToken!);
    _log.debug('✓ Drive API re-initialized with new token');
  }

  /// Check if the current token is expired or about to expire
  bool _isTokenExpired() {
    if (_tokenExpiresAt == null) {
      return true; // Treat unknown expiration as expired
    }

    // Consider token expired if it expires within the threshold
    final expiresWithinThreshold = _tokenExpiresAt!.isBefore(
      DateTime.now().add(_tokenRefreshThreshold),
    );

    return expiresWithinThreshold;
  }

  /// Ensure the OAuth token is valid, refreshing if necessary
  Future<void> _ensureValidToken() async {
    // If using macOS tokens (either on macOS or iOS via QR pairing), check and refresh
    if (_macOSAccessToken != null) {
      if (_isTokenExpired()) {
        _log.info('Token expired or expiring soon, refreshing proactively...');
        await _refreshMacOSToken();
      }
      return;
    }

    // If using traditional mobile sign-in, the google_sign_in package handles refresh
    if (!Platform.isMacOS && _currentUser != null) {
      return;
    }

    // No valid authentication method found
    throw CloudStorageException('Not authenticated');
  }

  /// Check if retry is allowed based on rate limiting
  /// SECURITY: Prevents rapid retry loops that could cause DoS or API rate limiting
  /// RFC 6749 Section 4.1.4: Clients should implement rate limiting for token refresh
  Future<void> _checkRetryRateLimit() async {
    final now = DateTime.now();

    // Reset retry counter if we're outside the retry window
    if (_lastRetryTime != null &&
        now.difference(_lastRetryTime!) > _retryWindow) {
      _retryCount = 0;
      _lastRetryTime = null;
      _log.debug('Rate limit window expired, reset retry counter');
    }

    // Check if we've exceeded max retries in the current window
    if (_retryCount >= _maxRetriesPerWindow) {
      _log.error(
          'OAuth retry rate limit exceeded: $_retryCount retries in ${_retryWindow.inSeconds}s');
      throw OAuthRateLimitException(
        message: 'Too many authentication retry attempts',
        retryCount: _retryCount,
        retryWindow: _retryWindow,
        details:
            'Please wait ${_retryWindow.inSeconds} seconds before trying again',
      );
    }

    // Enforce minimum delay between retries
    if (_lastRetryTime != null) {
      final timeSinceLastRetry = now.difference(_lastRetryTime!);
      if (timeSinceLastRetry < _minRetryDelay) {
        final remainingDelay = _minRetryDelay - timeSinceLastRetry;
        _log.debug(
            'Rate limiting: waiting ${remainingDelay.inMilliseconds}ms before retry');
        // Sleep to enforce minimum delay
        await Future.delayed(remainingDelay);
      }
    }

    // Update retry tracking
    _retryCount++;
    _lastRetryTime = now;
    _log.debug('OAuth retry attempt $_retryCount/$_maxRetriesPerWindow');
  }

  /// Wrapper to execute API calls with automatic 401 handling and retry
  /// SECURITY: Includes rate limiting to prevent rapid retry loops
  Future<T> _executeWithRetry<T>(Future<T> Function() apiCall,
      {String operationName = 'API call'}) async {
    try {
      return await apiCall();
    } catch (e, stackTrace) {
      // Check if it's a 401 Unauthorized error
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('401') || errorString.contains('unauthorized')) {
        _log.warning('401 error detected, attempting token refresh', e, stackTrace);
        _log.warning(
            '401 error detected during $operationName, refreshing token and retrying...');

        // SECURITY: Check rate limit before attempting retry
        await _checkRetryRateLimit();

        // Force token refresh
        if (_macOSAccessToken != null) {
          await _refreshMacOSToken();
        } else if (_currentUser != null) {
          // For mobile, try to get fresh auth headers
          await _initializeDriveApi();
        } else {
          throw CloudStorageException(
              'Cannot refresh token: not authenticated');
        }

        // Retry the API call once
        try {
          _log.debug('Retrying $operationName after token refresh...');
          return await apiCall();
        } catch (retryError, retryStackTrace) {
          _log.error('Retry failed for $operationName', retryError, retryStackTrace);
          throw CloudStorageException(
              '$operationName failed after token refresh', retryError);
        }
      }

      // If not a 401 error, rethrow
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    _log.info('Signing out and clearing all tokens...');

    // Clear google_sign_in session for mobile platforms
    if (!Platform.isMacOS) {
      try {
        await _googleSignIn.signOut();
      } catch (e, stackTrace) {
        _log.error('Error during Google Sign-In signOut', e, stackTrace);
        // Continue with cleanup even if this fails
      }
      _currentUser = null;
    }

    // Comprehensive cleanup: clear memory, close connections, and clear storage
    await _clearTokensAndResources(clearStorage: true);

    _log.info('✅ Sign-out complete - all tokens and resources cleared');
  }

  @override
  Future<String?> getCurrentUserIdentifier() async {
    if (Platform.isMacOS) {
      return _macOSUserEmail;
    }
    return _currentUser?.email;
  }

  /// Get or create a folder in Google Drive
  Future<String> _getOrCreateFolder(String folderPath) async {
    if (_driveApi == null) {
      throw CloudStorageException('Not authenticated');
    }

    // Ensure token is valid before making API calls
    await _ensureValidToken();

    _log.debug('_getOrCreateFolder: $folderPath');

    // Check cache first
    if (_folderIdCache.containsKey(folderPath)) {
      final cachedId = _folderIdCache[folderPath]!;
      _log.debug('Using cached folder ID: $cachedId for path: $folderPath');
      return cachedId;
    }

    // Split path into components
    final parts = folderPath.split('/').where((p) => p.isNotEmpty).toList();
    String? parentId = 'root';

    for (final folderName in parts) {
      // Search for folder
      final query = "name='$folderName' and '$parentId' in parents and "
          "mimeType='application/vnd.google-apps.folder' and trashed=false";

      _log.debug('Searching for folder "$folderName" under parent: $parentId');

      final fileList = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        $fields: 'files(id, name)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        parentId = fileList.files!.first.id;
        _log.debug('Found existing folder: $folderName (ID: $parentId)');
        if (fileList.files!.length > 1) {
          _log.warning(
              'Multiple folders with name "$folderName" found! Using first one.');
          _log.debug(
              'All folder IDs: ${fileList.files!.map((f) => f.id).join(", ")}');
        }
      } else {
        // Create folder
        final folder = drive.File()
          ..name = folderName
          ..mimeType = 'application/vnd.google-apps.folder'
          ..parents = [parentId!];

        final created = await _driveApi!.files.create(folder);
        parentId = created.id;
        _log.debug('Created new folder: $folderName (ID: $parentId)');
      }
    }

    _folderIdCache[folderPath] = parentId!;
    _log.debug('Final folder ID for "$folderPath": $parentId');
    return parentId;
  }

  @override
  Future<String> uploadFile({
    required String localPath,
    required String remotePath,
    void Function(double progress)? onProgress,
  }) async {
    if (_driveApi == null) {
      throw CloudStorageException('Not authenticated');
    }

    // Ensure token is valid before making API calls
    await _ensureValidToken();

    try {
      final file = File(localPath);
      if (!await file.exists()) {
        throw CloudStorageException('Local file does not exist: $localPath');
      }

      // Extract folder path and file name
      final pathParts = remotePath.split('/');
      final fileName = pathParts.last;
      final folderPath = pathParts.length > 1
          ? pathParts.sublist(0, pathParts.length - 1).join('/')
          : '';

      // Get or create parent folder
      final folderId =
          folderPath.isNotEmpty ? await _getOrCreateFolder(folderPath) : 'root';

      // Check if file already exists and delete it
      await _deleteFileByName(fileName, folderId);

      // Create file metadata
      final driveFile = drive.File()
        ..name = fileName
        ..parents = [folderId];

      // Upload file
      final media = drive.Media(file.openRead(), await file.length());
      final uploadedFile = await _driveApi!.files.create(
        driveFile,
        uploadMedia: media,
      );

      return uploadedFile.id ?? remotePath;
    } catch (e, stackTrace) {
      _log.error('Failed to upload file', e, stackTrace);
      throw CloudStorageException('Failed to upload file', e);
    }
  }

  Future<void> _deleteFileByName(String fileName, String parentId) async {
    try {
      final query =
          "name='$fileName' and '$parentId' in parents and trashed=false";
      final fileList = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        $fields: 'files(id)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        for (final file in fileList.files!) {
          final fileId = file.id;
          if (fileId == null) {
            _log.warning('Skipping file deletion: file ID is null for file "${file.name}"');
            continue;
          }
          await _driveApi!.files.delete(fileId);
        }
      }
    } catch (e, stackTrace) {
      // Log but ignore errors when deleting old file - this is best-effort cleanup
      _log.debug('Best-effort deletion of old file failed (non-critical)', e, stackTrace);
    }
  }

  @override
  Future<String> downloadFile({
    required String remotePath,
    required String localPath,
    void Function(double progress)? onProgress,
  }) async {
    if (_driveApi == null) {
      throw CloudStorageException('Not authenticated');
    }

    // Ensure token is valid before making API calls
    await _ensureValidToken();

    try {
      final fileId = await _getFileId(remotePath);
      if (fileId == null) {
        throw CloudStorageException('File not found: $remotePath');
      }

      final media = await _driveApi!.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final file = File(localPath);
      final sink = file.openWrite();

      await for (final chunk in media.stream) {
        sink.add(chunk);
      }

      await sink.close();
      return localPath;
    } catch (e, stackTrace) {
      _log.error('Failed to download file', e, stackTrace);
      throw CloudStorageException('Failed to download file', e);
    }
  }

  Future<String?> _getFileId(String remotePath) async {
    final pathParts = remotePath.split('/');
    final fileName = pathParts.last;
    final folderPath = pathParts.length > 1
        ? pathParts.sublist(0, pathParts.length - 1).join('/')
        : '';

    final folderId =
        folderPath.isNotEmpty ? await _getOrCreateFolder(folderPath) : 'root';

    final query =
        "name='$fileName' and '$folderId' in parents and trashed=false";
    final fileList = await _driveApi!.files.list(
      q: query,
      spaces: 'drive',
      $fields: 'files(id)',
    );

    return fileList.files?.firstOrNull?.id;
  }

  @override
  Future<void> deleteFile(String remotePath) async {
    if (_driveApi == null) {
      throw CloudStorageException('Not authenticated');
    }

    // Ensure token is valid before making API calls
    await _ensureValidToken();

    try {
      final fileId = await _getFileId(remotePath);
      if (fileId != null) {
        await _driveApi!.files.delete(fileId);
      }
    } catch (e, stackTrace) {
      _log.error('Failed to delete file', e, stackTrace);
      throw CloudStorageException('Failed to delete file', e);
    }
  }

  @override
  Future<bool> fileExists(String remotePath) async {
    if (_driveApi == null) {
      return false;
    }

    try {
      final fileId = await _getFileId(remotePath);
      return fileId != null;
    } catch (e, stackTrace) {
      _log.debug('Error checking file existence', e, stackTrace);
      return false;
    }
  }

  @override
  Future<List<CloudFile>> listFiles(String folderPath) async {
    if (_driveApi == null) {
      throw CloudStorageException('Not authenticated');
    }

    // Ensure token is valid before making API calls
    await _ensureValidToken();

    try {
      _log.debug('listFiles: $folderPath');
      final folderId = await _getOrCreateFolder(folderPath);
      final query = "'$folderId' in parents and trashed=false";

      _log.debug('Querying Drive for files in folder ID: $folderId');
      final fileList = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        $fields: 'files(id, name, size, modifiedTime, mimeType)',
      );

      final fileCount = fileList.files?.length ?? 0;
      _log.debug('Found $fileCount files in folder "$folderPath"');
      if (fileCount > 0) {
        _log.debug('Files: ${fileList.files!.map((f) => f.name).join(", ")}');
      }

      return fileList.files?.map((file) {
            return CloudFile(
              name: file.name ?? '',
              path: '$folderPath/${file.name}',
              sizeBytes: file.size != null ? int.tryParse(file.size!) : null,
              modifiedTime: file.modifiedTime,
              isFolder: file.mimeType == 'application/vnd.google-apps.folder',
            );
          }).toList() ??
          [];
    } catch (e, stackTrace) {
      _log.error('Error listing files in "$folderPath"', e, stackTrace);
      throw CloudStorageException('Failed to list files', e);
    }
  }

  @override
  Future<String> uploadJson({
    required String remotePath,
    required Map<String, dynamic> data,
  }) async {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);

    return uploadBytes(
      bytes: Uint8List.fromList(bytes),
      remotePath: remotePath,
      mimeType: 'application/json',
    );
  }

  @override
  Future<Map<String, dynamic>> downloadJson(String remotePath) async {
    final bytes = await downloadBytes(remotePath);
    final jsonString = utf8.decode(bytes);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  @override
  Future<void> deleteJson(String remotePath) async {
    await deleteFile(remotePath);
  }

  @override
  Future<int?> getAvailableSpace() async {
    if (_driveApi == null) {
      return null;
    }

    // Ensure token is valid before making API calls
    await _ensureValidToken();

    try {
      final about = await _driveApi!.about.get($fields: 'storageQuota');
      final quota = about.storageQuota;
      final limitString = quota?.limit;
      final usageString = quota?.usage;
      if (limitString != null && usageString != null) {
        final limit = int.tryParse(limitString);
        final usage = int.tryParse(usageString);
        if (limit != null && usage != null) {
          return limit - usage;
        }
      }
      return null;
    } catch (e, stackTrace) {
      _log.debug('Error getting available space', e, stackTrace);
      return null;
    }
  }

  @override
  Future<String> uploadBytes({
    required Uint8List bytes,
    required String remotePath,
    String? mimeType,
  }) async {
    if (_driveApi == null) {
      throw CloudStorageException('Not authenticated');
    }

    // Proactively ensure token is valid before making API call
    await _ensureValidToken();

    return _executeWithRetry(() async {
      try {
        _log.debug('uploadBytes: $remotePath');
        final pathParts = remotePath.split('/');
        final fileName = pathParts.last;
        final folderPath = pathParts.length > 1
            ? pathParts.sublist(0, pathParts.length - 1).join('/')
            : '';

        final folderId = folderPath.isNotEmpty
            ? await _getOrCreateFolder(folderPath)
            : 'root';

        _log.debug(
            'Uploading "$fileName" to folder ID: $folderId (path: $folderPath)');

        // Delete existing file
        await _deleteFileByName(fileName, folderId);

        // Create file metadata
        final driveFile = drive.File()
          ..name = fileName
          ..parents = [folderId];

        // Upload bytes
        final media = drive.Media(Stream.value(bytes.toList()), bytes.length);
        final uploadedFile = await _driveApi!.files.create(
          driveFile,
          uploadMedia: media,
        );

        _log.debug('Upload successful: ${uploadedFile.id}');
        return uploadedFile.id ?? remotePath;
      } catch (e, stackTrace) {
        _log.error('Upload failed', e, stackTrace);
        throw CloudStorageException('Failed to upload bytes', e);
      }
    }, operationName: 'uploadBytes');
  }

  @override
  Future<Uint8List> downloadBytes(String remotePath) async {
    if (_driveApi == null) {
      throw CloudStorageException('Not authenticated');
    }

    // Proactively ensure token is valid before making API call
    await _ensureValidToken();

    return _executeWithRetry(() async {
      try {
        final fileId = await _getFileId(remotePath);
        if (fileId == null) {
          throw CloudStorageException('File not found: $remotePath');
        }

        final media = await _driveApi!.files.get(
          fileId,
          downloadOptions: drive.DownloadOptions.fullMedia,
        ) as drive.Media;

        final chunks = <List<int>>[];
        await for (final chunk in media.stream) {
          chunks.add(chunk);
        }

        final allBytes = chunks.expand((chunk) => chunk).toList();
        return Uint8List.fromList(allBytes);
      } catch (e, stackTrace) {
        _log.error('Download bytes failed', e, stackTrace);
        throw CloudStorageException('Failed to download bytes', e);
      }
    }, operationName: 'downloadBytes');
  }

  /// Dispose resources and clear sensitive data
  /// SECURITY: Called when provider is no longer needed to ensure cleanup
  ///
  /// This clears tokens from memory but NOT from secure storage,
  /// allowing the user to restore their session later.
  /// For complete sign-out, use signOut() instead.
  Future<void> dispose() async {
    _log.debug('Disposing GoogleDriveProvider...');

    // Clear tokens from memory but keep in secure storage for session restore
    await _clearTokensAndResources(clearStorage: false);

    // Clear google_sign_in state
    _currentUser = null;

    _log.debug('✅ GoogleDriveProvider disposed - resources cleared');
  }
}

/// HTTP client that adds authentication headers
class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

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
