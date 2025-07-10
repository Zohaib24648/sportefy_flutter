import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/model/user_profile.dart';
import '../../data/model/profile_update_request.dart';
import '../../data/repository/i_profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateProfileData>(_onUpdateProfileData);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _profileRepository.getUserProfile(event.userId);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());
    try {
      await _profileRepository.updateUserProfile(event.profile);
      emit(ProfileUpdated(event.profile));
    } catch (e) {
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfileData(
    UpdateProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());
    try {
      // Update only the changed fields
      await _profileRepository.updateProfileData(
        event.userId,
        event.updateRequest,
      );

      // Get the updated profile to emit the new state
      final updatedProfile = await _profileRepository.getUserProfile(
        event.userId,
      );

      // Emit the updated profile
      emit(ProfileUpdated(updatedProfile));
      emit(ProfileLoaded(updatedProfile));
    } catch (e) {
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
  }
}
