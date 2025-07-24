part of 'venue_bloc.dart';

abstract class VenueEvent {}

class GetVenue extends VenueEvent {
  final String userId;

  GetVenue(this.userId);
}
