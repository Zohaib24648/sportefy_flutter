import 'package:sportefy/data/model/slot_dto.dart';
import 'package:sportefy/data/model/time_slot.dart';

/// Generates available time slots based on booked ones
class SlotGenerator {
  /// Generates time slots between 00:00 to 24:00 for given date
  /// Removes overlaps with booked slots
  static List<TimeSlotDTO> generateTimeSlots(
    DateTime date,
    List<SlotDTO> bookedSlots,
  ) {
    final List<TimeSlotDTO> timeSlots = [];

    final dayStart = DateTime(date.year, date.month, date.day, 0, 0);
    final dayEnd = DateTime(date.year, date.month, date.day, 23, 59);

    final sorted = List<SlotDTO>.from(bookedSlots)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    DateTime current = dayStart;

    for (final booked in sorted) {
      if (current.isBefore(booked.startTime)) {
        timeSlots.add(
          TimeSlotDTO(
            startTime: current,
            endTime: booked.startTime,
            isAvailable: true,
          ),
        );
      }
      current = booked.endTime.isAfter(current) ? booked.endTime : current;
    }

    if (current.isBefore(dayEnd)) {
      timeSlots.add(
        TimeSlotDTO(startTime: current, endTime: dayEnd, isAvailable: true),
      );
    }

    return timeSlots
        .where((s) => s.endTime.difference(s.startTime).inMinutes >= 30)
        .toList();
  }
}
