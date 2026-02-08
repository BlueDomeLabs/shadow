// lib/presentation/screens/supplements/supplement_list_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 4 - Supplement Screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/supplements/supplements_usecases.dart';
import 'package:shadow_app/presentation/providers/supplements/supplement_list_provider.dart';
import 'package:shadow_app/presentation/screens/supplements/supplement_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen displaying the list of supplements for a profile.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 4 exactly.
/// Uses [SupplementListProvider] for state management.
class SupplementListScreen extends ConsumerWidget {
  final String profileId;

  const SupplementListScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplementsAsync = ref.watch(supplementListProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
            tooltip: 'Filter supplements',
          ),
        ],
      ),
      body: Semantics(
        label: 'Supplement list',
        child: supplementsAsync.when(
          data: (supplements) =>
              _buildSupplementList(context, ref, supplements),
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading supplements'),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Add new supplement',
        child: FloatingActionButton(
          onPressed: () => _navigateToAddSupplement(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSupplementList(
    BuildContext context,
    WidgetRef ref,
    List<Supplement> supplements,
  ) {
    if (supplements.isEmpty) {
      return _buildEmptyState(context);
    }

    // Separate active and archived supplements
    final activeSupplements = supplements.where((s) => s.isActive).toList();
    final archivedSupplements = supplements.where((s) => s.isArchived).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(supplementListProvider(profileId));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activeSupplements.isNotEmpty) ...[
            _buildSectionHeader(context, 'Active Supplements'),
            const SizedBox(height: 8),
            ...activeSupplements.map(
              (supplement) => _buildSupplementCard(context, ref, supplement),
            ),
          ],
          if (archivedSupplements.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Archived'),
            const SizedBox(height: 8),
            ...archivedSupplements.map(
              (supplement) => _buildSupplementCard(context, ref, supplement),
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

  Widget _buildSupplementCard(
    BuildContext context,
    WidgetRef ref,
    Supplement supplement,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadowCard.listItem(
        onTap: () => _navigateToEditSupplement(context, supplement),
        semanticLabel: '${supplement.name}, ${supplement.displayDosage}',
        semanticHint: 'Double tap to edit',
        child: Row(
          children: [
            // Supplement icon based on form
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getFormIcon(supplement.form),
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            // Supplement info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supplement.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: supplement.isArchived
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    supplement.displayDosage,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (supplement.brand.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      supplement.brand,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Schedule indicator
            if (supplement.hasSchedules)
              Semantics(
                label: 'Has schedule',
                child: Icon(
                  Icons.schedule,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
            const SizedBox(width: 8),
            // More options
            PopupMenuButton<String>(
              onSelected: (value) =>
                  _handleSupplementAction(context, ref, supplement, value),
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
                  value: 'log',
                  child: ListTile(
                    leading: Icon(Icons.check_circle),
                    title: Text('Log Intake'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: supplement.isArchived ? 'unarchive' : 'archive',
                  child: ListTile(
                    leading: Icon(
                      supplement.isArchived ? Icons.unarchive : Icons.archive,
                    ),
                    title: Text(
                      supplement.isArchived ? 'Unarchive' : 'Archive',
                    ),
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
              Icons.medication_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No supplements yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first supplement',
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
              'Failed to load supplements',
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
                  ref.invalidate(supplementListProvider(profileId)),
              label: 'Retry',
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFormIcon(SupplementForm form) => switch (form) {
    SupplementForm.capsule => Icons.medication,
    SupplementForm.tablet => Icons.circle,
    SupplementForm.powder => Icons.grain,
    SupplementForm.liquid => Icons.water_drop,
    SupplementForm.gummy => Icons.cookie_outlined,
    SupplementForm.spray => Icons.air,
    SupplementForm.other => Icons.category,
  };

  void _showFilterOptions(BuildContext context) {
    // TODO: Implement filter dialog
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  void _navigateToAddSupplement(BuildContext context) {
    // TODO: Navigate to add supplement screen
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => SupplementEditScreen(profileId: profileId),
      ),
    );
  }

  void _navigateToEditSupplement(BuildContext context, Supplement supplement) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            SupplementEditScreen(profileId: profileId, supplement: supplement),
      ),
    );
  }

  Future<void> _handleSupplementAction(
    BuildContext context,
    WidgetRef ref,
    Supplement supplement,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        _navigateToEditSupplement(context, supplement);
      case 'log':
        _navigateToLogIntake(context, supplement);
      case 'archive':
      case 'unarchive':
        await _toggleArchive(context, ref, supplement);
    }
  }

  void _navigateToLogIntake(BuildContext context, Supplement supplement) {
    // TODO: Navigate to log intake screen
  }

  Future<void> _toggleArchive(
    BuildContext context,
    WidgetRef ref,
    Supplement supplement,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: supplement.isArchived
          ? 'Unarchive Supplement?'
          : 'Archive Supplement?',
      contentText: supplement.isArchived
          ? 'This supplement will appear in your active list again.'
          : 'This supplement will be moved to the archived section.',
      confirmButtonText: supplement.isArchived ? 'Unarchive' : 'Archive',
    );

    if (confirmed ?? false) {
      try {
        await ref
            .read(supplementListProvider(profileId).notifier)
            .archive(
              ArchiveSupplementInput(
                id: supplement.id,
                profileId: profileId,
                archive: !supplement.isArchived,
              ),
            );
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: supplement.isArchived
                ? 'Supplement unarchived'
                : 'Supplement archived',
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

/// Bottom sheet for filtering supplements.
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
          Text('Filter Supplements', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          // TODO: Implement filter options
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
