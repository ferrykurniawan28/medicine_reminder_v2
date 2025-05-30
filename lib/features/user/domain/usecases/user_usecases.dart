import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;
  GetUsers(this.repository);
  Future<List<User>> call() async => await repository.getUsers();
}

class GetUser {
  final UserRepository repository;
  GetUser(this.repository);
  Future<User?> call(int id) async => await repository.getUser(id);
}

class AddUser {
  final UserRepository repository;
  AddUser(this.repository);
  Future<void> call(User user) async => await repository.addUser(user);
}

class UpdateUser {
  final UserRepository repository;
  UpdateUser(this.repository);
  Future<void> call(User user) async => await repository.updateUser(user);
}

class DeleteUser {
  final UserRepository repository;
  DeleteUser(this.repository);
  Future<void> call(int id) async => await repository.deleteUser(id);
}

class DeleteAllUsers {
  final UserRepository repository;
  DeleteAllUsers(this.repository);
  Future<void> call() async => await repository.deleteAllUsers();
}
