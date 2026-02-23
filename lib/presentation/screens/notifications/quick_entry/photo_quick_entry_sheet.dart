// lib/presentation/screens/notifications/quick_entry/photo_quick_entry_sheet.dart
// Per 57_NOTIFICATION_SYSTEM.md — Photos quick-entry sheet

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/presentation/providers/photo_areas/photo_area_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Quick-entry sheet for Photos notification category.
///
/// Per spec: "Tap notification → app opens directly to camera within the Photo
/// Entry screen for the configured photo area."
///
/// This sheet presents photo areas for selection. Camera integration is a
/// platform concern deferred to Phase 13d — the sheet provides the selection
/// UI and a clearly-labelled "Take Photo" action. The [onAreaSelected]
/// callback is invoked when the user confirms an area so the caller can
/// navigate to the camera screen.
/// Per 57_NOTIFICATION_SYSTEM.md section: Photos.
class PhotoQuickEntrySheet extends ConsumerWidget {
  final String profileId;

  /// Called with the selected [PhotoArea] when the user taps "Take Photo".
  /// The caller is responsible for navigating to the camera screen.
  final void Function(PhotoArea area)? onAreaSelected;

  const PhotoQuickEntrySheet({
    super.key,
    required this.profileId,
    this.onAreaSelected,
  });

  /// Shows the sheet as a modal bottom sheet.
  ///
  /// [onAreaSelected] is invoked when the user selects a photo area and taps
  /// "Take Photo". The callback receives the selected [PhotoArea] so the
  /// caller can navigate to the camera screen.
  static Future<void> show(
    BuildContext context, {
    required String profileId,
    void Function(PhotoArea area)? onAreaSelected,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => PhotoQuickEntrySheet(
      profileId: profileId,
      onAreaSelected: onAreaSelected,
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final areasAsync = ref.watch(photoAreaListProvider(profileId));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Semantics(
        label: 'Photo check-in quick-entry sheet',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              header: true,
              child: Text('Photo Check-in', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            areasAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
              data: (areas) {
                final active = areas.where((a) => !a.isArchived).toList()
                  ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

                if (active.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'No photo areas defined yet. Add a photo area in the Photos tab first.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ShadowButton.outlined(
                        onPressed: () => Navigator.of(context).pop(),
                        label: 'Dismiss',
                        child: const Text('Dismiss'),
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Select a photo area:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 240),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: active.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final area = active[index];
                          return Semantics(
                            label: 'Take photo for ${area.name}',
                            button: true,
                            child: ListTile(
                              leading: const Icon(Icons.camera_alt_outlined),
                              title: Text(area.name),
                              subtitle: area.description != null
                                  ? Text(
                                      area.description!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : null,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.of(context).pop();
                                onAreaSelected?.call(area);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
