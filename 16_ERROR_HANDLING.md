# Shadow Error Handling Strategy

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Centralized error handling patterns and implementation

---

## Overview

This document defines Shadow's error handling architecture, including the Result type pattern, error categorization, user-facing messages, logging strategy, and recovery mechanisms. All error handling must follow these patterns for consistency.

---

## 1. Result Type Pattern

### 1.1 Core Types

All operations that can fail must return a `Result` type instead of throwing exceptions.

> **Usage Convention:** While Result is generic (`Result<T, E>`), all domain operations in Shadow use `Result<T, AppError>` specifically. This ensures consistent error handling throughout the application. See `02_CODING_STANDARDS.md` Section 7 for the canonical usage pattern.

```dart
// lib/core/types/result.dart

/// Sealed class representing either success or failure
/// In practice, always use Result<T, AppError> for domain operations
sealed class Result<T, E> {
  const Result();

  /// Returns true if this is a Success
  bool get isSuccess => this is Success<T, E>;

  /// Returns true if this is a Failure
  bool get isFailure => this is Failure<T, E>;

  /// Gets the value if Success, throws if Failure
  T get value => switch (this) {
    Success(value: final v) => v,
    Failure() => throw StateError('Cannot get value from Failure'),
  };

  /// Gets the error if Failure, throws if Success
  E get error => switch (this) {
    Failure(error: final e) => e,
    Success() => throw StateError('Cannot get error from Success'),
  };

  /// Maps the success value
  Result<U, E> map<U>(U Function(T) transform) => switch (this) {
    Success(value: final v) => Success(transform(v)),
    Failure(error: final e) => Failure(e),
  };

  /// Maps the error value
  Result<T, F> mapError<F>(F Function(E) transform) => switch (this) {
    Success(value: final v) => Success(v),
    Failure(error: final e) => Failure(transform(e)),
  };

  /// Executes onSuccess or onFailure based on result
  U fold<U>(U Function(T) onSuccess, U Function(E) onFailure) => switch (this) {
    Success(value: final v) => onSuccess(v),
    Failure(error: final e) => onFailure(e),
  };
}

/// Represents a successful result
final class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);

  @override
  bool operator ==(Object other) =>
    other is Success<T, E> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Represents a failed result
final class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);

  @override
  bool operator ==(Object other) =>
    other is Failure<T, E> && other.error == error;

  @override
  int get hashCode => error.hashCode;
}

/// Extension for async Result handling
extension AsyncResultExtension<T, E> on Future<Result<T, E>> {
  Future<Result<U, E>> mapAsync<U>(U Function(T) transform) async {
    final result = await this;
    return result.map(transform);
  }
}
```

### 1.2 Unit Type for Void Results

```dart
// lib/core/types/unit.dart

/// Represents "no value" for Result<Unit, E> returns
class Unit {
  const Unit._();
  static const unit = Unit._();

  @override
  bool operator ==(Object other) => other is Unit;

  @override
  int get hashCode => 0;
}

// Usage
Future<Result<Unit, DatabaseError>> deleteEntry(String id);
```

---

## 2. Error Categorization

> **IMPORTANT - Architecture Pattern:**
>
> The **canonical implementation** is in [22_API_CONTRACTS.md](22_API_CONTRACTS.md) Section 2.
>
> **Required Pattern:** Flat hierarchy with factory methods
> - `final class DatabaseError extends AppError` with `DatabaseError.notFound()`, `DatabaseError.queryFailed()`, etc.
> - `final class AuthError extends AppError` with `AuthError.tokenExpired()`, `AuthError.unauthorized()`, etc.
>
> **Property Naming:** The canonical property is `message` (not `technicalMessage`). Examples below use `technicalMessage` for conceptual clarity, but implementations must use `message` per 22_API_CONTRACTS.md.
>
> The code examples below show conceptual patterns. For exact implementation, always reference 22_API_CONTRACTS.md.

### 2.1 Error Type Hierarchy

> **Note:** The canonical AppError definition with exact error codes is in [22_API_CONTRACTS.md](22_API_CONTRACTS.md) Section 2. This section shows the behavioral interface; contracts shows the implementation.

