// lib/core/errors/app_error.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md
// All error types consolidated into single file (Dart sealed class requirement)

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
  bool get isRecoverable;

  /// The recommended action to recover from this error
  RecoveryAction get recoveryAction;
}

// =============================================================================
// DatabaseError
// =============================================================================

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

  static const String codeQueryFailed = 'DB_QUERY_FAILED';
  static const String codeInsertFailed = 'DB_INSERT_FAILED';
  static const String codeUpdateFailed = 'DB_UPDATE_FAILED';
  static const String codeDeleteFailed = 'DB_DELETE_FAILED';
  static const String codeNotFound = 'DB_NOT_FOUND';
  static const String codeMigrationFailed = 'DB_MIGRATION_FAILED';
  static const String codeConnectionFailed = 'DB_CONNECTION_FAILED';
  static const String codeConstraintViolation = 'DB_CONSTRAINT_VIOLATION';

  factory DatabaseError.queryFailed(
    String details, [
    dynamic error,
    StackTrace? stack,
  ]) => DatabaseError._(
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

  factory DatabaseError.insertFailed(
    String table, [
    dynamic error,
    StackTrace? stack,
  ]) => DatabaseError._(
    code: codeInsertFailed,
    message: 'Failed to insert into $table',
    userMessage: 'Unable to save data. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory DatabaseError.updateFailed(
    String table,
    String id, [
    dynamic error,
    StackTrace? stack,
  ]) => DatabaseError._(
    code: codeUpdateFailed,
    message: 'Failed to update $table with id $id',
    userMessage: 'Unable to update data. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory DatabaseError.deleteFailed(
    String table,
    String id, [
    dynamic error,
    StackTrace? stack,
  ]) => DatabaseError._(
    code: codeDeleteFailed,
    message: 'Failed to delete from $table with id $id',
    userMessage: 'Unable to delete data. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory DatabaseError.migrationFailed(
    int fromVersion,
    int toVersion, [
    dynamic error,
    StackTrace? stack,
  ]) => DatabaseError._(
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

  factory DatabaseError.constraintViolation(
    String constraint, [
    dynamic error,
    StackTrace? stack,
  ]) => DatabaseError._(
    code: codeConstraintViolation,
    message: 'Constraint violation: $constraint',
    userMessage: 'This operation violates data constraints.',
    originalError: error,
    stackTrace: stack,
    isRecoverable: false,
    recoveryAction: RecoveryAction.none,
  );
}

// =============================================================================
// AuthError
// =============================================================================

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

  factory AuthError.tokenExpired() => const AuthError._(
    code: codeTokenExpired,
    message: 'Authentication token has expired',
    userMessage: 'Your session has expired. Please sign in again.',
    isRecoverable: true,
    recoveryAction: RecoveryAction.refreshToken,
  );

  factory AuthError.tokenRefreshFailed([dynamic error, StackTrace? stack]) =>
      AuthError._(
        code: codeTokenRefreshFailed,
        message: 'Failed to refresh authentication token',
        userMessage: 'Unable to refresh session. Please sign in again.',
        originalError: error,
        stackTrace: stack,
      );

  factory AuthError.signInFailed(
    String reason, [
    dynamic error,
    StackTrace? stack,
  ]) => AuthError._(
    code: codeSignInFailed,
    message: 'Sign in failed: $reason',
    userMessage: 'Unable to sign in. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory AuthError.signOutFailed([dynamic error, StackTrace? stack]) =>
      AuthError._(
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

// =============================================================================
// NetworkError
// =============================================================================

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

  static const String codeNoConnection = 'NET_NO_CONNECTION';
  static const String codeTimeout = 'NET_TIMEOUT';
  static const String codeServerError = 'NET_SERVER_ERROR';
  static const String codeSslError = 'NET_SSL_ERROR';

  factory NetworkError.noConnection() => const NetworkError._(
    code: codeNoConnection,
    message: 'No network connection available',
    userMessage:
        'No internet connection. Please check your connection and try again.',
    recoveryAction: RecoveryAction.checkConnection,
  );

  factory NetworkError.timeout(
    String operation, [
    Duration? duration,
  ]) => NetworkError._(
    code: codeTimeout,
    message:
        'Network timeout during $operation${duration != null ? ' after ${duration.inSeconds}s' : ''}',
    userMessage: 'The request timed out. Please try again.',
  );

  factory NetworkError.serverError(
    int statusCode,
    String details, [
    dynamic error,
  ]) => NetworkError._(
    code: codeServerError,
    message: 'Server error $statusCode: $details',
    userMessage: 'Server error. Please try again later.',
    originalError: error,
  );

  factory NetworkError.sslError(
    String host, [
    dynamic error,
    StackTrace? stack,
  ]) => NetworkError._(
    code: codeSslError,
    message: 'SSL certificate error for $host',
    userMessage: 'Secure connection failed. Please contact support.',
    originalError: error,
    stackTrace: stack,
    isRecoverable: false,
    recoveryAction: RecoveryAction.contactSupport,
  );
}

// =============================================================================
// ValidationError
// =============================================================================

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

  static const String codeRequired = 'VAL_REQUIRED';
  static const String codeInvalidFormat = 'VAL_INVALID_FORMAT';
  static const String codeOutOfRange = 'VAL_OUT_OF_RANGE';
  static const String codeTooLong = 'VAL_TOO_LONG';
  static const String codeTooShort = 'VAL_TOO_SHORT';
  static const String codeDuplicate = 'VAL_DUPLICATE';
  static const String codeCustomFluidNameRequired =
      'VAL_CUSTOM_FLUID_NAME_REQUIRED';
  static const String codeCustomFluidNameInvalid =
      'VAL_CUSTOM_FLUID_NAME_INVALID';

  factory ValidationError.fromFieldErrors(Map<String, List<String>> errors) {
    final allErrors = errors.values.expand((e) => e).join(', ');
    return ValidationError._(
      code: codeInvalidFormat,
      message: 'Validation failed: $allErrors',
      userMessage: 'Please fix the highlighted fields.',
      fieldErrors: errors,
    );
  }

  factory ValidationError.required(String field) => ValidationError._(
    code: codeRequired,
    message: 'Field "$field" is required',
    userMessage: 'Please fill in the required field.',
    fieldErrors: {
      field: ['This field is required'],
    },
  );

  factory ValidationError.invalidFormat(String field, String expected) =>
      ValidationError._(
        code: codeInvalidFormat,
        message: 'Field "$field" has invalid format. Expected: $expected',
        userMessage: 'Please enter a valid value.',
        fieldErrors: {
          field: ['Invalid format. Expected: $expected'],
        },
      );

  factory ValidationError.outOfRange(String field, num min, num max) =>
      ValidationError._(
        code: codeOutOfRange,
        message: 'Field "$field" must be between $min and $max',
        userMessage: 'Value must be between $min and $max.',
        fieldErrors: {
          field: ['Must be between $min and $max'],
        },
      );

  factory ValidationError.tooLong(String field, int maxLength) =>
      ValidationError._(
        code: codeTooLong,
        message: 'Field "$field" exceeds $maxLength characters',
        userMessage: 'Text is too long. Maximum $maxLength characters.',
        fieldErrors: {
          field: ['Maximum $maxLength characters'],
        },
      );

  factory ValidationError.tooShort(String field, int minLength) =>
      ValidationError._(
        code: codeTooShort,
        message: 'Field "$field" must be at least $minLength characters',
        userMessage: 'Text is too short. Minimum $minLength characters.',
        fieldErrors: {
          field: ['Minimum $minLength characters'],
        },
      );

  factory ValidationError.duplicate(String field, String value) =>
      ValidationError._(
        code: codeDuplicate,
        message: 'Duplicate value "$value" for field "$field"',
        userMessage: 'This value already exists.',
        fieldErrors: {
          field: ['Already exists'],
        },
      );

  factory ValidationError.customFluidNameRequired() => const ValidationError._(
    code: codeCustomFluidNameRequired,
    message: 'Custom fluid name required when providing amount or notes',
    userMessage: 'Please provide a name for the fluid.',
    fieldErrors: {
      'otherFluidName': ['Name required when providing amount or notes'],
    },
  );

  bool hasErrorForField(String field) => fieldErrors.containsKey(field);

  List<String> errorsForField(String field) => fieldErrors[field] ?? [];
}

// =============================================================================
// SyncError
// =============================================================================

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

  static const String codeConflict = 'SYNC_CONFLICT';
  static const String codeUploadFailed = 'SYNC_UPLOAD_FAILED';
  static const String codeDownloadFailed = 'SYNC_DOWNLOAD_FAILED';
  static const String codeQuotaExceeded = 'SYNC_QUOTA_EXCEEDED';
  static const String codeCorruptedData = 'SYNC_CORRUPTED';

  factory SyncError.conflict(
    String entityType,
    String id,
    String localVersion,
    String remoteVersion,
  ) => SyncError._(
    code: codeConflict,
    message:
        'Sync conflict for $entityType $id (local: $localVersion, remote: $remoteVersion)',
    userMessage:
        'A conflict was detected. Please choose which version to keep.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.none,
  );

  factory SyncError.uploadFailed(
    String entityType,
    String id, [
    dynamic error,
    StackTrace? stack,
  ]) => SyncError._(
    code: codeUploadFailed,
    message: 'Failed to upload $entityType $id',
    userMessage: 'Unable to sync data to cloud. Will retry automatically.',
    originalError: error,
    stackTrace: stack,
  );

  factory SyncError.downloadFailed(
    String entityType, [
    dynamic error,
    StackTrace? stack,
  ]) => SyncError._(
    code: codeDownloadFailed,
    message: 'Failed to download $entityType',
    userMessage: 'Unable to fetch data from cloud. Will retry automatically.',
    originalError: error,
    stackTrace: stack,
  );

  factory SyncError.quotaExceeded(int usedBytes, int maxBytes) => SyncError._(
    code: codeQuotaExceeded,
    message:
        'Storage quota exceeded (${usedBytes ~/ 1024 ~/ 1024}MB / ${maxBytes ~/ 1024 ~/ 1024}MB)',
    userMessage:
        'Cloud storage limit reached. Please free up space or upgrade.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.freeStorage,
  );

  factory SyncError.corruptedData(
    String entityType,
    String id,
    String reason,
  ) => SyncError._(
    code: codeCorruptedData,
    message: 'Corrupted data detected in $entityType $id: $reason',
    userMessage: 'Data corruption detected. Please contact support.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.contactSupport,
  );
}

