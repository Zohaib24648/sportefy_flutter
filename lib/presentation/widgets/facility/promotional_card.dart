import 'package:flutter/material.dart';
// widgets/promotional_cards.dart
class PromotionalCard extends StatelessWidget {
  final String tagline;
  final String title;
  final String buttonText;
  final Color backgroundColor;
  final String? imageUrl;
  final bool hasImage;

  const PromotionalCard({
    Key? key,
    required this.tagline,
    required this.title,
    required this.buttonText,
    required this.backgroundColor,
    this.imageUrl,
    this.hasImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: hasImage ? 340 : 364,
      height: 158,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
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
                style: TextStyle(
                  color: Colors.white.withOpacity(0.67),
                  fontSize: 12,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(81),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Color(0xFF5D3891),
                fontSize: 10,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}