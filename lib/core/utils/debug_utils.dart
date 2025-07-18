import 'package:flutter/foundation.dart';
import '../../data/services/secure_storage_service.dart';
import '../../dependency_injection.dart';

class DebugUtils {
  static Future<void> storeTestToken() async {
    if (!kDebugMode) return;

    final secureStorage = getIt<SecureStorageService>();

    try {
      // Check if token already exists
      final existingToken = await secureStorage.getAccessToken();
      if (existingToken != null && existingToken.isNotEmpty) {
        if (kDebugMode) {
          print('Debug: Token already exists, skipping storage');
        }
        return;
      }

      // Store the test token you provided
      const testToken =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE3NTI3NTAxNzEsImV4cCI6MTc4NDI5MDI2NSwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoiODc5MjI4NmQtZjA0NC00YWY3LWE5YjctMzhjYWE0YTJlMjgyIn0.bBNmcGvG-UVnLYmpV2Q1iMDszq5x0qBYYWEMEyMrROY';

      await secureStorage.storeAccessToken(testToken);

      if (kDebugMode) {
        print('Debug: Test token stored successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Debug: Error storing test token: $e');
      }
    }
  }

  static Future<void> clearTokens() async {
    if (!kDebugMode) return;

    final secureStorage = getIt<SecureStorageService>();
    await secureStorage.clearAll();

    if (kDebugMode) {
      print('Debug: All tokens cleared');
    }
  }

  static Future<void> printStoredToken() async {
    if (!kDebugMode) return;

    final secureStorage = getIt<SecureStorageService>();
    final token = await secureStorage.getAccessToken();

    if (kDebugMode) {
      print('Debug: Stored token: ${token?.substring(0, 50)}...');
    }
  }
}
