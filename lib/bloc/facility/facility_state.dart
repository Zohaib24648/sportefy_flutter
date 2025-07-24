part of 'facility_bloc.dart';

abstract class FacilityState {}

class FacilityInitial extends FacilityState {}

class FacilityLoading extends FacilityState {}

class FacilityLoaded extends FacilityState {
  final List<VenueBase> items;

  FacilityLoaded(this.items);
}

class FacilitySyncing extends FacilityState {}

class FacilitySyncSuccess extends FacilityState {
  final List<VenueBase> items;

  FacilitySyncSuccess(this.items);
}

class FacilityError extends FacilityState {
  final String message;

  FacilityError(this.message);
}
