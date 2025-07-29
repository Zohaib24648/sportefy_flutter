import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/common/api_response_dto.dart';
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

      final slots = ApiResponse<List<SlotDTO>>.fromJson(
        response.data,
        (dynamic data) =>
            (data as List).map((item) => SlotDTO.fromJson(item)).toList(),
      );

      if (slots.success == false) {
        throw Exception('Failed to load venue slots: ${slots.message}');
      }
      return slots.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch venue slots: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // @override
  // Future<List<SlotDTO>> getVenueSlotsRange({
  //   required String venueId,
  //   required DateTime startDate,
  //   required DateTime endDate,
  // }) async {
  //   try {
  //     final formattedStartDate = _formatDate(startDate);
  //     final formattedEndDate = _formatDate(endDate);

  //     final response = await _dio.get(
  //       '/slot/venues/$venueId/slots',
  //       queryParameters: {
  //         'startDate': formattedStartDate,
  //         'endDate': formattedEndDate,
  //       },
  //     );

  //     final slots = ApiResponse<List<SlotDTO>>.fromJson(response.data);

  //     if (slots.success == false) {
  //       throw Exception('Failed to load venue slots: ${slots.message}');
  //     }
  //     return slots.data;
  //   } on DioException catch (e) {
  //     throw Exception('Failed to fetch venue slots: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Failed to fetch venue slots range: $e');
  //   }
  // }

  /// Format DateTime to yyyy-MM-dd string
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
