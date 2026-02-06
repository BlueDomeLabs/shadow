/// Accessible image components for Shadow app.
///
/// Provides [ShadowImage] with configurable image sources and memory
/// optimization, following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [09_WIDGET_LIBRARY.md] Section 1.4 for image specifications
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full accessibility requirements
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

/// A consolidated image widget with accessible semantics and memory optimization.
///
/// [ShadowImage] provides a unified interface for all image display needs
/// in the Shadow app, ensuring consistent accessibility support and
/// efficient memory usage.
///
/// {@template shadow_image}
/// All image instances:
/// - Include semantic labels for screen readers (unless decorative)
/// - Use ResizeImage for memory optimization
/// - Support error and loading states
/// {@endtemplate}
///
/// ## Asset Image
///
/// ```dart
/// ShadowImage.asset(
///   path: 'assets/icons/supplement.png',
///   semanticLabel: 'Supplement icon',
///   width: 48,
///   height: 48,
/// )
/// ```
///
/// ## File Image
///
/// ```dart
/// ShadowImage.file(
///   filePath: '/path/to/photo.jpg',
///   semanticLabel: 'Condition photo',
///   width: 200,
///   height: 200,
/// )
/// ```
///
/// ## Network Image
///
/// ```dart
/// ShadowImage.network(
///   url: 'https://example.com/image.png',
///   semanticLabel: 'Profile picture',
///   width: 100,
///   height: 100,
/// )
/// ```
///
/// See also:
///
/// * [ImageSource] for available image sources
/// * [ShadowCard] for image containers
class ShadowImage extends StatelessWidget {
  /// The type of image source.
  final ImageSource source;

  /// The semantic label for screen readers.
  ///
  /// Required unless [isDecorative] is true.
  final String? semanticLabel;

  /// Whether this image is purely decorative.
  ///
  /// Decorative images are hidden from screen readers.
  final bool isDecorative;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// How to fit the image within its bounds.
  final BoxFit fit;

  /// The asset path (for [ImageSource.asset]).
  final String? assetPath;

  /// The file path (for [ImageSource.file]).
  final String? filePath;

  /// The network URL (for [ImageSource.network]).
  final String? url;

  /// Cache width for memory optimization.
  ///
  /// Images are decoded at this width to reduce memory usage.
  final int? cacheWidth;

  /// Cache height for memory optimization.
  ///
  /// Images are decoded at this height to reduce memory usage.
  final int? cacheHeight;

  /// Widget to show while loading (for network images).
  final Widget? loadingWidget;

  /// Widget to show on error.
  final Widget? errorWidget;

  /// Border radius for the image.
  final BorderRadius? borderRadius;

  /// Callback when image is tapped (for [ImageSource.picker]).
  final VoidCallback? onTap;

  /// Placeholder icon for picker mode.
  final IconData? placeholderIcon;

  /// Creates an image widget.
  const ShadowImage({
    super.key,
    required this.source,
    this.semanticLabel,
    this.isDecorative = false,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.assetPath,
    this.filePath,
    this.url,
    this.cacheWidth,
    this.cacheHeight,
    this.loadingWidget,
    this.errorWidget,
    this.borderRadius,
    this.onTap,
    this.placeholderIcon,
  }) : assert(
         isDecorative || semanticLabel != null,
         'semanticLabel is required unless isDecorative is true',
       );

  /// Creates an asset image.
  const ShadowImage.asset({
    super.key,
    required this.assetPath,
    this.semanticLabel,
    this.isDecorative = false,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.cacheHeight,
    this.borderRadius,
  }) : source = ImageSource.asset,
       filePath = null,
       url = null,
       loadingWidget = null,
       errorWidget = null,
       onTap = null,
       placeholderIcon = null;

  /// Creates a file image.
  const ShadowImage.file({
    super.key,
    required this.filePath,
    this.semanticLabel,
    this.isDecorative = false,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.cacheHeight,
    this.borderRadius,
    this.errorWidget,
  }) : source = ImageSource.file,
       assetPath = null,
       url = null,
       loadingWidget = null,
       onTap = null,
       placeholderIcon = null;

  /// Creates a network image.
  const ShadowImage.network({
    super.key,
    required this.url,
    this.semanticLabel,
    this.isDecorative = false,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.cacheHeight,
    this.loadingWidget,
    this.errorWidget,
    this.borderRadius,
  }) : source = ImageSource.network,
       assetPath = null,
       filePath = null,
       onTap = null,
       placeholderIcon = null;

  /// Creates an image picker placeholder.
  const ShadowImage.picker({
    super.key,
    required this.onTap,
    required this.semanticLabel,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholderIcon = Icons.add_a_photo,
    this.filePath,
  }) : source = ImageSource.picker,
       isDecorative = false,
       fit = BoxFit.cover,
       assetPath = null,
       url = null,
       cacheWidth = null,
       cacheHeight = null,
       loadingWidget = null,
       errorWidget = null;

  @override
  Widget build(BuildContext context) {
    var image = _buildImage(context);

    // Apply border radius if specified
    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    // Wrap in semantics
    if (isDecorative) {
      return ExcludeSemantics(child: image);
    }

    return Semantics(label: semanticLabel, image: true, child: image);
  }

  Widget _buildImage(BuildContext context) {
    switch (source) {
      case ImageSource.asset:
        return _buildAssetImage();
      case ImageSource.file:
        return _buildFileImage(context);
      case ImageSource.network:
        return _buildNetworkImage(context);
      case ImageSource.picker:
        return _buildPickerImage(context);
    }
  }

  Widget _buildAssetImage() {
    ImageProvider provider = AssetImage(assetPath!);

    // Apply cache dimensions for memory optimization
    if (cacheWidth != null || cacheHeight != null) {
      provider = ResizeImage(provider, width: cacheWidth, height: cacheHeight);
    }

    return Image(image: provider, width: width, height: height, fit: fit);
  }

  Widget _buildFileImage(BuildContext context) {
    final file = File(filePath!);

    if (!file.existsSync()) {
      return _buildErrorWidget(context);
    }

    ImageProvider provider = FileImage(file);

    // Apply cache dimensions for memory optimization
    if (cacheWidth != null || cacheHeight != null) {
      provider = ResizeImage(provider, width: cacheWidth, height: cacheHeight);
    }

    return Image(
      image: provider,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context),
    );
  }

  Widget _buildNetworkImage(BuildContext context) => Image.network(
    url!,
    width: width,
    height: height,
    fit: fit,
    cacheWidth: cacheWidth,
    cacheHeight: cacheHeight,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return _buildLoadingWidget(context, loadingProgress);
    },
    errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context),
  );

  Widget _buildPickerImage(BuildContext context) {
    final theme = Theme.of(context);

    // If we have a file path, show the image
    if (filePath != null && File(filePath!).existsSync()) {
      return GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            _buildFileImage(context),
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withAlpha(204),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show placeholder
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outline, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              placeholderIcon ?? Icons.add_a_photo,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photo',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(
    BuildContext context,
    ImageChunkEvent loadingProgress,
  ) {
    if (loadingWidget != null) return loadingWidget!;

    final theme = Theme.of(context);
    final progress = loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
        : null;

    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: CircularProgressIndicator(
          value: progress,
          semanticsLabel: 'Loading image',
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorWidget != null) return errorWidget!;

    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.errorContainer,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image,
              size: 32,
              color: theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(height: 4),
            Text(
              'Image not available',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
