/// Guest invite management screen.
///
/// Hosts use this screen to view and manage all guest invites for a profile.
/// Each invite shows device name, status, creation date, and last seen time.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/presentation/providers/guest_invites/guest_invite_list_provider.dart';
import 'package:shadow_app/presentation/screens/guest_invites/guest_invite_qr_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen showing all guest invites for a profile.
class GuestInviteListScreen extends ConsumerWidget {
  final String profileId;
  final String profileName;

  const GuestInviteListScreen({
    super.key,
    required this.profileId,
    required this.profileName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitesAsync = ref.watch(guestInviteListProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Invites'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: invitesAsync.when(
        data: (invites) => invites.isEmpty
            ? _buildEmptyState(context)
            : _buildList(context, ref, invites),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Failed to load invites: $error'),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'guest_invite_fab',
        backgroundColor: Colors.indigo,
        tooltip: 'Create new invite',
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => GuestInviteQrScreen(
              profileId: profileId,
              profileName: profileName,
            ),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.devices, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text(
          'No active invites',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap + to create an invite for this profile',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    ),
  );

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<GuestInvite> invites,
  ) => ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: invites.length,
    itemBuilder: (context, index) {
      final invite = invites[index];
      return _InviteCard(
        invite: invite,
        profileName: profileName,
        profileId: profileId,
      );
    },
  );
}

class _InviteCard extends ConsumerWidget {
  final GuestInvite invite;
  final String profileName;
  final String profileId;

  const _InviteCard({
    required this.invite,
    required this.profileName,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createdDate = DateFormat.yMMMd().format(
      DateTime.fromMillisecondsSinceEpoch(
        invite.createdAt,
        isUtc: true,
      ).toLocal(),
    );
    final lastSeenDate = invite.lastSeenAt != null
        ? DateFormat.yMMMd().format(
            DateTime.fromMillisecondsSinceEpoch(
              invite.lastSeenAt!,
              isUtc: true,
            ).toLocal(),
          )
        : 'Never';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    invite.label.isNotEmpty ? invite.label : 'Unnamed Device',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                _buildStatusChip(),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  tooltip:
                      'Options for ${invite.label.isNotEmpty ? invite.label : "invite"}',
                  onSelected: (value) {
                    if (value == 'remove') {
                      _showRemoveConfirmation(context, ref);
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'remove',
                      child: Text('Remove Device'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Created: $createdDate',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.visibility, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Last seen: $lastSeenDate',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            if (invite.isActivated) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.phone_android, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Device connected',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    String label;

    if (invite.isRevoked) {
      backgroundColor = Colors.red;
      label = 'Revoked';
    } else if (!invite.isActive) {
      backgroundColor = Colors.orange;
      label = 'Expired';
    } else {
      backgroundColor = Colors.green;
      label = 'Active';
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showRemoveConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Device'),
        content: Text(
          'Are you sure you want to remove access for '
          '"${invite.label.isNotEmpty ? invite.label : "this device"}" '
          "from $profileName's profile?\n\n"
          'The guest device will lose access on next sync.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              // Second confirmation step
              if (context.mounted) {
                _showFinalConfirmation(context, ref);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showFinalConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Removal'),
        content: Text(
          'This will immediately revoke access for ${invite.label.isNotEmpty ? invite.label : "this device"}. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(guestInviteListProvider(profileId).notifier)
                  .revoke(invite.id);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                showAccessibleSnackBar(
                  context: context,
                  message: 'Device access removed',
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Remove'),
          ),
        ],
      ),
    );
  }
}
