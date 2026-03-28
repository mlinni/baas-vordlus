import 'package:firebase_auth/firebase_auth.dart';

import '../../models/app_user.dart';
import '../../repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);

  final FirebaseAuth _auth;

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null || user.email == null) {
        throw const FormatException('Sisselogimine ebaonnestus.');
      }

      return AppUser(
        id: user.uid,
        email: user.email!,
      );
    } on FirebaseAuthException catch (error) {
      throw FormatException(_mapAuthError(error));
    }
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

  String _mapAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Vale e-post voi parool.';
      case 'invalid-email':
        return 'E-posti aadress ei ole korrektne.';
      case 'user-disabled':
        return 'See konto on keelatud.';
      case 'too-many-requests':
        return 'Liiga palju katseid. Proovi hiljem uuesti.';
      default:
        return error.message ?? 'Sisselogimine ebaonnestus.';
    }
  }
}
