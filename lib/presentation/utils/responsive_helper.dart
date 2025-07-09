//lib/presentation/utils/responsive_helper.dart
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getResponsiveWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getResponsiveHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Responsive font sizes for mobile screens
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    double screenWidth = getResponsiveWidth(context);

    // Small phones (< 360px width)
    if (screenWidth < 360) {
      return baseFontSize * 0.8;
    }
    // Large phones (> 414px width - iPhone Plus sizes and above)
    else if (screenWidth > 414) {
      return baseFontSize * 1.2;
    }
    // Regular phones
    return baseFontSize;
  }

  // Responsive spacing for mobile screens
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    double screenWidth = getResponsiveWidth(context);

    // Small phones
    if (screenWidth < 360) {
      return baseSpacing * 0.75;
    }
    // Large phones
    else if (screenWidth > 414) {
      return baseSpacing * 1.1;
    }
    // Regular phones
    return baseSpacing;
  }

  // Get horizontal padding for mobile screens
  static double getHorizontalPadding(BuildContext context) {
    double screenWidth = getResponsiveWidth(context);

    // Slightly more padding for larger phones
    if (screenWidth > 414) {
      return 24.0;
    }
    // Standard padding for regular phones
    else if (screenWidth >= 360) {
      return 16.0;
    }
    // Reduced padding for small phones
    return 12.0;
  }

  // Helper to check if it's a small mobile screen
  static bool isSmallMobile(BuildContext context) => getResponsiveWidth(context) < 360;

  // Helper to check if it's a large mobile screen
  static bool isLargeMobile(BuildContext context) => getResponsiveWidth(context) > 414;
}