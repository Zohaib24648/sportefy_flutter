import 'package:flutter/material.dart';
import '../common/shimmer_exports.dart';
import '../../theme/app_colors.dart';

/// Loading widget specifically for buttons
class ButtonLoading extends StatelessWidget {
  final Color? color;
  final double size;

  const ButtonLoading({super.key, this.color, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AppShimmer(
        child: Container(
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
      ),
    );
  }
}

/// Loading widget for content areas
class ContentLoading extends StatelessWidget {
  final double height;
  final double? width;

  const ContentLoading({super.key, this.height = 100.0, this.width});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

/// Loading widget for list items
class ListItemLoading extends StatelessWidget {
  final int itemCount;

  const ListItemLoading({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => const ContentLoading(height: 80),
    );
  }
}

/// Loading widget for cards
class CardLoading extends StatelessWidget {
  final double height;
  final double width;

  const CardLoading({super.key, this.height = 200.0, this.width = 150.0});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}

/// Generic loading indicator with app styling
class AppLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const AppLoadingIndicator({super.key, this.color, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
        strokeWidth: 2.0,
      ),
    );
  }
}
