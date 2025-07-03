import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sportefy',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontFamily: 'Lexend',
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }
}
