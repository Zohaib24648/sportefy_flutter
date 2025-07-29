import 'package:equatable/equatable.dart';

/// Time slot chip model for UI
class TimeSlotDTO extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  const TimeSlotDTO({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  /// Format time slot as "HH:MM AM/PM - HH:MM AM/PM"
  String get formattedTime {
    String formatTime(DateTime time) {
      int hour = time.hour;
      int minute = time.minute;
      String period = hour >= 12 ? 'PM' : 'AM';

      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;

      String hourStr = hour.toString().padLeft(2, '0');
      String minuteStr = minute.toString().padLeft(2, '0');

      return '$hourStr:$minuteStr $period';
    }

    return '${formatTime(startTime)} - ${formatTime(endTime)}';
  }

  /// Duration in hours
  double get durationInHours {
    return endTime.difference(startTime).inMinutes / 60.0;
  }

  @override
  List<Object?> get props => [startTime, endTime, isAvailable];
}
