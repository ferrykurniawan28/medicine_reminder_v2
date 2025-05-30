part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {}

class LoadUser extends UserEvent {
  final int id;
  const LoadUser(this.id);
  @override
  List<Object?> get props => [id];
}

class CreateUser extends UserEvent {
  final User user;
  const CreateUser(this.user);
  @override
  List<Object?> get props => [user];
}

class EditUser extends UserEvent {
  final User user;
  const EditUser(this.user);
  @override
  List<Object?> get props => [user];
}

class RemoveUser extends UserEvent {
  final int id;
  const RemoveUser(this.id);
  @override
  List<Object?> get props => [id];
}

class RemoveAllUsers extends UserEvent {}
