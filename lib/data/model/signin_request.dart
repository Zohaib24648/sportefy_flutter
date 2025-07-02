//lib/data/model/signin_request.dart
class SignInRequest {
  final String email;
  final String password;
  final bool rememberMe;

  SignInRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'rememberMe': rememberMe};
  }
}
