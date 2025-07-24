import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/venue_base.dart';
import 'package:sportefy/data/model/venue_details.dart';
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

  @override
  Future<VenueBase> getVenueById(String id) async {
    try {
      final response = await _dio.get('/venues/$id');
      final Map<String, dynamic> responseData = response.data;
      final Map<String, dynamic> data = responseData['data'];
      return VenueBase.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch venue: $e');
    }
  }

  @override
  Future<VenueDetails> getVenueDetails(String id) async {
    try {
      print('Fetching venue details for ID: $id');
      final response = await _dio.get('/venues/$id');
      print('Raw API response: ${response.data}');

      if (response.data == null) {
        throw Exception('API returned null response');
      }

      final Map<String, dynamic> responseData = response.data;
      if (!responseData.containsKey('data')) {
        throw Exception('API response missing data field');
      }

      final Map<String, dynamic> data = responseData['data'];
      if (data.isEmpty) {
        throw Exception('API returned empty data');
      }

      print('Processing venue data: ${data.keys.toList()}');
      final venueDetails = VenueDetails.fromJson(data);
      print('Successfully parsed venue details: ${venueDetails.name}');

      return venueDetails;
    } catch (e) {
      print('Error fetching venue details: $e');
      if (e.toString().contains(
        'type \'Null\' is not a subtype of type \'String\'',
      )) {
        throw Exception(
          'Failed to fetch venue details: Some required fields are missing from the API response',
        );
      }
      throw Exception('Failed to fetch venue details: $e');
    }
  }
}
