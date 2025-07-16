import 'package:flutter/material.dart';
import 'package:sportefy/presentation/constants/image_links.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final double borderWidth;
  final Color borderColor;
  final double size;

  const CustomCircleAvatar({
    super.key,
    required this.imageUrl,
    this.size = 50.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl.isNotEmpty ? imageUrl : ImageLinks.fallbackAvatar,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
              ImageLinks.fallbackAvatar,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: size,
                  height: size,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: Colors.grey[600],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
