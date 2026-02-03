# Shadow API Contracts

**Version:** 1.0
**Last Updated:** January 30, 2026
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
  none,
  /// Retry the operation (transient failure)
  retry,
  /// Refresh the authentication token
  refreshToken,
  /// User must re-authenticate (sign in again)
  reAuthenticate,
  /// User should check app settings
  goToSettings,
  /// User should contact support
  contactSupport,
  /// User should check network connection
  checkConnection,
  /// User should free up storage space
  freeStorage,
}

sealed class AppError {
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

  factory DatabaseError.updateFailed(String table, String id, [dynamic error, StackTrace? stack]) =>
    DatabaseError._(
      code: codeUpdateFailed,
      message: 'Failed to update $table with id $id',
      userMessage: 'Unable to update data. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory DatabaseError.deleteFailed(String table, String id, [dynamic error, StackTrace? stack]) =>
    DatabaseError._(
      code: codeDeleteFailed,
      message: 'Failed to delete from $table with id $id',
      userMessage: 'Unable to delete data. Please try again.',
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
  normal,
  diarrhea,
  constipation,
  bloody,
  mucusy,
  custom,
}

enum UrineCondition {
  clear,
  lightYellow,
  darkYellow,
  amber,
  brown,
  red,
  custom,
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
}

enum SleepQuality {
  veryPoor(1),
  poor(2),
  fair(3),
  good(4),
  excellent(5);

  final int value;
  const SleepQuality(this.value);
}

enum ActivityIntensity {
  light,
  moderate,
  vigorous,
}

enum ConditionSeverity {
  none(0),
  mild(1),
  moderate(2),
  severe(3),
  extreme(4);

  final int value;
  const ConditionSeverity(this.value);

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
}

enum DietRuleType {
  // Food-based rules
  excludeCategory,      // Exclude entire food category
  excludeIngredient,    // Exclude specific ingredient
  requireCategory,      // Must include category (e.g., vegetables)
  limitCategory,        // Max servings per day/week

  // Macronutrient rules
  maxCarbs,             // Maximum carbs (grams)
  maxFat,               // Maximum fat (grams)
  maxProtein,           // Maximum protein (grams)
  minCarbs,             // Minimum carbs (grams)
  minFat,               // Minimum fat (grams)
  minProtein,           // Minimum protein (grams)
  carbPercentage,       // Carbs as % of calories
  fatPercentage,        // Fat as % of calories
  proteinPercentage,    // Protein as % of calories
  maxCalories,          // Maximum daily calories

  // Time-based rules
  eatingWindowStart,    // Earliest eating time
  eatingWindowEnd,      // Latest eating time
  fastingHours,         // Required consecutive fasting hours
  fastingDays,          // Specific fasting days (for 5:2)
  maxMealsPerDay,       // Maximum number of meals

  // Combination rules
  mealSpacing,          // Minimum hours between meals
  noEatingBefore,       // No food before time
  noEatingAfter,        // No food after time
}

enum PatternType {
  temporal,
  cyclical,
  sequential,
  cluster,
  dosage,
}

/// Diet preset types - predefined diet configurations
enum DietPresetType {
  vegan,
  vegetarian,
  pescatarian,
  paleo,
  keto,
  ketoStrict,
  lowCarb,
  mediterranean,
  whole30,
  aip,              // Autoimmune Protocol
  lowFodmap,
  glutenFree,
  dairyFree,
  if168,            // Intermittent Fasting 16:8
  if186,            // Intermittent Fasting 18:6
  if204,            // Intermittent Fasting 20:4
  omad,             // One Meal A Day
  fiveTwoDiet,      // 5:2 Fasting
  zone,
  custom,
}

enum InsightCategory {
  daily,
  summary,         // Weekly/monthly summaries
  pattern,
  trigger,
  progress,
  compliance,
  anomaly,
  milestone,
  recommendation,  // Actionable recommendations
}

enum AlertPriority {
  low,
  medium,
  high,
  critical,
}

enum WearablePlatform {
  healthkit,
  googlefit,
  fitbit,
  garmin,
  oura,
  whoop,
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
    sleepBedtime => 15,
    sleepWakeup => 5,
    fastingWindowOpen => 15,
    fastingWindowClose => 15,
    fastingWindowClosed => 15,
    fluidsGeneral => 60,
    fluidsBowel => 60,
    _ => 60,  // Default for flexible types
  };
}

// Supplement-related enums
enum SupplementForm {
  capsule,
  powder,
  liquid,
  tablet,
  other,
}

enum DosageUnit {
  g('g'),        // grams
  mg('mg'),      // milligrams
  mcg('mcg'),    // micrograms
  iu('IU'),      // International Units
  hdu('HDU'),    // Histamine Degrading Units
  ml('mL'),      // milliliters
  drops('drops'),
  tsp('tsp'),    // teaspoons
  custom('');    // User-defined unit

  final String abbreviation;
  const DosageUnit(this.abbreviation);
}

enum SupplementTimingType {
  withEvent(0),
  beforeEvent(1),
  afterEvent(2),
  specificTime(3);

  final int value;
  const SupplementTimingType(this.value);
}

enum SupplementFrequencyType {
  daily(0),
  everyXDays(1),
  specificWeekdays(2);

  final int value;
  const SupplementFrequencyType(this.value);
}

// Document type enum
enum DocumentType {
  medical(0),
  prescription(1),
  lab(2),
  other(3);

