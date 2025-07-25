import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Performance configuration and optimization utilities
class PerformanceConfig {
  static const double kListCacheExtent = 500.0;
  static const int kImageCacheSize = 100;
  static const int kImageCacheMaxSize = 50 * 1024 * 1024; // 50MB

  /// Initialize performance optimizations
  static void initialize() {
    if (kDebugMode) {
      // Enable performance overlay in debug mode if needed
      // debugPaintSizeEnabled = true;
    }

    // Configure image cache
    PaintingBinding.instance.imageCache.maximumSize = kImageCacheSize;
    PaintingBinding.instance.imageCache.maximumSizeBytes = kImageCacheMaxSize;
  }

  /// Common ListView physics for better performance
  static const scrollPhysics = BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  );
}
