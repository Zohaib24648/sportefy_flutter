import 'package:sportefy/data/model/signin_request.dart';
import 'package:sportefy/data/model/signup_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthRepository {
  Future<AuthResponse> signInWithEmailAndPassword({
    required SignInRequest request,
  });

  Future<AuthResponse> signUpWithEmailAndPassword({
    required SignUpRequest request,
  });

  Future<AuthResponse> signInWithOAuth(OAuthProvider provider);

  Future<void> signOut();

  Future<void> refreshSession();

  Future<bool> isSessionValid();

  Future<bool> checkUserExists(String email);

  Future<User?> getStoredUser();

  Stream<AuthState> get authStateChanges;

  User? get currentUser;

  Session? get currentSession;

  String? get accessToken;

  String? get refreshToken;
}
