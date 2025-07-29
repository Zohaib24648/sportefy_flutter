import 'package:flutter/material.dart';

/// Utility class for home screen navigation tiles data
class HomeTileUtils {
  /// Private constructor to prevent instantiation
  HomeTileUtils._();

  /// Returns the configuration data for home screen navigation tiles
  ///
  /// [onNavigateToTab] - Callback function to handle tab navigation
  /// Returns a list of maps containing tile configuration data
  static List<Map<String, dynamic>> getTileData({
    required Function(int)? onNavigateToTab,
  }) {
    return [
      {
        'subtitle': 'Book Play. Win!',
        'title': 'Customize Your Own Event',
        'buttonText': 'Book Now',
        'white': const Color(0xFFFFD0BA),
        'onTap': () {
          onNavigateToTab?.call(2); // Navigate to QR/create tab
        },
      },
      {
        'subtitle': 'Find & Join',
        'title': 'Discover Sports Events',
        'buttonText': 'Explore',
        'white': const Color(0xFFB8E6B8),
        'onTap': () {
          onNavigateToTab?.call(1); // Navigate to search tab
        },
      },
      {
        'subtitle': 'Connect & Play',
        'title': 'Meet Fellow Athletes',
        'buttonText': 'Connect',
        'white': const Color(0xFFB8D4FF),
        'onTap': () {
          onNavigateToTab?.call(3); // Navigate to profile tab
        },
      },
      {
        'subtitle': 'Track & Improve',
        'title': 'Your Activity History',
        'buttonText': 'View History',
        'white': const Color(0xFFFFB8E6),
        'onTap': () {
          onNavigateToTab?.call(4); // Navigate to history tab
        },
      },
    ];
  }

  /// Tab indices for navigation
  static const int qrTabIndex = 2;
  static const int searchTabIndex = 1;
  static const int profileTabIndex = 3;
  static const int historyTabIndex = 4;
}
