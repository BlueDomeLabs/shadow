# Shadow API Contracts

**Version:** 1.0
**Last Updated:** February 9, 2026
**Purpose:** Exact interface definitions that ALL implementations MUST follow

---

## Overview

This document defines the exact method signatures, return types, and error contracts for all interfaces. Engineers MUST implement these exactly as specified. Any deviation requires an Architecture Decision Record (ADR) and team lead approval.

---

## 1. Result Type Contract

ALL repository and use case methods returning data MUST use the Result type. No exceptions.

```dart
// lib/core/types/result.dart - EXACT IMPLEMENTATION REQUIRED

sealed class Result<T, E> {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T? get valueOrNull => isSuccess ? (this as Success<T, E>).value : null;
  E? get errorOrNull => isFailure ? (this as Failure<T, E>).error : null;

  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  }) {
    if (this is Success<T, E>) {
      return success((this as Success<T, E>).value);
    } else {
      return failure((this as Failure<T, E>).error);
    }
  }
}

final class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

final class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}
```

---

## 2. Error Type Contracts

### 2.1 AppError Base

```dart
// lib/core/errors/app_error.dart - EXACT IMPLEMENTATION REQUIRED

/// Actions that can be taken to recover from an error
enum RecoveryAction {
  /// No recovery possible - user must accept the error
  none(0),
  /// Retry the operation (transient failure)
  retry(1),
  /// Refresh the authentication token
  refreshToken(2),
  /// User must re-authenticate (sign in again)
  reAuthenticate(3),
  /// User should check app settings
  goToSettings(4),
  /// User should contact support
  contactSupport(5),
  /// User should check network connection
  checkConnection(6),
  /// User should free up storage space
  freeStorage(7);

  final int value;
  const RecoveryAction(this.value);
}

sealed class AppError implements Exception {
  final String code;
  final String message;
  final String userMessage;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppError({
    required this.code,
    required this.message,
    required this.userMessage,
    this.originalError,
    this.stackTrace,
  });

  /// Whether the error can be recovered from without user intervention
  /// Used to determine if retry logic should be attempted automatically
  bool get isRecoverable;

  /// The recommended action to recover from this error
  /// UI layer uses this to show appropriate recovery options
  RecoveryAction get recoveryAction;
}
```

### 2.2 Error Categories with Exact Codes

```dart
// lib/core/errors/database_error.dart

final class DatabaseError extends AppError {
  final bool _isRecoverable;
  final RecoveryAction _recoveryAction;

  const DatabaseError._({
    required super.code,
    required super.message,
    required super.userMessage,
    super.originalError,
    super.stackTrace,
    bool isRecoverable = true,
    RecoveryAction recoveryAction = RecoveryAction.retry,
  }) : _isRecoverable = isRecoverable,
       _recoveryAction = recoveryAction;

  @override
  bool get isRecoverable => _isRecoverable;

  @override
  RecoveryAction get recoveryAction => _recoveryAction;

  // THESE ARE THE ONLY VALID DATABASE ERROR CODES
  static const String codeQueryFailed = 'DB_QUERY_FAILED';
  static const String codeInsertFailed = 'DB_INSERT_FAILED';
  static const String codeUpdateFailed = 'DB_UPDATE_FAILED';
  static const String codeDeleteFailed = 'DB_DELETE_FAILED';
  static const String codeNotFound = 'DB_NOT_FOUND';
  static const String codeMigrationFailed = 'DB_MIGRATION_FAILED';
  static const String codeConnectionFailed = 'DB_CONNECTION_FAILED';
  static const String codeTransactionFailed = 'DB_TRANSACTION_FAILED';
  static const String codeConstraintViolation = 'DB_CONSTRAINT_VIOLATION';

  factory DatabaseError.queryFailed(String details, [dynamic error, StackTrace? stack]) =>
    DatabaseError._(
      code: codeQueryFailed,
      message: 'Database query failed: $details',
      userMessage: 'Unable to load data. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory DatabaseError.notFound(String entityType, String id) =>
    DatabaseError._(
      code: codeNotFound,
      message: '$entityType with id $id not found',
      userMessage: 'The requested item could not be found.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.none,
    );

  factory DatabaseError.insertFailed(String table, [dynamic error, StackTrace? stack]) =>
    DatabaseError._(
      code: codeInsertFailed,
      message: 'Failed to insert into $table',
      userMessage: 'Unable to save data. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory DatabaseError.updateFailed(String table, [dynamic error, StackTrace? stack]) =>
    DatabaseError._(
      code: codeUpdateFailed,
      message: 'Failed to update $table',
      userMessage: 'Unable to update data. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory DatabaseError.deleteFailed(String table, [dynamic error, StackTrace? stack]) =>
    DatabaseError._(
      code: codeDeleteFailed,
      message: 'Failed to delete from $table',
      userMessage: 'Unable to delete data. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory DatabaseError.transactionFailed(String operation, [dynamic error, StackTrace? stack]) =>
    DatabaseError._(
      code: codeTransactionFailed,
      message: 'Transaction failed during $operation',
      userMessage: 'Unable to complete the operation. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory DatabaseError.migrationFailed(int fromVersion, int toVersion, [dynamic error, StackTrace? stack]) =>
    DatabaseError._(
      code: codeMigrationFailed,
      message: 'Migration failed from v$fromVersion to v$toVersion',
      userMessage: 'Database update failed. Please restart the app.',
      originalError: error,
      stackTrace: stack,
      isRecoverable: false,
      recoveryAction: RecoveryAction.contactSupport,
    );

  factory DatabaseError.connectionFailed([dynamic error, StackTrace? stack]) =>
    DatabaseError._(
      code: codeConnectionFailed,
      message: 'Database connection failed',
      userMessage: 'Unable to access local storage. Please restart the app.',
      originalError: error,
      stackTrace: stack,
    );

  factory DatabaseError.constraintViolation(String constraint, [dynamic error, StackTrace? stack]) =>
    DatabaseError._(
      code: codeConstraintViolation,
      message: 'Constraint violation: $constraint',
      userMessage: 'This operation violates data constraints.',
      originalError: error,
      stackTrace: stack,
      isRecoverable: false,
      recoveryAction: RecoveryAction.none,
    );
}

// lib/core/errors/auth_error.dart

final class AuthError extends AppError {
  final bool _isRecoverable;
  final RecoveryAction _recoveryAction;

  const AuthError._({
    required super.code,
    required super.message,
    required super.userMessage,
    super.originalError,
    super.stackTrace,
    bool isRecoverable = false,
    RecoveryAction recoveryAction = RecoveryAction.reAuthenticate,
  }) : _isRecoverable = isRecoverable,
       _recoveryAction = recoveryAction;

  @override
  bool get isRecoverable => _isRecoverable;

  @override
  RecoveryAction get recoveryAction => _recoveryAction;

  // THESE ARE THE ONLY VALID AUTH ERROR CODES
  static const String codeUnauthorized = 'AUTH_UNAUTHORIZED';
  static const String codeTokenExpired = 'AUTH_TOKEN_EXPIRED';
  static const String codeTokenRefreshFailed = 'AUTH_REFRESH_FAILED';
  static const String codeSignInFailed = 'AUTH_SIGNIN_FAILED';
  static const String codeSignOutFailed = 'AUTH_SIGNOUT_FAILED';
  static const String codePermissionDenied = 'AUTH_PERMISSION_DENIED';
  static const String codeProfileAccessDenied = 'AUTH_PROFILE_ACCESS_DENIED';

  factory AuthError.unauthorized(String reason) => AuthError._(
    code: codeUnauthorized,
    message: 'Unauthorized: $reason',
    userMessage: 'You do not have permission to perform this action.',
  );

  factory AuthError.profileAccessDenied(String profileId) => AuthError._(
    code: codeProfileAccessDenied,
    message: 'Access denied to profile $profileId',
    userMessage: 'You do not have access to this profile.',
  );

  factory AuthError.tokenExpired() => AuthError._(
    code: codeTokenExpired,
    message: 'Authentication token has expired',
    userMessage: 'Your session has expired. Please sign in again.',
    isRecoverable: true,
    recoveryAction: RecoveryAction.refreshToken,
  );

  factory AuthError.tokenRefreshFailed([dynamic error, StackTrace? stack]) => AuthError._(
    code: codeTokenRefreshFailed,
    message: 'Failed to refresh authentication token',
    userMessage: 'Unable to refresh session. Please sign in again.',
    originalError: error,
    stackTrace: stack,
  );

  factory AuthError.signInFailed(String reason, [dynamic error, StackTrace? stack]) => AuthError._(
    code: codeSignInFailed,
    message: 'Sign in failed: $reason',
    userMessage: 'Unable to sign in. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory AuthError.signOutFailed([dynamic error, StackTrace? stack]) => AuthError._(
    code: codeSignOutFailed,
    message: 'Sign out failed',
    userMessage: 'Unable to sign out. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory AuthError.permissionDenied(String resource) => AuthError._(
    code: codePermissionDenied,
    message: 'Permission denied for resource: $resource',
    userMessage: 'You do not have permission to perform this action.',
  );
}

// lib/core/errors/network_error.dart

final class NetworkError extends AppError {
  final bool _isRecoverable;
  final RecoveryAction _recoveryAction;

  const NetworkError._({
    required super.code,
    required super.message,
    required super.userMessage,
    super.originalError,
    super.stackTrace,
    bool isRecoverable = true,
    RecoveryAction recoveryAction = RecoveryAction.retry,
  }) : _isRecoverable = isRecoverable,
       _recoveryAction = recoveryAction;

  @override
  bool get isRecoverable => _isRecoverable;

  @override
  RecoveryAction get recoveryAction => _recoveryAction;

  // THESE ARE THE ONLY VALID NETWORK ERROR CODES
  static const String codeNoConnection = 'NET_NO_CONNECTION';
  static const String codeTimeout = 'NET_TIMEOUT';
  static const String codeServerError = 'NET_SERVER_ERROR';
  static const String codeRateLimited = 'NET_RATE_LIMITED';
  static const String codeSslError = 'NET_SSL_ERROR';

  factory NetworkError.noConnection() => NetworkError._(
    code: codeNoConnection,
    message: 'No network connection available',
    userMessage: 'No internet connection. Please check your connection and try again.',
    recoveryAction: RecoveryAction.checkConnection,
  );

  factory NetworkError.timeout(String operation, [Duration? duration]) => NetworkError._(
    code: codeTimeout,
    message: 'Network timeout during $operation${duration != null ? ' after ${duration.inSeconds}s' : ''}',
    userMessage: 'The request timed out. Please try again.',
  );

  factory NetworkError.serverError(int statusCode, String details, [dynamic error]) => NetworkError._(
    code: codeServerError,
    message: 'Server error $statusCode: $details',
    userMessage: 'Server error. Please try again later.',
    originalError: error,
  );

  factory NetworkError.rateLimited(String operation, [Duration? retryAfter]) => NetworkError._(
    code: codeRateLimited,
    message: 'Rate limited during $operation${retryAfter != null ? ', retry after ${retryAfter.inSeconds}s' : ''}',
    userMessage: 'Too many requests. Please wait a moment and try again.',
    recoveryAction: RecoveryAction.retry,
  );

  factory NetworkError.sslError(String host, [dynamic error, StackTrace? stack]) => NetworkError._(
    code: codeSslError,
    message: 'SSL certificate error for $host',
    userMessage: 'Secure connection failed. Please contact support.',
    originalError: error,
    stackTrace: stack,
    isRecoverable: false,
    recoveryAction: RecoveryAction.contactSupport,
  );
}

// lib/core/errors/validation_error.dart

final class ValidationError extends AppError {
  final Map<String, List<String>> fieldErrors;
  final bool _isRecoverable;
  final RecoveryAction _recoveryAction;

  const ValidationError._({
    required super.code,
    required super.message,
    required super.userMessage,
    required this.fieldErrors,
    super.originalError,
    super.stackTrace,
    bool isRecoverable = false,
    RecoveryAction recoveryAction = RecoveryAction.none,
  }) : _isRecoverable = isRecoverable,
       _recoveryAction = recoveryAction;

  @override
  bool get isRecoverable => _isRecoverable;

  @override
  RecoveryAction get recoveryAction => _recoveryAction;

  // THESE ARE THE ONLY VALID VALIDATION ERROR CODES
  static const String codeRequired = 'VAL_REQUIRED';
  static const String codeInvalidFormat = 'VAL_INVALID_FORMAT';
  static const String codeOutOfRange = 'VAL_OUT_OF_RANGE';
  static const String codeTooLong = 'VAL_TOO_LONG';
  static const String codeTooShort = 'VAL_TOO_SHORT';
  static const String codeDuplicate = 'VAL_DUPLICATE';
  static const String codeCustomFluidNameRequired = 'VAL_CUSTOM_FLUID_NAME_REQUIRED';
  static const String codeCustomFluidNameInvalid = 'VAL_CUSTOM_FLUID_NAME_INVALID';

  /// Create from map of field-level errors
  factory ValidationError.fromFieldErrors(Map<String, List<String>> errors) {
    final allErrors = errors.values.expand((e) => e).join(', ');
    return ValidationError._(
      code: codeInvalidFormat,
      message: 'Validation failed: $allErrors',
      userMessage: 'Please fix the highlighted fields.',
      fieldErrors: errors,
    );
  }

  /// Single field required
  factory ValidationError.required(String field) => ValidationError._(
    code: codeRequired,
    message: 'Field "$field" is required',
    userMessage: 'Please fill in the required field.',
    fieldErrors: {field: ['This field is required']},
  );

  /// Field format invalid
  factory ValidationError.invalidFormat(String field, String expected) => ValidationError._(
    code: codeInvalidFormat,
    message: 'Field "$field" has invalid format. Expected: $expected',
    userMessage: 'Please enter a valid value.',
    fieldErrors: {field: ['Invalid format. Expected: $expected']},
  );

  /// Value out of allowed range
  factory ValidationError.outOfRange(String field, num min, num max) => ValidationError._(
    code: codeOutOfRange,
    message: 'Field "$field" must be between $min and $max',
    userMessage: 'Value must be between $min and $max.',
    fieldErrors: {field: ['Must be between $min and $max']},
  );

  /// Field exceeds max length
  factory ValidationError.tooLong(String field, int maxLength) => ValidationError._(
    code: codeTooLong,
    message: 'Field "$field" exceeds $maxLength characters',
    userMessage: 'Text is too long. Maximum $maxLength characters.',
    fieldErrors: {field: ['Maximum $maxLength characters']},
  );

  /// Field below min length
  factory ValidationError.tooShort(String field, int minLength) => ValidationError._(
    code: codeTooShort,
    message: 'Field "$field" must be at least $minLength characters',
    userMessage: 'Text is too short. Minimum $minLength characters.',
    fieldErrors: {field: ['Minimum $minLength characters']},
  );

  /// Duplicate value detected
  factory ValidationError.duplicate(String field, String value) => ValidationError._(
    code: codeDuplicate,
    message: 'Duplicate value "$value" for field "$field"',
    userMessage: 'This value already exists.',
    fieldErrors: {field: ['Already exists']},
  );

  /// Custom fluid name required when amount or notes provided
  factory ValidationError.customFluidNameRequired() => ValidationError._(
    code: codeCustomFluidNameRequired,
    message: 'Custom fluid name required when providing amount or notes',
    userMessage: 'Please provide a name for the fluid.',
    fieldErrors: {'otherFluidName': ['Name required when providing amount or notes']},
  );

  /// Check if a specific field has errors
  bool hasErrorForField(String field) => fieldErrors.containsKey(field);

  /// Get errors for a specific field
  List<String> errorsForField(String field) => fieldErrors[field] ?? [];
}

// lib/core/errors/sync_error.dart

final class SyncError extends AppError {
  final bool _isRecoverable;
  final RecoveryAction _recoveryAction;

  const SyncError._({
    required super.code,
    required super.message,
    required super.userMessage,
    super.originalError,
    super.stackTrace,
    bool isRecoverable = true,
    RecoveryAction recoveryAction = RecoveryAction.retry,
  }) : _isRecoverable = isRecoverable,
       _recoveryAction = recoveryAction;

  @override
  bool get isRecoverable => _isRecoverable;

  @override
  RecoveryAction get recoveryAction => _recoveryAction;

  // THESE ARE THE ONLY VALID SYNC ERROR CODES
  static const String codeConflict = 'SYNC_CONFLICT';
  static const String codeUploadFailed = 'SYNC_UPLOAD_FAILED';
  static const String codeDownloadFailed = 'SYNC_DOWNLOAD_FAILED';
  static const String codeQuotaExceeded = 'SYNC_QUOTA_EXCEEDED';
  static const String codeCorruptedData = 'SYNC_CORRUPTED';

  factory SyncError.conflict(String entityType, String id, String localVersion, String remoteVersion) =>
    SyncError._(
      code: codeConflict,
      message: 'Sync conflict for $entityType $id (local: $localVersion, remote: $remoteVersion)',
      userMessage: 'A conflict was detected. Please choose which version to keep.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.none,  // Requires user decision
    );

  factory SyncError.uploadFailed(String entityType, String id, [dynamic error, StackTrace? stack]) =>
    SyncError._(
      code: codeUploadFailed,
      message: 'Failed to upload $entityType $id',
      userMessage: 'Unable to sync data to cloud. Will retry automatically.',
      originalError: error,
      stackTrace: stack,
    );

  factory SyncError.downloadFailed(String entityType, [dynamic error, StackTrace? stack]) =>
    SyncError._(
      code: codeDownloadFailed,
      message: 'Failed to download $entityType',
      userMessage: 'Unable to fetch data from cloud. Will retry automatically.',
      originalError: error,
      stackTrace: stack,
    );

  factory SyncError.quotaExceeded(int usedBytes, int maxBytes) =>
    SyncError._(
      code: codeQuotaExceeded,
      message: 'Storage quota exceeded (${usedBytes ~/ 1024 ~/ 1024}MB / ${maxBytes ~/ 1024 ~/ 1024}MB)',
      userMessage: 'Cloud storage limit reached. Please free up space or upgrade.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.freeStorage,
    );

  factory SyncError.corruptedData(String entityType, String id, String reason) =>
    SyncError._(
      code: codeCorruptedData,
      message: 'Corrupted data detected in $entityType $id: $reason',
      userMessage: 'Data corruption detected. Please contact support.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.contactSupport,
    );
}

// lib/core/errors/wearable_error.dart

final class WearableError extends AppError {
  final bool _isRecoverable;
  final RecoveryAction _recoveryAction;

  const WearableError._({
    required super.code,
    required super.message,
    required super.userMessage,
    super.originalError,
    super.stackTrace,
    bool isRecoverable = true,
    RecoveryAction recoveryAction = RecoveryAction.retry,
  }) : _isRecoverable = isRecoverable,
       _recoveryAction = recoveryAction;

  @override
  bool get isRecoverable => _isRecoverable;

  @override
  RecoveryAction get recoveryAction => _recoveryAction;

  // THESE ARE THE ONLY VALID WEARABLE ERROR CODES
  static const String codeAuthFailed = 'WEARABLE_AUTH_FAILED';
  static const String codeConnectionFailed = 'WEARABLE_CONNECTION_FAILED';
  static const String codeSyncFailed = 'WEARABLE_SYNC_FAILED';
  static const String codeDataMappingFailed = 'WEARABLE_MAPPING_FAILED';
  static const String codeQuotaExceeded = 'WEARABLE_QUOTA_EXCEEDED';
  static const String codePlatformUnavailable = 'WEARABLE_PLATFORM_UNAVAILABLE';
  static const String codePermissionDenied = 'WEARABLE_PERMISSION_DENIED';

  factory WearableError.authFailed(String platform, [dynamic error]) =>
    WearableError._(
      code: codeAuthFailed,
      message: 'Failed to authenticate with $platform',
      userMessage: 'Unable to connect to $platform. Please try again.',
      originalError: error,
    );

  factory WearableError.platformUnavailable(String platform) =>
    WearableError._(
      code: codePlatformUnavailable,
      message: '$platform is not available on this device',
      userMessage: '$platform is not supported on this device.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.none,
    );

  factory WearableError.connectionFailed(String platform, [dynamic error, StackTrace? stack]) =>
    WearableError._(
      code: codeConnectionFailed,
      message: 'Failed to connect to $platform',
      userMessage: 'Unable to connect to $platform. Please check your device settings.',
      originalError: error,
      stackTrace: stack,
    );

  factory WearableError.syncFailed(String platform, String details, [dynamic error, StackTrace? stack]) =>
    WearableError._(
      code: codeSyncFailed,
      message: 'Sync failed with $platform: $details',
      userMessage: 'Unable to sync data from $platform. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory WearableError.dataMappingFailed(String platform, String dataType, [dynamic error]) =>
    WearableError._(
      code: codeDataMappingFailed,
      message: 'Failed to map $dataType from $platform',
      userMessage: 'Unable to import $dataType data. Format not recognized.',
      originalError: error,
    );

  factory WearableError.quotaExceeded(String platform, int maxRequests, Duration window) =>
    WearableError._(
      code: codeQuotaExceeded,
      message: '$platform API rate limit exceeded ($maxRequests per ${window.inMinutes}min)',
      userMessage: 'Too many requests to $platform. Please wait a few minutes.',
    );

  factory WearableError.permissionDenied(String platform, String permission) =>
    WearableError._(
      code: codePermissionDenied,
      message: '$platform permission denied: $permission',
      userMessage: 'Permission required for $permission. Please update settings.',
    );
}

// lib/core/errors/diet_error.dart

final class DietError extends AppError {
  final bool _isRecoverable;
  final RecoveryAction _recoveryAction;

  const DietError._({
    required super.code,
    required super.message,
    required super.userMessage,
    super.originalError,
    super.stackTrace,
    bool isRecoverable = false,
    RecoveryAction recoveryAction = RecoveryAction.none,
  }) : _isRecoverable = isRecoverable,
       _recoveryAction = recoveryAction;

  @override
  bool get isRecoverable => _isRecoverable;

  @override
  RecoveryAction get recoveryAction => _recoveryAction;

  // THESE ARE THE ONLY VALID DIET ERROR CODES
  static const String codeInvalidRule = 'DIET_INVALID_RULE';
  static const String codeRuleConflict = 'DIET_RULE_CONFLICT';
  static const String codeViolationNotFound = 'DIET_VIOLATION_NOT_FOUND';
  static const String codeComplianceCalculationFailed = 'DIET_COMPLIANCE_FAILED';
  static const String codeDietNotActive = 'DIET_NOT_ACTIVE';
  static const String codeMultipleActiveDiets = 'DIET_MULTIPLE_ACTIVE';

  factory DietError.ruleConflict(String rule1, String rule2) =>
    DietError._(
      code: codeRuleConflict,
      message: 'Diet rules conflict: $rule1 vs $rule2',
      userMessage: 'These diet rules conflict with each other.',
    );

  /// Rule Conflict Detection Criteria:
  ///
  /// Two DietRules conflict when they cannot both be satisfied simultaneously.
  ///
  /// **Category Conflicts:**
  /// - excludeCategory(X) + requireCategory(X) -> CONFLICT (can't exclude and require same category)
  ///
  /// **Macro Conflicts:**
  /// - maxCarbs(50g) + minCarbs(100g) -> CONFLICT (max < min)
  /// - carbPercentage(10%) + fatPercentage(10%) + proteinPercentage(10%) = 30% -> CONFLICT (must sum to 100%)
  /// - carbPercentage(50%) + fatPercentage(50%) + proteinPercentage(50%) = 150% -> CONFLICT (exceeds 100%)
  ///
  /// **Timing Conflicts:**
  /// - eatingWindow(10:00-18:00) + maxMealsPerDay(8) with mealSpacing(3h) -> CONFLICT (8 meals × 3h > 8h window)
  /// - fastingHours(20) + eatingWindow(10:00-18:00) -> CONFLICT (20h fasting only leaves 4h eating window)
  ///
  /// **Calorie Conflicts:**
  /// - maxCalories(1000) with maxCarbs(50g), maxFat(50g), maxProtein(50g) -> CONFLICT if minimums can't fit
  ///   (50g carbs × 4cal = 200cal, 50g fat × 9cal = 450cal, 50g protein × 4cal = 200cal = 850cal minimum)
  ///
  /// **Detection Algorithm:**
  /// ```
  /// bool hasConflict(List<DietRule> rules):
  ///   1. Check macro min/max inversions (max < min for same nutrient)
  ///   2. Check category exclusion/requirement overlap
  ///   3. If percentage rules exist, verify sum equals 100% ± tolerance
  ///   4. Calculate minimum feasible calories from macro minimums
  ///   5. Verify eating window accommodates meal count × spacing
  ///   6. Verify fasting hours compatible with eating window
  /// ```

  factory DietError.multipleActiveDiets() =>
    DietError._(
      code: codeMultipleActiveDiets,
      message: 'Multiple active diets detected',
      userMessage: 'Only one diet can be active at a time.',
    );

  factory DietError.invalidRule(String ruleType, String reason) =>
    DietError._(
      code: codeInvalidRule,
      message: 'Invalid diet rule $ruleType: $reason',
      userMessage: 'This diet rule is not valid. $reason',
    );

  factory DietError.violationNotFound(String violationId) =>
    DietError._(
      code: codeViolationNotFound,
      message: 'Diet violation $violationId not found',
      userMessage: 'The specified violation record was not found.',
    );

  factory DietError.complianceCalculationFailed(String reason, [dynamic error, StackTrace? stack]) =>
    DietError._(
      code: codeComplianceCalculationFailed,
      message: 'Failed to calculate compliance: $reason',
      userMessage: 'Unable to calculate diet compliance. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory DietError.dietNotActive(String dietId) =>
    DietError._(
      code: codeDietNotActive,
      message: 'Diet $dietId is not currently active',
      userMessage: 'This diet is not active. Activate it to track compliance.',
    );
}

// lib/core/errors/intelligence_error.dart

final class IntelligenceError extends AppError {
  final bool _isRecoverable;
  final RecoveryAction _recoveryAction;

  const IntelligenceError._({
    required super.code,
    required super.message,
    required super.userMessage,
    super.originalError,
    super.stackTrace,
    bool isRecoverable = true,
    RecoveryAction recoveryAction = RecoveryAction.retry,
  }) : _isRecoverable = isRecoverable,
       _recoveryAction = recoveryAction;

  @override
  bool get isRecoverable => _isRecoverable;

  @override
  RecoveryAction get recoveryAction => _recoveryAction;

  // THESE ARE THE ONLY VALID INTELLIGENCE ERROR CODES
  static const String codeInsufficientData = 'INTEL_INSUFFICIENT_DATA';
  static const String codeAnalysisFailed = 'INTEL_ANALYSIS_FAILED';
  static const String codePredictionFailed = 'INTEL_PREDICTION_FAILED';
  static const String codeModelNotFound = 'INTEL_MODEL_NOT_FOUND';
  static const String codePatternDetectionFailed = 'INTEL_PATTERN_FAILED';
  static const String codeCorrelationFailed = 'INTEL_CORRELATION_FAILED';

  factory IntelligenceError.insufficientData(int required, int actual) =>
    IntelligenceError._(
      code: codeInsufficientData,
      message: 'Insufficient data: need $required days, have $actual',
      userMessage: 'More data is needed for analysis. Keep tracking for ${required - actual} more days.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.none,  // Requires more data collection over time
    );

  factory IntelligenceError.modelNotFound(String modelType) =>
    IntelligenceError._(
      code: codeModelNotFound,
      message: 'ML model not found: $modelType',
      userMessage: 'Prediction model not yet available. Continue tracking to enable predictions.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.none,  // Requires data collection to train model
    );

  factory IntelligenceError.analysisFailed(String analysisType, String reason, [dynamic error, StackTrace? stack]) =>
    IntelligenceError._(
      code: codeAnalysisFailed,
      message: 'Analysis failed for $analysisType: $reason',
      userMessage: 'Unable to analyze data. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory IntelligenceError.predictionFailed(String predictionType, [dynamic error, StackTrace? stack]) =>
    IntelligenceError._(
      code: codePredictionFailed,
      message: 'Prediction failed for $predictionType',
      userMessage: 'Unable to generate prediction. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory IntelligenceError.patternDetectionFailed(String patternType, [dynamic error, StackTrace? stack]) =>
    IntelligenceError._(
      code: codePatternDetectionFailed,
      message: 'Pattern detection failed for $patternType',
      userMessage: 'Unable to detect patterns. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory IntelligenceError.correlationFailed(String trigger, String outcome, [dynamic error, StackTrace? stack]) =>
    IntelligenceError._(
      code: codeCorrelationFailed,
      message: 'Correlation analysis failed between $trigger and $outcome',
      userMessage: 'Unable to analyze correlations. Please try again.',
      originalError: error,
      stackTrace: stack,
    );
}

// lib/core/errors/business_error.dart

/// BusinessError covers generic business logic violations not specific to a feature domain.
/// Use feature-specific errors (DietError, IntelligenceError, etc.) when applicable.
final class BusinessError extends AppError {
  final bool _isRecoverable;
  final RecoveryAction _recoveryAction;

  const BusinessError._({
    required super.code,
    required super.message,
    required super.userMessage,
    super.originalError,
    super.stackTrace,
    bool isRecoverable = false,
    RecoveryAction recoveryAction = RecoveryAction.none,
  }) : _isRecoverable = isRecoverable,
       _recoveryAction = recoveryAction;

  @override
  bool get isRecoverable => _isRecoverable;

  @override
  RecoveryAction get recoveryAction => _recoveryAction;

  // THESE ARE THE ONLY VALID BUSINESS ERROR CODES
  static const String codeInvalidState = 'BUS_INVALID_STATE';
  static const String codeOperationNotAllowed = 'BUS_OPERATION_NOT_ALLOWED';
  static const String codeDependencyConflict = 'BUS_DEPENDENCY_CONFLICT';
  static const String codePreconditionFailed = 'BUS_PRECONDITION_FAILED';
  static const String codeInvariantViolation = 'BUS_INVARIANT_VIOLATION';

  /// Entity is in a state that doesn't allow the requested operation
  factory BusinessError.invalidState(String entity, String currentState, String requiredState) =>
    BusinessError._(
      code: codeInvalidState,
      message: '$entity is in state "$currentState" but requires "$requiredState"',
      userMessage: 'This operation cannot be performed in the current state.',
    );

  /// Operation is not allowed for business reasons
  factory BusinessError.operationNotAllowed(String operation, String reason) =>
    BusinessError._(
      code: codeOperationNotAllowed,
      message: 'Operation "$operation" not allowed: $reason',
      userMessage: 'This operation is not allowed. $reason',
    );

  /// Entity has dependencies that prevent the operation
  factory BusinessError.dependencyConflict(String entity, String dependency, String reason) =>
    BusinessError._(
      code: codeDependencyConflict,
      message: 'Cannot modify $entity due to dependency on $dependency: $reason',
      userMessage: 'This item has dependencies that prevent the change.',
    );

  /// Precondition for operation was not met
  factory BusinessError.preconditionFailed(String operation, String precondition) =>
    BusinessError._(
      code: codePreconditionFailed,
      message: 'Precondition failed for $operation: $precondition',
      userMessage: 'Required conditions were not met. $precondition',
    );

  /// Business invariant was violated
  factory BusinessError.invariantViolation(String invariant, String actual) =>
    BusinessError._(
      code: codeInvariantViolation,
      message: 'Invariant violated: expected $invariant, got $actual',
      userMessage: 'An unexpected condition occurred. Please try again.',
    );
}

// lib/core/errors/notification_error.dart

/// NotificationError covers errors specific to the notification system.
final class NotificationError extends AppError {
  final bool _isRecoverable;
  final RecoveryAction _recoveryAction;

  const NotificationError._({
    required super.code,
    required super.message,
    required super.userMessage,
    super.originalError,
    super.stackTrace,
    bool isRecoverable = true,
    RecoveryAction recoveryAction = RecoveryAction.retry,
  }) : _isRecoverable = isRecoverable,
       _recoveryAction = recoveryAction;

  @override
  bool get isRecoverable => _isRecoverable;

  @override
  RecoveryAction get recoveryAction => _recoveryAction;

  // THESE ARE THE ONLY VALID NOTIFICATION ERROR CODES
  static const String codeScheduleFailed = 'NOTIF_SCHEDULE_FAILED';
  static const String codeCancelFailed = 'NOTIF_CANCEL_FAILED';
  static const String codePermissionDenied = 'NOTIF_PERMISSION_DENIED';
  static const String codeInvalidTime = 'NOTIF_INVALID_TIME';
  static const String codeNotFound = 'NOTIF_NOT_FOUND';
  static const String codePlatformUnsupported = 'NOTIF_PLATFORM_UNSUPPORTED';

  /// Failed to schedule a notification
  factory NotificationError.scheduleFailed(String notificationType, [dynamic error, StackTrace? stack]) =>
    NotificationError._(
      code: codeScheduleFailed,
      message: 'Failed to schedule notification: $notificationType',
      userMessage: 'Unable to set reminder. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  /// Failed to cancel a notification
  factory NotificationError.cancelFailed(String notificationId, [dynamic error, StackTrace? stack]) =>
    NotificationError._(
      code: codeCancelFailed,
      message: 'Failed to cancel notification: $notificationId',
      userMessage: 'Unable to remove reminder. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  /// Notification permission denied by user
  factory NotificationError.permissionDenied() =>
    NotificationError._(
      code: codePermissionDenied,
      message: 'Notification permission denied by user',
      userMessage: 'Notification permission required. Please enable in Settings.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.goToSettings,
    );

  /// Invalid notification time (e.g., in the past)
  factory NotificationError.invalidTime(String reason) =>
    NotificationError._(
      code: codeInvalidTime,
      message: 'Invalid notification time: $reason',
      userMessage: 'Please select a valid time for the reminder.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.none,
    );

  /// Notification schedule not found
  factory NotificationError.notFound(String scheduleId) =>
    NotificationError._(
      code: codeNotFound,
      message: 'Notification schedule not found: $scheduleId',
      userMessage: 'The reminder was not found.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.none,
    );

  /// Notification feature not supported on platform
  factory NotificationError.platformUnsupported(String platform, String feature) =>
    NotificationError._(
      code: codePlatformUnsupported,
      message: '$feature not supported on $platform',
      userMessage: 'This notification feature is not supported on your device.',
      isRecoverable: false,
      recoveryAction: RecoveryAction.none,
    );
}
```

---

## 3. Sync & Core Type Contracts

### 3.1 SyncMetadata Contract

ALL entities with sync support MUST include this exact SyncMetadata structure:

```dart
// lib/domain/entities/sync_metadata.dart

/// SyncMetadata handles cloud synchronization state for all entities.
///
/// DATABASE MAPPING: Field names use camelCase in Dart but map to snake_case
/// columns in the database via @JsonKey annotations. The JSON key names
/// match the database column names exactly.
@freezed
class SyncMetadata with _$SyncMetadata {
  const SyncMetadata._();

  const factory SyncMetadata({
    // Dart field: syncCreatedAt → DB column: sync_created_at
    @JsonKey(name: 'sync_created_at') required int syncCreatedAt,      // Epoch milliseconds
    // Dart field: syncUpdatedAt → DB column: sync_updated_at
    @JsonKey(name: 'sync_updated_at') required int syncUpdatedAt,      // Epoch milliseconds
    // Dart field: syncDeletedAt → DB column: sync_deleted_at
    @JsonKey(name: 'sync_deleted_at') int? syncDeletedAt,              // Null = not deleted
    // Dart field: syncLastSyncedAt → DB column: sync_last_synced_at
    @JsonKey(name: 'sync_last_synced_at') int? syncLastSyncedAt,       // Last cloud sync
    // Dart field: syncStatus → DB column: sync_status
    @JsonKey(name: 'sync_status') @Default(SyncStatus.pending) SyncStatus syncStatus,
    // Dart field: syncVersion → DB column: sync_version
    @JsonKey(name: 'sync_version') @Default(1) int syncVersion,        // Optimistic concurrency
    // Dart field: syncDeviceId → DB column: sync_device_id
    @JsonKey(name: 'sync_device_id') required String syncDeviceId,     // Last modifying device
    // Dart field: syncIsDirty → DB column: sync_is_dirty
    @JsonKey(name: 'sync_is_dirty') @Default(true) bool syncIsDirty,   // Unsynchronized changes
    // Dart field: conflictData → DB column: conflict_data
    @JsonKey(name: 'conflict_data') String? conflictData,              // JSON of conflicting record
  }) = _SyncMetadata;

  factory SyncMetadata.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataFromJson(json);

  /// Create new sync metadata for a fresh entity
  factory SyncMetadata.create({required String deviceId}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return SyncMetadata(
      syncCreatedAt: now,
      syncUpdatedAt: now,
      syncDeviceId: deviceId,
    );
  }

  /// Mark as modified (updates timestamp, dirty flag, AND increments version)
  /// IMPORTANT: syncVersion is incremented to detect conflicts during sync
  SyncMetadata markModified(String deviceId) => copyWith(
    syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    syncDeviceId: deviceId,
    syncIsDirty: true,
    syncStatus: SyncStatus.modified,
    syncVersion: syncVersion + 1,  // REQUIRED: Increment for conflict detection
  );

  /// Mark as synced (clears dirty flag, updates last synced time, does NOT increment version)
  /// Called after successful cloud sync - version stays same since no local change
  SyncMetadata markSynced() => copyWith(
    syncIsDirty: false,
    syncStatus: SyncStatus.synced,
    syncLastSyncedAt: DateTime.now().millisecondsSinceEpoch,
    // NOTE: syncVersion NOT incremented - no local change occurred
  );

  /// Mark as soft deleted (updates timestamp, dirty flag, AND increments version)
  /// IMPORTANT: Delete is a local change, so version must increment
  SyncMetadata markDeleted(String deviceId) => copyWith(
    syncDeletedAt: DateTime.now().millisecondsSinceEpoch,
    syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    syncDeviceId: deviceId,
    syncIsDirty: true,
    syncStatus: SyncStatus.deleted,
    syncVersion: syncVersion + 1,  // REQUIRED: Delete is a local change
  );

  bool get isDeleted => syncDeletedAt != null;

  /// Mark as conflicted (conflict detected during applyChanges).
  ///
  /// Called when a remote entity arrives for a locally-dirty record.
  /// Sets sync_status = conflict(3) and stores the remote version's JSON
  /// in conflict_data for quick access without joining sync_conflicts table.
  ///
  /// IMPORTANT: Does NOT increment syncVersion — the entity has not changed
  /// locally. The version conflict is what triggered this state.
  SyncMetadata markConflict(String remoteJson) => copyWith(
    syncStatus: SyncStatus.conflict,
    syncIsDirty: true,     // Remains dirty until resolved
    conflictData: remoteJson,
    // syncVersion NOT incremented — no local change
  );

  /// Clear conflict state after resolution.
  ///
  /// Called by resolveConflict() after applying the chosen version.
  /// Increments syncVersion (resolution is a local change that must re-sync).
  SyncMetadata clearConflict() => copyWith(
    syncStatus: SyncStatus.pending,
    syncIsDirty: true,                                   // Must re-upload resolved version
    syncVersion: syncVersion + 1,                        // REQUIRED: resolution is a local change
    conflictData: null,
  );

  /// Create empty sync metadata (for entity construction before persisting)
  /// IMPORTANT: Must call create() with deviceId before saving to database
  factory SyncMetadata.empty() {
    return SyncMetadata(
      syncCreatedAt: 0,
      syncUpdatedAt: 0,
      syncDeviceId: '',
    );
  }

  /// Check if this metadata was created with empty() and needs initialization
  bool get needsInitialization => syncDeviceId.isEmpty;
}

/// Interface for entities that support cloud synchronization.
/// ALL syncable entities MUST implement this interface.
abstract interface class Syncable {
  SyncMetadata get syncMetadata;
}

enum SyncStatus {
  pending(0),    // Never synced
  synced(1),     // Successfully synced
  modified(2),   // Modified since last sync
  conflict(3),   // Conflict detected, needs resolution
  deleted(4);    // Marked for deletion

  final int value;
  const SyncStatus(this.value);

  static SyncStatus fromValue(int value) =>
    SyncStatus.values.firstWhere((e) => e.value == value, orElse: () => pending);
}
```

### 3.2 Flutter Platform Types

The following types are imported from Flutter SDK and used throughout the API contracts:

```dart
// From flutter/material.dart - NO custom implementation needed
import 'package:flutter/material.dart' show TimeOfDay, DateTimeRange;

/// TimeOfDay - Represents a time of day (hour and minute)
/// Used for: eating windows, notification schedules, sleep times
/// Example: TimeOfDay(hour: 8, minute: 0) represents 8:00 AM

/// DateTimeRange - Represents a range between two dates
/// Used for: report date ranges, compliance calculation windows
/// Example: DateTimeRange(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 31))

// JSON Serialization helpers for TimeOfDay
extension TimeOfDayJson on TimeOfDay {
  /// Convert to JSON-serializable map
  Map<String, int> toJson() => {'hour': hour, 'minute': minute};

  /// Create from JSON map
  static TimeOfDay fromJson(Map<String, dynamic> json) =>
    TimeOfDay(hour: json['hour'] as int, minute: json['minute'] as int);
}

// JSON Serialization helpers for DateTimeRange
extension DateTimeRangeJson on DateTimeRange {
  /// Convert to JSON-serializable map (ISO 8601 strings)
  Map<String, String> toJson() => {
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
  };

  /// Create from JSON map
  static DateTimeRange fromJson(Map<String, dynamic> json) =>
    DateTimeRange(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );
}
```

### 3.3 Core Domain Enums

ALL domain enums MUST be defined here:

```dart
// lib/domain/enums/health_enums.dart

enum BowelCondition {
  diarrhea(0),
  runny(1),
  loose(2),
  normal(3),
  firm(4),
  hard(5),
  custom(6);

  final int value;
  const BowelCondition(this.value);

  static BowelCondition fromValue(int value) =>
    BowelCondition.values.firstWhere((e) => e.value == value, orElse: () => normal);
}

enum UrineCondition {
  clear(0),
  lightYellow(1),
  yellow(2),
  darkYellow(3),
  amber(4),
  brown(5),
  red(6),
  custom(7);

  final int value;
  const UrineCondition(this.value);

  static UrineCondition fromValue(int value) =>
    UrineCondition.values.firstWhere((e) => e.value == value, orElse: () => lightYellow);
}

enum MovementSize {
  tiny(0),
  small(1),
  medium(2),
  large(3),
  huge(4);

  final int value;
  const MovementSize(this.value);

  static MovementSize fromValue(int value) =>
    MovementSize.values.firstWhere((e) => e.value == value, orElse: () => medium);
}

enum MenstruationFlow {
  none(0),
  spotty(1),
  light(2),
  medium(3),
  heavy(4);

  final int value;
  const MenstruationFlow(this.value);

  static MenstruationFlow fromValue(int value) =>
    MenstruationFlow.values.firstWhere((e) => e.value == value, orElse: () => none);
}

enum SleepQuality {
  veryPoor(1),
  poor(2),
  fair(3),
  good(4),
  excellent(5);

  final int value;
  const SleepQuality(this.value);

  static SleepQuality fromValue(int value) =>
    SleepQuality.values.firstWhere((e) => e.value == value, orElse: () => fair);
}

enum ActivityIntensity {
  light(0),
  moderate(1),
  vigorous(2);

  final int value;
  const ActivityIntensity(this.value);

  static ActivityIntensity fromValue(int value) =>
    ActivityIntensity.values.firstWhere((e) => e.value == value, orElse: () => moderate);
}

enum ConditionSeverity {
  none(0),
  mild(1),
  moderate(2),
  severe(3),
  extreme(4);

  final int value;
  const ConditionSeverity(this.value);

  static ConditionSeverity fromValue(int value) =>
    ConditionSeverity.values.firstWhere((e) => e.value == value, orElse: () => none);

  /// Convert 5-level enum to 1-10 storage scale
  /// Mapping: none=1, mild=2-3, moderate=4-5, severe=6-8, extreme=9-10
  int toStorageScale() => switch (this) {
    ConditionSeverity.none => 1,
    ConditionSeverity.mild => 3,
    ConditionSeverity.moderate => 5,
    ConditionSeverity.severe => 7,
    ConditionSeverity.extreme => 10,
  };

  /// Create from 1-10 storage scale
  static ConditionSeverity fromStorageScale(int value) {
    if (value <= 1) return ConditionSeverity.none;
    if (value <= 3) return ConditionSeverity.mild;
    if (value <= 5) return ConditionSeverity.moderate;
    if (value <= 8) return ConditionSeverity.severe;
    return ConditionSeverity.extreme;
  }
}

enum MoodLevel {
  veryLow(1),
  low(2),
  neutral(3),
  good(4),
  veryGood(5);

  final int value;
  const MoodLevel(this.value);

  static MoodLevel fromValue(int value) =>
    MoodLevel.values.firstWhere((e) => e.value == value, orElse: () => neutral);
}

enum DietRuleType {
  // Food-based rules
  excludeCategory(0),      // Exclude entire food category
  excludeIngredient(1),    // Exclude specific ingredient
  requireCategory(2),      // Must include category (e.g., vegetables)
  limitCategory(3),        // Max servings per day/week

  // Macronutrient rules
  maxCarbs(4),             // Maximum carbs (grams)
  maxFat(5),               // Maximum fat (grams)
  maxProtein(6),           // Maximum protein (grams)
  minCarbs(7),             // Minimum carbs (grams)
  minFat(8),               // Minimum fat (grams)
  minProtein(9),           // Minimum protein (grams)
  carbPercentage(10),      // Carbs as % of calories
  fatPercentage(11),       // Fat as % of calories
  proteinPercentage(12),   // Protein as % of calories
  maxCalories(13),         // Maximum daily calories

  // Time-based rules
  eatingWindowStart(14),   // Earliest eating time
  eatingWindowEnd(15),     // Latest eating time
  fastingHours(16),        // Required consecutive fasting hours
  fastingDays(17),         // Specific fasting days (for 5:2)
  maxMealsPerDay(18),      // Maximum number of meals

  // Combination rules
  mealSpacing(19),         // Minimum hours between meals
  noEatingBefore(20),      // No food before time
  noEatingAfter(21);       // No food after time

  final int value;
  const DietRuleType(this.value);

  static DietRuleType fromValue(int value) =>
    DietRuleType.values.firstWhere((e) => e.value == value, orElse: () => excludeCategory);
}

enum PatternType {
  temporal(0),
  cyclical(1),
  sequential(2),
  cluster(3),
  dosage(4);

  final int value;
  const PatternType(this.value);

  static PatternType fromValue(int value) =>
    PatternType.values.firstWhere((e) => e.value == value, orElse: () => temporal);
}

/// Diet preset types - predefined diet configurations
enum DietPresetType {
  vegan(0),
  vegetarian(1),
  pescatarian(2),
  paleo(3),
  keto(4),
  ketoStrict(5),
  lowCarb(6),
  mediterranean(7),
  whole30(8),
  aip(9),              // Autoimmune Protocol
  lowFodmap(10),
  glutenFree(11),
  dairyFree(12),
  if168(13),           // Intermittent Fasting 16:8
  if186(14),           // Intermittent Fasting 18:6
  if204(15),           // Intermittent Fasting 20:4
  omad(16),            // One Meal A Day
  fiveTwoDiet(17),     // 5:2 Fasting
  zone(18),
  custom(19);

  final int value;
  const DietPresetType(this.value);
}

enum InsightCategory {
  daily(0),
  summary(1),         // Weekly/monthly summaries
  pattern(2),
  trigger(3),
  progress(4),
  compliance(5),
  anomaly(6),
  milestone(7),
  recommendation(8);  // Actionable recommendations

  final int value;
  const InsightCategory(this.value);
}

enum AlertPriority {
  low(0),
  medium(1),
  high(2),
  critical(3);

  final int value;
  const AlertPriority(this.value);

  static AlertPriority fromValue(int value) =>
    AlertPriority.values.firstWhere((e) => e.value == value, orElse: () => low);
}

enum WearablePlatform {
  healthkit(0),
  googlefit(1),
  fitbit(2),
  garmin(3),
  oura(4),
  whoop(5);

  final int value;
  const WearablePlatform(this.value);
}

/// CANONICAL: This is the authoritative definition of notification types.
/// See 37_NOTIFICATIONS.md for implementation details.
///
/// **Meal Type Mapping (API → UI):**
/// The 4 API meal types map to 6 UI meal times as follows:
/// - mealBreakfast(2) → breakfast
/// - mealLunch(3) → lunch
/// - mealDinner(4) → dinner
/// - mealSnacks(5) → morningSnack, afternoonSnack, eveningSnack (collapsed)
///
/// The MealType enum in 37_NOTIFICATIONS.md (6 values) is for UI configuration
/// only. The NotificationType enum here (4 meal values) is for storage and
/// scheduling. When creating a morningSnack reminder, use mealSnacks(5).
///
/// **Snooze Behavior by Type:**
/// | Type | Snooze Allowed | Default Duration | Rationale |
/// |------|----------------|------------------|-----------|
/// | supplementIndividual | Yes | 15 min | Can be delayed |
/// | supplementGrouped | Yes | 15 min | Can be delayed |
/// | mealBreakfast/Lunch/Dinner/Snacks | Yes | 30 min | Flexible timing |
/// | waterInterval/Fixed/Smart | Yes | 30 min | Flexible timing |
/// | bbtMorning | **NO** | N/A | Medical accuracy requires same-time |
/// | menstruationTracking | Yes | 60 min | Flexible timing |
/// | sleepBedtime | Yes | 15 min | Pre-warning allows delay |
/// | sleepWakeup | Yes | 5 min | Already awake |
/// | conditionCheckIn | Yes | 60 min | Flexible timing |
/// | photoReminder | Yes | 60 min | Flexible timing |
/// | journalPrompt | Yes | 60 min | Flexible timing |
/// | syncReminder | Yes | 120 min | Not time-critical |
/// | fastingWindowOpen/Close | Yes | 15 min | Can delay awareness |
/// | dietStreak/WeeklySummary | **NO** | N/A | Informational only |
///
/// **Smart Water Reminder Algorithm:**
/// See SmartWaterReminderService in 37_NOTIFICATIONS.md Section 5.3.
/// Formula: nextInterval = max(30, remainingMinutes / glassesRemaining)
/// Where glassesRemaining = ceil((dailyGoalMl - consumedTodayMl) / 237ml)
enum NotificationType {
  supplementIndividual(0),
  supplementGrouped(1),
  mealBreakfast(2),
  mealLunch(3),
  mealDinner(4),
  mealSnacks(5),
  waterInterval(6),
  waterFixed(7),
  waterSmart(8),
  bbtMorning(9),
  menstruationTracking(10),
  sleepBedtime(11),
  sleepWakeup(12),
  conditionCheckIn(13),
  photoReminder(14),
  journalPrompt(15),
  syncReminder(16),
  fastingWindowOpen(17),
  fastingWindowClose(18),
  fastingWindowClosed(19),   // Alert when fasting period begins
  dietStreak(20),
  dietWeeklySummary(21),
  fluidsGeneral(22),         // General fluids tracking reminders
  fluidsBowel(23),           // Bowel movement tracking reminders
  inactivity(24);            // Re-engagement after extended absence

  final int value;
  const NotificationType(this.value);

  static NotificationType fromValue(int value) =>
    NotificationType.values.firstWhere((e) => e.value == value, orElse: () => supplementIndividual);

  /// Whether this notification type allows snooze action
  bool get allowsSnooze => switch (this) {
    bbtMorning => false,        // Medical accuracy
    dietStreak => false,        // Informational
    dietWeeklySummary => false, // Informational
    inactivity => false,        // Re-engagement, not time-sensitive
    _ => true,
  };

  /// Default snooze duration in minutes for this type
  int get defaultSnoozeMinutes => switch (this) {
    supplementIndividual => 15,
    supplementGrouped => 15,
    mealBreakfast => 30,
    mealLunch => 30,
    mealDinner => 30,
    mealSnacks => 30,
    waterInterval => 30,
    waterFixed => 30,
    waterSmart => 30,
    menstruationTracking => 60,
    sleepBedtime => 15,
    sleepWakeup => 5,
    conditionCheckIn => 60,
    photoReminder => 60,
    journalPrompt => 60,
    syncReminder => 120,
    fastingWindowOpen => 15,
    fastingWindowClose => 15,
    fastingWindowClosed => 15,
    fluidsGeneral => 30,
    fluidsBowel => 60,
    _ => 0,  // Non-snoozable types (bbtMorning, dietStreak, dietWeeklySummary, inactivity)
  };
}

// Supplement-related enums
enum SupplementForm {
  capsule(0),
  powder(1),
  liquid(2),
  tablet(3),
  gummy(4),
  spray(5),
  other(6);

  final int value;
  const SupplementForm(this.value);

  static SupplementForm fromValue(int value) =>
    SupplementForm.values.firstWhere((e) => e.value == value, orElse: () => capsule);
}

enum DosageUnit {
  g(0, 'g'),        // grams
  mg(1, 'mg'),      // milligrams
  mcg(2, 'mcg'),    // micrograms
  iu(3, 'IU'),      // International Units
  hdu(4, 'HDU'),    // Histamine Degrading Units
  ml(5, 'mL'),      // milliliters
  drops(6, 'drops'),
  tsp(7, 'tsp'),    // teaspoons
  custom(8, '');    // User-defined unit

  final int value;
  final String abbreviation;
  const DosageUnit(this.value, this.abbreviation);

  static DosageUnit fromValue(int value) =>
    DosageUnit.values.firstWhere((e) => e.value == value, orElse: () => mg);
}

enum SupplementTimingType {
  withEvent(0),
  beforeEvent(1),
  afterEvent(2),
  specificTime(3);

  final int value;
  const SupplementTimingType(this.value);

  static SupplementTimingType fromValue(int value) =>
    SupplementTimingType.values.firstWhere((e) => e.value == value, orElse: () => withEvent);
}

enum SupplementFrequencyType {
  daily(0),
  everyXDays(1),
  specificWeekdays(2);

  final int value;
  const SupplementFrequencyType(this.value);

  static SupplementFrequencyType fromValue(int value) =>
    SupplementFrequencyType.values.firstWhere((e) => e.value == value, orElse: () => daily);
}

// Document type enum
enum DocumentType {
  medical(0),
  prescription(1),
  lab(2),
  other(3);

  final int value;
  const DocumentType(this.value);

  static DocumentType fromValue(int value) =>
    DocumentType.values.firstWhere((e) => e.value == value, orElse: () => other);
}

// Authorization and scope enums (for profile sharing)
// See 35_QR_DEVICE_PAIRING.md Section 8.4 for full context

/// DataScope defines which data types can be accessed via a HIPAA authorization
enum DataScope {
  conditions(0),        // Health conditions and symptom logs
  supplements(1),       // Supplement definitions and intake logs
  food(2),              // Food items and meal logs
  sleep(3),             // Sleep entries
  activities(4),        // Activity definitions and logs
  fluids(5),            // Fluids tracking (water, bowel, urine, menstruation, BBT)
  photos(6),            // Photo documentation (requires explicit consent)
  journal(7),           // Journal entries
  reports(8),           // Generated reports
  insights(9);          // Intelligence system insights and patterns

  final int value;
  const DataScope(this.value);
}

/// AccessLevel defines what operations are allowed on shared profiles
enum AccessLevel {
  readOnly(0),          // Can only view data within scope
  readWrite(1),         // Can view and create/update data (no delete)
  owner(2);             // Full access (profile owner)

  final int value;
  const AccessLevel(this.value);
}

/// AuthorizationDuration defines how long a HIPAA authorization is valid
enum AuthorizationDuration {
  untilRevoked(0),      // No expiration
  days30(1),            // 30 days
  days90(2),            // 90 days
  days180(3),           // 6 months
  days365(4);           // 1 year

  final int value;
  const AuthorizationDuration(this.value);

  int? get daysOrNull => switch (this) {
    AuthorizationDuration.untilRevoked => null,
    AuthorizationDuration.days30 => 30,
    AuthorizationDuration.days90 => 90,
    AuthorizationDuration.days180 => 180,
    AuthorizationDuration.days365 => 365,
  };
}

/// WriteOperation types for authorization checking
enum WriteOperation {
  create(0),
  update(1),
  softDelete(2),
  hardDelete(3);

  final int value;
  const WriteOperation(this.value);
}
```

---

## 4. Repository Interface Contracts

### 4.1 Base Repository Contract

ALL repositories MUST extend this interface pattern:

```dart
// lib/domain/repositories/base_repository_contract.dart

/// Base contract for all entity repositories.
/// ALL repositories MUST implement these exact method signatures.
abstract class EntityRepository<T, ID> {
  /// Get all entities, optionally filtered by profile.
  /// Returns empty list if none found, never null.
  Future<Result<List<T>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  });

  /// Get single entity by ID.
  /// Returns Failure(DatabaseError.notFound) if not found.
  Future<Result<T, AppError>> getById(ID id);

  /// Create new entity.
  /// Entity ID will be generated if empty.
  /// Returns created entity with generated ID and sync metadata.
  Future<Result<T, AppError>> create(T entity);

  /// Update existing entity.
  /// Returns Failure(DatabaseError.notFound) if not found.
  /// Set markDirty=false only during sync operations.
  Future<Result<T, AppError>> update(T entity, {bool markDirty = true});

  /// Soft delete entity (sets deletedAt).
  /// Returns Failure(DatabaseError.notFound) if not found.
  Future<Result<void, AppError>> delete(ID id);

  /// Permanently remove entity from database.
  /// Use only for sync cleanup. Normal deletes should use delete().
  Future<Result<void, AppError>> hardDelete(ID id);

  /// Get entities modified since timestamp (for sync).
  Future<Result<List<T>, AppError>> getModifiedSince(int since);  // Epoch ms

  /// Get entities pending sync (isDirty = true).
  Future<Result<List<T>, AppError>> getPendingSync();
}

/// Alias for EntityRepository used by intelligence and other subsystems.
/// IMPORTANT: BaseRepositoryContract and EntityRepository are interchangeable.
/// Use EntityRepository for new code; BaseRepositoryContract exists for consistency
/// with patterns used in intelligence repositories.
/// NOTE: Named BaseRepositoryContract (not BaseRepository) to avoid conflict with
/// the helper class in lib/core/repositories/base_repository.dart.
typedef BaseRepositoryContract<T, ID> = EntityRepository<T, ID>;
```

### 4.2 Base Repository SQL Implementation

**ALL data source implementations MUST follow these patterns exactly:**

```dart
// lib/data/datasources/local/base_local_data_source.dart

/// Base interface for database model classes that map entities to/from database rows.
abstract class Model<T> {
  Map<String, dynamic> toMap();
  Model<T> copyWith({
    String? id,
    int? syncCreatedAt,
    int? syncUpdatedAt,
    int? syncVersion,
    bool? syncIsDirty,
    int? syncStatus,
    int? syncDeletedAt,
  });
}

abstract class BaseLocalDataSource<T extends Syncable, M extends Model<T>> {
  final Database _database;
  final String _tableName;

  BaseLocalDataSource(this._database, this._tableName);

  // ========== getAll ==========
  // MUST: Include sync_deleted_at IS NULL for soft delete filtering
  // MUST: Support optional profileId filter
  // MUST: Support pagination with LIMIT/OFFSET
  Future<Result<List<T>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      final where = StringBuffer('sync_deleted_at IS NULL');
      final whereArgs = <Object>[];

      if (profileId != null) {
        where.write(' AND profile_id = ?');
        whereArgs.add(profileId);
      }

      final orderBy = 'sync_created_at DESC';
      final limitOffset = limit != null ? 'LIMIT $limit' : '';
      final offsetClause = offset != null ? 'OFFSET $offset' : '';

      final rows = await _database.query(
        'SELECT * FROM $_tableName WHERE $where ORDER BY $orderBy $limitOffset $offsetClause',
        whereArgs,
      );

      return Success(rows.map((row) => _fromRow(row)).toList());
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed(_tableName, e.toString(), stack));
    }
  }

  // ========== getById ==========
  // MUST: Include sync_deleted_at IS NULL
  // MUST: Return DatabaseError.notFound if not exists
  Future<Result<T, AppError>> getById(String id) async {
    try {
      final rows = await _database.query(
        'SELECT * FROM $_tableName WHERE id = ? AND sync_deleted_at IS NULL',
        [id],
      );

      if (rows.isEmpty) {
        return Failure(DatabaseError.notFound(_tableName, id));
      }

      return Success(_fromRow(rows.first));
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed(_tableName, e.toString(), stack));
    }
  }

  // ========== create ==========
  // MUST: Generate UUID if id is empty
  // MUST: Set all sync metadata columns
  // MUST: Return created entity with generated values
  Future<Result<T, AppError>> create(T entity) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final id = entity.id.isEmpty ? const Uuid().v4() : entity.id;

      final model = _toModel(entity).copyWith(
        id: id,
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncVersion: 1,
        syncIsDirty: true,
        syncStatus: SyncStatus.pending.value,
        syncDeletedAt: null,
      );

      await _database.insert(_tableName, model.toMap());

      return getById(id);
    } catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'));
      }
      return Failure(DatabaseError.insertFailed(_tableName, e.toString(), stack));
    }
  }

  // ========== update ==========
  // MUST: Check entity exists first
  // MUST: Increment sync_version
  // MUST: Set sync_is_dirty based on markDirty param
  // MUST: Update sync_updated_at timestamp
  Future<Result<T, AppError>> update(T entity, {bool markDirty = true}) async {
    try {
      // Verify exists
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) {
        return existsResult;
      }

      final existing = existsResult.valueOrNull!;
      final now = DateTime.now().millisecondsSinceEpoch;

      final model = _toModel(entity).copyWith(
        syncUpdatedAt: now,
        syncVersion: existing.syncMetadata.syncVersion + 1,
        syncIsDirty: markDirty ? true : existing.syncMetadata.syncIsDirty,
        syncStatus: markDirty ? SyncStatus.modified.value : existing.syncMetadata.syncStatus.value,
      );

      await _database.update(
        _tableName,
        model.toMap(),
        where: 'id = ? AND sync_deleted_at IS NULL',
        whereArgs: [entity.id],
      );

      return getById(entity.id);
    } catch (e, stack) {
      return Failure(DatabaseError.updateFailed(_tableName, e.toString(), stack));
    }
  }

  // ========== delete (soft delete) ==========
  // MUST: Set sync_deleted_at to current timestamp
  // MUST: Increment version and mark dirty
  // MUST: NOT physically remove the row
  Future<Result<void, AppError>> delete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      final rowsAffected = await _database.update(
        _tableName,
        {
          'sync_deleted_at': now,
          'sync_updated_at': now,
          'sync_is_dirty': 1,
          'sync_status': SyncStatus.deleted.value,
        },
        where: 'id = ? AND sync_deleted_at IS NULL',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound(_tableName, id));
      }

      return const Success(null);
    } catch (e, stack) {
      return Failure(DatabaseError.deleteFailed(_tableName, e.toString(), stack));
    }
  }

  // ========== hardDelete ==========
  // MUST: Physically remove row from database
  // MUST: Only use for sync cleanup after cloud deletion confirmed
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await _database.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound(_tableName, id));
      }

      return const Success(null);
    } catch (e, stack) {
      return Failure(DatabaseError.deleteFailed(_tableName, e.toString(), stack));
    }
  }

  // ========== getModifiedSince ==========
  // EXCEPTION: MUST NOT filter sync_deleted_at - include tombstones for sync
  // MUST: Return all records modified after timestamp
  Future<Result<List<T>, AppError>> getModifiedSince(int since) async {
    try {
      final rows = await _database.query(
        // NOTE: NO sync_deleted_at filter - sync needs tombstones
        'SELECT * FROM $_tableName WHERE sync_updated_at > ? ORDER BY sync_updated_at ASC',
        [since],
      );

      return Success(rows.map((row) => _fromRow(row)).toList());
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed(_tableName, e.toString(), stack));
    }
  }

  // ========== getPendingSync ==========
  // EXCEPTION: MUST NOT filter sync_deleted_at - include deleted for sync
  // MUST: Return all records where sync_is_dirty = 1
  Future<Result<List<T>, AppError>> getPendingSync() async {
    try {
      final rows = await _database.query(
        // NOTE: NO sync_deleted_at filter - deleted records must sync
        'SELECT * FROM $_tableName WHERE sync_is_dirty = 1 ORDER BY sync_updated_at ASC',
        [],
      );

      return Success(rows.map((row) => _fromRow(row)).toList());
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed(_tableName, e.toString(), stack));
    }
  }

  // ========== Abstract methods for subclasses ==========
  T _fromRow(Map<String, dynamic> row);
  M _toModel(T entity);
}
```

### 4.3 Specific Repository Contracts

```dart
// lib/domain/repositories/supplement_repository.dart

abstract class SupplementRepository implements EntityRepository<Supplement, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get supplements for a profile with optional active filter.
  Future<Result<List<Supplement>, AppError>> getByProfile(
    String profileId, {
    bool? activeOnly,
    int? limit,
    int? offset,
  });

  /// Get supplements due at a specific time.
  Future<Result<List<Supplement>, AppError>> getDueAt(
    String profileId,
    int time,  // Epoch ms
  );

  /// Search supplements by name.
  Future<Result<List<Supplement>, AppError>> search(
    String profileId,
    String query, {
    int limit = ValidationRules.defaultSearchLimit,
  });
}

// lib/domain/repositories/fluids_entry_repository.dart

abstract class FluidsEntryRepository implements EntityRepository<FluidsEntry, String> {
  /// Get entries for date range.
  Future<Result<List<FluidsEntry>, AppError>> getByDateRange(
    String profileId,
    int start,  // Epoch ms
    int end,    // Epoch ms
  );

  /// Get entries with BBT data for chart.
  Future<Result<List<FluidsEntry>, AppError>> getBBTEntries(
    String profileId,
    int start,  // Epoch ms
    int end,    // Epoch ms
  );

  /// Get entries with menstruation data.
  Future<Result<List<FluidsEntry>, AppError>> getMenstruationEntries(
    String profileId,
    int start,  // Epoch ms
    int end,    // Epoch ms
  );

  /// Get most recent entry for today.
  Future<Result<FluidsEntry?, AppError>> getTodayEntry(String profileId);
}

// NOTE: NotificationScheduleRepository is defined in Section 8.2 below
```

---

## 4.5 Use Case Contracts

### 4.1 Use Case Base Pattern

ALL use cases MUST follow this exact pattern:

```dart
// lib/domain/usecases/base_use_case.dart

/// Base class for use cases with single input and output.
abstract class UseCase<Input, Output> {
  Future<Result<Output, AppError>> call(Input input);
}

/// Base class for use cases with no input.
abstract class UseCaseNoInput<Output> {
  Future<Result<Output, AppError>> call();
}

/// Base class for use cases with no output.
abstract class UseCaseNoOutput<Input> {
  Future<Result<void, AppError>> call(Input input);
}

/// Alternate naming convention for UseCase (output, input order).
/// Used by intelligence and wearable subsystems for consistency
/// with their existing patterns. Functionally identical to UseCase.
///
/// NOTE: The type parameter order is <Output, Input> (reversed from UseCase).
abstract class UseCaseWithInput<Output, Input> {
  Future<Result<Output, AppError>> call(Input input);
}
```

### 4.2 Specific Use Case Contracts

```dart
// lib/domain/usecases/supplements/get_supplements_use_case.dart

/// NOTE: All use case input types MUST use @freezed for immutability
/// and code generation. This ensures consistent hashCode/equals and
/// enables pattern matching in tests.

@freezed
class GetSupplementsInput with _$GetSupplementsInput {
  const factory GetSupplementsInput({
    required String profileId,
    bool? activeOnly,
    int? limit,
    int? offset,
  }) = _GetSupplementsInput;
}

class GetSupplementsUseCase implements UseCase<GetSupplementsInput, List<Supplement>> {
  final SupplementRepository _repository;
  final ProfileAuthorizationService _authService;

  GetSupplementsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<Supplement>, AppError>> call(GetSupplementsInput input) async {
    // 1. Check authorization FIRST
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Execute repository call
    return _repository.getByProfile(
      input.profileId,
      activeOnly: input.activeOnly,
      limit: input.limit,
      offset: input.offset,
    );
  }
}

// lib/domain/usecases/supplements/get_supplement_by_id_use_case.dart

class GetSupplementByIdUseCase implements UseCase<String, Supplement?> {
  final SupplementRepository _repository;
  final ProfileAuthorizationService _authService;

  GetSupplementByIdUseCase(this._repository, this._authService);

  @override
  Future<Result<Supplement?, AppError>> call(String id) async {
    final result = await _repository.getById(id);
    if (result.isFailure) return Failure(result.errorOrNull!);
    final supplement = result.valueOrNull;
    if (supplement != null && !await _authService.canRead(supplement.profileId)) {
      return Failure(AuthError.profileAccessDenied(supplement.profileId));
    }
    return Success(supplement);
  }
}

@riverpod
GetSupplementByIdUseCase getSupplementByIdUseCase(Ref ref) =>
    GetSupplementByIdUseCase(
      ref.read(supplementRepositoryProvider),
      ref.read(profileAuthServiceProvider),
    );

@riverpod
DeleteEntityUseCase deleteSupplementUseCase(Ref ref) =>
    DeleteEntityUseCase(
      ref.read(supplementRepositoryProvider),
      ref.read(profileAuthServiceProvider),
    );

@riverpod
DeleteEntityUseCase deleteNotificationScheduleUseCase(Ref ref) =>
    DeleteEntityUseCase(
      ref.read(notificationScheduleRepositoryProvider),
      ref.read(profileAuthServiceProvider),
    );

// lib/domain/usecases/notifications/get_notification_schedules_use_case.dart

@freezed
class GetNotificationSchedulesInput with _$GetNotificationSchedulesInput {
  const factory GetNotificationSchedulesInput({
    required String profileId,
  }) = _GetNotificationSchedulesInput;
}

class GetNotificationSchedulesUseCase
    implements UseCase<GetNotificationSchedulesInput, List<NotificationSchedule>> {
  final NotificationScheduleRepository _repository;
  final ProfileAuthorizationService _authService;

  GetNotificationSchedulesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<NotificationSchedule>, AppError>> call(
    GetNotificationSchedulesInput input,
  ) async {
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }
    return _repository.getByProfile(input.profileId);
  }
}

@riverpod
GetNotificationSchedulesUseCase getNotificationSchedulesUseCase(Ref ref) =>
    GetNotificationSchedulesUseCase(
      ref.read(notificationScheduleRepositoryProvider),
      ref.read(profileAuthServiceProvider),
    );

// lib/domain/usecases/auth/get_current_user_use_case.dart

class GetCurrentUserUseCase implements UseCaseNoInput<UserAccount?> {
  final UserAccountRepository _repository;
  final AuthTokenService _tokenService;

  GetCurrentUserUseCase(this._repository, this._tokenService);

  @override
  Future<Result<UserAccount?, AppError>> call() async {
    final userId = await _tokenService.getCurrentUserId();
    if (userId == null) {
      return const Success(null);
    }
    return _repository.getById(userId);
  }
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) =>
    GetCurrentUserUseCase(
      ref.read(userAccountRepositoryProvider),
      ref.read(authTokenServiceProvider),
    );

// lib/domain/usecases/profiles/profile_use_cases.dart

@freezed
class CreateProfileInput with _$CreateProfileInput {
  const factory CreateProfileInput({
    required String clientId,
    required String ownerId,
    required String name,
    BiologicalSex? biologicalSex,
    int? birthDate,               // Epoch milliseconds
    @Default(ProfileDietType.none) ProfileDietType dietType,
    String? dietDescription,
    String? ethnicity,
    String? notes,
  }) = _CreateProfileInput;
}

@freezed
class DeleteProfileInput with _$DeleteProfileInput {
  const factory DeleteProfileInput({
    required String profileId,
  }) = _DeleteProfileInput;
}

@freezed
class UpdateProfileInput with _$UpdateProfileInput {
  const factory UpdateProfileInput({
    required String profileId,
    String? name,
    BiologicalSex? biologicalSex,
    int? birthDate,               // Epoch milliseconds
    ProfileDietType? dietType,
    String? dietDescription,
    String? ethnicity,
    String? notes,
    int? waterGoalMl,             // Used by FluidsEntryList.setWaterGoal
  }) = _UpdateProfileInput;
}

class GetAccessibleProfilesUseCase implements UseCaseNoInput<List<Profile>> {
  final ProfileRepository _repository;
  final UserAccountRepository _userRepository;
  final AuthTokenService _tokenService;

  GetAccessibleProfilesUseCase(this._repository, this._userRepository, this._tokenService);

  @override
  Future<Result<List<Profile>, AppError>> call() async {
    final userId = await _tokenService.getCurrentUserId();
    if (userId == null) {
      return Failure(AuthError.notAuthenticated());
    }
    return _repository.getByOwner(userId);
  }
}

class SetCurrentProfileUseCase implements UseCase<String, void> {
  final ProfileRepository _repository;
  final AuthTokenService _tokenService;

  SetCurrentProfileUseCase(this._repository, this._tokenService);

  @override
  Future<Result<void, AppError>> call(String profileId) async {
    final userId = await _tokenService.getCurrentUserId();
    if (userId == null) {
      return Failure(AuthError.notAuthenticated());
    }
    // Verify profile belongs to user
    final profileResult = await _repository.getById(profileId);
    if (profileResult.isFailure) return Failure(profileResult.errorOrNull!);
    final profile = profileResult.valueOrNull;
    if (profile == null || profile.ownerId != userId) {
      return Failure(AuthError.profileAccessDenied(profileId));
    }
    // Persist selection (stored locally)
    return const Success(null);
  }
}

class CreateProfileUseCase implements UseCase<CreateProfileInput, Profile> {
  final ProfileRepository _repository;
  final AuthTokenService _tokenService;

  CreateProfileUseCase(this._repository, this._tokenService);

  @override
  Future<Result<Profile, AppError>> call(CreateProfileInput input) async {
    final userId = await _tokenService.getCurrentUserId();
    if (userId == null) {
      return Failure(AuthError.notAuthenticated());
    }
    if (input.ownerId != userId) {
      return Failure(AuthError.profileAccessDenied(input.ownerId));
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final id = const Uuid().v4();

    final profile = Profile(
      id: id,
      clientId: input.clientId,
      ownerId: input.ownerId,
      name: input.name,
      biologicalSex: input.biologicalSex,
      birthDate: input.birthDate,
      dietType: input.dietType,
      dietDescription: input.dietDescription,
      ethnicity: input.ethnicity,
      notes: input.notes,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '',
      ),
    );

    return _repository.create(profile);
  }
}

class DeleteProfileUseCase implements UseCase<DeleteProfileInput, void> {
  final ProfileRepository _repository;
  final ProfileAuthorizationService _authService;

  DeleteProfileUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(DeleteProfileInput input) async {
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }
    return _repository.delete(input.profileId);
  }
}

class UpdateProfileUseCase implements UseCase<UpdateProfileInput, Profile> {
  final ProfileRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateProfileUseCase(this._repository, this._authService);

  @override
  Future<Result<Profile, AppError>> call(UpdateProfileInput input) async {
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    final existingResult = await _repository.getById(input.profileId);
    if (existingResult.isFailure) return Failure(existingResult.errorOrNull!);
    final existing = existingResult.valueOrNull!;

    final now = DateTime.now().millisecondsSinceEpoch;
    final updated = existing.copyWith(
      name: input.name ?? existing.name,
      biologicalSex: input.biologicalSex ?? existing.biologicalSex,
      birthDate: input.birthDate ?? existing.birthDate,
      dietType: input.dietType ?? existing.dietType,
      dietDescription: input.dietDescription ?? existing.dietDescription,
      ethnicity: input.ethnicity ?? existing.ethnicity,
      notes: input.notes ?? existing.notes,
      syncMetadata: existing.syncMetadata.copyWith(
        syncUpdatedAt: now,
        syncVersion: existing.syncMetadata.syncVersion + 1,
        syncIsDirty: true,
      ),
    );

    return _repository.update(updated);
  }
}

@riverpod
GetAccessibleProfilesUseCase getAccessibleProfilesUseCase(Ref ref) =>
    GetAccessibleProfilesUseCase(
      ref.read(profileRepositoryProvider),
      ref.read(userAccountRepositoryProvider),
      ref.read(authTokenServiceProvider),
    );

@riverpod
SetCurrentProfileUseCase setCurrentProfileUseCase(Ref ref) =>
    SetCurrentProfileUseCase(
      ref.read(profileRepositoryProvider),
      ref.read(authTokenServiceProvider),
    );

@riverpod
CreateProfileUseCase createProfileUseCase(Ref ref) =>
    CreateProfileUseCase(
      ref.read(profileRepositoryProvider),
      ref.read(authTokenServiceProvider),
    );

@riverpod
DeleteProfileUseCase deleteProfileUseCase(Ref ref) =>
    DeleteProfileUseCase(
      ref.read(profileRepositoryProvider),
      ref.read(profileAuthServiceProvider),
    );

@riverpod
UpdateProfileUseCase updateProfileUseCase(Ref ref) =>
    UpdateProfileUseCase(
      ref.read(profileRepositoryProvider),
      ref.read(profileAuthServiceProvider),
    );

// lib/domain/usecases/fluids/log_fluids_entry_use_case.dart

@freezed
class LogFluidsEntryInput with _$LogFluidsEntryInput {
  const factory LogFluidsEntryInput({
    required String profileId,
    required String clientId,           // Required for database merging
    required int entryDate,             // Epoch milliseconds

    // Water intake
    int? waterIntakeMl,
    String? waterIntakeNotes,

    // Bowel
    BowelCondition? bowelCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,             // Optional photo attachment

    // Urine
    UrineCondition? urineCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,             // Optional photo attachment

    // Menstruation
    MenstruationFlow? menstruationFlow,

    // BBT
    double? basalBodyTemperature,
    int? bbtRecordedTime,               // Epoch milliseconds

    // Custom "Other" fluid
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,

    @Default('') String notes,          // Matches entity pattern
  }) = _LogFluidsEntryInput;
}

class LogFluidsEntryUseCase implements UseCase<LogFluidsEntryInput, FluidsEntry> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;
  LogFluidsEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<FluidsEntry, AppError>> call(LogFluidsEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final entry = FluidsEntry(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      entryDate: input.entryDate,
      waterIntakeMl: input.waterIntakeMl,
      waterIntakeNotes: input.waterIntakeNotes,
      bowelCondition: input.bowelCondition,
      bowelSize: input.bowelSize,
      bowelPhotoPath: input.bowelPhotoPath,
      urineCondition: input.urineCondition,
      urineSize: input.urineSize,
      urinePhotoPath: input.urinePhotoPath,
      menstruationFlow: input.menstruationFlow,
      basalBodyTemperature: input.basalBodyTemperature,
      bbtRecordedTime: input.bbtRecordedTime,
      otherFluidName: input.otherFluidName,
      otherFluidAmount: input.otherFluidAmount,
      otherFluidNotes: input.otherFluidNotes,
      notes: input.notes,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(entry);
  }

  ValidationError? _validate(LogFluidsEntryInput input) {
    final errors = <String, List<String>>{};

    // At least one data point required
    if (input.waterIntakeMl == null &&
        input.bowelCondition == null &&
        input.urineCondition == null &&
        input.menstruationFlow == null &&
        input.basalBodyTemperature == null &&
        input.otherFluidName == null) {
      errors['general'] = ['At least one measurement is required'];
    }

    // Water intake validation
    if (input.waterIntakeMl != null) {
      if (input.waterIntakeMl! < 0 || input.waterIntakeMl! > 10000) {
        errors['waterIntakeMl'] = ['Water intake must be between 0 and 10000 mL'];
      }
    }

    // BBT range validation
    if (input.basalBodyTemperature != null) {
      if (input.basalBodyTemperature! < 95.0 || input.basalBodyTemperature! > 105.0) {
        errors['basalBodyTemperature'] = ['Temperature must be between 95°F and 105°F'];
      }
    }

    // BBT requires recorded time
    if (input.basalBodyTemperature != null && input.bbtRecordedTime == null) {
      errors['bbtRecordedTime'] = ['Recording time is required for BBT'];
    }

    // Other fluid requires name if amount or notes provided (defensive check for empty strings)
    if ((input.otherFluidAmount != null && input.otherFluidAmount!.isNotEmpty) ||
        (input.otherFluidNotes != null && input.otherFluidNotes!.isNotEmpty)) {
      if (input.otherFluidName == null || input.otherFluidName!.isEmpty) {
        errors['otherFluidName'] = ['Fluid name is required when amount or notes are provided'];
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

// lib/domain/usecases/fluids_entries/get_fluids_entries_use_case.dart

@freezed
class GetFluidsEntriesInput with _$GetFluidsEntriesInput {
  const factory GetFluidsEntriesInput({
    required String profileId,
    required int startDate,       // Epoch milliseconds
    required int endDate,         // Epoch milliseconds
  }) = _GetFluidsEntriesInput;
}

/// Use case to get fluids entries by date range.
class GetFluidsEntriesUseCase implements UseCase<GetFluidsEntriesInput, List<FluidsEntry>> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetFluidsEntriesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<FluidsEntry>, AppError>> call(GetFluidsEntriesInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    if (input.startDate > input.endDate) {
      return Failure(
        ValidationError.fromFieldErrors({
          'dateRange': ['Start date must be before or equal to end date'],
        }),
      );
    }

    // 3. Repository call
    return _repository.getByDateRange(input.profileId, input.startDate, input.endDate);
  }
}

// lib/domain/usecases/fluids_entries/get_today_fluids_entry_use_case.dart

@freezed
class GetTodayFluidsEntryInput with _$GetTodayFluidsEntryInput {
  const factory GetTodayFluidsEntryInput({
    required String profileId,
  }) = _GetTodayFluidsEntryInput;
}

/// Use case to get today's fluids entry.
class GetTodayFluidsEntryUseCase implements UseCase<GetTodayFluidsEntryInput, FluidsEntry?> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetTodayFluidsEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<FluidsEntry?, AppError>> call(GetTodayFluidsEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Repository call
    return _repository.getTodayEntry(input.profileId);
  }
}

// lib/domain/usecases/sleep_entries/sleep_entry_inputs.dart

@freezed
class LogSleepEntryInput with _$LogSleepEntryInput {
  const factory LogSleepEntryInput({
    required String profileId,
    required String clientId,
    required int bedTime,             // Epoch milliseconds

    // Wake time is optional (user may log bed time first, wake time later)
    int? wakeTime,                    // Epoch milliseconds

    // Sleep stages (optional, may come from wearable import)
    @Default(0) int deepSleepMinutes,
    @Default(0) int lightSleepMinutes,
    @Default(0) int restlessSleepMinutes,

    // Dream and feeling
    @Default(DreamType.noDreams) DreamType dreamType,
    @Default(WakingFeeling.neutral) WakingFeeling wakingFeeling,

    // Notes
    @Default('') String notes,

    // Import tracking (for wearable data)
    String? importSource,             // 'healthkit', 'googlefit', 'apple_watch', etc.
    String? importExternalId,         // External record ID for deduplication
  }) = _LogSleepEntryInput;
}

class LogSleepEntryUseCase implements UseCase<LogSleepEntryInput, SleepEntry> {
  final SleepEntryRepository _repository;
  final ProfileAuthorizationService _authService;
  LogSleepEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<SleepEntry, AppError>> call(LogSleepEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final entry = SleepEntry(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      bedTime: input.bedTime,
      wakeTime: input.wakeTime,
      deepSleepMinutes: input.deepSleepMinutes,
      lightSleepMinutes: input.lightSleepMinutes,
      restlessSleepMinutes: input.restlessSleepMinutes,
      dreamType: input.dreamType,
      wakingFeeling: input.wakingFeeling,
      notes: input.notes,
      importSource: input.importSource,
      importExternalId: input.importExternalId,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(entry);
  }

  ValidationError? _validate(LogSleepEntryInput input) {
    final errors = <String, List<String>>{};

    // Bed time validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
    if (input.bedTime > oneHourFromNow) {
      errors['bedTime'] = ['Bed time cannot be more than 1 hour in the future'];
    }

    // Wake time must be after bed time
    if (input.wakeTime != null) {
      if (input.wakeTime! <= input.bedTime) {
        errors['wakeTime'] = ['Wake time must be after bed time'];
      }
      // Max 24 hours of sleep
      final maxWakeTime = input.bedTime + (24 * 60 * 60 * 1000);
      if (input.wakeTime! > maxWakeTime) {
        errors['wakeTime'] = ['Sleep duration cannot exceed 24 hours'];
      }
    }

    // Sleep stage minutes must be non-negative
    if (input.deepSleepMinutes < 0) {
      errors['deepSleepMinutes'] = ['Deep sleep minutes cannot be negative'];
    }
    if (input.lightSleepMinutes < 0) {
      errors['lightSleepMinutes'] = ['Light sleep minutes cannot be negative'];
    }
    if (input.restlessSleepMinutes < 0) {
      errors['restlessSleepMinutes'] = ['Restless sleep minutes cannot be negative'];
    }

    // Sleep stages should not exceed total sleep time
    if (input.wakeTime != null) {
      final totalSleepMinutes = ((input.wakeTime! - input.bedTime) / 60000).round();
      final stagesTotal = input.deepSleepMinutes + input.lightSleepMinutes + input.restlessSleepMinutes;
      if (stagesTotal > totalSleepMinutes) {
        errors['sleepStages'] = ['Sleep stage minutes cannot exceed total sleep time'];
      }
    }

    // Notes length validation
    if (input.notes.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

@freezed
class GetSleepEntriesInput with _$GetSleepEntriesInput {
  const factory GetSleepEntriesInput({
    required String profileId,
    int? startDate,                   // Epoch milliseconds
    int? endDate,                     // Epoch milliseconds
    int? limit,
    int? offset,
  }) = _GetSleepEntriesInput;
}

@freezed
class UpdateSleepEntryInput with _$UpdateSleepEntryInput {
  const factory UpdateSleepEntryInput({
    required String id,
    required String profileId,
    int? bedTime,
    int? wakeTime,
    int? deepSleepMinutes,
    int? lightSleepMinutes,
    int? restlessSleepMinutes,
    DreamType? dreamType,
    WakingFeeling? wakingFeeling,
    String? notes,
    String? importSource,
    String? importExternalId,
  }) = _UpdateSleepEntryInput;
}

@freezed
class DeleteSleepEntryInput with _$DeleteSleepEntryInput {
  const factory DeleteSleepEntryInput({
    required String id,
    required String profileId,
  }) = _DeleteSleepEntryInput;
}

// lib/domain/usecases/activities/activity_inputs.dart

@freezed
class CreateActivityInput with _$CreateActivityInput {
  const factory CreateActivityInput({
    required String profileId,
    required String clientId,
    required String name,
    String? description,
    String? location,
    String? triggers,                 // Comma-separated trigger descriptions
    required int durationMinutes,
  }) = _CreateActivityInput;
}

class CreateActivityUseCase implements UseCase<CreateActivityInput, Activity> {
  final ActivityRepository _repository;
  final ProfileAuthorizationService _authService;

  @override
  Future<Result<Activity, AppError>> call(CreateActivityInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final activity = Activity(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      description: input.description,
      location: input.location,
      triggers: input.triggers,
      durationMinutes: input.durationMinutes,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(activity);
  }

  ValidationError? _validate(CreateActivityInput input) {
    final errors = <String, List<String>>{};

    // Name validation: 2-100 characters
    if (input.name.length < 2 || input.name.length > 100) {
      errors['name'] = ['Activity name must be 2-100 characters'];
    }

    // Duration validation: 1-1440 minutes (max 24 hours)
    if (input.durationMinutes < 1 || input.durationMinutes > 1440) {
      errors['durationMinutes'] = ['Duration must be between 1 and 1440 minutes'];
    }

    // Description max length
    if (input.description != null && input.description!.length > 1000) {
      errors['description'] = ['Description must be 1000 characters or less'];
    }

    // Location max length
    if (input.location != null && input.location!.length > 200) {
      errors['location'] = ['Location must be 200 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

@freezed
class GetActivitiesInput with _$GetActivitiesInput {
  const factory GetActivitiesInput({
    required String profileId,
    @Default(false) bool includeArchived,
    int? limit,
    int? offset,
  }) = _GetActivitiesInput;
}

@freezed
class UpdateActivityInput with _$UpdateActivityInput {
  const factory UpdateActivityInput({
    required String id,
    required String profileId,
    String? name,
    String? description,
    String? location,
    String? triggers,
    int? durationMinutes,
  }) = _UpdateActivityInput;
}

@freezed
class ArchiveActivityInput with _$ArchiveActivityInput {
  const factory ArchiveActivityInput({
    required String id,
    required String profileId,
    @Default(true) bool archive,      // false to unarchive
  }) = _ArchiveActivityInput;
}

// lib/domain/usecases/activity_logs/activity_log_inputs.dart

@freezed
class LogActivityInput with _$LogActivityInput {
  const factory LogActivityInput({
    required String profileId,
    required String clientId,
    required int timestamp,           // Epoch milliseconds
    @Default([]) List<String> activityIds,
    @Default([]) List<String> adHocActivities,
    int? duration,                    // Actual duration if different from planned
    @Default('') String notes,
    String? importSource,
    String? importExternalId,
  }) = _LogActivityInput;
}

class LogActivityUseCase implements UseCase<LogActivityInput, ActivityLog> {
  final ActivityLogRepository _repository;
  final ActivityRepository _activityRepository;
  final ProfileAuthorizationService _authService;

  @override
  Future<Result<ActivityLog, AppError>> call(LogActivityInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = await _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final log = ActivityLog(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      timestamp: input.timestamp,
      activityIds: input.activityIds,
      adHocActivities: input.adHocActivities,
      duration: input.duration,
      notes: input.notes,
      importSource: input.importSource,
      importExternalId: input.importExternalId,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(log);
  }

  Future<ValidationError?> _validate(LogActivityInput input) async {
    final errors = <String, List<String>>{};

    // Must have at least one activity (predefined or ad-hoc)
    if (input.activityIds.isEmpty && input.adHocActivities.isEmpty) {
      errors['activities'] = ['At least one activity is required'];
    }

    // Timestamp validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
    if (input.timestamp > oneHourFromNow) {
      errors['timestamp'] = ['Timestamp cannot be more than 1 hour in the future'];
    }

    // Duration validation if provided (1-1440 minutes)
    if (input.duration != null) {
      if (input.duration! < 1 || input.duration! > 1440) {
        errors['duration'] = ['Duration must be between 1 and 1440 minutes'];
      }
    }

    // Notes max length
    if (input.notes.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    // Verify activity IDs exist and belong to profile
    for (final activityId in input.activityIds) {
      final result = await _activityRepository.getById(activityId);
      if (result.isFailure) {
        errors['activityIds'] = ['Activity not found: $activityId'];
        break;
      }
      final activity = result.valueOrNull!;
      if (activity.profileId != input.profileId) {
        errors['activityIds'] = ['Activity does not belong to this profile'];
        break;
      }
    }

    // Validate ad-hoc activity names (2-100 characters each)
    for (final name in input.adHocActivities) {
      if (name.length < 2 || name.length > 100) {
        errors['adHocActivities'] = ['Ad-hoc activity names must be 2-100 characters'];
        break;
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

@freezed
class GetActivityLogsInput with _$GetActivityLogsInput {
  const factory GetActivityLogsInput({
    required String profileId,
    int? startDate,                   // Epoch milliseconds
    int? endDate,                     // Epoch milliseconds
    int? limit,
    int? offset,
  }) = _GetActivityLogsInput;
}

@freezed
class UpdateActivityLogInput with _$UpdateActivityLogInput {
  const factory UpdateActivityLogInput({
    required String id,
    required String profileId,
    List<String>? activityIds,
    List<String>? adHocActivities,
    int? duration,
    String? notes,
  }) = _UpdateActivityLogInput;
}

@freezed
class DeleteActivityLogInput with _$DeleteActivityLogInput {
  const factory DeleteActivityLogInput({
    required String id,
    required String profileId,
  }) = _DeleteActivityLogInput;
}
```

### 4.3.7 FoodItem Use Cases (P0 - Food)

```dart
// lib/domain/usecases/food_items/food_item_inputs.dart

@freezed
class CreateFoodItemInput with _$CreateFoodItemInput {
  const factory CreateFoodItemInput({
    required String profileId,
    required String clientId,
    required String name,
    @Default(FoodItemType.simple) FoodItemType type,
    @Default([]) List<String> simpleItemIds,  // For complex items
    String? servingSize,
    double? calories,
    double? carbsGrams,
    double? fatGrams,
    double? proteinGrams,
    double? fiberGrams,
    double? sugarGrams,
  }) = _CreateFoodItemInput;
}

class CreateFoodItemUseCase implements UseCase<CreateFoodItemInput, FoodItem> {
  final FoodItemRepository _repository;
  final ProfileAuthorizationService _authService;

  @override
  Future<Result<FoodItem, AppError>> call(CreateFoodItemInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = await _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final foodItem = FoodItem(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      type: input.type,
      simpleItemIds: input.simpleItemIds,
      servingSize: input.servingSize,
      calories: input.calories,
      carbsGrams: input.carbsGrams,
      fatGrams: input.fatGrams,
      proteinGrams: input.proteinGrams,
      fiberGrams: input.fiberGrams,
      sugarGrams: input.sugarGrams,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(foodItem);
  }

  Future<ValidationError?> _validate(CreateFoodItemInput input) async {
    final errors = <String, List<String>>{};

    // Name validation: 2-100 characters
    if (input.name.length < 2 || input.name.length > 100) {
      errors['name'] = ['Food item name must be 2-100 characters'];
    }

    // Complex items must have simple item IDs
    if (input.type == FoodItemType.complex && input.simpleItemIds.isEmpty) {
      errors['simpleItemIds'] = ['Complex items must include at least one simple item'];
    }

    // Simple items should not have simple item IDs
    if (input.type == FoodItemType.simple && input.simpleItemIds.isNotEmpty) {
      errors['simpleItemIds'] = ['Simple items cannot have component items'];
    }

    // Verify simple item IDs exist and belong to profile (only for complex items)
    if (input.type == FoodItemType.complex) {
      for (final itemId in input.simpleItemIds) {
        final result = await _repository.getById(itemId);
        if (result.isFailure) {
          errors['simpleItemIds'] = ['Food item not found: $itemId'];
          break;
        }
        final item = result.valueOrNull!;
        if (item.profileId != input.profileId) {
          errors['simpleItemIds'] = ['Food item does not belong to this profile'];
          break;
        }
        // Prevent nesting complex items
        if (item.isComplex) {
          errors['simpleItemIds'] = ['Cannot nest complex items'];
          break;
        }
      }
    }

    // Nutritional values must be non-negative if provided
    if (input.calories != null && input.calories! < 0) {
      errors['calories'] = ['Calories cannot be negative'];
    }
    if (input.carbsGrams != null && input.carbsGrams! < 0) {
      errors['carbsGrams'] = ['Carbs cannot be negative'];
    }
    if (input.fatGrams != null && input.fatGrams! < 0) {
      errors['fatGrams'] = ['Fat cannot be negative'];
    }
    if (input.proteinGrams != null && input.proteinGrams! < 0) {
      errors['proteinGrams'] = ['Protein cannot be negative'];
    }
    if (input.fiberGrams != null && input.fiberGrams! < 0) {
      errors['fiberGrams'] = ['Fiber cannot be negative'];
    }
    if (input.sugarGrams != null && input.sugarGrams! < 0) {
      errors['sugarGrams'] = ['Sugar cannot be negative'];
    }

    // Serving size max length
    if (input.servingSize != null && input.servingSize!.length > 50) {
      errors['servingSize'] = ['Serving size must be 50 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

@freezed
class GetFoodItemsInput with _$GetFoodItemsInput {
  const factory GetFoodItemsInput({
    required String profileId,
    FoodItemType? type,
    @Default(false) bool includeArchived,
    int? limit,
    int? offset,
  }) = _GetFoodItemsInput;
}

@freezed
class SearchFoodItemsInput with _$SearchFoodItemsInput {
  const factory SearchFoodItemsInput({
    required String profileId,
    required String query,
    @Default(20) int limit,
  }) = _SearchFoodItemsInput;
}

@freezed
class UpdateFoodItemInput with _$UpdateFoodItemInput {
  const factory UpdateFoodItemInput({
    required String id,
    required String profileId,
    String? name,
    FoodItemType? type,
    List<String>? simpleItemIds,
    String? servingSize,
    double? calories,
    double? carbsGrams,
    double? fatGrams,
    double? proteinGrams,
    double? fiberGrams,
    double? sugarGrams,
  }) = _UpdateFoodItemInput;
}

@freezed
class ArchiveFoodItemInput with _$ArchiveFoodItemInput {
  const factory ArchiveFoodItemInput({
    required String id,
    required String profileId,
    @Default(true) bool archive,      // false to unarchive
  }) = _ArchiveFoodItemInput;
}
```

### 4.3.8 FoodLog Use Cases (P0 - Food)

```dart
// lib/domain/usecases/food_logs/food_log_inputs.dart

@freezed
class LogFoodInput with _$LogFoodInput {
  const factory LogFoodInput({
    required String profileId,
    required String clientId,
    required int timestamp,           // Epoch milliseconds
    MealType? mealType,
    @Default([]) List<String> foodItemIds,
    @Default([]) List<String> adHocItems,
    @Default('') String notes,
  }) = _LogFoodInput;
}

class LogFoodUseCase implements UseCase<LogFoodInput, FoodLog> {
  final FoodLogRepository _repository;
  final FoodItemRepository _foodItemRepository;
  final ProfileAuthorizationService _authService;

  @override
  Future<Result<FoodLog, AppError>> call(LogFoodInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = await _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final log = FoodLog(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      timestamp: input.timestamp,
      foodItemIds: input.foodItemIds,
      adHocItems: input.adHocItems,
      notes: input.notes.isEmpty ? null : input.notes,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(log);
  }

  Future<ValidationError?> _validate(LogFoodInput input) async {
    final errors = <String, List<String>>{};

    // Must have at least one food item (predefined or ad-hoc)
    if (input.foodItemIds.isEmpty && input.adHocItems.isEmpty) {
      errors['items'] = ['At least one food item is required'];
    }

    // Timestamp validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
    if (input.timestamp > oneHourFromNow) {
      errors['timestamp'] = ['Timestamp cannot be more than 1 hour in the future'];
    }

    // Notes max length
    if (input.notes.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    // Verify food item IDs exist and belong to profile
    for (final itemId in input.foodItemIds) {
      final result = await _foodItemRepository.getById(itemId);
      if (result.isFailure) {
        errors['foodItemIds'] = ['Food item not found: $itemId'];
        break;
      }
      final item = result.valueOrNull!;
      if (item.profileId != input.profileId) {
        errors['foodItemIds'] = ['Food item does not belong to this profile'];
        break;
      }
    }

    // Validate ad-hoc item names (2-100 characters each)
    for (final name in input.adHocItems) {
      if (name.length < 2 || name.length > 100) {
        errors['adHocItems'] = ['Ad-hoc item names must be 2-100 characters'];
        break;
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

@freezed
class GetFoodLogsInput with _$GetFoodLogsInput {
  const factory GetFoodLogsInput({
    required String profileId,
    int? startDate,                   // Epoch milliseconds
    int? endDate,                     // Epoch milliseconds
    int? limit,
    int? offset,
  }) = _GetFoodLogsInput;
}

@freezed
class UpdateFoodLogInput with _$UpdateFoodLogInput {
  const factory UpdateFoodLogInput({
    required String id,
    required String profileId,
    MealType? mealType,
    List<String>? foodItemIds,
    List<String>? adHocItems,
    String? notes,
  }) = _UpdateFoodLogInput;
}

@freezed
class DeleteFoodLogInput with _$DeleteFoodLogInput {
  const factory DeleteFoodLogInput({
    required String id,
    required String profileId,
  }) = _DeleteFoodLogInput;
}
```

### 4.3.9 JournalEntry Use Cases (P1)

```dart
// lib/domain/usecases/journal_entries/journal_entry_inputs.dart

@freezed
class CreateJournalEntryInput with _$CreateJournalEntryInput {
  const factory CreateJournalEntryInput({
    required String profileId,
    required String clientId,
    required int timestamp,           // Epoch milliseconds
    required String content,
    String? title,
    int? mood,                        // 1-10 rating
    @Default([]) List<String> tags,
    String? audioUrl,
  }) = _CreateJournalEntryInput;
}

class CreateJournalEntryUseCase implements UseCase<CreateJournalEntryInput, JournalEntry> {
  final JournalEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  @override
  Future<Result<JournalEntry, AppError>> call(CreateJournalEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final entry = JournalEntry(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      timestamp: input.timestamp,
      content: input.content,
      title: input.title,
      mood: input.mood,
      tags: input.tags.isEmpty ? null : input.tags,
      audioUrl: input.audioUrl,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(entry);
  }

  ValidationError? _validate(CreateJournalEntryInput input) {
    final errors = <String, List<String>>{};

    // Content validation: 1-50000 characters
    if (input.content.isEmpty || input.content.length > 50000) {
      errors['content'] = ['Content must be 1-50000 characters'];
    }

    // Title validation: 1-200 characters if provided
    if (input.title != null && (input.title!.isEmpty || input.title!.length > 200)) {
      errors['title'] = ['Title must be 1-200 characters'];
    }

    // Mood validation: 1-10 if provided
    if (input.mood != null && (input.mood! < 1 || input.mood! > 10)) {
      errors['mood'] = ['Mood must be between 1 and 10'];
    }

    // Timestamp validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
    if (input.timestamp > oneHourFromNow) {
      errors['timestamp'] = ['Timestamp cannot be more than 1 hour in the future'];
    }

    // Tags validation: each tag 1-50 characters
    for (final tag in input.tags) {
      if (tag.isEmpty || tag.length > 50) {
        errors['tags'] = ['Each tag must be 1-50 characters'];
        break;
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

@freezed
class GetJournalEntriesInput with _$GetJournalEntriesInput {
  const factory GetJournalEntriesInput({
    required String profileId,
    int? startDate,                   // Epoch milliseconds
    int? endDate,                     // Epoch milliseconds
    List<String>? tags,
    int? mood,
    int? limit,
    int? offset,
  }) = _GetJournalEntriesInput;
}

@freezed
class SearchJournalEntriesInput with _$SearchJournalEntriesInput {
  const factory SearchJournalEntriesInput({
    required String profileId,
    required String query,
  }) = _SearchJournalEntriesInput;
}

@freezed
class UpdateJournalEntryInput with _$UpdateJournalEntryInput {
  const factory UpdateJournalEntryInput({
    required String id,
    required String profileId,
    String? content,
    String? title,
    int? mood,
    List<String>? tags,
    String? audioUrl,
  }) = _UpdateJournalEntryInput;
}

@freezed
class DeleteJournalEntryInput with _$DeleteJournalEntryInput {
  const factory DeleteJournalEntryInput({
    required String id,
    required String profileId,
  }) = _DeleteJournalEntryInput;
}
```

### 4.3.10 PhotoArea Use Cases (P1)

```dart
// lib/domain/usecases/photo_areas/photo_area_inputs.dart

@freezed
class CreatePhotoAreaInput with _$CreatePhotoAreaInput {
  const factory CreatePhotoAreaInput({
    required String profileId,
    required String clientId,
    required String name,
    String? description,
    String? consistencyNotes,
  }) = _CreatePhotoAreaInput;
}

class CreatePhotoAreaUseCase implements UseCase<CreatePhotoAreaInput, PhotoArea> {
  final PhotoAreaRepository _repository;
  final ProfileAuthorizationService _authService;

  @override
  Future<Result<PhotoArea, AppError>> call(CreatePhotoAreaInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final area = PhotoArea(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      description: input.description,
      consistencyNotes: input.consistencyNotes,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(area);
  }

  ValidationError? _validate(CreatePhotoAreaInput input) {
    final errors = <String, List<String>>{};

    // Name validation: 2-100 characters
    if (input.name.length < 2 || input.name.length > 200) {
      errors['name'] = ['Area name must be 2-200 characters'];
    }

    // Description max length
    if (input.description != null && input.description!.length > 1000) {
      errors['description'] = ['Description must be 1000 characters or less'];
    }

    // Consistency notes max length
    if (input.consistencyNotes != null && input.consistencyNotes!.length > 1000) {
      errors['consistencyNotes'] = ['Consistency notes must be 1000 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

@freezed
class GetPhotoAreasInput with _$GetPhotoAreasInput {
  const factory GetPhotoAreasInput({
    required String profileId,
    @Default(false) bool includeArchived,
  }) = _GetPhotoAreasInput;
}

@freezed
class UpdatePhotoAreaInput with _$UpdatePhotoAreaInput {
  const factory UpdatePhotoAreaInput({
    required String id,
    required String profileId,
    String? name,
    String? description,
    String? consistencyNotes,
  }) = _UpdatePhotoAreaInput;
}

@freezed
class ArchivePhotoAreaInput with _$ArchivePhotoAreaInput {
  const factory ArchivePhotoAreaInput({
    required String id,
    required String profileId,
    @Default(true) bool archive,
  }) = _ArchivePhotoAreaInput;
}
```

### 4.3.11 PhotoEntry Use Cases (P1)

```dart
// lib/domain/usecases/photo_entries/photo_entry_inputs.dart

@freezed
class CreatePhotoEntryInput with _$CreatePhotoEntryInput {
  const factory CreatePhotoEntryInput({
    required String profileId,
    required String clientId,
    required String photoAreaId,
    required int timestamp,           // Epoch milliseconds
    required String filePath,
    String? notes,
    int? fileSizeBytes,
    String? fileHash,
  }) = _CreatePhotoEntryInput;
}

class CreatePhotoEntryUseCase implements UseCase<CreatePhotoEntryInput, PhotoEntry> {
  final PhotoEntryRepository _repository;
  final PhotoAreaRepository _areaRepository;
  final ProfileAuthorizationService _authService;

  @override
  Future<Result<PhotoEntry, AppError>> call(CreatePhotoEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = await _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final entry = PhotoEntry(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      photoAreaId: input.photoAreaId,
      timestamp: input.timestamp,
      filePath: input.filePath,
      notes: input.notes,
      fileSizeBytes: input.fileSizeBytes,
      fileHash: input.fileHash,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(entry);
  }

  Future<ValidationError?> _validate(CreatePhotoEntryInput input) async {
    final errors = <String, List<String>>{};

    // File path required
    if (input.filePath.isEmpty) {
      errors['filePath'] = ['File path is required'];
    }

    // Verify photo area exists and belongs to profile
    final areaResult = await _areaRepository.getById(input.photoAreaId);
    if (areaResult.isFailure) {
      errors['photoAreaId'] = ['Photo area not found'];
    } else {
      final area = areaResult.valueOrNull!;
      if (area.profileId != input.profileId) {
        errors['photoAreaId'] = ['Photo area does not belong to this profile'];
      }
    }

    // Timestamp validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
    if (input.timestamp > oneHourFromNow) {
      errors['timestamp'] = ['Timestamp cannot be more than 1 hour in the future'];
    }

    // Notes max length
    if (input.notes != null && input.notes!.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

@freezed
class GetPhotoEntriesByAreaInput with _$GetPhotoEntriesByAreaInput {
  const factory GetPhotoEntriesByAreaInput({
    required String profileId,
    required String photoAreaId,
    int? startDate,                   // Epoch milliseconds
    int? endDate,                     // Epoch milliseconds
    int? limit,
    int? offset,
  }) = _GetPhotoEntriesByAreaInput;
}

@freezed
class GetPhotoEntriesInput with _$GetPhotoEntriesInput {
  const factory GetPhotoEntriesInput({
    required String profileId,
    int? startDate,                   // Epoch milliseconds
    int? endDate,                     // Epoch milliseconds
    int? limit,
    int? offset,
  }) = _GetPhotoEntriesInput;
}

@freezed
class DeletePhotoEntryInput with _$DeletePhotoEntryInput {
  const factory DeletePhotoEntryInput({
    required String id,
    required String profileId,
  }) = _DeletePhotoEntryInput;
}
```

### 4.3.12 FlareUp Use Cases (P1)

```dart
// lib/domain/usecases/flare_ups/flare_up_inputs.dart

@freezed
class LogFlareUpInput with _$LogFlareUpInput {
  const factory LogFlareUpInput({
    required String profileId,
    required String clientId,
    required String conditionId,
    required int startDate,           // Epoch milliseconds
    int? endDate,                     // Null = ongoing
    required int severity,            // 1-10
    String? notes,
    @Default([]) List<String> triggers,
    String? activityId,
    String? photoPath,
  }) = _LogFlareUpInput;
}

class LogFlareUpUseCase implements UseCase<LogFlareUpInput, FlareUp> {
  final FlareUpRepository _repository;
  final ConditionRepository _conditionRepository;
  final ProfileAuthorizationService _authService;

  @override
  Future<Result<FlareUp, AppError>> call(LogFlareUpInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = await _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final flareUp = FlareUp(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      conditionId: input.conditionId,
      startDate: input.startDate,
      endDate: input.endDate,
      severity: input.severity,
      notes: input.notes,
      triggers: input.triggers,
      activityId: input.activityId,
      photoPath: input.photoPath,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(flareUp);
  }

  Future<ValidationError?> _validate(LogFlareUpInput input) async {
    final errors = <String, List<String>>{};

    // Severity validation: 1-10
    if (input.severity < 1 || input.severity > 10) {
      errors['severity'] = ['Severity must be between 1 and 10'];
    }

    // Verify condition exists and belongs to profile
    final conditionResult = await _conditionRepository.getById(input.conditionId);
    if (conditionResult.isFailure) {
      errors['conditionId'] = ['Condition not found'];
    } else {
      final condition = conditionResult.valueOrNull!;
      if (condition.profileId != input.profileId) {
        errors['conditionId'] = ['Condition does not belong to this profile'];
      }
    }

    // Start date validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
    if (input.startDate > oneHourFromNow) {
      errors['startDate'] = ['Start date cannot be more than 1 hour in the future'];
    }

    // End date must be after start date if provided
    if (input.endDate != null && input.endDate! <= input.startDate) {
      errors['endDate'] = ['End date must be after start date'];
    }

    // Notes max length
    if (input.notes != null && input.notes!.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    // Trigger descriptions max 100 characters each
    for (final trigger in input.triggers) {
      if (trigger.isEmpty || trigger.length > 100) {
        errors['triggers'] = ['Each trigger must be 1-100 characters'];
        break;
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

@freezed
class GetFlareUpsInput with _$GetFlareUpsInput {
  const factory GetFlareUpsInput({
    required String profileId,
    String? conditionId,
    int? startDate,                   // Epoch milliseconds
    int? endDate,                     // Epoch milliseconds
    bool? ongoingOnly,
    int? limit,
    int? offset,
  }) = _GetFlareUpsInput;
}

@freezed
class UpdateFlareUpInput with _$UpdateFlareUpInput {
  const factory UpdateFlareUpInput({
    required String id,
    required String profileId,
    int? severity,
    String? notes,
    List<String>? triggers,
    String? photoPath,
  }) = _UpdateFlareUpInput;
}

@freezed
class EndFlareUpInput with _$EndFlareUpInput {
  const factory EndFlareUpInput({
    required String id,
    required String profileId,
    required int endDate,             // Epoch milliseconds
  }) = _EndFlareUpInput;
}

@freezed
class DeleteFlareUpInput with _$DeleteFlareUpInput {
  const factory DeleteFlareUpInput({
    required String id,
    required String profileId,
  }) = _DeleteFlareUpInput;
}
```

### 4.4 Domain-Specific Repository SQL Patterns

**ALL domain repositories extend BaseLocalDataSource and add entity-specific methods:**

```dart
// lib/data/datasources/local/supplement_local_data_source.dart

class SupplementLocalDataSource extends BaseLocalDataSource<Supplement, SupplementModel> {
  SupplementLocalDataSource(Database db) : super(db, 'supplements');

  /// Get supplements by profile with optional active filter
  /// PATTERN: Profile-scoped query with optional boolean filter
  Future<Result<List<Supplement>, AppError>> getByProfile(
    String profileId, {
    bool? activeOnly,
    int? limit,
    int? offset,
  }) async {
    try {
      final where = StringBuffer('profile_id = ? AND sync_deleted_at IS NULL');
      final whereArgs = <Object>[profileId];

      if (activeOnly == true) {
        where.write(' AND is_archived = 0');
      }

      final sql = '''
        SELECT * FROM supplements
        WHERE $where
        ORDER BY brand ASC, sync_created_at DESC
        ${limit != null ? 'LIMIT $limit' : ''}
        ${offset != null ? 'OFFSET $offset' : ''}
      ''';

      final rows = await _database.query(sql, whereArgs);
      return Success(rows.map(_fromRow).toList());
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed('supplements', e.toString(), stack));
    }
  }

  /// Search supplements by name/brand
  /// PATTERN: LIKE query with case-insensitive search
  Future<Result<List<Supplement>, AppError>> search(
    String profileId,
    String query, {
    int limit = ValidationRules.defaultSearchLimit,
  }) async {
    try {
      final searchTerm = '%${query.toLowerCase()}%';

      final rows = await _database.query('''
        SELECT * FROM supplements
        WHERE profile_id = ?
          AND sync_deleted_at IS NULL
          AND (LOWER(brand) LIKE ? OR LOWER(ingredients) LIKE ?)
        ORDER BY brand ASC
        LIMIT ?
      ''', [profileId, searchTerm, searchTerm, limit]);

      return Success(rows.map(_fromRow).toList());
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed('supplements', e.toString(), stack));
    }
  }
}

// lib/data/datasources/local/fluids_entry_local_data_source.dart

class FluidsEntryLocalDataSource extends BaseLocalDataSource<FluidsEntry, FluidsEntryModel> {
  FluidsEntryLocalDataSource(Database db) : super(db, 'fluids_entries');

  /// Get entries for date range
  /// PATTERN: Timestamp range query
  Future<Result<List<FluidsEntry>, AppError>> getByDateRange(
    String profileId,
    int start,  // Epoch ms
    int end,    // Epoch ms
  ) async {
    try {
      final rows = await _database.query('''
        SELECT * FROM fluids_entries
        WHERE profile_id = ?
          AND entry_date >= ?
          AND entry_date < ?
          AND sync_deleted_at IS NULL
        ORDER BY entry_date DESC
      ''', [profileId, start, end]);

      return Success(rows.map(_fromRow).toList());
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed('fluids_entries', e.toString(), stack));
    }
  }

  /// Get BBT entries for chart
  /// PATTERN: Nullable column filter (only rows with data)
  Future<Result<List<FluidsEntry>, AppError>> getBBTEntries(
    String profileId,
    int start,
    int end,
  ) async {
    try {
      final rows = await _database.query('''
        SELECT * FROM fluids_entries
        WHERE profile_id = ?
          AND entry_date >= ?
          AND entry_date < ?
          AND basal_body_temperature IS NOT NULL
          AND sync_deleted_at IS NULL
        ORDER BY entry_date ASC
      ''', [profileId, start, end]);

      return Success(rows.map(_fromRow).toList());
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed('fluids_entries', e.toString(), stack));
    }
  }

  /// Get today's entry
  /// PATTERN: Single record for date (uses date boundary calculation)
  Future<Result<FluidsEntry?, AppError>> getTodayEntry(String profileId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final endOfDay = startOfDay + Duration.millisecondsPerDay;

      final rows = await _database.query('''
        SELECT * FROM fluids_entries
        WHERE profile_id = ?
          AND entry_date >= ?
          AND entry_date < ?
          AND sync_deleted_at IS NULL
        ORDER BY entry_date DESC
        LIMIT 1
      ''', [profileId, startOfDay, endOfDay]);

      if (rows.isEmpty) {
        return const Success(null);
      }
      return Success(_fromRow(rows.first));
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed('fluids_entries', e.toString(), stack));
    }
  }
}

// lib/data/datasources/local/diet_local_data_source.dart

class DietLocalDataSource extends BaseLocalDataSource<Diet, DietModel> {
  DietLocalDataSource(Database db) : super(db, 'diets');

  /// Get active diet for profile
  /// PATTERN: Single active record query
  Future<Result<Diet?, AppError>> getActiveDiet(String profileId) async {
    try {
      final rows = await _database.query('''
        SELECT * FROM diets
        WHERE profile_id = ?
          AND is_active = 1
          AND sync_deleted_at IS NULL
        LIMIT 1
      ''', [profileId]);

      if (rows.isEmpty) {
        return const Success(null);
      }
      return Success(_fromRow(rows.first));
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed('diets', e.toString(), stack));
    }
  }

  /// Activate diet (deactivates others in transaction)
  /// PATTERN: Transaction with multiple updates
  Future<Result<Diet, AppError>> activate(String dietId) async {
    try {
      return await _database.transaction((txn) async {
        // Get diet to activate
        final dietRows = await txn.query('''
          SELECT * FROM diets WHERE id = ? AND sync_deleted_at IS NULL
        ''', [dietId]);

        if (dietRows.isEmpty) {
          return Failure(DatabaseError.notFound('diets', dietId));
        }

        final diet = _fromRow(dietRows.first);
        final now = DateTime.now().millisecondsSinceEpoch;

        // Deactivate all other diets for this profile
        await txn.update(
          'diets',
          {'is_active': 0, 'sync_updated_at': now, 'sync_is_dirty': 1},
          where: 'profile_id = ? AND id != ? AND is_active = 1 AND sync_deleted_at IS NULL',
          whereArgs: [diet.profileId, dietId],
        );

        // Activate the requested diet
        await txn.update(
          'diets',
          {'is_active': 1, 'sync_updated_at': now, 'sync_is_dirty': 1},
          where: 'id = ?',
          whereArgs: [dietId],
        );

        return getById(dietId);
      });
    } catch (e, stack) {
      return Failure(DatabaseError.transactionFailed('diets.activate', e.toString(), stack));
    }
  }
}

// lib/data/datasources/local/condition_log_local_data_source.dart

class ConditionLogLocalDataSource extends BaseLocalDataSource<ConditionLog, ConditionLogModel> {
  ConditionLogLocalDataSource(Database db) : super(db, 'condition_logs');

  /// Get flare entries only
  /// PATTERN: Boolean flag filter
  Future<Result<List<ConditionLog>, AppError>> getFlares(
    String conditionId, {
    int limit = 50,
  }) async {
    try {
      final rows = await _database.query('''
        SELECT * FROM condition_logs
        WHERE condition_id = ?
          AND is_flare = 1
          AND sync_deleted_at IS NULL
        ORDER BY timestamp DESC
        LIMIT ?
      ''', [conditionId, limit]);

      return Success(rows.map(_fromRow).toList());
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed('condition_logs', e.toString(), stack));
    }
  }
}

// lib/data/datasources/local/intake_log_local_data_source.dart

class IntakeLogLocalDataSource extends BaseLocalDataSource<IntakeLog, IntakeLogModel> {
  IntakeLogLocalDataSource(Database db) : super(db, 'intake_logs');

  /// Mark intake as taken
  /// PATTERN: Status update with timestamp
  Future<Result<IntakeLog, AppError>> markTaken(String id, int actualTime) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      final rowsAffected = await _database.update(
        'intake_logs',
        {
          'status': IntakeLogStatus.taken.value,
          'actual_time': actualTime,
          'sync_updated_at': now,
          'sync_is_dirty': 1,
        },
        where: 'id = ? AND sync_deleted_at IS NULL',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('intake_logs', id));
      }

      return getById(id);
    } catch (e, stack) {
      return Failure(DatabaseError.updateFailed('intake_logs', e.toString(), stack));
    }
  }

  /// Mark intake as skipped
  /// PATTERN: Status update with reason
  Future<Result<IntakeLog, AppError>> markSkipped(String id, String? reason) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      final rowsAffected = await _database.update(
        'intake_logs',
        {
          'status': IntakeLogStatus.skipped.value,
          'reason': reason,
          'sync_updated_at': now,
          'sync_is_dirty': 1,
        },
        where: 'id = ? AND sync_deleted_at IS NULL',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('intake_logs', id));
      }

      return getById(id);
    } catch (e, stack) {
      return Failure(DatabaseError.updateFailed('intake_logs', e.toString(), stack));
    }
  }
}

// lib/data/datasources/local/health_insight_local_data_source.dart

class HealthInsightLocalDataSource extends BaseLocalDataSource<HealthInsight, HealthInsightModel> {
  HealthInsightLocalDataSource(Database db) : super(db, 'health_insights');

  /// Get active insights (not dismissed, not expired)
  /// PATTERN: Multiple condition filter with expiration check
  Future<Result<List<HealthInsight>, AppError>> getActive(
    String profileId, {
    InsightCategory? category,
    int? minPriority,
    int limit = ValidationRules.defaultSearchLimit,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final where = StringBuffer('''
        profile_id = ?
        AND is_dismissed = 0
        AND (expires_at IS NULL OR expires_at > ?)
        AND sync_deleted_at IS NULL
      ''');
      final whereArgs = <Object>[profileId, now];

      if (category != null) {
        where.write(' AND category = ?');
        whereArgs.add(category.value);
      }

      if (minPriority != null) {
        where.write(' AND priority >= ?');
        whereArgs.add(minPriority);
      }

      final rows = await _database.query('''
        SELECT * FROM health_insights
        WHERE $where
        ORDER BY priority DESC, created_at DESC
        LIMIT $limit
      ''', whereArgs);

      return Success(rows.map(_fromRow).toList());
    } catch (e, stack) {
      return Failure(DatabaseError.queryFailed('health_insights', e.toString(), stack));
    }
  }

  /// Dismiss insight
  /// PATTERN: Simple boolean toggle
  Future<Result<void, AppError>> dismiss(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      final rowsAffected = await _database.update(
        'health_insights',
        {
          'is_dismissed': 1,
          'sync_updated_at': now,
          'sync_is_dirty': 1,
        },
        where: 'id = ? AND sync_deleted_at IS NULL',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('health_insights', id));
      }

      return const Success(null);
    } catch (e, stack) {
      return Failure(DatabaseError.updateFailed('health_insights', e.toString(), stack));
    }
  }
}
```

**SQL Pattern Reference Table:**

| Pattern | Use Case | Example Method |
|---------|----------|----------------|
| Profile-scoped query | Any entity belonging to profile | `getByProfile()` |
| Date range filter | Logs, entries, history | `getByDateRange()` |
| Nullable column filter | Optional data fields | `getBBTEntries()` |
| Single record for date | Daily entries | `getTodayEntry()` |
| Active record query | Single active entity | `getActiveDiet()` |
| Transaction multi-update | Activate/deactivate patterns | `activate()` |
| Boolean flag filter | Flares, archived, enabled | `getFlares()` |
| Status update with data | Intake logging | `markTaken()`, `markSkipped()` |
| Expiration check | Insights, alerts, auth | `getActive()` |
| Boolean toggle | Dismiss, archive, enable | `dismiss()` |
| LIKE search | Name/content search | `search()` |
| Aggregation | Counts, averages | Use `SELECT COUNT(*), AVG()` |
| FK join | Related entity lookup | `JOIN conditions ON...` |

---

### 4.5 Complete Use Case Implementation Examples

This section provides complete implementation examples for ALL use cases. Each implementation follows the standard pattern:

1. **Authorization** - Check profile access FIRST
2. **Validation** - Validate input using ValidationRules
3. **Business Logic** - Apply domain rules
4. **Repository Call** - Execute operation
5. **Result Wrapping** - Return `Success` or `Failure`

> **@Default Values Policy:** When constructing entities, implementations MAY omit fields
> that have `@Default` annotations in the entity definition. The Dart analyzer enforces
> `avoid_redundant_argument_values`, so explicit default values should NOT be written.
> Code examples in this spec may show conceptual values for documentation clarity, but
> implementations should rely on Freezed `@Default` annotations where defined.

#### 4.5.1 CRUD Use Case Templates

These templates apply to ALL entities. Each entity MUST have corresponding use cases.

```dart
// lib/domain/usecases/base_crud_use_cases.dart

/// Template: Create Entity Use Case
/// Apply to: Supplement, Condition, Activity, PhotoArea, etc.
class CreateEntityUseCase<T, CreateInput> implements UseCase<CreateInput, T> {
  final EntityRepository<T, String> _repository;
  final ProfileAuthorizationService _authService;
  final String Function(CreateInput) _getProfileId;
  final ValidationError? Function(CreateInput) _validate;
  final T Function(CreateInput, String) _toEntity; // Input + generated ID

  CreateEntityUseCase({
    required EntityRepository<T, String> repository,
    required ProfileAuthorizationService authService,
    required String Function(CreateInput) getProfileId,
    required ValidationError? Function(CreateInput) validate,
    required T Function(CreateInput, String) toEntity,
  })  : _repository = repository,
        _authService = authService,
        _getProfileId = getProfileId,
        _validate = validate,
        _toEntity = toEntity;

  @override
  Future<Result<T, AppError>> call(CreateInput input) async {
    // 1. Authorization
    final profileId = _getProfileId(input);
    if (!await _authService.canWrite(profileId)) {
      return Failure(AuthError.profileAccessDenied(profileId));
    }

    // 2. Validation
    final validationError = _validate(input);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 3. Generate ID and create entity
    final id = const Uuid().v4();
    final entity = _toEntity(input, id);

    // 4. Persist
    return _repository.create(entity);
  }
}

/// Template: Update Entity Use Case
class UpdateEntityUseCase<T, UpdateInput> implements UseCase<UpdateInput, T> {
  final EntityRepository<T, String> _repository;
  final ProfileAuthorizationService _authService;
  final String Function(UpdateInput) _getId;
  final String Function(UpdateInput) _getProfileId;
  final ValidationError? Function(UpdateInput, T) _validate;
  final T Function(UpdateInput, T) _applyUpdate;

  UpdateEntityUseCase({
    required EntityRepository<T, String> repository,
    required ProfileAuthorizationService authService,
    required String Function(UpdateInput) getId,
    required String Function(UpdateInput) getProfileId,
    required ValidationError? Function(UpdateInput, T) validate,
    required T Function(UpdateInput, T) applyUpdate,
  })  : _repository = repository,
        _authService = authService,
        _getId = getId,
        _getProfileId = getProfileId,
        _validate = validate,
        _applyUpdate = applyUpdate;

  @override
  Future<Result<T, AppError>> call(UpdateInput input) async {
    // 1. Authorization
    final profileId = _getProfileId(input);
    if (!await _authService.canWrite(profileId)) {
      return Failure(AuthError.profileAccessDenied(profileId));
    }

    // 2. Fetch existing entity
    final existingResult = await _repository.getById(_getId(input));
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }
    final existing = existingResult.valueOrNull!;

    // 3. Validation
    final validationError = _validate(input, existing);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 4. Apply update
    final updated = _applyUpdate(input, existing);

    // 5. Persist
    return _repository.update(updated);
  }
}

/// Template: Delete Entity Use Case (Soft Delete)
class DeleteEntityUseCase implements UseCase<DeleteEntityInput, void> {
  final EntityRepository<dynamic, String> _repository;
  final ProfileAuthorizationService _authService;

  DeleteEntityUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(DeleteEntityInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Verify entity exists and belongs to profile
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    // 3. Soft delete
    return _repository.delete(input.id);
  }
}

@freezed
class DeleteEntityInput with _$DeleteEntityInput {
  const factory DeleteEntityInput({
    required String id,
    required String profileId,
  }) = _DeleteEntityInput;
}
```

#### 4.5.2 Supplement Use Cases

```dart
// lib/domain/usecases/supplements/create_supplement_use_case.dart

@freezed
class CreateSupplementInput with _$CreateSupplementInput {
  const factory CreateSupplementInput({
    required String profileId,
    required String clientId,
    required String name,
    required SupplementForm form,
    String? customForm,
    required int dosageQuantity,
    required DosageUnit dosageUnit,
    @Default('') String brand,
    @Default('') String notes,
    @Default([]) List<SupplementIngredient> ingredients,
    @Default([]) List<SupplementSchedule> schedules,
    int? startDate,
    int? endDate,
  }) = _CreateSupplementInput;
}

class CreateSupplementUseCase implements UseCase<CreateSupplementInput, Supplement> {
  final SupplementRepository _repository;
  final ProfileAuthorizationService _authService;

  CreateSupplementUseCase(this._repository, this._authService);

  @override
  Future<Result<Supplement, AppError>> call(CreateSupplementInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationError = _validate(input);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    // Note: isArchived uses @Default(false) from Supplement entity
    // SyncMetadata fields use @Default values: syncVersion=1, syncStatus=pending, syncIsDirty=true
    final supplement = Supplement(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      form: input.form,
      customForm: input.customForm,
      dosageQuantity: input.dosageQuantity,
      dosageUnit: input.dosageUnit,
      brand: input.brand,
      notes: input.notes,
      ingredients: input.ingredients,
      schedules: input.schedules,
      startDate: input.startDate,
      endDate: input.endDate,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(supplement);
  }

  ValidationError? _validate(CreateSupplementInput input) {
    final errors = <String, List<String>>{};

    // Name validation
    final nameError = ValidationRules.supplementName(input.name);
    if (nameError != null) errors['name'] = [nameError];

    // Brand validation (optional but max length)
    if (input.brand.isNotEmpty) {
      final brandError = ValidationRules.brand(input.brand);
      if (brandError != null) errors['brand'] = [brandError];
    }

    // Custom form required when form is 'other'
    if (input.form == SupplementForm.other &&
        (input.customForm == null || input.customForm!.isEmpty)) {
      errors['customForm'] = ['Custom form name is required when form is "Other"'];
    }

    // Dosage quantity must be positive
    if (input.dosageQuantity <= 0) {
      errors['dosageQuantity'] = ['Dosage quantity must be greater than 0'];
    }

    // Ingredients count limit
    final ingredientsError = ValidationRules.ingredientsCount(input.ingredients.length);
    if (ingredientsError != null) errors['ingredients'] = [ingredientsError];

    // Schedules count limit
    final schedulesError = ValidationRules.schedulesCount(input.schedules.length);
    if (schedulesError != null) errors['schedules'] = [schedulesError];

    // Date range validation
    if (input.startDate != null && input.endDate != null) {
      final dateError = ValidationRules.dateRange(input.startDate!, input.endDate!, 'startDate', 'endDate');
      if (dateError != null) errors['dateRange'] = [dateError];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

// lib/domain/usecases/supplements/update_supplement_use_case.dart

@freezed
class UpdateSupplementInput with _$UpdateSupplementInput {
  const factory UpdateSupplementInput({
    required String id,
    required String profileId,
    String? name,
    SupplementForm? form,
    String? customForm,
    int? dosageQuantity,
    DosageUnit? dosageUnit,
    String? brand,
    String? notes,
    List<SupplementIngredient>? ingredients,
    List<SupplementSchedule>? schedules,
    int? startDate,
    int? endDate,
    bool? isArchived,
  }) = _UpdateSupplementInput;
}

class UpdateSupplementUseCase implements UseCase<UpdateSupplementInput, Supplement> {
  final SupplementRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateSupplementUseCase(this._repository, this._authService);

  @override
  Future<Result<Supplement, AppError>> call(UpdateSupplementInput input) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }
    final existing = existingResult.valueOrNull!;

    // 3. Verify ownership
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 4. Apply updates (copyWith pattern)
    final updated = existing.copyWith(
      name: input.name ?? existing.name,
      form: input.form ?? existing.form,
      customForm: input.customForm ?? existing.customForm,
      dosageQuantity: input.dosageQuantity ?? existing.dosageQuantity,
      dosageUnit: input.dosageUnit ?? existing.dosageUnit,
      brand: input.brand ?? existing.brand,
      notes: input.notes ?? existing.notes,
      ingredients: input.ingredients ?? existing.ingredients,
      schedules: input.schedules ?? existing.schedules,
      startDate: input.startDate ?? existing.startDate,
      endDate: input.endDate ?? existing.endDate,
      isArchived: input.isArchived ?? existing.isArchived,
      syncMetadata: existing.syncMetadata.copyWith(
        syncUpdatedAt: now,
        syncVersion: existing.syncMetadata.syncVersion + 1,
        syncIsDirty: true,
      ),
    );

    // 5. Validate updated entity
    final validationError = _validateUpdated(updated);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 6. Persist
    return _repository.update(updated);
  }

  ValidationError? _validateUpdated(Supplement supplement) {
    final errors = <String, List<String>>{};

    final nameError = ValidationRules.supplementName(supplement.name);
    if (nameError != null) errors['name'] = [nameError];

    if (supplement.form == SupplementForm.other &&
        (supplement.customForm == null || supplement.customForm!.isEmpty)) {
      errors['customForm'] = ['Custom form name is required when form is "Other"'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

// lib/domain/usecases/supplements/archive_supplement_use_case.dart

@freezed
class ArchiveSupplementInput with _$ArchiveSupplementInput {
  const factory ArchiveSupplementInput({
    required String id,
    required String profileId,
    required bool archive, // true = archive, false = unarchive
  }) = _ArchiveSupplementInput;
}

class ArchiveSupplementUseCase implements UseCase<ArchiveSupplementInput, Supplement> {
  final SupplementRepository _repository;
  final ProfileAuthorizationService _authService;

  ArchiveSupplementUseCase(this._repository, this._authService);

  @override
  Future<Result<Supplement, AppError>> call(ArchiveSupplementInput input) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }
    final existing = existingResult.valueOrNull!;

    // 3. Verify ownership
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 4. Update archive status
    final updated = existing.copyWith(
      isArchived: input.archive,
      syncMetadata: existing.syncMetadata.copyWith(
        syncUpdatedAt: now,
        syncVersion: existing.syncMetadata.syncVersion + 1,
        syncIsDirty: true,
      ),
    );

    // 5. Persist
    return _repository.update(updated);
  }
}
```

#### 4.5.3 Condition Use Cases

```dart
// lib/domain/usecases/conditions/get_conditions_use_case.dart
// UPDATED to match Section 10.8 entity definition and actual implementation

@freezed
class GetConditionsInput with _$GetConditionsInput {
  const factory GetConditionsInput({
    required String profileId,
    ConditionStatus? status,
    @Default(false) bool includeArchived,
  }) = _GetConditionsInput;
}

class GetConditionsUseCase implements UseCase<GetConditionsInput, List<Condition>> {
  final ConditionRepository _repository;
  final ProfileAuthorizationService _authService;

  GetConditionsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<Condition>, AppError>> call(GetConditionsInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Execute query
    return _repository.getByProfile(
      input.profileId,
      status: input.status,
      includeArchived: input.includeArchived,
    );
  }
}

// lib/domain/usecases/conditions/create_condition_use_case.dart
// UPDATED to match Section 10.8 Condition entity definition

@freezed
class CreateConditionInput with _$CreateConditionInput {
  const factory CreateConditionInput({
    required String profileId,
    required String clientId,
    required String name,
    required String category,
    @Default([]) List<String> bodyLocations,
    String? description,
    String? baselinePhotoPath,
    required int startTimeframe,    // Epoch ms
    int? endDate,                   // Epoch ms
    String? activityId,
  }) = _CreateConditionInput;
}

class CreateConditionUseCase implements UseCase<CreateConditionInput, Condition> {
  final ConditionRepository _repository;
  final ProfileAuthorizationService _authService;

  CreateConditionUseCase(this._repository, this._authService);

  @override
  Future<Result<Condition, AppError>> call(CreateConditionInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final errors = <String, List<String>>{};

    final nameError = ValidationRules.conditionName(input.name);
    if (nameError != null) errors['name'] = [nameError];

    if (errors.isNotEmpty) {
      return Failure(ValidationError.fromFieldErrors(errors));
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final condition = Condition(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      category: input.category,
      bodyLocations: input.bodyLocations,
      description: input.description,
      baselinePhotoPath: input.baselinePhotoPath,
      startTimeframe: input.startTimeframe,
      endDate: input.endDate,
      activityId: input.activityId,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(condition);
  }
}

// lib/domain/usecases/condition_logs/log_condition_use_case.dart
// UPDATED to match Section 10.9 ConditionLog entity definition

@freezed
class LogConditionInput with _$LogConditionInput {
  const factory LogConditionInput({
    required String profileId,
    required String clientId,
    required String conditionId,
    required int timestamp,         // Epoch ms
    required int severity,          // 1-10 scale
    String? notes,
    @Default(false) bool isFlare,
    @Default([]) List<String> flarePhotoIds,
    String? photoPath,
    String? activityId,
    String? triggers,               // Comma-separated
  }) = _LogConditionInput;
}

class LogConditionUseCase implements UseCase<LogConditionInput, ConditionLog> {
  final ConditionLogRepository _logRepository;
  final ConditionRepository _conditionRepository;
  final ProfileAuthorizationService _authService;

  LogConditionUseCase(
    this._logRepository,
    this._conditionRepository,
    this._authService,
  );

  @override
  Future<Result<ConditionLog, AppError>> call(LogConditionInput input) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Verify condition exists and belongs to profile
    final conditionResult = await _conditionRepository.getById(input.conditionId);
    if (conditionResult.isFailure) {
      return Failure(conditionResult.errorOrNull!);
    }
    final condition = conditionResult.valueOrNull!;
    if (condition.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Validation
    final errors = <String, List<String>>{};

    // Severity range
    if (input.severity < 1 || input.severity > 10) {
      errors['severity'] = ['Severity must be between 1 and 10'];
    }

    // Notes length
    if (input.notes != null && input.notes!.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    // Timestamp not in future (allow 1 hour tolerance)
    final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
    if (input.timestamp > oneHourFromNow) {
      errors['timestamp'] = ['Timestamp cannot be more than 1 hour in the future'];
    }

    if (errors.isNotEmpty) {
      return Failure(ValidationError.fromFieldErrors(errors));
    }

    // 4. Create log entry
    final id = const Uuid().v4();

    final log = ConditionLog(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      conditionId: input.conditionId,
      timestamp: input.timestamp,
      severity: input.severity,
      notes: input.notes,
      isFlare: input.isFlare,
      flarePhotoIds: input.flarePhotoIds,
      photoPath: input.photoPath,
      activityId: input.activityId,
      triggers: input.triggers,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 6. Persist
    return _logRepository.create(log);
  }

  /// Detect flare-up based on severity threshold
  /// Flare = severity >= 7 on 1-10 scale
  bool _detectFlare(int severity, Condition condition) {
    return severity >= 7;
  }
}

// lib/domain/usecases/condition_logs/get_condition_logs_use_case.dart

/// Gets condition logs for a condition within a date range.
class GetConditionLogsUseCase implements UseCase<GetConditionLogsInput, List<ConditionLog>> {
  final ConditionLogRepository _repository;
  final ProfileAuthorizationService _auth;

  GetConditionLogsUseCase(this._repository, this._auth);

  @override
  Future<Result<List<ConditionLog>, AppError>> call(GetConditionLogsInput input) async {
    if (!await _auth.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }
    return _repository.getByCondition(input.conditionId, startDate: input.startDate, endDate: input.endDate);
  }
}

@freezed
class GetConditionLogsInput with _$GetConditionLogsInput {
  const factory GetConditionLogsInput({
    required String profileId,
    required String conditionId,
    int? startDate,
    int? endDate,
  }) = _GetConditionLogsInput;
}

// lib/domain/usecases/conditions/get_condition_trend_use_case.dart

@freezed
class GetConditionTrendInput with _$GetConditionTrendInput {
  const factory GetConditionTrendInput({
    required String profileId,
    required String conditionId,
    required int startDate,        // Epoch ms
    required int endDate,          // Epoch ms
    @Default(TrendGranularity.daily) TrendGranularity granularity,
  }) = _GetConditionTrendInput;
}

enum TrendGranularity {
  daily(0),
  weekly(1),
  monthly(2);

  final int value;
  const TrendGranularity(this.value);

  static TrendGranularity fromValue(int value) =>
    TrendGranularity.values.firstWhere((e) => e.value == value, orElse: () => daily);
}

@freezed
class ConditionTrend with _$ConditionTrend {
  const factory ConditionTrend({
    required List<TrendDataPoint> dataPoints,
    required double averageSeverity,
    required int totalFlares,
    required int daysTracked,
    required int? currentSeverity,
    required TrendDirection direction, // improving, stable, worsening
  }) = _ConditionTrend;
}

@freezed
class TrendDataPoint with _$TrendDataPoint {
  const factory TrendDataPoint({
    required int dateEpoch,
    required double? averageSeverity,
    required int? maxSeverity,
    required int logCount,
    required bool hadFlare,
  }) = _TrendDataPoint;
}

enum TrendDirection {
  improving(0),
  stable(1),
  worsening(2);

  final int value;
  const TrendDirection(this.value);

  static TrendDirection fromValue(int value) =>
    TrendDirection.values.firstWhere((e) => e.value == value, orElse: () => stable);
}

class GetConditionTrendUseCase implements UseCase<GetConditionTrendInput, ConditionTrend> {
  final ConditionLogRepository _repository;
  final ProfileAuthorizationService _authService;

  GetConditionTrendUseCase(this._repository, this._authService);

  @override
  Future<Result<ConditionTrend, AppError>> call(GetConditionTrendInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    if (input.startDate >= input.endDate) {
      return Failure(ValidationError.fromFieldErrors({
        'dateRange': ['Start date must be before end date'],
      }));
    }

    // 3. Fetch logs in range
    final logsResult = await _repository.getByCondition(
      input.conditionId,
      startDate: input.startDate,
      endDate: input.endDate,
    );
    if (logsResult.isFailure) {
      return Failure(logsResult.errorOrNull!);
    }
    final logs = logsResult.valueOrNull!;

    // 4. Calculate trend
    final dataPoints = _aggregateByGranularity(logs, input.granularity);
    final trend = _calculateTrend(logs, dataPoints);

    return Success(trend);
  }

  List<TrendDataPoint> _aggregateByGranularity(
    List<ConditionLog> logs,
    TrendGranularity granularity,
  ) {
    // Group logs by date bucket based on granularity
    final buckets = <int, List<ConditionLog>>{};

    for (final log in logs) {
      final bucketKey = _getBucketKey(log.timestamp, granularity);
      buckets.putIfAbsent(bucketKey, () => []).add(log);
    }

    return buckets.entries.map((entry) {
      final bucketLogs = entry.value;
      final severities = bucketLogs.map((l) => l.severity).toList();

      return TrendDataPoint(
        dateEpoch: entry.key,
        averageSeverity: severities.isNotEmpty
            ? severities.reduce((a, b) => a + b) / severities.length
            : null,
        maxSeverity: severities.isNotEmpty
            ? severities.reduce(max)
            : null,
        logCount: bucketLogs.length,
        hadFlare: bucketLogs.any((l) => l.isFlare),
      );
    }).toList()
      ..sort((a, b) => a.dateEpoch.compareTo(b.dateEpoch));
  }

  int _getBucketKey(int epochMs, TrendGranularity granularity) {
    final date = DateTime.fromMillisecondsSinceEpoch(epochMs);
    switch (granularity) {
      case TrendGranularity.daily:
        return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
      case TrendGranularity.weekly:
        // Start of ISO week
        final weekday = date.weekday - 1; // 0 = Monday
        final startOfWeek = date.subtract(Duration(days: weekday));
        return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day)
            .millisecondsSinceEpoch;
      case TrendGranularity.monthly:
        return DateTime(date.year, date.month, 1).millisecondsSinceEpoch;
    }
  }

  ConditionTrend _calculateTrend(List<ConditionLog> logs, List<TrendDataPoint> dataPoints) {
    if (logs.isEmpty) {
      return const ConditionTrend(
        dataPoints: [],
        averageSeverity: 0,
        totalFlares: 0,
        daysTracked: 0,
        currentSeverity: null,
        direction: TrendDirection.stable,
      );
    }

    final severities = logs.map((l) => l.severity).toList();
    final avgSeverity = severities.reduce((a, b) => a + b) / severities.length;
    final totalFlares = logs.where((l) => l.isFlare).length;

    // Get unique days
    final uniqueDays = logs
        .map((l) => DateTime.fromMillisecondsSinceEpoch(l.timestamp))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .length;

    // Current = most recent log
    final sortedLogs = logs..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final currentSeverity = sortedLogs.first.severity;

    // Calculate direction based on first half vs second half
    TrendDirection direction;
    if (dataPoints.length < 2) {
      direction = TrendDirection.stable;
    } else {
      final midpoint = dataPoints.length ~/ 2;
      final firstHalf = dataPoints.take(midpoint).toList();
      final secondHalf = dataPoints.skip(midpoint).toList();

      final firstAvg = firstHalf
          .where((p) => p.averageSeverity != null)
          .map((p) => p.averageSeverity!)
          .fold<double>(0, (sum, v) => sum + v) / firstHalf.length;
      final secondAvg = secondHalf
          .where((p) => p.averageSeverity != null)
          .map((p) => p.averageSeverity!)
          .fold<double>(0, (sum, v) => sum + v) / secondHalf.length;

      if (secondAvg < firstAvg - 0.5) {
        direction = TrendDirection.improving;
      } else if (secondAvg > firstAvg + 0.5) {
        direction = TrendDirection.worsening;
      } else {
        direction = TrendDirection.stable;
      }
    }

    return ConditionTrend(
      dataPoints: dataPoints,
      averageSeverity: avgSeverity,
      totalFlares: totalFlares,
      daysTracked: uniqueDays,
      currentSeverity: currentSeverity,
      direction: direction,
    );
  }
}
```

#### 4.5.4 Diet Use Cases

```dart
// lib/domain/usecases/diet/create_diet_use_case.dart

class CreateDietUseCase implements UseCaseWithInput<Diet, CreateDietInput> {
  final DietRepository _dietRepository;
  final DietRuleRepository _ruleRepository;
  final ProfileAuthorizationService _authService;

  CreateDietUseCase(this._dietRepository, this._ruleRepository, this._authService);

  @override
  Future<Result<Diet, AppError>> call(CreateDietInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationError = _validate(input);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 3. Deactivate any existing active diet
    final deactivateResult = await _deactivateCurrentDiet(input.profileId);
    if (deactivateResult.isFailure) {
      return Failure(deactivateResult.errorOrNull!);
    }

    // 4. Get rules (from preset or custom)
    final rules = input.presetId != null
        ? DietPresets.getRules(input.presetId!)
        : input.customRules;

    // 5. Create diet entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final diet = Diet(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      presetType: input.presetId != null
          ? DietPresetType.values.firstWhere((t) => t.name == input.presetId)
          : null,
      isActive: true,
      startDate: input.startDateEpoch ?? now,
      endDate: input.endDateEpoch,
      eatingWindowStartMinutes: input.eatingWindowStartMinutes,
      eatingWindowEndMinutes: input.eatingWindowEndMinutes,
      rules: rules,
      notes: null,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '',
      ),
    );

    // 6. Persist diet and rules in transaction
    return _dietRepository.create(diet);
  }

  ValidationError? _validate(CreateDietInput input) {
    final errors = <String, List<String>>{};

    // Name required
    if (input.name.isEmpty || input.name.length > 100) {
      errors['name'] = ['Diet name must be 1-100 characters'];
    }

    // Either preset or custom rules required
    if (input.presetId == null && input.customRules.isEmpty) {
      errors['rules'] = ['Either a preset diet or custom rules are required'];
    }

    // Eating window validation
    if (input.eatingWindowStartMinutes != null && input.eatingWindowEndMinutes != null) {
      final startError = ValidationRules.minutesFromMidnight(
        input.eatingWindowStartMinutes!, 'eatingWindowStart');
      if (startError != null) errors['eatingWindowStart'] = [startError];

      final endError = ValidationRules.minutesFromMidnight(
        input.eatingWindowEndMinutes!, 'eatingWindowEnd');
      if (endError != null) errors['eatingWindowEnd'] = [endError];

      if (input.eatingWindowStartMinutes! >= input.eatingWindowEndMinutes!) {
        errors['eatingWindow'] = ['Eating window start must be before end'];
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }

  Future<Result<void, AppError>> _deactivateCurrentDiet(String profileId) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    final activeResult = await _dietRepository.getActiveDiet(profileId);
    if (activeResult.isFailure) {
      return Failure(activeResult.errorOrNull!);
    }

    final activeDiet = activeResult.valueOrNull;
    if (activeDiet != null) {
      final deactivated = activeDiet.copyWith(
        isActive: false,
        syncMetadata: activeDiet.syncMetadata.copyWith(
          syncUpdatedAt: now,
          syncVersion: activeDiet.syncMetadata.syncVersion + 1,
          syncIsDirty: true,
        ),
      );
      final updateResult = await _dietRepository.update(deactivated);
      if (updateResult.isFailure) return Failure(updateResult.errorOrNull!);
    }

    return const Success(null);
  }
}

// lib/domain/usecases/diet/activate_diet_use_case.dart

class ActivateDietUseCase implements UseCaseWithInput<Diet, ActivateDietInput> {
  final DietRepository _dietRepository;
  final ProfileAuthorizationService _authService;

  ActivateDietUseCase(this._dietRepository, this._authService);

  @override
  Future<Result<Diet, AppError>> call(ActivateDietInput input) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch diet to activate
    final dietResult = await _dietRepository.getById(input.dietId);
    if (dietResult.isFailure) {
      return Failure(dietResult.errorOrNull!);
    }
    final diet = dietResult.valueOrNull!;

    // 3. Verify ownership
    if (diet.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 4. Already active?
    if (diet.isActive) {
      return Success(diet);
    }

    // 5. Deactivate current diet
    final activeResult = await _dietRepository.getActiveDiet(input.profileId);
    if (activeResult.isSuccess && activeResult.valueOrNull != null) {
      final currentActive = activeResult.valueOrNull!;
      await _dietRepository.update(currentActive.copyWith(
        isActive: false,
        syncMetadata: currentActive.syncMetadata.copyWith(
          syncUpdatedAt: now,
          syncVersion: currentActive.syncMetadata.syncVersion + 1,
          syncIsDirty: true,
        ),
      ));
    }

    // 6. Activate target diet
    final activated = diet.copyWith(
      isActive: true,
      syncMetadata: diet.syncMetadata.copyWith(
        syncUpdatedAt: now,
        syncVersion: diet.syncMetadata.syncVersion + 1,
        syncIsDirty: true,
      ),
    );

    return _dietRepository.update(activated);
  }
}

// lib/domain/usecases/diet/pre_log_compliance_check_use_case.dart

class PreLogComplianceCheckUseCase
    implements UseCaseWithInput<ComplianceWarning, PreLogComplianceCheckInput> {
  final DietRepository _dietRepository;
  final FoodItemRepository _foodItemRepository;
  final DietComplianceService _complianceService;
  final ProfileAuthorizationService _authService;

  PreLogComplianceCheckUseCase(
    this._dietRepository,
    this._foodItemRepository,
    this._complianceService,
    this._authService,
  );

  @override
  Future<Result<ComplianceWarning, AppError>> call(PreLogComplianceCheckInput input) async {
    // 1. Authorization (read access is sufficient for checking)
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch diet
    final dietResult = await _dietRepository.getById(input.dietId);
    if (dietResult.isFailure) {
      return Failure(dietResult.errorOrNull!);
    }
    final diet = dietResult.valueOrNull!;

    // 3. Fetch food item
    final foodResult = await _foodItemRepository.getById(input.foodItemId);
    if (foodResult.isFailure) {
      return Failure(foodResult.errorOrNull!);
    }
    final food = foodResult.valueOrNull!;

    // 4. Check compliance
    
    final violations = _complianceService.checkFoodAgainstRules(food, diet.rules, input.logTimeEpoch);

    // 5. If no violations, return all clear
    if (violations.isEmpty) {
      return Success(ComplianceWarning(
        violatesRules: false,
        violatedRules: [],
        complianceImpactPercent: 0.0,
        alternatives: [],
      ));
    }

    // 6. Calculate impact
    final impact = _complianceService.calculateImpact(input.profileId, violations);

    // 7. Find alternatives
    final alternativesResult = await _findAlternatives(input.profileId, food, violations);
    final alternatives = alternativesResult.isSuccess
        ? alternativesResult.valueOrNull!
        : <FoodItem>[];

    return Success(ComplianceWarning(
      violatesRules: true,
      violatedRules: violations,
      complianceImpactPercent: impact,
      alternatives: alternatives,
    ));
  }

  Future<Result<List<FoodItem>, AppError>> _findAlternatives(
    String profileId,
    FoodItem food,
    List<DietRule> violatedRules,
  ) async {
    // Find foods in similar category that don't violate the rules
    final categories = violatedRules
        .where((r) => r.category != null)
        .map((r) => r.category!)
        .toList();

    // Exclude those categories and find similar foods
    return _foodItemRepository.searchExcludingCategories(
      profileId,
      food.name,
      excludeCategories: categories,
      limit: 5,
    );
  }
}

// lib/domain/usecases/diet/get_compliance_stats_use_case.dart

class GetComplianceStatsUseCase implements UseCase<ComplianceStatsInput, ComplianceStats> {
  final DietRepository _dietRepository;
  final DietViolationRepository _violationRepository;
  final FoodLogRepository _foodLogRepository;
  final ProfileAuthorizationService _authService;

  GetComplianceStatsUseCase(
    this._dietRepository,
    this._violationRepository,
    this._foodLogRepository,
    this._authService,
  );

  @override
  Future<Result<ComplianceStats, AppError>> call(ComplianceStatsInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    if (input.startDateEpoch >= input.endDateEpoch) {
      return Failure(ValidationError.fromFieldErrors({
        'dateRange': ['Start date must be before end date'],
      }));
    }

    // 3. Fetch diet
    final dietResult = await _dietRepository.getById(input.dietId);
    if (dietResult.isFailure) {
      return Failure(dietResult.errorOrNull!);
    }
    final diet = dietResult.valueOrNull!;

    // 4. Fetch violations in range
    final violationsResult = await _violationRepository.getByDiet(
      input.dietId,
      input.startDateEpoch,
      input.endDateEpoch,
    );
    if (violationsResult.isFailure) {
      return Failure(violationsResult.errorOrNull!);
    }
    final violations = violationsResult.valueOrNull!;

    // 5. Fetch food logs for the period
    final logsResult = await _foodLogRepository.getByDateRange(
      input.profileId,
      input.startDateEpoch,
      input.endDateEpoch,
    );
    if (logsResult.isFailure) {
      return Failure(logsResult.errorOrNull!);
    }
    final foodLogs = logsResult.valueOrNull!;

    // 6. Calculate statistics
    return Success(_calculateStats(diet, violations, foodLogs, input));
  }

  ComplianceStats _calculateStats(
    Diet diet,
    List<DietViolation> violations,
    List<FoodLog> foodLogs,
    ComplianceStatsInput input,
  ) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final todayStart = _startOfDay(now);
    final weekStart = now - (7 * Duration.millisecondsPerDay);
    final monthStart = now - (30 * Duration.millisecondsPerDay);

    // Calculate scores
    final dailyScore = _calculateScore(foodLogs, violations, todayStart, now);
    final weeklyScore = _calculateScore(foodLogs, violations, weekStart, now);
    final monthlyScore = _calculateScore(foodLogs, violations, monthStart, now);
    final overallScore = _calculateScore(
      foodLogs, violations, input.startDateEpoch, input.endDateEpoch);

    // Calculate streak
    final streak = _calculateStreak(foodLogs, violations);

    // Compliance by rule type
    final byRule = _calculateByRuleType(violations, diet.rules);

    // Daily trend
    final dailyTrend = _calculateDailyTrend(foodLogs, violations, input);

    return ComplianceStats(
      overallScore: overallScore,
      dailyScore: dailyScore,
      weeklyScore: weeklyScore,
      monthlyScore: monthlyScore,
      currentStreak: streak.current,
      longestStreak: streak.longest,
      totalViolations: violations.where((v) => v.wasDismissed != true).length,
      totalWarnings: violations.where((v) => v.wasDismissed == true).length,
      complianceByRule: byRule,
      recentViolations: violations.take(10).toList(),
      dailyTrend: dailyTrend,
    );
  }

  double _calculateScore(
    List<FoodLog> logs,
    List<DietViolation> violations,
    int start,
    int end,
  ) {
    final logsInRange = logs.where((l) =>
        l.timestamp >= start && l.timestamp <= end).length;
    final violationsInRange = violations.where((v) =>
        v.timestamp >= start && v.timestamp <= end).length;

    if (logsInRange == 0) return 100.0;
    return ((logsInRange - violationsInRange) / logsInRange * 100).clamp(0.0, 100.0);
  }

  int _startOfDay(int epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    return DateTime(dt.year, dt.month, dt.day).millisecondsSinceEpoch;
  }

  ({int current, int longest}) _calculateStreak(
    List<FoodLog> logs,
    List<DietViolation> violations,
  ) {
    // Implementation details: count consecutive days at 100%
    // This is a simplified version
    return (current: 0, longest: 0);
  }

  Map<DietRuleType, double> _calculateByRuleType(
    List<DietViolation> violations,
    List<DietRule> rules,
  ) {
    final result = <DietRuleType, double>{};
    for (final ruleType in DietRuleType.values) {
      final rulesOfType = rules.where((r) => r.ruleType == ruleType).length;
      final violationsOfType = violations.where((v) =>
          rules.any((r) => r.id == v.ruleId && r.ruleType == ruleType)).length;

      if (rulesOfType > 0) {
        result[ruleType] = ((rulesOfType - violationsOfType) / rulesOfType * 100)
            .clamp(0.0, 100.0);
      }
    }
    return result;
  }

  List<DailyCompliance> _calculateDailyTrend(
    List<FoodLog> logs,
    List<DietViolation> violations,
    ComplianceStatsInput input,
  ) {
    final result = <DailyCompliance>[];
    var current = input.startDateEpoch;

    while (current < input.endDateEpoch) {
      final dayEnd = current + Duration.millisecondsPerDay;
      final dayLogs = logs.where((l) => l.timestamp >= current && l.timestamp < dayEnd);
      final dayViolations = violations.where((v) =>
          v.timestamp >= current && v.timestamp < dayEnd);

      final score = dayLogs.isEmpty ? 100.0 :
          ((dayLogs.length - dayViolations.length) / dayLogs.length * 100).clamp(0.0, 100.0);

      result.add(DailyCompliance(
        dateEpoch: current,
        score: score,
        violations: dayViolations.where((v) => v.wasDismissed != true).length,
        warnings: dayViolations.where((v) => v.wasDismissed == true).length,
      ));

      current = dayEnd;
    }

    return result;
  }
}
```

#### 4.5.5 Intelligence Use Cases

```dart
// lib/domain/usecases/intelligence/detect_patterns_use_case.dart

class DetectPatternsUseCase implements UseCaseWithInput<List<Pattern>, DetectPatternsInput> {
  final PatternRepository _patternRepository;
  final ConditionLogRepository _conditionLogRepository;
  final FoodLogRepository _foodLogRepository;
  final SleepEntryRepository _sleepRepository;
  final PatternDetectionService _patternService;
  final ProfileAuthorizationService _authService;

  DetectPatternsUseCase(
    this._patternRepository,
    this._conditionLogRepository,
    this._foodLogRepository,
    this._sleepRepository,
    this._patternService,
    this._authService,
  );

  @override
  Future<Result<List<Pattern>, AppError>> call(DetectPatternsInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Calculate date range
    final now = DateTime.now().millisecondsSinceEpoch;
    final lookbackMs = input.lookbackDays * Duration.millisecondsPerDay;
    final startDate = now - lookbackMs;

    // 3. Fetch all relevant data
    final conditionLogsResult = await _conditionLogRepository.getByProfile(
      input.profileId,
      startDate: startDate,
      endDate: now,
    );
    if (conditionLogsResult.isFailure) {
      return Failure(conditionLogsResult.errorOrNull!);
    }

    final foodLogsResult = await _foodLogRepository.getByDateRange(
      input.profileId,
      startDate,
      now,
    );
    if (foodLogsResult.isFailure) {
      return Failure(foodLogsResult.errorOrNull!);
    }

    final sleepResult = await _sleepRepository.getByDateRange(
      input.profileId,
      startDate,
      now,
    );
    if (sleepResult.isFailure) {
      return Failure(sleepResult.errorOrNull!);
    }

    // 4. Check minimum data requirements
    final conditionLogs = conditionLogsResult.valueOrNull!;
    if (conditionLogs.length < input.minimumDataPoints) {
      // Not enough data - return empty (no patterns yet)
      return const Success([]);
    }

    // 5. Detect patterns
    final detectedPatterns = _patternService.detectPatterns(
      conditionLogs: conditionLogs,
      foodLogs: foodLogsResult.valueOrNull!,
      sleepEntries: sleepResult.valueOrNull!,
      patternTypes: input.patternTypes.isEmpty
          ? PatternType.values
          : input.patternTypes,
      minimumConfidence: input.minimumConfidence,
    );

    // 6. Filter by requested conditions (if specified)
    final filteredPatterns = input.conditionIds.isEmpty
        ? detectedPatterns
        : detectedPatterns.where((p) =>
            input.conditionIds.contains(p.entityId)).toList();

    // 7. Persist new patterns
    for (final pattern in filteredPatterns) {
      // Check if similar pattern already exists
      final similarResult = await _patternRepository.findSimilar(pattern.id);
      if (similarResult.isSuccess && similarResult.valueOrNull!.isNotEmpty) {
        // Update existing pattern's confidence/last observed
        final existing = similarResult.valueOrNull!.first;
        final updateResult = await _patternRepository.update(existing.copyWith(
          confidence: pattern.confidence,
          lastObservedAt: DateTime.now().millisecondsSinceEpoch,
          observationCount: existing.observationCount + 1,
        ));
        if (updateResult.isFailure) return Failure(updateResult.errorOrNull!);
      } else {
        // Create new pattern
        final createResult = await _patternRepository.create(pattern);
        if (createResult.isFailure) return Failure(createResult.errorOrNull!);
      }
    }

    return Success(filteredPatterns);
  }
}

// lib/domain/usecases/intelligence/analyze_triggers_use_case.dart

class AnalyzeTriggersUseCase
    implements UseCaseWithInput<List<TriggerCorrelation>, AnalyzeTriggersInput> {
  final TriggerCorrelationRepository _correlationRepository;
  final ConditionLogRepository _conditionLogRepository;
  final FoodLogRepository _foodLogRepository;
  final TriggerAnalysisService _analysisService;
  final ProfileAuthorizationService _authService;

  AnalyzeTriggersUseCase(
    this._correlationRepository,
    this._conditionLogRepository,
    this._foodLogRepository,
    this._analysisService,
    this._authService,
  );

  @override
  Future<Result<List<TriggerCorrelation>, AppError>> call(AnalyzeTriggersInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Calculate date range
    final now = DateTime.now().millisecondsSinceEpoch;
    final lookbackMs = input.lookbackDays * Duration.millisecondsPerDay;
    final startDate = now - lookbackMs;

    // 3. Fetch condition logs
    final conditionLogsResult = input.conditionId != null
        ? await _conditionLogRepository.getByCondition(
            input.conditionId!,
            startDate: startDate,
            endDate: now,
          )
        : await _conditionLogRepository.getByProfile(
            input.profileId,
            startDate: startDate,
            endDate: now,
          );
    if (conditionLogsResult.isFailure) {
      return Failure(conditionLogsResult.errorOrNull!);
    }

    // 4. Fetch food logs (potential triggers)
    final foodLogsResult = await _foodLogRepository.getByDateRange(
      input.profileId,
      startDate,
      now,
    );
    if (foodLogsResult.isFailure) {
      return Failure(foodLogsResult.errorOrNull!);
    }

    // 5. Check minimum data requirements
    final conditionLogs = conditionLogsResult.valueOrNull!;
    if (conditionLogs.length < input.minimumOccurrences) {
      return const Success([]);
    }

    // 6. Analyze correlations
    final correlations = _analysisService.analyzeCorrelations(
      conditionLogs: conditionLogs,
      foodLogs: foodLogsResult.valueOrNull!,
      timeWindows: input.timeWindowHours.isEmpty
          ? [6, 12, 24, 48, 72]
          : input.timeWindowHours,
      minimumConfidence: input.minimumConfidence,
      minimumOccurrences: input.minimumOccurrences,
    );

    // 7. Filter by significance
    final significantCorrelations = correlations
        .where((c) => c.pValue <= 0.05) // Statistical significance
        .where((c) => c.confidence >= input.minimumConfidence)
        .toList();

    // 8. Persist correlations
    for (final correlation in significantCorrelations) {
      await _correlationRepository.upsert(correlation);
    }

    return Success(significantCorrelations);
  }
}

// lib/domain/usecases/intelligence/generate_insights_use_case.dart

class GenerateInsightsUseCase
    implements UseCaseWithInput<List<HealthInsight>, GenerateInsightsInput> {
  final HealthInsightRepository _insightRepository;
  final PatternRepository _patternRepository;
  final TriggerCorrelationRepository _correlationRepository;
  final ConditionLogRepository _conditionLogRepository;
  final InsightGeneratorService _insightService;
  final ProfileAuthorizationService _authService;

  GenerateInsightsUseCase(
    this._insightRepository,
    this._patternRepository,
    this._correlationRepository,
    this._conditionLogRepository,
    this._insightService,
    this._authService,
  );

  @override
  Future<Result<List<HealthInsight>, AppError>> call(GenerateInsightsInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing patterns and correlations
    final patternsResult = await _patternRepository.getByProfile(input.profileId);
    if (patternsResult.isFailure) {
      return Failure(patternsResult.errorOrNull!);
    }

    final correlationsResult = await _correlationRepository.getByProfile(input.profileId);
    if (correlationsResult.isFailure) {
      return Failure(correlationsResult.errorOrNull!);
    }

    // 3. Fetch recent condition data for context
    final now = DateTime.now().millisecondsSinceEpoch;
    final recentStart = now - (7 * Duration.millisecondsPerDay);
    final recentLogsResult = await _conditionLogRepository.getByProfile(
      input.profileId,
      startDate: recentStart,
      endDate: now,
    );
    if (recentLogsResult.isFailure) {
      return Failure(recentLogsResult.errorOrNull!);
    }

    // 4. Generate insights
    final insights = _insightService.generateInsights(
      patterns: patternsResult.valueOrNull!,
      correlations: correlationsResult.valueOrNull!,
      recentLogs: recentLogsResult.valueOrNull!,
      categories: input.categories.isEmpty
          ? InsightCategory.values
          : input.categories,
      maxInsights: input.maxInsights,
    );

    // 5. Filter already dismissed insights
    final existingResult = await _insightRepository.getActive(
      input.profileId,
    );
    final existingIds = existingResult.isSuccess
        ? existingResult.valueOrNull!.map((i) => i.insightKey).toSet()
        : <String>{};

    final newInsights = insights
        .where((i) => !existingIds.contains(i.insightKey))
        .toList();

    // 6. Persist new insights
    for (final insight in newInsights) {
      await _insightRepository.create(insight);
    }

    // 7. Return all active insights (new + existing undismissed)
    final allActiveResult = await _insightRepository.getActive(
      input.profileId,
      limit: input.maxInsights,
    );

    return allActiveResult;
  }
}

// lib/domain/usecases/intelligence/generate_predictive_alerts_use_case.dart

class GeneratePredictiveAlertsUseCase
    implements UseCaseWithInput<List<PredictiveAlert>, GeneratePredictiveAlertsInput> {
  final PredictiveAlertRepository _alertRepository;
  final PatternRepository _patternRepository;
  final TriggerCorrelationRepository _correlationRepository;
  final ConditionLogRepository _conditionLogRepository;
  final MLModelRepository _mlModelRepository;
  final PredictionService _predictionService;
  final RateLimitService _rateLimitService;
  final ProfileAuthorizationService _authService;

  GeneratePredictiveAlertsUseCase(
    this._alertRepository,
    this._patternRepository,
    this._correlationRepository,
    this._conditionLogRepository,
    this._mlModelRepository,
    this._predictionService,
    this._rateLimitService,
    this._authService,
  );

  @override
  Future<Result<List<PredictiveAlert>, AppError>> call(
    GeneratePredictiveAlertsInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Rate limit check (max 1 per minute)
    final rateLimitResult = await _rateLimitService.checkLimit(
      input.profileId,
      RateLimitOperation.prediction,
    );
    if (rateLimitResult.isFailure) {
      return Failure(rateLimitResult.errorOrNull!);
    }
    if (!rateLimitResult.valueOrNull!.isAllowed) {
      return Failure(NetworkError.rateLimited(
        'prediction',
        Duration(seconds: rateLimitResult.valueOrNull!.retryAfterSeconds),
      ));
    }

    // 3. Load ML models
    final modelsResult = await _mlModelRepository.getActiveModels(input.profileId);
    if (modelsResult.isFailure) {
      return Failure(modelsResult.errorOrNull!);
    }

    // 4. Fetch patterns and correlations
    final patternsResult = await _patternRepository.getByProfile(input.profileId);
    final correlationsResult = await _correlationRepository.getByProfile(input.profileId);

    // 5. Fetch recent data for prediction
    final now = DateTime.now().millisecondsSinceEpoch;
    final recentStart = now - (7 * Duration.millisecondsPerDay);
    final recentLogsResult = await _conditionLogRepository.getByProfile(
      input.profileId,
      startDate: recentStart,
      endDate: now,
    );

    if (recentLogsResult.isFailure) {
      return Failure(recentLogsResult.errorOrNull!);
    }

    // 6. Generate predictions
    final alerts = <PredictiveAlert>[];
    final predictionWindow = Duration(hours: input.predictionWindowHours);

    // Flare-up predictions
    if (input.includeFlareUpPredictions) {
      final flareAlerts = await _predictionService.predictFlareUps(
        profileId: input.profileId,
        models: modelsResult.valueOrNull!,
        patterns: patternsResult.valueOrNull ?? [],
        recentLogs: recentLogsResult.valueOrNull!,
        predictionWindow: predictionWindow,
        minimumConfidence: input.minimumConfidence,
      );
      alerts.addAll(flareAlerts);
    }

    // Menstrual predictions
    if (input.includeMenstrualPredictions) {
      final menstrualAlerts = await _predictionService.predictMenstrualCycle(
        profileId: input.profileId,
        predictionWindow: predictionWindow,
      );
      alerts.addAll(menstrualAlerts);
    }

    // Trigger warnings
    if (input.includeTriggerWarnings) {
      final triggerAlerts = await _predictionService.generateTriggerWarnings(
        profileId: input.profileId,
        correlations: correlationsResult.valueOrNull ?? [],
        predictionWindow: predictionWindow,
        minimumConfidence: input.minimumConfidence,
      );
      alerts.addAll(triggerAlerts);
    }

    // Missed supplement predictions
    if (input.includeMissedSupplementPredictions) {
      final supplementAlerts = await _predictionService.predictMissedSupplements(
        profileId: input.profileId,
        patterns: patternsResult.valueOrNull ?? [],
      );
      alerts.addAll(supplementAlerts);
    }

    // 7. Filter by confidence threshold
    final filteredAlerts = alerts
        .where((a) => a.probability >= input.minimumConfidence)
        .toList();

    // 8. Persist alerts
    for (final alert in filteredAlerts) {
      await _alertRepository.create(alert);
    }

    // 9. Record rate limit operation
    await _rateLimitService.recordOperation(
      input.profileId,
      RateLimitOperation.prediction,
    );

    return Success(filteredAlerts);
  }
}

// lib/domain/usecases/intelligence/assess_data_quality_use_case.dart

class AssessDataQualityUseCase
    implements UseCaseWithInput<DataQualityReport, AssessDataQualityInput> {
  final ConditionLogRepository _conditionLogRepository;
  final FoodLogRepository _foodLogRepository;
  final SleepEntryRepository _sleepRepository;
  final FluidsEntryRepository _fluidsRepository;
  final IntakeLogRepository _intakeLogRepository;
  final DataQualityService _qualityService;
  final ProfileAuthorizationService _authService;

  AssessDataQualityUseCase(
    this._conditionLogRepository,
    this._foodLogRepository,
    this._sleepRepository,
    this._fluidsRepository,
    this._intakeLogRepository,
    this._qualityService,
    this._authService,
  );

  @override
  Future<Result<DataQualityReport, AppError>> call(AssessDataQualityInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Calculate date range
    final now = DateTime.now().millisecondsSinceEpoch;
    final lookbackMs = input.lookbackDays * Duration.millisecondsPerDay;
    final startDate = now - lookbackMs;

    // 3. Fetch all tracking data
    final conditionLogs = await _conditionLogRepository.getByProfile(
      input.profileId,
      startDate: startDate,
      endDate: now,
    );
    final foodLogs = await _foodLogRepository.getByDateRange(
      input.profileId,
      startDate,
      now,
    );
    final sleepEntries = await _sleepRepository.getByDateRange(
      input.profileId,
      startDate,
      now,
    );
    final fluidsEntries = await _fluidsRepository.getByDateRange(
      input.profileId,
      startDate,
      now,
    );
    final intakeLogs = await _intakeLogRepository.getByProfile(
      input.profileId,
      startDate: startDate,
      endDate: now,
    );

    // 4. Analyze data quality
    final scores = <String, DataTypeQuality>{};
    final gaps = <DataGap>[];
    final recommendations = <String>[];

    // Analyze each data type
    if (input.dataTypes.isEmpty || input.dataTypes.contains('conditions')) {
      if (conditionLogs.isSuccess) {
        final quality = _qualityService.assessConditionLogging(
          conditionLogs.valueOrNull!,
          startDate,
          now,
        );
        scores['conditions'] = quality;
        if (input.includeGapAnalysis) {
          gaps.addAll(_qualityService.findGaps(
            conditionLogs.valueOrNull!.map((l) => l.timestamp).toList(),
            startDate,
            now,
            'conditions',
          ));
        }
      }
    }

    if (input.dataTypes.isEmpty || input.dataTypes.contains('food')) {
      if (foodLogs.isSuccess) {
        final quality = _qualityService.assessFoodLogging(
          foodLogs.valueOrNull!,
          startDate,
          now,
        );
        scores['food'] = quality;
        if (input.includeGapAnalysis) {
          gaps.addAll(_qualityService.findGaps(
            foodLogs.valueOrNull!.map((l) => l.timestamp).toList(),
            startDate,
            now,
            'food',
          ));
        }
      }
    }

    if (input.dataTypes.isEmpty || input.dataTypes.contains('sleep')) {
      if (sleepEntries.isSuccess) {
        final quality = _qualityService.assessSleepLogging(
          sleepEntries.valueOrNull!,
          startDate,
          now,
        );
        scores['sleep'] = quality;
        if (input.includeGapAnalysis) {
          gaps.addAll(_qualityService.findGaps(
            sleepEntries.valueOrNull!.map((s) => s.bedTime).toList(),
            startDate,
            now,
            'sleep',
          ));
        }
      }
    }

    if (input.dataTypes.isEmpty || input.dataTypes.contains('fluids')) {
      if (fluidsEntries.isSuccess) {
        final quality = _qualityService.assessFluidsLogging(
          fluidsEntries.valueOrNull!,
          startDate,
          now,
        );
        scores['fluids'] = quality;
      }
    }

    if (input.dataTypes.isEmpty || input.dataTypes.contains('supplements')) {
      if (intakeLogs.isSuccess) {
        final quality = _qualityService.assessSupplementLogging(
          intakeLogs.valueOrNull!,
          startDate,
          now,
        );
        scores['supplements'] = quality;
      }
    }

    // 5. Calculate overall score
    final overallScore = scores.values.isEmpty
        ? 0.0
        : scores.values.map((q) => (q.completenessScore + q.consistencyScore) / 2.0).reduce((a, b) => a + b) / scores.values.length;

    // 6. Generate recommendations
    if (input.includeRecommendations) {
      recommendations.addAll(_qualityService.generateRecommendations(scores, gaps));
    }

    // Calculate days with data from scores
    final totalDaysWithData = scores.values
        .map((q) => q.actualEntries)
        .fold<int>(0, (sum, v) => sum > v ? sum : v); // max entries across types

    return Success(DataQualityReport(
      profileId: input.profileId,
      assessedAt: now,
      totalDaysAnalyzed: input.lookbackDays,
      daysWithData: totalDaysWithData,
      overallQualityScore: overallScore,
      byDataType: scores,
      gaps: gaps,
      recommendations: recommendations,
    ));
  }
}
```

#### 4.5.6 Notification Use Cases

```dart
// lib/domain/usecases/notifications/schedule_notification_use_case.dart

class ScheduleNotificationUseCase
    implements UseCase<ScheduleNotificationInput, NotificationSchedule> {
  final NotificationScheduleRepository _repository;
  final SupplementRepository _supplementRepository;
  final ConditionRepository _conditionRepository;
  final NotificationService _notificationService;
  final ProfileAuthorizationService _authService;

  ScheduleNotificationUseCase(
    this._repository,
    this._supplementRepository,
    this._conditionRepository,
    this._notificationService,
    this._authService,
  );

  @override
  Future<Result<NotificationSchedule, AppError>> call(
    ScheduleNotificationInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationError = await _validate(input);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 3. Create schedule entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final schedule = NotificationSchedule(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      type: input.type,
      entityId: input.entityId,
      timesMinutesFromMidnight: input.timesMinutesFromMidnight,
      weekdays: input.weekdays,
      isEnabled: true,
      customMessage: input.customMessage,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '',
      ),
    );

    // 4. Persist
    final createResult = await _repository.create(schedule);
    if (createResult.isFailure) {
      return Failure(createResult.errorOrNull!);
    }

    // 5. Schedule with platform notification service
    await _notificationService.scheduleNotifications(schedule);

    return createResult;
  }

  Future<ValidationError?> _validate(ScheduleNotificationInput input) async {
    final errors = <String, List<String>>{};

    // Times validation (1-10 times, each 0-1439)
    if (input.timesMinutesFromMidnight.isEmpty ||
        input.timesMinutesFromMidnight.length > 10) {
      errors['times'] = ['Must have 1-10 reminder times'];
    } else {
      for (final time in input.timesMinutesFromMidnight) {
        final timeError = ValidationRules.minutesFromMidnight(time, 'time');
        if (timeError != null) {
          errors['times'] = [timeError];
          break;
        }
      }
    }

    // Weekdays validation (1-7 days, each 0-6)
    if (input.weekdays.isEmpty || input.weekdays.length > 7) {
      errors['weekdays'] = ['Must have 1-7 weekdays selected'];
    } else {
      for (final day in input.weekdays) {
        if (day < 0 || day > 6) {
          errors['weekdays'] = ['Weekday must be 0-6 (Monday=0, Sunday=6)'];
          break;
        }
      }
    }

    // Entity ID required for supplement/condition types
    if ((input.type == NotificationType.supplementIndividual || input.type == NotificationType.supplementGrouped ||
        input.type == NotificationType.conditionCheckIn) &&
        input.entityId == null) {
      errors['entityId'] = ['Entity ID required for ${input.type.name} notifications'];
    }

    // Verify entity exists
    if (input.entityId != null) {
      if (input.type == NotificationType.supplementIndividual || input.type == NotificationType.supplementGrouped) {
        final supplementResult = await _supplementRepository.getById(input.entityId!);
        if (supplementResult.isFailure) {
          errors['entityId'] = ['Supplement not found'];
        }
      } else if (input.type == NotificationType.conditionCheckIn) {
        final conditionResult = await _conditionRepository.getById(input.entityId!);
        if (conditionResult.isFailure) {
          errors['entityId'] = ['Condition not found'];
        }
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}

// lib/domain/usecases/notifications/get_pending_notifications_use_case.dart

class GetPendingNotificationsUseCase
    implements UseCase<GetPendingNotificationsInput, List<PendingNotification>> {
  final NotificationScheduleRepository _repository;
  final SupplementRepository _supplementRepository;
  final NotificationService _notificationService;
  final ProfileAuthorizationService _authService;

  GetPendingNotificationsUseCase(
    this._repository,
    this._supplementRepository,
    this._notificationService,
    this._authService,
  );

  @override
  Future<Result<List<PendingNotification>, AppError>> call(
    GetPendingNotificationsInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    if (input.windowStartEpoch >= input.windowEndEpoch) {
      return Failure(ValidationError.fromFieldErrors({
        'window': ['Window start must be before window end'],
      }));
    }

    // 3. Fetch enabled schedules
    final schedulesResult = await _repository.getEnabled(
      input.profileId,
    );
    if (schedulesResult.isFailure) {
      return Failure(schedulesResult.errorOrNull!);
    }
    final schedules = schedulesResult.valueOrNull!;

    // 4. Calculate pending notifications in window
    final pending = <PendingNotification>[];
    for (final schedule in schedules) {
      // Get occurrences in window
      final occurrences = _calculateOccurrences(
        schedule,
        input.windowStartEpoch,
        input.windowEndEpoch,
      );

      for (final occurrenceEpoch in occurrences) {
        final notification = await _buildPendingNotification(schedule, occurrenceEpoch);
        pending.add(notification);
      }
    }

    // 5. Sort by scheduled time
    pending.sort((a, b) => a.scheduledTimeEpoch.compareTo(b.scheduledTimeEpoch));

    return Success(pending);
  }

  List<int> _calculateOccurrences(
    NotificationSchedule schedule,
    int windowStartEpoch,  // Epoch milliseconds
    int windowEndEpoch,    // Epoch milliseconds
  ) {
    final occurrences = <int>[];
    final windowStart = DateTime.fromMillisecondsSinceEpoch(windowStartEpoch);
    final windowEnd = DateTime.fromMillisecondsSinceEpoch(windowEndEpoch);
    var current = windowStart;

    while (current.isBefore(windowEnd)) {
      // Check if this day is in weekdays (0=Monday)
      final weekday = current.weekday - 1; // Convert to 0-indexed Monday start
      if (schedule.weekdays.contains(weekday)) {
        // Add each scheduled time for this day
        for (final minutes in schedule.timesMinutesFromMidnight) {
          final occurrence = DateTime(
            current.year,
            current.month,
            current.day,
            minutes ~/ 60,
            minutes % 60,
          );
          if (occurrence.isAfter(windowStart) && occurrence.isBefore(windowEnd)) {
            occurrences.add(occurrence.millisecondsSinceEpoch);
          }
        }
      }
      current = current.add(const Duration(days: 1));
    }

    return occurrences;
  }

  Future<PendingNotification> _buildPendingNotification(
    NotificationSchedule schedule,
    int scheduledTimeEpoch,  // Epoch milliseconds
  ) async {
    String title;
    String body;
    String? deepLink;

    switch (schedule.type) {
      case NotificationType.supplementIndividual:
      case NotificationType.supplementGrouped:
        // Fetch supplement name
        final supplementResult = await _supplementRepository.getById(schedule.entityId!);
        final supplementName = supplementResult.isSuccess
            ? supplementResult.valueOrNull!.name
            : 'Supplement';
        title = 'Supplement Reminder';
        body = schedule.customMessage ?? 'Time to take your $supplementName';
        deepLink = 'shadow://supplement/${schedule.entityId}/log';
        break;
      case NotificationType.mealBreakfast:
      case NotificationType.mealLunch:
      case NotificationType.mealDinner:
      case NotificationType.mealSnacks:
        title = 'Meal Reminder';
        body = schedule.customMessage ?? 'Time to log your meal';
        deepLink = 'shadow://food/log';
        break;
      case NotificationType.fluidsGeneral:
      case NotificationType.fluidsBowel:
        title = 'Fluids Reminder';
        body = schedule.customMessage ?? 'Time to log your fluids';
        deepLink = 'shadow://fluids/log';
        break;
      case NotificationType.waterInterval:
      case NotificationType.waterFixed:
      case NotificationType.waterSmart:
        title = 'Water Reminder';
        body = schedule.customMessage ?? 'Time to drink some water';
        deepLink = 'shadow://fluids/water';
        break;
      case NotificationType.sleepBedtime:
        title = 'Bedtime Reminder';
        body = schedule.customMessage ?? 'Time to start winding down';
        deepLink = 'shadow://sleep/log';
        break;
      case NotificationType.sleepWakeup:
        title = 'Good Morning';
        body = schedule.customMessage ?? 'Time to log how you slept';
        deepLink = 'shadow://sleep/log';
        break;
      case NotificationType.conditionCheckIn:
        title = 'Check-In Reminder';
        body = schedule.customMessage ?? 'How are you feeling?';
        deepLink = 'shadow://condition/${schedule.entityId}/log';
        break;
      default:
        title = 'Reminder';
        body = schedule.customMessage ?? 'You have a reminder';
        deepLink = 'shadow://home';
    }

    return PendingNotification(
      schedule: schedule,
      scheduledTimeEpoch: scheduledTimeEpoch,
      title: title,
      body: body,
      deepLink: deepLink,
    );
  }
}

// lib/domain/usecases/notifications/toggle_notification_use_case.dart

@freezed
class ToggleNotificationInput with _$ToggleNotificationInput {
  const factory ToggleNotificationInput({
    required String id,
    required String profileId,
    required bool enabled,
  }) = _ToggleNotificationInput;
}

class ToggleNotificationUseCase
    implements UseCase<ToggleNotificationInput, NotificationSchedule> {
  final NotificationScheduleRepository _repository;
  final NotificationService _notificationService;
  final ProfileAuthorizationService _authService;

  ToggleNotificationUseCase(
    this._repository,
    this._notificationService,
    this._authService,
  );

  @override
  Future<Result<NotificationSchedule, AppError>> call(
    ToggleNotificationInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing schedule
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }
    final existing = existingResult.valueOrNull!;

    // 3. Verify ownership
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 4. Update enabled status
    final updated = existing.copyWith(
      isEnabled: input.enabled,
      syncMetadata: existing.syncMetadata.copyWith(
        syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
        syncVersion: existing.syncMetadata.syncVersion + 1,
        syncIsDirty: true,
      ),
    );

    // 5. Persist
    final updateResult = await _repository.update(updated);
    if (updateResult.isFailure) {
      return Failure(updateResult.errorOrNull!);
    }

    // 6. Update platform notifications
    if (input.enabled) {
      await _notificationService.scheduleNotifications(updated);
    } else {
      await _notificationService.cancelNotifications(updated.id);
    }

    return updateResult;
  }
}
```

#### 4.5.7 Wearable Use Cases

```dart
// lib/domain/usecases/wearables/connect_wearable_use_case.dart

class ConnectWearableUseCase
    implements UseCaseWithInput<WearableConnection, ConnectWearableInput> {
  final WearableConnectionRepository _repository;
  final WearablePlatformService _platformService;
  final ProfileAuthorizationService _authService;

  ConnectWearableUseCase(
    this._repository,
    this._platformService,
    this._authService,
  );

  @override
  Future<Result<WearableConnection, AppError>> call(
    ConnectWearableInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Check platform availability
    final isAvailable = await _platformService.isAvailable(input.platform);
    if (!isAvailable) {
      return Failure(WearableError.platformUnavailable(input.platform));
    }

    // 3. Request permissions
    final permissionsResult = await _platformService.requestPermissions(
      input.platform,
      input.requestedPermissions,
    );
    if (permissionsResult.isFailure) {
      return Failure(permissionsResult.errorOrNull!);
    }
    final grantedPermissions = permissionsResult.valueOrNull!;

    if (grantedPermissions.isEmpty) {
      return Failure(WearableError.permissionDenied(input.platform));
    }

    // 4. Check for existing connection
    final existingResult = await _repository.getByPlatform(
      input.profileId,
      input.platform,
    );

    final now = DateTime.now().millisecondsSinceEpoch;
    WearableConnection connection;

    if (existingResult.isSuccess && existingResult.valueOrNull != null) {
      // Update existing connection
      final existing = existingResult.valueOrNull!;
      connection = existing.copyWith(
        isConnected: true,
        connectedAt: now,
        disconnectedAt: null,
        readPermissions: grantedPermissions.read,
        writePermissions: grantedPermissions.write,
        backgroundSyncEnabled: input.enableBackgroundSync,
        lastSyncStatus: null,
        lastSyncError: null,
        syncMetadata: existing.syncMetadata.copyWith(
          syncUpdatedAt: now,
          syncVersion: existing.syncMetadata.syncVersion + 1,
          syncIsDirty: true,
        ),
      );
      return _repository.update(connection);
    } else {
      // Create new connection
      final id = const Uuid().v4();
      connection = WearableConnection(
        id: id,
        clientId: input.clientId,
        profileId: input.profileId,
        platform: input.platform.name,
        isConnected: true,
        connectedAt: now,
        disconnectedAt: null,
        readPermissions: grantedPermissions.read,
        writePermissions: grantedPermissions.write,
        backgroundSyncEnabled: input.enableBackgroundSync,
        lastSyncAt: null,
        lastSyncStatus: null,
        lastSyncError: null,
        oauthRefreshToken: null, // Will be set for cloud APIs
        syncMetadata: SyncMetadata(
          syncCreatedAt: now,
          syncUpdatedAt: now,
          syncDeviceId: '',
        ),
      );
      return _repository.create(connection);
    }
  }
}

// lib/domain/usecases/wearables/sync_wearable_data_use_case.dart

class SyncWearableDataUseCase
    implements UseCaseWithInput<SyncWearableDataOutput, SyncWearableDataInput> {
  final WearableConnectionRepository _connectionRepository;
  final WearablePlatformService _platformService;
  final ImportedDataLogRepository _importLogRepository;
  final ActivityLogRepository _activityLogRepository;
  final SleepEntryRepository _sleepRepository;
  final FluidsEntryRepository _fluidsRepository;
  final RateLimitService _rateLimitService;
  final ProfileAuthorizationService _authService;

  SyncWearableDataUseCase(
    this._connectionRepository,
    this._platformService,
    this._importLogRepository,
    this._activityLogRepository,
    this._sleepRepository,
    this._fluidsRepository,
    this._rateLimitService,
    this._authService,
  );

  @override
  Future<Result<SyncWearableDataOutput, AppError>> call(
    SyncWearableDataInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Rate limit check (1 per 5 minutes per platform)
    final rateLimitResult = await _rateLimitService.checkLimit(
      '${input.profileId}_${input.platform.name}',
      RateLimitOperation.wearableSync,
    );
    if (rateLimitResult.isFailure) {
      return Failure(rateLimitResult.errorOrNull!);
    }
    if (!rateLimitResult.valueOrNull!.isAllowed) {
      return Failure(NetworkError.rateLimited(
        'sync',
        Duration(seconds: rateLimitResult.valueOrNull!.retryAfterSeconds),
      ));
    }

    // 3. Get connection
    final connectionResult = await _connectionRepository.getByPlatform(
      input.profileId,
      input.platform,
    );
    if (connectionResult.isFailure) {
      return Failure(connectionResult.errorOrNull!);
    }
    final connection = connectionResult.valueOrNull;
    if (connection == null || !connection.isConnected) {
      return Failure(WearableError.connectionFailed(input.platform));
    }

    // 4. Calculate sync range
    final now = DateTime.now().millisecondsSinceEpoch;
    final syncStart = input.startDate ?? connection.lastSyncAt ??
        (now - (7 * Duration.millisecondsPerDay)); // Default 7 days
    final syncEnd = input.endDate ?? now;

    // 5. Fetch data from platform
    final platformDataResult = await _platformService.fetchData(
      platform: input.platform,
      connection: connection,
      startDate: syncStart,
      endDate: syncEnd,
      dataTypes: (input.dataTypes == null || input.dataTypes!.isEmpty)
          ? connection.readPermissions
          : input.dataTypes!,
    );
    if (platformDataResult.isFailure) {
      // Update connection with error
      await _updateConnectionStatus(connection, 'failed', platformDataResult.errorOrNull!.message);
      return Failure(platformDataResult.errorOrNull!);
    }
    final platformData = platformDataResult.valueOrNull!;

    // 6. Import data
    var importedCount = 0;
    var skippedCount = 0;
    var errorCount = 0;

    // Import activities (steps, workouts)
    if (platformData.activities.isNotEmpty) {
      for (final activity in platformData.activities) {
        final result = await _importActivity(input.profileId, input.clientId, activity);
        if (result.isSuccess) {
          importedCount++;
        } else if (result.errorOrNull is ValidationError) {
          skippedCount++;
        } else {
          errorCount++;
        }
      }
    }

    // Import sleep
    if (platformData.sleepEntries.isNotEmpty) {
      for (final sleep in platformData.sleepEntries) {
        final result = await _importSleep(input.profileId, input.clientId, sleep);
        if (result.isSuccess) {
          importedCount++;
        } else if (result.errorOrNull is ValidationError) {
          skippedCount++;
        } else {
          errorCount++;
        }
      }
    }

    // Import water intake
    if (platformData.waterIntakes.isNotEmpty) {
      for (final water in platformData.waterIntakes) {
        final result = await _importWater(input.profileId, input.clientId, water);
        if (result.isSuccess) {
          importedCount++;
        } else if (result.errorOrNull is ValidationError) {
          skippedCount++;
        } else {
          errorCount++;
        }
      }
    }

    // 7. Log import
    final importLog = ImportedDataLog(
      id: const Uuid().v4(),
      clientId: input.clientId,
      profileId: input.profileId,
      source: input.platform.name,
      importedAt: now,
      recordCount: importedCount,
      skippedCount: skippedCount,
      errorCount: errorCount,
      syncRangeStart: syncStart,
      syncRangeEnd: syncEnd,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '',
      ),
    );
    await _importLogRepository.create(importLog);

    // 8. Update connection status
    final status = errorCount == 0
        ? 'success'
        : (importedCount > 0 ? 'partial' : 'failed');
    await _updateConnectionStatus(connection, status, null);

    // 9. Record rate limit
    await _rateLimitService.recordOperation(
      '${input.profileId}_${input.platform.name}',
      RateLimitOperation.wearableSync,
    );

    return Success(SyncWearableDataOutput(
      importedCount: importedCount,
      skippedCount: skippedCount,
      errorCount: errorCount,
      syncedRangeStart: syncStart,
      syncedRangeEnd: syncEnd,
    ));
  }

  Future<void> _updateConnectionStatus(
    WearableConnection connection,
    String status,
    String? error,
  ) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _connectionRepository.update(connection.copyWith(
      lastSyncAt: now,
      lastSyncStatus: status,
      lastSyncError: error,
      syncMetadata: connection.syncMetadata.copyWith(
        syncUpdatedAt: now,
        syncVersion: connection.syncMetadata.syncVersion + 1,
        syncIsDirty: true,
      ),
    ));
  }

  Future<Result<ActivityLog, AppError>> _importActivity(
    String profileId,
    String clientId,
    WearableActivity activity,
  ) async {
    // Check for duplicate by external ID
    final existing = await _activityLogRepository.getByExternalId(
      profileId,
      activity.externalId,
    );
    if (existing.isSuccess && existing.valueOrNull != null) {
      return Failure(ValidationError.duplicate('externalId', activity.externalId));
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final log = ActivityLog(
      id: const Uuid().v4(),
      clientId: clientId,
      profileId: profileId,
      timestamp: activity.startTime,
      activityIds: activity.mappedActivityId != null ? [activity.mappedActivityId!] : [],
      duration: activity.durationMinutes,
      notes: 'Imported from ${activity.source}',
      importExternalId: activity.externalId,
      importSource: activity.source,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    return _activityLogRepository.create(log);
  }

  Future<Result<SleepEntry, AppError>> _importSleep(
    String profileId,
    String clientId,
    WearableSleep sleep,
  ) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    // Similar pattern to _importActivity
    final existing = await _sleepRepository.getByExternalId(
      profileId,
      sleep.externalId,
    );
    if (existing.isSuccess && existing.valueOrNull != null) {
      return Failure(ValidationError.duplicate('externalId', sleep.externalId));
    }

    final entry = SleepEntry(
      id: const Uuid().v4(),
      clientId: clientId,
      profileId: profileId,
      bedTime: sleep.sleepStart,
      wakeTime: sleep.sleepEnd,
      notes: 'Imported from ${sleep.source}',
      externalId: sleep.externalId,
      importSource: sleep.source,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '',
      ),
    );

    return _sleepRepository.create(entry);
  }

  Future<Result<FluidsEntry, AppError>> _importWater(
    String profileId,
    String clientId,
    WearableWaterIntake water,
  ) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    // For water, we merge into existing daily entries
    final dayStart = _startOfDay(water.loggedAt);
    final dayEnd = dayStart + Duration.millisecondsPerDay;

    final existingResult = await _fluidsRepository.getByDateRange(
      profileId,
      dayStart,
      dayEnd,
    );

    if (existingResult.isSuccess && existingResult.valueOrNull!.isNotEmpty) {
      // Update existing entry
      final existing = existingResult.valueOrNull!.first;
      final currentWater = existing.waterIntakeMl ?? 0;
      final updated = existing.copyWith(
        waterIntakeMl: currentWater + water.amountMl,
        syncMetadata: existing.syncMetadata.copyWith(
          syncUpdatedAt: now,
          syncVersion: existing.syncMetadata.syncVersion + 1,
          syncIsDirty: true,
        ),
      );
      return _fluidsRepository.update(updated);
    } else {
      // Create new entry
      final entry = FluidsEntry(
        id: const Uuid().v4(),
        clientId: clientId,
        profileId: profileId,
        entryDate: water.loggedAt,
        waterIntakeMl: water.amountMl,
        syncMetadata: SyncMetadata(
          syncCreatedAt: now,
          syncUpdatedAt: now,
          syncDeviceId: '',
        ),
      );
      return _fluidsRepository.create(entry);
    }
  }

  int _startOfDay(int epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    return DateTime(dt.year, dt.month, dt.day).millisecondsSinceEpoch;
  }
}
```

#### 4.5.8 Auth Use Cases

```dart
// lib/domain/usecases/auth/sign_in_with_google_use_case.dart

@freezed
class SignInWithGoogleInput with _$SignInWithGoogleInput {
  const factory SignInWithGoogleInput({
    required String idToken,
    required String accessToken,
    String? serverAuthCode,
  }) = _SignInWithGoogleInput;
}

@freezed
class SignInResult with _$SignInResult {
  const factory SignInResult({
    required UserAccount user,
    required List<Profile> profiles,
    required bool isNewUser,
  }) = _SignInResult;
}

class SignInWithGoogleUseCase implements UseCase<SignInWithGoogleInput, SignInResult> {
  final UserAccountRepository _userRepository;
  final ProfileRepository _profileRepository;
  final AuthTokenService _tokenService;
  final GoogleAuthService _googleService;
  final DeviceInfoService _deviceService;

  SignInWithGoogleUseCase(
    this._userRepository,
    this._profileRepository,
    this._tokenService,
    this._googleService,
    this._deviceService,
  );

  @override
  Future<Result<SignInResult, AppError>> call(SignInWithGoogleInput input) async {
    // 1. Verify Google token
    final verifyResult = await _googleService.verifyIdToken(input.idToken);
    if (verifyResult.isFailure) {
      return Failure(AuthError.invalidToken('Google token verification failed'));
    }
    final googleUser = verifyResult.valueOrNull!;

    // 2. Look up or create user
    final existingResult = await _userRepository.getByAuthProvider(
      AuthProvider.google,
      googleUser.id,
    );

    final now = DateTime.now().millisecondsSinceEpoch;
    UserAccount user;
    bool isNewUser;

    if (existingResult.isSuccess && existingResult.valueOrNull != null) {
      // Existing user - update last sign in
      user = existingResult.valueOrNull!;
      isNewUser = false;

      // Check if account is active
      if (!user.isActive) {
        return Failure(AuthError.accountDeactivated(user.deactivatedReason));
      }

      await _userRepository.update(user.copyWith(
        lastSignInAt: now,
        syncMetadata: user.syncMetadata.copyWith(
          syncUpdatedAt: now,
          syncVersion: user.syncMetadata.syncVersion + 1,
          syncIsDirty: true,
        ),
      ));
    } else {
      // New user - create account
      final id = const Uuid().v4();
      final clientId = const Uuid().v4();

      user = UserAccount(
        id: id,
        clientId: clientId,
        authProvider: AuthProvider.google,
        authProviderId: googleUser.id,
        email: googleUser.email,
        displayName: googleUser.displayName,
        avatarUrl: googleUser.avatarUrl,
        isActive: true,
        deactivatedReason: null,
        createdAt: now,
        lastSignInAt: now,
        syncMetadata: SyncMetadata(
          syncCreatedAt: now,
          syncUpdatedAt: now,
          syncDeviceId: '',
        ),
      );

      final createResult = await _userRepository.create(user);
      if (createResult.isFailure) {
        return Failure(createResult.errorOrNull!);
      }
      user = createResult.valueOrNull!;
      isNewUser = true;

      // Create default profile for new user
      final profileId = const Uuid().v4();
      final profileClientId = const Uuid().v4();
      final defaultProfile = Profile(
        id: profileId,
        clientId: profileClientId,
        userId: user.id,
        name: googleUser.displayName ?? 'My Profile',
        isDefault: true,
        avatarUrl: googleUser.avatarUrl,
        syncMetadata: SyncMetadata(
          syncCreatedAt: now,
          syncUpdatedAt: now,
          syncDeviceId: '',
        ),
      );
      await _profileRepository.create(defaultProfile);
    }

    // 3. Register device
    await _deviceService.registerCurrentDevice(user.id);

    // 4. Generate auth tokens
    await _tokenService.storeTokens(
      userId: user.id,
      accessToken: input.accessToken,
      refreshToken: input.serverAuthCode,
    );

    // 5. Fetch profiles
    final profilesResult = await _profileRepository.getByUser(user.id);
    final profiles = profilesResult.isSuccess
        ? profilesResult.valueOrNull!
        : <Profile>[];

    return Success(SignInResult(
      user: user,
      profiles: profiles,
      isNewUser: isNewUser,
    ));
  }
}

// lib/domain/usecases/auth/sign_out_use_case.dart

class SignOutUseCase implements UseCaseNoInput<void> {
  final AuthTokenService _tokenService;
  final NotificationService _notificationService;
  final SyncService _syncService;
  final DeviceInfoService _deviceService;

  SignOutUseCase(
    this._tokenService,
    this._notificationService,
    this._syncService,
    this._deviceService,
  );

  @override
  Future<Result<void, AppError>> call() async {
    try {
      // 1. Push any pending sync changes
      await _syncService.pushPendingChanges();

      // 2. Cancel all notifications
      await _notificationService.cancelAllNotifications();

      // 3. Unregister device
      await _deviceService.unregisterCurrentDevice();

      // 4. Clear auth tokens
      await _tokenService.clearTokens();

      // 5. Clear local cache (but keep encrypted DB)
      // The DB remains for quick sign-in, but is re-synced

      return const Success(null);
    } catch (e, stack) {
      return Failure(AuthError.signOutFailed(e.toString(), stack));
    }
  }
}
```

#### 4.5.9 Sync Use Cases

```dart
// lib/domain/usecases/sync/push_changes_use_case.dart

@freezed
class PushChangesInput with _$PushChangesInput {
  const factory PushChangesInput({
    required String profileId,
    @Default(500) int maxBatchSize,
  }) = _PushChangesInput;
}

@freezed
class PushChangesResult with _$PushChangesResult {
  const factory PushChangesResult({
    required int pushedCount,
    required int failedCount,
    required List<SyncConflict> conflicts,
  }) = _PushChangesResult;
}

class PushChangesUseCase implements UseCase<PushChangesInput, PushChangesResult> {
  final SyncService _syncService;
  final ProfileAuthorizationService _authService;
  final RateLimitService _rateLimitService;

  PushChangesUseCase(
    this._syncService,
    this._authService,
    this._rateLimitService,
  );

  @override
  Future<Result<PushChangesResult, AppError>> call(PushChangesInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Rate limit check
    final rateLimitResult = await _rateLimitService.checkLimit(
      input.profileId,
      RateLimitOperation.sync,
    );
    if (rateLimitResult.isFailure) {
      return Failure(rateLimitResult.errorOrNull!);
    }
    if (!rateLimitResult.valueOrNull!.isAllowed) {
      return Failure(NetworkError.rateLimited(
        'sync',
        Duration(seconds: rateLimitResult.valueOrNull!.retryAfterSeconds),
      ));
    }

    // 3. Get pending changes
    final pendingResult = await _syncService.getPendingChanges(
      input.profileId,
      limit: input.maxBatchSize,
    );
    if (pendingResult.isFailure) {
      return Failure(pendingResult.errorOrNull!);
    }
    final pending = pendingResult.valueOrNull!;

    if (pending.isEmpty) {
      return const Success(PushChangesResult(
        pushedCount: 0,
        failedCount: 0,
        conflicts: [],
      ));
    }

    // 4. Push to cloud
    final pushResult = await _syncService.pushChanges(pending);
    if (pushResult.isFailure) {
      return Failure(pushResult.errorOrNull!);
    }

    // 5. Record rate limit
    await _rateLimitService.recordOperation(
      input.profileId,
      RateLimitOperation.sync,
    );

    return Success(pushResult.valueOrNull!);
  }
}

// lib/domain/usecases/sync/pull_changes_use_case.dart

@freezed
class PullChangesInput with _$PullChangesInput {
  const factory PullChangesInput({
    required String profileId,
    int? sinceVersion,             // Pull changes since this version
    @Default(500) int maxBatchSize,
  }) = _PullChangesInput;
}

@freezed
class PullChangesResult with _$PullChangesResult {
  const factory PullChangesResult({
    required int pulledCount,
    required int appliedCount,
    required int conflictCount,
    required List<SyncConflict> conflicts,
    required int latestVersion,
  }) = _PullChangesResult;
}

class PullChangesUseCase implements UseCase<PullChangesInput, PullChangesResult> {
  final SyncService _syncService;
  final ProfileAuthorizationService _authService;
  final RateLimitService _rateLimitService;

  PullChangesUseCase(
    this._syncService,
    this._authService,
    this._rateLimitService,
  );

  @override
  Future<Result<PullChangesResult, AppError>> call(PullChangesInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Rate limit check
    final rateLimitResult = await _rateLimitService.checkLimit(
      input.profileId,
      RateLimitOperation.sync,
    );
    if (rateLimitResult.isFailure) {
      return Failure(rateLimitResult.errorOrNull!);
    }
    if (!rateLimitResult.valueOrNull!.isAllowed) {
      return Failure(NetworkError.rateLimited(
        'sync',
        Duration(seconds: rateLimitResult.valueOrNull!.retryAfterSeconds),
      ));
    }

    // 3. Get last sync version if not provided
    int? sinceVersion = input.sinceVersion;
    if (sinceVersion == null) {
      final lastVersionResult = await _syncService.getLastSyncVersion(input.profileId);
      if (lastVersionResult.isFailure) {
        return Failure(lastVersionResult.errorOrNull!);
      }
      sinceVersion = lastVersionResult.valueOrNull;
    }

    // 4. Pull from cloud
    final pullResult = await _syncService.pullChanges(
      input.profileId,
      sinceVersion: sinceVersion,
      limit: input.maxBatchSize,
    );
    if (pullResult.isFailure) {
      return Failure(pullResult.errorOrNull!);
    }
    final remoteChanges = pullResult.valueOrNull!;

    if (remoteChanges.isEmpty) {
      return Success(PullChangesResult(
        pulledCount: 0,
        appliedCount: 0,
        conflictCount: 0,
        conflicts: [],
        latestVersion: sinceVersion ?? 0,
      ));
    }

    // 5. Apply changes with conflict detection
    final applyResult = await _syncService.applyChanges(
      input.profileId,
      remoteChanges,
    );
    if (applyResult.isFailure) {
      return Failure(applyResult.errorOrNull!);
    }

    // 6. Record rate limit
    await _rateLimitService.recordOperation(
      input.profileId,
      RateLimitOperation.sync,
    );

    return Success(applyResult.valueOrNull!);
  }
}

// lib/domain/usecases/sync/resolve_conflict_use_case.dart

@freezed
class ResolveConflictInput with _$ResolveConflictInput {
  const factory ResolveConflictInput({
    required String profileId,
    required String conflictId,
    required ConflictResolutionType resolution,
  }) = _ResolveConflictInput;
}

enum ConflictResolution {
  keepLocal(0),   // Use local version, overwrite remote
  keepRemote(1),  // Use remote version, overwrite local
  merge(2);       // Merge both versions (for compatible changes)

  final int value;
  const ConflictResolution(this.value);

  static ConflictResolution fromValue(int value) =>
    ConflictResolution.values.firstWhere((e) => e.value == value, orElse: () => keepLocal);
}

class ResolveConflictUseCase implements UseCase<ResolveConflictInput, void> {
  final SyncService _syncService;
  final ProfileAuthorizationService _authService;

  ResolveConflictUseCase(this._syncService, this._authService);

  @override
  Future<Result<void, AppError>> call(ResolveConflictInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Resolve conflict
    return _syncService.resolveConflict(
      input.conflictId,
      input.resolution,
    );
  }
}
```

---

## 5. Entity Contracts (Freezed)

ALL entities MUST use this exact Freezed pattern:

```dart
// lib/domain/entities/supplement.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplement.freezed.dart';
part 'supplement.g.dart';

@freezed
class Supplement with _$Supplement {
  const Supplement._(); // Required for custom methods

  const factory Supplement({
    required String id,
    required String clientId,    // Required for database merging support
    required String profileId,
    required String name,
    required SupplementForm form,
    String? customForm,          // User-defined form when form == 'other'
    required int dosageQuantity, // Number of units per dose (e.g., 2 capsules)
    required DosageUnit dosageUnit,
    @Default('') String brand,
    @Default('') String notes,
    @Default([]) List<SupplementIngredient> ingredients,
    @Default([]) List<SupplementSchedule> schedules,

    // Scheduling duration
    int? startDate,              // Epoch milliseconds - When to start taking (null = immediately)
    int? endDate,                // Epoch milliseconds - When to stop taking (null = ongoing)

    // Status
    @Default(false) bool isArchived, // Temporarily stopped, can reactivate
    required SyncMetadata syncMetadata,
  }) = _Supplement;

  factory Supplement.fromJson(Map<String, dynamic> json) =>
      _$SupplementFromJson(json);

  // Computed properties
  bool get hasSchedules => schedules.isNotEmpty;
  bool get isActive => !isArchived && syncMetadata.syncDeletedAt == null;
  bool get isWithinDateRange {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (startDate != null && now < startDate!) return false;
    if (endDate != null && now > endDate!) return false;
    return true;
  }

  String get displayDosage => '$dosageQuantity ${dosageUnit.abbreviation}';
}

// lib/domain/entities/supplement_ingredient.dart

/// VALUE OBJECT - Embedded in Supplement entity, not a standalone entity.
/// Does not require id, clientId, profileId, or syncMetadata.
/// Ingredient in a supplement (e.g., Vitamin D3, Magnesium Citrate)
@freezed
class SupplementIngredient with _$SupplementIngredient {
  const SupplementIngredient._();
  const factory SupplementIngredient({
    required String name,              // e.g., "Vitamin D3", "Magnesium Citrate"
    double? quantity,                  // Amount of this ingredient
    DosageUnit? unit,                  // Unit for quantity
    String? notes,                     // Additional details
  }) = _SupplementIngredient;

  factory SupplementIngredient.fromJson(Map<String, dynamic> json) =>
      _$SupplementIngredientFromJson(json);
}

// lib/domain/entities/supplement_schedule.dart

/// Schedule for when a supplement should be taken.
///
/// **DATABASE MAPPING:**
/// The database table `supplements` stores timing fields directly for the PRIMARY
/// schedule. Multiple schedules per supplement are stored as a JSON array in the
/// `schedules` column (see 10_DATABASE_SCHEMA.md for details).
///
/// Direct column mapping for primary schedule:
/// - anchor_events TEXT → anchorEvent (first event in comma-separated list)
/// - timing_type INTEGER → timingType
/// - offset_minutes INTEGER → offsetMinutes
/// - specific_time_minutes INTEGER → specificTimeMinutes
/// - frequency_type INTEGER → frequencyType
/// - every_x_days INTEGER → everyXDays
/// - weekdays TEXT → weekdays (JSON array)
///
/// When reading from DB:
/// 1. Parse primary schedule from direct columns
/// 2. If multiple anchor_events, create additional SupplementSchedule entries
/// 3. All share same timing/frequency settings
///
/// When writing to DB:
/// 1. Store first schedule's timing in direct columns
/// 2. Store anchor_events as comma-separated list of all schedules' events
/// 3. If schedules have different timing, store as JSON in `schedules_json` column
@freezed
class SupplementSchedule with _$SupplementSchedule {
  const SupplementSchedule._();
  const factory SupplementSchedule({
    required SupplementAnchorEvent anchorEvent,  // Wake, breakfast, lunch, dinner, bed
    required SupplementTimingType timingType,    // With, before, after, specific time
    @Default(0) int offsetMinutes,               // Minutes before/after anchor event
    int? specificTimeMinutes,                    // Minutes from midnight (for specificTime type)
    required SupplementFrequencyType frequencyType, // Daily, every X days, specific weekdays
    @Default(1) int everyXDays,                  // For everyXDays frequency
    @Default([0, 1, 2, 3, 4, 5, 6]) List<int> weekdays, // For specificWeekdays frequency
  }) = _SupplementSchedule;

  factory SupplementSchedule.fromJson(Map<String, dynamic> json) =>
      _$SupplementScheduleFromJson(json);
}

/// Anchor events for supplement timing
enum SupplementAnchorEvent {
  wake(0),
  breakfast(1),
  lunch(2),
  dinner(3),
  bed(4);

  final int value;
  const SupplementAnchorEvent(this.value);

  static SupplementAnchorEvent fromValue(int value) =>
    SupplementAnchorEvent.values.firstWhere((e) => e.value == value, orElse: () => wake);
}

// lib/domain/entities/fluids_entry.dart

@freezed
class FluidsEntry with _$FluidsEntry {
  const FluidsEntry._();

  const factory FluidsEntry({
    required String id,
    required String clientId,        // Required for database merging support
    required String profileId,
    required int entryDate,          // Epoch milliseconds

    // Water Intake (NEW)
    int? waterIntakeMl,              // Water consumed in milliliters
    String? waterIntakeNotes,        // Notes specific to water (e.g., "with lemon", "electrolytes")

    // Bowel tracking
    BowelCondition? bowelCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,

    // Urine tracking
    UrineCondition? urineCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,

    // Menstruation
    MenstruationFlow? menstruationFlow,

    // BBT
    double? basalBodyTemperature,
    int? bbtRecordedTime,            // Epoch milliseconds

    // Customizable "Other" Fluid (NEW)
    String? otherFluidName,          // User-defined name (e.g., "Discharge", "Mucus")
    String? otherFluidAmount,        // User-defined amount description
    String? otherFluidNotes,         // Notes specific to this other fluid entry

    // Import tracking (for wearable data)
    String? importSource,            // 'healthkit', 'googlefit', etc.
    String? importExternalId,        // External record ID for deduplication

    // File sync metadata (for bowel/urine photos)
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    @Default(false) bool isFileUploaded,

    // General notes for the entire fluids entry (bowel/urine observations, etc.)
    // Use section-specific notes (waterIntakeNotes, otherFluidNotes) for targeted info
    @Default('') String notes,
    @Default([]) List<String> photoIds,
    required SyncMetadata syncMetadata,
  }) = _FluidsEntry;

  factory FluidsEntry.fromJson(Map<String, dynamic> json) =>
      _$FluidsEntryFromJson(json);

  // Computed properties
  // NOTE: These computed properties map to the DB columns has_bowel_movement/has_urine_movement
  // When saving to DB: has_bowel_movement = hasBowelData ? 1 : 0
  // When loading from DB: bowelCondition is only queried if has_bowel_movement = 1
  bool get hasWaterData => waterIntakeMl != null;
  bool get hasBowelData => bowelCondition != null;  // Maps to DB: has_bowel_movement
  bool get hasUrineData => urineCondition != null;  // Maps to DB: has_urine_movement
  bool get hasMenstruationData => menstruationFlow != null;
  bool get hasBBTData => basalBodyTemperature != null;
  bool get hasOtherFluidData => otherFluidName != null;

  /// Temperature in Celsius (converts if stored in Fahrenheit)
  double? get bbtCelsius => basalBodyTemperature != null
      ? (basalBodyTemperature! - 32) * 5 / 9
      : null;
}
```

---

## 6. Validation Rules Contract

ALL validation MUST use these exact rules:

```dart
// lib/core/validation/validation_rules.dart

class ValidationRules {
  // ===== String length limits =====
  static const int nameMinLength = 2;             // Min for all name fields
  static const int nameMaxLength = 100;           // Default max for names
  static const int supplementNameMaxLength = 200; // Supplements can have longer names
  static const int conditionNameMaxLength = 200;  // Conditions can have longer names
  static const int activityNameMaxLength = 200;   // Activities can have longer names
  static const int foodNameMaxLength = 200;       // Foods can have longer names
  static const int dietNameMaxLength = 50;        // Diet names are shorter
  static const int photoAreaNameMaxLength = 200;  // Photo area names can be descriptive

  // Notes and content limits
  static const int notesMaxLength = 2000;         // Standard notes for most entities
  static const int journalContentMinLength = 10;
  static const int journalContentMaxLength = 50000; // Journals can be much longer
  static const int descriptionMaxLength = 1000;   // Descriptions benefit from detail
  static const int locationMaxLength = 200;
  static const int consistencyNotesMaxLength = 1000;
  static const int titleMaxLength = 200;
  static const int tagMaxLength = 50;
  static const int triggerMaxLength = 100;
  static const int servingSizeMaxLength = 50;
  static const int otherFluidNotesMaxLength = 5000;

  // Activity duration
  static const int activityDurationMinMinutes = 1;
  static const int activityDurationMaxMinutes = 1440; // 24 hours

  // Mood scale
  static const int moodMin = 1;
  static const int moodMax = 10;

  // Custom fluid naming
  static const int customFluidNameMinLength = 2;
  static const int customFluidNameMaxLength = 100;
  static const int otherFluidAmountMaxLength = 50;

  // ===== Compliance streak rules =====
  // A streak is consecutive days meeting compliance criteria
  // Streak resets when any of these conditions occur:
  static const int streakResetOnMissedDays = 1;  // Miss 1 day = streak resets
  static const double streakMinDailyCompliancePercent = 80.0;  // Must be 80%+ to count
  static const int streakGracePeriodHours = 4;  // Entry can be logged up to 4h late

  // ===== Supplement validation =====
  static const double dosageMinAmount = 0.001;
  static const double dosageMaxAmount = 999999.0;
  static const int dosageMaxDecimalPlaces = 6;
  static const int quantityPerDoseMin = 1;
  static const int quantityPerDoseMax = 100;
  static const int maxIngredientsPerSupplement = 20;

  // ===== BBT (Basal Body Temperature) =====
  // Note: Ranges are mathematically equivalent (±0.1°C tolerance for display rounding)
  static const double bbtMinFahrenheit = 95.0;   // = 35.0°C
  static const double bbtMaxFahrenheit = 105.0;  // = 40.56°C
  static const double bbtMinCelsius = 35.0;      // = 95.0°F
  static const double bbtMaxCelsius = 40.6;      // = 105.08°F (rounded for consistency)

  // ===== Water intake =====
  static const int waterIntakeMinMl = 0;
  static const int waterIntakeMaxMl = 10000;    // 10 liters per entry
  static const int dailyWaterGoalMinMl = 500;   // 0.5 liters
  static const int dailyWaterGoalMaxMl = 10000; // 10 liters

  // ===== Severity scales =====
  static const int severityMin = 1;
  static const int severityMax = 10;
  static const int menstruationFlowMin = 0;     // 0 = none
  static const int menstruationFlowMax = 4;     // 4 = heavy

  // ===== Time constraints =====
  static const int maxScheduleTimesPerDay = 10;
  static const int maxNotificationSchedules = 50;
  static const int minReminderIntervalMinutes = 5;
  static const int maxReminderIntervalMinutes = 1440;  // 24 hours

  // ===== Collection limits =====
  static const int maxPhotosPerEntry = 10;              // Default for fluids, journal
  static const int maxPhotosPerConditionLog = 5;       // Condition logs more restrictive
  static const int maxConditionsPerProfile = 100;
  static const int maxSupplementsPerProfile = 200;
  static const int maxDietsPerProfile = 20;
  static const int maxRulesPerDiet = 50;
  static const int maxFoodItemsPerProfile = 1000;
  static const int maxActivitiesPerProfile = 100;

  // ===== Photo size limits =====
  // CANONICAL: These are the authoritative values. See 18_PHOTO_PROCESSING.md for details.
  static const int photoInputMaxBytes = 10 * 1024 * 1024;        // 10 MB - max raw input size
  static const int photoCompressedStandardBytes = 500 * 1024;    // 500 KB - target after compression
  static const int photoCompressedHighDetailBytes = 1024 * 1024; // 1 MB - high-detail after compression
  static const int photoAbsoluteMaxBytes = 2 * 1024 * 1024;      // 2 MB - hard limit post-compression
  static const int photoMaxDimension = 2048;                     // 2048px max width or height
  static const int thumbnailSize = 200;                          // 200px thumbnail dimension
  static const int profilePhotoMaxBytes = 5 * 1024 * 1024;       // 5 MB - profile avatar only

  // ===== Diet system =====
  static const int macroLimitMinGrams = 0;
  static const int macroLimitMaxGrams = 10000;  // 10kg
  static const double calorieMinPerDay = 0;
  static const double calorieMaxPerDay = 20000;
  static const int eatingWindowMinMinutes = 60;   // 1 hour minimum window
  static const int eatingWindowMaxMinutes = 1380; // 23 hours maximum window

  // ===== Intelligence system =====
  static const int minDaysForPatternDetection = 14;
  static const int minDaysForTriggerCorrelation = 30;
  static const int minDaysForPredictiveAlerts = 60;
  static const double minConfidenceForInsight = 0.65;
  static const double minRelativeRiskForCorrelation = 1.5;

  // ===== Sync limits =====
  static const int maxSyncBatchSize = 500;
  static const int maxSyncRetries = 3;
  static const int syncRetryDelaySeconds = 30;

  // ===== UI display constants =====
  static const int earliestSelectableYear = 2000;
  static const int journalSnippetMaxLength = 100;
  static const int defaultPickerMaxTimes = 5;
  static const int badgeMaxDisplayCount = 99;
  static const int photoGalleryColumns = 3;

  // ===== Time validation constants =====
  static const int maxFutureTimestampToleranceMs = 60 * 60 * 1000; // 1 hour

  // ===== Search defaults =====
  static const int defaultSearchLimit = 20;

  // ===== Meal time detection =====
  // Per 38_UI_FIELD_SPECIFICATIONS.md Section 5.1
  static const int breakfastStartHour = 5;
  static const int breakfastEndHour = 10;
  static const int lunchStartHour = 11;
  static const int lunchEndHour = 14;
  static const int dinnerStartHour = 15;
  static const int dinnerEndHour = 20;

  // ===== Sleep UI constraints =====
  static const int timesAwakenedMax = 20;

  // ===== Intake snooze durations =====
  // Per 38_UI_FIELD_SPECIFICATIONS.md Section 4.2
  static const List<int> validSnoozeDurationMinutes = [5, 10, 15, 30, 60];

  // ===== Import source validation =====
  static const List<String> validSleepImportSources = [
    'healthkit',
    'googlefit',
    'apple_watch',
    'fitbit',
    'garmin',
    'manual',
  ];

  // ===== Tag display =====
  static const int tagPreviewMaxCount = 3;
}

// lib/core/validation/validators.dart

class Validators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? maxLength(String? value, int max, String fieldName) {
    if (value != null && value.length > max) {
      return '$fieldName must be $max characters or less';
    }
    return null;
  }

  static String? range(num? value, num min, num max, String fieldName) {
    if (value != null && (value < min || value > max)) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }

  static String? bbtFahrenheit(double? value) {
    return range(
      value,
      ValidationRules.bbtMinFahrenheit,
      ValidationRules.bbtMaxFahrenheit,
      'Temperature',
    );
  }

  static String? severity(int? value) {
    return range(value, ValidationRules.severityMin, ValidationRules.severityMax, 'Severity');
  }

  static String? waterIntakeMl(int? value) {
    return range(value, ValidationRules.waterIntakeMinMl, ValidationRules.waterIntakeMaxMl, 'Water intake');
  }

  static String? dosageAmount(double? value) {
    return range(value, ValidationRules.dosageMinAmount, ValidationRules.dosageMaxAmount, 'Dosage');
  }

  static String? quantityPerDose(int? value) {
    return range(value, ValidationRules.quantityPerDoseMin, ValidationRules.quantityPerDoseMax, 'Quantity per dose');
  }

  static String? menstruationFlow(int? value) {
    return range(value, ValidationRules.menstruationFlowMin, ValidationRules.menstruationFlowMax, 'Flow level');
  }

  static String? macroLimit(double? value) {
    return range(value, ValidationRules.macroLimitMinGrams, ValidationRules.macroLimitMaxGrams, 'Macro limit');
  }

  /// Validate eating window times (for intermittent fasting diets)
  /// Edge cases handled:
  /// - Overnight windows: start=20:00 (1200), end=12:00 (720) = valid 16-hour fast
  /// - Same time (0-minute window): INVALID - must be >= 1 hour
  /// - Boundary times: start=00:00 (0), end=23:59 (1439) = valid 24-hour window
  /// - Reversed times: treated as overnight window, not an error
  static String? eatingWindow(int startMinutes, int endMinutes) {
    // Validate times are in valid range (0-1439 minutes from midnight)
    if (startMinutes < 0 || startMinutes > 1439) {
      return 'Start time must be 0-1439 (minutes from midnight)';
    }
    if (endMinutes < 0 || endMinutes > 1439) {
      return 'End time must be 0-1439 (minutes from midnight)';
    }

    // Calculate duration, handling overnight windows
    // Example: start=20:00 (1200 min), end=12:00 (720 min)
    // Duration = (1440 - 1200) + 720 = 240 + 720 = 960 min (16 hours)
    final duration = endMinutes > startMinutes
        ? endMinutes - startMinutes
        : (1440 - startMinutes) + endMinutes;  // Overnight: minutes until midnight + minutes after midnight

    // Zero-minute window (same start and end) is invalid
    if (duration == 0) {
      return 'Eating window cannot be 0 minutes - start and end times must differ';
    }

    if (duration < ValidationRules.eatingWindowMinMinutes) {
      return 'Eating window must be at least 1 hour (60 minutes)';
    }
    if (duration > ValidationRules.eatingWindowMaxMinutes) {
      return 'Eating window cannot exceed 23 hours';
    }
    return null;
  }

  // ===== UUID Format Validators =====

  static final _uuidRegex = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  static String? uuid(String? value, String fieldName) {
    if (value == null || value.isEmpty) return null;
    if (!_uuidRegex.hasMatch(value)) {
      return '$fieldName must be a valid UUID';
    }
    return null;
  }

  static String? id(String? value) => uuid(value, 'ID');
  static String? clientId(String? value) => uuid(value, 'Client ID');
  static String? profileId(String? value) => uuid(value, 'Profile ID');

  // ===== Supplement Validators =====

  static String? brand(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Brand is required';
    }
    if (value.length > ValidationRules.nameMaxLength) {
      return 'Brand must be ${ValidationRules.nameMaxLength} characters or less';
    }
    return null;
  }

  static String? ingredientsCount(List? ingredients) {
    if (ingredients != null && ingredients.length > ValidationRules.maxIngredientsPerSupplement) {
      return 'Maximum ${ValidationRules.maxIngredientsPerSupplement} ingredients allowed';
    }
    return null;
  }

  // ===== Fluids Validators =====

  // Allowed characters for custom fluid names: letters, spaces, hyphens, apostrophes
  static final _fluidNameRegex = RegExp(r"^[a-zA-Z\s\-']+$");

  static String? otherFluidName(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.length < ValidationRules.customFluidNameMinLength) {
      return 'Fluid name must be at least ${ValidationRules.customFluidNameMinLength} characters';
    }
    if (value.length > ValidationRules.customFluidNameMaxLength) {
      return 'Fluid name must be ${ValidationRules.customFluidNameMaxLength} characters or less';
    }
    if (!_fluidNameRegex.hasMatch(value)) {
      return 'Fluid name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  static String? otherFluidAmount(String? value) {
    if (value != null && value.length > ValidationRules.otherFluidAmountMaxLength) {
      return 'Amount must be ${ValidationRules.otherFluidAmountMaxLength} characters or less';
    }
    return null;
  }

  static String? otherFluidConsistency(String? name, String? amount, String? notes) {
    // If any "other" field is provided, name should be provided
    if ((amount != null && amount.isNotEmpty) || (notes != null && notes.isNotEmpty)) {
      if (name == null || name.isEmpty) {
        return 'Fluid name is required when amount or notes are provided';
      }
    }
    return null;
  }

  static String? photoIdsCount(List? photoIds) {
    if (photoIds != null && photoIds.length > ValidationRules.maxPhotosPerEntry) {
      return 'Maximum ${ValidationRules.maxPhotosPerEntry} photos allowed';
    }
    return null;
  }

  static String? conditionLogPhotosCount(List? photoIds) {
    if (photoIds != null && photoIds.length > ValidationRules.maxPhotosPerConditionLog) {
      return 'Maximum ${ValidationRules.maxPhotosPerConditionLog} photos allowed for condition logs';
    }
    return null;
  }

  // ===== Entity Name Validators =====

  static String? entityName(String? value, String fieldName, int maxLength) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < ValidationRules.nameMinLength) {
      return '$fieldName must be at least ${ValidationRules.nameMinLength} characters';
    }
    if (value.length > maxLength) {
      return '$fieldName must be $maxLength characters or less';
    }
    return null;
  }

  static String? supplementName(String? value) =>
      entityName(value, 'Supplement name', ValidationRules.supplementNameMaxLength);

  static String? conditionName(String? value) =>
      entityName(value, 'Condition name', ValidationRules.conditionNameMaxLength);

  static String? activityName(String? value) =>
      entityName(value, 'Activity name', ValidationRules.activityNameMaxLength);

  static String? foodName(String? value) =>
      entityName(value, 'Food name', ValidationRules.foodNameMaxLength);

  static String? dietName(String? value) =>
      entityName(value, 'Diet name', ValidationRules.dietNameMaxLength);

  static String? photoAreaName(String? value) =>
      entityName(value, 'Photo area name', ValidationRules.photoAreaNameMaxLength);

  static String? journalContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Journal content is required';
    }
    if (value.length < ValidationRules.journalContentMinLength) {
      return 'Journal entry must be at least ${ValidationRules.journalContentMinLength} characters';
    }
    if (value.length > ValidationRules.journalContentMaxLength) {
      return 'Journal entry must be ${ValidationRules.journalContentMaxLength} characters or less';
    }
    return null;
  }

  static String? notes(String? value) {
    if (value != null && value.length > ValidationRules.notesMaxLength) {
      return 'Notes must be ${ValidationRules.notesMaxLength} characters or less';
    }
    return null;
  }

  // ===== Date Validators =====

  static String? notFutureDate(int? epochMs, String fieldName) {
    if (epochMs == null) return null;
    if (epochMs > DateTime.now().millisecondsSinceEpoch) {
      return '$fieldName cannot be in the future';
    }
    return null;
  }

  static String? notPastDate(int? epochMs, String fieldName) {
    if (epochMs == null) return null;
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day).millisecondsSinceEpoch;
    if (epochMs < startOfToday) {
      return '$fieldName cannot be in the past';
    }
    return null;
  }

  static String? mustBePastDate(int? epochMs, String fieldName) {
    if (epochMs == null) return null;
    if (epochMs >= DateTime.now().millisecondsSinceEpoch) {
      return '$fieldName must be a past date';
    }
    return null;
  }

  // ===== Conditional Validators =====

  static String? requiredIf(String? value, bool condition, String fieldName, String conditionDesc) {
    if (condition && (value == null || value.trim().isEmpty)) {
      return '$fieldName is required when $conditionDesc';
    }
    return null;
  }

  static String? atLeastOneRequired(List? items, String fieldName) {
    if (items == null || items.isEmpty) {
      return 'At least one $fieldName is required';
    }
    return null;
  }

  // ===== Diet Validators =====

  static String? dateRange(int? startDate, int? endDate) {  // Epoch ms
    if (startDate != null && endDate != null && endDate < startDate) {
      return 'End date must be after start date';
    }
    return null;
  }

  static String? dietRuleNumericValue(DietRuleType type, double? value) {
    if (value == null) return null;

    switch (type) {
      case DietRuleType.maxCarbs:
      case DietRuleType.maxFat:
      case DietRuleType.maxProtein:
      case DietRuleType.minCarbs:
      case DietRuleType.minFat:
      case DietRuleType.minProtein:
        return range(value, 0, ValidationRules.macroLimitMaxGrams, 'Macro value');
      case DietRuleType.carbPercentage:
      case DietRuleType.fatPercentage:
      case DietRuleType.proteinPercentage:
        return range(value, 0, 100, 'Percentage');
      case DietRuleType.maxCalories:
        return range(value, ValidationRules.calorieMinPerDay, ValidationRules.calorieMaxPerDay, 'Calories');
      case DietRuleType.fastingHours:
        return range(value, 1, 23, 'Fasting hours');
      case DietRuleType.maxMealsPerDay:
        return range(value, 1, 10, 'Meals per day');
      case DietRuleType.mealSpacing:
        return range(value, 1, 12, 'Meal spacing hours');
      default:
        return null;
    }
  }

  static String? daysOfWeek(List<int>? days) {
    if (days == null) return null;
    for (final day in days) {
      if (day < 0 || day > 6) {
        return 'Day of week must be 0 (Monday) through 6 (Sunday)';
      }
    }
    return null;
  }

  // ===== Notification Schedule Validators =====

  static String? timeMinutesFromMidnight(int? value) {
    if (value == null) return null;
    if (value < 0 || value > 1439) {
      return 'Time must be 0-1439 (minutes from midnight)';
    }
    return null;
  }

  static String? timesMinutesFromMidnight(List<int>? times) {
    if (times == null) return null;
    if (times.length > ValidationRules.maxScheduleTimesPerDay) {
      return 'Maximum ${ValidationRules.maxScheduleTimesPerDay} times per schedule';
    }
    for (final time in times) {
      final error = timeMinutesFromMidnight(time);
      if (error != null) return error;
    }
    return null;
  }

  static String? weekdays(List<int>? days) {
    if (days == null) return null;
    for (final day in days) {
      if (day < 0 || day > 6) {
        return 'Weekday must be 0 (Monday) through 6 (Sunday)';
      }
    }
    if (days.isEmpty) {
      return 'At least one weekday must be selected';
    }
    return null;
  }

  // ===== Intelligence System Validators =====

  static String? confidence(double? value) {
    if (value == null) return null;
    if (value < 0 || value > 1) {
      return 'Confidence must be between 0 and 1';
    }
    return null;
  }

  static String? probability(double? value) {
    if (value == null) return null;
    if (value < 0 || value > 1) {
      return 'Probability must be between 0 and 1';
    }
    return null;
  }

  static String? pValue(double? value) {
    if (value == null) return null;
    if (value < 0 || value > 1) {
      return 'P-value must be between 0 and 1';
    }
    return null;
  }

  static String? relativeRisk(double? value) {
    if (value == null) return null;
    if (value < 0) {
      return 'Relative risk must be non-negative';
    }
    return null;
  }
}

// ===== Error Message Templates =====

class ValidationMessages {
  static String invalidFormat(String field, String expected) =>
      '$field format is invalid. Expected: $expected';

  static String tooShort(String field, int min) =>
      '$field must be at least $min characters';

  static String tooLong(String field, int max) =>
      '$field must be $max characters or less';

  static String duplicate(String field) =>
      'A record with this $field already exists';

  static String outOfRange(String field, num min, num max) =>
      '$field must be between $min and $max';

  static String required(String field) =>
      '$field is required';

  static String invalidUuid(String field) =>
      '$field must be a valid UUID';

  static String maxCount(String field, int max) =>
      'Maximum $max $field allowed';
}
```

---

## 7. Provider Contracts (Riverpod)

ALL providers MUST follow this exact pattern:

```dart
// lib/presentation/providers/supplement_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supplement_provider.g.dart';

/// State for supplement list operations.
/// MUST use this exact state class pattern.
@freezed
class SupplementListState with _$SupplementListState {
  const factory SupplementListState({
    @Default([]) List<Supplement> supplements,
    @Default([]) List<Supplement> archivedSupplements,
    @Default(false) bool showArchived,
    @Default(false) bool isLoading,
    AppError? error,
  }) = _SupplementListState;
}

@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<SupplementListState> build(String profileId) async {
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) => SupplementListState(supplements: supplements),
      failure: (error) => SupplementListState(error: error),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(/* profileId from arg */));
  }

  Future<Result<Supplement, AppError>> addSupplement(Supplement supplement) async {
    final useCase = ref.read(createSupplementUseCaseProvider);
    final result = await useCase(supplement);

    if (result.isSuccess) {
      ref.invalidateSelf();
    }

    return result;
  }
}
```

### 7.1 Riverpod Framework Exceptions to Result Pattern

> **IMPORTANT:** The `build()` and `refresh()` methods above do NOT return `Result<T, AppError>`.
> This is NOT a violation of the coding standards. These methods are **framework-constrained**:
>
> - **`build()`**: Must return `Future<State>` per Riverpod's `@riverpod` code generation
> - **`refresh()`**: Sets `state = AsyncLoading()` then `state = AsyncValue.guard(...)` per Riverpod patterns
>
> Errors are captured in the **state object's `AppError? error` field** instead of being returned.
> The UI checks `state.value?.error` to display error states.
>
> All **custom action methods** (like `addSupplement`, `deleteSupplement`, etc.) MUST return
> `Future<Result<T, AppError>>` and follow the standard Result pattern.

### 7.2 Complete Provider Implementation Templates

This section provides complete implementation examples for ALL Riverpod providers. Each provider follows the canonical pattern established in Section 7.

#### 7.2.1 Entity List Provider Template

```dart
// lib/presentation/providers/entity_list_provider.dart
//
// TEMPLATE: Use this pattern for all entity list providers.
// Replace "Entity" with actual entity name (Supplement, Condition, etc.)

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entity_list_provider.g.dart';

/// State for entity list operations
@freezed
class EntityListState with _$EntityListState {
  const factory EntityListState({
    @Default([]) List<Entity> items,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,        // For pagination
    @Default(0) int currentPage,
    AppError? error,
  }) = _EntityListState;
}

/// Provider for managing a list of entities
@riverpod
class EntityList extends _$EntityList {
  String? _profileId;  // Store for refresh

  @override
  Future<EntityListState> build(String profileId) async {
    _profileId = profileId;
    final useCase = ref.read(getEntitiesUseCaseProvider);
    final result = await useCase(GetEntitiesInput(
      profileId: profileId,
      limit: 50,
      offset: 0,
    ));

    return result.when(
      success: (items) => EntityListState(
        items: items,
        hasMore: items.length == 50,
        currentPage: 0,
      ),
      failure: (error) => EntityListState(error: error),
    );
  }

  /// Refresh the entire list
  Future<void> refresh() async {
    if (_profileId == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(_profileId!));
  }

  /// Load next page (pagination)
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoading || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoading: true));

    final useCase = ref.read(getEntitiesUseCaseProvider);
    final result = await useCase(GetEntitiesInput(
      profileId: _profileId!,
      limit: 50,
      offset: (current.currentPage + 1) * 50,
    ));

    result.when(
      success: (newItems) {
        state = AsyncData(current.copyWith(
          items: [...current.items, ...newItems],
          hasMore: newItems.length == 50,
          currentPage: current.currentPage + 1,
          isLoading: false,
        ));
      },
      failure: (error) {
        state = AsyncData(current.copyWith(
          error: error,
          isLoading: false,
        ));
      },
    );
  }

  /// Create a new entity
  Future<Result<Entity, AppError>> add(CreateEntityInput input) async {
    final useCase = ref.read(createEntityUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      // Optimistic update: add to list
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData(current.copyWith(
          items: [result.valueOrNull!, ...current.items],
        ));
      }
    }

    return result;
  }

  /// Update an existing entity
  Future<Result<Entity, AppError>> update(UpdateEntityInput input) async {
    final current = state.valueOrNull;

    // Optimistic update
    if (current != null) {
      final index = current.items.indexWhere((e) => e.id == input.id);
      if (index >= 0) {
        final optimisticItems = List<Entity>.from(current.items);
        // Apply partial update for optimistic UI
        optimisticItems[index] = _applyOptimisticUpdate(
          current.items[index],
          input,
        );
        state = AsyncData(current.copyWith(items: optimisticItems));
      }
    }

    final useCase = ref.read(updateEntityUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      // Replace with actual result
      final updatedCurrent = state.valueOrNull;
      if (updatedCurrent != null) {
        final index = updatedCurrent.items.indexWhere((e) => e.id == input.id);
        if (index >= 0) {
          final items = List<Entity>.from(updatedCurrent.items);
          items[index] = result.valueOrNull!;
          state = AsyncData(updatedCurrent.copyWith(items: items));
        }
      }
    } else {
      // Rollback optimistic update on failure
      if (current != null) {
        state = AsyncData(current);
      }
    }

    return result;
  }

  /// Delete an entity (soft delete)
  Future<Result<void, AppError>> delete(String id) async {
    final current = state.valueOrNull;

    // Optimistic update: remove from list
    if (current != null) {
      final items = current.items.where((e) => e.id != id).toList();
      state = AsyncData(current.copyWith(items: items));
    }

    final useCase = ref.read(deleteEntityUseCaseProvider);
    final result = await useCase(DeleteEntityInput(id: id, profileId: _profileId!));

    if (result.isFailure) {
      // Rollback on failure
      if (current != null) {
        state = AsyncData(current);
      }
    }

    return result;
  }

  Entity _applyOptimisticUpdate(Entity entity, UpdateEntityInput input) {
    // Override in specific providers to apply partial updates
    return entity;
  }
}
```

#### 7.2.2 Current Profile Provider

```dart
// lib/presentation/providers/profile_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

/// State for profile operations
@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    Profile? currentProfile,
    @Default([]) List<Profile> accessibleProfiles,
    @Default(false) bool isLoading,
    AppError? error,
  }) = _ProfileState;
}

/// Provider for current profile management
@riverpod
class CurrentProfile extends _$CurrentProfile {
  @override
  Future<ProfileState> build() async {
    final authState = ref.watch(authStateProvider);

    // Not signed in
    if (!authState.isSignedIn) {
      return const ProfileState();
    }

    // Fetch accessible profiles
    final useCase = ref.read(getAccessibleProfilesUseCaseProvider);
    final result = await useCase();

    return result.when(
      success: (profiles) {
        final defaultProfile = profiles.firstWhereOrNull((p) => p.isDefault);
        return ProfileState(
          currentProfile: defaultProfile ?? profiles.firstOrNull,
          accessibleProfiles: profiles,
        );
      },
      failure: (error) => ProfileState(error: error),
    );
  }

  /// Switch to a different profile
  Future<Result<void, AppError>> switchProfile(String profileId) async {
    final current = state.valueOrNull;
    if (current == null) {
      return Failure(BusinessError.invalidState('ProfileState', 'null', 'initialized'));
    }

    final profile = current.accessibleProfiles.firstWhereOrNull(
      (p) => p.id == profileId,
    );
    if (profile == null) {
      return Failure(AuthError.profileAccessDenied(profileId));
    }

    state = AsyncData(current.copyWith(currentProfile: profile));

    // Persist selection
    final useCase = ref.read(setCurrentProfileUseCaseProvider);
    return useCase(profileId);
  }

  /// Create a new profile
  Future<Result<Profile, AppError>> createProfile(CreateProfileInput input) async {
    final useCase = ref.read(createProfileUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData(current.copyWith(
          accessibleProfiles: [...current.accessibleProfiles, result.valueOrNull!],
        ));
      }
    }

    return result;
  }

  /// Delete profile (only owner can delete, must not be last profile)
  Future<Result<void, AppError>> deleteProfile(String profileId) async {
    final current = state.valueOrNull;
    if (current == null) {
      return Failure(BusinessError.invalidState('ProfileState', 'null', 'initialized'));
    }

    if (current.accessibleProfiles.length <= 1) {
      return Failure(ValidationError.fromFieldErrors({
        'profile': ['Cannot delete the only remaining profile'],
      }));
    }

    if (current.currentProfile?.id == profileId) {
      return Failure(ValidationError.fromFieldErrors({
        'profile': ['Cannot delete the currently active profile. Switch to another profile first.'],
      }));
    }

    final useCase = ref.read(deleteProfileUseCaseProvider);
    final result = await useCase(DeleteProfileInput(profileId: profileId));

    if (result.isSuccess) {
      state = AsyncData(current.copyWith(
        accessibleProfiles: current.accessibleProfiles
            .where((p) => p.id != profileId)
            .toList(),
      ));
    }

    return result;
  }
}

/// Simple provider for just the current profile ID
/// NOTE: Use `Ref` (not deprecated FooRef) for Riverpod 3.0 compatibility
@riverpod
String? currentProfileId(Ref ref) {
  final profileState = ref.watch(currentProfileProvider);
  return profileState.valueOrNull?.currentProfile?.id;
}
```

#### 7.2.3 Supplement Provider (Enhanced)

```dart
// lib/presentation/providers/supplement_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supplement_provider.g.dart';

// SupplementListState: See Section 7 (line ~7862) for canonical definition

@riverpod
class SupplementList extends _$SupplementList {
  String? _profileId;

  @override
  Future<SupplementListState> build(String profileId) async {
    _profileId = profileId;
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) => SupplementListState(
        supplements: supplements.where((s) => !s.isArchived).toList(),
        archivedSupplements: supplements.where((s) => s.isArchived).toList(),
      ),
      failure: (error) => SupplementListState(error: error),
    );
  }

  Future<void> refresh() async {
    if (_profileId == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(_profileId!));
  }

  void toggleShowArchived() {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(showArchived: !current.showArchived));
    }
  }

  Future<Result<Supplement, AppError>> addSupplement(
    CreateSupplementInput input,
  ) async {
    final useCase = ref.read(createSupplementUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData(current.copyWith(
          supplements: [result.valueOrNull!, ...current.supplements],
        ));
      }
    }

    return result;
  }

  Future<Result<Supplement, AppError>> updateSupplement(
    UpdateSupplementInput input,
  ) async {
    final useCase = ref.read(updateSupplementUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      final current = state.valueOrNull;
      if (current != null) {
        final updated = result.valueOrNull!;
        state = AsyncData(current.copyWith(
          supplements: current.supplements
              .map((s) => s.id == updated.id ? updated : s)
              .toList(),
        ));
      }
    }

    return result;
  }

  Future<Result<Supplement, AppError>> archiveSupplement(
    String id, {
    required bool archive,
  }) async {
    final useCase = ref.read(archiveSupplementUseCaseProvider);
    final result = await useCase(ArchiveSupplementInput(
      id: id,
      profileId: _profileId!,
      archive: archive,
    ));

    if (result.isSuccess) {
      final current = state.valueOrNull;
      if (current != null) {
        final supplement = result.valueOrNull!;
        if (archive) {
          // Move to archived
          state = AsyncData(current.copyWith(
            supplements: current.supplements.where((s) => s.id != id).toList(),
            archivedSupplements: [supplement, ...current.archivedSupplements],
          ));
        } else {
          // Move to active
          state = AsyncData(current.copyWith(
            supplements: [supplement, ...current.supplements],
            archivedSupplements: current.archivedSupplements
                .where((s) => s.id != id)
                .toList(),
          ));
        }
      }
    }

    return result;
  }

  Future<Result<void, AppError>> deleteSupplement(String id) async {
    final current = state.valueOrNull;

    // Optimistic update
    if (current != null) {
      state = AsyncData(current.copyWith(
        supplements: current.supplements.where((s) => s.id != id).toList(),
        archivedSupplements: current.archivedSupplements
            .where((s) => s.id != id)
            .toList(),
      ));
    }

    final useCase = ref.read(deleteSupplementUseCaseProvider);
    final result = await useCase(DeleteEntityInput(
      id: id,
      profileId: _profileId!,
    ));

    if (result.isFailure && current != null) {
      // Rollback
      state = AsyncData(current);
    }

    return result;
  }
}

/// Provider for a single supplement
@riverpod
Future<Supplement?> supplement(Ref ref, String id) async {
  final useCase = ref.read(getSupplementByIdUseCaseProvider);
  final result = await useCase(id);
  return result.valueOrNull;
}
```

#### 7.2.4 Condition Provider

```dart
// lib/presentation/providers/condition_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'condition_provider.g.dart';

@freezed
class ConditionListState with _$ConditionListState {
  const factory ConditionListState({
    @Default([]) List<Condition> conditions,
    @Default({}) Map<String, List<ConditionLog>> recentLogs, // Last 7 days per condition
    @Default(false) bool isLoading,
    String? selectedCategoryId,
    AppError? error,
  }) = _ConditionListState;
}

@riverpod
class ConditionList extends _$ConditionList {
  String? _profileId;

  @override
  Future<ConditionListState> build(String profileId) async {
    _profileId = profileId;

    // Fetch conditions
    final conditionsUseCase = ref.read(getConditionsUseCaseProvider);
    final conditionsResult = await conditionsUseCase(GetConditionsInput(
      profileId: profileId,
      status: ConditionStatus.active,
    ));

    if (conditionsResult.isFailure) {
      return ConditionListState(error: conditionsResult.errorOrNull!);
    }

    final conditions = conditionsResult.valueOrNull!;

    // Fetch recent logs for each condition
    final recentLogs = <String, List<ConditionLog>>{};
    final now = DateTime.now().millisecondsSinceEpoch;
    final weekAgo = now - (7 * Duration.millisecondsPerDay);

    final logsUseCase = ref.read(getConditionLogsUseCaseProvider);
    for (final condition in conditions) {
      final logsResult = await logsUseCase(GetConditionLogsInput(
        profileId: profileId,
        conditionId: condition.id,
        startDate: weekAgo,
        endDate: now,
      ));
      if (logsResult.isSuccess) {
        recentLogs[condition.id] = logsResult.valueOrNull!;
      }
    }

    return ConditionListState(
      conditions: conditions,
      recentLogs: recentLogs,
    );
  }

  Future<void> refresh() async {
    if (_profileId == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(_profileId!));
  }

  void filterByCategory(String? categoryId) {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(selectedCategoryId: categoryId));
    }
  }

  Future<Result<Condition, AppError>> addCondition(
    CreateConditionInput input,
  ) async {
    final useCase = ref.read(createConditionUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData(current.copyWith(
          conditions: [...current.conditions, result.valueOrNull!],
          recentLogs: {
            ...current.recentLogs,
            result.valueOrNull!.id: [],
          },
        ));
      }
    }

    return result;
  }

  Future<Result<ConditionLog, AppError>> logCondition(
    LogConditionInput input,
  ) async {
    final useCase = ref.read(logConditionUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      final current = state.valueOrNull;
      if (current != null) {
        final conditionId = input.conditionId;
        final existingLogs = current.recentLogs[conditionId] ?? [];
        state = AsyncData(current.copyWith(
          recentLogs: {
            ...current.recentLogs,
            conditionId: [result.valueOrNull!, ...existingLogs],
          },
        ));
      }
    }

    return result;
  }
}

/// Provider for condition trend data
@riverpod
Future<ConditionTrend?> conditionTrend(
  Ref ref,
  String conditionId,
  int days,  // Positional — Riverpod code gen does not support optional named params
) async {
  final profileId = ref.watch(currentProfileIdProvider);
  if (profileId == null) return null;

  final now = DateTime.now().millisecondsSinceEpoch;
  final startDate = now - (days * Duration.millisecondsPerDay);

  final useCase = ref.read(getConditionTrendUseCaseProvider);
  final result = await useCase(GetConditionTrendInput(
    profileId: profileId,
    conditionId: conditionId,
    startDate: startDate,
    endDate: now,
  ));

  return result.valueOrNull;
}
```

#### 7.2.5 Fluids Entry Provider

```dart
// lib/presentation/providers/fluids_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fluids_provider.g.dart';

@freezed
class FluidsState with _$FluidsState {
  const FluidsState._();
  const factory FluidsState({
    FluidsEntry? todayEntry,
    @Default([]) List<FluidsEntry> weekEntries,
    @Default(0) int todayWaterMl,
    @Default(2500) int dailyWaterGoalMl,  // Default 2.5L goal
    @Default(false) bool isLoading,
    AppError? error,
  }) = _FluidsState;

  double get waterProgress => todayWaterMl / dailyWaterGoalMl;
  int get waterRemaining => (dailyWaterGoalMl - todayWaterMl).clamp(0, dailyWaterGoalMl);
}

@riverpod
class FluidsEntryList extends _$FluidsEntryList {
  String? _profileId;

  @override
  Future<FluidsState> build(String profileId) async {
    _profileId = profileId;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final todayEnd = todayStart + Duration.millisecondsPerDay;
    final weekStart = todayStart - (7 * Duration.millisecondsPerDay);

    // Fetch today's entry
    final todayUseCase = ref.read(getTodayFluidsEntryUseCaseProvider);
    final todayResult = await todayUseCase(GetTodayFluidsEntryInput(profileId: profileId));

    // Fetch week's entries
    final weekUseCase = ref.read(getFluidsEntriesUseCaseProvider);
    final weekResult = await weekUseCase(GetFluidsEntriesInput(
      profileId: profileId,
      startDate: weekStart,
      endDate: todayEnd,
    ));

    // Get water goal from profile settings
    final profileProvider = ref.read(currentProfileProvider);
    final waterGoal = profileProvider.valueOrNull?.currentProfile?.waterGoalMl ?? 2500;

    return FluidsState(
      todayEntry: todayResult.valueOrNull,
      weekEntries: weekResult.valueOrNull ?? [],
      todayWaterMl: todayResult.valueOrNull?.waterIntakeMl ?? 0,
      dailyWaterGoalMl: waterGoal,
    );
  }

  Future<void> refresh() async {
    if (_profileId == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(_profileId!));
  }

  /// Quick add water (common amounts)
  Future<Result<FluidsEntry, AppError>> addWater(int amountMl) async {
    final current = state.valueOrNull;
    if (current == null || _profileId == null) {
      return Failure(BusinessError.preconditionFailed('fluids operation', 'No fluids state available'));
    }

    // Optimistic update
    state = AsyncData(current.copyWith(
      todayWaterMl: current.todayWaterMl + amountMl,
    ));

    final useCase = ref.read(logFluidsEntryUseCaseProvider);
    final result = await useCase(LogFluidsEntryInput(
      profileId: _profileId!,
      clientId: const Uuid().v4(),
      entryDate: DateTime.now().millisecondsSinceEpoch,
      waterIntakeMl: (current.todayEntry?.waterIntakeMl ?? 0) + amountMl,
    ));

    if (result.isFailure) {
      // Rollback
      state = AsyncData(current);
    } else {
      // Update today's entry
      state = AsyncData(current.copyWith(
        todayEntry: result.valueOrNull,
        todayWaterMl: result.valueOrNull?.waterIntakeMl ?? current.todayWaterMl,
      ));
    }

    return result;
  }

  /// Log complete fluids entry
  Future<Result<FluidsEntry, AppError>> logEntry(
    LogFluidsEntryInput input,
  ) async {
    final useCase = ref.read(logFluidsEntryUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      await refresh(); // Refresh to get updated totals
    }

    return result;
  }

  /// Update water goal
  Future<Result<void, AppError>> setWaterGoal(int goalMl) async {
    final current = state.valueOrNull;
    if (current == null) return Failure(BusinessError.preconditionFailed('fluids operation', 'No state available'));

    state = AsyncData(current.copyWith(dailyWaterGoalMl: goalMl));

    // Persist to profile
    final useCase = ref.read(updateProfileUseCaseProvider);
    return useCase(UpdateProfileInput(
      profileId: _profileId!,
      waterGoalMl: goalMl,
    ));
  }
}

/// BBT chart data provider
@riverpod
Future<List<FluidsEntry>> bbtChartData(
  Ref ref,
  String profileId,
  int days,  // Positional — Riverpod code gen does not support optional named params
) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  final startDate = now - (days * Duration.millisecondsPerDay);

  final useCase = ref.read(getBBTEntriesUseCaseProvider);
  final result = await useCase(GetBBTEntriesInput(
    profileId: profileId,
    startDate: startDate,
    endDate: now,
  ));

  return result.valueOrNull ?? [];
}
```

#### 7.2.6 Notification Schedule Provider

```dart
// lib/presentation/providers/notification_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

@freezed
class NotificationScheduleState with _$NotificationScheduleState {
  const factory NotificationScheduleState({
    @Default([]) List<NotificationSchedule> schedules,
    @Default({}) Map<NotificationType, List<NotificationSchedule>> byType,
    @Default(false) bool isLoading,
    AppError? error,
  }) = _NotificationScheduleState;
}

@riverpod
class NotificationScheduleList extends _$NotificationScheduleList {
  String? _profileId;

  @override
  Future<NotificationScheduleState> build(String profileId) async {
    _profileId = profileId;

    final useCase = ref.read(getNotificationSchedulesUseCaseProvider);
    final result = await useCase(GetNotificationSchedulesInput(profileId: profileId));

    return result.when(
      success: (schedules) {
        // Group by type
        final byType = <NotificationType, List<NotificationSchedule>>{};
        for (final schedule in schedules) {
          byType.putIfAbsent(schedule.type, () => []).add(schedule);
        }
        return NotificationScheduleState(
          schedules: schedules,
          byType: byType,
        );
      },
      failure: (error) => NotificationScheduleState(error: error),
    );
  }

  Future<void> refresh() async {
    if (_profileId == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(_profileId!));
  }

  Future<Result<NotificationSchedule, AppError>> createSchedule(
    ScheduleNotificationInput input,
  ) async {
    final useCase = ref.read(scheduleNotificationUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      final current = state.valueOrNull;
      if (current != null) {
        final schedule = result.valueOrNull!;
        final byType = Map<NotificationType, List<NotificationSchedule>>.from(current.byType);
        byType.putIfAbsent(schedule.type, () => []).add(schedule);

        state = AsyncData(current.copyWith(
          schedules: [...current.schedules, schedule],
          byType: byType,
        ));
      }
    }

    return result;
  }

  Future<Result<NotificationSchedule, AppError>> toggleEnabled(
    String id, {
    required bool enabled,
  }) async {
    final useCase = ref.read(toggleNotificationUseCaseProvider);
    final result = await useCase(ToggleNotificationInput(
      id: id,
      profileId: _profileId!,
      enabled: enabled,
    ));

    if (result.isSuccess) {
      final current = state.valueOrNull;
      if (current != null) {
        final updated = result.valueOrNull!;
        state = AsyncData(current.copyWith(
          schedules: current.schedules
              .map((s) => s.id == id ? updated : s)
              .toList(),
        ));
      }
    }

    return result;
  }

  Future<Result<void, AppError>> deleteSchedule(String id) async {
    final current = state.valueOrNull;

    // Optimistic update
    if (current != null) {
      state = AsyncData(current.copyWith(
        schedules: current.schedules.where((s) => s.id != id).toList(),
      ));
    }

    final useCase = ref.read(deleteNotificationScheduleUseCaseProvider);
    final result = await useCase(DeleteEntityInput(
      id: id,
      profileId: _profileId!,
    ));

    if (result.isFailure && current != null) {
      state = AsyncData(current);
    }

    return result;
  }
}

/// Pending notifications for today
@riverpod
Future<List<PendingNotification>> pendingNotifications(
  Ref ref,
) async {
  final profileId = ref.watch(currentProfileIdProvider);
  if (profileId == null) return [];

  final now = DateTime.now();
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

  final useCase = ref.read(getPendingNotificationsUseCaseProvider);
  final result = await useCase(GetPendingNotificationsInput(
    profileId: profileId,
    windowStartEpoch: now.millisecondsSinceEpoch,
    windowEndEpoch: endOfDay.millisecondsSinceEpoch,
  ));

  if (result.isFailure) {
    throw result.errorOrNull!;
  }
  return result.valueOrNull ?? [];
}
```

#### 7.2.7 Auth State Provider

```dart
// lib/presentation/providers/auth_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    UserAccount? user,
    @Default(false) bool isLoading,
    @Default(false) bool isSignedIn,
    AppError? error,
  }) = _AuthState;
}

@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  Future<AuthState> build() async {
    // Check for existing session
    final tokenService = ref.read(authTokenServiceProvider);
    final hasToken = await tokenService.hasValidToken();

    if (!hasToken) {
      return const AuthState(isSignedIn: false);
    }

    // Fetch user account
    final useCase = ref.read(getCurrentUserUseCaseProvider);
    final result = await useCase();

    return result.when(
      success: (user) => AuthState(
        user: user,
        isSignedIn: true,
      ),
      failure: (error) {
        // Token invalid, clear it
        tokenService.clearTokens();
        return AuthState(error: error);
      },
    );
  }

  Future<Result<SignInResult, AppError>> signInWithGoogle(
    SignInWithGoogleInput input,
  ) async {
    state = AsyncData(state.valueOrNull?.copyWith(isLoading: true) ??
        const AuthState(isLoading: true));

    final useCase = ref.read(signInWithGoogleUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (signInResult) {
        state = AsyncData(AuthState(
          user: signInResult.user,
          isSignedIn: true,
        ));

        // Invalidate profile provider to refresh
        ref.invalidate(currentProfileProvider);
      },
      failure: (error) {
        state = AsyncData(AuthState(
          isSignedIn: false,
          error: error,
        ));
      },
    );

    return result;
  }

  Future<Result<SignInResult, AppError>> signInWithApple(
    SignInWithAppleInput input,
  ) async {
    state = AsyncData(state.valueOrNull?.copyWith(isLoading: true) ??
        const AuthState(isLoading: true));

    final useCase = ref.read(signInWithAppleUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (signInResult) {
        state = AsyncData(AuthState(
          user: signInResult.user,
          isSignedIn: true,
        ));
        ref.invalidate(currentProfileProvider);
      },
      failure: (error) {
        state = AsyncData(AuthState(
          isSignedIn: false,
          error: error,
        ));
      },
    );

    return result;
  }

  Future<Result<void, AppError>> signOut() async {
    final useCase = ref.read(signOutUseCaseProvider);
    final result = await useCase();

    if (result.isSuccess) {
      state = const AsyncData(AuthState(isSignedIn: false));
      ref.invalidate(currentProfileProvider);
    }

    return result;
  }
}

/// Simple bool provider for checking auth status
@riverpod
bool isSignedIn(Ref ref) {
  return ref.watch(authStateNotifierProvider).valueOrNull?.isSignedIn ?? false;
}
```

#### 7.2.8 Sync Provider

```dart
// lib/presentation/providers/sync_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_provider.g.dart';

@freezed
class SyncState with _$SyncState {
  const SyncState._();
  const factory SyncState({
    @Default(false) bool isSyncing,
    @Default(0) int pendingChanges,
    @Default(0) int conflictCount,
    int? lastSyncAt,
    String? lastSyncStatus,
    AppError? error,
  }) = _SyncState;

  bool get hasPendingChanges => pendingChanges > 0;
  bool get hasConflicts => conflictCount > 0;
}

@riverpod
class SyncNotifier extends _$SyncNotifier {
  @override
  Future<SyncState> build(String profileId) async {
    // Check pending changes count
    final syncService = ref.read(syncServiceProvider);
    final pendingResult = await syncService.getPendingChangesCount(profileId);
    final conflictResult = await syncService.getConflictCount(profileId);
    final lastSyncResult = await syncService.getLastSyncTime(profileId);

    return SyncState(
      pendingChanges: pendingResult.valueOrNull ?? 0,
      conflictCount: conflictResult.valueOrNull ?? 0,
      lastSyncAt: lastSyncResult.valueOrNull,
    );
  }

  Future<Result<PushChangesResult, AppError>> pushChanges() async {
    final current = state.valueOrNull;
    if (current == null) return Failure(BusinessError.preconditionFailed('sync operation', 'No sync state available'));

    state = AsyncData(current.copyWith(isSyncing: true, error: null));

    final useCase = ref.read(pushChangesUseCaseProvider);
    final result = await useCase(PushChangesInput(
      profileId: ref.read(currentProfileIdProvider)!,
    ));

    result.when(
      success: (pushResult) {
        state = AsyncData(current.copyWith(
          isSyncing: false,
          pendingChanges: current.pendingChanges - pushResult.pushedCount,
          conflictCount: current.conflictCount + pushResult.conflicts.length,
          lastSyncAt: DateTime.now().millisecondsSinceEpoch,
          lastSyncStatus: 'success',
        ));
      },
      failure: (error) {
        state = AsyncData(current.copyWith(
          isSyncing: false,
          lastSyncStatus: 'failed',
          error: error,
        ));
      },
    );

    return result;
  }

  Future<Result<PullChangesResult, AppError>> pullChanges() async {
    final current = state.valueOrNull;
    if (current == null) return Failure(BusinessError.preconditionFailed('sync operation', 'No sync state available'));

    state = AsyncData(current.copyWith(isSyncing: true, error: null));

    final useCase = ref.read(pullChangesUseCaseProvider);
    final result = await useCase(PullChangesInput(
      profileId: ref.read(currentProfileIdProvider)!,
    ));

    result.when(
      success: (pullResult) {
        state = AsyncData(current.copyWith(
          isSyncing: false,
          conflictCount: current.conflictCount + pullResult.conflictCount,
          lastSyncAt: DateTime.now().millisecondsSinceEpoch,
          lastSyncStatus: 'success',
        ));

        // Invalidate entity providers to refresh with new data
        ref.invalidate(supplementListProvider);
        ref.invalidate(conditionListProvider);
        // ... etc
      },
      failure: (error) {
        state = AsyncData(current.copyWith(
          isSyncing: false,
          lastSyncStatus: 'failed',
          error: error,
        ));
      },
    );

    return result;
  }

  Future<Result<void, AppError>> resolveConflict(
    String conflictId,
    ConflictResolutionType resolution,
  ) async {
    final useCase = ref.read(resolveConflictUseCaseProvider);
    final result = await useCase(ResolveConflictInput(
      profileId: ref.read(currentProfileIdProvider)!,
      conflictId: conflictId,
      resolution: resolution,
    ));

    if (result.isSuccess) {
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData(current.copyWith(
          conflictCount: (current.conflictCount - 1).clamp(0, 999999),
        ));
      }
    }

    return result;
  }

  /// Full sync (push then pull)
  Future<void> sync() async {
    await pushChanges();
    await pullChanges();
  }
}
```

### 7.3 UI Integration Patterns

#### 7.3.1 Error Display Widget

```dart
// lib/presentation/widgets/error_display.dart

/// Standard widget for displaying provider errors
class ProviderErrorDisplay extends ConsumerWidget {
  final AppError error;
  final VoidCallback? onRetry;

  const ProviderErrorDisplay({
    required this.error,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(error),
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              error.userMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (error.recoveryAction != RecoveryAction.none) ...[
              const SizedBox(height: 16),
              _buildRecoveryButton(context, ref),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIcon(AppError error) {
    if (error is NetworkError) return Icons.wifi_off;
    if (error is AuthError) return Icons.lock;
    if (error is DatabaseError) return Icons.storage;
    return Icons.error_outline;
  }

  Widget _buildRecoveryButton(BuildContext context, WidgetRef ref) {
    switch (error.recoveryAction) {
      case RecoveryAction.retry:
        return ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        );
      case RecoveryAction.reAuthenticate:
        return ElevatedButton.icon(
          onPressed: () {
            ref.read(authStateNotifierProvider.notifier).signOut();
            context.go('/sign-in');
          },
          icon: const Icon(Icons.login),
          label: const Text('Sign In Again'),
        );
      case RecoveryAction.checkConnection:
        return OutlinedButton.icon(
          onPressed: () => AppSettings.openWifiSettings(),
          icon: const Icon(Icons.settings),
          label: const Text('Check Connection'),
        );
      case RecoveryAction.goToSettings:
        return OutlinedButton.icon(
          onPressed: () => context.go('/settings'),
          icon: const Icon(Icons.settings),
          label: const Text('Open Settings'),
        );
      case RecoveryAction.refreshToken:
        return ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh Session'),
        );
      case RecoveryAction.contactSupport:
        return OutlinedButton.icon(
          onPressed: () => context.go('/settings/support'),
          icon: const Icon(Icons.support_agent),
          label: const Text('Contact Support'),
        );
      case RecoveryAction.freeStorage:
        return OutlinedButton.icon(
          onPressed: () => context.go('/settings/storage'),
          icon: const Icon(Icons.storage),
          label: const Text('Free Storage'),
        );
      case RecoveryAction.none:
        return const SizedBox.shrink();
    }
  }
}
```

#### 7.3.2 List Screen Pattern

```dart
// lib/presentation/screens/supplements_screen.dart

/// Example screen showing standard provider integration pattern
class SupplementsScreen extends ConsumerWidget {
  const SupplementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileId = ref.watch(currentProfileIdProvider);
    if (profileId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final supplementsAsync = ref.watch(supplementListProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/supplements/add'),
          ),
        ],
      ),
      body: supplementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ProviderErrorDisplay(
          error: error is AppError ? error : UnknownError(error.toString()),
          onRetry: () => ref.invalidate(supplementListProvider(profileId)),
        ),
        data: (state) {
          // Check for error in state
          if (state.error != null) {
            return ProviderErrorDisplay(
              error: state.error!,
              onRetry: () => ref.read(supplementListProvider(profileId).notifier).refresh(),
            );
          }

          if (state.displayedSupplements.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.medication,
              title: 'No Supplements',
              subtitle: 'Add supplements to track your intake',
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(supplementListProvider(profileId).notifier).refresh(),
            child: ListView.builder(
              itemCount: state.displayedSupplements.length,
              itemBuilder: (context, index) {
                final supplement = state.displayedSupplements[index];
                return SupplementListTile(
                  supplement: supplement,
                  onTap: () => context.push('/supplements/${supplement.id}'),
                  onArchive: () => _archiveSupplement(context, ref, profileId, supplement),
                  onDelete: () => _deleteSupplement(context, ref, profileId, supplement.id),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _archiveSupplement(
    BuildContext context,
    WidgetRef ref,
    String profileId,
    Supplement supplement,
  ) async {
    final result = await ref
        .read(supplementListProvider(profileId).notifier)
        .archiveSupplement(supplement.id, archive: !supplement.isArchived);

    if (result.isFailure && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorOrNull!.userMessage)),
      );
    }
  }

  Future<void> _deleteSupplement(
    BuildContext context,
    WidgetRef ref,
    String profileId,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Supplement?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await ref
          .read(supplementListProvider(profileId).notifier)
          .deleteSupplement(id);

      if (result.isFailure && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorOrNull!.userMessage)),
        );
      }
    }
  }
}
```

### 7.4 Provider Reference Table

| Provider | State Class | Primary Methods |
|----------|-------------|-----------------|
| `currentProfileProvider` | `ProfileState` | `switchProfile()`, `createProfile()`, `deleteProfile()` |
| `supplementListProvider` | `SupplementListState` | `add()`, `update()`, `archive()`, `delete()`, `refresh()` |
| `conditionListProvider` | `ConditionListState` | `add()`, `log()`, `refresh()`, `filterByCategory()` |
| `fluidsEntryListProvider` | `FluidsState` | `addWater()`, `logEntry()`, `setWaterGoal()`, `refresh()` |
| `foodLogListProvider` | `FoodLogListState` | `add()`, `update()`, `delete()`, `refresh()` |
| `sleepEntryListProvider` | `SleepEntryListState` | `add()`, `update()`, `delete()`, `refresh()` |
| `activityLogListProvider` | `ActivityLogListState` | `add()`, `update()`, `delete()`, `refresh()` |
| `journalEntryListProvider` | `JournalEntryListState` | `add()`, `update()`, `delete()`, `refresh()` |
| `photoEntryListProvider` | `PhotoEntryListState` | `add()`, `delete()`, `refresh()` |
| `notificationScheduleListProvider` | `NotificationScheduleState` | `create()`, `toggleEnabled()`, `delete()`, `refresh()` |
| `dietListProvider` | `DietListState` | `create()`, `activate()`, `delete()`, `refresh()` |
| `dietComplianceProvider` | `DietComplianceState` | `checkFood()`, `getStats()`, `refresh()` |
| `authStateNotifierProvider` | `AuthState` | `signInWithGoogle()`, `signInWithApple()`, `signOut()` |
| `syncNotifierProvider` | `SyncState` | `pushChanges()`, `pullChanges()`, `resolveConflict()`, `sync()` |
| `wearableConnectionListProvider` | `WearableConnectionState` | `connect()`, `disconnect()`, `sync()`, `refresh()` |
| `patternListProvider` | `PatternListState` | `detect()`, `dismiss()`, `refresh()` |
| `healthInsightListProvider` | `HealthInsightListState` | `generate()`, `dismiss()`, `refresh()` |
| `predictiveAlertListProvider` | `PredictiveAlertListState` | `generate()`, `dismiss()`, `provideFeedback()`, `refresh()` |

---

## 7.5 Diet Entity Contracts

### Diet Entity

```dart
// lib/domain/entities/diet.dart

@freezed
class Diet with _$Diet {
  const Diet._();

  const factory Diet({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    DietPresetType? presetType,           // NULL for custom diets, enum value for presets
    @Default(true) bool isActive,
    int? startDate,                       // Epoch milliseconds - For fixed-duration diets
    int? endDate,                         // Epoch milliseconds
    int? eatingWindowStartMinutes,        // Minutes from midnight (for IF diets)
    int? eatingWindowEndMinutes,          // Minutes from midnight
    @Default([]) List<DietRule> rules,    // Custom rules (preset rules loaded from code)
    String? notes,
    required SyncMetadata syncMetadata,
  }) = _Diet;

  factory Diet.fromJson(Map<String, dynamic> json) =>
      _$DietFromJson(json);

  // Computed properties
  bool get isPreset => presetType != null;
  bool get isCustom => presetType == null;
  bool get hasEatingWindow => eatingWindowStartMinutes != null && eatingWindowEndMinutes != null;
  bool get isFixedDuration => endDate != null;

  Duration? get eatingWindowDuration {
    if (!hasEatingWindow) return null;
    // Handle overnight windows (start > end means crosses midnight)
    final diff = eatingWindowEndMinutes! - eatingWindowStartMinutes!;
    final minutes = diff >= 0 ? diff : diff + 1440; // Add 24 hours if negative
    return Duration(minutes: minutes);
  }

  Duration? get fastingDuration {
    if (!hasEatingWindow) return null;
    return Duration(hours: 24) - eatingWindowDuration!;
  }
}
```

### DietRule Entity

```dart
// lib/domain/entities/diet_rule.dart
// NOTE: DietRuleType enum defined in Section 3.2 above

enum RuleSeverity {
  violation(0),
  warning(1),
  info(2);

  final int value;
  const RuleSeverity(this.value);
}

enum FoodCategory {
  meat(0), poultry(1), fish(2), eggs(3), dairy(4),
  vegetables(5), fruits(6), grains(7), legumes(8), nuts(9), seeds(10),
  gluten(11), nightshades(12), fodmaps(13), sugar(14), alcohol(15), caffeine(16),
  processedFoods(17), artificialSweeteners(18), friedFoods(19), rawFoods(20);

  final int value;
  const FoodCategory(this.value);
}

@freezed
class DietRule with _$DietRule {
  const DietRule._();
  const factory DietRule({
    required String id,
    required String clientId,         // REQUIRED: For database merging
    required String profileId,        // REQUIRED: FK to profiles
    required String dietId,           // FK to parent Diet
    required DietRuleType type,
    required RuleSeverity severity,
    FoodCategory? category,
    String? ingredientName,
    double? numericValue,
    TimeOfDay? timeValue,
    List<int>? daysOfWeek,
    String? description,
    String? violationMessage,
    required SyncMetadata syncMetadata, // REQUIRED: For sync
  }) = _DietRule;

  factory DietRule.fromJson(Map<String, dynamic> json) =>
      _$DietRuleFromJson(json);
}
```

### DietViolation Entity

```dart
// lib/domain/entities/diet_violation.dart

@freezed
class DietViolation with _$DietViolation {
  const DietViolation._();
  const factory DietViolation({
    required String id,
    required String clientId,
    required String profileId,
    required String dietId,
    required String foodLogId,
    String? ruleId,
    required DietRuleType ruleType,
    required RuleSeverity severity,
    required String message,
    required int timestamp,          // Epoch milliseconds
    @Default(false) bool wasDismissed,
    required SyncMetadata syncMetadata,
  }) = _DietViolation;

  factory DietViolation.fromJson(Map<String, dynamic> json) =>
      _$DietViolationFromJson(json);
}
```

### Diet Repository Contract

```dart
// lib/domain/repositories/diet_repository.dart

abstract class DietRepository implements EntityRepository<Diet, String> {
  /// Get active diet for a profile.
  Future<Result<Diet?, AppError>> getActiveDiet(String profileId);

  /// Get all diets for a profile (active and inactive).
  Future<Result<List<Diet>, AppError>> getByProfile(
    String profileId, {
    bool? activeOnly,
  });

  /// Activate a diet (deactivates others).
  Future<Result<Diet, AppError>> activate(String dietId);

  /// Deactivate current diet.
  Future<Result<void, AppError>> deactivate(String profileId);
}

abstract class DietRuleRepository implements EntityRepository<DietRule, String> {
  /// Get rules for a diet.
  Future<Result<List<DietRule>, AppError>> getByDiet(String dietId);
}

abstract class DietViolationRepository implements EntityRepository<DietViolation, String> {
  /// Get violations for a date range.
  Future<Result<List<DietViolation>, AppError>> getByDateRange(
    String profileId,
    int start,  // Epoch ms
    int end,    // Epoch ms
  );

  /// Get violations for a specific diet.
  Future<Result<List<DietViolation>, AppError>> getByDiet(
    String dietId,
    int start,  // Epoch ms
    int end,    // Epoch ms
  );

  /// Get violation count by rule type.
  Future<Result<Map<DietRuleType, int>, AppError>> getCountByType(
    String dietId,
    int start,  // Epoch ms
    int end,    // Epoch ms
  );
}
```

### Diet Compliance Use Cases

```dart
// lib/domain/usecases/diet/check_compliance_use_case.dart

/// Input for checking food compliance against a diet
/// ALL use case inputs MUST use @freezed for consistency
@freezed
class CheckComplianceInput with _$CheckComplianceInput {
  const factory CheckComplianceInput({
    required String profileId,
    required String dietId,
    required FoodItem foodItem,
    required int logTimeEpoch,           // Epoch milliseconds (matches DB storage)
  }) = _CheckComplianceInput;

  factory CheckComplianceInput.fromJson(Map<String, dynamic> json) =>
      _$CheckComplianceInputFromJson(json);
}

/// Result of a compliance check
@freezed
class ComplianceCheckResult with _$ComplianceCheckResult {
  const factory ComplianceCheckResult({
    required bool isCompliant,
    required List<DietRule> violatedRules,
    required double complianceImpact,      // How much this will reduce compliance %
    required List<FoodItem> alternatives,  // Suggested compliant alternatives
  }) = _ComplianceCheckResult;

  factory ComplianceCheckResult.fromJson(Map<String, dynamic> json) =>
      _$ComplianceCheckResultFromJson(json);
}

class CheckComplianceUseCase implements UseCase<CheckComplianceInput, ComplianceCheckResult> {
  final DietRepository _dietRepository;
  final FoodItemRepository _foodItemRepository;
  final DietComplianceService _complianceService;
  final ProfileAuthorizationService _authService;

  CheckComplianceUseCase(
    this._dietRepository,
    this._foodItemRepository,
    this._complianceService,
    this._authService,
  );

  @override
  Future<Result<ComplianceCheckResult, AppError>> call(CheckComplianceInput input) async {
    // 1. Authorization FIRST (per Coding Standards Section 5.5)
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Get diet with rules
    final dietResult = await _dietRepository.getById(input.dietId);
    if (dietResult.isFailure) return Failure(dietResult.errorOrNull!);

    final diet = dietResult.valueOrNull!;

    // 3. Check food against all rules
    final violations = _complianceService.checkFoodAgainstRules(
      input.foodItem,
      diet.rules,
      input.logTimeEpoch,
    );

    // 4. Calculate impact
    final impact = _complianceService.calculateImpact(
      input.profileId,
      violations,
    );

    // 5. Find alternatives if violations exist
    List<FoodItem> alternatives = [];
    if (violations.isNotEmpty) {
      final altResult = await _findAlternatives(
        input.foodItem,
        violations.map((v) => v.category).whereType<FoodCategory>().toList(),
      );
      if (altResult.isSuccess) {
        alternatives = altResult.valueOrNull!;
      }
    }

    return Success(ComplianceCheckResult(
      isCompliant: violations.isEmpty,
      violatedRules: violations,
      complianceImpact: impact,
      alternatives: alternatives,
    ));
  }
}

// lib/domain/usecases/diet/get_compliance_stats_use_case.dart

/// Input for getting compliance statistics
@freezed
class ComplianceStatsInput with _$ComplianceStatsInput {
  const factory ComplianceStatsInput({
    required String profileId,
    required String dietId,
    required int startDateEpoch,         // Epoch milliseconds
    required int endDateEpoch,           // Epoch milliseconds
  }) = _ComplianceStatsInput;

  factory ComplianceStatsInput.fromJson(Map<String, dynamic> json) =>
      _$ComplianceStatsInputFromJson(json);
}

/// Compliance statistics result
@freezed
class ComplianceStats with _$ComplianceStats {
  const factory ComplianceStats({
    required double overallScore,          // 0-100
    required double dailyScore,            // Today's score
    required double weeklyScore,           // Last 7 days
    required double monthlyScore,          // Last 30 days
    required int currentStreak,            // Days at 100%
    required int longestStreak,            // Best streak ever
    required int totalViolations,
    required int totalWarnings,
    required Map<DietRuleType, double> complianceByRule,
    required List<DietViolation> recentViolations,
    required List<DailyCompliance> dailyTrend,
  }) = _ComplianceStats;

  factory ComplianceStats.fromJson(Map<String, dynamic> json) =>
      _$ComplianceStatsFromJson(json);
}

/// Daily compliance record
@freezed
class DailyCompliance with _$DailyCompliance {
  const DailyCompliance._();
  const factory DailyCompliance({
    required int dateEpoch,                // Epoch milliseconds (midnight of date)
    required double score,
    required int violations,
    required int warnings,
  }) = _DailyCompliance;

  factory DailyCompliance.fromJson(Map<String, dynamic> json) =>
      _$DailyComplianceFromJson(json);
}
```

---

## 7.6 Intelligence System Contracts (Phase 3)

For complete specifications, see [42_INTELLIGENCE_SYSTEM.md](42_INTELLIGENCE_SYSTEM.md).

### Pattern Entity

```dart
@freezed
class Pattern with _$Pattern {
  const Pattern._();
  const factory Pattern({
    required String id,
    required String clientId,
    required String profileId,
    required PatternType type,
    required String entityType,
    String? entityId,
    required Map<String, dynamic> data,
    required double confidence,
    required int sampleSize,
    required int detectedAt,        // Epoch milliseconds
    required int dataRangeStart,    // Epoch milliseconds
    required int dataRangeEnd,      // Epoch milliseconds
    required int observationCount,
    required int lastObservedAt,    // Epoch milliseconds
    @Default(true) bool isActive,
    required SyncMetadata syncMetadata,
  }) = _Pattern;
}

// PatternType: See Section 7 (line ~1342) for canonical definition
```

### TriggerCorrelation Entity

```dart
@freezed
class TriggerCorrelation with _$TriggerCorrelation {
  const TriggerCorrelation._();
  const factory TriggerCorrelation({
    required String id,
    required String clientId,
    required String profileId,
    required String triggerId,
    required String triggerType,
    required String triggerName,
    required String outcomeId,
    required String outcomeType,
    required String outcomeName,
    required CorrelationType correlationType,
    required double relativeRisk,
    required double confidenceIntervalLow,
    required double confidenceIntervalHigh,
    required double pValue,
    required int triggerExposures,
    required int outcomeOccurrences,
    required int cooccurrences,
    required int timeWindowHours,
    required double averageLatencyHours,
    required double confidence,
    required int detectedAt,        // Epoch milliseconds
    required int dataRangeStart,    // Epoch milliseconds
    required int dataRangeEnd,      // Epoch milliseconds
    String? doseResponseEquation,
    @Default(true) bool isActive,
    required SyncMetadata syncMetadata,
  }) = _TriggerCorrelation;
}

enum CorrelationType {
  positive(0),
  negative(1),
  neutral(2),
  doseResponse(3);

  final int value;
  const CorrelationType(this.value);
}
```

### HealthInsight Entity

```dart
@freezed
class HealthInsight with _$HealthInsight {
  const HealthInsight._();
  const factory HealthInsight({
    required String id,
    required String clientId,
    required String profileId,
    required String insightKey,       // Deduplication key for insight
    required InsightCategory category,
    required AlertPriority priority,
    required String title,
    required String description,
    String? recommendation,
    required List<InsightEvidence> evidence,
    required int generatedAt,       // Epoch milliseconds
    int? expiresAt,                 // Epoch milliseconds
    @Default(false) bool isDismissed,
    int? dismissedAt,               // Epoch milliseconds
    String? relatedEntityType,
    String? relatedEntityId,
    required SyncMetadata syncMetadata,
  }) = _HealthInsight;
}

// NOTE: InsightCategory and AlertPriority enums are defined in Section 3.2 above

/// VALUE OBJECT - Embedded in HealthInsight entity, not a standalone entity.
/// Does not require id, clientId, profileId, or syncMetadata.
/// Evidence supporting a health insight
@freezed
class InsightEvidence with _$InsightEvidence {
  const InsightEvidence._();
  const factory InsightEvidence({
    required String entityType,        // 'condition_log', 'food_log', 'supplement_intake', etc.
    required String entityId,          // ID of the supporting record
    required int timestamp,            // Epoch milliseconds - When the evidence occurred
    required String description,       // Human-readable description
    double? value,                     // Numeric value if applicable
    String? unit,                      // Unit for value
  }) = _InsightEvidence;

  factory InsightEvidence.fromJson(Map<String, dynamic> json) =>
      _$InsightEvidenceFromJson(json);
}
```

### PredictiveAlert Entity

```dart
@freezed
class PredictiveAlert with _$PredictiveAlert {
  const PredictiveAlert._();
  const factory PredictiveAlert({
    required String id,
    required String clientId,
    required String profileId,
    required PredictionType type,
    required String title,
    required String description,
    required double probability,
    required int predictedEventTime,   // Epoch milliseconds
    required int alertGeneratedAt,     // Epoch milliseconds
    required List<PredictionFactor> factors,
    String? preventiveAction,
    @Default(false) bool isAcknowledged,
    int? acknowledgedAt,               // Epoch milliseconds
    bool? eventOccurred,
    int? eventOccurredAt,              // Epoch milliseconds
    required SyncMetadata syncMetadata,
  }) = _PredictiveAlert;
}

enum PredictionType {
  flareUp(0),
  menstrualStart(1),
  ovulation(2),
  triggerExposure(3),
  missedSupplement(4),
  poorSleep(5);

  final int value;
  const PredictionType(this.value);
}

/// VALUE OBJECT - Embedded in PredictiveAlert entity, not a standalone entity.
/// Does not require id, clientId, profileId, or syncMetadata.
/// Factor contributing to a predictive alert
@freezed
class PredictionFactor with _$PredictionFactor {
  const PredictionFactor._();
  const factory PredictionFactor({
    required String name,              // Factor name (e.g., "High stress yesterday")
    required double weight,            // Contribution to prediction (0.0-1.0)
    required String direction,         // 'positive' (increases risk) or 'negative' (decreases)
    String? entityType,                // Related entity type if applicable
    String? entityId,                  // Related entity ID if applicable
    String? description,               // Human-readable explanation
  }) = _PredictionFactor;

  factory PredictionFactor.fromJson(Map<String, dynamic> json) =>
      _$PredictionFactorFromJson(json);
}
```

### Intelligence Repository Contracts

```dart
abstract class PatternRepository implements EntityRepository<Pattern, String> {
  Future<Result<List<Pattern>, AppError>> getByProfile(
    String profileId, {
    PatternType? type,
    bool activeOnly = true,
  });
  Future<Result<List<Pattern>, AppError>> getByEntity(String entityType, String entityId);
  Future<Result<void, AppError>> deactivate(String id);

  /// Find similar patterns based on type and entities.
  Future<Result<List<Pattern>, AppError>> findSimilar(
    String patternId, {
    double minSimilarity = 0.7,
    int? limit,
  });
}

abstract class TriggerCorrelationRepository implements EntityRepository<TriggerCorrelation, String> {
  Future<Result<List<TriggerCorrelation>, AppError>> getByProfile(
    String profileId, {
    CorrelationType? type,
    bool activeOnly = true,
  });
  Future<Result<List<TriggerCorrelation>, AppError>> getByTrigger(String triggerType, String triggerId);
  Future<Result<List<TriggerCorrelation>, AppError>> getByOutcome(String outcomeType, String outcomeId);
  Future<Result<List<TriggerCorrelation>, AppError>> getPositive(String profileId, String outcomeId);
  Future<Result<TriggerCorrelation, AppError>> upsert(TriggerCorrelation correlation);
}

abstract class HealthInsightRepository implements EntityRepository<HealthInsight, String> {
  Future<Result<List<HealthInsight>, AppError>> getActive(
    String profileId, {
    InsightCategory? category,
    AlertPriority? minPriority,
    int? limit,
  });
  Future<Result<void, AppError>> dismiss(String id);
}

abstract class PredictiveAlertRepository implements EntityRepository<PredictiveAlert, String> {
  Future<Result<List<PredictiveAlert>, AppError>> getPending(String profileId, {PredictionType? type});
  Future<Result<void, AppError>> acknowledge(String id);
  Future<Result<void, AppError>> recordOutcome(String id, bool occurred, int? occurredAt);  // Epoch ms
}
```

### Intelligence Use Case Input Types

```dart
/// Input for pattern detection analysis
@freezed
class DetectPatternsInput with _$DetectPatternsInput {
  const factory DetectPatternsInput({
    required String profileId,
    @Default(90) int lookbackDays,
    @Default([]) List<PatternType> patternTypes,
    @Default(0.6) double minimumConfidence,
    @Default(5) int minimumDataPoints,
    @Default([]) List<String> conditionIds,
    @Default(true) bool includeTemporalPatterns,
    @Default(true) bool includeCyclicalPatterns,
    @Default(true) bool includeSequentialPatterns,
  }) = _DetectPatternsInput;
}


/// Input for trigger correlation analysis
@freezed
class AnalyzeTriggersInput with _$AnalyzeTriggersInput {
  const factory AnalyzeTriggersInput({
    required String profileId,
    String? conditionId,                              // Nullable - use case checks for null
    @Default(90) int lookbackDays,
    @Default([6, 12, 24, 48, 72]) List<int> timeWindowHours,
    @Default(0.6) double minimumConfidence,
    @Default(10) int minimumOccurrences,
    @Default(true) bool includeFoodTriggers,
    @Default(true) bool includeSupplementTriggers,
    @Default(true) bool includeActivityTriggers,
    @Default(true) bool includeSleepTriggers,
    @Default(true) bool includeEnvironmentalTriggers,
  }) = _AnalyzeTriggersInput;
}

/// Input for health insight generation
@freezed
class GenerateInsightsInput with _$GenerateInsightsInput {
  const factory GenerateInsightsInput({
    required String profileId,
    required int asOfDate,                           // Epoch milliseconds - Generate insights as of this date
    @Default(30) int lookbackDays,                   // How far back to analyze
    @Default([]) List<InsightCategory> categories, // Empty = all types
    @Default(10) int maxInsights,                   // Limit returned insights
    @Default(true) bool includePatternInsights,
    @Default(true) bool includeTriggerInsights,
    @Default(true) bool includeProgressInsights,
    @Default(true) bool includeComplianceInsights,
    @Default(true) bool includeAnomalyAlerts,
  }) = _GenerateInsightsInput;
}
```

### Intelligence Output Types

```dart
/// Output type for data quality assessment
@freezed
class DataQualityReport with _$DataQualityReport {
  const factory DataQualityReport({
    required String profileId,
    required int assessedAt,         // Epoch milliseconds
    required int totalDaysAnalyzed,
    required int daysWithData,
    required double overallQualityScore,           // 0.0 - 1.0
    required Map<String, DataTypeQuality> byDataType,
    required List<DataGap> gaps,
    required List<String> recommendations,
  }) = _DataQualityReport;

  factory DataQualityReport.fromJson(Map<String, dynamic> json) =>
      _$DataQualityReportFromJson(json);
}

@freezed
class DataTypeQuality with _$DataTypeQuality {
  const factory DataTypeQuality({
    required String dataType,                      // e.g., 'supplements', 'food', 'sleep'
    required int expectedEntries,
    required int actualEntries,
    required double completenessScore,             // 0.0 - 1.0
    required double consistencyScore,              // 0.0 - 1.0 (regular logging)
    required int longestStreak,
    required int currentStreak,
    int? lastEntry,                  // Epoch milliseconds
  }) = _DataTypeQuality;

  factory DataTypeQuality.fromJson(Map<String, dynamic> json) =>
      _$DataTypeQualityFromJson(json);
}

@freezed
class DataGap with _$DataGap {
  const factory DataGap({
    required String dataType,
    required int gapStartEpoch,          // Epoch milliseconds
    required int gapEndEpoch,            // Epoch milliseconds
    required int daysMissed,
  }) = _DataGap;

  factory DataGap.fromJson(Map<String, dynamic> json) =>
      _$DataGapFromJson(json);
}
```

### Intelligence Use Case Contracts

```dart
// Pattern Detection
class DetectPatternsUseCase implements UseCaseWithInput<List<Pattern>, DetectPatternsInput> {
  Future<Result<List<Pattern>, AppError>> call(DetectPatternsInput input);
}

// Trigger Analysis
class AnalyzeTriggersUseCase implements UseCaseWithInput<List<TriggerCorrelation>, AnalyzeTriggersInput> {
  Future<Result<List<TriggerCorrelation>, AppError>> call(AnalyzeTriggersInput input);
}

// Insight Generation
class GenerateInsightsUseCase implements UseCaseWithInput<List<HealthInsight>, GenerateInsightsInput> {
  Future<Result<List<HealthInsight>, AppError>> call(GenerateInsightsInput input);
}

/// Input for generating predictive alerts
@freezed
class GeneratePredictiveAlertsInput with _$GeneratePredictiveAlertsInput {
  const factory GeneratePredictiveAlertsInput({
    required String profileId,
    @Default([]) List<PredictionType> predictionTypes,  // Empty = all types
    @Default(72) int predictionWindowHours,              // How far ahead to predict
    @Default(0.6) double minimumConfidence,              // Min probability threshold
    @Default(true) bool includeFlareUpPredictions,
    @Default(true) bool includeMenstrualPredictions,
    @Default(true) bool includeTriggerWarnings,
    @Default(true) bool includeMissedSupplementPredictions,
  }) = _GeneratePredictiveAlertsInput;

  factory GeneratePredictiveAlertsInput.fromJson(Map<String, dynamic> json) =>
      _$GeneratePredictiveAlertsInputFromJson(json);
}

// Predictive Alerts
class GeneratePredictiveAlertsUseCase
    implements UseCaseWithInput<List<PredictiveAlert>, GeneratePredictiveAlertsInput> {
  /// Authorization: User must have read access to profileId
  /// Rate Limit: Max 1 per minute per profile
  Future<Result<List<PredictiveAlert>, AppError>> call(GeneratePredictiveAlertsInput input);
}

/// Input for data quality assessment
@freezed
class AssessDataQualityInput with _$AssessDataQualityInput {
  const factory AssessDataQualityInput({
    required String profileId,
    @Default(30) int lookbackDays,                       // How many days to analyze
    @Default([]) List<String> dataTypes,                 // Empty = all types
    @Default(true) bool includeRecommendations,          // Generate improvement suggestions
    @Default(true) bool includeGapAnalysis,              // Find gaps in tracking
  }) = _AssessDataQualityInput;

  factory AssessDataQualityInput.fromJson(Map<String, dynamic> json) =>
      _$AssessDataQualityInputFromJson(json);
}

// Data Quality Assessment
class AssessDataQualityUseCase
    implements UseCaseWithInput<DataQualityReport, AssessDataQualityInput> {
  /// Authorization: User must have read access to profileId
  Future<Result<DataQualityReport, AppError>> call(AssessDataQualityInput input);
}
```

---

### 7.5b Data Layer Model Stubs

These Model classes implement `Model<T>` (defined in Section 2) and provide
database serialization for their respective entities. Each extends the base
pattern of `toMap()`, `copyWith()`, and a `fromMap()` factory.

```dart
/// Database model for Supplement entity
class SupplementModel extends Model<Supplement> {
  final Map<String, dynamic> _data;
  SupplementModel(this._data);

  @override
  Map<String, dynamic> toMap() => _data;

  @override
  Model<Supplement> copyWith({
    String? id, int? syncCreatedAt, int? syncUpdatedAt,
    int? syncVersion, bool? syncIsDirty, int? syncStatus, int? syncDeletedAt,
  }) => SupplementModel({..._data, if (id != null) 'id': id,
    if (syncCreatedAt != null) 'sync_created_at': syncCreatedAt,
    if (syncUpdatedAt != null) 'sync_updated_at': syncUpdatedAt,
    if (syncVersion != null) 'sync_version': syncVersion,
    if (syncIsDirty != null) 'sync_is_dirty': syncIsDirty ? 1 : 0,
    if (syncStatus != null) 'sync_status': syncStatus,
    if (syncDeletedAt != null) 'sync_deleted_at': syncDeletedAt,
  });

  factory SupplementModel.fromEntity(Supplement entity) => SupplementModel(/* entity to map */);
  Supplement toEntity() => /* map to entity */;
}

/// Database model for FluidsEntry entity
class FluidsEntryModel extends Model<FluidsEntry> {
  final Map<String, dynamic> _data;
  FluidsEntryModel(this._data);
  @override Map<String, dynamic> toMap() => _data;
  @override Model<FluidsEntry> copyWith({String? id, int? syncCreatedAt, int? syncUpdatedAt, int? syncVersion, bool? syncIsDirty, int? syncStatus, int? syncDeletedAt}) => FluidsEntryModel({..._data});
  factory FluidsEntryModel.fromEntity(FluidsEntry entity) => FluidsEntryModel({});
  FluidsEntry toEntity() => throw UnimplementedError();
}

/// Database model for Diet entity
class DietModel extends Model<Diet> {
  final Map<String, dynamic> _data;
  DietModel(this._data);
  @override Map<String, dynamic> toMap() => _data;
  @override Model<Diet> copyWith({String? id, int? syncCreatedAt, int? syncUpdatedAt, int? syncVersion, bool? syncIsDirty, int? syncStatus, int? syncDeletedAt}) => DietModel({..._data});
  factory DietModel.fromEntity(Diet entity) => DietModel({});
  Diet toEntity() => throw UnimplementedError();
}

/// Database model for ConditionLog entity
class ConditionLogModel extends Model<ConditionLog> {
  final Map<String, dynamic> _data;
  ConditionLogModel(this._data);
  @override Map<String, dynamic> toMap() => _data;
  @override Model<ConditionLog> copyWith({String? id, int? syncCreatedAt, int? syncUpdatedAt, int? syncVersion, bool? syncIsDirty, int? syncStatus, int? syncDeletedAt}) => ConditionLogModel({..._data});
  factory ConditionLogModel.fromEntity(ConditionLog entity) => ConditionLogModel({});
  ConditionLog toEntity() => throw UnimplementedError();
}

/// Database model for IntakeLog entity
class IntakeLogModel extends Model<IntakeLog> {
  final Map<String, dynamic> _data;
  IntakeLogModel(this._data);
  @override Map<String, dynamic> toMap() => _data;
  @override Model<IntakeLog> copyWith({String? id, int? syncCreatedAt, int? syncUpdatedAt, int? syncVersion, bool? syncIsDirty, int? syncStatus, int? syncDeletedAt}) => IntakeLogModel({..._data});
  factory IntakeLogModel.fromEntity(IntakeLog entity) => IntakeLogModel({});
  IntakeLog toEntity() => throw UnimplementedError();
}

/// Database model for HealthInsight entity
class HealthInsightModel extends Model<HealthInsight> {
  final Map<String, dynamic> _data;
  HealthInsightModel(this._data);
  @override Map<String, dynamic> toMap() => _data;
  @override Model<HealthInsight> copyWith({String? id, int? syncCreatedAt, int? syncUpdatedAt, int? syncVersion, bool? syncIsDirty, int? syncStatus, int? syncDeletedAt}) => HealthInsightModel({..._data});
  factory HealthInsightModel.fromEntity(HealthInsight entity) => HealthInsightModel({});
  HealthInsight toEntity() => throw UnimplementedError();
}
```

> NOTE: Full implementations of `toMap()`, `fromEntity()`, and `toEntity()` will follow
> the patterns established by the database column mappings in Section 13.

## 7.7 Wearable Integration Contracts (Phase 4)

For complete specifications, see [43_WEARABLE_INTEGRATION.md](43_WEARABLE_INTEGRATION.md).

### Wearable Platform DTOs

These DTOs represent data fetched from wearable platforms before import into Shadow entities.

```dart
/// Data container returned by WearablePlatformService.fetchData()
@freezed
class WearablePlatformData with _$WearablePlatformData {
  const factory WearablePlatformData({
    required List<WearableActivity> activities,
    required List<WearableSleep> sleepEntries,
    required List<WearableWaterIntake> waterIntakes,
  }) = _WearablePlatformData;
}

/// Activity record from a wearable platform
@freezed
class WearableActivity with _$WearableActivity {
  const factory WearableActivity({
    required String externalId,
    required int startTime,              // Epoch milliseconds
    String? mappedActivityId,            // Shadow Activity ID if mapped
    required int durationMinutes,
    required String source,              // Platform name
  }) = _WearableActivity;
}

/// Sleep record from a wearable platform
@freezed
class WearableSleep with _$WearableSleep {
  const factory WearableSleep({
    required String externalId,
    required int sleepStart,             // Epoch milliseconds
    required int sleepEnd,               // Epoch milliseconds
    String? quality,                     // Platform-specific quality indicator
    required String source,              // Platform name
  }) = _WearableSleep;
}

/// Water intake record from a wearable platform
@freezed
class WearableWaterIntake with _$WearableWaterIntake {
  const factory WearableWaterIntake({
    required int loggedAt,               // Epoch milliseconds
    required int amountMl,               // Milliliters
  }) = _WearableWaterIntake;
}
```

### WearableConnection Entity

```dart
@freezed
class WearableConnection with _$WearableConnection {
  const WearableConnection._();

  const factory WearableConnection({
    required String id,
    required String clientId,
    required String profileId,
    required String platform,              // 'healthkit', 'googlefit', 'fitbit', 'garmin', 'oura', 'whoop'
    required bool isConnected,
    int? connectedAt,                      // Epoch milliseconds
    int? disconnectedAt,                   // Epoch milliseconds
    @Default([]) List<String> readPermissions,
    @Default([]) List<String> writePermissions,
    @Default(false) bool backgroundSyncEnabled,
    int? lastSyncAt,                       // Epoch milliseconds
    String? lastSyncStatus,                // 'success', 'partial', 'failed'
    String? lastSyncError,
    String? oauthRefreshToken,             // Encrypted, for cloud APIs (Fitbit, Garmin, Oura, WHOOP)
    required SyncMetadata syncMetadata,
  }) = _WearableConnection;

  bool get canReadSteps => readPermissions.contains('steps');
  bool get canReadHeartRate => readPermissions.contains('heart_rate');
  bool get canReadSleep => readPermissions.contains('sleep');
  bool get canWriteWater => writePermissions.contains('water');
}

// WearablePlatform: See Section 7 (line ~1411) for canonical definition
```

### WearableConnectionRepository

```dart
abstract class WearableConnectionRepository
    implements EntityRepository<WearableConnection, String> {

  /// Get connection for specific platform
  Future<Result<WearableConnection?, AppError>> getByPlatform(
    String profileId,
    WearablePlatform platform,
  );

  /// Get all connected wearables for profile
  Future<Result<List<WearableConnection>, AppError>> getConnected(
    String profileId,
  );

  /// Connect to a wearable platform
  Future<Result<WearableConnection, AppError>> connect(
    String profileId,
    WearablePlatform platform,
    List<String> requestedPermissions,
  );

  /// Disconnect from a wearable platform
  Future<Result<void, AppError>> disconnect(
    String profileId,
    WearablePlatform platform,
  );

  /// Update sync status after sync operation
  Future<Result<WearableConnection, AppError>> updateSyncStatus(
    String connectionId,
    String status,
    String? error,
  );
}
```

### Wearable Use Cases

```dart
// Connect to wearable platform
@freezed
class ConnectWearableInput with _$ConnectWearableInput {
  const factory ConnectWearableInput({
    required String profileId,
    required String clientId,
    required WearablePlatform platform,
    required List<String> requestedPermissions,
    @Default(false) bool enableBackgroundSync,  }) = _ConnectWearableInput;

  factory ConnectWearableInput.fromJson(Map<String, dynamic> json) =>
      _$ConnectWearableInputFromJson(json);
}

class ConnectWearableUseCase
    implements UseCaseWithInput<WearableConnection, ConnectWearableInput> {
  /// Authorization: User must have write access to profileId
  /// Validation: Platform must be available on device
  Future<Result<WearableConnection, AppError>> call(ConnectWearableInput input);
}

// Sync data from wearable
@freezed
class SyncWearableDataInput with _$SyncWearableDataInput {
  const factory SyncWearableDataInput({
    required String profileId,
    required String clientId,
    required WearablePlatform platform,
    int? sinceEpoch,                     // Epoch ms, null for full sync
    int? startDate,                      // Epoch ms - explicit range start
    int? endDate,                        // Epoch ms - explicit range end
    List<String>? dataTypes,             // Filter to specific data types
  }) = _SyncWearableDataInput;





  factory SyncWearableDataInput.fromJson(Map<String, dynamic> json) =>
      _$SyncWearableDataInputFromJson(json);
}

@freezed
class SyncWearableDataOutput with _$SyncWearableDataOutput {
  const factory SyncWearableDataOutput({
    required int importedCount,
    required int skippedCount,
    required int errorCount,
    required int syncedRangeStart,        // Epoch milliseconds
    required int syncedRangeEnd,          // Epoch milliseconds
  }) = _SyncWearableDataOutput;






  factory SyncWearableDataOutput.fromJson(Map<String, dynamic> json) =>
      _$SyncWearableDataOutputFromJson(json);
}

class SyncWearableDataUseCase
    implements UseCaseWithInput<SyncWearableDataOutput, SyncWearableDataInput> {
  /// Authorization: User must have write access to profileId
  /// Rate Limit: Max 1 sync per platform per 5 minutes
  Future<Result<SyncWearableDataOutput, AppError>> call(SyncWearableDataInput input);
}
```

---

### 7.6b Missing Use Case and Service Definitions

The following definitions are referenced in provider registrations or use case code
but were not previously defined in this document.

#### GetBBTEntriesInput and UseCase

```dart
@freezed
class GetBBTEntriesInput with _$GetBBTEntriesInput {
  const factory GetBBTEntriesInput({
    required String profileId,
    int? startDate,                      // Epoch ms
    int? endDate,                        // Epoch ms
    @Default(30) int limit,
  }) = _GetBBTEntriesInput;
}

class GetBBTEntriesUseCase implements UseCaseWithInput<List<FluidsEntry>, GetBBTEntriesInput> {
  Future<Result<List<FluidsEntry>, AppError>> call(GetBBTEntriesInput input);
}
```

#### SignInWithAppleInput and UseCase

```dart
@freezed
class SignInWithAppleInput with _$SignInWithAppleInput {
  const factory SignInWithAppleInput({
    required String identityToken,
    required String authorizationCode,
    String? email,
    String? displayName,
  }) = _SignInWithAppleInput;
}

class SignInWithAppleUseCase implements UseCaseWithInput<UserAccount, SignInWithAppleInput> {
  /// Validates Apple identity token and creates/retrieves user account
  Future<Result<UserAccount, AppError>> call(SignInWithAppleInput input);
}
```

#### SyncService Convenience Methods

The following methods must be added to the SyncService interface
(defined in Section 17 Sync Service Contract):

```dart
/// Additional SyncService methods referenced by providers
abstract class SyncService {
  // ... existing methods ...

  /// Get count of pending changes awaiting sync
  Future<Result<int, AppError>> getPendingChangesCount(String profileId);

  /// Get count of unresolved sync conflicts
  Future<Result<int, AppError>> getConflictCount(String profileId);

  /// Get last successful sync time (epoch ms) for a profile
  Future<Result<int?, AppError>> getLastSyncTime(String profileId);
}
```

#### AuthTokenService.hasValidToken

```dart
/// Additional AuthTokenService methods referenced by providers
abstract class AuthTokenService {
  // ... existing methods (storeTokens, clearTokens) ...

  /// Check if valid auth tokens exist for current session
  Future<bool> hasValidToken();

  /// Get the current authenticated user's ID from stored tokens
  Future<String?> getCurrentUserId();
}
```

#### Generic Use Case Templates

These generic templates provide implementations for the 30 orphaned Input classes
defined in Sections 3.1-3.5 (GetXxxInput, SearchXxxInput, ArchiveXxxInput, etc.).

```dart
/// Generic use case for retrieving entities by profile with pagination.
/// Maps to: GetSleepEntriesInput, GetActivitiesInput, GetActivityLogsInput,
/// GetFoodItemsInput, GetFoodLogsInput, GetJournalEntriesInput, GetPhotoAreasInput,
/// GetPhotoEntriesInput, GetPhotoEntriesByAreaInput, GetFlareUpsInput
class GetEntitiesUseCase<T extends Syncable, I> implements UseCaseWithInput<List<T>, I> {
  final EntityRepository<T, String> _repository;
  final ProfileAuthorizationService _authService;

  GetEntitiesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<T>, AppError>> call(I input);
}

/// Generic use case for searching entities by query string.
/// Maps to: SearchFoodItemsInput, SearchJournalEntriesInput
class SearchEntitiesUseCase<T extends Syncable, I> implements UseCaseWithInput<List<T>, I> {
  final EntityRepository<T, String> _repository;
  final ProfileAuthorizationService _authService;

  SearchEntitiesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<T>, AppError>> call(I input);
}

/// Generic use case for archiving (soft-deleting) entities.
/// Maps to: ArchiveActivityInput, ArchiveFoodItemInput, ArchivePhotoAreaInput
class ArchiveEntityUseCase<T extends Syncable, I> implements UseCaseWithInput<void, I> {
  final EntityRepository<T, String> _repository;
  final ProfileAuthorizationService _authService;

  ArchiveEntityUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(I input);
}
```

**Input-to-Template Mapping:**

| Input Class | Template | Notes |
|-------------|----------|-------|
| GetSleepEntriesInput | GetEntitiesUseCase<SleepEntry, GetSleepEntriesInput> | |
| GetActivitiesInput | GetEntitiesUseCase<Activity, GetActivitiesInput> | |
| GetActivityLogsInput | GetEntitiesUseCase<ActivityLog, GetActivityLogsInput> | |
| GetFoodItemsInput | GetEntitiesUseCase<FoodItem, GetFoodItemsInput> | |
| GetFoodLogsInput | GetEntitiesUseCase<FoodLog, GetFoodLogsInput> | |
| GetJournalEntriesInput | GetEntitiesUseCase<JournalEntry, GetJournalEntriesInput> | |
| GetPhotoAreasInput | GetEntitiesUseCase<PhotoArea, GetPhotoAreasInput> | |
| GetPhotoEntriesInput | GetEntitiesUseCase<PhotoEntry, GetPhotoEntriesInput> | |
| GetPhotoEntriesByAreaInput | GetEntitiesUseCase<PhotoEntry, GetPhotoEntriesByAreaInput> | |
| GetFlareUpsInput | GetEntitiesUseCase<FlareUp, GetFlareUpsInput> | |
| SearchFoodItemsInput | SearchEntitiesUseCase<FoodItem, SearchFoodItemsInput> | |
| SearchJournalEntriesInput | SearchEntitiesUseCase<JournalEntry, SearchJournalEntriesInput> | |
| ArchiveActivityInput | ArchiveEntityUseCase<Activity, ArchiveActivityInput> | |
| ArchiveFoodItemInput | ArchiveEntityUseCase<FoodItem, ArchiveFoodItemInput> | |
| ArchivePhotoAreaInput | ArchiveEntityUseCase<PhotoArea, ArchivePhotoAreaInput> | |
| UpdateSleepEntryInput | UpdateEntityUseCase<SleepEntry> | Existing generic |
| UpdateActivityInput | UpdateEntityUseCase<Activity> | Existing generic |
| UpdateActivityLogInput | UpdateEntityUseCase<ActivityLog> | Existing generic |
| UpdateFoodItemInput | UpdateEntityUseCase<FoodItem> | Existing generic |
| UpdateFoodLogInput | UpdateEntityUseCase<FoodLog> | Existing generic |
| UpdateJournalEntryInput | UpdateEntityUseCase<JournalEntry> | Existing generic |
| UpdatePhotoAreaInput | UpdateEntityUseCase<PhotoArea> | Existing generic |
| UpdateFlareUpInput | UpdateEntityUseCase<FlareUp> | Existing generic |
| DeleteSleepEntryInput | DeleteEntityUseCase<SleepEntry> | Existing generic |
| DeleteActivityLogInput | DeleteEntityUseCase<ActivityLog> | Existing generic |
| DeleteFoodLogInput | DeleteEntityUseCase<FoodLog> | Existing generic |
| DeleteJournalEntryInput | DeleteEntityUseCase<JournalEntry> | Existing generic |
| DeletePhotoEntryInput | DeleteEntityUseCase<PhotoEntry> | Existing generic |
| DeleteFlareUpInput | DeleteEntityUseCase<FlareUp> | Existing generic |
| EndFlareUpInput | Custom: EndFlareUpUseCase | Sets endDate on FlareUp |

## 7.8 Diet Management Use Cases (Additions)

These use cases were identified as missing during specification audit:

```dart
// Create or activate diet
@freezed
class CreateDietInput with _$CreateDietInput {
  const factory CreateDietInput({
    required String profileId,
    required String clientId,
    required String name,
    String? presetId,                    // NULL for custom diet
    @Default([]) List<DietRule> customRules,  // Empty list for presets
    int? startDateEpoch,                 // Epoch ms, NULL for immediate start
    int? endDateEpoch,                   // Epoch ms, NULL for ongoing
    int? eatingWindowStartMinutes,       // Minutes from midnight (0-1439)
    int? eatingWindowEndMinutes,         // Minutes from midnight (0-1439)
  }) = _CreateDietInput;

  factory CreateDietInput.fromJson(Map<String, dynamic> json) =>
      _$CreateDietInputFromJson(json);
}

class CreateDietUseCase implements UseCaseWithInput<Diet, CreateDietInput> {
  /// Authorization: User must have write access to profileId
  /// Validation:
  ///   - name: 1-100 characters
  ///   - presetId OR customRules required (not both empty)
  ///   - eatingWindow: start < end (when both provided)
  ///   - eatingWindowStartMinutes/EndMinutes: 0-1439
  /// Business Rule: Deactivates any existing active diet for profile
  Future<Result<Diet, AppError>> call(CreateDietInput input);
}

// Activate existing diet
@freezed
class ActivateDietInput with _$ActivateDietInput {
  const factory ActivateDietInput({
    required String profileId,
    required String dietId,
  }) = _ActivateDietInput;

  factory ActivateDietInput.fromJson(Map<String, dynamic> json) =>
      _$ActivateDietInputFromJson(json);
}

class ActivateDietUseCase implements UseCaseWithInput<Diet, ActivateDietInput> {
  /// Authorization: User must have write access to profileId
  /// Business Rule: Deactivates any existing active diet for profile
  Future<Result<Diet, AppError>> call(ActivateDietInput input);
}

// Pre-log compliance check (warn before logging violating food)
@freezed
class PreLogComplianceCheckInput with _$PreLogComplianceCheckInput {
  const factory PreLogComplianceCheckInput({
    required String profileId,
    required String dietId,
    required String foodItemId,
    required int quantity,
    required int logTimeEpoch,           // When the food will be logged (for IF checks)
  }) = _PreLogComplianceCheckInput;

  factory PreLogComplianceCheckInput.fromJson(Map<String, dynamic> json) =>
      _$PreLogComplianceCheckInputFromJson(json);
}

@freezed
class ComplianceWarning with _$ComplianceWarning {
  const factory ComplianceWarning({
    required bool violatesRules,
    required List<DietRule> violatedRules,
    required double complianceImpactPercent,  // How much score will drop
    required List<FoodItem> alternatives,     // Compliant alternatives
  }) = _ComplianceWarning;

  factory ComplianceWarning.fromJson(Map<String, dynamic> json) =>
      _$ComplianceWarningFromJson(json);
}

class PreLogComplianceCheckUseCase
    implements UseCaseWithInput<ComplianceWarning, PreLogComplianceCheckInput> {
  /// Authorization: User must have read access to profileId
  /// Returns: Warning showing impact if user proceeds with logging
  Future<Result<ComplianceWarning, AppError>> call(PreLogComplianceCheckInput input);
}
```

---

## 8. Notification Schedule Contracts

### 8.1 NotificationSchedule Entity

```dart
// lib/domain/entities/notification_schedule.dart

@freezed
class NotificationSchedule with _$NotificationSchedule {
  const NotificationSchedule._();

  const factory NotificationSchedule({
    required String id,
    required String clientId,
    required String profileId,
    required NotificationType type,
    String? entityId,                              // e.g., supplementId for supplement reminders
    required List<int> timesMinutesFromMidnight,   // [480, 720] = 8:00 AM, 12:00 PM
    required List<int> weekdays,                   // [0-6] where 0=Monday (matches DateTime.weekday - 1)
    @Default(true) bool isEnabled,
    String? customMessage,
    required SyncMetadata syncMetadata,
  }) = _NotificationSchedule;

  factory NotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$NotificationScheduleFromJson(json);

  /// Human-readable time strings
  List<String> get timeStrings => timesMinutesFromMidnight.map((m) {
    final hours = m ~/ 60;
    final mins = m % 60;
    final period = hours >= 12 ? 'PM' : 'AM';
    final h = hours > 12 ? hours - 12 : (hours == 0 ? 12 : hours);
    return '${h.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')} $period';
  }).toList();

  /// Whether reminder is active today (weekday 0=Monday to 6=Sunday)
  bool get isActiveToday => weekdays.contains(DateTime.now().weekday - 1);
}
```

### 8.2 NotificationScheduleRepository

```dart
// lib/domain/repositories/notification_schedule_repository.dart

abstract class NotificationScheduleRepository
    implements EntityRepository<NotificationSchedule, String> {

  /// Get all schedules for a profile
  Future<Result<List<NotificationSchedule>, AppError>> getByProfile(
    String profileId,
  );

  /// Get enabled schedules for a profile
  Future<Result<List<NotificationSchedule>, AppError>> getEnabled(
    String profileId,
  );

  /// Get schedules by notification type
  Future<Result<List<NotificationSchedule>, AppError>> getByType(
    String profileId,
    NotificationType type,
  );

  /// Get schedule linked to specific entity (e.g., supplement)
  Future<Result<NotificationSchedule?, AppError>> getByEntityId(
    String profileId,
    String entityId,
  );

  /// Toggle enabled status
  Future<Result<void, AppError>> toggleEnabled(String id, bool enabled);
}
```

### 8.3 Notification Use Cases

```dart
// lib/domain/usecases/notifications/schedule_notification_use_case.dart

@freezed
class ScheduleNotificationInput with _$ScheduleNotificationInput {
  const factory ScheduleNotificationInput({
    required String profileId,
    required String clientId,
    required NotificationType type,
    String? entityId,
    required List<int> timesMinutesFromMidnight,
    required List<int> weekdays,
    String? customMessage,
  }) = _ScheduleNotificationInput;

  factory ScheduleNotificationInput.fromJson(Map<String, dynamic> json) =>
      _$ScheduleNotificationInputFromJson(json);
}

class ScheduleNotificationUseCase
    implements UseCase<ScheduleNotificationInput, NotificationSchedule> {
  /// Authorization: User must have write access to profileId
  /// Validation:
  ///   - timesMinutesFromMidnight: 1-10 times, each 0-1439
  ///   - weekdays: 1-7 days, each 0-6
  ///   - entityId: Required for supplement/condition types
  Future<Result<NotificationSchedule, AppError>> call(ScheduleNotificationInput input);
}

@freezed
class GetPendingNotificationsInput with _$GetPendingNotificationsInput {
  const factory GetPendingNotificationsInput({
    required String profileId,
    required int windowStartEpoch,        // Epoch milliseconds
    required int windowEndEpoch,          // Epoch milliseconds
  }) = _GetPendingNotificationsInput;

  factory GetPendingNotificationsInput.fromJson(Map<String, dynamic> json) =>
      _$GetPendingNotificationsInputFromJson(json);
}

/// OUTPUT DTO - Computed from NotificationSchedule, not a persistent entity.
/// Does not require id, clientId, profileId, or syncMetadata.
@freezed
class PendingNotification with _$PendingNotification {
  const factory PendingNotification({
    required NotificationSchedule schedule,
    required int scheduledTimeEpoch,       // Epoch milliseconds
    required String title,
    required String body,
    String? deepLink,
  }) = _PendingNotification;

  factory PendingNotification.fromJson(Map<String, dynamic> json) =>
      _$PendingNotificationFromJson(json);
}

class GetPendingNotificationsUseCase
    implements UseCase<GetPendingNotificationsInput, List<PendingNotification>> {
  /// Returns notifications scheduled within the given time window
  Future<Result<List<PendingNotification>, AppError>> call(GetPendingNotificationsInput input);
}
```

---

## 9. Authorization Service Contracts

### 9.1 ProfileAuthorizationService

```dart
// lib/domain/services/profile_authorization_service.dart

/// Service contract for profile-level authorization checks.
/// ALL use cases MUST use this service before accessing profile data.
abstract class ProfileAuthorizationService {
  /// Check if current user can read profile data
  Future<bool> canRead(String profileId);

  /// Check if current user can write to profile
  Future<bool> canWrite(String profileId);

  /// Check if current user owns the profile
  Future<bool> isProfileOwner(String profileId);

  /// Get all profiles current user can access
  Future<Result<List<ProfileAccess>, AppError>> getAccessibleProfiles();

  /// Validate authorization and return failure if denied
  Future<Result<void, AppError>> requireReadAccess(String profileId);
  Future<Result<void, AppError>> requireWriteAccess(String profileId);
  Future<Result<void, AppError>> requireOwnerAccess(String profileId);
}

@freezed
class ProfileAccess with _$ProfileAccess {
  const factory ProfileAccess({
    required String profileId,
    required String profileName,
    required AccessLevel accessLevel,
    int? grantedAt,           // Epoch milliseconds
    int? expiresAt,           // Epoch milliseconds
    String? grantedBy,        // Profile ID of granter (for shared profiles)
  }) = _ProfileAccess;

  factory ProfileAccess.fromJson(Map<String, dynamic> json) =>
      _$ProfileAccessFromJson(json);
}

// AccessLevel: See Section 7 (line ~1624) for canonical definition
```

### 9.2 Rate Limiting Service

```dart
// lib/domain/services/rate_limit_service.dart

abstract class RateLimitService {
  /// Check if operation is allowed under rate limits
  Future<Result<RateLimitResult, AppError>> checkLimit(
    String userId,
    RateLimitOperation operation,
  );

  /// Record an operation for rate limiting
  Future<Result<void, AppError>> recordOperation(
    String userId,
    RateLimitOperation operation,
  );
}

enum RateLimitOperation {
  sync(0, 60, Duration(minutes: 1)),              // 60 per minute
  photoUpload(1, 10, Duration(minutes: 1)),      // 10 per minute
  reportGeneration(2, 5, Duration(minutes: 1)),  // 5 per minute
  dataExport(3, 2, Duration(minutes: 1)),        // 2 per minute
  wearableSync(4, 1, Duration(minutes: 5));      // 1 per 5 minutes per platform

  final int value;
  final int maxRequests;
  final Duration window;

  const RateLimitOperation(this.value, this.maxRequests, this.window);
}

@freezed
class RateLimitResult with _$RateLimitResult {
  const factory RateLimitResult({
    required bool isAllowed,
    required int remainingRequests,
    Duration? retryAfter,
  }) = _RateLimitResult;
}
```

### 9.3 Audit Logging Service

```dart
// lib/domain/services/audit_log_service.dart

/// Service contract for HIPAA-compliant audit logging.
/// ALL PHI access MUST be logged through this service.
abstract class AuditLogService {
  /// Log a PHI access event
  Future<Result<void, AppError>> logAccess(AuditLogEntry entry);

  /// Get audit log for a profile (owner only)
  Future<Result<List<AuditLogEntry>, AppError>> getAuditLog(
    String profileId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    AuditEventType? eventType,
    int limit = 100,
    int offset = 0,
  });
}

@freezed
class AuditLogEntry with _$AuditLogEntry {
  const AuditLogEntry._();
  const factory AuditLogEntry({
    required String id,
    required String clientId,     // Required for database merging
    required String userId,
    required String profileId,
    required AuditEventType eventType,
    required int timestamp,       // Epoch milliseconds
    required String deviceId,
    String? entityType,
    String? entityId,
    String? ipAddress,
    Map<String, dynamic>? metadata,
    required SyncMetadata syncMetadata,  // Required for all entities
  }) = _AuditLogEntry;

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditLogEntryFromJson(json);
}

enum AuditEventType {
  // Data operations (PHI)
  dataAccess(0),             // Read PHI
  dataModify(1),             // Create/update PHI
  dataDelete(2),             // Delete PHI
  dataExport(3),             // Export to file/external
  dataSync(4),               // PHI synced to cloud storage (Google Drive/iCloud)

  // Authorization
  authorizationGrant(5),     // Share profile access
  authorizationRevoke(6),    // Revoke profile access
  authorizationDenied(7),    // Failed access attempt (access denied)
  profileShare(8),           // Share profile via QR
  reportGenerate(9),         // Generate PDF report

  // Authentication
  login(10),                  // Successful authentication
  logout(11),                 // User sign out
  authenticationFailed(12),   // Failed login attempt
  passwordChanged(13),        // Password reset/change

  // Token operations
  tokenRefresh(14),           // Refresh token used
  tokenRevoke(15),            // Token invalidated

  // Device management
  deviceRegistration(16),     // New device registered
  deviceRemoval(17),          // Device removed/deactivated
  sessionTermination(18),     // Session ended (timeout or forced)

  // Security events
  encryptionKeyRotation(19),  // Encryption key rotated
  rateLimitExceeded(20);      // Rate limit violation

  final int value;
  const AuditEventType(this.value);
}

/// CRITICAL: Log BOTH success and failure cases for all operations.
/// Example:
/// - dataAccess: Log when PHI is read (success) AND when access is denied (authorizationDenied)
/// - login: Log successful logins AND failed attempts (authenticationFailed)
```

### 9.4 ProfileAccessLog and AuditLogService Integration

The `ProfileAccessLog` and `AuditLogService` serve complementary HIPAA audit purposes:

| System | Purpose | Scope | Retention |
|--------|---------|-------|-----------|
| AuditLogService | General security events, authentication, all PHI access | All users on device | 7 years |
| ProfileAccessLog | Shared profile access specifically | HIPAA authorized access only | 7 years |

**Integration Rules**:

1. **Shared Profile Access** - When a non-owner accesses a shared profile:
   - Log to `ProfileAccessLog` with authorizationId reference
   - Log to `AuditLogService` with `dataAccess` event type and metadata containing authorizationId

2. **Owner Access** - When profile owner accesses their own data:
   - Log to `AuditLogService` only (no HIPAA authorization needed)
   - ProfileAccessLog NOT used for owner's own profile

3. **Authorization Events**:
   - Grant: Log to `AuditLogService` with `authorizationGrant` event type
   - Revoke: Log to `AuditLogService` with `authorizationRevoke` event type
   - Store HIPAA authorization in `HipaaAuthorization` table

**Example: Authorized Access Flow**:
```dart
/// IMPORTANT: Use Result pattern - never throw exceptions (per 02_CODING_STANDARDS.md Section 7.2)
Future<Result<void, AppError>> accessSharedProfile(String profileId, String authorizationId) async {
  // 1. Validate authorization exists and is not expired
  final authResult = await hipaaAuthorizationRepo.getById(authorizationId);

  return authResult.when(
    success: (auth) async {
      if (auth == null || auth.isExpired) {
        await auditLogService.logAccess(AuditLogEntry(
          eventType: AuditEventType.authorizationDenied,
          profileId: profileId,
          // ... other fields
        ));
        return Failure(AuthError.profileAccessDenied(profileId));
      }

      // 2. Log to ProfileAccessLog (for HIPAA tracking)
      await profileAccessLogRepo.create(ProfileAccessLog(
        authorizationId: authorizationId,
        profileId: profileId,
        action: ProfileAccessAction.view,
        // ... other fields
      ));

      // 3. Log to AuditLogService (for general audit)
      await auditLogService.logAccess(AuditLogEntry(
        eventType: AuditEventType.dataAccess,
        profileId: profileId,
        metadata: {'authorizationId': authorizationId},
        // ... other fields
      ));

      return Success(null);
    },
    failure: (error) => Failure(error),
  );
}
```

---

## 10. Missing Entity Contracts

### 10.1 ConditionCategory Entity

```dart
@freezed
class ConditionCategory with _$ConditionCategory {
  const ConditionCategory._();
  const factory ConditionCategory({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    String? description,
    String? iconName,
    int? colorValue,
    @Default(0) int sortOrder,
    required SyncMetadata syncMetadata,
  }) = _ConditionCategory;

  factory ConditionCategory.fromJson(Map<String, dynamic> json) =>
      _$ConditionCategoryFromJson(json);
}
```

### 10.2 FoodItemCategory Entity

NOTE: This entity is for user-defined food categories that extend the built-in FoodCategory enum.
The database table `food_item_categories` is a junction table linking food_items to FoodCategory enum values.
This entity would be stored in a separate `user_food_categories` table if implemented.

```dart
@freezed
class FoodItemCategory with _$FoodItemCategory {
  const FoodItemCategory._();
  const factory FoodItemCategory({
    required String id,
    required String clientId,
    required String profileId,          // User-defined categories are profile-scoped
    required String name,
    FoodCategory? parentCategory,       // Links to FoodCategory enum for diet rules
    @Default(false) bool isUserDefined, // Always true for this entity
    required SyncMetadata syncMetadata,
  }) = _FoodItemCategory;

  factory FoodItemCategory.fromJson(Map<String, dynamic> json) =>
      _$FoodItemCategoryFromJson(json);
}
```

### 10.2b UserFoodCategory Entity

This entity represents user-defined food categories stored in the `user_food_categories` table.
Referenced in Section 13 DB alignment but previously undefined.

```dart
@freezed
class UserFoodCategory with _$UserFoodCategory {
  const UserFoodCategory._();
  const factory UserFoodCategory({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    String? description,
    FoodCategory? parentCategory,       // Links to built-in FoodCategory enum
    @Default(0) int sortOrder,
    @Default(false) bool isArchived,
    required SyncMetadata syncMetadata,
  }) = _UserFoodCategory;

  factory UserFoodCategory.fromJson(Map<String, dynamic> json) =>
      _$UserFoodCategoryFromJson(json);
}

abstract class UserFoodCategoryRepository implements EntityRepository<UserFoodCategory, String> {
  Future<Result<List<UserFoodCategory>, AppError>> getByProfile(String profileId);
  Future<Result<List<UserFoodCategory>, AppError>> getByParentCategory(String profileId, FoodCategory parent);
}
```

### 10.3 HipaaAuthorization Entity

```dart
/// HIPAA-compliant authorization for profile sharing
/// Matches database table: hipaa_authorizations
@freezed
class HipaaAuthorization with _$HipaaAuthorization {
  const HipaaAuthorization._();

  const factory HipaaAuthorization({
    required String id,
    required String clientId,
    required String profileId,
    required String grantedToUserId,       // User ID receiving access
    required String grantedByUserId,       // User ID who granted access (profile owner)
    required List<DataScope> scopes,       // DataScope values from 35_QR_DEVICE_PAIRING.md
    required String purpose,               // Stated purpose for access
    required AuthorizationDuration duration, // How long authorization lasts
    required int authorizedAt,             // Epoch milliseconds - When authorization was signed
    int? expiresAt,                        // Epoch milliseconds - NULL = until revoked
    int? revokedAt,                        // Epoch milliseconds
    String? revokedReason,
    required String signatureDeviceId,     // Device that signed authorization
    required String signatureIpAddress,    // IP address at signing
    @Default(false) bool photosIncluded,   // Whether photos are included in scope
    required SyncMetadata syncMetadata,
  }) = _HipaaAuthorization;

  factory HipaaAuthorization.fromJson(Map<String, dynamic> json) =>
      _$HipaaAuthorizationFromJson(json);

  bool get isActive => revokedAt == null &&
      (expiresAt == null || expiresAt! > DateTime.now().millisecondsSinceEpoch);
}

// NOTE: AuthorizationDuration enum is defined in Section 3.2 above

/// Repository for HIPAA authorization records
abstract class HipaaAuthorizationRepository implements EntityRepository<HipaaAuthorization, String> {
  /// Get all authorizations for a profile
  Future<Result<List<HipaaAuthorization>, AppError>> getByProfile(String profileId);

  /// Get active (non-revoked, non-expired) authorizations
  Future<Result<List<HipaaAuthorization>, AppError>> getActive(String profileId);

  /// Get authorization for a specific grantee
  Future<Result<HipaaAuthorization?, AppError>> getByGrantee(String profileId, String grantedToUserId);

  /// Revoke an authorization
  Future<Result<void, AppError>> revoke(String id, String reason);
}
```

### 10.4 ProfileAccessLog Entity

```dart
/// Audit log for shared profile access (HIPAA requirement)
/// Matches database table: profile_access_logs
@freezed
class ProfileAccessLog with _$ProfileAccessLog {
  const ProfileAccessLog._();
  const factory ProfileAccessLog({
    required String id,
    required String clientId,              // Required for database merging
    required String authorizationId,       // Reference to HipaaAuthorization
    required String profileId,
    required String accessedByUserId,      // User who accessed
    required String accessedByDeviceId,    // Device used for access
    required ProfileAccessAction action,   // What action was performed
    required String entityType,            // Type of entity accessed
    String? entityId,                      // Specific entity if applicable
    required int accessedAt,               // Epoch milliseconds
    required String ipAddress,             // Required for HIPAA audit
    required SyncMetadata syncMetadata,    // Required for all entities
  }) = _ProfileAccessLog;

  factory ProfileAccessLog.fromJson(Map<String, dynamic> json) =>
      _$ProfileAccessLogFromJson(json);
}

/// Actions logged for profile access audit
enum ProfileAccessAction {
  view(0),       // Viewed data
  export(1),     // Exported/downloaded data
  addEntry(2),   // Added new entry
  editEntry(3);  // Modified existing entry

  final int value;
  const ProfileAccessAction(this.value);
}

/// Repository for HIPAA profile access audit logs
abstract class ProfileAccessLogRepository {
  /// Get access logs for an authorization
  Future<Result<List<ProfileAccessLog>, AppError>> getByAuthorization(
    String authorizationId, {
    int? limit,
    int? offset,
  });

  /// Get access logs for a profile (across all authorizations)
  Future<Result<List<ProfileAccessLog>, AppError>> getByProfile(
    String profileId, {
    int? since,          // Epoch ms
    int? limit,
  });

  /// Log an access event
  Future<Result<ProfileAccessLog, AppError>> create(ProfileAccessLog log);

  /// Count accesses by action type (for analytics)
  Future<Result<Map<ProfileAccessAction, int>, AppError>> countByAction(
    String profileId,
    int since,  // Epoch ms
  );
}

/// Repository for condition categories
abstract class ConditionCategoryRepository implements EntityRepository<ConditionCategory, String> {
  Future<Result<List<ConditionCategory>, AppError>> getByProfile(String profileId);
}

/// Repository for food item categories
/// NOTE: getAll() returns all categories (system + user-defined) without profileId filter.
/// See Section 15.7 for exemption documentation.
abstract class FoodItemCategoryRepository implements EntityRepository<FoodItemCategory, String> {
  @override
  Future<Result<List<FoodItemCategory>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  });
  Future<Result<List<FoodItemCategory>, AppError>> getUserDefined(String profileId);
}

/// Repository for imported data tracking
abstract class ImportedDataLogRepository implements EntityRepository<ImportedDataLog, String> {
  /// Check if a record has already been imported
  Future<Result<bool, AppError>> wasImported(
    String profileId,
    WearablePlatform platform,
    String sourceRecordId,
  );

  /// Get import history for a profile
  Future<Result<List<ImportedDataLog>, AppError>> getByProfile(
    String profileId, {
    WearablePlatform? platform,
    int? since,          // Epoch ms
    int? limit,
  });

  /// Get the shadow entity ID for an imported record
  Future<Result<String?, AppError>> getShadowEntityId(
    String profileId,
    WearablePlatform platform,
    String sourceRecordId,
  );
}
```

### 10.5 ImportedDataLog Entity

```dart
@freezed
class ImportedDataLog with _$ImportedDataLog {
  const ImportedDataLog._();
  const factory ImportedDataLog({
    required String id,
    required String clientId,
    required String profileId,
    required WearablePlatform sourcePlatform,
    required String sourceRecordId,
    required String targetEntityType,
    required String targetEntityId,
    required int importedAt,              // Epoch milliseconds
    required int sourceTimestamp,         // Epoch milliseconds
    String? rawData,                      // JSON of original record
    required SyncMetadata syncMetadata,
  }) = _ImportedDataLog;

  factory ImportedDataLog.fromJson(Map<String, dynamic> json) =>
      _$ImportedDataLogFromJson(json);
}
```

### 10.6 FhirExport Entity

```dart
@freezed
class FhirExport with _$FhirExport {
  const FhirExport._();
  const factory FhirExport({
    required String id,
    required String clientId,
    required String profileId,
    required String fhirVersion,          // 'R4'
    required String exportFormat,         // 'json' or 'xml'
    required List<String> resourceTypes,  // ['Patient', 'Condition', 'Observation']
    required int exportedAt,              // Epoch milliseconds
    required int dataRangeStart,          // Epoch milliseconds
    required int dataRangeEnd,            // Epoch milliseconds
    required int recordCount,
    required int fileSizeBytes,
    String? fileHash,
    String? cloudStorageUrl,
    required int createdAt,              // Epoch ms - local only
    required int updatedAt,              // Epoch ms - local only
  }) = _FhirExport;

  factory FhirExport.fromJson(Map<String, dynamic> json) =>
      _$FhirExportFromJson(json);
}

/// Repository for FHIR exports
abstract class FhirExportRepository implements EntityRepository<FhirExport, String> {
  /// Get exports for a profile
  Future<Result<List<FhirExport>, AppError>> getByProfile(
    String profileId, {
    int? since,          // Epoch ms
    int? limit,
  });

  /// Get export by file hash (for deduplication)
  Future<Result<FhirExport?, AppError>> getByHash(String fileHash);

  /// Get total export size for a profile (for quota management)
  Future<Result<int, AppError>> getTotalSizeBytes(String profileId);
}
```

### 10.7 Profile Entity (P0 - Core)

```dart
enum BiologicalSex {
  male(0),
  female(1),
  other(2);

  final int value;
  const BiologicalSex(this.value);
}

/// Simple diet indicator on Profile.
/// NOTE: This is DISTINCT from the full Diet system (see Diet entity).
/// - ProfileDietType: Simple label shown in profile, for quick reference
/// - Diet entity: Full diet with rules, compliance tracking, eating windows
/// A profile can have BOTH: dietType for display AND an active Diet for tracking
enum ProfileDietType {
  none(0),
  vegan(1),
  vegetarian(2),
  paleo(3),
  keto(4),
  glutenFree(5),
  other(6);

  final int value;
  const ProfileDietType(this.value);
}

/// Profile is the root entity for user health data.
/// NOTE: Profile does not have a profileId field because it IS the profile.
/// Child entities reference this entity via their profileId foreign key.
/// The ownerId field links to user_accounts for multi-profile support.
@freezed
class Profile with _$Profile {
  const Profile._();

  const factory Profile({
    required String id,                   // This IS the profileId for child entities
    required String clientId,
    required String name,
    int? birthDate,                       // Epoch milliseconds
    BiologicalSex? biologicalSex,
    String? ethnicity,
    String? notes,
    String? ownerId,                      // FK to user_accounts
    /// Simple diet label for display purposes.
    /// For compliance tracking, create a Diet entity instead.
    @Default(ProfileDietType.none) ProfileDietType dietType,
    String? dietDescription,              // Custom description when dietType=other
    required SyncMetadata syncMetadata,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  int? get ageYears {
    if (birthDate == null) return null;
    final birth = DateTime.fromMillisecondsSinceEpoch(birthDate!);
    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }
}

abstract class ProfileRepository implements EntityRepository<Profile, String> {
  Future<Result<List<Profile>, AppError>> getByOwner(String ownerId);
  Future<Result<Profile?, AppError>> getDefault(String ownerId);

  /// Get all profiles for a user (alias for getByOwner for clarity in user context).
  Future<Result<List<Profile>, AppError>> getByUser(String userId);
}
```

### 10.8 Condition Entity (P0 - Core)

```dart
enum ConditionStatus {
  active(0),
  resolved(1);

  final int value;
  const ConditionStatus(this.value);
}

@freezed
class Condition with _$Condition {
  const Condition._();

  const factory Condition({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    required String category,
    required List<String> bodyLocations,  // JSON array in DB
    @Default([]) List<String> triggers,   // Predefined trigger list per 38_UI_FIELD_SPECIFICATIONS.md Section 8.2
    String? description,
    String? baselinePhotoPath,
    required int startTimeframe,          // Epoch milliseconds
    int? endDate,                         // Epoch milliseconds
    @Default(ConditionStatus.active) ConditionStatus status,
    @Default(false) bool isArchived,
    String? activityId,                   // FK to activities
    // File sync metadata
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    @Default(false) bool isFileUploaded,
    required SyncMetadata syncMetadata,
  }) = _Condition;

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);

  bool get hasBaselinePhoto => baselinePhotoPath != null;
  bool get isResolved => status == ConditionStatus.resolved;
  bool get isActive => !isArchived && status == ConditionStatus.active;
}

abstract class ConditionRepository implements EntityRepository<Condition, String> {
  Future<Result<List<Condition>, AppError>> getByProfile(
    String profileId, {
    ConditionStatus? status,
    bool includeArchived = false,
  });
  Future<Result<List<Condition>, AppError>> getActive(String profileId);
  Future<Result<void, AppError>> archive(String id);
  Future<Result<void, AppError>> resolve(String id);
}
```

### 10.9 ConditionLog Entity (P0 - Core)

```dart
@freezed
class ConditionLog with _$ConditionLog {
  const ConditionLog._();

  const factory ConditionLog({
    required String id,
    required String clientId,
    required String profileId,
    required String conditionId,
    required int timestamp,               // Epoch milliseconds
    required int severity,                // 1-10 scale
    String? notes,
    @Default(false) bool isFlare,
    @Default([]) List<String> flarePhotoIds,
    String? photoPath,
    String? activityId,
    String? triggers,                     // Comma-separated
    // File sync metadata
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    @Default(false) bool isFileUploaded,
    required SyncMetadata syncMetadata,
  }) = _ConditionLog;

  factory ConditionLog.fromJson(Map<String, dynamic> json) =>
      _$ConditionLogFromJson(json);

  bool get hasPhoto => photoPath != null;
  List<String> get triggerList => triggers?.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList() ?? [];
}

abstract class ConditionLogRepository implements EntityRepository<ConditionLog, String> {
  /// Get all condition logs for a profile.
  Future<Result<List<ConditionLog>, AppError>> getByProfile(
    String profileId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    int? limit,
    int? offset,
  });

  /// Get condition logs for a specific condition.
  Future<Result<List<ConditionLog>, AppError>> getByCondition(
    String conditionId, {
    int? startDate,     // Epoch milliseconds
    int? endDate,       // Epoch milliseconds
    int? limit,
    int? offset,
  });
  Future<Result<List<ConditionLog>, AppError>> getByDateRange(
    String profileId,
    int start,  // Epoch ms
    int end,    // Epoch ms
  );
  Future<Result<List<ConditionLog>, AppError>> getFlares(
    String conditionId, {
    int? limit,
  });
}
```

### 10.10 IntakeLog Entity (P0 - Supplements)

```dart
enum IntakeLogStatus {
  pending(0),
  taken(1),
  skipped(2),
  missed(3),
  snoozed(4);              // Per 38_UI_FIELD_SPECIFICATIONS.md Section 4.2

  final int value;
  const IntakeLogStatus(this.value);
}

@freezed
class IntakeLog with _$IntakeLog {
  const IntakeLog._();

  const factory IntakeLog({
    required String id,
    required String clientId,
    required String profileId,
    required String supplementId,
    required int scheduledTime,           // Epoch milliseconds
    int? actualTime,                      // Epoch milliseconds - when actually taken
    @Default(IntakeLogStatus.pending) IntakeLogStatus status,
    String? reason,                       // Why skipped/missed
    String? note,
    int? snoozeDurationMinutes,           // See ValidationRules.validSnoozeDurationMinutes
    required SyncMetadata syncMetadata,
  }) = _IntakeLog;

  factory IntakeLog.fromJson(Map<String, dynamic> json) =>
      _$IntakeLogFromJson(json);

  bool get isTaken => status == IntakeLogStatus.taken;
  bool get isPending => status == IntakeLogStatus.pending;
  bool get isSkipped => status == IntakeLogStatus.skipped;
  bool get isMissed => status == IntakeLogStatus.missed;
  bool get isSnoozed => status == IntakeLogStatus.snoozed;
  Duration? get delayFromScheduled {
    if (actualTime == null) return null;
    return Duration(milliseconds: actualTime! - scheduledTime);
  }
}

abstract class IntakeLogRepository implements EntityRepository<IntakeLog, String> {
  Future<Result<List<IntakeLog>, AppError>> getByProfile(
    String profileId, {
    IntakeLogStatus? status,
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    int? limit,
    int? offset,
  });
  Future<Result<List<IntakeLog>, AppError>> getBySupplement(
    String supplementId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
  });
  Future<Result<List<IntakeLog>, AppError>> getPendingForDate(
    String profileId,
    int date,  // Epoch ms (start of day)
  );
  Future<Result<IntakeLog, AppError>> markTaken(String id, int actualTime);  // Epoch ms
  Future<Result<IntakeLog, AppError>> markSkipped(String id, String? reason);
  Future<Result<IntakeLog, AppError>> markSnoozed(String id, int snoozeDurationMinutes);
}
```

### 10.11 FoodItem Entity (P0 - Food)

```dart
enum FoodItemType {
  simple(0),
  complex(1);

  final int value;
  const FoodItemType(this.value);
}

@freezed
class FoodItem with _$FoodItem {
  const FoodItem._();

  const factory FoodItem({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    @Default(FoodItemType.simple) FoodItemType type,
    @Default([]) List<String> simpleItemIds,  // For complex items
    @Default(true) bool isUserCreated,
    @Default(false) bool isArchived,

    // Nutritional information (optional)
    String? servingSize,             // e.g., "1 cup", "100g"
    double? calories,                // kcal per serving
    double? carbsGrams,              // Carbohydrates in grams
    double? fatGrams,                // Fat in grams
    double? proteinGrams,            // Protein in grams
    double? fiberGrams,              // Fiber in grams
    double? sugarGrams,              // Sugar in grams

    required SyncMetadata syncMetadata,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  bool get isComplex => type == FoodItemType.complex;
  bool get isSimple => type == FoodItemType.simple;
  bool get hasNutritionalInfo => calories != null || carbsGrams != null;
}

abstract class FoodItemRepository implements EntityRepository<FoodItem, String> {
  Future<Result<List<FoodItem>, AppError>> getByProfile(
    String profileId, {
    FoodItemType? type,
    bool includeArchived = false,
  });
  Future<Result<List<FoodItem>, AppError>> search(
    String profileId,
    String query, {
    int limit = ValidationRules.defaultSearchLimit,
  });
  Future<Result<void, AppError>> archive(String id);

  /// Search food items excluding specific categories.
  Future<Result<List<FoodItem>, AppError>> searchExcludingCategories(
    String profileId,
    String query, {
    required List<String> excludeCategories,
    int limit = ValidationRules.defaultSearchLimit,
  });
}
```

### 10.12 FoodLog Entity (P0 - Food)

```dart
/// Meal type classification per 38_UI_FIELD_SPECIFICATIONS.md Section 5.1
enum MealType {
  breakfast(0),
  lunch(1),
  dinner(2),
  snack(3);

  final int value;
  const MealType(this.value);

  static MealType fromValue(int value) => MealType.values.firstWhere(
    (e) => e.value == value,
    orElse: () => snack,
  );
}

@freezed
class FoodLog with _$FoodLog {
  const FoodLog._();

  const factory FoodLog({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp,               // Epoch milliseconds
    MealType? mealType,                   // Per 38_UI_FIELD_SPECIFICATIONS.md Section 5.1
    @Default([]) List<String> foodItemIds,  // Comma-separated in DB
    @Default([]) List<String> adHocItems,   // Comma-separated in DB - quick entry items
    String? notes,
    required SyncMetadata syncMetadata,
  }) = _FoodLog;

  factory FoodLog.fromJson(Map<String, dynamic> json) =>
      _$FoodLogFromJson(json);

  bool get hasItems => foodItemIds.isNotEmpty || adHocItems.isNotEmpty;
  int get totalItems => foodItemIds.length + adHocItems.length;
}

abstract class FoodLogRepository implements EntityRepository<FoodLog, String> {
  Future<Result<List<FoodLog>, AppError>> getByProfile(
    String profileId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    int? limit,
    int? offset,
  });
  Future<Result<List<FoodLog>, AppError>> getForDate(
    String profileId,
    int date,  // Epoch ms (start of day)
  );

  /// Get food logs within a date range.
  Future<Result<List<FoodLog>, AppError>> getByDateRange(
    String profileId,
    int startDate,  // Epoch ms
    int endDate,    // Epoch ms
  );
}
```

### 10.13 Activity Entity (P1)

```dart
// lib/domain/entities/activity.dart

@freezed
class Activity with _$Activity implements Syncable {
  const Activity._();
  const factory Activity({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    String? description,
    String? location,
    String? triggers,             // Comma-separated trigger descriptions
    required int durationMinutes,
    @Default(false) bool isArchived,
    required SyncMetadata syncMetadata,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

abstract class ActivityRepository implements EntityRepository<Activity, String> {
  Future<Result<List<Activity>, AppError>> getByProfile(
    String profileId, {
    bool includeArchived = false,
    int? limit,
    int? offset,
  });
  Future<Result<List<Activity>, AppError>> getActive(String profileId);
}
```

### 10.14 ActivityLog Entity (P1)

```dart
// lib/domain/entities/activity_log.dart

@freezed
class ActivityLog with _$ActivityLog implements Syncable {
  const ActivityLog._();
  const factory ActivityLog({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp,          // Epoch milliseconds
    required List<String> activityIds,
    required List<String> adHocActivities,
    int? duration,                   // Actual duration if different from planned
    String? notes,
    // Import tracking (for wearable data - HealthKit/Google Fit)
    String? importSource,            // 'healthkit', 'googlefit', etc.
    String? importExternalId,        // External record ID for deduplication
    required SyncMetadata syncMetadata,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogFromJson(json);
}

abstract class ActivityLogRepository implements EntityRepository<ActivityLog, String> {
  Future<Result<List<ActivityLog>, AppError>> getByProfile(
    String profileId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    int? limit,
    int? offset,
  });
  Future<Result<List<ActivityLog>, AppError>> getForDate(
    String profileId,
    int date,  // Epoch ms (start of day)
  );

  /// Get activity log by external import ID (for deduplication of wearable data).
  Future<Result<ActivityLog?, AppError>> getByExternalId(
    String profileId,
    String importSource,
    String importExternalId,
  );
}
```

### 10.15 SleepEntry Entity (P1)

```dart
// lib/domain/entities/sleep_entry.dart

enum DreamType {
  noDreams(0),
  vague(1),
  vivid(2),
  nightmares(3);

  final int value;
  const DreamType(this.value);
}

enum WakingFeeling {
  unrested(0),
  neutral(1),
  rested(2);

  final int value;
  const WakingFeeling(this.value);
}

@freezed
class SleepEntry with _$SleepEntry implements Syncable {
  const SleepEntry._();
  const factory SleepEntry({
    required String id,
    required String clientId,
    required String profileId,
    required int bedTime,            // Epoch milliseconds
    int? wakeTime,                   // Epoch milliseconds
    @Default(0) int deepSleepMinutes,
    @Default(0) int lightSleepMinutes,
    @Default(0) int restlessSleepMinutes,
    @Default(DreamType.noDreams) DreamType dreamType,
    @Default(WakingFeeling.neutral) WakingFeeling wakingFeeling,
    String? notes,
    // Import tracking (for wearable data - HealthKit/Google Fit/Apple Watch)
    String? importSource,            // 'healthkit', 'googlefit', 'apple_watch', etc.
    String? importExternalId,        // External record ID for deduplication
    required SyncMetadata syncMetadata,
  }) = _SleepEntry;

  factory SleepEntry.fromJson(Map<String, dynamic> json) =>
      _$SleepEntryFromJson(json);

  int? get totalSleepMinutes {
    if (wakeTime == null) return null;
    return ((wakeTime! - bedTime) / 60000).round();
  }
}

abstract class SleepEntryRepository implements EntityRepository<SleepEntry, String> {
  Future<Result<List<SleepEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    int? limit,
    int? offset,
  });
  Future<Result<SleepEntry?, AppError>> getForNight(
    String profileId,
    int date,  // Epoch ms (start of day)
  );
  Future<Result<Map<String, double>, AppError>> getAverages(
    String profileId, {
    required int startDate,  // Epoch ms
    required int endDate,    // Epoch ms
  });
}
```

### 10.16 JournalEntry Entity (P1)

```dart
// lib/domain/entities/journal_entry.dart

@freezed
class JournalEntry with _$JournalEntry implements Syncable {
  const JournalEntry._();

  const factory JournalEntry({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp,          // Epoch milliseconds
    required String content,
    String? title,
    int? mood,                       // Mood rating 1-10, optional
    List<String>? tags,
    String? audioUrl,
    required SyncMetadata syncMetadata,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);
}

abstract class JournalEntryRepository implements EntityRepository<JournalEntry, String> {
  Future<Result<List<JournalEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    List<String>? tags,
    int? mood,           // Filter by mood rating
    int? limit,
    int? offset,
  });
  Future<Result<List<JournalEntry>, AppError>> search(
    String profileId,
    String query,
  );
  Future<Result<Map<int, int>, AppError>> getMoodDistribution(
    String profileId, {
    required int startDate,  // Epoch ms
    required int endDate,    // Epoch ms
  });
}
```

### 10.17 PhotoArea Entity (P1)

```dart
// lib/domain/entities/photo_area.dart

@freezed
class PhotoArea with _$PhotoArea implements Syncable {
  const PhotoArea._();

  const factory PhotoArea({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    String? description,             // Area description
    String? consistencyNotes,        // Guidance for consistent photo positioning
    @Default(0) int sortOrder,       // Display order
    @Default(false) bool isArchived, // Soft delete flag
    required SyncMetadata syncMetadata,
  }) = _PhotoArea;

  factory PhotoArea.fromJson(Map<String, dynamic> json) =>
      _$PhotoAreaFromJson(json);
}

abstract class PhotoAreaRepository implements EntityRepository<PhotoArea, String> {
  Future<Result<List<PhotoArea>, AppError>> getByProfile(
    String profileId, {
    bool includeArchived = false,
  });
  Future<Result<void, AppError>> reorder(
    String profileId,
    List<String> areaIds,  // Ordered list of area IDs
  );
}
```

### 10.18 PhotoEntry Entity (P1)

```dart
// lib/domain/entities/photo_entry.dart

@freezed
class PhotoEntry with _$PhotoEntry implements Syncable {
  const PhotoEntry._();

  const factory PhotoEntry({
    required String id,
    required String clientId,
    required String profileId,
    required String photoAreaId,     // FK to PhotoArea
    required int timestamp,          // Epoch milliseconds
    required String filePath,
    String? notes,
    // File sync metadata
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    @Default(false) bool isFileUploaded,
    required SyncMetadata syncMetadata,
  }) = _PhotoEntry;

  factory PhotoEntry.fromJson(Map<String, dynamic> json) =>
      _$PhotoEntryFromJson(json);
}

abstract class PhotoEntryRepository implements EntityRepository<PhotoEntry, String> {
  Future<Result<List<PhotoEntry>, AppError>> getByArea(
    String photoAreaId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    int? limit,
    int? offset,
  });
  Future<Result<List<PhotoEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    int? limit,
    int? offset,
  });
  Future<Result<List<PhotoEntry>, AppError>> getPendingUpload();
}
```

### 10.19 FlareUp Entity (P1)

```dart
// lib/domain/entities/flare_up.dart

@freezed
class FlareUp with _$FlareUp implements Syncable {
  const FlareUp._();

  const factory FlareUp({
    required String id,
    required String clientId,
    required String profileId,
    required String conditionId,
    required int startDate,          // Epoch milliseconds - flare-up start
    int? endDate,                    // Epoch milliseconds - flare-up end (null = ongoing)
    required int severity,           // 1-10 scale
    String? notes,
    required List<String> triggers,  // Trigger descriptions
    String? activityId,              // Activity that may have triggered flare-up
    String? photoPath,
    required SyncMetadata syncMetadata,
  }) = _FlareUp;

  factory FlareUp.fromJson(Map<String, dynamic> json) =>
      _$FlareUpFromJson(json);

  /// Duration in milliseconds, null if ongoing
  int? get durationMs => endDate != null ? endDate! - startDate : null;

  /// Whether the flare-up is currently active
  bool get isOngoing => endDate == null;
}

abstract class FlareUpRepository implements EntityRepository<FlareUp, String> {
  Future<Result<List<FlareUp>, AppError>> getByCondition(
    String conditionId, {
    int? startDate,      // Epoch ms - filter by flare-up startDate
    int? endDate,        // Epoch ms - filter by flare-up startDate
    bool? ongoingOnly,   // Filter to only ongoing flare-ups
    int? limit,
    int? offset,
  });
  Future<Result<List<FlareUp>, AppError>> getByProfile(
    String profileId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    bool? ongoingOnly,   // Filter to only ongoing flare-ups
    int? limit,
    int? offset,
  });
  Future<Result<Map<String, int>, AppError>> getTriggerCounts(
    String conditionId, {
    required int startDate,  // Epoch ms
    required int endDate,    // Epoch ms
  });
  Future<Result<List<FlareUp>, AppError>> getOngoing(String profileId);
}
```

### 10.20 UserAccount Entity (P0 - Core)

```dart
// lib/domain/entities/user_account.dart

@freezed
class UserAccount with _$UserAccount {
  const UserAccount._();

  const factory UserAccount({
    required String id,
    required String clientId,
    required String email,
    String? displayName,
    String? photoUrl,
    required AuthProvider authProvider,    // google, apple
    required String authProviderId,        // External provider user ID
    required int createdAt,                // Epoch milliseconds
    int? lastLoginAt,                      // Epoch milliseconds
    @Default(true) bool isActive,
    String? deactivatedReason,
    required SyncMetadata syncMetadata,
  }) = _UserAccount;

  factory UserAccount.fromJson(Map<String, dynamic> json) =>
      _$UserAccountFromJson(json);

  bool get isDeactivated => !isActive;
}

enum AuthProvider {
  google(0),
  apple(1);

  final int value;
  const AuthProvider(this.value);
}

abstract class UserAccountRepository implements EntityRepository<UserAccount, String> {
  Future<Result<UserAccount?, AppError>> getByEmail(String email);
  Future<Result<UserAccount?, AppError>> getByAuthProvider(
    AuthProvider provider,
    String providerId,
  );
  Future<Result<void, AppError>> updateLastLogin(String id);
  Future<Result<void, AppError>> deactivate(String id, String reason);
}
```

### 10.21 DeviceRegistration Entity (P0 - Core)

```dart
// lib/domain/entities/device_registration.dart

@freezed
class DeviceRegistration with _$DeviceRegistration {
  const DeviceRegistration._();

  const factory DeviceRegistration({
    required String id,
    required String clientId,
    required String userAccountId,
    required String deviceId,              // Platform-specific unique ID
    required String deviceName,            // User-friendly name
    required DeviceType deviceType,
    String? osVersion,
    String? appVersion,
    required int registeredAt,             // Epoch milliseconds
    required int lastSeenAt,               // Epoch milliseconds
    @Default(true) bool isActive,
    String? pushToken,                     // For notifications
    required SyncMetadata syncMetadata,
  }) = _DeviceRegistration;

  factory DeviceRegistration.fromJson(Map<String, dynamic> json) =>
      _$DeviceRegistrationFromJson(json);

  bool get isStale => DateTime.now().millisecondsSinceEpoch - lastSeenAt > 30 * 24 * 60 * 60 * 1000;
}

enum DeviceType {
  iOS(0),
  android(1),
  macOS(2),
  web(3);

  final int value;
  const DeviceType(this.value);
}

abstract class DeviceRegistrationRepository implements EntityRepository<DeviceRegistration, String> {
  Future<Result<List<DeviceRegistration>, AppError>> getByUser(String userAccountId);
  Future<Result<DeviceRegistration?, AppError>> getByDeviceId(String deviceId);
  Future<Result<void, AppError>> updateLastSeen(String id);
  Future<Result<void, AppError>> updatePushToken(String id, String pushToken);
  Future<Result<void, AppError>> deactivate(String id);
  Future<Result<void, AppError>> deactivateAllForUser(String userAccountId);
}
```

### 10.22 Document Entity (P0 - Core)

```dart
// lib/domain/entities/document.dart

@freezed
class Document with _$Document {
  const Document._();

  const factory Document({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    required DocumentType documentType,
    required String filePath,
    String? notes,
    int? documentDate,                     // Epoch milliseconds - date of document
    required int uploadedAt,               // Epoch milliseconds - when uploaded
    // File sync metadata
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    String? mimeType,
    @Default(false) bool isFileUploaded,
    required SyncMetadata syncMetadata,
  }) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  bool get isPdf => mimeType == 'application/pdf';
  bool get isImage => mimeType?.startsWith('image/') ?? false;
}

abstract class DocumentRepository implements EntityRepository<Document, String> {
  Future<Result<List<Document>, AppError>> getByProfile(
    String profileId, {
    DocumentType? type,
    int? limit,
    int? offset,
  });
  Future<Result<List<Document>, AppError>> search(
    String profileId,
    String query, {
    int limit = ValidationRules.defaultSearchLimit,
  });
  Future<Result<List<Document>, AppError>> getPendingUpload();
}
```

### 10.23 MLModel Entity (P1 - Intelligence)

```dart
// lib/domain/entities/ml_model.dart
// NOTE: Local-only entity - does NOT sync to cloud (privacy-first ML)

@freezed
class MLModel with _$MLModel {
  const MLModel._();

  const factory MLModel({
    required String id,
    required String clientId,            // Required for database merging support
    required String profileId,
    required MLModelType modelType,
    required String modelVersion,
    required int trainedAt,                // Epoch milliseconds
    required int dataPointsUsed,
    required double accuracy,              // 0.0-1.0
    required double precision,             // 0.0-1.0
    required double recall,                // 0.0-1.0
    required int modelSizeBytes,
    required String modelPath,             // Local file path to TFLite model
    String? trainingNotes,
    required int createdAt,              // Epoch ms - local only
    required int updatedAt,              // Epoch ms - local only
  }) = _MLModel;

  factory MLModel.fromJson(Map<String, dynamic> json) =>
      _$MLModelFromJson(json);

  double get f1Score => 2 * (precision * recall) / (precision + recall);
}

enum MLModelType {
  flareUpPrediction(0),
  menstrualCyclePrediction(1),
  triggerDetection(2),
  sleepQualityPrediction(3);

  final int value;
  const MLModelType(this.value);
}

abstract class MLModelRepository {
  // NOTE: No sync - local only repository
  Future<Result<MLModel?, AppError>> getLatest(String profileId, MLModelType type);
  Future<Result<List<MLModel>, AppError>> getByProfile(String profileId);
  Future<Result<MLModel, AppError>> save(MLModel model);
  Future<Result<void, AppError>> delete(String id);
  Future<Result<void, AppError>> deleteOldVersions(
    String profileId,
    MLModelType type,
    {int keepCount = 3},
  );
}
```

### 10.24 PredictionFeedback Entity (P1 - Intelligence)

```dart
// lib/domain/entities/prediction_feedback.dart
// NOTE: Local-only entity - used to improve ML models

@freezed
class PredictionFeedback with _$PredictionFeedback {
  const PredictionFeedback._();

  const factory PredictionFeedback({
    required String id,
    required String clientId,            // Required for database merging support
    required String profileId,
    required String predictiveAlertId,
    required PredictionType predictionType,
    required double predictedProbability,
    required int predictedEventTime,       // Epoch milliseconds
    required bool eventOccurred,
    int? actualEventTime,                  // Epoch milliseconds
    required int feedbackRecordedAt,       // Epoch milliseconds
    String? userNotes,
    @Default(false) bool usedForRetraining,
    required int createdAt,              // Epoch ms - local only
    required int updatedAt,              // Epoch ms - local only
  }) = _PredictionFeedback;

  factory PredictionFeedback.fromJson(Map<String, dynamic> json) =>
      _$PredictionFeedbackFromJson(json);

  bool get wasCorrect => eventOccurred == (predictedProbability >= 0.5);
  Duration? get timingError {
    if (actualEventTime == null) return null;
    return Duration(milliseconds: (actualEventTime! - predictedEventTime).abs());
  }
}

abstract class PredictionFeedbackRepository {
  // NOTE: No sync - local only repository
  Future<Result<List<PredictionFeedback>, AppError>> getByProfile(
    String profileId, {
    PredictionType? type,
    bool untrainedOnly = false,
    int? limit,
  });
  Future<Result<PredictionFeedback, AppError>> create(PredictionFeedback feedback);
  Future<Result<void, AppError>> markAsUsedForRetraining(List<String> ids);
  Future<Result<Map<PredictionType, double>, AppError>> getAccuracyByType(String profileId);
}
```

### 10.25 BowelUrineLog Entity (Legacy Compatibility)

```dart
// lib/domain/entities/bowel_urine_log.dart
// NOTE: Legacy entity for backwards compatibility with pre-Fluids data.
// New code should use FluidsEntry instead.
// This entity exists to support migration from v3 databases.

@freezed
class BowelUrineLog with _$BowelUrineLog {
  const BowelUrineLog._();

  const factory BowelUrineLog({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp,                // Epoch milliseconds
    // Bowel fields
    bool? hasBowelMovement,
    BristolScale? bowelCondition,
    String? bowelCustomCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,
    // Urine fields
    bool? hasUrineMovement,
    UrineColor? urineCondition,
    String? urineCustomCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,
    required SyncMetadata syncMetadata,
  }) = _BowelUrineLog;

  factory BowelUrineLog.fromJson(Map<String, dynamic> json) =>
      _$BowelUrineLogFromJson(json);

  /// Convert to FluidsEntry for new code paths
  FluidsEntry toFluidsEntry() => FluidsEntry(
    id: id,
    clientId: clientId,
    profileId: profileId,
    timestamp: timestamp,
    hasBowelMovement: hasBowelMovement ?? false,
    bowelCondition: bowelCondition,
    bowelCustomCondition: bowelCustomCondition,
    bowelSize: bowelSize,
    bowelPhotoPath: bowelPhotoPath,
    hasUrineMovement: hasUrineMovement ?? false,
    urineCondition: urineCondition,
    urineCustomCondition: urineCustomCondition,
    urineSize: urineSize,
    urinePhotoPath: urinePhotoPath,
    syncMetadata: syncMetadata,
  );
}

/// Repository only used for migration - read-only
abstract class BowelUrineLogRepository {
  Future<Result<List<BowelUrineLog>, AppError>> getAll(String profileId);
  Future<Result<int, AppError>> getCount(String profileId);
}
```

### 10.26 ProfileAccess Entity (P0 - Core)

```dart
// lib/domain/entities/profile_access.dart

/// Represents a user's access grant to a profile.
/// This is the database entity - distinct from the ProfileAccess DTO in Section 9.1.
/// Matches database table: profile_access
@freezed
class ProfileAccessEntity with _$ProfileAccessEntity {
  const ProfileAccessEntity._();

  const factory ProfileAccessEntity({
    required String id,
    required String clientId,
    required String profileId,           // FK to profiles
    required String userId,              // FK to user_accounts
    required AccessLevel accessLevel,    // read_only, read_write, owner
    required int grantedAt,              // Epoch milliseconds
    int? expiresAt,                       // Epoch milliseconds, null = no expiry
    required SyncMetadata syncMetadata,
  }) = _ProfileAccessEntity;

  factory ProfileAccessEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfileAccessEntityFromJson(json);

  /// Check if access has expired
  bool get isExpired =>
      expiresAt != null && expiresAt! < DateTime.now().millisecondsSinceEpoch;

  /// Check if access is currently valid
  bool get isValid => !isExpired;
}

abstract class ProfileAccessRepository implements EntityRepository<ProfileAccessEntity, String> {
  /// Get all access grants for a profile
  Future<Result<List<ProfileAccessEntity>, AppError>> getByProfile(String profileId);

  /// Get all profiles a user has access to
  Future<Result<List<ProfileAccessEntity>, AppError>> getByUser(String userId);

  /// Get specific access grant for user-profile combination
  Future<Result<ProfileAccessEntity?, AppError>> getByUserAndProfile(
    String userId,
    String profileId,
  );

  /// Revoke access (soft delete via syncMetadata.isDeleted)
  Future<Result<void, AppError>> revoke(String id);

  /// Get all valid (non-expired) access grants for a user
  Future<Result<List<ProfileAccessEntity>, AppError>> getValidAccessByUser(String userId);
}
```

---

## 11. Enforcement Mechanisms

### 11.1 Custom Lint Rules

```yaml
# analysis_options.yaml

analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    - require_result_type_for_repositories: true
    - no_throwing_in_repositories: true
    - require_authorization_in_use_cases: true
    - require_validation_in_use_cases: true
    - require_freezed_for_entities: true
    - require_semantic_labels: true
```

### 11.2 Pre-commit Checks

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Check for missing generated files
if git diff --name-only | grep -E '\.(freezed|g)\.dart$'; then
  echo "ERROR: Generated files modified. Run build_runner."
  exit 1
fi

# Run analyzer
flutter analyze --fatal-infos

# Run contract tests
flutter test test/contracts/
```

---

## 12. Behavioral Specifications

This section resolves ambiguities identified during specification audits. These are CANONICAL definitions.

### 12.1 Diet Compliance Calculation

**What constitutes a "meal" for compliance calculation:**

A "meal" is defined as ANY FoodLog entry, regardless of meal type designation. Each food log is counted as ONE compliance opportunity.

**Compliance Score Formula:**

```dart
/// Daily compliance score calculation
/// Returns: 0.0 - 100.0 (percentage)
double calculateDailyCompliance(
  String profileId,
  String dietId,
  int date,  // Epoch ms (start of day)
) {
  final foodLogs = getLogsForDate(profileId, date);
  if (foodLogs.isEmpty) {
    // No food logged = 100% compliant (no violations possible)
    return 100.0;
  }

  int totalMeals = foodLogs.length;
  int violatingMeals = 0;

  for (final log in foodLogs) {
    // A single FoodLog with multiple violating items counts as ONE violation
    final hasViolation = checkLogForViolations(log, dietId).isNotEmpty;
    if (hasViolation) violatingMeals++;
  }

  return ((totalMeals - violatingMeals) / totalMeals) * 100.0;
}
```

**Precision and Rounding:**
- Internal calculations use double precision
- Display values rounded to 1 decimal place (e.g., "87.5%")
- Streak calculations use integer threshold (≥80% for streak continuation)

**Time-Based Diet Compliance:**

For intermittent fasting diets, compliance is binary per day:
- Within eating window: 100% compliant
- Any food logged outside window: 0% compliant for that day
- "Grace period" of 5 minutes at window boundaries

### 12.2 Conditional Field Requirements

**BBT (Basal Body Temperature):**

| Field | Required When | Validation |
|-------|---------------|------------|
| basalBodyTemperature | User wants to log BBT | 95.0-105.0°F / 35.0-40.6°C |
| bbtRecordedTime | basalBodyTemperature is provided | Must be valid epoch ms (int) |

**Other Fluid Tracking:**

| Field | Required When | Validation |
|-------|---------------|------------|
| otherFluidName | otherFluidAmount OR otherFluidNotes provided | 2-100 characters, letters/spaces/hyphens only |
| otherFluidAmount | Never required (optional descriptive text) | Max 50 characters |
| otherFluidNotes | Never required | Max 5000 characters |

**FluidsEntry Minimum Data:**

At least ONE of the following must be non-null:
- waterIntakeMl
- bowelCondition
- urineCondition
- menstruationFlow
- basalBodyTemperature
- otherFluidName

### 12.3 Pre-Log Compliance Warning

**Warning Precision:**

When calculating `complianceImpactPercent` for pre-log warnings:

```dart
/// Calculate how much logging this food will reduce compliance
double calculateImpact(String profileId, String dietId, FoodItem food) {
  // Get today's current compliance
  final currentScore = calculateDailyCompliance(profileId, dietId, today);
  final currentMeals = getTodayMealCount(profileId);

  // Calculate what score would be with this addition
  final wouldViolate = checkFoodForViolations(food, dietId).isNotEmpty;
  final newMeals = currentMeals + 1;
  final newViolations = wouldViolate ? 1 : 0;

  // Current violations count
  final currentViolations = ((100.0 - currentScore) / 100.0 * currentMeals).round();

  // New score
  final newScore = ((newMeals - (currentViolations + newViolations)) / newMeals) * 100.0;

  // Impact is the difference (always positive or zero)
  return max(0, currentScore - newScore);
}
```

### 12.4 Quiet Hours Queuing Behavior

**When `holdUntilEnd` is selected:**

```dart
/// EPHEMERAL DTO - NOT a persistent entity.
/// Used for quiet hours notification queuing. Stored in memory or temporary table.
/// Exempt from standard entity requirements (id, syncMetadata) per Section 15.
/// Cleared when quiet hours end - no long-term persistence.
@freezed
class QueuedNotification with _$QueuedNotification {
  const factory QueuedNotification({
    required String id,
    required String clientId,            // For consistency with entity pattern
    required String profileId,           // Profile that owns this queued notification
    required NotificationType type,
    required int originalScheduledTime,  // Epoch milliseconds
    required int queuedAt,               // Epoch milliseconds
    required Map<String, dynamic> payload,
    // NOTE: No syncMetadata - ephemeral entity, cleared when quiet hours end
  }) = _QueuedNotification;

  factory QueuedNotification.fromJson(Map<String, dynamic> json) =>
      _$QueuedNotificationFromJson(json);
}

class QuietHoursQueueService {
  final QueuedNotificationTable _queuedNotificationsTable;
  final NotificationService _notificationService;

  QuietHoursQueueService(this._queuedNotificationsTable, this._notificationService);

  /// Queue a notification for delivery after quiet hours
  /// Returns Result per 02_CODING_STANDARDS.md Section 7
  Future<Result<void, AppError>> queue(QueuedNotification notification) async {
    try {
      await _queuedNotificationsTable.insert(notification);
      return Success(null);
    } catch (e, stack) {
      return Failure(DatabaseError.insertFailed('queued_notifications', e, stack));
    }
  }

  /// Process queue when quiet hours end
  /// Returns Result per 02_CODING_STANDARDS.md Section 7
  Future<Result<int, AppError>> processQueue() async {
    try {
      final queued = await _queuedNotificationsTable.getAll();

      // Sort by original scheduled time (oldest first)
      queued.sort((a, b) => a.originalScheduledTime.compareTo(b.originalScheduledTime));

      // Collapse duplicates of same type within 15 minutes
      final collapsed = _collapseDuplicates(queued);

      // Discard stale notifications (> 24 hours old)
      final fresh = collapsed.where((n) =>
        DateTime.now().millisecondsSinceEpoch - n.originalScheduledTime < 24 * 60 * 60 * 1000
      ).toList();

      // Deliver with 2-second spacing to avoid flood
      for (final notification in fresh) {
        await _notificationService.showNow(notification);
        await Future.delayed(Duration(seconds: 2));
      }

      await _queuedNotificationsTable.deleteAll();
      return Success(fresh.length);  // Return count of processed notifications
    } catch (e, stack) {
      return Failure(NotificationError.scheduleFailed('processQueue', e, stack));
    }
  }

  List<QueuedNotification> _collapseDuplicates(List<QueuedNotification> queue) {
    final Map<NotificationType, List<QueuedNotification>> byType = {};
    for (final n in queue) {
      byType.putIfAbsent(n.type, () => []).add(n);
    }

    final result = <QueuedNotification>[];
    for (final entry in byType.entries) {
      if (entry.value.length == 1) {
        result.add(entry.value.first);
      } else {
        // Create summary notification
        result.add(QueuedNotification(
          id: 'collapsed_${entry.key.name}',
          clientId: entry.value.first.clientId,
          profileId: entry.value.first.profileId,
          type: entry.key,
          originalScheduledTime: entry.value.first.originalScheduledTime,
          queuedAt: DateTime.now().millisecondsSinceEpoch,
          payload: {
            'collapsed': true,
            'count': entry.value.length,
            'originalIds': entry.value.map((n) => n.id).toList(),
          },
        ));










      }
    }
    return result;
  }
}
```

### 12.5 Sync Reminder Threshold

**When to trigger sync reminder (NotificationType.syncReminder):**

```dart
class SyncReminderService {
  /// Threshold for triggering sync reminder
  static const int syncReminderDays = 7;

  /// Check if sync reminder should be shown
  /// Uses epoch ms arithmetic per 02_CODING_STANDARDS.md (no DateTime in domain)
  bool shouldShowSyncReminder(String profileId) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    final int? lastSyncTime = getLastSyncTime(profileId);  // Epoch ms or null
    if (lastSyncTime == null) {
      // Never synced - remind after 24 hours of app usage
      final int? firstUse = getFirstUseTime(profileId);    // Epoch ms or null
      if (firstUse == null) return false;
      return now - firstUse >= 24 * 60 * 60 * 1000;
    }

    // Remind if not synced in 7+ days
    return now - lastSyncTime >= syncReminderDays * 24 * 60 * 60 * 1000;
  }











  /// Default message
  String getMessage(int daysSinceSync) {
    if (daysSinceSync == 0) {
      return "Your data hasn't been backed up yet";
    }
    return "Your data hasn't synced in $daysSinceSync days";
  }
}
```

### 12.6 Meal Auto-Detection Boundaries

**For smart meal reminder (future feature):**

| Meal | Start Time | End Time | Trigger After |
|------|------------|----------|---------------|
| Breakfast | 5:00 AM | 10:30 AM | 30 min after expected end |
| Lunch | 11:00 AM | 2:30 PM | 30 min after expected end |
| Dinner | 5:00 PM | 9:00 PM | 30 min after expected end |
| Snacks | N/A | N/A | Never auto-detected |

**Trigger Conditions:**
- Expected meal time window has passed
- No FoodLog exists for that meal period
- User has meal reminders enabled for that meal type

### 12.7 Archive Impact on Compliance

**Archived items and compliance calculations:**

```dart
/// Archived supplements/diets do NOT affect compliance
/// They are excluded from all calculations
bool shouldIncludeInCompliance(Supplement supplement) {
  return !supplement.isArchived && supplement.syncMetadata.syncDeletedAt == null;
}

bool shouldIncludeInCompliance(Diet diet) {
  return diet.isActive && diet.syncMetadata.syncDeletedAt == null;
}
```

### 12.8 Default Values and Constraints

**Entity Defaults:**

| Entity | Field | Default Value | Notes |
|--------|-------|---------------|-------|
| Supplement | isArchived | false | Active by default |
| Diet | isActive | true | Active when created |
| NotificationSchedule | isEnabled | true | Enabled by default |
| Profile | dietType | ProfileDietType.none | No diet restriction |
| SyncMetadata | syncStatus | SyncStatus.pending | Never synced |
| SyncMetadata | syncVersion | 1 | First version |
| SyncMetadata | syncIsDirty | true | Needs sync |

**Numeric Constraints:**

| Field | Min | Max | Unit |
|-------|-----|-----|------|
| severity | 1 | 10 | integer |
| waterIntakeMl | 0 | 10000 | milliliters |
| basalBodyTemperature | 95.0 | 105.0 | Fahrenheit |
| timesMinutesFromMidnight | 0 | 1439 | minutes |
| weekdays (each value) | 0 | 6 | 0=Monday, 6=Sunday |
| snoozeMinutes | 1 | 480 | minutes (8 hours max) |
| offsetMinutes | -1440 | 1440 | minutes (±24 hours) |

### 12.9 Timezone Handling

**All timestamps are stored as:**
- Epoch milliseconds (int) in UTC
- Converted to local timezone for display only

**Day boundaries for compliance:**
- Determined by device's local timezone at time of query
- A "day" is midnight-to-midnight local time
- FoodLogs are attributed to the day they were logged, not the day they occurred

**Example:**
```dart
/// Get logs for a specific local date
/// Note: date parameter is epoch ms representing start of day in local timezone
Future<Result<List<FoodLog>, AppError>> getLogsForDate(String profileId, int date) {  // Epoch ms
  // Calculate end of day (24 hours later)
  final endOfDay = date + (24 * 60 * 60 * 1000);  // +24 hours in ms

  // IMPORTANT: Always include sync_deleted_at IS NULL for soft delete filtering
  return query(
    'SELECT * FROM food_logs WHERE profile_id = ? AND timestamp >= ? AND timestamp < ? AND sync_deleted_at IS NULL',
    [profileId, date, endOfDay],
  );
}
```

### 12.10 Stepper Constraints

**For numeric input steppers in UI:**

| Field | Step | Min | Max |
|-------|------|-----|-----|
| Water intake (oz) | 1 | 1 | 128 |
| Water intake (mL) | 10 | 10 | 3785 |
| Temperature (°F) | 0.1 | 95.0 | 105.0 |
| Temperature (°C) | 0.05 | 35.0 | 40.6 |
| Severity | 1 | 1 | 10 |
| Duration (minutes) | 5 | 5 | 480 |
| Quantity | 1 | 1 | 100 |

---

## 13. Entity-Database Alignment Reference

This section documents the exact mapping between Dart entity fields and SQLite database columns.

### 13.1 Type Mapping Rules

**CRITICAL: All entities MUST follow these type mappings:**

| Entity Type | Database Type | Notes |
|-------------|---------------|-------|
| String | TEXT | Direct mapping |
| int | INTEGER | Direct mapping |
| double | REAL | Direct mapping |
| bool | INTEGER | 0=false, 1=true |
| DateTime | **NOT ALLOWED** | Use int (epoch ms) instead |
| TimeOfDay | **NOT ALLOWED** | Use int (minutes from midnight) instead |
| List<String> | TEXT | JSON array or comma-separated |
| List<T> (enum) | TEXT | Comma-separated int values |
| Enum | INTEGER | Enum's .value property |
| SyncMetadata | 9 columns | See SyncMetadata mapping below |

### 13.2 Supplement Entity ↔ supplements Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | Direct |
| name | name | String | TEXT | Direct |
| form | form | SupplementForm | INTEGER | .value |
| customForm | custom_form | String? | TEXT | Direct |
| dosageQuantity | dosage_quantity | int | INTEGER | Direct |
| dosageUnit | dosage_unit | DosageUnit | INTEGER | .value |
| brand | brand | String | TEXT | Direct (default: '') |
| notes | notes | String | TEXT | Direct (default: '') |
| ingredients | ingredients | List\<SupplementIngredient\> | TEXT | JSON array |
| schedules | schedules | List\<SupplementSchedule\> | TEXT | JSON array |
| startDate | start_date | int? | INTEGER | Epoch ms |
| endDate | end_date | int? | INTEGER | Epoch ms |
| isArchived | is_archived | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See below |

**Notes:**
- `ingredients` stores `List<SupplementIngredient>` as a JSON array in DB
- `schedules` stores `List<SupplementSchedule>` as a JSON array in DB
- The primary schedule may also have flattened DB columns (`anchor_events`, `timing_type`, `offset_minutes`, `specific_time_minutes`, `frequency_type`, `every_x_days`, `weekdays`) per 10_DATABASE_SCHEMA.md

### 13.3 FluidsEntry Entity ↔ fluids_entries Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | Direct |
| entryDate | entry_date | int | INTEGER | Epoch ms |
| waterIntakeMl | water_intake_ml | int? | INTEGER | Direct |
| waterIntakeNotes | water_intake_notes | String? | TEXT | Direct |
| (computed) hasBowelData | has_bowel_movement | bool | INTEGER | bowelCondition != null |
| bowelCondition | bowel_condition | BowelCondition? | INTEGER | .value |
| bowelSize | bowel_size | MovementSize? | INTEGER | .value |
| bowelPhotoPath | bowel_photo_path | String? | TEXT | Direct |
| (computed) hasUrineData | has_urine_movement | bool | INTEGER | urineCondition != null |
| urineCondition | urine_condition | UrineCondition? | INTEGER | .value |
| urineSize | urine_size | MovementSize? | INTEGER | .value |
| urinePhotoPath | urine_photo_path | String? | TEXT | Direct |
| menstruationFlow | menstruation_flow | MenstruationFlow? | INTEGER | .value |
| basalBodyTemperature | basal_body_temperature | double? | REAL | Direct (°F) |
| bbtRecordedTime | bbt_recorded_time | int? | INTEGER | Epoch ms |
| otherFluidName | other_fluid_name | String? | TEXT | Direct |
| otherFluidAmount | other_fluid_amount | String? | TEXT | Direct |
| otherFluidNotes | other_fluid_notes | String? | TEXT | Direct |
| importSource | import_source | String? | TEXT | Direct |
| importExternalId | import_external_id | String? | TEXT | Direct |
| cloudStorageUrl | cloud_storage_url | String? | TEXT | File sync |
| fileHash | file_hash | String? | TEXT | SHA-256 hash |
| fileSizeBytes | file_size_bytes | int? | INTEGER | Direct |
| isFileUploaded | is_file_uploaded | bool | INTEGER | 0/1 |
| notes | notes | String | TEXT | Direct (default: '') |
| photoIds | photo_ids | List\<String\> | TEXT | JSON array (default: []) |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See below |

**Notes:**
- `entryDate` in entity maps to `entry_date` column in DB
- `hasBowelData` and `hasUrineData` are computed getters in entity, stored as `has_bowel_movement`/`has_urine_movement` in DB
- `bowelCustomCondition` and `urineCustomCondition` DB columns exist for "custom" enum values but are not in current entity
- File sync fields are for bowel/urine photo uploads
- `notes` and `photoIds` are general fields for the entire fluids entry

### 13.4 Diet Entity ↔ diets Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | Direct |
| name | name | String | TEXT | Direct |
| presetType | preset_type | DietPresetType? | INTEGER | .value |
| startDate | start_date | int? | INTEGER | Epoch ms |
| endDate | end_date | int? | INTEGER | Epoch ms |
| isActive | is_active | bool | INTEGER | 0/1 |
| eatingWindowStartMinutes | eating_window_start | int? | INTEGER | Minutes from midnight |
| eatingWindowEndMinutes | eating_window_end | int? | INTEGER | Minutes from midnight |
| notes | notes | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See below |

**Notes:**
- `rules` field on the Diet entity (`List<DietRule>`) is NOT stored in the `diets` table. Rules are stored in the separate `diet_rules` table with `diet_id` FK, and populated via a join query in the repository layer.

### 13.5 DietRule Entity ↔ diet_rules Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| dietId | diet_id | String | TEXT | FK to diets |
| type | rule_type | DietRuleType | INTEGER | .value |
| severity | severity | RuleSeverity | INTEGER | .value |
| category | category | FoodCategory? | INTEGER | .value |
| ingredientName | ingredient_name | String? | TEXT | Direct |
| numericValue | numeric_value | double? | REAL | Direct |
| timeValue | time_value | TimeOfDay? | INTEGER | Minutes from midnight |
| daysOfWeek | days_of_week | List<int>? | TEXT | Comma-separated 0-6 |
| description | description | String? | TEXT | Direct |
| violationMessage | violation_message | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See below |

**Notes:**
- `timeValue` is a Flutter `TimeOfDay` in entity, stored as INTEGER minutes from midnight in DB
- `daysOfWeek` is `List<int>` in entity (0=Monday to 6=Sunday), stored as comma-separated TEXT in DB

### 13.6 DietViolation Entity ↔ diet_violations Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | Direct |
| dietId | diet_id | String | TEXT | FK to diets |
| foodLogId | food_log_id | String | TEXT | FK to food_logs |
| ruleId | rule_id | String? | TEXT | FK to diet_rules |
| ruleType | rule_type | DietRuleType | INTEGER | .value |
| severity | severity | RuleSeverity | INTEGER | .value |
| message | message | String | TEXT | Direct |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| wasDismissed | was_dismissed | bool | INTEGER | 0/1 (default: 0) |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See below |

### 13.7 SyncMetadata Column Mapping

**ALL entities with SyncMetadata use these columns:**

| Entity Field | DB Column | Type |
|--------------|-----------|------|
| syncCreatedAt | sync_created_at | INTEGER (epoch ms) |
| syncUpdatedAt | sync_updated_at | INTEGER (epoch ms, nullable) |
| syncDeletedAt | sync_deleted_at | INTEGER (epoch ms, nullable) |
| syncLastSyncedAt | sync_last_synced_at | INTEGER (epoch ms, nullable) |
| syncStatus | sync_status | INTEGER (SyncStatus.value) |
| syncVersion | sync_version | INTEGER (default 1) |
| syncDeviceId | sync_device_id | TEXT (nullable) |
| syncIsDirty | sync_is_dirty | INTEGER (0/1, default 1) |
| conflictData | conflict_data | TEXT (JSON, nullable) |

### 13.8 UserAccount Entity ↔ user_accounts Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| email | email | String | TEXT | Direct |
| displayName | display_name | String | TEXT | Direct |
| role | role | String | TEXT | 'counselor' \| 'client' \| 'admin' |
| authProvider | auth_provider | String | TEXT | 'google' \| 'apple' |
| externalId | external_id | String | TEXT | OAuth provider ID |
| createdAt | created_at | int | INTEGER | Epoch ms |
| lastLoginAt | last_login_at | int? | INTEGER | Epoch ms |
| isActive | is_active | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.9 Profile Entity ↔ profiles Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| name | name | String | TEXT | Direct |
| birthDate | birth_date | int? | INTEGER | Epoch ms |
| biologicalSex | biological_sex | BiologicalSex? | INTEGER | .value |
| ethnicity | ethnicity | String? | TEXT | Direct |
| notes | notes | String? | TEXT | Direct |
| ownerId | owner_id | String? | TEXT | FK to user_accounts |
| dietType | diet_type | ProfileDietType | INTEGER | .value (default: none) |
| dietDescription | diet_description | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.10 ProfileAccess Entity ↔ profile_access Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| userId | user_id | String | TEXT | FK to user_accounts |
| accessLevel | access_level | AccessLevel | TEXT | 'read_only' \| 'read_write' \| 'owner' |
| grantedAt | granted_at | int | INTEGER | Epoch ms |
| expiresAt | expires_at | int? | INTEGER | Epoch ms |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.11 DeviceRegistration Entity ↔ device_registrations Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| userAccountId | user_account_id | String | TEXT | FK to user_accounts |
| deviceId | device_id | String | TEXT | Unique device identifier |
| deviceName | device_name | String | TEXT | User-friendly name |
| deviceType | device_type | DeviceType | INTEGER | .value (0=iOS, 1=android, 2=macOS, 3=web) |
| osVersion | os_version | String? | TEXT | e.g., "iOS 17.2" |
| appVersion | app_version | String? | TEXT | e.g., "1.2.3" |
| registeredAt | registered_at | int | INTEGER | Epoch ms |
| lastSeenAt | last_seen_at | int | INTEGER | Epoch ms |
| isActive | is_active | bool | INTEGER | 0/1 |
| pushToken | push_token | String? | TEXT | FCM/APNs token |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

**Notes:**
- `deviceType` is an enum in entity, stored as INTEGER .value in DB
- Entity field `userAccountId` matches DB column `user_account_id`

### 13.12 IntakeLog Entity ↔ intake_logs Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| supplementId | supplement_id | String | TEXT | FK to supplements |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| intakeTime | intake_time | IntakeTime | INTEGER | .value (0-3) |
| dosageAmount | dosage_amount | double? | REAL | Direct |
| notes | notes | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.13 FoodItem Entity ↔ food_items Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| name | name | String | TEXT | Direct |
| type | type | FoodItemType | INTEGER | .value (0=simple, 1=complex) |
| simpleItemIds | simple_item_ids | List<String> | TEXT | Comma-separated IDs |
| isUserCreated | is_user_created | bool | INTEGER | 0/1 |
| isArchived | is_archived | bool | INTEGER | 0/1 |
| servingSize | serving_size | String? | TEXT | Direct (e.g., "1 cup", "100g") |
| calories | calories | double? | REAL | Direct |
| carbsGrams | carbs_grams | double? | REAL | Direct |
| fatGrams | fat_grams | double? | REAL | Direct |
| proteinGrams | protein_grams | double? | REAL | Direct |
| fiberGrams | fiber_grams | double? | REAL | Direct |
| sugarGrams | sugar_grams | double? | REAL | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.14 FoodLog Entity ↔ food_logs Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| mealType | meal_type | MealType? | INTEGER | .value (0=breakfast, 1=lunch, 2=dinner, 3=snack) |
| foodItemIds | food_item_ids | List<String> | TEXT | Comma-separated IDs |
| adHocItems | ad_hoc_items | List<String> | TEXT | Comma-separated names |
| notes | notes | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.15 Activity Entity ↔ activities Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| name | name | String | TEXT | Direct |
| description | description | String? | TEXT | Direct |
| location | location | String? | TEXT | Direct |
| triggers | triggers | String? | TEXT | Comma-separated trigger descriptions |
| durationMinutes | duration_minutes | int | INTEGER | Direct |
| isArchived | is_archived | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.16 ActivityLog Entity ↔ activity_logs Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| activityIds | activity_ids | List<String> | TEXT | Comma-separated IDs |
| adHocActivities | ad_hoc_activities | List<String> | TEXT | Comma-separated names |
| duration | duration | int? | INTEGER | Actual duration in minutes |
| notes | notes | String? | TEXT | Direct |
| importSource | import_source | String? | TEXT | 'healthkit', 'googlefit', etc. |
| importExternalId | import_external_id | String? | TEXT | External record ID |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.17 SleepEntry Entity ↔ sleep_entries Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| bedTime | bed_time | int | INTEGER | Epoch ms |
| wakeTime | wake_time | int? | INTEGER | Epoch ms |
| deepSleepMinutes | deep_sleep_minutes | int | INTEGER | Default 0 |
| lightSleepMinutes | light_sleep_minutes | int | INTEGER | Default 0 |
| restlessSleepMinutes | restless_sleep_minutes | int | INTEGER | Default 0 |
| dreamType | dream_type | DreamType | INTEGER | .value (0=noDreams, 1=vague, 2=vivid, 3=nightmares) |
| wakingFeeling | waking_feeling | WakingFeeling | INTEGER | .value (0=unrested, 1=neutral, 2=rested) |
| notes | notes | String? | TEXT | Direct |
| importSource | import_source | String? | TEXT | 'healthkit', 'googlefit', etc. |
| importExternalId | import_external_id | String? | TEXT | External record ID |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.18 JournalEntry Entity ↔ journal_entries Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| content | content | String | TEXT | Direct |
| title | title | String? | TEXT | Direct |
| tags | tags | List<String>? | TEXT | Comma-separated tags |
| mood | mood | int? | INTEGER | 1-10 rating |
| audioUrl | audio_url | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.19 Document Entity ↔ documents Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| name | name | String | TEXT | Direct |
| documentType | document_type | DocumentType | INTEGER | .value (0=medical, 1=prescription, 2=lab, 3=other) |
| filePath | file_path | String | TEXT | Direct |
| notes | notes | String? | TEXT | Direct |
| documentDate | document_date | int? | INTEGER | Epoch ms - date of document |
| uploadedAt | uploaded_at | int | INTEGER | Epoch ms - when uploaded |
| cloudStorageUrl | cloud_storage_url | String? | TEXT | File sync |
| fileHash | file_hash | String? | TEXT | SHA-256 hash |
| fileSizeBytes | file_size_bytes | int? | INTEGER | Direct |
| mimeType | mime_type | String? | TEXT | Direct |
| isFileUploaded | is_file_uploaded | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.20 Condition Entity ↔ conditions Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| name | name | String | TEXT | Direct |
| category | category | String | TEXT | Direct |
| bodyLocations | body_locations | List<String> | TEXT | JSON array |
| triggers | triggers | List<String> | TEXT | JSON array |
| description | description | String? | TEXT | Direct |
| baselinePhotoPath | baseline_photo_path | String? | TEXT | Direct |
| startTimeframe | start_timeframe | int | INTEGER | Epoch ms |
| endDate | end_date | int? | INTEGER | Epoch ms |
| status | status | ConditionStatus | INTEGER | .value (0=active, 1=resolved) |
| isArchived | is_archived | bool | INTEGER | 0/1 |
| activityId | activity_id | String? | TEXT | FK to activities |
| cloudStorageUrl | cloud_storage_url | String? | TEXT | File sync |
| fileHash | file_hash | String? | TEXT | SHA-256 hash |
| fileSizeBytes | file_size_bytes | int? | INTEGER | Direct |
| isFileUploaded | is_file_uploaded | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.21 ConditionLog Entity ↔ condition_logs Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| conditionId | condition_id | String | TEXT | FK to conditions |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| severity | severity | int | INTEGER | 1-10 scale |
| notes | notes | String? | TEXT | Direct |
| isFlare | is_flare | bool | INTEGER | 0/1 |
| flarePhotoIds | flare_photo_ids | List<String> | TEXT | Comma-separated IDs |
| photoPath | photo_path | String? | TEXT | Direct |
| activityId | activity_id | String? | TEXT | FK to activities |
| triggers | triggers | String? | TEXT | Comma-separated |
| cloudStorageUrl | cloud_storage_url | String? | TEXT | File sync |
| fileHash | file_hash | String? | TEXT | SHA-256 hash |
| fileSizeBytes | file_size_bytes | int? | INTEGER | Direct |
| isFileUploaded | is_file_uploaded | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.22 FlareUp Entity ↔ flare_ups Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| conditionId | condition_id | String | TEXT | FK to conditions |
| startDate | start_date | int | INTEGER | Epoch ms - flare-up start |
| endDate | end_date | int? | INTEGER | Epoch ms - flare-up end (null = ongoing) |
| severity | severity | int | INTEGER | 1-10 scale |
| notes | notes | String? | TEXT | Direct |
| triggers | triggers | List<String> | TEXT | JSON array |
| activityId | activity_id | String? | TEXT | FK to activities |
| photoPath | photo_path | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.23 ConditionCategory Entity ↔ condition_categories Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| name | name | String | TEXT | Direct |
| description | description | String? | TEXT | Direct |
| iconName | icon_name | String? | TEXT | Direct |
| colorValue | color_value | int? | INTEGER | Direct |
| sortOrder | sort_order | int | INTEGER | Direct (default: 0) |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.24 PhotoArea Entity ↔ photo_areas Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| name | name | String | TEXT | Direct |
| description | description | String? | TEXT | Area description |
| consistencyNotes | consistency_notes | String? | TEXT | Guidance for consistent photo positioning |
| sortOrder | sort_order | int | INTEGER | Default 0 |
| isArchived | is_archived | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.25 PhotoEntry Entity ↔ photo_entries Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| photoAreaId | photo_area_id | String | TEXT | FK to photo_areas |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| filePath | file_path | String | TEXT | Direct |
| notes | notes | String? | TEXT | Direct |
| cloudStorageUrl | cloud_storage_url | String? | TEXT | File sync |
| fileHash | file_hash | String? | TEXT | SHA-256 hash |
| fileSizeBytes | file_size_bytes | int? | INTEGER | Direct |
| isFileUploaded | is_file_uploaded | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.26 NotificationSchedule Entity ↔ notification_schedules Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| type | type | NotificationType | INTEGER | .value (0-24) |
| entityId | entity_id | String? | TEXT | FK to linked entity |
| timesMinutesFromMidnight | times_minutes | List<int> | TEXT | JSON array [480, 720] |
| weekdays | weekdays | List<int> | TEXT | JSON array [0-6] |
| isEnabled | is_enabled | bool | INTEGER | 0/1 |
| customMessage | custom_message | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.27 FoodItemCategory (Junction) ↔ food_item_categories Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| foodItemId | food_item_id | String | TEXT | FK to food_items (PK) |
| category | category | FoodCategory | INTEGER | .value (enum index) (PK) |

**Note:** This is a junction table with composite primary key; no sync metadata.

### 13.28 UserFoodCategory Entity ↔ user_food_categories Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| name | name | String | TEXT | Direct |
| parentCategory | parent_category | FoodCategory? | INTEGER | .value |
| isUserDefined | is_user_defined | bool | INTEGER | Always 1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.29 Pattern Entity ↔ patterns Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| type | pattern_type | PatternType | INTEGER | .value (0=temporal, 1=cyclical, 2=sequential, 3=cluster, 4=dosage) |
| entityType | entity_type | String | TEXT | Direct |
| entityId | entity_id | String? | TEXT | Direct |
| data | data_json | Map<String, dynamic> | TEXT | JSON encoded |
| confidence | confidence | double | REAL | 0.0-1.0 |
| sampleSize | sample_size | int | INTEGER | Direct |
| observationCount | observation_count | int | INTEGER | Direct |
| lastObservedAt | last_observed_at | int? | INTEGER | Epoch ms |
| detectedAt | detected_at | int | INTEGER | Epoch ms |
| dataRangeStart | data_range_start | int | INTEGER | Epoch ms |
| dataRangeEnd | data_range_end | int | INTEGER | Epoch ms |
| isActive | is_active | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.30 TriggerCorrelation Entity ↔ trigger_correlations Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| triggerId | trigger_id | String | TEXT | Direct |
| triggerType | trigger_type | String | TEXT | Direct |
| triggerName | trigger_name | String | TEXT | Direct |
| outcomeId | outcome_id | String | TEXT | Direct |
| outcomeType | outcome_type | String | TEXT | Direct |
| outcomeName | outcome_name | String | TEXT | Direct |
| correlationType | correlation_type | CorrelationType | INTEGER | .value (0=positive, 1=negative, 2=neutral, 3=dose-response) |
| relativeRisk | relative_risk | double | REAL | Direct |
| confidenceIntervalLow | ci_low | double | REAL | Direct |
| confidenceIntervalHigh | ci_high | double | REAL | Direct |
| pValue | p_value | double | REAL | Direct |
| triggerExposures | trigger_exposures | int | INTEGER | Direct |
| outcomeOccurrences | outcome_occurrences | int | INTEGER | Direct |
| cooccurrences | cooccurrences | int | INTEGER | Direct |
| timeWindowHours | time_window_hours | int | INTEGER | Direct |
| averageLatencyHours | average_latency_hours | double | REAL | Direct |
| confidence | confidence | double | REAL | 0.0-1.0 |
| detectedAt | detected_at | int | INTEGER | Epoch ms |
| dataRangeStart | data_range_start | int | INTEGER | Epoch ms |
| dataRangeEnd | data_range_end | int | INTEGER | Epoch ms |
| doseResponseEquation | dose_response_equation | String? | TEXT | Direct |
| isActive | is_active | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.31 HealthInsight Entity ↔ health_insights Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| category | category | InsightCategory | INTEGER | .value (0-8) |
| priority | priority | AlertPriority | INTEGER | .value (0=high, 1=medium, 2=low) |
| title | title | String | TEXT | Direct |
| description | description | String | TEXT | Direct |
| recommendation | recommendation | String? | TEXT | Direct |
| evidence | evidence_json | List<InsightEvidence> | TEXT | JSON encoded |
| generatedAt | generated_at | int | INTEGER | Epoch ms |
| expiresAt | expires_at | int? | INTEGER | Epoch ms |
| isDismissed | is_dismissed | bool | INTEGER | 0/1 |
| dismissedAt | dismissed_at | int? | INTEGER | Epoch ms |
| relatedEntityType | related_entity_type | String? | TEXT | Direct |
| relatedEntityId | related_entity_id | String? | TEXT | Direct |
| insightKey | insight_key | String? | TEXT | De-duplication key |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.32 PredictiveAlert Entity ↔ predictive_alerts Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| type | prediction_type | PredictionType | INTEGER | .value (0-5) |
| title | title | String | TEXT | Direct |
| description | description | String | TEXT | Direct |
| probability | probability | double | REAL | 0.0-1.0 |
| predictedEventTime | predicted_event_time | int | INTEGER | Epoch ms |
| alertGeneratedAt | alert_generated_at | int | INTEGER | Epoch ms |
| factors | factors_json | List<PredictionFactor> | TEXT | JSON encoded |
| preventiveAction | preventive_action | String? | TEXT | Direct |
| isAcknowledged | is_acknowledged | bool | INTEGER | 0/1 |
| acknowledgedAt | acknowledged_at | int? | INTEGER | Epoch ms |
| eventOccurred | event_occurred | bool? | INTEGER | NULL, 0, or 1 |
| eventOccurredAt | event_occurred_at | int? | INTEGER | Epoch ms |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.33 MLModel Entity ↔ ml_models Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| modelType | model_type | MLModelType | INTEGER | .value (0=flareUpPrediction, 1=menstrualCyclePrediction, 2=triggerDetection, 3=sleepQualityPrediction) |
| modelVersion | model_version | String | TEXT | Direct |
| trainedAt | trained_at | int | INTEGER | Epoch ms |
| dataPointsUsed | data_points_used | int | INTEGER | Direct |
| accuracy | accuracy | double | REAL | 0.0-1.0 |
| precision | precision | double | REAL | 0.0-1.0 |
| recall | recall | double | REAL | 0.0-1.0 |
| modelSizeBytes | model_size_bytes | int | INTEGER | Direct |
| modelPath | model_path | String | TEXT | Local file path to TFLite model |
| trainingNotes | training_notes | String? | TEXT | Direct |
| createdAt | created_at | int | INTEGER | Epoch ms |
| updatedAt | updated_at | int | INTEGER | Epoch ms |

**Notes:**
- Local-only entity - does NOT sync to cloud (privacy-first ML)
- Uses `createdAt`/`updatedAt` instead of `syncMetadata` per 02_CODING_STANDARDS.md Section 8.2.1 exemption
- Computed property: `f1Score` = 2 * (precision * recall) / (precision + recall)

### 13.34 PredictionFeedback Entity ↔ prediction_feedback Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| predictiveAlertId | predictive_alert_id | String | TEXT | FK to predictive_alerts |
| predictionType | prediction_type | PredictionType | INTEGER | .value |
| predictedProbability | predicted_probability | double | REAL | 0.0-1.0 |
| predictedEventTime | predicted_event_time | int | INTEGER | Epoch ms |
| eventOccurred | event_occurred | bool | INTEGER | 0/1 |
| actualEventTime | actual_event_time | int? | INTEGER | Epoch ms |
| feedbackRecordedAt | feedback_recorded_at | int | INTEGER | Epoch ms |
| userNotes | user_notes | String? | TEXT | Direct |
| usedForRetraining | used_for_retraining | bool | INTEGER | 0/1 (default: 0) |
| createdAt | created_at | int | INTEGER | Epoch ms |
| updatedAt | updated_at | int | INTEGER | Epoch ms |

**Notes:**
- Local-only entity - used to improve ML models
- Uses `createdAt`/`updatedAt` instead of `syncMetadata` per 02_CODING_STANDARDS.md Section 8.2.1 exemption
- Computed properties: `wasCorrect`, `timingError`

### 13.35 WearableConnection Entity ↔ wearable_connections Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| platform | platform | String | TEXT | 'healthkit', 'googlefit', 'fitbit', 'garmin', 'oura', 'whoop' |
| isConnected | is_connected | bool | INTEGER | 0/1 |
| connectedAt | connected_at | int? | INTEGER | Epoch ms |
| disconnectedAt | disconnected_at | int? | INTEGER | Epoch ms |
| readPermissions | read_permissions | List<String>? | TEXT | JSON array |
| writePermissions | write_permissions | List<String>? | TEXT | JSON array |
| backgroundSyncEnabled | background_sync_enabled | bool | INTEGER | 0/1 |
| lastSyncAt | last_sync_at | int? | INTEGER | Epoch ms |
| lastSyncStatus | last_sync_status | String? | TEXT | Direct |
| oauthRefreshToken | oauth_refresh_token | String? | TEXT | Encrypted |
| lastSyncError | last_sync_error | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.36 ImportedDataLog Entity ↔ imported_data_log Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| sourcePlatform | source_platform | WearablePlatform | INTEGER | .value |
| sourceRecordId | source_record_id | String | TEXT | External record ID |
| targetEntityType | target_entity_type | String | TEXT | Target entity type |
| targetEntityId | target_entity_id | String | TEXT | FK to target entity |
| importedAt | imported_at | int | INTEGER | Epoch ms |
| sourceTimestamp | source_timestamp | int | INTEGER | Original data timestamp (Epoch ms) |
| rawData | raw_data | String? | TEXT | JSON of original record |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.37 FhirExport Entity ↔ fhir_exports Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| fhirVersion | fhir_version | String | TEXT | e.g., 'R4' |
| exportFormat | export_format | String | TEXT | 'json' or 'xml' |
| resourceTypes | resource_types | List<String> | TEXT | JSON array |
| exportedAt | exported_at | int | INTEGER | Epoch ms |
| dataRangeStart | data_range_start | int | INTEGER | Epoch ms |
| dataRangeEnd | data_range_end | int | INTEGER | Epoch ms |
| recordCount | record_count | int | INTEGER | Direct |
| fileSizeBytes | file_size_bytes | int | INTEGER | Direct |
| fileHash | file_hash | String? | TEXT | SHA-256 hash |
| cloudStorageUrl | cloud_storage_url | String? | TEXT | File sync |
| createdAt | created_at | int | INTEGER | Epoch ms |
| updatedAt | updated_at | int | INTEGER | Epoch ms |

**Notes:**
- Uses `createdAt`/`updatedAt` instead of `syncMetadata` per 02_CODING_STANDARDS.md Section 8.2.1 exemption
- Local export history - does not sync to cloud

### 13.38 HipaaAuthorization Entity ↔ hipaa_authorizations Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| grantedToUserId | granted_to_user_id | String | TEXT | FK to user_accounts |
| grantedByUserId | granted_by_user_id | String | TEXT | FK to user_accounts |
| scopes | scopes | List<DataScope> | TEXT | JSON array |
| purpose | purpose | String | TEXT | Direct |
| duration | duration | AuthorizationDuration | INTEGER | .value (0-4) |
| authorizedAt | authorized_at | int | INTEGER | Epoch ms |
| expiresAt | expires_at | int? | INTEGER | Epoch ms |
| revokedAt | revoked_at | int? | INTEGER | Epoch ms |
| revokedReason | revoked_reason | String? | TEXT | Direct |
| signatureDeviceId | signature_device_id | String | TEXT | Direct |
| signatureIpAddress | signature_ip_address | String | TEXT | Direct |
| photosIncluded | photos_included | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.39 ProfileAccessLog Entity ↔ profile_access_logs Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| authorizationId | authorization_id | String | TEXT | FK to hipaa_authorizations |
| profileId | profile_id | String | TEXT | FK to profiles |
| accessedByUserId | accessed_by_user_id | String | TEXT | FK to user_accounts |
| accessedByDeviceId | accessed_by_device_id | String | TEXT | Direct |
| action | action | ProfileAccessAction | INTEGER | .value (0=view, 1=export, 2=addEntry, 3=editEntry) |
| entityType | entity_type | String | TEXT | Direct |
| entityId | entity_id | String? | TEXT | Direct |
| accessedAt | accessed_at | int | INTEGER | Epoch ms |
| ipAddress | ip_address | String | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.40 AuditLogEntry Entity ↔ audit_logs Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| userId | user_id | String | TEXT | FK to user_accounts |
| profileId | profile_id | String | TEXT | FK to profiles |
| eventType | event_type | AuditEventType | INTEGER | Enum .value |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| deviceId | device_id | String | TEXT | Direct |
| entityType | entity_type | String? | TEXT | Direct |
| entityId | entity_id | String? | TEXT | Direct |
| ipAddress | ip_address | String? | TEXT | Direct |
| metadata | metadata | Map<String, dynamic>? | TEXT | JSON encoded |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

**Note:** Audit logs are immutable and append-only for HIPAA compliance.

### 13.41 BowelUrineLog Entity ↔ bowel_urine_logs Table (Legacy)

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| hasBowelMovement | has_bowel_movement | bool? | INTEGER | 0/1 |
| bowelCondition | bowel_condition | BristolScale? | INTEGER | .value |
| bowelCustomCondition | bowel_custom_condition | String? | TEXT | Direct |
| bowelSize | bowel_size | MovementSize? | INTEGER | .value |
| bowelPhotoPath | bowel_photo_path | String? | TEXT | Direct |
| hasUrineMovement | has_urine_movement | bool? | INTEGER | 0/1 |
| urineCondition | urine_condition | UrineColor? | INTEGER | .value |
| urineCustomCondition | urine_custom_condition | String? | TEXT | Direct |
| urineSize | urine_size | MovementSize? | INTEGER | .value |
| urinePhotoPath | urine_photo_path | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

**Note:** Legacy table for backward compatibility. New code should use FluidsEntry instead. This entity exists to support migration from v3 databases. Repository is read-only (`getAll`, `getCount`).

### 13.42 Complete Table Coverage Summary

| # | Table Name | Entity | Mapping Section |
|---|------------|--------|-----------------|
| 1 | user_accounts | UserAccount | 13.8 |
| 2 | profiles | Profile | 13.9 |
| 3 | profile_access | ProfileAccess | 13.10 |
| 4 | device_registrations | DeviceRegistration | 13.11 |
| 5 | supplements | Supplement | 13.2 |
| 6 | intake_logs | IntakeLog | 13.12 |
| 7 | food_items | FoodItem | 13.13 |
| 8 | food_logs | FoodLog | 13.14 |
| 9 | activities | Activity | 13.15 |
| 10 | activity_logs | ActivityLog | 13.16 |
| 11 | sleep_entries | SleepEntry | 13.17 |
| 12 | journal_entries | JournalEntry | 13.18 |
| 13 | documents | Document | 13.19 |
| 14 | conditions | Condition | 13.20 |
| 15 | condition_logs | ConditionLog | 13.21 |
| 16 | flare_ups | FlareUp | 13.22 |
| 17 | condition_categories | ConditionCategory | 13.23 |
| 18 | fluids_entries | FluidsEntry | 13.3 |
| 19 | bowel_urine_logs | BowelUrineLog | 13.41 (legacy) |
| 20 | photo_areas | PhotoArea | 13.24 |
| 21 | photo_entries | PhotoEntry | 13.25 |
| 22 | notification_schedules | NotificationSchedule | 13.26 |
| 23 | diets | Diet | 13.4 |
| 24 | diet_rules | DietRule | 13.5 |
| 25 | diet_violations | DietViolation | 13.6 |
| 26 | food_item_categories | (Junction) | 13.27 |
| 27 | user_food_categories | UserFoodCategory | 13.28 |
| 28 | patterns | Pattern | 13.29 |
| 29 | trigger_correlations | TriggerCorrelation | 13.30 |
| 30 | health_insights | HealthInsight | 13.31 |
| 31 | predictive_alerts | PredictiveAlert | 13.32 |
| 32 | ml_models | MLModel | 13.33 |
| 33 | prediction_feedback | PredictionFeedback | 13.34 |
| 34 | wearable_connections | WearableConnection | 13.35 |
| 35 | imported_data_log | ImportedDataLog | 13.36 |
| 36 | fhir_exports | FhirExport | 13.37 |
| 37 | hipaa_authorizations | HipaaAuthorization | 13.38 |
| 38 | profile_access_logs | ProfileAccessLog | 13.39 |
| 39 | audit_logs | AuditLogEntry | 13.40 |
| 40 | refresh_token_usage | (Security infrastructure) | 10_DATABASE_SCHEMA.md §15.1 |
| 41 | pairing_sessions | PairingSession | 35_QR_DEVICE_PAIRING.md — see that document for full @freezed definition |

**Note:** All 41 tables now have explicit documentation. Tables 1-39 are domain entities with full mappings. Tables 40-41 are security infrastructure tables documented in their respective specification documents.

---

## 14. Test Scenarios for Behavioral Specifications

### 14.1 Diet Compliance Calculation Tests

```dart
group('Diet Compliance Calculation', () {
  test('returns 100% when no food logs exist', () {
    final score = calculateDailyCompliance(profileId, dietId, today);
    expect(score, equals(100.0));
  });

  test('returns 100% when all meals are compliant', () {
    // Given: 3 meals logged, all compliant
    createFoodLog(breakfast, compliantFood);
    createFoodLog(lunch, compliantFood);
    createFoodLog(dinner, compliantFood);

    final score = calculateDailyCompliance(profileId, dietId, today);
    expect(score, equals(100.0));
  });

  test('returns 66.67% when 1 of 3 meals violates', () {
    createFoodLog(breakfast, compliantFood);
    createFoodLog(lunch, violatingFood);
    createFoodLog(dinner, compliantFood);

    final score = calculateDailyCompliance(profileId, dietId, today);
    expect(score, closeTo(66.67, 0.01));
  });

  test('returns 0% when all meals violate', () {
    createFoodLog(breakfast, violatingFood);
    createFoodLog(lunch, violatingFood);
    createFoodLog(dinner, violatingFood);

    final score = calculateDailyCompliance(profileId, dietId, today);
    expect(score, equals(0.0));
  });

  test('one meal with multiple violations counts as one violation', () {
    // Given: One meal with 3 violating items
    createFoodLog(lunch, [violatingFood1, violatingFood2, violatingFood3]);
    createFoodLog(dinner, compliantFood);

    final score = calculateDailyCompliance(profileId, dietId, today);
    expect(score, equals(50.0)); // 1 of 2 meals violated
  });
});
```

### 14.2 Quiet Hours Queuing Tests

```dart
group('Quiet Hours Queuing', () {
  test('queues notification during quiet hours when holdUntilEnd selected', () async {
    // Given: Quiet hours 10pm-7am, current time 11pm
    setQuietHours(22 * 60, 7 * 60, QuietHoursAction.holdUntilEnd);
    setCurrentTime(DateTime(2026, 1, 1, 23, 0));

    // When: Supplement notification scheduled for 11pm
    await scheduleNotification(supplementReminder);

    // Then: Notification is queued, not delivered
    expect(getDeliveredNotifications(), isEmpty);
    expect(getQueuedNotifications(), hasLength(1));
  });

  test('delivers queued notifications with 2-second spacing', () async {
    // Given: 3 queued notifications
    queueNotification(notification1);
    queueNotification(notification2);
    queueNotification(notification3);

    // When: Quiet hours end
    await endQuietHours();

    // Then: Notifications delivered with 2-second gaps
    expect(getDeliveryTimes()[0], anything);
    expect(getDeliveryTimes()[1].difference(getDeliveryTimes()[0]).inSeconds, equals(2));
    expect(getDeliveryTimes()[2].difference(getDeliveryTimes()[1]).inSeconds, equals(2));
  });

  test('collapses duplicate notifications of same type', () async {
    // Given: 5 water reminder notifications queued
    for (var i = 0; i < 5; i++) {
      queueNotification(waterReminder);
    }

    // When: Quiet hours end
    await endQuietHours();

    // Then: Only 1 collapsed notification delivered
    final delivered = getDeliveredNotifications();
    expect(delivered, hasLength(1));
    expect(delivered[0].payload['collapsed'], isTrue);
    expect(delivered[0].payload['count'], equals(5));
  });

  test('discards stale notifications older than 24 hours', () async {
    // Given: Notification queued 25 hours ago
    final now = DateTime.now().millisecondsSinceEpoch;
    final oldNotification = QueuedNotification(
      id: 'test-stale-notification',
      clientId: 'test-client-id',
      type: NotificationType.supplementIndividual,
      profileId: profileId,
      originalScheduledTime: now - (25 * 60 * 60 * 1000), // 25 hours ago, epoch ms
      queuedAt: now - (25 * 60 * 60 * 1000),
      payload: const {},
    );
    queueNotification(oldNotification);

    // When: Quiet hours end
    await endQuietHours();

    // Then: Notification is discarded
    expect(getDeliveredNotifications(), isEmpty);
  });
});
```

### 14.3 Snooze Behavior Tests

```dart
group('Notification Snooze Behavior', () {
  test('BBT morning notification cannot be snoozed', () {
    expect(NotificationType.bbtMorning.allowsSnooze, isFalse);
  });

  test('supplement notification can be snoozed for 15 minutes by default', () {
    expect(NotificationType.supplementIndividual.allowsSnooze, isTrue);
    expect(NotificationType.supplementIndividual.defaultSnoozeMinutes, equals(15));
  });

  test('snooze reschedules notification for specified duration', () async {
    final notification = await scheduleNotification(supplementReminder);

    await snoozeNotification(notification.id, minutes: 30);

    final rescheduled = await getScheduledNotification(notification.id);
    expect(
      rescheduled.scheduledTime.difference(notification.scheduledTime).inMinutes,
      equals(30),
    );
  });

  test('snooze limits: minimum 1 minute, maximum 480 minutes', () {
    expect(() => snoozeNotification(id, minutes: 0), throwsValidationError);
    expect(() => snoozeNotification(id, minutes: 481), throwsValidationError);
    expect(() => snoozeNotification(id, minutes: 480), returnsNormally);
  });
});
```

### 14.4 Fasting Window Tests

```dart
group('Intermittent Fasting Windows', () {
  test('16:8 fasting window detection', () {
    // Given: 16:8 diet with eating window 12pm-8pm
    final diet = createDiet(
      presetType: DietPresetType.if168,
      eatingWindowStartMinutes: 12 * 60, // 12:00 PM
      eatingWindowEndMinutes: 20 * 60,   // 8:00 PM
    );

    // At 11am: Outside eating window
    setCurrentTime(DateTime(2026, 1, 1, 11, 0));
    expect(isInEatingWindow(diet), isFalse);
    expect(isInFastingWindow(diet), isTrue);

    // At 12pm: Start of eating window
    setCurrentTime(DateTime(2026, 1, 1, 12, 0));
    expect(isInEatingWindow(diet), isTrue);

    // At 8:01pm: After eating window
    setCurrentTime(DateTime(2026, 1, 1, 20, 1));
    expect(isInEatingWindow(diet), isFalse);
  });

  test('logging food during fasting window creates violation', () {
    final diet = createIFDiet(eatingWindow: 12 * 60, 20 * 60);
    setCurrentTime(DateTime(2026, 1, 1, 10, 0)); // 10am, fasting

    final warning = checkPreLogCompliance(
      profileId: profileId,
      dietId: diet.id,
      foodItemId: anyFoodId,
    );

    expect(warning.violatesRules, isTrue);
    expect(warning.violatedRules.any((r) => r.ruleType == DietRuleType.timeRestriction), isTrue);
  });
});
```

### 14.5 Sync Reminder Tests

```dart
group('Sync Reminder Threshold', () {
  test('shows reminder after 7 days without sync', () {
    setLastSyncTime(DateTime.now().subtract(Duration(days: 7)));

    expect(shouldShowSyncReminder(profileId), isTrue);
  });

  test('does not show reminder if synced within 7 days', () {
    setLastSyncTime(DateTime.now().subtract(Duration(days: 6)));

    expect(shouldShowSyncReminder(profileId), isFalse);
  });

  test('shows reminder 24 hours after first use if never synced', () {
    setFirstUseTime(DateTime.now().subtract(Duration(hours: 25)));
    setLastSyncTime(null);

    expect(shouldShowSyncReminder(profileId), isTrue);
  });
});
```

### 14.6 Archive Impact Tests

```dart
group('Archive Impact on Compliance', () {
  test('archived supplements excluded from intake compliance', () {
    final supplement = createSupplement(name: 'Test');
    archiveSupplement(supplement.id);

    final pending = getPendingIntakeLogs(profileId);
    expect(pending.any((log) => log.supplementId == supplement.id), isFalse);
  });

  test('archived diets do not trigger violation warnings', () {
    final diet = createDiet(name: 'Test');
    activateDiet(diet.id);
    archiveDiet(diet.id);

    final warning = checkPreLogCompliance(
      profileId: profileId,
      dietId: diet.id,
      foodItemId: violatingFoodId,
    );

    expect(warning.violatesRules, isFalse);
  });
});
```

---

## 15. Edge Cases and Exceptions

This section documents all exceptions to standard patterns. Engineers MUST understand these exceptions to avoid incorrect implementations.

### 15.1 Sync Method Soft-Delete Exceptions

**Standard Rule:** All `getAll()`, `getById()`, and list methods MUST include `WHERE sync_deleted_at IS NULL` to filter soft-deleted records.

**EXCEPTION:** Sync-specific methods MUST NOT filter soft-deleted records because tombstones must propagate:

| Method | Behavior | Rationale |
|--------|----------|-----------|
| `getModifiedSince(timestamp)` | Includes soft-deleted | Sync must send deletion tombstones |
| `getPendingSync()` | Includes soft-deleted | Dirty deletions must sync to cloud |

```dart
// CORRECT: Sync method includes all records
Future<Result<List<T>, AppError>> getModifiedSince(int since) async {
  return _query(
    'SELECT * FROM $table WHERE sync_updated_at > ?', // NO sync_deleted_at filter
    [since],
  );
}

// CORRECT: Standard method filters soft-deleted
Future<Result<List<T>, AppError>> getAll(String profileId) async {
  return _query(
    'SELECT * FROM $table WHERE profile_id = ? AND sync_deleted_at IS NULL',
    [profileId],
  );
}
```

### 15.2 Entity Type Classification

**Rule:** Only standalone persisted entities need the 4 required fields (id, clientId, profileId, syncMetadata).

| Type | Requires 4 Fields? | Examples |
|------|-------------------|----------|
| **Standalone Entity** (own DB table) | YES | Supplement, Condition, FluidsEntry, Diet, DietRule |
| **Embedded/Value Type** (JSON in parent) | NO | SupplementIngredient, SupplementSchedule, InsightEvidence, PredictionFactor |
| **Input DTO** (use case input) | NO | GetSupplementsInput, LogFluidsEntryInput, CheckComplianceInput |
| **Output/Result Type** (computed) | NO | ComplianceCheckResult, DataQualityReport, ComplianceStats, ConditionTrend, TrendDataPoint |
| **UI State Class** | NO | SupplementListState |
| **Ephemeral Entity** (no persistence) | NO | QueuedNotification, PendingNotification |

**Decision Rule:** If the type has its own database table → standalone entity. If stored as JSON within parent → embedded type.

### 15.3 Input vs Output vs Entity Classification

```dart
// INPUT DTO: @freezed, no syncMetadata, for passing data INTO use cases
// CreateDietInput: See Section 8.4 (line ~10128) for canonical definition

// OUTPUT/RESULT: @freezed, no syncMetadata, computed/returned from use cases
// ComplianceCheckResult: See Section 8.3 (line ~9447) for canonical definition

// PERSISTED ENTITY: @freezed, MUST have 4 required fields
// Diet: See Section 8.3 (line ~9254) for canonical definition
```

### 15.4 Foreign Key ON DELETE Behaviors

| Parent → Child | ON DELETE | Rationale |
|----------------|-----------|-----------|
| profiles → supplements | CASCADE | Delete profile = delete all health data |
| profiles → conditions | CASCADE | Privacy: remove all related data |
| profiles → food_items | CASCADE | Privacy |
| profiles → activities | CASCADE | Privacy |
| profiles → diets | CASCADE | Privacy |
| user_accounts → profiles | SET NULL | Keep orphaned profiles for recovery |
| supplements → intake_logs | CASCADE | Delete supplement = delete intake history |
| conditions → condition_logs | CASCADE | Delete condition = delete logs |
| conditions → flare_ups | CASCADE | Delete condition = delete flare records |
| diets → diet_rules | CASCADE | Delete diet = delete rules |
| diets → diet_violations | CASCADE | Delete diet = delete violation history |
| photo_areas → photo_entries | CASCADE | Delete area = delete all photos |
| hipaa_authorizations → profile_access_logs | CASCADE | Authorization deleted = logs deleted |

### 15.5 Riverpod Framework Exceptions

**Rule:** All use case and repository methods return `Result<T, AppError>`.

**EXCEPTION:** Riverpod `@riverpod` annotated provider methods have framework-constrained signatures:

| Method | Returns | Where Errors Go |
|--------|---------|-----------------|
| `build()` | `Future<State>` or `State` | `state = AsyncError(error)` |
| `refresh()` | `void` | `state = AsyncError(error)` |
| Custom actions (`addItem()`, etc.) | `Future<Result<T, AppError>>` | Standard Result pattern |

```dart
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<SupplementListState> build(String profileId) async {
// SupplementList: See Section 7 (line ~7766) for canonical definition
```

### 15.6 Weekday Convention

**All weekday values use 0=Monday to 6=Sunday** (matches `DateTime.weekday - 1`).

| Day | Value |
|-----|-------|
| Monday | 0 |
| Tuesday | 1 |
| Wednesday | 2 |
| Thursday | 3 |
| Friday | 4 |
| Saturday | 5 |
| Sunday | 6 |

Used in: `NotificationSchedule.weekdays`, `SupplementSchedule.weekdays`, `DietRule.daysOfWeek`

### 15.7 Repository Pattern Exemptions

**Standard Rule:** All repositories MUST implement `EntityRepository<T, String>` with the full CRUD + sync interface (getAll, getById, create, update, delete, hardDelete, getModifiedSince, getPendingSync).

**EXCEPTION: Intelligence Repositories** — These repositories use `BaseRepositoryContract<T, String>` (which is a typedef for `EntityRepository<T, String>`, see Section 4.1). They inherit all standard CRUD + sync methods and add domain-specific query methods.

| Repository | Extends | Rationale |
|------------|---------|-----------|
| `PatternRepository` | `BaseRepositoryContract<Pattern, String>` | Intelligence subsystem convention |
| `TriggerCorrelationRepository` | `BaseRepositoryContract<TriggerCorrelation, String>` | Intelligence subsystem convention |
| `HealthInsightRepository` | `BaseRepositoryContract<HealthInsight, String>` | Intelligence subsystem convention |
| `PredictiveAlertRepository` | `BaseRepositoryContract<PredictiveAlert, String>` | Intelligence subsystem convention |

**EXCEPTION: Local-Only / Special-Purpose Repositories** — These repositories do NOT implement `EntityRepository` because they have no sync requirements and serve specialized purposes.

| Repository | Purpose | Missing Methods | Rationale |
|------------|---------|-----------------|-----------|
| `MLModelRepository` | Local ML model storage | getAll, getById, update, sync methods | Local-only, no sync needed; uses `save`/`delete`/`getLatest` |
| `PredictionFeedbackRepository` | Local feedback storage | getAll, getById, update, delete, sync methods | Local-only, no sync needed; write-once with `create` |
| `ProfileAccessLogRepository` | HIPAA audit trail | getAll, getById, update, delete, sync methods | Audit-only, append-only; has `create`/`getByProfile`/`getByAuthorization` |
| `BowelUrineLogRepository` | Migration read-only | getById, create, update, delete, sync methods | Read-only for data migration; has `getAll`/`getCount` only |

**EXCEPTION: Category Repositories** — `FoodItemCategoryRepository` overrides `getAll()` to return all categories (system-defined + user-defined) without requiring a profileId. Use `getUserDefined(profileId)` for profile-scoped queries.

---

## 16. Cloud Storage Provider Contract

### 16.1 CloudProviderType Enum

```dart
// lib/data/datasources/remote/cloud_storage_provider.dart

/// Type of cloud storage provider.
/// Explicit integer values required per Rule 9.1.1.
enum CloudProviderType {
  googleDrive(0),
  icloud(1),
  offline(2);

  final int value;
  const CloudProviderType(this.value);

  static CloudProviderType fromValue(int value) => CloudProviderType.values
      .firstWhere((e) => e.value == value, orElse: () => offline);
}
```

### 16.2 SyncChange DTO

```dart
// lib/data/datasources/remote/cloud_storage_provider.dart

/// Represents a change from the cloud that needs to be applied locally.
class SyncChange {
  /// The entity type string (e.g. 'supplements', 'intake_logs').
  final String entityType;

  /// The entity's unique identifier.
  final String entityId;

  /// The profile this entity belongs to.
  final String profileId;

  /// The client/device that last modified this entity.
  final String clientId;

  /// The serialized entity data as JSON.
  final Map<String, dynamic> data;

  /// The sync version of this change.
  final int version;

  /// Epoch milliseconds when this change was made.
  final int timestamp;

  /// Whether this change represents a deletion.
  final bool isDeleted;

  const SyncChange({
    required this.entityType,
    required this.entityId,
    required this.profileId,
    required this.clientId,
    required this.data,
    required this.version,
    required this.timestamp,
    this.isDeleted = false,
  });
}
```

### 16.3 CloudStorageProvider Interface

```dart
// lib/data/datasources/remote/cloud_storage_provider.dart

/// Abstract interface for cloud storage providers.
///
/// Implementations must handle authentication, file upload/download,
/// and change tracking for cloud synchronization.
///
/// All methods return Result<T, AppError> - never throw exceptions.
/// Authentication errors use AuthError factory methods.
/// Sync errors use SyncError factory methods.
abstract class CloudStorageProvider {
  /// The type of this cloud provider.
  CloudProviderType get providerType;

  /// Authenticate with the cloud provider.
  ///
  /// Returns [AuthError.signInFailed] on failure.
  Future<Result<void, AppError>> authenticate();

  /// Sign out from the cloud provider.
  ///
  /// Returns [AuthError.signOutFailed] on failure.
  Future<Result<void, AppError>> signOut();

  /// Check if currently authenticated with the provider.
  Future<bool> isAuthenticated();

  /// Check if the provider is available on this platform.
  Future<bool> isAvailable();

  /// Upload an entity to cloud storage.
  ///
  /// The [json] data will be encrypted before upload.
  /// [version] is used for conflict detection.
  Future<Result<void, AppError>> uploadEntity(
    String entityType,
    String entityId,
    String profileId,
    String clientId,
    Map<String, dynamic> json,
    int version,
  );

  /// Download an entity from cloud storage.
  ///
  /// Returns null if the entity does not exist in the cloud.
  Future<Result<Map<String, dynamic>?, AppError>> downloadEntity(
    String entityType,
    String entityId,
  );

  /// Get all changes since [sinceTimestamp] (epoch milliseconds).
  ///
  /// Returns a list of [SyncChange] objects representing remote modifications.
  Future<Result<List<SyncChange>, AppError>> getChangesSince(
    int sinceTimestamp,
  );

  /// Delete an entity from cloud storage.
  Future<Result<void, AppError>> deleteEntity(
    String entityType,
    String entityId,
  );

  /// Upload a file (e.g. photo) to cloud storage.
  Future<Result<void, AppError>> uploadFile(
    String localPath,
    String remotePath,
  );

  /// Download a file from cloud storage.
  ///
  /// Returns the local path where the file was saved.
  Future<Result<String, AppError>> downloadFile(
    String remotePath,
    String localPath,
  );
}
```

### 16.4 Google Drive Folder Structure

All data stored in Google Drive follows this structure:

```
shadow_app/
  └── data/
      ├── profiles/
      │   ├── {uuid}.json          (encrypted)
      │   └── ...
      ├── supplements/
      │   ├── {uuid}.json          (encrypted)
      │   └── ...
      ├── conditions/
      │   └── ...
      ├── intake_logs/
      │   └── ...
      └── ... (one folder per entity type)
  └── files/
      └── photos/
          └── {entityType}/{entityId}/
              └── {timestamp}_{filename}
```

Each entity JSON file is an envelope containing:

```json
{
  "entityType": "supplements",
  "entityId": "uuid-string",
  "version": 3,
  "deviceId": "device-abc-123",
  "updatedAt": 1707926400000,
  "encryptedData": "base64-encoded-AES-256-GCM-ciphertext"
}
```

### 16.5 OAuth Error Mapping

OAuth data source exceptions are caught by the provider and mapped to `AuthError`:

| OAuth Exception | Maps To | Recovery |
|-----------------|---------|----------|
| User cancelled sign-in | `AuthError.signInFailed("User cancelled")` | none |
| Invalid credentials | `AuthError.signInFailed("Invalid credentials")` | reAuthenticate |
| Token expired | `AuthError.tokenExpired()` | refreshToken |
| Refresh token revoked | `AuthError.tokenRefreshFailed()` | reAuthenticate |
| Network timeout | `NetworkError.timeout()` | retry |
| State mismatch (CSRF) | `AuthError.signInFailed("State mismatch")` | reAuthenticate |

### 16.6 OAuth Configuration

See `08_OAUTH_IMPLEMENTATION.md` for:
- Google Cloud project credentials
- Platform-specific client IDs and redirect URIs
- PKCE flow implementation
- OAuth proxy service for token exchange
- Token storage key constants

### 16.7 Cloud Sync Tier Order

Entity sync follows dependency order per `02_CODING_STANDARDS.md` Section 9.8:

| Tier | Entities | Must Sync Before |
|------|----------|-----------------|
| 1 | user_accounts | Everything |
| 2 | profiles | All health data |
| 3 | hipaa_authorizations, device_registrations | - |
| 4 | supplements, conditions, activities, diets, photo_areas | Their child logs |
| 5 | food_items | food_logs |
| 6 | intake_logs, condition_logs, activity_logs, etc. | - |
| 7 | food_logs | - |
| 8 | sleep_entries, fluids_entries, journal_entries | - |

### 16.8 Encryption Requirement

All entity data MUST be encrypted with AES-256-GCM before upload per `02_CODING_STANDARDS.md` Section 11.4. The `encryptedData` field in the envelope contains the base64-encoded ciphertext. Encryption keys are stored in platform secure storage (Keychain on iOS/macOS).

### 16.9 GoogleDriveProvider userEmail Getter

The `GoogleDriveProvider` exposes the signed-in user's email for display in the UI:

```dart
// lib/data/cloud/google_drive_provider.dart (addition to class)

/// The signed-in user's email address, or null if not authenticated.
///
/// For macOS: retrieved from the user info endpoint during OAuth flow.
/// For iOS: retrieved from the GoogleSignInAccount.
String? get userEmail => _userEmail ?? _currentUser?.email;
```

This getter is read by `CloudSyncAuthNotifier` after successful authentication to populate the UI with the user's identity.

### 16.10 CloudSyncAuthState

Authentication state for the Cloud Sync Setup screen. This is a lightweight state class used during Phase 1 before the full `AuthState` (Section 7.2.7) is implemented with domain-layer use cases.

```dart
// lib/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart

/// Authentication state for cloud sync.
class CloudSyncAuthState {
  /// Whether a sign-in or sign-out operation is in progress.
  final bool isLoading;

  /// Whether the user is currently authenticated.
  final bool isAuthenticated;

  /// The authenticated user's email address.
  final String? userEmail;

  /// The active cloud provider type.
  final CloudProviderType? activeProvider;

  /// User-facing error message from the last operation.
  final String? errorMessage;

  const CloudSyncAuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userEmail,
    this.activeProvider,
    this.errorMessage,
  });

  /// Creates a copy with the given fields replaced.
  ///
  /// Use clear* flags to explicitly set nullable fields to null:
  /// - clearUserEmail: sets userEmail to null
  /// - clearActiveProvider: sets activeProvider to null
  /// - clearErrorMessage: sets errorMessage to null
  ///
  /// If both a new value and a clear flag are provided for the same field,
  /// the new value wins.
  CloudSyncAuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? userEmail,
    CloudProviderType? activeProvider,
    String? errorMessage,
    bool clearUserEmail = false,
    bool clearActiveProvider = false,
    bool clearErrorMessage = false,
  }) => CloudSyncAuthState(
    isLoading: isLoading ?? this.isLoading,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    userEmail: clearUserEmail ? null : (userEmail ?? this.userEmail),
    activeProvider: clearActiveProvider
        ? null
        : (activeProvider ?? this.activeProvider),
    errorMessage: clearErrorMessage
        ? null
        : (errorMessage ?? this.errorMessage),
  );
}
```

**Migration note**: This class will be replaced by the `@freezed AuthState` from Section 7.2.7 when the auth domain layer (use cases, UserAccount entity) is implemented. The `CloudSyncAuthNotifier` will then delegate to use cases per Section 6.2 of the Coding Standards. Until then, the `StateNotifier` pattern (matching the existing `ProfileProvider` precedent) is used as a pragmatic interim approach.

### 16.11 CloudSyncAuthNotifier

Notifier managing cloud sync authentication state. Wraps `GoogleDriveProvider` to provide sign-in/sign-out operations and expose authentication state to the UI.

```dart
// lib/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart

class CloudSyncAuthNotifier extends StateNotifier<CloudSyncAuthState> {
  final GoogleDriveProvider _provider;
  final ScopedLogger _log;

  CloudSyncAuthNotifier(this._provider)
    : _log = logger.scope('CloudSyncAuth'),
      super(const CloudSyncAuthState()) {
    _checkExistingSession();
  }

  /// Check if there's an existing authenticated session on startup.
  ///
  /// If the user previously signed in and tokens are still valid,
  /// restores the authenticated state without requiring re-sign-in.
  /// Non-fatal on failure (user can still sign in manually).
  Future<void> _checkExistingSession() async {
    try {
      final authenticated = await _provider.isAuthenticated();
      if (authenticated) {
        state = state.copyWith(
          isAuthenticated: true,
          userEmail: _provider.userEmail,
          activeProvider: CloudProviderType.googleDrive,
        );
      }
    } on Exception catch (e, stack) {
      _log.error('Failed to check existing session', e, stack);
    }
  }

  /// Sign in with Google Drive.
  ///
  /// Opens the browser for OAuth sign-in (macOS) or shows the
  /// Google Sign-In sheet (iOS). Updates state with result.
  ///
  /// Behavior:
  /// - Ignores concurrent calls while isLoading is true
  /// - Clears previous error before starting
  /// - Sets isLoading=true during the operation
  /// - On success: isAuthenticated=true, userEmail populated, activeProvider=googleDrive
  /// - On failure: isAuthenticated=false, errorMessage set, userEmail/activeProvider cleared
  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    final result = await _provider.authenticate();

    result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userEmail: _provider.userEmail,
          activeProvider: CloudProviderType.googleDrive,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: error.userMessage,
          clearUserEmail: true,
          clearActiveProvider: true,
        );
      },
    );
  }

  /// Sign out from the current cloud provider.
  ///
  /// Behavior:
  /// - Ignores concurrent calls while isLoading is true
  /// - Clears previous error before starting
  /// - On success: resets state to default (const CloudSyncAuthState())
  /// - On failure: keeps current auth state, sets errorMessage
  Future<void> signOut() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    final result = await _provider.signOut();

    result.when(
      success: (_) {
        state = const CloudSyncAuthState();
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.userMessage,
        );
      },
    );
  }

  /// Clear any error message displayed to the user.
  ///
  /// Preserves all other state fields (isAuthenticated, userEmail, etc.).
  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }
}
```

**Concurrency guard**: Both `signInWithGoogle()` and `signOut()` check `state.isLoading` at entry and return immediately if another operation is already in progress. This prevents duplicate OAuth windows or conflicting sign-out requests.

### 16.12 Cloud Sync Provider Declarations

```dart
// lib/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart

/// Provider for the GoogleDriveProvider instance.
///
/// Override in ProviderScope for testing.
final googleDriveProviderProvider = Provider<GoogleDriveProvider>(
  (ref) => GoogleDriveProvider(),
);

/// Provider for cloud sync authentication state.
final cloudSyncAuthProvider =
    StateNotifierProvider<CloudSyncAuthNotifier, CloudSyncAuthState>(
      (ref) => CloudSyncAuthNotifier(ref.read(googleDriveProviderProvider)),
    );
```

**Pattern justification**: These use `StateNotifierProvider` (legacy Riverpod) rather than the `@riverpod` annotation required by Coding Standards Section 6.1. This follows the `ProfileProvider` precedent — the auth domain layer (use cases, `UserAccount` entity, `AuthTokenService`) does not yet exist. When the domain layer is built in a future phase, these providers will be refactored to `@riverpod` annotation syntax with `UseCase` delegation per Section 6.2.

**Testing**: Both providers can be overridden in `ProviderScope` for widget tests:
```dart
ProviderScope(
  overrides: [
    cloudSyncAuthProvider.overrideWith(
      (ref) => FakeCloudSyncAuthNotifier(testState),
    ),
  ],
  child: const MaterialApp(home: CloudSyncSetupScreen()),
)
```

---

## 17. Sync Service Contract

The `SyncService` is the domain-layer orchestration interface for cloud synchronization.
It coordinates between local repositories (dirty record queries) and the `CloudStorageProvider`
(remote operations). All methods referenced by use cases (Section 4.5.9) and providers
(Section 7.2.8) are consolidated here.

### 17.1 SyncConflict Type

```dart
// lib/domain/entities/sync_conflict.dart

@freezed
class SyncConflict with _$SyncConflict {
  const factory SyncConflict({
    required String id,              // Unique conflict identifier (UUID v4)
    required String entityType,      // Table name (e.g. 'supplements')
    required String entityId,        // The conflicting entity's ID
    required String profileId,
    required int localVersion,       // Local syncVersion at time of conflict
    required int remoteVersion,      // Remote syncVersion at time of conflict
    required Map<String, dynamic> localData,   // Full local entity JSON
    required Map<String, dynamic> remoteData,  // Full remote entity JSON
    required int detectedAt,         // Epoch ms when conflict was detected
    @Default(false) bool isResolved,
    ConflictResolutionType? resolution,  // How it was resolved (null if unresolved)
    int? resolvedAt,                 // Epoch ms when resolved
  }) = _SyncConflict;

  factory SyncConflict.fromJson(Map<String, dynamic> json) =>
      _$SyncConflictFromJson(json);
}
```

### 17.2 SyncService Interface

```dart
// lib/domain/services/sync_service.dart

/// Domain-layer sync orchestration service.
///
/// Coordinates local dirty-record queries with CloudStorageProvider
/// remote operations. Injected into sync use cases and providers.
///
/// All methods return Result<T, AppError> per Section 1.
abstract class SyncService {

  // === Push Operations ===

  /// Get locally-modified records awaiting sync upload.
  ///
  /// Queries all entity tables for records where sync_is_dirty = true
  /// AND sync_deleted_at IS NULL (live records) OR sync_deleted_at IS NOT NULL
  /// (tombstones that need to propagate per Section 15.1).
  ///
  /// Returns at most [limit] changes, ordered by sync_updated_at ASC.
  Future<Result<List<SyncChange>, AppError>> getPendingChanges(
    String profileId, {
    int limit = 500,
  });

  /// Push local changes to the cloud provider.
  ///
  /// For each SyncChange: encrypts entity data with AES-256-GCM (per Section 16.8),
  /// then calls CloudStorageProvider.uploadEntity. Returns aggregate result
  /// with count of pushed/failed and any conflicts detected.
  Future<Result<PushChangesResult, AppError>> pushChanges(
    List<SyncChange> changes,
  );

  /// Convenience: push ALL pending changes for sign-out cleanup.
  ///
  /// Best-effort — errors are logged but do not fail sign-out.
  /// Referenced by SignOutUseCase (Section 4.5.8).
  Future<void> pushPendingChanges();

  // === Pull Operations ===

  /// Pull remote changes from the cloud provider since [sinceVersion].
  ///
  /// Calls CloudStorageProvider.getChangesSince, decrypts payloads,
  /// and returns the raw SyncChange list for local application.
  ///
  /// [sinceVersion] is null on first sync (pulls everything).
  Future<Result<List<SyncChange>, AppError>> pullChanges(
    String profileId, {
    int? sinceVersion,
    int limit = 500,
  });

  /// Apply pulled remote changes to local database.
  ///
  /// For each SyncChange:
  /// 1. Check if local entity exists
  /// 2. If no local entity → insert
  /// 3. If local entity is NOT dirty → overwrite with remote
  /// 4. If local entity IS dirty → create SyncConflict
  ///
  /// Returns aggregate result with counts and any detected conflicts.
  Future<Result<PullChangesResult, AppError>> applyChanges(
    String profileId,
    List<SyncChange> changes,
  );

  // === Conflict Resolution ===

  /// Resolve a sync conflict by applying the chosen resolution strategy.
  ///
  /// - keepLocal: Mark local version as dirty, discard remote
  /// - keepRemote: Overwrite local with remote, clear dirty flag
  /// - merge: Apply non-conflicting fields from both versions
  Future<Result<void, AppError>> resolveConflict(
    String conflictId,
    ConflictResolutionType resolution,
  );

  // === Status Queries ===

  /// Get count of locally-modified records awaiting sync.
  ///
  /// SELECT COUNT(*) FROM each entity table WHERE profile_id = ? AND sync_is_dirty = true
  Future<Result<int, AppError>> getPendingChangesCount(String profileId);

  /// Get count of unresolved sync conflicts for a profile.
  Future<Result<int, AppError>> getConflictCount(String profileId);

  /// Get last successful sync time (epoch milliseconds) for a profile.
  ///
  /// Used by SyncNotifier (Section 7.2.8) for display and by
  /// SyncReminderService (Section 12.5) for reminder threshold.
  Future<Result<int?, AppError>> getLastSyncTime(String profileId);

  /// Get last successfully synced version number for a profile.
  ///
  /// Used by PullChangesUseCase (Section 4.5.9) to determine
  /// which remote changes to pull. Returns null if never synced.
  Future<Result<int?, AppError>> getLastSyncVersion(String profileId);
}
```

### 17.3 Cloud Envelope Format

All entities uploaded to Google Drive are wrapped in an envelope JSON object.
The envelope contains metadata for routing/conflict detection and the encrypted entity data.

**Canonical field names (used by both push and pull):**

```json
{
  "entityType": "supplements",
  "entityId": "uuid-v4",
  "profileId": "uuid-v4",
  "clientId": "device-uuid",
  "version": 1,
  "timestamp": 1708300000000,
  "isDeleted": false,
  "encryptedData": "base64nonce:base64ciphertext:base64tag"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `entityType` | `String` | Table name (e.g. `'supplements'`, `'intake_logs'`) |
| `entityId` | `String` | The entity's UUID v4 identifier |
| `profileId` | `String` | The profile this entity belongs to |
| `clientId` | `String` | The client/device that last modified this entity |
| `version` | `int` | The entity's `syncVersion` at time of upload |
| `timestamp` | `int` | Epoch milliseconds (`syncUpdatedAt`) at time of upload |
| `isDeleted` | `bool` | Whether this is a tombstone (soft-deleted record) |
| `encryptedData` | `String` | AES-256-GCM encrypted entity JSON in `nonce:ciphertext:tag` format (all base64) |

**IMPORTANT:** The `encryptedData` field is NOT raw JSON. It is an AES-256-GCM encrypted string
that must be decrypted by `EncryptionService.decrypt()` before JSON parsing. The decrypted
string is a JSON-encoded `Map<String, dynamic>` matching the entity's `toJson()` output.

### 17.4 SyncEntityAdapter (Pull Support)

For the pull path, `SyncEntityAdapter` needs to reconstruct entities from downloaded JSON.
Each adapter registers a `fromJson` callback alongside the existing push-path callbacks.

```dart
class SyncEntityAdapter<T extends Syncable> {
  final String entityType;
  final EntityRepository<T, String> repository;

  /// Returns a copy of the entity with the given sync metadata.
  final T Function(T entity, SyncMetadata metadata) withSyncMetadata;

  /// Reconstruct an entity from its JSON representation (for pull path).
  /// This bridges the generic Syncable interface to concrete Freezed fromJson.
  final T Function(Map<String, dynamic> json) fromJson;

  const SyncEntityAdapter({
    required this.entityType,
    required this.repository,
    required this.withSyncMetadata,
    required this.fromJson,
  });
}
```

### 17.5 Pull Path Flow

The pull path is the reverse of the push path. It downloads remote changes,
decrypts them, and applies them to the local database.

**Step-by-step flow for `pullChanges`:**

1. Read `getLastSyncTime(profileId)` to get the last successful sync timestamp (epoch ms).
   If null (first sync), use `0` to pull all remote data.
2. Call `CloudStorageProvider.getChangesSince(lastSyncTime)`.
   - The provider returns `List<SyncChange>` where each `SyncChange.data` contains
     the **raw envelope** (with `encryptedData` still as an encrypted string).
3. For each `SyncChange`, extract the `encryptedData` field from the envelope,
   call `EncryptionService.decrypt()`, then `jsonDecode()` the result to get
   the entity's `Map<String, dynamic>` data.
4. Replace the `SyncChange.data` with the decrypted entity data.
5. Return the list of decrypted `SyncChange` objects.

**Step-by-step flow for `applyChanges`:**

1. For each `SyncChange`:
   a. Find the `SyncEntityAdapter` for the entity type.
   b. Call `adapter.fromJson(change.data)` to reconstruct the entity.
   c. Try `adapter.repository.getById(change.entityId)`:
      - **Not found** → Call `adapter.repository.create(entity)` with `markDirty: false`
        (this is a remote record, not a local change).
        Set sync metadata: `syncIsDirty = false`, `syncStatus = synced`,
        `syncLastSyncedAt = now`.
      - **Found, NOT dirty** → Call `adapter.repository.update(entity, markDirty: false)`.
        Overwrite local with remote version.
      - **Found, IS dirty** → Conflict detected. Create a `SyncConflict` with both
        local and remote data. Log the conflict. Skip this entity for now (Phase 4).
2. Update `lastSyncTime` and `lastSyncVersion` in SharedPreferences.
3. Return `PullChangesResult` with counts.

**Per `02_CODING_STANDARDS.md` Section 9.2:**
- `markDirty: false` for all remote sync applies
- `sync_is_dirty = 0, sync_status = synced` after receiving remote update
- Conflict: `sync_is_dirty = 1, sync_status = conflict`

### 17.6 Implementation Notes

| Concern | Approach |
|---------|----------|
| **Encryption** | All entity data encrypted with AES-256-GCM before upload per `02_CODING_STANDARDS.md` Section 11.4 and Section 16.8 |
| **Decryption** | Pull path decrypts `encryptedData` via `EncryptionService.decrypt()` before JSON parsing |
| **Soft-delete propagation** | `getPendingChanges` includes tombstones per Section 15.1; pull path applies remote tombstones by setting local `syncDeletedAt` |
| **Version tracking** | `getLastSyncVersion` reads MAX(sync_version) from successfully synced records; `getLastSyncTime` reads the stored last-sync epoch ms |
| **Concurrency** | `pushPendingChanges` is best-effort for sign-out; full push/pull operations use rate limiting via `RateLimitService` |
| **Conflict detection** | During `applyChanges`, if local `syncIsDirty == true` AND remote `syncVersion > local.syncVersion`, a `SyncConflict` is created |
| **Conflict storage** | Two simultaneous writes: (1) insert into `sync_conflicts` table; (2) call `entity.syncMetadata.markConflict(remoteJson)` to set `sync_status = 3` and store remote JSON in `conflict_data` column on the entity row. See `10_DATABASE_SCHEMA.md` Section 17. |
| **Conflict resolution** | `resolveConflict()` applies the chosen version, calls `syncMetadata.clearConflict()` on the entity, and marks the `sync_conflicts` row as resolved. |
| **Provider dependency** | `SyncService` is injected via `syncServiceProvider` (Riverpod) into use cases and the `SyncNotifier` |
| **Envelope consistency** | Push and pull use identical field names (Section 17.3). `getChangesSince` must read the same fields that `pushChanges` writes |

### 17.7 Conflict Resolution — Detailed Behavior

#### 17.7.1 Detection (during `applyChanges`)

A conflict is created when ALL of the following are true:
- A remote `SyncChange` arrives for an entity that already exists locally
- The local entity has `syncIsDirty == true` (it was locally modified since last sync)

When detected, two writes happen atomically:
1. Insert a `SyncConflict` row into `sync_conflicts` (Section 17.1 entity definition, `10_DATABASE_SCHEMA.md` Section 17 for table schema)
2. Update the entity row: call `markConflict(remoteJson)` on its `SyncMetadata` and persist via repository (with `markDirty: false` — the dirty state is already set by `markConflict`)

#### 17.7.2 Resolution Options

**`keepLocal` (0):**
- The local entity is already the correct version on disk
- Update the entity's sync metadata: call `clearConflict()` → sets `syncStatus = pending`, `syncIsDirty = true`, increments `syncVersion`, clears `conflictData`
- The entity will be re-uploaded in the next push, overwriting the remote version
- Mark `sync_conflicts` row: `isResolved = true`, `resolution = 0`, `resolvedAt = now`

**`keepRemote` (1):**
- Reconstruct the remote entity from `SyncConflict.remoteData` JSON via `adapter.fromJson(conflict.remoteData)`
- Call `adapter.repository.update(remoteEntity, markDirty: false)`
- This single call is sufficient — the remote entity's sync metadata already has `syncIsDirty = false`, `syncStatus = synced`, and `conflictData = null`. Applying it overwrites the local conflicted row completely, including clearing the conflict state.
- **Do NOT call `clearConflict()`** for keepRemote — `clearConflict()` sets `syncIsDirty = true` which would cause an unnecessary re-upload.
- Mark `sync_conflicts` row: `isResolved = true`, `resolution = 1`, `resolvedAt = now`

**`merge` (2):**
- Compare `SyncConflict.localData` and `SyncConflict.remoteData` field by field
- **If changed fields are disjoint** (local changed field A only, remote changed field B only): build a merged entity taking each changed field from the version that modified it; apply with `markDirty: true`
- **If any field was changed by both versions** (true conflict on a field): fall back to `keepRemote` for that field; the overall resolution is still recorded as `merge(2)`
- **Special cases by entity type:**
  - `journal_entries`: append local and remote `content` fields with `\n\n---\n\n` separator
  - `photo_entries`: cannot merge images — treat as `keepLocal`; remote version remains accessible via re-pull if needed
- Mark `sync_conflicts` row: `isResolved = true`, `resolution = 2`, `resolvedAt = now`

#### 17.7.3 `getConflictCount` Implementation

```dart
// Queries sync_conflicts table — NOT entity tables
Future<Result<int, AppError>> getConflictCount(String profileId) async {
  // SELECT COUNT(*) FROM sync_conflicts
  // WHERE profile_id = ? AND is_resolved = 0
}
```

#### 17.7.4 State Machine After Resolution

```
keepLocal  → clearConflict() on entity
               → syncStatus=pending, dirty=true, version++, conflictData=null
               → will re-upload on next push (local version overwrites remote)

keepRemote → apply remoteEntity with markDirty:false (no clearConflict() call)
               → syncStatus=synced, dirty=false, conflictData=null
               → no upload needed (remote is already authoritative)

merge      → apply merged entity with markDirty:true, clearConflict()
               → syncStatus=pending, dirty=true, version++, conflictData=null
               → merged entity will upload on next push
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-01-31 | Added Intelligence System contracts (Pattern, TriggerCorrelation, HealthInsight, PredictiveAlert entities, repositories, use cases) |
| 1.2 | 2026-02-01 | Added 6 missing entity contracts: UserAccount, DeviceRegistration, Document, MLModel, PredictionFeedback, BowelUrineLog (Round 5 Audit) |
| 1.3 | 2026-02-01 | Added complete error factory methods for all error types; added comprehensive notification type documentation with snooze behavior; added Section 12 Behavioral Specifications resolving all ambiguities (Round 7 Audit) |
| 1.4 | 2026-02-01 | Converted ALL use case inputs to @freezed format; Added Section 13 Entity-Database Alignment Reference; Added Section 14 Test Scenarios for Behavioral Specifications (Complete 100% Audit) |
| 1.5 | 2026-02-01 | Added Section 15 Edge Cases and Exceptions; Fixed weekday convention (0=Monday); Fixed Diet/DietRule/DeviceRegistration entity-DB alignment; Fixed FluidsEntry entryDate mapping |
| 1.6 | 2026-02-14 | Added Section 16 Cloud Storage Provider Contract (CloudProviderType, SyncChange, CloudStorageProvider interface, Google Drive folder structure, OAuth error mapping, sync tier order, encryption requirement) |
| 1.7 | 2026-02-14 | Added Sections 16.9–16.12: GoogleDriveProvider.userEmail getter, CloudSyncAuthState, CloudSyncAuthNotifier, provider declarations (Phase 1c spec coverage) |
| 1.8 | 2026-02-17 | Added Section 17 Sync Service Contract (complete SyncService interface, SyncConflict entity); Fixed dangling Section 11 reference → Section 17; Fixed SyncNotifier getLastSyncTime Result unwrap bug; Fixed PullChangesUseCase getLastSyncVersion Result unwrap and null safety (Phase 2a spec prep) |
| 1.9 | 2026-02-18 | Added Sections 17.3–17.6: Cloud envelope format spec, SyncEntityAdapter fromJson requirement, pull path flow, updated implementation notes. Fixed envelope field name discrepancy (clientId/timestamp vs deviceId/updatedAt). Documented encryptedData format (AES-256-GCM, not raw JSON). (Phase 3a spec prep) |
| 1.10 | 2026-02-19 | Fixed ConflictResolution → ConflictResolutionType to match actual enum name in code. (Phase 3b audit) |
| 1.11 | 2026-02-21 | Phase 4a spec: Added markConflict() and clearConflict() to SyncMetadata; Added Section 17.7 Conflict Resolution Detailed Behavior (detection, keepLocal/keepRemote/merge resolution logic, getConflictCount implementation, post-resolution state machine); Updated Section 17.6 implementation notes with conflict storage and resolution rows. |
