import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

/// Shimmer loading for facility grid tiles
class FacilityGridTileShimmer extends StatelessWidget {
  const FacilityGridTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              flex: 3,
              child: ShimmerImage(
                width: double.infinity,
                height: double.infinity,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
            ),
            // Content section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const ShimmerText(width: double.infinity, height: 16),
                    const SizedBox(height: 6),
                    // Address
                    ShimmerText(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 12,
                    ),
                    const SizedBox(height: 6),
                    // Rating or additional info
                    Row(
                      children: [
                        const ShimmerCircle(size: 12),
                        const SizedBox(width: 6),
                        ShimmerText(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 12,
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
    );
  }
}

/// Shimmer for facility details page
class FacilityDetailsShimmer extends StatelessWidget {
  const FacilityDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ShimmerCircle(size: 48),
                ShimmerText(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 24,
                ),
                const ShimmerCircle(size: 48),
              ],
            ),
            const SizedBox(height: 24),

            // Main image
            ShimmerImage(
              width: double.infinity,
              height: 240,
              borderRadius: BorderRadius.circular(15),
            ),
            const SizedBox(height: 16),

            // Info section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerText(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 24,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const ShimmerCircle(size: 16),
                          const SizedBox(width: 8),
                          ShimmerText(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShimmerText(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 18,
                    ),
                    const SizedBox(height: 8),
                    ShimmerText(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 16,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sports section
            const ShimmerText(width: 100, height: 20),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                6,
                (index) => ShimmerContainer(
                  width: 82,
                  height: 73,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Description section
            const ShimmerText(width: 120, height: 20),
            const SizedBox(height: 16),
            const ShimmerTextPattern(lines: 4, lastLineWidth: 200),
            const SizedBox(height: 24),

            // Reviews section
            const ShimmerText(width: 150, height: 20),
            const SizedBox(height: 16),
            ...List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerCircle(size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ShimmerText(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 16,
                              ),
                              const Spacer(),
                              ...List.generate(
                                5,
                                (i) => const Padding(
                                  padding: EdgeInsets.only(left: 2),
                                  child: ShimmerCircle(size: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const ShimmerTextPattern(
                            lines: 2,
                            lastLineWidth: 150,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Proceed button
            ShimmerContainer(
              width: double.infinity,
              height: 56,
              borderRadius: BorderRadius.circular(14),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for homepage tiles
class HomepageTileShimmer extends StatelessWidget {
  const HomepageTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerText(width: 80, height: 14),
              const SizedBox(height: 8),
              const ShimmerText(width: 150, height: 20),
              const Spacer(),
              ShimmerContainer(
                width: 120,
                height: 36,
                borderRadius: BorderRadius.circular(18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer for profile screen sections
class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile picture and basic info
            Row(
              children: [
                const ShimmerCircle(size: 80),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerText(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 24,
                      ),
                      const SizedBox(height: 8),
                      ShimmerText(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 16,
                      ),
                      const SizedBox(height: 8),
                      ShimmerText(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Profile info rows
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    const ShimmerCircle(size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerText(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 12,
                          ),
                          const SizedBox(height: 4),
                          ShimmerText(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for history list items
class HistoryItemShimmer extends StatelessWidget {
  const HistoryItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const ShimmerCircle(size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerText(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 18,
                  ),
                  const SizedBox(height: 8),
                  ShimmerText(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 14,
                  ),
                  const SizedBox(height: 4),
                  ShimmerText(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 12,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const ShimmerCircle(size: 24),
                const SizedBox(height: 8),
                const ShimmerCircle(size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
