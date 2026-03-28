import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../../repositories/storage_repository.dart';

class FirebaseStorageRepository implements StorageRepository {
  FirebaseStorageRepository(this._storage);

  final FirebaseStorage _storage;

  @override
  Future<String> uploadProfileImage({
    required String userId,
    required String fileName,
    required List<int> bytes,
  }) async {
    final path = 'avatars/$userId/$fileName';

    final ref = _storage.ref(path);
    await ref.putData(Uint8List.fromList(bytes));

    return ref.getDownloadURL();
  }
}
