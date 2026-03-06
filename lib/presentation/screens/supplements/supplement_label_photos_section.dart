// lib/presentation/screens/supplements/supplement_label_photos_section.dart

import 'dart:io';

import 'package:flutter/material.dart';

/// Displays label photo thumbnails and buttons to add or remove photos.
///
/// Used inside SupplementEditScreen. Maximum 3 photos per supplement.
class SupplementLabelPhotosSection extends StatelessWidget {
  final List<String> photoPaths;
  final VoidCallback onTakePhoto;
  final VoidCallback onPickFromLibrary;
  final void Function(int index) onRemovePhoto;

  const SupplementLabelPhotosSection({
    super.key,
    required this.photoPaths,
    required this.onTakePhoto,
    required this.onPickFromLibrary,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photoPaths.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: photoPaths
                .asMap()
                .entries
                .map(
                  (entry) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(entry.value),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          tooltip: 'Remove photo',
                          onPressed: () => onRemovePhoto(entry.key),
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface
                                .withAlpha(180),
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(24, 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (photoPaths.length < 3) ...[
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: onTakePhoto,
                icon: const Icon(Icons.camera_alt, size: 18),
                label: const Text('Take Photo'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onPickFromLibrary,
                icon: const Icon(Icons.photo_library, size: 18),
                label: const Text('Choose from Library'),
              ),
            ],
          ),
        ] else ...[
          Text(
            'Maximum 3 label photos per supplement',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
