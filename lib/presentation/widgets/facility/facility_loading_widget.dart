import 'package:flutter/material.dart';

class FacilityLoadingWidget extends StatelessWidget {
  const FacilityLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF9C86F2)),
          SizedBox(height: 16),
          Text(
            'Loading facility details...',
            style: TextStyle(
              color: Color(0xFF63616A),
              fontSize: 14,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
