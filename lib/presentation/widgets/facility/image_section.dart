// widgets/venue_image_section.dart
import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';

class VenueImageSection extends StatelessWidget {
  final String imageUrl;
  final String venueName;
  final double rating;
  final int reviewCount;
  final int pricePerHour;
  final bool isOpen24Hours;

  const VenueImageSection({
    super.key,
    required this.imageUrl,
    required this.venueName,
    required this.rating,
    required this.reviewCount,
    required this.pricePerHour,
    required this.isOpen24Hours,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image
        Container(
          width: double.infinity,
          height: 244,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFF2F6F7),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFF2F6F7),
                      child: const Center(
                        child: Icon(
                          Icons.business,
                          size: 80,
                          color: Color(0xFF9C86F2),
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: const Color(0xFFF2F6F7),
                    child: const Center(
                      child: Icon(
                        Icons.business,
                        size: 80,
                        color: Color(0xFF9C86F2),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 15),

        // Info Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - Name and Rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(venueName, style: AppTextStyles.h3),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(
                      '$rating ($reviewCount reviews)',
                      style: const TextStyle(
                        color: Color(0xFF63616A),
                        fontSize: 14,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Right side - Price and Hours
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$pricePerHour credits /hr',
                  style: const TextStyle(
                    color: Color(0xFF1A1D1F),
                    fontSize: 15,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF272727),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOpen24Hours ? 'Open 24 hours' : 'Check hours',
                      style: const TextStyle(
                        color: Color(0xFF272727),
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
