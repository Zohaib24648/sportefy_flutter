part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final UserProfile profile;

  ProfileUpdated(this.profile);
}
