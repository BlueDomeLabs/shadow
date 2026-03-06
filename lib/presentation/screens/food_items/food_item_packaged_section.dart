// lib/presentation/screens/food_items/food_item_packaged_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Packaged food item section: scan shortcuts, brand, barcode, ingredients
/// fields, and optional import source badge.
class FoodItemPackagedSection extends StatelessWidget {
  final TextEditingController brandController;
  final TextEditingController barcodeController;
  final TextEditingController ingredientsTextController;
  final String? importSource;
  final String? imageUrl;
  final VoidCallback onScanBarcode;
  final VoidCallback onScanLabel;

  const FoodItemPackagedSection({
    super.key,
    required this.brandController,
    required this.barcodeController,
    required this.ingredientsTextController,
    required this.importSource,
    required this.imageUrl,
    required this.onScanBarcode,
    required this.onScanLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scan shortcuts
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onScanBarcode,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Barcode'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onScanLabel,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Scan Label'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Brand
        ShadowTextField(
          controller: brandController,
          label: 'Brand',
          hintText: 'e.g., Organic Valley',
          maxLength: ValidationRules.nameMaxLength,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        // Barcode row with inline scan icon
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ShadowTextField(
                controller: barcodeController,
                label: 'Barcode',
                hintText: 'e.g., 012345678901',
                maxLength: 13,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: IconButton(
                onPressed: onScanBarcode,
                icon: const Icon(Icons.qr_code_scanner),
                tooltip: 'Scan barcode',
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Ingredients text
        ShadowTextField(
          controller: ingredientsTextController,
          label: 'Ingredients',
          hintText: 'Ingredients list as printed on label',
          maxLength: 5000,
          maxLines: 4,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
        ),
        if (importSource != null) ...[
          const SizedBox(height: 12),
          _buildImportSourceBadge(theme),
        ],
      ],
    );
  }

  Widget _buildImportSourceBadge(ThemeData theme) {
    final label = switch (importSource) {
      'open_food_facts' => 'Open Food Facts',
      'claude_scan' => 'Photo Scan',
      'manual' => 'Manual Entry',
      _ => importSource!,
    };

    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          'Source: $label',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
