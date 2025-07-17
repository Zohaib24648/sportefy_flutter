import 'package:flutter/material.dart';
import 'package:sportefy/data/model/facility_base.dart';
import 'common/shimmer_exports.dart';

/// ──────────────────────────────────────────────────────────────────────────
/// 1️⃣  Simple immutable model
/// ──────────────────────────────────────────────────────────────────────────
class Facility {
  final String name;
  final String imageUrl;
  final String address;
  final String phoneNumber;

  const Facility({
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.phoneNumber,
  });

  factory Facility.fromFacilityBase(FacilityBase base) => Facility(
    name: base.name,
    imageUrl: base.coverUrl,
    address: base.address,
    phoneNumber: base.phoneNumber,
  );
}

/// ──────────────────────────────────────────────────────────────────────────
/// 2️⃣  Reusable tile
/// ──────────────────────────────────────────────────────────────────────────
class FacilityGridTile extends StatelessWidget {
  final Facility facility;
  final VoidCallback? onTap;

  const FacilityGridTile({super.key, required this.facility, this.onTap});

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
                    facility.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return AppShimmer(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.business,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.name,
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
                          facility.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 9,
                            color: Color(0xFF858585),
                          ),
                        ),
                        Text(
                          facility.phoneNumber,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
