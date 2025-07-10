import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user_profile.dart';
import '../model/profile_update_request.dart';
import 'i_profile_repository.dart';
import '../../core/utils/crypto_utils.dart';

@Injectable(as: IProfileRepository)
class ProfileRepository implements IProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepository() : _supabase = Supabase.instance.client;

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      // If profile doesn't exist, create a default one
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final defaultProfile = UserProfile(
          id: userId,
          fullName:
              user.userMetadata?['name'] ?? user.email?.split('@')[0] ?? 'User',
          role: 'user',
          email: user.email ?? '',
          avatarUrl: CryptoUtils.generateGravatarUrl(user.email ?? ''),
        );

        // Create the profile in Supabase
        await _createUserProfile(defaultProfile);
        return defaultProfile;
      }
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    await _supabase
        .from('profiles')
        .update(profile.toJson())
        .eq('id', profile.id);
  }

  @override
  Future<void> updateProfileData(
    String userId,
    ProfileUpdateRequest updateRequest,
  ) async {
    final updateData = updateRequest.toJson();
    if (updateData.isNotEmpty) {
      await _supabase.from('profiles').update(updateData).eq('id', userId);
    }
  }

  @override
  Future<void> updateAvatarUrl(String userId, String avatarUrl) async {
    await _supabase
        .from('profiles')
        .update({
          'avatar_url': avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }

  Future<void> _createUserProfile(UserProfile profile) async {
    await _supabase.from('profiles').insert(profile.toJson());
  }
}