// =============================================================================
// WearableError
// =============================================================================

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

  factory WearableError.platformUnavailable(String platform) => WearableError._(
    code: codePlatformUnavailable,
    message: '$platform is not available on this device',
    userMessage: '$platform is not supported on this device.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.none,
  );

  factory WearableError.connectionFailed(
    String platform, [
    dynamic error,
    StackTrace? stack,
  ]) => WearableError._(
    code: codeConnectionFailed,
    message: 'Failed to connect to $platform',
    userMessage:
        'Unable to connect to $platform. Please check your device settings.',
    originalError: error,
    stackTrace: stack,
  );

  factory WearableError.syncFailed(
    String platform,
    String details, [
    dynamic error,
    StackTrace? stack,
  ]) => WearableError._(
    code: codeSyncFailed,
    message: 'Sync failed with $platform: $details',
    userMessage: 'Unable to sync data from $platform. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory WearableError.dataMappingFailed(
    String platform,
    String dataType, [
    dynamic error,
  ]) => WearableError._(
    code: codeDataMappingFailed,
    message: 'Failed to map $dataType from $platform',
    userMessage: 'Unable to import $dataType data. Format not recognized.',
    originalError: error,
  );

  factory WearableError.quotaExceeded(
    String platform,
    int maxRequests,
    Duration window,
  ) => WearableError._(
    code: codeQuotaExceeded,
    message:
        '$platform API rate limit exceeded ($maxRequests per ${window.inMinutes}min)',
    userMessage: 'Too many requests to $platform. Please wait a few minutes.',
  );

  factory WearableError.permissionDenied(String platform, String permission) =>
      WearableError._(
        code: codePermissionDenied,
        message: '$platform permission denied: $permission',
        userMessage:
            'Permission required for $permission. Please update settings.',
      );
}

