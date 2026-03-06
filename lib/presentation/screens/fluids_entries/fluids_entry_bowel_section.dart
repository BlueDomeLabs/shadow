// lib/presentation/screens/fluids_entries/fluids_entry_bowel_section.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Bowel movement section extracted from FluidsEntryScreen.
///
/// Stateless — all state is owned by the parent. Each user action fires a
/// callback; the parent calls setState and rebuilds.
class FluidsEntryBowelSection extends StatelessWidget {
  final bool hadBowelMovement;
  final BowelCondition? bowelCondition;
  final TextEditingController customConditionController;
  final String? customConditionError;
  final MovementSize bowelSize;
  final String? bowelPhotoPath;
  final ValueChanged<bool> onToggleChanged;
  final void Function(BowelCondition?) onConditionChanged;
  final VoidCallback onCustomConditionChanged;
  final void Function(MovementSize) onSizeChanged;
  final VoidCallback onAddPhoto;
  final VoidCallback onRemovePhoto;

  const FluidsEntryBowelSection({
    super.key,
    required this.hadBowelMovement,
    required this.bowelCondition,
    required this.customConditionController,
    required this.customConditionError,
    required this.bowelSize,
    required this.bowelPhotoPath,
    required this.onToggleChanged,
    required this.onConditionChanged,
    required this.onCustomConditionChanged,
    required this.onSizeChanged,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  String _bowelConditionLabel(BowelCondition condition) => switch (condition) {
    BowelCondition.diarrhea => 'Diarrhea',
    BowelCondition.runny => 'Runny',
    BowelCondition.loose => 'Loose',
    BowelCondition.normal => 'Normal',
    BowelCondition.firm => 'Firm',
    BowelCondition.hard => 'Hard',
    BowelCondition.custom => 'Custom',
  };

  String _movementSizeLabel(MovementSize size) => switch (size) {
    MovementSize.tiny => 'Tiny',
    MovementSize.small => 'Small',
    MovementSize.medium => 'Medium',
    MovementSize.large => 'Large',
    MovementSize.huge => 'Huge',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle
        Semantics(
          label: 'Had bowel movement, toggle',
          toggled: hadBowelMovement,
          child: ExcludeSemantics(
            child: SwitchListTile(
              title: const Text('Had Bowel Movement'),
              value: hadBowelMovement,
              onChanged: onToggleChanged,
            ),
          ),
        ),

        if (hadBowelMovement) ...[
          const SizedBox(height: 16),

          // Condition dropdown
          Semantics(
            label: 'Bristol stool scale, 1 to 7, required if bowel movement',
            child: ExcludeSemantics(
              child: DropdownButtonFormField<BowelCondition>(
                initialValue: bowelCondition,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                  hintText: 'Select',
                ),
                items: BowelCondition.values
                    .map(
                      (condition) => DropdownMenuItem<BowelCondition>(
                        value: condition,
                        child: Text(_bowelConditionLabel(condition)),
                      ),
                    )
                    .toList(),
                onChanged: onConditionChanged,
              ),
            ),
          ),

          // Custom condition field
          if (bowelCondition == BowelCondition.custom) ...[
            const SizedBox(height: 16),
            ShadowTextField(
              controller: customConditionController,
              label: 'Custom Condition',
              hintText: 'Describe',
              errorText: customConditionError,
              maxLength: ValidationRules.nameMaxLength,
              textInputAction: TextInputAction.next,
              onChanged: (_) => onCustomConditionChanged(),
            ),
          ],

          const SizedBox(height: 16),

          // Size dropdown
          Semantics(
            label: 'Movement size, small medium or large',
            child: ExcludeSemantics(
              child: DropdownButtonFormField<MovementSize>(
                initialValue: bowelSize,
                decoration: const InputDecoration(labelText: 'Size'),
                items: MovementSize.values
                    .map(
                      (size) => DropdownMenuItem<MovementSize>(
                        value: size,
                        child: Text(_movementSizeLabel(size)),
                      ),
                    )
                    .toList(),
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
              if (bowelPhotoPath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(bowelPhotoPath!),
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
                label: 'Take photo of bowel movement, optional',
                child: ExcludeSemantics(
                  child: OutlinedButton.icon(
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
