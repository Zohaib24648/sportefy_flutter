import 'package:flutter/material.dart';
import 'package:sportefy/data/model/time_slot.dart';
import 'package:sportefy/presentation/widgets/booking/reusable_widgets.dart';

class TimeSlotChip extends StatelessWidget {
  const TimeSlotChip({
    super.key,
    required this.timeSlot,
    this.isSelected = false,
    this.onTap,
  });

  final TimeSlotDTO timeSlot;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: timeSlot.isAvailable ? onTap : null,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: _getBorderColor(), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeSlot.formattedTime,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Lexend',
                color: _getTextColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getDurationChipColor(),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${timeSlot.durationInHours.toStringAsFixed(1)}h',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Lexend',
                  color: _getDurationTextColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!timeSlot.isAvailable) {
      return Colors.grey[100]!;
    }
    return isSelected ? AppColors.primary : Colors.white;
  }

  Color _getBorderColor() {
    if (!timeSlot.isAvailable) {
      return Colors.grey[300]!;
    }
    return isSelected ? AppColors.primary : Colors.grey[300]!;
  }

  Color _getTextColor() {
    if (!timeSlot.isAvailable) {
      return Colors.grey[400]!;
    }
    return isSelected ? Colors.white : const Color(0xB2212121);
  }

  Color _getDurationChipColor() {
    if (!timeSlot.isAvailable) {
      return Colors.grey[200]!;
    }
    return isSelected
        ? Colors.white.withValues(alpha: 0.2)
        : AppColors.primary.withValues(alpha: 0.1);
  }

  Color _getDurationTextColor() {
    if (!timeSlot.isAvailable) {
      return Colors.grey[500]!;
    }
    return isSelected ? Colors.white : AppColors.primary;
  }
}
