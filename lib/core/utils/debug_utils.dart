import 'package:flutter/foundation.dart';
import '../auth/token_manager.dart';
import '../../dependency_injection.dart';
import 'app_logger.dart';

class DebugUtils {
  /// Reports concise authentication state in debug mode
  static Future<void> reportAuthState() async {
    if (!kDebugMode) return;
    final tm = getIt<TokenManager>();
    final auth = tm.isAuthenticated;
    final valid = await tm.ensureValidSession();
    final token = await tm.getAccessToken();
    final userId = tm.userId;
    AppLogger.debug(
      'AuthState -> authenticated: $auth, validSession: $valid, '
      'userId: ${userId ?? 'none'}, tokenExists: ${token != null}',
      tag: 'Auth',
    );
    if (token != null && token.length > 20) {
      AppLogger.debug(
        'Token preview: ${token.substring(0, 20)}...',
        tag: 'Auth',
      );
    }
  }

  /// Clears authentication session
  static Future<void> clearSession() async {
    if (!kDebugMode) return;
    await getIt<TokenManager>().clearSession();
    AppLogger.debug('Session cleared', tag: 'Auth');
  }
}
