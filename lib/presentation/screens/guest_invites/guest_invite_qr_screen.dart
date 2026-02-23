/// QR code generation screen for guest invites.
///
/// Hosts use this screen to create a new invite and display its QR code
/// for a guest device to scan.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:shadow_app/presentation/providers/guest_invites/guest_invite_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen showing a QR code for a guest invite.
class GuestInviteQrScreen extends ConsumerStatefulWidget {
  final String profileId;
  final String profileName;

  const GuestInviteQrScreen({
    super.key,
    required this.profileId,
    required this.profileName,
  });

  @override
  ConsumerState<GuestInviteQrScreen> createState() =>
      _GuestInviteQrScreenState();
}

class _GuestInviteQrScreenState extends ConsumerState<GuestInviteQrScreen> {
  GuestInvite? _invite;
  bool _isCreating = true;
  String? _error;
  final _labelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _createInvite();
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _createInvite() async {
    try {
      final invite = await ref
          .read(guestInviteListProvider(widget.profileId).notifier)
          .create(CreateGuestInviteInput(profileId: widget.profileId));
      if (mounted) {
        setState(() {
          _invite = invite;
          _isCreating = false;
          _labelController.text = invite?.label ?? '';
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isCreating = false;
        });
      }
    }
  }

  String _buildDeepLink() {
    if (_invite == null) return '';
    return 'shadow://invite?token=${_invite!.token}&profile=${_invite!.profileId}';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Invite Device'),
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
    body: _buildBody(),
  );

  Widget _buildBody() {
    if (_isCreating) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Creating invite...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to create invite',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    if (_invite == null) return const SizedBox.shrink();

    final deepLink = _buildDeepLink();
    final createdDate = DateFormat.yMMMd().format(
      DateTime.fromMillisecondsSinceEpoch(
        _invite!.createdAt,
        isUtc: true,
      ).toLocal(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Profile name
          Text(
            'Share access to ${widget.profileName}',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // QR Code
          Semantics(
            label: 'QR code for guest invite',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: QrImageView(data: deepLink, size: 250),
            ),
          ),
          const SizedBox(height: 24),
          // Invite label
          ShadowTextField(
            controller: _labelController,
            label: 'Invite Label',
            hintText: "e.g. John's iPhone",
          ),
          const SizedBox(height: 16),
          // Creation date
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Created'),
            subtitle: Text(createdDate),
          ),
          // Expiry
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Expires'),
            subtitle: Text(
              _invite!.expiresAt != null
                  ? DateFormat.yMMMd().format(
                      DateTime.fromMillisecondsSinceEpoch(
                        _invite!.expiresAt!,
                        isUtc: true,
                      ).toLocal(),
                    )
                  : 'Never',
            ),
          ),
          const SizedBox(height: 24),
          // Share button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: deepLink));
                showAccessibleSnackBar(
                  context: context,
                  message: 'Invite link copied to clipboard',
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Share Invite Link'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Instructions
          Text(
            'The guest can scan this QR code with their camera, '
            'or you can share the link directly.',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
