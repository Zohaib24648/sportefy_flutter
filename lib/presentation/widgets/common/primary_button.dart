//lib/presentation/widgets/primary_button.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/responsive_helper.dart';
import 'shimmer_exports.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ResponsiveHelper.getResponsiveSpacing(context, 60),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 8,
          shadowColor: AppColors.shadow,
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: ResponsiveHelper.getResponsiveFontSize(context, 16),
                    height: ResponsiveHelper.getResponsiveFontSize(context, 16),
                    child: const CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppShimmer(
                    baseColor: AppColors.white.withValues(alpha: 0.3),
                    highlightColor: AppColors.white.withValues(alpha: 0.6),
                    child: ShimmerText(
                      width: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        60,
                      ),
                      height: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        16,
                      ),
                    ),
                  ),
                ],
              )
            : Text(text, style: AppTextStyles.button),
      ),
    );
  }
}
