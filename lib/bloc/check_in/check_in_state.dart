part of 'check_in_bloc.dart';

abstract class CheckInState {}

class CheckInInitial extends CheckInState {}

class CheckInLoading extends CheckInState {}

class CheckInSuccess extends CheckInState {
  final String message;
  final CheckInRecord record;

  CheckInSuccess({required this.message, required this.record});
}

class CheckInError extends CheckInState {
  final String error;

  CheckInError(this.error);
}

class CheckInHistoryLoaded extends CheckInState {
  final List<CheckInRecord> records;

  CheckInHistoryLoaded(this.records);
}

// Data model for check-in records
class CheckInRecord {
  final String id;
  final String userId;
  final String eventName;
  final String qrData;
  final DateTime checkInTime;

  CheckInRecord({
    required this.id,
    required this.userId,
    required this.eventName,
    required this.qrData,
    required this.checkInTime,
  });
}
