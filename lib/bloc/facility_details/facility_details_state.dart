part of 'facility_details_bloc.dart';

abstract class FacilityDetailsState {}

class FacilityDetailsInitial extends FacilityDetailsState {}

class FacilityDetailsLoading extends FacilityDetailsState {}

class FacilityDetailsLoaded extends FacilityDetailsState {
  final FacilityDetails facility;

  FacilityDetailsLoaded(this.facility);
}

class FacilityDetailsError extends FacilityDetailsState {
  final String message;

  FacilityDetailsError(this.message);
}
