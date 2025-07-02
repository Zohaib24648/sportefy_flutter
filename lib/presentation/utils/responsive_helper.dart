//lib/presentation/utils/responsive_helper.dart
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getResponsiveWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getResponsiveHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Define breakpoints
  static bool isMobile(BuildContext context) => getResponsiveWidth(context) < 768;
  static bool isTablet(BuildContext context) => getResponsiveWidth(context) >= 768 && getResponsiveWidth(context) < 1024;
  static bool isDesktop(BuildContext context) => getResponsiveWidth(context) >= 1024;

  // Responsive font sizes
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    double screenWidth = getResponsiveWidth(context);
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 768) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  // Responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    double screenWidth = getResponsiveWidth(context);
    if (screenWidth < 360) {
      return baseSpacing * 0.75;
    } else if (screenWidth > 768) {
      return baseSpacing * 1.2;
    }
    return baseSpacing;
  }

  // Get horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    double screenWidth = getResponsiveWidth(context);
    if (isDesktop(context)) {
      return screenWidth * 0.25; // 25% padding on desktop
    } else if (isTablet(context)) {
      return screenWidth * 0.15; // 15% padding on tablet
    } else {
      return screenWidth * 0.05; // 5% padding on mobile
    }
  }
}