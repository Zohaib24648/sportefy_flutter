import 'package:flutter/material.dart';
import '../common/shimmer_exports.dart';

class VenueLoadingWidget extends StatelessWidget {
  const VenueLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const VenueDetailsShimmer();
  }
}
