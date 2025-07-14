import 'package:flutter/material.dart';

/// A responsive promo tile that scales itself to the
/// supplied [size].  Leave [size] null and let the parent’s
/// constraints decide.
class HomepageTile extends StatelessWidget {
  static const _kBaseSize = Size(364, 158);

  const HomepageTile({
    super.key,
    required this.subtitle,
    required this.title,
    required this.buttonText,
    this.backgroundColor = const Color(0xFFFFD0BA),
    this.onTap,
    this.size,
  });

  final String subtitle;
  final String title;
  final String buttonText;
  final Color backgroundColor;
  final VoidCallback? onTap;

  final Size? size;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final target =
            size ??
            Size(
              constraints.maxWidth,
              constraints.maxWidth * _kBaseSize.height / _kBaseSize.width,
            );

        final scale = target.width / _kBaseSize.width;

        double s(double value) => value * scale;

        return Container(
          width: target.width,
          height: target.height,
          padding: EdgeInsets.symmetric(horizontal: s(24), vertical: s(27)),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(s(14)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: .67),
                  fontSize: s(12),
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.12 * scale,
                ),
              ),
              SizedBox(height: s(4)),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: s(22),
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.66 * scale,
                  height: 1.18,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: s(18),
                    vertical: s(3),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(s(81)),
                  ),
                  child: Text(
                    buttonText,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF5D3891),
                      fontSize: s(10),
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.10 * scale,
                      height: 1.95,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
