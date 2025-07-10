import '../model/user_profile.dart';
import '../model/profile_update_request.dart';

abstract class IProfileRepository {
  Future<UserProfile> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfile profile);
  Future<void> updateProfileData(
    String userId,
    ProfileUpdateRequest updateRequest,
  );
  Future<void> updateAvatarUrl(String userId, String avatarUrl);
}
