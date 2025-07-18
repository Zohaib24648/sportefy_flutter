part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final String userId;

  LoadUserProfile(this.userId);
}

class LoadCurrentUserProfile extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  final UserProfile profile;

  UpdateUserProfile(this.profile);
}

class UpdateProfileData extends ProfileEvent {
  final String userId;
  final ProfileUpdateRequest updateRequest;

  UpdateProfileData({required this.userId, required this.updateRequest});
}
