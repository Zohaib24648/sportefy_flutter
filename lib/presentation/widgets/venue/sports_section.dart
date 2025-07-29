// widgets/sports_section.dart
import 'package:flutter/material.dart';
import 'package:sportefy/data/model/sport_dto.dart';

class SportsSection extends StatelessWidget {
  final List<SportDTO> sports;

  const SportsSection({super.key, required this.sports});

  @override
  Widget build(BuildContext context) {
    if (sports.isEmpty) return const SizedBox.shrink();

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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sports
              .map((venueSport) => _buildSportCard(venueSport))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSportCard(SportDTO venueSport) {
    final sport = venueSport;
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
          // Use sport icon based on sport name
          _getSportIcon(sport.name),
          const SizedBox(height: 8),
          Text(
            sport.name,
            style: const TextStyle(
              color: Color(0xFF272727),
              fontSize: 12,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSportIcon(String sportName) {
    final Map<String, String> sportIcons = {
      'football': 'assets/icons/football.png',
      'cricket': 'assets/icons/cricket_ball.png',
      'basketball': 'assets/icons/basketball.png',
    };

    final iconPath = sportIcons[sportName.toLowerCase()];

    if (iconPath != null) {
      return Image.asset(
        iconPath,
        width: 32,
        height: 32,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.sports, size: 32, color: Color(0xFF9C86F2)),
      );
    } else {
      return const Icon(Icons.sports, size: 32, color: Color(0xFF9C86F2));
    }
  }
}
