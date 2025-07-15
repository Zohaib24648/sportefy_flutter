// widgets/sports_section.dart
import 'package:flutter/material.dart';

class SportsSection extends StatelessWidget {
  const SportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sports available',
          style: TextStyle(
            color: Color(0xFF272727),
            fontSize: 14,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildSportCard('Football', 'https://placehold.co/48x48'),
            const SizedBox(width: 8),
            _buildSportCard('Cricket', 'https://placehold.co/56x48'),
          ],
        ),
      ],
    );
  }

  Widget _buildSportCard(String sport, String iconUrl) {
    return Container(
      width: 82,
      height: 73,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            sport,
            style: const TextStyle(
              color: Color(0xFF272727),
              fontSize: 12,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Image.network(iconUrl, width: 40, height: 40, fit: BoxFit.cover),
        ],
      ),
    );
  }
}

// widgets/amenities_section.dart
class AmenitiesSection extends StatelessWidget {
  final List<String> amenities;
  final String selectedAmenity;

  const AmenitiesSection({
    super.key,
    required this.amenities,
    required this.selectedAmenity,
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
              ),
              child: Text(
                amenity,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xB2212121),
                  fontSize: 12,
                  fontFamily: 'Lexend',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
