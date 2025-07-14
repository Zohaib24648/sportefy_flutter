// widgets/rules_button.dart
import 'package:flutter/material.dart';

class RulesButton extends StatelessWidget {
  const RulesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle rules and regulations tap
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F6F7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rules and regulations',
              style: TextStyle(
                color: Color(0xFF212121),
                fontSize: 12,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: const Color(0xFF212121),
            ),
          ],
        ),
      ),
    );
  }
}
