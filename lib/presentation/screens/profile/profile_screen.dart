import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../dependency_injection.dart';
import '../../constants/app_colors.dart';
import '../../widgets/simple_profile_image.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>(),
      child: const ProfileScreenContent(),
    );
  }
}

class ProfileScreenContent extends StatefulWidget {
  const ProfileScreenContent({super.key});

  @override
  State<ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends State<ProfileScreenContent> {
  @override
  void initState() {
    super.initState();
    // Load user profile when screen initializes
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<ProfileBloc>().add(LoadUserProfile(authState.user.id));
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primaryColor,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // Debug: Logout button pressed
                  context.read<AuthBloc>().add(SignOutRequested());
                },
              );
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Signing out...'),
                  ],
                ),
              );
            } else if (authState is Authenticated) {
              return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
                  if (profileState is ProfileLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading profile...'),
                        ],
                      ),
                    );
                  } else if (profileState is ProfileLoaded) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          SimpleProfileImage(
                            avatarUrl: profileState.profile.avatarUrl,
                            radius: 60,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              // Capture references before async operation
                              final authBloc = context.read<AuthBloc>();
                              final profileBloc = context.read<ProfileBloc>();

                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileEditScreen(
                                    initialProfile: profileState.profile,
                                  ),
                                ),
                              );

                              // Only reload if the screen is still mounted
                              if (mounted) {
                                // Reload profile when returning from edit screen
                                final authState = authBloc.state;
                                if (authState is Authenticated) {
                                  profileBloc.add(
                                    LoadUserProfile(authState.user.id),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Profile'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildInfoRow(
                                    Icons.person,
                                    'Name',
                                    profileState.profile.fullName,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow(
                                    Icons.email,
                                    'Email',
                                    profileState.profile.email,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow(
                                    Icons.fingerprint,
                                    'User ID',
                                    profileState.profile.id,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.settings),
                                  title: const Text('Settings'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {},
                                ),
                                const Divider(height: 1),
                                ListTile(
                                  leading: const Icon(Icons.help),
                                  title: const Text('Help & Support'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {},
                                ),
                                const Divider(height: 1),
                                ListTile(
                                  leading: const Icon(Icons.info),
                                  title: const Text('About'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (profileState is ProfileError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load profile',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profileState.error,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProfileBloc>().add(
                                LoadUserProfile(authState.user.id),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
