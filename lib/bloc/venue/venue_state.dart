part of 'venue_bloc.dart';

abstract class VenueState {}

class VenueInitial extends VenueState {}

class VenueLoading extends VenueState {}

class VenueLoaded extends VenueState {
  final List<VenueDTO> items;

  VenueLoaded(this.items);
}

class VenueSyncing extends VenueState {}

class VenueSyncSuccess extends VenueState {
  final List<VenueDTO> items;

  VenueSyncSuccess(this.items);
}

class VenueError extends VenueState {
  final String message;

  VenueError(this.message);
}
