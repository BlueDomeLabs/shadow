// test/unit/core/services/logger_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/services/logger_service.dart';

void main() {
  group('LoggerService', () {
    test('is a singleton', () {
      final logger1 = LoggerService();
      final logger2 = LoggerService();

      expect(identical(logger1, logger2), isTrue);
    });

    test('global logger instance is the singleton', () {
      expect(identical(logger, LoggerService()), isTrue);
    });

    group('log methods exist and are callable', () {
      // Note: We can't easily verify log output in unit tests
      // These tests verify the methods exist and don't throw

      test('debug() is callable', () {
        expect(() => logger.debug('test message'), returnsNormally);
      });

      test('info() is callable', () {
        expect(() => logger.info('test message'), returnsNormally);
      });

      test('warning() is callable', () {
        expect(() => logger.warning('test message'), returnsNormally);
      });

      test('error() is callable', () {
        expect(() => logger.error('test message'), returnsNormally);
      });

      test('debug() with error parameter is callable', () {
        expect(
          () => logger.debug('test message', Exception('test')),
          returnsNormally,
        );
      });

      test('error() with error and stackTrace is callable', () {
        expect(
          () => logger.error(
            'test message',
            Exception('test'),
            StackTrace.current,
          ),
          returnsNormally,
        );
      });
    });

    group('scope()', () {
      test('returns a ScopedLogger', () {
        final scopedLogger = logger.scope('TestClass');

        expect(scopedLogger, isA<ScopedLogger>());
      });

      test('returned ScopedLogger has correct scope', () {
        final scopedLogger = logger.scope('MyScope');

        expect(scopedLogger.scope, equals('MyScope'));
      });
    });
  });

  group('ScopedLogger', () {
    late ScopedLogger scopedLogger;

    setUp(() {
      scopedLogger = logger.scope('TestScope');
    });

    test('scope property returns the scope name', () {
      expect(scopedLogger.scope, equals('TestScope'));
    });

    group('log methods exist and are callable', () {
      test('debug() is callable', () {
        expect(() => scopedLogger.debug('test message'), returnsNormally);
      });

      test('info() is callable', () {
        expect(() => scopedLogger.info('test message'), returnsNormally);
      });

      test('warning() is callable', () {
        expect(() => scopedLogger.warning('test message'), returnsNormally);
      });

      test('error() is callable', () {
        expect(() => scopedLogger.error('test message'), returnsNormally);
      });

      test('debug() with error parameter is callable', () {
        expect(
          () => scopedLogger.debug('test message', Exception('test')),
          returnsNormally,
        );
      });

      test('error() with error and stackTrace is callable', () {
        expect(
          () => scopedLogger.error(
            'test message',
            Exception('test'),
            StackTrace.current,
          ),
          returnsNormally,
        );
      });
    });

    test('multiple scoped loggers can coexist', () {
      final logger1 = logger.scope('Scope1');
      final logger2 = logger.scope('Scope2');

      expect(logger1.scope, equals('Scope1'));
      expect(logger2.scope, equals('Scope2'));
      expect(logger1.scope, isNot(equals(logger2.scope)));
    });
  });
}
