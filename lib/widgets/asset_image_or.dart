import 'package:flutter/material.dart';

/// Shows [asset] if it loads, otherwise renders [fallback]. Lets the app ship
/// with procedurally-drawn placeholders that are seamlessly upgraded once the
/// generated images (tool/generate_images.py) are present.
class AssetImageOr extends StatelessWidget {
  const AssetImageOr({
    super.key,
    required this.asset,
    required this.fallback,
    this.fit = BoxFit.cover,
  });

  final String? asset;
  final Widget fallback;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (asset == null) return fallback;
    return Image.asset(
      asset!,
      fit: fit,
      // Missing/corrupt asset → fall back to the painted version.
      errorBuilder: (context, error, stack) => fallback,
      // Fade in once decoded to avoid a hard pop.
      frameBuilder: (context, child, frame, wasSyncLoaded) {
        if (wasSyncLoaded || frame != null) {
          return AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 250),
            child: child,
          );
        }
        return fallback;
      },
    );
  }
}
