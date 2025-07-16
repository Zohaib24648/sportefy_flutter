import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sportefy/data/model/signin_request.dart';
import 'package:sportefy/data/model/signup_request.dart';
import 'package:sportefy/data/services/secure_storage_service.dart';

import 'i_auth_repository.dart';

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final SupabaseClient _supabase;
  final SecureStorageService _secureStorage;
  static const String _redirectUrl = 'io.supabase.sportefy://callback';

  AuthRepository(this._secureStorage) : _supabase = Supabase.instance.client;

  @override
  Future<AuthResponse> signInWithEmailAndPassword({
    required SignInRequest request,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: request.email,
      password: request.password,
    );

    if (response.session != null) {
      await _storeSessionData(response.session!);
    }

    return response;
  }

  @override
  Future<AuthResponse> signUpWithEmailAndPassword({
    required SignUpRequest request,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: request.email,
        password: request.password,
        data: {'name': request.name},
      );

      // Check if user already exists by examining identities
      if (response.user != null && response.user!.identities!.isEmpty) {
        throw AuthException(
          'An account with this email already exists. Please try signing in instead.',
        );
      }

      if (response.user != null && response.session == null) {
        return response;
      } else if (response.user != null && response.session != null) {
        await _storeSessionData(response.session!);
        return response;
      } else if (response.user == null) {
        throw AuthException('Unable to create account. Please try again.');
      }

      return response;
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('already registered') ||
          e.message.toLowerCase().contains('already exists') ||
          e.message.toLowerCase().contains('user already registered')) {
        throw AuthException(
          'An account with this email already exists. Please try signing in instead.',
        );
      }
      rethrow;
    }
  }

  @override
  Future<AuthResponse> signInWithOAuth(OAuthProvider provider) async {
    await _supabase.auth.signInWithOAuth(provider, redirectTo: _redirectUrl);
    return AuthResponse(session: currentSession, user: currentUser);
  }

  @override
  Future<void> signOut() async {
    try {
      await _secureStorage.clearAll();
      await _supabase.auth.signOut(scope: SignOutScope.global);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> refreshSession() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken != null) {
      final response = await _supabase.auth.refreshSession(refreshToken);
      if (response.session != null) {
        await _storeSessionData(response.session!);
      }
    }
  }

  @override
  Future<bool> isSessionValid() async {
    return await _secureStorage.isSessionValid();
  }

  @override
  Future<bool> checkUserExists(String email) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: 'dummy_password', // This won't be used if user exists
      );
      if (response.user != null && response.user!.identities!.isEmpty) {
        return true;
      }
      if (response.session != null) {
        await _supabase.auth.signOut();
      }

      return false;
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('already registered') ||
          e.message.toLowerCase().contains('already exists')) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User?> getStoredUser() async {
    return await _secureStorage.getUserData();
  }

  @override
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  @override
  User? get currentUser => _supabase.auth.currentUser;

  @override
  Session? get currentSession => _supabase.auth.currentSession;

  @override
  String? get accessToken => _supabase.auth.currentSession?.accessToken;

  @override
  String? get refreshToken => _supabase.auth.currentSession?.refreshToken;

  Future<void> _storeSessionData(Session session) async {
    await _secureStorage.storeSessionData(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
      userId: session.user.id,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000),
      user: session.user,
    );
  }
}
