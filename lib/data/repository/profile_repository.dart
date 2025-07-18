import 'package:injectable/injectable.dart';
import '../model/user_profile.dart';
import '../model/profile_update_request.dart';
import '../services/profile_api_service.dart';
import 'i_profile_repository.dart';

@Injectable(as: IProfileRepository)
class ProfileRepository implements IProfileRepository {
  final ProfileApiService _profileApiService;

  ProfileRepository(this._profileApiService);

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      return await _profileApiService.getMyProfile();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _profileApiService.updateProfile(profile.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfileData(
    String userId,
    ProfileUpdateRequest updateRequest,
  ) async {
    try {
      final updateData = updateRequest.toJson();
      if (updateData.isNotEmpty) {
        await _profileApiService.updateProfile(updateData);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateAvatarUrl(String userId, String avatarUrl) async {
    try {
      await _profileApiService.updateProfile({'avatarUrl': avatarUrl});
    } catch (e) {
      rethrow;
    }
  }
}
