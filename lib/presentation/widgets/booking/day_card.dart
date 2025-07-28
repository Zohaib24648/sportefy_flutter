import 'package:flutter/material.dart';
import 'package:sportefy/presentation/widgets/booking/reusable_widgets.dart';

class DayCard extends StatelessWidget {
  const DayCard({
    super.key,
    required this.weekday,
    required this.day,
    this.isSelected = false,
    this.onTap,
  });

  final String weekday;
  final String day;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final background = isSelected ? AppColors.primary : Colors.white;
    final textColor = isSelected ? Colors.white : const Color(0xFF221122);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 54,
        height: 69,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2.27,
              offset: Offset(0, 1.13),
              color: Color(0x07000000),
            ),
          ],
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$weekday\n',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                  fontFamily: 'Lexend',
                ),
              ),
              TextSpan(
                text: day,
                style: TextStyle(
                  fontSize: 24,
                  color: textColor,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
