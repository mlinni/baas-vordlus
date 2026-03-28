import '../models/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
