part of 'check_in_bloc.dart';

abstract class CheckInEvent {}

class CheckInRequested extends CheckInEvent {
  final String qrData;
  final String userId;

  CheckInRequested({required this.qrData, required this.userId});
}

class CheckInHistoryRequested extends CheckInEvent {
  final String userId;

  CheckInHistoryRequested(this.userId);
}
