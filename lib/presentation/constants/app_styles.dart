import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // ── Headings ─────────────────────────────────
  static const h1 = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 42,
    height: 1.07, // 45 ÷ 42
    fontWeight: FontWeight.w700,
    color: AppColors.black1,
  );

  static const h2 = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 32,
    height: 1.25, // 40 ÷ 32
    fontWeight: FontWeight.w700,
    color: AppColors.black1,
  );

  static const h3 = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 20,
    height: 1.40, // 28 ÷ 20
    fontWeight: FontWeight.w600,
    color: AppColors.black1,
  );

  static const h4 = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 18,
    height: 1.33, // 24 ÷ 18
    fontWeight: FontWeight.w600,
    color: AppColors.black1,
  );

  // ── Body (1.4 line-height) ───────────────────
  static TextStyle bodyLarge({bool bold = false}) => TextStyle(
    fontFamily: 'Lexend',
    fontSize: 20,
    height: 1.40,
    fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    color: AppColors.grey2,
  );

  static TextStyle bodyMedium({bool bold = false}) => TextStyle(
    fontFamily: 'Lexend',
    fontSize: 18,
    height: 1.40,
    fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    color: AppColors.grey2,
  );

  static TextStyle bodyNormal({bool bold = false}) => TextStyle(
    fontFamily: 'Lexend',
    fontSize: 16,
    height: 1.40,
    fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    color: AppColors.grey2,
  );

  static TextStyle bodySmall({bool bold = false}) => TextStyle(
    fontFamily: 'Lexend',
    fontSize: 14,
    height: 1.40,
    fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    color: AppColors.grey2,
  );

  // ── Convenience extras ───────────────────────
  static const link = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 16,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  static const button = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 16,
    height: 1.4,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
}

/// AppStyles class that provides responsive styling methods used throughout the app
class AppStyles {
  // ── Text Field Styles ────────────────────────
  static TextStyle textFieldStyle(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Lexend',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.black2,
      height: 1.4,
    );
  }

  static TextStyle hintTextStyle(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Lexend',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.grey3,
      height: 1.4,
    );
  }

  // ── Button Styles ─────────────────────────────
  static TextStyle buttonText(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Lexend',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.white,
      height: 1.4,
    );
  }

  // ── Common Text Styles ───────────────────────
  static TextStyle heading(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Lexend',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.black1,
      height: 1.4,
    );
  }

  static TextStyle bodyText(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Lexend',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.grey2,
      height: 1.4,
    );
  }

  static TextStyle caption(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Lexend',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.grey3,
      height: 1.4,
    );
  }

  static TextStyle smallText(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Lexend',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.grey2,
      height: 1.4,
    );
  }
}