// =============================================================================
// DietError
// =============================================================================

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

  static const String codeInvalidRule = 'DIET_INVALID_RULE';
  static const String codeRuleConflict = 'DIET_RULE_CONFLICT';
  static const String codeViolationNotFound = 'DIET_VIOLATION_NOT_FOUND';
  static const String codeComplianceCalculationFailed =
      'DIET_COMPLIANCE_FAILED';
  static const String codeDietNotActive = 'DIET_NOT_ACTIVE';
  static const String codeMultipleActiveDiets = 'DIET_MULTIPLE_ACTIVE';

  factory DietError.ruleConflict(String rule1, String rule2) => DietError._(
    code: codeRuleConflict,
    message: 'Diet rules conflict: $rule1 vs $rule2',
    userMessage: 'These diet rules conflict with each other.',
  );

  factory DietError.multipleActiveDiets() => const DietError._(
    code: codeMultipleActiveDiets,
    message: 'Multiple active diets detected',
    userMessage: 'Only one diet can be active at a time.',
  );

  factory DietError.invalidRule(String ruleType, String reason) => DietError._(
    code: codeInvalidRule,
    message: 'Invalid diet rule $ruleType: $reason',
    userMessage: 'This diet rule is not valid. $reason',
  );

  factory DietError.violationNotFound(String violationId) => DietError._(
    code: codeViolationNotFound,
    message: 'Diet violation $violationId not found',
    userMessage: 'The specified violation record was not found.',
  );

  factory DietError.complianceCalculationFailed(
    String reason, [
    dynamic error,
    StackTrace? stack,
  ]) => DietError._(
    code: codeComplianceCalculationFailed,
    message: 'Failed to calculate compliance: $reason',
    userMessage: 'Unable to calculate diet compliance. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory DietError.dietNotActive(String dietId) => DietError._(
    code: codeDietNotActive,
    message: 'Diet $dietId is not currently active',
    userMessage: 'This diet is not active. Activate it to track compliance.',
  );
}

