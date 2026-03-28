import '../../models/app_user.dart';
import '../../repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (email.trim().isEmpty || password.isEmpty) {
      throw const FormatException('E-post ja parool on kohustuslikud.');
    }

    if (password != 'password123') {
      throw const FormatException('Vale e-post voi parool.');
    }

    return AppUser(
      id: 'demo-user',
      email: email.trim(),
    );
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }
}
