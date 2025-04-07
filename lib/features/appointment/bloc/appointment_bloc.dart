import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/models/models.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  List<Appointment> _appointments = [];
  Appointment? _appointment;
  AppointmentBloc() : super(AppointmentInitial()) {
    on<AppointmentsFetch>(_onFetchAppointments);
    on<AppointmentFetch>(_onFetchAppointment);
    on<AppointmentAdd>(addAppointment);
    on<AppointmentUpdate>(updateAppointment);
    on<AppointmentDelete>(deleteAppointment);
  }

  Future<void> _onFetchAppointments(
      AppointmentsFetch event, Emitter<AppointmentState> emit) async {
    emit(AppointmentListLoading());
    try {
      _appointments = dummyAppointment;
      // final appointments = await _appointmentRepository.getAppointments();
      emit(AppointmentsLoaded(_appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onFetchAppointment(
      AppointmentFetch event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      _appointment =
          dummyAppointment.firstWhere((element) => element.id == event.id);
      // final appointment = await _appointmentRepository.getAppointment(event.id);
      emit(AppointmentLoaded(_appointment!));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> addAppointment(
      AppointmentAdd event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      _appointments.add(event.appointment);
      // await _appointmentRepository.addAppointment(event.appointment);
      emit(AppointmentsLoaded(_appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> updateAppointment(
      AppointmentUpdate event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final index =
          _appointments.indexWhere((a) => a.id == event.appointment.id);
      if (index != -1) {
        _appointments[index] = event.appointment;
        // await _appointmentRepository.updateAppointment(event.appointment);
        emit(AppointmentsLoaded(_appointments));
      } else {
        emit(const AppointmentError("Appointment not found"));
      }
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> deleteAppointment(
      AppointmentDelete event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      _appointments.removeWhere((a) => a.id == event.appointment.id);
      // await _appointmentRepository.deleteAppointment(event.id);
      emit(AppointmentsLoaded(_appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }
}