```dart
// lib/core/errors/app_error.dart
// See 22_API_CONTRACTS.md Section 2 for exact implementation with error codes

/// Base class for all application errors
sealed class AppError {
  /// Error code constant (e.g., 'DB_NOT_FOUND', 'AUTH_TOKEN_EXPIRED')
  String get code;

  /// Technical message for logging
  String get message;

  /// User-facing message (localized)
  String get userMessage;

  /// Original exception that caused this error
  dynamic get originalError;

  /// Stack trace for debugging
  StackTrace? get stackTrace;

  /// Whether this error is recoverable
  bool get isRecoverable;

  /// Suggested recovery action
  RecoveryAction get recoveryAction;
}

/// CANONICAL: Must match 22_API_CONTRACTS.md exactly (8 values)
enum RecoveryAction {
  none,           // No recovery possible
  retry,          // User can retry the operation
  refreshToken,   // Need to refresh auth token
  reAuthenticate, // Need full re-authentication
  goToSettings,   // User should go to settings
  contactSupport, // User should contact support
  checkConnection, // User should check network connection
  freeStorage,    // User should free up storage space
}
```

### 2.2 Network Errors

> **CANONICAL SOURCE:** See [22_API_CONTRACTS.md](22_API_CONTRACTS.md) Section 2 for the exact implementation.
> The API Contracts document uses a **flat hierarchy** with factory methods (e.g., `NetworkError.timeout()`, `NetworkError.noInternet()`).
> The code below shows conceptual error handling; implement using the factory pattern from API Contracts.

```dart
// lib/core/errors/network_error.dart
// EXACT IMPLEMENTATION: See 22_API_CONTRACTS.md Section 2.3

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

  // Use factory methods for specific error types
  factory NetworkError.timeout(Duration timeout, [dynamic error, StackTrace? stack]) =>
    NetworkError._(
      code: 'NET_TIMEOUT',
      message: 'Connection timeout after ${timeout.inSeconds}s',
      userMessage: 'Connection timed out. Please try again.',
      originalError: error,
      stackTrace: stack,
    );

  factory NetworkError.noInternet([dynamic error, StackTrace? stack]) =>
    NetworkError._(
      code: 'NET_NO_INTERNET',
      message: 'No network connectivity detected',
      userMessage: 'No internet connection. Your changes are saved locally.',
      originalError: error,
      stackTrace: stack,
      recoveryAction: RecoveryAction.checkConnection,
    );

  factory NetworkError.serverError(int statusCode, [String? serverMessage, dynamic error, StackTrace? stack]) =>
    NetworkError._(
      code: 'NET_SERVER_ERROR',
      message: 'HTTP $statusCode: ${serverMessage ?? "Unknown"}',
      userMessage: 'Server error. Please try again later.',
      originalError: error,
      stackTrace: stack,
      isRecoverable: statusCode >= 500,
    );

  factory NetworkError.rateLimited([Duration? retryAfter, dynamic error, StackTrace? stack]) =>
    NetworkError._(
      code: 'NET_RATE_LIMITED',
      message: 'Rate limited${retryAfter != null ? ", retry after ${retryAfter.inSeconds}s" : ""}',
      userMessage: 'Too many requests. Please wait a moment.',
      originalError: error,
      stackTrace: stack,
    );
}
```

### 2.3 Authentication Errors

> **CANONICAL SOURCE:** See [22_API_CONTRACTS.md](22_API_CONTRACTS.md) Section 2.2 for the exact implementation.

```dart
// lib/core/errors/auth_error.dart
// EXACT IMPLEMENTATION: See 22_API_CONTRACTS.md Section 2.2

final class AuthError extends AppError {

final class TokenExpiredError extends AuthError {
  const TokenExpiredError();

  @override
  String get userMessage => 'Your session has expired. Signing you back in...';

  @override
  String get technicalMessage => 'OAuth access token expired';

  @override
  bool get isRecoverable => true;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.refreshToken;
}

final class TokenInvalidError extends AuthError {
  const TokenInvalidError();

  @override
  String get userMessage => 'Please sign in again to continue.';

  @override
  String get technicalMessage => 'OAuth token invalid or revoked';

  @override
  bool get isRecoverable => true;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.reAuthenticate;
}

final class PermissionDeniedError extends AuthError {
  final String? resource;

  const PermissionDeniedError([this.resource]);

  @override
  String get userMessage => 'You don\'t have permission to access this.';

  @override
  String get technicalMessage => 'Permission denied${resource != null ? " for $resource" : ""}';

  @override
  bool get isRecoverable => false;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.none;
}

final class ProfileAccessDeniedError extends AuthError {
  final String profileId;

  const ProfileAccessDeniedError(this.profileId);

  @override
  String get userMessage => 'You don\'t have access to this profile.';

  @override
  String get technicalMessage => 'Profile access denied: $profileId';

  @override
  bool get isRecoverable => false;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.none;
}
```

