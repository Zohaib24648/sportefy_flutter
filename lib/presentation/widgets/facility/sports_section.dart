// widgets/sports_section.dart
import 'package:flutter/material.dart';

class Sport {
  final String name;
  final String iconPath;

  const Sport({required this.name, required this.iconPath});
}

class SportsSection extends StatelessWidget {
  final List<Sport> sports;

  const SportsSection({
    super.key,
    this.sports = const [
      Sport(name: 'Football', iconPath: 'assets/icons/football.png'),
      Sport(name: 'Cricket', iconPath: 'assets/icons/cricket_ball.png'),
      Sport(name: 'Basketball', iconPath: 'assets/icons/basketball.png'),
    ],
  });

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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sports.map((sport) => _buildSportCard(sport)).toList(),
        ),
      ],
    );
  }

  Widget _buildSportCard(Sport sport) {
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
          Image.asset(
            sport.iconPath,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.sports, size: 32, color: Color(0xFF9C86F2)),
          ),
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
}
