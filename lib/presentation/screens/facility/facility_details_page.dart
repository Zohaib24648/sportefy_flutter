import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportefy/bloc/facility_details/facility_details_bloc.dart';
import 'package:sportefy/dependency_injection.dart';
import 'package:sportefy/presentation/widgets/facility/custom_app_bar.dart';
import 'package:sportefy/presentation/widgets/facility/image_section.dart';
import 'package:sportefy/presentation/widgets/facility/location_section.dart';
import 'package:sportefy/presentation/widgets/facility/proceed_button.dart';
import 'package:sportefy/presentation/widgets/facility/ratings_and_reviews_section.dart';
import 'package:sportefy/presentation/widgets/facility/rules_button.dart';
import 'package:sportefy/presentation/widgets/facility/sports_section.dart';

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
                return const Center(child: CircularProgressIndicator());
              } else if (state is FacilityDetailsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading facility details',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
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
                        const CustomAppBar(title: 'Venue Details'),
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
                        if (facility.description.isNotEmpty) ...[
                          const Text(
                            'About this venue',
                            style: TextStyle(
                              color: Color(0xFF272727),
                              fontSize: 14,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            facility.description,
                            style: const TextStyle(
                              color: Color(0xFF63616A),
                              fontSize: 12,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Operating Hours Section
                        if (facility.operatingHours.isNotEmpty) ...[
                          const Text(
                            'Operating Hours',
                            style: TextStyle(
                              color: Color(0xFF272727),
                              fontSize: 14,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...facility.operatingHours.map(
                            (hour) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    hour.dayOfWeek,
                                    style: const TextStyle(
                                      color: Color(0xFF63616A),
                                      fontSize: 12,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '${hour.openTime} - ${hour.closeTime}',
                                    style: const TextStyle(
                                      color: Color(0xFF272727),
                                      fontSize: 12,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Contact Information
                        const Text(
                          'Contact Information',
                          style: TextStyle(
                            color: Color(0xFF272727),
                            fontSize: 14,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: Color(0xFF9C86F2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              facility.phoneNumber,
                              style: const TextStyle(
                                color: Color(0xFF272727),
                                fontSize: 12,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Color(0xFF9C86F2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Owner: ${facility.owner.profile.fullName}',
                              style: const TextStyle(
                                color: Color(0xFF272727),
                                fontSize: 12,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Sports Available (placeholder - would need sports data)
                        const SportsSection(),
                        const SizedBox(height: 24),

                        // Amenities (placeholder - would need amenities data)
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
