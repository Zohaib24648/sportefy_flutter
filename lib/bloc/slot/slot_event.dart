part of 'slot_bloc.dart';

abstract class SlotEvent {}

class LoadVenueSlots extends SlotEvent {
  final String venueId;
  final DateTime date;

  LoadVenueSlots({required this.venueId, required this.date});
}

class RefreshSlots extends SlotEvent {
  final String venueId;
  final DateTime date;

  RefreshSlots({required this.venueId, required this.date});
}
