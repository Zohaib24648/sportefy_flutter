import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

/// Shimmer for search results
class SearchResultShimmer extends StatelessWidget {
  const SearchResultShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: [
          // Search suggestions
          Container(
            height: 150,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerText(width: 100, height: 16),
                const SizedBox(height: 12),
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const ShimmerCircle(size: 16),
                        const SizedBox(width: 12),
                        ShimmerText(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search results grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShimmerText(width: double.infinity, height: 14),
                          const SizedBox(height: 6),
                          ShimmerText(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for QR scanner screen elements
class QRScannerShimmer extends StatelessWidget {
  const QRScannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: Column(
          children: [
            const Spacer(),
            // Camera frame placeholder
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            const SizedBox(height: 40),

            // Instructions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  ShimmerText(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 20,
                  ),
                  const SizedBox(height: 12),
                  ShimmerText(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ShimmerContainer(
                  width: 120,
                  height: 44,
                  borderRadius: BorderRadius.circular(22),
                ),
                ShimmerContainer(
                  width: 120,
                  height: 44,
                  borderRadius: BorderRadius.circular(22),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for form fields in auth screens
class AuthFormShimmer extends StatelessWidget {
  final int fieldCount;

  const AuthFormShimmer({super.key, this.fieldCount = 4});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          ShimmerText(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 32,
          ),
          const SizedBox(height: 12),
          ShimmerText(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 16,
          ),
          const SizedBox(height: 32),

          // OAuth buttons
          Row(
            children: [
              Expanded(
                child: ShimmerContainer(
                  width: double.infinity,
                  height: 56,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ShimmerContainer(
                  width: double.infinity,
                  height: 56,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // OR divider
          Row(
            children: [
              Expanded(
                child: ShimmerContainer(
                  width: double.infinity,
                  height: 2,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(width: 16),
              const ShimmerText(width: 30, height: 16),
              const SizedBox(width: 16),
              Expanded(
                child: ShimmerContainer(
                  width: double.infinity,
                  height: 2,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form fields
          ...List.generate(
            fieldCount,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ShimmerContainer(
                width: double.infinity,
                height: 56,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit button
          ShimmerContainer(
            width: double.infinity,
            height: 56,
            borderRadius: BorderRadius.circular(14),
          ),
          const SizedBox(height: 16),

          // Footer text
          Center(
            child: ShimmerText(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for home screen carousels
class CarouselShimmer extends StatelessWidget {
  const CarouselShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SizedBox(
        height: 160,
        child: PageView.builder(
          itemCount: 3,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
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
        ),
      ),
    );
  }
}

/// Shimmer for sports category chips
class SportsCategoryChipsShimmer extends StatelessWidget {
  const SportsCategoryChipsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemBuilder: (context, index) => Container(
            width: 80,
            height: 32,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer for bottom navigation bar
class BottomNavShimmer extends StatelessWidget {
  const BottomNavShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...List.generate(
              2,
              (index) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ShimmerCircle(size: 24),
                  const SizedBox(height: 4),
                  ShimmerText(width: 40, height: 12),
                ],
              ),
            ),
            const ShimmerCircle(size: 56), // Center button
            ...List.generate(
              2,
              (index) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ShimmerCircle(size: 24),
                  const SizedBox(height: 4),
                  ShimmerText(width: 40, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
