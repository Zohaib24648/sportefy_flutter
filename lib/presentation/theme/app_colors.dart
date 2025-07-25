// lib/presentation/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Core color palette - minimal and clear
class AppColors {
  AppColors._();

  // Brand colors
  static const primary = Color(0xFF9C86F3);
  static const secondary = Color(0xFFFFD1BA);

  // Semantic colors
  static const success = Color(0xFF27AE60);
  static const warning = Color(0xFFE2B93B);
  static const error = Color(0xFFEB5757);
  static const info = Color(0xFF2F80ED);

  // Neutrals (simplified)
  static const black = Color(0xFF000000);
  static const dark = Color(0xFF212121);
  static const grey = Color(0xFF828282);
  static const lightGrey = Color(0xFFE0E0E0);
  static const white = Color(0xFFFFFFFF);

  // Utility colors
  static const shadow = Color(0x1A000000);
  static const divider = Color(0xFFE0E0E0);
  static const background = Color(0xFFF5F5F5);

  // Additional colors for compatibility (mapping to your main colors)
  static const black1 = black;
  static const black2 = dark;
  static const grey1 = dark;
  static const grey2 = Color(0xFF4F4F4F);
  static const grey3 = grey;
  static const grey4 = Color(0xFFBDBDBD);
  static const grey5 = lightGrey;
  static const shadowColor = shadow;
  static const oauthButtonColor = Color(0xFFF5F5F5);
}
