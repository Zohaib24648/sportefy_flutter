part of 'venue_details_bloc.dart';

abstract class VenueDetailsState {}

class VenueDetailsInitial extends VenueDetailsState {}

class VenueDetailsLoading extends VenueDetailsState {}

class VenueDetailsLoaded extends VenueDetailsState {
  final VenueDetails venue;

  VenueDetailsLoaded(this.venue);
}

class VenueDetailsError extends VenueDetailsState {
  final String message;

  VenueDetailsError(this.message);
}
