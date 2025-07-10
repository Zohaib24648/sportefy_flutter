import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'i_auth_repository.dart';

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final SupabaseClient _supabase;
  static const String _redirectUrl = 'io.supabase.sportefy://callback';

  AuthRepository() : _supabase = Supabase.instance.client;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: _redirectUrl,
      data: metadata,
    );
  }

  @override
  Future<void> signInWithOAuth(OAuthProvider provider) async {
    await _supabase.auth.signInWithOAuth(provider, redirectTo: _redirectUrl);
  }

  @override
  Future<void> signOut() async {
    // Debug: AuthRepository: Starting sign out...
    try {
      await _supabase.auth.signOut(scope: SignOutScope.global);
      // Debug: AuthRepository: Sign out completed successfully
    } catch (e) {
      // Debug: AuthRepository: Sign out failed: $e
      rethrow;
    }
  }

  @override
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  @override
  User? get currentUser => _supabase.auth.currentUser;
}
