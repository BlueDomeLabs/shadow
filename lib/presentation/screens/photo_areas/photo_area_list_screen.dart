// lib/presentation/screens/photo_areas/photo_area_list_screen.dart
// Photo area list screen following ConditionListScreen pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/usecases/photo_areas/photo_areas_usecases.dart';
import 'package:shadow_app/presentation/providers/photo_areas/photo_area_list_provider.dart';
import 'package:shadow_app/presentation/screens/photo_areas/photo_area_edit_screen.dart';
import 'package:shadow_app/presentation/screens/photo_entries/photo_entry_gallery_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen displaying the list of photo areas for a profile.
///
/// Follows [ConditionListScreen] pattern with archive/unarchive.
/// Tapping an area navigates to the photo gallery for that area.
class PhotoAreaListScreen extends ConsumerWidget {
  final String profileId;

  const PhotoAreaListScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areasAsync = ref.watch(photoAreaListProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Photo Areas')),
      body: Semantics(
        label: 'Photo area list',
        child: areasAsync.when(
          data: (areas) => _buildAreaList(context, ref, areas),
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading photo areas'),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Add new photo area',
        child: FloatingActionButton(
          onPressed: () => _navigateToAddArea(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildAreaList(
    BuildContext context,
    WidgetRef ref,
    List<PhotoArea> areas,
  ) {
    if (areas.isEmpty) {
      return _buildEmptyState(context);
    }

    final activeAreas = areas.where((a) => !a.isArchived).toList();
    final archivedAreas = areas.where((a) => a.isArchived).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(photoAreaListProvider(profileId));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activeAreas.isNotEmpty) ...[
            _buildSectionHeader(context, 'Active Areas'),
            const SizedBox(height: 8),
            ...activeAreas.map((area) => _buildAreaCard(context, ref, area)),
          ],
          if (archivedAreas.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Archived Areas'),
            const SizedBox(height: 8),
            ...archivedAreas.map((area) => _buildAreaCard(context, ref, area)),
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

  Widget _buildAreaCard(BuildContext context, WidgetRef ref, PhotoArea area) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadowCard.listItem(
        onTap: () => _navigateToGallery(context, area),
        semanticLabel: area.name,
        semanticHint: 'Double tap to view photos',
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
                Icons.photo_camera,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    area.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: area.isArchived
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (area.description != null &&
                      area.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      area.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (area.consistencyNotes != null &&
                      area.consistencyNotes!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      area.consistencyNotes!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              tooltip: 'More options',
              onSelected: (value) =>
                  _handleAreaAction(context, ref, area, value),
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
                  value: area.isArchived ? 'unarchive' : 'archive',
                  child: ListTile(
                    leading: Icon(
                      area.isArchived ? Icons.unarchive : Icons.archive,
                    ),
                    title: Text(area.isArchived ? 'Unarchive' : 'Archive'),
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
              Icons.photo_library_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No photo areas yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first photo area',
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
              'Failed to load photo areas',
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
              onPressed: () => ref.invalidate(photoAreaListProvider(profileId)),
              label: 'Retry',
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddArea(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => PhotoAreaEditScreen(profileId: profileId),
      ),
    );
  }

  void _navigateToEditArea(BuildContext context, PhotoArea area) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            PhotoAreaEditScreen(profileId: profileId, photoArea: area),
      ),
    );
  }

  void _navigateToGallery(BuildContext context, PhotoArea area) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            PhotoEntryGalleryScreen(profileId: profileId, photoArea: area),
      ),
    );
  }

  Future<void> _handleAreaAction(
    BuildContext context,
    WidgetRef ref,
    PhotoArea area,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        _navigateToEditArea(context, area);
      case 'archive':
      case 'unarchive':
        await _toggleArchive(context, ref, area);
    }
  }

  Future<void> _toggleArchive(
    BuildContext context,
    WidgetRef ref,
    PhotoArea area,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: area.isArchived ? 'Unarchive Photo Area?' : 'Archive Photo Area?',
      contentText: area.isArchived
          ? 'This photo area will appear in your active list again.'
          : 'This photo area will be moved to the archived section.',
      confirmButtonText: area.isArchived ? 'Unarchive' : 'Archive',
    );

    if (confirmed ?? false) {
      try {
        await ref
            .read(photoAreaListProvider(profileId).notifier)
            .archive(
              ArchivePhotoAreaInput(
                id: area.id,
                profileId: profileId,
                archive: !area.isArchived,
              ),
            );
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: area.isArchived
                ? 'Photo area unarchived'
                : 'Photo area archived',
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