### 2.4 Database Errors

```dart
// lib/core/errors/database_error.dart

sealed class DatabaseError extends AppError {}

final class EntityNotFoundError extends DatabaseError {
  final String entityType;
  final String entityId;

  const EntityNotFoundError(this.entityType, this.entityId);

  @override
  String get userMessage => 'Item not found. It may have been deleted.';

  @override
  String get technicalMessage => '$entityType not found: $entityId';

  @override
  bool get isRecoverable => false;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.none;
}

final class DatabaseWriteError extends DatabaseError {
  final String operation;
  final String? details;

  const DatabaseWriteError(this.operation, [this.details]);

  @override
  String get userMessage => 'Couldn\'t save your changes. Tap to retry.';

  @override
  String get technicalMessage => 'Database $operation failed: ${details ?? "unknown"}';

  @override
  bool get isRecoverable => true;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.retry;
}

final class DatabaseReadError extends DatabaseError {
  final String query;
  final String? details;

  const DatabaseReadError(this.query, [this.details]);

  @override
  String get userMessage => 'Couldn\'t load data. Pull to refresh.';

  @override
  String get technicalMessage => 'Database read failed ($query): ${details ?? "unknown"}';

  @override
  bool get isRecoverable => true;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.retry;
}

final class DatabaseCorruptionError extends DatabaseError {
  const DatabaseCorruptionError();

  @override
  String get userMessage => 'Database error. Please contact support.';

  @override
  String get technicalMessage => 'Database corruption detected';

  @override
  bool get isRecoverable => false;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.contactSupport;
}
```

### 2.5 Validation Errors

**CANONICAL:** See 22_API_CONTRACTS.md Section 2 for authoritative ValidationError definition.

ValidationError uses a flat structure with `fieldErrors` map and error codes:

```dart
// lib/core/errors/validation_error.dart
// CANONICAL DEFINITION - from 22_API_CONTRACTS.md

final class ValidationError extends AppError {
  final Map<String, List<String>> fieldErrors;

  // Standard error codes (use these, not custom subclasses)
  static const String codeRequired = 'VAL_REQUIRED';
  static const String codeInvalidFormat = 'VAL_INVALID_FORMAT';
  static const String codeOutOfRange = 'VAL_OUT_OF_RANGE';
  static const String codeTooLong = 'VAL_TOO_LONG';
  static const String codeTooShort = 'VAL_TOO_SHORT';
  static const String codeDuplicate = 'VAL_DUPLICATE';

  ValidationError({
    required String code,
    required this.fieldErrors,
    String? userMessage,
  }) : super(code: code, userMessage: userMessage ?? _buildMessage(fieldErrors));

  /// Factory for required field errors
  factory ValidationError.required(String fieldName) => ValidationError(
    code: codeRequired,
    fieldErrors: {fieldName: ['$fieldName is required']},
  );

  /// Factory for out-of-range errors (includes BBT, severity, water, etc.)
  factory ValidationError.outOfRange(String fieldName, num value, num min, num max) =>
    ValidationError(
      code: codeOutOfRange,
      fieldErrors: {fieldName: ['$fieldName must be between $min and $max (was $value)']},
    );

  /// Factory for format errors
  factory ValidationError.invalidFormat(String fieldName, String expected) =>
    ValidationError(
      code: codeInvalidFormat,
      fieldErrors: {fieldName: ['Invalid format. Expected: $expected']},
    );

  @override
  bool get isRecoverable => true;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.none; // User must fix input

  static String _buildMessage(Map<String, List<String>> errors) {
    return errors.entries
      .map((e) => '${e.key}: ${e.value.join(", ")}')
      .join('; ');
  }
}
```

