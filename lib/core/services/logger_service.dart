// lib/core/services/logger_service.dart - SHADOW-010 Implementation
// Implements structured logging per 05_IMPLEMENTATION_ROADMAP.md Section 2.2

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Structured logging service with scoped loggers for per-class logging.
///
/// Provides different log levels for debug vs release builds:
/// - Debug: All logs (debug, info, warning, error)
/// - Release: Info and above only
///
/// Usage:
/// ```dart
/// // Global logger
/// logger.info('Application started');
///
/// // Scoped logger for a specific class
/// static final _log = logger.scope('MyClass');
/// _log.debug('Processing started');
/// ```
///
/// IMPORTANT: Never log PII (Personally Identifiable Information).
/// See 11_SECURITY_GUIDELINES.md for logging restrictions.
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  late final Logger _logger;

  /// Returns the singleton instance of LoggerService.
  factory LoggerService() => _instance;

  LoggerService._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      // Debug mode: show all logs; Release mode: info and above
      level: kDebugMode ? Level.debug : Level.info,
    );
  }

  /// Logs a debug message.
  ///
  /// Only visible in debug builds.
  /// Use for detailed diagnostic information during development.
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an info message.
  ///
  /// Visible in both debug and release builds.
  /// Use for general operational information.
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message.
  ///
  /// Visible in both debug and release builds.
  /// Use for potentially harmful situations that don't prevent operation.
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an error message.
  ///
  /// Visible in both debug and release builds.
  /// Use for error conditions that may require attention.
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Creates a scoped logger for a specific class or module.
  ///
  /// The scope name is prepended to all log messages from the returned logger.
  ///
  /// Usage:
  /// ```dart
  /// class SupplementRepository {
  ///   static final _log = logger.scope('SupplementRepository');
  ///
  ///   Future<void> save(Supplement supplement) async {
  ///     _log.debug('Saving supplement: ${supplement.id}');
  ///   }
  /// }
  /// ```
  ScopedLogger scope(String scope) => ScopedLogger(scope, this);
}

/// A logger scoped to a specific class or module.
///
/// All log messages are automatically prefixed with the scope name,
/// making it easy to filter and identify log sources.
class ScopedLogger {
  /// The scope name (typically the class name).
  final String scope;
  final LoggerService _logger;

  /// Creates a scoped logger with the given scope name.
  ///
  /// Typically created via [LoggerService.scope] rather than directly.
  ScopedLogger(this.scope, this._logger);

  /// Logs a debug message with the scope prefix.
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.debug('[$scope] $message', error, stackTrace);
  }

  /// Logs an info message with the scope prefix.
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.info('[$scope] $message', error, stackTrace);
  }

  /// Logs a warning message with the scope prefix.
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.warning('[$scope] $message', error, stackTrace);
  }

  /// Logs an error message with the scope prefix.
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.error('[$scope] $message', error, stackTrace);
  }
}

/// Global logger instance for convenient access throughout the application.
///
/// Usage:
/// ```dart
/// import 'package:shadow_app/core/services/logger_service.dart';
///
/// // Direct logging
/// logger.info('Application started');
///
/// // Scoped logging (recommended for classes)
/// static final _log = logger.scope('MyClass');
/// _log.debug('Processing item');
/// ```
final logger = LoggerService();
