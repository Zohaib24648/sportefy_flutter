import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sportefy/presentation/theme/app_colors.dart';

class HomepageTile extends StatelessWidget {
  const HomepageTile({
    super.key,
    required this.subtitle,
    required this.title,
    required this.buttonText,
    this.backgroundColor = AppColors.secondary,
    this.onTap,
    required this.height,
    this.imageLink,
  });

  final String subtitle;
  final String title;
  final String buttonText;
  final double height;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final String? imageLink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        image: imageLink != null
            ? DecorationImage(
                image: NetworkImage(imageLink!),
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: imageLink != null
                  ? AppColors.white
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: imageLink != null
                  ? AppColors.white
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        buttonText,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(4),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