**Usage Examples:**

```dart
// BBT validation - use generic outOfRange, not BBTOutOfRangeError
if (temperature < 95.0 || temperature > 105.0) {
  return Failure(ValidationError.outOfRange('temperature', temperature, 95.0, 105.0));
}

// Required field
if (name == null || name.isEmpty) {
  return Failure(ValidationError.required('name'));
}

// Multiple field errors
return Failure(ValidationError(
  code: ValidationError.codeRequired,
  fieldErrors: {
    'email': ['Email is required'],
    'password': ['Password is required', 'Password must be at least 8 characters'],
  },
));
```

### 2.6 Notification Errors

```dart
// lib/core/errors/notification_error.dart

sealed class NotificationError extends AppError {}

final class NotificationPermissionDeniedError extends NotificationError {
  final bool isPermanent;

  const NotificationPermissionDeniedError({this.isPermanent = false});

  @override
  String get userMessage => isPermanent
    ? 'Notifications are disabled. Enable them in Settings.'
    : 'Notification permission required for reminders.';

  @override
  String get technicalMessage =>
    'Notification permission denied (permanent: $isPermanent)';

  @override
  bool get isRecoverable => true;

  @override
  RecoveryAction get recoveryAction =>
    isPermanent ? RecoveryAction.goToSettings : RecoveryAction.retry;
}

final class NotificationScheduleError extends NotificationError {
  final String scheduleId;
  final String? details;

  const NotificationScheduleError(this.scheduleId, [this.details]);

  @override
  String get userMessage => 'Couldn\'t schedule reminder. Please try again.';

  @override
  String get technicalMessage =>
    'Failed to schedule notification $scheduleId: ${details ?? "unknown"}';

  @override
  bool get isRecoverable => true;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.retry;
}

final class NoTimesSelectedError extends NotificationError {
  const NoTimesSelectedError();

  @override
  String get userMessage => 'Please select at least one reminder time.';

  @override
  String get technicalMessage => 'Notification schedule has no times';

  @override
  bool get isRecoverable => true;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.none;
}

final class NoDaysSelectedError extends NotificationError {
  const NoDaysSelectedError();

  @override
  String get userMessage => 'Please select at least one day for reminders.';

  @override
  String get technicalMessage => 'Notification schedule has no days';

  @override
  bool get isRecoverable => true;

  @override
  RecoveryAction get recoveryAction => RecoveryAction.none;
}
```

---

## 3. Error Handling in Layers

### 3.1 Repository Layer

Repositories catch low-level exceptions and return typed Results.

```dart
// lib/data/repositories/fluids_repository_impl.dart

class FluidsRepositoryImpl implements FluidsRepository {
  final FluidsLocalDataSource _localDataSource;

  @override
  Future<Result<FluidsEntry, DatabaseError>> getEntry(String id) async {
    try {
      final entry = await _localDataSource.getEntry(id);
      if (entry == null) {
        return Failure(EntityNotFoundError('FluidsEntry', id));
      }
      return Success(entry);
    } on DatabaseException catch (e) {
      return Failure(DatabaseReadError('getEntry', e.message));
    }
  }

  @override
  Future<Result<Unit, DatabaseError>> saveEntry(FluidsEntry entry) async {
    try {
      await _localDataSource.insertOrUpdate(FluidsModel.fromEntity(entry));
      return const Success(Unit.unit);
    } on DatabaseException catch (e) {
      return Failure(DatabaseWriteError('saveEntry', e.message));
    }
  }
}
```

### 3.2 Use Case Layer

Use cases combine multiple repository calls and handle business logic errors.

