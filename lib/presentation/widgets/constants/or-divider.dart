import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../utils/responsive_helper.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.dividerColor,
            thickness: 2,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsiveSpacing(context, 16),
          ),
          child: Text(
            AppStrings.or,
            style: TextStyle(
              color: const Color(0xFF262626),
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.dividerColor,
            thickness: 2,
          ),
        ),
      ],
    );
  }
}
