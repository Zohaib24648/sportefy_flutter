import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../data/model/signin_request.dart';
import '../../data/model/signup_request.dart';
import '../../data/repository/i_auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;
  StreamSubscription<supabase.AuthState>? _authStateSubscription;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<OAuthSignInRequested>(_onOAuthSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<SupabaseAuthStateChanged>(_onSupabaseAuthStateChanged);

    _startAuthSubscription();
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: event.signInRequest.email,
        password: event.signInRequest.password,
      );
      // Auth state change will handle the authenticated state
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUpWithEmailAndPassword(
        email: event.signupRequest.email,
        password: event.signupRequest.password,
        metadata: {'name': event.signupRequest.name},
      );
      emit(
        AuthSuccess(
          message:
              'Sign up successful! Please check your email to verify your account.',
        ),
      );
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
      emit(Unauthenticated());
    }
  }

  Future<void> _onOAuthSignInRequested(
    OAuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithOAuth(event.provider);
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('Sign out requested');
    emit(AuthLoading());
    try {
      print('Calling repository signOut...');
      await _authRepository.signOut();
      print('Repository signOut completed');

      // Let the Supabase auth state change handler manage the state
      // The _onSupabaseAuthStateChanged will emit Unauthenticated when signedOut event is received
    } catch (e) {
      print('Sign out error: $e');
      emit(AuthError(_getErrorMessage(e)));
      // Emit Unauthenticated as fallback if signOut fails
      emit(Unauthenticated());
    }
  }

  Future<void> _onSupabaseAuthStateChanged(
    SupabaseAuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    final authEvent = event.supabaseAuthState.event;
    final user = event.supabaseAuthState.session?.user;

    // Add debug logging
    print('Auth state changed: $authEvent, user: ${user?.email}');

    switch (authEvent) {
      case supabase.AuthChangeEvent.signedIn:
        if (user != null) {
          emit(Authenticated(user));
        }
        break;
      case supabase.AuthChangeEvent.signedOut:
        emit(Unauthenticated());
        break;
      case supabase.AuthChangeEvent.tokenRefreshed:
        if (user != null) {
          emit(Authenticated(user));
        }
        break;
      case supabase.AuthChangeEvent.userUpdated:
        if (user != null) {
          emit(Authenticated(user));
        }
        break;
      default:
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
    }
  }

  void _startAuthSubscription() {
    print('Starting auth state subscription...');
    _authStateSubscription = _authRepository.authStateChanges.listen((
      supabaseAuthState,
    ) {
      print('Auth state subscription received: ${supabaseAuthState.event}');
      add(SupabaseAuthStateChanged(supabaseAuthState));
    });
  }

  String _getErrorMessage(dynamic error) {
    if (error is supabase.AuthException) {
      return error.message;
    }
    return 'An unexpected error occurred';
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
