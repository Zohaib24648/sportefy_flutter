import 'package:flutter/material.dart';

class HomepageChip extends StatelessWidget {
  const HomepageChip({
    Key? key,
    required this.title,
    this.imageUrl,
    this.icon,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFF272727),
    this.width, // if null → auto
    this.height, // if null → content-based
    this.horizontalPadding = 5,
    this.verticalPadding = 0,
  }) : super(key: key);

  final String title;
  final String? imageUrl;
  final IconData? icon;
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
          mainAxisSize: MainAxisSize.min, // 👈  shrink-wrap
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Avatar(imageUrl: imageUrl, icon: icon),
            const SizedBox(width: 6),
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

/// Wrapped into its own widget just to keep build() tidy.
class _Avatar extends StatelessWidget {
  const _Avatar({this.imageUrl, this.icon});

  final String? imageUrl;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(13),
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackIcon,
              ),
            )
          : _fallbackIcon,
    );
  }

  Widget get _fallbackIcon =>
      Icon(icon ?? Icons.sports, size: 16, color: Colors.grey[600]);
}
