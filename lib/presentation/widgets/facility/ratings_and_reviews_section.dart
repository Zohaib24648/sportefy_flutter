// widgets/ratings_reviews_section.dart
import 'package:flutter/material.dart';

class RatingsReviewsSection extends StatelessWidget {
  const RatingsReviewsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ratings & Reviews',
          style: TextStyle(
            color: Color(0xFF272727),
            fontSize: 20,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          height: 167,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(width: 1, color: Colors.black.withOpacity(0.06)),
          ),
          // Add rating overview content here
        ),
        const SizedBox(height: 18),
        _buildReviewItem(),
      ],
    );
  }

  Widget _buildReviewItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              size: 14,
              color: index < 4 ? Colors.amber : Colors.grey.shade300,
            ),
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          style: TextStyle(
            color: Color(0xFF63616A),
            fontSize: 14,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'László Barbara',
                  style: TextStyle(
                    color: Color(0xFF161320),
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Text(
                  '24 Oct 2025',
                  style: TextStyle(
                    color: Color(0xFF63616A),
                    fontSize: 11,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 14,
                  color: index < 4 ? Colors.amber : Colors.grey.shade300,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
