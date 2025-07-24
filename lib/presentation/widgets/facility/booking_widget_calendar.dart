import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sportefy/presentation/theme/app_colors.dart';

/// A lightweight, reusable component mirroring the Figma design:
/// ┌─── Book now ───>>>  📅 ┐
/// It bundles a primary call‑to‑action with a secondary square icon.
class BookingWidget extends StatelessWidget {
  final String label;
  final Widget leadingIcon; // e.g. Image.asset('assets/ball.png', width: 26)
  final Widget sideIcon; // e.g. Image.asset('assets/calendar.png', width: 34)
  final VoidCallback onTap;

  const BookingWidget({
    super.key,
    required this.label,
    required this.leadingIcon,
    required this.sideIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(12));

    return Row(
      children: [
        // Main button
        Expanded(
          child: Material(
            color: Colors.white,
            elevation: 1,
            shadowColor: Colors.black12,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: onTap,
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Leading square icon
                    Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadius,
                      ),
                      alignment: Alignment.center,
                      child: leadingIcon,
                    ),
                    const SizedBox(width: 12),
                    // Animated Label
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 50, // Fixed width to prevent layout shifts
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  RotateAnimatedText(
                                    'Book',
                                    duration: const Duration(
                                      milliseconds: 2200,
                                    ), // 2s display + 0.2s transition
                                  ),
                                  RotateAnimatedText(
                                    'Play',
                                    duration: const Duration(
                                      milliseconds: 2200,
                                    ), // 2s display + 0.2s transition
                                  ),
                                ],
                                onTap: () {
                                  print("Tap Event");
                                },
                                isRepeatingAnimation: true,
                                repeatForever: true,
                                pause: Duration
                                    .zero, // No pause between animations
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Now',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Colors.black54,
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 23,
                          color: Colors.black54,
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 26,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Side icon button
        Material(
          color: Colors.white,
          elevation: 1,
          shadowColor: Colors.black12,
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              child: sideIcon,
            ),
          ),
        ),
      ],
    );
  }
}
