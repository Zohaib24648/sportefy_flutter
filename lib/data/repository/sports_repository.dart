import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/common/api_response_dto.dart';
import '../model/sport_dto.dart';
import 'i_sports_repository.dart';

@LazySingleton(as: ISportsRepository)
class SportsRepository implements ISportsRepository {
  final Dio _dio;

  SportsRepository(this._dio);

  @override
  Future<List<SportDTO>> getSports() async {
    try {
      final response = await _dio.get('/sports');
      final sports = ApiResponseDTO<List<SportDTO>>.fromJson(
        response.data,
        (dynamic data) =>
            (data as List).map((item) => SportDTO.fromJson(item)).toList(),
      );
      if (sports.success == false) {
        throw Exception('Failed to load sports: ${sports.message}');
      }
      return sports.data;
    } on DioException catch (e) {
      throw Exception('Failed to load sports: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
