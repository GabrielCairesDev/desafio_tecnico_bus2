abstract class IPersistenceService {
  Future<bool> saveList(String key, List<Map<String, dynamic>> data);

  Future<List<Map<String, dynamic>>> loadList(String key);

  Future<bool> delete(String key);

  Future<bool> exists(String key);
}
