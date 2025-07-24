import 'package:flutter/material.dart';
import 'package:sportefy/data/model/venue_details.dart';

class OperatingHoursSection extends StatelessWidget {
  final List<OperatingHour> operatingHours;

  const OperatingHoursSection({super.key, required this.operatingHours});

  @override
  Widget build(BuildContext context) {
    if (operatingHours.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operating Hours',
          style: TextStyle(
            color: Color(0xFF272727),
            fontSize: 14,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ...operatingHours.map(
          (hour) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hour.dayOfWeek,
                  style: const TextStyle(
                    color: Color(0xFF63616A),
                    fontSize: 12,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '${hour.openTime} - ${hour.closeTime}',
                  style: const TextStyle(
                    color: Color(0xFF272727),
                    fontSize: 12,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
