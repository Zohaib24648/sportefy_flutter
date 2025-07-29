import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sportefy/core/utils/performance_config.dart';
import 'package:sportefy/core/utils/home_tile_utils.dart';
import 'package:sportefy/presentation/widgets/common/custom_top_bar/custom_profile_picture.dart';
import 'package:sportefy/presentation/widgets/common/custom_top_bar/user_info.dart';
import 'package:sportefy/presentation/widgets/common/shimmer_exports.dart';
import 'package:sportefy/presentation/widgets/common/custom_top_bar/sports_dropdown.dart';
import 'package:sportefy/presentation/widgets/venue/venue_widgets.dart';
import 'package:sportefy/presentation/screens/venue/venue_details_page.dart';
import '../../../bloc/venue/venue_bloc.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../theme/app_colors.dart';
import '../../widgets/home/home_widgets.dart';
import '../../widgets/search/search_widgets.dart';

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

    // Only trigger fetching user profile if not already loaded
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is! ProfileLoaded) {
      context.read<ProfileBloc>().add(LoadUserProfile());
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          // Extract profile data when loaded
          String? avatarUrl;
          String userName = 'Guest User';
          String credits = '0';

          if (profileState is ProfileLoaded) {
            avatarUrl = profileState.profile.avatarUrl;
            userName =
                profileState.profile.userName ?? profileState.profile.fullName;
            credits = profileState.profile.credits?.toString() ?? '0';
          }

          return AppBar(
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leadingWidth: 80,
            elevation: 0, // Remove shadow
            scrolledUnderElevation: 0, // Remove elevation when scrolled
            leading:
                profileState is ProfileLoaded &&
                    avatarUrl != null &&
                    avatarUrl.isNotEmpty
                ? ProfilePicture(
                    imageUrl: avatarUrl,
                    size: 50,
                    membershipType: MembershipType.gold,
                    badge: Icon(Icons.star, color: Colors.white, size: 12),
                  )
                : Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightGrey,
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Icon(Icons.person, color: AppColors.grey, size: 25),
                  ),
            title: UserInfo(
              name: userName,
              creditAmount: credits,
              membershipType: MembershipType.gold,
            ),
            actions: [SportsDropdown()],
            backgroundColor: AppColors.white,
            toolbarHeight: 50,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false, // Ensure body doesn't extend behind AppBar
      appBar: _buildAppBar(),
      body: BlocBuilder<VenueBloc, VenueState>(
        builder: (context, venueState) {
          return BlocListener<ProfileBloc, ProfileState>(
            listener: (context, profileState) {
              // Handle profile error by showing a snackbar
              if (profileState is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Failed to load profile: ${profileState.error}',
                    ),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'Retry',
                      textColor: Colors.white,
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadUserProfile());
                      },
                    ),
                  ),
                );
              }
            },
            child: _buildBody(venueState),
          );
        },
      ),
    );
  }

  Widget _buildBody(VenueState venueState) {
    if (venueState is VenueLoading) {
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.8,
              ),
              itemCount: 6,
              itemBuilder: (context, index) => const VenueGridTileShimmer(),
            ),
          ],
        ),
      );
    } else if (venueState is VenueLoaded) {
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
                autoPlayAnimationDuration: const Duration(milliseconds: 400),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.15,
                viewportFraction: 0.8,
                aspectRatio: 16 / 9,
                initialPage: 0,
              ),
              items:
                  HomeTileUtils.getTileData(
                    onNavigateToTab: widget.onNavigateToTab,
                  ).map((tileData) {
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
              sideIcon: Image.asset('assets/icons/calendar.png', width: 34),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                //TODO: Add navigation to view all venues when API is ready
                Text(
                  'View All',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                itemCount: venueState.items.length,
                cacheExtent: PerformanceConfig.kListCacheExtent,
                physics: PerformanceConfig.scrollPhysics,
                itemBuilder: (context, index) {
                  final venue = venueState.items[index];
                  return Container(
                    width: 180, // Fixed width for each card
                    margin: const EdgeInsets.only(right: 12),
                    child: RepaintBoundary(
                      // Isolate repaints to individual cards
                      child: VenueCard(
                        imageUrl:
                            'https://cdn.bhdw.net/im/one-day-you-can-have-such-muscles-by-working-in-the-gym-wallpaper-92002_w635.webp', // TODO: Add venue image when available in API
                        name: venue.name ?? 'Unknown Venue',
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
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      );
    } else if (venueState is VenueError) {
      return Center(child: Text(venueState.message));
    }
    return const Center(child: CircularProgressIndicator());
  }
}
