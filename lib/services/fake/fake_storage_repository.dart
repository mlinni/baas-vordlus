import '../../repositories/storage_repository.dart';

class FakeStorageRepository implements StorageRepository {
  @override
  Future<String> uploadProfileImage({
    required String userId,
    required String fileName,
    required List<int> bytes,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return 'fake-storage://$userId/$fileName';
  }
}
