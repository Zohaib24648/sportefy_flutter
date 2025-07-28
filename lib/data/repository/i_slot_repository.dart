import '../model/slot.dart';

/// Interface for slot repository operations
abstract class ISlotRepository {
  /// Get venue slots for a specific date
  Future<SlotsApiResponse> getVenueSlots({
    required String venueId,
    required DateTime date,
  });

  /// Get venue slots for a date range
  Future<SlotsApiResponse> getVenueSlotsRange({
    required String venueId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
