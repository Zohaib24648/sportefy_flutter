import 'package:flutter/material.dart';
import 'package:sportefy/presentation/widgets/booking/reusable_widgets.dart';

class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 48,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size),
          border: Border.all(color: const Color(0x26969696)),
        ),
        child: Icon(icon, size: size * 0.5, color: AppColors.textDark),
      ),
    );
  }
}
