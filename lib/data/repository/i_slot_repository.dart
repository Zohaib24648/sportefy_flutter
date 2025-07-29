import 'package:sportefy/data/model/common/api_response_dto.dart';
import 'package:sportefy/data/model/sport_dto.dart';

import '../model/slot_dto.dart';

/// Interface for slot repository operations
abstract class ISlotRepository {
  /// Get venue slots for a specific date
  Future<ApiResponse<List<SlotDTO>>> getVenueSlots({
    required String venueId,
    required DateTime date,
  });

  /// Get venue slots for a date range
  Future<ApiResponse<List<SlotDTO>>> getVenueSlotsRange({
    required String venueId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
