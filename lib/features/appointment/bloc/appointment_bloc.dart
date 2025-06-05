import 'package:medicine_reminder/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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

  AppointmentBloc(AppointmentRepository repository)
      : getAppointments = GetAppointments(repository),
        getAppointment = GetAppointment(repository),
        addAppointmentUseCase = AddAppointment(repository),
        updateAppointmentUseCase = UpdateAppointment(repository),
        deleteAppointmentUseCase = DeleteAppointment(repository),
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
      _appointments = (await getAppointments(event.userId));
      print('Fetched appointments: ${_appointments.length}');
      for (var appointment in _appointments) {
        print('Appointment details: ${appointment.toString()}');
      }
      if (_appointments.isEmpty) {
        emit(const AppointmentError('No appointments found'));
        return;
      }
      emit(AppointmentsLoaded(_appointments));
    } catch (e) {
      print('Error fetching appointments: $e');
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
      await addAppointmentUseCase(event.appointment);
      add(AppointmentsFetch(event.appointment.userAssigned.userId!));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _updateAppointment(
      AppointmentUpdate event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      await updateAppointmentUseCase(_toDomain(event.appointment));
      add(AppointmentsFetch(event.appointment.userAssigned.userId!));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _deleteAppointment(
      AppointmentDelete event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      await deleteAppointmentUseCase(event.appointment.id!);
      add(AppointmentsFetch(event.appointment.userAssigned.userId!));
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
