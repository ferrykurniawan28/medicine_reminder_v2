import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/appointment/data/datasources/appointment_local_datasource_impl.dart';
import 'package:medicine_reminder/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:medicine_reminder/features/appointment/domain/entities/appointment.dart';
import 'package:medicine_reminder/features/appointment/domain/usecases/add_appointment.dart';
import 'package:medicine_reminder/features/appointment/domain/usecases/delete_appointment.dart';
import 'package:medicine_reminder/features/appointment/domain/usecases/get_appointment.dart';
import 'package:medicine_reminder/features/appointment/domain/usecases/get_appointments.dart';
import 'package:medicine_reminder/features/appointment/domain/usecases/update_appointment.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAppointments getAppointments;
  final GetAppointment getAppointment;
  final AddAppointment addAppointmentUseCase;
  final UpdateAppointment updateAppointmentUseCase;
  final DeleteAppointment deleteAppointmentUseCase;

  List<Appointment> _appointments = [];
  Appointment? _appointment;

  AppointmentBloc()
      : getAppointments = GetAppointments(
            AppointmentRepositoryImpl(AppointmentLocalDataSourceImpl())),
        getAppointment = GetAppointment(
            AppointmentRepositoryImpl(AppointmentLocalDataSourceImpl())),
        addAppointmentUseCase = AddAppointment(
            AppointmentRepositoryImpl(AppointmentLocalDataSourceImpl())),
        updateAppointmentUseCase = UpdateAppointment(
            AppointmentRepositoryImpl(AppointmentLocalDataSourceImpl())),
        deleteAppointmentUseCase = DeleteAppointment(
            AppointmentRepositoryImpl(AppointmentLocalDataSourceImpl())),
        super(AppointmentInitial()) {
    on<AppointmentsFetch>(_onFetchAppointments);
    on<AppointmentFetch>(_onFetchAppointment);
    on<AppointmentAdd>(_addAppointment);
    on<AppointmentUpdate>(_updateAppointment);
    on<AppointmentDelete>(_deleteAppointment);
  }

  Future<void> _onFetchAppointments(
      AppointmentsFetch event, Emitter<AppointmentState> emit) async {
    emit(AppointmentListLoading());
    try {
      _appointments = (await getAppointments()).cast<Appointment>();
      if (_appointments.isEmpty) {
        emit(const AppointmentError('No appointments found'));
        return;
      }
      emit(AppointmentsLoaded(_appointments));
    } catch (e) {
      print('Error adding appointment: $e');
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onFetchAppointment(
      AppointmentFetch event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final result = await getAppointment(event.id);
      if (result == null) {
        emit(const AppointmentError('Appointment not found'));
        return;
      }
      _appointment = result as Appointment;
      emit(AppointmentLoaded(_appointment!));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _addAppointment(
      AppointmentAdd event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      print('Adding appointment: ${event.appointment.toJson()}');
      await addAppointmentUseCase(event.appointment);
      add(AppointmentsFetch(event.appointment.userAssigned.userId));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _updateAppointment(
      AppointmentUpdate event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      await updateAppointmentUseCase(_toDomain(event.appointment));
      add(AppointmentsFetch(event.appointment.userAssigned.userId));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _deleteAppointment(
      AppointmentDelete event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      await deleteAppointmentUseCase(event.appointment.id!);
      add(AppointmentsFetch(event.appointment.userAssigned.userId));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  // Helper to convert model Appointment to domain Appointment
  Appointment _toDomain(Appointment appointment) {
    return Appointment(
      id: appointment.id,
      userCreated: appointment.userCreated,
      userAssigned: appointment.userAssigned,
      doctor: appointment.doctor,
      note: appointment.note,
      time: appointment.time,
    );
  }
}
