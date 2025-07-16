import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../bloc/auth/auth_bloc.dart';
import '../../data/services/auth_state_manager.dart';
import '../../core/utils/user_utils.dart';

/// Example widget showing how to use the stored user data
class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return _buildUserProfile(context, state.user);
        } else {
          return const Center(child: Text('User not authenticated'));
        }
      },
    );
  }

  Widget _buildUserProfile(BuildContext context, supabase.User user) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: UserUtils.getAvatarUrl(user) != null
                      ? NetworkImage(UserUtils.getAvatarUrl(user)!)
                      : null,
                  child: UserUtils.getAvatarUrl(user) == null
                      ? Text(UserUtils.getDisplayName(user)[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UserUtils.getDisplayName(user),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        user.email ?? 'No email',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Role', UserUtils.getUserRole(user)),
            _buildInfoRow('User ID', user.id),
            _buildInfoRow(
              'Email Confirmed',
              UserUtils.isEmailConfirmed(user) ? 'Yes' : 'No',
            ),
            if (UserUtils.getPhoneNumber(user) != null)
              _buildInfoRow('Phone', UserUtils.getPhoneNumber(user)!),
            _buildInfoRow(
              'Phone Confirmed',
              UserUtils.isPhoneConfirmed(user) ? 'Yes' : 'No',
            ),
            _buildInfoRow(
              'Identity Providers',
              UserUtils.getIdentityProviders(user).join(', '),
            ),
            if (UserUtils.getFirstSignInTime(user) != null)
              _buildInfoRow(
                'Member Since',
                UserUtils.getFirstSignInTime(user)!.toLocal().toString(),
              ),
            if (UserUtils.getLastSignInTime(user) != null)
              _buildInfoRow(
                'Last Sign In',
                UserUtils.getLastSignInTime(user)!.toLocal().toString(),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showStoredUserData(context),
              child: const Text('Show Stored User Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showStoredUserData(BuildContext context) async {
    final authStateManager = context.read<AuthStateManager>();
    final storedUser = await authStateManager.storedUser;

    if (!context.mounted) return;

    if (storedUser != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Stored User Data'),
            content: SingleChildScrollView(
              child: Text(UserUtils.formatUserInfo(storedUser)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No stored user data available')),
      );
    }
  }
}

/// Example of how to use stored user data in a service
class UserDataService {
  final AuthStateManager _authStateManager;

  UserDataService(this._authStateManager);

  /// Get current user information
  Future<supabase.User?> getCurrentUser() async {
    // Try to get the current user from auth state first
    final currentUser = _authStateManager.currentUser;
    if (currentUser != null) {
      return currentUser;
    }

    // If no current user (e.g., offline), try to get stored user
    return await _authStateManager.storedUser;
  }

  /// Get user display name with fallback to stored data
  Future<String> getUserDisplayName() async {
    final user = await getCurrentUser();
    if (user != null) {
      return UserUtils.getDisplayName(user);
    }
    return 'Unknown User';
  }

  /// Check if user has a specific role
  Future<bool> userHasRole(String role) async {
    final user = await getCurrentUser();
    if (user != null) {
      return UserUtils.hasRole(user, role);
    }
    return false;
  }

  /// Get comprehensive user info for analytics or logging
  Future<Map<String, dynamic>> getUserAnalyticsData() async {
    final user = await getCurrentUser();
    if (user == null) return {};

    return {
      'user_id': user.id,
      'email': user.email,
      'email_confirmed': UserUtils.isEmailConfirmed(user),
      'phone_confirmed': UserUtils.isPhoneConfirmed(user),
      'role': UserUtils.getUserRole(user),
      'providers': UserUtils.getIdentityProviders(user),
      'first_sign_in': UserUtils.getFirstSignInTime(user)?.toIso8601String(),
      'last_sign_in': UserUtils.getLastSignInTime(user)?.toIso8601String(),
    };
  }
}
