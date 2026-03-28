import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/app_user.dart';
import '../../repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      if (user == null || user.email == null) {
        throw const FormatException('Sisselogimine ebaonnestus.');
      }

      return AppUser(
        id: user.id,
        email: user.email!,
      );
    } on AuthException catch (error) {
      throw FormatException(error.message);
    }
  }

  @override
  Future<void> signOut() {
    return _client.auth.signOut();
  }
}
