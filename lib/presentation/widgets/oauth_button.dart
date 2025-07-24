//lib/presentation/widgets/oauth_button.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/responsive_helper.dart';

class OAuthButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  const OAuthButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.getResponsiveSpacing(context, 16),
            horizontal: ResponsiveHelper.getResponsiveSpacing(context, 4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const Gap(4),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
