/// Deep link handling service for shadow:// URLs.
///
/// Parses incoming deep links (e.g. shadow://invite?token=TOKEN&profile=PROFILE_ID)
/// and provides a stream of parsed link events to the app.
library;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shadow_app/core/services/logger_service.dart';

/// Parsed deep link data from a shadow://invite URL.
class GuestInviteLink {
  final String token;
  final String profileId;

  const GuestInviteLink({required this.token, required this.profileId});
}

/// Service that listens for incoming deep links and parses them.
///
/// On iOS: configured via CFBundleURLSchemes in Info.plist
/// On Android: configured via intent-filter in AndroidManifest.xml
class DeepLinkService {
  final ScopedLogger _log = logger.scope('DeepLink');

  /// Method channel for receiving initial deep link on cold start.
  static const _channel = MethodChannel('com.bluedome.shadow/deeplink');

  /// Event channel for receiving deep links while app is running.
  static const _eventChannel = EventChannel(
    'com.bluedome.shadow/deeplink_events',
  );

  StreamSubscription<dynamic>? _subscription;
  final _controller = StreamController<GuestInviteLink>.broadcast();

  /// Stream of parsed guest invite links.
  Stream<GuestInviteLink> get inviteLinks => _controller.stream;

  /// Initialize deep link listening.
  ///
  /// Checks for an initial deep link (cold start) and subscribes
  /// to the event channel for links received while running.
  Future<void> initialize() async {
    // Check for initial link (app launched via deep link)
    try {
      final initialLink = await _channel.invokeMethod<String>('getInitialLink');
      if (initialLink != null) {
        _handleLink(initialLink);
      }
    } on PlatformException catch (e) {
      _log.warning('No initial deep link: ${e.message}');
    } on MissingPluginException {
      // Expected in tests and on platforms without native setup
      _log.debug('Deep link channel not available (expected in test/desktop)');
    }

    // Listen for links while app is running
    _subscription = _eventChannel.receiveBroadcastStream().listen(
      (dynamic link) {
        if (link is String) _handleLink(link);
      },
      onError: (dynamic error) {
        _log.error('Deep link stream error: $error');
      },
    );
  }

  /// Parse a deep link URI and emit it if valid.
  void _handleLink(String link) {
    _log.info('Received deep link: $link');

    final parsed = parseInviteLink(link);
    if (parsed != null) {
      _controller.add(parsed);
    } else {
      _log.warning('Invalid deep link format: $link');
    }
  }

  /// Parse a shadow://invite deep link URL.
  ///
  /// Returns null if the URL is not a valid invite link.
  /// Exposed as static for unit testing without platform channels.
  static GuestInviteLink? parseInviteLink(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    if (uri.scheme != 'shadow') return null;
    if (uri.host != 'invite') return null;

    final token = uri.queryParameters['token'];
    final profileId = uri.queryParameters['profile'];

    if (token == null || token.isEmpty) return null;
    if (profileId == null || profileId.isEmpty) return null;

    return GuestInviteLink(token: token, profileId: profileId);
  }

  /// Clean up resources.
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
