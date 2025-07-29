import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../model/sport_dto.dart';
import 'i_sports_repository.dart';

@LazySingleton(as: ISportsRepository)
class SportsRepository implements ISportsRepository {
  final Dio _dio;

  SportsRepository(this._dio);

  @override
  Future<List<Sport>> getSports() async {
    try {
      final response = await _dio.get('/sports');
      final apiResponse = SportsApiResponse.fromJson(response.data);
      return apiResponse.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch sports: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred while fetching sports');
    }
  }
}
