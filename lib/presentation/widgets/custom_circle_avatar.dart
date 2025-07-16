import 'package:flutter/material.dart';
import 'package:sportefy/presentation/constants/image_links.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final double borderWidth;
  final Color borderColor;
  final double radius;

  const CustomCircleAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 30.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        imageUrl.isNotEmpty ? imageUrl : ImageLinks.fallbackAvatar,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.network(
            ImageLinks.fallbackAvatar,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // If even the fallback fails, show a default icon
              return Container(
                width: radius * 2,
                height: radius * 2,
                color: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: radius,
                  color: Colors.grey[600],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
