// test/core/services/notification_permission_service_test.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/services/notification_permission_service.dart';

import 'notification_permission_service_test.mocks.dart';

@GenerateMocks([FlutterLocalNotificationsPlugin])
void main() {
  group('NotificationPermissionService', () {
    late MockFlutterLocalNotificationsPlugin mockPlugin;
    late NotificationPermissionService service;

    setUp(() {
      mockPlugin = MockFlutterLocalNotificationsPlugin();
      service = NotificationPermissionService(mockPlugin);
    });

    test(
      'returns true when no platform-specific implementation available',
      () async {
        when(
          mockPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(null);
        when(
          mockPlugin
              .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(null);
        when(
          mockPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(null);

        final result = await service.requestPermission();

        expect(result, isTrue);
      },
    );
  });
}
