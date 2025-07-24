import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class BookingWidget extends StatelessWidget {
  final String label;
  final Widget leadingIcon;
  final Widget sideIcon;
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
                          DefaultTextStyle(
                            style: Theme.of(context).textTheme.headlineSmall!,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                RotateAnimatedText(
                                  'Book Now',
                                  duration: const Duration(milliseconds: 4400),
                                  transitionHeight: 30,
                                ),
                                RotateAnimatedText(
                                  'Play Now',
                                  duration: const Duration(milliseconds: 4400),
                                  transitionHeight:
                                      30.0, // Adjust height for smooth transition
                                ),
                              ],
                              onTap: () {
                                print("Tap Event");
                              },
                              isRepeatingAnimation: true,
                              repeatForever: true,
                              pause:
                                  Duration.zero, // No pause between animations
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
