import 'dart:convert';
import 'package:crypto/crypto.dart';

class CryptoUtils {
  /// Generate MD5 hash of a string for Gravatar
  static String md5Hash(String input) {
    var bytes = utf8.encode(input.toLowerCase().trim());
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Generate Gravatar URL for an email
  static String generateGravatarUrl(
    String email, {
    int size = 400,
    String defaultImage = 'robohash',
  }) {
    final hash = md5Hash(email);
    return 'https://gravatar.com/avatar/$hash?s=$size&d=$defaultImage&r=x';
  }
}
