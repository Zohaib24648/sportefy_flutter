import '../model/slot_dto.dart';

abstract class ISlotRepository {
  Future<List<SlotDTO>> getVenueSlots({
    required String venueId,
    required DateTime date,
  });

  /// Get venue slots for a date range
  // Future<List<SlotDTO>> getVenueSlotsRange({
  //   required String venueId,
  //   required DateTime startDate,
  //   required DateTime endDate,
  // });
}
