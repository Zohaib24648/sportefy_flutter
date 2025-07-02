//data/repository/auth_repository.dart
import 'dart:async';

import 'package:sportefy/data/model/Signin_request.dart';

import '../../bloc/auth/auth_event.dart';
import '../model/signup_request.dart';
import '../model/user.dart';

class AuthRepository {
  // Simulate API call
  Future<User> signUp(SignupRequest request) async {
    await Future.delayed(const Duration(seconds: 2));

    // Validation
    if (request.name.isEmpty) {
      throw Exception('Name is required');
    }
    if (request.email.isEmpty) {
      throw Exception('Email is required');
    }
    if (request.password.isEmpty) {
      throw Exception('Password is required');
    }
    if (request.password != request.confirmPassword) {
      throw Exception('Passwords do not match');
    }
    if (!request.agreedToTerms) {
      throw Exception('You must agree to the terms');
    }

    // Simulate successful signup
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: request.name,
      email: request.email,
      createdAt: DateTime.now(),
    );
  }

  Future<User> signInWithOAuth(OAuthProvider provider) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate OAuth sign in
    switch (provider) {
      case OAuthProvider.apple:
        return User(
          id: 'apple_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Apple User',
          email: 'apple@example.com',
          createdAt: DateTime.now(),
        );
      case OAuthProvider.google:
        return User(
          id: 'google_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Google User',
          email: 'google@example.com',
          createdAt: DateTime.now(),
        );
      case OAuthProvider.facebook:
        return User(
          id: 'fb_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Facebook User',
          email: 'facebook@example.com',
          createdAt: DateTime.now(),
        );
    }
  }

  Future<User> signIn(SignInRequest request) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful sign in
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'User',
      email: request.email,
      createdAt: DateTime.now(),
    );
  }
}
