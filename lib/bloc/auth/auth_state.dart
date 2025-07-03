part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String? message;

  AuthSuccess({this.message});
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

class Authenticated extends AuthState {
  final supabase.User user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}