  final int value;
  const DocumentType(this.value);
}

// Authorization and scope enums (for profile sharing)
// See 35_QR_DEVICE_PAIRING.md Section 8.4 for full context

/// DataScope defines which data types can be accessed via a HIPAA authorization
enum DataScope {
  conditions,        // Health conditions and symptom logs
  supplements,       // Supplement definitions and intake logs
  food,              // Food items and meal logs
  sleep,             // Sleep entries
  activities,        // Activity definitions and logs
  fluids,            // Fluids tracking (water, bowel, urine, menstruation, BBT)
  photos,            // Photo documentation (requires explicit consent)
  journal,           // Journal entries
  reports,           // Generated reports
  insights,          // Intelligence system insights and patterns
}

/// AccessLevel defines what operations are allowed on shared profiles
enum AccessLevel {
  readOnly,          // Can only view data within scope
  readWrite,         // Can view and create/update data (no delete)
  owner,             // Full access (profile owner)
}

/// AuthorizationDuration defines how long a HIPAA authorization is valid
enum AuthorizationDuration {
  untilRevoked,      // No expiration
  days30,            // 30 days
  days90,            // 90 days
  days180,           // 6 months
  days365,           // 1 year
}

/// WriteOperation types for authorization checking
enum WriteOperation {
  create,
  update,
  softDelete,
  hardDelete,
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
/// IMPORTANT: BaseRepository and EntityRepository are interchangeable.
/// Use EntityRepository for new code; BaseRepository exists for consistency
/// with patterns used in intelligence repositories.
typedef BaseRepository<T, ID> = EntityRepository<T, ID>;
```

### 3.2 Specific Repository Contracts

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
    int limit = 20,
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

// lib/domain/repositories/notification_schedule_repository.dart

abstract class NotificationScheduleRepository
    implements EntityRepository<NotificationSchedule, String> {
  /// Get all enabled schedules for a profile.
  Future<Result<List<NotificationSchedule>, AppError>> getEnabled(
    String profileId,
  );

  /// Get schedules by type.
  Future<Result<List<NotificationSchedule>, AppError>> getByType(
    String profileId,
    NotificationType type,
  );

  /// Get schedule linked to specific entity (e.g., supplement).
  Future<Result<NotificationSchedule?, AppError>> getByEntityId(
    String profileId,
    String entityId,
  );
}
```

---

## 4. Use Case Contracts

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

    // Urine
    UrineCondition? urineCondition,

    // Menstruation
    MenstruationFlow? menstruationFlow,

    // BBT
    double? basalBodyTemperature,
    int? bbtRecordedTime,               // Epoch milliseconds

    // Custom "Other" fluid
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,

    String? notes,
  }) = _LogFluidsEntryInput;
}

