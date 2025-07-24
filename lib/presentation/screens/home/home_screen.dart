import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sportefy/presentation/widgets/common/custom_top_bar/custom_profile_picture.dart';
import 'package:sportefy/presentation/widgets/common/custom_top_bar/user_info.dart';
import 'package:sportefy/presentation/widgets/common/shimmer_exports.dart';
import 'package:sportefy/presentation/widgets/common/custom_top_bar/sports_dropdown.dart';
import 'package:sportefy/presentation/widgets/facility/booking_widget_calendar.dart';
import 'package:sportefy/presentation/widgets/venue_card.dart';
import 'package:sportefy/presentation/screens/venue/venue_details_page.dart';
import '../../../bloc/facility/venue_bloc.dart';
import '../../theme/app_colors.dart';
import '../../widgets/homepage_tile.dart';
import '../../widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const HomePage({super.key, this.onNavigateToTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Trigger fetching venues when the page loads
    context.read<VenueBloc>().add(GetVenue(''));
  }

  List<Map<String, dynamic>> _getTileData() {
    return [
      {
        'subtitle': 'Book Play. Win!',
        'title': 'Customize Your Own Event',
        'buttonText': 'Book Now',
        'white': const Color(0xFFFFD0BA),
        'onTap': () {
          widget.onNavigateToTab?.call(2); // Navigate to QR/create tab
        },
      },
      {
        'subtitle': 'Find & Join',
        'title': 'Discover Sports Events',
        'buttonText': 'Explore',
        'white': const Color(0xFFB8E6B8),
        'onTap': () {
          widget.onNavigateToTab?.call(1); // Navigate to search tab
        },
      },
      {
        'subtitle': 'Connect & Play',
        'title': 'Meet Fellow Athletes',
        'buttonText': 'Connect',
        'white': const Color(0xFFB8D4FF),
        'onTap': () {
          widget.onNavigateToTab?.call(3); // Navigate to profile tab
        },
      },
      {
        'subtitle': 'Track & Improve',
        'title': 'Your Activity History',
        'buttonText': 'View History',
        'white': const Color(0xFFFFB8E6),
        'onTap': () {
          widget.onNavigateToTab?.call(4); // Navigate to history tab
        },
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 16.0),
        leadingWidth: 80,
        leading: ProfilePicture(
          imageUrl:
              'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg',
          size: 50,
          membershipType: MembershipType.gold,
          badge: Icon(Icons.star, color: Colors.white, size: 12),
        ),
        title: UserInfo(
          name: 'John',
          creditAmount: '500',
          membershipType: MembershipType.gold,
        ),
        actions: [SportsDropdown()],
        backgroundColor: AppColors.white,
        toolbarHeight: 60,
      ),
      body: BlocBuilder<VenueBloc, VenueState>(
        builder: (context, state) {
          if (state is VenueLoading) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar shimmer
                  AppShimmer(
                    child: ShimmerContainer(
                      width: double.infinity,
                      height: 48,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Carousel shimmer
                  const CarouselShimmer(),
                  const SizedBox(height: 20),

                  // Sports chips shimmer
                  const SportsCategoryChipsShimmer(),
                  const SizedBox(height: 24),

                  // Section title shimmer
                  AppShimmer(
                    child: Row(
                      children: [
                        const ShimmerCircle(size: 20),
                        const SizedBox(width: 8),
                        ShimmerText(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Venues grid shimmer
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
                    itemCount: 6,
                    itemBuilder: (context, index) =>
                        const FacilityGridTileShimmer(),
                  ),
                ],
              ),
            );
          } else if (state is VenueLoaded) {
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
                      widget.onNavigateToTab?.call(1);
                    },
                    enabled: false, // Make it non-editable so it just navigates
                    white: Colors.white,
                    borderColor: Colors.transparent,
                    showShadow: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.primary,
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
                      height: 130,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 400,
                      ),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.15,
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
                              height: 130,
                              imageLink:
                                  'https://img.freepik.com/free-photo/front-view-handsome-athletic-male-rugby-player-holding-ball_23-2148793297.jpg?semt=ais_hybrid&w=740',
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
                  BookingWidget(
                    label: 'Book now',
                    leadingIcon: Image.asset(
                      'assets/icons/basketball.png',
                      width: 26,
                    ),
                    sideIcon: Image.asset(
                      'assets/icons/calendar.png',
                      width: 34,
                    ),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  // Section Title
                  const Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Nearby Venues',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      //TODO: Add navigation to view all venues when API is ready
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Venues Horizontal List
                  SizedBox(
                    height: 240, // Fixed height for the horizontal list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final venue = state.items[index];
                        return Container(
                          width: 180, // Fixed width for each card
                          margin: const EdgeInsets.only(right: 12),
                          child: VenueCard(
                            imageUrl:
                                'https://cdn.bhdw.net/im/one-day-you-can-have-such-muscles-by-working-in-the-gym-wallpaper-92002_w635.webp', // TODO: Add venue image when available in API
                            name: venue.name,
                            activities:
                                'Space Type: ${venue.spaceType}', // Using spaceType instead
                            rating: 4.5,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      VenueDetailsPage(venueId: venue.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            );
          } else if (state is VenueError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
