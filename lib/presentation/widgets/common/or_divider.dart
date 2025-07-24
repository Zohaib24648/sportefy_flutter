import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../constants/app_strings.dart';
import '../../utils/responsive_helper.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.dark, thickness: 2)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsiveSpacing(context, 16),
          ),
          child: Text(
            AppStrings.or,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.dark, thickness: 2)),
      ],
    );
  }
}
