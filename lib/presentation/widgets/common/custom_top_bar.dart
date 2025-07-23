import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// Enum for membership types
enum MembershipType { basic, silver, gold, platinum, vip }

// 1. Profile Picture Widget with Frame
class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  final double size;
  final MembershipType membershipType;
  final Widget? badge;

  const ProfilePicture({
    super.key,
    required this.imageUrl,
    this.size = 50,
    this.membershipType = MembershipType.basic,
    this.badge,
  });

  Color _getFrameColor() {
    switch (membershipType) {
      case MembershipType.basic:
        return Colors.grey;
      case MembershipType.silver:
        return Colors.grey[400]!;
      case MembershipType.gold:
        return Colors.amber;
      case MembershipType.platinum:
        return Colors.blueGrey;
      case MembershipType.vip:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: size + 8, // Add frame width
          height: size + 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _getFrameColor(), width: 3),
          ),
          child: Center(
            child: Container(
              width: size,
              height: size,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                shape: CircleBorder(),
              ),
            ),
          ),
        ),
        // Badge (crown, star, etc.)
        if (badge != null)
          Positioned(
            bottom: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _getFrameColor(),
                shape: BoxShape.circle,
              ),
              child: Center(child: badge!),
            ),
          ),
      ],
    );
  }
}

// 2. User Info Widget with Credit Chip
class UserInfo extends StatelessWidget {
  final String name;
  final String creditAmount;
  final MembershipType membershipType;
  final TextStyle? nameStyle;
  final TextStyle? creditLabelStyle;

  const UserInfo({
    super.key,
    required this.name,
    required this.creditAmount,
    this.membershipType = MembershipType.basic,
    this.nameStyle,
    this.creditLabelStyle,
  });

  Gradient _getCreditGradient() {
    switch (membershipType) {
      case MembershipType.basic:
        return LinearGradient(
          colors: [
            Colors.grey[600]!,
            Colors.grey[400]!,
            Colors.grey[400]!,
            Colors.grey[600]!,
          ],
        );
      case MembershipType.silver:
        return LinearGradient(
          colors: [
            const Color(0xFF636363),
            const Color(0xFFABABAB),
            const Color(0xFFBABABA),
            const Color(0xFF636363),
          ],
        );
      case MembershipType.gold:
        return LinearGradient(
          colors: [
            Colors.amber[700]!,
            Colors.amber[400]!,
            Colors.amber[400]!,
            Colors.amber[700]!,
          ],
        );
      case MembershipType.platinum:
        return LinearGradient(
          colors: [
            Colors.blueGrey[700]!,
            Colors.blueGrey[400]!,
            Colors.blueGrey[400]!,
            Colors.blueGrey[700]!,
          ],
        );
      case MembershipType.vip:
        return LinearGradient(
          colors: [
            Colors.purple[700]!,
            Colors.purple[400]!,
            Colors.purple[400]!,
            Colors.purple[700]!,
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style:
              nameStyle ??
              theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
        ),
        Gap(2),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Credits: ',
              style:
                  creditLabelStyle ??
                  theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: ShapeDecoration(
                gradient: _getCreditGradient(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                creditAmount,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Main CustomTopBar Widget
class CustomTopBar extends StatelessWidget {
  final Widget? profilePicture;
  final Widget? userInfo;
  final Widget? actionIcons;
  final EdgeInsets padding;

  const CustomTopBar({
    super.key,
    this.profilePicture,
    this.userInfo,
    this.actionIcons,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left section - Profile and User Info
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (profilePicture != null) profilePicture!,
                if (profilePicture != null && userInfo != null)
                  SizedBox(width: 16),
                if (userInfo != null) Expanded(child: userInfo!),
              ],
            ),
          ),
          // Right section - Action Icons
          if (actionIcons != null) actionIcons!,
        ],
      ),
    );
  }
}