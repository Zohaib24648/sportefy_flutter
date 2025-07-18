//lib/presentation/widgets/oauth_button.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
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
      color: AppColors.oauthButtonColor,
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
                style: AppStyles.caption(
                  context,
                ).copyWith(color: AppColors.grey2),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
