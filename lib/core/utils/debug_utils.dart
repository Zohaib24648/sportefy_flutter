import 'package:flutter/foundation.dart';
import '../auth/token_manager.dart';
import '../../dependency_injection.dart';

class DebugUtils {
  /// Reports concise authentication state in debug mode
  static Future<void> reportAuthState() async {
    if (!kDebugMode) return;
    final tm = getIt<TokenManager>();
    final auth = tm.isAuthenticated;
    final valid = await tm.ensureValidSession();
    final token = await tm.getAccessToken();
    final userId = tm.userId;
    print(
      'AuthState -> authenticated: $auth, validSession: $valid, '
      'userId: ${userId ?? 'none'}, tokenExists: ${token != null}',
    );
    if (token != null && token.length > 20) {
      print('Token preview: ${token.substring(0, 20)}...');
    }
  }

  /// Clears authentication session
  static Future<void> clearSession() async {
    if (!kDebugMode) return;
    await getIt<TokenManager>().clearSession();
    print('Debug: Session cleared');
  }
}
