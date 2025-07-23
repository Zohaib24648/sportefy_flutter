import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportefy/bloc/facility_details/facility_details_bloc.dart';
import 'package:sportefy/dependency_injection.dart';
import 'package:sportefy/presentation/widgets/facility/facility_widgets.dart';

class FacilityDetailsPage extends StatelessWidget {
  final String facilityId;

  const FacilityDetailsPage({super.key, required this.facilityId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<FacilityDetailsBloc>()..add(LoadFacilityDetails(facilityId)),
      child: FacilityDetailsPageContent(),
    );
  }
}

class FacilityDetailsPageContent extends StatelessWidget {
  const FacilityDetailsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F7),
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 428),
          child: BlocBuilder<FacilityDetailsBloc, FacilityDetailsState>(
            builder: (context, state) {
              if (state is FacilityDetailsLoading) {
                return const FacilityLoadingWidget();
              } else if (state is FacilityDetailsError) {
                return FacilityErrorWidget(
                  message: state.message,
                  onRetry: () {
                    // Get the facilityId from the parent widget
                    final facilityId = context
                        .findAncestorWidgetOfExactType<FacilityDetailsPage>()
                        ?.facilityId;
                    if (facilityId != null) {
                      context.read<FacilityDetailsBloc>().add(
                        LoadFacilityDetails(facilityId),
                      );
                    }
                  },
                );
              } else if (state is FacilityDetailsLoaded) {
                final facility = state.facility;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom App Bar
                        // const CustomAppBar(title: 'Venue Details'),
                        const SizedBox(height: 14),

                        // Facility Image and Info
                        FacilityImageSection(
                          imageUrl: facility.primaryImageUrl,
                          facilityName: facility.name,
                          rating: facility.rating,
                          reviewCount: facility.reviewCount,
                          pricePerHour: facility.pricePerHour,
                          isOpen24Hours: facility.isOpen24Hours,
                        ),
                        const SizedBox(height: 30),

                        // Location Section
                        LocationSection(address: facility.address),
                        const SizedBox(height: 24),

                        // Description Section
                        DescriptionSection(description: facility.description),
                        if (facility.description.isNotEmpty)
                          const SizedBox(height: 24),

                        // Operating Hours Section
                        OperatingHoursSection(
                          operatingHours: facility.operatingHours,
                        ),
                        if (facility.operatingHours.isNotEmpty)
                          const SizedBox(height: 24),

                        // Contact Information
                        ContactInfoSection(
                          phoneNumber: facility.phoneNumber,
                          owner: facility.owner,
                        ),
                        const SizedBox(height: 24),

                        // Sports Available
                        const SportsSection(),
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
                        const ProceedButton(),
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
