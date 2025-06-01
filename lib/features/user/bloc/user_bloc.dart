import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/user/data/datasources/user_local_datasource_impl.dart';
import 'package:medicine_reminder/features/user/data/repositories/user_repository_impl.dart';
import 'package:medicine_reminder/features/user/domain/entities/user.dart';
import 'package:medicine_reminder/features/user/domain/usecases/user_usecases.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  static final _userRepository = UserRepositoryImpl(UserLocalDataSourceImpl());

  final GetUsers getUsers = GetUsers(_userRepository);
  final GetUser getUser = GetUser(_userRepository);
  final AddUser addUser = AddUser(_userRepository);
  final UpdateUser updateUser = UpdateUser(_userRepository);
  final DeleteUser deleteUser = DeleteUser(_userRepository);
  final DeleteAllUsers deleteAllUsers = DeleteAllUsers(_userRepository);

  UserBloc() : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadUser>(_onLoadUser);
    on<CreateUser>(_onCreateUser);
    on<EditUser>(_onEditUser);
    on<RemoveUser>(_onRemoveUser);
    on<RemoveAllUsers>(_onRemoveAllUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await getUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await getUser(event.id);
      if (user == null) {
        emit(const UserError('User not found'));
        return;
      }
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await addUser(event.user);
      add(LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onEditUser(EditUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await updateUser(event.user);
      add(LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onRemoveUser(RemoveUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await deleteUser(event.id);
      add(LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onRemoveAllUsers(
      RemoveAllUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await deleteAllUsers();
      add(LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
