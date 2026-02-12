// lib/presentation/screens/conditions/condition_list_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 8 - Condition Screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/usecases/conditions/conditions_usecases.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/screens/conditions/condition_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen displaying the list of conditions for a profile.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 8 exactly.
/// Uses [ConditionListProvider] for state management.
class ConditionListScreen extends ConsumerWidget {
  final String profileId;

  const ConditionListScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conditionsAsync = ref.watch(conditionListProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conditions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
            tooltip: 'Filter conditions',
          ),
        ],
      ),
      body: Semantics(
        label: 'Condition list',
        child: conditionsAsync.when(
          data: (conditions) => _buildConditionList(context, ref, conditions),
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading conditions'),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Add new condition',
        child: FloatingActionButton(
          onPressed: () => _navigateToAddCondition(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildConditionList(
    BuildContext context,
    WidgetRef ref,
    List<Condition> conditions,
  ) {
    if (conditions.isEmpty) {
      return _buildEmptyState(context);
    }

    final activeConditions = conditions.where((c) => c.isActive).toList();
    final resolvedConditions = conditions.where((c) => c.isResolved).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(conditionListProvider(profileId));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activeConditions.isNotEmpty) ...[
            _buildSectionHeader(context, 'Active Conditions'),
            const SizedBox(height: 8),
            ...activeConditions.map(
              (condition) => _buildConditionCard(context, ref, condition),
            ),
          ],
          if (resolvedConditions.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Resolved Conditions'),
            const SizedBox(height: 8),
            ...resolvedConditions.map(
              (condition) => _buildConditionCard(context, ref, condition),
            ),
          ],
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

  Widget _buildConditionCard(
    BuildContext context,
    WidgetRef ref,
    Condition condition,
  ) {
    final theme = Theme.of(context);
    final bodyLocationsSummary = condition.bodyLocations.isNotEmpty
        ? condition.bodyLocations.join(', ')
        : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadowCard.listItem(
        onTap: () => _navigateToEditCondition(context, condition),
        semanticLabel: '${condition.name}, ${condition.category}',
        semanticHint: 'Double tap to edit',
        child: Row(
          children: [
            // Condition icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.medical_services,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            // Condition info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    condition.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: condition.isArchived
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    condition.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (bodyLocationsSummary.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      bodyLocationsSummary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Photo indicator
            if (condition.hasBaselinePhoto)
              Semantics(
                label: 'Has baseline photo',
                child: Icon(
                  Icons.photo_camera,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
            const SizedBox(width: 8),
            // More options
            PopupMenuButton<String>(
              tooltip: 'More options',
              onSelected: (value) =>
                  _handleConditionAction(context, ref, condition, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: condition.isArchived ? 'unarchive' : 'archive',
                  child: ListTile(
                    leading: Icon(
                      condition.isArchived ? Icons.unarchive : Icons.archive,
                    ),
                    title: Text(condition.isArchived ? 'Unarchive' : 'Archive'),
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
              Icons.medical_services_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No conditions yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first condition',
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
              'Failed to load conditions',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error is AppError
                  ? error.userMessage
                  : 'Something went wrong. Please try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ShadowButton(
              onPressed: () => ref.invalidate(conditionListProvider(profileId)),
              label: 'Retry',
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  void _navigateToAddCondition(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => ConditionEditScreen(profileId: profileId),
      ),
    );
  }

  void _navigateToEditCondition(BuildContext context, Condition condition) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            ConditionEditScreen(profileId: profileId, condition: condition),
      ),
    );
  }

  Future<void> _handleConditionAction(
    BuildContext context,
    WidgetRef ref,
    Condition condition,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        _navigateToEditCondition(context, condition);
      case 'archive':
      case 'unarchive':
        await _toggleArchive(context, ref, condition);
    }
  }

  Future<void> _toggleArchive(
    BuildContext context,
    WidgetRef ref,
    Condition condition,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: condition.isArchived
          ? 'Unarchive Condition?'
          : 'Archive Condition?',
      contentText: condition.isArchived
          ? 'This condition will appear in your active list again.'
          : 'This condition will be moved to the archived section.',
      confirmButtonText: condition.isArchived ? 'Unarchive' : 'Archive',
    );

    if (confirmed ?? false) {
      try {
        await ref
            .read(conditionListProvider(profileId).notifier)
            .archive(
              ArchiveConditionInput(id: condition.id, profileId: profileId),
            );
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: condition.isArchived
                ? 'Condition unarchived'
                : 'Condition archived',
          );
        }
      } on AppError catch (e) {
        if (context.mounted) {
          showAccessibleSnackBar(context: context, message: e.userMessage);
        }
      } on Exception {
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'An unexpected error occurred',
          );
        }
      }
    }
  }
}

/// Bottom sheet for filtering conditions.
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
          Text('Filter Conditions', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Active only'),
            trailing: Switch(value: true, onChanged: (value) {}),
          ),
          ListTile(
            leading: const Icon(Icons.archive),
            title: const Text('Show archived'),
            trailing: Switch(value: true, onChanged: (value) {}),
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
