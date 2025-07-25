part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final SignInRequest signInRequest;

  SignInRequested({required this.signInRequest});
}

class SignUpRequested extends AuthEvent {
  final SignUpRequest signUpRequest;

  SignUpRequested({required this.signUpRequest});
}

enum OAuthProviderTypes { apple, google, facebook }

class OAuthSignInRequested extends AuthEvent {
  final supabase.OAuthProvider provider;

  OAuthSignInRequested({required this.provider});
}

class SignOutRequested extends AuthEvent {
  SignOutRequested();
}

class SupabaseAuthStateChanged extends AuthEvent {
  final supabase.AuthState supabaseAuthState;

  SupabaseAuthStateChanged(this.supabaseAuthState);
}
