//lib/presentation/constants/app_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../utils/responsive_helper.dart';

class AppStyles {
  static TextStyle heading(BuildContext context) => TextStyle(
    color: AppColors.textPrimary,
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 34),
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodyText(BuildContext context) => TextStyle(
    color: AppColors.textSecondary,
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w400,
  );

  static TextStyle buttonText(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w500,
  );

  static TextStyle textFieldStyle(BuildContext context) => TextStyle(
    color: Colors.black,
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w400,
  );

  static TextStyle hintTextStyle(BuildContext context) => TextStyle(
    color: AppColors.textHint,
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w300,
  );

  static TextStyle linkText(BuildContext context) => TextStyle(
    color: AppColors.primaryColor,
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w400,
  );
}