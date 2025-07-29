import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Centralized logging utility for the application
class AppLogger {
  static const String _appTag = 'Sportefy';

  // Disable all logging in production
  static const bool _loggingEnabled = false;

  /// Log debug information
  static void debug(String message, {String? tag, Object? error}) {
    if (kDebugMode && _loggingEnabled) {
      developer.log(
        message,
        name: tag ?? _appTag,
        level: 500, // Debug level
        error: error,
      );
    }
  }

  /// Log informational messages
  static void info(String message, {String? tag}) {
    if (kDebugMode && _loggingEnabled) {
      developer.log(
        message,
        name: tag ?? _appTag,
        level: 800, // Info level
      );
    }
  }

  /// Log warning messages
  static void warning(String message, {String? tag, Object? error}) {
    if (kDebugMode && _loggingEnabled) {
      developer.log(
        message,
        name: tag ?? _appTag,
        level: 900, // Warning level
        error: error,
      );
    }
  }

  /// Log error messages
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode && _loggingEnabled) {
      developer.log(
        message,
        name: tag ?? _appTag,
        level: 1000, // Error level
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log network requests and responses
  static void network(String message, {String? tag}) {
    if (kDebugMode && _loggingEnabled) {
      developer.log(message, name: tag ?? '$_appTag-Network', level: 500);
    }
  }

  /// Log connectivity changes
  static void connectivity(String message, {String? tag}) {
    if (kDebugMode && _loggingEnabled) {
      developer.log(message, name: tag ?? '$_appTag-Connectivity', level: 800);
    }
  }
}
