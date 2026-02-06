/// Accessible text input components for Shadow app.
///
/// Provides [ShadowTextField] with configurable input types for all form fields,
/// following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full requirements
/// * [ShadowButton] for form buttons
/// * [38_UI_FIELD_SPECIFICATIONS.md] for field specifications
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

/// A consolidated text field widget with accessible semantics.
///
/// [ShadowTextField] provides a unified interface for all text input variants
/// in the Shadow app, including text, numeric, password, and dropdown.
///
/// {@template shadow_text_field}
/// All text field instances:
/// - Meet WCAG 2.1 accessibility requirements
/// - Include semantic labels for screen readers
/// - Support error states with appropriate announcements
/// {@endtemplate}
///
/// ## Basic Usage
///
/// ```dart
/// ShadowTextField(
///   label: 'Supplement Name',
///   controller: _nameController,
///   onChanged: (value) => validate(value),
/// )
/// ```
///
/// ## Input Types
///
/// ```dart
/// // Text input (default)
/// ShadowTextField(
///   inputType: InputType.text,
///   label: 'Name',
/// )
///
/// // Numeric input
/// ShadowTextField(
///   inputType: InputType.numeric,
///   label: 'Dosage Amount',
/// )
///
/// // Password input
/// ShadowTextField(
///   inputType: InputType.password,
///   label: 'Password',
/// )
/// ```
class ShadowTextField extends StatelessWidget {
  /// The input type determining keyboard and masking behavior.
  ///
  /// Defaults to [InputType.text].
  final InputType inputType;

  /// The text editing controller.
  final TextEditingController? controller;

  /// The field label displayed above the input.
  final String label;

  /// Optional semantic label for screen readers.
  ///
  /// If not provided, [label] is used.
  final String? semanticLabel;

  /// Optional hint providing additional context for screen readers.
  final String? semanticHint;

  /// Placeholder text displayed when the field is empty.
  final String? hintText;

  /// Helper text displayed below the field.
  final String? helperText;

  /// Error text displayed when validation fails.
  ///
  /// When non-null, the field displays in error state.
  final String? errorText;

  /// The keyboard type for text input.
  final TextInputType? keyboardType;

  /// The keyboard action button type.
  final TextInputAction? textInputAction;

  /// Maximum number of lines for the input.
  final int maxLines;

  /// Maximum character length.
  final int? maxLength;

  /// Whether the field is enabled.
  final bool enabled;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Called when the user submits.
  final ValueChanged<String>? onSubmitted;

  /// Focus node for managing focus.
  final FocusNode? focusNode;

  /// Input formatters for text validation.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to obscure text (for passwords).
  final bool obscureText;

  /// Prefix icon.
  final IconData? prefixIcon;

  /// Suffix icon.
  final IconData? suffixIcon;

  /// Callback when suffix icon is tapped.
  final VoidCallback? onSuffixTap;

  /// Creates an accessible text field.
  ///
  /// The [label] is required for accessibility.
  const ShadowTextField({
    super.key,
    this.inputType = InputType.text,
    this.controller,
    required this.label,
    this.semanticLabel,
    this.semanticHint,
    this.hintText,
    this.helperText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.focusNode,
    this.inputFormatters,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  });

  /// Creates a text input field (convenience constructor).
  const ShadowTextField.text({
    super.key,
    this.controller,
    required this.label,
    this.semanticLabel,
    this.semanticHint,
    this.hintText,
    this.helperText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.focusNode,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  }) : inputType = InputType.text,
       obscureText = false;

  /// Creates a numeric input field (convenience constructor).
  const ShadowTextField.numeric({
    super.key,
    this.controller,
    required this.label,
    this.semanticLabel,
    this.semanticHint,
    this.hintText,
    this.helperText,
    this.errorText,
    this.textInputAction,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.focusNode,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  }) : inputType = InputType.numeric,
       keyboardType = TextInputType.number,
       maxLines = 1,
       obscureText = false;

  /// Creates a password input field (convenience constructor).
  const ShadowTextField.password({
    super.key,
    this.controller,
    required this.label,
    this.semanticLabel,
    this.semanticHint,
    this.hintText,
    this.helperText,
    this.errorText,
    this.textInputAction,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.focusNode,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  }) : inputType = InputType.password,
       keyboardType = TextInputType.visiblePassword,
       maxLines = 1,
       obscureText = true;

  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(icon: Icon(suffixIcon), onPressed: onSuffixTap)
            : null,
      ),
      keyboardType: _effectiveKeyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      obscureText: _effectiveObscureText,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      inputFormatters: _effectiveInputFormatters,
    );

    // Only wrap in Semantics when custom semanticLabel differs from label
    // TextField already provides semantics via labelText
    if (semanticLabel != null && semanticLabel != label) {
      return Semantics(
        label: semanticLabel,
        hint: semanticHint,
        textField: true,
        enabled: enabled,
        child: ExcludeSemantics(child: textField),
      );
    }

    // When semanticHint is provided without custom label, add it via Semantics
    if (semanticHint != null) {
      return Semantics(hint: semanticHint, child: textField);
    }

    return textField;
  }

  TextInputType get _effectiveKeyboardType {
    if (keyboardType != null) return keyboardType!;
    switch (inputType) {
      case InputType.text:
        return TextInputType.text;
      case InputType.dropdown:
        return TextInputType.text;
      case InputType.numeric:
        return TextInputType.number;
      case InputType.password:
        return TextInputType.visiblePassword;
    }
  }

  bool get _effectiveObscureText {
    if (inputType == InputType.password) return true;
    return obscureText;
  }

  List<TextInputFormatter>? get _effectiveInputFormatters {
    if (inputFormatters != null) return inputFormatters;
    if (inputType == InputType.numeric) {
      return [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))];
    }
    return null;
  }
}
