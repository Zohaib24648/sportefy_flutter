import 'package:flutter/material.dart';

class HomepageChip extends StatelessWidget {
  const HomepageChip({
    super.key,
    required this.title,
    this.icon,
    this.iconAsset,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFF272727),
    this.width,
    this.height,
    this.horizontalPadding = 10,
    this.verticalPadding = 0,
  });

  final String title;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double? height;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width, // null ⇒ shrink-wrap
        height: height, // null ⇒ min-height from padding/Icon
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15), // big pill
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null || iconAsset != null) ...[
              SizedBox(
                width: 20,
                height: 20,
                child: iconAsset != null
                    ? Image.asset(
                        iconAsset!,
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      )
                    : Icon(icon!, size: 20, color: textColor),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
