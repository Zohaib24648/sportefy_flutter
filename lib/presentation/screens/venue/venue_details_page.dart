import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportefy/bloc/venue_details/venue_details_bloc.dart';
import 'package:sportefy/dependency_injection.dart';
import 'package:sportefy/presentation/widgets/venue/venue_widgets.dart';

class VenueDetailsPage extends StatelessWidget {
  final String venueId;

  const VenueDetailsPage({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<VenueDetailsBloc>()..add(LoadVenueDetails(venueId)),
      child: const VenueDetailsPageContent(),
    );
  }
}

class VenueDetailsPageContent extends StatelessWidget {
  const VenueDetailsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F7),
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 428),
          child: BlocBuilder<VenueDetailsBloc, VenueDetailsState>(
            builder: (context, state) {
              if (state is VenueDetailsLoading) {
                return const VenueLoadingWidget();
              } else if (state is VenueDetailsError) {
                return VenueErrorWidget(
                  message: state.message,
                  onRetry: () {
                    // Get the venueId from the parent widget
                    final venueId = context
                        .findAncestorWidgetOfExactType<VenueDetailsPage>()
                        ?.venueId;
                    if (venueId != null) {
                      context.read<VenueDetailsBloc>().add(
                        LoadVenueDetails(venueId),
                      );
                    }
                  },
                );
              } else if (state is VenueDetailsLoaded) {
                final venue = state.venue;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom App Bar
                        // const CustomAppBar(title: 'Venue Details'),
                        const SizedBox(height: 14),

                        // Venue Image and Info
                        VenueImageSection(
                          imageUrl: venue.primaryImageUrl,
                          venueName: venue.name,
                          rating: venue.rating,
                          reviewCount: venue.reviewCount,
                          pricePerHour: venue.pricePerHour,
                          isOpen24Hours: venue.isOpen24Hours,
                        ),
                        const SizedBox(height: 30),

                        // Location Section
                        LocationSection(
                          address: venue.address ?? 'No address provided',
                        ),
                        const SizedBox(height: 24),

                        // Description Section
                        DescriptionSection(description: venue.description),
                        if (venue.description.isNotEmpty)
                          const SizedBox(height: 24),

                        // Operating Hours Section
                        OperatingHoursSection(
                          operatingHours: venue.operatingHours,
                        ),
                        if (venue.operatingHours.isNotEmpty)
                          const SizedBox(height: 24),

                        // Contact Information
                        ContactInfoSection(
                          phoneNumber: venue.phoneNumber,
                          // owner: venue.facility.owner,
                        ),
                        const SizedBox(height: 24),

                        // Sports Available
                        SportsSection(sports: venue.sports),
                        const SizedBox(height: 24),

                        // Amenities
                        const AmenitiesSection(
                          amenities: [
                            'Parking',
                            'Changing room',
                            'Water',
                            'Lockers',
                            'Toilets',
                            'First Aid',
                          ],
                          selectedAmenity: 'Toilets',
                        ),
                        const SizedBox(height: 24),

                        // Rules and Regulations
                        const RulesButton(),
                        const SizedBox(height: 30),

                        // Ratings and Reviews
                        const RatingsReviewsSection(),
                        const SizedBox(height: 30),

                        // Proceed Button
                        ProceedButton(venueId: venue.id, venueName: venue.name),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
