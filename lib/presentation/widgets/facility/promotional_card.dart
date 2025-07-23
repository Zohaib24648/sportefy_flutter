import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_colors.dart';

// widgets/promotional_cards.dart
class PromotionalCard extends StatelessWidget {
  final String tagline;
  final String title;
  final String buttonText;
  final Color white;
  final String? imageUrl;
  final bool hasImage;

  const PromotionalCard({
    super.key,
    required this.tagline,
    required this.title,
    required this.buttonText,
    required this.white,
    this.imageUrl,
    this.hasImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: hasImage ? 340 : 364,
      height: 158,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0x28000000),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tagline,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.white.withValues(alpha: .67),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppTextStyles.h3.copyWith(color: AppColors.white),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(81),
            ),
            child: Text(
              buttonText,
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFF5D3891),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
