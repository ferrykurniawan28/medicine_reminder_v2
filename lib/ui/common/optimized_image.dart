import 'package:flutter/material.dart';

/// Optimized image widget that automatically calculates appropriate cache dimensions
/// to prevent excessive memory usage and improve performance
class OptimizedImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Calculate cache dimensions based on display size and device pixel ratio
    int? cacheWidth;
    int? cacheHeight;

    if (width != null) {
      cacheWidth = (width! * devicePixelRatio).round();
    }
    if (height != null) {
      cacheHeight = (height! * devicePixelRatio).round();
    }

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      frameBuilder: placeholder != null
          ? (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              }
              return placeholder!;
            }
          : null,
      errorBuilder: errorWidget != null
          ? (context, error, stackTrace) => errorWidget!
          : (context, error, stackTrace) => const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
    );
  }
}

/// Specialized optimized image for icons with standard sizing
class OptimizedIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? color;

  const OptimizedIcon({
    super.key,
    required this.assetPath,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cacheSize = (size * devicePixelRatio).round();

    return Image.asset(
      assetPath,
      width: size,
      height: size,
      cacheWidth: cacheSize,
      cacheHeight: cacheSize,
      color: color,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.image_not_supported_outlined,
        size: size,
        color: color ?? Colors.grey,
      ),
    );
  }
}
