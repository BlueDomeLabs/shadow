// lib/presentation/screens/cloud_sync/conflict_resolution_screen.dart
// Screen for viewing and resolving sync conflicts — Phase 30.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/sync_conflict.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// Entity type label mapping
// ════════════════════════════════════════════════════════════════════════════

const _entityTypeLabels = <String, String>{
  'supplements': 'Supplement',
  'intake_logs': 'Supplement Log',
  'conditions': 'Condition',
  'condition_logs': 'Condition Log',
  'flare_ups': 'Flare-Up',
  'fluids_entries': 'Fluids Entry',
  'sleep_entries': 'Sleep Entry',
  'activities': 'Activity',
  'activity_logs': 'Activity Log',
  'food_items': 'Food Item',
  'food_logs': 'Food Log',
  'journal_entries': 'Journal Entry',
  'photo_areas': 'Photo Area',
  'photo_entries': 'Photo Entry',
  'profiles': 'Profile',
};

String _entityLabel(String entityType) =>
    _entityTypeLabels[entityType] ?? entityType;

// ════════════════════════════════════════════════════════════════════════════
// ConflictResolutionScreen
// ════════════════════════════════════════════════════════════════════════════

/// Screen for reviewing and resolving sync conflicts.
///
/// Loads all unresolved conflicts for the active profile and presents
/// each as a [_ConflictCard] with options to keep local, keep remote, or merge.
class ConflictResolutionScreen extends ConsumerStatefulWidget {
  const ConflictResolutionScreen({super.key});

  @override
  ConsumerState<ConflictResolutionScreen> createState() =>
      _ConflictResolutionScreenState();
}

class _ConflictResolutionScreenState
    extends ConsumerState<ConflictResolutionScreen> {
  List<SyncConflict>? _conflicts;
  AppError? _loadError;
  final Set<String> _resolvingIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadConflicts());
  }

  Future<void> _loadConflicts() async {
    final profileId = ref.read(profileProvider).currentProfileId;
    if (profileId == null) {
      if (mounted) setState(() => _conflicts = []);
      return;
    }

    final result = await ref
        .read(syncServiceProvider)
        .getUnresolvedConflicts(profileId);

    if (!mounted) return;

    result.when(
      success: (conflicts) => setState(() {
        _conflicts = conflicts;
        _loadError = null;
      }),
      failure: (error) => setState(() => _loadError = error),
    );
  }

  Future<void> _resolve(
    String conflictId,
    ConflictResolutionType resolution,
  ) async {
    setState(() => _resolvingIds.add(conflictId));

    final result = await ref
        .read(syncServiceProvider)
        .resolveConflict(conflictId, resolution);

    if (!mounted) return;

    setState(() {
      _resolvingIds.remove(conflictId);
      if (result.isSuccess) {
        _conflicts?.removeWhere((c) => c.id == conflictId);
      }
    });

    if (result.isFailure && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to resolve conflict: '
            '${result.errorOrNull!.userMessage}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sync Conflicts')),
    body: _buildBody(context),
  );

  Widget _buildBody(BuildContext context) {
    if (_loadError != null) {
      return Center(child: Text('Error: ${_loadError!.userMessage}'));
    }

    if (_conflicts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_conflicts!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'All conflicts resolved',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Banner
        Container(
          width: double.infinity,
          color: Colors.amber[100],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.amber[800]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_conflicts!.length} conflict${_conflicts!.length == 1 ? '' : 's'} '
                  'need${_conflicts!.length == 1 ? 's' : ''} your review. '
                  'Choose which version to keep for each item.',
                  style: TextStyle(color: Colors.amber[900]),
                ),
              ),
            ],
          ),
        ),
        // Conflict list
        Expanded(
          child: ListView.builder(
            itemCount: _conflicts!.length,
            itemBuilder: (context, index) {
              final conflict = _conflicts![index];
              return _ConflictCard(
                conflict: conflict,
                isResolving: _resolvingIds.contains(conflict.id),
                onResolve: _resolve,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// _ConflictCard
// ════════════════════════════════════════════════════════════════════════════

class _ConflictCard extends StatelessWidget {
  const _ConflictCard({
    required this.conflict,
    required this.isResolving,
    required this.onResolve,
  });

  final SyncConflict conflict;
  final bool isResolving;
  final Future<void> Function(String, ConflictResolutionType) onResolve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _entityLabel(conflict.entityType),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '…${conflict.entityId.length >= 8 ? conflict.entityId.substring(conflict.entityId.length - 8) : conflict.entityId}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Detected ${_relativeTime(conflict.detectedAt)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Version panels
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _VersionPanel(
                        label: 'THIS DEVICE',
                        data: conflict.localData,
                        background: Colors.blueGrey[50]!,
                        labelColor: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _VersionPanel(
                        label: 'OTHER DEVICE',
                        data: conflict.remoteData,
                        background: Colors.amber[50]!,
                        labelColor: Colors.amber[700]!,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Action row
              if (isResolving)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => onResolve(
                          conflict.id,
                          ConflictResolutionType.keepLocal,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                        ),
                        child: const Text(
                          'Keep This Device',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => onResolve(
                          conflict.id,
                          ConflictResolutionType.keepRemote,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                        ),
                        child: const Text(
                          'Keep Other Device',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => onResolve(
                          conflict.id,
                          ConflictResolutionType.merge,
                        ),
                        child: const Text('Merge'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _relativeTime(int epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return DateFormat('MMM d').format(dt);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// _VersionPanel
// ════════════════════════════════════════════════════════════════════════════

class _VersionPanel extends StatelessWidget {
  const _VersionPanel({
    required this.label,
    required this.data,
    required this.background,
    required this.labelColor,
  });

  final String label;
  final Map<String, dynamic> data;
  final Color background;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final fields = _extractFields(data);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: labelColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          if (fields.isEmpty)
            Text(
              'No preview available',
              style: TextStyle(
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            )
          else
            ...fields.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(f, style: const TextStyle(fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }

  List<String> _extractFields(Map<String, dynamic> data) {
    final results = <String>[];
    final dateFormatter = DateFormat('MMM d, h:mm a');

    // Name
    if (data['name'] != null) results.add('${data['name']}');

    // Notes (truncate to 60 chars)
    if (data['notes'] != null) {
      final notes = '${data['notes']}';
      results.add(notes.length > 60 ? '${notes.substring(0, 60)}…' : notes);
    }

    // Content (journal, truncate to 60 chars)
    if (data['content'] != null) {
      final content = '${data['content']}';
      results.add(
        content.length > 60 ? '${content.substring(0, 60)}…' : content,
      );
    }

    // sync_updated_at
    if (data['sync_updated_at'] != null) {
      try {
        final ms = data['sync_updated_at'] as int;
        results.add(
          'Modified: ${dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(ms))}',
        );
      } on Exception {
        // ignore unparseable timestamps
      }
    }

    // Any other _at or _time fields
    for (final entry in data.entries) {
      if (entry.key == 'sync_updated_at') continue;
      if (entry.value == null) continue;
      final key = entry.key;
      if (key.endsWith('_at') || key.endsWith('_time')) {
        try {
          final ms = entry.value as int;
          results.add(
            '${_humanizeKey(key)}: ${dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(ms))}',
          );
        } on Exception {
          // ignore
        }
      }
    }

    return results;
  }

  String _humanizeKey(String key) => key
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}
