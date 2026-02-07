// lib/presentation/screens/sleep_entries/sleep_entry_list_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 7 - Sleep Entry Screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/sleep_entries/sleep_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/sleep_entries/sleep_entry_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen displaying the list of sleep entries for a profile.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 7 exactly.
/// Uses [SleepEntryList] provider for state management.
class SleepEntryListScreen extends ConsumerWidget {
  final String profileId;

  const SleepEntryListScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepEntriesAsync = ref.watch(sleepEntryListProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
            tooltip: 'Filter sleep entries',
          ),
        ],
      ),
      body: Semantics(
        label: 'Sleep entry list',
        child: sleepEntriesAsync.when(
          data: (entries) => _buildSleepEntryList(context, ref, entries),
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading sleep entries'),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Add new sleep entry',
        child: FloatingActionButton(
          onPressed: () => _navigateToAddSleepEntry(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSleepEntryList(
    BuildContext context,
    WidgetRef ref,
    List<SleepEntry> entries,
  ) {
    if (entries.isEmpty) {
      return _buildEmptyState(context);
    }

    // Sort by bed time, most recent first
    final sortedEntries = List<SleepEntry>.from(entries)
      ..sort((a, b) => b.bedTime.compareTo(a.bedTime));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(sleepEntryListProvider(profileId));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'Sleep Entries'),
          const SizedBox(height: 8),
          ...sortedEntries.map(
            (entry) => _buildSleepEntryCard(context, ref, entry),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSleepEntryCard(
    BuildContext context,
    WidgetRef ref,
    SleepEntry entry,
  ) {
    final theme = Theme.of(context);
    final bedDateTime = DateTime.fromMillisecondsSinceEpoch(entry.bedTime);
    final wakeDateTime = entry.wakeTime != null
        ? DateTime.fromMillisecondsSinceEpoch(entry.wakeTime!)
        : null;

    final dateStr = _formatDate(bedDateTime);
    final bedTimeStr = _formatTime(bedDateTime);
    final wakeTimeStr = wakeDateTime != null
        ? _formatTime(wakeDateTime)
        : 'Not recorded';
    final durationStr = _formatDuration(entry.totalSleepMinutes);
    final feelingStr = _getWakingFeelingLabel(entry.wakingFeeling);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadowCard.listItem(
        onTap: () => _navigateToEditSleepEntry(context, entry),
        semanticLabel: '$dateStr, $bedTimeStr to $wakeTimeStr, $feelingStr',
        semanticHint: 'Double tap to edit',
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getWakingFeelingIcon(entry.wakingFeeling),
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateStr,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$bedTimeStr - $wakeTimeStr',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        durationStr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        feelingStr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) =>
                  _handleSleepEntryAction(context, ref, entry, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bedtime_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No sleep entries yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to log your first sleep entry',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load sleep entries',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ShadowButton(
              onPressed: () =>
                  ref.invalidate(sleepEntryListProvider(profileId)),
              label: 'Retry',
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatDuration(int? totalMinutes) {
    if (totalMinutes == null) return 'Duration unknown';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  String _getWakingFeelingLabel(WakingFeeling feeling) => switch (feeling) {
    WakingFeeling.unrested => 'Unrested',
    WakingFeeling.neutral => 'Neutral',
    WakingFeeling.rested => 'Rested',
  };

  IconData _getWakingFeelingIcon(WakingFeeling feeling) => switch (feeling) {
    WakingFeeling.unrested => Icons.sentiment_dissatisfied,
    WakingFeeling.neutral => Icons.sentiment_neutral,
    WakingFeeling.rested => Icons.sentiment_satisfied,
  };

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  void _navigateToAddSleepEntry(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => SleepEntryEditScreen(profileId: profileId),
      ),
    );
  }

  void _navigateToEditSleepEntry(BuildContext context, SleepEntry entry) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            SleepEntryEditScreen(profileId: profileId, sleepEntry: entry),
      ),
    );
  }

  Future<void> _handleSleepEntryAction(
    BuildContext context,
    WidgetRef ref,
    SleepEntry entry,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        _navigateToEditSleepEntry(context, entry);
      case 'delete':
        await _confirmDelete(context, ref, entry);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    SleepEntry entry,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Delete Sleep Entry?',
      contentText: 'This sleep entry will be permanently deleted.',
    );

    if (confirmed ?? false) {
      try {
        await ref
            .read(sleepEntryListProvider(profileId).notifier)
            .delete(DeleteSleepEntryInput(id: entry.id, profileId: profileId));
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'Sleep entry deleted',
          );
        }
      } on Exception catch (e) {
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'Failed to delete sleep entry: $e',
          );
        }
      }
    }
  }
}

/// Bottom sheet for filtering sleep entries.
class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter Sleep Entries', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Date range'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement date range filter
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
