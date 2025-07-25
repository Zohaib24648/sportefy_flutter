import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import '../auth/token_manager.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;

  AuthInterceptor(this._tokenManager);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      if (kDebugMode) {
        print(
          '[AuthInterceptor] Skipping auth for public endpoint: ${options.path}',
        );
      }
      super.onRequest(options, handler);
      return;
    }

    if (kDebugMode) {
      print('[AuthInterceptor] Processing request to: ${options.path}');
    }

    // Ensure session is valid before making request
    await _tokenManager.ensureValidSession();

    // Get the access token
    final accessToken = await _tokenManager.getAccessToken();

    if (kDebugMode) {
      print(
        '[AuthInterceptor] Token found: ${accessToken != null && accessToken.isNotEmpty}',
      );
      if (accessToken != null && accessToken.length > 20) {
        print(
          '[AuthInterceptor] Token preview: ${accessToken.substring(0, 20)}...',
        );
      }
    }

    if (accessToken != null && accessToken.isNotEmpty) {
      // Add the Bearer token to the Authorization header
      options.headers['Authorization'] = 'Bearer $accessToken';
      if (kDebugMode) {
        print('[AuthInterceptor] Authorization header added');
      }
    } else {
      if (kDebugMode) {
        print(
          '[AuthInterceptor] WARNING: No access token available for protected endpoint!',
        );
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print(
        '[AuthInterceptor] Error occurred: ${err.response?.statusCode} - ${err.message}',
      );
    }

    // Handle 401 unauthorized errors
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        print('[AuthInterceptor] 401 Unauthorized - attempting token refresh');
      }

      // Token is expired or invalid, try to refresh it
      final refreshSuccess = await _tokenManager.ensureValidSession();

      if (kDebugMode) {
        print('[AuthInterceptor] Token refresh success: $refreshSuccess');
      }

      if (refreshSuccess) {
        // Retry the original request with new token
        final newToken = await _tokenManager.getAccessToken();
        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

          if (kDebugMode) {
            print('[AuthInterceptor] Retrying request with new token');
          }

          try {
            final response = await _retryRequest(err.requestOptions);
            handler.resolve(response);
            return;
          } catch (retryError) {
            if (kDebugMode) {
              print('[AuthInterceptor] Retry failed: $retryError');
            }
            // If retry fails, proceed with original error
          }
        }
      }

      // If refresh failed or retry failed, clear tokens and proceed with error
      if (kDebugMode) {
        print('[AuthInterceptor] Clearing session due to auth failure');
      }
      await _tokenManager.clearSession();
    }

    super.onError(err, handler);
  }

  /// Check if the endpoint is public and doesn't require authentication
  bool _isPublicEndpoint(String path) {
    const publicPaths = [
      '/auth/signin',
      '/auth/signup',
      '/auth/refresh',
      '/health',
      '/public',
    ];

    return publicPaths.any((publicPath) => path.startsWith(publicPath));
  }

  /// Retry the original request with new authentication
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final dio = Dio();
    return await dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
        contentType: requestOptions.contentType,
        responseType: requestOptions.responseType,
        followRedirects: requestOptions.followRedirects,
        maxRedirects: requestOptions.maxRedirects,
        receiveTimeout: requestOptions.receiveTimeout,
        sendTimeout: requestOptions.sendTimeout,
      ),
    );
  }
}
