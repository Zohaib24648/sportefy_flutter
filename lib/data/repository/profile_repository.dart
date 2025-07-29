import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../model/user_profile_dto.dart';
import 'i_profile_repository.dart';

@Injectable(as: IProfileRepository)
class ProfileRepository implements IProfileRepository {
  final Dio dio;

  ProfileRepository(this.dio);

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await dio.get('/profile');
      return UserProfile.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

  // @override
  // Future<void> updateUserProfile(UserProfile profile) async {
  //   try {
  //     await _profileApiService.updateProfile(profile.toJson());
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // @override
  // Future<void> updateProfileData(
  //   String userId,
  //   ProfileUpdateRequest updateRequest,
  // ) async {
  //   try {
  //     final updateData = updateRequest.toJson();
  //     if (updateData.isNotEmpty) {
  //       await _profileApiService.updateProfile(updateData);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // @override
  // Future<void> updateAvatarUrl(String userId, String avatarUrl) async {
  //   try {
  //     await _profileApiService.updateProfile({'avatarUrl': avatarUrl});
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
