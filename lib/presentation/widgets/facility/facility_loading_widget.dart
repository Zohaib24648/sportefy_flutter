import 'package:flutter/material.dart';
import '../common/shimmer_exports.dart';

class FacilityLoadingWidget extends StatelessWidget {
  const FacilityLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const FacilityDetailsShimmer();
  }
}
