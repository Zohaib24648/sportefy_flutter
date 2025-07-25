import 'package:injectable/injectable.dart';
import '../../data/repository/i_auth_repository.dart';

/// Centralized token management utility
@injectable
class TokenManager {
  final IAuthRepository _authRepository;
  TokenManager(this._authRepository);

  /// Returns the current access token from the authentication repository
  Future<String?> getAccessToken() async {
    return _authRepository.accessToken;
  }

  /// Ensure the session is valid, refreshing if expired
  Future<bool> ensureValidSession() async {
    final session = _authRepository.currentSession;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (session != null && (session.expiresAt ?? 0) > now) {
      return true;
    }
    await _authRepository.refreshSession();
    final refreshed = _authRepository.currentSession;
    return refreshed != null && (refreshed.expiresAt ?? 0) > now;
  }

  /// Clear all authentication data
  /// Clears session by signing out
  Future<void> clearSession() async {
    await _authRepository.signOut();
  }

  /// Get the signed-in user's ID
  String? get userId => _authRepository.currentUser?.id;

  /// Check if user is authenticated
  bool get isAuthenticated => _authRepository.currentUser != null;
}
