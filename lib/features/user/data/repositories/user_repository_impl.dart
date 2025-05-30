import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;
  UserRepositoryImpl(this.localDataSource);

  @override
  Future<List<User>> getUsers() async {
    return await localDataSource.getUsers();
  }

  @override
  Future<User?> getUser(int id) async {
    return await localDataSource.getUser(id);
  }

  @override
  Future<void> addUser(User user) async {
    await localDataSource.addUser(user);
  }

  @override
  Future<void> updateUser(User user) async {
    await localDataSource.updateUser(user);
  }

  @override
  Future<void> deleteUser(int id) async {
    await localDataSource.deleteUser(id);
  }

  @override
  Future<void> deleteAllUsers() async {
    await localDataSource.deleteAllUsers();
  }
}
