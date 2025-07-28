import 'package:equatable/equatable.dart';

/// Slot model for API response
class SlotApiResponse extends Equatable {
  final String id;
  final String venueId;
  final DateTime startTime;
  final DateTime endTime;
  final String eventType;
  final String eventId;
  final DateTime createdAt;

  const SlotApiResponse({
    required this.id,
    required this.venueId,
    required this.startTime,
    required this.endTime,
    required this.eventType,
    required this.eventId,
    required this.createdAt,
  });

  factory SlotApiResponse.fromJson(Map<String, dynamic> json) {
    return SlotApiResponse(
      id: json['id']?.toString() ?? '',
      venueId: json['venueId']?.toString() ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : DateTime.now(),
      eventType: json['eventType']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venueId': venueId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'eventType': eventType,
      'eventId': eventId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    venueId,
    startTime,
    endTime,
    eventType,
    eventId,
    createdAt,
  ];
}

/// API Response wrapper for slots
class SlotsApiResponse extends Equatable {
  final List<SlotApiResponse> data;
  final bool success;
  final String message;

  const SlotsApiResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory SlotsApiResponse.fromJson(Map<String, dynamic> json) {
    return SlotsApiResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((slot) => SlotApiResponse.fromJson(slot))
              .toList() ??
          [],
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [data, success, message];
}

/// Time slot chip model for UI
class TimeSlot extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  const TimeSlot({
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

/// Utility class to generate time slots from booked slots
class SlotGenerator {
  /// Generate available time slots for a day based on booked slots
  /// Operating hours are from 00:00 to 24:00 (full day)
  static List<TimeSlot> generateTimeSlots(
    DateTime date,
    List<SlotApiResponse> bookedSlots,
  ) {
    final List<TimeSlot> timeSlots = [];

    // Start from beginning of day
    final dayStart = DateTime(date.year, date.month, date.day, 0, 0);
    final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);

    // Sort booked slots by start time
    final sortedBookedSlots = List<SlotApiResponse>.from(bookedSlots)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    DateTime currentTime = dayStart;

    for (final bookedSlot in sortedBookedSlots) {
      // If there's a gap before this booked slot, create an available slot
      if (currentTime.isBefore(bookedSlot.startTime)) {
        timeSlots.add(
          TimeSlot(
            startTime: currentTime,
            endTime: bookedSlot.startTime,
            isAvailable: true,
          ),
        );
      }

      // Move current time to end of booked slot
      currentTime = bookedSlot.endTime.isAfter(currentTime)
          ? bookedSlot.endTime
          : currentTime;
    }

    // If there's time remaining after all booked slots, create final available slot
    if (currentTime.isBefore(dayEnd)) {
      timeSlots.add(
        TimeSlot(startTime: currentTime, endTime: dayEnd, isAvailable: true),
      );
    }

    // Filter out slots less than 30 minutes (too short to be useful)
    return timeSlots
        .where(
          (slot) => slot.endTime.difference(slot.startTime).inMinutes >= 30,
        )
        .toList();
  }
}
