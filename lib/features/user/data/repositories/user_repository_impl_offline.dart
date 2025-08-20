import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;
  final bool Function()? isOnline;

  UserRepositoryImpl(
    this.localDataSource, {
    this.isOnline,
  });

  @override
  Future<List<User>> getUsers() async {
    // For now, only read from local cache
    // TODO: Implement remote sync when online
    return await localDataSource.getUsers();
  }

  @override
  Future<User?> getUser(int id) async {
    // For now, only read from local cache
    // TODO: Implement remote sync when online
    return await localDataSource.getUser(id);
  }

  @override
  Future<void> addUser(User user) async {
    // Only allow user modifications when online
    if (isOnline == null || !isOnline!()) {
      throw Exception('User modifications require internet connection');
    }

    // For now, just throw error since we don't have remote implemented
    throw Exception(
        'User addition requires server connection (not yet implemented)');
  }

  @override
  Future<void> updateUser(User user) async {
    // Only allow user modifications when online
    if (isOnline == null || !isOnline!()) {
      throw Exception('User modifications require internet connection');
    }

    // For now, just throw error since we don't have remote implemented
    throw Exception(
        'User update requires server connection (not yet implemented)');
  }

  @override
  Future<void> deleteUser(int id) async {
    // Only allow user deletion when online
    if (isOnline == null || !isOnline!()) {
      throw Exception('User deletion requires internet connection');
    }

    // For now, just throw error since we don't have remote implemented
    throw Exception(
        'User deletion requires server connection (not yet implemented)');
  }

  @override
  Future<void> deleteAllUsers() async {
    // Only allow user deletion when online
    if (isOnline == null || !isOnline!()) {
      throw Exception('User deletion requires internet connection');
    }

    // For now, just throw error since we don't have remote implemented
    throw Exception(
        'Delete all users requires server connection (not yet implemented)');
  }
}
