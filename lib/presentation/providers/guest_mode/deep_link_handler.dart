/// Deep link handler for guest invite activation.
///
/// Listens for incoming shadow://invite deep links and validates
/// the token, activates guest mode, or shows rejection feedback.
library;

import 'dart:async';

import 'package:shadow_app/core/services/deep_link_service.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/services/guest_token_service.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';

/// Callback type for showing the Access Revoked screen.
typedef OnAccessRevoked = void Function(TokenRejectionReason reason);

/// Callback type for showing the guest disclaimer dialog.
typedef OnShowDisclaimer = Future<bool> Function();

/// Handles deep link events and activates guest mode if valid.
class DeepLinkHandler {
  final DeepLinkService _deepLinkService;
  final GuestTokenService _tokenService;
  final GuestModeNotifier _guestModeNotifier;
  final String _deviceId;
  final ScopedLogger _log = logger.scope('DeepLinkHandler');

  StreamSubscription<GuestInviteLink>? _subscription;

  OnAccessRevoked? onAccessRevoked;
  OnShowDisclaimer? onShowDisclaimer;

  DeepLinkHandler({
    required DeepLinkService deepLinkService,
    required GuestTokenService tokenService,
    required GuestModeNotifier guestModeNotifier,
    required String deviceId,
  }) : _deepLinkService = deepLinkService,
       _tokenService = tokenService,
       _guestModeNotifier = guestModeNotifier,
       _deviceId = deviceId;

  /// Start listening for deep links.
  void startListening() {
    _subscription = _deepLinkService.inviteLinks.listen(_handleInviteLink);
  }

  /// Handle an incoming invite link.
  Future<void> _handleInviteLink(GuestInviteLink link) async {
    _log.info('Processing invite link for profile ${link.profileId}');

    final result = await _tokenService.validateAndActivate(
      token: link.token,
      deviceId: _deviceId,
    );

    result.when(
      success: (validation) {
        if (validation.isValid) {
          _log.info('Token valid, activating guest mode');
          _activateWithDisclaimer(link);
        } else {
          _log.warning('Token rejected: ${validation.rejectionReason}');
          onAccessRevoked?.call(validation.rejectionReason!);
        }
      },
      failure: (error) {
        _log.error('Token validation failed: ${error.message}');
        onAccessRevoked?.call(TokenRejectionReason.notFound);
      },
    );
  }

  Future<void> _activateWithDisclaimer(GuestInviteLink link) async {
    // Show disclaimer if not seen before
    if (!_guestModeNotifier.hasSeenDisclaimer && onShowDisclaimer != null) {
      final accepted = await onShowDisclaimer!();
      if (!accepted) {
        _log.info('User declined disclaimer, not activating guest mode');
        return;
      }
      await _guestModeNotifier.markDisclaimerSeen();
    }

    _guestModeNotifier.activateGuestMode(
      profileId: link.profileId,
      token: link.token,
    );
  }

  /// Clean up resources.
  void dispose() {
    _subscription?.cancel();
  }
}
