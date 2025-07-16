import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sportefy/data/services/auth_state_manager.dart';
import 'package:sportefy/presentation/widgets/custom_circle_avatar.dart';

class UserAvatarWidget extends StatelessWidget {
  final double radius;
  final double borderWidth;
  final Color borderColor;

  const UserAvatarWidget({
    super.key,
    this.radius = 30.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final authStateManager = GetIt.instance<AuthStateManager>();

    return StreamBuilder(
      stream: authStateManager.authStateChanges,
      builder: (context, snapshot) {
        final userAvatarUrl = authStateManager.userAvatarUrl;
        final userEmail = authStateManager.userEmail;
        String avatarUrl = '';

        if (userAvatarUrl != null && userAvatarUrl.isNotEmpty) {
          avatarUrl = userAvatarUrl;
        } else if (userEmail != null) {
          final encodedEmail = Uri.encodeComponent(userEmail);
          avatarUrl =
              'https://ui-avatars.com/api/?name=$encodedEmail&background=random';
        }

        return CustomCircleAvatar(
          imageUrl: avatarUrl,
          radius: radius,
          borderWidth: borderWidth,
          borderColor: borderColor,
        );
      },
    );
  }
}

class StaticUserAvatarWidget extends StatelessWidget {
  final double radius;
  final double borderWidth;
  final Color borderColor;

  const StaticUserAvatarWidget({
    super.key,
    this.radius = 30.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final authStateManager = GetIt.instance<AuthStateManager>();

    final userAvatarUrl = authStateManager.userAvatarUrl;
    final userEmail = authStateManager.userEmail;

    String avatarUrl = '';

    if (userAvatarUrl != null && userAvatarUrl.isNotEmpty) {
      avatarUrl = userAvatarUrl;
    } else if (userEmail != null) {
      final encodedEmail = Uri.encodeComponent(userEmail);
      avatarUrl =
          'https://ui-avatars.com/api/?name=$encodedEmail&background=random';
    }

    return CustomCircleAvatar(
      imageUrl: avatarUrl,
      radius: radius,
      borderWidth: borderWidth,
      borderColor: borderColor,
    );
  }
}
