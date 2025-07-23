// lib/presentation/theme/theme_extensions.dart
import 'package:flutter/material.dart';

/// Optional: Add custom properties if needed
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    this.cardRadius = 12.0,
    this.buttonRadius = 12.0,
    this.spacing = const AppSpacing(),
  });
  
  final double cardRadius;
  final double buttonRadius;
  final AppSpacing spacing;
  
  @override
  AppThemeExtension copyWith({
    double? cardRadius,
    double? buttonRadius,
    AppSpacing? spacing,
  }) {
    return AppThemeExtension(
      cardRadius: cardRadius ?? this.cardRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      spacing: spacing ?? this.spacing,
    );
  }
  
  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t) ?? cardRadius,
      buttonRadius: lerpDouble(buttonRadius, other.buttonRadius, t) ?? buttonRadius,
      spacing: AppSpacing.lerp(spacing, other.spacing, t),
    );
  }
}

/// Consistent spacing values
@immutable
class AppSpacing {
  const AppSpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 16,
    this.lg = 24,
    this.xl = 32,
  });
  
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  
  static AppSpacing lerp(AppSpacing a, AppSpacing b, double t) {
    return AppSpacing(
      xs: lerpDouble(a.xs, b.xs, t) ?? a.xs,
      sm: lerpDouble(a.sm, b.sm, t) ?? a.sm,
      md: lerpDouble(a.md, b.md, t) ?? a.md,
      lg: lerpDouble(a.lg, b.lg, t) ?? a.lg,
      xl: lerpDouble(a.xl, b.xl, t) ?? a.xl,
    );
  }
}

// Helper function
double? lerpDouble(num? a, num? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}

// Extension for easy access
extension ThemeExtensions on BuildContext {
  AppThemeExtension get appTheme {
    return Theme.of(this).extension<AppThemeExtension>() ?? 
           const AppThemeExtension();
  }
  
  // Quick access to common values
  double get spacing => appTheme.spacing.md;
  double get spacingSm => appTheme.spacing.sm;
  double get spacingLg => appTheme.spacing.lg;
}
