// lib/presentation/theme/app_text_styles.dart
import 'package:flutter/material.dart';

/// Mobile-optimized text styles
class AppTextStyles {
  AppTextStyles._();

  static const _fontFamily = 'Lexend';

  // Display (for hero sections only)
  static const display = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  // Headings (mobile-friendly sizes)
  static const h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    height: 1.3,
    fontWeight: FontWeight.w700,
  );

  static const h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );

  static const h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );

  // Added h4 for compatibility
  static const h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );

  // Body text
  static const body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  // Utility styles
  static const button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Additional styles for compatibility
  static const link = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9C86F3), // AppColors.primary
    decoration: TextDecoration.underline,
  );
}
