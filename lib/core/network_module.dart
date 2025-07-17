import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio() {
    return Dio(
      BaseOptions(
        baseUrl:
            dotenv.env['API_BASE_URL'] ??
            'https://sportefy-backend.onrender.com',
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }
}
