import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_styles.dart';
import '../../utils/responsive_helper.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.grey1, thickness: 2)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsiveSpacing(context, 16),
          ),
          child: Text(
            AppStrings.or,
            style: AppStyles.smallText(
              context,
            ).copyWith(color: AppColors.grey2),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.grey1, thickness: 2)),
      ],
    );
  }
}
