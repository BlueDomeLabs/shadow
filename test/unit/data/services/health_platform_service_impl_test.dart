// test/unit/data/services/health_platform_service_impl_test.dart
// Unit tests for HealthPlatformServiceImpl — Phase 16c
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart' as hp;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/services/health_platform_service_impl.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/health_platform_service.dart';

@GenerateMocks([hp.Health])
import 'health_platform_service_impl_test.mocks.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Creates a minimal HealthDataPoint for a numeric type.
hp.HealthDataPoint _makePoint({
  required hp.HealthDataType type,
  required num value,
  required DateTime dateFrom,
  DateTime? dateTo,
  String sourceName = 'Apple Watch',
}) => hp.HealthDataPoint(
  uuid: 'uuid-1',
  value: hp.NumericHealthValue(numericValue: value),
  type: type,
  unit: hp.HealthDataUnit.BEATS_PER_MINUTE,
  dateFrom: dateFrom,
  dateTo: dateTo ?? dateFrom,
  sourcePlatform: hp.HealthPlatformType.googleHealthConnect,
  sourceDeviceId: 'device-1',
  sourceId: 'source-1',
  sourceName: sourceName,
);

void main() {
  late MockHealth mockHealth;
  late HealthPlatformServiceImpl sut;

  final t0 = DateTime(2025, 1, 15, 10);

  setUp(() {
    mockHealth = MockHealth();
    sut = HealthPlatformServiceImpl(mockHealth);
  });

  // -------------------------------------------------------------------------
  // currentPlatform
  // -------------------------------------------------------------------------

  group('currentPlatform', () {
    test('returns googleHealthConnect on non-iOS platform', () {
      // On macOS (test machine), Platform.isIOS is false.
      expect(
        sut.currentPlatform,
        Platform.isIOS
            ? HealthSourcePlatform.appleHealth
            : HealthSourcePlatform.googleHealthConnect,
      );
    });
  });

  // -------------------------------------------------------------------------
  // isAvailable
  // -------------------------------------------------------------------------

  group('isAvailable', () {
    test('returns false on non-mobile platforms', () async {
      // macOS test machine is not iOS or Android.
      if (!Platform.isIOS && !Platform.isAndroid) {
        final result = await sut.isAvailable();
        expect(result, isFalse);
        verifyNever(mockHealth.isHealthConnectAvailable());
      }
    });
  });

  // -------------------------------------------------------------------------
  // requestPermissions
  // -------------------------------------------------------------------------

  group('requestPermissions', () {
    test(
      'returns Success([]) for empty types without calling platform',
      () async {
        final result = await sut.requestPermissions([]);

        expect(result, isA<Success<List<HealthDataType>, AppError>>());
        expect(result.valueOrNull, isEmpty);
        verifyNever(
          mockHealth.requestAuthorization(
            any,
            permissions: anyNamed('permissions'),
          ),
        );
      },
    );

    test('includes type when hasPermissions returns true', () async {
      when(
        mockHealth.requestAuthorization(
          any,
          permissions: anyNamed('permissions'),
        ),
      ).thenAnswer((_) async => true);
      when(
        mockHealth.hasPermissions(any, permissions: anyNamed('permissions')),
      ).thenAnswer((_) async => true);

      final result = await sut.requestPermissions([HealthDataType.heartRate]);

      expect(result.valueOrNull, equals([HealthDataType.heartRate]));
    });

    test('excludes type when hasPermissions returns false', () async {
      when(
        mockHealth.requestAuthorization(
          any,
          permissions: anyNamed('permissions'),
        ),
      ).thenAnswer((_) async => false);
      when(
        mockHealth.hasPermissions(any, permissions: anyNamed('permissions')),
      ).thenAnswer((_) async => false);

      final result = await sut.requestPermissions([HealthDataType.heartRate]);

      expect(result.valueOrNull, isEmpty);
    });

    test(
      'includes type when hasPermissions returns null (iOS privacy)',
      () async {
        when(
          mockHealth.requestAuthorization(
            any,
            permissions: anyNamed('permissions'),
          ),
        ).thenAnswer((_) async => true);
        when(
          mockHealth.hasPermissions(any, permissions: anyNamed('permissions')),
        ).thenAnswer((_) async => null);

        final result = await sut.requestPermissions([HealthDataType.heartRate]);

        // null means unknown/iOS privacy — treated as granted
        expect(result.valueOrNull, equals([HealthDataType.heartRate]));
      },
    );

    test('returns Failure on exception', () async {
      when(
        mockHealth.requestAuthorization(
          any,
          permissions: anyNamed('permissions'),
        ),
      ).thenThrow(Exception('platform error'));

      final result = await sut.requestPermissions([HealthDataType.heartRate]);

      expect(result, isA<Failure<List<HealthDataType>, AppError>>());
      expect(result.errorOrNull, isA<WearableError>());
    });

    test('grants multiple types selectively based on hasPermissions', () async {
      when(
        mockHealth.requestAuthorization(
          any,
          permissions: anyNamed('permissions'),
        ),
      ).thenAnswer((_) async => true);

      // heartRate → granted, weight → denied
      var callCount = 0;
      when(
        mockHealth.hasPermissions(any, permissions: anyNamed('permissions')),
      ).thenAnswer((_) async {
        callCount++;
        // First call = heartRate plugin types, second = weight plugin types
        return callCount == 1;
      });

      final result = await sut.requestPermissions([
        HealthDataType.heartRate,
        HealthDataType.weight,
      ]);

      expect(result.valueOrNull, equals([HealthDataType.heartRate]));
    });
  });

  // -------------------------------------------------------------------------
  // readRecords
  // -------------------------------------------------------------------------

  group('readRecords', () {
    test('maps heart rate point to HealthDataRecord', () async {
      final point = _makePoint(
        type: hp.HealthDataType.HEART_RATE,
        value: 72,
        dateFrom: t0,
      );
      when(
        mockHealth.getHealthDataFromTypes(
          types: anyNamed('types'),
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
        ),
      ).thenAnswer((_) async => [point]);

      final result = await sut.readRecords(
        HealthDataType.heartRate,
        t0.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        t0.millisecondsSinceEpoch,
      );

      final records = result.valueOrNull!;
      expect(records, hasLength(1));
      expect(records.first.value, equals(72.0));
      expect(records.first.recordedAt, equals(t0.millisecondsSinceEpoch));
      expect(records.first.sourceDevice, equals('Apple Watch'));
    });

    test('sleep duration: converts minutes to hours', () async {
      // dateTo - dateFrom = 2 hours = 120 minutes
      // HealthDataPoint constructor overrides value via _convertMinutes()
      final dateFrom = t0;
      final dateTo = t0.add(const Duration(hours: 2));
      final point = hp.HealthDataPoint(
        uuid: 'sleep-uuid',
        value: hp.NumericHealthValue(numericValue: 0), // overridden by ctor
        type: hp.HealthDataType.SLEEP_ASLEEP,
        unit: hp.HealthDataUnit.MINUTE,
        dateFrom: dateFrom,
        dateTo: dateTo,
        sourcePlatform: hp.HealthPlatformType.appleHealth,
        sourceDeviceId: 'device-1',
        sourceId: 'source-1',
        sourceName: 'Apple Watch',
      );
      when(
        mockHealth.getHealthDataFromTypes(
          types: anyNamed('types'),
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
        ),
      ).thenAnswer((_) async => [point]);

      final result = await sut.readRecords(
        HealthDataType.sleepDuration,
        dateFrom.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        dateTo.millisecondsSinceEpoch,
      );

      final records = result.valueOrNull!;
      expect(records, hasLength(1));
      // 120 minutes → 2.0 hours
      expect(records.first.value, closeTo(2.0, 0.001));
    });

    test('empty sourceName maps to null sourceDevice', () async {
      final point = _makePoint(
        type: hp.HealthDataType.HEART_RATE,
        value: 65,
        dateFrom: t0,
        sourceName: '',
      );
      when(
        mockHealth.getHealthDataFromTypes(
          types: anyNamed('types'),
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
        ),
      ).thenAnswer((_) async => [point]);

      final result = await sut.readRecords(
        HealthDataType.heartRate,
        t0.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        t0.millisecondsSinceEpoch,
      );

      expect(result.valueOrNull!.first.sourceDevice, isNull);
    });

    test('non-empty sourceName is preserved as sourceDevice', () async {
      final point = _makePoint(
        type: hp.HealthDataType.WEIGHT,
        value: 75.5,
        dateFrom: t0,
        sourceName: 'Garmin Scale',
      );
      when(
        mockHealth.getHealthDataFromTypes(
          types: anyNamed('types'),
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
        ),
      ).thenAnswer((_) async => [point]);

      final result = await sut.readRecords(
        HealthDataType.weight,
        t0.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        t0.millisecondsSinceEpoch,
      );

      expect(result.valueOrNull!.first.sourceDevice, equals('Garmin Scale'));
    });

    test('returns empty list when no data points', () async {
      when(
        mockHealth.getHealthDataFromTypes(
          types: anyNamed('types'),
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
        ),
      ).thenAnswer((_) async => []);

      final result = await sut.readRecords(
        HealthDataType.steps,
        t0.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        t0.millisecondsSinceEpoch,
      );

      expect(result.valueOrNull, isEmpty);
    });

    test('returns Failure on exception', () async {
      when(
        mockHealth.getHealthDataFromTypes(
          types: anyNamed('types'),
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
        ),
      ).thenThrow(Exception('read error'));

      final result = await sut.readRecords(
        HealthDataType.heartRate,
        t0.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        t0.millisecondsSinceEpoch,
      );

      expect(result, isA<Failure<List<HealthDataRecord>, AppError>>());
      expect(result.errorOrNull, isA<WearableError>());
    });
  });
}
