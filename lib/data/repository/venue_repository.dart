import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/venue_base_dto.dart';
import 'package:sportefy/data/model/venue_details_dto.dart';
import 'package:sportefy/data/repository/i_venue_repository.dart';
import '../model/common/api_response_dto.dart';

/// Repository implementation for venue operations
@LazySingleton(as: IVenueRepository)
class VenueRepository implements IVenueRepository {
  final Dio _dio;

  VenueRepository(this._dio);

  @override
  Future<List<VenueDTO>> getVenues() async {
    try {
      final response = await _dio.get('/venues');
      final apiResponse = ApiResponseDTO<List<VenueDTO>>.fromJson(
        response.data,
        (dynamic data) => (data as List)
            .map((item) => VenueDTO.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
      return apiResponse.data;
    } catch (e) {
      throw Exception('Failed to fetch venues: $e');
    }
  }

  @override
  Future<VenueDetailsDTO> getVenueById(String id) async {
    try {
      final response = await _dio.get('/venues/$id');

      final apiResponse = ApiResponseDTO<VenueDetailsDTO>.fromJson(
        response.data,
        (dynamic data) =>
            VenueDetailsDTO.fromJson(data as Map<String, dynamic>),
      );
      return apiResponse.data;
    } catch (e) {
      throw Exception('Failed to fetch venue: $e');
    }
  }
}