class LogFluidsEntryUseCase implements UseCase<LogFluidsEntryInput, FluidsEntry> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;

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
    final entry = FluidsEntry(
      id: '', // Will be generated
      profileId: input.profileId,
      entryDate: input.entryDate,
      bowelCondition: input.bowelCondition,
      bowelSize: input.bowelSize,
      urineCondition: input.urineCondition,
      menstruationFlow: input.menstruationFlow,
      basalBodyTemperature: input.basalBodyTemperature,
      bbtRecordedTime: input.bbtRecordedTime,
      notes: input.notes,
      syncMetadata: SyncMetadata.empty(), // Will be populated
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

    // Other fluid requires name if amount or notes provided
    if ((input.otherFluidAmount != null || input.otherFluidNotes != null) &&
        input.otherFluidName == null) {
      errors['otherFluidName'] = ['Fluid name is required when logging other fluids'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
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

/// Ingredient in a supplement (e.g., Vitamin D3, Magnesium Citrate)
@freezed
class SupplementIngredient with _$SupplementIngredient {
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
  static const int nameMinLength = 1;
  static const int nameMaxLength = 100;
  static const int notesMaxLength = 5000;
  static const int descriptionMaxLength = 500;
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
  static const int maxPhotosPerEntry = 10;
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
    String? presetId,                     // NULL for custom diets
    @Default(true) bool isActive,
    int? startDate,                       // Epoch milliseconds - For fixed-duration diets
    int? endDate,                         // Epoch milliseconds
    TimeOfDay? eatingWindowStart,         // For IF diets
    TimeOfDay? eatingWindowEnd,
    @Default([]) List<DietRule> rules,    // Custom rules (preset rules loaded from code)
    required SyncMetadata syncMetadata,
  }) = _Diet;

  factory Diet.fromJson(Map<String, dynamic> json) =>
      _$DietFromJson(json);

  // Computed properties
  bool get isPreset => presetId != null;
  bool get isCustom => presetId == null;
  bool get hasEatingWindow => eatingWindowStart != null && eatingWindowEnd != null;
  bool get isFixedDuration => endDate != null;

  Duration? get eatingWindowDuration {
    if (!hasEatingWindow) return null;
    final startMinutes = eatingWindowStart!.hour * 60 + eatingWindowStart!.minute;
    final endMinutes = eatingWindowEnd!.hour * 60 + eatingWindowEnd!.minute;
    return Duration(minutes: endMinutes - startMinutes);
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

enum RuleSeverity { violation, warning, info }

enum FoodCategory {
  meat, poultry, fish, eggs, dairy,
  vegetables, fruits, grains, legumes, nuts, seeds,
  gluten, nightshades, fodmaps, sugar, alcohol, caffeine,
  processedFoods, artificialSweeteners, friedFoods, rawFoods,
}

@freezed
class DietRule with _$DietRule {
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

  @override
  Future<Result<ComplianceCheckResult, AppError>> call(CheckComplianceInput input) async {
    // 1. Get diet with rules
    final dietResult = await _dietRepository.getById(input.dietId);
    if (dietResult.isFailure) return Failure(dietResult.errorOrNull!);

    final diet = dietResult.valueOrNull!;

    // 2. Check food against all rules
    final violations = _complianceService.checkFoodAgainstRules(
      input.foodItem,
      diet.rules,
      input.logTime,
    );

    // 3. Calculate impact
    final impact = _complianceService.calculateImpact(
      input.profileId,
      violations,
    );

    // 4. Find alternatives if violations exist
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

## 7.5 Intelligence System Contracts (Phase 3)

For complete specifications, see [42_INTELLIGENCE_SYSTEM.md](42_INTELLIGENCE_SYSTEM.md).

### Pattern Entity

```dart
@freezed
class Pattern with _$Pattern {
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
    @Default(true) bool isActive,
    required SyncMetadata syncMetadata,
  }) = _Pattern;
}

enum PatternType { temporal, cyclical, sequential, cluster, dosage }
```

### TriggerCorrelation Entity

```dart
@freezed
class TriggerCorrelation with _$TriggerCorrelation {
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

enum CorrelationType { positive, negative, neutral, doseResponse }
```

### HealthInsight Entity

```dart
@freezed
class HealthInsight with _$HealthInsight {
  const factory HealthInsight({
    required String id,
    required String clientId,
    required String profileId,
    required InsightCategory category,
    required InsightPriority priority,
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

enum InsightCategory { summary, pattern, trigger, progress, compliance, anomaly, milestone, recommendation }
enum InsightPriority { high, medium, low }

/// Evidence supporting a health insight
@freezed
class InsightEvidence with _$InsightEvidence {
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

enum PredictionType { flareUp, menstrualStart, ovulation, triggerExposure, missedSupplement, poorSleep }

/// Factor contributing to a predictive alert
@freezed
class PredictionFactor with _$PredictionFactor {
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
abstract class PatternRepository extends BaseRepository<Pattern, String> {
  Future<Result<List<Pattern>, AppError>> getByProfile(
    String profileId, {
    PatternType? type,
    bool activeOnly = true,
  });
  Future<Result<List<Pattern>, AppError>> getByEntity(String entityType, String entityId);
  Future<Result<void, AppError>> deactivate(String id);
}

abstract class TriggerCorrelationRepository extends BaseRepository<TriggerCorrelation, String> {
  Future<Result<List<TriggerCorrelation>, AppError>> getByProfile(
    String profileId, {
    CorrelationType? type,
    bool activeOnly = true,
  });
  Future<Result<List<TriggerCorrelation>, AppError>> getByTrigger(String triggerType, String triggerId);
  Future<Result<List<TriggerCorrelation>, AppError>> getByOutcome(String outcomeType, String outcomeId);
  Future<Result<List<TriggerCorrelation>, AppError>> getPositive(String profileId, String outcomeId);
}

abstract class HealthInsightRepository extends BaseRepository<HealthInsight, String> {
  Future<Result<List<HealthInsight>, AppError>> getActive(
    String profileId, {
    InsightCategory? category,
    InsightPriority? minPriority,
    int? limit,
  });
  Future<Result<void, AppError>> dismiss(String id);
}

abstract class PredictiveAlertRepository extends BaseRepository<PredictiveAlert, String> {
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
    required int startDate,                         // Epoch milliseconds
    required int endDate,                           // Epoch milliseconds
    @Default([]) List<PatternType> patternTypes,    // Empty = all types
    @Default(0.05) double significanceThreshold,    // p-value threshold
    @Default(5) int minimumOccurrences,             // Min data points needed
    @Default(true) bool includeTemporalPatterns,    // Day-of-week, time-of-day
    @Default(true) bool includeCyclicalPatterns,    // Menstrual, flare cycles
    @Default(true) bool includeSequentialPatterns,  // Trigger→outcome sequences
  }) = _DetectPatternsInput;
}

/// Input for trigger correlation analysis
@freezed
class AnalyzeTriggersInput with _$AnalyzeTriggersInput {
  const factory AnalyzeTriggersInput({
    required String profileId,
    required String conditionId,                    // Which condition to analyze
    required int startDate,                         // Epoch milliseconds
    required int endDate,                           // Epoch milliseconds
    @Default([6, 12, 24, 48, 72]) List<int> timeWindowsHours,  // Lag windows to check
    @Default(0.05) double significanceThreshold,    // p-value for correlation
    @Default(10) int minimumOccurrences,            // Min co-occurrences needed
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
    @Default([]) List<InsightCategory> insightTypes, // Empty = all types
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

## 7.6 Wearable Integration Contracts (Phase 4)

For complete specifications, see [43_WEARABLE_INTEGRATION.md](43_WEARABLE_INTEGRATION.md).

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

enum WearablePlatform {
  healthkit,   // Apple HealthKit (iOS/watchOS)
  googlefit,   // Google Fit (Android)
  fitbit,      // Fitbit Web API
  garmin,      // Garmin Connect
  oura,        // Oura Ring
  whoop,       // WHOOP
}
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
  }) = _ConnectWearableInput;

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
    required WearablePlatform platform,
    int? sinceEpoch,                     // Epoch ms, null for full sync
  }) = _SyncWearableDataInput;

  factory SyncWearableDataInput.fromJson(Map<String, dynamic> json) =>
      _$SyncWearableDataInputFromJson(json);
}

@freezed
class SyncWearableDataOutput with _$SyncWearableDataOutput {
  const factory SyncWearableDataOutput({
    required int recordsImported,
    required int recordsSkipped,
    required List<String> errors,
    required int syncedAtEpoch,           // Epoch milliseconds
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

## 7.7 Diet Management Use Cases (Additions)

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
    required List<int> weekdays,                   // [0-6] where 0=Sunday
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

  /// Whether reminder is active today
  bool get isActiveToday => weekdays.contains(DateTime.now().weekday % 7);
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
  Future<Result<bool, AppError>> canReadProfile(String profileId);

  /// Check if current user can write to profile
  Future<Result<bool, AppError>> canWriteProfile(String profileId);

  /// Check if current user owns the profile
  Future<Result<bool, AppError>> isProfileOwner(String profileId);

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

enum AccessLevel {
  readOnly,   // Can view data only
  readWrite,  // Can view and modify data
  owner,      // Full control including deletion and sharing
}
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
  sync(60, Duration(minutes: 1)),              // 60 per minute
  photoUpload(10, Duration(minutes: 1)),      // 10 per minute
  reportGeneration(5, Duration(minutes: 1)),  // 5 per minute
  dataExport(2, Duration(minutes: 1)),        // 2 per minute
  wearableSync(1, Duration(minutes: 5));      // 1 per 5 minutes per platform

  final int maxRequests;
  final Duration window;

  const RateLimitOperation(this.maxRequests, this.window);
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
  const factory AuditLogEntry({
    required String id,
    required String userId,
    required String profileId,
    required AuditEventType eventType,
    required int timestamp,       // Epoch milliseconds
    required String deviceId,
    String? entityType,
    String? entityId,
    String? ipAddress,
    Map<String, dynamic>? metadata,
  }) = _AuditLogEntry;

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditLogEntryFromJson(json);
}

enum AuditEventType {
  // Data operations (PHI)
  dataAccess,             // Read PHI
  dataModify,             // Create/update PHI
  dataDelete,             // Delete PHI
  dataExport,             // Export to file/external
  dataSync,               // PHI synced to cloud storage (Google Drive/iCloud)

  // Authorization
  authorizationGrant,     // Share profile access
  authorizationRevoke,    // Revoke profile access
  authorizationDenied,    // Failed access attempt (access denied)
  profileShare,           // Share profile via QR
  reportGenerate,         // Generate PDF report

  // Authentication
  login,                  // Successful authentication
  logout,                 // User sign out
  authenticationFailed,   // Failed login attempt
  passwordChanged,        // Password reset/change

  // Token operations
  tokenRefresh,           // Refresh token used
  tokenRevoke,            // Token invalidated

  // Device management
  deviceRegistration,     // New device registered
  deviceRemoval,          // Device removed/deactivated
  sessionTermination,     // Session ended (timeout or forced)

  // Security events
  encryptionKeyRotation,  // Encryption key rotated
  rateLimitExceeded,      // Rate limit violation
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
Future<void> accessSharedProfile(String profileId, String authorizationId) async {
  // 1. Validate authorization exists and is not expired
  final auth = await hipaaAuthorizationRepo.getById(authorizationId);
  if (auth == null || auth.isExpired) {
    await auditLogService.logAccess(AuditLogEntry(
      eventType: AuditEventType.authorizationDenied,
      profileId: profileId,
      // ... other fields
    ));
    throw AccessDeniedException();
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
}
```

---

## 10. Missing Entity Contracts

### 10.1 ConditionCategory Entity

```dart
@freezed
class ConditionCategory with _$ConditionCategory {
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

/// Duration options for HIPAA authorization
enum AuthorizationDuration {
  untilRevoked(0),   // No expiration, revoke manually
  days30(1),         // 30 days
  days90(2),         // 90 days
  days180(3),        // 180 days
  days365(4);        // 1 year

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
```

### 10.4 ProfileAccessLog Entity

```dart
/// Audit log for shared profile access (HIPAA requirement)
/// Matches database table: profile_access_logs
@freezed
class ProfileAccessLog with _$ProfileAccessLog {
  const factory ProfileAccessLog({
    required String id,
    required String authorizationId,       // Reference to HipaaAuthorization
    required String profileId,
    required String accessedByUserId,      // User who accessed
    required String accessedByDeviceId,    // Device used for access
    required ProfileAccessAction action,   // What action was performed
    required String entityType,            // Type of entity accessed
    String? entityId,                      // Specific entity if applicable
    required int accessedAt,               // Epoch milliseconds
    required String ipAddress,             // Required for HIPAA audit
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
abstract class FoodItemCategoryRepository implements EntityRepository<FoodItemCategory, String> {
  Future<Result<List<FoodItemCategory>, AppError>> getAll();
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

  final int value;
  const ProfileAccessAction(this.value);
}
```

### 10.5 ImportedDataLog Entity

```dart
@freezed
class ImportedDataLog with _$ImportedDataLog {
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
    required SyncMetadata syncMetadata,
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
}
```

### 10.8 Condition Entity (P0 - Core)

```dart
enum ConditionStatus { active, resolved }

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
  List<String> get triggerList => triggers?.split(',').map((t) => t.trim()).toList() ?? [];
}

abstract class ConditionLogRepository implements EntityRepository<ConditionLog, String> {
  Future<Result<List<ConditionLog>, AppError>> getByCondition(
    String conditionId, {
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
  missed(3);

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
    required SyncMetadata syncMetadata,
  }) = _IntakeLog;

  factory IntakeLog.fromJson(Map<String, dynamic> json) =>
      _$IntakeLogFromJson(json);

  bool get isTaken => status == IntakeLogStatus.taken;
  bool get isPending => status == IntakeLogStatus.pending;
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
  Future<Result<void, AppError>> markTaken(String id, int actualTime);  // Epoch ms
  Future<Result<void, AppError>> markSkipped(String id, String? reason);
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
    int limit = 20,
  });
  Future<Result<void, AppError>> archive(String id);
}
```

### 10.12 FoodLog Entity (P0 - Food)

```dart
@freezed
class FoodLog with _$FoodLog {
  const FoodLog._();

  const factory FoodLog({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp,               // Epoch milliseconds
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
}
```

### 10.13 Activity Entity (P1)

```dart
// lib/domain/entities/activity.dart

@freezed
class Activity with _$Activity implements Syncable {
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

  const SleepEntry._();

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
  const factory JournalEntry({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp,          // Epoch milliseconds
    required String content,
    String? title,
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
    int? limit,
    int? offset,
  });
  Future<Result<List<JournalEntry>, AppError>> search(
    String profileId,
    String query,
  );
}
```

### 10.17 PhotoArea Entity (P1)

```dart
// lib/domain/entities/photo_area.dart

@freezed
class PhotoArea with _$PhotoArea implements Syncable {
  const factory PhotoArea({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    String? consistencyNotes,        // Guidance for consistent photo positioning
    required SyncMetadata syncMetadata,
  }) = _PhotoArea;

  factory PhotoArea.fromJson(Map<String, dynamic> json) =>
      _$PhotoAreaFromJson(json);
}

abstract class PhotoAreaRepository implements EntityRepository<PhotoArea, String> {
  Future<Result<List<PhotoArea>, AppError>> getByProfile(String profileId);
}
```

### 10.18 PhotoEntry Entity (P1)

```dart
// lib/domain/entities/photo_entry.dart

@freezed
class PhotoEntry with _$PhotoEntry implements Syncable {
  const factory PhotoEntry({
    required String id,
    required String clientId,
    required String profileId,
    required String areaId,
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
    String areaId, {
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
  const factory FlareUp({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp,          // Epoch milliseconds
    required String conditionId,
    String? activityId,              // Activity that may have triggered flare-up
    required List<String> triggers,  // Trigger descriptions
    required int severity,           // 1-10 scale
    String? notes,
    String? photoPath,
    required SyncMetadata syncMetadata,
  }) = _FlareUp;

  factory FlareUp.fromJson(Map<String, dynamic> json) =>
      _$FlareUpFromJson(json);
}

abstract class FlareUpRepository implements EntityRepository<FlareUp, String> {
  Future<Result<List<FlareUp>, AppError>> getByCondition(
    String conditionId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    int? limit,
    int? offset,
  });
  Future<Result<List<FlareUp>, AppError>> getByProfile(
    String profileId, {
    int? startDate,      // Epoch ms
    int? endDate,        // Epoch ms
    int? limit,
    int? offset,
  });
  Future<Result<Map<String, int>, AppError>> getTriggerCounts(
    String conditionId, {
    required int startDate,  // Epoch ms
    required int endDate,    // Epoch ms
  });
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

  bool get isStale => DateTime.now().difference(
    DateTime.fromMillisecondsSinceEpoch(lastSeenAt)
  ).inDays > 30;
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
    int limit = 20,
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

---

## 11. Enforcement Mechanisms

### 8.1 Custom Lint Rules

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

### 8.2 Pre-commit Checks

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
@freezed
class QueuedNotification with _$QueuedNotification {
  const factory QueuedNotification({
    required String id,
    required NotificationType type,
    required int originalScheduledTime,  // Epoch milliseconds
    required int queuedAt,               // Epoch milliseconds
    required Map<String, dynamic> payload,
  }) = _QueuedNotification;

  factory QueuedNotification.fromJson(Map<String, dynamic> json) =>
      _$QueuedNotificationFromJson(json);
}

class QuietHoursQueueService {
  /// Queue a notification for delivery after quiet hours
  Future<void> queue(QueuedNotification notification) async {
    await _queuedNotificationsTable.insert(notification);
  }

  /// Process queue when quiet hours end
  Future<void> processQueue() async {
    final queued = await _queuedNotificationsTable.getAll();

    // Sort by original scheduled time (oldest first)
    queued.sort((a, b) => a.originalScheduledTime.compareTo(b.originalScheduledTime));

    // Collapse duplicates of same type within 15 minutes
    final collapsed = _collapseDuplicates(queued);

    // Discard stale notifications (> 24 hours old)
    final fresh = collapsed.where((n) =>
      DateTime.now().difference(n.originalScheduledTime).inHours < 24
    );

    // Deliver with 2-second spacing to avoid flood
    for (final notification in fresh) {
      await _notificationService.showNow(notification);
      await Future.delayed(Duration(seconds: 2));
    }

    await _queuedNotificationsTable.deleteAll();
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
          type: entry.key,
          originalScheduledTime: entry.value.first.originalScheduledTime,
          queuedAt: DateTime.now(),
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
  bool shouldShowSyncReminder(String profileId) {
    final lastSyncTime = getLastSyncTime(profileId);
    if (lastSyncTime == null) {
      // Never synced - remind after 24 hours of app usage
      final firstUse = getFirstUseTime(profileId);
      return DateTime.now().difference(firstUse).inHours >= 24;
    }

    // Remind if not synced in 7+ days
    return DateTime.now().difference(lastSyncTime).inDays >= syncReminderDays;
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
| weekdays (each value) | 0 | 6 | 0=Sunday |
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
Future<List<FoodLog>> getLogsForDate(String profileId, int date) {  // Epoch ms
  // Calculate end of day (24 hours later)
  final endOfDay = date + (24 * 60 * 60 * 1000);  // +24 hours in ms

  return query(
    'SELECT * FROM food_logs WHERE profile_id = ? AND timestamp >= ? AND timestamp < ?',
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
| brand | brand | String | TEXT | Direct |
| ingredients | ingredients | List<String> | TEXT | JSON array |
| form | form | SupplementForm | TEXT | .name |
| customForm | custom_form | String? | TEXT | Direct |
| dosageQuantity | dosage_quantity | int | INTEGER | Direct |
| dosageUnit | dosage_unit | DosageUnit? | TEXT | .name |
| anchorEvents | anchor_events | List<AnchorEvent> | TEXT | Comma-separated names |
| timingType | timing_type | TimingType | INTEGER | .value |
| offsetMinutes | offset_minutes | int? | INTEGER | Direct |
| specificTimeMinutes | specific_time_minutes | int? | INTEGER | Minutes from midnight |
| frequencyType | frequency_type | FrequencyType | INTEGER | .value |
| everyXDays | every_x_days | int? | INTEGER | Direct |
| weekdays | weekdays | List<int>? | TEXT | Comma-separated |
| startDate | start_date | int? | INTEGER | Epoch ms |
| endDate | end_date | int? | INTEGER | Epoch ms |
| isArchived | is_archived | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See below |

### 13.3 FluidsEntry Entity ↔ fluids_entries Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | Direct |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| waterIntakeMl | water_intake_ml | int? | INTEGER | Direct |
| waterIntakeNotes | water_intake_notes | String? | TEXT | Direct |
| hasBowelMovement | has_bowel_movement | bool | INTEGER | 0/1 |
| bowelCondition | bowel_condition | BowelCondition? | INTEGER | .value |
| bowelCustomCondition | bowel_custom_condition | String? | TEXT | Direct |
| bowelSize | bowel_size | MovementSize? | INTEGER | .value |
| bowelPhotoPath | bowel_photo_path | String? | TEXT | Direct |
| hasUrineMovement | has_urine_movement | bool | INTEGER | 0/1 |
| urineCondition | urine_condition | UrineCondition? | INTEGER | .value |
| urineCustomCondition | urine_custom_condition | String? | TEXT | Direct |
| urineSize | urine_size | MovementSize? | INTEGER | .value |
| urinePhotoPath | urine_photo_path | String? | TEXT | Direct |
| menstruationFlow | menstruation_flow | MenstruationFlow? | INTEGER | .value |
| basalBodyTemperature | basal_body_temperature | double? | REAL | Direct (°F) |
| bbtRecordedTime | bbt_recorded_time | int? | INTEGER | Epoch ms |
| otherFluidName | other_fluid_name | String? | TEXT | Direct |
| otherFluidAmount | other_fluid_amount | String? | TEXT | Direct |
| otherFluidNotes | other_fluid_notes | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See below |

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

### 13.5 DietRule Entity ↔ diet_rules Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| dietId | diet_id | String | TEXT | FK to diets |
| ruleType | rule_type | DietRuleType | INTEGER | .value |
| category | category | FoodCategory? | INTEGER | .value |
| maxValue | max_value | double? | REAL | Direct |
| unit | unit | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See below |

### 13.6 DietViolation Entity ↔ diet_violations Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | Direct |
| dietId | diet_id | String | TEXT | FK to diets |
| ruleId | rule_id | String | TEXT | FK to diet_rules |
| foodLogId | food_log_id | String | TEXT | FK to food_logs |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| severity | severity | ViolationSeverity | INTEGER | .value |
| notes | notes | String? | TEXT | Direct |
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
| ownerId | owner_id | String | TEXT | FK to user_accounts |
| displayName | display_name | String | TEXT | Direct |
| dateOfBirth | date_of_birth | int? | INTEGER | Epoch ms |
| avatarPath | avatar_path | String? | TEXT | Direct |
| dietType | diet_type | DietType? | INTEGER | .value |
| dietDescription | diet_description | String? | TEXT | Direct |
| cloudStorageUrl | cloud_storage_url | String? | TEXT | Avatar file sync |
| fileHash | file_hash | String? | TEXT | SHA-256 hash |
| isFileUploaded | is_file_uploaded | bool | INTEGER | 0/1 |
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
| userId | user_id | String | TEXT | FK to user_accounts |
| deviceId | device_id | String | TEXT | Unique device identifier |
| deviceName | device_name | String | TEXT | User-friendly name |
| platform | platform | String | TEXT | 'ios' \| 'android' \| 'macos' \| 'web' |
| pushToken | push_token | String? | TEXT | FCM/APNs token |
| registeredAt | registered_at | int | INTEGER | Epoch ms |
| lastSeenAt | last_seen_at | int | INTEGER | Epoch ms |
| isActive | is_active | bool | INTEGER | 0/1 |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

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
| servingSize | serving_size | double? | REAL | Direct |
| servingUnit | serving_unit | String? | TEXT | Direct |
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
| audioUrl | audio_url | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.19 Document Entity ↔ documents Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| filename | filename | String | TEXT | Direct |
| type | type | DocumentType | INTEGER | .value (0=medical, 1=prescription, 2=lab, 3=other) |
| description | description | String? | TEXT | Direct |
| uploadedAt | uploaded_at | int | INTEGER | Epoch ms |
| localPath | local_path | String | TEXT | Direct |
| cloudUrl | cloud_url | String? | TEXT | Direct |
| fileSizeBytes | file_size_bytes | int? | INTEGER | Direct |
| mimeType | mime_type | String? | TEXT | Direct |
| tags | tags | String? | TEXT | Comma-separated |
| cloudStorageUrl | cloud_storage_url | String? | TEXT | File sync |
| fileHash | file_hash | String? | TEXT | SHA-256 hash |
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
| description | description | String? | TEXT | Direct |
| baselinePhotoPath | baseline_photo_path | String? | TEXT | Direct |
| startTimeframe | start_timeframe | int | INTEGER | Epoch ms |
| endDate | end_date | int? | INTEGER | Epoch ms |
| status | status | ConditionStatus | TEXT | 'active' \| 'resolved' |
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
| timestamp | timestamp | int | INTEGER | Epoch ms |
| conditionId | condition_id | String | TEXT | FK to conditions |
| activityId | activity_id | String? | TEXT | FK to activities |
| triggers | triggers | List<String> | TEXT | JSON array |
| severity | severity | int | INTEGER | 1-10 scale |
| notes | notes | String? | TEXT | Direct |
| photoPath | photo_path | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.23 ConditionCategory Entity ↔ condition_categories Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| name | name | String | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.24 PhotoArea Entity ↔ photo_areas Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| name | name | String | TEXT | Direct |
| consistencyNotes | consistency_notes | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.25 PhotoEntry Entity ↔ photo_entries Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| areaId | area_id | String | TEXT | FK to photo_areas |
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
| patternType | pattern_type | PatternType | INTEGER | .value (0=temporal, 1=cyclical, 2=sequential, 3=cluster, 4=dosage) |
| entityType | entity_type | String | TEXT | Direct |
| entityId | entity_id | String? | TEXT | Direct |
| data | data_json | Map<String, dynamic> | TEXT | JSON encoded |
| confidence | confidence | double | REAL | 0.0-1.0 |
| sampleSize | sample_size | int | INTEGER | Direct |
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
| priority | priority | InsightPriority | INTEGER | .value (0=high, 1=medium, 2=low) |
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
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.32 PredictiveAlert Entity ↔ predictive_alerts Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| predictionType | prediction_type | PredictionType | INTEGER | .value (0-5) |
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
| modelType | model_type | MLModelType | TEXT | String name |
| conditionId | condition_id | String? | TEXT | FK to conditions |
| modelPath | model_path | String | TEXT | Direct |
| accuracy | accuracy | double? | REAL | 0.0-1.0 |
| precisionScore | precision_score | double? | REAL | 0.0-1.0 |
| recallScore | recall_score | double? | REAL | 0.0-1.0 |
| trainingSamples | training_samples | int | INTEGER | Direct |
| trainedAt | trained_at | int | INTEGER | Epoch ms |
| lastUsedAt | last_used_at | int? | INTEGER | Epoch ms |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.34 PredictionFeedback Entity ↔ prediction_feedback Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| alertId | alert_id | String | TEXT | FK to predictive_alerts |
| predictionType | prediction_type | PredictionType | INTEGER | .value |
| predictedProbability | predicted_probability | double | REAL | 0.0-1.0 |
| actualOutcome | actual_outcome | int | INTEGER | 0 or 1 |
| predictionWindowHours | prediction_window_hours | int | INTEGER | Direct |
| actualLatencyHours | actual_latency_hours | int? | INTEGER | Direct |
| recordedAt | recorded_at | int | INTEGER | Epoch ms |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.35 WearableConnection Entity ↔ wearable_connections Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| platform | platform | WearablePlatform | TEXT | 'healthkit', 'googlefit', 'fitbit', etc. |
| isConnected | is_connected | bool | INTEGER | 0/1 |
| connectedAt | connected_at | int? | INTEGER | Epoch ms |
| disconnectedAt | disconnected_at | int? | INTEGER | Epoch ms |
| readPermissions | read_permissions | List<String>? | TEXT | JSON array |
| writePermissions | write_permissions | List<String>? | TEXT | JSON array |
| backgroundSyncEnabled | background_sync_enabled | bool | INTEGER | 0/1 |
| lastSyncAt | last_sync_at | int? | INTEGER | Epoch ms |
| lastSyncStatus | last_sync_status | String? | TEXT | Direct |
| oauthRefreshToken | oauth_refresh_token | String? | TEXT | Encrypted |
| syncId | sync_id | String | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.36 ImportedDataLog Entity ↔ imported_data_log Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| platform | platform | WearablePlatform | TEXT | 'healthkit', 'googlefit', etc. |
| externalId | external_id | String? | TEXT | External record ID |
| entityType | entity_type | String | TEXT | Target entity type |
| entityId | entity_id | String | TEXT | FK to target entity |
| importedAt | imported_at | int | INTEGER | Epoch ms |
| dataTimestamp | data_timestamp | int | INTEGER | Original data timestamp (Epoch ms) |

**Note:** No sync metadata - local tracking table only.

### 13.37 FhirExport Entity ↔ fhir_exports Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| exportedAt | exported_at | int | INTEGER | Epoch ms |
| startDate | start_date | int | INTEGER | Epoch ms |
| endDate | end_date | int | INTEGER | Epoch ms |
| resourceTypes | resource_types | List<String> | TEXT | JSON array |
| format | format | String | TEXT | 'json', 'xml', 'ndjson' |
| fileSizeBytes | file_size_bytes | int? | INTEGER | Direct |
| resourceCount | resource_count | int? | INTEGER | Direct |
| exportPath | export_path | String? | TEXT | Direct |

**Note:** No sync metadata - local export history only.

### 13.38 HipaaAuthorization Entity ↔ hipaa_authorizations Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| grantedToUserId | granted_to_user_id | String | TEXT | FK to user_accounts |
| grantedByUserId | granted_by_user_id | String | TEXT | FK to user_accounts |
| accessLevel | access_level | AccessLevel | TEXT | 'read_only' \| 'read_write' |
| scopes | scope | List<DataScope> | TEXT | JSON array |
| purpose | purpose | String | TEXT | Direct |
| duration | duration | AuthorizationDuration | INTEGER | .value (0-4) |
| authorizedAt | authorized_at | int | INTEGER | Epoch ms |
| expiresAt | expires_at | int? | INTEGER | Epoch ms |
| revokedAt | revoked_at | int? | INTEGER | Epoch ms |
| revocationReason | revocation_reason | String? | TEXT | Direct |
| signatureDeviceId | signature_device_id | String | TEXT | Direct |
| signatureIpAddress | signature_ip_address | String | TEXT | Direct |
| photosIncluded | photos_included | bool | INTEGER | 0/1 |
| syncId | sync_id | String | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

### 13.39 ProfileAccessLog Entity ↔ profile_access_logs Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| authorizationId | authorization_id | String | TEXT | FK to hipaa_authorizations |
| profileId | profile_id | String | TEXT | FK to profiles |
| accessedByUserId | accessed_by_user_id | String | TEXT | FK to user_accounts |
| accessedByDeviceId | accessed_by_device_id | String | TEXT | Direct |
| action | action | ProfileAccessAction | INTEGER | .value (0=view, 1=export, 2=addEntry, 3=editEntry) |
| entityType | entity_type | String | TEXT | Direct |
| entityId | entity_id | String? | TEXT | Direct |
| accessedAt | accessed_at | int | INTEGER | Epoch ms |
| ipAddress | ip_address | String | TEXT | Direct |

**Note:** No sync metadata - audit log is immutable local storage only.

### 13.40 AuditLog Entity ↔ audit_logs Table

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| userId | user_id | String | TEXT | FK to user_accounts |
| profileId | profile_id | String | TEXT | FK to profiles |
| eventType | event_type | AuditEventType | INTEGER | Enum .value |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| deviceId | device_id | String | TEXT | Direct |
| entityType | entity_type | String? | TEXT | Direct |
| entityId | entity_id | String? | TEXT | Direct |
| ipAddress | ip_address | String? | TEXT | Direct |
| metadata | metadata | Map<String, dynamic>? | TEXT | JSON encoded |

**Note:** No sync metadata - audit logs are immutable, never deleted, stored locally only for HIPAA compliance.

### 13.41 BowelUrineLog Entity ↔ bowel_urine_logs Table (Legacy)

| Entity Field | DB Column | Entity Type | DB Type | Conversion |
|--------------|-----------|-------------|---------|------------|
| id | id | String | TEXT | Direct |
| clientId | client_id | String | TEXT | Direct |
| profileId | profile_id | String | TEXT | FK to profiles |
| timestamp | timestamp | int | INTEGER | Epoch ms |
| typeId | type_id | String | TEXT | Direct |
| note | note | String? | TEXT | Direct |
| syncMetadata | sync_* | SyncMetadata | 9 columns | See 13.7 |

**Note:** Legacy table for backward compatibility. New code should use fluids_entries.

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
| 39 | audit_logs | AuditLog | 13.40 |
| 40 | refresh_token_usage | (Security infrastructure) | 10_DATABASE_SCHEMA.md §15.1 |
| 41 | pairing_sessions | PairingSession | 35_QR_DEVICE_PAIRING.md |

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
    final oldNotification = QueuedNotification(
      originalScheduledTime: DateTime.now().subtract(Duration(hours: 25)),
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

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-01-31 | Added Intelligence System contracts (Pattern, TriggerCorrelation, HealthInsight, PredictiveAlert entities, repositories, use cases) |
| 1.2 | 2026-02-01 | Added 6 missing entity contracts: UserAccount, DeviceRegistration, Document, MLModel, PredictionFeedback, BowelUrineLog (Round 5 Audit) |
| 1.3 | 2026-02-01 | Added complete error factory methods for all error types; added comprehensive notification type documentation with snooze behavior; added Section 12 Behavioral Specifications resolving all ambiguities (Round 7 Audit) |
| 1.4 | 2026-02-01 | Converted ALL use case inputs to @freezed format; Added Section 13 Entity-Database Alignment Reference; Added Section 14 Test Scenarios for Behavioral Specifications (Complete 100% Audit) |
