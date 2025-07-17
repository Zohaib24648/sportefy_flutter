import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../data/model/profile_update_request.dart';
import '../../../data/model/user_profile.dart';
import '../../../dependency_injection.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/shimmer_exports.dart';
import '../../widgets/custom_dropdown_field.dart';
import '../../widgets/common/primary_button.dart';
import '../../utils/responsive_helper.dart';

class ProfileEditScreen extends StatelessWidget {
  final UserProfile? initialProfile;

  const ProfileEditScreen({super.key, this.initialProfile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>(),
      child: ProfileEditScreenContent(initialProfile: initialProfile),
    );
  }
}

class ProfileEditScreenContent extends StatefulWidget {
  final UserProfile? initialProfile;

  const ProfileEditScreenContent({super.key, this.initialProfile});

  @override
  State<ProfileEditScreenContent> createState() =>
      _ProfileEditScreenContentState();
}

class _ProfileEditScreenContentState extends State<ProfileEditScreenContent> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _organizationController = TextEditingController();
  final _ageController = TextEditingController();

  String? _selectedGender;
  String? _avatarUrl;
  String? _userId;

  @override
  void initState() {
    super.initState();
    // Get user ID from auth state
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _userId = authState.user.id;
    }

    // Populate fields with initial profile data if provided
    if (widget.initialProfile != null) {
      _populateFields(widget.initialProfile!);
    } else if (_userId != null) {
      // Load profile if not provided
      context.read<ProfileBloc>().add(LoadUserProfile(_userId!));
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _organizationController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _populateFields(UserProfile profile) {
    _fullNameController.text = profile.fullName;
    _userNameController.text = profile.userName ?? '';
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber ?? '';
    _addressController.text = profile.address ?? '';
    _organizationController.text = profile.organization ?? '';
    _ageController.text = profile.age?.toString() ?? '';
    _selectedGender = profile.gender;
    _avatarUrl = profile.avatarUrl;
  }

  void _handleUpdateProfile() {
    if (_formKey.currentState!.validate() && _userId != null) {
      final updateRequest = ProfileUpdateRequest(
        fullName: _fullNameController.text.trim().isNotEmpty
            ? _fullNameController.text.trim()
            : null,
        userName: _userNameController.text.trim().isNotEmpty
            ? _userNameController.text.trim()
            : null,
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
        phoneNumber: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        address: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : null,
        organization: _organizationController.text.trim().isNotEmpty
            ? _organizationController.text.trim()
            : null,
        age: _ageController.text.trim().isNotEmpty
            ? int.tryParse(_ageController.text.trim())
            : null,
        gender: _selectedGender,
        avatarUrl: _avatarUrl,
      );

      context.read<ProfileBloc>().add(
        UpdateProfileData(userId: _userId!, updateRequest: updateRequest),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded && _fullNameController.text.isEmpty) {
            // Only populate fields if they're empty (first load)
            _populateFields(state.profile);
          } else if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getHorizontalPadding(context),
                  vertical: 16,
                ),
                child: const AuthFormShimmer(fieldCount: 6),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getHorizontalPadding(context),
                vertical: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture Section
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            child: _avatarUrl != null && _avatarUrl!.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      _avatarUrl!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.person,
                                              size: 50,
                                            );
                                          },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const CircularProgressIndicator();
                                          },
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Implement image picker
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Image picker will be implemented',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Change Photo'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Form Fields
                    Text(
                      'Personal Information',
                      style: AppStyles.heading(context).copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _fullNameController,
                      hintText: 'Full Name',
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),

                    CustomTextField(
                      controller: _userNameController,
                      hintText: 'Username',
                      keyboardType: TextInputType.text,
                    ),

                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    CustomTextField(
                      controller: _phoneController,
                      hintText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                    ),

                    CustomDropdownField<String>(
                      value: _selectedGender,
                      hintText: 'Gender',
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),

                    CustomTextField(
                      controller: _ageController,
                      hintText: 'Age',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final age = int.tryParse(value.trim());
                          if (age == null || age < 1 || age > 120) {
                            return 'Please enter a valid age';
                          }
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Additional Information',
                      style: AppStyles.heading(context).copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _addressController,
                      hintText: 'Address',
                      keyboardType: TextInputType.streetAddress,
                      maxLines: 2,
                    ),

                    CustomTextField(
                      controller: _organizationController,
                      hintText: 'Organization',
                      keyboardType: TextInputType.text,
                    ),

                    const SizedBox(height: 32),

                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          return PrimaryButton(
                            text: 'Update Profile',
                            onPressed: _handleUpdateProfile,
                            isLoading: state is ProfileUpdating,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
