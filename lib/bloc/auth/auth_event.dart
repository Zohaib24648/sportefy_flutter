//lib/bloc/auth/auth_event.dart
import 'package:equatable/equatable.dart';
import 'package:sportefy/data/model/Signin_request.dart';
import '../../data/model/signup_request.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthEvent {
  final SignupRequest signupRequest;

  const SignUpRequested({required this.signupRequest});

  @override
  List<Object?> get props => [signupRequest];
}

class OAuthSignInRequested extends AuthEvent {
  final OAuthProvider provider;

  const OAuthSignInRequested({required this.provider});

  @override
  List<Object?> get props => [provider];
}

class SignInRequested extends AuthEvent {
  final SignInRequest signInRequest;

  const SignInRequested({required this.signInRequest});

  @override
  List<Object?> get props => [signInRequest];
}

enum OAuthProvider { apple, google, facebook }
