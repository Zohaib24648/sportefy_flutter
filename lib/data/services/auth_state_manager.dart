import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sportefy/data/repository/i_auth_repository.dart';
import 'package:sportefy/data/services/secure_storage_service.dart';

@singleton
class AuthStateManager {
  final IAuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  AuthStateManager(this._authRepository, this._secureStorage) {
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    // Listen to auth state changes and update secure storage accordingly
    _authRepository.authStateChanges.listen((AuthState state) async {
      final event = state.event;
      final session = state.session;

      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session != null) {
            await _storeSessionData(session);
          }
          break;
        case AuthChangeEvent.signedOut:
          await _secureStorage.clearAll();
          break;
        case AuthChangeEvent.tokenRefreshed:
          if (session != null) {
            await _storeSessionData(session);
          }
          break;
        default:
          break;
      }
    });
  }

  Future<void> _storeSessionData(Session session) async {
    await _secureStorage.storeSessionData(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
      userId: session.user.id,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000),
      user: session.user,
    );
  }

  // Convenience methods for checking auth state
  bool get isAuthenticated => _authRepository.currentUser != null;

  User? get currentUser => _authRepository.currentUser;

  Future<User?> get storedUser async => await _authRepository.getStoredUser();

  Session? get currentSession => _authRepository.currentSession;

  String? get userId => _authRepository.currentUser?.id;

  String? get userEmail => _authRepository.currentUser?.email;

  String? get userName => _authRepository.currentUser?.userMetadata?['name'];

  String? get userAvatarUrl =>
      _authRepository.currentUser?.userMetadata?['avatar_url'];

  // Expose auth state changes stream
  Stream<AuthState> get authStateChanges => _authRepository.authStateChanges;

  Future<bool> get hasValidSession async {
    return await _authRepository.isSessionValid();
  }

  // Auto-refresh session if needed
  Future<void> ensureValidSession() async {
    final isValid = await _authRepository.isSessionValid();
    if (!isValid && _authRepository.currentSession != null) {
      await _authRepository.refreshSession();
    }
  }
}
