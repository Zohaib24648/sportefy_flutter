import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

@singleton
class SecureStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _sessionExpiryKey = 'session_expiry';
  static const String _userDataKey = 'user_data';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Token methods
  Future<void> storeAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // User session methods
  Future<void> storeUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  // User data methods
  Future<void> storeUserData(supabase.User user) async {
    final userData = jsonEncode({
      'id': user.id,
      'aud': user.aud,
      'role': user.role,
      'email': user.email,
      'email_confirmed_at': user.emailConfirmedAt,
      'phone': user.phone,
      'phone_confirmed_at': user.phoneConfirmedAt,
      'last_sign_in_at': user.lastSignInAt,
      'app_metadata': user.appMetadata,
      'user_metadata': user.userMetadata,
      'identities': user.identities
          ?.map(
            (identity) => {
              'identity_id': identity.identityId,
              'id': identity.id,
              'user_id': identity.userId,
              'identity_data': identity.identityData,
              'provider': identity.provider,
              'created_at': identity.createdAt,
              'last_sign_in_at': identity.lastSignInAt,
              'updated_at': identity.updatedAt,
            },
          )
          .toList(),
      'created_at': user.createdAt,
      'updated_at': user.updatedAt,
    });
    await _storage.write(key: _userDataKey, value: userData);
  }

  Future<supabase.User?> getUserData() async {
    final userDataString = await _storage.read(key: _userDataKey);
    if (userDataString == null) return null;

    try {
      final userData = jsonDecode(userDataString) as Map<String, dynamic>;

      // Convert identities back to UserIdentity objects
      final identities = (userData['identities'] as List<dynamic>?)
          ?.map(
            (identityData) => supabase.UserIdentity(
              identityId: identityData['identity_id'],
              id: identityData['id'],
              userId: identityData['user_id'],
              identityData: Map<String, dynamic>.from(
                identityData['identity_data'] ?? {},
              ),
              provider: identityData['provider'],
              createdAt: identityData['created_at'],
              lastSignInAt: identityData['last_sign_in_at'],
              updatedAt: identityData['updated_at'],
            ),
          )
          .toList();

      return supabase.User(
        id: userData['id'],
        aud: userData['aud'],
        role: userData['role'],
        email: userData['email'],
        emailConfirmedAt: userData['email_confirmed_at'],
        phone: userData['phone'],
        phoneConfirmedAt: userData['phone_confirmed_at'],
        lastSignInAt: userData['last_sign_in_at'],
        appMetadata: Map<String, dynamic>.from(userData['app_metadata'] ?? {}),
        userMetadata: Map<String, dynamic>.from(
          userData['user_metadata'] ?? {},
        ),
        identities: identities,
        createdAt: userData['created_at'],
        updatedAt: userData['updated_at'],
      );
    } catch (e) {
      // If parsing fails, return null
      return null;
    }
  }

  Future<void> storeSessionExpiry(DateTime expiry) async {
    await _storage.write(
      key: _sessionExpiryKey,
      value: expiry.toIso8601String(),
    );
  }

  Future<DateTime?> getSessionExpiry() async {
    final expiryString = await _storage.read(key: _sessionExpiryKey);
    if (expiryString != null) {
      return DateTime.parse(expiryString);
    }
    return null;
  }

  // Session validation
  Future<bool> isSessionValid() async {
    final expiry = await getSessionExpiry();
    if (expiry == null) return false;
    return DateTime.now().isBefore(
      expiry.subtract(const Duration(minutes: 5)),
    ); // 5 min buffer
  }

  // Clear all stored data
  Future<void> clearAll() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _sessionExpiryKey);
    await _storage.delete(key: _userDataKey);
  }

  // Store complete session data
  Future<void> storeSessionData({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required DateTime expiresAt,
    supabase.User? user,
  }) async {
    final futures = [
      storeAccessToken(accessToken),
      storeRefreshToken(refreshToken),
      storeUserId(userId),
      storeSessionExpiry(expiresAt),
    ];

    if (user != null) {
      futures.add(storeUserData(user));
    }

    await Future.wait(futures);
  }
}
