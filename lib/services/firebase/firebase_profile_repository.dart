import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_profile.dart';
import '../../repositories/profile_repository.dart';

class FirebaseProfileRepository implements ProfileRepository {
  FirebaseProfileRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _profiles =>
      _firestore.collection('profiles');

  @override
  Future<UserProfile?> getProfile(String userId) async {
    final snapshot = await _profiles.doc(userId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return _fromMap(userId, data);
  }

  @override
  Future<UserProfile> saveProfile(UserProfile profile) async {
    final payload = {
      'email': profile.email,
      'displayName': profile.displayName,
      'bio': profile.bio,
      'avatarUrl': profile.avatarUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _profiles.doc(profile.userId).set(payload, SetOptions(merge: true));

    final updated = await _profiles.doc(profile.userId).get();
    final data = updated.data();
    if (data == null) {
      throw const FormatException('Profiili salvestamine ebaonnestus.');
    }

    return _fromMap(profile.userId, data);
  }

  UserProfile _fromMap(String userId, Map<String, dynamic> data) {
    return UserProfile(
      userId: userId,
      email: (data['email'] as String?) ?? '',
      displayName: (data['displayName'] as String?) ?? '',
      bio: (data['bio'] as String?) ?? '',
      avatarUrl: data['avatarUrl'] as String?,
    );
  }
}
