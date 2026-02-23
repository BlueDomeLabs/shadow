// test/core/services/notification_tap_handler_test.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/services/notification_tap_handler.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

void main() {
  group('NotificationTapHandler', () {
    late NotificationTapHandler handler;

    setUp(() {
      handler = NotificationTapHandler();
    });

    NotificationResponse makeResponse(String? payload) => NotificationResponse(
      notificationResponseType: NotificationResponseType.selectedNotification,
      payload: payload,
    );

    test('invokes onTap with correct category for supplements', () {
      final received = <NotificationCategory>[];
      handler
        ..onTap = received.add
        ..handleTap(makeResponse('{"category": 0}'));

      expect(received, [NotificationCategory.supplements]);
    });

    test('invokes onTap with correct category for foodMeals', () {
      final received = <NotificationCategory>[];
      handler
        ..onTap = received.add
        ..handleTap(makeResponse('{"category": 1}'));

      expect(received, [NotificationCategory.foodMeals]);
    });

    test('invokes onTap with correct category for bbtVitals', () {
      final received = <NotificationCategory>[];
      handler
        ..onTap = received.add
        ..handleTap(makeResponse('{"category": 7}'));

      expect(received, [NotificationCategory.bbtVitals]);
    });

    test('ignores tap when onTap is null', () {
      expect(
        () => handler.handleTap(makeResponse('{"category": 0}')),
        returnsNormally,
      );
    });

    test('ignores null payload', () {
      final received = <NotificationCategory>[];
      handler
        ..onTap = received.add
        ..handleTap(makeResponse(null));

      expect(received, isEmpty);
    });

    test('ignores empty payload', () {
      final received = <NotificationCategory>[];
      handler
        ..onTap = received.add
        ..handleTap(makeResponse(''));

      expect(received, isEmpty);
    });

    test('ignores malformed JSON payload', () {
      final received = <NotificationCategory>[];
      handler
        ..onTap = received.add
        ..handleTap(makeResponse('not-json'));

      expect(received, isEmpty);
    });

    test('ignores payload missing category key', () {
      final received = <NotificationCategory>[];
      handler
        ..onTap = received.add
        ..handleTap(makeResponse('{"other": 1}'));

      expect(received, isEmpty);
    });

    test('ignores JSON array payload (not object)', () {
      final received = <NotificationCategory>[];
      handler
        ..onTap = received.add
        ..handleTap(makeResponse('[1, 2, 3]'));

      expect(received, isEmpty);
    });

    test('setting onTap to null clears callback', () {
      handler
        ..onTap = (_) {}
        ..onTap = null;

      expect(
        () => handler.handleTap(makeResponse('{"category": 0}')),
        returnsNormally,
      );
    });

    test('anchor event payload with category field fires callback', () {
      final received = <NotificationCategory>[];
      handler
        ..onTap = received.add
        ..handleTap(makeResponse('{"category": 5, "anchorEvent": 2}'));

      expect(received, [NotificationCategory.activities]);
    });
  });
}
