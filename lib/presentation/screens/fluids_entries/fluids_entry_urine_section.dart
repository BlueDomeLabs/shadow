// lib/presentation/screens/fluids_entries/fluids_entry_urine_section.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Urine section extracted from FluidsEntryScreen.
///
/// Stateless — all state is owned by the parent. Each user action fires a
/// callback; the parent calls setState and rebuilds.
class FluidsEntryUrineSection extends StatelessWidget {
  final bool hadUrination;
  final UrineCondition? urineCondition;
  final TextEditingController customColorController;
  final String? customColorError;
  final MovementSize urineSize;
  final String? urinePhotoPath;
  final ValueChanged<bool> onToggleChanged;
  final void Function(UrineCondition?) onConditionChanged;
  final VoidCallback onCustomColorChanged;
  final void Function(MovementSize) onSizeChanged;
  final VoidCallback onAddPhoto;
  final VoidCallback onRemovePhoto;

  const FluidsEntryUrineSection({
    super.key,
    required this.hadUrination,
    required this.urineCondition,
    required this.customColorController,
    required this.customColorError,
    required this.urineSize,
    required this.urinePhotoPath,
    required this.onToggleChanged,
    required this.onConditionChanged,
    required this.onCustomColorChanged,
    required this.onSizeChanged,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  String _urineConditionLabel(UrineCondition condition) => switch (condition) {
    UrineCondition.clear => 'Clear',
    UrineCondition.lightYellow => 'Light Yellow',
    UrineCondition.yellow => 'Yellow',
    UrineCondition.darkYellow => 'Dark Yellow',
    UrineCondition.amber => 'Amber',
    UrineCondition.brown => 'Brown',
    UrineCondition.red => 'Red',
    UrineCondition.custom => 'Custom',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle
        Semantics(
          label: 'Had urination, toggle',
          toggled: hadUrination,
          child: ExcludeSemantics(
            child: SwitchListTile(
              title: const Text('Had Urination'),
              value: hadUrination,
              onChanged: onToggleChanged,
            ),
          ),
        ),

        if (hadUrination) ...[
          const SizedBox(height: 16),

          // Color dropdown
          Semantics(
            label: 'Urine color, select from scale',
            child: ExcludeSemantics(
              child: DropdownButtonFormField<UrineCondition>(
                initialValue: urineCondition,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  hintText: 'Select color',
                ),
                items: UrineCondition.values
                    .map(
                      (condition) => DropdownMenuItem<UrineCondition>(
                        value: condition,
                        child: Text(_urineConditionLabel(condition)),
                      ),
                    )
                    .toList(),
                onChanged: onConditionChanged,
              ),
            ),
          ),

          // Custom color field
          if (urineCondition == UrineCondition.custom) ...[
            const SizedBox(height: 16),
            ShadowTextField(
              controller: customColorController,
              label: 'Custom Color',
              hintText: 'Describe',
              errorText: customColorError,
              maxLength: ValidationRules.nameMaxLength,
              textInputAction: TextInputAction.next,
              onChanged: (_) => onCustomColorChanged(),
            ),
          ],

          const SizedBox(height: 16),

          // Size dropdown
          Semantics(
            label: 'Urination volume, small medium or large',
            child: ExcludeSemantics(
              child: DropdownButtonFormField<MovementSize>(
                initialValue: urineSize,
                decoration: const InputDecoration(labelText: 'Size'),
                items: const [
                  DropdownMenuItem(
                    value: MovementSize.small,
                    child: Text('Small'),
                  ),
                  DropdownMenuItem(
                    value: MovementSize.medium,
                    child: Text('Medium'),
                  ),
                  DropdownMenuItem(
                    value: MovementSize.large,
                    child: Text('Large'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) onSizeChanged(value);
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Photo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (urinePhotoPath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(urinePhotoPath!),
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
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: onRemovePhoto,
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Remove photo'),
                ),
                const SizedBox(height: 8),
              ],
              Semantics(
                label: 'Take photo of urine, optional',
                child: ExcludeSemantics(
                  child: OutlinedButton.icon(
                    key: const Key('add_urine_photo_button'),
                    onPressed: onAddPhoto,
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Add photo'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
