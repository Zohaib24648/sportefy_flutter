import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../constants/app_colors.dart';
import '../../widgets/homepage_tile.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/home_page_chip.dart';

class HomePage extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const HomePage({super.key, this.onNavigateToTab});

  List<Map<String, dynamic>> _getChipData() {
    return [
      {
        'title': 'Football',
        'icon': Icons.sports_soccer,
        'onTap': () {
          debugPrint('Football chip tapped');
          onNavigateToTab?.call(1); // Navigate to search with football filter
        },
      },
      {
        'title': 'Basketball',
        'icon': Icons.sports_basketball,
        'onTap': () {
          debugPrint('Basketball chip tapped');
          onNavigateToTab?.call(1);
        },
      },
      {
        'title': 'Tennis',
        'icon': Icons.sports_tennis,
        'onTap': () {
          debugPrint('Tennis chip tapped');
          onNavigateToTab?.call(1);
        },
      },
      {
        'title': 'Swimming',
        'icon': Icons.pool,
        'onTap': () {
          debugPrint('Swimming chip tapped');
          onNavigateToTab?.call(1);
        },
      },
      {
        'title': 'Running',
        'icon': Icons.directions_run,
        'onTap': () {
          debugPrint('Running chip tapped');
          onNavigateToTab?.call(1);
        },
      },
      {
        'title': 'Gym',
        'icon': Icons.fitness_center,
        'onTap': () {
          debugPrint('Gym chip tapped');
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
            return Padding(
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

                  // Sports Categories Chips
                  SizedBox(
                    height: 55,
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
                            icon: chipData['icon'] as IconData,
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

                  // Featured Events section
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.primaryColor, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Featured Events',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _getTileData().length,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        final tileData = _getTileData()[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: SizedBox(
                            width: 280,
                            height: 160,
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
                          ),
                        );
                      },
                    ),
                  ),
                  const Expanded(flex: 2, child: SizedBox()),
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
