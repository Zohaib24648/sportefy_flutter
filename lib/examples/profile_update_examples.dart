// Profile Update API Usage Examples
// This file demonstrates how to use the profile update functionality

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../data/model/profile_update_request.dart';

class ProfileUpdateExamples {
  // Example 1: Update only the full name
  static void updateFullNameOnly(BuildContext context, String userId) {
    final updateRequest = ProfileUpdateRequest(fullName: "John Doe Updated");

    context.read<ProfileBloc>().add(
      UpdateProfileData(userId: userId, updateRequest: updateRequest),
    );
  }

  // Example 2: Update multiple fields
  static void updateMultipleFields(BuildContext context, String userId) {
    final updateRequest = ProfileUpdateRequest(
      fullName: "John Doe",
      email: "john.doe@example.com",
      userName: "johndoe",
      gender: "male",
      age: 30,
      address: "123 Main St, City, Country",
      organization: "Tech Corp",
      phoneNumber: "+1234567890",
    );

    context.read<ProfileBloc>().add(
      UpdateProfileData(userId: userId, updateRequest: updateRequest),
    );
  }

  // Example 3: Update only avatar URL
  static void updateAvatarOnly(BuildContext context, String userId) {
    final updateRequest = ProfileUpdateRequest(
      avatarUrl: "https://example.com/new-avatar.jpg",
    );

    context.read<ProfileBloc>().add(
      UpdateProfileData(userId: userId, updateRequest: updateRequest),
    );
  }

  // Example 4: Update from API endpoint format
  static void updateFromApiEndpoint(BuildContext context, String userId) {
    // This matches the endpoint specification provided by the user
    final updateRequest = ProfileUpdateRequest(
      fullName: "John Doe",
      avatarUrl: "https://example.com/avatar.jpg",
      email: "john.doe@example.com",
      userName: "johndoe",
      gender: "male",
      age: 30,
      address: "123 Main St",
      organization: "Acme Corp",
      phoneNumber: "+1234567890",
    );

    context.read<ProfileBloc>().add(
      UpdateProfileData(userId: userId, updateRequest: updateRequest),
    );
  }

  // Example 5: Update with validation and error handling
  static void updateWithErrorHandling(BuildContext context, String userId) {
    final updateRequest = ProfileUpdateRequest(
      fullName: "John Doe",
      email: "john.doe@example.com",
      age: 30,
    );

    // Listen to BLoC state changes for success/error handling
    final profileBloc = context.read<ProfileBloc>();

    profileBloc.stream.listen((state) {
      if (state is ProfileUpdated) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (state is ProfileError) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: ${state.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    profileBloc.add(
      UpdateProfileData(userId: userId, updateRequest: updateRequest),
    );
  }

  // Example 6: BLoC state management in a widget
  static Widget buildProfileUpdateWidget(String userId) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileUpdating) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Updating profile...'),
              ],
            ),
          );
        } else if (state is ProfileLoaded) {
          return Column(
            children: [
              Text('Profile: ${state.profile.fullName}'),
              Text('Email: ${state.profile.email}'),
              Text('Phone: ${state.profile.phoneNumber ?? "Not set"}'),
              ElevatedButton(
                onPressed: () => updateFullNameOnly(context, userId),
                child: const Text('Update Name'),
              ),
            ],
          );
        } else if (state is ProfileError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.error}'),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProfileBloc>().add(LoadUserProfile(userId));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// API Integration Example
class ProfileApiService {
  // Simulate an API call that would be integrated with your backend
  static Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> profileData,
  }) async {
    // This would be an actual HTTP request to your backend
    // Example using http package:
    /*
    final response = await http.put(
      Uri.parse('${dotenv.env['BACKEND_URL']}/users/$userId/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(profileData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
    */

    // For now, simulate a successful response
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'message': 'Profile updated successfully',
      'data': profileData,
    };
  }
}
