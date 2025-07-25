import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/auth_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl:
            dotenv.env['API_BASE_URL'] ??
            'https://sportefy-backend.onrender.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Enable response validation
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Add the auth interceptor first (most important)
    dio.interceptors.add(authInterceptor);

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (object) => debugPrint('[DIO] $object'),
        ),
      );
    }

    return dio;
  }
}
