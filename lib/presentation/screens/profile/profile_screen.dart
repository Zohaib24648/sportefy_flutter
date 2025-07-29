import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sportefy/bloc/auth/auth_bloc.dart';
import 'package:sportefy/presentation/widgets/confirmation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../data/model/user_profile_dto.dart';
import '../../../core/utils/debug_utils.dart';
import '../../../core/auth/token_manager.dart';
import '../../../dependency_injection.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      // Validate session in debug mode
      if (kDebugMode) {
        await DebugUtils.reportAuthState();
        print(
          '[ProfileScreen] Ensuring valid session before loading profile...',
        );
      }

      // Ensure we have a valid session before making API calls
      final tokenManager = getIt<TokenManager>();
      final hasValidSession = await tokenManager.ensureValidSession();

      if (kDebugMode) {
        print('[ProfileScreen] Valid session available: $hasValidSession');
      }

      if (!hasValidSession) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Please log in again')));
          Navigator.of(context).pushReplacementNamed('/signin');
        }
        return;
      }

      if (mounted) {
        context.read<ProfileBloc>().add(LoadCurrentUserProfile());
      }
    } catch (e) {
      if (kDebugMode) {
        print('[ProfileScreen] Error initializing profile: $e');
      }
      if (mounted) {
        // Handle error - maybe show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.h4),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.popAndPushNamed(context, '/home'),
        ),
        toolbarHeight: 50,
      ),
      backgroundColor: AppColors.white,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  Gap(16),
                  _buildUserProfileSection(state),
                  Gap(16),
                  _buildSection(
                    title: 'Account Settings',
                    items: [
                      ProfileListItem(
                        icon: Icons.person_outline,
                        title: 'Personal Information',
                        onTap: () => _navigateToPage(context, '/personal-info'),
                      ),
                      ProfileListItem(
                        icon: Icons.lock_outline,
                        title: 'Password & Security',
                        onTap: () => _navigateToPage(context, '/security'),
                      ),
                      ProfileListItem(
                        icon: Icons.location_on_outlined,
                        title: 'Address Book',
                        onTap: () => _navigateToPage(context, '/address-book'),
                      ),
                      ProfileListItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notification',
                        trailing: Switch(
                          value: notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              notificationsEnabled = value;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  _buildSection(
                    title: 'Pricing',
                    items: [
                      ProfileListItem(
                        icon: Icons.card_membership_outlined,
                        title: 'Membership Plan',
                        onTap: () => _navigateToPage(context, '/membership'),
                      ),
                    ],
                  ),

                  _buildSection(
                    title: 'Preferences',
                    items: [
                      ProfileListItem(
                        icon: Icons.palette_outlined,
                        title: 'Theme',
                        onTap: () => _navigateToPage(context, '/theme'),
                      ),
                    ],
                  ),

                  _buildSection(
                    title: 'Resources',
                    items: [
                      ProfileListItem(
                        icon: Icons.info_outline,
                        title: 'About',
                        onTap: () => _navigateToPage(context, '/about'),
                      ),
                      ProfileListItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () => _openUrl('https://support.example.com'),
                      ),
                      ProfileListItem(
                        icon: Icons.feedback_outlined,
                        title: 'Share Feedback',
                        onTap: () => _openUrl('mailto:feedback@example.com'),
                      ),
                    ],
                  ),

                  _buildLogoutButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search what you need...',
                hintStyle: Theme.of(context).textTheme.bodySmall,
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.search, color: AppColors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection(ProfileState state) {
    if (state is ProfileLoading) {
      return SizedBox(
        height: 80,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    } else if (state is ProfileError) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 32),
              SizedBox(height: 8),
              Text(
                'Failed to load profile',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
              TextButton(
                onPressed: () =>
                    context.read<ProfileBloc>().add(LoadCurrentUserProfile()),
                child: Text('Retry', style: AppTextStyles.link),
              ),
            ],
          ),
        ),
      );
    } else if (state is ProfileLoaded) {
      return _buildUserProfile(state.profile);
    }

    return _buildUserProfile(null);
  }

  Widget _buildUserProfile(UserProfile? profile) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: AppColors.lightGrey,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: profile?.avatarUrl != null
                ? Image.network(
                    profile!.avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.lightGrey,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.grey,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.lightGrey,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    color: AppColors.lightGrey,
                    child: Icon(Icons.person, size: 40, color: AppColors.grey),
                  ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile?.fullName ?? 'Loading...',
                style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                profile?.email ?? 'Loading...',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<ProfileListItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h4),
        SizedBox(height: 16),
        ...items.map(
          (item) => Padding(padding: EdgeInsets.only(bottom: 15), child: item),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return PrimaryButton(
      text: 'Logout',
      onPressed: () => ConfirmationDialog.show(
        context: context,
        title: 'Logout',
        message: 'Are you sure you want to logout?',
        onConfirm: () {
          context.read<AuthBloc>().add(SignOutRequested());
        },
      ),
    );
  }

  void _navigateToPage(BuildContext context, String route) {
    // Navigate to the specified route
    Navigator.pushNamed(context, route);
  }

  void _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Handle error - show snackbar or dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open $url',
              style: AppTextStyles.body.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.lightGrey, width: 1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 3,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Icon(icon, size: 16, color: AppColors.dark),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ),
            trailing ??
                Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
