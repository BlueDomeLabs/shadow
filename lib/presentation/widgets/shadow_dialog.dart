/// Accessible dialog components for Shadow app.
///
/// Provides [ShadowDialog] and helper functions for standard dialogs,
/// following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full requirements
/// * [ShadowButton] for dialog actions
library;

import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/widgets/shadow_button.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

/// A consolidated dialog widget with accessible semantics.
///
/// [ShadowDialog] provides a unified interface for all dialog types
/// in the Shadow app.
///
/// {@template shadow_dialog}
/// All dialog instances:
/// - Meet WCAG 2.1 accessibility requirements
/// - Include proper focus management
/// - Support keyboard navigation
/// {@endtemplate}
///
/// ## Basic Usage
///
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => ShadowDialog(
///     title: 'Delete Item?',
///     content: 'This action cannot be undone.',
///     actions: [
///       ShadowButton.text(label: 'Cancel', onPressed: () => Navigator.pop(context)),
///       ShadowButton.elevated(label: 'Delete', onPressed: () => deleteAndClose()),
///     ],
///   ),
/// );
/// ```
class ShadowDialog extends StatelessWidget {
  /// The dialog type determining default behavior.
  ///
  /// Defaults to [DialogType.alert].
  final DialogType dialogType;

  /// The dialog title.
  final String title;

  /// The dialog content text.
  ///
  /// Either [content] or [contentWidget] must be provided.
  final String? content;

  /// Custom content widget.
  ///
  /// Used when more than simple text is needed.
  final Widget? contentWidget;

  /// The semantic label for screen readers.
  final String? semanticLabel;

  /// The dialog action buttons.
  final List<Widget>? actions;

  /// Creates an accessible dialog.
  const ShadowDialog({
    super.key,
    this.dialogType = DialogType.alert,
    required this.title,
    this.content,
    this.contentWidget,
    this.semanticLabel,
    this.actions,
  }) : assert(
         content != null || contentWidget != null,
         'Either content or contentWidget must be provided',
       );

  /// Creates an alert dialog (convenience constructor).
  const ShadowDialog.alert({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.semanticLabel,
    this.actions,
  }) : dialogType = DialogType.alert;

  /// Creates a confirmation dialog (convenience constructor).
  const ShadowDialog.confirm({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.semanticLabel,
    this.actions,
  }) : dialogType = DialogType.confirm;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel ?? 'Dialog: $title',
    child: AlertDialog(
      title: Text(title),
      content: contentWidget ?? (content != null ? Text(content!) : null),
      actions: actions,
    ),
  );
}

/// Shows a delete confirmation dialog.
///
/// Returns `true` if confirmed, `false` or `null` if cancelled.
///
/// ```dart
/// final confirmed = await showDeleteConfirmationDialog(
///   context: context,
///   title: 'Delete Supplement',
///   contentText: 'Are you sure you want to delete "Vitamin D3"?',
/// );
///
/// if (confirmed == true) {
///   // Perform deletion
/// }
/// ```
Future<bool?> showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String contentText,
  String confirmButtonText = 'Delete',
  String cancelButtonText = 'Cancel',
}) => showDialog<bool>(
  context: context,
  builder: (context) => ShadowDialog.confirm(
    title: title,
    content: contentText,
    semanticLabel: 'Confirmation dialog: $title',
    actions: [
      ShadowButton.text(
        label: cancelButtonText,
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(cancelButtonText),
      ),
      ShadowButton.elevated(
        label: confirmButtonText,
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(confirmButtonText),
      ),
    ],
  ),
);

/// Shows a text input dialog.
///
/// Returns the entered text if confirmed, `null` if cancelled.
///
/// ```dart
/// final categoryName = await showTextInputDialog(
///   context: context,
///   title: 'New Category',
///   labelText: 'Category Name',
///   hintText: 'Enter category name',
/// );
///
/// if (categoryName != null) {
///   // Use the sanitized input
/// }
/// ```
Future<String?> showTextInputDialog({
  required BuildContext context,
  required String title,
  required String labelText,
  String? hintText,
  String? initialValue,
  String confirmButtonText = 'OK',
  String cancelButtonText = 'Cancel',
  int maxLines = 1,
  TextCapitalization textCapitalization = TextCapitalization.none,
}) {
  final controller = TextEditingController(text: initialValue);

  return showDialog<String>(
    context: context,
    builder: (context) => ShadowDialog(
      dialogType: DialogType.input,
      title: title,
      contentWidget: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: labelText, hintText: hintText),
        maxLines: maxLines,
        textCapitalization: textCapitalization,
        autofocus: true,
      ),
      semanticLabel: 'Text input dialog: $title',
      actions: [
        ShadowButton.text(
          label: cancelButtonText,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelButtonText),
        ),
        ShadowButton.elevated(
          label: confirmButtonText,
          onPressed: () {
            final text = controller.text.trim();
            Navigator.of(context).pop(text.isEmpty ? null : text);
          },
          child: Text(confirmButtonText),
        ),
      ],
    ),
  );
}

/// Shows an accessible snackbar notification.
///
/// Uses `liveRegion: true` for immediate screen reader announcement.
void showAccessibleSnackBar({
  required BuildContext context,
  required String message,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Semantics(liveRegion: true, child: Text(message)),
      duration: duration,
      action: actionLabel != null && onAction != null
          ? SnackBarAction(label: actionLabel, onPressed: onAction)
          : null,
    ),
  );
}
