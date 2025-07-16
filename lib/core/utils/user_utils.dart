import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Utility class for working with user data
class UserUtils {
  /// Get user's display name from user metadata or email
  static String getDisplayName(supabase.User user) {
    // Try to get name from user metadata first
    final metadataName = user.userMetadata?['name'] as String?;
    if (metadataName != null && metadataName.isNotEmpty) {
      return metadataName;
    }

    // Try to get full_name from user metadata
    final fullName = user.userMetadata?['full_name'] as String?;
    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    // Fall back to email prefix
    if (user.email != null && user.email!.isNotEmpty) {
      return user.email!.split('@')[0];
    }

    // Last resort
    return 'User';
  }

  /// Get user's avatar URL from user metadata
  static String? getAvatarUrl(supabase.User user) {
    return user.userMetadata?['avatar_url'] as String?;
  }

  /// Get user's phone number
  static String? getPhoneNumber(supabase.User user) {
    return user.phone ?? user.userMetadata?['phone'] as String?;
  }

  /// Check if user's email is confirmed
  static bool isEmailConfirmed(supabase.User user) {
    return user.emailConfirmedAt != null;
  }

  /// Check if user's phone is confirmed
  static bool isPhoneConfirmed(supabase.User user) {
    return user.phoneConfirmedAt != null;
  }

  /// Get user's role from app metadata
  static String getUserRole(supabase.User user) {
    return user.appMetadata['role'] as String? ?? 'user';
  }

  /// Check if user has a specific role
  static bool hasRole(supabase.User user, String role) {
    return getUserRole(user) == role;
  }

  /// Get user's identity providers
  static List<String> getIdentityProviders(supabase.User user) {
    return user.identities?.map((identity) => identity.provider).toList() ?? [];
  }

  /// Check if user signed up with a specific provider
  static bool hasProvider(supabase.User user, String provider) {
    return getIdentityProviders(user).contains(provider);
  }

  /// Get user's first sign in time
  static DateTime? getFirstSignInTime(supabase.User user) {
    try {
      return DateTime.parse(user.createdAt);
    } catch (e) {
      return null;
    }
  }

  /// Get user's last sign in time
  static DateTime? getLastSignInTime(supabase.User user) {
    if (user.lastSignInAt != null) {
      try {
        return DateTime.parse(user.lastSignInAt!);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Format user info as a readable string
  static String formatUserInfo(supabase.User user) {
    final buffer = StringBuffer();
    buffer.writeln('User ID: ${user.id}');
    buffer.writeln('Email: ${user.email ?? 'N/A'}');
    buffer.writeln('Display Name: ${getDisplayName(user)}');
    buffer.writeln('Email Confirmed: ${isEmailConfirmed(user)}');
    buffer.writeln('Phone: ${getPhoneNumber(user) ?? 'N/A'}');
    buffer.writeln('Phone Confirmed: ${isPhoneConfirmed(user)}');
    buffer.writeln('Role: ${getUserRole(user)}');
    buffer.writeln('Providers: ${getIdentityProviders(user).join(', ')}');

    final firstSignIn = getFirstSignInTime(user);
    if (firstSignIn != null) {
      buffer.writeln('First Sign In: ${firstSignIn.toLocal()}');
    }

    final lastSignIn = getLastSignInTime(user);
    if (lastSignIn != null) {
      buffer.writeln('Last Sign In: ${lastSignIn.toLocal()}');
    }

    return buffer.toString();
  }
}
