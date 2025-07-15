import 'package:flutter/material.dart';

/// ──────────────────────────────────────────────────────────────────────────
/// 1️⃣  Simple immutable model
/// ──────────────────────────────────────────────────────────────────────────
class Venue {
  final String name;
  final String imageUrl;
  final List<String> sports;
  final double rating;
  final int reviewCount;
  final String distance;
  final String price;

  const Venue({
    required this.name,
    required this.imageUrl,
    required this.sports,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.price,
  });

  factory Venue.fromMap(Map<String, dynamic> map) => Venue(
    name: map['name'] as String,
    imageUrl: map['imageUrl'] as String,
    sports: List<String>.from(map['sports'] as List),
    rating: (map['rating'] as num).toDouble(),
    reviewCount: map['reviewCount'] as int,
    distance: map['distance'] as String,
    price: map['price'] as String,
  );
}

/// ──────────────────────────────────────────────────────────────────────────
/// 2️⃣  Reusable tile
/// ──────────────────────────────────────────────────────────────────────────
class VenueGridTile extends StatelessWidget {
  final Venue venue;
  final VoidCallback? onTap;

  const VenueGridTile({super.key, required this.venue, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Dimensions come from the grid’s childAspectRatio; avoid hard-coding here.
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Cover image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    venue.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // White card overlay
                Positioned(
                  left: 4,
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & sports
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                venue.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(0xFF272727),
                                  height: 1.3,
                                ),
                              ),
                              Text(
                                venue.sports.join(', '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Lexend',
                                  fontSize: 9,
                                  color: Color(0xFF858585),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Rating & distance
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 8,
                                  color: Color(0xFF272727),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${venue.rating.toStringAsFixed(1)} '
                                  '(${venue.reviewCount})',
                                  style: const TextStyle(
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9,
                                    color: Color(0xFF272727),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              venue.distance,
                              style: const TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 9,
                                color: Color(0xFF858585),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
