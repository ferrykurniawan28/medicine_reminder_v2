import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:medicine_reminder/features/user/bloc/user_bloc.dart';
import 'package:medicine_reminder/features/user/domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({this.userBloc}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    // Add more events as needed
  }

  final networkService = NetworkService();
  final authRemoteDataSource =
      AuthRemoteDataSource(networkService: NetworkService());
  final UserBloc? userBloc;

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRemoteDataSource.loginUser(
        email: event.email,
        password: event.password,
      );

      if (response.isSuccess) {
        final user = response.data!;
        // Add user to local user table via UserBloc
        userBloc?.add(CreateUser(user));
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(response.message ?? response.error ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(AuthUnauthenticated());
  }

  Future<void> _onRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRemoteDataSource.registerUser(
        name: event.username,
        email: event.email,
        password: event.password,
      );

      if (response.isSuccess) {
        final user = response.data!;
        // Add user to local user table via UserBloc
        userBloc?.add(CreateUser(user));
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(
            response.message ?? response.error ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
