import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../data/services/secure_storage_service.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get the access token from secure storage
    final accessToken = await _secureStorage.getAccessToken();

    if (accessToken != null) {
      // Add the Bearer token to the Authorization header
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 unauthorized errors
    if (err.response?.statusCode == 401) {
      // Token might be expired, try to refresh it
      final refreshToken = await _secureStorage.getRefreshToken();

      if (refreshToken != null) {
        // You can implement token refresh logic here
        // For now, we'll just clear the stored tokens
        await _secureStorage.clearAll();
      }
    }

    super.onError(err, handler);
  }
}
