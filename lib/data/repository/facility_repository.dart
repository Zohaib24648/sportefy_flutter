import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/facility_base.dart';
import 'package:sportefy/data/repository/i_facility_repository.dart';

/// Simple repository implementation for facility operations
@LazySingleton(as: IFacilityRepository)
class FacilityRepository implements IFacilityRepository {
  final Dio _dio;

  FacilityRepository(this._dio);

  @override
  Future<List<FacilityBase>> getFacilities() async {
    try {
      final response = await _dio.get('/facilities');
      final List<dynamic> data = response.data;
      return data.map((json) => FacilityBase.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch facilities: $e');
    }
  }

  @override
  Future<FacilityBase> getFacilityById(String id) async {
    try {
      final response = await _dio.get('/facilities/$id');
      return FacilityBase.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch facility: $e');
    }
  }

  @override
  Future<FacilityBase> createFacility(FacilityBase facility) async {
    try {
      final response = await _dio.post('/facilities', data: facility.toJson());
      return FacilityBase.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create facility: $e');
    }
  }

  @override
  Future<FacilityBase> updateFacility(String id, FacilityBase facility) async {
    try {
      final response = await _dio.put('/facilities/$id', data: facility.toJson());
      return FacilityBase.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update facility: $e');
    }
  }

  @override
  Future<void> deleteFacility(String id) async {
    try {
      await _dio.delete('/facilities/$id');
    } catch (e) {
      throw Exception('Failed to delete facility: $e');
    }
  }
}
