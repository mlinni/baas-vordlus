import '../../models/user_profile.dart';
import '../../repositories/profile_repository.dart';

class FakeProfileRepository implements ProfileRepository {
  final Map<String, UserProfile> _profiles = {};

  @override
  Future<UserProfile?> getProfile(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _profiles[userId];
  }

  @override
  Future<UserProfile> saveProfile(UserProfile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _profiles[profile.userId] = profile;
    return profile;
  }
}
