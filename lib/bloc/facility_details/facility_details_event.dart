part of 'facility_details_bloc.dart';

abstract class FacilityDetailsEvent {}

class LoadFacilityDetails extends FacilityDetailsEvent {
  final String facilityId;

  LoadFacilityDetails(this.facilityId);
}
