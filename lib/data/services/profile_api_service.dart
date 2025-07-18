import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../model/user_profile.dart';

@injectable
class ProfileApiService {
  final Dio _dio;

  ProfileApiService(this._dio);

  Future<UserProfile> getMyProfile() async {
    try {
      final response = await _dio.get('/profile/me');
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _dio.put('/profile', data: profileData);
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'An error occurred';
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.unknown:
        return Exception(
          'Network error. Please check your internet connection.',
        );
      default:
        return Exception('An unexpected error occurred: ${e.message}');
    }
  }
}
