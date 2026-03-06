// lib/presentation/screens/supplements/supplement_scan_shortcuts_bar.dart

import 'package:flutter/material.dart';

/// Two-button shortcut row for scanning a barcode or label image,
/// shown at the top of the Basic Information section in SupplementEditScreen.
class SupplementScanShortcutsBar extends StatelessWidget {
  final VoidCallback onScanBarcode;
  final VoidCallback onScanLabel;

  const SupplementScanShortcutsBar({
    super.key,
    required this.onScanBarcode,
    required this.onScanLabel,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      TextButton.icon(
        onPressed: onScanBarcode,
        icon: const Icon(Icons.qr_code_scanner, size: 18),
        label: const Text('Scan Barcode'),
        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
      ),
      const SizedBox(width: 8),
      TextButton.icon(
        onPressed: onScanLabel,
        icon: const Icon(Icons.camera_alt, size: 18),
        label: const Text('Scan Label'),
        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
      ),
    ],
  );
}