```dart
// lib/domain/usecases/save_fluids_entry_usecase.dart

class SaveFluidsEntryUseCase {
  final FluidsRepository _repository;
  final ProfileAuthorizationService _authService;

  Future<Result<FluidsEntry, AppError>> execute(FluidsEntry entry) async {
    // Authorization check
    if (!_authService.canWrite(entry.profileId)) {
      return const Failure(ProfileAccessDeniedError(''));
    }

    // Validation
    final validationError = _validate(entry);
    if (validationError != null) {
      return Failure(validationError);
    }

    // Prepare entry with sync metadata
    final preparedEntry = await _prepareForSave(entry);

    // Save
    final saveResult = await _repository.saveEntry(preparedEntry);

    return saveResult.map((_) => preparedEntry);
  }

  ValidationError? _validate(FluidsEntry entry) {
    if (entry.basalBodyTemperature != null) {
      final temp = entry.basalBodyTemperature!;
      // Use ValidationError.outOfRange per line 478 guidance
      if (temp < 95.0 || temp > 105.0) {
        return ValidationError.outOfRange('basalBodyTemperature', temp, 95.0, 105.0);
      }
    }
    return null;
  }
}
```

### 3.3 Provider Layer (Riverpod)

Providers handle Results and update UI state using Riverpod's AsyncValue.

```dart
// lib/presentation/providers/fluids_provider.dart

@riverpod
class FluidsEntryList extends _$FluidsEntryList {
  static final _log = logger.scope('FluidsEntryList');

  @override
  Future<List<FluidsEntry>> build(String profileId) async {
    final useCase = ref.read(getFluidsEntriesUseCaseProvider);
    final result = await useCase(GetFluidsEntriesInput(profileId: profileId));

    return result.when(
      success: (entries) => entries,
      failure: (error) {
        _log.error('Failed to load fluids entries: ${error.message}');
        throw error;  // AsyncValue.error will hold this
      },
    );
  }

  Future<Result<FluidsEntry, AppError>> saveEntry(LogFluidsEntryInput input) async {
    final useCase = ref.read(logFluidsEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) => ref.invalidateSelf(),  // Refresh list
      failure: (error) => _log.error('Save failed: ${error.technicalMessage}'),
    );

    return result;
  }
}

// Consumer widget handles error display
class FluidsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(fluidsEntryListProvider(profileId));

    return entriesAsync.when(
      data: (entries) => FluidsEntryList(entries: entries),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorDisplay(
        message: error is AppError ? error.userMessage : 'An error occurred',
        recoveryAction: error is AppError ? error.recoveryAction : null,
        onRetry: () => ref.invalidate(fluidsEntryListProvider(profileId)),
      ),
    );
  }
}

/// Generic async state wrapper
sealed class AsyncState<T> {
  const AsyncState();

  const factory AsyncState.loading() = AsyncLoading;
  const factory AsyncState.data(T data) = AsyncData;
  const factory AsyncState.error(String message) = AsyncError;
}

final class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading();
}

final class AsyncData<T> extends AsyncState<T> {
  final T data;
  const AsyncData(this.data);
}

final class AsyncError<T> extends AsyncState<T> {
  final String message;
  const AsyncError(this.message);
}
```

### 3.4 UI Layer

Screens display errors and recovery options.

```dart
// lib/presentation/screens/add_fluids_entry_screen.dart

class AddFluidsEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FluidsProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: Column(
            children: [
              // Error banner
              if (provider.errorMessage != null)
                ErrorBanner(
                  message: provider.errorMessage!,
                  recoveryAction: provider.recoveryAction,
                  onRetry: provider.recoveryAction == RecoveryAction.retry
                    ? () => _retrySave(context)
                    : null,
                  onGoToSettings: provider.recoveryAction == RecoveryAction.goToSettings
                    ? () => _openSettings()
                    : null,
                ),

              // Form content
              Expanded(child: _buildForm()),
            ],
          ),
        );
      },
    );
  }
}
```

---

## 4. Error UI Components

### 4.1 Error Banner Widget

