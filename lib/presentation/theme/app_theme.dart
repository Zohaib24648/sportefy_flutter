// lib/presentation/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // Reusable constants
  static const _borderRadius = 12.0;
  static const _contentPadding = EdgeInsets.all(16);

  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    surface: AppColors.white,
    background: AppColors.background,
    onSurface: AppColors.black,
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    surface: AppColors.dark,
    background: AppColors.black,
    onSurface: AppColors.white,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color surface,
    required Color background,
    required Color onSurface,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Lexend',

      // Colors
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        surface: surface,
        onSurface: onSurface,
        error: AppColors.error,
      ),

      scaffoldBackgroundColor: background,
      dividerColor: isDark
          ? AppColors.grey.withValues(alpha: 0.2)
          : AppColors.divider,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0, // Remove elevation when scrolled
        centerTitle: false,
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent, // Remove surface tint
        foregroundColor: onSurface,
        titleTextStyle: AppTextStyles.h3.copyWith(color: onSurface),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Transparent status bar
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: surface,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display.copyWith(color: onSurface),
        headlineLarge: AppTextStyles.h1.copyWith(color: onSurface),
        headlineMedium: AppTextStyles.h2.copyWith(color: onSurface),
        headlineSmall: AppTextStyles.h3.copyWith(color: onSurface),
        titleLarge: AppTextStyles.h3.copyWith(color: onSurface),
        titleMedium: AppTextStyles.body.copyWith(
          color: onSurface,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: AppTextStyles.body.copyWith(color: onSurface),
        bodyMedium: AppTextStyles.bodySmall.copyWith(color: onSurface),
        bodySmall: AppTextStyles.caption.copyWith(
          color: onSurface.withValues(alpha: 0.7),
        ),
        labelLarge: AppTextStyles.button,
        labelSmall: AppTextStyles.label.copyWith(
          color: onSurface.withValues(alpha: 0.7),
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.lightGrey,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.black : AppColors.white,
        contentPadding: _contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTextStyles.body.copyWith(color: AppColors.grey),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.grey),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        margin: const EdgeInsets.all(4),
      ),
    );
  }
}
