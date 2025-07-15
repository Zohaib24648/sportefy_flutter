import 'package:flutter/material.dart';

// widgets/proceed_button.dart
class ProceedButton extends StatelessWidget {
  const ProceedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle proceed action - navigate to booking screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proceeding to booking...'),
            duration: Duration(seconds: 2),
          ),
        );
        // TODO: Implement navigation to booking screen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const BookingScreen(),
        //   ),
        // );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF9C86F2),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0x38000000),
              blurRadius: 14,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Proceed Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
