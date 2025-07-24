part of 'venue_details_bloc.dart';

abstract class VenueDetailsEvent {}

class LoadVenueDetails extends VenueDetailsEvent {
  final String venueId;

  LoadVenueDetails(this.venueId);
}
