import 'package:flutter/material.dart';
import 'package:sportefy/presentation/screens/booking/booking_screen.dart';
import '../../theme/app_colors.dart';

// widgets/proceed_button.dart
class ProceedButton extends StatelessWidget {
  final String? venueId;
  final String? venueName;

  const ProceedButton({super.key, this.venueId, this.venueName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                BookingScreen(venueId: venueId, venueName: venueName),
          ),
        );
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
              color: AppColors.white,
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
