//lib/presentation/widgets/oauth_button.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/app_colors.dart';
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
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(14),
          //   boxShadow: const [
          //     BoxShadow(
          //       color: AppColors.shadowColor,
          //       blurRadius: 8,
          //       offset: Offset(0, 2),
          //       spreadRadius: 0,
          //     ),
          //   ],
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const Gap(4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: .7),
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
