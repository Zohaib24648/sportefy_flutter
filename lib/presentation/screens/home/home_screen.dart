import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sportefy/presentation/widgets/home_page_grid_tile.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../constants/app_colors.dart';
import '../../widgets/homepage_tile.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/home_page_chip.dart';

class HomePage extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const HomePage({super.key, this.onNavigateToTab});

  List<Map<String, dynamic>> _getDummyVenues() {
    return [
      {
        'name': 'Red Meadows Sports Complex',
        'imageUrl':
            'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
        'sports': ['Football', 'Cricket'],
        'rating': 4.0,
        'reviewCount': 175,
        'distance': '1.8 km',
        'price': '\$25/hr',
      },
      {
        'name': 'Blue Court Tennis Club',
        'imageUrl':
            'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=400',
        'sports': ['Tennis', 'Badminton'],
        'rating': 4.5,
        'reviewCount': 89,
        'distance': '2.3 km',
        'price': '\$30/hr',
      },
      {
        'name': 'Green Valley Swimming Pool',
        'imageUrl':
            'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=400',
        'sports': ['Swimming', 'Water Polo'],
        'rating': 4.2,
        'reviewCount': 234,
        'distance': '0.9 km',
        'price': '\$15/hr',
      },
      {
        'name': 'Urban Fitness Center',
        'imageUrl':
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400',
        'sports': ['Gym', 'CrossFit'],
        'rating': 4.7,
        'reviewCount': 456,
        'distance': '1.2 km',
        'price': '\$20/hr',
      },
      {
        'name': 'Mountain Trail Basketball',
        'imageUrl':
            'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
        'sports': ['Basketball', 'Volleyball'],
        'rating': 3.8,
        'reviewCount': 67,
        'distance': '3.1 km',
        'price': '\$18/hr',
      },
      {
        'name': 'Riverside Running Track',
        'imageUrl':
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
        'sports': ['Running', 'Athletics'],
        'rating': 4.3,
        'reviewCount': 123,
        'distance': '1.5 km',
        'price': 'Free',
      },
    ];
  }

  List<Map<String, dynamic>> _getChipData() {
    return [
      {
        'title': 'Football',
        'icon': 'assets/icons/football.png',
        'onTap': () {
          debugPrint('Football chip tapped');
          onNavigateToTab?.call(1); // Navigate to search with football filter
        },
      },
      {
        'title': 'Basketball',
        'icon': 'assets/icons/basketball.png',
        'onTap': () {
          debugPrint('Basketball chip tapped');
          onNavigateToTab?.call(1);
        },
      },
      {
        'title': 'Cricket',
        'icon': 'assets/icons/cricket_ball.png',
        'onTap': () {
          debugPrint('Cricket chip tapped');
          onNavigateToTab?.call(1);
        },
      },
    ];
  }

  List<Map<String, dynamic>> _getTileData() {
    return [
      {
        'subtitle': 'Book Play. Win!',
        'title': 'Customize Your Own Event',
        'buttonText': 'Book Now',
        'backgroundColor': const Color(0xFFFFD0BA),
        'onTap': () {
          debugPrint('Navigating to Create Event tab (index 2)');
          onNavigateToTab?.call(2); // Navigate to QR/create tab
        },
      },
      {
        'subtitle': 'Find & Join',
        'title': 'Discover Sports Events',
        'buttonText': 'Explore',
        'backgroundColor': const Color(0xFFB8E6B8),
        'onTap': () {
          debugPrint('Navigating to Search tab (index 1)');
          onNavigateToTab?.call(1); // Navigate to search tab
        },
      },
      {
        'subtitle': 'Connect & Play',
        'title': 'Meet Fellow Athletes',
        'buttonText': 'Connect',
        'backgroundColor': const Color(0xFFB8D4FF),
        'onTap': () {
          debugPrint('Navigating to Profile tab (index 3)');
          onNavigateToTab?.call(3); // Navigate to profile tab
        },
      },
      {
        'subtitle': 'Track & Improve',
        'title': 'Your Activity History',
        'buttonText': 'View History',
        'backgroundColor': const Color(0xFFFFB8E6),
        'onTap': () {
          debugPrint('Navigating to History tab (index 4)');
          onNavigateToTab?.call(4); // Navigate to history tab
        },
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  EnhancedSearchBar(
                    hintText: 'Search for sports events...',
                    onTap: () {
                      // Navigate to search tab when search bar is tapped
                      HapticFeedback.lightImpact();
                      debugPrint(
                        'Search bar tapped - navigating to search tab',
                      );
                      onNavigateToTab?.call(1);
                    },
                    enabled: false, // Make it non-editable so it just navigates
                    backgroundColor: Colors.white,
                    borderColor: Colors.transparent,
                    showShadow: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                    suffixIcon: Icon(
                      Icons.filter_list,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Featured Events Carousel
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 160,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 400,
                      ),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.25,
                      viewportFraction: 0.8,
                      aspectRatio: 16 / 9,
                      initialPage: 0,
                    ),
                    items: _getTileData().map((tileData) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: HomepageTile(
                              subtitle: tileData['subtitle']!,
                              title: tileData['title']!,
                              buttonText: tileData['buttonText']!,
                              backgroundColor:
                                  tileData['backgroundColor'] as Color,
                              onTap: () {
                                // Add haptic feedback for better UX
                                HapticFeedback.lightImpact();
                                tileData['onTap']?.call();
                              },
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const Gap(20),

                  // Sports Category Chips - Fixed Height
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _getChipData().length,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        final chipData = _getChipData()[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: HomepageChip(
                            title: chipData['title']!,
                            iconAsset: chipData['icon'] as String,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              chipData['onTap']?.call();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section Title
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Nearby Venues',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Venues Grid - Shrink Wrap to avoid scrolling conflicts
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: _getDummyVenues().length,
                    itemBuilder: (context, index) {
                      final venueData = _getDummyVenues()[index];
                      final venue = Venue.fromMap(venueData);
                      return VenueGridTile(
                        venue: venue,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          debugPrint('Venue tapped: ${venue.name}');
                          onNavigateToTab?.call(1);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
