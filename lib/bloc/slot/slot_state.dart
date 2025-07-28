part of 'slot_bloc.dart';

abstract class SlotState {}

class SlotInitial extends SlotState {}

class SlotLoading extends SlotState {}

class SlotLoaded extends SlotState {
  final List<TimeSlot> timeSlots;
  final DateTime date;

  SlotLoaded({required this.timeSlots, required this.date});
}

class SlotError extends SlotState {
  final String message;

  SlotError(this.message);
}
