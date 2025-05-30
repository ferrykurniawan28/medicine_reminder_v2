import '../../domain/entities/user.dart';

abstract class UserLocalDataSource {
  Future<List<User>> getUsers();
  Future<User?> getUser(int id);
  Future<void> addUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(int id);
  Future<void> deleteAllUsers();
}
