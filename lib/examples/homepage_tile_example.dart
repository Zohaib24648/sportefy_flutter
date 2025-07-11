// Example usage of HomepageTile widget
// You can copy this code to test the widget independently

import 'package:flutter/material.dart';
import 'package:sportefy/presentation/widgets/homepage_tile.dart';

class HomepageTileExample extends StatelessWidget {
  const HomepageTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homepage Tile Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Single tile example
            HomepageTile(
              subtitle: 'Book Play. Win!',
              title: 'Customize Your Own Event',
              buttonText: 'Book Now',
              backgroundColor: const Color(0xFFFFD0BA),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book Now tapped!')),
                );
              },
            ),
            const SizedBox(height: 20),

            // Horizontal ListView example (as used in homepage)
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  final tiles = [
                    {
                      'subtitle': 'Book Play. Win!',
                      'title': 'Customize Your Own Event',
                      'buttonText': 'Book Now',
                      'backgroundColor': const Color(0xFFFFD0BA),
                    },
                    {
                      'subtitle': 'Find & Join',
                      'title': 'Discover Sports Events',
                      'buttonText': 'Explore',
                      'backgroundColor': const Color(0xFFB8E6B8),
                    },
                    {
                      'subtitle': 'Connect & Play',
                      'title': 'Meet Fellow Athletes',
                      'buttonText': 'Connect',
                      'backgroundColor': const Color(0xFFB8D4FF),
                    },
                    {
                      'subtitle': 'Track & Improve',
                      'title': 'Your Activity History',
                      'buttonText': 'View History',
                      'backgroundColor': const Color(0xFFFFB8E6),
                    },
                  ];

                  final tile = tiles[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: HomepageTile(
                      subtitle: tile['subtitle'] as String,
                      title: tile['title'] as String,
                      buttonText: tile['buttonText'] as String,
                      backgroundColor: tile['backgroundColor'] as Color,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${tile['buttonText']} tapped!'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
