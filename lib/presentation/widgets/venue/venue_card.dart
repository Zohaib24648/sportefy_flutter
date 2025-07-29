import 'package:flutter/material.dart';
import 'package:sportefy/data/model/venue_base_dto.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({
    super.key,
    required this.imageUrl,
    required this.name,
    this.activities,
    this.rating,
    this.reviewCount,
    this.width = 233,
    this.height = 303,
    this.onTap,
  });

  factory VenueCard.fromVenue({
    Key? key,
    required VenueBase venue,
    double? rating,
    int? reviewCount,
    double? distanceKm,
    double width = 233,
    double height = 303,
    VoidCallback? onTap,
  }) {
    return VenueCard(
      key: key,
      imageUrl: '', // TODO: Add venue image when available in API
      name: venue.name,
      activities: 'Space Type: ${venue.spaceType}, Capacity: ${venue.capacity}',
      rating: rating,
      reviewCount: reviewCount,
      width: width,
      height: height,
      onTap: onTap,
    );
  }

  // -------------------------------------------------------------------------
  // Immutable fields
  // -------------------------------------------------------------------------
  final String imageUrl;
  final String name;
  final String? activities; // e.g. "Football, Cricket" _or_ address.
  final double? rating; // Optional: star score out of 5.
  final int? reviewCount; // Optional: number of reviews.
  final double width; // Target width supplied by parent.
  final double height; // Target height supplied by parent.
  final VoidCallback? onTap; // Tap handler.

  // Reference design used to derive proportional scaling.
  static const double _kBaseWidth = 233;
  static const double _kBaseHeight = 303;

  // Pre-calculate styles to avoid creating them in build method
  static const LinearGradient _overlayGradient = LinearGradient(
    begin: Alignment(0.50, 0.62),
    end: Alignment(0.49, 0.97),
    colors: [
      Color(0x00000000), // Transparent
      Color(0xD9000000), // 85% opacity black
    ],
  );

  @override
  Widget build(BuildContext context) {
    // Derive proportional multipliers.
    final double scaleW = width / _kBaseWidth;
    final double scaleH = height / _kBaseHeight;
    final double fontScale = scaleW; // One axis is plenty for text scaling.

    final bool hasRating = rating != null && reviewCount != null;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20 * scaleW),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image.
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[400],
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                    ),
                  ),
                ),
                memCacheWidth: (width * 2)
                    .round(), // Cache at 2x for better quality
                memCacheHeight: (height * 2).round(),
              ),

              // Bottom fade so text remains legible.
              Container(
                decoration: const BoxDecoration(gradient: _overlayGradient),
              ),

              // Foreground content.
              Positioned(
                left: 20 * scaleW,
                right: 20 * scaleW,
                bottom: 20 * scaleH,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and secondary line.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.83 * fontScale,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          if (activities != null && activities!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 4 * scaleH),
                              child: Text(
                                activities!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.87 * fontScale,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                  height: 1.3,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12 * scaleW),
                    // Rating / distance column (only shown if data provided).
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (hasRating)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 11 * fontScale,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4 * scaleW),
                              Text(
                                '${rating!.toStringAsFixed(1)} ($reviewCount)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.87 * fontScale,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        // if (hasRating && hasDistance)
                        //   SizedBox(height: 4 * scaleH),
                        // if (hasDistance)
                        //   Text(
                        //     '~${distanceKm!.toStringAsFixed(1)} km',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 11.87 * fontScale,
                        //       fontFamily: 'Lexend',
                        //       fontWeight: FontWeight.w400,
                        //       height: 1.3,
                        //     ),
                        //   ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
