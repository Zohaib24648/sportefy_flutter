//lib/data/model/signup_request.dart
class SignupRequest {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool agreedToTerms;

  SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.agreedToTerms,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'agreedToTerms': agreedToTerms,
    };
  }
}