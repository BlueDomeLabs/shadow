// lib/core/utils/photo_picker_utils.dart
// Shared photo picker utility for Camera / Photo Library selection.

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as image_picker;

/// Shows a bottom sheet offering "Camera" and "Photo Library" options, then
/// opens [image_picker.ImagePicker] with the chosen source.
///
/// Returns the [String] path of the selected image, or `null` if the user
/// cancelled or no source was selected.
///
/// Throws [Exception] if the chosen source is unavailable (e.g. no camera on
/// this device). The caller is responsible for catching this and showing an
/// appropriate snack bar.
Future<String?> showPhotoPicker(BuildContext context) async {
  if (!context.mounted) return null;

  final source = await showModalBottomSheet<image_picker.ImageSource>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () => Navigator.pop(ctx, image_picker.ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Photo Library'),
            onTap: () => Navigator.pop(ctx, image_picker.ImageSource.gallery),
          ),
        ],
      ),
    ),
  );

  if (source == null) return null;

  final picker = image_picker.ImagePicker();
  final photo = await picker.pickImage(source: source);
  return photo?.path;
}