```dart
// lib/presentation/widgets/error_banner.dart

class ErrorBanner extends StatelessWidget {
  final String message;
  final RecoveryAction? recoveryAction;
  final VoidCallback? onRetry;
  final VoidCallback? onGoToSettings;
  final VoidCallback? onDismiss;

  const ErrorBanner({
    required this.message,
    this.recoveryAction,
    this.onRetry,
    this.onGoToSettings,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true, // Announce to screen readers
      child: MaterialBanner(
        content: Text(message),
        backgroundColor: AppColors.error.withOpacity(0.1),
        leading: Icon(Icons.error_outline, color: AppColors.error),
        actions: _buildActions(),
      ),
    );
  }

  List<Widget> _buildActions() {
    final actions = <Widget>[];

    switch (recoveryAction) {
      case RecoveryAction.retry:
        if (onRetry != null) {
          actions.add(TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ));
        }
        break;

      case RecoveryAction.goToSettings:
        if (onGoToSettings != null) {
          actions.add(TextButton(
            onPressed: onGoToSettings,
            child: const Text('Open Settings'),
          ));
        }
        break;

      case RecoveryAction.contactSupport:
        actions.add(TextButton(
          onPressed: () => _launchSupportUrl(),
          child: const Text('Contact Support'),
        ));
        break;

      default:
        break;
    }

    if (onDismiss != null) {
      actions.add(TextButton(
        onPressed: onDismiss,
        child: const Text('Dismiss'),
      ));
    }

    return actions;
  }
}
```

### 4.2 Inline Field Error

```dart
// lib/presentation/widgets/field_error.dart

class FieldError extends StatelessWidget {
  final String? errorMessage;

  const FieldError({this.errorMessage});

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        errorMessage!,
        style: TextStyle(
          color: AppColors.error,
          fontSize: 12,
        ),
        semanticsLabel: 'Error: $errorMessage',
      ),
    );
  }
}
```

---

## 5. Logging Strategy

### 5.1 Log Levels

| Level | Usage | Example |
|-------|-------|---------|
| Debug | Development info | "Parsing BBT: 98.6" |
| Info | User actions | "User saved fluids entry" |
| Warning | Recoverable issues | "Network timeout, retrying" |
| Error | Failures | "Database write failed" |

### 5.2 Structured Logging

```dart
// lib/core/services/error_logger.dart

class ErrorLogger {
  void logError(AppError error, {StackTrace? stackTrace}) {
    final logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'error_type': error.runtimeType.toString(),
      'technical_message': error.technicalMessage,
      'is_recoverable': error.isRecoverable,
      'recovery_action': error.recoveryAction.name,
    };

    logger.error(
      jsonEncode(logEntry),
      error,
      stackTrace,
    );

    // Send to crash reporting (e.g., Firebase Crashlytics)
    if (!error.isRecoverable) {
      _crashReporter.recordError(error, stackTrace);
    }
  }
}
```

---

## 6. Error Matrix

Quick reference for error handling:

| Error Type | User Message | Log Level | Auto-Retry | Recovery UI |
|------------|--------------|-----------|------------|-------------|
| ConnectionTimeout | "Connection timed out..." | Warning | Yes (3x) | Retry button |
| NoInternet | "No internet connection..." | Info | No | None (offline mode) |
| ServerError (5xx) | "Server error..." | Error | Yes (3x) | Retry button |
| TokenExpired | "Session expired..." | Info | Yes (silent) | None |
| TokenInvalid | "Please sign in..." | Warning | No | Sign-in screen |
| EntityNotFound | "Item not found..." | Warning | No | Navigate back |
| DatabaseWrite | "Couldn't save..." | Error | No | Retry button |
| ValidationError | Field-specific | Debug | No | Highlight field |
| BBTOutOfRange | "Temperature must be..." | Debug | No | Highlight field |
| NotificationPermission | "Enable in Settings" | Info | No | Settings button |

---

## 7. Testing Error Handling

### 7.1 Unit Test Pattern

```dart
// test/domain/usecases/save_fluids_entry_usecase_test.dart

void main() {
  group('SaveFluidsEntryUseCase', () {
    test('returns ValidationError when temperature out of range', () async {
      final useCase = SaveFluidsEntryUseCase(mockRepo, mockAuth);
      final entry = FluidsEntry(
        basalBodyTemperature: 94.0, // Too low (valid range: 95-105°F)
        // ... other fields
      );

      final result = await useCase.execute(entry);

      expect(result.isFailure, true);
      expect(result.error, isA<ValidationError>());
      expect(result.error.code, ValidationError.codeOutOfRange);
    });

    test('returns ProfileAccessDeniedError when no write permission', () async {
      when(mockAuth.canWrite(any)).thenReturn(false);

      final result = await useCase.execute(validEntry);

      expect(result.isFailure, true);
      expect(result.error, isA<ProfileAccessDeniedError>());
    });
  });
}
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
