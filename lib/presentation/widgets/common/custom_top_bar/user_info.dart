import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

enum MembershipType { basic, silver, gold, platinum, vip }

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
        Text(name, style: nameStyle ?? theme.textTheme.titleMedium),
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