// =============================================================================
// IntelligenceError
// =============================================================================

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

  static const String codeInsufficientData = 'INTEL_INSUFFICIENT_DATA';
  static const String codeAnalysisFailed = 'INTEL_ANALYSIS_FAILED';
  static const String codePredictionFailed = 'INTEL_PREDICTION_FAILED';
  static const String codeModelNotFound = 'INTEL_MODEL_NOT_FOUND';
  static const String codePatternDetectionFailed = 'INTEL_PATTERN_FAILED';
  static const String codeCorrelationFailed = 'INTEL_CORRELATION_FAILED';

  factory IntelligenceError.insufficientData(
    int required,
    int actual,
  ) => IntelligenceError._(
    code: codeInsufficientData,
    message: 'Insufficient data: need $required days, have $actual',
    userMessage:
        'More data is needed for analysis. Keep tracking for ${required - actual} more days.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.none,
  );

  factory IntelligenceError.modelNotFound(
    String modelType,
  ) => IntelligenceError._(
    code: codeModelNotFound,
    message: 'ML model not found: $modelType',
    userMessage:
        'Prediction model not yet available. Continue tracking to enable predictions.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.none,
  );

  factory IntelligenceError.analysisFailed(
    String analysisType,
    String reason, [
    dynamic error,
    StackTrace? stack,
  ]) => IntelligenceError._(
    code: codeAnalysisFailed,
    message: 'Analysis failed for $analysisType: $reason',
    userMessage: 'Unable to analyze data. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory IntelligenceError.predictionFailed(
    String predictionType, [
    dynamic error,
    StackTrace? stack,
  ]) => IntelligenceError._(
    code: codePredictionFailed,
    message: 'Prediction failed for $predictionType',
    userMessage: 'Unable to generate prediction. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory IntelligenceError.patternDetectionFailed(
    String patternType, [
    dynamic error,
    StackTrace? stack,
  ]) => IntelligenceError._(
    code: codePatternDetectionFailed,
    message: 'Pattern detection failed for $patternType',
    userMessage: 'Unable to detect patterns. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory IntelligenceError.correlationFailed(
    String trigger,
    String outcome, [
    dynamic error,
    StackTrace? stack,
  ]) => IntelligenceError._(
    code: codeCorrelationFailed,
    message: 'Correlation analysis failed between $trigger and $outcome',
    userMessage: 'Unable to analyze correlations. Please try again.',
    originalError: error,
    stackTrace: stack,
  );
}

