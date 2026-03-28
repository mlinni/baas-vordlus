import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../repositories/storage_repository.dart';

class SupabaseStorageRepository implements StorageRepository {
  SupabaseStorageRepository(
    this._client, {
    this.bucketName = 'avatars',
  });

  final SupabaseClient _client;
  final String bucketName;

  @override
  Future<String> uploadProfileImage({
    required String userId,
    required String fileName,
    required List<int> bytes,
  }) async {
    final path = '$userId/$fileName';

    await _client.storage.from(bucketName).uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from(bucketName).getPublicUrl(path);
  }
}
