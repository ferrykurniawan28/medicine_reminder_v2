import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';
import '../models/user_model.dart';

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
  Future<void> addUser(User user, {int isSynced = 0}) async {
    final userModel = user is UserModel
        ? user
        : UserModel(
            userId: user.userId,
            userName: user.userName,
            email: user.email,
            isSynced: isSynced);
    await localDataSource.addUser(userModel);
  }

  @override
  Future<void> updateUser(User user, {int? isSynced}) async {
    final userModel = user is UserModel
        ? (isSynced != null ? user.copyWith(isSynced: isSynced) : user)
        : UserModel(
            userId: user.userId,
            userName: user.userName,
            email: user.email,
            isSynced: isSynced ?? 0);
    await localDataSource.updateUser(userModel);
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
