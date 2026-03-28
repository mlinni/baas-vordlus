import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user_profile.dart';
import '../../repositories/profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<UserProfile?> getProfile(String userId) async {
    final row = await _client
        .from('profiles')
        .select('id, email, full_name, bio, avatar_url')
        .eq('id', userId)
        .maybeSingle();

    if (row == null) {
      return null;
    }

    return _fromMap(row);
  }

  @override
  Future<UserProfile> saveProfile(UserProfile profile) async {
    final row = await _client
        .from('profiles')
        .upsert({
          'id': profile.userId,
          'email': profile.email,
          'full_name': profile.displayName,
          'bio': profile.bio,
          'avatar_url': profile.avatarUrl,
        })
        .select('id, email, full_name, bio, avatar_url')
        .single();

    return _fromMap(row);
  }

  UserProfile _fromMap(Map<String, dynamic> row) {
    return UserProfile(
      userId: row['id'] as String,
      email: (row['email'] as String?) ?? '',
      displayName: (row['full_name'] as String?) ?? '',
      bio: (row['bio'] as String?) ?? '',
      avatarUrl: row['avatar_url'] as String?,
    );
  }
}
