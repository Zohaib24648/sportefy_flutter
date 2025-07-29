import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/venue_details_dto.dart';
import 'package:sportefy/data/model/venue_list_response_dto.dart';
import 'package:sportefy/data/repository/i_venue_repository.dart';
import '../model/common/api_response_dto.dart';

/// Repository implementation for venue operations
@LazySingleton(as: IVenueRepository)
class VenueRepository implements IVenueRepository {
  final Dio _dio;

  VenueRepository(this._dio);

  @override
  Future<VenueListResponseDTO> getVenuesPaginated({
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get('/venues', queryParameters: queryParams);

      return VenueListResponseDTO.fromJson(
        response.data as Map<String, dynamic>,
      );
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
