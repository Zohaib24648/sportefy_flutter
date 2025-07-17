import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'common/shimmer_exports.dart';

/// Simple profile image widget with minimal complexity
class SimpleProfileImage extends StatelessWidget {
  final String? avatarUrl;
  final double radius;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const SimpleProfileImage({
    super.key,
    this.avatarUrl,
    this.radius = 50,
    this.backgroundColor = AppColors.primaryColor,
    this.iconColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: ClipOval(child: _buildAvatarContent()),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return Image.network(
        avatarUrl!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return AppShimmer(child: ShimmerCircle(size: radius * 2));
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: radius * 0.8, color: iconColor);
        },
      );
    } else {
      return Icon(Icons.person, size: radius * 0.8, color: iconColor);
    }
  }
}
