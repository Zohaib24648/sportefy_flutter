import 'package:flutter/material.dart';

/// Exact hex values from the UI-style-guide.
class AppColors {
  // Brand
  static const primary = Color(0xFF9C86F3);
  static const secondary = Color(0xFFFFD1BA);

  // States
  static const info = Color(0xFF2F80ED);
  static const success = Color(0xFF27AE60);
  static const warning = Color(0xFFE2B93B);
  static const error = Color(0xFFEB5757);

  // Blacks / White
  static const black1 = Color(0xFF000000);
  static const black2 = Color(0xFF212121);
  static const black3 = Color(0xFF474747);
  static const white = Color(0xFFFFFFFF);

  // Greys
  static const grey1 = Color(0xFF333333);
  static const grey2 = Color(0xFF4F4F4F);
  static const grey3 = Color(0xFF828282);
  static const grey4 = Color(0xFFBDBDBD);
  static const grey5 = Color(0xFFE0E0E0);

  // Aliases for consistency (commonly used throughout the app)
  static const shadowColor = Color(0x1A000000); // 10% black shadow
  static const oauthButtonColor = Color(
    0xFFF5F5F5,
  ); // Light grey for OAuth buttons
}
