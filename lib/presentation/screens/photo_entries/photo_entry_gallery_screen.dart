// lib/presentation/screens/photo_entries/photo_entry_gallery_screen.dart
// Photo entry gallery screen for viewing/adding photos in a photo area.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/usecases/photo_entries/photo_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/photo_entries/photo_entry_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Gallery screen showing photos for a given photo area.
///
/// Displays grid of photos filtered by area.
/// FAB to add new photo via camera/gallery picker.
/// Tap photo to view full-screen, long-press for delete.
class PhotoEntryGalleryScreen extends ConsumerWidget {
  final String profileId;
  final PhotoArea photoArea;

  const PhotoEntryGalleryScreen({
    super.key,
    required this.profileId,
    required this.photoArea,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(photoEntryListProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: Text(photoArea.name),
        actions: [
          if (photoArea.consistencyNotes != null &&
              photoArea.consistencyNotes!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showConsistencyNotes(context),
              tooltip: 'Photo tips',
            ),
        ],
      ),
      body: Semantics(
        label: 'Photo gallery for ${photoArea.name}',
        child: entriesAsync.when(
          data: (allEntries) {
            final entries =
                allEntries.where((e) => e.photoAreaId == photoArea.id).toList()
                  ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
            return _buildGallery(context, ref, entries);
          },
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading photos'),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Add new photo',
        child: FloatingActionButton(
          onPressed: () => _showAddPhotoOptions(context, ref),
          child: const Icon(Icons.add_a_photo),
        ),
      ),
    );
  }

  Widget _buildGallery(
    BuildContext context,
    WidgetRef ref,
    List<PhotoEntry> entries,
  ) {
    if (entries.isEmpty) {
      return _buildEmptyState(context);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildPhotoTile(context, ref, entry);
      },
    );
  }

  Widget _buildPhotoTile(
    BuildContext context,
    WidgetRef ref,
    PhotoEntry entry,
  ) {
    final file = File(entry.filePath);
    final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
    final dateStr = '${date.month}/${date.day}/${date.year}';

    return Semantics(
      label: 'Photo from $dateStr',
      child: GestureDetector(
        onTap: () => _viewFullScreen(context, entry),
        onLongPress: () => _confirmDelete(context, ref, entry),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: file.existsSync()
              ? Image.file(file, fit: BoxFit.cover)
              : ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image),
                ),
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
              Icons.photo_camera_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No photos yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap the camera button to add your first photo',
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
            Text('Failed to load photos', style: theme.textTheme.titleLarge),
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
                  ref.invalidate(photoEntryListProvider(profileId)),
              label: 'Retry',
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConsistencyNotes(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Photo Tips'),
        content: Text(photoArea.consistencyNotes!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddPhotoOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(context, ref, picker.ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(context, ref, picker.ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhoto(
    BuildContext context,
    WidgetRef ref,
    picker.ImageSource source,
  ) async {
    try {
      final imagePicker = picker.ImagePicker();
      final image = await imagePicker.pickImage(source: source);
      if (image == null || !context.mounted) return;

      final file = File(image.path);
      final fileSize = await file.length();
      if (!context.mounted) return;

      // Show details dialog for notes and date/time
      final details = await showDialog<_PhotoEntryDetails>(
        context: context,
        builder: (context) => _PhotoDetailsDialog(filePath: image.path),
      );
      if (details == null || !context.mounted) return;

      await ref
          .read(photoEntryListProvider(profileId).notifier)
          .create(
            CreatePhotoEntryInput(
              profileId: profileId,
              clientId: const Uuid().v4(),
              photoAreaId: photoArea.id,
              timestamp: details.timestamp,
              notes: details.notes?.isNotEmpty ?? false ? details.notes : null,
              filePath: image.path,
              fileSizeBytes: fileSize,
            ),
          );

      if (context.mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Photo added successfully',
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
          message: 'Failed to add photo',
        );
      }
    }
  }

  void _viewFullScreen(BuildContext context, PhotoEntry entry) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => _FullScreenPhotoView(entry: entry),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    PhotoEntry entry,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Delete Photo?',
      contentText: 'This photo will be permanently deleted.',
    );

    if (confirmed ?? false) {
      try {
        await ref
            .read(photoEntryListProvider(profileId).notifier)
            .delete(DeletePhotoEntryInput(id: entry.id, profileId: profileId));
        if (context.mounted) {
          showAccessibleSnackBar(context: context, message: 'Photo deleted');
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

/// Data returned from the photo details dialog.
class _PhotoEntryDetails {
  final int timestamp;
  final String? notes;

  const _PhotoEntryDetails({required this.timestamp, this.notes});
}

/// Dialog for entering photo details (notes and date/time) after selecting a photo.
class _PhotoDetailsDialog extends StatefulWidget {
  final String filePath;

  const _PhotoDetailsDialog({required this.filePath});

  @override
  State<_PhotoDetailsDialog> createState() => _PhotoDetailsDialogState();
}

class _PhotoDetailsDialogState extends State<_PhotoDetailsDialog> {
  final _notesController = TextEditingController();
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${_selectedDateTime.month}/${_selectedDateTime.day}/${_selectedDateTime.year}';
    final hour = _selectedDateTime.hour % 12 == 0
        ? 12
        : _selectedDateTime.hour % 12;
    final minute = _selectedDateTime.minute.toString().padLeft(2, '0');
    final period = _selectedDateTime.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $period';

    return AlertDialog(
      title: const Text('Photo Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Time
            Semantics(
              label: 'Photo date and time',
              child: ExcludeSemantics(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today),
                        label: Text(dateStr),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickTime,
                        icon: const Icon(Icons.access_time),
                        label: Text(timeStr),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Notes
            Semantics(
              label: 'Photo notes, optional',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _notesController,
                  label: 'Notes',
                  hintText: 'Notes about this photo',
                  maxLength: ValidationRules.notesMaxLength,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            _PhotoEntryDetails(
              timestamp: _selectedDateTime.millisecondsSinceEpoch,
              notes: _notesController.text.trim(),
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }
}

/// Full-screen photo viewer.
class _FullScreenPhotoView extends StatelessWidget {
  final PhotoEntry entry;

  const _FullScreenPhotoView({required this.entry});

  @override
  Widget build(BuildContext context) {
    final file = File(entry.filePath);
    final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
    final dateStr = '${date.month}/${date.day}/${date.year}';

    return Scaffold(
      appBar: AppBar(
        title: Text(dateStr),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: file.existsSync()
            ? InteractiveViewer(child: Image.file(file))
            : const Icon(Icons.broken_image, color: Colors.white, size: 64),
      ),
    );
  }
}
