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
import 'package:shadow_app/presentation/screens/supplements/supplement_log_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen displaying the list of supplements for a profile.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 4 exactly.
/// Uses [SupplementListProvider] for state management.
class SupplementListScreen extends ConsumerStatefulWidget {
  final String profileId;

  const SupplementListScreen({super.key, required this.profileId});

  @override
  ConsumerState<SupplementListScreen> createState() =>
      _SupplementListScreenState();
}

class _SupplementListScreenState extends ConsumerState<SupplementListScreen> {
  // Filter state — both default to true so all supplements show on first open.
  bool _showActive = true;
  bool _showArchived = true;

  String get profileId => widget.profileId;

  @override
  Widget build(BuildContext context) {
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
          data: (supplements) => _buildSupplementList(context, supplements),
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading supplements'),
          ),
          error: (error, stack) => _buildErrorState(context, error),
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
    List<Supplement> supplements,
  ) {
    if (supplements.isEmpty) {
      return _buildEmptyState(context);
    }

    // Separate active and archived supplements, applying filter state.
    final activeSupplements = _showActive
        ? supplements.where((s) => s.isActive).toList()
        : <Supplement>[];
    final archivedSupplements = _showArchived
        ? supplements.where((s) => s.isArchived).toList()
        : <Supplement>[];

    if (activeSupplements.isEmpty && archivedSupplements.isEmpty) {
      return _buildEmptyState(context);
    }

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
              (supplement) => _buildSupplementCard(context, supplement),
            ),
          ],
          if (archivedSupplements.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Archived'),
            const SizedBox(height: 8),
            ...archivedSupplements.map(
              (supplement) => _buildSupplementCard(context, supplement),
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

  Widget _buildSupplementCard(BuildContext context, Supplement supplement) {
    final theme = Theme.of(context);

    return Padding(
      key: ValueKey(supplement.id),
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
              tooltip: 'More options',
              onSelected: (value) =>
                  _handleSupplementAction(context, supplement, value),
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

  Widget _buildErrorState(BuildContext context, Object error) {
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
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => _FilterBottomSheet(
        showActive: _showActive,
        showArchived: _showArchived,
        onChanged: ({required showActive, required showArchived}) {
          setState(() {
            _showActive = showActive;
            _showArchived = showArchived;
          });
        },
      ),
    );
  }

  void _navigateToAddSupplement(BuildContext context) {
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
        await _toggleArchive(context, supplement);
    }
  }

  void _navigateToLogIntake(BuildContext context, Supplement supplement) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            SupplementLogScreen(profileId: profileId, supplement: supplement),
      ),
    );
  }

  Future<void> _toggleArchive(
    BuildContext context,
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
class _FilterBottomSheet extends StatefulWidget {
  final bool showActive;
  final bool showArchived;
  final void Function({required bool showActive, required bool showArchived})
  onChanged;

  const _FilterBottomSheet({
    required this.showActive,
    required this.showArchived,
    required this.onChanged,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late bool _showActive;
  late bool _showArchived;

  @override
  void initState() {
    super.initState();
    _showActive = widget.showActive;
    _showArchived = widget.showArchived;
  }

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
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Active only'),
            trailing: Switch(
              value: _showActive,
              onChanged: (value) => setState(() => _showActive = value),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.archive),
            title: const Text('Show archived'),
            trailing: Switch(
              value: _showArchived,
              onChanged: (value) => setState(() => _showArchived = value),
            ),
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
                onPressed: () {
                  widget.onChanged(
                    showActive: _showActive,
                    showArchived: _showArchived,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
