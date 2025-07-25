import 'package:flutter/material.dart';

class AmenitiesSection extends StatelessWidget {
  final List<String> amenities;
  final String? selectedAmenity;

  const AmenitiesSection({
    super.key,
    required this.amenities,
    this.selectedAmenity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amenities',
          style: TextStyle(
            color: Color(0xFF272727),
            fontSize: 14,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amenities.map((amenity) {
            final isSelected = amenity == selectedAmenity;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF9C86F2)
                    : const Color(0xFFF2F6F7),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF9C86F2)
                      : const Color(0xFFEBEBEB),
                  width: 1,
                ),
              ),
              child: Text(
                amenity,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF272727),
                  fontSize: 12,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
