import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../model/slot_dto.dart';
import 'i_slot_repository.dart';

/// Repository implementation for slot operations
@LazySingleton(as: ISlotRepository)
class SlotRepository implements ISlotRepository {
  final Dio _dio;

  SlotRepository(this._dio);

  @override
  Future<List<SlotDTO>> getVenueSlots({
    required String venueId,
    required DateTime date,
  }) async {
    try {
      final formattedDate = _formatDate(date);

      final response = await _dio.get(
        '/slot/venues/$venueId/slots',
        queryParameters: {'date': formattedDate},
      );

      return SlotsApiResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch venue slots: $e');
    }
  }

  @override
  Future<SlotsApiResponse> getVenueSlotsRange({
    required String venueId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final formattedStartDate = _formatDate(startDate);
      final formattedEndDate = _formatDate(endDate);

      final response = await _dio.get(
        '/slot/venues/$venueId/slots',
        queryParameters: {
          'startDate': formattedStartDate,
          'endDate': formattedEndDate,
        },
      );

      return SlotsApiResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch venue slots range: $e');
    }
  }

  /// Format DateTime to yyyy-MM-dd string
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
