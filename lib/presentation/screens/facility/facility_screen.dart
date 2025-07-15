// main facility_details_page.dart
import 'package:flutter/material.dart';
import 'package:sportefy/presentation/widgets/facility/custom_app_bar.dart';
import 'package:sportefy/presentation/widgets/facility/image_section.dart';
import 'package:sportefy/presentation/widgets/facility/location_section.dart';
import 'package:sportefy/presentation/widgets/facility/proceed_button.dart';
import 'package:sportefy/presentation/widgets/facility/ratings_and_reviews_section.dart';
import 'package:sportefy/presentation/widgets/facility/rules_button.dart';
import 'package:sportefy/presentation/widgets/facility/sports_section.dart';

class FacilityDetailsPage extends StatelessWidget {
  const FacilityDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F7),
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 428),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom App Bar
                  const CustomAppBar(title: 'Venue Details'),
                  const SizedBox(height: 14),

                  // Facility Image and Info
                  const FacilityImageSection(
                    imageUrl: "",
                    facilityName: "Red Meadows",
                    rating: 4.5,
                    reviewCount: 1427,
                    pricePerHour: 1000,
                    isOpen24Hours: true,
                  ),
                  const SizedBox(height: 30),

                  // Location Section
                  const LocationSection(
                    address:
                        "5P4F+HR4, Adoor Bypass Road, Adoor, Kerala 691523",
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
          ),
        ),
      ),
    );
  }
}
