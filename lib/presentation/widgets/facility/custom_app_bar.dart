import 'package:flutter/material.dart';

// widgets/custom_app_bar.dart
class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconButton(
          onTap: () => Navigator.pop(context),
          icon: Icons.arrow_back,
        ),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A1D1F),
            fontSize: 18,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildIconButton(
          onTap: () {
            // Handle share action
          },
          icon: Icons.share,
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 1, color: const Color(0x26969696)),
        ),
        child: Icon(icon, color: const Color(0xFF1A1D1F)),
      ),
    );
  }
}
