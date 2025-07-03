import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthRepository {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  });

  Future<void> signInWithOAuth(OAuthProvider provider);

  Future<void> signOut();

  Stream<AuthState> get authStateChanges;

  User? get currentUser;
}