// =============================================================================
// BusinessError
// =============================================================================

/// BusinessError covers generic business logic violations not specific to a feature domain.
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

  static const String codeInvalidState = 'BUS_INVALID_STATE';
  static const String codeOperationNotAllowed = 'BUS_OPERATION_NOT_ALLOWED';
  static const String codeDependencyConflict = 'BUS_DEPENDENCY_CONFLICT';
  static const String codePreconditionFailed = 'BUS_PRECONDITION_FAILED';
  static const String codeInvariantViolation = 'BUS_INVARIANT_VIOLATION';

  factory BusinessError.invalidState(
    String entity,
    String currentState,
    String requiredState,
  ) => BusinessError._(
    code: codeInvalidState,
    message:
        '$entity is in state "$currentState" but requires "$requiredState"',
    userMessage: 'This operation cannot be performed in the current state.',
  );

  factory BusinessError.operationNotAllowed(String operation, String reason) =>
      BusinessError._(
        code: codeOperationNotAllowed,
        message: 'Operation "$operation" not allowed: $reason',
        userMessage: 'This operation is not allowed. $reason',
      );

  factory BusinessError.dependencyConflict(
    String entity,
    String dependency,
    String reason,
  ) => BusinessError._(
    code: codeDependencyConflict,
    message: 'Cannot modify $entity due to dependency on $dependency: $reason',
    userMessage: 'This item has dependencies that prevent the change.',
  );

  factory BusinessError.preconditionFailed(
    String operation,
    String precondition,
  ) => BusinessError._(
    code: codePreconditionFailed,
    message: 'Precondition failed for $operation: $precondition',
    userMessage: 'Required conditions were not met. $precondition',
  );

  factory BusinessError.invariantViolation(String invariant, String actual) =>
      BusinessError._(
        code: codeInvariantViolation,
        message: 'Invariant violated: expected $invariant, got $actual',
        userMessage: 'An unexpected condition occurred. Please try again.',
      );
}

// =============================================================================
// NotificationError
// =============================================================================

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

  static const String codeScheduleFailed = 'NOTIF_SCHEDULE_FAILED';
  static const String codeCancelFailed = 'NOTIF_CANCEL_FAILED';
  static const String codePermissionDenied = 'NOTIF_PERMISSION_DENIED';
  static const String codeInvalidTime = 'NOTIF_INVALID_TIME';
  static const String codeNotFound = 'NOTIF_NOT_FOUND';
  static const String codePlatformUnsupported = 'NOTIF_PLATFORM_UNSUPPORTED';

  factory NotificationError.scheduleFailed(
    String notificationType, [
    dynamic error,
    StackTrace? stack,
  ]) => NotificationError._(
    code: codeScheduleFailed,
    message: 'Failed to schedule notification: $notificationType',
    userMessage: 'Unable to set reminder. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory NotificationError.cancelFailed(
    String notificationId, [
    dynamic error,
    StackTrace? stack,
  ]) => NotificationError._(
    code: codeCancelFailed,
    message: 'Failed to cancel notification: $notificationId',
    userMessage: 'Unable to remove reminder. Please try again.',
    originalError: error,
    stackTrace: stack,
  );

  factory NotificationError.permissionDenied() => const NotificationError._(
    code: codePermissionDenied,
    message: 'Notification permission denied by user',
    userMessage: 'Notification permission required. Please enable in Settings.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.goToSettings,
  );

  factory NotificationError.invalidTime(String reason) => NotificationError._(
    code: codeInvalidTime,
    message: 'Invalid notification time: $reason',
    userMessage: 'Please select a valid time for the reminder.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.none,
  );

  factory NotificationError.notFound(String scheduleId) => NotificationError._(
    code: codeNotFound,
    message: 'Notification schedule not found: $scheduleId',
    userMessage: 'The reminder was not found.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.none,
  );

  factory NotificationError.platformUnsupported(
    String platform,
    String feature,
  ) => NotificationError._(
    code: codePlatformUnsupported,
    message: '$feature not supported on $platform',
    userMessage: 'This notification feature is not supported on your device.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.none,
  );
}
