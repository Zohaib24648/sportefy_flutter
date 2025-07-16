import 'package:flutter/material.dart';

class FlexibleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FlexibleAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.backgroundColor,
    this.elevation = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double elevation;
  final EdgeInsetsGeometry padding;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.scaffoldBackgroundColor;

    return Material(
      color: bg,
      elevation: elevation,
      surfaceTintColor: theme.colorScheme.surfaceTint,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) leading!,
              const SizedBox(width: 16),
              Expanded(child: title ?? const SizedBox.shrink()),
              if (actions?.isNotEmpty ?? false) ...[
                const SizedBox(width: 16),
                Row(mainAxisSize: MainAxisSize.min, children: actions!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarActions {
  const AppBarActions._(); // cannot be instantiated

  static Widget notificationButton({
    required VoidCallback onTap,
    int notificationCount = 0,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _ActionButton(
          onTap: onTap,
          backgroundColor: backgroundColor,
          icon: Icons.notifications_outlined,
          iconColor: iconColor,
        ),
        if (notificationCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: _NotificationDot(count: notificationCount),
          ),
      ],
    );
  }

  static Widget searchButton({
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? iconColor,
  }) => _ActionButton(
    onTap: onTap,
    backgroundColor: backgroundColor,
    icon: Icons.search_outlined,
    iconColor: iconColor,
  );

  static Widget moreButton({
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? iconColor,
  }) => _ActionButton(
    onTap: onTap,
    backgroundColor: backgroundColor,
    icon: Icons.more_vert,
    iconColor: iconColor,
  );

  static Widget customButton({
    required VoidCallback onTap,
    required IconData icon,
    Color? backgroundColor,
    Color? iconColor,
    double size = 24,
  }) => _ActionButton(
    onTap: onTap,
    backgroundColor: backgroundColor,
    icon: icon,
    iconColor: iconColor,
    iconSize: size,
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onTap,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.iconSize = 24,
  });

  final VoidCallback onTap;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor ?? Colors.grey.shade700,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

class _NotificationDot extends StatelessWidget {
  const _NotificationDot({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final displayCount = count > 9 ? '9+' : '$count';
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          displayCount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AppBarLeading {
  const AppBarLeading._();

  static Widget profilePicture({
    required String userName,
    String? imageUrl,
    VoidCallback? onTap,
    double size = 40,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 2),
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageUrl == null
            ? CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  static Widget logo({
    required String assetPath,
    double size = 40,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  static Widget customIcon({
    required IconData icon,
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? iconColor,
    double size = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor ?? Colors.grey.shade700, size: size),
      ),
    );
  }
}
