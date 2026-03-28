abstract class StorageRepository {
  Future<String> uploadProfileImage({
    required String userId,
    required String fileName,
    required List<int> bytes,
  });
}
