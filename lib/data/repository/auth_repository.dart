import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sportefy/data/model/signin_request.dart';
import 'package:sportefy/data/model/signup_request.dart';
import 'i_auth_repository.dart';

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final SupabaseClient _supabase;
  static const String _redirectUrl = 'io.supabase.sportefy://callback';

  AuthRepository() : _supabase = Supabase.instance.client;

  @override
  Future<AuthResponse> signInWithEmailAndPassword({
    required SignInRequest request,
  }) => _supabase.auth.signInWithPassword(
    email: request.email,
    password: request.password,
  );

  @override
  Future<AuthResponse> signUpWithEmailAndPassword({
    required SignUpRequest request,
  }) {
    try {
      return _supabase.auth.signUp(
        email: request.email,
        password: request.password,
        data: {'name': request.name},
      );
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('already registered') ||
          msg.contains('already exists')) {
        throw AuthException(
          'An account with this email already exists. Please try signing in instead.',
        );
      }
      rethrow;
    }
  }

  @override
  Future<AuthResponse> signInWithOAuth(OAuthProvider provider) {
    _supabase.auth.signInWithOAuth(provider, redirectTo: _redirectUrl);
    return Future.value(
      AuthResponse(
        session: _supabase.auth.currentSession,
        user: _supabase.auth.currentUser,
      ),
    );
  }

  @override
  Future<void> signOut() => _supabase.auth.signOut(scope: SignOutScope.global);

  @override
  Future<void> refreshSession() => _supabase.auth.refreshSession();

  @override
  Future<bool> isSessionValid() {
    final session = _supabase.auth.currentSession;
    if (session == null) return Future.value(false);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return Future.value((session.expiresAt ?? 0) > now);
  }

  @override
  Future<bool> checkUserExists(String email) async {
    try {
      final res = await _supabase.auth.signUp(
        email: email,
        password: 'dummy_password',
      );
      final exists = res.user != null && res.user!.identities!.isEmpty;
      if (res.session != null) await _supabase.auth.signOut();
      return exists;
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      return msg.contains('already registered') ||
          msg.contains('already exists');
    }
  }

  @override
  Future<User?> getStoredUser() => Future.value(_supabase.auth.currentUser);

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
}
