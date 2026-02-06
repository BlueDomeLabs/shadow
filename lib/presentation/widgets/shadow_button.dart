/// Accessible button components for Shadow app.
///
/// Provides [ShadowButton] with configurable variants for all button use cases,
/// following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full requirements
/// * [ShadowTextField] for form inputs
/// * [ShadowCard] for tappable containers
library;

import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

/// A consolidated button widget with accessible semantics.
///
/// [ShadowButton] provides a unified interface for all button variants
/// in the Shadow app, ensuring consistent accessibility support.
///
/// {@template shadow_button}
/// All button instances:
/// - Meet WCAG 2.1 touch target requirements (48x48 dp minimum)
/// - Include semantic labels for screen readers
/// - Support disabled states with appropriate styling
/// {@endtemplate}
///
/// ## Basic Usage
///
/// ```dart
/// ShadowButton(
///   label: 'Save',
///   onPressed: () => save(),
/// )
/// ```
///
/// ## Variants
///
/// ```dart
/// // Elevated button (default)
/// ShadowButton(
///   variant: ButtonVariant.elevated,
///   label: 'Primary Action',
///   onPressed: doAction,
/// )
///
/// // Text button
/// ShadowButton(
///   variant: ButtonVariant.text,
///   label: 'Cancel',
///   onPressed: cancel,
/// )
///
/// // Icon button
/// ShadowButton(
///   variant: ButtonVariant.icon,
///   icon: Icons.add,
///   label: 'Add item',
///   onPressed: addItem,
/// )
/// ```
///
/// See also:
///
/// * [ButtonVariant] for available button styles
/// * [ShadowTextField] for form inputs
/// * [38_UI_FIELD_SPECIFICATIONS.md] for field-level button requirements
class ShadowButton extends StatelessWidget {
  /// The visual variant of the button.
  ///
  /// Defaults to [ButtonVariant.elevated].
  final ButtonVariant variant;

  /// Called when the button is tapped.
  ///
  /// If null, the button is disabled and appears grayed out.
  final VoidCallback? onPressed;

  /// The semantic label for screen readers.
  ///
  /// This is announced by VoiceOver/TalkBack when the button receives focus.
  /// Must describe the button's action, e.g., "Save supplement" not just "Save".
  final String label;

  /// Optional hint providing additional context.
  ///
  /// Announced after [label] by screen readers. Use for clarification,
  /// e.g., "Double-tap to activate".
  final String? hint;

  /// The icon to display for [ButtonVariant.icon] or [ButtonVariant.fab].
  ///
  /// Required when [variant] is [ButtonVariant.icon] or [ButtonVariant.fab].
  final IconData? icon;

  /// Custom child widget.
  ///
  /// If provided, overrides the default text/icon content.
  final Widget? child;

  /// Custom button style.
  ///
  /// Merged with the default style for this [variant].
  final ButtonStyle? style;

  /// Creates an accessible button.
  ///
  /// The [label] is required for accessibility and must describe the action.
  const ShadowButton({
    super.key,
    this.variant = ButtonVariant.elevated,
    required this.onPressed,
    required this.label,
    this.hint,
    this.icon,
    this.child,
    this.style,
  });

  /// Creates an elevated button (convenience constructor).
  const ShadowButton.elevated({
    super.key,
    required this.onPressed,
    required this.label,
    this.hint,
    this.icon,
    this.child,
    this.style,
  }) : variant = ButtonVariant.elevated;

  /// Creates a text button (convenience constructor).
  const ShadowButton.text({
    super.key,
    required this.onPressed,
    required this.label,
    this.hint,
    this.icon,
    this.child,
    this.style,
  }) : variant = ButtonVariant.text;

  /// Creates an icon button (convenience constructor).
  const ShadowButton.icon({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.hint,
    this.child,
    this.style,
  }) : variant = ButtonVariant.icon;

  /// Creates a floating action button (convenience constructor).
  const ShadowButton.fab({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.hint,
    this.child,
    this.style,
  }) : variant = ButtonVariant.fab;

  /// Creates an outlined button (convenience constructor).
  const ShadowButton.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.hint,
    this.icon,
    this.child,
    this.style,
  }) : variant = ButtonVariant.outlined;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    hint: hint,
    button: true,
    enabled: onPressed != null,
    child: _buildButton(context),
  );

  Widget _buildButton(BuildContext context) {
    switch (variant) {
      case ButtonVariant.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: _content,
        );
      case ButtonVariant.text:
        return TextButton(onPressed: onPressed, style: style, child: _content);
      case ButtonVariant.icon:
        return SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            tooltip: label,
            style: style,
          ),
        );
      case ButtonVariant.fab:
        return FloatingActionButton(
          onPressed: onPressed,
          tooltip: label,
          child: icon != null ? Icon(icon) : child,
        );
      case ButtonVariant.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: _content,
        );
    }
  }

  Widget get _content {
    if (child != null) {
      if (icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(icon), const SizedBox(width: 8), child!],
        );
      }
      return child!;
    }
    if (icon != null) {
      return Icon(icon);
    }
    // When using label as text content, exclude from semantics
    // to avoid duplication with outer Semantics wrapper
    return ExcludeSemantics(child: Text(label));
  }
}
