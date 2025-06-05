abstract class UserRemoteRepository {
  Future<List<Map<String, dynamic>>> fetchUsers();
  Future<void> addUser(Map<String, dynamic> userJson);
  Future<void> updateUser(int id, Map<String, dynamic> userJson);
  Future<void> deleteUser(int id);
  Future<void> syncUsers(List<Map<String, dynamic>> usersToSync);
}
