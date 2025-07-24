import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/venue_base.dart';
import 'package:sportefy/data/repository/i_venue_repository.dart';

/// Repository implementation for venue operations
@LazySingleton(as: IVenueRepository)
class VenueRepository implements IVenueRepository {
  final Dio _dio;

  VenueRepository(this._dio);

  @override
  Future<List<VenueBase>> getVenues() async {
    try {
      final response = await _dio.get('/venues');
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> data = responseData['data'];
      return data.map((json) => VenueBase.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch venues: $e');
    }
  }
}
