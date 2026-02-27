// Phase 18c
// lib/presentation/screens/guest_invites/guest_invite_scan_screen.dart

/// QR code scanning screen for guest invite activation.
///
/// Guest devices use this screen to scan an invite QR code generated
/// by the host's GuestInviteQrScreen and activate guest mode.
library;

import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shadow_app/core/services/deep_link_service.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';

/// Screen for scanning a guest invite QR code.
///
/// Validates the scanned token and activates guest mode on success.
///
/// [testDeviceId] may be supplied in widget tests to bypass the platform
/// device-info plugin and set a known device ID immediately.
class GuestInviteScanScreen extends ConsumerStatefulWidget {
  final String? testDeviceId;

  const GuestInviteScanScreen({super.key, this.testDeviceId});

  @override
  ConsumerState<GuestInviteScanScreen> createState() =>
      _GuestInviteScanScreenState();
}

class _GuestInviteScanScreenState extends ConsumerState<GuestInviteScanScreen> {
  bool _processing = false;
  String? _deviceId;
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(autoStart: false);
    if (widget.testDeviceId != null) {
      _deviceId = widget.testDeviceId;
    } else {
      _loadDeviceId();
      unawaited(_startCamera());
    }
  }

  Future<void> _loadDeviceId() async {
    try {
      final id = await DeviceInfoService(DeviceInfoPlugin()).getDeviceId();
      if (mounted) setState(() => _deviceId = id);
    } on Exception catch (_) {
      // Platform unavailable (e.g., test environment) — use fallback.
      if (mounted) setState(() => _deviceId = 'unknown-device-id');
    }
  }

  Future<void> _startCamera() async {
    try {
      await _controller.start();
    } on Exception catch (_) {
      // Camera unavailable — remain in uninitialized state.
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDetect(BarcodeCapture capture) async {
    if (_processing || _deviceId == null) return;
    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null) return;

    final link = DeepLinkService.parseInviteLink(rawValue);
    if (link == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not a valid Shadow invite')),
        );
      }
      return;
    }

    setState(() => _processing = true);
    await _controller.stop();

    final result = await ref
        .read(validateGuestTokenUseCaseProvider)
        .call(ValidateGuestTokenInput(token: link.token, deviceId: _deviceId!));

    if (!mounted) return;

    result.when(
      success: (_) {
        ref
            .read(guestModeProvider.notifier)
            .activateGuestMode(profileId: link.profileId, token: link.token);
        Navigator.of(context).pop();
      },
      failure: (error) {
        _showErrorDialog(error.message);
        setState(() => _processing = false);
        unawaited(_startCamera());
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unable to Join'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Scan Invite Code')),
    body: Stack(
      fit: StackFit.expand,
      children: [
        Semantics(
          label: 'QR code scanner',
          child: MobileScanner(
            controller: _controller,
            onDetect: _handleDetect,
          ),
        ),
        if (_processing)
          const ColoredBox(
            color: Colors.black54,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    ),
  );
}
