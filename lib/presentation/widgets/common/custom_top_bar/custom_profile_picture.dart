import 'package:flutter/material.dart';
import 'package:sportefy/presentation/widgets/common/custom_top_bar/user_info.dart';

class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  final double size;
  final MembershipType membershipType;
  final Widget? badge;

  const ProfilePicture({
    super.key,
    required this.imageUrl,
    this.size = 20,
    this.membershipType = MembershipType.basic,
    this.badge,
  });

  Color _getFrameColor() {
    switch (membershipType) {
      case MembershipType.basic:
        return Colors.grey;
      case MembershipType.silver:
        return Colors.grey.shade400;
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
    final double borderWidth = size * 0.06; // 6 % of main size
    final double frameSize = size + borderWidth * 2;
    final double badgeSize = size * 0.4; // 40 % of main size
    final double badgeOffset = size * 0.1; // 10 % of main size

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: frameSize,
          height: frameSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _getFrameColor(), width: borderWidth),
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
                shape: const CircleBorder(),
              ),
            ),
          ),
        ),
        if (badge != null)
          Positioned(
            bottom: badgeOffset,
            right: badgeOffset,
            child: Container(
              width: badgeSize,
              height: badgeSize,
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
