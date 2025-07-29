import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sportefy/bloc/auth/auth_bloc.dart';
import 'package:sportefy/presentation/widgets/confirmation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../data/model/user_profile_dto.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/shimmer_exports.dart';
import '../../widgets/profile/notification_toggle.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Profile should already be loaded globally - no need to load again
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
                        trailing: const NotificationToggle(),
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
      return AppShimmer(
        child: Row(
          children: [
            const ShimmerCircle(size: 80),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerText(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 24,
                  ),
                  const SizedBox(height: 8),
                  ShimmerText(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
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
                onPressed: () {
                  // Profile is managed globally - show app-level retry message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Profile is managed globally. Try refreshing the app.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                child: Text('Info', style: AppTextStyles.link),
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
                ? CachedNetworkImage(
                    imageUrl: profile!.avatarUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.lightGrey,
                      child: AppShimmer(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      if (kDebugMode) {
                        print('Profile image load error: $error');
                        print('Failed URL: $url');
                      }
                      return Container(
                        color: AppColors.lightGrey,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.grey,
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
